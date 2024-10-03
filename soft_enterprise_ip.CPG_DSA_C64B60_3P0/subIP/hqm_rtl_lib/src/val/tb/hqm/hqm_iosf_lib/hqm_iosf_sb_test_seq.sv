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
// File   : hqm_iosf_sb_test_seq.sv
// Author : rsshekha
// Description :
//
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_test_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_iosf_sb_test_seq_stim_config";

  `ovm_object_utils_begin(hqm_iosf_sb_test_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_iosf_sb_test_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hqm_iosf_sb_test_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_iosf_sb_test_seq_stim_config

class hqm_iosf_sb_test_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_test_seq,sla_sequencer)

  rand hqm_iosf_sb_test_seq_stim_config        cfg;
  static logic [2:0]       iosf_tag = 3'b000;
  rand   logic [7:0]       iosf_sai;
  rand   bit [31:0]        exp_cmpdata;
  rand   bit [31:0]        mask;
  rand   bit               do_compare;
  iosfsbm_seq::iosf_sb_seq sb_seq;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_iosf_sb_test_seq_stim_config);
  constraint deflt {
        soft iosf_sai       == 8'h03;
        soft do_compare     == 1'b0;
        soft mask           == 32'hffffffff;
        soft exp_cmpdata    ==  32'h00000000;
  }

  function new(string name = "hqm_iosf_sb_test_seq");
    super.new(name); 
    cfg = hqm_iosf_sb_test_seq_stim_config::type_id::create("hqm_iosf_sb_test_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction
  
  extern virtual task send_xaction (
                          input iosfsbm_cm::opcode_t opcode_l = OP_MRD,
                          input iosfsbm_cm::xaction_class_e xaction_class_l = NON_POSTED,
                          input bit [7:0] fid_l = 8'h0, 
                          input bit [7:0] src_l = 8'h01, 
                          input bit [7:0] dst_l = 8'h21, 
                          input bit [2:0] bar_l = 3'b010, 
                          input bit addr_len_l  = 1'b1, 
                          input bit exp_rsp_l   = 1'b1,
                          input bit en_ext_hdr  = 1'b1, 
                          input bit [1:0] exp_cplstatus_l = 2'b00, 
                          input bit [3:0] fbe_l = 4'hF, 
                          input bit [3:0] sbe_l = 4'h0,
                          input string opcode_str_l);

  extern virtual task body();
endclass : hqm_iosf_sb_test_seq

task  hqm_iosf_sb_test_seq::body();

  bit               addr_len;   
  bit               exp_rsp;
  logic[1:0]        exp_cplstatus, op_exp_cplstatus, fid_exp_cplstatus;
  bit[3:0]          fbe;
  bit[3:0]          sbe;
  bit [7:0]         fid;
  bit [2:0]         bar;
  string opcode_str = "", addr_len_str = "";
  int lp_cnt = 0;

  iosfsbm_cm::opcode_t opcode;
  iosfsbm_cm::xaction_class_e xaction_class;
  apply_stim_config_overrides(1);

  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_test_seq started \n"),OVM_LOW)
  get_pid();
  if($test$plusargs("RANDOM_FID"))begin
    for (int i = 0;i < 6;i++) begin
       case (i) 
           0: begin opcode = OP_IOWR; exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED; opcode_str = "IOWR"; addr_len_str = "ONLY_16BIT"; end 
           1: begin opcode = OP_IORD; exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED; opcode_str = "IORD"; addr_len_str = "ONLY_16BIT"; end
           2: begin opcode = OP_MRD; exp_rsp = 1; exp_cplstatus = 2'b00; xaction_class = NON_POSTED; opcode_str = "MRD"; addr_len_str = "BOTH"; end
           3: begin opcode = OP_MWR; exp_rsp = 0; exp_cplstatus = 2'b00; xaction_class = POSTED; opcode_str = "MWR"; addr_len_str = "BOTH"; end
           4: begin opcode = OP_CRRD; exp_rsp = 0; exp_cplstatus = 2'b01; xaction_class = NON_POSTED; opcode_str = "CRRD"; addr_len_str = "BOTH"; end  //vr_sbc_0178 
           5: begin opcode = OP_CRWR; exp_rsp = 0; exp_cplstatus = 2'b01; xaction_class = NON_POSTED; opcode_str = "CRWR"; addr_len_str = "BOTH"; end
       endcase    
       op_exp_cplstatus = exp_cplstatus; 
       for (int j = 0;j < 4;j++) begin
          case (j) 
              0: begin fid = $urandom_range(64,0); exp_cplstatus = fid ? 2'b01 : op_exp_cplstatus; end   
              1: begin fid = $urandom_range(128,65); exp_cplstatus = 2'b01; end 
              2: begin fid = $urandom_range(192,129); exp_cplstatus = 2'b01; end
              3: begin fid = $urandom_range(255,193); exp_cplstatus = 2'b01; end
          endcase
          fid_exp_cplstatus = exp_cplstatus; 
          for (int k = 0;k < 8;k++) begin
              bar = k;
              exp_cplstatus = ((bar == 0) || (bar == 2)) ? fid_exp_cplstatus : 2'b01; 
              lp_cnt = (addr_len_str == "ONLY_16BIT") ? 1 : 2 ;
              for (int l = lp_cnt;l > 0;l--) begin
                 addr_len = (l - 1); 
                 send_xaction(.opcode_l(opcode), .xaction_class_l(xaction_class), 
                              .fid_l(fid), .src_l(dest_pid[7:0]), .dst_l(src_pid[7:0]), .bar_l(bar), .addr_len_l(addr_len), 
                              .en_ext_hdr(1), .exp_rsp_l(exp_rsp), .exp_cplstatus_l(exp_cplstatus), 
                              .fbe_l(4'hF), .sbe_l(4'h0), .opcode_str_l(opcode_str));
              end     
          end     
       end     
    end
  end  

  if($test$plusargs("RANDOM_SBE"))begin
    for (int m = 0;m < 5;m++) begin
       case (m) 
           0: begin opcode = OP_IOWR; exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED; opcode_str = "IOWR"; end 
           1: begin opcode = OP_IORD; exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED; opcode_str = "IORD"; end
           2: begin opcode = OP_CRWR; exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED; opcode_str = "CRWR"; end
           3: begin opcode = OP_CRRD; exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED; opcode_str = "CRRD"; end
           4: begin opcode = OP_CFGWR; exp_rsp = 1;  exp_cplstatus = 2'b00; opcode_str = "CFGWR"; end
       endcase    
       for (int n = 1;n < 16;n++) begin
          sbe =  n;
          if (sbe != 4'h0) begin exp_cplstatus = 2'b01; end  
          send_xaction(.opcode_l(opcode), .xaction_class_l(xaction_class), 
                       .fid_l(8'h0), .src_l(dest_pid[7:0]), .dst_l(src_pid[7:0]), .bar_l(3'b000), .addr_len_l(1'b0), 
                       .exp_rsp_l(exp_rsp),.en_ext_hdr(1), .exp_cplstatus_l(exp_cplstatus), 
                       .fbe_l(4'hF), .sbe_l(sbe), .opcode_str_l(opcode_str));
       end
    end
  end  

  if($test$plusargs("RANDOM_FBE"))begin
   for (int o = 0;o < 4;o++) begin
      case (o) 
          0: begin opcode = OP_IOWR; exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED;  opcode_str = "IOWR"; end 
          1: begin opcode = OP_IORD; exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED;  opcode_str = "IORD"; end
          2: begin opcode = OP_CRWR; exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED;  opcode_str = "CRWR"; end
          3: begin opcode = OP_CRRD; exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED;  opcode_str = "CRRD"; end
      endcase    
      for (int p = 0;p < 16;p++) begin
         fbe =  p;
         send_xaction(.opcode_l(opcode), .xaction_class_l(xaction_class), 
                      .fid_l(8'h0), .src_l(dest_pid[7:0]), .dst_l(src_pid[7:0]), .bar_l(3'b000), .addr_len_l(1'b0), 
                      .exp_rsp_l(exp_rsp), .en_ext_hdr(1), .exp_cplstatus_l(exp_cplstatus), 
                      .fbe_l(fbe), .sbe_l(4'h0), .opcode_str_l(opcode_str));
      end
    end
  end  

  if($test$plusargs("RD_OPCODES"))begin
    for (int q = 0;q < 4;q++) begin //vr_sbc_0187
       case (q) 
           0: begin opcode = OP_CFGRD; exp_rsp = 1; exp_cplstatus = 2'b0; xaction_class = NON_POSTED;  opcode_str = "CFGRD"; end 
           1: begin opcode = OP_IORD;  exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED;  opcode_str = "IORD"; end
           2: begin opcode = OP_MRD;   exp_rsp = 1; exp_cplstatus = 2'b0; xaction_class = NON_POSTED;  opcode_str = "MRD"; end
           3: begin opcode = OP_CRRD;  exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED;  opcode_str = "CRRD"; end
       endcase    
       send_xaction(.opcode_l(opcode), .xaction_class_l(xaction_class), 
                    .fid_l(8'h0), .src_l(dest_pid[7:0]), .dst_l(src_pid[7:0]), .bar_l(3'b000), .addr_len_l(1'b0), 
                    .exp_rsp_l(exp_rsp), .en_ext_hdr(1), .exp_cplstatus_l(exp_cplstatus), 
                    .fbe_l(4'hF), .sbe_l(4'h0), .opcode_str_l(opcode_str));
    end
  end

  if($test$plusargs("FBE_ZERO_SBE_NON_ZERO"))begin
    for (int r = 0;r < 4;r++) begin //vr_sbc_0187
       case (r) 
           0: begin opcode = OP_CFGRD; exp_rsp = 1; exp_cplstatus = 2'b1; xaction_class = NON_POSTED;  opcode_str = "CFGRD"; end 
           1: begin opcode = OP_IORD;  exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED;  opcode_str = "IORD"; end
           2: begin opcode = OP_MRD;   exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED;  opcode_str = "MRD"; end
           3: begin opcode = OP_CRRD;  exp_rsp = 1; exp_cplstatus = 2'b01; xaction_class = NON_POSTED;  opcode_str = "CRRD"; end
       endcase    
       send_xaction(.opcode_l(opcode), .xaction_class_l(xaction_class), 
                    .fid_l(8'h0), .src_l(dest_pid[7:0]), .dst_l(src_pid[7:0]), .bar_l(3'b000), .addr_len_l(1'b0), 
                    .exp_rsp_l(exp_rsp), .en_ext_hdr(1), .exp_cplstatus_l(exp_cplstatus), 
                    .fbe_l(4'h0), .sbe_l(4'h1), .opcode_str_l(opcode_str));
    end
  end




  //vr_sbc_137, vr_sbc_0152

  if($test$plusargs("SRC_FE_DST_FF"))begin
    send_xaction(.opcode_l(OP_CFGWR), .xaction_class_l(NON_POSTED), 
               .fid_l(8'h0), .src_l(8'hFE), .dst_l(8'hFF), .bar_l(3'b000), .addr_len_l(1'b0), 
               .exp_rsp_l(1), .exp_cplstatus_l(0), .en_ext_hdr(1), 
               .fbe_l(4'hF), .sbe_l(4'h0), .opcode_str_l("CFGWR"));
  end  

  if($test$plusargs("SRC_FE_DST_notFF"))begin
    send_xaction(.opcode_l(OP_CFGWR), .xaction_class_l(NON_POSTED), 
               .fid_l(8'h0), .src_l(8'hFE), .dst_l(8'h20), .bar_l(3'b000), .addr_len_l(1'b0), 
               .exp_rsp_l(1), .exp_cplstatus_l(0), .en_ext_hdr(1), 
               .fbe_l(4'hF), .sbe_l(4'h0), .opcode_str_l("CFGWR"));
  end  

  if($test$plusargs("SRC_0_DST_FF"))begin
    send_xaction(.opcode_l(OP_CFGWR), .xaction_class_l(NON_POSTED), 
               .fid_l(8'h0), .src_l(8'h23), .dst_l(8'hFF), .bar_l(3'b000), .addr_len_l(1'b0), 
               .exp_rsp_l(1), .exp_cplstatus_l(0), .en_ext_hdr(1), 
               .fbe_l(4'hF), .sbe_l(4'h0), .opcode_str_l("CFGWR"));
  end  

  //vr_sbc_0190
  if($test$plusargs("SEND_DW_3"))begin
    send_xaction(.opcode_l(OP_CRWR), .xaction_class_l(NON_POSTED), 
                 .fid_l(8'h0), .src_l(dest_pid[7:0]), .dst_l(src_pid[7:0]), .bar_l(3'b000), .addr_len_l(1'b0), 
                 .exp_rsp_l(1), .exp_cplstatus_l(1), .en_ext_hdr(0), 
                 .fbe_l(4'hF), .sbe_l(4'h0), .opcode_str_l("CRWR"));
    
    send_xaction(.opcode_l(OP_MWR), .xaction_class_l(NON_POSTED), 
                 .fid_l(8'h0), .src_l(dest_pid[7:0]), .dst_l(src_pid[7:0]), .bar_l(3'b000), .addr_len_l(1'b0), 
                 .exp_rsp_l(1), .exp_cplstatus_l(0), .en_ext_hdr(0), 
                 .fbe_l(4'hF), .sbe_l(4'h0), .opcode_str_l("MWR"));
    
    send_xaction(.opcode_l(OP_IOWR), .xaction_class_l(NON_POSTED), 
                 .fid_l(8'h0), .src_l(dest_pid[7:0]), .dst_l(src_pid[7:0]), .bar_l(3'b000), .addr_len_l(1'b0), 
                 .exp_rsp_l(1), .exp_cplstatus_l(1), .en_ext_hdr(0), 
                 .fbe_l(4'hF), .sbe_l(4'h0), .opcode_str_l("IOWR"));
  end  

  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_test_seq ended \n"),OVM_LOW)

endtask : body

task hqm_iosf_sb_test_seq::send_xaction(
                                       input iosfsbm_cm::opcode_t opcode_l = OP_MRD, 
                                       input iosfsbm_cm::xaction_class_e xaction_class_l = NON_POSTED,
                                       input bit [7:0] fid_l = 8'h0, 
                                       input bit [7:0] src_l = 8'h01, 
                                       input bit [7:0] dst_l = 8'h21, 
                                       input bit [2:0] bar_l = 3'b010, 
                                       input bit addr_len_l = 1'b1, 
                                       input bit exp_rsp_l = 1'b1,
                                       input bit en_ext_hdr = 1'b1,
                                       input bit [1:0] exp_cplstatus_l = 2'b00, 
                                       input bit [3:0] fbe_l = 4'hF, 
                                       input bit [3:0] sbe_l = 4'h0,
                                       input string opcode_str_l);

  bit [63:0]               addr;
  bit [63:0]               wdata = 64'hFFFF_FFFF_FFFF_FFFF;
  bit [31:0]               rdata;
  string                   log = "", ref_name_file = "", ref_name_reg = "";
  int vf = 0; 

  iosfsbm_cm::flit_t            iosf_addr[];
  flit_t                        my_ext_headers[];
  iosfsbm_cm::flit_t            iosf_data[];
  
  `ovm_info(get_full_name(),$sformatf("\n task send_xaction started \n"),OVM_LOW)

  if (((opcode_l == OP_MWR) || (opcode_l == OP_MRD)) && (addr_len_l == 1'b1)) begin
      if (bar_l != 3'h0) begin
          addr = get_reg_addr("hqm_sif_csr", "ibcpl_hdr_fifo_ctl", "sideband");
      end 
      else begin
          ref_name_file="hqm_system_csr"; //PG
          ref_name_reg="aw_smon_timer[0]"; //PG
          addr = get_reg_addr(ref_name_file, ref_name_reg,  "sideband");
      end
     iosf_addr          = new[6];
     iosf_addr[0]       = addr[7:0];
     iosf_addr[1]       = addr[15:8];
     iosf_addr[2]       = addr[23:16];
     iosf_addr[3]       = addr[31:24];
     iosf_addr[4]       = addr[39:32];
     iosf_addr[5]       = addr[47:40];
  end
  else if (((opcode_l == OP_MWR) || (opcode_l == OP_MRD)) && (addr_len_l == 1'b0)) begin 
     if (bar_l != 3'h0) begin
        addr = get_reg_addr("hqm_sif_csr", "sif_alarm_err", "sideband");
     end 
     else begin
        ref_name_file="hqm_system_csr"; //PG
        ref_name_reg="aw_smon_timer[0]"; //PG
        addr = get_reg_addr(ref_name_file, ref_name_reg,  "sideband");
     end 
     iosf_addr          = new[2];
     iosf_addr[0]       = addr[7:0];
     iosf_addr[1]       = addr[15:8];
  end
  else begin 
     if(addr_len_l == 1'b1) begin
       addr = get_reg_addr("hqm_pf_cfg_i", "func_bar_l",  "sideband");
       iosf_addr          = new[6];
       iosf_addr[0]       = addr[7:0];
       iosf_addr[1]       = addr[15:8];
       iosf_addr[2]       = addr[23:16];
       iosf_addr[3]       = addr[31:24];
       iosf_addr[4]       = addr[39:32];
       iosf_addr[5]       = addr[47:40];
     end else begin
       addr = get_reg_addr("hqm_pf_cfg_i", "func_bar_l",  "sideband");
       iosf_addr          = new[2];
       iosf_addr[0]       = addr[7:0];
       iosf_addr[1]       = addr[15:8];
     end 
  end

  if ((opcode_l == OP_MWR) || (opcode_l == OP_IOWR) || (opcode_l == OP_CRWR) || (opcode_l == OP_CFGWR)) begin 
    if (sbe_l == 4'h0) begin 
      iosf_data = new[4];
      iosf_data[0] = wdata[7:0];
      iosf_data[1] = wdata[15:8];
      iosf_data[2] = wdata[23:16];
      iosf_data[3] = wdata[31:24];
    end
    else begin 
      iosf_data = new[8];
      iosf_data[0] = wdata[7:0];
      iosf_data[1] = wdata[15:8];
      iosf_data[2] = wdata[23:16];
      iosf_data[3] = wdata[31:24];
      iosf_data[4] = wdata[39:32];
      iosf_data[5] = wdata[47:40];
      iosf_data[6] = wdata[55:48];
      iosf_data[7] = wdata[63:56];
    end
  end

  if(en_ext_hdr) begin
    my_ext_headers      = new[4];
    my_ext_headers[0]   = 8'h00;
    my_ext_headers[1]   = iosf_sai;                // Set SAI
    my_ext_headers[2]   = 8'h00;
    my_ext_headers[3]   = {4'h0,$urandom_range(0,15)};
  end

  log = $psprintf("opcode = %h, opcode_str = %s, xaction_class = %s, fid = 0x%h, bar = 0x%h, addr_len = %b, exp_rsp = %b, exp_cplstatus = %b, fbe = %b, sbe = %b, addr = 0x%h, wdata = 0x%h",opcode_l,opcode_str_l,xaction_class_l,fid_l,bar_l,addr_len_l,exp_rsp_l,exp_cplstatus_l,fbe_l,sbe_l, addr, wdata);
  `ovm_info(get_full_name() ,$psprintf("Sending transaction %s",log),OVM_LOW)
  `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
    { addr_i.size         == iosf_addr.size;
      foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
      eh_i                == en_ext_hdr;
      ext_headers_i.size  == my_ext_headers.size();
      foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
      data_i.size         == iosf_data.size;
      foreach (data_i[j]) data_i[j] == iosf_data[j];
      xaction_class_i     == xaction_class_l;
      src_pid_i           == src_l;
      dest_pid_i          == dst_l;
      local_src_pid_i       == dest_pid[15:8];
      local_dest_pid_i      == src_pid[15:8];
      opcode_i            == opcode_l;
      tag_i               == iosf_tag;
      fbe_i               == fbe_l;
      sbe_i               == sbe_l;
      fid_i               == fid_l;
      bar_i               == bar_l;
      exp_rsp_i           == exp_rsp_l;
      compare_completion_i == 0;
    })

  if (exp_rsp_l) begin 
      rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
      rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
      rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
      rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];

      if(sb_seq.rx_compl_xaction.rsp != exp_cplstatus_l) 
         `ovm_error(get_full_name(), $psprintf("Cpl status check FAILED for transaction %s", log))
      else 
         `ovm_info(get_full_name(),  $psprintf("Cpl status check PASSED for transaction %s", log),OVM_LOW)

      if(sb_seq.rx_compl_xaction.rsp == 0) begin
         if ((do_compare) && (exp_cplstatus_l == 2'b00)) begin
           if ((rdata & mask) != (exp_cmpdata & mask)) begin
             `ovm_error(get_full_name() ,$psprintf("read data (0x%08x) does not match expected data (0x%08x) for transaction %s",rdata,exp_cmpdata,log))
           end else begin
             `ovm_info(get_full_name() ,$psprintf("read data (0x%08x) matches expected value (0x%08x) for transaction %s",rdata,exp_cmpdata,log),OVM_LOW)
           end
         end
      end
  end

  iosf_tag++;
  `ovm_info(get_full_name(),$sformatf("\n task send_xaction ended \n"),OVM_LOW)
endtask : send_xaction 

