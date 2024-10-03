//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//
//  Collateral Description:
//  dteg-jtag_bfm
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  CHASSIS_JTAGBFM_2020WW16_R4.1
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : JtagBfmPkg.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//    
//    
//    PURPOSE     : Package file for the ENV 
//    DESCRIPTION : Includes all the file in the ENV 
//----------------------------------------------------------------------

`ifndef INC_JtagBfmPkg
 `define INC_JtagBfmPkg

package JtagBfmPkg;

    `ifdef JTAG_BFM_DEBUG_MSG
       `define BFM_DEBUG  1
    `else
       `define BFM_DEBUG  0
    `endif
    
    `define dbg_display if (`BFM_DEBUG) $display

    `ifdef DTEG_UVM_EN
       import uvm_pkg::*;
    `endif
    import ovm_pkg::*;
    `ifdef DTEG_XVM_EN
       import xvm_pkg::*;
    `endif
    import JtagBfmUserDatatypesPkg::*;

    //------------------------------------------------------------------------------------
    // Added the enhancement to support the HSD with the details given below
    // https://vthsd.intel.com/hsd/seg_softip/default.aspx#bug/default.aspx?bug_id=5076834
    //
    // Uncomment the export line for VCS Versions above 2013.06 and the 
    // JtagBfmUserDatatypesPkg is required to be imported seperately for use in Driver.
    // For Lower versions the JtagBfmPkg will work as is.
    // -----------------------------------------------------------------------------------
    //https://hsdes.intel.com/home/default.html#article?id=1503985317
    //Added defines to supress export for older vcs versions(<2011)
    `ifdef SNPS201412BC
    `else
     //novas translate_off 
     export JtagBfmUserDatatypesPkg::*;  
     //novas translate_on
    `endif
    `ifdef DTEG_UVM_EN
       `include "uvm_macros.svh"
    `endif
    `include "ovm_macros.svh"
    `ifdef DTEG_XVM_EN
       `include "xvm_macros.svh"
    `endif

     //C functions 
     `ifdef JTAG_BFM_AES_256 
     import "DPI-C" context function void aes_c_enc_wrapper(byte aes_input[0:15], 
                                                            byte aes_key[0:31],
                                                     output byte aes_enc_out[0:15]);
     
     import "DPI-C" context function void aes_c_dec_wrapper(byte enc_out[0:15], 
                                                            byte aes_key[0:31], 
                                                     output byte dec_out[0:15]);
     `else
     import "DPI-C" context function void aes_c_enc_wrapper(byte aes_input[0:15], 
                                                            byte aes_key[0:15],
                                                     output byte aes_enc_out[0:15]);
     
     import "DPI-C" context function void aes_c_dec_wrapper(byte enc_out[0:15], 
                                                            byte aes_key[0:15], 
                                                     output byte dec_out[0:15]);
    `endif
     //Structure of ENDEBUG_ENCRYPTION_REG 
     typedef struct packed {
             logic [31:0]   REG_ACCESS_COUNTER; //[127:96] The Encrypted DR for the remote Debug 
             logic [2:0]    RSVD;               //[95:93] Resereved 
             logic          USE_DR_AS_IR;       //[92:92] use the 64 DR as IR and DR counter as IR counter 
             logic [1:0]    LONG_IR_MODE;       //[91:90] 00: IR no longer than 128bits ; 01: Enter IR Shift Directly from IDLE ;10: Return to IDLE after IR shift ; 11: Enter IR shift directly from IDLE and Return to IDLE after IR shift 
             logic [1:0]    LONG_DR_MODE;       //[89:88] 00: DR no longer than 128bits ; 01: Enter DR Shift Directly from IDLE ;10: Return to IDLE after DR shift ; 11: Enter DR shift directly from IDLE and Return to IDLE after DR shift 
             logic [1:0]    FSM_MODE;           //[87:86] 00: TRST ; 01: Shift IR only; 10: Shift DR only; 11: Shift IR followed by DR 
             logic [5:0]    DRSHIFT_COUNTER;    //[85:80] This field tells the FSM how many TCLKS to shift the DR shift chain 
             logic [15:0]   IRDATA;             //[79:64] The Encrypted IR for the remote Debug 
             logic [63:0]   DRDATA;             //[63:0] The Encrypted DR for the remote Debug 
     } jtagbfm_encryption_reg;
  
     typedef struct packed {
           `ifdef JTAGBFM_ENDEBUG_110REV
           logic [1:0]   RSVD_19_18;            //[19:18] RSVD 
           `else
           logic         SKIPRUTISTATEEN;       // To Skip RUTI for ARC TAP.
           logic         PGCB_FORCE_RST_B_OVERRIDE; //Used to override pgcb_rst_b in PGCB debug mode.
           logic         ENDEBUG_CLOCK_SRC;     //[18]    Mux Select between Crystal Clock and endebug_clk 
           `endif
           logic         FORCE_CLK_UNGATE;      //[17:17] Endebug will force the endebug clock gating logic to wake the clock and keep it on
                                                //        until this bit is cleared. 
                                                //           0: Normal operation
                                                //           1: Force endebug clock
           logic         CLEAR_LATCHED_NETWORK; //[16:16] Clear Latched Network latches. This bit clears the latches used for the SoC TAP network.
           logic         FORCE_PWR_UNGATE;      //[15:15] enDebug IP power ungate control
           `ifdef JTAGBFM_ENDEBUG_110REV
           logic [7:0]   RUTI_COUNT;            //[14:7]  RTI count. This provides the number of TCK cycles in the Run/Test-Idle state. 0h: reserved, 1h: 1 cycle, 2h: 2 cycle, ...
           `else
           logic [7:0]   RSVD_14_7;             //[14:7]  RSVD
           `endif
           logic         TAP_RESET;             //[6:6]   Assert TAP reset to internal TAP tree 
           logic [2:0]   TCK_RATIO;             //[5:3]   000 - TCLK = BCLK = 100Mhz ; 001 - Div by 2 ; 010 - Div by 4 ; 011 - Div by 8 ; 100 - Div by 16 ; 101- div by 32 ; TBD (currently: TCLK= 100 MHZ) 
           logic         END_DEBUG_SESSION;     //[2:2]   End Session , go to KEY generation error , hte session will be terminated 
           logic [1:0]   START_DEBUG_SESSION;   //[1:0]   00 - don't start ; 01-Starts remote debug session. ( wait for PCU to complete the TAP ownership) ;10-Force remote debug session to start,don't wait for PCU to finish; 11- TBD 
     } jtagbfm_encryption_cfg;

     //-------------------------------------------------------------------------------------------------------
     //ENDEBUG_DEBUG_CFG struct definition
     typedef struct packed {
             `ifndef JTAGBFM_ENDEBUG_110REV
             logic [1:0] RSVD;              //[17:16] Resereved
             logic       SESSION_KEYOVR_EN; //[15:15] Session Key Override Enable for Session Key Register Value.
             logic       DEBUGEN;           //[14:14] Enable access to two debug registers that are locked in Policy6.
             `else
             logic [3:0] RSVD;              //[17:14] Resereved
             `endif
             logic [3:0] FIFOLPBK_DATAINV;  //[13:10] FIFO Loopback data inversion with EXOR bits [7:4]:
                                            //           fifo_reg_out[127:8] = fifo_reg_in[127:8]
                                            //           fifo_reg_out[7:4]   = fifo_reg_in[127:8] ^ FIFOLPBK_DATAINV
                                            //           fifo_reg_out[3:0]   = fifo_reg_in[3:0]
             logic [1:0] LOOPBK_MODE;       //[9:8] Enable loopback modes:
                                            //         00 : normal operation (no loopback)
                                            //         01 : near loopback "FIFO_IN" to "FIFO_OUT"
                                            //         10 : post decrypt loopback to encrypt path
                                            //         11 : reserved
             logic DISABLE_COUNTER_SESSION; //[7:7] Disable Session Counter 
             logic SESSIONKEY_OVRD;         //[6:6] Session Key OVerride with a fixed number 
             logic ENDEBUG_MUX_DISABLE;     //[5:5] Disbale the endebug mux, need to force TAP reset after using this bit 
             logic DRNG_OVRD;               //[4:4] in debug mode Ovrride the seesion in key with hardcoded Key 
             logic STAY_IN_CURRENT_POLICY;  //[3:3] if enabled MUX still would allow enDebug commands but enDebug will not override DFx_Agg output. All other debug features would be open 
             logic FUSEKEY_OVRD;            //[2:2] 
             logic BYPASS_DEC_MACHINE;      //[1:1] Bypass the DEC machine, drive the data as is to the FSM controller 
             logic BYPASS_ENC_MACHINE;      //[0:0] Bypass the Enc machine, drive the data as is to the FSM controller 
     } jtagbfm_encryption_debug_cfg;

     //-------------------------------------------------------------------------------------------------------
     //ENDEBUG_DEBUG_SESSIONKEYOVR struct definition
     typedef struct packed {
             logic [127:0]   SESSIONKEYOVRVAL;          //[127:0]] Override value for Session Key 
     } jtagbfm_encryption_debug_sessionkeyovr;
   
    `include "JtagBfmSeqDrvPkt.sv"
    `include "JtagBfmOutMonSbrPkt.sv"
    `include "JtagBfmInMonSbrPkt.sv"
   
    `include "JtagBfmIfContainer.sv"
   
    `include "JtagBfmSequencer.sv"
    `include "JtagBfmDriver.sv"

    `include "JtagBfmInputMonitor.sv"
    `include "JtagBfmOutputMonitor.sv"

    `include "JtagBfmAPIs.sv"   

    `include "JtagBfmSoCTapNwRegModel.sv"
    `include "JtagBfmSoCTapNwAPIs.sv"
    
    `include "JtagBfmTracker.sv"
    `include "JtagBfmMasterAgent.sv"

    `include "JtagBfmCfg.svh"
endpackage

`endif // INC_JtagBfmPkg
   
