
module hqm_AW_cfg_mem_rsp
import hqm_AW_pkg::*; #(
  parameter NUM_RAM = 16
) (
      input logic [ ( NUM_RAM * 32 ) - 1 : 0 ]  in_cfg_mem_rdata
    , output logic [ ( 32 ) - 1 : 0 ]           out_cfg_mem_rdata
) ;

always_comb begin:L01
  out_cfg_mem_rdata = '0 ;
  for ( int i = 0 ; i < NUM_REQS ; i = i + 1 ) begin
    out_cfg_mem_rdata = out_cfg_mem_rdata | in_cfg_mem_rdata [ ( i * 32 ) +: 32 ]
  end
end

endmodule
