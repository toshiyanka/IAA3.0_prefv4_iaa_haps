`ifndef HQM_SLA_PCIE_MEM_MTLP_4KB_CROSS_SEQ
`define HQM_SLA_PCIE_MEM_MTLP_4KB_CROSS_SEQ

import lvm_common_pkg::*;


class hqm_sla_pcie_mem_mtlp_4kb_cross_seq extends hqm_sla_pcie_base_seq; 
  `ovm_sequence_utils(hqm_sla_pcie_mem_mtlp_4kb_cross_seq,sla_sequencer)
  rand bit Ep = 1'b0;
  hqm_tb_sequences_pkg::hqm_iosf_prim_memory_rd_seq        mem_read_seq;
  //hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_badtxn_seq    mem_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_rqid_seq      mem_write_seq;
  hqm_sla_pcie_eot_checks_sequence                         error_status_chk_seq;
  hqm_tb_cfg_file_mode_seq                                 i_hcw_file_mode_seq;

  constraint deflt_Ep { soft Ep == 1'b0; }

  function new(string name = "hqm_sla_pcie_mem_mtlp_4kb_cross_seq");
    super.new(name); 
  endfunction

  virtual task body();
    sla_ral_addr_t _mtlp_inj_addr_;
    sla_ral_data_t loc_data[$];
    int sev_mask_val;
    bit [4:0] first_pointer = 5'b0;
    bit urd = 1'b0;
    bit [127:0] header = 128'h00000000_00000000_0000690f_60000000;
    bit [31:0] rdata0, rdata1;

    // Cross write in PP system page boundary
    pf_cfg_regs.FUNC_BAR_U.read(status,rd_val,primary_id,this,.sai(1));
    _mtlp_inj_addr_[63:32] = rd_val[31:0];
    _mtlp_inj_addr_[31:0]  = 'h_0200_0000 - 'h_4;

    loc_data.delete();
    loc_data.push_back(32'h0000000F);
    loc_data.push_back(32'h00000003);
    loc_data.push_back(32'h54597700);

    // 4kb boundary cross write
    `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _mtlp_inj_addr_; iosf_data.size() == loc_data.size(); foreach(iosf_data[i]) { iosf_data[i] == loc_data[i] };})

    // Valid HCWs after cross write
    i_hcw_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hcw_file_mode_seq");
    i_hcw_file_mode_seq.set_cfg("HQM_EXTRA_DATA_PHASE_HCW1", 1'b0);
    i_hcw_file_mode_seq.start(get_sequencer());

    if (!p_sequencer.get_config_int("sev_mask_val", sev_mask_val))
        sev_mask_val = 0;
    `ovm_info(get_full_name(),$psprintf("tag field: mem_write_seq.iosf_tag = %h, sev_mask_val = %d, ", mem_write_seq.iosf_tag, sev_mask_val),OVM_LOW)
 
    header[28:24] = 5'b00000; // Type
    header[31:29] = 3'b010; //Fmt
    if (_mtlp_inj_addr_[63:32]==0) begin
      header[95:64] = _mtlp_inj_addr_[31:0];
    end
    else begin
      header[127:96] = _mtlp_inj_addr_[31:0];
      header[95:64] = _mtlp_inj_addr_[63:32];
    end
    
    header[23:8] = 16'h0000;
    header[47:40] = (mem_write_seq.iosf_tag[7:0] - 1); // Tag
    header[39:36] = (mem_write_seq.iosf_data.size() > 8) ? 4'hf : 4'h0; //LBE
    header[35:32] = 4'hf; // FBE
    header[23] = mem_write_seq.iosf_tag[9]; // Tag
    header[19] = mem_write_seq.iosf_tag[8]; // Tag
    header[14]  = Ep;// Ep bit
    header[7:0] = mem_write_seq.iosf_data.size();// Length

    case (sev_mask_val)
        0: begin
              `ovm_do_with(error_status_chk_seq, {func_no==0;test_induced_ned==1'b_1; test_induced_mtlp==1'b_1; test_induced_anfes==urd;en_H_FP_check==1'b_1; exp_header_log == header; test_induced_fep==first_pointer;}); //non-fatal unmask 
           end 
        1: begin 
              `ovm_do_with(error_status_chk_seq, {func_no==0;test_induced_fed==1'b_1; test_induced_mtlp==1'b_1;en_H_FP_check==1'b_1; exp_header_log == header;test_induced_fep==first_pointer;}); // fatal unmask
           end 
        2: begin
              `ovm_do_with(error_status_chk_seq, {func_no==0;test_induced_ned==1'b_1; test_induced_mtlp==1'b_1; test_induced_anfes==urd;en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); //non-fatal mask 
           end 
        3: begin 
              `ovm_do_with(error_status_chk_seq, {func_no==0;test_induced_fed==1'b_1; test_induced_mtlp==1'b_1;en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); // fatal mask
           end
    endcase      

  endtask : body
endclass : hqm_sla_pcie_mem_mtlp_4kb_cross_seq

`endif
