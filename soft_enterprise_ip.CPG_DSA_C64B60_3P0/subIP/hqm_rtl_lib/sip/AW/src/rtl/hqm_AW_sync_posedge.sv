//-----------------------------------------------------------------------------------------------------
// AW_sync_posedge
//
// This module is responsible for synchronizing a signal through 2 stages of flipflops.
// This version includes an asynchronous reset input.
//
// The following parameters are supported:
//
//      WIDTH           Width of the datapath that is synchronized
//      NUM_STAGES      The number of flipflop stages in the synchronizer (2-4)
//      STRENGTH        The drive strength of the gates instantiated (5=X0P5, 10=X1, 20=X2, etc.)
//      THRESH          The threshold type of the gates (R=rvt, H=hvt, S=svt, U=uvt, etc.)
//
//-----------------------------------------------------------------------------------------------------
module hqm_AW_sync_posedge #(

        parameter       WIDTH=1,
        parameter       NUM_STAGES=2,

        parameter       STRENGTH=40,
        parameter       CHWIDTH=16,
        parameter       THRESH="R"
) (
        input   wire                    clk,
        input   wire                    rst_n,
        input   wire    [WIDTH-1:0]     data,

        output  wire    [WIDTH-1:0]     data_sync
);

//-----------------------------------------------------------------------------------------------------
logic     [WIDTH-1:0]     sync_q[1:0];

genvar                  g;
generate
 for (g=0; g<2; g=g+1) begin: g_stage

  always_ff @(posedge clk or negedge rst_n) begin: L000
   if (!rst_n) begin
    sync_q[g] <= {WIDTH{1'b0}};
   end else begin
    sync_q[g] <= (g==0) ? data : sync_q[g-1];
   end
  end

 end
endgenerate

assign data_sync = sync_q[1];

endmodule // AW_sync_posedge

