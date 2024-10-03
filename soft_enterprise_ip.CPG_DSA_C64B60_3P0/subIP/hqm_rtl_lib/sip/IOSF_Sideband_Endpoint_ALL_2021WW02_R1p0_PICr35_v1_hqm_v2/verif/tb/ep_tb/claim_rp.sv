module claim_rp
#(
parameter WIDTH = 1,
parameter NUM_REPEATER_FLOPS = 0)
(
    tmsg_npclaim_in,
    tmsg_npclaim_out,
    clk,
    rst    

);
    
    input  logic [WIDTH:0]  tmsg_npclaim_in;
    output logic [WIDTH:0]  tmsg_npclaim_out;
    input  logic            clk;
    input  logic            rst;
     
    logic [WIDTH:0]  tmsg_npclaim_internal [NUM_REPEATER_FLOPS+1];  
    logic rst_dummy;
    
    genvar loop;
    
    assign tmsg_npclaim_internal[0] = tmsg_npclaim_in;
    assign tmsg_npclaim_out = tmsg_npclaim_internal[NUM_REPEATER_FLOPS];
    assign rst_dummy = rst;
     
    generate
        for( loop = 0 ; loop < NUM_REPEATER_FLOPS ; loop++) begin
            always_ff@(posedge clk) begin
                tmsg_npclaim_internal [loop+1] <= tmsg_npclaim_internal [loop];
            end
        end    
    endgenerate

endmodule :claim_rp
