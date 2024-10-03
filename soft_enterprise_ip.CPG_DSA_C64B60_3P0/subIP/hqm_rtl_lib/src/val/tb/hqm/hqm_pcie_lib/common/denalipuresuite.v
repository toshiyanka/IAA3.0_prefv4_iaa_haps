
`timescale 1ns/1ns
module denaliPuresuite;
   
  `include "denaliPcieTypes.v"

  integer result;
  integer status;
  reg [31:0] deviceState;

  initial begin
    // The Denali instance id's in the hqm_tb_top module are also initialized
    // in an initial-block.
    // Put a delay here to make sure we don't have a race condition.
    //
    deviceState = PCIE_DEVICE_STATE_UNDEFINED;
    #0;

    //
    // if the device uses a sideband reset (i.e., PIPE i/f) and we want to
    // bypass PL training, need to set some regsiters
    //
    `ifdef BYPASS_PL
      $display("Bypassing PL training");
      status = denaliPcie.writeWordField( hqm_tb_top.denali_model_cfg_id,
                                          PCIE_REG_DEN_SIM_ST,
                                          1'b1,
                                          PCIE_Rmask__DEN_SIM_ST_bypassPLcom,
                                          PCIE_Rpos__DEN_SIM_ST_bypassPLcom );
      status = denaliPcie.writeWordField( hqm_tb_top.denali_monitor_cfg_id,
                                          PCIE_REG_DEN_SIM_ST,
                                          1'b1,
                                          PCIE_Rmask__DEN_SIM_ST_bypassPLcom,
                                          PCIE_Rpos__DEN_SIM_ST_bypassPLcom );
      if (hqm_tb_top.DUT_cfg_id) begin
        status = denaliPcie.writeWordField( hqm_tb_top.DUT_cfg_id,
                                            PCIE_REG_DEN_SIM_ST,
                                            1'b1,
                                            PCIE_Rmask__DEN_SIM_ST_bypassPLcom,
                                            PCIE_Rpos__DEN_SIM_ST_bypassPLcom );
      end
    `endif
    `ifdef INVOKE_AFTER_RC_ACTIVE
    //
    // wait for the RC to reach ACTIVE (PL/DL/TL/CFG initialized) state ...
    //
    
    // if the monitor is the EP, the denali model must be the RC
    //
    if (denaliPcie.isEndpoint(hqm_tb_top.denali_monitor_cfg_id) ||
        denaliPcie.isSwitch(hqm_tb_top.denali_monitor_cfg_id) ||
        denaliPcie.isBridge(hqm_tb_top.denali_monitor_cfg_id) )
      begin
         while (deviceState != PCIE_DEVICE_STATE_Active) begin
            @(posedge hqm_tb_top.clk);
            deviceState = denaliPcie.readWordField(hqm_tb_top.denali_model_cfg_id, 
                                                   PCIE_REG_DEN_DEV_ST,
                                                   PCIE_Rmask__DEN_DEV_ST_state,
                                                   PCIE_Rpos__DEN_DEV_ST_state);
         end
      end
     
     // if the monitor is the RC, the DUT is the RC
     // (the user will need to modify this part...)
     //
    else if (denaliPcie.isRootComplex(hqm_tb_top.denali_monitor_cfg_id)) begin
       if (hqm_tb_top.DUT_cfg_id)
         begin
            // The DUT instance is a Denali model...
            while (deviceState != PCIE_DEVICE_STATE_Active) begin
               @(posedge hqm_tb_top.clk);
               deviceState = denaliPcie.readWordField(hqm_tb_top.DUT_cfg_id, 
                                                      PCIE_REG_DEN_DEV_ST,
                                                      PCIE_Rmask__DEN_DEV_ST_state,
                                                      PCIE_Rpos__DEN_DEV_ST_state);
            end
         end
       else
         begin
            // put_DUT_specific_code_here;
         end // else: !if(hqm_tb_top.DUT_cfg_id)
       // Set Monitor's dutActive
       status = denaliPcie.writeWordField( hqm_tb_top.denali_monitor_cfg_id,
                                           PCIE_REG_DEN_PS_ST,
                                           1'b1,
                                           PCIE_Rmask__DEN_PS_ST_dutActive,
                                           PCIE_Rpos__DEN_PS_ST_dutActive);
      end
    else begin
      $display("########### Unexpected Monitor Type ###########");
    end

    `endif
     
    // For many of the PL testcases to run in a reasonable amount of time,
    // several timeouts must be shortened in the DUT.  These modified
    // timeout values also need to be reflected in the denali_monitor.
    //
    // (ttoRcvrLock must be longer that 1024 TS1s to prevent a premature timeout
    // when EXP_LINK_CTRL.extSync is set.)
     //
    `ifdef DUT_IS_PHY
     mmsomaset("hqm_tb_top.denali_rc");
     mmsomaset("hqm_tb_top.denali_ep");
    `else
     `ifdef DUT_IS_DENALI
     mmsomaset("hqm_tb_top.DUT");
     `endif
    `endif
     
     // Don't forget to inform the monitor of the DUT's actual timeouts!
     //
     // (ttoRcvrLock must be longer that 1024 TS1s to prevent a premature timeout
     // when EXP_LINK_CTRL.extSync is set.)
     //
    `ifdef DUT_IS_PHY
     `ifdef SERIAL_MONITOR
     mmsomaset("hqm_tb_top.serial_monitor");
     `endif
     `ifdef PIPE_MONITOR
     mmsomaset("hqm_tb_top.pipe_monitor");     
     `endif
    `else
     mmsomaset("hqm_tb_top.denali_monitor");
    `endif
     
     
     //
     // ... and then invoke the PureSuite task
     //
     // (If SIDEBAND_RESET is defined, a sideband reset will be used to reset the
     // system between testcases, and the SIDEBAND_RESET macro is an integer specifying
     // the duration of the PERST_n assertion.)
     // 
     //

if($test$plusargs("RUN_PURESUITE")) 
begin
    `ifdef SIDEBAND_RESET
     status = $denaliPsTb(hqm_tb_top.PERST_n, `SIDEBAND_RESET);
    `else
     status = $denaliPsTb();
    `endif
end     

  end
   
   task mmsomaset;
      input [300:0] path;
      begin
         status = $mmsomaset(path, "ttoDetectQuiet", "3", "us"); // spec value = 12 ms
         status = $mmsomaset(path, "ttoDetectActive", "1.2", "us"); // spec value = 12 ms
         status = $mmsomaset(path, "ttoPollActive", "8", "us"); // spec value = 24 ms
         status = $mmsomaset(path, "ttoPollConfig", "8", "us"); // spec value = 48 ms
         status = $mmsomaset(path, "ttoCfgLkStartDn", "8", "us"); // spec value = 24 ms
         status = $mmsomaset(path, "ttoCfgLkStartUp", "8", "us"); // spec value = 24 ms
         status = $mmsomaset(path, "ttoCfgLkAcceptDn", "3", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoCfgLkAcceptUp", "3", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoCfgLnWaitDn", "3", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoCfgLnWaitUp", "3", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoCfgCompDn", "2", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoCfgCompUp", "2", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoCfgIdle", "2", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoRcvrLock", "8" /*128*/, "us"); // spec value = 24 ms
         status = $mmsomaset(path, "ttoRcvrCfg", "8", "us"); // spec value = 48 ms
         status = $mmsomaset(path, "ttoRcvrIdle", "2", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoDisabled", "2", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoHotReset", "2", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoLoopback", "2", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoRecSpeed", "10", "us"); // spec value = 48 ms
         status = $mmsomaset(path, "ttoLoopbackEntry", "3", "us"); // spec value = 100 ms
         status = $mmsomaset(path, "ttxG2DetectQuietMin", "1", "us"); // spec value = 1 ms
         status = $mmsomaset(path, "ttoPollCompTxEiMin", "1", "us"); // spec value = 1 ms
         status = $mmsomaset(path, "ttoPollCompTxEiMax", "2", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "trxInferEImax", "12", "us"); // spec value = 128 us
         status = $mmsomaset(path, "ttoInferEIExitSpeed5_0", "3000", "clk"); // spec value = 16000 clk
         status = $mmsomaset(path, "ttoLoopbackEntry2Active", "2", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoLoopbackEntryEIMaster", "2", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoLoopbackEntryEISlave", "1", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoFLRmin", "1", "us"); // spec value = 100 ms
         status = $mmsomaset(path, "ttoFLRmax", "2", "us"); // spec value = 100 ms
         status = $mmsomaset(path, "ttoFLRInit", "1", "us"); // spec value = undefined
         status = $mmsomaset(path, "ttoFCmin", "1", "us"); // spec value = 200 us
         status = $mmsomaset(path, "ttoFCmax", "1.5", "us"); // spec value = 300 us
         status = $mmsomaset(path, "ttoEqPhase0Max", "1", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoEqPhase1Max", "1", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoEqPhase2Max", "1", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoEqPhase3Max", "1", "us"); // spec value = 2 ms
         status = $mmsomaset(path, "ttoEqReqPeriodMin", "300", "ns"); // spec value = 1 us
         status = $mmsomaset(path, "ttoReSpdChg", "10", "us"); // spec value = 200 ms
      end
   endtask   
endmodule


