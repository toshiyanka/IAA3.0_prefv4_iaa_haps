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
// File   : hqm_pasid_enabled_seq.sv
//
// Description :
//
// -----------------------------------------------------------------------------

`ifndef HQM_PASID_ENABLED_SEQ__SV
`define HQM_PASID_ENABLED_SEQ__SV

class hqm_pasid_enabled_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_pasid_enabled_seq,sla_sequencer)

    hqm_sla_pcie_eot_checks_sequence                      error_status_chk_seq;

  function new(string name = "hqm_pasid_enabled_seq");
    super.new(name);
  endfunction

  virtual task body();
     sla_ral_data_t _orig_reg1_data, _new_reg1_data_;
     Iosf::data_t _new_reg2_data_;
     sla_ral_data_t _orig_reg2_data_;
     Iosf::data_t _rand_reg2_data_ = $urandom_range(23'h_0,23'h_0f_fff0);
     sla_ral_data_t wr_val = 'h_1;
     sla_ral_data_t op_val[$];
     bit rslt;
     bit [22:0] pasid_prefix;
     IosfTxn pasid_tlp;
     bit [127:0] header;
     bit [31:0] pasid_tlp_prefix;
     int aer_error_exp=0;

     sla_ral_reg reg1 = hqm_sif_csr_regs.AW_SMON_TIMER[0];
     sla_ral_reg reg2 = hqm_system_csr_regs.LDB_CQ_PASID[0];

     $value$plusargs("PASID_EN_AER_ERROR=%0d", aer_error_exp);

     // set pasid_enable=0
     pf_cfg_regs.PASID_CONTROL.write(status,16'h1,primary_id);
     read_compare(pf_cfg_regs.PASID_CONTROL,16'h1,16'h0001,result);

     pasid_prefix = $urandom();
     pasid_prefix[22] = 1'b1;
     pasid_prefix[21:20] = 2'b00;

     case (aer_error_exp)
         1: begin

                //--HQMV25--  pasid_tlp = get_tlp(ral.get_addr_val(primary_id, func_vf_bar[0].VF_TO_PF_MAILBOX[0]), Iosf::MRd64, .i_pasidtlp(pasid_prefix));
                //--HQMV30_TMP doesn't work because it's a legit address in PF --// pasid_tlp = get_tlp(ral.get_addr_val(primary_id, hqm_system_csr_regs.AW_SMON_TIMER[0]), Iosf::MRd64, .i_pasidtlp(pasid_prefix));
                pasid_tlp = get_tlp((ral.get_addr_val(primary_id, hqm_system_csr_regs.AW_SMON_TIMER[0]) + 'h80_0000_0000), Iosf::MRd64, .i_pasidtlp(pasid_prefix));

                header[31:24]   = 8'b0010_0000; // cmd_type = MRd64
                header[23:8]  = 8'h00;       // attr, tc, th etc. fields
                header[14]    = pasid_tlp.errorPresent;
                header[7:0] = pasid_tlp.length;//8'h01;      // len[7:0]
                header[63:48] = pasid_tlp.reqID[15:0];
                header[47:40] = pasid_tlp.tag;
                header[39:32] = {pasid_tlp.last_byte_en,pasid_tlp.first_byte_en} ;

                header[127:96] = pasid_tlp.address[31:0];
                header[95:64] = pasid_tlp.address[63:32];

                pasid_tlp_prefix[31:24] = 8'b1001_0001; 
                pasid_tlp_prefix[23:22] = pasid_prefix[21:20];//2'b00; //Privilege Mode Requested, Execute Requested
                pasid_tlp_prefix[21:20] = 2'b00; //Rsvd 
                pasid_tlp_prefix[19:0] = pasid_prefix[19:0]; 

                `ovm_info(get_full_name(),$sformatf("MRd64 with PASID & pasid_enable=0: pasid_tlp_prefix=0x%0h, pasid_prefix=0x%0x,  addr=0x%0x, header=0x%0h", pasid_tlp_prefix, pasid_prefix, pasid_tlp.address, header),OVM_MEDIUM)

                 send_tlp(pasid_tlp, .ur(1));
                 read_compare(pf_cfg_regs.PASID_CONTROL,16'h1,16'h0001,result);
                 `ovm_do_with(error_status_chk_seq, {func_no==0; test_induced_anfes==1'b1; test_induced_ced==1'b1; test_induced_urd==1'b1; test_induced_ur==1'b1; en_H_FP_check==1'b_1; exp_header_log == header; test_induced_tlppflogp==1; exp_tlp_prefix_log==pasid_tlp_prefix;}); // non-fatal unmask, anfes unmask
         end
         2: begin
                pasid_tlp = get_tlp(ral.get_addr_val(primary_id, hqm_msix_mem_regs.MSG_DATA[0]), Iosf::MWr64, .i_pasidtlp(pasid_prefix), .i_fill_data(1), .i_errorPresent(1));

                header[31:24]   = 8'b0110_0000; // cmd_type = MWr64
                header[23:8]  = 8'h00;       // attr, tc, th etc. fields
                header[14]    = pasid_tlp.errorPresent;
                header[7:0] = pasid_tlp.length;//8'h01;      // len[7:0]
                header[63:48] = pasid_tlp.reqID[15:0];
                header[47:40] = pasid_tlp.tag;
                header[39:32] = {pasid_tlp.last_byte_en,pasid_tlp.first_byte_en} ;
                header[127:96] = pasid_tlp.address[31:0];
                header[95:64] = pasid_tlp.address[63:32];

                pasid_tlp_prefix[31:24] = 8'b1001_0001; 
                pasid_tlp_prefix[23:22] = pasid_prefix[21:20];//2'b00; //Privilege Mode Requested, Execute Requested
                pasid_tlp_prefix[21:20] = 2'b00; //Rsvd 
                pasid_tlp_prefix[19:0] = pasid_prefix[19:0]; 

                `ovm_info(get_full_name(),$sformatf("MWr64 with PASID & pasid_enable=0: pasid_tlp_prefix=0x%0h, addr=0x%0x, header=0x%0h", pasid_tlp_prefix, pasid_tlp.address, header),OVM_MEDIUM)

                 send_tlp(pasid_tlp);
                 read_compare(pf_cfg_regs.PASID_CONTROL,16'h1,16'h0001,result);
                 `ovm_do_with(error_status_chk_seq, {func_no==0; test_induced_fed==1'b1; test_induced_dpe==1'b1; test_induced_ptlpr==1'b1; en_H_FP_check==1'b_1; exp_header_log == header; test_induced_tlppflogp==1; exp_tlp_prefix_log==pasid_tlp_prefix;}); // fatal unmask
         end
         0: begin
                // -- Enable PASID capability -- //
                pf_cfg_regs.PASID_CONTROL.write_fields(status,{"PASID_ENABLE"},{wr_val},primary_id,this,.sai(legal_sai));
                pf_cfg_regs.PASID_CONTROL.readx_fields(status,{"PASID_ENABLE"},{wr_val}, op_val,primary_id,.sai(legal_sai));

                // -- Read original values -- //
                reg1.read(status,_orig_reg1_data,primary_id,this,.sai(legal_sai));
                reg2.read(status,_orig_reg2_data_,primary_id,this,.sai(legal_sai));

                _new_reg1_data_ = _orig_reg1_data;
                _new_reg1_data_[0] = ~_orig_reg1_data[0];
                // -- Send MWr without PASID TLP prefix -- //
                send_wr(reg1, .with_pasid(0), .d(_new_reg1_data_));

                // -- Read chk updated value -- //
                read_compare(reg1,_new_reg1_data_,.result(rslt));

                // -- Send MWr with PASID TLP prefix and different value -- //
                send_wr(reg1, .with_pasid(1), .d(_orig_reg1_data));

                // -- Read chk updated value -- //
                read_compare(reg1,_orig_reg1_data,.result(rslt));

                // -- Send MWr with PASID TLP prefix and different value -- //
                send_wr(reg1, .with_pasid(1), .d(_new_reg1_data_));

                // -- Read chk updated value -- //
                read_compare(reg1,_new_reg1_data_,.result(rslt));

                // -- Write original value -- //
                reg1.write(status,_orig_reg1_data,primary_id,this,.sai(legal_sai));

// -           --------------------------------------------
// -           - Include once RTL fixed -- //
                // -- Send MWr without PASID TLP prefix -- //
                send_wr(reg2, .with_pasid(0), .d(_rand_reg2_data_));

                // -- Read chk updated value -- //
                read_compare(reg2,_rand_reg2_data_,.result(rslt));

                _new_reg2_data_ = _rand_reg2_data_ + 'h_f;
                // -- Send MWr with PASID TLP prefix and different value -- //
                send_wr(reg2, .with_pasid(1), .d(_new_reg2_data_));

                // -- Read chk updated value -- //
                read_compare(reg2,_new_reg2_data_,.result(rslt));

                // -- Send MWr without PASID TLP prefix -- //
                send_wr(reg2, .with_pasid(0), .d(_rand_reg2_data_));

                // -- Read chk updated value -- //
                read_compare(reg2,_rand_reg2_data_,.result(rslt));

                // -- Write original value -- //
                reg2.write(status,_orig_reg2_data_,primary_id,this,.sai(legal_sai));

                // -- Assuming pcie_init (sciov mode) is run before this seq -- //
                send_wr(pf_cfg_regs.DEVICE_COMMAND    , .d('h_6)); // -- Picked value as per init_seq -- //
               
                // -- Read compare Cfg space -- //
                read_compare(pf_cfg_regs.DEVICE_COMMAND    , 'h_6, 32'h_ffff,.result(rslt));
 
                // -- Send MRd with PASID TLP prefix and expect SC for it -- //
                send_rd(master_regs.CFG_DIAGNOSTIC_RESET_STATUS, .with_pasid(1), .ur(0));

                // -- Send MRd without PASID TLP prefix and expect SC for it -- //
                send_rd(master_regs.CFG_DIAGNOSTIC_RESET_STATUS, .with_pasid(0), .ur(0));
               
                send_rd(pf_cfg_regs.CACHE_LINE_SIZE,              .with_pasid(0), .ur(0));
                
                send_rd_wr(pf_cfg_regs.DEVICE_COMMAND);

                send_rd_wr(pf_cfg_regs.CACHE_LINE_SIZE);

             end
         3: begin
                 sla_ral_reg reg_name[10];
                 reg_name[0] = pf_cfg_regs.CACHE_LINE_SIZE; 
                 reg_name[1] = hqm_system_csr_regs.LDB_CQ_PASID[0]; 
                 reg_name[2] = hqm_sif_csr_regs.AW_SMON_TIMER[0]; 
                 reg_name[3] = hqm_msix_mem_regs.MSG_DATA[0]; 
                 reg_name[4] = hqm_msix_mem_regs.MSG_DATA[1]; 
                 reg_name[5] = hqm_msix_mem_regs.MSG_DATA[2]; 
                 reg_name[6] = hqm_msix_mem_regs.MSG_DATA[3]; 
                 reg_name[7] = hqm_msix_mem_regs.MSG_DATA[4]; 
                 reg_name[8] = hqm_msix_mem_regs.MSG_DATA[5]; 
                 reg_name[9] = hqm_msix_mem_regs.MSG_DATA[6]; 
                 //reg_name[9] = { }; 

                // Enable PASID capability
                pf_cfg_regs.PASID_CONTROL.write_fields(status,{"PASID_ENABLE"},{wr_val},primary_id,this,.sai(legal_sai));
                pf_cfg_regs.PASID_CONTROL.readx_fields(status,{"PASID_ENABLE"},{wr_val}, op_val,primary_id,.sai(legal_sai));
                        
                for(int i=0;i<100;i++) begin
                    sla_ral_reg rand_reg;
                    repeat (1) @(sla_tb_env::sys_clk_r); 
                    rand_reg = reg_name[$urandom_range(0, 9)];
                    ovm_report_info(get_full_name(), $psprintf("Read, write, read register"), OVM_LOW);
                    send_rd(rand_reg, .with_pasid(1), .ur(0));
                    rand_reg = reg_name[$urandom_range(0, 9)];
                    send_wr(rand_reg, .with_pasid(1), .d(_rand_reg2_data_));
                    rand_reg = reg_name[$urandom_range(0, 9)];
                    send_rd(rand_reg, .with_pasid(1), .ur(0));
                end
             end

         endcase

         wait fork;
  endtask
 
endclass

`endif // -- HQM_PASID_ENABLED_SEQ__SV
