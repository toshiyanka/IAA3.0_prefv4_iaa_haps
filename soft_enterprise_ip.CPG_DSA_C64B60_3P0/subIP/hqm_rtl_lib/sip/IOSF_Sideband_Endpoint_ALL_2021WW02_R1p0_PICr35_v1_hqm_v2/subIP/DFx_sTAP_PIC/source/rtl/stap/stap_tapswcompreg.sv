//  -----------------------------------------------------------------------------
//  --                      Intel Proprietary
//  --              Copyright (C) 2010 Intel Corporation
//  --                     All Rights Reserved
//  -----------------------------------------------------------------------------
//  -- Module Name  : tapswcompreg
//  -- Author       : C. Koza 
//  -- Project Name : P1271 HIP TAP
//  -- Creation Date: 8/9/2010
//  -- Description  : Custom TAP register to support SWCOMP, with specific write-enable bits.
//                    Includes serial and parallel stages. Supports Capture/Shift/Update.
//                    Hardware reset only, not by TAP Test-Logic-Reset state,
//                    intended for use for Private test data registers
//                    which are to be reset by powergood reset only.
//
//  9/3/2010  C. Koza  Adding capability to do signed comparisons.
//    Port changes: added cmpsel_signed and cmpsel_sgnmag
//
//   8/20/2010 C. Koza  Added cmpen_blk_multi_fail control
//
//  08/09/2010 C. Koza:
//    Based on tap_rw_pdatareg module with updates to implement write-enables.

//  07/09/2010 C. Koza:
//    Updated ports, to make defaultpval a parameter instead of signal input.
//    Intention is ensure provide a constant h/w reset value at parallel stage for synthesis.
//-------------------------------------------------------------------------------

module stap_tapswcompreg
  #(
    parameter STAP_SWCOMP_NUM_OF_COMPARE_BITS = 10
    )
   (
    input logic                                         jtclk,    //jtag clock
    input logic                                         jpwrgood_rst_b,  //hardware reset
    input logic                                         tdi,      //serial input data to register
    input logic                                         capture,  //asserted to load parallel data (defaultval) into shift register
    input logic                                         shift,    //enable shifting of TDI data through the shift register
    input logic                                         update,   //enable parallel transfer from serial stage to parallel outputs 
    input logic                                         enable,   //enables this register for shift/capture at rising clock

    // values to capture into SWCOMP test data register, from Comparator
    input logic [7:0]                                   cmp_firstfail_cnt,
    input logic                                         cmp_sticky_fail_hi,
    input logic                                         cmp_sticky_fail_lo,

    // outputs from SWCOMP test data register parallel stage, to comparator
    output logic [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]  cmplim_hi,
    output logic [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]  cmplim_lo,
    output logic [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]  cmplim_mask,
    output logic                                        cmp_mirror_sel,
    output logic                                        cmp_tdo_sel,
    output logic                                        cmp_tdo_forcelo,
    output logic                                        cmpen_main,
    output logic                                        cmpsel_signed,
    output logic                                        cmpsel_sgnmag,
    output logic                                        cmpen_le_limhi,
    output logic                                        cmpen_ge_limlo,
    output logic                                        cmpen_blk_multi_fail,
    

    output logic                                        tdoctrl,
    output logic                                        tdostat

    );

  // parameter WIDTH = (2+3*DWIDTH+CSWIDTH); // 2xWE bits + 3x(CMPLIM values) + Control/Status bits
    localparam CMP0 = (STAP_SWCOMP_NUM_OF_COMPARE_BITS -5) +18;
    localparam CMP1 = (STAP_SWCOMP_NUM_OF_COMPARE_BITS + CMP0);
    localparam CMP2 = (STAP_SWCOMP_NUM_OF_COMPARE_BITS + CMP1);
       
    logic                                              cmplim_we;
    logic                                              ctrl_bits_we;
    logic                                              capture_en;
    logic                                              shift_en;
    logic                                              update_en;
    logic                                              update_en_control;
    logic                                              update_en_cmplim ;
    logic [CMP2-1:0]                                   serialdata_next;
    logic [CMP2-1:0]                                   serialdata;      //parallel output of the serial data shift-stage flops.
    logic [CMP2-1:0]                                   statusdata;      //parallel output of the serial data shift-stage flops.
    logic [CMP2-1:0]                                   statusdata_next;      //parallel output of the serial data shift-stage flops.
    logic [CMP2-1:0]                                   pre_data_regval;
    logic [CMP2-1:0]                                   pdata_regval;    //parallel output of the parallel output stage flops.
    logic [CMP2-1:0]                                   captdata_ctrl;        //value loaded into serial shift stage at posedge of clock in capture
    logic [CMP2-1:0]                                   captdata_stat;        //value loaded into serial shift stage at posedge of clock in capture

    logic                                              nc_cmp_rsvd_0; // no-connect reserved bits   
    logic                                              nc_cmp_rsvd_1; // no-connect reserved bits   

   // Create gated versions of capture, shift, and update which
   // are asserted only when this register is selected:
   assign capture_en = capture & enable;
   assign shift_en = shift & enable;
   assign update_en = update & enable;

// Control Register operations
   always_comb begin: serialdata_next_logic
      unique case({shift_en,capture_en})
        2'b00 : serialdata_next = serialdata;  // retain
        2'b01 : serialdata_next = captdata_ctrl; // capture
        2'b10 : serialdata_next = {tdi,serialdata[CMP2-1:1]}; // shifting serial data from TDI / prev. flop
        //VCS coverage off
        default : serialdata_next = {(CMP2){1'bX}};
        //VCS coverage on
      endcase
   end

   
   always_ff @(posedge jtclk or negedge jpwrgood_rst_b) begin : serial_shiftreg_flops
      if (jpwrgood_rst_b == 1'b0)
      serialdata <= {(CMP2){1'b0}};
      else 
      serialdata <= serialdata_next;
   end

  assign tdoctrl = serialdata[0];  // LSB of Serial stage is sent to TDO


//Status Register Operations
   always_comb begin: statusdata_next_logic
      unique case({shift_en,capture_en})
        2'b00 : statusdata_next = statusdata;  // retain
        2'b01 : statusdata_next = captdata_stat;    // capture
        2'b10 : statusdata_next =   {tdi,statusdata[CMP2-1:1]}; // shifting serial data from TDI / prev. flop
               //VCS coverage off
        default : statusdata_next = {(CMP2){1'bX}};
               //VCS coverage on
      endcase
   end

   
   // serial-only shift register does NOT require any reset.
   always_ff @(posedge jtclk or negedge jpwrgood_rst_b) begin : status_shiftreg_flops
      if (jpwrgood_rst_b == 1'b0)
      statusdata <= {(CMP2){1'b0}};
      else 
      statusdata <= statusdata_next;
   end


   assign tdostat = statusdata[0];  // LSB of Serial stage is sent to TDO


// Combo logic to determine what to load into the parallel stage
   // Take the write-enable bits into account, to prevent bit fields from being updated unless
   // the corresponding write-enable bit is set.
   // Reflects hard-coding of write-enable bits and the bits that they protect.
   assign update_en_cmplim  = update_en & serialdata[1]; 
   assign update_en_control = update_en & serialdata[12]; 

   always_comb begin : paralleldata_next_logic
      //  Bits from 2 to 11 are write-enabled by update_en_control
      for( int j = 2; j <= 11; j++) begin // 10:2
         pre_data_regval[j] = update_en_control ? serialdata[j] : pdata_regval[j];
      end
      // Bits from 13 to CMP2 are write-enabled by update_en_cmplim
      for( int j = 13; j <= (CMP2-1) ; j++) begin // CMP2-1 :13
         pre_data_regval[j] = update_en_cmplim ? serialdata[j] : pdata_regval[j];
      end
      //Bits 1 and 12 are not write-enabled . They are control bits. Bit 0 is reserved
         pre_data_regval[1]  = update_en ? serialdata[1] : pdata_regval[1];
         pre_data_regval[12] = update_en ? serialdata[12] : pdata_regval[12];
         pre_data_regval[0]  = update_en ? serialdata[0] : pdata_regval[0];

// pre_data_regval[0]  = 1'b0;

   end


   // Update Parallel register stage register on the falling edge of jtclk
   // with the appropriate data. This is the parallel output stage. 
   always_ff @(negedge jtclk or negedge jpwrgood_rst_b) begin : parallel_stage_flops
      if (jpwrgood_rst_b == 1'b0)
        pdata_regval <= {(CMP2){1'b0}};
        //pdata_regval <= {(WIDTH){1'b0}};
      else
        pdata_regval <= pre_data_regval;
   end
  
  
    assign cmplim_we = update_en_cmplim ;
    assign ctrl_bits_we = update_en_control; 
   
   //assign swcomp_pregdata = pdata_regval; // send out all but write-enables
   // ------------------------------
   // SWCOMP test data register bits
   // ------------------------------
   always_comb begin: tdr_assignments
     
     cmplim_hi[STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]               = pdata_regval[CMP2-1:CMP1];
     cmplim_lo[STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]               = pdata_regval[CMP1-1:CMP0] ;
     cmplim_mask[STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]             = pdata_regval[CMP0-1:13] ;
    // cmplim_we                                                  = pdata_regval[12];
     nc_cmp_rsvd_1                                                = pdata_regval[11]; // no-connect / unused /reserved bits
     cmpsel_signed                                                = pdata_regval[10];
     cmpsel_sgnmag                                                = pdata_regval[9];
     cmpen_blk_multi_fail                                         = pdata_regval[8];
     cmp_mirror_sel                                               = pdata_regval[7];
     cmp_tdo_sel                                                  = pdata_regval[6];
     cmp_tdo_forcelo                                              = pdata_regval[5];
     cmpen_main                                                   = pdata_regval[4];
     cmpen_le_limhi                                               = pdata_regval[3];
     cmpen_ge_limlo                                               = pdata_regval[2];
   //  ctrl_bits_we                                               = pdata_regval[1];
     nc_cmp_rsvd_0                                                = pdata_regval[0]; // no-connect / unused /reserved bits

  //Capturing Control Register values

    captdata_ctrl [CMP2-1 : 0]                                    = pdata_regval[CMP2-1 :0];

  //Capturing Status Register Values

    captdata_stat[CMP2-1:13]                                      = pdata_regval[CMP2-1:13];
    captdata_stat[12]                                             = cmplim_we;    
    captdata_stat[11:4]                                           = cmp_firstfail_cnt[7:0];
    captdata_stat[3]                                              = cmp_sticky_fail_hi;
    captdata_stat[2]                                              = cmp_sticky_fail_lo;
    captdata_stat[1]                                              = ctrl_bits_we ;
    captdata_stat[0]                                              = nc_cmp_rsvd_0 ;
    
   end

endmodule : stap_tapswcompreg
