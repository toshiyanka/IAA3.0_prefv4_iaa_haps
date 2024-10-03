
class hcw_credit_error_seq extends hqm_base_seq;

   `ovm_sequence_utils(hcw_credit_error_seq, sla_sequencer)

   hqm_pp_cq_base_seq    ldb_pp_cq_seq[`HQM_NUM_LDB_PORTS];
   hqm_pp_cq_base_seq    dir_pp_cq_seq[`HQM_NUM_DIR_PORTS];

   hqm_background_cfg_file_mode_seq      bg_cfg_seq;

   bit    [5:0] test_pp_num;
   string       test_pp_type;

   typedef struct {
       int       num_hcw_gen;
       int       illegal_credit_prob;
       hcw_qtype qtype;
   } pp_attr_t;

   function new(string name = "hcw_credit_error_seq");
       super.new(name);
   endfunction

   function void get_plusargs();
       `ovm_info(get_full_name(), $psprintf("get_plusargs -- Start"), OVM_DEBUG)
       for (int i = 0; i < 64; i++) begin
           if ($test$plusargs($psprintf("LDB_PP%0d_ILLEGAL_CREDIT_PROB", i))) begin
              test_pp_num = i;
              test_pp_type = "LDB";
              break;
           end
           if ($test$plusargs($psprintf("DIR_PP%0d_ILLEGAL_CREDIT_PROB", i))) begin
              test_pp_num = i;
              test_pp_type = "DIR";
              break;
           end
       end
       `ovm_info(get_full_name(), $psprintf("get_plusargs -- End"),   OVM_DEBUG)
   endfunction : get_plusargs

   virtual task body();

       pp_attr_t dir_pp_attr[64];
       pp_attr_t ldb_pp_attr[64];

       get_hqm_cfg();

       test_pp_num  = $urandom_range(0, 63);
       test_pp_type = ($urandom_range(0, 1))? "LDB" : "DIR"; 

       get_plusargs();
       ovm_report_info(get_full_name(), $psprintf("Verifying illegal credit for %0s PP 0x%0x", test_pp_type, test_pp_num), OVM_LOW);

       // -- Set exp drop error bit for the test_pp_num
       if (test_pp_type == "LDB") begin
           i_hqm_cfg.ldb_pp_cq_cfg[test_pp_num].exp_errors.drop = 1;
       end else begin
           i_hqm_cfg.dir_pp_cq_cfg[test_pp_num].exp_errors.drop = 1;
       end

       // -- Disable the CQ from scheduling
       ovm_report_info(get_full_name(), $psprintf("Illegal credit testcase, disabling CQs from scheduling for %0s port %0d", test_pp_type, test_pp_num), OVM_LOW);
       write_reg($psprintf("cfg_cq_%0s_disable[%0d]", test_pp_type, test_pp_num), 1, "list_sel_pipe");

       // -- Since in LDB , a single QID is mapped to two CQs, therefore disabling both CQs from scheduling
       if (test_pp_type == "LDB") begin
           if (test_pp_num % 2) begin
               write_reg($psprintf("cfg_cq_%0s_disable[%0d]", test_pp_type, (test_pp_num - 1)), 1, "list_sel_pipe");
           end else begin
               write_reg($psprintf("cfg_cq_%0s_disable[%0d]", test_pp_type, (test_pp_num + 1)), 1, "list_sel_pipe");
           end
       end

       // -- Prepare LDB struct
       foreach (ldb_pp_attr[i]) begin
           ldb_pp_attr[i].qtype               = QUNO;
           ldb_pp_attr[i].num_hcw_gen         = 64;
           ldb_pp_attr[i].illegal_credit_prob = 0;

           if ( ( (i/2) % 4) == 2 ) begin
               ldb_pp_attr[i].qtype = QATM;
           end

           if (i == test_pp_num) begin
               if (test_pp_type == "LDB") begin
                   ldb_pp_attr[i].num_hcw_gen         = 228;
                   ldb_pp_attr[i].illegal_credit_prob = 100;
               end else begin
                   ldb_pp_attr[i].num_hcw_gen = 0;
               end
           end

           if (test_pp_num % 2) begin
               if (i == (test_pp_num - 1) ) begin
                   ldb_pp_attr[i].num_hcw_gen = 0;
               end
           end else begin
               if ( i == (test_pp_num + 1) ) begin
                   ldb_pp_attr[i].num_hcw_gen = 0;
               end
           end
       end

       // -- Prepare DIR struct
       foreach (dir_pp_attr[i]) begin
           dir_pp_attr[i].qtype               = QDIR;
           dir_pp_attr[i].num_hcw_gen         = 64;
           dir_pp_attr[i].illegal_credit_prob = 0;

           if ( i == test_pp_num) begin
               if (test_pp_type == "DIR") begin
                   dir_pp_attr[i].num_hcw_gen         = 228;
                   dir_pp_attr[i].illegal_credit_prob = 100;
               end else begin
                   dir_pp_attr[i].num_hcw_gen = 0;
               end
           end 

           if (test_pp_num % 2) begin
               if ( i == (test_pp_num - 1) ) begin
                   dir_pp_attr[i].num_hcw_gen = 0;
               end
           end else begin
               if ( i == (test_pp_num + 1) ) begin
                   dir_pp_attr[i].num_hcw_gen = 0;
               end
           end
       end

       fork
           begin
               `ovm_do(bg_cfg_seq)
           end

           // -- LDB Traffic
           begin
               for (int i = 0; i < 64; i++) begin
                   fork 
                       automatic int j = i;
                       start_pp_cq(.is_ldb(1), .pp_cq_num_in(j), .is_vf(0), .vf_num(0), .qid(j/2), .qtype(ldb_pp_attr[j].qtype), .hcw_delay_in(8), .num_hcw_gen(ldb_pp_attr[j].num_hcw_gen), .illegal_credit_prob(ldb_pp_attr[j].illegal_credit_prob), .pp_cq_seq(ldb_pp_cq_seq[j]));

                   join_none
               end
               wait fork;
           end

           // -- DIR Traffic
           begin
               for (int i = 0; i < 64; i++) begin
                   fork 
                       automatic int j = i;
                       start_pp_cq(.is_ldb(0), .pp_cq_num_in(j), .is_vf(0), .vf_num(0), .qid(j),   .qtype(dir_pp_attr[j].qtype), .hcw_delay_in(8), .num_hcw_gen(dir_pp_attr[j].num_hcw_gen), .illegal_credit_prob(dir_pp_attr[j].illegal_credit_prob), .pp_cq_seq(dir_pp_cq_seq[j]));
                   join_none
               end
               wait fork;
           end

           begin
              ovm_report_info(get_full_name(), $psprintf("Wait for the HCWs to be dropped"), OVM_LOW);
              poll_reg("cfg_counter_chp_error_drop_l", 'h64, "credit_hist_pipe");
              poll_reg("cfg_counter_chp_error_drop_h", 'h0,  "credit_hist_pipe");
              ovm_report_info(get_full_name(), $psprintf("Expected packets dropped, enabling %0s port %0d for scheduling", test_pp_type, test_pp_num), OVM_LOW);
              write_reg($psprintf("cfg_cq_%0s_disable[%0d]", test_pp_type, test_pp_num), 0, "list_sel_pipe");
              if (test_pp_type == "LDB") begin
                  if (test_pp_num % 2) begin
                      write_reg($psprintf("cfg_cq_%0s_disable[%0d]", test_pp_type, (test_pp_num - 1)), 0, "list_sel_pipe");
                  end else begin
                      write_reg($psprintf("cfg_cq_%0s_disable[%0d]", test_pp_type, (test_pp_num + 1)), 0, "list_sel_pipe");
                  end
              end
           end
       join

       begin

           bit [31:0]     exp_data;
           sla_ral_data_t rd_data;
           sla_ral_data_t rd_val[$];

           exp_data[31:0] = 'hc501_0100;
           if (test_pp_type == "LDB") begin
               exp_data[7] = 1'b1;
           end
           exp_data[6:0] = test_pp_num;
           compare_reg($psprintf("alarm_pf_synd0"), exp_data, rd_data, "hqm_system_csr");
           write_fields($psprintf("alarm_pf_synd0"), '{"valid", "more"}, '{'h1, 'h1}, "hqm_system_csr");
           compare_fields($psprintf("alarm_pf_synd0"), '{"valid", "more"}, '{'h0, 'h0}, rd_val, "hqm_system_csr");

       end

   endtask

   virtual task start_pp_cq(bit is_ldb, int pp_cq_num_in, bit is_vf, int vf_num, int qid, hcw_qtype qtype, int hcw_delay_in, int num_hcw_gen, int illegal_credit_prob,output hqm_pp_cq_base_seq pp_cq_seq);

       
       logic [63:0]        cq_addr_val;
       string              pp_cq_prefix;
       string              qtype_str;
       int                 vf_num_val;
       bit [15:0]          lock_id;
       bit [15:0]          dsi;
       int                 cq_poll_int;

       `ovm_info("START_PP_CQ",$psprintf("Starting PP/CQ processing: %s PP/CQ 0x%0x is_vf=%d vf_num=0x%0x qid=0x%0x qtype=%s hcw_delay=%d, num_hcw_gen=%0d, illegal_credit_prob=%0d", is_ldb?"LDB":"DIR", pp_cq_num_in, is_vf, vf_num, qid, qtype.name(), hcw_delay_in, num_hcw_gen, illegal_credit_prob),OVM_LOW)

       cq_addr_val = get_cq_addr_val(e_port_type'(is_ldb), pp_cq_num_in);
       cq_addr_val[5:0] = 0;

       $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_in);

       cq_poll_int = 1;
       $value$plusargs({$psprintf("%s_PP%0d_CQ_POLL",pp_cq_prefix,pp_cq_num_in),"=%d"}, cq_poll_int);

       `ovm_create(pp_cq_seq)
       pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_num_in));
       start_item(pp_cq_seq);
       if (!pp_cq_seq.randomize() with {
                        pp_cq_num                  == pp_cq_num_in;      // Producer Port/Consumer Queue number
                        pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type
                        queue_list.size()          == 1;
                        hcw_enqueue_batch_min      == 1;  // Minimum number of HCWs to send as a batch (1-4)
                        hcw_enqueue_batch_max      == 1;  // Maximum number of HCWs to send as a batch (1-4)
                        queue_list_delay_min       == hcw_delay_in;
                        queue_list_delay_max       == hcw_delay_in;
                        cq_addr                    == cq_addr_val;
                        cq_poll_interval           == cq_poll_int;
                      } ) begin
         `ovm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
       end

       if ($value$plusargs({$psprintf("%s_PP%0d_VF",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, vf_num)) begin
         if (vf_num >= 0) begin
           is_vf   = 1;
         end else begin
           is_vf   = 0;
         end
       end

       pp_cq_seq.is_vf   = is_vf;
       pp_cq_seq.vf_num  = vf_num;

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

       for (int i = 0 ; i < 1 ; i++) begin

           $value$plusargs({$psprintf("%s_PP%0d_ILLEGAL_CREDIT_PROB",pp_cq_prefix,pp_cq_num_in),"=%d"}, illegal_credit_prob);
           $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%d"}, num_hcw_gen);

           pp_cq_seq.queue_list[i].num_hcw                   = num_hcw_gen;

           pp_cq_seq.queue_list[i].qid                       = qid + i;
           pp_cq_seq.queue_list[i].qtype                     = qtype;
           pp_cq_seq.queue_list[i].comp_flow                 = 1;
           pp_cq_seq.queue_list[i].cq_token_return_flow      = 1;

           pp_cq_seq.queue_list[i].qpri_weight[0]            = 1;
           pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_in * 1;
           pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_in * 1;
           pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1'b1;
           pp_cq_seq.queue_list[i].lock_id                   = lock_id;
           pp_cq_seq.queue_list[i].dsi                       = dsi;
           pp_cq_seq.queue_list[i].illegal_credit_prob       = illegal_credit_prob;
       end
       finish_item(pp_cq_seq);
   endtask

endclass
