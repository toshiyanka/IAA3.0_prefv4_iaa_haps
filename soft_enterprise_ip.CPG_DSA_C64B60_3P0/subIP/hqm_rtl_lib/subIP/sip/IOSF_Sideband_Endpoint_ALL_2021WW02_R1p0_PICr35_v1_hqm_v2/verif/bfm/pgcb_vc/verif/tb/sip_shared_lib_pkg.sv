// put imports coming from dependent_libs in the ROOT scope,
// as if they had been compiled directly in sip_shared_lib
// This enables vcs, etc to act as if these packages had been 
// compiled directly into sip_shared_lib when compiling later packages
// into sip_shared_lib (in case the later packages forgot to use import)
import ovm_pkg::*;
import sla_pkg::*;

//Three below items form the Chassis Power Gating VC
	import PowerGatingCommonPkg::*;
	import CCAgentPkg::*;
	import PGCBAgentPkg::*;
	`ifdef PG_HIP_SUPPORT
	   import hip_pg_pkg::*;
        `endif

`include "ovm_macros.svh"
`include "sla_macros.svh"
