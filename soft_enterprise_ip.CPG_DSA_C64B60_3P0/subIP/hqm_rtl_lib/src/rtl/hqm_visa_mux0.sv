//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
// hqm_visa
//
// This module is responsible for flopping (and synchronizing some) top-level hqm_sif signals.
//
//-----------------------------------------------------------------------------------------------------

module hqm_visa_mux0
// collage-pragma translate_off

     import hqm_core_pkg::*, hqm_sif_pkg::*;

// collage-pragma translate_on


(

     input  logic                     fvisa_frame_vcfn
    ,input  logic                     fvisa_serdata_vcfn
    ,input  logic                     fvisa_serstb_vcfn
    ,input  logic [8:0]               fvisa_startid0_vcfn

    ,input  logic                     prim_freerun_clk
    ,input  logic                     powergood_rst_b
    

    ,input  logic                     visa_all_dis
    ,input  logic                     visa_customer_dis

    ,output logic [7:0]               avisa_dbgbus0_vcfn

    ,input  logic [679:0]             hqm_sif_visa             // iosf visa
    ,input  logic [31:0]              hqm_pmsm_visa             // pm_unit visa
 
    , input  logic                    fscan_mode

);

// collage-pragma translate_off

    
    `include "hqm_visa_mux0.VISA_IT.hqm_visa_mux0.wires.sv" // Auto Included by VISA IT - *** Do not modify this line ***
    typedef struct packed {
   
      logic           flr_cmp_sent;                                  // 333
      logic           flr_triggered_wl;                              // 332
      logic           flr_clk_enable;                                // 331
      logic           flr_clk_enable_system;                         // 330
      logic           prim_clk_enable_cdc;                           // 329
      logic           flr_triggered;                                 // 328
      logic           ps_d0_to_d3;                                   // 327
      logic           flr_function0;                                 // 326
   
      logic           flr_treatment;                                 // 325
      logic           flr_pending;                                   // 324
      logic           bme_or_mem_wr;                                 // 323
      logic           ps_txn_sent_q;                                 // 322
      logic           ps_cmp_sent_q;                                 // 321
      logic           ps_cmp_sent_ack;                               // 320
      logic           flr_txn_sent_q;                                // 319
      logic           flr_cmp_sent_q;                                // 318
      logic           flr;                                           // 317
      logic           pf0_fsm_rst;                                   // 316
      logic   [1:0]   ps;                                            // 315:314
   
      logic           sw_trigger;                                    // 313
      logic           prim_gated_rst_b_sync;                         // 312
      logic           prim_clk_enable;                               // 311
      logic           prim_clk_enable_sys;                           // 310
   
      logic           prim_clkreq_sync;                              // 309
      logic           prim_clkack_sync;                              // 308
      logic           hqm_idle_q;                                    // 307
      logic           sys_mstr_idle;                                 // 306
      logic           sys_tgt_idle;                                  // 305
      logic           sys_ri_idle;                                   // 304
      logic           sys_ti_idle;                                   // 303
      logic           sys_cfgm_idle;                                 // 302
   
      logic   [2:0]   iosf_tgt_dec_bits;                             // 301:299 
      logic   [3:0]   iosf_tgt_dec_type;                             // 298:295 
      logic           iosf_tgt_idle;                                 // 294
                                                                                          
      logic   [1:0]   iosf_tgt_cput_cmd_rtype;                       // 293:292 
      logic           iosf_tgt_cput_cmd_put;                         // 291 
      logic   [1:0]   iosf_tgt_cmd_tfmt;                             // 290:289 
      logic           iosf_tgt_has_data;                             // 288 
      logic   [9:0]   iosf_tgt_data_count_ff;                        // 287:278
                                                                                  
      logic           iosf_tgt_crdtinit_in_progress;                 // 277 
      logic           iosf_tgt_rst_complete;                         // 276 
      logic           iosf_tgt_credit_init;                          // 275
      logic           iosf_tgt_zero;                                 // 274 
      logic   [3:0]   iosf_tgt_port_present;                         // 273:270 
   
      logic   [31:0]  mstr_iosf_cmd_caddress_31_0;                   // 269:238  

      logic   [3:0]   mstr_iosf_cmd_clbe;                            // 237:234 
      logic   [3:0]   mstr_iosf_cmd_cfbe;                            // 233:230 

      logic   [7:0]   mstr_iosf_cmd_ctag;                            // 229:222 

      logic   [15:0]  mstr_iosf_cmd_crqid;                           // 221:206 

      logic   [7:0]   mstr_iosf_cmd_clength_7_0;                     // 205:198 

      logic           mstr_iosf_cmd_cth;                             // 197 
      logic           mstr_iosf_cmd_cep;                             // 196 
      logic           mstr_iosf_cmd_cro;                             // 195 
      logic           mstr_iosf_cmd_cns;                             // 194 
      logic           mstr_iosf_cmd_cido;                            // 193 
      logic   [1:0]   mstr_iosf_cmd_cat;                             // 192:191 
      logic           mstr_iosf_cmd_ctd;                             // 190 

      logic           mstr_iosf_gnt_q_gnt2;                          // 189 
      logic   [1:0]   mstr_iosf_cmd_cfmt;                            // 188:187 
      logic   [4:0]   mstr_iosf_cmd_ctype;                           // 186:182 

      logic   [2:0]   mstr_iosf_req_dlen_4_2;                        // 181:179 
      logic   [4:0]   mstr_iosf_req_credits_cpl;                     // 178:174 

      logic   [1:0]   mstr_iosf_req_dlen_1_0;                        // 173:172 
      logic           mstr_data_out_valid_q;                         // 171 
      logic   [4:0]   mstr_iosf_req_credits_p;                       // 170:166 

      logic           mstr_idle;                                     // 165 
      logic   [1:0]   mstr_hfifo_data_fmt;                           // 164:163
      logic   [4:0]   mstr_hfifo_data_type;                          // 162:158 

      logic   [1:0]   mstr_rxq_hdr_avail;                            // 157:156 
      logic   [1:0]   mstr_iosf_gnt_q_dec;                           // 155:154 
      logic   [1:0]   mstr_req_fifo_empty;                           // 153:152 
      logic   [1:0]   mstr_req_fifo_fully;                           // 151:150 

      logic   [2:0]   mstr_prim_ism_agent;                           // 149:147 
      logic           mstr_dfifo_rd_gt4dw;                           // 146
      logic   [1:0]   mstr_dfifo_rd;                                 // 145:144
      logic   [1:0]   mstr_hfifo_rd;                                 // 143:142 

      logic   [1:0]   mstr_iosf_gnt_q_gtype;                         // 141:140 
      logic   [1:0]   mstr_iosf_gnt_q_rtype;                         // 139:138 
      logic           mstr_iosf_gnt_q_gnt;                           // 137 
      logic   [1:0]   mstr_iosf_req_rtype;                           // 136:135
      logic           mstr_iosf_req_put;                             // 134

      logic           mstr_iosfp_ti_rxq_rdy;                         // 133
      logic           mstr_iosfp_ri_rxq_rsprepack_vote_ri;           // 132 
      logic           mstr_iosf_ep_poison_wr_sent_rl;                // 131 
      logic   [4:0]   mstr_iosf_ep_poison_wr_func_rxl;               // 130:126 

      logic           rxq_ti_rsprepack_vote_rp_q;                    // 125 
      logic           rxq_ri_iosfp_quiesce_rp;                       // 124 
      logic           cplhdr_rxq_fifo_perr_q;                        // 123 
      logic           ioq_rxq_fifo_pop;                              // 122 
      logic           phdr_rxq_fifo_pop;                             // 121 
      logic           pdata_rxq_fifo_pop;                            // 120 
      logic           cplhdr_rxq_fifo_pop;                           // 119 
      logic           cpldata_rxq_fifo_pop;                          // 118 

      logic           rxq_ti_iosfp_ifc_wxi_stp;                      // 117 
      logic           rxq_ti_iosfp_ifc_wxi_endp;                     // 116 
      logic           phdr_rxq_fifo_perr_q;                          // 115 
      logic           ioq_rxq_fifo_push;                             // 114 
      logic           phdr_rxq_fifo_push;                            // 113 
      logic           pdata_rxq_fifo_push;                           // 112 
      logic           cplhdr_rxq_fifo_push;                          // 111 
      logic           cpldata_rxq_fifo_push;                         // 110 

      logic           rxq_ti_iosfp_push_wi;                          // 109 
      logic   [6:0]   rxq_pcie_cmd;                                  // 108:102
   
      logic           tlq_tlq_pdataval_wp;                           // 101 
      logic           tlq_npdataval_wp;                              // 100 
                                                                           
      logic           tlq_ioq_fifo_full;                             //  99 
      logic           tlq_ioq_hdr_push_in;                           //  98 
      logic           tlq_ioq_pop;                                   //  97 
      logic           tlq_ioqval_wp;                                 //  96 
      logic   [1:0]   tlq_ioq_data_rxp;                              //  95: 94
   
      logic           obc_ri_obcmpl_req_rl;                          //  93 
      logic           obc_ri_obcmpl_hdr_rxl_ep;                      //  92 
      logic   [2:0]   obc_ri_obcmpl_hdr_rxl_tc;                      //  91: 89 
                                                                                     
      logic   [2:0]   obc_ri_obcmpl_hdr_rxl_cs;                      //  88: 86 
   
      logic           csr_ext_mmio_ack_sai_successfull;              //  85 
      logic           csr_ext_mmio_ack_read_miss;                    //  84 
      logic           csr_ext_mmio_ack_write_miss;                   //  83 
      logic           csr_ext_mmio_ack_read_valid;                   //  82 
      logic           csr_ext_mmio_ack_write_valid;                  //  81 
      logic           csr_ext_mmio_req_valid;                        //  80 
      logic           csr_ext_mmio_req_opcode_0;                     //  79
      logic           csr_ext_mmio_req_data_0;                       //  78 
                                                                                        
      logic           csr_int_mmio_ack_sai_successfull;              //  77 
      logic           csr_int_mmio_ack_read_miss;                    //  76 
      logic           csr_int_mmio_ack_write_miss;                   //  75 
      logic           csr_int_mmio_ack_read_valid;                   //  74 
      logic           csr_int_mmio_ack_write_valid;                  //  73 
      logic           csr_int_mmio_req_valid;                        //  72 
      logic           csr_int_mmio_req_opcode_0;                     //  71 
      logic           csr_int_mmio_req_data_0;                       //  70 
                                                                                     
      logic           csr_pf0_ack_sai_successfull;                   //  69 
      logic           csr_pf0_ack_read_miss;                         //  68 
      logic           csr_pf0_ack_write_miss;                        //  67 
      logic           csr_pf0_ack_read_valid;                        //  66 
      logic           csr_pf0_ack_write_valid;                       //  65 
      logic           csr_pf0_req_valid;                             //  64 
      logic           csr_pf0_req_opcode_0;                          //  63 
      logic           csr_pf0_req_data_0;                            //  62
                                                                                     
      logic           csr_req_q_csr_mem_mapped;                      //  61
      logic           csr_req_q_csr_ext_mem_mapped;                  //  60
      logic           csr_req_q_csr_func_pf_mem_mapped;              //  59
      logic           csr_req_q_csr_func_vf_mem_mapped;              //  58 
      logic   [3:0]   csr_req_q_csr_func_vf_num;                     //  57: 54
                                                                                     
      logic           cds_cbd_func_pf_bar_hit_0;                     //  53   
      logic           cds_cbd_func_vf_bar_hit_0;                     //  52   
      logic           cds_cbd_func_pf_rgn_hit_0;                     //  51
      logic           cds_cbd_csr_pf_rgn_hit_1;                      //  50
      logic           cds_cbd_csr_pf_rgn_hit_0;                      //  49
      logic           cds_cbd_func_vf_rgn_hit_0;                     //  48 
                                                                                          
      logic           cds_csr_rd_ur;                                 //  47   
      logic           cds_csr_rd_sai_error;                          //  46   
      logic           cds_csr_rd_timeout_error;                      //  45   
      logic           cds_mmio_wr_sai_error;                         //  44   
      logic           cds_mmio_wr_sai_ok;                            //  43   
      logic           cds_cfg_wr_ur;                                 //  42   
      logic           cds_cfg_wr_sai_error;                          //  41   
      logic           cds_cfg_wr_sai_ok;                             //  40   
                                                                                         
      logic           cds_cbd_csr_pf_bar_hit;                        //  39 
      logic           cds_bar_decode_err_wp;                         //  38 
                                                                                            
      logic           cds_addr_val;                                  //  37 
      logic           cds_cbd_decode_val_0;                          //  36    

      logic           ri_idle_q;                                     //  35 
      logic           csr_pasid_enable;                              //  34 
      logic           reqsrv_send_msg;                               //  33 
      logic           ri_iosfp_quiesce_rp;                           //  32 
      logic           ti_rsprepack_vote_rp;                          //  31
      logic           ti_iosfp_push_wl;                              //  30 
      logic           ti_idle_q;                                     //  29 

      logic           ph_trigger;                                    //  28 

      logic           phdr_rxl_pasidtlp_22;                          //  27 

      logic   [3:0]   trn_msi_vf;                                    //  26: 23 
      logic           trn_ims_write;                                 //  22 
      logic           trn_msix_write;                                //  21 
      logic           trn_msi_write;                                 //  20 
      logic           trn_ioq_p_rl;                                  //  19 
      logic           trn_ioq_valid_rl;                              //  18 
      logic           trn_p_req_wl;                                  //  17 
      logic           trn_ioq_cmpl_rl;                               //  16 
      logic           trn_cmpl_req_rl;                               //  15 
      logic           trn_ri_obcmpl_req_rl2;                         //  14
      logic           trn_ti_obcmpl_ack_rl2;                         //  13 
      logic           trn_p_tlp_avail_wl;                            //  12    
      logic   [1:0]   trn_trans_type_rxl;                            //  11: 10
      logic   [4:0]   trn_nxtstate_wxl;                              //   9:  5 
      logic           trn_ph_valid_rl;                               //   4 
      logic           trn_pdata_valid_rl;                            //   3 
      logic           trn_pderr_rxl;                                 //   2 
      logic           trn_cmplh_deq_wl;                              //   1
      logic           trn_phdr_deq_wl;                               //   0
    } hqm_sif_visa_struct_t;

hqm_sif_visa_signals_t                             hqm_sif_visa_signals;
hqm_sif_visa_struct_t                              hqm_sif_visa_struct;
pmsm_visa_t                                         hqm_pmsm_visa_probe;

assign hqm_sif_visa_signals = hqm_sif_visa;
assign hqm_pmsm_visa_probe = hqm_pmsm_visa;

`ifndef HQM_VISA_ELABORATE

always_comb begin
  hqm_sif_visa_struct.flr_cmp_sent = hqm_sif_visa_signals.flr_cmp_sent ;
  hqm_sif_visa_struct.flr_triggered_wl = hqm_sif_visa_signals.flr_triggered_wl ;
  hqm_sif_visa_struct.flr_clk_enable = hqm_sif_visa_signals.flr_clk_enable ;
  hqm_sif_visa_struct.flr_clk_enable_system = hqm_sif_visa_signals.flr_clk_enable_system ;
  hqm_sif_visa_struct.prim_clk_enable_cdc = hqm_sif_visa_signals.prim_clk_enable_cdc ;
  hqm_sif_visa_struct.flr_triggered = hqm_sif_visa_signals.flr_triggered ;
  hqm_sif_visa_struct.ps_d0_to_d3 = hqm_sif_visa_signals.ps_d0_to_d3 ;
  hqm_sif_visa_struct.flr_function0 = hqm_sif_visa_signals.flr_function0 ;
   
  hqm_sif_visa_struct.flr_treatment = hqm_sif_visa_signals.flr_treatment ;
  hqm_sif_visa_struct.flr_pending = hqm_sif_visa_signals.flr_pending ;
  hqm_sif_visa_struct.bme_or_mem_wr = hqm_sif_visa_signals.bme_or_mem_wr ;
  hqm_sif_visa_struct.ps_txn_sent_q = hqm_sif_visa_signals.ps_txn_sent_q ;
  hqm_sif_visa_struct.ps_cmp_sent_q = hqm_sif_visa_signals.ps_cmp_sent_q ;
  hqm_sif_visa_struct.ps_cmp_sent_ack = hqm_sif_visa_signals.ps_cmp_sent_ack ;
  hqm_sif_visa_struct.flr_txn_sent_q = hqm_sif_visa_signals.flr_txn_sent_q ;
  hqm_sif_visa_struct.flr_cmp_sent_q = hqm_sif_visa_signals.flr_cmp_sent_q ;
  hqm_sif_visa_struct.flr = hqm_sif_visa_signals.flr ;
  hqm_sif_visa_struct.pf0_fsm_rst = hqm_sif_visa_signals.pf0_fsm_rst ;
  hqm_sif_visa_struct.ps = hqm_sif_visa_signals.ps ;
   
  hqm_sif_visa_struct.sw_trigger = hqm_sif_visa_signals.sw_trigger ;
  hqm_sif_visa_struct.prim_gated_rst_b_sync = hqm_sif_visa_signals.prim_gated_rst_b_sync ;
  hqm_sif_visa_struct.prim_clk_enable = hqm_sif_visa_signals.prim_clk_enable ;
  hqm_sif_visa_struct.prim_clk_enable_sys = hqm_sif_visa_signals.prim_clk_enable_sys ;
   
  hqm_sif_visa_struct.prim_clkreq_sync = hqm_sif_visa_signals.prim_clkreq_sync ;
  hqm_sif_visa_struct.prim_clkack_sync = hqm_sif_visa_signals.prim_clkack_sync ;
  hqm_sif_visa_struct.hqm_idle_q = hqm_sif_visa_signals.hqm_idle_q ;
  hqm_sif_visa_struct.sys_mstr_idle = hqm_sif_visa_signals.sys_mstr_idle ;
  hqm_sif_visa_struct.sys_tgt_idle = hqm_sif_visa_signals.sys_tgt_idle ;
  hqm_sif_visa_struct.sys_ri_idle = hqm_sif_visa_signals.sys_ri_idle ;
  hqm_sif_visa_struct.sys_ti_idle = hqm_sif_visa_signals.sys_ti_idle ;
  hqm_sif_visa_struct.sys_cfgm_idle = hqm_sif_visa_signals.sys_cfgm_idle ;
   
  hqm_sif_visa_struct.iosf_tgt_dec_bits = hqm_sif_visa_signals.iosf_tgt_dec_bits ;
  hqm_sif_visa_struct.iosf_tgt_dec_type = hqm_sif_visa_signals.iosf_tgt_dec_type ;
  hqm_sif_visa_struct.iosf_tgt_idle = hqm_sif_visa_signals.iosf_tgt_idle ;
                                                                                 
  hqm_sif_visa_struct.iosf_tgt_cput_cmd_rtype = hqm_sif_visa_signals.iosf_tgt_cput_cmd_rtype ;
  hqm_sif_visa_struct.iosf_tgt_cput_cmd_put = hqm_sif_visa_signals.iosf_tgt_cput_cmd_put ;
  hqm_sif_visa_struct.iosf_tgt_cmd_tfmt = hqm_sif_visa_signals.iosf_tgt_cmd_tfmt ;
  hqm_sif_visa_struct.iosf_tgt_has_data = hqm_sif_visa_signals.iosf_tgt_has_data ;
  hqm_sif_visa_struct.iosf_tgt_data_count_ff = hqm_sif_visa_signals.iosf_tgt_data_count_ff ;
                                                                                                
  hqm_sif_visa_struct.iosf_tgt_crdtinit_in_progress = hqm_sif_visa_signals.iosf_tgt_crdtinit_in_progress ;
  hqm_sif_visa_struct.iosf_tgt_rst_complete = hqm_sif_visa_signals.iosf_tgt_rst_complete ;
  hqm_sif_visa_struct.iosf_tgt_credit_init = hqm_sif_visa_signals.iosf_tgt_credit_init ;
  hqm_sif_visa_struct.iosf_tgt_zero = hqm_sif_visa_signals.iosf_tgt_zero ;
  hqm_sif_visa_struct.iosf_tgt_port_present = hqm_sif_visa_signals.iosf_tgt_port_present ;
   
  hqm_sif_visa_struct.mstr_iosf_cmd_caddress_31_0 = hqm_sif_visa_signals.mstr_iosf_cmd_caddress_31_0 ;

  hqm_sif_visa_struct.mstr_iosf_cmd_clbe = hqm_sif_visa_signals.mstr_iosf_cmd_clbe ;
  hqm_sif_visa_struct.mstr_iosf_cmd_cfbe = hqm_sif_visa_signals.mstr_iosf_cmd_cfbe ;

  hqm_sif_visa_struct.mstr_iosf_cmd_ctag = hqm_sif_visa_signals.mstr_iosf_cmd_ctag ;

  hqm_sif_visa_struct.mstr_iosf_cmd_crqid = hqm_sif_visa_signals.mstr_iosf_cmd_crqid ;

  hqm_sif_visa_struct.mstr_iosf_cmd_clength_7_0 = hqm_sif_visa_signals.mstr_iosf_cmd_clength_7_0 ;

  hqm_sif_visa_struct.mstr_iosf_cmd_cth = hqm_sif_visa_signals.mstr_iosf_cmd_cth ;
  hqm_sif_visa_struct.mstr_iosf_cmd_cep = hqm_sif_visa_signals.mstr_iosf_cmd_cep ;
  hqm_sif_visa_struct.mstr_iosf_cmd_cro = hqm_sif_visa_signals.mstr_iosf_cmd_cro ;
  hqm_sif_visa_struct.mstr_iosf_cmd_cns = hqm_sif_visa_signals.mstr_iosf_cmd_cns ;
  hqm_sif_visa_struct.mstr_iosf_cmd_cido = hqm_sif_visa_signals.mstr_iosf_cmd_cido ;
  hqm_sif_visa_struct.mstr_iosf_cmd_cat = hqm_sif_visa_signals.mstr_iosf_cmd_cat ;
  hqm_sif_visa_struct.mstr_iosf_cmd_ctd = hqm_sif_visa_signals.mstr_iosf_cmd_ctd ;

  hqm_sif_visa_struct.mstr_iosf_gnt_q_gnt2 = hqm_sif_visa_signals.mstr_iosf_gnt_q_gnt2 ;
  hqm_sif_visa_struct.mstr_iosf_cmd_cfmt = hqm_sif_visa_signals.mstr_iosf_cmd_cfmt ;
  hqm_sif_visa_struct.mstr_iosf_cmd_ctype = hqm_sif_visa_signals.mstr_iosf_cmd_ctype ;

  hqm_sif_visa_struct.mstr_iosf_req_dlen_4_2 = hqm_sif_visa_signals.mstr_iosf_req_dlen_4_2 ;
  hqm_sif_visa_struct.mstr_iosf_req_credits_cpl = hqm_sif_visa_signals.mstr_iosf_req_credits_cpl ;

  hqm_sif_visa_struct.mstr_iosf_req_dlen_1_0 = hqm_sif_visa_signals.mstr_iosf_req_dlen_1_0 ;
  hqm_sif_visa_struct.mstr_data_out_valid_q = hqm_sif_visa_signals.mstr_data_out_valid_q ;
  hqm_sif_visa_struct.mstr_iosf_req_credits_p = hqm_sif_visa_signals.mstr_iosf_req_credits_p ;

  hqm_sif_visa_struct.mstr_idle = hqm_sif_visa_signals.mstr_idle ;
  hqm_sif_visa_struct.mstr_hfifo_data_fmt = hqm_sif_visa_signals.mstr_hfifo_data_fmt ;
  hqm_sif_visa_struct.mstr_hfifo_data_type = hqm_sif_visa_signals.mstr_hfifo_data_type ;

  hqm_sif_visa_struct.mstr_rxq_hdr_avail = hqm_sif_visa_signals.mstr_rxq_hdr_avail ;
  hqm_sif_visa_struct.mstr_iosf_gnt_q_dec = hqm_sif_visa_signals.mstr_iosf_gnt_q_dec ;
  hqm_sif_visa_struct.mstr_req_fifo_empty = hqm_sif_visa_signals.mstr_req_fifo_empty ;
  hqm_sif_visa_struct.mstr_req_fifo_fully = hqm_sif_visa_signals.mstr_req_fifo_fully ;

  hqm_sif_visa_struct.mstr_prim_ism_agent = hqm_sif_visa_signals.mstr_prim_ism_agent ;
  hqm_sif_visa_struct.mstr_dfifo_rd_gt4dw = hqm_sif_visa_signals.mstr_dfifo_rd_gt4dw ;
  hqm_sif_visa_struct.mstr_dfifo_rd = hqm_sif_visa_signals.mstr_dfifo_rd ;
  hqm_sif_visa_struct.mstr_hfifo_rd = hqm_sif_visa_signals.mstr_hfifo_rd ;

  hqm_sif_visa_struct.mstr_iosf_gnt_q_gtype = hqm_sif_visa_signals.mstr_iosf_gnt_q_gtype ;
  hqm_sif_visa_struct.mstr_iosf_gnt_q_rtype = hqm_sif_visa_signals.mstr_iosf_gnt_q_rtype ;
  hqm_sif_visa_struct.mstr_iosf_gnt_q_gnt = hqm_sif_visa_signals.mstr_iosf_gnt_q_gnt ;
  hqm_sif_visa_struct.mstr_iosf_req_rtype = hqm_sif_visa_signals.mstr_iosf_req_rtype ;
  hqm_sif_visa_struct.mstr_iosf_req_put = hqm_sif_visa_signals.mstr_iosf_req_put ;

  hqm_sif_visa_struct.mstr_iosfp_ti_rxq_rdy = hqm_sif_visa_signals.mstr_iosfp_ti_rxq_rdy ;
  hqm_sif_visa_struct.mstr_iosfp_ri_rxq_rsprepack_vote_ri = hqm_sif_visa_signals.mstr_iosfp_ri_rxq_rsprepack_vote_ri ;
  hqm_sif_visa_struct.mstr_iosf_ep_poison_wr_sent_rl = hqm_sif_visa_signals.mstr_iosf_ep_poison_wr_sent_rl ;
  hqm_sif_visa_struct.mstr_iosf_ep_poison_wr_func_rxl = hqm_sif_visa_signals.mstr_iosf_ep_poison_wr_func_rxl ;

  hqm_sif_visa_struct.rxq_ti_rsprepack_vote_rp_q = hqm_sif_visa_signals.rxq_ti_rsprepack_vote_rp_q ;
  hqm_sif_visa_struct.rxq_ri_iosfp_quiesce_rp = hqm_sif_visa_signals.rxq_ri_iosfp_quiesce_rp ;
  hqm_sif_visa_struct.cplhdr_rxq_fifo_perr_q = hqm_sif_visa_signals.cplhdr_rxq_fifo_perr_q ;
  hqm_sif_visa_struct.ioq_rxq_fifo_pop = hqm_sif_visa_signals.ioq_rxq_fifo_pop ;
  hqm_sif_visa_struct.phdr_rxq_fifo_pop = hqm_sif_visa_signals.phdr_rxq_fifo_pop ;
  hqm_sif_visa_struct.pdata_rxq_fifo_pop = hqm_sif_visa_signals.pdata_rxq_fifo_pop ;
  hqm_sif_visa_struct.cplhdr_rxq_fifo_pop = hqm_sif_visa_signals.cplhdr_rxq_fifo_pop ;
  hqm_sif_visa_struct.cpldata_rxq_fifo_pop = hqm_sif_visa_signals.cpldata_rxq_fifo_pop ;

  hqm_sif_visa_struct.rxq_ti_iosfp_ifc_wxi_stp = hqm_sif_visa_signals.rxq_ti_iosfp_ifc_wxi_stp ;
  hqm_sif_visa_struct.rxq_ti_iosfp_ifc_wxi_endp = hqm_sif_visa_signals.rxq_ti_iosfp_ifc_wxi_endp ;
  hqm_sif_visa_struct.phdr_rxq_fifo_perr_q = hqm_sif_visa_signals.phdr_rxq_fifo_perr_q ;
  hqm_sif_visa_struct.ioq_rxq_fifo_push = hqm_sif_visa_signals.ioq_rxq_fifo_push ;
  hqm_sif_visa_struct.phdr_rxq_fifo_push = hqm_sif_visa_signals.phdr_rxq_fifo_push ;
  hqm_sif_visa_struct.pdata_rxq_fifo_push = hqm_sif_visa_signals.pdata_rxq_fifo_push ;
  hqm_sif_visa_struct.cplhdr_rxq_fifo_push = hqm_sif_visa_signals.cplhdr_rxq_fifo_push ;
  hqm_sif_visa_struct.cpldata_rxq_fifo_push = hqm_sif_visa_signals.cpldata_rxq_fifo_push ;

  hqm_sif_visa_struct.rxq_ti_iosfp_push_wi = hqm_sif_visa_signals.rxq_ti_iosfp_push_wi ;
  hqm_sif_visa_struct.rxq_pcie_cmd = hqm_sif_visa_signals.rxq_pcie_cmd ;
   
  hqm_sif_visa_struct.tlq_tlq_pdataval_wp = hqm_sif_visa_signals.tlq_tlq_pdataval_wp ;
  hqm_sif_visa_struct.tlq_npdataval_wp = hqm_sif_visa_signals.tlq_npdataval_wp ;
                                                                  
  hqm_sif_visa_struct.tlq_ioq_fifo_full = hqm_sif_visa_signals.tlq_ioq_fifo_full ;
  hqm_sif_visa_struct.tlq_ioq_hdr_push_in = hqm_sif_visa_signals.tlq_ioq_hdr_push_in ;
  hqm_sif_visa_struct.tlq_ioq_pop = hqm_sif_visa_signals.tlq_ioq_pop ;
  hqm_sif_visa_struct.tlq_ioqval_wp = hqm_sif_visa_signals.tlq_ioqval_wp ;
  hqm_sif_visa_struct.tlq_ioq_data_rxp = hqm_sif_visa_signals.tlq_ioq_data_rxp [ 1 : 0 ] ;
   
  hqm_sif_visa_struct.obc_ri_obcmpl_req_rl = hqm_sif_visa_signals.obc_ri_obcmpl_req_rl ;
  hqm_sif_visa_struct.obc_ri_obcmpl_hdr_rxl_ep = hqm_sif_visa_signals.obc_ri_obcmpl_hdr_rxl_ep ;
  hqm_sif_visa_struct.obc_ri_obcmpl_hdr_rxl_tc = hqm_sif_visa_signals.obc_ri_obcmpl_hdr_rxl_tc ;
  hqm_sif_visa_struct.obc_ri_obcmpl_hdr_rxl_cs = hqm_sif_visa_signals.obc_ri_obcmpl_hdr_rxl_cs ;
   
  hqm_sif_visa_struct.csr_ext_mmio_ack_sai_successfull = hqm_sif_visa_signals.csr_ext_mmio_ack_sai_successfull ;
  hqm_sif_visa_struct.csr_ext_mmio_ack_read_miss = hqm_sif_visa_signals.csr_ext_mmio_ack_read_miss ;
  hqm_sif_visa_struct.csr_ext_mmio_ack_write_miss = hqm_sif_visa_signals.csr_ext_mmio_ack_write_miss ;
  hqm_sif_visa_struct.csr_ext_mmio_ack_read_valid = hqm_sif_visa_signals.csr_ext_mmio_ack_read_valid ;
  hqm_sif_visa_struct.csr_ext_mmio_ack_write_valid = hqm_sif_visa_signals.csr_ext_mmio_ack_write_valid ;
  hqm_sif_visa_struct.csr_ext_mmio_req_valid = hqm_sif_visa_signals.csr_ext_mmio_req_valid ;
  hqm_sif_visa_struct.csr_ext_mmio_req_opcode_0 = hqm_sif_visa_signals.csr_ext_mmio_req_opcode_0 ;
  hqm_sif_visa_struct.csr_ext_mmio_req_data_0 = hqm_sif_visa_signals.csr_ext_mmio_req_data_0 ;
                                                                               
  hqm_sif_visa_struct.csr_int_mmio_ack_sai_successfull = hqm_sif_visa_signals.csr_int_mmio_ack_sai_successfull ;
  hqm_sif_visa_struct.csr_int_mmio_ack_read_miss = hqm_sif_visa_signals.csr_int_mmio_ack_read_miss ;
  hqm_sif_visa_struct.csr_int_mmio_ack_write_miss = hqm_sif_visa_signals.csr_int_mmio_ack_write_miss ;
  hqm_sif_visa_struct.csr_int_mmio_ack_read_valid = hqm_sif_visa_signals.csr_int_mmio_ack_read_valid ;
  hqm_sif_visa_struct.csr_int_mmio_ack_write_valid = hqm_sif_visa_signals.csr_int_mmio_ack_write_valid ;
  hqm_sif_visa_struct.csr_int_mmio_req_valid = hqm_sif_visa_signals.csr_int_mmio_req_valid ;
  hqm_sif_visa_struct.csr_int_mmio_req_opcode_0 = hqm_sif_visa_signals.csr_int_mmio_req_opcode_0 ;
  hqm_sif_visa_struct.csr_int_mmio_req_data_0 = hqm_sif_visa_signals.csr_int_mmio_req_data_0 ;
                                                                            
  hqm_sif_visa_struct.csr_pf0_ack_sai_successfull = hqm_sif_visa_signals.csr_pf0_ack_sai_successfull ;
  hqm_sif_visa_struct.csr_pf0_ack_read_miss = hqm_sif_visa_signals.csr_pf0_ack_read_miss ;
  hqm_sif_visa_struct.csr_pf0_ack_write_miss = hqm_sif_visa_signals.csr_pf0_ack_write_miss ;
  hqm_sif_visa_struct.csr_pf0_ack_read_valid = hqm_sif_visa_signals.csr_pf0_ack_read_valid ;
  hqm_sif_visa_struct.csr_pf0_ack_write_valid = hqm_sif_visa_signals.csr_pf0_ack_write_valid ;
  hqm_sif_visa_struct.csr_pf0_req_valid = hqm_sif_visa_signals.csr_pf0_req_valid ;
  hqm_sif_visa_struct.csr_pf0_req_opcode_0 = hqm_sif_visa_signals.csr_pf0_req_opcode_0 ;
  hqm_sif_visa_struct.csr_pf0_req_data_0 = hqm_sif_visa_signals.csr_pf0_req_data_0 ;
                                                                          
  hqm_sif_visa_struct.csr_req_q_csr_mem_mapped = hqm_sif_visa_signals.csr_req_q_csr_mem_mapped ;
  hqm_sif_visa_struct.csr_req_q_csr_ext_mem_mapped = hqm_sif_visa_signals.csr_req_q_csr_ext_mem_mapped ;
  hqm_sif_visa_struct.csr_req_q_csr_func_pf_mem_mapped = hqm_sif_visa_signals.csr_req_q_csr_func_pf_mem_mapped ;
  hqm_sif_visa_struct.csr_req_q_csr_func_vf_mem_mapped = hqm_sif_visa_signals.csr_req_q_csr_func_vf_mem_mapped ;
  hqm_sif_visa_struct.csr_req_q_csr_func_vf_num = hqm_sif_visa_signals.csr_req_q_csr_func_vf_num ;
                                                                            
  hqm_sif_visa_struct.cds_cbd_func_pf_bar_hit_0 = hqm_sif_visa_signals.cds_cbd_func_pf_bar_hit_0 ;
  hqm_sif_visa_struct.cds_cbd_func_vf_bar_hit_0 = hqm_sif_visa_signals.cds_cbd_func_vf_bar_hit_0 ;
  hqm_sif_visa_struct.cds_cbd_func_pf_rgn_hit_0 = hqm_sif_visa_signals.cds_cbd_func_pf_rgn_hit [0] ;
  hqm_sif_visa_struct.cds_cbd_csr_pf_rgn_hit_1 = hqm_sif_visa_signals.cds_cbd_csr_pf_rgn_hit [1] ;
  hqm_sif_visa_struct.cds_cbd_csr_pf_rgn_hit_0 = hqm_sif_visa_signals.cds_cbd_csr_pf_rgn_hit [0] ;
  hqm_sif_visa_struct.cds_cbd_func_vf_rgn_hit_0 = hqm_sif_visa_signals.cds_cbd_func_vf_rgn_hit [0] ;
                                                                                
  hqm_sif_visa_struct.cds_csr_rd_ur = hqm_sif_visa_signals.cds_csr_rd_ur ;
  hqm_sif_visa_struct.cds_csr_rd_sai_error = hqm_sif_visa_signals.cds_csr_rd_sai_error ;
  hqm_sif_visa_struct.cds_csr_rd_timeout_error = hqm_sif_visa_signals.cds_csr_rd_timeout_error ;
  hqm_sif_visa_struct.cds_mmio_wr_sai_error = hqm_sif_visa_signals.cds_mmio_wr_sai_error ;
  hqm_sif_visa_struct.cds_mmio_wr_sai_ok = hqm_sif_visa_signals.cds_mmio_wr_sai_ok ;
  hqm_sif_visa_struct.cds_cfg_wr_ur = hqm_sif_visa_signals.cds_cfg_wr_ur ;
  hqm_sif_visa_struct.cds_cfg_wr_sai_error = hqm_sif_visa_signals.cds_cfg_wr_sai_error ;
  hqm_sif_visa_struct.cds_cfg_wr_sai_ok = hqm_sif_visa_signals.cds_cfg_wr_sai_ok ;

  hqm_sif_visa_struct.cds_cbd_csr_pf_bar_hit = hqm_sif_visa_signals.cds_cbd_csr_pf_bar_hit ;
  hqm_sif_visa_struct.cds_bar_decode_err_wp = hqm_sif_visa_signals.cds_bar_decode_err_wp ;

  hqm_sif_visa_struct.cds_addr_val = hqm_sif_visa_signals.cds_addr_val ;
  hqm_sif_visa_struct.cds_cbd_decode_val_0 = hqm_sif_visa_signals.cds_cbd_decode_val_0 ;

  hqm_sif_visa_struct.ri_idle_q = hqm_sif_visa_signals.ri_idle_q ;
  hqm_sif_visa_struct.csr_pasid_enable = hqm_sif_visa_signals.csr_pasid_enable ;
  hqm_sif_visa_struct.reqsrv_send_msg = hqm_sif_visa_signals.reqsrv_send_msg ;
  hqm_sif_visa_struct.ri_iosfp_quiesce_rp = hqm_sif_visa_signals.ri_iosfp_quiesce_rp ;
  hqm_sif_visa_struct.ti_rsprepack_vote_rp = hqm_sif_visa_signals.ti_rsprepack_vote_rp ;
  hqm_sif_visa_struct.ti_iosfp_push_wl = hqm_sif_visa_signals.ti_iosfp_push_wl ;
  hqm_sif_visa_struct.ti_idle_q = hqm_sif_visa_signals.ti_idle_q ;

  hqm_sif_visa_struct.ph_trigger = hqm_sif_visa_signals.ph_trigger ;

  hqm_sif_visa_struct.phdr_rxl_pasidtlp_22 = hqm_sif_visa_signals.phdr_rxl_pasidtlp_22 ;

  hqm_sif_visa_struct.trn_msi_vf = hqm_sif_visa_signals.trn_msi_vf ;
  hqm_sif_visa_struct.trn_ims_write = hqm_sif_visa_signals.trn_phdr_deq_wl2 ;
  hqm_sif_visa_struct.trn_msix_write = hqm_sif_visa_signals.trn_zero_byte_wr_wl ;
  hqm_sif_visa_struct.trn_msi_write = hqm_sif_visa_signals.trn_msi_write ;
  hqm_sif_visa_struct.trn_ioq_p_rl = hqm_sif_visa_signals.trn_ioq_p_rl ;
  hqm_sif_visa_struct.trn_ioq_valid_rl = hqm_sif_visa_signals.trn_ioq_valid_rl ;
  hqm_sif_visa_struct.trn_p_req_wl = hqm_sif_visa_signals.trn_p_req_wl ;
  hqm_sif_visa_struct.trn_ioq_cmpl_rl = hqm_sif_visa_signals.trn_ioq_cmpl_rl ;
  hqm_sif_visa_struct.trn_cmpl_req_rl = hqm_sif_visa_signals.trn_cmpl_req_rl ;
  hqm_sif_visa_struct.trn_ri_obcmpl_req_rl2 = hqm_sif_visa_signals.trn_ri_obcmpl_req_rl2 ;
  hqm_sif_visa_struct.trn_ti_obcmpl_ack_rl2 = hqm_sif_visa_signals.trn_ti_obcmpl_ack_rl2 ;
  hqm_sif_visa_struct.trn_p_tlp_avail_wl = hqm_sif_visa_signals.trn_p_tlp_avail_wl ;
  hqm_sif_visa_struct.trn_trans_type_rxl = hqm_sif_visa_signals.trn_trans_type_rxl ;
  hqm_sif_visa_struct.trn_nxtstate_wxl = hqm_sif_visa_signals.trn_nxtstate_wxl ;
  hqm_sif_visa_struct.trn_ph_valid_rl = hqm_sif_visa_signals.trn_ph_valid_rl ;
  hqm_sif_visa_struct.trn_pdata_valid_rl = hqm_sif_visa_signals.trn_pdata_valid_rl ;
  hqm_sif_visa_struct.trn_pderr_rxl = hqm_sif_visa_signals.trn_pderr_rxl ;
  hqm_sif_visa_struct.trn_cmplh_deq_wl = hqm_sif_visa_signals.trn_cmplh_deq_wl ;
  hqm_sif_visa_struct.trn_phdr_deq_wl = hqm_sif_visa_signals.trn_phdr_deq_wl ;
end 

`endif

// collage-pragma translate_on


`include "hqm_visa_mux0.VISA_IT.hqm_visa_mux0.logic.sv" // Auto Included by VISA IT - *** Do not modify this line ***
endmodule // hqm_visa_mux0
