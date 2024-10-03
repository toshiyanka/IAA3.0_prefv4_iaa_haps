import hcw_transaction_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

class hcw_perf_dir_ldb_test1_hcw_seq extends hqm_base_seq; //sla_sequence_base;

  `ovm_sequence_utils(hcw_perf_dir_ldb_test1_hcw_seq, sla_sequencer)

  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;
  hqm_cfg                       i_hqm_cfg;

  hqm_pp_cq_base_seq            dir_pp_cq_0_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_1_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_2_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_3_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_4_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_5_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_6_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_7_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_8_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_9_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_10_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_11_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_12_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_13_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_14_seq;
  hqm_pp_cq_base_seq            dir_pp_cq_15_seq;

  hqm_pp_cq_base_seq            ldb_pp_cq_0_seq;
  hqm_pp_cq_base_seq            ldb_pp_cq_1_seq;
  hqm_pp_cq_base_seq            ldb_pp_cq_2_seq;
  hqm_pp_cq_base_seq            ldb_pp_cq_3_seq;
  hqm_pp_cq_base_seq            ldb_pp_cq_4_seq;
  hqm_pp_cq_base_seq            ldb_pp_cq_5_seq;
  hqm_pp_cq_base_seq            ldb_pp_cq_6_seq;
  hqm_pp_cq_base_seq            ldb_pp_cq_7_seq;

  int                           has_hqm_trf_hcwnum;
  int                           has_hqm_trf_hcwnum1;
  int                           has_hqm_trf_hcwnum2;
  int                           has_hqm_trf_waitnum;

  function new(string name = "hcw_perf_dir_ldb_test1_hcw_seq");
    super.new(name);

    has_hqm_trf_waitnum=300;
    $value$plusargs("HAS_HQM_TRF_WAITNUM=%d",has_hqm_trf_waitnum);
    ovm_report_info(get_type_name(),$psprintf("hcw_perf_dir_ldb_test1_hcw_seq setting: has_hqm_trf_waitnum=%0d ", has_hqm_trf_waitnum ), OVM_LOW);

    has_hqm_trf_hcwnum1=1024;
    $value$plusargs("HAS_HQM_TRF_HCWNUM_1=%d",has_hqm_trf_hcwnum1);
    ovm_report_info(get_type_name(),$psprintf("hcw_perf_dir_ldb_test1_hcw_seq setting: has_hqm_trf_hcwnum1=%0d ", has_hqm_trf_hcwnum1 ), OVM_LOW);

    has_hqm_trf_hcwnum2=3096;
    $value$plusargs("HAS_HQM_TRF_HCWNUM_2=%d",has_hqm_trf_hcwnum2);
    ovm_report_info(get_type_name(),$psprintf("hcw_perf_dir_ldb_test1_hcw_seq setting: has_hqm_trf_hcwnum2=%0d ", has_hqm_trf_hcwnum2 ), OVM_LOW);


  endfunction



  virtual task body();
    ovm_object  o_tmp;

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
    end 

    //-----------------------------
    //-- get i_hcw_scoreboard
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hcw_scoreboard", o_tmp)) begin
       ovm_report_info(get_full_name(), "hcw_perf_dir_ldb_test1_hcw_seq: Unable to find i_hcw_scoreboard object", OVM_LOW);
       i_hcw_scoreboard = null;
    end else begin
       if (!$cast(i_hcw_scoreboard, o_tmp)) begin
         ovm_report_fatal(get_full_name(), $psprintf("Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
       end
    end

    //-----------------------------
    //-- CQ disable tasks 
    //-----------------------------
    if ($test$plusargs("HAS_HQM_TRF_CQ_CTRL")) begin
       if(i_hqm_cfg.hqm_trf_cq_ctrl_st == 0)      has_hqm_trf_hcwnum = has_hqm_trf_hcwnum1;
       else if(i_hqm_cfg.hqm_trf_cq_ctrl_st == 1) has_hqm_trf_hcwnum = has_hqm_trf_hcwnum2;

       ovm_report_info(get_full_name(), $psprintf("Main_flow_HAS_HQM_CQ_CTRL_S0: Disable CQ, current total_enq_count=%0d total_sch_count=%0d has_hqm_trf_hcwnum=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, has_hqm_trf_hcwnum), OVM_LOW);
       for(int k=0; k<16; k++) hqm_cfg_cq_disable_task(0, k, 1);
       for(int k=0; k<8; k++) hqm_cfg_cq_disable_task(1, k, 1);
       ovm_report_info(get_full_name(), $psprintf("Main_flow_HAS_HQM_CQ_CTRL_S1: Disable CQ Done, current total_enq_count=%0d total_sch_count=%0d has_hqm_trf_hcwnum=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, has_hqm_trf_hcwnum), OVM_LOW);
     end

    //-----------------------------
    //-- tasks 
    //-----------------------------
    fork
      begin
        start_pp_cq(0,0,0,QDIR, 1,32,dir_pp_cq_0_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_0: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #2ns;
        start_pp_cq(0,1,1,QDIR, 1,32,dir_pp_cq_1_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_1: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #4ns;
        start_pp_cq(0,2,2,QDIR, 1,32,dir_pp_cq_2_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_2: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #6ns;
        start_pp_cq(0,3,3,QDIR, 1,32,dir_pp_cq_3_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_3: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #8ns;
        start_pp_cq(0,4,4,QDIR, 1,32,dir_pp_cq_4_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_4: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #10ns;
        start_pp_cq(0,5,5,QDIR, 1,32,dir_pp_cq_5_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_5: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #12ns;
        start_pp_cq(0,6,6,QDIR, 1,32,dir_pp_cq_6_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_6: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #14ns;
        start_pp_cq(0,7,7,QDIR, 1,32,dir_pp_cq_7_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_7: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #16ns;
        start_pp_cq(0,8,8,QDIR, 1,32,dir_pp_cq_8_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_8: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #18ns;
        start_pp_cq(0,9,9,QDIR, 1,32,dir_pp_cq_9_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_9: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #20ns;
        start_pp_cq(0,10,10,QDIR, 1,32,dir_pp_cq_10_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_10: Trf_Done"),OVM_MEDIUM);  
      end
      begin
        #22ns;
        start_pp_cq(0,11,11,QDIR, 1,32,dir_pp_cq_11_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_11: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #24ns;
        start_pp_cq(0,12,12,QDIR, 1,32,dir_pp_cq_12_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_12: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #26ns;
        start_pp_cq(0,13,13,QDIR, 1,32,dir_pp_cq_13_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_13: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #28ns;
        start_pp_cq(0,14,14,QDIR, 1,32,dir_pp_cq_14_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_14: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #30ns;
        start_pp_cq(0,15,15,QDIR, 1,32,dir_pp_cq_15_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_dir_15: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #1ns;
        start_pp_cq(1,0,0,QUNO,   1,8,ldb_pp_cq_0_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_ldb_0: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #5ns;
        start_pp_cq(1,1,1,QUNO,   1,8,ldb_pp_cq_1_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_ldb_1: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #9ns;
        start_pp_cq(1,2,2,QUNO,   1,8,ldb_pp_cq_2_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_ldb_2: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #13ns;
        start_pp_cq(1,3,3,QUNO,   1,8,ldb_pp_cq_3_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_ldb_3: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #17ns;
        start_pp_cq(1,4,4,QUNO,   1,8,ldb_pp_cq_4_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_ldb_4: Trf_Done"),OVM_MEDIUM);  
      end
      begin
        #21ns;
        start_pp_cq(1,5,5,QUNO,   1,8,ldb_pp_cq_5_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_ldb_5: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #25ns;
        start_pp_cq(1,6,6,QUNO,   1,8,ldb_pp_cq_6_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_ldb_6: Trf_Done"),OVM_MEDIUM);   
      end
      begin
        #29ns;
        start_pp_cq(1,7,7,QUNO,   1,8,ldb_pp_cq_7_seq);
        ovm_report_info(get_full_name(),$psprintf("Main_flow_ldb_7: Trf_Done"),OVM_MEDIUM);   
      end

      begin
          if ($test$plusargs("HAS_HQM_TRF_CQ_CTRL")) begin
                while(i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count < has_hqm_trf_hcwnum) begin
                   wait_idle(has_hqm_trf_waitnum);
                   ovm_report_info(get_full_name(), $psprintf("Main_flow_HAS_HQM_CQ_CTRL_S2: current total_enq_count=%0d total_sch_count=%0d has_hqm_trf_hcwnum=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, has_hqm_trf_hcwnum), OVM_MEDIUM);
                end
                
                ovm_report_info(get_full_name(), $psprintf("Main_flow_HAS_HQM_CQ_CTRL_S3: enable CQ, current total_enq_count=%0d total_sch_count=%0d has_hqm_trf_hcwnum=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, has_hqm_trf_hcwnum), OVM_LOW);
                for(int k=0; k<16; k++) hqm_cfg_cq_disable_task(0, k, 0);
                for(int k=0; k<8; k++) hqm_cfg_cq_disable_task(1, k, 0);
                if(i_hqm_cfg.hqm_trf_cq_ctrl_st==0) i_hqm_cfg.hqm_trf_cq_ctrl_st = 1;
                ovm_report_info(get_full_name(), $psprintf("Main_flow_HAS_HQM_CQ_CTRL_S4: enable CQ Done hqm_trf_cq_ctrl_st=%0d ", i_hqm_cfg.hqm_trf_cq_ctrl_st), OVM_LOW);
          end
      end
    join


    super.body();

  endtask

  virtual task start_pp_cq(bit is_ldb, int pp_cq_num_in, int qid, hcw_qtype qtype, int queue_list_size, int hcw_delay_in, output hqm_pp_cq_base_seq pp_cq_seq);
    sla_ral_env         ral;
    sla_ral_reg         my_reg;
    sla_ral_field       my_field;
    sla_ral_data_t      ral_data;
    logic [63:0]        cq_addr_val;
    int                 num_hcw_gen;
    int                 hcw_time_gen;
    string              pp_cq_prefix;
    string              qtype_str;
    int                 vf_num_val;
    bit [15:0]          lock_id;
    bit [15:0]          dsi;
    int                 batch_min;
    int                 batch_max;
    int                 wu_min;
    int                 wu_max;
    bit                 msix_mode;
    int                 cq_poll_int;
    int                 hcw_delay_max_in;
    int                 comp_return_delay;
    int                 comp_return_delay_mode;
    int                 tok_return_delay;
    int                 tok_return_delay_mode;

    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal("CFG", "Unable to get RAL handle");
    end    

    cq_addr_val = '0;

    if (is_ldb) begin
      pp_cq_prefix = "LDB";
    end else begin
      pp_cq_prefix = "DIR";
    end

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pp_cq_num_in), "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[63:32] = ral_data[31:0];

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pp_cq_num_in), "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[31:6] = ral_data[31:6];
    ovm_report_info(get_full_name(), $psprintf("hcw_perf_dir_ldb_test1_hcw_seq: is_ldb=%0d pp_cq_num_in=%0d read cq_addr_u/l to get cq_addr_val=0x%0x", is_ldb, pp_cq_num_in, cq_addr_val), OVM_LOW);

    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- the above cq_addr_val read from CQ_ADDR ral is virtual address
    //-- to get physical address: cq_addr_val=i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in);  
    //----------------------------------
    if(i_hqm_cfg.ats_enabled==1) begin
        cq_addr_val = i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in); 
        ovm_report_info(get_full_name(), $psprintf("hcw_perf_dir_ldb_test1_hcw_seq: is_ldb=%0d pp_cq_num_in=%0d get cq_addr_val=0x%0x (physical address when i_hqm_cfg.ats_enabled==1)", is_ldb, pp_cq_num_in, cq_addr_val), OVM_LOW);
    end  


    my_field    = ral.find_field_by_name("MODE", "MSIX_MODE", "hqm_system_csr");
    ral_data    = my_field.get_actual();

    msix_mode   = ral_data[0];

    batch_min = 1;
    batch_max = 1;

    wu_min=0;
    $value$plusargs({$psprintf("%s_PP%0d_WU_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, wu_min);
    wu_max=0;
    $value$plusargs({$psprintf("%s_PP%0d_WU_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, wu_max);


    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_in);

    hcw_delay_max_in = hcw_delay_in;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_max_in);

    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, batch_min);
    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, batch_max);

    cq_poll_int = 1;
    $value$plusargs({$psprintf("%s_PP%0d_CQ_POLL",pp_cq_prefix,pp_cq_num_in),"=%d"}, cq_poll_int);

    `ovm_create(pp_cq_seq)
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_num_in));
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
                     pp_cq_num                  == pp_cq_num_in;      // Producer Port/Consumer Queue number
                     pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type

                     queue_list.size()          == queue_list_size;

                     hcw_enqueue_batch_min      == batch_min;  // Minimum number of HCWs to send as a batch (1-4)
                     hcw_enqueue_batch_max      == batch_max;  // Maximum number of HCWs to send as a batch (1-4)

                     hcw_enqueue_wu_min         == wu_min;  // Minimum WU value for HCWs
                     hcw_enqueue_wu_max         == wu_max;  // Maximum WU value for HCWs

                     queue_list_delay_min       == hcw_delay_in;
                     queue_list_delay_max       == hcw_delay_max_in;

                     cq_addr                    == cq_addr_val;

                     cq_poll_interval           == cq_poll_int;
                   } ) begin
      `ovm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end

    vf_num_val = -1;

    $value$plusargs({$psprintf("%s_PP%0d_VF",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, vf_num_val);

    if (vf_num_val >= 0) begin
      pp_cq_seq.is_vf   = 1;
      pp_cq_seq.vf_num  = vf_num_val;
    end

    $value$plusargs({$psprintf("%s_PP%0d_QID",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, qid);

    qtype_str = qtype.name();
    $value$plusargs({$psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%s"}, qtype_str);
    qtype_str = qtype_str.tolower();

    lock_id = 16'h4001;
    $value$plusargs({$psprintf("%s_PP%0d_LOCKID",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, lock_id);

    dsi = 16'h0100;
    $value$plusargs({$psprintf("%s_PP%0d_DSI",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, dsi);

    if($value$plusargs({$psprintf("%s_PP%0d_COMP_RETURN_DELAY_MODE", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, comp_return_delay_mode)) begin
         pp_cq_seq.comp_return_delay_mode = comp_return_delay_mode;
         ovm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY_MODE=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, comp_return_delay_mode), OVM_LOW);
    end

    if($value$plusargs({$psprintf("%s_PP%0d_COMP_RETURN_DELAY", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, comp_return_delay)) begin
         pp_cq_seq.comp_return_delay_q.push_back(comp_return_delay);
         ovm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, comp_return_delay), OVM_LOW);
    end

    if($value$plusargs({$psprintf("%s_PP%0d_TOK_RETURN_DELAY_MODE", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, tok_return_delay_mode)) begin
         pp_cq_seq.tok_return_delay_mode = tok_return_delay_mode;
         ovm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY_MODE=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, tok_return_delay_mode), OVM_LOW);
    end

    if($value$plusargs({$psprintf("%s_PP%0d_TOK_RETURN_DELAY", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, tok_return_delay)) begin
         pp_cq_seq.tok_return_delay_q.push_back(tok_return_delay);
         ovm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, tok_return_delay), OVM_LOW);
    end

    case (qtype_str)
      "qdir": qtype = QDIR;
      "quno": qtype = QUNO;
      "qatm": qtype = QATM;
      "qord": qtype = QORD;
    endcase

    for (int i = 0 ; i < queue_list_size ; i++) begin
      num_hcw_gen = 0;
      $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%d"}, num_hcw_gen);

      hcw_time_gen      = 0;
      $value$plusargs({$psprintf("%s_PP%0d_Q%0d_HCW_TIME",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%d"}, hcw_time_gen);

      if ((hcw_time_gen > 0) && (num_hcw_gen == 0)) begin
        num_hcw_gen = 1;
      end

      pp_cq_seq.queue_list[i].num_hcw                   = num_hcw_gen;
      pp_cq_seq.queue_list[i].hcw_time                  = hcw_time_gen;
      pp_cq_seq.queue_list[i].qid                       = qid + i;
      pp_cq_seq.queue_list[i].qtype                     = qtype;
      pp_cq_seq.queue_list[i].qpri_weight[0]            = 1;
      pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_in * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_in * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1'b1;
      pp_cq_seq.queue_list[i].lock_id                   = lock_id;
      pp_cq_seq.queue_list[i].dsi                       = dsi;
      pp_cq_seq.queue_list[i].comp_flow                 = 1;
      pp_cq_seq.queue_list[i].cq_token_return_flow      = 1;
      pp_cq_seq.queue_list[i].illegal_hcw_gen_mode      = hqm_pp_cq_base_seq::NO_ILLEGAL;
 

      //-- condition is pp[idx] => cq[idx]
      if(qtype != QDIR) 
          i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num_in] = num_hcw_gen;
      else 
          i_hcw_scoreboard.hcw_dir_cq_hcw_num[pp_cq_num_in] = num_hcw_gen;

      ovm_report_info(get_type_name(),$psprintf("start_pp_cq_generate__[%0d]: pp_cq_num_in=%0d/qtype=%0s/qid=%0d/lockid=0x%0x/delay=%0d/num_hcw_gen=%0d, hcw_ldb_cq_hcw_num[%0d]=%0d/hcw_dir_cq_hcw_num[%0d]=%0d", i, pp_cq_num_in, qtype.name(), pp_cq_seq.queue_list[i].qid, lock_id, hcw_delay_in, num_hcw_gen, pp_cq_num_in, i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num_in], pp_cq_num_in, i_hcw_scoreboard.hcw_dir_cq_hcw_num[pp_cq_num_in] ),  OVM_LOW);
    end

    finish_item(pp_cq_seq);
  endtask


//-------------------------
//------------------------- 
//-------------------------
// wait_idle
//------------------------- 
virtual task wait_idle(int wait_cycles);
      for(int i=0; i<wait_cycles; i++) #1ns;
endtask:wait_idle  
//-------------------------
// hqm_cfg_cq_disable_task: disable_in=1 => DISABLE
//------------------------- 
virtual task hqm_cfg_cq_disable_task(bit is_ldb_in, int cq_num_in, bit disable_in);
    string pp_cq_prefix;
 
    ovm_report_info(get_type_name(),$psprintf("hqm_cfg_cq_disable_task_start: configure is_ldb=%0d cq_num=%0d disable=%0d ", is_ldb_in, cq_num_in, disable_in), OVM_LOW);
    if (is_ldb_in) begin
      pp_cq_prefix = "LDB";
    end else begin
      pp_cq_prefix = "DIR";
    end
    write_reg($psprintf("cfg_cq_%0s_disable[%0d]", pp_cq_prefix, cq_num_in), disable_in, "list_sel_pipe");

    ovm_report_info(get_type_name(),$psprintf("hqm_cfg_cq_disable_task_end: configure is_ldb=%0d cq_num=%0d disable=%0d ", is_ldb_in, cq_num_in, disable_in), OVM_LOW);
endtask:hqm_cfg_cq_disable_task  


endclass
