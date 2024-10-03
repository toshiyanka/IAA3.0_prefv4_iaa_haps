
class hqm_cfg_seq extends hqm_cfg_base_seq;

  `ovm_sequence_utils(hqm_cfg_seq, sla_sequencer)

  sla_ral_data_t        last_rd_val;

  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  function new(string name = "hqm_cfg_seq");
     super.new(name);
  endfunction
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  virtual protected task process_reg_op(hqm_cfg_register_ops  reg_ops, output bit reg_op_processed, output bit test_done);  
      sla_status_t          status;
      sla_ral_reg           my_reg;
      sla_ral_field         my_field;
      sla_ral_data_t        rd_val;
      string                my_access_path;
      sla_ral_sai_t         my_sai;

      reg_op_processed  = 1'b0;
      test_done         = 1'b0;

      `ovm_info("CFG_SEQ",$psprintf("DBprocess_reg_op: ops=%0s reg_name=%0s file_name=%0s ", reg_ops.ops.name(), reg_ops.reg_name, {tb_env_hier,".",reg_ops.file_name} ),OVM_MEDIUM)


      if (reg_ops.ops == HQM_CFG_IDLE) begin
        `ovm_info("CFG_SEQ",$psprintf("IDLE: %d ns",reg_ops.poll_delay),OVM_HIGH)

        repeat (reg_ops.poll_delay) @(sla_tb_env::sys_clk_r);

        reg_op_processed = 1'b1;
      end else if (reg_ops.ops == HQM_CFG_MSIX_ALARM_WAIT) begin
        bit [15:0] msix_data;
        int poll_count;

        `ovm_info("CFG_SEQ",$psprintf("MSIX_ALARM_WAIT: timeout %0d ns",reg_ops.poll_delay),OVM_HIGH)

        poll_count = reg_ops.poll_delay;

        while ((poll_count > 0) && (cfg.i_hqm_pp_cq_status.msix_int_received(0) == 0)) begin
          @(sla_tb_env::sys_clk_r);
          poll_count--;
        end

        if (cfg.i_hqm_pp_cq_status.msix_int_received(0)) begin
          cfg.i_hqm_pp_cq_status.wait_for_msix_int(0,msix_data);
          `ovm_info("CFG_SEQ",$psprintf("MSIX_ALARM_WAIT: interupt received after %0d ns",reg_ops.poll_delay - poll_count),OVM_LOW)
        end else begin
          `ovm_error("CFG_SEQ",$psprintf("MSIX_ALARM_WAIT: interrupt not detected, timeout after %0d ns",reg_ops.poll_delay))
        end

        reg_op_processed = 1'b1;
      end else if (reg_ops.ops == HQM_CFG_POLL_SCH) begin

          string         cq_type;
          sla_ral_data_t cq_num;
          int unsigned   poll_delay;
          int unsigned   poll_timeout;
          int unsigned   exp_sch_cnt;

          cq_type      = reg_ops.field_name;
          cq_num       = reg_ops.exp_rd_val;
          exp_sch_cnt  = reg_ops.exp_rd_mask;
          poll_delay   = reg_ops.poll_delay;
          poll_timeout = reg_ops.poll_timeout;

          if (cq_type == "ldb") begin
              if ( !( (cq_num >= 0) && (cq_num < hqm_pkg::NUM_LDB_PP) ) ) begin
                  `ovm_fatal(get_type_name(), $psprintf("Out of range LDB CQ 0x%0x provided", cq_num))
              end 
          end else if (cq_type == "dir") begin
              if ( ( !(cq_num >= 0) && (cq_num < hqm_pkg::NUM_DIR_PP) ) ) begin
                  `ovm_fatal(get_type_name(), $psprintf("Out of range DIR CQ 0x%0x provided", cq_num))
              end
          end else begin
              `ovm_fatal(get_type_name(), $psprintf("Unknown CQ type option %0s provided", cq_type))
          end

          while (poll_timeout > 0) begin
              if (cq_type == "dir") begin
                  `ovm_info(get_full_name(), $psprintf("POLL_SCH :: poll_timeout=%0d, dir, cq_num=%0d, exp_sch_cnt=%0d, actual_sch_cnt=%0d", 
                                                        poll_timeout, cq_num, exp_sch_cnt, cfg.i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].mon_sch_cnt), OVM_LOW);
              end else begin
                  `ovm_info(get_full_name(), $psprintf("POLL_SCH :: poll_timeout=%0d, ldb, cq_num=%0d, exp_sch_cnt=%0d, actual_sch_cnt=%0d", 
                                                        poll_timeout, cq_num, exp_sch_cnt, cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].mon_sch_cnt), OVM_LOW);
              end
              if (cq_type == "dir") begin
                  if (exp_sch_cnt == cfg.i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].mon_sch_cnt) begin
                      break;
                  end
              end else begin
                  if (exp_sch_cnt == cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].mon_sch_cnt) begin
                      break;
                  end
              end
              poll_timeout--;
              repeat (poll_delay) @(sla_tb_env::sys_clk_r);
          end

          if (poll_timeout == 0) begin
              if (cq_type == "dir") begin
                  `ovm_error(get_full_name(), $psprintf("POLL_SCH :: dir, cq_num=%0d exp_sch_cnt=%0d, actual_sch_cnt=%0d timed out", cq_num, exp_sch_cnt, cfg.i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].mon_sch_cnt))
              end else begin
                  `ovm_error(get_full_name(), $psprintf("POLL_SCH :: ldb, cq_num=%0d exp_sch_cnt=%0d, actual_sch_cnt=%0d timed out", cq_num, exp_sch_cnt, cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].mon_sch_cnt))
              end
          end

          reg_op_processed = 1'b1;
      end else if (reg_ops.ops == HQM_CFG_HCW_ENQ) begin
        int             num_hcw;
        bit [63:0]      pp_addr;
        hqm_hcw_enq_seq hcw_enq_seq;
        bit [127:0]     hcw_q[$];
        
        num_hcw = cfg.hcw_queues[reg_ops.poll_delay].hcw_q.size();
        
        pp_addr = reg_ops.offset;
        
        hcw_q = cfg.hcw_queues[reg_ops.poll_delay].hcw_q;
        
        `ovm_create(hcw_enq_seq)
        
        `ovm_rand_send_with(hcw_enq_seq, { 
                                             pp_enq_addr == pp_addr;
                                             sai == reg_ops.sai;
                                             hcw_enq_q.size == num_hcw;
                                             foreach (hcw_enq_q[i]) hcw_enq_q[i] == hcw_q[i];
                                         })
        
        cfg.hcw_queues[reg_ops.poll_delay].hcw_q.delete();
        reg_op_processed = 1'b1;
      end else if (reg_ops.ops == HQM_CFG_TEST_DONE) begin
        `ovm_info("CFG_SEQ",$psprintf("TEST_DONE: %d ns",reg_ops.poll_delay),OVM_HIGH)

        repeat (reg_ops.poll_delay) @(sla_tb_env::sys_clk_r);

        test_done               = 1'b1;
        reg_op_processed        = 1'b1;
      end else if ((reg_ops.file_name inside {cfg_files}) && (!(reg_ops.file_name inside { skip_files }))) begin
         if (reg_ops.sai[0] == 1) begin
           my_sai = {1'b0,3'b000, reg_ops.sai[3:1]};    // sla_ral_sai_t is 7 bits wide for a 6 bit SAI, pad upper bit with 0
         end else if ((reg_ops.sai[7:1] > 7'b0000111) && (reg_ops.sai[7:1] < 7'b0111111)) begin
           my_sai = {1'b0, reg_ops.sai[6:1]};
         end else begin
           my_sai = {1'b0, 6'b111111};
         end

         my_reg = ral.find_reg_by_file_name(reg_ops.reg_name, {tb_env_hier,".",reg_ops.file_name});
         if (my_reg == null) begin
            ovm_report_error("CFG_SEQ", $psprintf("Unable to find %s.%s regsiter", reg_ops.file_name, reg_ops.reg_name));
         end else begin
           if (reg_ops.field_name != "") begin
             my_field = my_reg.find_field(reg_ops.field_name);

             if (my_field == null) begin
               ovm_report_error("CFG_SEQ", $psprintf("Unable to find %s.%s.%s field", reg_ops.file_name, reg_ops.reg_name, reg_ops.field_name));
               return;
             end
           end else begin
             my_field = null;
           end

           my_access_path = get_access_method(my_reg);

           if (reg_ops.ops == HQM_CFG_WRITE) begin
             ovm_report_info("HQM_CFG_SEQ", $psprintf("Writing 0x%0h to %s.%s HQM_CFG_WRITE access_path %0s", my_reg.get_cfg_val(), reg_ops.file_name, reg_ops.reg_name, my_access_path), OVM_MEDIUM);
             if (my_access_path.tolower()  != "backdoor") begin
               my_reg.write(status, my_reg.get_cfg_val(), my_access_path, this, .sai(my_sai));
             end
             //backdoor
             else begin
               my_reg.write_backdoor(status, my_reg.get_cfg_val());   
             end 

             reg_op_processed = 1'b1;
           end else if (reg_ops.ops == HQM_CFG_CWRITE) begin
             if (this.skip_write_if_value_unchange && (my_reg.get() == my_reg.get_cfg_val())) begin
               ovm_report_info("HQM_CFG_SEQ", $psprintf("Skipping write 0x%0h to %s.%s", my_reg.get_cfg_val(), reg_ops.file_name, reg_ops.reg_name), OVM_MEDIUM);
               my_reg.set_actual(my_reg.get());
             end
             else begin
               ovm_report_info("HQM_CFG_SEQ", $psprintf("Writing 0x%0h to %s.%s HQM_CFG_CWRITE access_path %0s", my_reg.get_cfg_val(), reg_ops.file_name, reg_ops.reg_name, my_access_path), OVM_MEDIUM);
               if (my_access_path.tolower()  != "backdoor") begin
                 my_reg.write(status, my_reg.get_cfg_val(), my_access_path, this, .sai(my_sai));
               end
               //backdoor
               else begin
                 my_reg.write_backdoor(status, my_reg.get_cfg_val());   
               end 
             end 

             reg_op_processed = 1'b1;
           end else if (reg_ops.ops == HQM_CFG_WRITE_ERR) begin
             ovm_report_info("HQM_CFG_SEQ", $psprintf("Writing 0x%0h to %s.%s HQM_CFG_WRITE_ERR access_path %0s", my_reg.get_cfg_val(), reg_ops.file_name, reg_ops.reg_name, my_access_path), OVM_MEDIUM);
             if (my_access_path.tolower()  != "backdoor") begin
               my_reg.write(status, reg_ops.exp_rd_val, my_access_path, this, .ignore_access_error(SLA_TRUE), .sai(my_sai));
             end
             //backdoor
             else begin
               my_reg.write_backdoor(status, my_reg.get_cfg_val());   
             end 

             reg_op_processed = 1'b1;
           end else if ((reg_ops.ops == HQM_CFG_WRITE) || (reg_ops.ops == HQM_CFG_BWRITE)) begin
             ovm_report_info("HQM_CFG_SEQ", $psprintf("Writing 0x%0h to %s.%s HQM_CFG_WRITE|HQM_CFG_BWRITE access_path %0s", my_reg.get_cfg_val(), reg_ops.file_name, reg_ops.reg_name, my_access_path), OVM_MEDIUM);

             if ((my_access_path.tolower()  == "backdoor") || (reg_ops.ops == HQM_CFG_BWRITE)) begin
               my_reg.write(status, my_reg.get_cfg_val(), "backdoor", this, .sai(my_sai));
             end else begin
               my_reg.write(status, my_reg.get_cfg_val(), my_access_path, this, .sai(my_sai));
             end 

             reg_op_processed = 1'b1;
           end else if ((reg_ops.ops == HQM_CFG_READ) || (reg_ops.ops == HQM_CFG_BREAD)) begin
             if ((my_access_path.tolower()  == "backdoor") || (reg_ops.ops == HQM_CFG_BREAD)) begin
                ovm_report_info("HQM_CFG_SEQ", $psprintf("Reading %s.%s", reg_ops.file_name, reg_ops.reg_name), OVM_MEDIUM);
                if (reg_ops.field_name == "") begin
                  my_reg.read_backdoor(status, rd_val, this);
                end else begin
                  my_field.read_backdoor(status, rd_val, this);
                end
             end else begin //backdoor
                ovm_report_info("HQM_CFG_SEQ", $psprintf("Reading %s.%s HQM_CFG_READ access_path %0s", reg_ops.file_name, reg_ops.reg_name, my_access_path), OVM_MEDIUM);

                my_reg.readx(status, 0, 0, rd_val, my_access_path, SLA_FALSE, this, .sai(my_sai));
                rd_val &= my_reg.get_read_mask();

                if (reg_ops.field_name != "") begin
                  rd_val = my_field.get_actual();
                end
             end    

             if ((rd_val & reg_ops.exp_rd_mask) != (reg_ops.exp_rd_val & reg_ops.exp_rd_mask)) begin
               if (reg_ops.field_name == "") begin
                 `ovm_error("CFG_SEQ",$psprintf("Read: %s.%s mask 0x%0x read data (0x%08x) does not match expected data (0x%08x)",reg_ops.file_name, reg_ops.reg_name, reg_ops.exp_rd_mask, rd_val, reg_ops.exp_rd_val))
               end else begin
                 `ovm_error("CFG_SEQ",$psprintf("Read: %s.%s.%s mask 0x%0x read data (0x%08x) does not match expected data (0x%08x)",reg_ops.file_name, reg_ops.reg_name, reg_ops.field_name, reg_ops.exp_rd_mask, rd_val, reg_ops.exp_rd_val))
               end
             end else begin
               if (reg_ops.field_name == "") begin
                 if (reg_ops.exp_rd_mask == 0) begin
                   `ovm_info("CFG_SEQ",$psprintf("Read: %s.%s read data 0x%08x",reg_ops.file_name, reg_ops.reg_name, rd_val),OVM_MEDIUM)
                 end else begin
                   `ovm_info("CFG_SEQ",$psprintf("Read: %s.%s mask 0x%0x read data (0x%08x) matches expected data (0x%08x)",reg_ops.file_name, reg_ops.reg_name, reg_ops.exp_rd_mask, rd_val, reg_ops.exp_rd_val),OVM_MEDIUM)
                 end
               end else begin
                 if (reg_ops.exp_rd_mask == 0) begin
                   `ovm_info("CFG_SEQ",$psprintf("Read: %s.%s.%s read data 0x%08x",reg_ops.file_name, reg_ops.reg_name, reg_ops.field_name, rd_val),OVM_MEDIUM)
                 end else begin
                   `ovm_info("CFG_SEQ",$psprintf("Read: %s.%s.%s mask 0x%0x read data (0x%08x) matches expected data (0x%08x)",reg_ops.file_name, reg_ops.reg_name, reg_ops.field_name, reg_ops.exp_rd_mask, rd_val, reg_ops.exp_rd_val),OVM_MEDIUM)
                 end
               end
             end

             last_rd_val = rd_val;

             reg_op_processed = 1'b1;
           end else if (reg_ops.ops == HQM_CFG_READ_ERR) begin
             ovm_report_info("HQM_CFG_SEQ", $psprintf("Reading %s.%s HQM_CFG_READ_ERR access_path %0s", reg_ops.file_name, reg_ops.reg_name, my_access_path), OVM_MEDIUM);

             my_reg.readx(status, 0, 0, rd_val, my_access_path, SLA_FALSE, this, .ignore_access_error(SLA_TRUE), .sai(my_sai));
             rd_val &= my_reg.get_read_mask();

             if (reg_ops.field_name != "") begin
               rd_val = my_field.get_actual();
             end

             last_rd_val = rd_val;

             reg_op_processed = 1'b1;
           end else if (reg_ops.ops == HQM_CFG_POLL) begin
             int poll_cnt = 0;

             if (my_access_path.tolower()  != "backdoor") begin
               my_reg.readx(status, 0, 0, rd_val, my_access_path, SLA_FALSE, this, .sai(my_sai));
               rd_val &= my_reg.get_read_mask();

               if (reg_ops.field_name != "") begin
                 rd_val = my_field.get_actual();
               end
             end else begin //backdoor
               if (reg_ops.field_name == "") begin
                 my_reg.read_backdoor(status, rd_val, this);
               end else begin
                 my_field.read_backdoor(status, rd_val, this);
               end
             end    
             `ovm_info("CFG_SEQ",$psprintf("POLL_DEBUG0: my_reg.read_backdoor status=%0s, rd_val=0x%0x reg_ops.exp_rd_val=0x%0x poll_cnt=%0d", status.name(), rd_val, reg_ops.exp_rd_val, poll_cnt),OVM_HIGH)


             while (((rd_val & reg_ops.exp_rd_mask) != (reg_ops.exp_rd_val & reg_ops.exp_rd_mask)) && (poll_cnt < reg_ops.poll_timeout)) begin
               poll_cnt++;

               if (reg_ops.field_name == "") begin
                 `ovm_info("CFG_SEQ",$psprintf("POLL: %s.%s mask (0x%08x) read data (0x%08x) does not match expected data (0x%08x), poll_cnt=%0d",reg_ops.file_name, reg_ops.reg_name, reg_ops.exp_rd_mask, rd_val, reg_ops.exp_rd_val,poll_cnt),OVM_MEDIUM)
               end else begin
                 `ovm_info("CFG_SEQ",$psprintf("POLL: %s.%s.%s mask (0x%08x) read data (0x%08x) does not match expected data (0x%08x), poll_cnt=%0d",reg_ops.file_name, reg_ops.reg_name, reg_ops.field_name, reg_ops.exp_rd_mask, rd_val, reg_ops.exp_rd_val,poll_cnt),OVM_MEDIUM)
               end

               repeat (reg_ops.poll_delay) @(sla_tb_env::sys_clk_r);

               if (my_access_path.tolower()  != "backdoor") begin
                 my_reg.readx(status, 0, 0, rd_val, my_access_path, SLA_FALSE, this, .sai(my_sai));
                 rd_val &= my_reg.get_read_mask();

                 if (reg_ops.field_name != "") begin
                   rd_val = my_field.get_actual();
                 end
               end else begin //backdoor
                 if (reg_ops.field_name == "") begin
                   my_reg.read_backdoor(status, rd_val, this);
                   `ovm_info("CFG_SEQ",$psprintf("POLL_DEBUG1: my_reg.read_backdoor status=%0s, rd_val=0x%0x reg_ops.exp_rd_val=0x%0x poll_cnt=%0d", status.name(), rd_val, reg_ops.exp_rd_val, poll_cnt),OVM_HIGH)
                 end else begin
                   my_field.read_backdoor(status, rd_val, this);
                   `ovm_info("CFG_SEQ",$psprintf("POLL_DEBUG1: my_field.read_backdoor status=%0s, rd_val=0x%0x reg_ops.exp_rd_val=0x%0x poll_cnt=%0d", status.name(), rd_val, reg_ops.exp_rd_val, poll_cnt),OVM_HIGH)
                 end
               end    
             end

             if ((rd_val & reg_ops.exp_rd_mask) == (reg_ops.exp_rd_val & reg_ops.exp_rd_mask)) begin
               if (reg_ops.field_name == "") begin
                 `ovm_info("CFG_SEQ",$psprintf("POLL: %s.%s mask (0x%08x) read data (0x%08x) matches expected data (0x%08x)",reg_ops.file_name, reg_ops.reg_name, reg_ops.exp_rd_mask, rd_val, reg_ops.exp_rd_val),OVM_MEDIUM)
               end else begin
                 `ovm_info("CFG_SEQ",$psprintf("POLL: %s.%s.%s mask (0x%08x) read data (0x%08x) matches expected data (0x%08x)",reg_ops.file_name, reg_ops.reg_name, reg_ops.field_name, reg_ops.exp_rd_mask, rd_val, reg_ops.exp_rd_val),OVM_MEDIUM)
               end
             end else begin
               if (reg_ops.field_name == "") begin
                 `ovm_error("CFG_SEQ",$psprintf("POLL: %s.%s timeout rd_val=0x%0x reg_ops.exp_rd_val=0x%0x poll_cnt=%0d", reg_ops.file_name, reg_ops.reg_name, rd_val, reg_ops.exp_rd_val, poll_cnt))
               end else begin
                 `ovm_error("CFG_SEQ",$psprintf("POLL: %s.%s.%s timeout",reg_ops.file_name, reg_ops.reg_name, reg_ops.field_name))
               end
             end

             last_rd_val = rd_val;

             reg_op_processed = 1'b1;
           end  
         end
      end

  endtask

  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  virtual protected task body();  
      hqm_cfg_register_ops      reg_ops;
      bit                       reg_op_processed;
      bit                       test_done;

      if (ral == null) begin
        if(ral_type == "") begin
           `sla_fatal(get_type_name(), 
             ("RAL> You must set RAL Env for this sequence instance [%s] for the given IP/SoC using set_ral_type or set_ral_env API", get_full_name()));
           return;
        end 

        `sla_assert( $cast(ral, sla_utils::get_comp_by_type( ral_type )), ( ($psprintf("Could not find RAL Env Type [%s]\n", ral_type) )));
        if(ral == null)
           `sla_fatal(get_type_name(), 
                  ("RAL> Could not find RAL Env Type [%s]", ral_type));
      end

      reg_ops = cfg.get_next_register_from_access_list();

      while (reg_ops != null) begin
        process_reg_op(reg_ops,reg_op_processed,test_done);

        if (!reg_op_processed) begin
          `ovm_error("HQM_CFG_SEQ",$psprintf("Operation not recognized - ops=%s",reg_ops.ops.name()))
        end

        if (test_done) begin
          cfg.test_done = 1'b1;
        end

        reg_ops = cfg.get_next_register_from_access_list();
      end

  endtask

endclass
