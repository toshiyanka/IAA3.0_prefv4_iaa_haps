`ifndef HQM_SLA_PCIE_CFG_BADPARITY_SEQ
`define HQM_SLA_PCIE_CFG_BADPARITY_SEQ

import lvm_common_pkg::*;


class hqm_sla_pcie_cfg_badparity_seq extends ovm_sequence; 
  `ovm_sequence_utils(hqm_sla_pcie_cfg_badparity_seq,sla_sequencer)

  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_wr_badparity_seq cfg_write_badparity_seq;
  hqm_sla_pcie_eot_checks_sequence                         error_status_chk_seq;
  ovm_event_pool glbl_pool;
  sla_ral_env           ral;
  hqm_pf_cfg_bridge_file                pf_cfg_regs;
  sla_ral_access_path_t primary_id, access;

  function new(string name = "hqm_sla_pcie_cfg_badparity_seq");
    super.new(name); 
    glbl_pool      = ovm_event_pool::get_global_pool();
    `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
    `sla_assert($cast(pf_cfg_regs,          ral.find_file("hqm_pf_cfg_i")),     ("Unable to get handle to pf_cfg_regs."))

    primary_id = sla_iosf_pri_reg_lib_pkg::get_src_type();

  endfunction

  virtual task body();
    sla_ral_addr_t _badparity_inj_addr_;
    sla_ral_data_t rd_val;
    sla_status_t          status;
    logic [4:0]  func_num=0;
    logic [7:0]  hqm_func_base_strap_arg;
    bit          hqm_is_reg_ep_arg;
    int sev_mask_val;
    bit [31:0] cache_line_default_val;
    bit [31:0]      write_data;


    bit [127:0] header = 128'h0007000c_00000000_0000000f_44004001;// bits ep = 1, length[7:0] = 1, {fmt,type} = 02 (as per steve mail) -- Should be actual  
    write_data =$urandom();
    hqm_is_reg_ep_arg = '0; $value$plusargs("hqm_is_reg_ep=%d",hqm_is_reg_ep_arg);

    //if(hqm_is_reg_ep_arg) begin hqm_func_base_strap_arg = 8'h00; end       // EP Base function number
    //else                  begin hqm_func_base_strap_arg = `HQM_FUNC_BASE_STRAP;           // RCIEP Base function number
    //end


    if($test$plusargs("HQM_PCIE_CFG_ERR_FUNC_NO")) begin $value$plusargs("HQM_PCIE_CFG_ERR_FUNC_NO=%0d",func_num); end 

    if (func_num == 0) begin
      _badparity_inj_addr_ = ral.get_addr_val(primary_id, pf_cfg_regs.CACHE_LINE_SIZE);
	    pf_cfg_regs.CACHE_LINE_SIZE.write(status,write_data[7:0],primary_id);
	    pf_cfg_regs.CACHE_LINE_SIZE.read(status,rd_val,primary_id);
      cache_line_default_val = rd_val[31:0];
    end  
  
    `ovm_info(get_full_name(),$psprintf("Starting hqm_sla_pcie_cfg_badparity_seq with: _badparity_inj_addr_ (0x%0x); func_num (0x%0x) and hqm_func_base_strap_arg (0x%0x), bus_num (0x%0x)",_badparity_inj_addr_,func_num,hqm_func_base_strap_arg,  _badparity_inj_addr_[31:24]),OVM_LOW)
    `ovm_do_on_with(cfg_write_badparity_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == _badparity_inj_addr_; iosf_data == 32'hf; m_driveBadCmdParity == 1'b0; m_driveBadDataParity == 1'b1; m_driveBadDataParityCycle == 1'b0; m_driveBadDataParityPct == 32'h00000064;})


    if (!p_sequencer.get_config_int("sev_mask_val", sev_mask_val))
        sev_mask_val = 0;
    `ovm_info(get_full_name(),$psprintf("tag field: cfg_write_badparity_seq.iosf_tag = %h, sev_mask_val = %d", cfg_write_badparity_seq.iosf_tag, sev_mask_val),OVM_LOW)

    header[31:24]   = 8'h44;
    header[47:40]   = (cfg_write_badparity_seq.iosf_tag[7:0] ); 
    header[23]      = (cfg_write_badparity_seq.iosf_tag[9]);
    header[19]      = (cfg_write_badparity_seq.iosf_tag[8]);
    header[95:64]   = _badparity_inj_addr_[31:0]; 
    header[127:96] = _badparity_inj_addr_[63:32]; 

    case (sev_mask_val)
        0: begin 
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==1'b_1;test_induced_anfes==1'b_1; test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_0; en_H_FP_check==1'b_0; test_induced_fep==5'b_11110; /*exp_header_log == header;*/}); //non-fatal unmask 
           end 
        1: begin 
              wait_ns_clk(1000);
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_fed==1'b_1;test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_1;test_induced_sse==1'b_1;en_H_FP_check==1'b_1; exp_header_log == header;}); // fatal unmask
           end 
        2: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==1'b_1;test_induced_anfes==1'b_1; test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_0; en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); //non-fatal mask 
           end 
        3: begin 
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_fed==1'b_1;test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_1;en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); // fatal mask
           end
        4: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==1'b_1;test_induced_anfes==1'b_1; test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_1; en_H_FP_check==1'b_1; exp_header_log == header;}); //non-fatal unmask anfes unmask 
           end 
    endcase      
    if (func_num == 0) 
	    pf_cfg_regs.CACHE_LINE_SIZE.read(status,rd_val,primary_id,this,.sai(1));
    else 
    //read_compare(pf_cfg_regs.AER_CAP_CONTROL,32'h0000_000c,32'hffff_ffff,rslt);
    if (rd_val[31:0] != cache_line_default_val) 
      `ovm_error(get_full_name(), $psprintf("Register check failed for reg cache_line rd_val = %h, cache_line_default_val = %h",rd_val[31:0],cache_line_default_val))
    else     
      `ovm_info(get_full_name(),$psprintf("Register check passed for reg cache_line rd_val = %h, cache_line_default_val = %h",rd_val[31:0],cache_line_default_val),OVM_LOW)

  endtask : body

  task wait_ns_clk(int ticks=10);
   repeat(ticks) begin @(sla_tb_env::sys_clk_r); end
  endtask

endclass : hqm_sla_pcie_cfg_badparity_seq

`endif
