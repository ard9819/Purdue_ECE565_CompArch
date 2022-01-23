/**
 * Copyright (c) 2018 Inria
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met: redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer;
 * redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution;
 * neither the name of the copyright holders nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "mem/cache/replacement_policies/drrip_rp.hh"

#include <cassert>
#include <memory>

#include "base/random.hh"
#include "params/DRRIPRP.hh"

DRRIPRP::DRRIPRP(const Params *p)
    : BRRIPRP(p),
      numSetDuelingSets(p->num_set_dueling_sets), numPSELCounterBits(p->num_PSEL_counter_bits)
{
    // Setting the PSELCounter Initially to 2^(numPSELCounterBits - 1)
    // And Incrementing on Miss incurred in SRRIP Dedicated Sets
    // And Decrementing on Miss incurred in BRRIP Dedicated Sets
    PSELCounter = (1 << (numPSELCounterBits - 1));
    //PSELCounter = pow(2, (numPSELCounterBits - 1));
}

void
DRRIPRP::reset(const std::shared_ptr<ReplacementData>& replacement_data) const
{
    uint32_t set_num;
    uint32_t constituency_num;
    uint32_t offset_within_constituency;
    uint32_t offset_within_constituency_complement;

    bool srrip_dedicated_set;
    bool brrip_dedicated_set;

    int PSELCounter_MSB;
    uint32_t PSELCounter_max_val;
    uint32_t PSELCounter_min_val;

    std::shared_ptr<BRRIPReplData> casted_replacement_data =
        std::static_pointer_cast<BRRIPReplData>(replacement_data);

    // Calculating the Set Number
    set_num = replacement_data->set_num;

    // Calculating Constituency and masking off the bits higher than ((2^numSetDuelingSets) - 1)
    constituency_num = ((set_num / numSetDuelingSets) & (numSetDuelingSets - 1));

    // Offset is a number between 0 - (numSetDuelingSets-1)
    offset_within_constituency = (set_num % numSetDuelingSets);

    // Calculating Complement of offset and masking off the bits higher than ((2^numSetDuelingSets) - 1)
    offset_within_constituency_complement = ((~offset_within_constituency) & (numSetDuelingSets - 1));

    // Calculating whether the set_num belongs to
    // Dedicated SRRIP Set (constituency = offset)
    // Dedicated BRRIP Set (constituency = offset_complement)
    srrip_dedicated_set = (constituency_num == offset_within_constituency)? true: false;
    brrip_dedicated_set = (constituency_num == offset_within_constituency_complement)? true: false;

    // Calculating the MSB of Policy Selection Counter
    // If MSB == 0, BRRIP has more misses -> Follow SRRIP
    // If MSB == 1, SRRIP has more misses -> Follow BRRIP
    PSELCounter_MSB = ((PSELCounter) & (1 << (numPSELCounterBits - 1))) >> (numPSELCounterBits - 1);

    // Calculating the Max and Min value of Policy Selection Counter
    PSELCounter_max_val = ((1 << numPSELCounterBits) - 1);
    PSELCounter_min_val = 0;

    // Reset RRPV
    // Replacement data is inserted as "long re-reference" if lower than btp,
    // "distant re-reference" otherwise
    casted_replacement_data->rrpv.saturate();

    if (srrip_dedicated_set == true) // In case of SRRIP Dedicated Sets
    {
      // Incrementing the Policy Selector through saturating arithmetic
      if (PSELCounter < PSELCounter_max_val)
      {
        PSELCounter = PSELCounter + 1;
      }

      // Inserting Cache block with Long re-reference interval prediction (2^M - 2)
      casted_replacement_data->rrpv--;
    }
    else if (brrip_dedicated_set == true) // In case of BRRIP Dedicated Sets
    {
      // Decrementing the Policy Selector through saturating arithmetic
      if (PSELCounter > PSELCounter_min_val)
      {
        PSELCounter = PSELCounter - 1;
      }

      // Inserting Cache block with Distant re-reference interval prediction (2^M - 1)
      // and Infrequently with Long re-reference interval prediction (2^M - 2)
      if (random_mt.random<unsigned>(1, 100) <= btp) {
          casted_replacement_data->rrpv--;
      }
    }
    else // In case of Follower Sets
    {
      if (PSELCounter_MSB == 1) // SRRIP has more misses, Follow BRRIP Replacement Policy
      {
        // Inserting Cache block with Distant re-reference interval prediction (2^M - 1)
        // and Infrequently with Long re-reference interval prediction (2^M - 2)
        if (random_mt.random<unsigned>(1, 100) <= btp) {
            casted_replacement_data->rrpv--;
        }
      }
      else // BRRIP has more misses, Follow SRRIP Replacement Policy
      {
        // Inserting Cache block with Long re-reference interval prediction (2^M - 2)
        casted_replacement_data->rrpv--;
      }      
    }

    // Mark entry as ready to be used
    casted_replacement_data->valid = true;
}

DRRIPRP*
DRRIPRPParams::create()
{
    return new DRRIPRP(this);
}


