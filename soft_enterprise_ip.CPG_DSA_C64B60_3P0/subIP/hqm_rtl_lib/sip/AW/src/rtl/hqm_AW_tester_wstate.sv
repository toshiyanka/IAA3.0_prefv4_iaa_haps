module hqm_AW_tester_wstate ( 
  input logic clk
, input logic rst_n
, input in
, output out
); 

hqm_AW_rmw_mem_4pipe #(
 .DEPTH ( 32768 )
,.WIDTH( 144 )
) i_hqm_AW_rmw_mem_4pipe (
, .clk ( clk )
, .rst_n ( rst_n )
, .status ( )
, .p0_v_nxt ( in )
, .p0_rw_nxt ( {2{in}} )
, .p0_addr_nxt ({15{in}} )
, .p0_write_data_nxt ( {144{in}} )
, .p0_v_f ( )
, .p0_rw_f ( )
, .p0_addr_f ( )
, .p0_data_f ( )
, .p1_hold ( in )
, .p1_v_f ( )
, .p1_rw_f ( )
, .p1_addr_f ( )
, .p1_data_f ( )
, .p2_hold ( in )
, .p2_v_f ( )
, .p2_rw_f ( )
, .p2_addr_f ( )
, .p2_data_f ( )
, .p3_hold ( in )
, .p3_bypsel ( in )
, .p3_bypdata ( {144{in}} )
, .p3_v_f ( )
, .p3_rw_f ( )
, .p3_addr_f ( )
, .p3_data_f ( )
, .mem_write ( )
, .mem_write_addr ( )
, .mem_write_data ( )
, .mem_read ( )
, .mem_read_addr ( )
, .mem_read_data ( {128{in}} )
);


endmodule 
