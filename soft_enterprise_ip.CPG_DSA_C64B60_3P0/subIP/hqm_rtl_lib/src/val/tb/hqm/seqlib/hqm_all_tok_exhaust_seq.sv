`ifndef HQM_ALL_TOK_EXHAUST_SEQ__SV
`define HQM_ALL_TOK_EXHAUST_SEQ__SV

class hqm_all_tok_exhaust_seq extends hqm_base_seq;

    hqm_pp_cq_base_seq dir_t_pp_cq_seq;
    hqm_pp_cq_base_seq ldb_t_pp_cq_seq;
    hqm_pp_cq_base_seq dir_pp_cq_seq[10];
    hqm_pp_cq_base_seq ldb_pp_cq_seq[10];

    `ovm_sequence_utils(hqm_all_tok_exhaust_seq, sla_sequencer)

    extern function new         (string name = "hqm_all_tok_exhaust_seq");
    extern task     body        ();
    extern task     start_pp_cq (bit is_ldb, int pp_cq_num_in, int qid, hcw_qtype qtype, int timeout, bit cq_poll, int unsigned num_hcw, ref hqm_pp_cq_base_seq pp_cq_seq);

endclass : hqm_all_tok_exhaust_seq

function hqm_all_tok_exhaust_seq::new(string name = "hqm_all_tok_exhaust_seq");
    super.new(name);
endfunction : new

task hqm_all_tok_exhaust_seq::body();

    bit          lq_t_found;
    bit          dq_t_found;
    int unsigned num_hcw;
    int unsigned test_pp_timeout;
    bit          test_cond_met;

    ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);

    get_hqm_cfg();

    get_hqm_pp_cq_status();

    if ($test$plusargs("TEST_NUM_HCW")) begin
        void'($value$plusargs("TEST_NUM_HCW=%0d", num_hcw));
        ovm_report_info(get_full_name(), $psprintf("TEST_NUM_HCW=%0d", num_hcw), OVM_LOW);
    end else begin
        ovm_report_error(get_full_name(), $psprintf("No plusargs TEST_NUM_HCW found"));
    end

    if ($test$plusargs("TEST_PP_TIMEOUT")) begin
        void'($value$plusargs("TEST_PP_TIMEOUT=%0d", test_pp_timeout));
    end else begin
        test_pp_timeout = 20000;
    end

    ovm_report_info(get_full_name(), $psprintf("TEST_PP_TIMEOUT=%0d", test_pp_timeout), OVM_LOW);

    fork
        begin
            int val;

            if ( !(i_hqm_cfg.get_name_val("DQ_T", val) ) ) begin
                ovm_report_warning(get_full_name(), $psprintf("No value found for label DQ_T"));
            end else begin
                dq_t_found = 1'b1;
                fork
                    start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in(val), .qid(val), .qtype(QDIR), .timeout(test_pp_timeout), .cq_poll(0), .num_hcw(num_hcw), .pp_cq_seq(dir_t_pp_cq_seq));
                    forever begin
                        wait_for_clk();
                        if ( !($test$plusargs("HQM_DISABLE_TEST_COND_MET")) ) begin
                            if ( ( (num_hcw - i_hqm_pp_cq_status.dir_pp_cq_status[val].mon_enq_cnt) > 0) && (i_hqm_pp_cq_status.get_cq_tokens_cnt(1'b0, val) == 0) ) begin
                                test_cond_met = 1'b1;
                                break;
                            end else begin
                                ovm_report_info(get_full_name(), $psprintf("num_hcw=%0d, cq_tokens_cnt=%0d", (num_hcw - i_hqm_pp_cq_status.dir_pp_cq_status[val].mon_enq_cnt), i_hqm_pp_cq_status.get_cq_tokens_cnt(1'b0, val)), OVM_LOW);
                            end
                        end else begin
                            test_cond_met = 1'b1;
                            ovm_report_info(get_full_name(), $psprintf("HQM_DISABLE_TEST_COND_MET plusargs provided; disabling the check"), OVM_LOW);
                            break;
                        end
                    end
                join
            end
        end
        begin
            for (int i = 0; i < 10; i++) begin
                fork
                    automatic int j = i;
                    automatic int val;

                    if ( !(i_hqm_cfg.get_name_val($psprintf("DQ_%0d", j), val)) ) begin
                        ovm_report_fatal(get_full_name(), $psprintf("No value for found for label %0s", $psprintf("DQ_%0d", j)));
                    end
                    start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in(val), .qid(val), .qtype(QDIR), .timeout(4000), .cq_poll(1), .num_hcw(200), .pp_cq_seq(dir_pp_cq_seq[j]));
                join_none
            end
            wait fork;
        end
        begin
            int val;

            if ( !(i_hqm_cfg.get_name_val("LQ_T", val) ) ) begin
                ovm_report_warning(get_full_name(), $psprintf("No value found for label LQ_T"));
            end else begin
                lq_t_found = 1'b1;
                fork
                    start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in(val), .qid(val), .qtype(QUNO), .timeout(test_pp_timeout), .cq_poll(0), .num_hcw(num_hcw), .pp_cq_seq(ldb_t_pp_cq_seq));
                    forever begin
                        wait_for_clk();
                        if ( !($test$plusargs("HQM_DISABLE_TEST_COND_MET")) ) begin
                            if ( ( (num_hcw - i_hqm_pp_cq_status.ldb_pp_cq_status[val].mon_enq_cnt) > 0) && (i_hqm_pp_cq_status.get_cq_tokens_cnt(1'b1, val) == 0) ) begin
                                test_cond_met = 1'b1;
                                break;
                            end else begin
                                ovm_report_info(get_full_name(), $psprintf("num_hcw=%0d, cq_tokens_cnt=%0d", (num_hcw - i_hqm_pp_cq_status.ldb_pp_cq_status[val].mon_enq_cnt), i_hqm_pp_cq_status.get_cq_tokens_cnt(1'b1, val)), OVM_LOW);
                            end
                        end else begin
                            test_cond_met = 1'b1;
                            ovm_report_info(get_full_name(), $psprintf("HQM_DISABLE_TEST_COND_MET plusargs provided; disabling the check"), OVM_LOW);
                            break;
                        end
                    end
                join
            end
        end
        begin
            for (int i = 0; i < 10; i++) begin
                fork
                    automatic int j = i;
                    automatic int val;

                    if ( !(i_hqm_cfg.get_name_val($psprintf("LQ_%0d", j), val)) ) begin
                        ovm_report_fatal(get_full_name(), $psprintf("No value for found for label %0s", $psprintf("DQ_%0d", j)));
                    end
                    start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in(val), .qid(val), .qtype(QUNO), .timeout(4000), .cq_poll(1), .num_hcw(200), .pp_cq_seq(ldb_pp_cq_seq[j]));
                join_none
            end
            wait fork;
        end
    join

    if ( !(dq_t_found || lq_t_found) ) begin
        ovm_report_error(get_full_name(), $psprintf("No label found for either directed or load balanced"));
    end

    if (test_cond_met) begin
        ovm_report_info(get_full_name(), $psprintf("Test condition met; enqueues took place after CQ buffer was full"), OVM_LOW);
    end else begin
        ovm_report_error(get_full_name(), $psprintf("Test condition not met; enqueues didn't took place after CQ buffer was full"));
    end
    ovm_report_info(get_full_name(), $psprintf("body -- End"),   OVM_DEBUG);

endtask : body

task hqm_all_tok_exhaust_seq::start_pp_cq(bit is_ldb, int pp_cq_num_in, int qid, hcw_qtype qtype, int timeout, bit cq_poll, int unsigned num_hcw, ref hqm_pp_cq_base_seq pp_cq_seq);

    string        pp_cq_prefix;
    bit    [63:0] cq_addr_val;
    int           hcw_delay_min;
    int           hcw_delay_max;

    ovm_report_info(get_full_name(), $psprintf("start_pp_cq(is_ldb=%0b, pp_cq_num_in=%0d, qid=%0d, qtype=%0s,    timeout=%0d, num_hcw=%0d) -- Start",
                                                            is_ldb,     pp_cq_num_in,     qid,     qtype.name(), timeout,     num_hcw), OVM_LOW);
    if (is_ldb) begin
        pp_cq_prefix = "LDB";
    end else begin
        pp_cq_prefix = "DIR";
    end

    cq_addr_val      = get_cq_addr_val(e_port_type'(is_ldb), pp_cq_num_in);
    cq_addr_val[5:0] = 0;
    ovm_report_info(get_full_name(), $psprintf("start_pp_cq is_ldb=%0b, pp_cq_num_in=%0d, cq_addr_val=0x%0x", is_ldb, pp_cq_num_in, cq_addr_val), OVM_LOW);

    `ovm_create(pp_cq_seq)
    pp_cq_seq.set_name($psprintf("%s_PP%0d", pp_cq_prefix, pp_cq_num_in));
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
            pp_cq_num                 == pp_cq_num_in;
            pp_cq_type                == ( (is_ldb)? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);
            queue_list.size()         == 1;
            hcw_enqueue_batch_min     == 1;
            hcw_enqueue_batch_max     == 1;
            cq_addr                   == cq_addr_val;
            cq_poll_interval          == cq_poll;
            tok_return_delay_mode     == 0;
            mon_watchdog_timeout      == (timeout * 10);
            sb_watchdog_timeout       == (timeout * 10);
        } ) begin
        ovm_report_fatal(get_full_name(), $psprintf("Randomization failed for pp_cq_seq(is_ldb=%0b, pp_cq_num_in=%0d)", is_ldb, pp_cq_num_in));
    end

    hcw_delay_min = 20;
    hcw_delay_max = 30;

    void'($value$plusargs("TEST_HCW_DELAY_MIN=%0d", hcw_delay_min));
    void'($value$plusargs("TEST_HCW_DELAY_MAX=%0d", hcw_delay_max));

    if ($test$plusargs("HQM_TB_PH_REGR")) begin
        hcw_delay_min *= 8;
        hcw_delay_max *= 8;
    end

    ovm_report_info(get_full_name(), $psprintf("test_hcw_delay_min=%0d", hcw_delay_min), OVM_LOW);
    ovm_report_info(get_full_name(), $psprintf("test_hcw_delay_max=%0d", hcw_delay_max), OVM_LOW);

    pp_cq_seq.tok_return_delay_q.push_back(timeout); 
    pp_cq_seq.queue_list[0].num_hcw              = num_hcw;
    pp_cq_seq.queue_list[0].qid                  = qid;
    pp_cq_seq.queue_list[0].qtype                = qtype;
    pp_cq_seq.queue_list[0].cq_token_return_flow = 1'b1;
    pp_cq_seq.queue_list[0].comp_flow            = 1'b1;
    pp_cq_seq.queue_list[0].qpri_weight[0]       = 1;
    pp_cq_seq.queue_list[0].hcw_delay_min        = hcw_delay_min;
    pp_cq_seq.queue_list[0].hcw_delay_max        = hcw_delay_max;

    if (cq_poll) begin
        pp_cq_seq.cq_intr_process_delay = 1000;
    end

    finish_item(pp_cq_seq);
    ovm_report_info(get_full_name(), $psprintf("start_pp_cq(is_ldb=%0b, pp_cq_num_in=%0d, qid=%0d,    qtype=%0s,    timeout=%0d, num_hcw=%0d) -- End",
                                                            is_ldb,     pp_cq_num_in,     qid,        qtype.name(), timeout,     num_hcw), OVM_LOW);

endtask : start_pp_cq

`endif //HQM_ALL_TOK_EXHAUST_SEQ__SV
