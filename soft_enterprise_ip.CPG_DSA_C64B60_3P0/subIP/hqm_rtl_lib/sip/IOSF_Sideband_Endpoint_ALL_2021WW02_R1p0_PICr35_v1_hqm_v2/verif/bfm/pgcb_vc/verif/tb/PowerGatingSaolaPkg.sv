package PowerGatingSaolaPkg;

	import ovm_pkg::*;
	import sla_pkg::*;
	`include "ovm_macros.svh"
	`include "sla_macros.svh"

	import PowerGatingCommonPkg::*;
	import CCAgentPkg::*;
	import PGCBAgentPkg::*;
	`ifdef PG_HIP_SUPPORT
	   import hip_pg_pkg::*;
        `endif

	
	`include "ScoreBoard.svh"
	//Saola Envs
	`include "PowerGatingSaolaEnv.svh"
	`include "seqLib/FabEnterIdleSequence.svh"
	`include "seqLib/FabExitIdleSequence.svh"
	`include "seqLib/SIPHWUGReqSequence.svh"
	`include "seqLib/SIPPMCWakeSequence.svh"
	`include "seqLib/DESIPPMCWakeSequence.svh"
	`include "seqLib/SIPSWPGReqSequence.svh"
	`include "seqLib/DeSIPSWPGReqSequence.svh"
	`include "seqLib/SIPHWSaveReqSequence.svh"
//	`include "seqLib/SIPHWRestoreReqSequence.svh"
	`include "seqLib/SIPPMCWakeAllSequence.svh"
	`include "seqLib/DESIPPMCWakeAllSequence.svh"
	
	`include "seqLib/SIPRandHWUGReqSequence.svh"
	`include "seqLib/SIPRandHWSaveReqSequence.svh"
	`include "seqLib/FETONMode.svh"
	`include "seqLib/FETONModeReset.svh"
	`include "seqLib/IPInaccessibleSequence.svh"
	`include "seqLib/FabPMCPGReq.svh"
	`include "seqLib/RestoreNextWake.svh"
	`include "seqLib/RestoreDsd.svh"
	`include "seqLib/FabPMCUGReq.svh"
	`include "seqLib/SIPBaseTestPhase2Seq.svh"
	
	//DBV
	//HIP PG Sequences
	`ifdef PG_HIP_SUPPORT
	  `include "seqLib/hip_pg_seq_lib/hip_pg_seq_lib_includes.svh"
        `endif  
	
	`include "test/PowerGatingBaseTest.svh"
	`include "test/FabricBasicTest.svh"
	`include "test/FabricAbortTest.svh"
	`include "test/FabricAgentWakeTest.svh"
	`include "test/FabricResponseOverrideTest.svh"
	`include "test/SIPBasicTest.svh"
	//`include "test/SIPAbortTest.svh"
	`include "test/AssertionFailTest.svh"
	`include "test/ConcurrentTest.svh"
	`include "test/ResetTest.svh"
	`include "test/ArbitrationTest.svh"
	`include "test/FETModeTest.svh"
	`include "test/WaitForComplete.svh"
	`include "test/ErrorPMCWakeTest.svh"
	`include "test/Acc_IPInaccTest.svh"
	`include "test/FabricPMCPGErrorTest.svh"
	`include "test/RestoreTest.svh"
	`include "test/RestoreErrorTest.svh"
	`include "test/DfxTest.svh"
	`include "test/SIPBasicTestPhase2.svh"

        //DBV HIP tests
        `ifdef PG_HIP_SUPPORT
	  `include "test/HIPPowergate_ungate.svh"
        `endif



endpackage
