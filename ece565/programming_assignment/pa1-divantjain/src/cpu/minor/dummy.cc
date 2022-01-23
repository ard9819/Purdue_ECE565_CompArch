#include "cpu/minor/dummy.hh"

#include "cpu/minor/pipeline.hh"
//#include "debug/Decode.hh" 

namespace Minor
{

Dummy::Dummy(const std::string &name,
    MinorCPU &cpu_,
    MinorCPUParams &params,
    Latch<ForwardInstData>::Output inp_,
    Latch<ForwardInstData>::Input out_,
    std::vector<InputBuffer<ForwardInstData>> &next_stage_input_buffer) :
    Named(name),
    cpu(cpu_),
    inp(inp_),
    out(out_),
    nextStageReserve(next_stage_input_buffer),
    outputWidth(params.executeInputWidth),
    processMoreThanOneInput(params.dummyCycleInput),
    dummyInfo(params.numThreads),
    threadPriority(0)
{
    if (outputWidth < 1)
        fatal("%s: executeInputWidth must be >= 1 (%d)\n", name, outputWidth);

    if (params.dummyInputBufferSize < 1) {
        fatal("%s: dummyInputBufferSize must be >= 1 (%d)\n", name,
        params.dummyInputBufferSize);
    }

    /* Per-thread input buffers */
    for (ThreadID tid = 0; tid < params.numThreads; tid++) {
        inputBuffer.push_back(
            InputBuffer<ForwardInstData>(
                name + ".inputBuffer" + std::to_string(tid), "insts",
                params.dummyInputBufferSize));
    }
}

const ForwardInstData *
Dummy::getInput(ThreadID tid)
{
    /* Get insts from the inputBuffer to work with */
    if (!inputBuffer[tid].empty()) {
        const ForwardInstData &head = inputBuffer[tid].front();

        return (head.isBubble() ? NULL : &(inputBuffer[tid].front()));
    } else {
        return NULL;
    }
}

void
Dummy::popInput(ThreadID tid)
{
    if (!inputBuffer[tid].empty())
        inputBuffer[tid].pop();

    dummyInfo[tid].inputIndex = 0;
}

#if TRACING_ON
/** Add the tracing data to an instruction.  This originates in
 *  decode because this is the first place that execSeqNums are known
 *  (these are used as the 'FetchSeq' in tracing data) */
static void
dynInstAddTracing(MinorDynInstPtr inst, StaticInstPtr static_inst,
    MinorCPU &cpu)
{
    inst->traceData = cpu.getTracer()->getInstRecord(curTick(),
        cpu.getContext(inst->id.threadId),
        inst->staticInst, inst->pc, static_inst);

    /* Use the execSeqNum as the fetch sequence number as this most closely
     *  matches the other processor models' idea of fetch sequence */
    if (inst->traceData)
        inst->traceData->setFetchSeq(inst->id.execSeqNum); //TODO
}
#endif

void
Dummy::evaluate()
{
    /* Push input onto appropriate input buffer */
    if (!inp.outputWire->isBubble())
        inputBuffer[inp.outputWire->threadId].setTail(*inp.outputWire);

    ForwardInstData &insts_out = *out.inputWire;

    assert(insts_out.isBubble());

    for (ThreadID tid = 0; tid < cpu.numThreads; tid++)
        dummyInfo[tid].blocked = !nextStageReserve[tid].canReserve();

    ThreadID tid = getScheduledThread();

    if (tid != InvalidThreadID) {
        DummyThreadInfo &dummy_info = dummyInfo[tid];
        const ForwardInstData *insts_in = getInput(tid);

        unsigned int output_index = 0;

        /* Pack instructions into the output while we can.  This may involve
         * using more than one input line */
        while (insts_in &&
           dummy_info.inputIndex < insts_in->width() && /* Still more input */
           output_index < outputWidth /* Still more output to fill */)
        {
            MinorDynInstPtr inst = insts_in->insts[dummy_info.inputIndex];

            if (inst->isBubble()) {
                /* Skip */
                dummy_info.inputIndex++;
                dummy_info.inMacroop = false;
            } else {
                StaticInstPtr static_inst = inst->staticInst;
                /* Static inst of a macro-op above the output_inst */
                StaticInstPtr parent_static_inst = NULL;
                MinorDynInstPtr output_inst = inst;

                if (inst->isFault()) {
/*
                    DPRINTF(Dummy, "Fault being passed: %d\n",
                        inst->fault->name());
*/

                    dummy_info.inputIndex++;
                    dummy_info.inMacroop = false;
                } else if (static_inst->isMacroop()) {
                    /* Generate a new micro-op */
                    StaticInstPtr static_micro_inst;

                    /* Set up PC for the next micro-op emitted */
                    if (!dummy_info.inMacroop) {
                        dummy_info.microopPC = inst->pc;
                        dummy_info.inMacroop = true;
                    }

                    /* Get the micro-op static instruction from the
                     * static_inst. */
                    static_micro_inst =
                        static_inst->fetchMicroop(
                                dummy_info.microopPC.microPC());

                    output_inst = new MinorDynInst(inst->id);
                    output_inst->pc = dummy_info.microopPC;
                    output_inst->staticInst = static_micro_inst;
                    output_inst->fault = NoFault;

                    /* Allow a predicted next address only on the last
                     *  microop */
                    if (static_micro_inst->isLastMicroop()) {
                        output_inst->predictedTaken = inst->predictedTaken;
                        output_inst->predictedTarget = inst->predictedTarget;
                    }
/*
                    DPRINTF(Dummy, "Microop decomposition inputIndex:"
                        " %d output_index: %d lastMicroop: %s microopPC:"
                        " %d.%d inst: %d\n",
                        dummy_info.inputIndex, output_index,
                        (static_micro_inst->isLastMicroop() ?
                            "true" : "false"),
                        dummy_info.microopPC.instAddr(),
                        dummy_info.microopPC.microPC(),
                        *output_inst);
*/
                    /* Acknowledge that the static_inst isn't mine, it's my
                     * parent macro-op's */
                    parent_static_inst = static_inst;

                    static_micro_inst->advancePC(dummy_info.microopPC);

                    /* Step input if this is the last micro-op */
                    if (static_micro_inst->isLastMicroop()) {
                        dummy_info.inputIndex++;
                        dummy_info.inMacroop = false;
                    }
                } else {
                    /* Doesn't need decomposing, pass on instruction */
/*
                      DPRINTF(Dummy, "Passing on inst: %s inputIndex:"
                        " %d output_index: %d\n",
                        *output_inst, dummy_info.inputIndex, output_index);
*/
                    parent_static_inst = static_inst;

                    /* Step input */
                    dummy_info.inputIndex++;
                    dummy_info.inMacroop = false;
                }

                /* Set execSeqNum of output_inst */
                output_inst->id.execSeqNum = dummy_info.execSeqNum;
                /* Add tracing */
#if TRACING_ON
                dynInstAddTracing(output_inst, parent_static_inst, cpu);
#endif

                /* Step to next sequence number */
                dummy_info.execSeqNum++;

                /* Correctly size the output before writing */
                if (output_index == 0) insts_out.resize(outputWidth);
                /* Push into output */
                insts_out.insts[output_index] = output_inst;
                output_index++;
            }

            /* Have we finished with the input? */
            if (dummy_info.inputIndex == insts_in->width()) {
                /* If we have just been producing micro-ops, we *must* have
                 * got to the end of that for inputIndex to be pushed past
                 * insts_in->width() */
                assert(!dummy_info.inMacroop);
                popInput(tid);
                insts_in = NULL;

                if (processMoreThanOneInput) {
                    //DPRINTF(Dummy, "Wrapping\n");
                    insts_in = getInput(tid);
                }
            }
        }

        /* The rest of the output (if any) should already have been packed
         *  with bubble instructions by insts_out's initialisation
         *
         *  for (; output_index < outputWidth; output_index++)
         *      assert(insts_out.insts[output_index]->isBubble());
         */
    }

    /* If we generated output, reserve space for the result in the next stage
     *  and mark the stage as being active this cycle */
    if (!insts_out.isBubble()) {
        /* Note activity of following buffer */
        cpu.activityRecorder->activity();
        insts_out.threadId = tid;
        nextStageReserve[tid].reserve();
    }

    /* If we still have input to process and somewhere to put it,
     *  mark stage as active */
    for (ThreadID i = 0; i < cpu.numThreads; i++)
    {
        if (getInput(i) && nextStageReserve[i].canReserve()) {
            cpu.activityRecorder->activateStage(Pipeline::DummyStageId);
            break;
        }
    }

    /* Make sure the input (if any left) is pushed */
    if (!inp.outputWire->isBubble())
        inputBuffer[inp.outputWire->threadId].pushTail();
}

inline ThreadID
Dummy::getScheduledThread()
{
    /* Select thread via policy. */
    std::vector<ThreadID> priority_list;

    switch (cpu.threadPolicy) {
      case Enums::SingleThreaded:
        priority_list.push_back(0);
        break;
      case Enums::RoundRobin:
        priority_list = cpu.roundRobinPriority(threadPriority);
        break;
      case Enums::Random:
        priority_list = cpu.randomPriority();
        break;
      default:
        panic("Unknown fetch policy");
    }

    for (auto tid : priority_list) {
        if (getInput(tid) && !dummyInfo[tid].blocked) {
            threadPriority = tid;
            return tid;
        }
    }

   return InvalidThreadID;
}

bool
Dummy::isDrained()
{
    for (const auto &buffer : inputBuffer) {
        if (!buffer.empty())
            return false;
    }

    return (*inp.outputWire).isBubble();
}

void
Dummy::minorTrace() const
{
    std::ostringstream data;

    if (dummyInfo[0].blocked)
        data << 'B';
    else
        (*out.inputWire).reportData(data);

    MINORTRACE("insts=%s\n", data.str());
    inputBuffer[0].minorTrace();
}
}
