import hcw_transaction_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

class hcw_perf_dir_ldb_test1_agi_hcw_seq extends hqm_base_seq;

    `ovm_sequence_utils(hcw_perf_dir_ldb_test1_agi_hcw_seq, sla_sequencer)

    typedef enum {
      TI_PHDR_AFULL             = 0,
      TI_PDATA_AFULL            = 1,
      TI_CMPL_AFULL             = 2,
      SIG_NUM_AFULL             = 3,
      PEND_SIG_AFULL            = 4,
      CSR_DATA_AFULL            = 5,
      WB_SCH_OUT_AFULL          = 6,
      IG_HCW_ENQ_AFULL          = 7,
      IG_HCW_ENQ_W_DB           = 8,
      EG_HCW_SCHED_DB           = 9,
      AL_MSI_MSIX_DB            = 10,
      AL_CWD_ALARM_DB           = 11,
      AL_HQM_ALARM_DB           = 12, 
      AL_SIF_ALARM_AFULL        = 13              //-- Not sure why this was not present in v1
      //TI_NPHDR_AFULL            = 2,            //-- Register Not present in v2 (Review)
      //WB_DMV_HCW_AFULL          = 5,            //-- DMV not present in v2
      //WB_DMV_WDATA_AFULL        = 6,            //-- DMV not present in v2
      //IG_CMPL_DATA_AFULL        = 7,            //-- Register Not present in v2 (Review)
      //IG_CMPL_HDR_AFULL         = 8,            //-- Register Not present in v2 (Review)
      //PPTR_AFULL                = 10,           //-- Register Not present in v2 (Review)
      //IG_HCW_ENQ_AW_DB          = 14,           //-- Register Not present in v2 (Review)
      //IG_DMV_R_DB               = 16,           //-- DMV not present in v2
      //EG_PUSH_PTR_AW_DB         = 17,           //-- Push pointer Not present in v2
      //EG_DMV_ENQ_W_DB           = 19,           //-- DMV Not present in v2
      //AL_DMV_ALARM_DB           = 22,           //-- DMV Not present in v2
    } agitate_en_sel_t;


  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;

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

  function new(string name = "hcw_perf_dir_ldb_test1_agi_hcw_seq");
    super.new(name);
  endfunction



  virtual task body();
    ovm_object  o_tmp;

    //-----------------------------
    //-- get i_hcw_scoreboard
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hcw_scoreboard", o_tmp)) begin
       ovm_report_info(get_full_name(), "hcw_perf_dir_ldb_test1_agi_hcw_seq: Unable to find i_hcw_scoreboard object", OVM_LOW);
       i_hcw_scoreboard = null;
    end else begin
       if (!$cast(i_hcw_scoreboard, o_tmp)) begin
         ovm_report_fatal(get_full_name(), $psprintf("Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
       end
    end

    //-----------------------------
    //-- tasks 
    //-----------------------------
    fork
      begin
        start_pp_cq(0,0,0,QDIR, 1,32,dir_pp_cq_0_seq);
      end
      begin
        #2ns;
        start_pp_cq(0,1,1,QDIR, 1,32,dir_pp_cq_1_seq);
      end
      begin
        #4ns;
        start_pp_cq(0,2,2,QDIR, 1,32,dir_pp_cq_2_seq);
      end
      begin
        #6ns;
        start_pp_cq(0,3,3,QDIR, 1,32,dir_pp_cq_3_seq);
      end
      begin
        #8ns;
        start_pp_cq(0,4,4,QDIR, 1,32,dir_pp_cq_4_seq);
      end
      begin
        #10ns;
        start_pp_cq(0,5,5,QDIR, 1,32,dir_pp_cq_5_seq);
      end
      begin
        #12ns;
        start_pp_cq(0,6,6,QDIR, 1,32,dir_pp_cq_6_seq);
      end
      begin
        #14ns;
        start_pp_cq(0,7,7,QDIR, 1,32,dir_pp_cq_7_seq);
      end
      begin
        #16ns;
        start_pp_cq(0,8,8,QDIR, 1,32,dir_pp_cq_8_seq);
      end
      begin
        #18ns;
        start_pp_cq(0,9,9,QDIR, 1,32,dir_pp_cq_9_seq);
      end
      begin
        #20ns;
        start_pp_cq(0,10,10,QDIR, 1,32,dir_pp_cq_10_seq);
      end
      begin
        #22ns;
        start_pp_cq(0,11,11,QDIR, 1,32,dir_pp_cq_11_seq);
      end
      begin
        #24ns;
        start_pp_cq(0,12,12,QDIR, 1,32,dir_pp_cq_12_seq);
      end
      begin
        #26ns;
        start_pp_cq(0,13,13,QDIR, 1,32,dir_pp_cq_13_seq);
      end
      begin
        #28ns;
        start_pp_cq(0,14,14,QDIR, 1,32,dir_pp_cq_14_seq);
      end
      begin
        #30ns;
        start_pp_cq(0,15,15,QDIR, 1,32,dir_pp_cq_15_seq);
      end
      begin
        #1ns;
        start_pp_cq(1,0,0,QUNO,   1,8,ldb_pp_cq_0_seq);
      end
      begin
        #5ns;
        start_pp_cq(1,1,1,QUNO,   1,8,ldb_pp_cq_1_seq);
      end
      begin
        #9ns;
        start_pp_cq(1,2,2,QUNO,   1,8,ldb_pp_cq_2_seq);
      end
      begin
        #13ns;
        start_pp_cq(1,3,3,QUNO,   1,8,ldb_pp_cq_3_seq);
      end
      begin
        #17ns;
        start_pp_cq(1,4,4,QUNO,   1,8,ldb_pp_cq_4_seq);
      end
      begin
        #21ns;
        start_pp_cq(1,5,5,QUNO,   1,8,ldb_pp_cq_5_seq);
      end
      begin
        #25ns;
        start_pp_cq(1,6,6,QUNO,   1,8,ldb_pp_cq_6_seq);
      end
      begin
        #29ns;
        start_pp_cq(1,7,7,QUNO,   1,8,ldb_pp_cq_7_seq);
      end
      begin
        #50ns;
        repeat(500) begin
          @(sla_tb_env::sys_clk_r); 
        end
        agitate(1);
        repeat(2000) begin
          @(sla_tb_env::sys_clk_r); 
        end
        agitate(0);
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
    bit                 msix_mode;
    int                 cq_poll_int;
    int                 hcw_delay_max_in;

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

    ovm_report_info(get_full_name(), $psprintf("hcw_perf_dir_ldb_test1_agi_hcw_seq: is_ldb=%0d pp_cq_num_in=%0d read cq_addr_u/l to get cq_addr_val=0x%0x", is_ldb, pp_cq_num_in, cq_addr_val), OVM_LOW);

    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- get_cq_addr_val is virtual address
    //-- cq_physical_addr_val=get_cq_hpa(is_ldb, cq);
    //----------------------------------
    get_hqm_cfg();
    if(i_hqm_cfg.ats_enabled==1) begin
        cq_addr_val = i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in); 
        ovm_report_info(get_full_name(), $psprintf("hcw_perf_dir_ldb_test1_agi_hcw_seq: is_ldb=%0d pp_cq_num_in=%0d get cq_addr_val=0x%0x (physical address when i_hqm_cfg.ats_enabled==1)", is_ldb, pp_cq_num_in, cq_addr_val), OVM_LOW);
    end


    my_field    = ral.find_field_by_name("MODE", "MSIX_MODE", "hqm_system_csr");
    ral_data    = my_field.get_actual();

    msix_mode   = ral_data[0];

    batch_min = 1;
    batch_max = 1;

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

  virtual task agitate(bit start_stop = 1);
    agitate_en_sel_t agitate_en_sel;
    string           agitate_en_name;
    sla_ral_data_t   rd_data;

    for (int i = 0; i < agitate_en_sel.num() ; i++) begin
      if ($test$plusargs({"HQM_AGI_",agitate_en_sel.name(),"_STRESS"})) begin
        agitate_en_name = agitate_en_sel.name();
        agitate_en_name = agitate_en_name.tolower();
    
        if(start_stop == 1) begin
          `ovm_info(get_full_name(),$psprintf("Agitate enabled - %s wdata=0x01020002",agitate_en_sel.name(),),OVM_LOW)
          //--abbiswal-- Need to fix this. --//
          if (agitate_en_sel <= 5) begin
              write_reg($psprintf("%s_agitate_control",agitate_en_name), 32'hffff0025, "hqm_sif_csr");
          end
          else begin
              write_reg($psprintf("%s_agitate_control",agitate_en_name), 32'hffff0025, "hqm_system_csr");
          end
          
          //-- iosf read txn --//
          //cfg_cmds.push_back($psprintf("rd hqm_pf_cfg_i.vendor_id"));
          read_reg("vendor_id", rd_data);
        end
        else begin
          `ovm_info(get_full_name(),$psprintf("Agitate disabled - %s wdata=0x00000000",agitate_en_sel.name(),),OVM_LOW)
          //--abbiswal-- Need to fix this. --//
          if (agitate_en_sel <= 5) begin
              write_reg($psprintf("%s_agitate_control",agitate_en_name), 32'h00000000, "hqm_sif_csr");
          end
          else begin
              write_reg($psprintf("%s_agitate_control",agitate_en_name), 32'h00000000, "hqm_system_csr");
          end
          
          //-- iosf read txn --//
          read_reg("vendor_id", rd_data);
        end
      end
    end
  endtask

endclass
