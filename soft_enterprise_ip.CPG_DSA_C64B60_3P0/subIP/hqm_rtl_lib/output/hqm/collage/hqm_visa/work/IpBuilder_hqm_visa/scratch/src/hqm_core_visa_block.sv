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
// hqm_core_visa_block
//
// This module is responsible for flopping (and synchronizing some) top-level hqm_core signals.
// The flopped values are demuxed and output as 10 64-bit buses.
//
//-----------------------------------------------------------------------------------------------------

// reuse-pragma startSub [InsertComponentPrefix %subText 7]
module hqm_core_visa_block

// synopsys translate_off

  import hqm_AW_pkg::*, hqm_pkg::*;

// synopsys translate_on

(
  input  logic                        clk
, input  logic                        fscan_rstbypen
, input  logic                        fscan_byprst_b

, input  logic [ ( 260 ) -1 : 0 ]     hqm_core_visa_str
// reuse-pragma startSub [InsertFilePrefix %subText]
`include "hqm_core_visa_block.VISA_IT.hqm_core_visa_block.port_defs.sv" // Auto Included by VISA IT - *** Do not modify this line ***


);

// Structures

// reuse-pragma startSub [InsertFilePrefix %subText]
`include "hqm_core_visa_block.VISA_IT.hqm_core_visa_block.wires.sv" // Auto Included by VISA IT - *** Do not modify this line ***
typedef struct packed {
  logic         ap_alarm_up_ready;                       // bit  259     //OK
  logic         aqed_alarm_down_v;                       // bit  258     //OK
  logic         spare_257;                               // bit  257     //OK
  logic         spare_256;                               // bit  256     //OK
  logic         spare_255;                               // bit  255     //OK
  logic         spare_254;                               // bit  254     //OK
  logic         qed_lsp_deq_v;                           // bit  253     //OK
  logic         aqed_lsp_deq_v;                          // bit  252     //OK
  logic         ap_alarm_down_ready ;                    // bit  251     //OK
  logic         ap_alarm_down_v ;                        // bit  250     //OK
  logic         rop_alarm_up_ready;                      // bit  249     //OK
  logic         qed_alarm_down_v;                        // bit  248     //OK
  logic         lsp_alarm_down_ready ;                   // bit  247     //OK
  logic         lsp_alarm_down_v ;                       // bit  246     //OK
  logic         rop_alarm_down_ready ;                   // bit  245     //OK
  logic         rop_alarm_down_v ;                       // bit  244     //OK
  logic         spare_243;                               // bit  243     //OK
  logic         spare_242;                               // bit  242     //OK
  logic [1:0]   aqed_cfg_rsp_down ; //[5:4]              // bit  241:240 //OK
  logic         aqed_cfg_rsp_down_ack ;                  // bit  239     //OK
  logic [1:0]   aqed_cfg_req_down ; //[1:0]              // bit  238:237 //OK
  logic         aqed_cfg_req_down_write ;                // bit  236     //OK
  logic         aqed_cfg_req_down_read ;                 // bit  235     //OK
  logic [1:0]   spare_234_233 ;                          // bit  234:233 //OK
  logic         spare_232 ;                              // bit  232     //OK
  logic [1:0]   spare_231_230 ;                          // bit  231:230 //OK
  logic         spare_229;                               // bit  229     //OK
  logic         spare_228;                               // bit  228     //OK
  logic [1:0]   qed_cfg_rsp_down ; //[5:4]               // bit  227:226 //OK
  logic         qed_cfg_rsp_down_ack ;                   // bit  225     //OK
  logic [1:0]   qed_cfg_req_down ; //[1:0]               // bit  224:223 //OK   
  logic         qed_cfg_req_down_write ;                 // bit  222     //OK 
  logic         qed_cfg_req_down_read ;                  // bit  221     //OK 
  logic [1:0]   spare_220_219;                           // bit  220:219 //OK
  logic         spare_218;                               // bit  218     //OK
  logic [1:0]   spare_217_216 ;                          // bit  217:216 //OK
  logic         spare_215 ;                              // bit  215     //OK
  logic         spare_214 ;                              // bit  214     //OK
  logic [1:0]   ap_cfg_rsp_down ; //[5:4]                // bit  213:212 //OK
  logic         ap_cfg_rsp_down_ack ;                    // bit  211     //OK
  logic [1:0]   ap_cfg_req_down ; //[1:0]                // bit  210:209 //OK
  logic         ap_cfg_req_down_write ;                  // bit  208     //OK
  logic         ap_cfg_req_down_read ;                   // bit  207     //OK
  logic [1:0]   spare_206_205; //[5:4]                   // bit  206:205 //OK
  logic         spare_204 ;                              // bit  204     //OK
  logic [1:0]   spare_203_202 ; //[1:0]                  // bit  203:202 //OK
  logic         spare_201 ;                              // bit  201     //OK
  logic         spare_200 ;                              // bit  200     //OK
  logic [1:0]   lsp_cfg_rsp_down ; //[5:4]               // bit  199:198 //OK
  logic         lsp_cfg_rsp_down_ack ;                   // bit  197     //OK
  logic [1:0]   lsp_cfg_req_down ; //[1:0]               // bit  196:195 //OK
  logic         lsp_cfg_req_down_write ;                 // bit  194     //OK
  logic         lsp_cfg_req_down_read ;                  // bit  193     //OK
  logic [1:0]   rop_cfg_rsp_down ; //[5:4]               // bit  192:191 //OK
  logic         rop_cfg_rsp_down_ack ;                   // bit  190:190 //OK
  logic [1:0]   rop_cfg_req_down ; //[1:0]               // bit  189:188 //OK
  logic         rop_cfg_req_down_write ;                 // bit  187     //OK
  logic         rop_cfg_req_down_read ;                  // bit  186     //OK
  logic [1:0]   chp_cfg_rsp_down ; //[5:4]               // bit  185:184 //OK
  logic         chp_cfg_rsp_down_ack ;                   // bit  183     //OK
  logic [1:0]   chp_cfg_req_down ; //[1:0]               // bit  182:181 //OK
  logic         chp_cfg_req_down_write ;                 // bit  180     //OK
  logic         chp_cfg_req_down_read ;                  // bit  179     //OK
  logic [1:0]   mstr_cfg_rsp_down ; //[5:4]              // bit  178:177 //OK
  logic         mstr_cfg_rsp_down_ack ;                  // bit  176     //OK
  logic [1:0]   mstr_cfg_req_down ; //[1:0]              // bit  175:174 //OK
  logic         mstr_cfg_req_down_write ;                // bit  173   //OK
  logic         mstr_cfg_req_down_read ;                 // bit  172   //OK
  logic         rop_lsp_reordercmp_ready ;               // bit  171   //OK
  logic         rop_lsp_reordercmp_v ;                   // bit  170   //OK
  logic         aqed_lsp_sch_ready ;                     // bit  169   //OK
  logic         aqed_lsp_sch_v ;                         // bit  168    //OK
  logic         aqed_chp_sch_ready ;                     // bit  167    //OK
  logic         aqed_chp_sch_v ;                         // bit  166    //OK
  logic         aqed_ap_enq_ready ;                      // bit  165    //OK 
  logic         aqed_ap_enq_v ;                          // bit  164    //OK
  logic         spare_163 ;                              // bit  163    //OK
  logic         spare_162 ;                              // bit  162    //OK 
  logic         qed_aqed_enq_ready ;                     // bit  161    //OK
  logic         qed_aqed_enq_v ;                         // bit  160    //OK
  logic         qed_chp_sch_ready ;                      // bit  159    //OK
  logic         qed_chp_sch_v ;                          // bit  158    //OK
  logic         ap_aqed_ready ;                          // bit  157    //OK
  logic         ap_aqed_v ;                              // bit  156    //OK
  logic         spare_155 ;                              // bit  155    //OK
  logic         spare_154 ;                              // bit  154    //OK
  logic         dp_lsp_enq_rorply_ready ;                // bit  153    //OK
  logic         dp_lsp_enq_rorply_v ;                    // bit  152    //OK
  logic         dp_lsp_enq_dir_ready ;                   // bit  151    //OK
  logic         dp_lsp_enq_dir_v ;                       // bit  150    //OK
  logic         spare_149 ;                              // bit  149    //OK
  logic         spare_148 ;                              // bit  148    //OK
  logic         nalb_lsp_enq_rorply_ready ;              // bit  147    //OK
  logic         nalb_lsp_enq_rorply_v ;                  // bit  146    //OK
  logic         nalb_lsp_enq_lb_ready ;                  // bit  145    //OK
  logic         nalb_lsp_enq_lb_v ;                      // bit  144    //OK
  logic         lsp_nalb_sch_atq_ready ;                 // bit  143    //OK
  logic         lsp_nalb_sch_atq_v ;                     // bit  142    //OK
  logic         lsp_dp_sch_rorply_ready ;                // bit  141    //OK
  logic         lsp_dp_sch_rorply_v ;                    // bit  140    //OK
  logic         lsp_nalb_sch_rorply_ready ;              // bit  139    //OK
  logic         lsp_nalb_sch_rorply_v ;                  // bit  138    //OK
  logic         lsp_dp_sch_dir_ready ;                   // bit  137    //OK
  logic         lsp_dp_sch_dir_v ;                       // bit  136    //OK
  logic         lsp_nalb_sch_unoord_ready ;              // bit  135    //OK
  logic         lsp_nalb_sch_unoord_v ;                  // bit  134    //OK
  logic         rop_dqed_enq_ready ;                     // bit  133    //OK
  logic         rop_qed_enq_ready ;                      // bit  132    //OK
  logic         rop_qed_dqed_enq_v ;                     // bit  131    //OK
  logic         rop_nalb_enq_ready ;                     // bit  130    //OK
  logic         rop_nalb_enq_v ;                         // bit  129    //OK
  logic         rop_dp_enq_ready ;                       // bit  128    //OK
  logic         rop_dp_enq_v ;                           // bit  127    //OK
  logic         chp_lsp_token_ready ;                    // bit  126    //OK
  logic         chp_lsp_token_v ;                        // bit  125    //OK
  logic         chp_lsp_cmp_data ;                       // bit  124    //OK
  logic         chp_lsp_cmp_ready ;                      // bit  123    //OK
  logic         chp_lsp_cmp_v ;                          // bit  122    //OK
  logic         chp_rop_hcw_ready ;                      // bit  121    //OK
  logic         chp_rop_hcw_v ;                          // bit  120    //OK
  logic         spare_119 ;                              // bit  119    //OK
  logic         spare_118 ;                              // bit  118    //OK
  logic         spare_117 ;                              // bit  117    //OK
  logic         spare_116 ;                              // bit  116    //OK
  logic         spare_115 ;                              // bit  115    //OK
  logic         spare_114 ;                              // bit  114    //OK
  logic         hcw_sched_w_req_ready ;                  // bit  113    //OK
  logic         hcw_sched_w_req_valid ;                  // bit  112:   //OK
  logic         spare_111 ;                              // bit  111:   //OK
  logic         spare_110 ;                              // bit  110:   //OK
  logic         spare_109 ;                              // bit  109:   //OK
  logic         spare_108 ;                              // bit  108:   //OK 
  logic         hcw_enq_w_req_ready ;                    // bit  107:   //OK 
  logic         hcw_enq_w_req_valid ;                    // bit  106:   //OK 
  logic         spare_105 ;                              // bit  105:   //OK
  logic         spare_104 ;                              // bit  104:   //OK
  logic         cwdi_interrupt_w_req_ready ;             // bit  103:   //OK
  logic         cwdi_interrupt_w_req_valid ;             // bit  102:   //OK
  logic         interrupt_w_req_ready ;                  // bit  101:   //OK
  logic         interrupt_w_req_valid ;                  // bit  100:   //OK
  logic         spare_99 ;                               // bit  99:    //OK - no system pipeidle, status bit tied 1 in register
  logic         aqed_unit_pipeidle ;                     // bit  98:    //OK
  logic         qed_unit_pipeidle ;                      // bit  97:    //OK
  logic         dp_unit_pipeidle ;                       // bit  96:    //OK
  logic         ap_unit_pipeidle ;                       // bit  95:    //OK
  logic         nalb_unit_pipeidle ;                     // bit  94:    //OK
  logic         lsp_unit_pipeidle ;                      // bit  93:    //OK
  logic         rop_unit_pipeidle ;                      // bit  92:    //OK
  logic         chp_unit_pipeidle ;                      // bit  91:    //OK
  logic         sys_unit_idle ;                          // bit  90:    //OK
  logic         aqed_unit_idle ;                         // bit  89:    //OK
  logic         qed_unit_idle ;                          // bit  88:    //OK
  logic         dp_unit_idle ;                           // bit  87:    //OK
  logic         ap_unit_idle ;                           // bit  86:    //OK
  logic         nalb_unit_idle ;                         // bit  85:    //OK
  logic         lsp_unit_idle ;                          // bit  84:    //OK
  logic         rop_unit_idle ;                          // bit  83:    //OK
  logic         chp_unit_idle ;                          // bit  82:    //OK
  logic         spare_81;                                // bit  81:    //OK
  logic         spare_80;                                // bit  80:    //OK
  logic         spare_79;                                // bit  79:    //OK
  logic         sys_hqm_proc_clk_en;                     // bit  78:    //OK
  logic         nalb_hqm_proc_clk_en;                    // bit  77:    //OK
  logic         dp_hqm_proc_clk_en;                      // bit  76:    //OK
  logic         qed_hqm_proc_clk_en;                     // bit  75:    //OK  
  logic         lsp_hqm_proc_clk_en;                     // bit  74:    //OK - covers LSP,ATM,AQED
  logic         chp_hqm_proc_clk_en;                     // bit  73:    //OK - covers CHP,ROP
  logic         sys_reset_done ;                         // bit  72:    //OK
  logic         aqed_reset_done ;                        // bit  71:    //OK
  logic         qed_reset_done ;                         // bit  70:    //OK
  logic         dp_reset_done ;                          // bit  69:    //OK
  logic         ap_reset_done ;                          // bit  68:    //OK
  logic         nalb_reset_done ;                        // bit  67:    //OK
  logic         lsp_reset_done ;                         // bit  66:    //OK
  logic         rop_reset_done ;                         // bit  65:    //OK
  logic         chp_reset_done ;                         // bit  64:    //OK
  logic         spare_63 ;                               // bit  63:    //OK
  logic         spare_62 ;                               // bit  62:    //OK
  logic         fscan_ram_rddis_b ;                      // bit  61:    //OK - collage/subsystems/dft
  logic         fscan_ram_wrdis_b ;                      // bit  60:    //OK - collage/subsystems/dft
  logic         spare_59 ;                               // bit  59:     //OK
  logic [3:0]   spare_58_55 ; //[3:0]                    // bit  58:55   //OK
  logic         spare_54 ;                               // bit  54:54   //OK
  logic [4:0]   spare_53_49 ; //[4:0]                    // bit  53:49   //OK
  logic         hqm_alarm_v ;                            // bit  48:48   //OK- added every lane w/ ready, removed spare_41 to make room 
  logic         hqm_alarm_ready ;                        // bit  47:47   //OK
  logic         hqm_unit_pipeidle ;                      // bit  46:46   //OK
  logic         hqm_unit_idle ;                          // bit  45:45   //OK
  logic         constant_one ;                           // bit  44:44   //OK - was spare_44
  logic         rop_qed_force_clockon;                   // bit  43      //OK - was spare_43 
  logic         hqm_proc_reset_done ;                    // bit  42:42   //OK
  logic         spare_41 ;                               // bit  41:41   //OK
  logic [7:0]   spare_40_33 ;                            // bit  40:33   //OK
  logic         spare_32 ;                               // bit  32      //OK
  logic         spare_31 ;                               // bit  31:31   //OK
  logic [7:0]   spare_30_23 ; //[7:0]                    // bit  30:23   //OK
  logic [3:0]   spare_22_19 ; //[3:0]                    // bit  22_19   //OK
  logic         spare_18 ;                               // bit  18:    //OK
  logic         spare_17 ;                               // bit  17:    //OK
  logic         spare_16 ;                               // bit  16:    //OK
  logic         pm_ip_clk_halt_b_2_rpt_0_iosf ;          // bit  15:    //OK
  logic         hqm_flr_prep ;                           // bit  14:    //OK
  logic         hqm_gated_local_override ;               // bit  13:    //OK
  logic         hqm_cdc_clk_enable ;                     // bit  12:    //OK
  logic         hqm_gclock_enable ;                      // bit  11:    //OK
  logic         hqm_clk_throttle ;                       // bit  10:    //OK
  logic         hqm_clk_enable ;                         // bit  9:    //OK
  logic         prim_clk_enable ;                        // bit  8:    //OK
  logic         spare_7 ;                                // bit  7:    //OK
  logic         spare_6 ;                                // bit  6:    //OK
  logic         spare_5 ;                                // bit  5:    //OK
  logic         spare_4 ;                                // bit  4:    //OK
  logic         spare_3 ;                                // bit  3:    //OK
  logic         spare_2 ;                                // bit  2:    //OK
  logic         spare_1 ;                                // bit  1:    //OK
  logic         core_gated_rst_b ;                       // bit  0:    //OK
} hqm_core_visa_str_in_t ;

                                                                                                                             
// Structures
typedef struct packed {
  logic         ap_alarm_up_ready;                       // bit  162
  logic         aqed_alarm_down_v;                       // bit  161
  logic         qed_lsp_deq_v;                           // bit  160
  logic         aqed_lsp_deq_v;                          // bit  159
  logic         ap_alarm_down_ready ;                    // bit  158
  logic         ap_alarm_down_v ;                        // bit  157
  logic         rop_alarm_up_ready;                      // bit  156
  logic         qed_alarm_down_v;                        // bit  155
  logic         lsp_alarm_down_ready ;                   // bit  154
  logic         lsp_alarm_down_v ;                       // bit  153
  logic         rop_alarm_down_ready ;                   // bit  152
  logic         rop_alarm_down_v ;                       // bit  151
  logic [1:0]   aqed_cfg_rsp_down ; //[5:4]              // bit  150:149
  logic         aqed_cfg_rsp_down_ack ;                  // bit  148
  logic [1:0]   aqed_cfg_req_down ; //[1:0]              // bit  147:146
  logic         aqed_cfg_req_down_write ;                // bit  145
  logic         aqed_cfg_req_down_read ;                 // bit  144
  logic [1:0]   qed_cfg_rsp_down ; //[5:4]               // bit  143:142
  logic         qed_cfg_rsp_down_ack ;                   // bit  141
  logic [1:0]   qed_cfg_req_down ; //[1:0]               // bit  140:139
  logic         qed_cfg_req_down_write ;                 // bit  138
  logic         qed_cfg_req_down_read ;                  // bit  137
  logic [1:0]   ap_cfg_rsp_down ; //[5:4]                // bit  136:135
  logic         ap_cfg_rsp_down_ack ;                    // bit  134
  logic [1:0]   ap_cfg_req_down ; //[1:0]                // bit  133:132
  logic         ap_cfg_req_down_write ;                  // bit  131
  logic         ap_cfg_req_down_read ;                   // bit  130
  logic [1:0]   lsp_cfg_rsp_down ; //[5:4]               // bit  129:128
  logic         lsp_cfg_rsp_down_ack ;                   // bit  127
  logic [1:0]   lsp_cfg_req_down ; //[1:0]               // bit  126:125
  logic         lsp_cfg_req_down_write ;                 // bit  124
  logic         lsp_cfg_req_down_read ;                  // bit  123
  logic [1:0]   rop_cfg_rsp_down ; //[5:4]               // bit  122:121
  logic         rop_cfg_rsp_down_ack ;                   // bit  120
  logic [1:0]   rop_cfg_req_down ; //[1:0]               // bit  119:118
  logic         rop_cfg_req_down_write ;                 // bit  117
  logic         rop_cfg_req_down_read ;                  // bit  116
  logic [1:0]   chp_cfg_rsp_down ; //[5:4]               // bit  115:114
  logic         chp_cfg_rsp_down_ack ;                   // bit  113
  logic [1:0]   chp_cfg_req_down ; //[1:0]               // bit  112:111
  logic         chp_cfg_req_down_write ;                 // bit  110
  logic         chp_cfg_req_down_read ;                  // bit  109
  logic [1:0]   mstr_cfg_rsp_down ; //[5:4]              // bit  108:107
  logic         mstr_cfg_rsp_down_ack ;                  // bit  106
  logic [1:0]   mstr_cfg_req_down ; //[1:0]              // bit  105:104
  logic         mstr_cfg_req_down_write ;                // bit  103
  logic         mstr_cfg_req_down_read ;                 // bit  102
  logic         rop_lsp_reordercmp_ready ;               // bit  101
  logic         rop_lsp_reordercmp_v ;                   // bit  100
  logic         aqed_lsp_sch_ready ;                     // bit  99
  logic         aqed_lsp_sch_v ;                         // bit  98
  logic         aqed_chp_sch_ready ;                     // bit  97
  logic         aqed_chp_sch_v ;                         // bit  96
  logic         aqed_ap_enq_ready ;                      // bit  95
  logic         aqed_ap_enq_v ;                          // bit  94
  logic         qed_aqed_enq_ready ;                     // bit  93
  logic         qed_aqed_enq_v ;                         // bit  92
  logic         qed_chp_sch_ready ;                      // bit  91
  logic         qed_chp_sch_v ;                          // bit  90
  logic         ap_aqed_ready ;                          // bit  89
  logic         ap_aqed_v ;                              // bit  88
  logic         dp_lsp_enq_rorply_ready ;                // bit  87
  logic         dp_lsp_enq_rorply_v ;                    // bit  86
  logic         dp_lsp_enq_dir_ready ;                   // bit  85
  logic         dp_lsp_enq_dir_v ;                       // bit  84
  logic         nalb_lsp_enq_rorply_ready ;              // bit  83
  logic         nalb_lsp_enq_rorply_v ;                  // bit  82
  logic         nalb_lsp_enq_lb_ready ;                  // bit  81
  logic         nalb_lsp_enq_lb_v ;                      // bit  80
  logic         lsp_nalb_sch_atq_ready ;                 // bit  79
  logic         lsp_nalb_sch_atq_v ;                     // bit  78
  logic         lsp_dp_sch_rorply_ready ;                // bit  77
  logic         lsp_dp_sch_rorply_v ;                    // bit  76
  logic         lsp_nalb_sch_rorply_ready ;              // bit  75
  logic         lsp_nalb_sch_rorply_v ;                  // bit  74
  logic         lsp_dp_sch_dir_ready ;                   // bit  73
  logic         lsp_dp_sch_dir_v ;                       // bit  72
  logic         lsp_nalb_sch_unoord_ready ;              // bit  71
  logic         lsp_nalb_sch_unoord_v ;                  // bit  70
  logic         rop_dqed_enq_ready ;                     // bit  69
  logic         rop_qed_enq_ready ;                      // bit  68
  logic         rop_qed_dqed_enq_v ;                     // bit  67
  logic         rop_nalb_enq_ready ;                     // bit  66
  logic         rop_nalb_enq_v ;                         // bit  65
  logic         rop_dp_enq_ready ;                       // bit  64
  logic         rop_dp_enq_v ;                           // bit  63
  logic         chp_lsp_token_ready ;                    // bit  62
  logic         chp_lsp_token_v ;                        // bit  61
  logic         chp_lsp_cmp_data ;                       // bit  60
  logic         chp_lsp_cmp_ready ;                      // bit  59
  logic         chp_lsp_cmp_v ;                          // bit  58
  logic         chp_rop_hcw_ready ;                      // bit  57
  logic         chp_rop_hcw_v ;                          // bit  56
  logic         hcw_sched_w_req_ready ;                  // bit  55
  logic         hcw_sched_w_req_valid ;                  // bit  54
  logic         hcw_enq_w_req_ready ;                    // bit  53
  logic         hcw_enq_w_req_valid ;                    // bit  52
  logic         cwdi_interrupt_w_req_ready ;             // bit  51
  logic         cwdi_interrupt_w_req_valid ;             // bit  50
  logic         interrupt_w_req_ready ;                  // bit  49
  logic         interrupt_w_req_valid ;                  // bit  48
  logic         aqed_unit_pipeidle ;                     // bit  47
  logic         qed_unit_pipeidle ;                      // bit  46
  logic         dp_unit_pipeidle ;                       // bit  45
  logic         ap_unit_pipeidle ;                       // bit  44
  logic         nalb_unit_pipeidle ;                     // bit  43
  logic         lsp_unit_pipeidle ;                      // bit  42
  logic         rop_unit_pipeidle ;                      // bit  41
  logic         chp_unit_pipeidle ;                      // bit  40
  logic         sys_unit_idle ;                          // bit  39
  logic         aqed_unit_idle ;                         // bit  38
  logic         qed_unit_idle ;                          // bit  37
  logic         dp_unit_idle ;                           // bit  36
  logic         ap_unit_idle ;                           // bit  35
  logic         nalb_unit_idle ;                         // bit  34
  logic         lsp_unit_idle ;                          // bit  33
  logic         rop_unit_idle ;                          // bit  32
  logic         chp_unit_idle ;                          // bit  31
  logic         sys_hqm_proc_clk_en;                     // bit  30
  logic         nalb_hqm_proc_clk_en;                    // bit  29
  logic         dp_hqm_proc_clk_en;                      // bit  28
  logic         qed_hqm_proc_clk_en;                     // bit  27
  logic         lsp_hqm_proc_clk_en;                     // bit  26
  logic         chp_hqm_proc_clk_en;                     // bit  25
  logic         sys_reset_done ;                         // bit  24
  logic         aqed_reset_done ;                        // bit  23
  logic         qed_reset_done ;                         // bit  22
  logic         dp_reset_done ;                          // bit  21
  logic         ap_reset_done ;                          // bit  20
  logic         nalb_reset_done ;                        // bit  19
  logic         lsp_reset_done ;                         // bit  18
  logic         rop_reset_done ;                         // bit  17
  logic         chp_reset_done ;                         // bit  16
  logic         hqm_alarm_v ;                            // bit  15
  logic         hqm_alarm_ready ;                        // bit  14
  logic         hqm_unit_pipeidle ;                      // bit  13
  logic         hqm_unit_idle ;                          // bit  12
  logic         constant_one ;                           // bit  11
  logic         rop_qed_force_clockon;                   // bit  10
  logic         hqm_proc_reset_done ;                    // bit  9
  logic         pm_ip_clk_halt_b_2_rpt_0_iosf ;          // bit  8
  logic         hqm_flr_prep ;                           // bit  7
  logic         hqm_gated_local_override ;               // bit  6
  logic         hqm_cdc_clk_enable ;                     // bit  5
  logic         hqm_gclock_enable ;                      // bit  4
  logic         hqm_clk_throttle ;                       // bit  3
  logic         hqm_clk_enable ;                         // bit  2
  logic         prim_clk_enable ;                        // bit  1
  logic         core_gated_rst_b ;                       // bit  0
} hqm_core_visa_str_t ;

logic                                    core_gated_rst_b_sync ; 

hqm_core_visa_str_in_t                   hqm_core_visa_str_in ;
hqm_core_visa_str_t                      visa_capture_reg_f, visa_capture_reg_nxt ;

`ifndef HQM_VISA_ELABORATE

//--------------------------------------------------------------------------------------- 
// Synchronizers 
 
hqm_AW_reset_sync_scan i_sync_reset_ring ( 
   .clk                                  ( clk ) 
 , .rst_n                                ( hqm_core_visa_str_in.core_gated_rst_b ) 
 , .fscan_rstbypen                       ( fscan_rstbypen )
 , .fscan_byprst_b                       ( fscan_byprst_b )
 , .rst_n_sync                           ( core_gated_rst_b_sync ) 
); 
  
//--------------------------------------------------------------------------------------- 
// Always block for assignments

always_comb begin
  
  // Assign input to struct
  hqm_core_visa_str_in                   = hqm_core_visa_str ; 

  // Default value of nxt for flop

  visa_capture_reg_nxt.ap_alarm_up_ready = hqm_core_visa_str_in.ap_alarm_up_ready ;
  visa_capture_reg_nxt.aqed_alarm_down_v = hqm_core_visa_str_in.aqed_alarm_down_v ;
  visa_capture_reg_nxt.qed_lsp_deq_v = hqm_core_visa_str_in.qed_lsp_deq_v ;
  visa_capture_reg_nxt.aqed_lsp_deq_v = hqm_core_visa_str_in.aqed_lsp_deq_v ;
  visa_capture_reg_nxt.ap_alarm_down_ready = hqm_core_visa_str_in.ap_alarm_down_ready ;
  visa_capture_reg_nxt.ap_alarm_down_v = hqm_core_visa_str_in.ap_alarm_down_v ;
  visa_capture_reg_nxt.rop_alarm_up_ready = hqm_core_visa_str_in.rop_alarm_up_ready ;
  visa_capture_reg_nxt.qed_alarm_down_v = hqm_core_visa_str_in.qed_alarm_down_v ;
  visa_capture_reg_nxt.lsp_alarm_down_ready = hqm_core_visa_str_in.lsp_alarm_down_ready ;
  visa_capture_reg_nxt.lsp_alarm_down_v = hqm_core_visa_str_in.lsp_alarm_down_v ;
  visa_capture_reg_nxt.rop_alarm_down_ready = hqm_core_visa_str_in.rop_alarm_down_ready ;
  visa_capture_reg_nxt.rop_alarm_down_v = hqm_core_visa_str_in.rop_alarm_down_v ;
  visa_capture_reg_nxt.aqed_cfg_rsp_down = hqm_core_visa_str_in.aqed_cfg_rsp_down ; 
  visa_capture_reg_nxt.aqed_cfg_rsp_down_ack = hqm_core_visa_str_in.aqed_cfg_rsp_down_ack ;
  visa_capture_reg_nxt.aqed_cfg_req_down = hqm_core_visa_str_in.aqed_cfg_req_down ;
  visa_capture_reg_nxt.aqed_cfg_req_down_write = hqm_core_visa_str_in.aqed_cfg_req_down_write ;
  visa_capture_reg_nxt.aqed_cfg_req_down_read = hqm_core_visa_str_in.aqed_cfg_req_down_read ;
  visa_capture_reg_nxt.qed_cfg_rsp_down = hqm_core_visa_str_in.qed_cfg_rsp_down ; 
  visa_capture_reg_nxt.qed_cfg_rsp_down_ack = hqm_core_visa_str_in.qed_cfg_rsp_down_ack ;
  visa_capture_reg_nxt.qed_cfg_req_down = hqm_core_visa_str_in.qed_cfg_req_down ;
  visa_capture_reg_nxt.qed_cfg_req_down_write = hqm_core_visa_str_in.qed_cfg_req_down_write ;
  visa_capture_reg_nxt.qed_cfg_req_down_read = hqm_core_visa_str_in.qed_cfg_req_down_read ;
  visa_capture_reg_nxt.ap_cfg_rsp_down = hqm_core_visa_str_in.ap_cfg_rsp_down ;
  visa_capture_reg_nxt.ap_cfg_rsp_down_ack = hqm_core_visa_str_in.ap_cfg_rsp_down_ack ;
  visa_capture_reg_nxt.ap_cfg_req_down = hqm_core_visa_str_in.ap_cfg_req_down ;
  visa_capture_reg_nxt.ap_cfg_req_down_write = hqm_core_visa_str_in.ap_cfg_req_down_write ;
  visa_capture_reg_nxt.ap_cfg_req_down_read = hqm_core_visa_str_in.ap_cfg_req_down_read ;
  visa_capture_reg_nxt.lsp_cfg_rsp_down = hqm_core_visa_str_in.lsp_cfg_rsp_down ;
  visa_capture_reg_nxt.lsp_cfg_rsp_down_ack = hqm_core_visa_str_in.lsp_cfg_rsp_down_ack ;
  visa_capture_reg_nxt.lsp_cfg_req_down = hqm_core_visa_str_in.lsp_cfg_req_down ;
  visa_capture_reg_nxt.lsp_cfg_req_down_write = hqm_core_visa_str_in.lsp_cfg_req_down_write ;
  visa_capture_reg_nxt.lsp_cfg_req_down_read = hqm_core_visa_str_in.lsp_cfg_req_down_read ;
  visa_capture_reg_nxt.rop_cfg_rsp_down = hqm_core_visa_str_in.rop_cfg_rsp_down ;
  visa_capture_reg_nxt.rop_cfg_rsp_down_ack = hqm_core_visa_str_in.rop_cfg_rsp_down_ack ;
  visa_capture_reg_nxt.rop_cfg_req_down = hqm_core_visa_str_in.rop_cfg_req_down ;
  visa_capture_reg_nxt.rop_cfg_req_down_write = hqm_core_visa_str_in.rop_cfg_req_down_write ;
  visa_capture_reg_nxt.rop_cfg_req_down_read = hqm_core_visa_str_in.rop_cfg_req_down_read ;
  visa_capture_reg_nxt.chp_cfg_rsp_down = hqm_core_visa_str_in.chp_cfg_rsp_down ;
  visa_capture_reg_nxt.chp_cfg_rsp_down_ack = hqm_core_visa_str_in.chp_cfg_rsp_down_ack ;
  visa_capture_reg_nxt.chp_cfg_req_down = hqm_core_visa_str_in.chp_cfg_req_down ;
  visa_capture_reg_nxt.chp_cfg_req_down_write = hqm_core_visa_str_in.chp_cfg_req_down_write ;
  visa_capture_reg_nxt.chp_cfg_req_down_read = hqm_core_visa_str_in.chp_cfg_req_down_read ;
  visa_capture_reg_nxt.mstr_cfg_rsp_down = hqm_core_visa_str_in.mstr_cfg_rsp_down ;
  visa_capture_reg_nxt.mstr_cfg_rsp_down_ack = hqm_core_visa_str_in.mstr_cfg_rsp_down_ack ;
  visa_capture_reg_nxt.mstr_cfg_req_down = hqm_core_visa_str_in.mstr_cfg_req_down ;
  visa_capture_reg_nxt.mstr_cfg_req_down_write = hqm_core_visa_str_in.mstr_cfg_req_down_write ;
  visa_capture_reg_nxt.mstr_cfg_req_down_read = hqm_core_visa_str_in.mstr_cfg_req_down_read ;
  visa_capture_reg_nxt.rop_lsp_reordercmp_ready = hqm_core_visa_str_in.rop_lsp_reordercmp_ready ;
  visa_capture_reg_nxt.rop_lsp_reordercmp_v = hqm_core_visa_str_in.rop_lsp_reordercmp_v ;
  visa_capture_reg_nxt.aqed_lsp_sch_ready = hqm_core_visa_str_in.aqed_lsp_sch_ready ;
  visa_capture_reg_nxt.aqed_lsp_sch_v = hqm_core_visa_str_in.aqed_lsp_sch_v ;
  visa_capture_reg_nxt.aqed_chp_sch_ready = hqm_core_visa_str_in.aqed_chp_sch_ready ;
  visa_capture_reg_nxt.aqed_chp_sch_v = hqm_core_visa_str_in.aqed_chp_sch_v ;
  visa_capture_reg_nxt.aqed_ap_enq_ready = hqm_core_visa_str_in.aqed_ap_enq_ready ;
  visa_capture_reg_nxt.aqed_ap_enq_v = hqm_core_visa_str_in.aqed_ap_enq_v ;
  visa_capture_reg_nxt.qed_aqed_enq_ready = hqm_core_visa_str_in.qed_aqed_enq_ready ;
  visa_capture_reg_nxt.qed_aqed_enq_v = hqm_core_visa_str_in.qed_aqed_enq_v ;
  visa_capture_reg_nxt.qed_chp_sch_ready = hqm_core_visa_str_in.qed_chp_sch_ready ;
  visa_capture_reg_nxt.qed_chp_sch_v = hqm_core_visa_str_in.qed_chp_sch_v ;
  visa_capture_reg_nxt.ap_aqed_ready = hqm_core_visa_str_in.ap_aqed_ready ;
  visa_capture_reg_nxt.ap_aqed_v = hqm_core_visa_str_in.ap_aqed_v ;
  visa_capture_reg_nxt.dp_lsp_enq_rorply_ready = hqm_core_visa_str_in.dp_lsp_enq_rorply_ready ;
  visa_capture_reg_nxt.dp_lsp_enq_rorply_v = hqm_core_visa_str_in.dp_lsp_enq_rorply_v ;
  visa_capture_reg_nxt.dp_lsp_enq_dir_ready = hqm_core_visa_str_in.dp_lsp_enq_dir_ready ;
  visa_capture_reg_nxt.dp_lsp_enq_dir_v = hqm_core_visa_str_in.dp_lsp_enq_dir_v ;
  visa_capture_reg_nxt.nalb_lsp_enq_rorply_ready = hqm_core_visa_str_in.nalb_lsp_enq_rorply_ready ;
  visa_capture_reg_nxt.nalb_lsp_enq_rorply_v = hqm_core_visa_str_in.nalb_lsp_enq_rorply_v ;
  visa_capture_reg_nxt.nalb_lsp_enq_lb_ready = hqm_core_visa_str_in.nalb_lsp_enq_lb_ready ;
  visa_capture_reg_nxt.nalb_lsp_enq_lb_v = hqm_core_visa_str_in.nalb_lsp_enq_lb_v ;
  visa_capture_reg_nxt.lsp_nalb_sch_atq_ready = hqm_core_visa_str_in.lsp_nalb_sch_atq_ready ;
  visa_capture_reg_nxt.lsp_nalb_sch_atq_v = hqm_core_visa_str_in.lsp_nalb_sch_atq_v ;
  visa_capture_reg_nxt.lsp_dp_sch_rorply_ready = hqm_core_visa_str_in.lsp_dp_sch_rorply_ready ;
  visa_capture_reg_nxt.lsp_dp_sch_rorply_v = hqm_core_visa_str_in.lsp_dp_sch_rorply_v ;
  visa_capture_reg_nxt.lsp_nalb_sch_rorply_ready = hqm_core_visa_str_in.lsp_nalb_sch_rorply_ready ;
  visa_capture_reg_nxt.lsp_nalb_sch_rorply_v = hqm_core_visa_str_in.lsp_nalb_sch_rorply_v ;
  visa_capture_reg_nxt.lsp_dp_sch_dir_ready = hqm_core_visa_str_in.lsp_dp_sch_dir_ready ;
  visa_capture_reg_nxt.lsp_dp_sch_dir_v = hqm_core_visa_str_in.lsp_dp_sch_dir_v ;
  visa_capture_reg_nxt.lsp_nalb_sch_unoord_ready = hqm_core_visa_str_in.lsp_nalb_sch_unoord_ready ;
  visa_capture_reg_nxt.lsp_nalb_sch_unoord_v = hqm_core_visa_str_in.lsp_nalb_sch_unoord_v ;
  visa_capture_reg_nxt.rop_dqed_enq_ready = hqm_core_visa_str_in.rop_dqed_enq_ready ;
  visa_capture_reg_nxt.rop_qed_enq_ready = hqm_core_visa_str_in.rop_qed_enq_ready ;
  visa_capture_reg_nxt.rop_qed_dqed_enq_v = hqm_core_visa_str_in.rop_qed_dqed_enq_v ;
  visa_capture_reg_nxt.rop_nalb_enq_ready = hqm_core_visa_str_in.rop_nalb_enq_ready ;
  visa_capture_reg_nxt.rop_nalb_enq_v = hqm_core_visa_str_in.rop_nalb_enq_v ;
  visa_capture_reg_nxt.rop_dp_enq_ready = hqm_core_visa_str_in.rop_dp_enq_ready ;
  visa_capture_reg_nxt.rop_dp_enq_v = hqm_core_visa_str_in.rop_dp_enq_v ;
  visa_capture_reg_nxt.chp_lsp_token_ready = hqm_core_visa_str_in.chp_lsp_token_ready ;
  visa_capture_reg_nxt.chp_lsp_token_v = hqm_core_visa_str_in.chp_lsp_token_v ;
  visa_capture_reg_nxt.chp_lsp_cmp_data = hqm_core_visa_str_in.chp_lsp_cmp_data ;
  visa_capture_reg_nxt.chp_lsp_cmp_ready = hqm_core_visa_str_in.chp_lsp_cmp_ready ;
  visa_capture_reg_nxt.chp_lsp_cmp_v = hqm_core_visa_str_in.chp_lsp_cmp_v ;
  visa_capture_reg_nxt.chp_rop_hcw_ready = hqm_core_visa_str_in.chp_rop_hcw_ready ;
  visa_capture_reg_nxt.chp_rop_hcw_v = hqm_core_visa_str_in.chp_rop_hcw_v ;
  visa_capture_reg_nxt.hcw_sched_w_req_ready = hqm_core_visa_str_in.hcw_sched_w_req_ready ;
  visa_capture_reg_nxt.hcw_sched_w_req_valid = hqm_core_visa_str_in.hcw_sched_w_req_valid ;
  visa_capture_reg_nxt.hcw_enq_w_req_ready = hqm_core_visa_str_in.hcw_enq_w_req_ready ;
  visa_capture_reg_nxt.hcw_enq_w_req_valid = hqm_core_visa_str_in.hcw_enq_w_req_valid ;
  visa_capture_reg_nxt.cwdi_interrupt_w_req_ready = hqm_core_visa_str_in.cwdi_interrupt_w_req_ready ;
  visa_capture_reg_nxt.cwdi_interrupt_w_req_valid = hqm_core_visa_str_in.cwdi_interrupt_w_req_valid ;
  visa_capture_reg_nxt.interrupt_w_req_ready = hqm_core_visa_str_in.interrupt_w_req_ready ;
  visa_capture_reg_nxt.interrupt_w_req_valid = hqm_core_visa_str_in.interrupt_w_req_valid ;
  visa_capture_reg_nxt.aqed_unit_pipeidle = hqm_core_visa_str_in.aqed_unit_pipeidle ;
  visa_capture_reg_nxt.qed_unit_pipeidle = hqm_core_visa_str_in.qed_unit_pipeidle ;
  visa_capture_reg_nxt.dp_unit_pipeidle = hqm_core_visa_str_in.dp_unit_pipeidle ;
  visa_capture_reg_nxt.ap_unit_pipeidle = hqm_core_visa_str_in.ap_unit_pipeidle ;
  visa_capture_reg_nxt.nalb_unit_pipeidle = hqm_core_visa_str_in.nalb_unit_pipeidle ;
  visa_capture_reg_nxt.lsp_unit_pipeidle = hqm_core_visa_str_in.lsp_unit_pipeidle ;
  visa_capture_reg_nxt.rop_unit_pipeidle = hqm_core_visa_str_in.rop_unit_pipeidle ;
  visa_capture_reg_nxt.chp_unit_pipeidle = hqm_core_visa_str_in.chp_unit_pipeidle ;
  visa_capture_reg_nxt.sys_unit_idle = hqm_core_visa_str_in.sys_unit_idle ;
  visa_capture_reg_nxt.aqed_unit_idle = hqm_core_visa_str_in.aqed_unit_idle ;
  visa_capture_reg_nxt.qed_unit_idle = hqm_core_visa_str_in.qed_unit_idle ;
  visa_capture_reg_nxt.dp_unit_idle = hqm_core_visa_str_in.dp_unit_idle ;
  visa_capture_reg_nxt.ap_unit_idle = hqm_core_visa_str_in.ap_unit_idle ;
  visa_capture_reg_nxt.nalb_unit_idle = hqm_core_visa_str_in.nalb_unit_idle ;
  visa_capture_reg_nxt.lsp_unit_idle = hqm_core_visa_str_in.lsp_unit_idle ;
  visa_capture_reg_nxt.rop_unit_idle = hqm_core_visa_str_in.rop_unit_idle ;
  visa_capture_reg_nxt.chp_unit_idle = hqm_core_visa_str_in.chp_unit_idle ;
  visa_capture_reg_nxt.sys_hqm_proc_clk_en = hqm_core_visa_str_in.sys_hqm_proc_clk_en ;
  visa_capture_reg_nxt.nalb_hqm_proc_clk_en = hqm_core_visa_str_in.nalb_hqm_proc_clk_en ;
  visa_capture_reg_nxt.dp_hqm_proc_clk_en = hqm_core_visa_str_in.dp_hqm_proc_clk_en ;
  visa_capture_reg_nxt.qed_hqm_proc_clk_en = hqm_core_visa_str_in.qed_hqm_proc_clk_en ;
  visa_capture_reg_nxt.lsp_hqm_proc_clk_en = hqm_core_visa_str_in.lsp_hqm_proc_clk_en ;
  visa_capture_reg_nxt.chp_hqm_proc_clk_en = hqm_core_visa_str_in.chp_hqm_proc_clk_en ;
  visa_capture_reg_nxt.sys_reset_done = hqm_core_visa_str_in.sys_reset_done ;
  visa_capture_reg_nxt.aqed_reset_done = hqm_core_visa_str_in.aqed_reset_done ;
  visa_capture_reg_nxt.qed_reset_done = hqm_core_visa_str_in.qed_reset_done ;
  visa_capture_reg_nxt.dp_reset_done = hqm_core_visa_str_in.dp_reset_done ;
  visa_capture_reg_nxt.ap_reset_done = hqm_core_visa_str_in.ap_reset_done ;
  visa_capture_reg_nxt.nalb_reset_done = hqm_core_visa_str_in.nalb_reset_done ;
  visa_capture_reg_nxt.lsp_reset_done = hqm_core_visa_str_in.lsp_reset_done ;
  visa_capture_reg_nxt.rop_reset_done = hqm_core_visa_str_in.rop_reset_done ;
  visa_capture_reg_nxt.chp_reset_done = hqm_core_visa_str_in.chp_reset_done ;
  visa_capture_reg_nxt.hqm_alarm_v = hqm_core_visa_str_in.hqm_alarm_v ;
  visa_capture_reg_nxt.hqm_alarm_ready = hqm_core_visa_str_in.hqm_alarm_ready ;
  visa_capture_reg_nxt.hqm_unit_pipeidle = hqm_core_visa_str_in.hqm_unit_pipeidle ;
  visa_capture_reg_nxt.hqm_unit_idle =hqm_core_visa_str_in.hqm_unit_idle ;
  visa_capture_reg_nxt.constant_one = hqm_core_visa_str_in.constant_one ;
  visa_capture_reg_nxt.rop_qed_force_clockon = hqm_core_visa_str_in.rop_qed_force_clockon ;
  visa_capture_reg_nxt.hqm_proc_reset_done = hqm_core_visa_str_in.hqm_proc_reset_done ;
  visa_capture_reg_nxt.pm_ip_clk_halt_b_2_rpt_0_iosf = hqm_core_visa_str_in.pm_ip_clk_halt_b_2_rpt_0_iosf ;
  visa_capture_reg_nxt.hqm_flr_prep = hqm_core_visa_str_in.hqm_flr_prep ;
  visa_capture_reg_nxt.hqm_gated_local_override = hqm_core_visa_str_in.hqm_gated_local_override ;
  visa_capture_reg_nxt.hqm_cdc_clk_enable = hqm_core_visa_str_in.hqm_cdc_clk_enable ;
  visa_capture_reg_nxt.hqm_gclock_enable = hqm_core_visa_str_in.hqm_gclock_enable ;
  visa_capture_reg_nxt.hqm_clk_throttle = hqm_core_visa_str_in.hqm_clk_throttle ;
  visa_capture_reg_nxt.hqm_clk_enable = hqm_core_visa_str_in.hqm_clk_enable ;
  visa_capture_reg_nxt.prim_clk_enable = hqm_core_visa_str_in.prim_clk_enable ;
  visa_capture_reg_nxt.core_gated_rst_b = hqm_core_visa_str_in.core_gated_rst_b ;

  // Output side of AW sync  
  visa_capture_reg_nxt.core_gated_rst_b  = core_gated_rst_b_sync ; 

end

//---------------------------------------------------------------------------------------
// Flops

always_ff @(posedge clk) begin

  visa_capture_reg_f <= visa_capture_reg_nxt ;

end

`endif

//---------------------------------------------------------------------------------------


// reuse-pragma startSub [InsertFilePrefix %subText]
`include "hqm_core_visa_block.VISA_IT.hqm_core_visa_block.logic.sv" // Auto Included by VISA IT - *** Do not modify this line ***
endmodule // hqm_core_visa_block

