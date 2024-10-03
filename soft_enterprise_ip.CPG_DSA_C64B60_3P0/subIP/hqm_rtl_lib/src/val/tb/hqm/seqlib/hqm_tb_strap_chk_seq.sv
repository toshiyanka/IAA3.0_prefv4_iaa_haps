//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2017 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------

`ifndef HQM_TB_STRAP_CHK_SEQ__SV
`define HQM_TB_STRAP_CHK_SEQ__SV

//-----------------------------------------------------------------------------------
// File        : hqm_tb_strap_chk_seq.sv
// Author      : Neeraj Shete
//
// Description : This sequence does the connectivity checks of straps driven to HQM.
//               Values are checked within RTL at the points where straps are used 
//               within HQM.
//-----------------------------------------------------------------------------------

import hqm_tb_sequences_pkg::*, hqm_sif_csr_pkg::*;

class hqm_tb_strap_chk_seq extends sla_sequence_base;

  `ovm_object_utils(hqm_tb_strap_chk_seq)

  int num_straps_checked = 0;

  //----------------------------------------------
  //-- new()
  //----------------------------------------------  
  function new(string name = "hqm_tb_strap_chk_seq");
    super.new(name); 
  endfunction

  //----------------------------------------------
  //-- body()
  //----------------------------------------------  
  virtual task body();
    string hqm_sif_core = "hqm_tb_top.u_hqm.i_hqm_sip.hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core";
    string strap_q[$], strap_sig_path_q[$], strap_concat_sig_path_q[$];
    longint strap_default_val_q[$];
    bit strap_hqm_16b_portids;
    string strap_path;
    bit [15:0] strap_val;

    strap_hqm_16b_portids = get_strap_val("HQM_STRAP_16B_PORTIDS", `HQM_STRAP_16B_PORTIDS, strap_hqm_16b_portids);

    // Checking portids
    strap_q = { "HQM_STRAP_ERR_SB_DSTID"};
    if (strap_hqm_16b_portids) begin
       strap_default_val_q = { `HQM_STRAP_ERR_SB_DSTID_16B};
       strap_sig_path_q = { $psprintf("%s.i_hqm_iosfsb_core.i_ri_iosf_sb.strap_hqm_err_sb_dstid[15:0]", hqm_sif_core)
                          }; 
       strap_val = get_strap_val("HQM_STRAP_GPSB_SRCID", `HQM_STRAP_GPSB_SRCID_16B, strap_hqm_16b_portids);
       strap_path = $psprintf("%s.i_hqm_iosfsb_core.i_hqm_sbebase.gen_doserrmstr.sbedoserrmstr.do_serr_srcid_strap[7:0]",hqm_sif_core);
       chk_strap_val("HQM_STRAP_GPSB_SRCID", strap_path, strap_val[7:0]); 
       strap_path = $psprintf("%s.i_hqm_iosfsb_core.i_hqm_sbebase.do_serr_hier_srcid_strap[7:0]",hqm_sif_core);
       chk_strap_val("HQM_STRAP_GPSB_SRCID", strap_path, strap_val[15:8]);  
       strap_val = get_strap_val("HQM_STRAP_DO_SERR_DSTID", `HQM_STRAP_DO_SERR_DSTID_16B, strap_hqm_16b_portids);
       strap_path = $psprintf("%s.i_hqm_iosfsb_core.i_hqm_sbebase.gen_doserrmstr.sbedoserrmstr.do_serr_dstid_strap[7:0]",hqm_sif_core);
       chk_strap_val("HQM_STRAP_DO_SERR_DSTID", strap_path, strap_val[7:0]); 
       strap_path = $psprintf("%s.i_hqm_iosfsb_core.i_hqm_sbebase.do_serr_hier_dstid_strap[7:0]",hqm_sif_core);
       chk_strap_val("HQM_STRAP_DO_SERR_DSTID", strap_path, strap_val[15:8]);  
    end
    else begin 
       strap_q.push_back("HQM_STRAP_GPSB_SRCID");
       strap_q.push_back("HQM_STRAP_DO_SERR_DSTID");
       strap_default_val_q = {`HQM_STRAP_ERR_SB_DSTID, `HQM_STRAP_GPSB_SRCID, `HQM_STRAP_DO_SERR_DSTID};
       strap_sig_path_q = {  
                            $psprintf("%s.i_hqm_iosfsb_core.i_ri_iosf_sb.strap_hqm_err_sb_dstid[15:0]", hqm_sif_core),
                            $psprintf("%s.i_hqm_iosfsb_core.i_hqm_sbebase.gen_doserrmstr.sbedoserrmstr.do_serr_srcid_strap[7:0]", hqm_sif_core),
                            $psprintf("%s.i_hqm_iosfsb_core.i_hqm_sbebase.gen_doserrmstr.sbedoserrmstr.do_serr_dstid_strap[7:0]", hqm_sif_core)
                          }; 
    end 

	`ovm_info(get_full_name(),$psprintf("Starting hqm_tb_strap_chk_seq for (0x%0x) # of straps!!", strap_q.size()),OVM_LOW);

    foreach(strap_q[i]) begin
       chk_strap_val(strap_q[i] , strap_sig_path_q[i], get_strap_val(strap_q[i], strap_default_val_q[i], strap_hqm_16b_portids));
    end
   // ------------------------------------------------------------------- // 
   // -- Delete Qs for verifying other straps  
   // ------------------------------------------------------------------- // 
    strap_q.delete(); 
    strap_default_val_q.delete(); 
    strap_sig_path_q.delete(); 
    strap_concat_sig_path_q.delete();
   // ------------------------------------------------------------------- // 

    strap_q             = { "HQM_STRAP_RESETPREP_SAI_0", "HQM_STRAP_RESETPREP_SAI_1", "HQM_STRAP_RESETPREP_ACK_SAI", "HQM_STRAP_FORCE_POK_SAI_0", "HQM_STRAP_FORCE_POK_SAI_1" };   
    strap_sig_path_q    = {  $psprintf("%s.i_hqm_iosfsb_core.i_hqm_sb_ep_xlate.strap_hqm_resetprep_sai_0[7:0]", hqm_sif_core) 
                            ,$psprintf("%s.i_hqm_iosfsb_core.i_hqm_sb_ep_xlate.strap_hqm_resetprep_sai_1[7:0]", hqm_sif_core) 
                            ,$psprintf("%s.i_hqm_iosfsb_core.i_ri_iosf_sb.strap_hqm_resetprep_ack_sai[7:0]", hqm_sif_core) 
                            ,$psprintf("%s.i_hqm_iosfsb_core.i_hqm_sb_ep_xlate.strap_hqm_force_pok_sai_0[7:0]", hqm_sif_core) 
                            ,$psprintf("%s.i_hqm_iosfsb_core.i_hqm_sb_ep_xlate.strap_hqm_force_pok_sai_1[7:0]", hqm_sif_core) 
                          };
    strap_default_val_q = { `HQM_STRAP_RESETPREP_SAI_0,  `HQM_STRAP_RESETPREP_SAI_1,  `HQM_STRAP_RESETPREP_ACK_SAI, `HQM_STRAP_FORCE_POK_SAI_0, `HQM_STRAP_FORCE_POK_SAI_1 };


    strap_q.push_back("HQM_STRAP_ERR_SB_SAI");
    strap_sig_path_q.push_back($psprintf("%s.i_hqm_iosfsb_core.i_ri_iosf_sb.strap_hqm_err_sb_sai[7:0]", hqm_sif_core)); 
    strap_default_val_q.push_back(`HQM_STRAP_ERR_SB_SAI);

    // ------------------------------------------------------------------- // 

    strap_q.push_back("HQM_STRAP_DO_SERR_TAG");
    strap_default_val_q.push_back(`HQM_STRAP_DO_SERR_TAG);
    strap_sig_path_q.push_back($psprintf("%s.i_hqm_iosfsb_core.i_hqm_sbebase.gen_doserrmstr.sbedoserrmstr.do_serr_tag_strap[2:0]",hqm_sif_core));

    strap_q.push_back("HQM_STRAP_DO_SERR_SAIRS_VALID");
    strap_default_val_q.push_back(`HQM_STRAP_DO_SERR_SAIRS_VALID);
    strap_sig_path_q.push_back($psprintf("%s.i_hqm_iosfsb_core.i_hqm_sbebase.gen_doserrmstr.sbedoserrmstr.do_serr_sairs_valid",hqm_sif_core));

    strap_q.push_back("HQM_STRAP_DO_SERR_SAI");
    strap_default_val_q.push_back(`HQM_STRAP_DO_SERR_SAI);
    strap_sig_path_q.push_back($psprintf("%s.i_hqm_iosfsb_core.i_hqm_sbebase.gen_doserrmstr.sbedoserrmstr.do_serr_sai[7:0]",hqm_sif_core));

    strap_q.push_back("HQM_STRAP_DO_SERR_RS");
    strap_default_val_q.push_back(`HQM_STRAP_DO_SERR_RS);
    strap_sig_path_q.push_back($psprintf("%s.i_hqm_iosfsb_core.i_hqm_sbebase.gen_doserrmstr.sbedoserrmstr.do_serr_rs[0:0]",hqm_sif_core));

 
   // ------------------------------------------------------------------- // 
 
    strap_q.push_back("HQM_STRAP_CMPL_SAI");
    strap_default_val_q.push_back(`HQM_STRAP_CMPL_SAI);
    strap_sig_path_q.push_back($psprintf("%s.i_hqm_iosfp_core.i_hqm_iosf_mstr.strap_cmpl_sai[7:0]",hqm_sif_core));
 
    strap_q.push_back("HQM_STRAP_TX_SAI");
    strap_default_val_q.push_back(`HQM_STRAP_TX_SAI);
    strap_sig_path_q.push_back($psprintf("%s.i_hqm_iosfp_core.i_hqm_iosf_mstr.strap_tx_sai[7:0]",hqm_sif_core));

   // ------------------------------------------------------------------- // 

   // ------------------------------------------------------------------- // 

    strap_q.push_back("HQM_STRAP_DEVICE_ID");
    strap_default_val_q.push_back(`HQM_STRAP_DEVICE_ID);
    strap_sig_path_q.push_back($psprintf("%s.i_hqm_ri.i_ri_pf_vf_cfg.i_hqm_pf_cfg.DEVICE_ID",hqm_sif_core));

   // ------------------------------------------------------------------- // 

    strap_q.push_back("HQM_STRAP_CSR_LOAD");
    strap_default_val_q.push_back(`HQM_STRAP_CSR_LOAD);
    strap_sig_path_q.push_back($psprintf("%s.i_hqm_ri.i_sif_csr_wrap.strap_hqm_csr_load",hqm_sif_core));

	`ovm_info(get_full_name(),$psprintf("Starting hqm_tb_strap_chk_seq for (0x%0x) # of straps!!", strap_q.size()),OVM_LOW);

    foreach(strap_q[i]) begin
       chk_strap_val(strap_q[i] , strap_sig_path_q[i], get_strap_val(strap_q[i], strap_default_val_q[i]));
    end
    

   // ------------------------------------------------------------------- // 
   // -- Delete Qs for special case of CSR_CP, CSR_RAC, CSR_WAC
   // ------------------------------------------------------------------- // 
    strap_q.delete(); 
    strap_default_val_q.delete(); 
    strap_sig_path_q.delete(); 
    strap_concat_sig_path_q.delete();
   // ------------------------------------------------------------------- // 

    strap_q.push_back("HQM_STRAP_CSR_CP");
    strap_default_val_q.push_back(`HQM_STRAP_CSR_CP);
    strap_sig_path_q.push_back($psprintf("%s.i_hqm_ri.i_sif_csr_wrap.i_hqm_sif_csr.HQM_CSR_CP_HI_sai_rst_strap[31:0]",hqm_sif_core));
    strap_concat_sig_path_q.push_back($psprintf("%s.i_hqm_ri.i_sif_csr_wrap.i_hqm_sif_csr.HQM_CSR_CP_LO_sai_rst_strap[31:0]",hqm_sif_core));

    strap_q.push_back("HQM_STRAP_CSR_RAC");
    strap_default_val_q.push_back(`HQM_STRAP_CSR_RAC);
    strap_sig_path_q.push_back($psprintf("%s.i_hqm_ri.i_sif_csr_wrap.i_hqm_sif_csr.HQM_CSR_RAC_HI_sai_rst_strap[31:0]",hqm_sif_core));
    strap_concat_sig_path_q.push_back($psprintf("%s.i_hqm_ri.i_sif_csr_wrap.i_hqm_sif_csr.HQM_CSR_RAC_LO_sai_rst_strap[31:0]",hqm_sif_core));

    strap_q.push_back("HQM_STRAP_CSR_WAC");
    strap_default_val_q.push_back(`HQM_STRAP_CSR_WAC);
    strap_sig_path_q.push_back($psprintf("%s.i_hqm_ri.i_sif_csr_wrap.i_hqm_sif_csr.HQM_CSR_WAC_HI_sai_rst_strap[31:0]",hqm_sif_core));
    strap_concat_sig_path_q.push_back($psprintf("%s.i_hqm_ri.i_sif_csr_wrap.i_hqm_sif_csr.HQM_CSR_WAC_LO_sai_rst_strap[31:0]",hqm_sif_core));

   // ------------------------------------------------------------------- // 

    foreach(strap_q[i]) begin
       if(get_strap_val("HQM_STRAP_CSR_LOAD", `HQM_STRAP_CSR_LOAD) == 1) begin
          chk_strap_val(strap_q[i] , strap_sig_path_q[i], get_strap_val(strap_q[i], strap_default_val_q[i]), strap_concat_sig_path_q[i]);
       end else begin
          chk_strap_val(strap_q[i] , strap_sig_path_q[i], strap_default_val_q[i], strap_concat_sig_path_q[i]);
       end
    end
  

    chk_strap_val("HQM_COMPLETER_TEN_BIT_TAG_EN", $psprintf("%s.i_hqm_ri.i_ri_pf_vf_cfg.i_hqm_pf_cfg.PCIE_CAP_DEVICE_CAP_2.CMP10BTAGS",hqm_sif_core), (1'b1 & ~$test$plusargs("HQM_TEN_BIT_TAG_DISABLE")));
    chk_strap_val("HQM_IS_REG_EP", $psprintf("%s.i_hqm_ri.i_ri_pf_vf_cfg.strap_hqm_is_reg_ep",hqm_sif_core), (1'b1 & $test$plusargs("hqm_is_reg_ep") ));

    `ovm_info(get_full_name(), $psprintf("Total number of straps checked : (0x%0x)/(%0d)",num_straps_checked, num_straps_checked), OVM_LOW)
 
  endtask : body

  function longint get_strap_val(string plusarg_name, longint default_val, bit mode = 0);
    string val_string = "";
    if(!$value$plusargs({$sformatf("%s",plusarg_name),"=%s"}, val_string)) begin
       get_strap_val = default_val; // -- Assign default value of strap, if no plusarg provided -- //
    end
    else if (lvm_common_pkg::token_to_longint(val_string,get_strap_val) == 0) begin
      `ovm_error(get_full_name(),$psprintf("+%s=%s not a valid integer value",plusarg_name,val_string))
      get_strap_val = default_val; // -- Assign default value of strap, if no plusarg provided -- //
    end

    if (mode == 1) begin  // 16bit mode 
      if (~(|get_strap_val[15:8])) begin 
         get_strap_val[15:8] = default_val[15:8];
      end  
    end 
    // -- Finally print the resolved strap value -- //
    `ovm_info(get_full_name(), $psprintf("Resolved strap (%s) with value (0x%0x) is_16bitmode (%0d)", plusarg_name, get_strap_val, mode), OVM_LOW);

  endfunction

  task chk_strap_val(string strap_name, string sig_name, longint exp_val, string concatenate_sig_name = "");
    chandle             strap_signal_handle;
    string              debug_msg="";
    longint             sig_val;

    strap_signal_handle = SLA_VPI_get_handle_by_name(sig_name,0);
    hqm_seq_get_value(strap_signal_handle, sig_val);
   
    if(concatenate_sig_name == "") begin
       `ovm_info(get_full_name(), $psprintf("Only sig_name (%s) provided", sig_name), OVM_LOW)
    end else begin
       longint loc_sig_val, temp_sig_val;
       `ovm_info(get_full_name(), $psprintf("Along with sig_name (%s), concatenate_sig_name (%s) provided", sig_name, concatenate_sig_name), OVM_LOW)
       strap_signal_handle = SLA_VPI_get_handle_by_name(concatenate_sig_name,0);
       hqm_seq_get_value(strap_signal_handle, loc_sig_val);
       temp_sig_val[63:32] = sig_val[31:0];
       temp_sig_val[31:00] = loc_sig_val[31:0];
       sig_val = temp_sig_val;
    end

    debug_msg = {debug_msg,$psprintf("Signal (%s) obs_val (0x%0x) and exp_val(0x%0x)",sig_name,sig_val,exp_val)};

    if(sig_val==exp_val) `ovm_info(get_full_name(), $sformatf("Strap %s value check passed for %s", strap_name, debug_msg),OVM_LOW) 
    else                 `ovm_error(get_full_name(),$sformatf("Strap %s value check failed for %s", strap_name, debug_msg))

    num_straps_checked++;

  endtask

endclass : hqm_tb_strap_chk_seq

`endif
