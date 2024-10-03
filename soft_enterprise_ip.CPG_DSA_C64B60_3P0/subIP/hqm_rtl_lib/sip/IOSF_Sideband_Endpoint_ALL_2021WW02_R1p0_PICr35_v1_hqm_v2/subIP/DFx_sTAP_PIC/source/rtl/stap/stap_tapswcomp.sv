//  -----------------------------------------------------------------------------
//  --                      Intel Proprietary
//  --              Copyright (C) 2010 Intel Corporation
//  --                     All Rights Reserved
//  -----------------------------------------------------------------------------
//  -- Module Name  : tapswcomp
//  -- Author       : C. Koza 
//  -- Project Name : P1271 HIP TAP
//  -- Creation Date: 8/9/2010
//  -- Description  : TAP Window Shift Comparator
//
//   9/7/2010  C. Koza.
//     - Updated sdata_smto2c_se addition to use 1'b1 to avoid lintra warning.
//       (previously used 1 which is a 32-bit value).

//   9/3/2010  C. Koza  
//     - Added descriptions to input/output ports
//     - Added capability to do signed comparisons.
//     Port updates:
//     - added cmpsel_sgnmag and cmpsel_signed inputs

//   8/20/2010 C. Koza  Added cmpen_blk_multi_fail control. 
//                      Updated dig_comps mux statement to use 1'b prefix
//                      to resolve Lintra and Syn warnings.
//                      Warning:  signed to unsigned assignment occurs. (VER-318)

//   8/6/2010  C. Koza  Original version

module stap_tapswcomp 
  #(
    parameter STAP_SWCOMP_NUM_OF_COMPARE_BITS = 10
   
    )    
   (
    // TAP clock and reset.
    input logic jtclk,
    input logic jtrst_b,

    // Serial test data input from TAP test data register TDO mux
    input logic tdi,

    // TAP FSM States
    input logic test_logic_reset,
    input logic capture_dr,
    input logic shift_dr,
    input logic exit2_dr,

    // TAP instruction=SWCOMP
    input logic tap_swcomp_active,

    // Inputs from SWCOMP test data register parallel stage:
    // -----------------------------------------------------
    // Comparator high/low limit data values
    // Hi(lo) Sets upper (lower) limit for serial shift register comparator 
    // when performing signed comparison (cmpsel_signed=1), software must 
    // sign-extend limits written in this field.
    input logic [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]    cmplim_hi,
    input logic [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]    cmplim_lo,

    // Comparator data masking (also serves as bits to specify sign_bit position)
    // when cmpsel_signed=0
    // Sets mask bits for serial shift register comparator.  Setting
    // bit(s) forces corresponding bit(s) in serial shift register
    // (after any mirroring that may be enabled if cmp_mirror_sel=1)
    // to be set to zero during comparison. User must consider effect
    // of zeroing on comparison results.
    // when cmpsel_signed=1:
    // bits [3:0] Sets the bit position of the sign bit for signed
    // comparison. Bits above this bit are sign-extended prior to
    // comparison.  
    // bits [9:4] These bits must be set low by software
    input logic [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]    cmplim_mask,

    // 1: Reverses the LSB/MSB direction of the result before masking and comparison  
    // 0: LSB/MSB are not reversed
    input logic                 cmp_mirror_sel,

    // 1: enables connection of the LSB of serial shift comparator window to 
    //    the TDO for non-SWCOMP TDR scans.
    // 0: LSB of serial shift comparator window is not stitched between TDI 
    //    and TDO (TDI is always passed directly to TDO)
    input logic                 cmp_tdo_sel,

    // 1: Enables forcing TDO low for non-SWCOMP TDR scans.
    // 0: TDO is not forced low
    input logic                 cmp_tdo_forcelo,

    // main comparator enable, enable shifting of comparator window and
    // enables comparator sticky fail flops / counter.
    input logic                 cmpen_main,

    // 1: select signed comparison (refer to cmpsel_sngmag also). 
    // 0: select unsigned comparison
    input logic                 cmpsel_signed,

    // 1=select signed magnitude; 0=2's complement (applies if cmpsel_signed=1)
    input logic                 cmpsel_sgnmag,

    // 1: Enables comparison of RSLT<=LIMHI. If cmpen_main=1, qualified 
    //    (mirrored, if applicable and nonmasked), result bits are
    //    compared to be less than or equal to cmplim_hi during
    //    Exit2-DR TAP state, and fail sets cmp_sticky_fail_hi.
    // 0:  Disable comparison of <=LIMHI
    input logic                 cmpen_le_limhi,

    // 1: Enables comparison of RSLT>=LIMLO. If cmpen_main=1, qualified 
    //    (mirrored, if applicable and nonmasked), result bits are
    //    compared to be greater than or equal to cmplim_lo during
    //    Exit2-DR TAP state, and fail sets cmp_sticky_fail_lo.
    // 0:  Disable comparison of <=LIMLO
    input logic                 cmpen_ge_limlo,

    // 1: Block comparator from storing multiple failures; after a 
    //    failure is stored in a sticky flop, sticky flops will not
    //    record any additional failures
    // 0: No blocking; sticky fail flops remain enabled to capture 
    //    additional failures 
    //    even after failure already detected.
   input logic                 cmpen_blk_multi_fail,

    // cmp_* outputs to capture into SWCOMP test data register:
    // --------------------------------------------------------

    // Fail count:
    // If a fail is detected, the cmp_firstfail_cnt[7:0] provides 
    // the count of the first fail (starting from zero). 
    // If no fails are detected, the count value equals the 
    // number of tests performed.
    // Count is incremented during Exit2_DR state if cmpen_main=1 and
    // no fail is present.  Counting is blocked once either
    // sticky_fail is set.  
    // Note: The captured values of all cmp_firstfail_cnt bits
    // self-clear during Exit2_DR state when SWCOMP instruction is
    // active.
    output logic [7:0]   cmp_firstfail_cnt,

    // 1: Indicates a failure was detected in the comparison of RSLT<=LIMHI.
    // 0: No fail was detected in the comparison of RSLT<=LIMHI. 
    //    Note: The captured value of this bit self-clears during 
    //    Exit2_DR state when SWCOMP instruction is active.
    output logic                cmp_sticky_fail_hi,


    // 1: Indicates a failure was detected in the comparison of RSLT ? LIMLO. 
    // 0: No fail was detected in the comparison of RSLT ? LIMLO. 
    //    Note: The captured value of this bit self-clears during 
    //    Exit2_DR state when SWCOMP instruction is active.
    output logic                cmp_sticky_fail_lo,

    // serial test data output, to the input of the TAP IR mux:
    output logic tdo
  );

   // value captured into serial comparator window flops
   // This sets a unique pattern that is visible on TDO upon shift-out
   // for debug if cmp_tdo_sel=1.
   parameter [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0] SERIAL_CAPTURE_VALUE = 10'b0111011010; 
 
   localparam CMP0 = (STAP_SWCOMP_NUM_OF_COMPARE_BITS -5) +18 ;
   localparam CMP1 = STAP_SWCOMP_NUM_OF_COMPARE_BITS + CMP0;
   localparam CMP2 = STAP_SWCOMP_NUM_OF_COMPARE_BITS + CMP1;
   
   logic                                                       tdi_tdo_direct;
   logic                                                       tdo_pregate;
   logic                                                       capture_en;
   logic                                                       shift_en;
   logic [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]                 serialdata_next;
   logic [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]                 serial_windowreg;
   logic [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]                 rslt_data;
   logic [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]                 rslt_data_qualified;
   logic                                                       rslt_le_limhi;
   logic                                                       rslt_ge_limlo;
   logic                                                       fail_limhi;
   logic                                                       fail_limlo;
   logic                                                       cmp_reset;
   logic                                                       cmp_enable;
   logic                                                       ctr_load0;
   logic                                                       ctr_enable;

   logic [3:0]                                                 cmpsel_sign_bit; // specify position of sign, when cmpsel_signed=1
   logic                                                       sign_bit_is1;
   
   // for signed-magnitude to 2s complement conversion:
   logic                                                       mag_is0;
   logic signed [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]          sdata_sm;         // signed-magnitude value
   logic signed [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]          sdata_smto2c_se;  // 2's complement value
         
   // for sign extension of 2s complement data
   logic signed [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]          sdata_2c;         // 2's comp 
   logic signed [STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:0]          sdata_2c_se;      // 2's comp sign extended
   
   // 2's complement signed comparator that is 1 bit wider so sign bit will be above the normal MSB
   // (This allows 11-bit signed comparator be used for 10-bit unsigned data.)
   logic signed [STAP_SWCOMP_NUM_OF_COMPARE_BITS:0]            scomp_limit_hi;
   logic signed [STAP_SWCOMP_NUM_OF_COMPARE_BITS:0]            scomp_limit_lo;
   logic signed [STAP_SWCOMP_NUM_OF_COMPARE_BITS:0]            scomp_data_in;

   // --------------------------
   // TDI/TDO data path / muxing
   // --------------------------
   // Based on TAP register controls cmp_tdo_sel and cmp_tdo_forcelo.
   // If not using the SWCOMP Instruction, then allow stitching in the 
   // comparator window between TDI and TDO, and force TDO low if so directed.
   // Otherwise, always bypass the window and just send TDI directly out without gating.
   // (do not interfere with TDO if TAP IR contains SWCOMP, to allow shifting those TDRs)
   assign tdi_tdo_direct = tap_swcomp_active;
   assign tdo_pregate    = ( cmp_tdo_sel     & !tdi_tdo_direct ) ? serial_windowreg[0] : tdi;
   assign tdo            = (!cmp_tdo_forcelo |  tdi_tdo_direct ) & tdo_pregate;

   // -----------------------------------------------
   // serial shift register stage (comparator window)
   // -----------------------------------------------
   // Results to be checked will be shifted through this window during Shift-DR
   // when comparator is enabled.

   // Create gated versions of capture and shift which
   // are asserted only when enabled
   assign capture_en = capture_dr & (cmpen_main | cmp_tdo_sel);
   assign shift_en = shift_dr & (cmpen_main | cmp_tdo_sel);
   
   always_comb begin: serialdata_next_muxes
      unique case({shift_en,capture_en})
        2'b00 : serialdata_next = serial_windowreg;
        2'b01 : serialdata_next = SERIAL_CAPTURE_VALUE;
        2'b10 : serialdata_next = {tdi,serial_windowreg[STAP_SWCOMP_NUM_OF_COMPARE_BITS-1:1]}; // shifting serial data from TDI / prev. flop
        //VCS coverage off
        default : serialdata_next = {(STAP_SWCOMP_NUM_OF_COMPARE_BITS){1'bx}};
        //VCS coverage on
      endcase
   end
   
   always_ff @(posedge jtclk or negedge jtrst_b) begin : serial_windowreg_flops
     if (jtrst_b == 1'b0) begin
        serial_windowreg <=1'b0; end
        else begin 
      serial_windowreg <= serialdata_next;
   end
   end

   
   // ------------------------------------
   // Mirroring-muxes and unsigned masking
   // ------------------------------------
   // Muxes to determine whether result data to be compared is mirrored or not e.g. 
   // whether LSB to comparator comes from LSB or MSB of serial window register,
   // For unsigned comparison, generate rslt_data_qualified with all masked bits set low.
   always_comb begin: rsltdata_combo
      for( int j = 0; j < STAP_SWCOMP_NUM_OF_COMPARE_BITS; j++) begin
         rslt_data[j] = cmp_mirror_sel ? serial_windowreg[STAP_SWCOMP_NUM_OF_COMPARE_BITS-1-j] : serial_windowreg[j];
         rslt_data_qualified[j] = (!cmplim_mask[j]) & rslt_data[j]; 
      end
   end


   // ----------------------------------------
   // Sign-bit position and check for negative
   // ----------------------------------------
   // For signed comparisions, the sign bit position is pulled off of lower 4 bits of
   // cmplim_mask input and identifies the bit position of the sign-bit for signed
   // comparison.  Sharing these bits avoids need for additional TDR bits (bit masking is
   // not expected to be required during signed comparison)
   assign cmpsel_sign_bit[3:0] = cmplim_mask[3:0];

   // determine if Sign bit is one
   assign sign_bit_is1         = ( (rslt_data>>cmpsel_sign_bit) & 1'b1) == 1'b1; 
    

   // ------------------------------------
   // Sign-extension of 2s complement data
   // ------------------------------------
   // This converts 2's complement sdata_2c to sign-extended 2's complement data sdata_2c_se.
   // Values must sign-extended to preserve sign prior to comparison (when comparator is wider than data)
   always_comb begin : se_2c

      sdata_2c = $signed(rslt_data); // take data off mirror muxes and treat it as 2's complement
      //sign_bit_is1         = ( (sdata_2c>>cmpsel_sign_bit) & 1'b1) == 1'b1; 

      case (sign_bit_is1)        

        // Positive numbers: (Sign bit is zero) 
        // Zero-out bits above Sign-bit
        1'b0:   sdata_2c_se = $signed(sdata_2c & ~({STAP_SWCOMP_NUM_OF_COMPARE_BITS{1'b1}}<<cmpsel_sign_bit)); 

        // Negative numbers. (Sign bit is set)
        // sign-extend to MSB
        1'b1:   sdata_2c_se = $signed(sdata_2c |  ({STAP_SWCOMP_NUM_OF_COMPARE_BITS{1'b1}}<<cmpsel_sign_bit)); 

        //VCS coverage off
        default: sdata_2c_se = $signed({STAP_SWCOMP_NUM_OF_COMPARE_BITS{1'bx}});
        //VCS coverage on
      endcase 
      
   end : se_2c


   // --------------------------------------------
   // Signed-magnitude to 2s complement conversion
   // --------------------------------------------   
   // convert sdata_sm (signed-magnitude) to sdata_smto2c_se (sign-extended 2's complement)
   // so that is can be successfully compared in the 2's complement comparator.
   // both data values are signed.
   always_comb begin : sm2c_conv

      sdata_sm = $signed(rslt_data); // take data off mirror muxes and treat it as signed-magnitude

      //sm_sign_bit_is1 = ( (sdata_sm>>cmpsel_sign_bit) & 1'b1) == 1'b1;       // determine if Sign bit is one

      // Determine if magnitude is zero, to flag special case of -0. 
      // mask off bits above and including cmpsel_sign_bit position 
      mag_is0 = ( ($unsigned(sdata_sm) & ~({STAP_SWCOMP_NUM_OF_COMPARE_BITS{1'b1}}<<cmpsel_sign_bit) ) == {STAP_SWCOMP_NUM_OF_COMPARE_BITS{1'b0}} ) ;

      casez ({mag_is0, sign_bit_is1})        

        // zero or negative-zero; special case to handle 'negative 0' which does not exist in 2s comp 
        2'b1?:   sdata_smto2c_se = 0;  // (-0 -> 0)

        // Positive numbers: (Sign bit is zero) 
        // Zero-out bits above Sign-bit
        2'b00:   sdata_smto2c_se = $signed(sdata_sm & ~({STAP_SWCOMP_NUM_OF_COMPARE_BITS{1'b1}}<<cmpsel_sign_bit)); 

        // Negative numbers. (Sign bit is set)
        // for bits below Sign bit: flip all bits and add 1, 
        // and set sign bit & sign-extend to MSB
        2'b01:   sdata_smto2c_se = $signed((~sdata_sm+1'b1) |  ({STAP_SWCOMP_NUM_OF_COMPARE_BITS{1'b1}}<<cmpsel_sign_bit)); 

        //VCS coverage off
        default: sdata_smto2c_se = $signed({STAP_SWCOMP_NUM_OF_COMPARE_BITS{1'bx}});
        //VCS coverage on

      endcase 
      
   end : sm2c_conv


   // --------------------------------------------
   // Set up limits and select data to be compared
   // --------------------------------------------
   always_comb begin : set_scomp_data

      // set signed limits to be compared
      // if unsigned, set MSB of comparator data/limit to be 0, otherwise, pull MSB (sign bit) from MSB of data/limit
      scomp_limit_hi = $signed(cmpsel_signed ? {cmplim_hi[STAP_SWCOMP_NUM_OF_COMPARE_BITS-1],cmplim_hi} : {1'b0,cmplim_hi});
      scomp_limit_lo = $signed(cmpsel_signed ? {cmplim_lo[STAP_SWCOMP_NUM_OF_COMPARE_BITS-1],cmplim_lo} : {1'b0,cmplim_lo});
      
      // setup signed data to be compared:
      casez ({cmpsel_signed, cmpsel_sgnmag})        
        // If unsigned, pull from qualified data as-is, with sign bit zeroed
        2'b0?:   scomp_data_in = $signed({1'b0,rslt_data_qualified});  

        // If signed 2's complement, sign extend from sign_bit into the comparator's sign bit
        2'b10:   scomp_data_in = $signed({sdata_2c_se[STAP_SWCOMP_NUM_OF_COMPARE_BITS-1],sdata_2c_se});

        // if signed magnitude, use value converted to 2s complement and sign-extended
        2'b11:   scomp_data_in = $signed({sdata_smto2c_se[STAP_SWCOMP_NUM_OF_COMPARE_BITS-1],sdata_smto2c_se});

        //VCS coverage off
        default: scomp_data_in = $signed({(STAP_SWCOMP_NUM_OF_COMPARE_BITS+1){1'bx}});
        //VCS coverage on
      endcase 
      
   end : set_scomp_data
   
   
   // -------------------------------------------
   // Digital comparators (signed 2's complement)
   // -------------------------------------------
   // note that comparator width is one more than data width, to allow for sign bit.
   always_comb begin : dig_comps
      rslt_ge_limlo = (scomp_data_in >= scomp_limit_lo) ? 1'b1 : 1'b0;
      rslt_le_limhi = (scomp_data_in <= scomp_limit_hi) ? 1'b1 : 1'b0;
   end : dig_comps


   // -----------------------------------------
   // Comparator fail results and control logic
   // -----------------------------------------
   always_comb begin : misc_logic
      // generate fail results if enabled:
      fail_limhi = cmpen_le_limhi & (!rslt_le_limhi);
      fail_limlo = cmpen_ge_limlo & (!rslt_ge_limlo);

      // condition to reset sticky-fail flops (and counter)
      cmp_reset = (tap_swcomp_active & exit2_dr) | test_logic_reset;
      
      // Enable to comparator sticky flops:
      // Always enable during cmp_reset condition. 
      // Enable when cmpen_main=1 during Exit2-DR state, but disable to block multiple
      // fails if cmpen_blk_multi_fail is set, when fail has already been detected.
      cmp_enable = cmp_reset | 
                   ( 
                     (cmpen_main & exit2_dr) &
                     ( !cmpen_blk_multi_fail | !(cmp_sticky_fail_lo | cmp_sticky_fail_hi) )
                   );      
   end
   

   // -----------------
   // Sticky-fail flops
   // -----------------
   always_ff @(posedge jtclk or negedge jtrst_b) begin : sticky_fail_flops
      if (jtrst_b == 1'b0) begin
         cmp_sticky_fail_hi <= 1'b0;
         cmp_sticky_fail_lo <= 1'b0;
      end
      else begin
         cmp_sticky_fail_hi <= cmp_enable ? ( (fail_limhi | cmp_sticky_fail_hi) & (!cmp_reset) ) : cmp_sticky_fail_hi; //Edited by badithya
         cmp_sticky_fail_lo <= cmp_enable ? ( (fail_limlo | cmp_sticky_fail_lo) & (!cmp_reset) ) : cmp_sticky_fail_lo; //Edited by badithya
      end
   end
 

   // -----------------
   // Counter
   // -----------------
   assign ctr_load0 = cmp_reset;
   // Stop counting if fail is currently detected or if sticky fail was set
   // so that counter records the first fail (count starting from 0)
   assign ctr_enable = (cmpen_main & exit2_dr) & !(fail_limlo | fail_limhi) & !(cmp_sticky_fail_lo | cmp_sticky_fail_hi);
   
   always_ff @(posedge jtclk or negedge jtrst_b) begin : fail_counter
      if (jtrst_b == 1'b0) 
        cmp_firstfail_cnt <= {8{1'b0}};
      else begin
         casez ({ctr_load0, ctr_enable})
           2'b1?:   cmp_firstfail_cnt <= {8{1'b0}};
           2'b00:   cmp_firstfail_cnt <= cmp_firstfail_cnt;
           2'b01:   cmp_firstfail_cnt <= cmp_firstfail_cnt + 1;
           //VCS coverage off
           default: cmp_firstfail_cnt <= {8{1'bx}};
           //VCS coverage on
         endcase 
      end
   end
   
endmodule : stap_tapswcomp
