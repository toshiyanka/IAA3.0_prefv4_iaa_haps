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

`ifndef HQM_SB_BASE_SEQ__SV
`define HQM_SB_BASE_SEQ__SV

// -----------------------------------------------------------------------------
// File        : hqm_sb_base_seq.sv
// Author      : Neeraj Shete
// Description :
//
// -----------------------------------------------------------------------------


class hqm_sb_base_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_sb_base_seq,sla_sequencer)

  sla_ral_env           ral;
  string                ral_tb_env_hier = "*.";    // -- Useful with multiple ral instances

  function new(string name = "hqm_sb_base_seq");
    super.new(name); 

    // -- Get handles to ral env and correspondignly to register file handles -- //
    `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

  endfunction

  virtual task body();
  endtask : body

  virtual task send_cfg_sb_msg(
         bit [63:0]   addr            
       , bit          rd            = 1'b_1
       , logic [7:0]  iosf_sai      = 'h_3
       , logic [7:0]  fid           = 8'h_0
       , logic [2:0]  bar           = 3'b_000
       , int          exp_rsp       = 'h_1
       , logic[1:0]   exp_cplstatus = 2'b_00
       , bit [31:0]   data          = 32'h_0
       , bit [31:0]   mask          = 32'h_ffff_ffff
       , bit          do_compare    = 1'b_0
       , bit          en_ext_hdr    = 1'b_1 
       , bit          block         = 1'b_0 

     );
    fork 
      automatic hqm_iosf_sb_cfg_rd_seq      cfgrd_msg;
      automatic hqm_iosf_sb_cfg_wr_seq      cfgwr_msg;
      automatic bit [63:0]  i_addr          = addr         ;
      automatic bit         i_rd            = rd           ; 
      automatic logic [7:0] i_iosf_sai      = iosf_sai     ; 
      automatic logic [7:0] i_fid           = fid          ; 
      automatic logic [2:0] i_bar           = bar          ; 
      automatic int         i_exp_rsp       = exp_rsp      ; 
      automatic logic[1:0]  i_exp_cplstatus = exp_cplstatus; 
      automatic bit [31:0]  i_data          = data         ; 
      automatic bit [31:0]  i_mask          = mask         ; 
      automatic bit         i_do_compare    = do_compare   ; 
      automatic bit         i_en_ext_hdr    = en_ext_hdr   ; 
      automatic bit         i_block         = block        ; 
      automatic bit         loc_done        = 0            ; 

    begin 

      `ovm_info(get_full_name(),$sformatf("Starting send_cfg_sb_msg with: rd(%0d), addr=(0x%0x), fid(0x%0x), bar(0x%0x), exp_rsp(%0d), cpl_stat(0x%0x), compare(0x%0x), en_ext_hdr(0x%0x)", i_rd, i_addr, i_fid, i_bar, i_exp_rsp, i_exp_cplstatus, i_do_compare, i_en_ext_hdr),OVM_LOW)

      if(i_rd == 1) begin 
         `ovm_do_with(cfgrd_msg, {addr == i_addr; iosf_sai == i_iosf_sai; fid == i_fid; bar == i_bar; exp_rsp == i_exp_rsp; exp_cplstatus == i_exp_cplstatus; exp_cmpdata == i_data; mask == i_mask; do_compare == i_do_compare; en_ext_hdr == i_en_ext_hdr;}) 
      end
      else        begin 
         `ovm_do_with(cfgwr_msg, {addr == i_addr; iosf_sai == i_iosf_sai; fid == i_fid; bar == i_bar; wdata == i_data; exp_rsp == i_exp_rsp; exp_cplstatus == i_exp_cplstatus; en_ext_hdr == i_en_ext_hdr;}) 
      end
   
      loc_done = 1;

    end 

    begin 

      `ovm_info(get_full_name(),$sformatf("--- Start wait(loc_done==1) in send_cfg_sb_msg with: addr=(0x%0x), fid(0x%0x), bar(0x%0x), exp_rsp(%0d), cpl_stat(0x%0x), compare(0x%0x), en_ext_hdr(0x%0x)", i_addr, i_fid, i_bar, i_exp_rsp, i_exp_cplstatus, i_do_compare, i_en_ext_hdr),OVM_LOW)
      if(i_block) wait(loc_done == 1);
      `ovm_info(get_full_name(),$sformatf("--- Done  wait(loc_done==1) in send_cfg_sb_msg with: rd(%0d), addr=(0x%0x), fid(0x%0x), bar(0x%0x), exp_rsp(%0d), cpl_stat(0x%0x), compare(0x%0x), en_ext_hdr(0x%0x)", i_rd, i_addr, i_fid, i_bar, i_exp_rsp, i_exp_cplstatus, i_do_compare, i_en_ext_hdr),OVM_LOW)

    end 

    join_any

  endtask : send_cfg_sb_msg

  virtual task send_mem_sb_msg(
         bit [63:0]   addr            
       , bit          rd            = 1'b_1
       , logic [7:0]  iosf_sai      = 'h_3
       , logic [7:0]  iosf_sai2     = 'h_0            //-- DEVICE_UNTRUSTED_SAI --//
       , logic [7:0]  fid           = 8'h_0
       , logic [2:0]  bar           = 3'b_000
       , int          exp_rsp       = 'h_1
       , logic[1:0]   exp_cplstatus = 2'b_00
       , bit [31:0]   data          = 32'h_0
       , bit [3:0]    sbe           = 4'h0 
       , bit [31:0]   data2         = 32'h_0
       , bit [31:0]   mask          = 32'h_ffff_ffff
       , bit          do_compare    = 1'b_0
       , bit          en_ext_hdr    = 1'b_1 
       , int          num_ext_hdr   = 1 
       , bit [6:0]    hdrid1        = 0 
       , bit [6:0]    hdrid2        = 0 
       , iosfsbm_cm::xaction_class_e xaction_class = NON_POSTED
       , bit block                                 = 0
     );
    
    process job;

    fork 
      begin
        automatic hqm_iosf_sb_mem_rd_seq      mrd_msg;
        automatic hqm_iosf_sb_mem_wr_seq      mwr_msg;
        automatic bit [63:0]                  i_addr          = addr         ;
        automatic bit                         i_rd            = rd           ; 
        automatic logic [7:0]                 i_iosf_sai      = iosf_sai     ; 
        automatic logic [7:0]                 i_iosf_sai2     = iosf_sai2    ; 
        automatic logic [7:0]                 i_fid           = fid          ; 
        automatic logic [2:0]                 i_bar           = bar          ; 
        automatic int                         i_exp_rsp       = exp_rsp      ; 
        automatic logic[1:0]                  i_exp_cplstatus = exp_cplstatus; 
        automatic bit [31:0]                  i_data          = data         ; 
        automatic bit [3:0]                   i_sbe           = sbe          ; 
        automatic bit [31:0]                  i_data2         = data2        ; 
        automatic bit [31:0]                  i_mask          = mask         ; 
        automatic bit                         i_do_compare    = do_compare   ; 
        automatic bit                         i_en_ext_hdr    = en_ext_hdr   ; 
        automatic int                         i_num_ext_hdr   = num_ext_hdr  ; 
        automatic bit [6:0]                   i_hdrid1        = hdrid1       ; 
        automatic bit [6:0]                   i_hdrid2        = hdrid2       ; 
        automatic iosfsbm_cm::xaction_class_e i_xaction_class = xaction_class;

        `ovm_info(get_full_name(),$sformatf("Starting send_mem_sb_msg with: "),OVM_LOW)

        if(rd == 1) begin 
           `ovm_do_with(mrd_msg, {addr == i_addr; iosf_sai == i_iosf_sai; iosf_sai2 == i_iosf_sai2; fid == i_fid; bar == i_bar; exp_rsp == i_exp_rsp; exp_cplstatus == i_exp_cplstatus; exp_cmpdata == i_data; mask == i_mask; do_compare == i_do_compare; en_ext_hdr == i_en_ext_hdr; num_ext_hdr == i_num_ext_hdr; hdrid1 == i_hdrid1; hdrid2 == i_hdrid2; }) 
        end
        else        begin 
           `ovm_do_with(mwr_msg, {addr == i_addr; iosf_sai == i_iosf_sai; iosf_sai2 == i_iosf_sai2; fid == i_fid; bar == i_bar; wdata == i_data; wdata2 == i_data2; exp_rsp == i_exp_rsp; exp_cplstatus == i_exp_cplstatus; en_ext_hdr == i_en_ext_hdr; num_ext_hdr == i_num_ext_hdr; hdrid1 == i_hdrid1; hdrid2 == i_hdrid2; sbe == i_sbe; xaction_class == i_xaction_class; })
        end

        job = process::self();
      end 
    join_none
    //-- disable fork;
    if(block == 1) begin 
      wait(job != null);
      job.await();
    end

  endtask : send_mem_sb_msg

  function sla_ral_data_t get_sb_addr(string reg_name, string file_name);
     sla_ral_reg my_reg ;
     get_sb_addr = 'h_0;
     my_reg   = ral.find_reg_by_file_name(reg_name, {ral_tb_env_hier, file_name});
     if(my_reg != null) begin get_sb_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), my_reg); end
     else               `ovm_error(get_full_name(), $psprintf("Null reg handle received for %s.%s", file_name, reg_name))
  endfunction: get_sb_addr
 
  function bit[2:0] get_sb_bar(string reg_name, string file_name);
     sla_ral_reg my_reg ;
     get_sb_bar = 'h_0;
     my_reg   = ral.find_reg_by_file_name(reg_name, {ral_tb_env_hier, file_name});
     if(my_reg != null) begin get_sb_bar = my_reg.get_bar("MEM-SB"); end
     else               `ovm_error(get_full_name(), $psprintf("Null reg handle received for %s.%s", file_name, reg_name))
  endfunction: get_sb_bar
 
  function bit[7:0] get_sb_fid(string reg_name, string file_name);
     sla_ral_reg my_reg ;
     get_sb_fid = 'h_0;
     my_reg   = ral.find_reg_by_file_name(reg_name, {ral_tb_env_hier, file_name});
     if(my_reg != null) begin 
        case(my_reg.get_space())
           "CFG"   : get_sb_fid = my_reg.get_fid("CFG-SB"); 
           "MEM"   : get_sb_fid = my_reg.get_fid("MEM-SB"); 
           default : `ovm_error(get_full_name(), $psprintf("Register %s.%s exists in unknown space !!!", file_name, reg_name)) 
        endcase
     end else           begin 
           `ovm_error(get_full_name(), $psprintf("Null reg handle received for %s.%s", file_name, reg_name))
     end
  endfunction: get_sb_fid

  task wait_ns_clk(int ticks=10);
   repeat(ticks) begin @(sla_tb_env::sys_clk_r); end
  endtask

endclass : hqm_sb_base_seq

`endif

