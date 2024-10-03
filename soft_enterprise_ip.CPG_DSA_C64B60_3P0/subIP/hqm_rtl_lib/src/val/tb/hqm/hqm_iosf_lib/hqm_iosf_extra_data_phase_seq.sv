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
// File   : hqm_iosf_extra_data_phase_seq.sv
// Author :araghuw 
// Description :
// This sequence is used after we have sent unsupported 
// type of transactions. To check HQM doesn't hang or lock,   
// we intend to send some valid transactions after unsupported
// transactions are sent.
// This sequence is called after USER_DATA_PHASE is complete 
// -----------------------------------------------------------------------------

`ifndef HQM_IOSF_EXTRA_DATA_SEQ_SV
`define HQM_IOSF_EXTRA_DATA_SEQ_SV

import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_extra_data_phase_seq extends hqm_iosf_base_seq;

  `ovm_sequence_utils(hqm_iosf_extra_data_phase_seq, sla_sequencer)

  string        file_name = "";
  integer       fd;
  integer       timeoutval;
  static logic [2:0]        iosf_tag = 0;
  iosfsbm_cm::flit_t        iosf_addr[];
  iosfsbm_cm::flit_t        iosf_data[];
  flit_t                    my_ext_headers[];
  bit [15:0]               src_pid;
  bit [15:0]               dest_pid;

  iosfsbm_seq::iosf_sb_seq                    sb_seq; 

  function new(string name = "hqm_iosf_extra_data_phase_seq");
    super.new(name); 
    my_ext_headers      = new[4];
    my_ext_headers[0]   = 8'h00;
    my_ext_headers[1]   = 8'h03;     
    my_ext_headers[2]   = 8'h00;
    my_ext_headers[3]   = 8'h00;

  endfunction

  virtual task body();
    bit [63:0]  address; 
    bit [31:0]  read_data;
    bit [31:0]  write_data;
    bit [1:0]   cplstatus;
    bit [2:0]   bar; 

    repeat (5) begin
   
      address      = cfg_addr0; 
      write_data   = 'hAA; 
      bar     = 3'b0; 
      m_sequencer.get_config_int("strap_hqm_gpsb_srcid", src_pid);
      m_sequencer.get_config_int("hqm_gpsb_dstid", dest_pid);
      `ovm_info(get_full_name(),$sformatf("src_pid %0h, dest_pid %0h", src_pid, dest_pid),OVM_LOW)

      send_command_iosf(CfgWr, address, write_data, iosf_tag, bar);  
      send_command_iosf(CfgRd, address, write_data, iosf_tag, bar);  
      
      read_data[7:0]    = sb_seq.rx_compl_xaction.data[0];
      read_data[15:8]   = sb_seq.rx_compl_xaction.data[1];
      read_data[23:16]  = sb_seq.rx_compl_xaction.data[2];
      read_data[31:24]  = sb_seq.rx_compl_xaction.data[3];
      cplstatus         = sb_seq.rx_compl_xaction.rsp;

      if(cplstatus == 2'b00) begin //Successful Completion
        ovm_report_info(get_full_name(), $psprintf("CfgRd Address=0x%x  Data=0x%08x",address,read_data), OVM_LOW);
      end else begin
        ovm_report_error(get_full_name(), $psprintf("Cfgrd0 Address=0x%x  Data=0x%08x error completion (0x%x)",address,read_data,cplstatus), OVM_LOW);
      end    
                 
      if(read_data != write_data) begin
        ovm_report_error(get_full_name(), $psprintf("Data comparison failed. The data written (0x%x) and read (0x%x) back from same register mismatched", write_data, read_data), OVM_LOW);
      end else begin
        ovm_report_info(get_full_name(), $psprintf("Data successfully compared. The data written (0x%x) and read (0x%x) back from same register matched", write_data, read_data), OVM_LOW);
      end

      mem_addr0[63:32] = 0;
      address = mem_addr0; 

      write_data = 'h1A; 
      bar     = 3'b10; 

      send_command_iosf(MemWr, address, write_data, iosf_tag, bar);  
      send_command_iosf(MemRd, address, write_data, iosf_tag, bar);  

      read_data[7:0]    = sb_seq.rx_compl_xaction.data[0];
      read_data[15:8]   = sb_seq.rx_compl_xaction.data[1];
      read_data[23:16]  = sb_seq.rx_compl_xaction.data[2];
      read_data[31:24]  = sb_seq.rx_compl_xaction.data[3];
      cplstatus         = sb_seq.rx_compl_xaction.rsp;

      if(cplstatus == 2'b00) begin //Successful Completion
        ovm_report_info(get_full_name(), $psprintf("MemRd Address=0x%x  Data=0x%08x",address,read_data), OVM_LOW);
      end else begin
        ovm_report_error(get_full_name(), $psprintf("MemRd Address=0x%x  Data=0x%08x error completion (0x%x)",address,read_data,cplstatus), OVM_LOW);
      end    
                 
      if(read_data != write_data) begin
        ovm_report_error(get_full_name(), $psprintf("Data comparison failed. The data written (0x%x) and read (0x%x) back from same register mismatched", write_data, read_data), OVM_LOW);
      end else begin
        ovm_report_info(get_full_name(), $psprintf("Data successfully compared. The data written (0x%x) and read (0x%x) back from same register matched", write_data, read_data), OVM_LOW);
      end

    end

  endtask

  virtual task send_command_iosf(input trans_type_t cmd_type, input bit [63:0] addr, input bit [63:0] wdata, input bit [2:0] iosf_tag, input bit [2:0] bar, input bit [7:0] fid = 0);
  
    if(cmd_type == MemWr || cmd_type == MemRd) begin 
      iosf_addr     = new[6];
      iosf_addr[0]  = addr[7:0];
      iosf_addr[1]  = addr[15:8];
      iosf_addr[2]  = addr[23:16];
      iosf_addr[3]  = addr[31:24];
      iosf_addr[4]  = addr[39:32];
      iosf_addr[5]  = addr[47:40];
    end else begin
      iosf_addr     = new[2];
      iosf_addr[0]  = addr[7:0];
      iosf_addr[1]  = addr[15:8];
    end
  
    if(cmd_type == CfgWr || cmd_type == MemWr) begin 
      iosf_data = new[4];
      iosf_data[0] = wdata[7:0];
      iosf_data[1] = wdata[15:8];
      iosf_data[2] = wdata[23:16];
      iosf_data[3] = wdata[31:24];
    end 
  
  
    `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
      { addr_i.size         == iosf_addr.size;
        foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
        eh_i                == 1'b1;
        ext_headers_i.size  == 4;
        foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
        xaction_class_i     == 1;
        src_pid_i           == dest_pid[7:0];
        dest_pid_i          == src_pid[7:0];
        local_src_pid_i       == dest_pid[15:8];
        local_dest_pid_i      == src_pid[15:8];
        opcode_i            == cmd_type;
        tag_i               == iosf_tag;
        fbe_i               == 4'hf;
        sbe_i               == 4'h0;
        fid_i               == 8'h0;
        bar_i               == bar;
        exp_rsp_i           == 'h1;
        compare_completion_i == 0;
        (cmd_type == CfgWr || cmd_type == MemWr) -> 
        {data_i.size         == iosf_data.size;
        foreach (data_i[j]) data_i[j] == iosf_data[j];}
    })
  
    if(sb_seq.rx_compl_xaction.tag == iosf_tag) begin //Tag check
      ovm_report_info(get_full_name(), $psprintf("Tag check successful for %s command and Address=0x%x ", cmd_type, addr), OVM_LOW);
      end else begin
        ovm_report_error(get_full_name(), $psprintf("Tag check failed for command %s and Address=0x%x. Expected tag is 0x%x, Actual tag is 0x%0x",cmd_type, addr,iosf_tag, sb_seq.rx_compl_xaction.tag), OVM_LOW);
    end 
  
    if (sb_seq.rx_compl_xaction.rsp == 2'b00) begin //Successful Completion
       ovm_report_info(get_full_name(), $psprintf("Completion received successfully for Address=0x%x ",addr), OVM_LOW);
    end else begin
       ovm_report_error(get_full_name(), $psprintf("Unsuccessful completion for Address=0x%x ",addr), OVM_LOW);
    end 
    iosf_tag++;
  endtask





endclass

`endif
