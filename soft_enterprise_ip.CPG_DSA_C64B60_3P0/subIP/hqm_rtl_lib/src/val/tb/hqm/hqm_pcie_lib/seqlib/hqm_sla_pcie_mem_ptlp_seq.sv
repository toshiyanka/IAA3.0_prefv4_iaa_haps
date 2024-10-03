`ifndef HQM_SLA_PCIE_MEM_PTLP_SEQ
`define HQM_SLA_PCIE_MEM_PTLP_SEQ

import lvm_common_pkg::*;


class hqm_sla_pcie_mem_ptlp_seq extends hqm_sla_pcie_base_seq; 
  `ovm_sequence_utils(hqm_sla_pcie_mem_ptlp_seq,sla_sequencer)

  rand bit Ep = 1'b0;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq         mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq         mem_write_seq;
  hqm_sla_pcie_eot_checks_sequence                       error_status_chk_seq;

  rand bit reporting_en;

  // ---------------------------------------------------------------
  // -- Event pool
  // ---------------------------------------------------------------

  ovm_event_pool glbl_pool;
  ovm_event      exp_ep_fatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      exp_ep_nfatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      exp_ep_corr_msg[`MAX_NO_OF_VFS+1];
  ovm_event      obs_ep_nfatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      obs_ep_fatal_msg[`MAX_NO_OF_VFS+1];


  constraint _report_en_ { soft reporting_en == 1'b1; }
  constraint deflt_Ep { soft Ep == 1'b0; }

  function new(string name = "hqm_sla_pcie_mem_ptlp_seq");
    super.new(name); 

    glbl_pool        = ovm_event_pool::get_global_pool();

    // -- Create/get handles to msi/msix_vector detected triggering -- // 
    for(int i=0; i<(`MAX_NO_OF_VFS+1); i++) begin
      exp_ep_nfatal_msg[i]   = glbl_pool.get($psprintf("exp_ep_nfatal_msg_%0d",i));
      exp_ep_fatal_msg[i]    = glbl_pool.get($psprintf("exp_ep_fatal_msg_%0d",i));
      exp_ep_corr_msg[i]     = glbl_pool.get($psprintf("exp_ep_corr_msg_%0d",i));
      obs_ep_nfatal_msg[i]   = glbl_pool.get($psprintf("obs_ep_nfatal_msg_%0d",i));
      obs_ep_fatal_msg[i]    = glbl_pool.get($psprintf("obs_ep_fatal_msg_%0d",i));
    end

    `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
    `sla_assert($cast(pf_cfg_regs,          ral.find_file("hqm_pf_cfg_i")),     ("Unable to get handle to pf_cfg_regs."))

  endfunction

  virtual task body();
    sla_ral_addr_t     ptlp_inj_addr;
    int                sev_mask_val;
    bit     [4:0]      first_pointer = 5'b0;
    bit                urd = 1'b0;
    bit     [127:0]    header;
    bit     [31:0]     write_data;
    logic   [4:0]      func_num=0;
    
    // bits ep = 1, length[7:0] = 1, {fmt,type} = 3'b0x0,5'b00000 = 0x40  
    header = 128'h0007000c_00000000_0000000f_40004001;
    write_data =$urandom();
    Ep=1;
    if($test$plusargs("HQM_PCIE_ERROR_MSG_FUNC_NUM")) begin $value$plusargs("HQM_PCIE_ERROR_MSG_FUNC_NUM=%0d",func_num); end

        ptlp_inj_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),hqm_msix_mem_regs.MSG_DATA[0]);
        hqm_msix_mem_regs.MSG_DATA[0].write(status, write_data[31:0], primary_id);

    `ovm_info(get_full_name(),$psprintf("hqm_sla_pcie_mem_ptlp_seq: valid normal write with random value write_data=%0h, at address ptlp_inj_addr=%0h", write_data, ptlp_inj_addr),OVM_LOW)

    write_data =$urandom();
    `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == ptlp_inj_addr; iosf_data.size() == 1; iosf_data[0] == write_data;iosf_EP==1;})

    hqm_msix_mem_regs.MSG_DATA[0].read(status, rd_val, primary_id);
    `ovm_info(get_full_name(),$psprintf("hqm_sla_pcie_mem_ptlp_seq: poison random write at ptlp_inj_addr=%0h, write_data=%0h, rd_val=%0h",ptlp_inj_addr, write_data, rd_val),OVM_LOW)

    if (rd_val[31:0]==write_data[31:0])
        `ovm_error(get_full_name(), $psprintf("Posion write value took effect which is incorrect: write_data=%0h, rd_val=%0h", write_data, rd_val))

    if (!p_sequencer.get_config_int("sev_mask_val", sev_mask_val))
        sev_mask_val = 0;


    `ovm_info(get_full_name(),$psprintf("tag field: mem_write_seq.iosf_tag = %h, sev_mask_val = %d, rd_val = %h", mem_write_seq.iosf_tag, sev_mask_val, rd_val),OVM_LOW)
 
    header[28:24] = 5'b00000; // Type
    if (ptlp_inj_addr[63:32]==0) begin
      header[95:64] = ptlp_inj_addr[31:0];
      header[31:29] = 3'b010; //Fmt -- MWr -> 3'b_011 -- 64 bit, 3'b010 -- 32bit
    end
    else begin
      header[127:96] = ptlp_inj_addr[31:0];
      header[95:64] = ptlp_inj_addr[63:32];
      header[31:29] = 3'b011; //Fmt -- MWr -> 3'b_011 -- 64 bit, 3'b010 -- 32bit
    end
    
    header[23:8] = 16'h0000;
    header[7:0] = 1;// Length
    header[47:40] = (mem_write_seq.iosf_tag[7:0] - 1); // Tag
    header[39:36] = 4'h0; //LBE
    header[35:32] = 4'hf; // FBE
    header[23] = mem_write_seq.iosf_tag[9]; // Tag
    header[19] = mem_write_seq.iosf_tag[8]; // Tag
    header[14] = 1;// Ep bit
    case (sev_mask_val)
        0: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==1'b_1;test_induced_anfes==1'b_1; test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_0; en_H_FP_check==1'b_0; test_induced_fep==5'b_11110; /*exp_header_log == header;*/}); //non-fatal unmask 
                  // -- if(reporting_en) exp_ep_nfatal_msg[func_num].trigger();
               end 
        1: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_fed==1'b_1;test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_1; en_H_FP_check==1'b_1; exp_header_log == header; }); // fatal unmask
              if(reporting_en) exp_ep_fatal_msg[func_num].trigger();
           end 
        2: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==1'b_1;test_induced_anfes==1'b_1; test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_0; en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); //non-fatal mask 
           end 
        3: begin 
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_fed==1'b_1;test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_1;en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); // fatal mask
           end
        4: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==1'b_1;test_induced_anfes==1'b_1; test_induced_dpe==1'b_1; test_induced_ptlpr==1'b_1; en_H_FP_check==1'b_1; exp_header_log == header;}); //non-fatal unmask anfes unmask 
              if(reporting_en) exp_ep_corr_msg[func_num].trigger();
           end 
    endcase      

  endtask : body
endclass : hqm_sla_pcie_mem_ptlp_seq

`endif
