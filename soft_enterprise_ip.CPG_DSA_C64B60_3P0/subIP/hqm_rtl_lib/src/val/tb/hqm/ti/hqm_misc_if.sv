//-----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2013) (2013) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
//------------------------------------------------------------------------------
// File   : hqm_misc_if.sv
// Author : Neeraj Shete
//
// Description : Declaration of hqm_misc_if (HQM Miscellaneous signals) 
// + Contains method definitions to drive signals to hqm (straps, pwr, etc.).
// + User can add methods to drive signals of interest.
//------------------------------------------------------------------------------

`ifndef HQM_MISC_IF__SV
`define HQM_MISC_IF__SV

`timescale 1ns/1ps


interface hqm_misc_if (
    input  logic side_clk
   ,input  logic prim_clk
   ,input  logic pgcb_clk
);
  logic powergood_rst_b, prim_rst_b, side_rst_b, fdfx_sync_rst;
  logic prim_pwrgate_pmc_wake, side_pwrgate_pmc_wake, pma_safemode;
  logic pm_hqm_adr_assert;              // -- Async DIMM Refresh function assertion signal 
  logic pm_hqm_adr_ack   ;              // -- Async DIMM Refresh function ack signal
  logic pmc_pgcb_restore_b;             // -- Active low PM Restore indication to PGCB: set to 1
  logic pgcb_isol_en_b;                 // -- Active low isolation cell enable: set to 1: might need for power 
  logic strap_hqm_completertenbittagen; // -- 10 bit completer tag enable: set to 1 by default
  logic strap_hqm_is_reg_ep;            // -- If 1 -> Enter EP mode of HQM; otherwise RCIEP 
  logic strap_hqm_pg_via_irc;           // -- If 1 -> PG via IRC; otherwise SAPMA?
  logic prochot;
  logic disable_prochot_drive = $test$plusargs("HQM_DISABLE_PROCHOT_DRIVE");
  bit   prochot_asserted;
  logic [15:0]         strap_hqm_err_sb_dstid;
  logic [7:0]          strap_hqm_err_sb_sai;
  logic [7:0]          strap_hqm_tx_sai;
  logic [7:0]          strap_hqm_cmpl_sai;            // -- SAI for completions
  logic [7:0]          strap_hqm_resetprep_ack_sai;   // -- SAI for ResetPrepAck message
  logic [7:0]          strap_hqm_resetprep_sai_0;     // -- Legal SAI values for Sideband ResetPrep message
  logic [7:0]          strap_hqm_resetprep_sai_1;     // -- Legal SAI values for Sideband ResetPrep message
  logic [7:0]          strap_hqm_force_pok_sai_0;     // -- Legal SAI values for Sideband ForcePwrGatePOK message
  logic [7:0]          strap_hqm_force_pok_sai_1;     // -- Legal SAI values for Sideband ForcePwrGatePOK message
  logic [15:0]         strap_hqm_do_serr_dstid;
  logic [2:0]          strap_hqm_do_serr_tag;
  logic                strap_hqm_do_serr_sairs_valid;
  logic [7:0]          strap_hqm_do_serr_sai;
  logic [0:0]          strap_hqm_do_serr_rs;
  
  logic [15:0]         strap_hqm_gpsb_srcid;
  logic                strap_hqm_16b_portids;

  logic [15:0]         strap_hqm_fp_cfg_dstid;
  logic [15:0]         strap_hqm_fp_cfg_ready_dstid;
  logic [15:0]         strap_hqm_fp_cfg_sai;
  logic [15:0]         strap_hqm_fp_cfg_sai_cmpl;
  logic [2:0]          strap_hqm_fp_cfg_tag;         

  logic [15:0]         strap_hqm_device_id;            // -- PCIe cfg device ID 
 
  logic [63:0]         strap_hqm_csr_cp;               // -- CSR CP value
  logic [63:0]         strap_hqm_csr_rac;              // -- CSR RAC value
  logic [63:0]         strap_hqm_csr_wac;              // -- CSR WAC value
  logic [9:0]          hqm_triggers;

  logic                strap_no_mgmt_acks;

  // -- Drive initial values -- //
  initial begin
          drive_initial_val();
          prochot = 1'b0;
          if(~disable_prochot_drive) drive_prochot();
  end

  initial begin  monitor_prochot(); end

  // -- Initial val -- //
  function drive_initial_val();
    powergood_rst_b<='0;       prim_rst_b<='0; 
    side_rst_b<='0;            fdfx_sync_rst<='0;
    prim_pwrgate_pmc_wake<='0; side_pwrgate_pmc_wake<='0;
    pm_hqm_adr_assert  <= '0;
    pmc_pgcb_restore_b <= '1;
    pgcb_isol_en_b     <= '1;

   
    set_strap_no_mgmt_acks($test$plusargs("HQM_STRAP_NO_MGMT_ACKS"));
    set_strap_hqm_completertenbittagen($test$plusargs("HQM_TEN_BIT_TAG_DISABLE"));
    set_strap_hqm_is_reg_ep($test$plusargs("hqm_is_reg_ep"));
    set_strap_hqm_pg_via_irc(0);
    set_strap_hqm_err_sb_sai();
    set_strap_hqm_tx_sai();
    set_strap_hqm_cmpl_sai();           
    set_strap_hqm_resetprep_ack_sai();  
    set_strap_hqm_resetprep_sai_0();    
    set_strap_hqm_resetprep_sai_1();    
    set_strap_hqm_force_pok_sai_0();    
    set_strap_hqm_force_pok_sai_1();    
    set_strap_hqm_do_serr_tag();
    set_strap_hqm_do_serr_sairs_valid();
    set_strap_hqm_do_serr_sai();
    set_strap_hqm_do_serr_rs();
    set_strap_hqm_fp_cfg_sai();
    set_strap_hqm_fp_cfg_sai_cmpl();
    set_strap_hqm_fp_cfg_tag();         
    set_strap_hqm_device_id();    
    set_strap_hqm_csr_cp();      
    set_strap_hqm_csr_rac();     
    set_strap_hqm_csr_wac();     
    set_strap_hqm_16b_portids();
    set_strap_hqm_err_sb_dstid();
    set_strap_hqm_gpsb_srcid();
    set_strap_hqm_fp_cfg_dstid();
    set_strap_hqm_fp_cfg_ready_dstid();
    set_strap_hqm_do_serr_dstid();

  endfunction

  // -- Warm reset -- //
  task hqm_warm_reset();
    `hqm_tb_log("---- Triggering warm reset to HQM ----")
    drive_initial_val();

    repeat (1) @(posedge side_clk); #0.1;
    fdfx_sync_rst <= '1;

    repeat (9) @(posedge side_clk); #0.1;
    prim_pwrgate_pmc_wake <= 1'b1;
    side_pwrgate_pmc_wake <= 1'b1;

    repeat (100) @(posedge side_clk); #0.1;
    powergood_rst_b <= 1'b1;

    // -- Release IOSF sideband from reset -- //
    repeat (20) @(posedge side_clk); #0.1;
    side_rst_b <= 1'b1;

    if($test$plusargs("hqm_pma_safemode_a")) 
       pma_safemode <= 1'b0;
    else 
       pma_safemode <= 1'b1;

    repeat (500) @(posedge side_clk); #0.1;

    if($test$plusargs("hqm_pma_safemode_b") || $test$plusargs("hqm_pma_safemode_c")) 
       pma_safemode <= 1'b1;
    else
       pma_safemode <= 1'b0;

    repeat (500) @(posedge side_clk); #0.1;

    // -- Release prim_rst_b -- //
    prim_rst_b <= 1'b1;
    repeat (5)   @(posedge side_clk); #0.1;

  endtask: hqm_warm_reset

  function set_strap_no_mgmt_acks(bit set_val);
    strap_no_mgmt_acks<= set_val;
  endfunction: set_strap_no_mgmt_acks 

  function set_strap_hqm_completertenbittagen(bit neg_val);
    strap_hqm_completertenbittagen <= ~neg_val;
  endfunction: set_strap_hqm_completertenbittagen 

  function set_strap_hqm_is_reg_ep(bit is_reg_ep);
    strap_hqm_is_reg_ep <= is_reg_ep;
  endfunction: set_strap_hqm_is_reg_ep 

  function set_strap_hqm_pg_via_irc(bit val);
    strap_hqm_pg_via_irc <= val;
  endfunction: set_strap_hqm_pg_via_irc

  task monitor_prochot();
    prochot_asserted = 1'b_0;
    wait(prochot==1'b_1);
    prochot_asserted = 1'b_1;
  endtask

  task drive_prochot();
     int dly1,dly1_min,dly1_max,dly2,dly2_min,dly2_max,seq_num,f1,f2;
     string mode;
    
     if (!$value$plusargs("HQM_PROCHOT_INIT_VAL=%b",prochot)) begin  
         prochot = 1'b0;
     end 
     // logic to drive the prochot
     if (!$value$plusargs("HQM_PH_DLY1_MIN=%d",dly1_min)) begin 
         dly1_min = $urandom_range(10,1000);
         f1 = 0;
     end   
     else begin
         f1 = 1;
     end
     if (!$value$plusargs("HQM_PH_DLY1_MAX=%d",dly1_max)) begin 
         dly1_max = $urandom_range(1000,40000);
         if (f1) begin
             dly1_max = dly1_min;
         end 
     end
     else begin
         if (f1 == 0) begin
             dly1_min = dly1_max;
         end 
     end
     dly1 = $urandom_range(dly1_min, dly1_max);
     if (!$value$plusargs("HQM_PH_DLY2_MIN=%d",dly2_min)) begin 
         dly2_min = $urandom_range(10,1000);
         f2 = 0;
     end    
     else begin
         f2 = 1;
     end
     if (!$value$plusargs("HQM_PH_DLY2_MAX=%d",dly2_max)) begin 
         dly2_max = $urandom_range(1000,40000);
         if (f2) begin
             dly2_max = dly2_min;
         end 
     end
     else begin
         if (f2 == 0) begin
             dly2_min = dly2_max;
         end 
     end
     dly2 = $urandom_range(dly2_min, dly2_max);
     if (!$value$plusargs("HQM_PH_SEQ_NUM=%d",seq_num)) begin
         seq_num = $urandom_range(5,20);
     end 
     if (!$value$plusargs("HQM_PH_MODE=%s",mode)) begin
         mode = "skip";
     end 
     case(mode)
         "assert_ph": begin
                       #dly1; 
                       prochot = 1'b1;
                     end
         "deassert_ph": begin 
                         #dly1; 
                         prochot = 1'b0;
                     end
         "ph_sequence": begin
                          if (seq_num != 0) begin 
                            repeat (seq_num) begin 
                              #dly1; 
                              prochot = ~prochot;
                              #dly2;
                              prochot = ~prochot;
                            end
                          end
                          else if (seq_num == 0) begin
                            forever begin 
                              #dly1; 
                              prochot = ~prochot;
                              #dly2;
                              prochot = ~prochot;
                            end
                          end
                        end
         "skip": ; 
     endcase 
  endtask

  function set_strap_hqm_err_sb_dstid();
      logic [15:0] temp_strap;
      if (strap_hqm_16b_portids) begin 
         strap_hqm_err_sb_dstid = get_strap_val("HQM_STRAP_ERR_SB_DSTID", `HQM_STRAP_ERR_SB_DSTID_16B);
         if (~(|strap_hqm_err_sb_dstid[15:8])) begin 
            temp_strap = `HQM_STRAP_ERR_SB_DSTID_16B;
            strap_hqm_err_sb_dstid[15:8] = temp_strap[15:8];
         end  
      end else begin
         strap_hqm_err_sb_dstid = get_strap_val("HQM_STRAP_ERR_SB_DSTID", `HQM_STRAP_ERR_SB_DSTID);
      end 
  endfunction

  function set_strap_hqm_err_sb_sai();
     strap_hqm_err_sb_sai <= get_strap_val("HQM_STRAP_ERR_SB_SAI", `HQM_STRAP_ERR_SB_SAI);
  endfunction

  function set_strap_hqm_tx_sai();
     strap_hqm_tx_sai <= get_strap_val("HQM_STRAP_TX_SAI", `HQM_STRAP_TX_SAI);
  endfunction

  function set_strap_hqm_cmpl_sai();
     strap_hqm_cmpl_sai <= get_strap_val("HQM_STRAP_CMPL_SAI", `HQM_STRAP_CMPL_SAI);
  endfunction
           
  function set_strap_hqm_resetprep_ack_sai();
     strap_hqm_resetprep_ack_sai <= get_strap_val("HQM_STRAP_RESETPREP_ACK_SAI", `HQM_STRAP_RESETPREP_ACK_SAI);
  endfunction
  
  function set_strap_hqm_resetprep_sai_0();
     strap_hqm_resetprep_sai_0 <= get_strap_val("HQM_STRAP_RESETPREP_SAI_0", `HQM_STRAP_RESETPREP_SAI_0);
  endfunction

  function set_strap_hqm_resetprep_sai_1();
     strap_hqm_resetprep_sai_1 <= get_strap_val("HQM_STRAP_RESETPREP_SAI_1", `HQM_STRAP_RESETPREP_SAI_1);
  endfunction
    
  function set_strap_hqm_force_pok_sai_0();
     strap_hqm_force_pok_sai_0 <= get_strap_val("HQM_STRAP_FORCE_POK_SAI_0", `HQM_STRAP_FORCE_POK_SAI_0);
  endfunction
    
  function set_strap_hqm_force_pok_sai_1();
     strap_hqm_force_pok_sai_1 <= get_strap_val("HQM_STRAP_FORCE_POK_SAI_1", `HQM_STRAP_FORCE_POK_SAI_1);
  endfunction

  function set_strap_hqm_do_serr_dstid();
      logic [15:0] temp_strap;
      if (strap_hqm_16b_portids) begin 
         strap_hqm_do_serr_dstid = get_strap_val("HQM_STRAP_DO_SERR_DSTID", `HQM_STRAP_DO_SERR_DSTID_16B);
         if (~(|strap_hqm_do_serr_dstid[15:8])) begin 
            temp_strap = `HQM_STRAP_DO_SERR_DSTID_16B;
            strap_hqm_do_serr_dstid[15:8] = temp_strap[15:8];
         end  
      end else begin
         strap_hqm_do_serr_dstid = get_strap_val("HQM_STRAP_DO_SERR_DSTID", `HQM_STRAP_DO_SERR_DSTID);
      end 
  endfunction

  function set_strap_hqm_do_serr_tag();
     strap_hqm_do_serr_tag <= get_strap_val("HQM_STRAP_DO_SERR_TAG", `HQM_STRAP_DO_SERR_TAG);
  endfunction

  function set_strap_hqm_do_serr_sairs_valid();
     strap_hqm_do_serr_sairs_valid <= get_strap_val("HQM_STRAP_DO_SERR_SAIRS_VALID", `HQM_STRAP_DO_SERR_SAIRS_VALID);
  endfunction

  function set_strap_hqm_do_serr_sai();
     strap_hqm_do_serr_sai <= get_strap_val("HQM_STRAP_DO_SERR_SAI", `HQM_STRAP_DO_SERR_SAI);
  endfunction

  function set_strap_hqm_do_serr_rs();
     strap_hqm_do_serr_rs <= get_strap_val("HQM_STRAP_DO_SERR_RS", `HQM_STRAP_DO_SERR_RS);
  endfunction

  function set_strap_hqm_gpsb_srcid();
      logic [15:0] temp_strap;
      if (strap_hqm_16b_portids) begin 
         strap_hqm_gpsb_srcid = get_strap_val("HQM_STRAP_GPSB_SRCID", `HQM_STRAP_GPSB_SRCID_16B);
         if (~(|strap_hqm_gpsb_srcid[15:8])) begin 
            temp_strap = `HQM_STRAP_GPSB_SRCID_16B;
            strap_hqm_gpsb_srcid[15:8] = temp_strap[15:8];
         end  
      end else begin
         strap_hqm_gpsb_srcid = get_strap_val("HQM_STRAP_GPSB_SRCID", `HQM_STRAP_GPSB_SRCID);
      end 
  endfunction

  function set_strap_hqm_16b_portids();
     strap_hqm_16b_portids = get_strap_val("HQM_STRAP_16B_PORTIDS", `HQM_STRAP_16B_PORTIDS);
  endfunction

  function set_strap_hqm_fp_cfg_dstid();
      logic [15:0] temp_strap;
      if (strap_hqm_16b_portids) begin 
         strap_hqm_fp_cfg_dstid = get_strap_val("HQM_STRAP_FP_CFG_DSTID", `HQM_STRAP_FP_CFG_DSTID_16B);
         if (~(|strap_hqm_fp_cfg_dstid[15:8])) begin 
            temp_strap = `HQM_STRAP_FP_CFG_DSTID_16B;
            strap_hqm_fp_cfg_dstid[15:8] = temp_strap[15:8];
         end  
      end else begin
         strap_hqm_fp_cfg_dstid = get_strap_val("HQM_STRAP_FP_CFG_DSTID", `HQM_STRAP_FP_CFG_DSTID);
      end 
  endfunction

  function set_strap_hqm_fp_cfg_ready_dstid();
      logic [15:0] temp_strap;
      if (strap_hqm_16b_portids) begin 
         strap_hqm_fp_cfg_ready_dstid = get_strap_val("HQM_STRAP_FP_CFG_READY_DSTID", `HQM_STRAP_FP_CFG_READY_DSTID_16B);
         if (~(|strap_hqm_fp_cfg_ready_dstid[15:8])) begin 
            temp_strap = `HQM_STRAP_FP_CFG_READY_DSTID_16B;
            strap_hqm_fp_cfg_ready_dstid[15:8] = temp_strap[15:8];
         end  
      end else begin
         strap_hqm_fp_cfg_ready_dstid = get_strap_val("HQM_STRAP_FP_CFG_READY_DSTID", `HQM_STRAP_FP_CFG_READY_DSTID);
      end
  endfunction

  function set_strap_hqm_fp_cfg_sai();
     strap_hqm_fp_cfg_sai <= get_strap_val("HQM_STRAP_FP_CFG_SAI", `HQM_STRAP_FP_CFG_SAI);
  endfunction

  function set_strap_hqm_fp_cfg_sai_cmpl();
     strap_hqm_fp_cfg_sai_cmpl <= get_strap_val("HQM_STRAP_FP_CFG_SAI_CMPL", `HQM_STRAP_FP_CFG_SAI_CMPL);
  endfunction

  function set_strap_hqm_fp_cfg_tag();         
     strap_hqm_fp_cfg_tag <= get_strap_val("HQM_STRAP_FP_CFG_TAG", `HQM_STRAP_FP_CFG_TAG);
  endfunction

  function set_strap_hqm_device_id();    
     strap_hqm_device_id  <= get_strap_val("HQM_STRAP_DEVICE_ID", `HQM_STRAP_DEVICE_ID);    
  endfunction

  function set_strap_hqm_csr_cp();      
     strap_hqm_csr_cp <= get_strap_val("HQM_STRAP_CSR_CP", `HQM_STRAP_CSR_CP);      
  endfunction

  function set_strap_hqm_csr_rac();     
     strap_hqm_csr_rac <= get_strap_val("HQM_STRAP_CSR_RAC", `HQM_STRAP_CSR_RAC);     
  endfunction

  function set_strap_hqm_csr_wac();     
     strap_hqm_csr_wac <= get_strap_val("HQM_STRAP_CSR_WAC", `HQM_STRAP_CSR_WAC);     
  endfunction

  function longint get_strap_val(string plusarg_name, longint default_val);
    string val_string = "";
    if(!$value$plusargs({$sformatf("%s",plusarg_name),"=%s"}, val_string)) begin
       get_strap_val = default_val; // -- Assign default value of strap, if no plusarg provided -- //
    end
    else if (lvm_common_pkg::token_to_longint(val_string,get_strap_val) == 0) begin
      `hqm_tb_log($psprintf("ERROR: +%s=%s not a valid integer value",plusarg_name,val_string))
      get_strap_val = default_val; // -- Assign default value of strap, if no plusarg provided -- //
    end

    // -- Finally print the resolved strap value -- //
     `hqm_tb_log($psprintf("Resolved strap (%s) with value (0x%0x) ", plusarg_name, get_strap_val));

  endfunction

  task drive_pm_adr_req(bit val);
     `hqm_tb_log($psprintf("Driving %0b on pm_hqm_adr_assert", val));
     pm_hqm_adr_assert <= val;
  endtask :drive_pm_adr_req

  task wait_for_pm_adr_req();
      `hqm_tb_log($psprintf("%t Waiting for rising edge of pm_hqm_adr_assert", $time));
      @(posedge pm_hqm_adr_assert);
      `hqm_tb_log($psprintf("%t Rising edge of pm_hqm_adr_assert detected", $time));
  endtask : wait_for_pm_adr_req

  task  wait_for_pm_adr_ack();
      `hqm_tb_log($psprintf("%t Waiting for pm_adr_ack to be asserted", $time));
      wait (pm_hqm_adr_ack == 1'b1);
      `hqm_tb_log($psprintf("pm_adr_ack asserted", $time));
  endtask : wait_for_pm_adr_ack

endinterface : hqm_misc_if 

`endif

