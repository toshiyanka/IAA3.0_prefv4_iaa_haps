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
// File   : hqm_iosf_sb_cfg_rd_seq.sv
// Author : rsshekha
// Description :
//
// -----------------------------------------------------------------------------

import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_cfg_rd_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_iosf_sb_cfg_rd_seq,sla_sequencer)

  static logic [2:0]       iosf_tag = 3'b000;
  rand   logic [7:0]       iosf_sai;
  rand bit [63:0]          addr;
  bit [31:0]               rdata;
  rand int                 exp_rsp ;
  rand bit [7:0]           fid ;
  rand bit [2:0]           bar ;
  rand logic[1:0]          exp_cplstatus;
  rand bit [31:0]          exp_cmpdata;
  rand bit [31:0]          mask;
  rand bit                 do_compare;
  rand bit                 en_ext_hdr;
  bit [15:0]               src_pid;
  bit [15:0]               dest_pid;

  constraint deflt {
        soft iosf_sai       == 8'h03;
        soft fid            == 8'h00;
        soft bar            == 3'b_000;
        soft exp_rsp        == 1;
        soft exp_cplstatus  == 2'b00;
        soft do_compare     == 1'b0;
        soft en_ext_hdr     == 1'b1;
        soft mask           == 32'hffffffff;
        soft exp_cmpdata    ==  32'h00000000;
  }

  function new(string name = "hqm_iosf_sb_cfg_rd_seq");
    super.new(name); 
  endfunction

  
  virtual task body();
    iosfsbm_cm::flit_t            iosf_addr[];
    flit_t                        my_ext_headers[];
    iosfsbm_seq::iosf_sb_seq      sb_seq;
    string                        log = "";

    `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_cfg_rd_seq started \n"),OVM_LOW)
    m_sequencer.get_config_int("strap_hqm_gpsb_srcid", src_pid);
    m_sequencer.get_config_int("hqm_gpsb_dstid", dest_pid);
    `ovm_info(get_full_name(),$sformatf("src_pid %0h, dest_pid %0h", src_pid, dest_pid),OVM_LOW)
     
    iosf_addr       = new[2];
    iosf_addr[0]    = addr[7:0];
    iosf_addr[1]    = addr[15:8];
    
    if(en_ext_hdr) begin
      my_ext_headers      = new[4];
      my_ext_headers[0]   = 8'h00;
      my_ext_headers[1]   = iosf_sai;                // Set SAI
      my_ext_headers[2]   = 8'h00;
      my_ext_headers[3]   = {4'h0,$urandom_range(0,15)};
      //my_ext_headers[3]   = 8'h00;
    end
    
    `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
      { addr_i.size         == iosf_addr.size;
        foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
        eh_i                == en_ext_hdr;
        ext_headers_i.size  == my_ext_headers.size();
        foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
        xaction_class_i     == NON_POSTED;
        src_pid_i           == dest_pid[7:0];
        dest_pid_i          == src_pid[7:0];
        local_src_pid_i     == dest_pid[15:8];
        local_dest_pid_i    == src_pid[15:8];
        opcode_i            == OP_CFGRD;
        tag_i               == iosf_tag;
        fbe_i               == 4'hf;
        sbe_i               == 4'h0;
        fid_i               == fid ;
        bar_i               == bar ;
        exp_rsp_i           == exp_rsp;
        compare_completion_i == 0;
      })

    if (exp_rsp) begin 
       rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
       rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
       rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
       rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
       
       log = $psprintf("Address=0x%0x exp_cplstatus(0x%0x), received_cplstatus(0x%0x)",addr,exp_cplstatus,sb_seq.rx_compl_xaction.rsp);

       if(sb_seq.rx_compl_xaction.rsp != exp_cplstatus) 
          ovm_report_error(get_full_name(), $psprintf("CfgRd0 Cpl status check FAILED %s", log), OVM_LOW);
       else 
          ovm_report_info(get_full_name(),  $psprintf("CfgRd0 Cpl status check PASSED %s", log), OVM_LOW);

       if(sb_seq.rx_compl_xaction.rsp == 0) begin
          if (do_compare) begin
            if ((rdata & mask) != (exp_cmpdata & mask)) begin
              `ovm_error("hqm_iosf_sb_cfg_rd_seq",$psprintf("address 0x%0x mask 0x%0x read data (0x%08x) does not match expected data (0x%08x)",addr,mask,rdata,exp_cmpdata))
            end else begin
              `ovm_info("hqm_iosf_sb_cfg_rd_seq",$psprintf("address 0x%0x mask 0x%0x read data (0x%08x) matches expected value (0x%08x)",addr,mask,rdata,exp_cmpdata),OVM_LOW)
            end
          end
       end
    end 

    iosf_tag++;
 
    `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_cfg_rd_seq ended \n"),OVM_LOW);

  endtask : body
endclass : hqm_iosf_sb_cfg_rd_seq
