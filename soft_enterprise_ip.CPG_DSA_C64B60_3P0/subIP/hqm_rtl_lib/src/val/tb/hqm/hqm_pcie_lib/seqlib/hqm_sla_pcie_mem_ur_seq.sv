`ifndef HQM_SLA_PCIE_MEM_UR_SEQUENCE_
`define HQM_SLA_PCIE_MEM_UR_SEQUENCE_

class hqm_sla_pcie_mem_ur_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_mem_ur_seq,sla_sequencer)
  rand bit Ep = 1'b0;
 
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_rd_seq;
  hqm_tb_sequences_pkg::hqm_iosf_unsupport_memory_seq   unsupp_mem_rd_seq;
  hqm_sla_pcie_eot_checks_sequence                      error_status_chk_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_badtxn_seq mem_wr_seq;
  hqm_sla_pcie_init_seq                                 hqm_init_seq;
  constraint deflt_Ep { soft Ep == 1'b0; }

  function new(string name = "hqm_sla_pcie_mem_ur_seq");
    super.new(name);
  endfunction

  virtual task body();
    sla_ral_reg       my_reg;
    sla_ral_data_t    ral_data;
    sla_ral_addr_t    _ur_inj_addr_='h_0;
    logic [7:0]  func_num=0;
    int sev_mask_val;
    bit [127:0] header = 128'h00000000_00000000_0000690f_00000001;
                         //128'h{address[31:2],2’b00}_{address[63:32}__0f{tag}0000_01000020;      

    if($test$plusargs("HQM_PCIE_MEM_UR_ERR_FUNC_NO")) begin $value$plusargs("HQM_PCIE_MEM_UR_ERR_FUNC_NO=%0d",func_num); end 

        // -- master_regs.CFG_DIAGNOSTIC_RESET_STATUS.read(status,rd_val,primary_id,this,.ignore_access_error(SLA_TRUE)); 
      _ur_inj_addr_ = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),master_regs.CFG_DIAGNOSTIC_RESET_STATUS); 
        // -- `ovm_do_on_with(mem_wr_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _ur_inj_addr_; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_length == 35;})
      `ovm_do_on_with(unsupp_mem_rd_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _ur_inj_addr_; iosf_data == 32'h0; iosf_exp_error == 1'b_1; iosf_cmd64 == Iosf::MRdLk64; ep==Ep;})
        wait_ns_clk(2000);
        header[47:40] = (unsupp_mem_rd_seq.iosf_tag - 1);
        header[31:24] = 8'b0000_0110;

    header[14] = Ep;
    `ovm_info(get_full_name(),$psprintf("Starting hqm_sla_pcie_mem_ur_seq with: _ur_inj_addr_ (0x%0x); func_num (0x%0x), Ep %d",_ur_inj_addr_,func_num, Ep),OVM_LOW)

    if (!p_sequencer.get_config_int("sev_mask_val", sev_mask_val))  sev_mask_val = 0;
    `ovm_info(get_full_name(),$psprintf("tag field in header: iosf_tag = %h, sev_mask_val = %d", header[55:48], sev_mask_val),OVM_LOW)
    header[127:96] = _ur_inj_addr_[31:0];
    header[95:64] = _ur_inj_addr_[63:32];
    if(|func_num) header = 128'h_0;
    case (sev_mask_val)
        0: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==(func_num==0 && 1'b_1); test_induced_urd==(func_num==0 && 1'b_1);test_induced_anfes==(func_num==0 && 1'b_1); test_induced_ur==1'b_0; en_H_FP_check==1'b_0; test_induced_fep==5'b_11110; /*exp_header_log == header;*/}); //non-fatal unmask 
           end 
        1: begin 
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_fed==(func_num==0 && 1'b_1); test_induced_urd==(func_num==0 && 1'b_1); test_induced_ur==(func_num==0 && 1'b_1);en_H_FP_check==1'b_1; exp_header_log == header; }); // fatal unmask
           end 
        2: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==(func_num==0 && 1'b_1); test_induced_urd==(func_num==0 && 1'b_1);test_induced_anfes==(func_num==0 && 1'b_1); test_induced_ur==1'b_0; en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); //non-fatal mask 
           end 
        3: begin 
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_fed==(func_num==0 && 1'b_1); test_induced_urd==(func_num==0 && 1'b_1); test_induced_ur==(func_num==0 && 1'b_1);en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); // fatal mask
           end
        4: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==(func_num==0 && 1'b_1); test_induced_urd==(func_num==0 && 1'b_1);test_induced_anfes==(func_num==0 && 1'b_1); test_induced_ur==(func_num==0 && 1'b_1); en_H_FP_check==1'b_1; exp_header_log == header;}); //non-fatal unmask 
           end 

    endcase      

  endtask

endclass

`endif
