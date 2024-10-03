###############################################################################
Date: WW25'2014
------------------------
This release contains the RTL + Integration Guide for the PGCB+CDC+PCGU
version 1.20.  This version is intended to comply with the latest
version of the Chassis PM Spec.

PGCB = Power Gate Control Block
CDC  = Clock Domain Controller
PCGU = PGCB Clock Gating Unit

Release Notes :
--------------
- Please refer to doc/release_notes_1.20.docx
  for release notes, change lists and gate counts

###############################################################################
DOCS
----
Integration guides and other documentation is located in the doc/[ip] folder.

###############################################################################
SOURCE SETUP
------------
ACE is now set up for the PGCB+CDC+PCGU. Do the following to setup the
environment:
   cd scripts
   source setup

To compile components + Random Testbench:
   ace -c

Random Testbench is not self checking, load in interactive and run for >10ms,
then check for assertion failures. To run Random Testbench:
   ace -x -inter



To run Lintra: (Waivers are located in $MODEL_ROOT/tools/lint/waivers/)
   $MODEL_ROOT/scripts/runlintra [pgcb | cdc | tooltb | pcgu]

To run Synthesis:
   See $MODEL_ROOT/tools/syn/README

To run QuestaCDC: (Waivers are located in $MODEL_ROOT/tools/cdc/<unit>/)
   See $MODEL_ROOT/tools/cdc/README

To run Emulation Check:
   See $MODEL_ROOT/tools/emulation/README


###############################################################################



