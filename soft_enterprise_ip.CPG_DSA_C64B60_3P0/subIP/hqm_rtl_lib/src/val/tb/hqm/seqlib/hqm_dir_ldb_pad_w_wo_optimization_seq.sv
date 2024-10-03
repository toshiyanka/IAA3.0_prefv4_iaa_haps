`ifndef HQM_DIR_LDB_PAD_W_WO_OPTIMIZATION_SEQ__SV
`define HQM_DIR_LDB_PAD_W_WO_OPTIMIZATION_SEQ__SV

`include "stim_config_macros.svh"

class hqm_dir_ldb_pad_w_wo_optimization_stim_config extends ovm_object;

  static string stim_cfg_name = "hqm_dir_ldb_pad_w_wo_optimization_stim_config";
 
  rand int disable_wb_opt;
  rand int pad_write_dir;
  rand int pad_write_ldb;
  rand int pad_first_write_dir;
  rand int pad_first_write_ldb;
  rand int write_single_beats;
  rand int early_dir_int;
  rand int cq_num;
  //rand int ;

  `ovm_object_utils_begin(hqm_dir_ldb_pad_w_wo_optimization_stim_config)
    `ovm_field_int(pad_write_dir             , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pad_write_ldb             , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pad_first_write_dir       , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pad_first_write_ldb       , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(write_single_beats                , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(early_dir_int                     , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(disable_wb_opt                    , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cq_num                            , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    //`ovm_field_int(                     , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_dir_ldb_pad_w_wo_optimization_stim_config)
    `stimulus_config_field_rand_int (pad_write_dir)
    `stimulus_config_field_rand_int (pad_write_ldb)
    `stimulus_config_field_rand_int (pad_first_write_dir)
    `stimulus_config_field_rand_int (pad_first_write_ldb)
    `stimulus_config_field_rand_int (write_single_beats)
    `stimulus_config_field_rand_int (early_dir_int)
    `stimulus_config_field_rand_int (disable_wb_opt)
    `stimulus_config_field_rand_int (cq_num)
    //`stimulus_config_field_rand_int (            )
  `stimulus_config_object_utils_end
 
  constraint  deflt_pad_write_dir         { soft pad_write_dir == 1; }
  constraint  deflt_pad_write_ldb         { soft pad_write_ldb == 1; }
  constraint  deflt_pad_first_write_dir   { soft pad_first_write_dir == 0; }
  constraint  deflt_pad_first_write_ldb   { soft pad_first_write_ldb == 0; }
  constraint  deflt_write_single_beats    { soft write_single_beats == 0; }
  constraint  deflt_early_dir_int         { soft early_dir_int == 0; }
  constraint  deflt_disable_wb_opt        { soft disable_wb_opt == 0; }
  constraint  deflt_cq_num                { soft cq_num == 0; }
  //constraint  deflt_    { soft  == 0; }

  function new(string name = "hqm_dir_ldb_pad_w_wo_optimization_stim_config");
    super.new(name); 
  endfunction

endclass : hqm_dir_ldb_pad_w_wo_optimization_stim_config

class hqm_dir_ldb_pad_w_wo_optimization_seq extends hqm_base_seq;

  hqm_cfg          i_hqm_cfg;
  string           cfg_cmds[$];

  `ovm_sequence_utils(hqm_dir_ldb_pad_w_wo_optimization_seq, sla_sequencer)

  rand hqm_dir_ldb_pad_w_wo_optimization_stim_config cfg;
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_dir_ldb_pad_w_wo_optimization_stim_config);

  function new(string name = "hqm_dir_ldb_pad_w_wo_optimization_seq");
    super.new(name);
    cfg = hqm_dir_ldb_pad_w_wo_optimization_stim_config::type_id::create("hqm_dir_ldb_pad_w_wo_optimization_stim_config"); 
    apply_stim_config_overrides(0);  // 0 means apply overrides for non-rand variables before seq.randomize() is called
  endfunction

  virtual task body();

      ovm_object     o_tmp;
      sla_ral_addr_t addr;
      sla_ral_reg    reg_h;
      sla_ral_data_t rd_data;

      apply_stim_config_overrides(1); // (1) below means apply overrides for random variables after seq.randomize() is called

      //-----------------------------
      //-- get i_hqm_cfg
      //-----------------------------
      if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
        ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
      end

      if (!$cast(i_hqm_cfg, o_tmp)) begin
        ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
      end  

      configure_wb_opt_controls();
      start_traffic();
  endtask

  task cmds_execute();
      while (cfg_cmds.size()) begin

          bit         do_cfg_seq;
          hqm_cfg_seq cfg_seq;
          string      cmd;

          cmd = cfg_cmds.pop_front();
          i_hqm_cfg.set_cfg(cmd, do_cfg_seq);
          if (do_cfg_seq) begin
            `ovm_create(cfg_seq)
            cfg_seq.pre_body();
            start_item(cfg_seq);
            finish_item(cfg_seq);
            cfg_seq.post_body();
          end
      end

  endtask
  
  task configure_wb_opt_controls();       

       ovm_report_info(get_full_name(), $psprintf("Starting dir ldb pad with/without optimization, write_single_beats, early_dir_int configuration"), OVM_LOW);

       cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_chp_csr_control.pad_write_dir %0d", cfg.pad_write_dir));
       cfg_cmds.push_back($psprintf("rd credit_hist_pipe.cfg_chp_csr_control.pad_write_dir %0d", cfg.pad_write_dir));
       cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_chp_csr_control.pad_write_ldb %0d", cfg.pad_write_ldb));
       cfg_cmds.push_back($psprintf("rd credit_hist_pipe.cfg_chp_csr_control.pad_write_ldb %0d", cfg.pad_write_ldb));

       cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_chp_csr_control.pad_first_write_dir %0d", cfg.pad_first_write_dir));
       cfg_cmds.push_back($psprintf("rd credit_hist_pipe.cfg_chp_csr_control.pad_first_write_dir %0d", cfg.pad_first_write_dir));
       cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_chp_csr_control.pad_first_write_ldb %0d", cfg.pad_first_write_ldb));
       cfg_cmds.push_back($psprintf("rd credit_hist_pipe.cfg_chp_csr_control.pad_first_write_ldb %0d", cfg.pad_first_write_ldb));

       cfg_cmds.push_back($psprintf("wr hqm_system_csr.write_buffer_ctl.write_single_beats %0d", cfg.write_single_beats));
       cfg_cmds.push_back($psprintf("rd hqm_system_csr.write_buffer_ctl.write_single_beats %0d", cfg.write_single_beats));
       cfg_cmds.push_back($psprintf("wr hqm_system_csr.write_buffer_ctl.early_dir_int %0d", cfg.early_dir_int));
       cfg_cmds.push_back($psprintf("rd hqm_system_csr.write_buffer_ctl.early_dir_int %0d", cfg.early_dir_int));

       cfg_cmds.push_back($psprintf("wr list_sel_pipe.cfg_cq_dir_token_depth_select_dsi[%0d].disable_wb_opt %0d", cfg.cq_num, cfg.disable_wb_opt));
       cfg_cmds.push_back($psprintf("rd list_sel_pipe.cfg_cq_dir_token_depth_select_dsi[%0d].disable_wb_opt %0d", cfg.cq_num, cfg.disable_wb_opt));

       //cfg_cmds.push_back($psprintf(" %0d", cfg.));
       cmds_execute();

       ovm_report_info(get_full_name(), $psprintf("Completed dir ldb pad with/without optimization, write_single_beats, early_dir_int configuration"), OVM_LOW);
  endtask

  task start_traffic();       
      
        ovm_report_info(get_full_name(), $psprintf("Starting dir ldb pad with/without optimization seq"), OVM_LOW);

       // 3 dir hcws to dir pp/cq0, qid0
       cfg_cmds.push_back("HCW DIR:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302 batch=1");
       cfg_cmds.push_back("HCW DIR:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302");
       repeat (118) begin
       cfg_cmds.push_back("HCW DIR:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302");
       end
       // 5 ldb hcws to ldb pp/cq0, qid0 (4 in first cache line, 1 in 2nd cash line); 1 ldb hcw to pp/cq1, qid1
       cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=0 dsi=0x302");
       cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=0 dsi=0x302");
       cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=0 dsi=0x302");
       cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=0 dsi=0x302");
       repeat (116) begin
       cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=0 dsi=0x302");
       end

       cfg_cmds.push_back("HCW LDB:1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=1 dsi=0x302");

       for (int i = 0 ; i < 15 ; i++) begin
           cfg_cmds.push_back($psprintf("poll_sch dir:0 0x%0x 200 100", (8 * (i + 1) ) ));
           cfg_cmds.push_back("HCW DIR:0 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x7 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
       end

       for (int i = 0 ; i < 15 ; i++) begin
           cfg_cmds.push_back($psprintf("poll_sch ldb:0  0x%0x 2000 100", (8 * (i + 1) ) ) );
           repeat(8) begin
               cfg_cmds.push_back("HCW LDB:0 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=0 dsi=0x302"); 
           end
       end
       cfg_cmds.push_back("poll_sch ldb:1  0x1  2000 100");
       cfg_cmds.push_back("HCW LDB:1 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=1 dsi=0x302"); 

       cmds_execute();

       cfg_cmds.push_back("poll credit_hist_pipe.cfg_vas_credit_count[0] 0x400 0xffffffff 1000 200");

       cmds_execute();

       wait_for_clk(100);

  endtask : start_traffic

endclass : hqm_dir_ldb_pad_w_wo_optimization_seq
`endif //HQM_DIR_LDB_PAD_W_WO_OPTIMIZATION_SEQ__SV

