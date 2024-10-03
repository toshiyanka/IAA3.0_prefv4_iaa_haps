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
// File   : hqm_iosf_sb_cfg_wr_seq.sv
// Author : rsshekha
// Description :
//
// -----------------------------------------------------------------------------

import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_cfg_wr_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_iosf_sb_cfg_wr_seq,sla_sequencer)

  static logic [2:0]       iosf_tag = 3'b000;
  rand   logic [7:0]       iosf_sai;
  rand bit [31:0]          wdata;
  rand bit [63:0]          addr;
  rand int                 exp_rsp ;
  rand bit [7:0]           fid ;
  rand logic[1:0]          exp_cplstatus;
  rand bit                 en_ext_hdr;
  rand bit                 en_parity_err;
  bit [15:0]               src_pid;
  bit [15:0]               dest_pid;

  constraint deflt {
        soft iosf_sai == 8'h03;
        soft fid      == 8'h00;
        soft exp_rsp == 1;
        soft exp_cplstatus == 2'b00;
        soft en_ext_hdr     == 1'b1;
        soft wdata == 32'h00000000;
        soft en_parity_err == 1'b0;
  }

  function new(string name = "hqm_iosf_sb_cfg_wr_seq");
    super.new(name); 
  endfunction

  
  virtual task body();
    iosfsbm_cm::flit_t           iosf_addr[];
    iosfsbm_cm::flit_t           iosf_data[];
    flit_t                       my_ext_headers[];
    iosfsbm_seq::iosf_sb_seq     sb_seq;

    m_sequencer.get_config_int("strap_hqm_gpsb_srcid", src_pid);
    m_sequencer.get_config_int("hqm_gpsb_dstid", dest_pid);
    `ovm_info(get_full_name(),$sformatf("src_pid %0h, dest_pid %0h", src_pid, dest_pid),OVM_LOW)
    `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_cfg_wr_seq started \n"),OVM_LOW)
    
    iosf_addr= new[2];
    iosf_addr[0]       = addr[7:0];
    iosf_addr[1]       = addr[15:8];

    if(en_ext_hdr) begin
      my_ext_headers      = new[4];
      my_ext_headers[0]   = 8'h00;
      my_ext_headers[1]   = iosf_sai;                // Set SAI
      my_ext_headers[2]   = 8'h00;
      my_ext_headers[3]   = {4'h0,$urandom_range(0,15)};
      //my_ext_headers[3]   = 8'h00;
    end

    iosf_data = new[4];
    iosf_data[0] = wdata[7:0];
    iosf_data[1] = wdata[15:8];
    iosf_data[2] = wdata[23:16];
    iosf_data[3] = wdata[31:24];

    `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
      { addr_i.size         == iosf_addr.size;
        foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
        eh_i                == en_ext_hdr;
        ext_headers_i.size  == my_ext_headers.size();
        foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
        data_i.size         == iosf_data.size;
        foreach (data_i[j]) data_i[j] == iosf_data[j];
        xaction_class_i     == NON_POSTED;
        src_pid_i           == dest_pid[7:0];
        dest_pid_i          == src_pid[7:0];
        local_src_pid_i     == dest_pid[15:8];
        local_dest_pid_i    == src_pid[15:8];
        opcode_i            == OP_CFGWR;
        tag_i               == iosf_tag;
        fbe_i               == 4'hf;
        sbe_i               == 4'h0;
        fid_i               == fid;
        bar_i               == 3'b000;
        exp_rsp_i           == exp_rsp;
        parity_err_i        == en_parity_err; //enable parity error injection
        compare_completion_i == 0;
      })

    if (exp_rsp) begin 
       if (sb_seq.rx_compl_xaction.rsp != exp_cplstatus) 
          ovm_report_error(get_full_name(), $psprintf("Cfgwr0 Address=0x%x  Data=0x%08x error completion (0x%x)",addr,wdata,exp_cplstatus), OVM_LOW);
       else 
          ovm_report_info(get_full_name(), $psprintf("Cfgwr0 Address=0x%x  Data=0x%08x",addr,wdata), OVM_LOW);
    end

    iosf_tag++;
    `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_cfg_wr_seq ended \n"),OVM_LOW)

  endtask : body
endclass : hqm_iosf_sb_cfg_wr_seq
