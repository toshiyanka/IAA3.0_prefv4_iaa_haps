import hqm_cfg_pkg::*;
import hqm_cfg_seq_pkg::*;
import hqm_tb_cfg_pkg::*;
import hqm_saola_pkg::*;
import hqm_integ_seq_pkg::*;
//import pcie_seqlib_pkg::*;

class hqm_tb_cfg_seq extends hqm_cfg_seq;

  `ovm_sequence_utils(hqm_tb_cfg_seq, sla_sequencer)
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  //NS: rndcfg fix process_cq_seq                i_pp_cq_process;

  Iosf::address_t       addr;

  int                   ral_size;

  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_rd_seq                cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq                mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_wr_seq                cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq                mem_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_hcw_enq_seq               hcw_enq_seq;

  hqm_tb_sequences_pkg::hqm_iosf_sb_resetPrep_seq                    resetprep_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_forcewake_seq                    forcepwrgatepok_seq;
    
  function new(string name = "hqm_tb_cfg_seq");
     super.new(name);
     //NS: rndcfg fix i_pp_cq_process = process_cq_seq::type_id::create("i_pp_cq_process");
  endfunction
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  virtual protected task process_reg_op(hqm_cfg_register_ops  reg_ops, output bit reg_op_processed, output bit test_done);  
      sla_status_t          status;
      sla_ral_reg           my_reg;
      sla_ral_field         my_field;
      sla_ral_data_t        rd_val;
      hqm_tb_cfg            i_hqm_tb_cfg;
      logic [4:0]           flr_fn_no;
      bit                   do_seq;
      string                access_path;
      //hqm_sla_pcie_flr_sequence     flr_seq;
      //hqm_sla_pcie_init_seq         sys_init;
      //hqm_rndcfg_tgen_seq           tgen;
      //pool_init_seq                 i_pool_init_seq;
//      hqm_sla_pcie_hcw_enqueue_sequence       hcw_enq_seq ;

      if (!$cast(i_hqm_tb_cfg,cfg))
          `ovm_error("HQM_TB_CFG_SEQ","Error casting cfg to i_hqm_tb_cfg")

      reg_op_processed = 1'b1;
      test_done = 1'b1;


    case (reg_ops.ops)
        HQM_CFG_OREAD:  begin 
                          my_reg = ral.find_reg_by_file_name(reg_ops.reg_name, reg_ops.file_name);
                          if (my_reg == null) begin
                            ovm_report_error("CFG_SEQ", $psprintf("Unable to find %s.%s regsiter", reg_ops.file_name, reg_ops.reg_name));
                          end else begin
                            addr = my_reg.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type()) + reg_ops.offset;
                            `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr; iosf_sai == reg_ops.sai; iosf_exp_error == 0;})
                            rd_val = mem_read_seq.iosf_data;

                            if (mem_read_seq.iosf_cpl_status != 3'b000) begin
                              ovm_report_error("CFG_SEQ", $psprintf("Did not expect read error for %s.%s register + offset %0d", reg_ops.file_name, reg_ops.reg_name, reg_ops.offset));
                            end else begin
                              if ((rd_val & reg_ops.exp_rd_mask) != (reg_ops.exp_rd_val & reg_ops.exp_rd_mask)) begin
                                `ovm_error("CFG_SEQ",$psprintf("Read: %s.%s mask 0x%0x read data (0x%08x) does not match expected data (0x%08x)",reg_ops.file_name, reg_ops.reg_name, reg_ops.exp_rd_mask, rd_val, reg_ops.exp_rd_val))
                              end else begin
                                if (reg_ops.exp_rd_mask == 0) begin
                                  `ovm_info("CFG_SEQ",$psprintf("Read: %s.%s read data 0x%08x",reg_ops.file_name, reg_ops.reg_name, rd_val),OVM_LOW)
                                end else begin
                                  `ovm_info("CFG_SEQ",$psprintf("Read: %s.%s mask 0x%0x read data (0x%08x) matches expected data (0x%08x)",reg_ops.file_name, reg_ops.reg_name, reg_ops.exp_rd_mask, rd_val, reg_ops.exp_rd_val),OVM_LOW)
                                end
                              end
                            end
                          end
                        end

        HQM_CFG_OREAD_ERR:  begin 
                          my_reg = ral.find_reg_by_file_name(reg_ops.reg_name, reg_ops.file_name);
                          if (my_reg == null) begin
                            ovm_report_error("CFG_SEQ", $psprintf("Unable to find %s.%s regsiter", reg_ops.file_name, reg_ops.reg_name));
                          end else begin
                            addr = my_reg.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type()) + reg_ops.offset;
                            `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr; iosf_sai == reg_ops.sai; iosf_exp_error == 1;})
                            rd_val = mem_read_seq.iosf_data;
                            if (mem_read_seq.iosf_cpl_status == 3'b000) begin
                              ovm_report_error("CFG_SEQ", $psprintf("Expected read error for %s.%s register + offset %0d", reg_ops.file_name, reg_ops.reg_name, reg_ops.offset));
                            end
                          end
                        end

        HQM_CFG_OWRITE,HQM_CFG_OWRITE_ERR:  begin 
                          my_reg = ral.find_reg_by_file_name(reg_ops.reg_name, reg_ops.file_name);
                          if (my_reg == null) begin
                            ovm_report_error("CFG_SEQ", $psprintf("Unable to find %s.%s regsiter", reg_ops.file_name, reg_ops.reg_name));
                          end else begin
                            addr = my_reg.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type()) + reg_ops.offset;
                            `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr; iosf_data.size() == 1; iosf_data[0] == reg_ops.exp_rd_val[31:0]; iosf_sai == reg_ops.sai;})
                            `ovm_info("CFG_SEQ",$psprintf("Offset Write: %s.%s + %0d data 0x%08x",reg_ops.file_name, reg_ops.reg_name, reg_ops.offset, reg_ops.exp_rd_val),OVM_LOW)
                          end
                        end

        HQM_RUNTST_GO  :begin
                            //i_pp_cq_process.start(get_sequencer());
                            //`ovm_create(tgen);
                            //`ovm_send(tgen);
                        end

        HQM_RESETPREP:begin
                            `ovm_do(resetprep_seq);
                      end

        HQM_FORCEPWRGATEPOK:begin
                            `ovm_do(forcepwrgatepok_seq);
                      end

        HQM_SYSRST_FLR :begin 
                            flr_fn_no=i_hqm_tb_cfg.flr_Q.pop_front();
                            //`ovm_do_with(flr_seq,{func_no==flr_fn_no;}) 
                        end
        HQM_WARM_RST   :begin 
                            cfg.set_cfg("force hqm_tb_top.prim_rst_b 0",do_seq);
                            #(i_hqm_tb_cfg.warm_reset_delay);
                            cfg.set_cfg("force hqm_tb_top.prim_rst_b 1",do_seq);
                            #(i_hqm_tb_cfg.warm_reset_delay);
                        end
    
        HQM_SYS_INIT   :begin 
                            //`ovm_do(sys_init) 
                        end

        HQM_POOL_INIT  :begin
                            //i_pool_init_seq = pool_init_seq::type_id::create("i_pool_init_seq");
                            //i_pool_init_seq.pool_name = reg_ops.reg_name;
                            //i_pool_init_seq.start(get_sequencer());
                        end

        HQM_PF_INIT    :begin 
                            i_hqm_tb_cfg.update_pf_configuration();
                        end

        HQM_VF_INIT    :begin 
                            i_hqm_tb_cfg.update_vf_configuration(reg_ops.exp_rd_val);
                        end
    
        HQM_PKT_ENQ    :begin 
                            i_hqm_tb_cfg.loc_hcw_trans=i_hqm_tb_cfg.hcw_trans_Q.pop_front();
                            i_hqm_tb_cfg.loc_hcw_trans.iptr[63:48] = i_hqm_tb_cfg.GetGlblSeqNum(); //Used by RTL->Unique//
    
//                            `ovm_create(hcw_enq_seq);
//                            hcw_enq_seq.hcw_trans=i_hqm_tb_cfg.loc_hcw_trans;
//                            `ovm_send(hcw_enq_seq); 
    
                            i_hqm_tb_cfg.loc_hcw_trans.set_sequencer(p_sequencer.pick_sequencer("hcw_sequencer"));
                            start_item(i_hqm_tb_cfg.loc_hcw_trans);
                            `ovm_info(get_name(),"Sending HCW via HQM_PKT_ENQ",OVM_LOW);
                            i_hqm_tb_cfg.loc_hcw_trans.print();
                            finish_item(i_hqm_tb_cfg.loc_hcw_trans);
                            if(i_hqm_tb_cfg.hcw_trans_Q.size()>4)    begin
                                #100; `ovm_info(get_name(),$sformatf("Wating 100ns -> (hcw_trans_Q.size==%0d > 4)",i_hqm_tb_cfg.hcw_trans_Q.size()),OVM_LOW);
                            end
                        end

        HQM_CFG_PRIM_HCW_ENQ : begin
                           int             num_hcw;
                           bit [63:0]      pp_addr;
                           bit [127:0]     hcw_q[$];

                           `ovm_info(get_name(),"hqm_tb_cfg_seq.ops.HQM_CFG_PRIM_HCW_ENQ Sending HCW via PRIM_HCW_ENQ_SEQ",OVM_LOW);

                           num_hcw = cfg.hcw_queues[reg_ops.poll_delay].hcw_q.size();
        
                           pp_addr = reg_ops.offset;
        
                           hcw_q = cfg.hcw_queues[reg_ops.poll_delay].hcw_q;
                           `ovm_info(get_name(), $psprintf("hqm_tb_cfg_seq.ops.HQM_CFG_PRIM_HCW_ENQ Sending HCW via PRIM_HCW_ENQ_SEQ pp_addr=0x%0x pp_addr[25]=%0d num_hcw=%0d", pp_addr, pp_addr[25], num_hcw), OVM_MEDIUM);

                            `ovm_do_on_with(hcw_enq_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), { 
                                                                                          pp_enq_addr == pp_addr; 
                                                                                          hcw_enq_q.size == num_hcw; 
                                                                                          foreach (hcw_enq_q[i]) hcw_enq_q[i] == hcw_q[i];  
                                                                                          iosf_sai == reg_ops.sai;})

                           cfg.hcw_queues[reg_ops.poll_delay].hcw_q.delete();
                           reg_op_processed = 1'b1;

                        end

        default:            reg_op_processed = 1'b0; 
    endcase

    if (!reg_op_processed) begin
        super.process_reg_op(reg_ops,reg_op_processed,test_done);
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
          `ovm_error("HQM_CFG_SEQ",$psprintf("Operation not recognized - ops=%d",reg_ops.ops))
        end

        if (test_done) begin
          cfg.test_done = 1'b1;
        end

        reg_ops = cfg.get_next_register_from_access_list();
      end

  endtask

endclass
