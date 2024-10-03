// put imports coming from dependent_libs in the ROOT scope,
// as if they had been compiled directly in sip_shared_lib
// This enables vcs, etc to act as if these packages had been 
// compiled directly into sip_shared_lib when compiling later packages
// into sip_shared_lib (in case the later packages forgot to use import)
import ovm_pkg::*;

`include "ovm_macros.svh"
