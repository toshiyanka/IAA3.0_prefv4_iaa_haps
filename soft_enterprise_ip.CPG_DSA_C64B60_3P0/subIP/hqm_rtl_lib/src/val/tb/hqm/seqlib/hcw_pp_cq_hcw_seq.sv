import hqm_tb_cfg_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

class hcw_pp_cq_hcw_seq extends sla_sequence_base;

  `ovm_sequence_utils(hcw_pp_cq_hcw_seq, sla_sequencer)

  hqm_tb_cfg            i_hqm_cfg;

  hqm_pp_cq_base_seq    pp_cq_seq;

  function new(string name = "hcw_pp_cq_hcw_seq");
    super.new(name);
  endfunction

  virtual task body();
    sla_ral_env         ral;
    sla_ral_reg         my_reg;
    sla_ral_data_t      ral_data;
    logic [63:0]        cq_addr_val;
    int                 num_hcw_gen;
    ovm_object          o_tmp;

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg %s not consistent with hqm_tb_cfg type", o_tmp.sprint()));
    end


    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal("CFG", "Unable to get RAL handle");
    end    

    cq_addr_val = 64'h0000_0000_0200_0000;

    my_reg   = ral.find_reg_by_file_name("dir_cq_addr_u[0]", "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[63:32] = ral_data[31:0];

    my_reg   = ral.find_reg_by_file_name("dir_cq_addr_l[0]", "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[31:6] = ral_data[31:6];
    ovm_report_info(get_full_name(), $psprintf("hcw_pp_cq_hcw_seq:  read cq_addr_u/l to get cq_addr_val=0x%0x",  cq_addr_val), OVM_LOW);

    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- the above cq_addr_val read from CQ_ADDR ral is virtual address
    //-- to get physical address: cq_addr_val=i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in);  
    //----------------------------------
    if(i_hqm_cfg.ats_enabled==1) begin
        cq_addr_val = i_hqm_cfg.get_cq_hpa(0, 0); 
        ovm_report_info(get_full_name(), $psprintf("hcw_pp_cq_hcw_seq: is_ldb=0 pp_cq_num_in=0 get cq_addr_val=0x%0x (physical address when i_hqm_cfg.ats_enabled==1)",  cq_addr_val), OVM_LOW);
    end  


    `ovm_create(pp_cq_seq)
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
                     pp_cq_num            == 0;              // Producer Port/Consumer Queue number
                     pp_cq_type           == hqm_pp_cq_base_seq::IS_DIR;             // Producer Port/Consumer Queue number

                     cq_depth             == 1024;

                     queue_list.size()            == 1;

                     hcw_enqueue_batch_min        == 1;  // Minimum number of HCWs to send as a batch (1-4)
                     hcw_enqueue_batch_max        == 1;  // Maximum number of HCWs to send as a batch (1-4)

                     cq_addr                      == cq_addr_val;

                     cq_poll_interval             == 1;
                   } ) begin
      `ovm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end

    num_hcw_gen = 1;
    $value$plusargs({$psprintf("PP%0d_NUM_HCW",pp_cq_seq.pp_cq_num),"=%d"}, num_hcw_gen);

    pp_cq_seq.queue_list[0].num_hcw                     = num_hcw_gen;
    pp_cq_seq.queue_list[0].qid                         = 0;
    pp_cq_seq.queue_list[0].qtype                       = QDIR;
    pp_cq_seq.queue_list[0].qpri_weight[0]              = 1;
    pp_cq_seq.queue_list[0].hcw_delay_min               = 1;
    pp_cq_seq.queue_list[0].hcw_delay_max               = 1;
    pp_cq_seq.queue_list[0].comp_flow                   = 1;
    pp_cq_seq.queue_list[0].cq_token_return_flow        = 1;
    pp_cq_seq.queue_list[0].illegal_hcw_gen_mode        = hqm_pp_cq_base_seq::NO_ILLEGAL;
    pp_cq_seq.queue_list[0].hcw_delay_qe_only           = 1'b1;

    finish_item(pp_cq_seq);

    super.body();
  endtask

endclass
