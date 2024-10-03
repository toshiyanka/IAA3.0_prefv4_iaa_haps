// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2018) (2018) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
// File   : hqm_walking_1s_sai_hcw_seq.sv
//
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_walking_1s_sai_hcw_seq extends hqm_base_seq;

   `ovm_sequence_utils(hqm_walking_1s_sai_hcw_seq, sla_sequencer)

   typedef struct {
      bit [7:0]   sai_6bit_to_8bit[$];
   } sai_queue_t;

   sai_queue_t sai_queues[64];

   sla_ral_reg                   func_bar_u_reg;
   sla_ral_reg                   func_bar_l_reg;

   function new (string name = "hqm_walking_1s_sai_hcw_seq");

       super.new(name);

       for (bit [8:0] sai8 = 0 ; sai8 < 9'h100 ; sai8++) begin
           if (sai8[0] == 1'b1) begin
              sai_queues[{3'b000,sai8[3:1]}].sai_6bit_to_8bit.push_back(sai8);
           end else if ((sai8[7:1] > 7'b0000111) && (sai8[7:1] < 7'b0111111)) begin
              sai_queues[sai8[6:1]].sai_6bit_to_8bit.push_back(sai8);
           end else begin
              sai_queues[6'b111111].sai_6bit_to_8bit.push_back(sai8);
           end
        end

        func_bar_u_reg = ral_env.find_reg_by_file_name("func_bar_u", "hqm_pf_cfg_i");
        func_bar_l_reg = ral_env.find_reg_by_file_name("func_bar_l", "hqm_pf_cfg_i");
   endfunction : new 
 
  function bit [7:0] get_8bit_sai(sla_ral_sai_t sai6);
    sai6 = sai6 & 6'h3f;
    return (sai_queues[sai6].sai_6bit_to_8bit[$urandom_range(sai_queues[sai6].sai_6bit_to_8bit.size()-1,0)]);
  endfunction

  virtual task body();

     bit [63:0] csr_wac;

     get_hqm_pp_cq_status();
     get_hqm_cfg();

     if ($value$plusargs("CSR_WAC=0x%0x", csr_wac)) begin

         sla_ral_data_t rd_val;

         ovm_report_info(get_full_name(), $psprintf("CSR_WAC=0x%0x", csr_wac), OVM_LOW);
         write_reg("hqm_csr_wac_lo", csr_wac[31:0], "hqm_sif_csr");
         write_reg("hqm_csr_wac_hi", csr_wac[63:32], "hqm_sif_csr");

         // -- for wac_lo register as all bits are RW
        // csr_wac[31:0]  |= 32'h0100_020a;
        // csr_wac[63:32] |= 32'h0000_0400;
         compare_reg("hqm_csr_wac_lo", csr_wac[31:0],  rd_val, "hqm_sif_csr");
         compare_reg("hqm_csr_wac_hi", csr_wac[63:32], rd_val, "hqm_sif_csr");

     end else begin
         ovm_report_fatal(get_full_name(), $psprintf("No CSR_WAC plusargs found."));
     end

     for (int i = 0; i < 17 ; i++) begin
         fork
             automatic int j = i;
             begin
                 bit [127:0] hcw_q[$];

                 hcw_q.delete();

                 for(int k = 0 ; k < 100 ; k++) begin
                     int sai;

                     if ($value$plusargs({ $psprintf("DIR_PP%0d_SAI=0x", j), "%0x"}, sai)) begin
                         ovm_report_info(get_full_name(), $psprintf("8 bit SAI value for DIR_PP%0d_SAI=0x%0x", j, sai), OVM_LOW);
                         do_pf_hcw(.sai(sai), .pp(j), .qid(j), .hcw_batch((k == 99)? 0 : $urandom), .hcw_q(hcw_q));
                     end else begin
                         do_pf_hcw(.sai(-1), .pp(j), .qid(j), .hcw_batch((k == 99)? 0 : $urandom), .hcw_q(hcw_q));
                     end
                 end
             end
         join_none
     end
     wait fork;

     // -- Wait for tokens
     for (int i = 0; i < 17 ; i++) begin
         fork
             automatic int j = i;
             wait_for_sch_cnt(0, j, 100);
         join_none
     end
     wait fork;

     for (int i = 0; i < 17 ; i++) begin
         fork
             automatic int j = i;
             begin
                 do_pf_hcw_token_ret(j, j);
             end
         join_none
     end
     wait fork;

  endtask

  virtual task do_pf_hcw(int sai, bit [5:0] pp, bit [5:0] qid, bit hcw_batch, ref bit [127:0] hcw_q[$]);
    bit [7:0]           sai8;
    sla_ral_reg         my_reg;

    my_reg = get_reg_handle("msg_addr_l[0]", "hqm_msix_mem");

    if (sai == -1) begin
        sai8 = get_8bit_sai(my_reg.pick_legal_sai_value(RAL_WRITE));
    end else begin
        sai8 = sai;
    end
    do_hcw(.sai8(sai8), .pp(pp), .qid(qid), .hcw_batch(hcw_batch), .hcw_q(hcw_q));

  endtask

  task do_pf_hcw_token_ret(bit [5:0] pp, bit [5:0] qid);
    bit [7:0]           sai8;
    sla_ral_reg         my_reg;

    bit [127:0] hcw_q[$];

    hcw_q.delete();

    my_reg = get_reg_handle("msg_addr_l[0]", "hqm_msix_mem");

    sai8 = get_8bit_sai(my_reg.pick_legal_sai_value(RAL_WRITE));
    do_hcw(.sai8(sai8), .pp(pp), .qid(qid), .hcw_batch(1'b0), .qe_valid(1'b0), .tok_ret_cnt(100), .hcw_q(hcw_q));

  endtask

  virtual task do_hcw(bit [7:0] sai8, bit [5:0] pp, bit [5:0] qid,  bit hcw_batch = 1'b0, bit qe_valid = 1, int tok_ret_cnt = 0, ref bit [127:0] hcw_q[$]);
    hcw_transaction     hcw_trans;
    bit [127:0]         hcw_data_bits;
    bit [63:0]          pp_addr;
    hqm_hcw_enq_seq     hcw_enq_seq;
    sla_ral_data_t      ral_data;
    int                 num_hcw;

    hcw_trans = hcw_transaction::type_id::create("hcw_trans");

    hcw_trans.randomize();

    hcw_trans.rsvd0                     = '0;
    hcw_trans.dsi_error                 = '0;
    hcw_trans.no_inflcnt_dec            = '0;
    hcw_trans.dbg                       = '0;
    hcw_trans.cmp_id                    = '0;
    hcw_trans.is_nm_pf                  = '0;
    hcw_trans.is_vf                     = '0;
    hcw_trans.vf_num                    = '0;
    hcw_trans.sai                       = sai8;
    hcw_trans.rtn_credit_only           = '0;
    hcw_trans.exp_rtn_credit_only       = '0;
    hcw_trans.ingress_drop              = '0; 
    hcw_trans.exp_ingress_drop          = '0;
    hcw_trans.meas                      = '0;
    hcw_trans.ordqid                    = '0;
    hcw_trans.ordpri                    = '0;
    hcw_trans.ordlockid                 = '0;
    hcw_trans.ordidx                    = '0;
    hcw_trans.reord                     = '0;
    hcw_trans.frg_cnt                   = '0;
    hcw_trans.frg_last                  = '0;
    hcw_trans.hcw_batch                 = hcw_batch;

    hcw_trans.qe_valid                  = qe_valid;
    hcw_trans.qe_orsp                   = 0;
    hcw_trans.qe_uhl                    = 0;
    hcw_trans.cq_pop                    = (tok_ret_cnt > 0) ? 1 : 0;
    hcw_trans.is_ldb                    = 0;
    hcw_trans.ppid                      = pp; 
    hcw_trans.qtype                     = QDIR;
    hcw_trans.qid                       = qid;
    hcw_trans.qpri                      = 0;
    hcw_trans.lockid                    = tok_ret_cnt - 1;
    hcw_trans.msgtype                   = 0;
    hcw_trans.idsi                      = 0;
    hcw_trans.tbcnt                     = hcw_trans.get_transaction_id();
    hcw_trans.iptr                      = hcw_trans.tbcnt;

    if (hcw_trans.reord == 0)
      hcw_trans.ordidx = hcw_trans.tbcnt;

    //---- 
    //-- determine enqattr
    //----    
    hcw_trans.enqattr = 2'h0;   
    hcw_trans.sch_is_ldb = (hcw_trans.qtype == QDIR)? 1'b0 : 1'b1;
    if (hcw_trans.qe_valid == 1 && hcw_trans.qtype != QORD ) begin
      if (hcw_trans.qtype == QDIR ) begin
        hcw_trans.enqattr = 2'h0;      
      end else begin
        hcw_trans.enqattr[1:0] = {hcw_trans.qe_orsp, hcw_trans.qe_uhl};        
      end                      
    end
    
    //----    
    //-- hcw_trans.isdir is hidden info in ptr
    //----    
    if(hcw_trans.qtype == QDIR) hcw_trans.isdir=1;
    else                   hcw_trans.isdir=0;
    
    hcw_trans.set_hcw_trinfo(1);           //--kind=1: do not set iptr[63:48]=tbcnt
    
    //-- pass hcw_item to sb
    i_hqm_cfg.write_hcw_gen_port(hcw_trans);
    
    hcw_data_bits = hcw_trans.byte_pack(0);

    hcw_q.push_back(hcw_data_bits);
    
    if (qe_valid) begin
      i_hqm_pp_cq_status.wait_for_vas_credit(0);
    end

    `ovm_info(get_type_name(),"Sending HCW transaction",OVM_LOW);
    hcw_trans.print();

    if ((hcw_trans.hcw_batch == 0) || hcw_q.size() >= 4) begin
      pp_addr = 64'h0000_0000_0200_0000;
      
      ral_data = func_bar_u_reg.get_actual();
      
      pp_addr[63:32] = ral_data[31:0];
      
      ral_data = func_bar_l_reg.get_actual();
      
      pp_addr[31:26] = ral_data[31:26];
    
      pp_addr[19:12] = hcw_trans.ppid;
      pp_addr[20]    = hcw_trans.is_ldb;
      pp_addr[21]    = hcw_trans.is_nm_pf;
      pp_addr[9:6]   = 4'h0;

      num_hcw = hcw_q.size();

      `ovm_create(hcw_enq_seq)
    
      `ovm_rand_send_with(hcw_enq_seq, { 
                                           pp_enq_addr == pp_addr;
                                           sai == hcw_trans.sai;
                                           hcw_enq_q.size == num_hcw;
                                           foreach (hcw_enq_q[i]) hcw_enq_q[i] == hcw_q[i];
                                       })


      hcw_q.delete();
    end
  endtask


endclass : hqm_walking_1s_sai_hcw_seq
