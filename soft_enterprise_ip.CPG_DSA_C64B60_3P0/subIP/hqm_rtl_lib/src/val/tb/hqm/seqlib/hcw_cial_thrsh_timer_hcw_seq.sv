import hqm_tb_cfg_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

class hcw_cial_thrsh_timer_hcw_seq extends sla_sequence_base;

  `ovm_sequence_utils(hcw_cial_thrsh_timer_hcw_seq, sla_sequencer)

  hqm_tb_cfg            i_hqm_cfg;

  hqm_pp_cq_base_seq    dir_pp_cq_seq[16];

  hqm_pp_cq_base_seq    ldb_pp_cq_seq[15];

  int unsigned         max_interval;

  function new(string name = "hcw_cial_thrsh_timer_hcw_seq");
    super.new(name);
  endfunction

  virtual task body();
    ovm_object  o_tmp;
    int         num_dir;
    int         num_ldb;
    int         wd_timeout;
    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg %s not consistent with hqm_tb_cfg type", o_tmp.sprint()));
    end

    num_dir = 16;
    $value$plusargs("HCW_CIAL_THRSH_TIMER_HCW_SEQ_NUM_DIR=%d", num_dir);

    num_ldb = 15;
    $value$plusargs("HCW_CIAL_THRSH_TIMER_HCW_SEQ_NUM_LDB=%d", num_ldb);

    wd_timeout = 10;
    $value$plusargs("HCW_CIAL_THRSH_TIMER_HCW_SEQ_WD_TIMEOUT=%d", wd_timeout);

    for (int i = 0 ; i < num_dir ; i++) begin
      fork
        automatic int pp_num = i;
        start_pp_cq(.is_ldb(0),.log_pp_cq_num(pp_num),.qid(pp_num),.qtype(QDIR),.queue_list_size(1),.hcw_delay_min(32),.pp_cq_seq(dir_pp_cq_seq[pp_num]));
      join_none
    end

    for (int i = 0 ; i < num_ldb ; i++) begin
      fork
        automatic int pp_num = i;
        start_pp_cq(.is_ldb(1),.log_pp_cq_num(pp_num),.qid(pp_num),.qtype(QUNO),.queue_list_size(1),.hcw_delay_min(32),.pp_cq_seq(ldb_pp_cq_seq[pp_num]));
      join_none
    end

    wait fork;

    super.body();

  endtask

  virtual task start_pp_cq(bit is_ldb, int log_pp_cq_num, int qid, hcw_qtype qtype, int queue_list_size, int hcw_delay_min, output hqm_pp_cq_base_seq pp_cq_seq);
    sla_ral_env         ral;
    sla_ral_reg         my_reg;
    sla_ral_field       my_field;
    sla_ral_data_t      ral_data;
    logic [63:0]        cq_addr_val;
    int                 num_hcw_gen;
    string              pp_cq_prefix;
    string              qtype_str;
    int                 vf_num_val;
    bit [15:0]          lock_id;
    bit [15:0]          dsi;
    int                 batch_min;
    int                 batch_max;
    bit                 msix_mode;
    int                 cq_poll_int;
    int                 phy_pp_cq_num;
    int                 msi_num;
    int                 hcw_delay_max;
    int                 qid_opt;
    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal("CFG", "Unable to get RAL handle");
    end    

    phy_pp_cq_num = log_pp_cq_num;

    if (is_ldb) begin
      if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",log_pp_cq_num),phy_pp_cq_num)) begin
        `ovm_info(get_full_name(), $psprintf("Logical LDB PP %0d maps to physical PP %0d",log_pp_cq_num,phy_pp_cq_num),OVM_LOW)
      end else begin
        `ovm_error(get_full_name(), $psprintf("LPP%0d name not found in hqm_cfg",log_pp_cq_num))
      end
    end else begin
      if (i_hqm_cfg.get_name_val($psprintf("DQID%0d",log_pp_cq_num),phy_pp_cq_num)) begin
        `ovm_info(get_full_name(), $psprintf("Logical DIR PP %0d maps to physical PP %0d",log_pp_cq_num,phy_pp_cq_num),OVM_LOW)
      end else begin
        `ovm_error(get_full_name(), $psprintf("DQID%0d name not found in hqm_cfg",log_pp_cq_num))
      end
    end

    cq_addr_val = '0;

    if (is_ldb) begin
      pp_cq_prefix = "LDB";
    end else begin
      pp_cq_prefix = "DIR";
    end

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,phy_pp_cq_num), "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[63:32] = ral_data[31:0];

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,phy_pp_cq_num), "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[31:6] = ral_data[31:6];
    ovm_report_info(get_full_name(), $psprintf("hcw_cial_thrsh_timer_hcw_seq: is_ldb=%0d phy_pp_cq_num=%0d read cq_addr_u/l to get cq_addr_val=0x%0x", is_ldb, phy_pp_cq_num, cq_addr_val), OVM_LOW);

    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- the above cq_addr_val read from CQ_ADDR ral is virtual address
    //-- to get physical address: cq_addr_val=i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in);  
    //----------------------------------
    if(i_hqm_cfg.ats_enabled==1) begin
        cq_addr_val = i_hqm_cfg.get_cq_hpa(is_ldb, phy_pp_cq_num); 
        ovm_report_info(get_full_name(), $psprintf("hcw_cial_thrsh_timer_hcw_seq: is_ldb=%0d phy_pp_cq_num=%0d get cq_addr_val=0x%0x (physical address when i_hqm_cfg.ats_enabled==1)", is_ldb, phy_pp_cq_num, cq_addr_val), OVM_LOW);
    end  

    my_field    = ral.find_field_by_name("MODE", "MSIX_MODE", "hqm_system_csr");
    ral_data    = my_field.get_actual();

    msix_mode   = ral_data[0];

    batch_min = 1;
    batch_max = 1;

    vf_num_val = -1;
    $value$plusargs({$psprintf("%s_PP%0d_VF",pp_cq_prefix,log_pp_cq_num),"=%d"}, vf_num_val);

    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY_MIN",pp_cq_prefix,log_pp_cq_num),"=%d"}, hcw_delay_min);
    hcw_delay_max = hcw_delay_min;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY_MAX",pp_cq_prefix,log_pp_cq_num),"=%d"}, hcw_delay_max);
    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MIN",pp_cq_prefix,log_pp_cq_num),"=%d"}, batch_min);
    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MAX",pp_cq_prefix,log_pp_cq_num),"=%d"}, batch_max);

    cq_poll_int = 0;
    $value$plusargs({$psprintf("%s_PP%0d_CQ_POLL",pp_cq_prefix,log_pp_cq_num),"=%d"}, cq_poll_int);

  if(i_hqm_cfg.is_sriov_mode()) begin
    msi_num = -1;
   // msi_num           = i_hqm_cfg.get_msi_num(phy_pp_cq_num,vf_num_val,is_ldb);
    $value$plusargs({$psprintf("%s_PP%0d_MSI_NUM",pp_cq_prefix,log_pp_cq_num),"=%d"}, msi_num);
    `ovm_info(get_full_name(),$psprintf("MSI_NUM=%0d, PP_NUM=%0d VF_NUM=%0d, IS_LDB=%0d ",msi_num,phy_pp_cq_num,vf_num_val,is_ldb),OVM_MEDIUM)
    //$value$plusargs({$psprintf("%s_PP%0d_COMP_MSI_NUM",pp_cq_prefix,log_pp_cq_num),"=%d"}, msi_num);
  end


    `ovm_create(pp_cq_seq)
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,log_pp_cq_num));
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
      pp_cq_num                  == ((vf_num_val >= 0) ? log_pp_cq_num : phy_pp_cq_num);      // Producer Port/Consumer Queue number
      pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type

      msi_int_num                == msi_num;

      cq_depth                   == 16;

      queue_list.size()          == queue_list_size;

      hcw_enqueue_batch_min      == batch_min;  // Minimum number of HCWs to send as a batch (1-4)
      hcw_enqueue_batch_max      == batch_max;  // Maximum number of HCWs to send as a batch (1-4)

      queue_list_delay_min       == hcw_delay_min;
      queue_list_delay_max       == hcw_delay_max;

      cq_addr                    == cq_addr_val;

      cq_poll_interval           == cq_poll_int;
    } ) begin
      `ovm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end

    max_interval=2;    
    $value$plusargs({$psprintf("MAX_INTERVAL"),"=%d"}, max_interval);
    pp_cq_seq.mon_watchdog_timeout = (20000*max_interval);
   `ovm_info(get_full_name(), $psprintf("MAX_INTERVAL = %0d",max_interval),OVM_LOW)

    if (vf_num_val >= 0) begin
      int vf_num_opt;

      pp_cq_seq.is_vf   = 1;

      if (i_hqm_cfg.get_name_val($psprintf("VF%0d",vf_num_val),vf_num_opt)) begin
        pp_cq_seq.vf_num  = vf_num_opt;
      end else begin
        `ovm_error(get_full_name(), $psprintf("VF%0d name not found in hqm_cfg",vf_num_val))
        pp_cq_seq.vf_num  = vf_num_opt;
      end
    end

    $value$plusargs({$psprintf("%s_PP%0d_QID",pp_cq_prefix,log_pp_cq_num),"=%d"}, qid);

    if (!pp_cq_seq.is_vf) begin
      if (is_ldb) begin
        if (i_hqm_cfg.get_name_val($psprintf("LQID%0d",qid),qid_opt)) begin
          qid  = qid_opt;
        end else begin
          `ovm_error(get_full_name(), $psprintf("LQID%0d name not found in hqm_cfg",qid))
        end
      end else begin
        if (i_hqm_cfg.get_name_val($psprintf("DQID%0d",qid),qid_opt)) begin
          qid  = qid_opt;
        end else begin
          `ovm_error(get_full_name(), $psprintf("DQID%0d name not found in hqm_cfg",qid))
        end
      end
    end

    qtype_str = qtype.name();
    $value$plusargs({$psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,log_pp_cq_num),"=%s"}, qtype_str);
    qtype_str = qtype_str.tolower();

    lock_id = 16'h4001;
    $value$plusargs({$psprintf("%s_PP%0d_LOCKID",pp_cq_prefix,log_pp_cq_num),"=%d"}, lock_id);

    dsi = 16'h0100;
    $value$plusargs({$psprintf("%s_PP%0d_DSI",pp_cq_prefix,log_pp_cq_num),"=%d"}, dsi);

    case (qtype_str)
      "qdir": qtype = QDIR;
      "quno": qtype = QUNO;
      "qatm": qtype = QATM;
      "qord": qtype = QORD;
    endcase

    for (int i = 0 ; i < queue_list_size ; i++) begin
      num_hcw_gen = 1;
      $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,log_pp_cq_num,i),"=%d"}, num_hcw_gen);

      pp_cq_seq.queue_list[i].num_hcw                   = num_hcw_gen;
      pp_cq_seq.queue_list[i].qid                       = qid + i;
      pp_cq_seq.queue_list[i].qtype                     = qtype;
      pp_cq_seq.queue_list[i].qpri_weight[0]            = 1;
      pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_min * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_max * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1'b1;
      pp_cq_seq.queue_list[i].lock_id                   = lock_id;
      pp_cq_seq.queue_list[i].dsi                       = dsi;
      pp_cq_seq.queue_list[i].comp_flow                 = 1;
      pp_cq_seq.queue_list[i].cq_token_return_flow      = 1;
      pp_cq_seq.queue_list[i].illegal_hcw_gen_mode      = hqm_pp_cq_base_seq::NO_ILLEGAL;
    end

    finish_item(pp_cq_seq);
  endtask

endclass
