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
//    FILENAME    : JtagBfmPinIf.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//    
//    
//    PURPOSE     : Pin Interface for the ENV
//    DESCRIPTION : This is the pin interface for the environment.
//----------------------------------------------------------------------

//**********************************************************************
// Adding generic parameter decleration for interfaces
//**********************************************************************

`ifndef JTAG_IF_PARAMS_DECL
  `define JTAG_IF_PARAMS_DECL \
                  parameter time CLOCK_PERIOD    = 10000, \
                            PWRGOOD_SRC     = 0, \
                            CLK_SRC         = 1, \
                            BFM_MON_CLK_DIS         = 0
`endif

`ifndef JTAG_IF_PARAMS_INST
 `define JTAG_IF_PARAMS_INST \
                  .CLOCK_PERIOD      (CLOCK_PERIOD), \
                  .PWRGOOD_SRC       (PWRGOOD_SRC ), \
                  .CLK_SRC           (CLK_SRC), \
                  .BFM_MON_CLK_DIS           (BFM_MON_CLK_DIS) 
`endif

//**********************************************************************

`ifndef INC_JtagBfmIntf
 `define INC_JtagBfmIntf 

//interface JtagBfmIntf #(parameter CLOCK_PERIOD    = 10000, 
//                                  PWRGOOD_SRC     = 0,
//                                  CLK_SRC         = 0)
interface JtagBfmIntf #(`JTAG_IF_PARAMS_DECL) 
                                  (input logic soc_powergood_rst_b,
                                   input logic soc_clock);

    import JtagBfmUserDatatypesPkg::*;

    //https://hsdes.intel.com/home/default.html#article?id=1503984875
    //Modified for driving 'X' on all Lines
    logic tck;
    logic tms;
    logic trst_b;
    logic tdi;
    logic tdo;
    logic exp_tdo;
    
    localparam API_SIZE_OF_IR_REG = 4096;
    logic [API_SIZE_OF_IR_REG-1:0] shift_ir_reg;
    logic [API_SIZE_OF_IR_REG-1:0] tap_ir_reg;  
    logic bfm_powergood_rst_b;
    logic tap_tdo_strobe;
    logic powergood_rst_b;
    logic bfm_shift_states; 
    logic jtagbfm_clk;
    static event tap_clk_r;
    static event tap_clk_f;

    //Adding signals for RTDR interface 
    localparam MAX_NUM_OF_RTDRS = 50; // This is set to a huge number. 
    logic tap_rtdr_tck;
    logic [MAX_NUM_OF_RTDRS - 1:0] tap_rtdr_tdi;
    logic [MAX_NUM_OF_RTDRS - 1:0] tap_rtdr_tdo;
    logic [MAX_NUM_OF_RTDRS - 1:0] tap_rtdr_capture;
    logic [MAX_NUM_OF_RTDRS - 1:0] tap_rtdr_shift;
    logic [MAX_NUM_OF_RTDRS - 1:0] tap_rtdr_update;
    logic [MAX_NUM_OF_RTDRS - 1:0] tap_rtdr_irdec;
    logic tap_rtdr_powergood;
    logic tap_rtdr_selectir;
    logic tap_rtdr_rti;
    logic [MAX_NUM_OF_RTDRS - 1:0]tap_rtdr_prog_rst_b;
    
    logic         force_clk_gating_off;
    logic         en_clk_gating;
    logic         turn_clk_on;    
    logic         park_at_local;
    logic         sample_tdo_on_neg_edge;
  
    // Recommended by Dhruba during DNV FC debug around Jan-2014
    string intf_name;
    initial begin
       $sformat (intf_name, "%m");
      //$display ("This instance of JtagBfmIntf is hierarchically at : %s", intf_name);
        $display ("JtagBfmIntf:Value of BFM_MON_CLK_DIS = %d",BFM_MON_CLK_DIS);
    end

    //--------------------------------------------------------------------
    // Clock Generation
    //--------------------------------------------------------------------
    logic clock;

    initial begin 
        clock = 1'b0;
    end
   
    always begin
        #(CLOCK_PERIOD/2) clock = ~(clock);
    end

    //--------------------------------------------------------------------
    // Mux for Power Good 
    //--------------------------------------------------------------------
    assign powergood_rst_b = (PWRGOOD_SRC == 1) ? soc_powergood_rst_b : bfm_powergood_rst_b;
    assign tap_rtdr_powergood = (PWRGOOD_SRC == 1) ? soc_powergood_rst_b : bfm_powergood_rst_b;
    assign jtagbfm_clk = (CLK_SRC == 1)     ? soc_clock : clock;
    
    //modport  mp (
    //  inout wire tck, tap_rtdr_tck
    //);
    //https://hsdes.intel.com/appstore/article/#/1607013057
    generate if (BFM_MON_CLK_DIS==0)begin
    // (* vcs_ignore_drive *)
    // always @(*)begin
       assign tap_rtdr_tck = (turn_clk_on == 1'b1)?jtagbfm_clk:(en_clk_gating == 1'b0)?jtagbfm_clk:(force_clk_gating_off == 1'b1)?jtagbfm_clk:park_at_local;
       assign tck = (turn_clk_on == 1'b1)?jtagbfm_clk:(en_clk_gating == 1'b0)?jtagbfm_clk:(force_clk_gating_off == 1'b1)?jtagbfm_clk:park_at_local;
    // end
    end
    endgenerate
    //https://hsdes.intel.com/appstore/article/#/1606693671
    always @(posedge jtagbfm_clk) begin
        ->tap_clk_r;
    end

    always @(negedge jtagbfm_clk) begin
        ->tap_clk_f;
    end
    //--------------------------------------------------------------------
    // Assertion on TMS
    // Change detector on posedge
    //--------------------------------------------------------------------

    localparam LOW  = 1'b0;
    localparam HIGH = 1'b1;

    wire   tms_pulse;
    wire   tms_delayed_by_1ps;
    assign #1 tms_delayed_by_1ps     = tms ;
    assign tms_pulse                 = tms ^ tms_delayed_by_1ps;

    fsm_state_test  driver_state;
    fsm_state_test  mon_driver_state;
    fsm_state_test display_state_t;
    fsm_state_test mon_display_state_t;

    always_comb
    begin
       driver_state = display_state_t;
    end
    
    always_comb
    begin
       mon_driver_state = mon_display_state_t;
    end

    wire   tck_delayed_by_1ps;
    assign #1 tck_delayed_by_1ps     =  tck;
`ifndef INTEL_SVA_OFF 
   `ifndef JTAGBFM_SVA_OFF 
    property bfmintf_tap_assert_tms_during_posedge_clk;
        @(posedge tck_delayed_by_1ps)
        (powergood_rst_b) |-> (tms_pulse == LOW);
    endproperty: bfmintf_tap_assert_tms_during_posedge_clk

    chk_bfmintf_tap_assert_tms_during_posedge_clk_0:
    assert property (bfmintf_tap_assert_tms_during_posedge_clk)
    else $error ("ERROR: JtagBfmPinIf: TMS is not asserted at negedge of tck, but asserted at posedge");

    property bfmintf_tap_assert_check_tms_change_wrt_clk;
        @(posedge tms_pulse)
        (powergood_rst_b) |-> (tck_delayed_by_1ps == HIGH);
    endproperty: bfmintf_tap_assert_check_tms_change_wrt_clk

    chk_bfmintf_tap_assert_check_tms_change_wrt_clk_0:
    assert property (bfmintf_tap_assert_check_tms_change_wrt_clk)
    else $error ("ERROR: JtagBfmPinIf: TMS is not asserted wrt clk");
   `endif
`endif


    //--------------------------------------------------------------------
    // Assertion on TDI
    // Change detector on posedge
    //--------------------------------------------------------------------

    wire   tdi_pulse;
    wire   tdi_delayed_by_1ps;
    assign #1 tdi_delayed_by_1ps     = tdi;
    assign tdi_pulse                 = tdi ^ tdi_delayed_by_1ps;

`ifndef INTEL_SVA_OFF 
    `ifndef JTAGBFM_SVA_OFF 
    property bfmintf_tap_assert_tdi_during_posedge_clk;
        @(posedge tck_delayed_by_1ps)
        (powergood_rst_b) |-> (tdi_pulse == LOW);
    endproperty:bfmintf_tap_assert_tdi_during_posedge_clk

    chk_bfmintf_tap_assert_tdi_during_posedge_clk_0:
    assert property (bfmintf_tap_assert_tdi_during_posedge_clk)
    else $error ("ERROR: JtagBfmPinIf: TDI is not asserted at negedge of tck, but asserted at posedge");

    property bfmintf_tap_assert_check_tdi_change_wrt_clk;
        @(posedge tdi_pulse)
        (powergood_rst_b) |-> (tck_delayed_by_1ps == HIGH);
    endproperty:bfmintf_tap_assert_check_tdi_change_wrt_clk

    chk_bfmintf_tap_assert_check_tdi_change_wrt_clk_0:
    assert property (bfmintf_tap_assert_check_tdi_change_wrt_clk)
    else $error ("ERROR: JtagBfmPinIf: TDI is not asserted wrt clk");
  `endif
`endif

    //--------------------------------------------------------------------
    // Assertion on TDO
    // Change detector on posedge
    // Description: bfmintf_tap_assert_tdo_during_posedge_clk flags false errors when TCK (or TDO) is delayed through the chip.
    // A much better check would be to delay TDO by 1ps and make sure that TCK is LOW.  
    // This ensures that whether TDO is delayed or not in the DUT, the assertion will be able to catch changes on the posedge of TCK.
    // https://hsdes.intel.com/home/default.html#article?id=1017675823
    //--------------------------------------------------------------------

    wire   tdo_delayed_by_1ps;
    assign #1 tdo_delayed_by_1ps     = tdo;
    //if(sample_tdo_on_neg_edge==1)begin
  `ifndef INTEL_SVA_OFF 
    `ifndef JTAGBFM_SVA_OFF 
        property bfmintf_tap_assert_tdo_during_posedge_clk;
           //@(tdo)
           @(tdo_delayed_by_1ps)
             disable iff ((powergood_rst_b == LOW) || (trst_b == LOW)||sample_tdo_on_neg_edge)
             //((bfm_shift_states) && (tms == LOW)) |-> (tck == HIGH);
             ((bfm_shift_states) && (tms == LOW)) |-> (tck == LOW);
        endproperty: bfmintf_tap_assert_tdo_during_posedge_clk

        chk_bfmintf_tap_assert_tdo_during_posedge_clk_0:
        assert property (bfmintf_tap_assert_tdo_during_posedge_clk)
        else begin 
           $error ("ERROR: JtagBfmPinIf: TDO is not asserted at negedge of tck, but asserted at posedge");
        end
    //end
    //else begin
       property bfmintf_tap_assert_tdo_during_negedge_clk;
          //@(tdo)
          @(tdo_delayed_by_1ps)
            disable iff ((powergood_rst_b == LOW) || (trst_b == LOW)||~sample_tdo_on_neg_edge)
            ((bfm_shift_states) && (tms == LOW)) |-> (tck == HIGH);
       endproperty: bfmintf_tap_assert_tdo_during_negedge_clk

       chk_bfmintf_tap_assert_tdo_during_negedge_clk_0:
       assert property (bfmintf_tap_assert_tdo_during_negedge_clk)
       else begin 
          $error ("ERROR: JtagBfmPinIf: TDO is not asserted at posedge of tck, but asserted at negedge ");
       end
    //end
    //https://hsdes.intel.com/appstore/article/#/1604289527
    //https://hsdes.intel.com/appstore/article/#/1606888903
    `ifdef JTAGBFM_TDO_1_ASSERT_EN
       property bfmintf_tap_assert_tdo_1_during_non_shift_states;
          @(negedge tck_delayed_by_1ps)
            disable iff ((powergood_rst_b == LOW) || (trst_b == LOW))
            ((driver_state !== SHIR) || (driver_state !== SHDR) ) |-> (tdo_delayed_by_1ps == 1'b1);
       endproperty: bfmintf_tap_assert_tdo_1_during_non_shift_states

       chk_bfmintf_tap_assert_tdo_1_during_non_shift_states:
       assert property (bfmintf_tap_assert_tdo_1_during_non_shift_states)
       else $error ("ERROR: JtagBfmPinIf: TDO is not 1 at non-shift states");
    `endif
   `endif
  `endif
    
    // ------------------------------------------------------------------------------------
    // https://vthsd.intel.com/hsd/seg_softip/default.aspx#bug/default.aspx?bug_id=4963783
    // --------------------------Coverage for the FSM States and ARCS----------------------
  `ifdef DFX_COVERAGE_ON 
    covergroup ChassisJtagBfmFsm @ (posedge tck) ;
    option.per_instance = 1;
    option.name         = "JtagPinIfFsmStateArcCG" ;
    option.comment      = "Gives the FSM State and Arc Coverage" ;
      
      // Auto bin for all the FSM states
      FSM: coverpoint driver_state ;

      // Specific ARC coverage of state transitions
      ARC: coverpoint driver_state 
           {
             bins ARC_BIN_TLRS_TLRS   = ( TLRS => TLRS );
             bins ARC_BIN_TLRS_RUTI   = ( TLRS => RUTI );
             bins ARC_BIN_RUTI_RUTI   = ( RUTI => RUTI );
             bins ARC_BIN_RUTI_SDRS   = ( RUTI => SDRS );
             bins ARC_BIN_SDRS_SIRS   = ( SDRS => SIRS );
             bins ARC_BIN_SDRS_CADR   = ( SDRS => CADR );
             bins ARC_BIN_CADR_SHDR   = ( CADR => SHDR );
             bins ARC_BIN_CADR_E1DR   = ( CADR => E1DR );
             bins ARC_BIN_SHDR_E1DR   = ( SHDR => E1DR );
             bins ARC_BIN_SHDR_SHDR   = ( SHDR => SHDR );
             bins ARC_BIN_E1DR_PADR   = ( E1DR => PADR );
             bins ARC_BIN_E1DR_UPDR   = ( E1DR => UPDR );
             bins ARC_BIN_PADR_E2DR   = ( PADR => E2DR );
             bins ARC_BIN_PADR_PADR   = ( PADR => PADR );
             bins ARC_BIN_E2DR_UPDR   = ( E2DR => UPDR );
             bins ARC_BIN_E2DR_SHDR   = ( E2DR => SHDR );
             bins ARC_BIN_UPDR_RUTI   = ( UPDR => RUTI );
             bins ARC_BIN_UPDR_SDRS   = ( UPDR => SDRS );
             bins ARC_BIN_SIRS_CAIR   = ( SIRS => CAIR );
             bins ARC_BIN_SIRS_TLRS   = ( SIRS => TLRS );
             bins ARC_BIN_CAIR_SHIR   = ( CAIR => SHIR );
             bins ARC_BIN_CAIR_E1IR   = ( CAIR => E1IR );
             bins ARC_BIN_SHIR_E1IR   = ( SHIR => E1IR );
             bins ARC_BIN_SHIR_SHIR   = ( SHIR => SHIR );
             bins ARC_BIN_E1IR_PAIR   = ( E1IR => PAIR );
             bins ARC_BIN_E1IR_UPIR   = ( E1IR => UPIR );
             bins ARC_BIN_PAIR_E2IR   = ( PAIR => E2IR );
             bins ARC_BIN_PAIR_PAIR   = ( PAIR => PAIR );
             bins ARC_BIN_E2IR_UPIR   = ( E2IR => UPIR );
             bins ARC_BIN_E2IR_SHIR   = ( E2IR => SHIR );
             bins ARC_BIN_UPIR_RUTI   = ( UPIR => RUTI );
             bins ARC_BIN_UPIR_SDRS   = ( UPIR => SDRS );
           }
    endgroup:ChassisJtagBfmFsm

    // 
    ChassisJtagBfmFsm i_ChassisJtagBfmFsm = new();
 `endif

endinterface

`endif // INC_JtagBfmIntf
