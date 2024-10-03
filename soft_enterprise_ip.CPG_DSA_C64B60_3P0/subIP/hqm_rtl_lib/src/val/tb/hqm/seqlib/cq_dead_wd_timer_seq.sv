/* cq_wd_dead_timer

Max_interval logic: wd was polling cq 30 when the last schedule hcw occurred. It continued until it got to cq 4 when the wd timer got started and chp went idle. 
So the timing is wd polling cycle(worse case) + 256 where wd polling cycle is (interval + 1)*clk perid * 64 which is 2*10*64=1280+256=1536
When the timer expires depending on when it gets started so timing is again wd polling cycle(worse case) + 1000(wd timer) = 1280+1000=2280
*/




import hqm_tb_cfg_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

class cq_dead_wd_timer_seq extends hqm_base_seq;

  `ovm_sequence_utils(cq_dead_wd_timer_seq, sla_sequencer)

  hqm_pp_cq_base_seq    i_pp_cq_seq[hqm_pkg::NUM_DIR_PP];
  hqm_pp_cq_status      i_hqm_pp_cq_status;
  ovm_event_pool        glbl_pool;
  ovm_event exp_msix_0;
  bit                   kill_bg_cfg;

  realtime              wdog_interval;
  realtime              expiry_interval; 
  realtime              start_time;
  realtime              end_time;
  realtime              min_interval;
  realtime              max_interval;
   realtime             intr_interval;
//  realtime              time1;
//  realtime              time2;
//  realtime              pgcb_clk_period;
  realtime              intr_interval;
  int                   pp_sel_rand;
  int                   next_pp_sel_rand;
  int                   pp_sel_rand_label;
  int                   num_hcw_gen_rand;
  int                   pp_en_opt;
  bit                   is_ldb;
  hcw_qtype             i_qtype;
  string                pp_cq_prefix;
  int                   multiple_pp_en;
  int                   exp_cq_num_label;
  int                   exp_cq_num;
  int                   exp_next_cq_num_label;
  int                   exp_next_cq_num;
  int                   wd_bg_cfg;
  int                   num_bg_cfg;
  int                   lpp_pp_q[hqm_pkg::NUM_LDB_PP];
//   int                   pgcb_ref;
//  int                   counter = 0 ;

  rand bit [7:0]        wd_thresh;
  rand bit [27:0]       wd_intr;
  int unsigned          num_ports;
  int                   wd_disable;
  int                   wd_on_all_cq;

  constraint c_wd_intr {
    wd_intr  >= 0;   
    wd_intr  <= 28'h000_000f;   
    //wd_intr  <= 28'hfff_ffff;   
  }

  constraint c_wd_thresh {
    wd_thresh  >= 0;   
    wd_thresh  <= 8'hff;   
  }

  function new(string name = "cq_dead_wd_timer_seq");
    super.new(name);
    glbl_pool  = ovm_event_pool::get_global_pool();
    exp_msix_0 = glbl_pool.get("hqm_exp_ep_msix_0");
  endfunction

  virtual task body();

    hqm_cfg_file_mode_seq file_mode_seq;
    ovm_object o_tmp;

    get_hqm_cfg();
    //-----------------------------
    //-- get i_hqm_pp_cq_status
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_pp_cq_status", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
    end

    if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
    end

    $value$plusargs({$psprintf("IS_LDB"),"=%d"}, is_ldb);

    pp_sel_rand_label = is_ldb ? $urandom_range(0,(hqm_pkg::NUM_LDB_PP-1)) : $urandom_range(0,(hqm_pkg::NUM_DIR_PP-1));
    num_hcw_gen_rand  = $urandom_range(10,100);
    wd_disable = 0;
    wd_on_all_cq = 0;

    $value$plusargs({$psprintf("WD_SAMPLE_INTERVAL"),"=%d"}, wd_intr);
    if ($value$plusargs({$psprintf("PP_EN"),"=%d"}, pp_sel_rand_label)) pp_en_opt=1;
    $value$plusargs({$psprintf("NUM_HCW"),"=%d"}, num_hcw_gen_rand);
    $value$plusargs({$psprintf("WD_THRESHOLD"),"=%d"}, wd_thresh);
    $value$plusargs({$psprintf("MULTIPLE_PP_EN"),"=%d"}, multiple_pp_en);
    $value$plusargs({$psprintf("WD_BG_CFG"),"=%d"}, wd_bg_cfg);
    $value$plusargs({$psprintf("WD_DISABLE"),"=%d"}, wd_disable);
    if ($value$plusargs({$psprintf("WD_ON_ALL_CQ"),"=%d"}, wd_on_all_cq)) num_hcw_gen_rand=20;
    //pp_sel_rand_label=0;
    pp_sel_rand = pp_sel_rand_label;

    ovm_report_info(get_full_name(), $psprintf("BEFORE: wd_intr=%0d, pp_sel_rand=%0d, pp_en_opt=%0d, is_ldb=%0d, multiple_pp_en=%0d, wd_thresh=%0d, num_hcw_gen_rand=%0d, num_ports=%d, exp_cq_num=%0d, exp_next_cq_num=%0d, next_pp_sel_rand=%0d, pp_sel_rand_label=%0d, wd_on_all_cq=%0d, wd_disable=%0d", wd_intr, pp_sel_rand, pp_en_opt, is_ldb, multiple_pp_en,wd_thresh,num_hcw_gen_rand, num_ports, exp_cq_num, exp_next_cq_num, next_pp_sel_rand, pp_sel_rand_label, wd_on_all_cq, wd_disable), OVM_MEDIUM);

    if (is_ldb) begin

      pp_cq_prefix = "LDB";
      i_qtype=QUNO;

      for (int i=0;i<hqm_pkg::NUM_LDB_PP;i++) begin
          if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",i),lpp_pp_q[i])) begin
            `ovm_info(get_full_name(), $psprintf("Logical LDB PP %0d maps to physical PP %0d", i, lpp_pp_q[i]),OVM_MEDIUM)
          end else begin
            `ovm_error(get_full_name(), $psprintf("LPP%0d name not found in hqm_cfg", i))
          end
      end

      pp_sel_rand = lpp_pp_q[0];
      next_pp_sel_rand = lpp_pp_q[1];

      exp_cq_num  = lpp_pp_q[1];
      exp_next_cq_num =  lpp_pp_q[0];
      num_ports = hqm_pkg::NUM_LDB_PP;

    end else begin

      pp_cq_prefix = "DIR";
      i_qtype=QDIR;
      next_pp_sel_rand = (pp_sel_rand+1)%(hqm_pkg::NUM_DIR_PP);
      exp_cq_num = pp_sel_rand;
      exp_next_cq_num = next_pp_sel_rand;
      num_ports = hqm_pkg::NUM_DIR_PP;

    end

    ovm_report_info(get_full_name(), $psprintf(" wd_intr=%0d, pp_sel_rand=%0d, pp_en_opt=%0d, is_ldb=%0d, multiple_pp_en=%0d, wd_thresh=%0d, num_hcw_gen_rand=%0d, num_ports=%d, exp_cq_num=%0d, exp_next_cq_num=%0d, next_pp_sel_rand=%0d, pp_sel_rand_label=%0d", wd_intr, pp_sel_rand, pp_en_opt, is_ldb, multiple_pp_en,wd_thresh,num_hcw_gen_rand, num_ports, exp_cq_num, exp_next_cq_num, next_pp_sel_rand, pp_sel_rand_label), OVM_MEDIUM);

    //configure all watchdog timer registers

  fork
      begin
        ovm_report_info(get_full_name(), $psprintf("the pgcb_clk ref point started "), OVM_LOW);
       pgcb_clk();
      end
    join_none

    wd_timer_config();

    fork
      begin
          if (is_ldb) begin
              for (int i=0;i<num_ports;i++) begin
                fork
                  automatic int j = i;
                  automatic int k = lpp_pp_q[j];
                  if ((k==lpp_pp_q[0]) || (k==lpp_pp_q[1])) 
                      start_pp_cq(.is_ldb(is_ldb), .pp_cq_num_in(k), .qid(j), .qtype(i_qtype), .pp_cq_seq(i_pp_cq_seq[k]));
                join_none
              end
          end
          else begin
              for (int i=0;i<num_ports;i++) begin
                fork
                  automatic int j = i;
                  start_pp_cq(.is_ldb(is_ldb), .pp_cq_num_in(j), .qid(j), .qtype(i_qtype), .pp_cq_seq(i_pp_cq_seq[j]));
                join_none
              end
          end
        wait_for_cq_schedule();
        start_time = ($realtime);
        num_bg_cfg=0;//reset the bg cfg count on last schedule, as thi is used to add extra interval required for min/max interval adjustment
        fork
          if (!wd_bg_cfg) 
              wait_on_prim_clkreq();
          wait_on_cq_wd_msix();
        join
        ovm_report_info(get_full_name(), $psprintf("DEBUG:DS: 000AAA"), OVM_MEDIUM);
        wait_on_all_tok_return();
      end

      begin
          bg_cfg_access();
          wait (kill_bg_cfg==1);
      end

      begin
        #((wd_thresh+30)*max_interval);
        if (!wd_disable) 
            ovm_report_error(get_full_name(), $psprintf("MSI-X not generated at all even after Timeout value ((wd_thresh+30)*max_interval) = %f ", ((wd_thresh+30)*max_interval)));
        else begin
            ovm_report_info(get_full_name(), $psprintf("CFG_%0s_WD_DISABLE0 is not written to 1 (was kept at default value of 0xffff_ffff), so watchdog timeout interrupt shouldn't come out, and observation is as expected", pp_cq_prefix), OVM_MEDIUM);
            check_synd_regs();
        end
      end
    join_any

    disable fork;

    ovm_report_info(get_full_name(), $psprintf("BODY END: wd_intr=%0d, pp_sel_rand=%0d, pp_en_opt=%0d, is_ldb=%0d, multiple_pp_en=%0d, wd_thresh=%0d, num_hcw_gen_rand=%0d, num_ports=%d", wd_intr, pp_sel_rand, pp_en_opt, is_ldb, multiple_pp_en,wd_thresh,num_hcw_gen_rand, num_ports), OVM_MEDIUM);
  endtask

  virtual task start_pp_cq(bit is_ldb, int pp_cq_num_in, int qid, hcw_qtype qtype, ref hqm_pp_cq_base_seq pp_cq_seq);
    bit [63:0]        cq_addr_val;
    logic [63:0]        push_ptr_addr_val;
    int                 num_hcw_gen;
    string              pp_cq_prefix;
    string              qtype_str;
    int                 vf_num_val;
    bit [15:0]          lock_id;
    bit [15:0]          dsi;
    int                 pkt_size_min;
    int                 pkt_size_max;
    bit                 control_token_return;
    bit                 control_token_return_en;
    int                 token_hold_back_delay;
    int                 cq_token_return_delay;
    int                 tok_return_delay_en;
    int                 delay_offset;
    int                 hcw_delay_rand;

    cq_addr_val = '0;

    if (is_ldb) begin
      pp_cq_prefix = "LDB";
      delay_offset = 1000;
    end else begin
      pp_cq_prefix = "DIR";
      delay_offset = 500;
    end

    cq_addr_val      = get_cq_addr_val(e_port_type'(is_ldb), pp_cq_num_in);
    cq_addr_val[5:0] = 0;

    `ovm_create(pp_cq_seq)
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_num_in));
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
                     pp_cq_num            == pp_cq_num_in;      // Producer Port/Consumer Queue number
                     pp_cq_type           == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type

                     queue_list.size()            == 1;
                     hcw_enqueue_batch_min        == 1;  // Minimum number of HCWs to send as a batch (1-4)
                     hcw_enqueue_batch_max        == 4;  // Maximum number of HCWs to send as a batch (1-4)

                     cq_addr                      == cq_addr_val;

                     cq_poll_interval             == 1;
                   } ) begin
      `ovm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end

    cq_token_return_delay = 500;
    $value$plusargs({$psprintf("PP%0d_TOK_RETURN_DELAY_EN",pp_cq_seq.pp_cq_num),"=%d"}, tok_return_delay_en);
    $value$plusargs({$psprintf("PP%0d_CONTROL_TOKEN_RETURN",pp_cq_seq.pp_cq_num),"=%d"}, control_token_return);
    $value$plusargs({$psprintf("PP%0d_TOKEN_HOLD_BACK_DELAY",pp_cq_seq.pp_cq_num),"=%d"}, token_hold_back_delay);
    $value$plusargs({$psprintf("CONTROL_TOKEN_RETURN"),"=%d"}, control_token_return_en);

    hcw_delay_rand=1;
    if (pp_cq_seq.pp_cq_num == exp_cq_num) begin
        tok_return_delay_en=1;
        if (control_token_return_en==1) control_token_return=1;
    end

        
    if (multiple_pp_en && (pp_cq_seq.pp_cq_num == exp_next_cq_num)) begin
        tok_return_delay_en=1;
        delay_offset=2000;
    end
    if (wd_on_all_cq)
        tok_return_delay_en=1;

    if (tok_return_delay_en) begin
        cq_token_return_delay = (max_interval + delay_offset);
        if (cq_token_return_delay > 1000000) cq_token_return_delay = 1000000;
    end
      
    if (control_token_return) begin
        pp_cq_seq.tok_return_delay_mode = 3;
        pp_cq_seq.tok_return_delay_q.push_back(0);		// delay token returns for 0 cycles
        //pp_cq_seq.tok_return_delay_q.push_back(delay_offset);	// enable token returns for 2000 cycles (adjust as desired)
    end
    else begin
        pp_cq_seq.tok_return_delay_mode = 1'b0;
        pp_cq_seq.tok_return_delay_q.push_back( cq_token_return_delay );
    end

    pp_cq_seq.mon_watchdog_timeout = (30*max_interval);
    // -- pp_cq_seq.mon_watchdog_timeout = ( ( (4 + 1 + 1) * (64) * (2 + 1) * 10) + 4000);
    vf_num_val = -1;

    $value$plusargs({$psprintf("%s_PP%0d_VF",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, vf_num_val);

    if (vf_num_val >= 0) begin
      pp_cq_seq.is_vf   = 1;
      pp_cq_seq.vf_num  = vf_num_val;
    end

    //num_hcw_gen = 2;
    if (pp_cq_seq.pp_cq_num == pp_sel_rand) 
        num_hcw_gen = num_hcw_gen_rand;
    if ((multiple_pp_en==1) && (pp_cq_seq.pp_cq_num == (next_pp_sel_rand))) 
        num_hcw_gen = num_hcw_gen_rand;
    if (wd_on_all_cq)
        num_hcw_gen = num_hcw_gen_rand;


    ovm_report_info(get_full_name(), $psprintf("DEBUG:DS:pp_cq_seq.pp_cq_num=%0d, exp_cq_num=%0d, tok_return_delay_en=%0d, num_hcw_gen=%0d, cq_token_return_delay=%0d, max_interval=%0d, delay_offset=%0d, pp_sel_rand=%0d", pp_cq_seq.pp_cq_num, exp_cq_num, tok_return_delay_en, num_hcw_gen, cq_token_return_delay, max_interval, delay_offset, pp_sel_rand ), OVM_LOW);
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

    pp_cq_seq.queue_list[0].num_hcw                     = num_hcw_gen;
    pp_cq_seq.queue_list[0].qid                         = qid;
    pp_cq_seq.queue_list[0].qtype                       = qtype;
    pp_cq_seq.queue_list[0].hcw_delay_min               = hcw_delay_rand;//1;
    pp_cq_seq.queue_list[0].hcw_delay_max               = hcw_delay_rand;//1;
    pp_cq_seq.queue_list[0].qpri_weight[0]              = 1;
    pp_cq_seq.queue_list[0].lock_id                     = lock_id;
    pp_cq_seq.queue_list[0].dsi                         = dsi;
    pp_cq_seq.queue_list[0].comp_flow                   = 1;
    pp_cq_seq.queue_list[0].cq_token_return_flow        = 1'b1;
    pp_cq_seq.queue_list[0].hcw_delay_qe_only           = 1;
    pp_cq_seq.queue_list[0].illegal_hcw_gen_mode        = hqm_pp_cq_base_seq::NO_ILLEGAL;

    finish_item(pp_cq_seq);
  endtask

  task wait_on_prim_clkreq();
    
    hqm_reset_unit_sequence      i_wait_prim_clkreq_deassert_seq;
    hqm_reset_unit_sequence      i_wait_prim_clkreq_assert_seq;
    realtime                     prim_clkreq_deassert_time;
    realtime                     prim_clkreq_assert_time;
    realtime                     diff_prim_clkreq_deassert_scheduled;
    realtime                     diff_prim_clkreq_assert_scheduled;
    bit deassert_done=0, assert_done=0;
    int deassert_cnt=0, assert_cnt=0;
    real wd_interval_in_primclk_cycles=0;
    
    // after last HCW is scheduled, start prim_clkreq check seq
    fork
    begin
        `ovm_do_on_with(i_wait_prim_clkreq_deassert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::PRIM_CLKREQ_DEASSERT;});
        prim_clkreq_deassert_time = $realtime;
        diff_prim_clkreq_deassert_scheduled = (prim_clkreq_deassert_time - start_time);
        deassert_done=1;
    end
    begin
       while(deassert_done==0) begin
           @(sla_tb_env::sys_clk_r); 
           deassert_cnt++;
       end
    end
    join

    fork
    begin
        `ovm_do_on_with(i_wait_prim_clkreq_assert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::PRIM_CLKREQ_ASSERT;});
        prim_clkreq_assert_time = $realtime;
        diff_prim_clkreq_assert_scheduled = (prim_clkreq_assert_time - start_time);
        assert_done=1;
    end
    begin
       while(assert_done==0) begin
           @(sla_tb_env::sys_clk_r); 
           assert_cnt++;
       end
    end
    join

    wd_interval_in_primclk_cycles= (wdog_interval/1.25);
    ovm_report_info(get_full_name(), $psprintf("prim_clkreq: deassert time = %0t, assert time = %0t, last HCW schedule time=%0t, diff_prim_clkreq_deassert_scheduled =%0t, diff_prim_clkreq_assert_scheduled=%0t;  deassert_cnt =%0d, assert_cnt=%0d, wd_interval_in_primclk_cycles=%0d, wdog_interval=%0d, (wdog_interval/(1.25*10000))=%0d", prim_clkreq_deassert_time, prim_clkreq_assert_time, start_time, diff_prim_clkreq_deassert_scheduled, diff_prim_clkreq_assert_scheduled, deassert_cnt, assert_cnt, wd_interval_in_primclk_cycles, wdog_interval, (wdog_interval/(1.25))), OVM_MEDIUM);
    
    // Looking at the sim, wd was polling cq 30 when the last schedule hcw occurred. It continued until it got to cq 4 when the wd timer got started and chp went idle. 
    //So the timing is wd polling cycle(worse case) + 256 where wd polling cycle is (interval + 1)*clk perid * 64 which is 2*10*64=1280+256=1536
    // When the timer expires depending on when it gets started so timing is again wd polling cycle(worse case) + 1000(wd timer) = 1280+1000=2280

    if (pp_en_opt && !multiple_pp_en) begin
        if ((deassert_cnt/(1.25)) <= (wd_interval_in_primclk_cycles+256.0))
           ovm_report_info(get_full_name(), $psprintf("prim_clkreq got deasserted within (wd polling cycle + 256)=%0d prim clks of last scheduled HCW:diff_prim_clkreq_deassert_scheduled in prim_clks=%0d", (wd_interval_in_primclk_cycles+256.0), (deassert_cnt/(1.25))), OVM_MEDIUM);
        else
           ovm_report_error(get_full_name(), $psprintf("prim_clkreq didn't get deasserted within (wd polling cycle + 256)=%0d prim clks of last scheduled HCW:diff_prim_clkreq_deassert_scheduled in prim_clks=%0d", (wd_interval_in_primclk_cycles+256.0), (deassert_cnt/(1.25))));


        if ((((deassert_cnt+assert_cnt)/(1.25)) > (wd_interval_in_primclk_cycles+1000.0)) || (((deassert_cnt+assert_cnt)/(1.25)) < (wd_interval_in_primclk_cycles+1010.0)))
           ovm_report_info(get_full_name(), $psprintf("prim_clkreq got asserted approx after (wd polling cycle + 1000)=%0d prim clks of last scheduled HCW: diff_prim_clkreq_assert_scheduled in prim_clks=%0d", (wd_interval_in_primclk_cycles+1000.0), ((deassert_cnt+assert_cnt)/(1.25))), OVM_MEDIUM);
        else
           ovm_report_error(get_full_name(), $psprintf("prim_clkreq didn't get asserted approx after (wd polling cycle + 1000)=%0d prim clks of last scheduled HCW: diff_prim_clkreq_assert_scheduled in prim_clks=%0d", (wd_interval_in_primclk_cycles+1000.0), ((deassert_cnt+assert_cnt)/(1.25))));
    end
          
  endtask

  task wait_on_cq_wd_msix();

    bit [15:0]     data;
    int prochot_en, ph_dly1_max;
    sla_ral_data_t rd_val;

    ovm_report_info(get_full_name(), $psprintf("Starting the TB watchdog(start_time=%0t, intr_interval=%0t, min_interval=%0t, max_interval=%0t", start_time, intr_interval, min_interval, max_interval), OVM_MEDIUM);
    //i_hqm_pp_cq_status.wait_for_msix_int(0, data); // MISx entry index

    while (!i_hqm_pp_cq_status.msix_int_received(0)) begin
        wait_for_clk(1);
    end

    end_time = ($realtime);
    exp_msix_0.trigger();

    //write_reg("msix_ack", 'h0000_0001, "hqm_system_csr");

    if (is_ldb) begin
        min_interval += num_bg_cfg*1;
        max_interval += num_bg_cfg*4;
    end else begin
        min_interval += num_bg_cfg*2;
        max_interval += num_bg_cfg*40;
        if ($value$plusargs({$psprintf("HQM_PROCHOT_INIT_VAL"),"=%d"}, prochot_en) || $value$plusargs({$psprintf("HQM_PH_DLY1_MAX"),"=%d"}, ph_dly1_max)) begin
            min_interval += num_bg_cfg*5;
            max_interval += num_bg_cfg*60;
        end
    end

    if ( ( (end_time - start_time) >= ( min_interval ) ) &&
         ( (end_time - start_time) <= ( max_interval ) )
       ) begin
           ovm_report_info(get_full_name(), $psprintf("MSI-X interrupt got generated in defined time range=%0t (start_time=%0t, end_time=%0t), min_interval=%0t, max_interval=%0t", (end_time - start_time), start_time, end_time, min_interval, max_interval), OVM_LOW);
       end else begin
           if (multiple_pp_en)
                ovm_report_info(get_full_name(), $psprintf("when watchdog interrupt is expected from more than 1 CQ, then it is difficult to expect the exact minimum interval for MSIXas we can't predict which port is done with their PP activity or last schedule activity first, So not flagging error for MSIX not getting in the range:defined time range=%0t (start_time=%0t, end_time=%0t), min_interval=%0t, max_interval=%0t ", (end_time - start_time), start_time, end_time, min_interval, max_interval), OVM_MEDIUM);
            else
                ovm_report_error(get_full_name(), $psprintf("MSI-X interrupt didn't get generated in defined time range=%0t (start_time=%0t, end_time=%0t), min_interval=%0t, max_interval=%0t", (end_time - start_time), start_time, end_time, min_interval, max_interval));
    end
    ovm_report_info(get_full_name(), $psprintf("Check for interrupt"), OVM_MEDIUM);
          
    check_synd_regs();

endtask

task check_synd_regs();
    
    bit [hqm_pkg::NUM_DIR_CQ-1:0]        exp_reg_val;
    sla_ral_data_t    rd_val;

    ovm_report_info(get_full_name(), $psprintf("Check for syndrome regs: Start"), OVM_MEDIUM);
    exp_reg_val[exp_cq_num]='b1;
    if (multiple_pp_en)  
        exp_reg_val[exp_next_cq_num]='b1;
    if (wd_disable) 
        exp_reg_val[hqm_pkg::NUM_DIR_CQ-1:0] = 'h0;
    if (wd_on_all_cq) 
        exp_reg_val[hqm_pkg::NUM_DIR_CQ-1:0] = 64'hffff_ffff_ffff_ffff;

    //compare_reg($psprintf("cfg_%0s_wdto_0", pp_cq_prefix), exp_reg_val[31:0], rd_val, "credit_hist_pipe");
    poll_reg($psprintf("cfg_%0s_wdto_0", pp_cq_prefix), exp_reg_val[31:0], "credit_hist_pipe");
    ovm_report_info(get_full_name(), $psprintf("DEBUG: cfg_%0s_wdto_0 = %0h", pp_cq_prefix, rd_val), OVM_LOW);

    write_reg($psprintf("cfg_%0s_wdto_0", pp_cq_prefix), exp_reg_val, "credit_hist_pipe");
    compare_reg($psprintf("cfg_%0s_wdto_0", pp_cq_prefix), 0, rd_val, "credit_hist_pipe");
    ovm_report_info(get_full_name(), $psprintf("DEBUG: Read after W1C: cfg_%0s_wdto_0 = %0h", pp_cq_prefix, rd_val), OVM_LOW);

    //compare_reg($psprintf("cfg_%0s_wdto_1",pp_cq_prefix), exp_reg_val[63:32], rd_val, "credit_hist_pipe");
    poll_reg($psprintf("cfg_%0s_wdto_1", pp_cq_prefix), exp_reg_val[63:32], "credit_hist_pipe");
    ovm_report_info(get_full_name(), $psprintf("DEBUG: cfg_%0s_wdto_1 = %0h", pp_cq_prefix, rd_val), OVM_LOW);

    write_reg($psprintf("cfg_%0s_wdto_1", pp_cq_prefix), exp_reg_val[63:32], "credit_hist_pipe");
    compare_reg($psprintf("cfg_%0s_wdto_1", pp_cq_prefix), 0, rd_val, "credit_hist_pipe");
    ovm_report_info(get_full_name(), $psprintf("DEBUG: Read after W1C: cfg_%0s_wdto_1 = %0h", pp_cq_prefix, rd_val), OVM_LOW);


    if (wd_disable) 
        exp_reg_val[hqm_pkg::NUM_DIR_CQ-1:0] = 'hffff_ffff_ffff_ffff;

    compare_reg($psprintf("cfg_%0s_wd_disable0",pp_cq_prefix), exp_reg_val[31:0], rd_val, "credit_hist_pipe");
    compare_reg($psprintf("cfg_%0s_wd_disable1",pp_cq_prefix), exp_reg_val[63:32], rd_val, "credit_hist_pipe");


    exp_reg_val='h8000_0800;
    if (multiple_pp_en || wd_on_all_cq)  
        exp_reg_val[30]='b1;
    if (wd_disable) 
        exp_reg_val = 'h0;

    compare_reg("alarm_hw_synd", exp_reg_val[31:0], rd_val, "hqm_system_csr");
    ovm_report_info(get_full_name(), $psprintf("DEBUG: alarm_hw_synd = %0h", rd_val), OVM_LOW);

    exp_reg_val='h8000_0000;
    if (multiple_pp_en || wd_on_all_cq)  
        exp_reg_val[30]='b1;
    if (wd_disable) 
        exp_reg_val = 'h0;

    write_reg("alarm_hw_synd", exp_reg_val[31:0], "hqm_system_csr");

    exp_reg_val='h0000_0800;
    if (wd_disable) 
        exp_reg_val = 'h0;

    compare_reg("alarm_hw_synd", exp_reg_val[31:0], rd_val, "hqm_system_csr");

    ovm_report_info(get_full_name(), $psprintf("DEBUG: Read after W1C: alarm_hw_synd = %0h", rd_val), OVM_LOW);
    ovm_report_info(get_full_name(), $psprintf("Check for syndrome regs: End"), OVM_MEDIUM);
  endtask


  task bg_cfg_access();

    sla_ral_data_t temp;

    string reg_name[1];
    reg_name[0] = { $psprintf("cfg_%0s_wd_threshold", pp_cq_prefix)}; 

    if (wd_bg_cfg) begin
        forever begin
            string str;

//            repeat (100) @(sla_tb_env::sys_clk_r);
             repeat (200) @(posedge pins.pgcb_clk*12);
 
            if (kill_bg_cfg) break;
            str = reg_name[$urandom_range(0, 0)];
            ovm_report_info(get_full_name(), $psprintf("Read register %0s", str), OVM_LOW);
            read_reg(str, temp);
            num_bg_cfg++;
        end
    end
  endtask

  task wait_for_cq_schedule();

   sla_ral_data_t rd_val;

   poll_sch( .cq_num(exp_cq_num), .exp_cnt(num_hcw_gen_rand), .is_ldb(is_ldb) );
   //poll_reg($psprintf("cfg_cq_%0s_tot_sch_cntl[%0d]", pp_cq_prefix, exp_cq_num), num_hcw_gen_rand, "list_sel_pipe");

   if (multiple_pp_en) begin 
       poll_sch( .cq_num(exp_next_cq_num), .exp_cnt(num_hcw_gen_rand), .is_ldb(is_ldb) );
       //poll_reg($psprintf("cfg_cq_%0s_tot_sch_cntl[%0d]", pp_cq_prefix, exp_next_cq_num), num_hcw_gen_rand, "list_sel_pipe");
   end
   if (wd_on_all_cq) begin
       for (int i=0;i<num_ports; i++) begin
           poll_sch( .cq_num(i), .exp_cnt(num_hcw_gen_rand), .is_ldb(is_ldb) );
           //poll_reg($psprintf("cfg_cq_%0s_tot_sch_cntl[%0d]", pp_cq_prefix, i), num_hcw_gen_rand, "list_sel_pipe");
       end
   end

    ovm_report_info(get_full_name(), $psprintf("All QEs Scheduled"), OVM_MEDIUM);
  endtask

  task wait_on_all_tok_return();
    ovm_report_info(get_full_name(), $psprintf("DEBUG:DS: 000BBB"), OVM_MEDIUM);

    for(int i=0;i<num_ports;i++) begin
        poll_reg($psprintf("cfg_%0s_cq_depth[%0d]", pp_cq_prefix, i), 0, "credit_hist_pipe");
    end
    kill_bg_cfg=1;
    ovm_report_info(get_full_name(), $psprintf("All CQs Returned Tokens"), OVM_MEDIUM);

  endtask

  task wd_timer_config();
  
    sla_ral_data_t rd_val;

    // configure wd_threshold
    write_reg($psprintf("cfg_%0s_wd_threshold",pp_cq_prefix), wd_thresh, "credit_hist_pipe");

    compare_reg($psprintf("cfg_%0s_wd_disable0",pp_cq_prefix), 'hffff_ffff, rd_val, "credit_hist_pipe");
    compare_reg($psprintf("cfg_%0s_wd_disable1",pp_cq_prefix), 'hffff_ffff, rd_val, "credit_hist_pipe");

    if (!wd_disable) begin
        // configure wd_disable to enable the watchdog alarm
        write_reg($psprintf("cfg_%0s_wd_disable0",pp_cq_prefix), 'hffff_ffff, "credit_hist_pipe");
        write_reg($psprintf("cfg_%0s_wd_disable1",pp_cq_prefix), 'hffff_ffff, "credit_hist_pipe");
    end

    // configure wd_enb for all 64/64 LDB/DIR CQs
    for(int i=0;i<num_ports;i++) begin
        write_reg($psprintf("cfg_%0s_cq_wd_enb[%0d]",pp_cq_prefix, i), 'h1, "credit_hist_pipe");
    end

    // configure global wd_enb_interval
    ovm_report_info(get_full_name(), $psprintf("Write register cfg_%0s_wd_enb_interval.", pp_cq_prefix), OVM_LOW);
    wdog_interval   = realtime'((wd_intr + 1) * (num_ports) * (pgcb_ref));
    expiry_interval = (wdog_interval * realtime'(wd_thresh + 1));
     ovm_report_info(get_full_name(), $psprintf("pgcb_ref=%0d,wdog_interval=%0t,expiry_interval=%0t",pgcb_ref,wdog_interval,expiry_interval), OVM_LOW);


    write_reg($psprintf("cfg_%0s_wd_enb_interval",pp_cq_prefix), ( (1 <<28) + wd_intr), "credit_hist_pipe");
    compare_reg($psprintf("cfg_%0s_wd_enb_interval",pp_cq_prefix), ( (1 <<28) + wd_intr), rd_val, "credit_hist_pipe");

    intr_interval   = realtime'(256);
    min_interval    = ( expiry_interval );
    max_interval    = ( min_interval + wdog_interval + intr_interval);
  endtask



endclass
