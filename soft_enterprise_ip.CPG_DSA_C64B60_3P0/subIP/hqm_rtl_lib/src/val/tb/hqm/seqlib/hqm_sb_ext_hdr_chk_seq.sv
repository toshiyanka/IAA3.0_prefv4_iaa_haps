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

`ifndef HQM_SB_EXT_HDR_CHK_SEQ__SV
`define HQM_SB_EXT_HDR_CHK_SEQ__SV

// -----------------------------------------------------------------------------
// File        : hqm_sb_ext_hdr_chk_seq.sv
// Author      : Neeraj Shete
// Description : This sequence extends from hqm_sb_base_seq and intendts to,
//               - Check the effect of ext header presence 
//
// -----------------------------------------------------------------------------


class hqm_sb_ext_hdr_chk_seq extends hqm_sb_base_seq;
  `ovm_sequence_utils(hqm_sb_ext_hdr_chk_seq,sla_sequencer)
  string mode = "";
  function new(string name = "hqm_sb_ext_hdr_chk_seq");
    super.new(name); 
    if(!$value$plusargs("HQM_SB_TEST_MODE=%s",mode)) begin mode = "sb_msg_ext_hdr_chk"; end
  endfunction

  virtual task body();
    `ovm_info(get_full_name(), $psprintf("Starting hqm_sb_test_seq with mode (%s)", mode), OVM_LOW)
    case(mode.tolower())
      "sb_msg_ext_hdr_chk"   : sb_msg_ext_hdr_chk() ;
      "sb_msg_ext_hdr_chk2"  : sb_msg_ext_hdr_chk2() ;
      "sb_msg_ordering_chk"  : sb_msg_ordering_chk();
      "sb_msg_all_regions"   : sb_msg_all_regions() ;
      "sb_regio_ill_fid"     : sb_regio_ill_fid() ;
      "sb_regio_ill_bar"     : sb_regio_ill_bar() ;
      default                : begin `ovm_error(get_full_name(), $psprintf("Unknown mode (%s) provided !!!", mode)); end
    endcase
  endtask : body

  virtual task sb_msg_ext_hdr_chk();
     bit [63:0] loc_addr = get_sb_addr("cache_line_size", "hqm_pf_cfg_i");
     bit [2:0]  bar;
     bit [7:0]  fid;
     bit [31:0] wr_val_1 = 32'h_55;
     bit [31:0] wr_val_2 = 32'h_aa;

    `ovm_info(get_full_name(), $psprintf("---------- Starting sb_msg_ext_hdr_chk ------------"), OVM_LOW)

     // -------------------------------------------------------------------
     // -- Send write (wr_val_1) with ext hdr and read back value written
     // -------------------------------------------------------------------
     send_cfg_sb_msg(loc_addr, .rd(0), .data(wr_val_1));
     send_cfg_sb_msg(loc_addr, .rd(1), .data(wr_val_1), .do_compare(1));

     // -------------------------------------------------------------------
     // -- Send write (wr_val_2) without ext hdr and read back value being updated (SAI not checked)
     // -------------------------------------------------------------------
     send_cfg_sb_msg(loc_addr, .rd(0), .data(wr_val_2), .en_ext_hdr(0));
     send_cfg_sb_msg(loc_addr, .rd(1), .data(wr_val_2), .do_compare(1));

     // -------------------------------------------------------------------
     // -- Send write (wr_val_2) with ext hdr and read back value being updated
     // -------------------------------------------------------------------
     send_cfg_sb_msg(loc_addr, .rd(0), .data(wr_val_2));
     send_cfg_sb_msg(loc_addr, .rd(1), .data(wr_val_2), .do_compare(1));

     // -------------------------------------------------------------------
     // -- Send write (wr_val_1) with ext hdr and read back value written
     // -------------------------------------------------------------------
     send_cfg_sb_msg(loc_addr, .rd(0), .data(wr_val_1));
     send_cfg_sb_msg(loc_addr, .rd(1), .data(wr_val_1), .do_compare(1));

     // -------------------------------------------------------------------
     // -- Send without ext hdr and read back value
     // -------------------------------------------------------------------
     send_cfg_sb_msg(loc_addr, .rd(1), .data(wr_val_1), .do_compare(1), .en_ext_hdr(0));

     wait_ns_clk(10000);

     // -------------------------------------------------------------------
     // -- Running above scenario for MEM-space
     // -------------------------------------------------------------------
     loc_addr = get_sb_addr("msg_addr_u[0]", "hqm_msix_mem");
     bar      = get_sb_bar("msg_addr_u[0]", "hqm_msix_mem");
     fid      = get_sb_fid("msg_addr_u[0]", "hqm_msix_mem");

     // -------------------------------------------------------------------
     // -- Send write (wr_val_1) with ext hdr and read back value written
     // -------------------------------------------------------------------
     send_mem_sb_msg(loc_addr, .rd(0), .data(wr_val_1), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED));
     send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_1), .do_compare(1), .fid(fid), .bar(bar));
     wait_ns_clk(5000);

     // -------------------------------------------------------------------
     // -- Send write (wr_val_2) without ext hdr and read back value being updated (SAI not checked)
     // -------------------------------------------------------------------
     send_mem_sb_msg(loc_addr, .rd(0), .data(wr_val_2), .en_ext_hdr(0), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED));
     send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_2), .do_compare(1), .fid(fid), .bar(bar));
     wait_ns_clk(5000);

     // -------------------------------------------------------------------
     // -- Send write (wr_val_2) with ext hdr and read back value being updated
     // -------------------------------------------------------------------
     send_mem_sb_msg(loc_addr, .rd(0), .data(wr_val_2), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED));
     send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_2), .do_compare(1), .fid(fid), .bar(bar));
     wait_ns_clk(5000);

     // -------------------------------------------------------------------
     // -- Send write (wr_val_1) with ext hdr and read back value written
     // -------------------------------------------------------------------
     send_mem_sb_msg(loc_addr, .rd(0), .data(wr_val_1), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED));
     send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_1), .do_compare(1), .fid(fid), .bar(bar));
     wait_ns_clk(5000);

     // -------------------------------------------------------------------
     // -- Send without ext hdr and read back value as last written one. 
     // -------------------------------------------------------------------
     send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_1), .do_compare(1), .en_ext_hdr(0), .fid(fid), .bar(bar), .block(1));

     wait_ns_clk(15000);

  endtask : sb_msg_ext_hdr_chk

  //-- pvim: 1408327335 --//
  virtual task sb_msg_ext_hdr_chk2();
     string     regname;
     bit [31:0] rd_regval;
     bit [63:0] regaddr;
     bit [2:0]  bar;
     bit [7:0]  fid;
     bit [31:0] wr_val;

     //-- Txn types --//
     /*{
     //veMRd: correctly formed MRd with SAIRS EH ( DFX_INTEL_MANUFACTURING_SAI): Accepted
     //veMWr: correctly formed DW MWr with SAIRS EH( DFX_INTEL_MANUFACTURING_SAI ): Accepted
     //seMRd: correctly formed MRd with SAIRS EH ( DEVICE_UNTRUSTED_SAI ): Accepted : Returns register value
     //seMWr: correctly formed MWr with SAIRS EH ( DEVICE_UNTRUSTED_SAI ):Silently Dropped
     //sMRd: correctly formed MRd with EH == 0 : Accepted. Returns register value.
     //sMWr: correctly formed MWr with EH == 0: Silently Dropped
     //meMRd1:  correctly formed MRd with 2 extended headers (SAIRS is only EH supported by HQM): Accepted: Returns register value
     //meMWr1a: correctly formed MWr with 2 extended headers (SAIRS is only EH supported by HQM):Case a:  1st EH has SAI == DEVICE_UNTRUSTED_SAI --> silently dropped. --abbiswal-- What about the non-posted transaction. Do we expect a response?
     //meMWr1b: correctly formed MWr with 2 extended headers (SAIRS is only EH supported by HQM):Case b:  1st EH has SAI == --> DFX_INTEL_MANUFACTURING_SAI --> write completes.
     //meMRd2a: correctly formed MRd with 2 extended headers (HDRID == 1 for 1st EH): Accepted: Returns register value
     //meMRd2b: correctly formed MRd with 2 extended headers (HDRID == 1 for 2nd EH): Accepted: Returns register value
     //meMWr2a: correctly formed MWr with 2 extended headers (HDRID == 1 for 1st EH): silently dropped.
     //meMWr2b: correctly formed MWr with 2 extended headers (HDRID == 1 for 2nd EH): Write completes.
     //qeMWr: correctly formed QuadWord MWr with SAIRS EH ( DFX_INTEL_MANUFACTURING_SAI): UR
     }*/

     string txn_types[] = {"veMRd", "veMWr", "seMRd", "seMWr", "sMRd", "sMWr", "meMRd1", "meMWr1a", "meMWr1b", "meMRd2a", "meMRd2b", "meMWr2a", "meMWr2b", "meMWr2c", "qeMWr"};

     //-- 16 register --//
     string reglist[string] = { "msg_addr_l[0]":"hqm_msix_mem"
                               ,"msg_addr_l[1]":"hqm_msix_mem"
                               ,"msg_addr_l[2]":"hqm_msix_mem"
                               ,"msg_addr_l[3]":"hqm_msix_mem"
                               ,"msg_addr_l[4]":"hqm_msix_mem"
                               ,"msg_addr_l[5]":"hqm_msix_mem"
                               ,"msg_data[0]"  :"hqm_msix_mem"
                               ,"msg_data[2]"  :"hqm_msix_mem"
                               ,"ldb_cq_addr_l[0]":"hqm_system_csr"
                               ,"ldb_cq_addr_l[1]":"hqm_system_csr"
                               ,"ldb_cq_addr_l[2]":"hqm_system_csr"
                               ,"ldb_cq_addr_l[3]":"hqm_system_csr"
                               ,"dir_cq_addr_l[0]":"hqm_system_csr"
                               ,"dir_cq_addr_l[1]":"hqm_system_csr"
                               ,"dir_cq_addr_l[2]":"hqm_system_csr"
                               ,"dir_cq_addr_l[3]":"hqm_system_csr"
                              };
                              //--// 
                                
     bit [31:0] regvals[string] = { "msg_addr_l[0]":32'h00001100
                                   ,"msg_addr_l[1]":32'h00002000
                                   ,"msg_addr_l[2]":32'h00013000
                                   ,"msg_addr_l[3]":32'h00104000
                                   ,"msg_addr_l[4]":32'h01005000
                                   ,"msg_addr_l[5]":32'h10006000
                                   ,"msg_data[0]"  :32'h01007000
                                   ,"msg_data[2]"  :32'h00108000
                                   ,"ldb_cq_addr_l[0]":32'h80001100
                                   ,"ldb_cq_addr_l[1]":32'h80002000
                                   ,"ldb_cq_addr_l[2]":32'h80013000
                                   ,"ldb_cq_addr_l[3]":32'h80104000
                                   ,"dir_cq_addr_l[0]":32'h81005000
                                   ,"dir_cq_addr_l[1]":32'h90006000
                                   ,"dir_cq_addr_l[2]":32'h91007000
                                   ,"dir_cq_addr_l[3]":32'h90108000
                                  };
				  
     bit        reg_sai[string] = { "msg_addr_l[0]":1'b0
                                   ,"msg_addr_l[1]":1'b0
                                   ,"msg_addr_l[2]":1'b0
                                   ,"msg_addr_l[3]":1'b0
                                   ,"msg_addr_l[4]":1'b0
                                   ,"msg_addr_l[5]":1'b0
                                   ,"msg_data[0]"  :1'b0
                                   ,"msg_data[2]"  :1'b0
                                   ,"ldb_cq_addr_l[0]":1'b1
                                   ,"ldb_cq_addr_l[1]":1'b1
                                   ,"ldb_cq_addr_l[2]":1'b1
                                   ,"ldb_cq_addr_l[3]":1'b1
                                   ,"dir_cq_addr_l[0]":1'b1
                                   ,"dir_cq_addr_l[1]":1'b1
                                   ,"dir_cq_addr_l[2]":1'b1
                                   ,"dir_cq_addr_l[3]":1'b1
                                  };
				  
     `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("sb_msg_ext_hdr_chk2 started"), OVM_LOW)      

     //-- Initialize the register with unique value --//
     reglist.first(regname);  
     do begin
       regaddr = get_sb_addr(regname, reglist[regname]);
       bar     = get_sb_bar(regname, reglist[regname]);
       fid     = get_sb_fid(regname, reglist[regname]);
       wr_val  = regvals[regname]; 
       `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("Initializing register: %s | regaddr: 0x%0h | wr_val : 0x%0h", regname, regaddr, wr_val), OVM_LOW)
       send_mem_sb_msg(regaddr, .rd(0), .data(wr_val), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED), .block(1));
       //-- abbiswal --: Need to check what happens in case the write txn fails --//
       `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("Storing the written value to local variable after write | wr_val : 0x%0h", wr_val), OVM_LOW)
       regvals[regname] = wr_val; //-- Not required, but making sure local copy is updated after every wr --//
     end
     while(reglist.next(regname));
    
     //-- Issue 729 sequence of sideband mem txn --//
     for (int seq = 0; seq < 729; seq++) begin
        //-- decide the register --//
        int idx;
        bit [31:0] comp_val;
        bit     sai_checked;
	
        idx = $urandom_range(reglist.size(), 0);
        reglist.first(regname);
        for (int itr = 1; itr < idx; itr++) begin
            reglist.next(regname);
        end

        regaddr = get_sb_addr(regname, reglist[regname]);
        bar     = get_sb_bar(regname, reglist[regname]);
        fid     = get_sb_fid(regname, reglist[regname]);
        sai_checked = reg_sai[regname]; // SAI checked for write transaction if set to 1
	        
        `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("Performing transaction on register: %s | regaddr: 0x%0h; sai_checked: %0d", regname, regaddr, sai_checked), OVM_LOW)

        //-- sequence of txn to perform --//
        for (int itr = 0; itr <= 1; itr++) begin
            int txn_t_idx;
            txn_t_idx = $urandom_range((txn_types.size() - 1), 0);
            case(txn_types[txn_t_idx])
                "veMRd" : begin //veMRd: correctly formed MRd with SAIRS EH ( DFX_INTEL_MANUFACTURING_SAI): Accepted
                            comp_val = regvals[regname];
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("veMRd on register: %0s, regaddr=0x%0x, comp_val=0x%0x", regname, regaddr, comp_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .block(1));
                          end
                "seMRd" : begin //seMRd: correctly formed MRd with SAIRS EH ( DEVICE_UNTRUSTED_SAI ): Accepted Returns register value
                            comp_val = regvals[regname];
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("seMRd on register: %0s, regaddr=0x%0x, comp_val=0x%0x", regname, regaddr, comp_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .iosf_sai('h4), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .block(1));
                          end
                "sMRd" : begin //sMRd: correctly formed MRd with EH == 0 : Accepted: Returns register value
                            comp_val = regvals[regname];
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("sMRd on register: %0s, regaddr=0x%0x, comp_val=0x%0x", regname, regaddr, comp_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .en_ext_hdr(0), .block(1));
                         end
                "meMRd1": begin //meRd: correctly formed MRd with 2 extended headers (SAIRS is only EH supported by HQM): Accepted: Returns register value
                            comp_val = regvals[regname];
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("meMRd1 on register: %0s, regaddr=0x%0x, comp_val=0x%0x", regname, regaddr, comp_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .en_ext_hdr(1), .num_ext_hdr(2), .block(1));
                         end
                "meMRd2a": begin //meMRd2: correctly formed MRd with 2 extended headers (HDRID == 1 for 1st EH): Accepted: Returns register value
                            comp_val = regvals[regname];
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("meMRd2a on register: %0s, regaddr=0x%0x, comp_val=0x%0x", regname, regaddr, comp_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .en_ext_hdr(1), .num_ext_hdr(2), .hdrid1(7'h01), .block(1));
                         end
                "meMRd2b": begin //meMRd2: correctly formed MRd with 2 extended headers (HDRID == 1 for 2nd EH): Accepted: Returns register value
                            comp_val = regvals[regname];
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("meMRd2b on register: %0s, regaddr=0x%0x, comp_val=0x%0x", regname, regaddr, comp_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .en_ext_hdr(1), .num_ext_hdr(2), .hdrid2(7'h01), .block(1));
                         end
                "veMWr" : begin //veMWr: correctly formed DW MWr with SAIRS EH( DFX_INTEL_MANUFACTURING_SAI ): Accepted
                            wr_val = regvals[regname];
                            wr_val = wr_val + 8'h40;
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("veMWr.wr on register: %0s, regaddr=0x%0x, wr_val=0x%0x", regname, regaddr, wr_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(0), .data(wr_val), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED), .block(1));
                            wait_ns_clk(500);
                            regvals[regname] = wr_val;
                            //-- compare check written value --//
                            comp_val = wr_val;
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("veMWr.rdback on register: %0s, regaddr=0x%0x, exp comp_val=0x%0x", regname, regaddr, comp_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .block(1));
                          end
                "seMWr" : begin //seMWr: correctly formed MWr with SAIRS EH ( DEVICE_UNTRUSTED_SAI ):Silently Dropped if sai_checked==1
                            wr_val = regvals[regname];
                            wr_val = wr_val + 8'h40;
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("seMWr.wr on register: %0s, regaddr=0x%0x, wr_val=0x%0x", regname, regaddr, wr_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(0), .iosf_sai('h4), .data(wr_val), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED), .block(1));
                            wait_ns_clk(500);
                            //-- Don't update the local value of register as previous wr should be silently dropped if sai_checked set --//
                            //-- compare check written value --//
                            comp_val = sai_checked ? regvals[regname] : wr_val;
                            regvals[regname] = comp_val;
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("seMWr.rdback on register: %0s, regaddr=0x%0x, exp comp_val=0x%0x, wr_val=0x%0x, sai_checked=%0d", regname, regaddr, comp_val, wr_val, sai_checked), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .block(1));
                          end			  
                "sMWr" : begin //sMWr: correctly formed MWr with EH == 0: Silently Dropped
                            wr_val = regvals[regname];
                            wr_val = wr_val + 8'h40;
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("sMWr.wr on register: %0s, regaddr=0x%0x, wr_val=0x%0x", regname, regaddr, wr_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(0), .data(wr_val), .fid(fid), .bar(bar), .en_ext_hdr(0), .exp_rsp(0), .xaction_class(POSTED), .block(1));
                            wait_ns_clk(500);
                            //-- Don't update the local value of register as previous wr should be silently dropped if sai_checked set --//
                            //-- compare check written value --//
                            comp_val = sai_checked ? regvals[regname] : wr_val;
                            regvals[regname] = comp_val; 
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("sMWr.rdback on register: %0s, regaddr=0x%0x, exp comp_val=0x%0x, wr_val=0x%0x, sai_checked=%0d", regname, regaddr, comp_val, wr_val, sai_checked), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .block(1));
                            wait_ns_clk(500);
                         end
                "meMWr1a" : begin //meMWr1a: correctly formed MWr with 2 extended headers (SAIRS is only EH supported by HQM): Case a:  1st EH has SAI == DEVICE_UNTRUSTED_SAI --> silently dropped.
                            wr_val = regvals[regname];
                            wr_val = wr_val + 8'h40;
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("meMWr1a.wr on register: %0s, regaddr=0x%0x, wr_val=0x%0x", regname, regaddr, wr_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(0), .iosf_sai('h4), .exp_rsp(0), .data(wr_val), .fid(fid), .bar(bar), .en_ext_hdr(1), .num_ext_hdr(2), .xaction_class(POSTED), .block(1));
                            wait_ns_clk(500);
                            //-- Don't update the local value of register as previous wr should be silently dropped if sai_checked set --//
                            //-- compare check written value --//
                            comp_val = sai_checked ? regvals[regname] : wr_val;
                            regvals[regname] = comp_val;
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("meMWr1a.rdback on register: %0s, regaddr=0x%0x, exp comp_val=0x%0x, wr_val=0x%0x, sai_checked=%0d", regname, regaddr, comp_val, wr_val, sai_checked), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .block(1));
                          end 
                "meMWr1b" : begin //meMWr1b: correctly formed MWr with 2 extended headers (SAIRS is only EH supported by HQM): Case b:  1st EH has SAI == --> DFX_INTEL_MANUFACTURING_SAI --> write completes.
                            wr_val = regvals[regname];
                            wr_val = wr_val + 8'h40;
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("meMWr1b.wr on register: %0s, regaddr=0x%0x, wr_val=0x%0x", regname, regaddr, wr_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(0), .exp_rsp(0), .data(wr_val), .fid(fid), .bar(bar), .en_ext_hdr(1), .num_ext_hdr(2), .xaction_class(POSTED), .block(1));
                            wait_ns_clk(500);
                            regvals[regname] = wr_val;
                            //-- compare check written value --//
                            comp_val = regvals[regname];
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("meMWr1b.rdback on register: %0s, regaddr=0x%0x, exp comp_val=0x%0x, wr_val=0x%0x", regname, regaddr, comp_val, wr_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .block(1));
                          end 

                "meMWr2a" : begin  //meMWr2a: correctly formed MWr with 2 extended headers (HDRID == 1 for 1st EH) and DEVICE_UNTRUSTED_SAI in 2nd EH: silently dropped.
                            wr_val = regvals[regname];
                            wr_val = wr_val + 8'h40;
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("meMWr2a.wr on register: %0s, regaddr=0x%0x, wr_val=0x%0x", regname, regaddr, wr_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(0), .iosf_sai2('h0), .exp_rsp(0), .data(wr_val), .fid(fid), .bar(bar), .en_ext_hdr(1), .num_ext_hdr(2), .hdrid1(6'h01), .xaction_class(POSTED), .block(1));
                            wait_ns_clk(500);
                            //-- The write should be silently dropped if sai_checked set --//
                            //-- compare check written value --//
                            comp_val = sai_checked ? regvals[regname] : wr_val;
                            regvals[regname] = comp_val;
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("meMWr2a.rdback on register: %0s, regaddr=0x%0x, exp comp_val=0x%0x, wr_val=0x%0x, sai_checked=%0d", regname, regaddr, comp_val, wr_val, sai_checked), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .block(1));
                          end 
                
                "meMWr2b" : begin  //meMWr2b: correctly formed MWr with 2 extended headers (HDRID == 1 for 1st EH) and DFX_INTEL_MANUFACTURING_SAI in 2nd EH: Write completes 
                            wr_val = regvals[regname];
                            wr_val = wr_val + 8'h40;
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("meMWr2b.wr on register: %0s, regaddr=0x%0x, wr_val=0x%0x", regname, regaddr, wr_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(0), .iosf_sai2('h30), .exp_rsp(0), .data(wr_val), .fid(fid), .bar(bar), .en_ext_hdr(1), .num_ext_hdr(2), .hdrid1(6'h01), .xaction_class(POSTED), .block(1));
                            wait_ns_clk(500);
                            //-- The write should successfully complete--//
                            //-- compare check written value --//
                            regvals[regname] = wr_val;
                            comp_val = regvals[regname];
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("meMWr2b.rdback on register: %0s, regaddr=0x%0x, exp comp_val=0x%0x, wr_val=0x%0x", regname, regaddr, comp_val, wr_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .block(1));
                          end 
                    
                    
                "meMWr2c" : begin  //meMWr2c: correctly formed MWr with 2 extended headers (DFX_INTEL_MANUFACTURING_SAI in 1st EH)(HDRID == 1 for 2nd EH): Write completes.
                            wr_val = regvals[regname];
                            wr_val = wr_val + 8'h40;
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("meMWr2c.wr on register: %0s, regaddr=0x%0x, wr_val=0x%0x", regname, regaddr, wr_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(0), .iosf_sai('h30), .exp_rsp(0), .data(wr_val), .fid(fid), .bar(bar), .en_ext_hdr(1), .num_ext_hdr(2), .hdrid2(6'h01), .xaction_class(POSTED), .block(1));
                            wait_ns_clk(500);
                            regvals[regname] = wr_val;
                            //-- compare check written value --//
                            comp_val = regvals[regname];
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("meMWr2c.rdback on register: %0s, regaddr=0x%0x, exp comp_val=0x%0x, wr_val=0x%0x", regname, regaddr, comp_val, wr_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .block(1));
                          end 

                "qeMWr" : begin //qeMWr: correctly formed QuadWord MWr with SAIRS EH ( DFX_INTEL_MANUFACTURING_SAI): UR
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("qeMWr on register: %0s", regname), OVM_LOW)      
                            wr_val = regvals[regname];
                            wr_val = wr_val + 8'h40;
                            //send_mem_sb_msg(regaddr, .rd(0), .exp_cplstatus(2'b01), .data(wr_val), .sbe(4'hf), .data2(32'ha5a5a5a5), .fid(fid), .bar(bar), .en_ext_hdr(1), .block(1));
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("qeMWr.wr on register: %0s, regaddr=0x%0x, wr_val=0x%0x", regname, regaddr, wr_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(0), .exp_rsp(1), .exp_cplstatus(2'b01), .data(wr_val), .sbe(4'hf), .data2(32'ha5a5a5a5), .fid(fid), .bar(bar), .en_ext_hdr(1), .xaction_class(NON_POSTED), .block(1));
                            wait_ns_clk(500);
                            //-- Don't update the local value of register as previous wr should be URed --//
                            //-- compare check written value --//
                            comp_val = regvals[regname];
                            `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("qeMWr.rdback on register: %0s, regaddr=0x%0x, exp comp_val=0x%0x, wr_val=0x%0x", regname, regaddr, comp_val, wr_val), OVM_LOW)
                            send_mem_sb_msg(regaddr, .rd(1), .data(comp_val), .do_compare(1), .fid(fid), .bar(bar), .block(1));
                          end
                default: begin `ovm_error("SB_MSG_EXT_HDR_CHK2", $psprintf("Invalid txn type: %s. Index: %0d", txn_types[txn_t_idx], txn_t_idx)) end
            endcase
        end
     end

     `ovm_info("SB_MSG_EXT_HDR_CHK2", $psprintf("sb_msg_ext_hdr_chk2 ended"), OVM_LOW)      

  endtask : sb_msg_ext_hdr_chk2


  virtual task sb_msg_ordering_chk();
     bit [63:0] loc_addr = get_sb_addr("msg_addr_u[0]", "hqm_msix_mem");
     bit [2:0] bar       = get_sb_bar("msg_addr_u[0]", "hqm_msix_mem");
     bit [7:0] fid       = get_sb_fid("msg_addr_u[0]", "hqm_msix_mem");
     bit [31:0] wr_val;

     `ovm_info(get_full_name(), $psprintf("---------- Starting sb_msg_ordering_chk ------------"), OVM_LOW)

     for(int i=0; i<100; i++) begin
         wr_val = i;
         send_mem_sb_msg(loc_addr, .rd(0), .data(wr_val), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED));
     end
         send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val), .do_compare(1), .fid(fid), .bar(bar), .block(1));

     //wait_ns_clk(5000);
   
  endtask : sb_msg_ordering_chk

  virtual task sb_msg_all_regions();
     bit [63:0] loc_addr = get_sb_addr("cache_line_size", "hqm_pf_cfg_i");
     bit [2:0]  bar;
     bit [7:0]  fid;
     bit [31:0] wr_val_1 = 32'h_55;
     bit [31:0] wr_val_2 = 32'h_aa;

    `ovm_info(get_full_name(), $psprintf("---------- Starting sb_msg_all_regions ------------"), OVM_LOW)

     // -------------------------------------------------------------------
     // -- Access PF Cfg space
     // -------------------------------------------------------------------
     send_cfg_sb_msg(loc_addr, .rd(0), .data(wr_val_1));
     send_cfg_sb_msg(loc_addr, .rd(1), .data(wr_val_1), .do_compare(1));
     send_cfg_sb_msg(loc_addr, .rd(0), .data(wr_val_2));
     send_cfg_sb_msg(loc_addr, .rd(1), .data(wr_val_2), .do_compare(1));

     wait_ns_clk(30000);

     // -------------------------------------------------------------------
     // -- Access PF BAR space (CSR_BAR)
     // -------------------------------------------------------------------
     loc_addr = get_sb_addr("ldb_cq_addr_u[0]", "hqm_system_csr");
     bar      = get_sb_bar("ldb_cq_addr_u[0]",  "hqm_system_csr");
     fid      = get_sb_fid("ldb_cq_addr_u[0]",  "hqm_system_csr");

     send_mem_sb_msg(loc_addr, .rd(0), .data(wr_val_1), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED));
     send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_1), .do_compare(1), .fid(fid), .bar(bar));
     wait_ns_clk(5000);
     send_mem_sb_msg(loc_addr, .rd(0), .data(wr_val_2), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED));
     send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_2), .do_compare(1), .fid(fid), .bar(bar));
     wait_ns_clk(5000);

     // -------------------------------------------------------------------
     // -- Access PF BAR space (FUNC_PF_BAR) 
     // -------------------------------------------------------------------
     loc_addr = get_sb_addr("msg_addr_u[0]", "hqm_msix_mem");
     bar      = get_sb_bar("msg_addr_u[0]", "hqm_msix_mem");
     fid      = get_sb_fid("msg_addr_u[0]", "hqm_msix_mem");

     send_mem_sb_msg(loc_addr, .rd(0), .data(wr_val_1), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED));
     send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_1), .do_compare(1), .fid(fid), .bar(bar));
     wait_ns_clk(5000);
     send_mem_sb_msg(loc_addr, .rd(0), .data(wr_val_2), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED));
     send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_2), .do_compare(1), .fid(fid), .bar(bar));
     wait_ns_clk(5000);

     send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_2), .do_compare(1), .fid(fid), .bar(bar), .block(1));

  endtask : sb_msg_all_regions

  virtual task sb_regio_ill_fid();
     bit [63:0] loc_addr = get_sb_addr("cache_line_size", "hqm_pf_cfg_i");
     bit [2:0]  bar;
     bit [7:0]  fid;
     bit [31:0] wr_val_1 = 32'h_55;
     bit [31:0] wr_val_2 = 32'h_aa;

    `ovm_info(get_full_name(), $psprintf("---------- Starting sb_regio_ill_fid ------------"), OVM_LOW)

     // -------------------------------------------------------------------
     // -- Access implemented and unimplemented functions cfg space
     // -------------------------------------------------------------------
     for(int k=0; k<=8'h_ff; k++) begin
        loc_addr = get_sb_addr("cache_line_size", "hqm_pf_cfg_i");

        send_cfg_sb_msg(loc_addr, .rd(0), .fid(k), .exp_cplstatus(k>0), .data(wr_val_1));
        send_cfg_sb_msg(loc_addr, .rd(1), .fid(k), .exp_cplstatus(k>0), .data(wr_val_1), .do_compare(k==0));
     end
     wait_ns_clk(30000);

     // -------------------------------------------------------------------
     // -- Access Cfg space with random bars should complete successfully
     // -------------------------------------------------------------------
     for(int k=`HQM_PF_FUNC_NUM; k<=(`HQM_PF_FUNC_NUM); k++) begin
        loc_addr = get_sb_addr("cache_line_size", "hqm_pf_cfg_i");

        send_cfg_sb_msg(loc_addr, .rd(0), .bar($urandom(3'b_111)), .fid(k), .data(wr_val_2));
        send_cfg_sb_msg(loc_addr, .rd(1), .bar($urandom(3'b_111)), .fid(k), .data(wr_val_2), .do_compare(1));
     end

     wait_ns_clk(30000);
     wait_ns_clk(30000);
     wait_ns_clk(1000);

     // -------------------------------------------------------------------
     // -- Access PF BAR space (CSR_BAR)
     // -------------------------------------------------------------------
     loc_addr = get_sb_addr("ldb_cq_addr_u[0]", "hqm_system_csr");
     bar      = get_sb_bar("ldb_cq_addr_u[0]",  "hqm_system_csr");
     fid      = get_sb_fid("ldb_cq_addr_u[0]",  "hqm_system_csr");


    `ovm_info(get_full_name(), $psprintf("---------- Current reg fid value is (0x%0x) ------------", fid), OVM_LOW)

     for(int i=0; i<=8'h_ff; i++) begin
       if(i!=fid) begin
         // -- Run the below scenario for unsupported fid -- //
         send_mem_sb_msg(loc_addr, .rd(0), .data(wr_val_1), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED), .block(1));
         send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_1), .exp_cplstatus(0), .do_compare(1), .fid(fid), .bar(bar), .block(1));
         wait_ns_clk(1700);
         send_mem_sb_msg(loc_addr, .rd(0), .data(wr_val_2), .fid(i), .bar(bar), .exp_rsp(0), .xaction_class(POSTED), .block(1));
         send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_1), .exp_cplstatus(0), .do_compare(1), .fid(fid), .bar(bar), .block(1));
         wait_ns_clk(1700);
         send_mem_sb_msg(loc_addr, .rd(0), .data(wr_val_2), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED), .block(1));
         send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_2), .exp_cplstatus(0), .do_compare(1), .fid(fid), .bar(bar), .block(1));
         wait_ns_clk(1700);
         send_mem_sb_msg(loc_addr, .rd(1), .data(wr_val_2), .exp_cplstatus(1), .do_compare(0), .fid(i), .bar(bar), .block(1));
         wait_ns_clk(1400);
       end
     end

     wait_ns_clk(700);

    `ovm_info(get_full_name(), $psprintf("---------- Done unimplemented fid check ------------"), OVM_LOW)

  endtask : sb_regio_ill_fid

  virtual task sb_regio_ill_bar();
     bit [63:0] loc_addr = get_sb_addr("cache_line_size", "hqm_pf_cfg_i");
     bit [2:0]  bar, csr_pf_bar, func_pf_bar;
     bit [7:0]  fid;
     bit [31:0] wr_val_1 = 32'h_55;
     bit [31:0] wr_val_2 = 32'h_aa;
     csr_pf_bar  = get_sb_bar("ldb_cq_addr_u[0]",  "hqm_system_csr");
     func_pf_bar = get_sb_bar("msg_addr_u[0]", "hqm_msix_mem");

    `ovm_info(get_full_name(), $psprintf("---------- Starting sb_regio_ill_bar ------------"), OVM_LOW)

     // -------------------------------------------------------------------
     // -- Access PF BAR space (CSR_BAR)
     // -------------------------------------------------------------------
     loc_addr = get_sb_addr("ldb_cq_addr_u[0]", "hqm_system_csr");
     bar      = get_sb_bar("ldb_cq_addr_u[0]",  "hqm_system_csr");
     fid      = get_sb_fid("ldb_cq_addr_u[0]",  "hqm_system_csr");


    `ovm_info(get_full_name(), $psprintf("---------- Start unimplemented bar_id (CSR_BAR) check ------------"), OVM_LOW)
    `ovm_info(get_full_name(), $psprintf("---------- Current reg bar value is (0x%0x) ------------", bar), OVM_LOW)

     for(int i=0; i<=3'b_111; i++) begin
       if(i!=bar && i!=func_pf_bar) begin // -- Since func_pf_bar id is also associated with PF -- //
         // -- Run the below scenario for unsupported bar -- //
         send_mem_sb_msg(loc_addr, .block(1), .rd(0), .data(wr_val_1), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED));
         send_mem_sb_msg(loc_addr, .block(1), .rd(1), .data(wr_val_1), .exp_cplstatus(0), .do_compare(1), .fid(fid), .bar(bar));
         wait_ns_clk(700);
         send_mem_sb_msg(loc_addr, .block(1), .rd(0), .data(wr_val_2), .fid(fid), .bar(i), .exp_rsp(0), .xaction_class(POSTED));
         send_mem_sb_msg(loc_addr, .block(1), .rd(1), .data(wr_val_1), .exp_cplstatus(0), .do_compare(1), .fid(fid), .bar(bar));
         wait_ns_clk(700);
         send_mem_sb_msg(loc_addr, .block(1), .rd(0), .data(wr_val_2), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED));
         send_mem_sb_msg(loc_addr, .block(1), .rd(1), .data(wr_val_2), .exp_cplstatus(0), .do_compare(1), .fid(fid), .bar(bar));
         wait_ns_clk(700);
         send_mem_sb_msg(loc_addr, .block(1), .rd(1), .data(wr_val_2), .exp_cplstatus(1), .do_compare(0), .fid(fid), .bar(i));
         wait_ns_clk(400);
       end
     end

    `ovm_info(get_full_name(), $psprintf("---------- Done unimplemented bar_id (CSR_BAR) check ------------"), OVM_LOW)

     // -------------------------------------------------------------------
     // -- Access PF BAR space (FUNC_PF_BAR) 
     // -------------------------------------------------------------------
     loc_addr = get_sb_addr("msg_addr_u[0]", "hqm_msix_mem");
     bar      = get_sb_bar("msg_addr_u[0]", "hqm_msix_mem");
     fid      = get_sb_fid("msg_addr_u[0]", "hqm_msix_mem");

    `ovm_info(get_full_name(), $psprintf("---------- Start unimplemented bar_id (FUNC_PF_BAR) check ------------"), OVM_LOW)
    `ovm_info(get_full_name(), $psprintf("---------- Current reg bar value is (0x%0x) ------------", bar), OVM_LOW)

     for(int k=0; k<=3'b_111; k++) begin
       if(k!=bar && k!=csr_pf_bar) begin // -- Since csr_pf_bar id is also associated with PF -- //
         send_mem_sb_msg(loc_addr, .block(1), .rd(0), .data(wr_val_1), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED));
         send_mem_sb_msg(loc_addr, .block(1), .rd(1), .data(wr_val_1), .exp_cplstatus(0), .do_compare(1), .fid(fid), .bar(bar));
         wait_ns_clk(700);
         send_mem_sb_msg(loc_addr, .block(1), .rd(0), .data(wr_val_2), .fid(fid), .bar(k), .exp_rsp(0), .xaction_class(POSTED));
         send_mem_sb_msg(loc_addr, .block(1), .rd(1), .data(wr_val_1), .exp_cplstatus(0), .do_compare(1), .fid(fid), .bar(bar));
         wait_ns_clk(700);
         send_mem_sb_msg(loc_addr, .block(1), .rd(0), .data(wr_val_2), .fid(fid), .bar(bar), .exp_rsp(0), .xaction_class(POSTED));
         send_mem_sb_msg(loc_addr, .block(1), .rd(1), .data(wr_val_2), .exp_cplstatus(0), .do_compare(1), .fid(fid), .bar(bar));
         wait_ns_clk(700);
         send_mem_sb_msg(loc_addr, .block(1), .rd(1), .data(wr_val_2), .exp_cplstatus(1), .do_compare(0), .fid(fid), .bar(k));
         wait_ns_clk(400);
       end
     end

    `ovm_info(get_full_name(), $psprintf("---------- Done unimplemented bar_id (FUNC_PF_BAR) check ------------"), OVM_LOW)

    `ovm_info(get_full_name(), $psprintf("---------- Done with ill bar check ------------"), OVM_LOW)

  endtask : sb_regio_ill_bar

endclass : hqm_sb_ext_hdr_chk_seq

`endif

