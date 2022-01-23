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

/**
 * @file
 * Declaration of a Least Recently Used replacement policy.
 * The victim is chosen using the last touch timestamp.
 */

#ifndef __MEM_CACHE_REPLACEMENT_POLICIES_DRRIP_RP_HH__
#define __MEM_CACHE_REPLACEMENT_POLICIES_DRRIP_RP_HH__

#include "mem/cache/replacement_policies/brrip_rp.hh"

struct DRRIPRPParams;

class DRRIPRP : public BRRIPRP
{
  protected:
    /**
     * Number of Set Dueling Sets.
     */
    const unsigned numSetDuelingSets;

    /**
     * Number of Policy Selection Counter Bits.
     */
    const unsigned numPSELCounterBits;

    /**
     * Policy Selection Counter.
     * mutable storage class specifier to allow PSELCounter of 
     * const object to be modified. When a function is declared 
     * as const, the this pointer passed to function becomes 
     * const. Adding mutable to a variable allows a const 
     * pointer to change members. 
     */
    mutable int PSELCounter;

  public:
    /** Convenience typedef. */
    typedef DRRIPRPParams Params;

    /**
     * Construct and initiliaze this replacement policy.
     */
    DRRIPRP(const Params *p);

    /**
     * Destructor.
     */
    ~DRRIPRP() {}

    /**
     * Reset replacement data. Used when an entry is inserted.
     * Set RRPV according to the insertion policy used.
     *
     * @param replacement_data Replacement data to be reset.
     */
    void reset(const std::shared_ptr<ReplacementData>& replacement_data) const
                                                                     override;
};

#endif // __MEM_CACHE_REPLACEMENT_POLICIES_DRRIP_RP_HH__
