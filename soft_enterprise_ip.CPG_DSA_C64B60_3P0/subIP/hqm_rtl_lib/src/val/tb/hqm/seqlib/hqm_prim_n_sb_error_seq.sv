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

`ifndef HQM_PRIM_SB_ERROR_SEQ__SV
`define HQM_PRIM_SB_ERROR_SEQ__SV

// -----------------------------------------------------------------------------
// File        : hqm_prim_n_sb_error_seq.sv
// Author      : Neeraj Shete
// Description :
//
// -----------------------------------------------------------------------------


class hqm_prim_n_sb_error_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_prim_n_sb_error_seq,sla_sequencer)
   
  string mode = "";
  bit [15:0]               src_pid;
  bit [15:0]               dest_pid;

  function new(string name = "hqm_prim_n_sb_error_seq");
    super.new(name); 
    if(!$value$plusargs("HQM_PRIM_SB_ERROR_MODE=%s",mode)) begin mode = "primary_only"; end 
  endfunction

  virtual task body();
    pf_cfg_regs.FUNC_BAR_U.write(status,32'h_0000_0000,primary_id, .sai(legal_sai));
    pf_cfg_regs.FUNC_BAR_L.write(status,32'h_0000_0000,primary_id, .sai(legal_sai));
    pf_cfg_regs.CSR_BAR_U.write(status,32'h_0000_0002,primary_id, .sai(legal_sai));
    pf_cfg_regs.CSR_BAR_L.write(status,32'h_0000_0000,primary_id, .sai(legal_sai));

    m_sequencer.get_config_int("strap_hqm_gpsb_srcid", src_pid);
    m_sequencer.get_config_int("hqm_gpsb_dstid", dest_pid);
    `ovm_info(get_full_name(),$sformatf("src_pid %0h, dest_pid %0h", src_pid, dest_pid),OVM_LOW)
    `ovm_info(get_full_name(), $psprintf("Starting hqm_prim_n_sb_error_seq with mode (%s)", mode), OVM_LOW)
    case(mode.tolower())
      "primary_only"               : inject_err_primary_only();
      "sideband_only"              : inject_err_sideband_only();
      "primary_with_sideband"      : inject_err_primary_with_sideband();
      "prim_busnum_change_with_sb" : inject_busnum_change_on_primary_with_sideband();
      default                : begin `ovm_error(get_full_name(), $psprintf("Unknown mode (%s) provided !!!", mode)); inject_err_primary_only(); end
    endcase
    
  endtask : body

  task inject_err_primary_only();
    sla_ral_addr_t prim_addr;
    bit [31:0]     wr_val_1 = 32'h_aa, wr_val_2 = 32'h_55;
    bit            rslt;

    `ovm_info(get_full_name(), $psprintf("---------- Starting inject_err_primary_only ------------"), OVM_LOW)

    prim_addr[63:0] = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), hqm_msix_mem_regs.MSG_DATA[0]);

    // --------------------------------------------------------------
    // -- Write defaults on both prim and sb target registers
    // --------------------------------------------------------------
    hqm_msix_mem_regs.MSG_DATA[0].write(status,wr_val_1,primary_id,  .sai(legal_sai));
    hqm_msix_mem_regs.MSG_DATA[1].write(status, wr_val_1, iosf_sb_sla_pkg::get_src_type(), .sai(legal_sai));

    fork 
       begin
         send_tlp(get_tlp(prim_addr, Iosf::IOWr, .i_data({wr_val_2})), .ur(1));
       end
       begin
         hqm_msix_mem_regs.MSG_DATA[1].write(status,wr_val_2,iosf_sb_sla_pkg::get_src_type(), .sai(legal_sai));
       end
    join

    read_compare(hqm_msix_mem_regs.MSG_DATA[0],wr_val_1, .result(rslt));
    primary_id = iosf_sb_sla_pkg::get_src_type();          // -- Set access path to sideband
    read_compare(hqm_msix_mem_regs.MSG_DATA[1],wr_val_2, .result(rslt));
    primary_id = sla_iosf_pri_reg_lib_pkg::get_src_type(); // -- Restore access path to primary

  endtask : inject_err_primary_only

  task inject_err_sideband_only();
    hqm_sb_base_seq      sb_base;
    bit [31:0]     wr_val_1 = 32'h_aa, wr_val_2 = 32'h_55;
    bit            rslt;

    `ovm_info(get_full_name(), $psprintf("---------- Starting inject_err_sideband_only ------------"), OVM_LOW)

    sb_base = hqm_sb_base_seq::type_id::create("sb_base");
 
    // --------------------------------------------------------------
    // -- Write defaults on both prim and sb target registers
    // --------------------------------------------------------------
    hqm_msix_mem_regs.MSG_DATA[0].write(status,wr_val_1,primary_id,  .sai(legal_sai));
    //hqm_msix_mem_regs.MSG_DATA[1].set_user_attribute("SubnetPortID", "22");
    hqm_msix_mem_regs.MSG_DATA[1].write(status, wr_val_1, iosf_sb_sla_pkg::get_src_type(), .sai(legal_sai));

    fork 
       begin
         hqm_msix_mem_regs.MSG_DATA[0].write(status,wr_val_2,primary_id,  .sai(legal_sai));
       end
       begin
         send_iowr_sb(wr_val_2, sb_base.get_sb_addr("msg_data[0]", "hqm_msix_mem"), sb_base.get_sb_bar("msg_data[0]", "hqm_msix_mem"), sb_base.get_sb_fid("msg_data[0]", "hqm_msix_mem"));
       end
    join

    read_compare(hqm_msix_mem_regs.MSG_DATA[0],wr_val_2, .result(rslt));
    primary_id = iosf_sb_sla_pkg::get_src_type();          // -- Set access path to sideband
    read_compare(hqm_msix_mem_regs.MSG_DATA[1],wr_val_1, .result(rslt));
    primary_id = sla_iosf_pri_reg_lib_pkg::get_src_type(); // -- Restore access path to primary

  endtask : inject_err_sideband_only

  task inject_err_primary_with_sideband();
    sla_ral_addr_t prim_addr;
    hqm_sb_base_seq      sb_base;
    bit [31:0]     wr_val_1 = 32'h_aa, wr_val_2 = 32'h_55;
    bit            rslt;

    `ovm_info(get_full_name(), $psprintf("---------- Starting inject_err_primary_with_sideband ------------"), OVM_LOW)
   
    prim_addr[63:0] = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), hqm_msix_mem_regs.MSG_DATA[0]);

    sb_base = hqm_sb_base_seq::type_id::create("sb_base");

    // --------------------------------------------------------------
    // -- Write defaults on both prim and sb target registers
    // --------------------------------------------------------------

    hqm_msix_mem_regs.MSG_DATA[0].write(status,wr_val_1,primary_id,  .sai(legal_sai));
    hqm_msix_mem_regs.MSG_DATA[1].write(status, wr_val_1, iosf_sb_sla_pkg::get_src_type(), .sai(legal_sai));

    fork 
       begin
         send_tlp(get_tlp(prim_addr, Iosf::IOWr, .i_data({wr_val_2})), .ur(1));
       end
       begin
         send_iowr_sb(wr_val_2, sb_base.get_sb_addr("msg_data[0]", "hqm_msix_mem"), sb_base.get_sb_bar("msg_data[0]", "hqm_msix_mem"), sb_base.get_sb_fid("msg_data[0]", "hqm_msix_mem"));
       end
    join

    read_compare(hqm_msix_mem_regs.MSG_DATA[0],wr_val_1, .result(rslt));
    primary_id = iosf_sb_sla_pkg::get_src_type();          // -- Set access path to sideband
    read_compare(hqm_msix_mem_regs.MSG_DATA[1],wr_val_1, .result(rslt));
    primary_id = sla_iosf_pri_reg_lib_pkg::get_src_type(); // -- Restore access path to primary

  endtask : inject_err_primary_with_sideband

  task send_iowr_sb(bit [31:0] wr_val, bit [63:0] addr, bit [2:0] bar, bit [7:0] fid, bit ur = 1);
      iosfsbm_cm::flit_t           iosf_addr[];
      iosfsbm_cm::flit_t           iosf_data[];
      flit_t                       my_ext_headers[];
      iosfsbm_seq::iosf_sb_seq     sb_seq;

       my_ext_headers      = new[4];
       my_ext_headers[0]   = 8'h00;
       my_ext_headers[1]   = 8'h01;                // Set SAI
       my_ext_headers[2]   = 8'h00;
       my_ext_headers[3]   = 8'h00;
                 
       iosf_addr          = new[2];
       iosf_addr[0]       = addr[7:0];
       iosf_addr[1]       = addr[15:8];
// --       iosf_addr[2]       = addr[23:16];
// --       iosf_addr[3]       = addr[31:24];
// --       iosf_addr[4]       = addr[31:24];
// --       iosf_addr[5]       = addr[31:24];

       iosf_data    = new[4];
       iosf_data[0] = wr_val[7:0];
       iosf_data[1] = wr_val[15:8];
       iosf_data[2] = wr_val[23:16];
       iosf_data[3] = wr_val[31:24];

             
        `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
          { addr_i.size         == iosf_addr.size;
            foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
            eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            data_i.size         == iosf_data.size;
            foreach (data_i[j]) data_i[j] == iosf_data[j];
            xaction_class_i     == NON_POSTED;
            src_pid_i           == dest_pid[7:0];
            dest_pid_i          == src_pid[7:0];
            local_src_pid_i       == dest_pid[15:8];
            local_dest_pid_i      == src_pid[15:8];
            opcode_i            == OP_IOWR;
            tag_i               == 1;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == fid;
            bar_i               == bar;
            exp_rsp_i           == 1;
            chunk_size          == 1;
            compare_completion_i == 0;
          })

    if (sb_seq.rx_compl_xaction.rsp != ur) 
       ovm_report_error(get_full_name(), $psprintf("IOWr Address=0x%x  Data=0x%08x error completion (0x%x)",addr,wr_val,ur), OVM_LOW);
    else 
       ovm_report_info(get_full_name(), $psprintf("IOWr Address=0x%x  Data=0x%08x",addr,wr_val), OVM_LOW);

  endtask : send_iowr_sb

  task inject_busnum_change_on_primary_with_sideband();
    sla_ral_addr_t prim_addr;
    hqm_sb_base_seq      sb_base;
    bit [31:0]     wr_val_1 = 32'h_aa, wr_val_2 = 32'h_55;
    bit            rslt;

    `ovm_info(get_full_name(), $psprintf("---------- Starting inject_busnum_change_on_primary_with_sideband ------------"), OVM_LOW)
   
    prim_addr[63:0]  = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_cfg_regs.CACHE_LINE_SIZE);
    prim_addr[31:24] = $urandom_range(100,255);

    sb_base = hqm_sb_base_seq::type_id::create("sb_base");

    // --------------------------------------------------------------
    // -- Write defaults on both prim and sb target registers
    // --------------------------------------------------------------
    send_tlp(get_tlp(prim_addr, Iosf::CfgWr0, .i_data({wr_val_2})), .ur(0));

    primary_id = iosf_sb_sla_pkg::get_src_type();          // -- Set access path to sideband
    read_compare(pf_cfg_regs.CACHE_LINE_SIZE, wr_val_2, .result(rslt));

    pf_cfg_regs.CACHE_LINE_SIZE.write(status, wr_val_1, iosf_sb_sla_pkg::get_src_type(), .sai(legal_sai));
    read_compare(pf_cfg_regs.CACHE_LINE_SIZE, wr_val_1, .result(rslt));

    primary_id = sla_iosf_pri_reg_lib_pkg::get_src_type(); // -- Restore access path to primary
    read_compare(pf_cfg_regs.CACHE_LINE_SIZE, wr_val_1, .result(rslt));

  endtask : inject_busnum_change_on_primary_with_sideband

endclass : hqm_prim_n_sb_error_seq

`endif

