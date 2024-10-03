// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name : hqm_ri_err_stat
// -- Author : Dannie Feekes
// -- Project Name : Cave Creek
// -- Creation Date: Tuesday April 7, 2009
// -- Description :
// -- The is the edge detection and error status register used by the
// -- error logic FUB (hqm_ri_err). Upon the rising edge of an positively
// -- asserted error signal, the error status register will be set
// -- for the respective error. The error will be asserted until a 
// -- clear error signal is asserted. The output from this module
// -- we be the error status and a pulse when the error status have
// -- been set.
// -------------------------------------------------------------------

module hqm_ri_err_stat (

    //-----------------------------------------------------------------
    // Clock and reset
    //-----------------------------------------------------------------

     input logic        prim_nonflr_clk
    ,input logic        prim_gated_rst_b    

    //-----------------------------------------------------------------
    // Inputs 
    //-----------------------------------------------------------------

    ,input logic        err_signal      // The input error signal for edge detection.
    ,input logic        clr_err         // Signal to clear the error status.
    ,input logic        err_taken       // The error signal has been taken

    //-----------------------------------------------------------------
    // Outputs
    //-----------------------------------------------------------------

    ,output logic       err_arb_mask    // Mask the error signal after it has been taken
    ,output logic       err_status      // The status of the error condition. Set on
                                        // the rising edge of the err_signal and cleared
                                        // on the assertion of clr_err
);

//------------------------------------------------------------------------

logic               err_signal_ff;      // The state of the input error signal last clock
logic               err_set;            // Signal that there is a rising edge of the err signal

//------------------------------------------------------------------------
// Error Signal Edge Detect
//------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: edge_detect_ff_p

    // In this part of the edge detect logic we will record the state of 
    // the error input signal on the last cycle.

    if (!prim_gated_rst_b)
        err_signal_ff <= 1'b0;
    else
        err_signal_ff <= err_signal;

end // always_ff edge_detect_ff_p

//------------------------------------------------------------------------
// Rising Edge Detect
//------------------------------------------------------------------------

always_comb begin: rising_edg_detect_p
    err_set = !clr_err && err_signal && !err_signal_ff;
end // rising_edg_detect_p 

//------------------------------------------------------------------------
// Error Status Register
//------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: err_status_p

    // The error status register is cleared on reset or the assertion of
    // the clr_err signal. It can only be set on the rising edge of the 
    // err_signal when clr_err is not asserted.

    if (!prim_gated_rst_b)
        err_status <= 1'b0;
    else if (clr_err)
        err_status <= 1'b0;
    else if (err_set)
        err_status <= 1'b1;
    else
        err_status <= err_status;

end // always_ff err_status_p

//------------------------------------------------------------------------
// Error Mask after Arbitration
//------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: err_mask_p

    if (!prim_gated_rst_b)
        err_arb_mask <= 1'b0;
    else if (clr_err && !err_taken) 
        err_arb_mask <= 1'b0;
    else if (err_taken)
        err_arb_mask <= 1'b1;
    else
        err_arb_mask <= err_arb_mask;

end // always_ff err_mask_p

endmodule // hqm_ri_err_stat

