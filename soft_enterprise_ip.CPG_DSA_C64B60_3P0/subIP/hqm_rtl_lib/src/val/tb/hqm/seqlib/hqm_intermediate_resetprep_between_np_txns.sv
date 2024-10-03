
`ifndef HQM_INTERMEDIATE_RESETPREP_BETWEEN_NP_TXNS__SV 
`define HQM_INTERMEDIATE_RESETPREP_BETWEEN_NP_TXNS__SV


import hqm_integ_seq_pkg::*;

class hqm_intermediate_resetprep_between_np_txns extends hqm_sla_pcie_base_seq;//hqm_base_seq;

  `ovm_sequence_utils(hqm_intermediate_resetprep_between_np_txns, sla_sequencer)

  hqm_reset_init_sequence               warm_reset_seq;
  hqm_sla_pcie_init_seq                 hqm_pcie_init;

  hqm_iosf_sb_resetPrep_seq             resetPrep_seq;

  hqm_iosf_sb_forcewake_seq             forcePwrGatePOK_seq;
  ovm_event_pool                        global_pool;
  ovm_event                             hqm_ResetPrepAck;
  ovm_event                             hqm_ForcePwrGatePOK;

  bit                                   send_ur_txn = $test$plusargs("HQM_RESETPREP_WITH_UR_TXN");

  function new(string name = "hqm_intermediate_resetprep_between_np_txns");
    super.new(name);
    global_pool  = ovm_event_pool::get_global_pool();
    hqm_ResetPrepAck = global_pool.get("hqm_ResetPrepAck");
    hqm_ForcePwrGatePOK = global_pool.get("hqm_ForcePwrGatePOK");
  endfunction

  task wait_sys_clk(int ticks=10);
   repeat(ticks) begin @(sla_tb_env::sys_clk_r); end
  endtask

  virtual task body();
      bit [31:0] write_data, write_data1;
      int reset_with_np_txs_on;
      int is_ur;
      int num_txns, wait_clks, txn_type;

      write_data =$urandom();
      write_data1 =$urandom();
      `ovm_info(get_full_name(),$psprintf("Starting hqm_intermediate_resetprep_between_np_txns: write_data=%0h, write_data1=%0h", write_data[31:0], write_data1[31:0]),OVM_LOW);

      // Write a reg & send reads (NP MMIO)
      hqm_msix_mem_regs.MSG_DATA[0].write(status, write_data[31:0], primary_id);
      hqm_msix_mem_regs.MSG_DATA[1].write(status, write_data1[31:0], primary_id);
      repeat (50) begin
          //hqm_msix_mem_regs.MSG_DATA[0].read(status, rd_val, primary_id);
          hqm_msix_mem_regs.MSG_DATA[0].readx(status, write_data[31:0], 32'hffffffff, rd_val, primary_id, SLA_FALSE, this);
      end

      // send a resetPrep
      `ovm_do(resetPrep_seq);
      `ovm_info(get_full_name(),$psprintf(" hqm_intermediate_resetprep_between_np_txns: Reset Prep initiated"),OVM_LOW);

      // depending on the requirement, either wait for resetPrep_Ack or not, followed by burst of NP MRd64 Txns; let the warm reset flow to continue in parallel and come out once warm reset entry & exit is compelte
      fork
      begin
          if ($test$plusargs("WAIT_RESETPREP_ACK")) begin
              `ovm_info(get_full_name(),$psprintf(" hqm_intermediate_resetprep_between_np_txns:  waiting for Reset Prep Ack"),OVM_LOW);
              hqm_ResetPrepAck.wait_trigger();
              is_ur=1; // after ResetPrep_Ack is received, HQM should UR any following NP Txns
          end

          if ($test$plusargs("HQM_WAIT_FORCEPWRGATEPOK")) begin
              `ovm_info(get_full_name(),$psprintf(" hqm_intermediate_resetprep_between_np_txns:  waiting for ForcePwrGatePOK trigger"),OVM_LOW);
              hqm_ForcePwrGatePOK.wait_trigger();
              `ovm_info(get_full_name(),$psprintf(" hqm_intermediate_resetprep_between_np_txns:  Received ForcePwrGatePOK trigger"),OVM_LOW);
              if (!$value$plusargs("HQM_WAIT_CLKS=%d", wait_clks)) begin
                  wait_clks = 10;
              end 
              `ovm_info(get_full_name(),$psprintf("wait_clks=%d", wait_clks),OVM_LOW);
              wait_sys_clk(.ticks(wait_clks));
          end

          `ovm_info(get_full_name(),$psprintf(" hqm_intermediate_resetprep_between_np_txns: Started Issuing NP MRd64 during Reset Prep"),OVM_LOW);
          if (!$test$plusargs("SKIP_NP_TXNS_IN_WARMRESET")) begin
              if (!$value$plusargs("HQM_NUM_TXNS=%d", num_txns)) begin
                  num_txns = 100;
              end 
              if (!$value$plusargs("HQM_TXN_TYPE=%d", txn_type)) begin
                  txn_type = 1;
              end 
              `ovm_info(get_full_name(),$psprintf("num_txns=%d, txn_type=%d", num_txns, txn_type),OVM_LOW);
              repeat (num_txns) begin
                  if ((txn_type == 1) || (txn_type == 0)) begin // non posted
                      if(send_ur_txn) send_tlp(get_tlp('h_0, Iosf::MRd64), .ur(1));
                      hqm_msix_mem_regs.MSG_DATA[1].read(status, rd_val, primary_id, .ignore_access_error(is_ur));
                  end     
                  if ((txn_type == 2) || (txn_type == 0)) begin // posted
                      if(send_ur_txn) send_tlp(get_tlp('h_0, Iosf::MWr64));
                      hqm_msix_mem_regs.MSG_DATA[1].write(status, write_data1[31:0], primary_id);
                  end     
                  `ovm_info(get_full_name(),$psprintf(" hqm_intermediate_resetprep_between_np_txns:  DEBUG0: Issuing NP MRd64 during Reset Prep: is_ur=%d, status=%0s", is_ur, status),OVM_LOW);
              end
          end
          `ovm_info(get_full_name(),$psprintf(" hqm_intermediate_resetprep_between_np_txns:  Done Issuing NP MRd64 during Reset Prep"),OVM_LOW);
          while(1) begin 
            wait_sys_clk(100); 
            if(reset_with_np_txs_on) break; 
          end 
      end
      begin
          hqm_ResetPrepAck.wait_trigger();
          is_ur=1; // after ResetPrep_Ack is received, HQM should UR any following NP Txns
          `ovm_info(get_full_name(),$psprintf("Warm Reset Started:is_ur=%d", is_ur),OVM_LOW);
          `ovm_do(warm_reset_seq)
          wait_sys_clk(1200); 
          reset_with_np_txs_on=1;
          `ovm_info(get_full_name(),$psprintf("Warm Reset Ended"),OVM_LOW);
      end
      begin 
          while(1) begin 
            wait_sys_clk(100); 
            if(reset_with_np_txs_on) break; 
          end 
          `ovm_info(get_full_name(),$psprintf("Done with waiting for NP Txns " ),OVM_LOW);
      end
      join_any

      // Initialize HQM & send a mem write followed by some NP MRd64 Txns
      `ovm_do(hqm_pcie_init);
      write_data =$urandom();
      hqm_msix_mem_regs.MSG_DATA[0].write(status, write_data[31:0], primary_id);
      repeat (50) begin
          //hqm_msix_mem_regs.MSG_DATA[0].read(status, rd_val, primary_id);
          hqm_msix_mem_regs.MSG_DATA[0].readx(status, write_data[31:0], 32'hffffffff, rd_val, primary_id, SLA_FALSE, this);
      end

      `ovm_info(get_full_name(),$psprintf(" Done with hqm_intermediate_resetprep_between_np_txns"),OVM_LOW);

  endtask

endclass
`endif


