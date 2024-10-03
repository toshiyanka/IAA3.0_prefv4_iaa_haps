module hqm_AW_tester ( 
  input logic clk
, input logic rst_n
, input in
, output out
); 




logic [(32)-1:0] add_A_32_n, add_A_32_f ;
logic [(32)-1:0] add_B_32_n, add_B_32_f ;
logic [(32)-1:0] add_Z_32_n, add_Z_32_f ;
always_ff @(posedge clk or negedge rst_n) begin
 if ( rst_n == 1'd0 ) begin   
 add_A_32_f <= 0 ;
 add_B_32_f <= 0 ;
 add_Z_32_f <= 0 ;
 end else begin 
 add_A_32_f <= {32{in}};
 add_B_32_f <= {32{in}};
 add_Z_32_f <= add_Z_32_n ;
 end
end 
always_comb begin
add_Z_32_n = add_A_32_f + add_B_32_f ;
end

logic [(64)-1:0] add_A_64_n, add_A_64_f ;
logic [(64)-1:0] add_B_64_n, add_B_64_f ;
logic [(64)-1:0] add_Z_64_n, add_Z_64_f ; 
always_ff @(posedge clk or negedge rst_n) begin
 if ( rst_n == 1'd0 ) begin
 add_A_64_f <= 0 ;
 add_B_64_f <= 0 ;
 add_Z_64_f <= 0 ;
 end else begin 
 add_A_64_f <= {64{in}};
 add_B_64_f <= {64{in}};
 add_Z_64_f <= add_Z_64_n ;
 end
end 
always_comb begin
add_Z_64_n = add_A_64_f + add_B_64_f ;
end

logic [(96)-1:0] add_A_96_n, add_A_96_f ;
logic [(96)-1:0] add_B_96_n, add_B_96_f ;
logic [(96)-1:0] add_Z_96_n, add_Z_96_f ; 
always_ff @(posedge clk or negedge rst_n) begin
 if ( rst_n == 1'd0 ) begin
 add_A_96_f <= 0 ;
 add_B_96_f <= 0 ;
 add_Z_96_f <= 0 ;
 end else begin 
 add_A_96_f <= {96{in}};
 add_B_96_f <= {96{in}};
 add_Z_96_f <= add_Z_96_n ;
 end
end 
always_comb begin
add_Z_96_n = add_A_96_f + add_B_96_f ;
end

logic [(128)-1:0] add_A_128_n, add_A_128_f ;
logic [(128)-1:0] add_B_128_n, add_B_128_f ;
logic [(128)-1:0] add_Z_128_n, add_Z_128_f ; 
always_ff @(posedge clk or negedge rst_n) begin
 if ( rst_n == 1'd0 ) begin
 add_A_128_f <= 0 ;
 add_B_128_f <= 0 ;
 add_Z_128_f <= 0 ;
 end else begin 
 add_A_128_f <= {128{in}};
 add_B_128_f <= {128{in}};
 add_Z_128_f <= add_Z_128_n ;
 end
end 
always_comb begin
add_Z_128_n = add_A_128_f + add_B_128_f ;
end




logic [(32)-1:0] sub_A_32_n, sub_A_32_f ;
logic [(32)-1:0] sub_B_32_n, sub_B_32_f ;
logic [(32)-1:0] sub_Z_32_n, sub_Z_32_f ;
always_ff @(posedge clk or negedge rst_n) begin
 if ( rst_n == 1'd0 ) begin   
 sub_A_32_f <= 0 ;
 sub_B_32_f <= 0 ;
 sub_Z_32_f <= 0 ;
 end else begin 
 sub_A_32_f <= {32{in}};
 sub_B_32_f <= {32{in}};
 sub_Z_32_f <= sub_Z_32_n ;
 end
end 
always_comb begin
sub_Z_32_n = sub_A_32_f - sub_B_32_f ;
end

logic [(64)-1:0] sub_A_64_n, sub_A_64_f ;
logic [(64)-1:0] sub_B_64_n, sub_B_64_f ;
logic [(64)-1:0] sub_Z_64_n, sub_Z_64_f ; 
always_ff @(posedge clk or negedge rst_n) begin
 if ( rst_n == 1'd0 ) begin
 sub_A_64_f <= 0 ;
 sub_B_64_f <= 0 ;
 sub_Z_64_f <= 0 ;
 end else begin 
 sub_A_64_f <= {64{in}};
 sub_B_64_f <= {64{in}};
 sub_Z_64_f <= sub_Z_64_n ;
 end
end 
always_comb begin
sub_Z_64_n = sub_A_64_f - sub_B_64_f ;
end

logic [(96)-1:0] sub_A_96_n, sub_A_96_f ;
logic [(96)-1:0] sub_B_96_n, sub_B_96_f ;
logic [(96)-1:0] sub_Z_96_n, sub_Z_96_f ; 
always_ff @(posedge clk or negedge rst_n) begin
 if ( rst_n == 1'd0 ) begin
 sub_A_96_f <= 0 ;
 sub_B_96_f <= 0 ;
 sub_Z_96_f <= 0 ;
 end else begin 
 sub_A_96_f <= {96{in}};
 sub_B_96_f <= {96{in}};
 sub_Z_96_f <= sub_Z_96_n ;
 end
end 
always_comb begin
sub_Z_96_n = sub_A_96_f - sub_B_96_f ;
end

logic [(128)-1:0] sub_A_128_n, sub_A_128_f ;
logic [(128)-1:0] sub_B_128_n, sub_B_128_f ;
logic [(128)-1:0] sub_Z_128_n, sub_Z_128_f ; 
always_ff @(posedge clk or negedge rst_n) begin
 if ( rst_n == 1'd0 ) begin
 sub_A_128_f <= 0 ;
 sub_B_128_f <= 0 ;
 sub_Z_128_f <= 0 ;
 end else begin 
 sub_A_128_f <= {128{in}};
 sub_B_128_f <= {128{in}};
 sub_Z_128_f <= sub_Z_128_n ;
 end
end 
always_comb begin
sub_Z_128_n = sub_A_128_f - sub_B_128_f ;
end






logic [( 11 ) -1 : 0] hqm_AW_ecc_check_din_5_n ,hqm_AW_ecc_check_din_5_f ; 
logic [( 5 ) -1 : 0] hqm_AW_ecc_check_ecc_5_n ,hqm_AW_ecc_check_ecc_5_f ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_enable_5_n ,hqm_AW_ecc_check_enable_5_f ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_correct_5_n ,hqm_AW_ecc_check_correct_5_f ; 
logic [( 11 ) -1 : 0] hqm_AW_ecc_check_dout_5 ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_error_sb_5 ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_error_mb_5 ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_ecc_check_din_5_f  <= 0 ; 
 hqm_AW_ecc_check_ecc_5_f  <= 0 ; 
 hqm_AW_ecc_check_enable_5_f  <= 0 ; 
 hqm_AW_ecc_check_correct_5_f  <= 0 ; 
 end else begin 
 hqm_AW_ecc_check_din_5_f  <= hqm_AW_ecc_check_din_5_n ; 
 hqm_AW_ecc_check_ecc_5_f  <= hqm_AW_ecc_check_ecc_5_n ; 
 hqm_AW_ecc_check_enable_5_f  <= hqm_AW_ecc_check_enable_5_n ; 
 hqm_AW_ecc_check_correct_5_f  <= hqm_AW_ecc_check_correct_5_n ; 
 end 
end 
hqm_AW_ecc_check #( 
 .DATA_WIDTH(11) 
,.ECC_WIDTH(5) 
) i_hqm_AW_ecc_check_5 ( 
 .din_v ( hqm_AW_ecc_check_enable_5_f ) 
,.din ( hqm_AW_ecc_check_din_5_f) 
,.ecc ( hqm_AW_ecc_check_ecc_5_f) 
,.enable ( hqm_AW_ecc_check_enable_5_f) 
,.correct ( hqm_AW_ecc_check_correct_5_f) 
,.dout ( hqm_AW_ecc_check_dout_5 ) 
,.error_sb ( hqm_AW_ecc_check_error_sb_5 ) 
,.error_mb ( hqm_AW_ecc_check_error_mb_5 ) 
); 
assign hqm_AW_ecc_check_din_5_n = hqm_AW_ecc_check_dout_5 ; 
assign hqm_AW_ecc_check_ecc_5_n = {{3{1'b0}} , hqm_AW_ecc_check_error_sb_5 , hqm_AW_ecc_check_error_mb_5 } ; 
assign hqm_AW_ecc_check_enable_5_n = 1'd1 ; 
assign hqm_AW_ecc_check_correct_5_n = 1'd1 ; 

logic [( 26 ) -1 : 0] hqm_AW_ecc_check_din_6_n ,hqm_AW_ecc_check_din_6_f ; 
logic [( 6 ) -1 : 0] hqm_AW_ecc_check_ecc_6_n ,hqm_AW_ecc_check_ecc_6_f ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_enable_6_n ,hqm_AW_ecc_check_enable_6_f ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_correct_6_n ,hqm_AW_ecc_check_correct_6_f ; 
logic [( 26 ) -1 : 0] hqm_AW_ecc_check_dout_6 ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_error_sb_6 ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_error_mb_6 ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_ecc_check_din_6_f  <= 0 ; 
 hqm_AW_ecc_check_ecc_6_f  <= 0 ; 
 hqm_AW_ecc_check_enable_6_f  <= 0 ; 
 hqm_AW_ecc_check_correct_6_f  <= 0 ; 
 end else begin 
 hqm_AW_ecc_check_din_6_f  <= hqm_AW_ecc_check_din_6_n ; 
 hqm_AW_ecc_check_ecc_6_f  <= hqm_AW_ecc_check_ecc_6_n ; 
 hqm_AW_ecc_check_enable_6_f  <= hqm_AW_ecc_check_enable_6_n ; 
 hqm_AW_ecc_check_correct_6_f  <= hqm_AW_ecc_check_correct_6_n ; 
 end 
end 
hqm_AW_ecc_check #( 
 .DATA_WIDTH(26) 
,.ECC_WIDTH(6) 
) i_hqm_AW_ecc_check_6 ( 
 .din_v ( hqm_AW_ecc_check_enable_6_f ) 
,.din ( hqm_AW_ecc_check_din_6_f) 
,.ecc ( hqm_AW_ecc_check_ecc_6_f) 
,.enable ( hqm_AW_ecc_check_enable_6_f) 
,.correct ( hqm_AW_ecc_check_correct_6_f) 
,.dout ( hqm_AW_ecc_check_dout_6 ) 
,.error_sb ( hqm_AW_ecc_check_error_sb_6 ) 
,.error_mb ( hqm_AW_ecc_check_error_mb_6 ) 
); 
assign hqm_AW_ecc_check_din_6_n = hqm_AW_ecc_check_dout_6 ; 
assign hqm_AW_ecc_check_ecc_6_n = {{4{1'b0}} , hqm_AW_ecc_check_error_sb_6 , hqm_AW_ecc_check_error_mb_6 } ; 
assign hqm_AW_ecc_check_enable_6_n = 1'd1 ; 
assign hqm_AW_ecc_check_correct_6_n = 1'd1 ; 

logic [( 57 ) -1 : 0] hqm_AW_ecc_check_din_7_n ,hqm_AW_ecc_check_din_7_f ; 
logic [( 7 ) -1 : 0] hqm_AW_ecc_check_ecc_7_n ,hqm_AW_ecc_check_ecc_7_f ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_enable_7_n ,hqm_AW_ecc_check_enable_7_f ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_correct_7_n ,hqm_AW_ecc_check_correct_7_f ; 
logic [( 57 ) -1 : 0] hqm_AW_ecc_check_dout_7 ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_error_sb_7 ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_error_mb_7 ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_ecc_check_din_7_f  <= 0 ; 
 hqm_AW_ecc_check_ecc_7_f  <= 0 ; 
 hqm_AW_ecc_check_enable_7_f  <= 0 ; 
 hqm_AW_ecc_check_correct_7_f  <= 0 ; 
 end else begin 
 hqm_AW_ecc_check_din_7_f  <= hqm_AW_ecc_check_din_7_n ; 
 hqm_AW_ecc_check_ecc_7_f  <= hqm_AW_ecc_check_ecc_7_n ; 
 hqm_AW_ecc_check_enable_7_f  <= hqm_AW_ecc_check_enable_7_n ; 
 hqm_AW_ecc_check_correct_7_f  <= hqm_AW_ecc_check_correct_7_n ; 
 end 
end 
hqm_AW_ecc_check #( 
 .DATA_WIDTH(57) 
,.ECC_WIDTH(7) 
) i_hqm_AW_ecc_check_7 ( 
 .din_v ( hqm_AW_ecc_check_enable_7_f ) 
,.din ( hqm_AW_ecc_check_din_7_f) 
,.ecc ( hqm_AW_ecc_check_ecc_7_f) 
,.enable ( hqm_AW_ecc_check_enable_7_f) 
,.correct ( hqm_AW_ecc_check_correct_7_f) 
,.dout ( hqm_AW_ecc_check_dout_7 ) 
,.error_sb ( hqm_AW_ecc_check_error_sb_7 ) 
,.error_mb ( hqm_AW_ecc_check_error_mb_7 ) 
); 
assign hqm_AW_ecc_check_din_7_n = hqm_AW_ecc_check_dout_7 ; 
assign hqm_AW_ecc_check_ecc_7_n = {{5{1'b0}} , hqm_AW_ecc_check_error_sb_7 , hqm_AW_ecc_check_error_mb_7 } ; 
assign hqm_AW_ecc_check_enable_7_n = 1'd1 ; 
assign hqm_AW_ecc_check_correct_7_n = 1'd1 ; 

logic [( 120 ) -1 : 0] hqm_AW_ecc_check_din_8_n ,hqm_AW_ecc_check_din_8_f ; 
logic [( 8 ) -1 : 0] hqm_AW_ecc_check_ecc_8_n ,hqm_AW_ecc_check_ecc_8_f ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_enable_8_n ,hqm_AW_ecc_check_enable_8_f ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_correct_8_n ,hqm_AW_ecc_check_correct_8_f ; 
logic [( 120 ) -1 : 0] hqm_AW_ecc_check_dout_8 ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_error_sb_8 ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_error_mb_8 ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_ecc_check_din_8_f  <= 0 ; 
 hqm_AW_ecc_check_ecc_8_f  <= 0 ; 
 hqm_AW_ecc_check_enable_8_f  <= 0 ; 
 hqm_AW_ecc_check_correct_8_f  <= 0 ; 
 end else begin 
 hqm_AW_ecc_check_din_8_f  <= hqm_AW_ecc_check_din_8_n ; 
 hqm_AW_ecc_check_ecc_8_f  <= hqm_AW_ecc_check_ecc_8_n ; 
 hqm_AW_ecc_check_enable_8_f  <= hqm_AW_ecc_check_enable_8_n ; 
 hqm_AW_ecc_check_correct_8_f  <= hqm_AW_ecc_check_correct_8_n ; 
 end 
end 
hqm_AW_ecc_check #( 
 .DATA_WIDTH(120) 
,.ECC_WIDTH(8) 
) i_hqm_AW_ecc_check_8 ( 
 .din_v ( hqm_AW_ecc_check_enable_8_f ) 
,.din ( hqm_AW_ecc_check_din_8_f) 
,.ecc ( hqm_AW_ecc_check_ecc_8_f) 
,.enable ( hqm_AW_ecc_check_enable_8_f) 
,.correct ( hqm_AW_ecc_check_correct_8_f) 
,.dout ( hqm_AW_ecc_check_dout_8 ) 
,.error_sb ( hqm_AW_ecc_check_error_sb_8 ) 
,.error_mb ( hqm_AW_ecc_check_error_mb_8 ) 
); 
assign hqm_AW_ecc_check_din_8_n = hqm_AW_ecc_check_dout_8 ; 
assign hqm_AW_ecc_check_ecc_8_n = {{6{1'b0}} , hqm_AW_ecc_check_error_sb_8 , hqm_AW_ecc_check_error_mb_8 } ; 
assign hqm_AW_ecc_check_enable_8_n = 1'd1 ; 
assign hqm_AW_ecc_check_correct_8_n = 1'd1 ; 

logic [( 247 ) -1 : 0] hqm_AW_ecc_check_din_9_n ,hqm_AW_ecc_check_din_9_f ; 
logic [( 9 ) -1 : 0] hqm_AW_ecc_check_ecc_9_n ,hqm_AW_ecc_check_ecc_9_f ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_enable_9_n ,hqm_AW_ecc_check_enable_9_f ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_correct_9_n ,hqm_AW_ecc_check_correct_9_f ; 
logic [( 247 ) -1 : 0] hqm_AW_ecc_check_dout_9 ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_error_sb_9 ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_error_mb_9 ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_ecc_check_din_9_f  <= 0 ; 
 hqm_AW_ecc_check_ecc_9_f  <= 0 ; 
 hqm_AW_ecc_check_enable_9_f  <= 0 ; 
 hqm_AW_ecc_check_correct_9_f  <= 0 ; 
 end else begin 
 hqm_AW_ecc_check_din_9_f  <= hqm_AW_ecc_check_din_9_n ; 
 hqm_AW_ecc_check_ecc_9_f  <= hqm_AW_ecc_check_ecc_9_n ; 
 hqm_AW_ecc_check_enable_9_f  <= hqm_AW_ecc_check_enable_9_n ; 
 hqm_AW_ecc_check_correct_9_f  <= hqm_AW_ecc_check_correct_9_n ; 
 end 
end 
hqm_AW_ecc_check #( 
 .DATA_WIDTH(247) 
,.ECC_WIDTH(9) 
) i_hqm_AW_ecc_check_9 ( 
 .din_v ( hqm_AW_ecc_check_enable_9_f ) 
,.din ( hqm_AW_ecc_check_din_9_f) 
,.ecc ( hqm_AW_ecc_check_ecc_9_f) 
,.enable ( hqm_AW_ecc_check_enable_9_f) 
,.correct ( hqm_AW_ecc_check_correct_9_f) 
,.dout ( hqm_AW_ecc_check_dout_9 ) 
,.error_sb ( hqm_AW_ecc_check_error_sb_9 ) 
,.error_mb ( hqm_AW_ecc_check_error_mb_9 ) 
); 
assign hqm_AW_ecc_check_din_9_n = hqm_AW_ecc_check_dout_9 ; 
assign hqm_AW_ecc_check_ecc_9_n = {{7{1'b0}} , hqm_AW_ecc_check_error_sb_9 , hqm_AW_ecc_check_error_mb_9 } ; 
assign hqm_AW_ecc_check_enable_9_n = 1'd1 ; 
assign hqm_AW_ecc_check_correct_9_n = 1'd1 ; 

logic [( 502 ) -1 : 0] hqm_AW_ecc_check_din_10_n ,hqm_AW_ecc_check_din_10_f ; 
logic [( 10 ) -1 : 0] hqm_AW_ecc_check_ecc_10_n ,hqm_AW_ecc_check_ecc_10_f ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_enable_10_n ,hqm_AW_ecc_check_enable_10_f ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_correct_10_n ,hqm_AW_ecc_check_correct_10_f ; 
logic [( 502 ) -1 : 0] hqm_AW_ecc_check_dout_10 ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_error_sb_10 ; 
logic [( 1 ) -1 : 0] hqm_AW_ecc_check_error_mb_10 ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_ecc_check_din_10_f  <= 0 ; 
 hqm_AW_ecc_check_ecc_10_f  <= 0 ; 
 hqm_AW_ecc_check_enable_10_f  <= 0 ; 
 hqm_AW_ecc_check_correct_10_f  <= 0 ; 
 end else begin 
 hqm_AW_ecc_check_din_10_f  <= hqm_AW_ecc_check_din_10_n ; 
 hqm_AW_ecc_check_ecc_10_f  <= hqm_AW_ecc_check_ecc_10_n ; 
 hqm_AW_ecc_check_enable_10_f  <= hqm_AW_ecc_check_enable_10_n ; 
 hqm_AW_ecc_check_correct_10_f  <= hqm_AW_ecc_check_correct_10_n ; 
 end 
end 
hqm_AW_ecc_check #( 
 .DATA_WIDTH(502) 
,.ECC_WIDTH(10) 
) i_hqm_AW_ecc_check_10 ( 
 .din_v ( hqm_AW_ecc_check_enable_10_f ) 
,.din ( hqm_AW_ecc_check_din_10_f) 
,.ecc ( hqm_AW_ecc_check_ecc_10_f) 
,.enable ( hqm_AW_ecc_check_enable_10_f) 
,.correct ( hqm_AW_ecc_check_correct_10_f) 
,.dout ( hqm_AW_ecc_check_dout_10 ) 
,.error_sb ( hqm_AW_ecc_check_error_sb_10 ) 
,.error_mb ( hqm_AW_ecc_check_error_mb_10 ) 
); 
assign hqm_AW_ecc_check_din_10_n = hqm_AW_ecc_check_dout_10 ; 
assign hqm_AW_ecc_check_ecc_10_n = {{8{1'b0}} , hqm_AW_ecc_check_error_sb_10 , hqm_AW_ecc_check_error_mb_10 } ; 
assign hqm_AW_ecc_check_enable_10_n = 1'd1 ; 
assign hqm_AW_ecc_check_correct_10_n = 1'd1 ; 

logic [( 16 ) -1 : 0] hqm_AW_strict_arb_16_n , hqm_AW_strict_arb_16_f ; 
logic [( 16 ) -1 : 0] hqm_AW_strict_arb_16_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_strict_arb_16_winner_v ; 
logic [ ( 4 ) -1 : 0] hqm_AW_strict_arb_16_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_strict_arb_16_f <= 0 ; 
 end else begin 
  hqm_AW_strict_arb_16_f <= hqm_AW_strict_arb_16_n ; 
 end 
end 
hqm_AW_strict_arb #( 
 .NUM_REQS( 16 )  
) i_hqm_AW_strict_arb_16 ( 
  .reqs ( hqm_AW_strict_arb_16_reqs ) 
, .winner_v ( hqm_AW_strict_arb_16_winner_v ) 
, .winner ( hqm_AW_strict_arb_16_winner ) 
); 
assign hqm_AW_strict_arb_16_reqs = hqm_AW_strict_arb_16_f ; 
assign hqm_AW_strict_arb_16_n = { {11{1'b0}} , hqm_AW_strict_arb_16_winner , hqm_AW_strict_arb_16_winner_v } ; 

logic [( 32 ) -1 : 0] hqm_AW_strict_arb_32_n , hqm_AW_strict_arb_32_f ; 
logic [( 32 ) -1 : 0] hqm_AW_strict_arb_32_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_strict_arb_32_winner_v ; 
logic [ ( 5 ) -1 : 0] hqm_AW_strict_arb_32_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_strict_arb_32_f <= 0 ; 
 end else begin 
  hqm_AW_strict_arb_32_f <= hqm_AW_strict_arb_32_n ; 
 end 
end 
hqm_AW_strict_arb #( 
 .NUM_REQS( 32 )  
) i_hqm_AW_strict_arb_32 ( 
  .reqs ( hqm_AW_strict_arb_32_reqs ) 
, .winner_v ( hqm_AW_strict_arb_32_winner_v ) 
, .winner ( hqm_AW_strict_arb_32_winner ) 
); 
assign hqm_AW_strict_arb_32_reqs = hqm_AW_strict_arb_32_f ; 
assign hqm_AW_strict_arb_32_n = { {26{1'b0}} , hqm_AW_strict_arb_32_winner , hqm_AW_strict_arb_32_winner_v } ; 

logic [( 64 ) -1 : 0] hqm_AW_strict_arb_64_n , hqm_AW_strict_arb_64_f ; 
logic [( 64 ) -1 : 0] hqm_AW_strict_arb_64_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_strict_arb_64_winner_v ; 
logic [ ( 6 ) -1 : 0] hqm_AW_strict_arb_64_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_strict_arb_64_f <= 0 ; 
 end else begin 
  hqm_AW_strict_arb_64_f <= hqm_AW_strict_arb_64_n ; 
 end 
end 
hqm_AW_strict_arb #( 
 .NUM_REQS( 64 )  
) i_hqm_AW_strict_arb_64 ( 
  .reqs ( hqm_AW_strict_arb_64_reqs ) 
, .winner_v ( hqm_AW_strict_arb_64_winner_v ) 
, .winner ( hqm_AW_strict_arb_64_winner ) 
); 
assign hqm_AW_strict_arb_64_reqs = hqm_AW_strict_arb_64_f ; 
assign hqm_AW_strict_arb_64_n = { {57{1'b0}} , hqm_AW_strict_arb_64_winner , hqm_AW_strict_arb_64_winner_v } ; 

logic [( 128 ) -1 : 0] hqm_AW_strict_arb_128_n , hqm_AW_strict_arb_128_f ; 
logic [( 128 ) -1 : 0] hqm_AW_strict_arb_128_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_strict_arb_128_winner_v ; 
logic [ ( 7 ) -1 : 0] hqm_AW_strict_arb_128_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_strict_arb_128_f <= 0 ; 
 end else begin 
  hqm_AW_strict_arb_128_f <= hqm_AW_strict_arb_128_n ; 
 end 
end 
hqm_AW_strict_arb #( 
 .NUM_REQS( 128 )  
) i_hqm_AW_strict_arb_128 ( 
  .reqs ( hqm_AW_strict_arb_128_reqs ) 
, .winner_v ( hqm_AW_strict_arb_128_winner_v ) 
, .winner ( hqm_AW_strict_arb_128_winner ) 
); 
assign hqm_AW_strict_arb_128_reqs = hqm_AW_strict_arb_128_f ; 
assign hqm_AW_strict_arb_128_n = { {120{1'b0}} , hqm_AW_strict_arb_128_winner , hqm_AW_strict_arb_128_winner_v } ; 

logic [( 256 ) -1 : 0] hqm_AW_strict_arb_256_n , hqm_AW_strict_arb_256_f ; 
logic [( 256 ) -1 : 0] hqm_AW_strict_arb_256_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_strict_arb_256_winner_v ; 
logic [ ( 8 ) -1 : 0] hqm_AW_strict_arb_256_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_strict_arb_256_f <= 0 ; 
 end else begin 
  hqm_AW_strict_arb_256_f <= hqm_AW_strict_arb_256_n ; 
 end 
end 
hqm_AW_strict_arb #( 
 .NUM_REQS( 256 )  
) i_hqm_AW_strict_arb_256 ( 
  .reqs ( hqm_AW_strict_arb_256_reqs ) 
, .winner_v ( hqm_AW_strict_arb_256_winner_v ) 
, .winner ( hqm_AW_strict_arb_256_winner ) 
); 
assign hqm_AW_strict_arb_256_reqs = hqm_AW_strict_arb_256_f ; 
assign hqm_AW_strict_arb_256_n = { {247{1'b0}} , hqm_AW_strict_arb_256_winner , hqm_AW_strict_arb_256_winner_v } ; 

logic [( 512 ) -1 : 0] hqm_AW_strict_arb_512_n , hqm_AW_strict_arb_512_f ; 
logic [( 512 ) -1 : 0] hqm_AW_strict_arb_512_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_strict_arb_512_winner_v ; 
logic [ ( 9 ) -1 : 0] hqm_AW_strict_arb_512_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_strict_arb_512_f <= 0 ; 
 end else begin 
  hqm_AW_strict_arb_512_f <= hqm_AW_strict_arb_512_n ; 
 end 
end 
hqm_AW_strict_arb #( 
 .NUM_REQS( 512 )  
) i_hqm_AW_strict_arb_512 ( 
  .reqs ( hqm_AW_strict_arb_512_reqs ) 
, .winner_v ( hqm_AW_strict_arb_512_winner_v ) 
, .winner ( hqm_AW_strict_arb_512_winner ) 
); 
assign hqm_AW_strict_arb_512_reqs = hqm_AW_strict_arb_512_f ; 
assign hqm_AW_strict_arb_512_n = { {502{1'b0}} , hqm_AW_strict_arb_512_winner , hqm_AW_strict_arb_512_winner_v } ; 

logic [( 16 ) -1 : 0] hqm_AW_rr_arb_16_n , hqm_AW_rr_arb_16_f ; 
logic [( 16 ) -1 : 0] hqm_AW_rr_arb_16_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_rr_arb_16_update ; 
logic [ ( 1 ) -1 : 0] hqm_AW_rr_arb_16_winner_v ; 
logic [ ( 4 ) -1 : 0] hqm_AW_rr_arb_16_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_rr_arb_16_f <= 0 ; 
 end else begin 
  hqm_AW_rr_arb_16_f <= hqm_AW_rr_arb_16_n ; 
 end 
end 
hqm_AW_rr_arb #( 
 .NUM_REQS( 16 )  
) i_hqm_AW_rr_arb_16 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( hqm_AW_rr_arb_16_reqs ) 
, .update ( hqm_AW_rr_arb_16_update ) 
, .winner_v ( hqm_AW_rr_arb_16_winner_v ) 
, .winner ( hqm_AW_rr_arb_16_winner ) 
); 
assign hqm_AW_rr_arb_16_reqs = hqm_AW_rr_arb_16_f ; 
assign hqm_AW_rr_arb_16_update = hqm_AW_rr_arb_16_winner_v ; 
assign hqm_AW_rr_arb_16_n = { {11{1'b0}} , hqm_AW_rr_arb_16_winner , hqm_AW_rr_arb_16_winner_v } ; 

logic [( 32 ) -1 : 0] hqm_AW_rr_arb_32_n , hqm_AW_rr_arb_32_f ; 
logic [( 32 ) -1 : 0] hqm_AW_rr_arb_32_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_rr_arb_32_update ; 
logic [ ( 1 ) -1 : 0] hqm_AW_rr_arb_32_winner_v ; 
logic [ ( 5 ) -1 : 0] hqm_AW_rr_arb_32_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_rr_arb_32_f <= 0 ; 
 end else begin 
  hqm_AW_rr_arb_32_f <= hqm_AW_rr_arb_32_n ; 
 end 
end 
hqm_AW_rr_arb #( 
 .NUM_REQS( 32 )  
) i_hqm_AW_rr_arb_32 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( hqm_AW_rr_arb_32_reqs ) 
, .update ( hqm_AW_rr_arb_32_update ) 
, .winner_v ( hqm_AW_rr_arb_32_winner_v ) 
, .winner ( hqm_AW_rr_arb_32_winner ) 
); 
assign hqm_AW_rr_arb_32_reqs = hqm_AW_rr_arb_32_f ; 
assign hqm_AW_rr_arb_32_update = hqm_AW_rr_arb_32_winner_v ; 
assign hqm_AW_rr_arb_32_n = { {26{1'b0}} , hqm_AW_rr_arb_32_winner , hqm_AW_rr_arb_32_winner_v } ; 

logic [( 64 ) -1 : 0] hqm_AW_rr_arb_64_n , hqm_AW_rr_arb_64_f ; 
logic [( 64 ) -1 : 0] hqm_AW_rr_arb_64_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_rr_arb_64_update ; 
logic [ ( 1 ) -1 : 0] hqm_AW_rr_arb_64_winner_v ; 
logic [ ( 6 ) -1 : 0] hqm_AW_rr_arb_64_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_rr_arb_64_f <= 0 ; 
 end else begin 
  hqm_AW_rr_arb_64_f <= hqm_AW_rr_arb_64_n ; 
 end 
end 
hqm_AW_rr_arb #( 
 .NUM_REQS( 64 )  
) i_hqm_AW_rr_arb_64 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( hqm_AW_rr_arb_64_reqs ) 
, .update ( hqm_AW_rr_arb_64_update ) 
, .winner_v ( hqm_AW_rr_arb_64_winner_v ) 
, .winner ( hqm_AW_rr_arb_64_winner ) 
); 
assign hqm_AW_rr_arb_64_reqs = hqm_AW_rr_arb_64_f ; 
assign hqm_AW_rr_arb_64_update = hqm_AW_rr_arb_64_winner_v ; 
assign hqm_AW_rr_arb_64_n = { {57{1'b0}} , hqm_AW_rr_arb_64_winner , hqm_AW_rr_arb_64_winner_v } ; 

logic [( 128 ) -1 : 0] hqm_AW_rr_arb_128_n , hqm_AW_rr_arb_128_f ; 
logic [( 128 ) -1 : 0] hqm_AW_rr_arb_128_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_rr_arb_128_update ; 
logic [ ( 1 ) -1 : 0] hqm_AW_rr_arb_128_winner_v ; 
logic [ ( 7 ) -1 : 0] hqm_AW_rr_arb_128_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_rr_arb_128_f <= 0 ; 
 end else begin 
  hqm_AW_rr_arb_128_f <= hqm_AW_rr_arb_128_n ; 
 end 
end 
hqm_AW_rr_arb #( 
 .NUM_REQS( 128 )  
) i_hqm_AW_rr_arb_128 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( hqm_AW_rr_arb_128_reqs ) 
, .update ( hqm_AW_rr_arb_128_update ) 
, .winner_v ( hqm_AW_rr_arb_128_winner_v ) 
, .winner ( hqm_AW_rr_arb_128_winner ) 
); 
assign hqm_AW_rr_arb_128_reqs = hqm_AW_rr_arb_128_f ; 
assign hqm_AW_rr_arb_128_update = hqm_AW_rr_arb_128_winner_v ; 
assign hqm_AW_rr_arb_128_n = { {120{1'b0}} , hqm_AW_rr_arb_128_winner , hqm_AW_rr_arb_128_winner_v } ; 

logic [( 256 ) -1 : 0] hqm_AW_rr_arb_256_n , hqm_AW_rr_arb_256_f ; 
logic [( 256 ) -1 : 0] hqm_AW_rr_arb_256_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_rr_arb_256_update ; 
logic [ ( 1 ) -1 : 0] hqm_AW_rr_arb_256_winner_v ; 
logic [ ( 8 ) -1 : 0] hqm_AW_rr_arb_256_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_rr_arb_256_f <= 0 ; 
 end else begin 
  hqm_AW_rr_arb_256_f <= hqm_AW_rr_arb_256_n ; 
 end 
end 
hqm_AW_rr_arb #( 
 .NUM_REQS( 256 )  
) i_hqm_AW_rr_arb_256 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( hqm_AW_rr_arb_256_reqs ) 
, .update ( hqm_AW_rr_arb_256_update ) 
, .winner_v ( hqm_AW_rr_arb_256_winner_v ) 
, .winner ( hqm_AW_rr_arb_256_winner ) 
); 
assign hqm_AW_rr_arb_256_reqs = hqm_AW_rr_arb_256_f ; 
assign hqm_AW_rr_arb_256_update = hqm_AW_rr_arb_256_winner_v ; 
assign hqm_AW_rr_arb_256_n = { {247{1'b0}} , hqm_AW_rr_arb_256_winner , hqm_AW_rr_arb_256_winner_v } ; 

logic [( 512 ) -1 : 0] hqm_AW_rr_arb_512_n , hqm_AW_rr_arb_512_f ; 
logic [( 512 ) -1 : 0] hqm_AW_rr_arb_512_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_rr_arb_512_update ; 
logic [ ( 1 ) -1 : 0] hqm_AW_rr_arb_512_winner_v ; 
logic [ ( 9 ) -1 : 0] hqm_AW_rr_arb_512_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_rr_arb_512_f <= 0 ; 
 end else begin 
  hqm_AW_rr_arb_512_f <= hqm_AW_rr_arb_512_n ; 
 end 
end 
hqm_AW_rr_arb #( 
 .NUM_REQS( 512 )  
) i_hqm_AW_rr_arb_512 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( hqm_AW_rr_arb_512_reqs ) 
, .update ( hqm_AW_rr_arb_512_update ) 
, .winner_v ( hqm_AW_rr_arb_512_winner_v ) 
, .winner ( hqm_AW_rr_arb_512_winner ) 
); 
assign hqm_AW_rr_arb_512_reqs = hqm_AW_rr_arb_512_f ; 
assign hqm_AW_rr_arb_512_update = hqm_AW_rr_arb_512_winner_v ; 
assign hqm_AW_rr_arb_512_n = { {502{1'b0}} , hqm_AW_rr_arb_512_winner , hqm_AW_rr_arb_512_winner_v } ; 

logic [( 16 ) -1 : 0] hqm_AW_wrand_arb_wcfg_16_n , hqm_AW_wrand_arb_wcfg_16_f ; 
logic [( 16 ) -1 : 0] hqm_AW_wrand_arb_wcfg_16_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_wrand_arb_wcfg_16_winner_v ; 
logic [ ( 4 ) -1 : 0] hqm_AW_wrand_arb_wcfg_16_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_wrand_arb_wcfg_16_f <= 0 ; 
 end else begin 
  hqm_AW_wrand_arb_wcfg_16_f <= hqm_AW_wrand_arb_wcfg_16_n ; 
 end 
end 
hqm_AW_wrand_arb_wcfg #( 
 .NUM_REQS( 16 )  
) i_hqm_AW_wrand_arb_wcfg_16 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( hqm_AW_wrand_arb_wcfg_16_reqs ) 
, .winner_v ( hqm_AW_wrand_arb_wcfg_16_winner_v ) 
, .winner ( hqm_AW_wrand_arb_wcfg_16_winner ) 
, .cfg_write ( '0 ) 
, .cfg_read ( '0 ) 
, .cfg_user ( '0 ) 
, .cfg_addr ( '0 ) 
, .cfg_wdata ( '0 ) 
, .cfg_datasel ( '0 ) 
, .cfg_ack ( ) 
, .cfg_err ( ) 
, .cfg_rdata ( ) 
); 
assign hqm_AW_wrand_arb_wcfg_16_reqs = hqm_AW_wrand_arb_wcfg_16_f ; 
assign hqm_AW_wrand_arb_wcfg_16_n = { {11{1'b0}} , hqm_AW_wrand_arb_wcfg_16_winner , hqm_AW_wrand_arb_wcfg_16_winner_v } ; 

logic [( 32 ) -1 : 0] hqm_AW_wrand_arb_wcfg_32_n , hqm_AW_wrand_arb_wcfg_32_f ; 
logic [( 32 ) -1 : 0] hqm_AW_wrand_arb_wcfg_32_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_wrand_arb_wcfg_32_winner_v ; 
logic [ ( 5 ) -1 : 0] hqm_AW_wrand_arb_wcfg_32_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_wrand_arb_wcfg_32_f <= 0 ; 
 end else begin 
  hqm_AW_wrand_arb_wcfg_32_f <= hqm_AW_wrand_arb_wcfg_32_n ; 
 end 
end 
hqm_AW_wrand_arb_wcfg #( 
 .NUM_REQS( 32 )  
) i_hqm_AW_wrand_arb_wcfg_32 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( hqm_AW_wrand_arb_wcfg_32_reqs ) 
, .winner_v ( hqm_AW_wrand_arb_wcfg_32_winner_v ) 
, .winner ( hqm_AW_wrand_arb_wcfg_32_winner ) 
, .cfg_write ( '0 ) 
, .cfg_read ( '0 ) 
, .cfg_user ( '0 ) 
, .cfg_addr ( '0 ) 
, .cfg_wdata ( '0 ) 
, .cfg_datasel ( '0 ) 
, .cfg_ack ( ) 
, .cfg_err ( ) 
, .cfg_rdata ( ) 
); 
assign hqm_AW_wrand_arb_wcfg_32_reqs = hqm_AW_wrand_arb_wcfg_32_f ; 
assign hqm_AW_wrand_arb_wcfg_32_n = { {26{1'b0}} , hqm_AW_wrand_arb_wcfg_32_winner , hqm_AW_wrand_arb_wcfg_32_winner_v } ; 

logic [( 64 ) -1 : 0] hqm_AW_wrand_arb_wcfg_64_n , hqm_AW_wrand_arb_wcfg_64_f ; 
logic [( 64 ) -1 : 0] hqm_AW_wrand_arb_wcfg_64_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_wrand_arb_wcfg_64_winner_v ; 
logic [ ( 6 ) -1 : 0] hqm_AW_wrand_arb_wcfg_64_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_wrand_arb_wcfg_64_f <= 0 ; 
 end else begin 
  hqm_AW_wrand_arb_wcfg_64_f <= hqm_AW_wrand_arb_wcfg_64_n ; 
 end 
end 
hqm_AW_wrand_arb_wcfg #( 
 .NUM_REQS( 64 )  
) i_hqm_AW_wrand_arb_wcfg_64 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( hqm_AW_wrand_arb_wcfg_64_reqs ) 
, .winner_v ( hqm_AW_wrand_arb_wcfg_64_winner_v ) 
, .winner ( hqm_AW_wrand_arb_wcfg_64_winner ) 
, .cfg_write ( '0 ) 
, .cfg_read ( '0 ) 
, .cfg_user ( '0 ) 
, .cfg_addr ( '0 ) 
, .cfg_wdata ( '0 ) 
, .cfg_datasel ( '0 ) 
, .cfg_ack ( ) 
, .cfg_err ( ) 
, .cfg_rdata ( ) 
); 
assign hqm_AW_wrand_arb_wcfg_64_reqs = hqm_AW_wrand_arb_wcfg_64_f ; 
assign hqm_AW_wrand_arb_wcfg_64_n = { {57{1'b0}} , hqm_AW_wrand_arb_wcfg_64_winner , hqm_AW_wrand_arb_wcfg_64_winner_v } ; 

logic [( 128 ) -1 : 0] hqm_AW_wrand_arb_wcfg_128_n , hqm_AW_wrand_arb_wcfg_128_f ; 
logic [( 128 ) -1 : 0] hqm_AW_wrand_arb_wcfg_128_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_wrand_arb_wcfg_128_winner_v ; 
logic [ ( 7 ) -1 : 0] hqm_AW_wrand_arb_wcfg_128_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_wrand_arb_wcfg_128_f <= 0 ; 
 end else begin 
  hqm_AW_wrand_arb_wcfg_128_f <= hqm_AW_wrand_arb_wcfg_128_n ; 
 end 
end 
hqm_AW_wrand_arb_wcfg #( 
 .NUM_REQS( 128 )  
) i_hqm_AW_wrand_arb_wcfg_128 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( hqm_AW_wrand_arb_wcfg_128_reqs ) 
, .winner_v ( hqm_AW_wrand_arb_wcfg_128_winner_v ) 
, .winner ( hqm_AW_wrand_arb_wcfg_128_winner ) 
, .cfg_write ( '0 ) 
, .cfg_read ( '0 ) 
, .cfg_user ( '0 ) 
, .cfg_addr ( '0 ) 
, .cfg_wdata ( '0 ) 
, .cfg_datasel ( '0 ) 
, .cfg_ack ( ) 
, .cfg_err ( ) 
, .cfg_rdata ( ) 
); 
assign hqm_AW_wrand_arb_wcfg_128_reqs = hqm_AW_wrand_arb_wcfg_128_f ; 
assign hqm_AW_wrand_arb_wcfg_128_n = { {120{1'b0}} , hqm_AW_wrand_arb_wcfg_128_winner , hqm_AW_wrand_arb_wcfg_128_winner_v } ; 

logic [( 256 ) -1 : 0] hqm_AW_wrand_arb_wcfg_256_n , hqm_AW_wrand_arb_wcfg_256_f ; 
logic [( 256 ) -1 : 0] hqm_AW_wrand_arb_wcfg_256_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_wrand_arb_wcfg_256_winner_v ; 
logic [ ( 8 ) -1 : 0] hqm_AW_wrand_arb_wcfg_256_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_wrand_arb_wcfg_256_f <= 0 ; 
 end else begin 
  hqm_AW_wrand_arb_wcfg_256_f <= hqm_AW_wrand_arb_wcfg_256_n ; 
 end 
end 
hqm_AW_wrand_arb_wcfg #( 
 .NUM_REQS( 256 )  
) i_hqm_AW_wrand_arb_wcfg_256 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( hqm_AW_wrand_arb_wcfg_256_reqs ) 
, .winner_v ( hqm_AW_wrand_arb_wcfg_256_winner_v ) 
, .winner ( hqm_AW_wrand_arb_wcfg_256_winner ) 
, .cfg_write ( '0 ) 
, .cfg_read ( '0 ) 
, .cfg_user ( '0 ) 
, .cfg_addr ( '0 ) 
, .cfg_wdata ( '0 ) 
, .cfg_datasel ( '0 ) 
, .cfg_ack ( ) 
, .cfg_err ( ) 
, .cfg_rdata ( ) 
); 
assign hqm_AW_wrand_arb_wcfg_256_reqs = hqm_AW_wrand_arb_wcfg_256_f ; 
assign hqm_AW_wrand_arb_wcfg_256_n = { {247{1'b0}} , hqm_AW_wrand_arb_wcfg_256_winner , hqm_AW_wrand_arb_wcfg_256_winner_v } ; 

logic [( 512 ) -1 : 0] hqm_AW_wrand_arb_wcfg_512_n , hqm_AW_wrand_arb_wcfg_512_f ; 
logic [( 512 ) -1 : 0] hqm_AW_wrand_arb_wcfg_512_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_wrand_arb_wcfg_512_winner_v ; 
logic [ ( 9 ) -1 : 0] hqm_AW_wrand_arb_wcfg_512_winner ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_wrand_arb_wcfg_512_f <= 0 ; 
 end else begin 
  hqm_AW_wrand_arb_wcfg_512_f <= hqm_AW_wrand_arb_wcfg_512_n ; 
 end 
end 
hqm_AW_wrand_arb_wcfg #( 
 .NUM_REQS( 512 )  
) i_hqm_AW_wrand_arb_wcfg_512 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( hqm_AW_wrand_arb_wcfg_512_reqs ) 
, .winner_v ( hqm_AW_wrand_arb_wcfg_512_winner_v ) 
, .winner ( hqm_AW_wrand_arb_wcfg_512_winner ) 
, .cfg_write ( '0 ) 
, .cfg_read ( '0 ) 
, .cfg_user ( '0 ) 
, .cfg_addr ( '0 ) 
, .cfg_wdata ( '0 ) 
, .cfg_datasel ( '0 ) 
, .cfg_ack ( ) 
, .cfg_err ( ) 
, .cfg_rdata ( ) 
); 
assign hqm_AW_wrand_arb_wcfg_512_reqs = hqm_AW_wrand_arb_wcfg_512_f ; 
assign hqm_AW_wrand_arb_wcfg_512_n = { {502{1'b0}} , hqm_AW_wrand_arb_wcfg_512_winner , hqm_AW_wrand_arb_wcfg_512_winner_v } ; 

logic [( 16 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_16_n , hqm_AW_wrandwrand_arb_wcfg_16_f ; 
logic [( 16 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_16_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_16_winner_v ; 
logic [ ( 4 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_16_winner ; 
logic [ ( 3 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_16_winner_pri ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_wrandwrand_arb_wcfg_16_f <= 0 ; 
 end else begin 
  hqm_AW_wrandwrand_arb_wcfg_16_f <= hqm_AW_wrandwrand_arb_wcfg_16_n ; 
 end 
end 
hqm_AW_wrandwrand_arb_wcfg #( 
  .NUM_REQS( 16 )  
, .NUM_PRI( 8 )  
) i_hqm_AW_wrandwrand_arb_wcfg_16 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( {8{hqm_AW_wrandwrand_arb_wcfg_16_reqs}} ) 
, .winner_v ( hqm_AW_wrandwrand_arb_wcfg_16_winner_v ) 
, .winner_pri ( hqm_AW_wrandwrand_arb_wcfg_16_winner_pri ) 
, .winner ( hqm_AW_wrandwrand_arb_wcfg_16_winner ) 
, .cfg_write ( '0 ) 
, .cfg_read ( '0 ) 
, .cfg_user ( '0 ) 
, .cfg_addr ( '0 ) 
, .cfg_wdata ( '0 ) 
, .cfg_datasel ( '0 ) 
, .cfg_ack ( ) 
, .cfg_err ( ) 
, .cfg_rdata ( ) 
); 
assign hqm_AW_wrandwrand_arb_wcfg_16_reqs = hqm_AW_wrandwrand_arb_wcfg_16_f ; 
assign hqm_AW_wrandwrand_arb_wcfg_16_n = { {8{1'b0}} , hqm_AW_wrandwrand_arb_wcfg_16_winner_pri , hqm_AW_wrandwrand_arb_wcfg_16_winner , hqm_AW_wrandwrand_arb_wcfg_16_winner_v } ; 

logic [( 32 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_32_n , hqm_AW_wrandwrand_arb_wcfg_32_f ; 
logic [( 32 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_32_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_32_winner_v ; 
logic [ ( 5 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_32_winner ; 
logic [ ( 3 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_32_winner_pri ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_wrandwrand_arb_wcfg_32_f <= 0 ; 
 end else begin 
  hqm_AW_wrandwrand_arb_wcfg_32_f <= hqm_AW_wrandwrand_arb_wcfg_32_n ; 
 end 
end 
hqm_AW_wrandwrand_arb_wcfg #( 
  .NUM_REQS( 32 )  
, .NUM_PRI( 8 )  
) i_hqm_AW_wrandwrand_arb_wcfg_32 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( {8{hqm_AW_wrandwrand_arb_wcfg_32_reqs}} ) 
, .winner_v ( hqm_AW_wrandwrand_arb_wcfg_32_winner_v ) 
, .winner_pri ( hqm_AW_wrandwrand_arb_wcfg_32_winner_pri ) 
, .winner ( hqm_AW_wrandwrand_arb_wcfg_32_winner ) 
, .cfg_write ( '0 ) 
, .cfg_read ( '0 ) 
, .cfg_user ( '0 ) 
, .cfg_addr ( '0 ) 
, .cfg_wdata ( '0 ) 
, .cfg_datasel ( '0 ) 
, .cfg_ack ( ) 
, .cfg_err ( ) 
, .cfg_rdata ( ) 
); 
assign hqm_AW_wrandwrand_arb_wcfg_32_reqs = hqm_AW_wrandwrand_arb_wcfg_32_f ; 
assign hqm_AW_wrandwrand_arb_wcfg_32_n = { {23{1'b0}} , hqm_AW_wrandwrand_arb_wcfg_32_winner_pri , hqm_AW_wrandwrand_arb_wcfg_32_winner , hqm_AW_wrandwrand_arb_wcfg_32_winner_v } ; 

logic [( 64 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_64_n , hqm_AW_wrandwrand_arb_wcfg_64_f ; 
logic [( 64 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_64_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_64_winner_v ; 
logic [ ( 6 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_64_winner ; 
logic [ ( 3 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_64_winner_pri ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_wrandwrand_arb_wcfg_64_f <= 0 ; 
 end else begin 
  hqm_AW_wrandwrand_arb_wcfg_64_f <= hqm_AW_wrandwrand_arb_wcfg_64_n ; 
 end 
end 
hqm_AW_wrandwrand_arb_wcfg #( 
  .NUM_REQS( 64 )  
, .NUM_PRI( 8 )  
) i_hqm_AW_wrandwrand_arb_wcfg_64 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( {8{hqm_AW_wrandwrand_arb_wcfg_64_reqs}} ) 
, .winner_v ( hqm_AW_wrandwrand_arb_wcfg_64_winner_v ) 
, .winner_pri ( hqm_AW_wrandwrand_arb_wcfg_64_winner_pri ) 
, .winner ( hqm_AW_wrandwrand_arb_wcfg_64_winner ) 
, .cfg_write ( '0 ) 
, .cfg_read ( '0 ) 
, .cfg_user ( '0 ) 
, .cfg_addr ( '0 ) 
, .cfg_wdata ( '0 ) 
, .cfg_datasel ( '0 ) 
, .cfg_ack ( ) 
, .cfg_err ( ) 
, .cfg_rdata ( ) 
); 
assign hqm_AW_wrandwrand_arb_wcfg_64_reqs = hqm_AW_wrandwrand_arb_wcfg_64_f ; 
assign hqm_AW_wrandwrand_arb_wcfg_64_n = { {54{1'b0}} , hqm_AW_wrandwrand_arb_wcfg_64_winner_pri , hqm_AW_wrandwrand_arb_wcfg_64_winner , hqm_AW_wrandwrand_arb_wcfg_64_winner_v } ; 

logic [( 128 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_128_n , hqm_AW_wrandwrand_arb_wcfg_128_f ; 
logic [( 128 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_128_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_128_winner_v ; 
logic [ ( 7 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_128_winner ; 
logic [ ( 3 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_128_winner_pri ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_wrandwrand_arb_wcfg_128_f <= 0 ; 
 end else begin 
  hqm_AW_wrandwrand_arb_wcfg_128_f <= hqm_AW_wrandwrand_arb_wcfg_128_n ; 
 end 
end 
hqm_AW_wrandwrand_arb_wcfg #( 
  .NUM_REQS( 128 )  
, .NUM_PRI( 8 )  
) i_hqm_AW_wrandwrand_arb_wcfg_128 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( {8{hqm_AW_wrandwrand_arb_wcfg_128_reqs}} ) 
, .winner_v ( hqm_AW_wrandwrand_arb_wcfg_128_winner_v ) 
, .winner_pri ( hqm_AW_wrandwrand_arb_wcfg_128_winner_pri ) 
, .winner ( hqm_AW_wrandwrand_arb_wcfg_128_winner ) 
, .cfg_write ( '0 ) 
, .cfg_read ( '0 ) 
, .cfg_user ( '0 ) 
, .cfg_addr ( '0 ) 
, .cfg_wdata ( '0 ) 
, .cfg_datasel ( '0 ) 
, .cfg_ack ( ) 
, .cfg_err ( ) 
, .cfg_rdata ( ) 
); 
assign hqm_AW_wrandwrand_arb_wcfg_128_reqs = hqm_AW_wrandwrand_arb_wcfg_128_f ; 
assign hqm_AW_wrandwrand_arb_wcfg_128_n = { {117{1'b0}} , hqm_AW_wrandwrand_arb_wcfg_128_winner_pri , hqm_AW_wrandwrand_arb_wcfg_128_winner , hqm_AW_wrandwrand_arb_wcfg_128_winner_v } ; 

logic [( 256 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_256_n , hqm_AW_wrandwrand_arb_wcfg_256_f ; 
logic [( 256 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_256_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_256_winner_v ; 
logic [ ( 8 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_256_winner ; 
logic [ ( 3 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_256_winner_pri ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_wrandwrand_arb_wcfg_256_f <= 0 ; 
 end else begin 
  hqm_AW_wrandwrand_arb_wcfg_256_f <= hqm_AW_wrandwrand_arb_wcfg_256_n ; 
 end 
end 
hqm_AW_wrandwrand_arb_wcfg #( 
  .NUM_REQS( 256 )  
, .NUM_PRI( 8 )  
) i_hqm_AW_wrandwrand_arb_wcfg_256 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( {8{hqm_AW_wrandwrand_arb_wcfg_256_reqs}} ) 
, .winner_v ( hqm_AW_wrandwrand_arb_wcfg_256_winner_v ) 
, .winner_pri ( hqm_AW_wrandwrand_arb_wcfg_256_winner_pri ) 
, .winner ( hqm_AW_wrandwrand_arb_wcfg_256_winner ) 
, .cfg_write ( '0 ) 
, .cfg_read ( '0 ) 
, .cfg_user ( '0 ) 
, .cfg_addr ( '0 ) 
, .cfg_wdata ( '0 ) 
, .cfg_datasel ( '0 ) 
, .cfg_ack ( ) 
, .cfg_err ( ) 
, .cfg_rdata ( ) 
); 
assign hqm_AW_wrandwrand_arb_wcfg_256_reqs = hqm_AW_wrandwrand_arb_wcfg_256_f ; 
assign hqm_AW_wrandwrand_arb_wcfg_256_n = { {244{1'b0}} , hqm_AW_wrandwrand_arb_wcfg_256_winner_pri , hqm_AW_wrandwrand_arb_wcfg_256_winner , hqm_AW_wrandwrand_arb_wcfg_256_winner_v } ; 

logic [( 512 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_512_n , hqm_AW_wrandwrand_arb_wcfg_512_f ; 
logic [( 512 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_512_reqs ; 
logic [ ( 1 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_512_winner_v ; 
logic [ ( 9 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_512_winner ; 
logic [ ( 3 ) -1 : 0] hqm_AW_wrandwrand_arb_wcfg_512_winner_pri ; 
always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_wrandwrand_arb_wcfg_512_f <= 0 ; 
 end else begin 
  hqm_AW_wrandwrand_arb_wcfg_512_f <= hqm_AW_wrandwrand_arb_wcfg_512_n ; 
 end 
end 
hqm_AW_wrandwrand_arb_wcfg #( 
  .NUM_REQS( 512 )  
, .NUM_PRI( 8 )  
) i_hqm_AW_wrandwrand_arb_wcfg_512 ( 
  .clk ( clk ) 
, .rst_n ( rst_n ) 
, .reqs ( {8{hqm_AW_wrandwrand_arb_wcfg_512_reqs}} ) 
, .winner_v ( hqm_AW_wrandwrand_arb_wcfg_512_winner_v ) 
, .winner_pri ( hqm_AW_wrandwrand_arb_wcfg_512_winner_pri ) 
, .winner ( hqm_AW_wrandwrand_arb_wcfg_512_winner ) 
, .cfg_write ( '0 ) 
, .cfg_read ( '0 ) 
, .cfg_user ( '0 ) 
, .cfg_addr ( '0 ) 
, .cfg_wdata ( '0 ) 
, .cfg_datasel ( '0 ) 
, .cfg_ack ( ) 
, .cfg_err ( ) 
, .cfg_rdata ( ) 
); 
assign hqm_AW_wrandwrand_arb_wcfg_512_reqs = hqm_AW_wrandwrand_arb_wcfg_512_f ; 
assign hqm_AW_wrandwrand_arb_wcfg_512_n = { {499{1'b0}} , hqm_AW_wrandwrand_arb_wcfg_512_winner_pri , hqm_AW_wrandwrand_arb_wcfg_512_winner , hqm_AW_wrandwrand_arb_wcfg_512_winner_v } ; 


logic [( 4 ) -1 : 0] hqm_AW_residue_gen_a_4_n , hqm_AW_residue_gen_a_4_f ;
logic [( 2 ) -1 : 0] hqm_AW_residue_gen_r_4 ;

always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_residue_gen_a_4_f <= 0 ; 
 end else begin 
 hqm_AW_residue_gen_a_4_f <= hqm_AW_residue_gen_a_4_n  ; 
 end 
end 
hqm_AW_residue_gen # ( .WIDTH ( 4 ) ) i_hqm_AW_residue_gen_4 (
          .a                    ( hqm_AW_residue_gen_a_4_f )
        , .r                    ( hqm_AW_residue_gen_r_4 )
) ;

assign hqm_AW_residue_gen_a_4_n = { { (4-2) { in } } , hqm_AW_residue_gen_r_4 } ;


logic [( 8 ) -1 : 0] hqm_AW_residue_gen_a_8_n , hqm_AW_residue_gen_a_8_f ;
logic [( 2 ) -1 : 0] hqm_AW_residue_gen_r_8 ;

always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_residue_gen_a_8_f <= 0 ; 
 end else begin 
 hqm_AW_residue_gen_a_8_f <= hqm_AW_residue_gen_a_8_n  ; 
 end 
end 
hqm_AW_residue_gen # ( .WIDTH ( 8 ) ) i_hqm_AW_residue_gen_8 (
          .a                    ( hqm_AW_residue_gen_a_8_f )
        , .r                    ( hqm_AW_residue_gen_r_8 )
) ;

assign hqm_AW_residue_gen_a_8_n = { { (8-2) { in } } , hqm_AW_residue_gen_r_8 } ;


logic [( 16 ) -1 : 0] hqm_AW_residue_gen_a_16_n , hqm_AW_residue_gen_a_16_f ;
logic [( 2 ) -1 : 0] hqm_AW_residue_gen_r_16 ;

always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_residue_gen_a_16_f <= 0 ; 
 end else begin 
 hqm_AW_residue_gen_a_16_f <= hqm_AW_residue_gen_a_16_n  ; 
 end 
end 
hqm_AW_residue_gen # ( .WIDTH ( 16 ) ) i_hqm_AW_residue_gen_16 (
          .a                    ( hqm_AW_residue_gen_a_16_f )
        , .r                    ( hqm_AW_residue_gen_r_16 )
) ;

assign hqm_AW_residue_gen_a_16_n = { { (16-2) { in } } , hqm_AW_residue_gen_r_16 } ;


logic [( 32 ) -1 : 0] hqm_AW_residue_gen_a_32_n , hqm_AW_residue_gen_a_32_f ;
logic [( 2 ) -1 : 0] hqm_AW_residue_gen_r_32 ;

always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_residue_gen_a_32_f <= 0 ; 
 end else begin 
 hqm_AW_residue_gen_a_32_f <= hqm_AW_residue_gen_a_32_n  ; 
 end 
end 
hqm_AW_residue_gen # ( .WIDTH ( 32 ) ) i_hqm_AW_residue_gen_32 (
          .a                    ( hqm_AW_residue_gen_a_32_f )
        , .r                    ( hqm_AW_residue_gen_r_32 )
) ;

assign hqm_AW_residue_gen_a_32_n = { { (32-2) { in } } , hqm_AW_residue_gen_r_32 } ;


logic [( 64 ) -1 : 0] hqm_AW_residue_gen_a_64_n , hqm_AW_residue_gen_a_64_f ;
logic [( 2 ) -1 : 0] hqm_AW_residue_gen_r_64 ;

always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_residue_gen_a_64_f <= 0 ; 
 end else begin 
 hqm_AW_residue_gen_a_64_f <= hqm_AW_residue_gen_a_64_n  ; 
 end 
end 
hqm_AW_residue_gen # ( .WIDTH ( 64 ) ) i_hqm_AW_residue_gen_64 (
          .a                    ( hqm_AW_residue_gen_a_64_f )
        , .r                    ( hqm_AW_residue_gen_r_64 )
) ;

assign hqm_AW_residue_gen_a_64_n = { { (64-2) { in } } , hqm_AW_residue_gen_r_64 } ;


logic [( 128 ) -1 : 0] hqm_AW_residue_gen_a_128_n , hqm_AW_residue_gen_a_128_f ;
logic [( 2 ) -1 : 0] hqm_AW_residue_gen_r_128 ;

always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_residue_gen_a_128_f <= 0 ; 
 end else begin 
 hqm_AW_residue_gen_a_128_f <= hqm_AW_residue_gen_a_128_n  ; 
 end 
end 
hqm_AW_residue_gen # ( .WIDTH ( 128 ) ) i_hqm_AW_residue_gen_128 (
          .a                    ( hqm_AW_residue_gen_a_128_f )
        , .r                    ( hqm_AW_residue_gen_r_128 )
) ;

assign hqm_AW_residue_gen_a_128_n = { { (128-2) { in } } , hqm_AW_residue_gen_r_128 } ;


logic [( 256 ) -1 : 0] hqm_AW_residue_gen_a_256_n , hqm_AW_residue_gen_a_256_f ;
logic [( 2 ) -1 : 0] hqm_AW_residue_gen_r_256 ;

always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_residue_gen_a_256_f <= 0 ; 
 end else begin 
 hqm_AW_residue_gen_a_256_f <= hqm_AW_residue_gen_a_256_n  ; 
 end 
end 
hqm_AW_residue_gen # ( .WIDTH ( 256 ) ) i_hqm_AW_residue_gen_256 (
          .a                    ( hqm_AW_residue_gen_a_256_f )
        , .r                    ( hqm_AW_residue_gen_r_256 )
) ;

assign hqm_AW_residue_gen_a_256_n = { { (256-2) { in } } , hqm_AW_residue_gen_r_256 } ;


logic [( 512 ) -1 : 0] hqm_AW_residue_gen_a_512_n , hqm_AW_residue_gen_a_512_f ;
logic [( 2 ) -1 : 0] hqm_AW_residue_gen_r_512 ;

always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
 hqm_AW_residue_gen_a_512_f <= 0 ; 
 end else begin 
 hqm_AW_residue_gen_a_512_f <= hqm_AW_residue_gen_a_512_n  ; 
 end 
end 
hqm_AW_residue_gen # ( .WIDTH ( 512 ) ) i_hqm_AW_residue_gen_512 (
          .a                    ( hqm_AW_residue_gen_a_512_f )
        , .r                    ( hqm_AW_residue_gen_r_512 )
) ;

assign hqm_AW_residue_gen_a_512_n = { { (512-2) { in } } , hqm_AW_residue_gen_r_512 } ;


assign out = (|(add_A_32_f))
| (|(add_B_32_f))
| (|(add_Z_32_f))
| (|(add_A_64_f))
| (|(add_B_64_f))
| (|(add_Z_64_f))
| (|(add_A_96_f))
| (|(add_B_96_f))
| (|(add_Z_96_f))
| (|(add_A_128_f))
| (|(add_B_128_f))
| (|(add_Z_128_f))
| (|(sub_A_32_f))
| (|(sub_B_32_f))
| (|(sub_Z_32_f))
| (|(sub_A_64_f))
| (|(sub_B_64_f))
| (|(sub_Z_64_f))
| (|(sub_A_96_f))
| (|(sub_B_96_f))
| (|(sub_Z_96_f))
| (|(sub_A_128_f))
| (|(sub_B_128_f))
| (|(sub_Z_128_f))
| (|(hqm_AW_ecc_check_din_5_f))
| (|(hqm_AW_ecc_check_ecc_5_f))
| (|(hqm_AW_ecc_check_enable_5_f))
| (|(hqm_AW_ecc_check_correct_5_f))
| (|(hqm_AW_ecc_check_din_6_f))
| (|(hqm_AW_ecc_check_ecc_6_f))
| (|(hqm_AW_ecc_check_enable_6_f))
| (|(hqm_AW_ecc_check_correct_6_f))
| (|(hqm_AW_ecc_check_din_7_f))
| (|(hqm_AW_ecc_check_ecc_7_f))
| (|(hqm_AW_ecc_check_enable_7_f))
| (|(hqm_AW_ecc_check_correct_7_f))
| (|(hqm_AW_ecc_check_din_8_f))
| (|(hqm_AW_ecc_check_ecc_8_f))
| (|(hqm_AW_ecc_check_enable_8_f))
| (|(hqm_AW_ecc_check_correct_8_f))
| (|(hqm_AW_ecc_check_din_9_f))
| (|(hqm_AW_ecc_check_ecc_9_f))
| (|(hqm_AW_ecc_check_enable_9_f))
| (|(hqm_AW_ecc_check_correct_9_f))
| (|(hqm_AW_ecc_check_din_10_f))
| (|(hqm_AW_ecc_check_ecc_10_f))
| (|(hqm_AW_ecc_check_enable_10_f))
| (|(hqm_AW_ecc_check_correct_10_f))
| (|(hqm_AW_strict_arb_16_f))
| (|(hqm_AW_strict_arb_32_f))
| (|(hqm_AW_strict_arb_64_f))
| (|(hqm_AW_strict_arb_128_f))
| (|(hqm_AW_strict_arb_256_f))
| (|(hqm_AW_rr_arb_16_f))
| (|(hqm_AW_rr_arb_32_f))
| (|(hqm_AW_rr_arb_64_f))
| (|(hqm_AW_rr_arb_128_f))
| (|(hqm_AW_rr_arb_256_f))
| (|(hqm_AW_rr_arb_512_f))
| (|(hqm_AW_wrand_arb_wcfg_16_f))
| (|(hqm_AW_wrand_arb_wcfg_32_f))
| (|(hqm_AW_wrand_arb_wcfg_64_f))
| (|(hqm_AW_wrand_arb_wcfg_128_f))
| (|(hqm_AW_wrand_arb_wcfg_256_f))
| (|(hqm_AW_wrand_arb_wcfg_512_f))
| (|(hqm_AW_wrandwrand_arb_wcfg_16_f))
| (|(hqm_AW_wrandwrand_arb_wcfg_32_f))
| (|(hqm_AW_wrandwrand_arb_wcfg_64_f))
| (|(hqm_AW_wrandwrand_arb_wcfg_128_f))
| (|(hqm_AW_wrandwrand_arb_wcfg_256_f))
| (|(hqm_AW_wrandwrand_arb_wcfg_512_f))
| (|(hqm_AW_residue_gen_a_4_f))
| (|(hqm_AW_residue_gen_a_8_f))
| (|(hqm_AW_residue_gen_a_16_f))
| (|(hqm_AW_residue_gen_a_32_f))
| (|(hqm_AW_residue_gen_a_64_f))
| (|(hqm_AW_residue_gen_a_128_f))
| (|(hqm_AW_residue_gen_a_256_f))
| (|(hqm_AW_residue_gen_a_512_f))
;


logic [9:0] hqm_AW_bindec_val_f;
logic [1023:0] hqm_AW_bindec_val_bindec, hqm_AW_bindec_val_bindec_f;

hqm_AW_bindec #( .WIDTH (10) )
  i_hqm_AW_bindec (
  .a      (hqm_AW_bindec_val_f)
, .enable (1'b1)
, .dec    (hqm_AW_bindec_val_bindec)
);


always_ff @(posedge clk or negedge rst_n) begin 
 if ( rst_n == 1'd0 ) begin 
  hqm_AW_bindec_val_f <= '0 ; 
  hqm_AW_bindec_val_bindec_f <= '0;
 end else begin 
  hqm_AW_bindec_val_f <= {10{in}};
  hqm_AW_bindec_val_bindec_f <= hqm_AW_bindec_val_bindec;
 end 
end 

endmodule 

