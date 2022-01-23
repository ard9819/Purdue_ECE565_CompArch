#ifndef __CPU_MINOR_DUMMY_HH__
#define __CPU_MINOR_DUMMY_HH__

#include "cpu/minor/buffers.hh"
#include "cpu/minor/cpu.hh"
#include "cpu/minor/dyn_inst.hh"
#include "cpu/minor/pipe_data.hh"

namespace Minor
{
class Dummy : public Named
{
  protected:
    /** Pointer back to the containing CPU */
    MinorCPU &cpu;

    /** Input port carrying micro-op decomposed instructions from Decode */
    Latch<ForwardInstData>::Output inp;
    /** Output port carrying micro-op decomposed instructions to Execute */
    Latch<ForwardInstData>::Input out;

    /** Interface to reserve space in the next stage */
    std::vector<InputBuffer<ForwardInstData>> &nextStageReserve;

    /** Width of output of this stage/input of next in instructions */
    unsigned int outputWidth;

    /** If true, more than one input word can be processed each cycle if
     *  there is room in the output to contain its processed data */
    bool processMoreThanOneInput;

  public:
    /* Public for Pipeline to be able to pass it to Fetch2 */
    std::vector<InputBuffer<ForwardInstData>> inputBuffer;

  protected:
    /** Data members after this line are cycle-to-cycle state */

    struct DummyThreadInfo {

        /** Default Constructor */
        DummyThreadInfo() :
            inputIndex(0),
            inMacroop(false),
            execSeqNum(InstId::firstExecSeqNum), //TODO
            blocked(false)
        { }

        DummyThreadInfo(const DummyThreadInfo& other) :
            inputIndex(other.inputIndex),
            inMacroop(other.inMacroop),
            execSeqNum(other.execSeqNum), //TODO
            blocked(other.blocked)
        { }


        /** Index into the inputBuffer's head marking the start of unhandled
         *  instructions */
        unsigned int inputIndex;

        /** True when we're in the process of decomposing a micro-op and
         *  microopPC will be valid.  This is only the case when there isn't
         *  sufficient space in Executes input buffer to take the whole of a
         *  decomposed instruction and some of that instructions micro-ops must
         *  be generated in a later cycle */
        bool inMacroop;
        TheISA::PCState microopPC;

        /** Source of execSeqNums to number instructions. */
        InstSeqNum execSeqNum;

        /** Blocked indication for report */
        bool blocked;
    };

    std::vector<DummyThreadInfo> dummyInfo;
    ThreadID threadPriority;

  protected:
    /** Get a piece of data to work on, or 0 if there is no data. */
    const ForwardInstData *getInput(ThreadID tid);

    /** Pop an element off the input buffer, if there are any */
    void popInput(ThreadID tid);

    /** Use the current threading policy to determine the next thread to
     *  decode from. */
    ThreadID getScheduledThread();

  public:
    Dummy(const std::string &name,
        MinorCPU &cpu_,
        MinorCPUParams &params,
        Latch<ForwardInstData>::Output inp_,
        Latch<ForwardInstData>::Input out_,
        std::vector<InputBuffer<ForwardInstData>> &next_stage_input_buffer);

  public:
    /** Pass on input/buffer data to the output if you can */
    void evaluate();

    void minorTrace() const;

    /** Is this stage drained?  For Decoed, draining is initiated by
     *  Execute halting Fetch1 causing Fetch2 to naturally drain
     *  into Decode and on to Execute which is responsible for
     *  actually killing instructions */
    bool isDrained();
};
}

#endif
