`ifndef HQM_IOSF_PRIM_BASE_SEQ__SV
`define HQM_IOSF_PRIM_BASE_SEQ__SV


class hqm_iosf_prim_base_seq extends ovm_sequence;

  `ovm_sequence_utils(hqm_iosf_prim_base_seq, sla_sequencer);

  rand logic [63:0]     iosf_addr_l;
  rand Iosf::data_t     iosf_data_l[];
  rand logic [7:0]      iosf_sai_l;
  rand logic            iosf_exp_error_l;
  rand logic			      iosf_EP_l;
  rand logic [22:0]     iosf_pasidtlp_l;
  rand bit [31:0]       ecrc_l;             
  rand Iosf::iosf_cmd_t cmd;
  rand bit              drivecmdparityerr_l;
  rand int              iosf_wait_for_completion_l; 

  constraint deflt_c {
        soft iosf_sai_l == 8'h03;
        soft iosf_exp_error_l == 1'b0;
        soft iosf_EP_l		== 1'b0;
        soft iosf_pasidtlp_l == 23'h00;
        soft ecrc_l == 32'h0000_0000;
        soft drivecmdparityerr_l == 1'b0;
        soft iosf_wait_for_completion_l == 1;
  }

  function new(string name = "hqm_iosf_prim_base_seq");
      super.new(name);
  endfunction: new

  hqm_iosf_prim_mem_rd_seq       mem_read_seq;
  hqm_iosf_prim_mem_wr_seq       mem_write_seq;
  hqm_iosf_prim_cfg_rd_seq       cfg_read_seq;
  hqm_iosf_prim_cfg_wr_seq       cfg_write_seq;
  hqm_iosf_prim_np_mem_wr_seq    np_mem_write_seq;


  virtual task body();

    `ovm_info(get_full_name(),$psprintf("Sending iosf_prim txn with: cmd(0x%0x), address(0x%0x), pasidtlp(0x%0x), sai(0x%0x), ep(0x%0x), exp_err(0x%0x)", cmd, iosf_addr_l, iosf_pasidtlp_l, iosf_sai_l, iosf_EP_l, iosf_exp_error_l),OVM_LOW);

    case (cmd)
      Iosf::MRd32,Iosf::MRd64:  begin
        `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==iosf_addr_l; iosf_sai==iosf_sai_l; ep==iosf_EP_l; iosf_exp_error==iosf_exp_error_l; iosf_pasidtlp==iosf_pasidtlp_l;ecrc==ecrc_l;iosf_wait_for_completion==iosf_wait_for_completion_l;}); //iosf_tag -- not declared as rand 
                  iosf_data_l = new[1];
                  iosf_data_l[0] = mem_read_seq.iosf_data;
                end
      Iosf::MWr32,Iosf::MWr64:  begin
        `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==iosf_addr_l; iosf_data.size() == iosf_data_l.size(); foreach(iosf_data_l[i]) {iosf_data[i]==iosf_data_l[i]}; iosf_sai==iosf_sai_l; iosf_EP==iosf_EP_l; iosf_pasidtlp==iosf_pasidtlp_l;ecrc==ecrc_l;});
                end
      Iosf::NPMWr32,Iosf::NPMWr64:  begin
        `ovm_do_on_with(np_mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==iosf_addr_l; iosf_data.size() == iosf_data_l.size(); foreach(iosf_data_l[i]) {iosf_data[i]==iosf_data_l[i]}; iosf_sai==iosf_sai_l; iosf_EP==iosf_EP_l; iosf_pasidtlp==iosf_pasidtlp_l;ecrc==ecrc_l;});
                end
      Iosf::CfgRd0:  begin
        `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==iosf_addr_l; iosf_sai==iosf_sai_l; iosf_exp_error==iosf_exp_error_l; iosf_pasidtlp==iosf_pasidtlp_l;ecrc==ecrc_l;iosf_wait_for_completion==iosf_wait_for_completion_l;});
                  iosf_data_l = new[1];
                  iosf_data_l[0] = cfg_read_seq.iosf_data;
                end
      Iosf::CfgWr0:  begin
        `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==iosf_addr_l; iosf_data==iosf_data_l[0]; iosf_sai==iosf_sai_l; iosf_EP==iosf_EP_l; iosf_exp_error==iosf_exp_error_l; iosf_pasidtlp==iosf_pasidtlp_l;ecrc==ecrc_l;drivecmdparityerr==drivecmdparityerr_l;iosf_wait_for_completion==iosf_wait_for_completion_l;});
                end
      default:  begin `ovm_error(get_full_name(),$psprintf("Test generation error !! No supported "))
                end
    endcase

  endtask: body

endclass : hqm_iosf_prim_base_seq

`endif
