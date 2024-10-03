// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
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
// -----------------------------------------------------------------------------
// File   : hqm_iosf_cg_seq.sv
// Author :araghuw 
// Description :
//
// -----------------------------------------------------------------------------

class hqm_iosf_cg_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_cg_seq, sla_sequencer)
  back2back_sb_memrd_seq        sb_memrd_seq;
  back2back_sb_cfgrd_seq        sb_cfgrd_seq;        


  function new(string name = "hqm_iosf_cg_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0] rdata;
    
    if($test$plusargs("SIDE_CG"))begin
      WriteField("config_master", "cfg_control_general","CFG_ENABLE_UNIT_IDLE", 'h1);
      WriteReg("hqm_sif_csr", "side_cdc_ctl", 'h0003_4444);
      WriteReg("hqm_sif_csr", "iosfs_cgctl",  'h0000_0010);
    end

    if($test$plusargs("SIDE_CG1"))begin
      WriteField("config_master", "cfg_control_general","CFG_ENABLE_UNIT_IDLE", 'h1);
      WriteReg("hqm_sif_csr", "side_cdc_ctl", 'h0000_4444);
      WriteReg("hqm_sif_csr", "iosfs_cgctl",  'h0000_0110);

      `ovm_do(sb_memrd_seq);
    end

    if($test$plusargs("PRIM_CG"))begin
      WriteField("config_master", "cfg_control_general","CFG_ENABLE_UNIT_IDLE", 'h1);
      WriteReg("hqm_sif_csr", "prim_cdc_ctl", 'h0000_4444);
      WriteReg("hqm_sif_csr", "iosfp_cgctl",  'h0000_0110);
      #4000;
      WriteReg("hqm_sif_csr", "prim_cdc_ctl",  'h0003_4444);
      WriteReg("hqm_sif_csr", "iosfp_cgctl",  'h0000_0010);
      #4000;
      WriteReg("hqm_sif_csr", "prim_cdc_ctl",  'h0000_4444);
      WriteReg("hqm_sif_csr", "iosfp_cgctl",  'h0000_0110);
      #4000;
      WriteReg("hqm_sif_csr", "prim_cdc_ctl",  'h0003_4444);
      WriteReg("hqm_sif_csr", "iosfp_cgctl",  'h0000_0010);
      #4000;
      WriteReg("hqm_sif_csr", "prim_cdc_ctl", 'h0000_4444);
      WriteReg("hqm_sif_csr", "iosfp_cgctl",  'h0000_0110);
    end

    if($test$plusargs("PRIM_CG1"))begin
      WriteField("config_master", "cfg_control_general","CFG_ENABLE_UNIT_IDLE", 'h1);
      WriteReg("hqm_sif_csr", "prim_cdc_ctl", 'h0003_4444);
      WriteReg("hqm_sif_csr", "iosfp_cgctl",  'h0000_0010);
      #4000;
      WriteReg("hqm_sif_csr", "prim_cdc_ctl", 'h0000_4444);
      WriteReg("hqm_sif_csr", "iosfp_cgctl",  'h0000_0110);
      WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",  'h0044_1000);
    end

    if($test$plusargs("PRIM_CG2"))begin
      WriteField("config_master", "cfg_control_general","CFG_ENABLE_UNIT_IDLE", 'h1);
      WriteReg("hqm_sif_csr", "prim_cdc_ctl", 'h0000_4444);
      WriteReg("hqm_sif_csr", "iosfp_cgctl",  'h0000_0110);
      #4000;
    end

    if($test$plusargs("IDLE_NAK"))begin
      WriteReg("hqm_pf_cfg_i", "func_bar_l", 'h0);
      WriteReg("hqm_pf_cfg_i", "func_bar_u", 'h0);
      WriteReg("hqm_pf_cfg_i", "csr_bar_l",  'h0);
      WriteReg("hqm_pf_cfg_i", "csr_bar_u",  'h0);

      `ovm_do(sb_memrd_seq);

      WriteField("config_master", "cfg_control_general","CFG_ENABLE_UNIT_IDLE", 'h1);
      WriteReg("hqm_sif_csr", "prim_cdc_ctl", 'h0000_4444);
      WriteReg("hqm_sif_csr", "iosfp_cgctl",  'h0000_0110);
      #5000;
    end

    if($test$plusargs("IDLE_SB_NAK"))begin
      WriteField("config_master", "cfg_control_general","CFG_ENABLE_UNIT_IDLE", 'h1);
      WriteReg("hqm_sif_csr", "prim_cdc_ctl", 'h0000_4444);
      WriteReg("hqm_sif_csr", "iosfp_cgctl",  'h0000_0110);
      #5000;

      `ovm_do(sb_cfgrd_seq);
    
      for(int i = 0; i < 7; i++) begin  
        case (i)  
          0: #10;
          1: #400;
          2: #20;
          3: #15;
          4: #25;
          5: #10;
          6: #2;
        endcase  
        ReadReg("hqm_pf_cfg_i", "vendor_id",  SLA_FALSE, rdata);
        ReadReg("hqm_pf_cfg_i", "device_status",  SLA_FALSE, rdata);
        ReadReg("hqm_pf_cfg_i", "revision_id_class_code",  SLA_FALSE, rdata);
        ReadReg("hqm_pf_cfg_i", "cache_line_size",  SLA_FALSE, rdata);
      end
    end  

    if($test$plusargs("IDLE_SB_NAK1"))begin
      WriteField("config_master", "cfg_control_general","CFG_ENABLE_UNIT_IDLE", 'h1);
      WriteReg("hqm_sif_csr", "prim_cdc_ctl", 'h0000_4444);
      WriteReg("hqm_sif_csr", "iosfp_cgctl",  'h0000_0110);
      #5000;

      `ovm_do(sb_cfgrd_seq);
    
      for(int i = 0; i < 9; i++) begin  
        case (i)  
          0: #40;
          1: #400;
          2: #30;
          3: #20;
          4: #25;
          5: #10;
          6: #25;
          7: #75;
          8: #3;
        endcase  
        ReadReg("hqm_pf_cfg_i", "vendor_id",  SLA_FALSE, rdata);
        ReadReg("hqm_pf_cfg_i", "device_status",  SLA_FALSE, rdata);
        ReadReg("hqm_pf_cfg_i", "revision_id_class_code",  SLA_FALSE, rdata);
        ReadReg("hqm_pf_cfg_i", "cache_line_size",  SLA_FALSE, rdata);
      end
    end  
  endtask  

endclass  
   









