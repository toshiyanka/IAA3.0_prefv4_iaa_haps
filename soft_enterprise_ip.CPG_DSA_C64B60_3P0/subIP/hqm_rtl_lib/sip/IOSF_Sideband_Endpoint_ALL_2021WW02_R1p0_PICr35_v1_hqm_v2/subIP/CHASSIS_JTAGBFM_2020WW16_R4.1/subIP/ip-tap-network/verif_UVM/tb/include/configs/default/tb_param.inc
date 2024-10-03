//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : tb_param.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAP NW
//    
//    
//    PURPOSE     : Parameter declarations
//    DESCRIPTION :
//       User defined parameters. Please refer User Manual for examples.
//    PARAMETERS  :
//    VERCODE                   : (0/1) To configure if VERCODE is Enabled or Disabled
//    ENABLE_VISA_SEL_REG       : (0/1) To configure if VISA Register is Present or not
//    CLOCK_PERIOD              : To Configure the Clock Period 
//    SIZE_OF_IR_REG_sTAP       : Size of the Instruction REGISTER
//    STAP_NUMBER_OF_STAPS      : Number of Slave Tap present in the TAP Network 
//    STAP_NUMBER_OF_WTAPS      : Number of WTAP present in the TAP Network
//    NO_OF_RW_REG              : Number of registers in the TAP
//                                It does NOT include : Mandatory Register
//    TOTAL_DATA_REGISTER_WIDTH : Sum of the register width of al the register
//    BYPASS_TRANS_WIDTH        : This the number of transaction that user wants
//                                to carry out in Bypass state.
//    RO_REGISTER_WIDTH         : Width of Register which do not have parallel Data in
//    VISA_SELECT_REG_WIDTH     : Width of the Visa Select Register
//    RW_REG_ADDR               : This defines the address for all the RW registers
//    RW_REG_WIDTH              : This defines the width for all the RW registers
//    TB_DATA_REGISTER_RESET_VALUES : This defines the Reset value of all the RW registers
//    TB_LOAD_PIN_OR_NOT_LOOPBACK   : This defines the LoopBack or pin in for each bit in 
//                                    all the RW registers
//---------------------------------------------------------------------------------------------
//----------------------------------------------------------------------
//--------------------FIXED PARAMETER DO NOT CHANGE---------------------
//----------------------------------------------------------------------
// This makes the env support 0.7 TAP Network. This Parameter is fixed to 1
parameter MULTIPLE_TAP = 1;

// As per Spec the SLVIDCODE/IDCODE width of M/S/W Taps is 32
parameter IDCODE_WIDTH = 32;

//----------------------------------------------------------------------
//--------------------------USER AREA-----------------------------------
//----------------------------------------------------------------------

// Parameter to Enable VERCODE for all the Taps in the Network(including mTAP)
// Value of 1 entered here would cause all the Taps to have vercode.
parameter VERCODE                                           = 0;

// Clock Period in the Env
parameter CLOCK_PERIOD                                      = 10000; 

// Number of sTAP's in the ENV connected to the TAPNW
parameter TB_NUMBER_OF_STAP                                 = 8;

// Number of WTAP's in the ENV connected to the TAPNW
parameter TB_NUMBER_OF_WTAP                                 = 0;

//----------------------------------------------------------------------
//--------------------FIXED PARAMETER DO NOT CHANGE---------------------
//----------------------------------------------------------------------

// MasterTap's count (one) is added to the NO_OF_STAP's
parameter NO_OF_STAP                                        = TB_NUMBER_OF_STAP + 1; 
parameter NO_OF_WTAP                                        = TB_NUMBER_OF_WTAP; 
parameter NO_OF_TAP                                         = NO_OF_STAP + NO_OF_WTAP; 

//----------------------------------------------------------------------
//--------------------------USER AREA-----------------------------------
//----------------------------------------------------------------------

// Width of Instruction Register(ENV mandates that all TAPS have same IR width)
parameter SIZE_OF_IR_REG_sTAP                               = 8;

//Sum total of Registers inside mTAP, sTAP, WTAP.
parameter NO_OF_RW_REG                                      = 26;

//Sum total Width of All Registers inside mTAP, sTAP, WTAP.
parameter TOTAL_DATA_REGISTER_WIDTH                         = 629;

// Sum Total Width of Register that do not have parallel_in pins (Sel,Sec_Sel,Sel_OVR,VISA REG)
parameter RO_REGISTER_WIDTH                                 = 53; 

// Width of Visa Select Register if present else 0
parameter VISA_SELECT_REG_WIDTH                             = 0;

// Address of each register in TAP's. Bottom most Entries are for mTAP Registers
// Top most entries are for TAP at the MSB position in TAP chain.
parameter [(SIZE_OF_IR_REG_sTAP*NO_OF_RW_REG)-1:0] RW_REG_ADDR = { 
                                                                   8'hA4,
                                                                   8'h34, 
                                                                   8'hA3, 
                                                                   8'h34, 
                                                                   8'hA2, 
                                                                   8'h34, 
                                                                   8'hA1, 
                                                                   8'h34, 
                                                                   8'hA4,
                                                                   8'h34, 
                                                                   8'hA3, 
                                                                   8'h34, 
                                                                   8'hA2, 
                                                                   8'h34, 
                                                                   8'hA1, 
                                                                   8'h34, 
                                                                   8'hA0, 
                                                                   8'h34, 
                                                                   8'h14, 
                                                                   8'h12, 
                                                                   8'h11, 
                                                                   8'h10,
                                                                   8'h0F,
                                                                   8'h0E,
                                                                   8'h09,
                                                                   8'h01
                                                                 }; 
// Number of register present in each of the TAP. Bottom most Entries are for mTAP Registers
// Bypass and IDCODE/SLVIDCODE Should be excluded
parameter [(16*NO_OF_TAP)-1:0]CON_NO_OF_DR_REG_STAP = {
                                                        16'd2,
													                 16'd2,
													                 16'd2,
													                 16'd2,
                                                        16'd2,
													                 16'd2,
													                 16'd2,
													                 16'd2,
													                 16'd10
													                };

// Width of Registers in each TAP including the mTAP. Bottom most Entries are for mTAP Registers
parameter [(16*NO_OF_RW_REG)-1:0] RW_REG_WIDTH = {  
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,
                                                                   16'd32,  
                                                                   16'd32,
                                                                   16'd1,
                                                                   16'd16,  
                                                                   16'd16,
                                                                   16'd8, 
                                                                   16'd3,
                                                                   16'd3,
                                                                   16'd3,
                                                                   16'd3
                                                 };

// Reset value of Registers in each TAP including the mTAP. Bottom most Entries are for mTAP Registers
parameter [(TOTAL_DATA_REGISTER_WIDTH - 1):0] TB_DATA_REGISTER_RESET_VALUES = {
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,  
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,  
                                                                   32'h0000_0000,
                                                                   32'h0000_0000,
                                                                   1'b0,
                                                                   16'd0, 
                                                                   16'd0,
                                                                   8'd0,
                                                                   3'd0,
                                                                   3'd0,
                                                                   3'd0,
                                                                   3'd0
                                                                              };
// Width of Registers in each TAP including the mTAP. Bottom most Entries are for mTAP Registers
parameter [TOTAL_DATA_REGISTER_WIDTH - 1:0] TB_LOAD_PIN_OR_NOT_LOOPBACK = {
                                                                   32'h00000000,
                                                                   32'h00000000,
                                                                   32'h00000000,
                                                                   32'h00000000,
                                                                   32'h00000000,
                                                                   32'h00000000,
                                                                   32'h00000000,
                                                                   32'h00000000,  
                                                                   32'h00000000,
                                                                   32'h00000000,
                                                                   32'h00000000,
                                                                   32'h00000000,
                                                                   32'h00000000,
                                                                   32'h00000000,
                                                                   32'h00000000,
                                                                   32'h00000000,  
                                                                   32'h00000000,
                                                                   32'h00000000,
                                                                   1'b0,
                                                                   16'd0, 
                                                                   16'd0,
                                                                   8'd0,
                                                                   3'd0,
                                                                   3'd0,
                                                                   3'd0,
                                                                   3'd0
                                                             };
// Position of TAP '0' for mTAP/sTAP and '1' for WTAP LSB pos is fixed to '0' for mTAP                                                              
parameter [NO_OF_TAP - 1 : 0 ] TB_POSTION_OF_TAPS = 9'b0_00000000;

//----------------------------------------------------------------------
//--------------------FIXED PARAMETER DO NOT CHANGE---------------------
//----------------------------------------------------------------------
parameter STAP_NUMBER_OF_STAPS      = NO_OF_TAP - 1;
parameter STAP_NUMBER_OF_WTAPS      = 0;
parameter SIZE_OF_IR_REG            = NO_OF_TAP*SIZE_OF_IR_REG_sTAP;
parameter NO_PARALLEL_OUT_BIT_WIDTH = 5*STAP_NUMBER_OF_STAPS + STAP_NUMBER_OF_WTAPS + 12;
parameter BYPASS_TRANS_WIDTH        = 2;
//----------------------------------------------------------------------
