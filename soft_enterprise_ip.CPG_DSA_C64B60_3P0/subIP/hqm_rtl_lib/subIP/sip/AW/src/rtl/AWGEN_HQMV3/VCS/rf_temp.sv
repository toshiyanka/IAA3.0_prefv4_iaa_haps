module TB ();

//KAC-begin param

localparam MASK = {WIDTH{1'b1}} ;

initial begin
  $vcdplusfile("dump.vpd");
  $vcdpluson();
  $vcdplusmemon();
end

logic clk_rst_b ;
integer clk_period ;
logic clk , clk_pre , clk_off ;
integer rclk_period ;
logic rclk , rclk_pre , rclk_off ;
integer wclk_period ;
logic wclk , wclk_pre , wclk_off ;

logic [ ( 32 ) - 1 : 0 ] d_f , d_nxt ;
logic [ ( 32 ) - 1 : 0 ] d_rand32 ; logic [ ( 1024 ) - 1 : 0 ] d_rand , d_5 , d_a ;
logic d_clear , d_incr ;
logic ERROR , VERBOSE ;
logic [ ( 32 ) - 1 : 0 ] ERROR_CNT ;

logic re , re_f ;
logic we ;
logic [ ( DEPTHB2 ) - 1 : 0 ] waddr ;
logic [ ( DEPTHB2 ) - 1 : 0 ] raddr , raddr_f ;
logic [ ( WIDTH ) - 1 : 0 ] wdata ,  rdata , data_mask ;

//KAC-begin inst

always #( ( 1.0 * clk_period ) / 2.0 ) clk_pre = ~clk_pre ;
always #( ( 1.0 * rclk_period ) / 2.0 ) rclk_pre = ~rclk_pre ;
always #( ( 1.0 * wclk_period ) / 2.0 ) wclk_pre = ~wclk_pre ;

assign clk = clk_pre & ~ clk_off ;
assign rclk = rclk_pre & ~ rclk_off ;
assign wclk = wclk_pre & ~ wclk_off ;

initial begin
  $assertkill();
  VERBOSE = 0 ; 
  $display ("TB: @%09tps TEST RF %d %d   Begin",$time,DEPTH,WIDTH );
  clk_rst_b = 'd0 ;
  clk_period = 1000 ; clk_pre = 'd1 ; clk_off = 'd0 ;
  rclk_period = 1000 ; rclk_pre = 'd1 ; rclk_off = 'd1 ;
  wclk_period = 1000 ; wclk_pre = 'd1 ; wclk_off = 'd1 ;
  d_clear = '1 ; 
  d_incr = '0 ; 
  ERROR = '0 ; 
  ERROR_CNT = '0 ;
  re = '0 ;
  we = '0 ;
  raddr = '0 ; 
  waddr = '0 ; 
  wdata = '0 ;
 
  repeat ( 10 ) @ (posedge clk ) ;
  $asserton();

  repeat ( 90 ) @ (posedge clk ) ;
  $display ("TB: @%09tps TEST RF %d %d   Reset Complete",$time,DEPTH,WIDTH );
  clk_rst_b = 'd1 ;
 
  repeat ( 100 ) @ (posedge clk ) ;
  $display ("TB: @%09tps TEST RF %d %d   Enable Clocks",$time,DEPTH,WIDTH );
  rclk_off = 'd0 ;
  wclk_off = 'd0 ;

  $display ("TB: @%09tps TEST RF %d %d   Write Test",$time,DEPTH,WIDTH );
  d_clear = '0 ; 
  @ (posedge clk);
  for ( int i = 0 ; i < DEPTH ; i++ ) begin
    d_incr = '1;
    we = 1'b1 ;
    waddr = i ;
    data_mask = d_rand & MASK ;
    wdata = data_mask ;
    if (VERBOSE == 1'b1 ) begin $display ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x",$time,DEPTH,WIDTH,waddr,wdata ); end
    @ (posedge clk);
  end
  //reset state
  d_clear = '1 ;
  d_incr = '0 ;
  re = '0 ;
  we = '0 ;
  raddr = '0 ;
  waddr = '0 ;
  wdata = '0 ;
  @ (posedge clk);
 
  $display ("TB: @%09tps TEST RF %d %d   Read Test",$time,DEPTH,WIDTH );
  d_clear = '0 ; 
  @ (posedge clk);
  for ( int i = 0 ; i < DEPTH + 1 ; i++ ) begin
    re = 1'b1 ;
    raddr = i ;
    if (raddr >= DEPTH) begin re = 1'b0; end
    @ (posedge clk);
 
    if (re_f) begin 
      data_mask = d_rand & MASK ;
      d_incr = '1;
      if (VERBOSE == 1'b1 ) begin $display ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x obs:0x%x",$time,DEPTH,WIDTH,raddr_f,data_mask,rdata ); end
      if ( data_mask !== rdata ) begin
        ERROR = 1'b1 ;
        ERROR_CNT = ERROR_CNT + 1'b1 ;
        $error ("TB: @%09tps TEST RF %d %d ERROR addr:0x%x exp:0x%x obs:0x%x  %d",$time,DEPTH,WIDTH,raddr_f,data_mask,rdata,ERROR_CNT );
      end 
    end
  end
  //reset state
  d_clear = '1 ;
  d_incr = '0 ;
  re = '0 ;
  we = '0 ;
  raddr = '0 ;
  waddr = '0 ;
  wdata = '0 ;
  @ (posedge clk);
 
  $display ("TB: @%09tps TEST RF %d %d   Write Reverse Test",$time,DEPTH,WIDTH );
  d_clear = '0 ;
  @ (posedge clk);
  for ( int i = 0 ; i < DEPTH ; i++ ) begin
    d_incr = '1;
    we = 1'b1 ;
    waddr = ( DEPTH - 1 ) - i ;
    data_mask = d_rand & MASK ;
    wdata = data_mask ;
    if (VERBOSE == 1'b1 ) begin $display ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x",$time,DEPTH,WIDTH,waddr,wdata ); end
    @ (posedge clk);
  end
  //reset state
  d_clear = '1 ;
  d_incr = '0 ;
  re = '0 ;
  we = '0 ;
  raddr = '0 ;
  waddr = '0 ;
  wdata = '0 ;
  @ (posedge clk);
 
  $display ("TB: @%09tps TEST RF %d %d   Read Reverse Test",$time,DEPTH,WIDTH );
  d_clear = '0 ;
  @ (posedge clk);
  for ( int i = 0 ; i < DEPTH + 1 ; i++ ) begin
    re = 1'b1 ;
    raddr = ( DEPTH - 1 ) - i ;
    if (raddr >= DEPTH) begin re = 1'b0; end
    @ (posedge clk);
 
    if (re_f) begin
      data_mask = d_rand & MASK ;
      d_incr = '1;
      if (VERBOSE == 1'b1 ) begin $display ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x obs:0x%x",$time,DEPTH,WIDTH,raddr_f,data_mask,rdata ); end
      if ( data_mask !== rdata ) begin
        ERROR = 1'b1 ;
        ERROR_CNT = ERROR_CNT + 1'b1 ;
        $error ("TB: @%09tps TEST RF %d %d ERROR addr:0x%x exp:0x%x obs:0x%x  %d",$time,DEPTH,WIDTH,raddr_f,data_mask,rdata,ERROR_CNT );
      end
    end
  end
  //reset state
  d_clear = '1 ;
  d_incr = '0 ;
  re = '0 ;
  we = '0 ;
  raddr = '0 ;
  waddr = '0 ;
  wdata = '0 ;
  @ (posedge clk);

  $display ("TB: @%09tps TEST RF %d %d   Write0 Test",$time,DEPTH,WIDTH );
  d_clear = '0 ;
  @ (posedge clk);
  for ( int i = 0 ; i < DEPTH ; i++ ) begin
    d_incr = '1;
    we = 1'b1 ;
    waddr = i ;
    data_mask = '0 ;
    wdata = data_mask ;
    if (VERBOSE == 1'b1 ) begin $display ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x",$time,DEPTH,WIDTH,waddr,wdata ); end
    @ (posedge clk);
  end
  //reset state
  d_clear = '1 ;
  d_incr = '0 ;
  re = '0 ;
  we = '0 ;
  raddr = '0 ;
  waddr = '0 ;
  wdata = '0 ;
  @ (posedge clk);

  $display ("TB: @%09tps TEST RF %d %d   Read0 Test",$time,DEPTH,WIDTH );
  d_clear = '0 ;
  @ (posedge clk);
  for ( int i = 0 ; i < DEPTH + 1 ; i++ ) begin
    re = 1'b1 ;
    raddr = i ;
    if (raddr >= DEPTH) begin re = 1'b0; end
    @ (posedge clk);

    if (re_f) begin
      data_mask = '0 ;
      d_incr = '1;
      if (VERBOSE == 1'b1 ) begin $display ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x obs:0x%x",$time,DEPTH,WIDTH,raddr_f,data_mask,rdata ); end
      if ( data_mask !== rdata ) begin
        ERROR = 1'b1 ;
        ERROR_CNT = ERROR_CNT + 1'b1 ;
        $error ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x obs:0x%x  %d",$time,DEPTH,WIDTH,raddr_f,data_mask,rdata,ERROR_CNT );
      end
    end
  end
  //reset state
  d_clear = '1 ;
  d_incr = '0 ;
  re = '0 ;
  we = '0 ;
  raddr = '0 ;
  waddr = '0 ;
  wdata = '0 ;
  @ (posedge clk);

  $display ("TB: @%09tps TEST RF %d %d   Write1 Test",$time,DEPTH,WIDTH );
  d_clear = '0 ;
  @ (posedge clk);
  for ( int i = 0 ; i < DEPTH ; i++ ) begin
    d_incr = '1;
    we = 1'b1 ;
    waddr = i ;
    data_mask = '1 ;
    wdata = data_mask ;
    if (VERBOSE == 1'b1 ) begin $display ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x",$time,DEPTH,WIDTH,waddr,wdata ); end
    @ (posedge clk);
  end
  //reset state
  d_clear = '1 ;
  d_incr = '0 ;
  re = '0 ;
  we = '0 ;
  raddr = '0 ;
  waddr = '0 ;
  wdata = '0 ;
  @ (posedge clk);

  $display ("TB: @%09tps TEST RF %d %d   Read1 Test",$time,DEPTH,WIDTH );
  d_clear = '0 ;
  @ (posedge clk);
  for ( int i = 0 ; i < DEPTH + 1 ; i++ ) begin
    re = 1'b1 ;
    raddr = i ;
    if (raddr >= DEPTH) begin re = 1'b0; end
    @ (posedge clk);

    if (re_f) begin
      data_mask = '1 ;
      d_incr = '1;
      if (VERBOSE == 1'b1 ) begin $display ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x obs:0x%x",$time,DEPTH,WIDTH,raddr_f,data_mask,rdata ); end
      if ( data_mask !== rdata ) begin
        ERROR = 1'b1 ;
        ERROR_CNT = ERROR_CNT + 1'b1 ;
        $error ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x obs:0x%x  %d",$time,DEPTH,WIDTH,raddr_f,data_mask,rdata,ERROR_CNT );
      end
    end
  end
  //reset state
  d_clear = '1 ;
  d_incr = '0 ;
  re = '0 ;
  we = '0 ;
  raddr = '0 ;
  waddr = '0 ;
  wdata = '0 ;
  @ (posedge clk);

  $display ("TB: @%09tps TEST RF %d %d   Write5 Test",$time,DEPTH,WIDTH );
  d_clear = '0 ;
  @ (posedge clk);
  for ( int i = 0 ; i < DEPTH ; i++ ) begin
    d_incr = '1;
    we = 1'b1 ;
    waddr = i ;
    data_mask = d_5 & MASK ;
    wdata = data_mask ;
    if (VERBOSE == 1'b1 ) begin $display ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x",$time,DEPTH,WIDTH,waddr,wdata ); end
    @ (posedge clk);
  end
  //reset state
  d_clear = '1 ;
  d_incr = '0 ;
  re = '0 ;
  we = '0 ;
  raddr = '0 ;
  waddr = '0 ;
  wdata = '0 ;
  @ (posedge clk);

  $display ("TB: @%09tps TEST RF %d %d   Read5 Test",$time,DEPTH,WIDTH );
  d_clear = '0 ;
  @ (posedge clk);
  for ( int i = 0 ; i < DEPTH + 1 ; i++ ) begin
    re = 1'b1 ;
    raddr = i ;
    if (raddr >= DEPTH) begin re = 1'b0; end
    @ (posedge clk);

    if (re_f) begin
      data_mask = d_5 & MASK ;
      d_incr = '1;
      if (VERBOSE == 1'b1 ) begin $display ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x obs:0x%x",$time,DEPTH,WIDTH,raddr_f,data_mask,rdata ); end
      if ( data_mask !== rdata ) begin
        ERROR = 1'b1 ;
        ERROR_CNT = ERROR_CNT + 1'b1 ;
        $error ("TB: @%09tps TEST RF %d %d ERROR addr:0x%x exp:0x%x obs:0x%x  %d",$time,DEPTH,WIDTH,raddr_f,data_mask,rdata,ERROR_CNT );
      end
    end
  end
  //reset state
  d_clear = '1 ;
  d_incr = '0 ;
  re = '0 ;
  we = '0 ;
  raddr = '0 ;
  waddr = '0 ;
  wdata = '0 ;
  @ (posedge clk);

  $display ("TB: @%09tps TEST RF %d %d   Writea Test",$time,DEPTH,WIDTH );
  d_clear = '0 ;
  @ (posedge clk);
  for ( int i = 0 ; i < DEPTH ; i++ ) begin
    d_incr = '1;
    we = 1'b1 ;
    waddr = i ;
    data_mask = d_a & MASK ;
    wdata = data_mask ;
    if (VERBOSE == 1'b1 ) begin $display ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x",$time,DEPTH,WIDTH,waddr,wdata ); end
    @ (posedge clk);
  end
  //reset state
  d_clear = '1 ;
  d_incr = '0 ;
  re = '0 ;
  we = '0 ;
  raddr = '0 ;
  waddr = '0 ;
  wdata = '0 ;
  @ (posedge clk);

  $display ("TB: @%09tps TEST RF %d %d   Reada Test",$time,DEPTH,WIDTH );
  d_clear = '0 ;
  @ (posedge clk);
  for ( int i = 0 ; i < DEPTH + 1 ; i++ ) begin
    re = 1'b1 ;
    raddr = i ;
    if (raddr >= DEPTH) begin re = 1'b0; end
    @ (posedge clk);

    if (re_f) begin
      data_mask = d_a & MASK ;
      d_incr = '1;
      if (VERBOSE == 1'b1 ) begin $display ("TB: @%09tps TEST RF %d %d addr:0x%x exp:0x%x obs:0x%x",$time,DEPTH,WIDTH,raddr_f,data_mask,rdata ); end
      if ( data_mask !== rdata ) begin
        ERROR = 1'b1 ;
        ERROR_CNT = ERROR_CNT + 1'b1 ;
        $error ("TB: @%09tps TEST RF %d %d ERROR addr:0x%x exp:0x%x obs:0x%x  %d",$time,DEPTH,WIDTH,raddr_f,data_mask,rdata,ERROR_CNT );
      end
    end
  end
  //reset state
  d_clear = '1 ;
  d_incr = '0 ;
  re = '0 ;
  we = '0 ;
  raddr = '0 ;
  waddr = '0 ;
  wdata = '0 ;
  @ (posedge clk);

  if (ERROR) begin 
      $fatal ("TB: @%09tps TEST RF %d %d   Status: FAIL ",$time,DEPTH,WIDTH);
  end 
  else begin
      $display ("TB: @%09tps TEST RF %d %d   Status: PASS ",$time,DEPTH,WIDTH);
  end
 
  $display ("TB: @%09tps TEST RF %d %d   End total_ERROR:%-d ",$time,DEPTH,WIDTH,ERROR_CNT );
  repeat ( 100 ) @ (posedge clk ) ;
 
  $finish ;
end

always_ff @(posedge clk or negedge clk_rst_b ) begin
  if ( ~ clk_rst_b ) begin
    d_f <= '0 ;
    re_f <= '0 ;
    raddr_f <= '0 ;
  end else begin
    d_f <= d_nxt ;
    re_f <= re ;
    raddr_f <= raddr ;
  end
end
always_comb begin
   d_nxt = d_f + d_incr ; 
   if (d_clear) begin d_nxt = 0 ;end
   d_rand32[0] = d_nxt[0] ^ d_nxt[6] ^ d_nxt[9] ^ d_nxt[10] ^ d_nxt[12] ^ d_nxt[16] ^ d_nxt[24] ^ d_nxt[25] ^ d_nxt[26] ^ d_nxt[28] ^ d_nxt[29] ^ d_nxt[30] ^ d_nxt[31] ;
   d_rand32[1] = d_nxt[0] ^ d_nxt[1] ^ d_nxt[6] ^ d_nxt[7] ^ d_nxt[9] ^ d_nxt[11] ^ d_nxt[12] ^ d_nxt[13] ^ d_nxt[16] ^ d_nxt[17] ^ d_nxt[24] ^ d_nxt[27] ^ d_nxt[28] ;
   d_rand32[2] = d_nxt[0] ^ d_nxt[1] ^ d_nxt[2] ^ d_nxt[6] ^ d_nxt[7] ^ d_nxt[8] ^ d_nxt[9] ^ d_nxt[13] ^ d_nxt[14] ^ d_nxt[16] ^ d_nxt[17] ^ d_nxt[18] ^ d_nxt[24] ^ d_nxt[26] ^ d_nxt[30] ^ d_nxt[31] ;
   d_rand32[3] = d_nxt[1] ^ d_nxt[2] ^ d_nxt[3] ^ d_nxt[7] ^ d_nxt[8] ^ d_nxt[9] ^ d_nxt[10] ^ d_nxt[14] ^ d_nxt[15] ^ d_nxt[17] ^ d_nxt[18] ^ d_nxt[19] ^ d_nxt[25] ^ d_nxt[27] ^ d_nxt[31] ;
   d_rand32[4] = d_nxt[0] ^ d_nxt[2] ^ d_nxt[3] ^ d_nxt[4] ^ d_nxt[6] ^ d_nxt[8] ^ d_nxt[11] ^ d_nxt[12] ^ d_nxt[15] ^ d_nxt[18] ^ d_nxt[19] ^ d_nxt[20] ^ d_nxt[24] ^ d_nxt[25] ^ d_nxt[29] ^ d_nxt[30] ^ d_nxt[31] ;
   d_rand32[5] = d_nxt[0] ^ d_nxt[1] ^ d_nxt[3] ^ d_nxt[4] ^ d_nxt[5] ^ d_nxt[6] ^ d_nxt[7] ^ d_nxt[10] ^ d_nxt[13] ^ d_nxt[19] ^ d_nxt[20] ^ d_nxt[21] ^ d_nxt[24] ^ d_nxt[28] ^ d_nxt[29] ;
   d_rand32[6] = d_nxt[1] ^ d_nxt[2] ^ d_nxt[4] ^ d_nxt[5] ^ d_nxt[6] ^ d_nxt[7] ^ d_nxt[8] ^ d_nxt[11] ^ d_nxt[14] ^ d_nxt[20] ^ d_nxt[21] ^ d_nxt[22] ^ d_nxt[25] ^ d_nxt[29] ^ d_nxt[30] ;
   d_rand32[7] = d_nxt[0] ^ d_nxt[2] ^ d_nxt[3] ^ d_nxt[5] ^ d_nxt[7] ^ d_nxt[8] ^ d_nxt[10] ^ d_nxt[15] ^ d_nxt[16] ^ d_nxt[21] ^ d_nxt[22] ^ d_nxt[23] ^ d_nxt[24] ^ d_nxt[25] ^ d_nxt[28] ^ d_nxt[29] ;
   d_rand32[8] = d_nxt[0] ^ d_nxt[1] ^ d_nxt[3] ^ d_nxt[4] ^ d_nxt[8] ^ d_nxt[10] ^ d_nxt[11] ^ d_nxt[12] ^ d_nxt[17] ^ d_nxt[22] ^ d_nxt[23] ^ d_nxt[28] ^ d_nxt[31] ;
   d_rand32[9] = d_nxt[1] ^ d_nxt[2] ^ d_nxt[4] ^ d_nxt[5] ^ d_nxt[9] ^ d_nxt[11] ^ d_nxt[12] ^ d_nxt[13] ^ d_nxt[18] ^ d_nxt[23] ^ d_nxt[24] ^ d_nxt[29] ;
   d_rand32[10] = d_nxt[0] ^ d_nxt[2] ^ d_nxt[3] ^ d_nxt[5] ^ d_nxt[9] ^ d_nxt[13] ^ d_nxt[14] ^ d_nxt[16] ^ d_nxt[19] ^ d_nxt[26] ^ d_nxt[28] ^ d_nxt[29] ^ d_nxt[31] ;
   d_rand32[11] = d_nxt[0] ^ d_nxt[1] ^ d_nxt[3] ^ d_nxt[4] ^ d_nxt[9] ^ d_nxt[12] ^ d_nxt[14] ^ d_nxt[15] ^ d_nxt[16] ^ d_nxt[17] ^ d_nxt[20] ^ d_nxt[24] ^ d_nxt[25] ^ d_nxt[26] ^ d_nxt[27] ^ d_nxt[28] ^ d_nxt[31] ;
   d_rand32[12] = d_nxt[0] ^ d_nxt[1] ^ d_nxt[2] ^ d_nxt[4] ^ d_nxt[5] ^ d_nxt[6] ^ d_nxt[9] ^ d_nxt[12] ^ d_nxt[13] ^ d_nxt[15] ^ d_nxt[17] ^ d_nxt[18] ^ d_nxt[21] ^ d_nxt[24] ^ d_nxt[27] ^ d_nxt[30] ^ d_nxt[31] ;
   d_rand32[13] = d_nxt[1] ^ d_nxt[2] ^ d_nxt[3] ^ d_nxt[5] ^ d_nxt[6] ^ d_nxt[7] ^ d_nxt[10] ^ d_nxt[13] ^ d_nxt[14] ^ d_nxt[16] ^ d_nxt[18] ^ d_nxt[19] ^ d_nxt[22] ^ d_nxt[25] ^ d_nxt[28] ^ d_nxt[31] ;
   d_rand32[14] = d_nxt[2] ^ d_nxt[3] ^ d_nxt[4] ^ d_nxt[6] ^ d_nxt[7] ^ d_nxt[8] ^ d_nxt[11] ^ d_nxt[14] ^ d_nxt[15] ^ d_nxt[17] ^ d_nxt[19] ^ d_nxt[20] ^ d_nxt[23] ^ d_nxt[26] ^ d_nxt[29] ;
   d_rand32[15] = d_nxt[3] ^ d_nxt[4] ^ d_nxt[5] ^ d_nxt[7] ^ d_nxt[8] ^ d_nxt[9] ^ d_nxt[12] ^ d_nxt[15] ^ d_nxt[16] ^ d_nxt[18] ^ d_nxt[20] ^ d_nxt[21] ^ d_nxt[24] ^ d_nxt[27] ^ d_nxt[30] ;
   d_rand32[16] = d_nxt[0] ^ d_nxt[4] ^ d_nxt[5] ^ d_nxt[8] ^ d_nxt[12] ^ d_nxt[13] ^ d_nxt[17] ^ d_nxt[19] ^ d_nxt[21] ^ d_nxt[22] ^ d_nxt[24] ^ d_nxt[26] ^ d_nxt[29] ^ d_nxt[30] ;
   d_rand32[17] = d_nxt[1] ^ d_nxt[5] ^ d_nxt[6] ^ d_nxt[9] ^ d_nxt[13] ^ d_nxt[14] ^ d_nxt[18] ^ d_nxt[20] ^ d_nxt[22] ^ d_nxt[23] ^ d_nxt[25] ^ d_nxt[27] ^ d_nxt[30] ^ d_nxt[31] ;
   d_rand32[18] = d_nxt[2] ^ d_nxt[6] ^ d_nxt[7] ^ d_nxt[10] ^ d_nxt[14] ^ d_nxt[15] ^ d_nxt[19] ^ d_nxt[21] ^ d_nxt[23] ^ d_nxt[24] ^ d_nxt[26] ^ d_nxt[28] ^ d_nxt[31] ;
   d_rand32[19] = d_nxt[3] ^ d_nxt[7] ^ d_nxt[8] ^ d_nxt[11] ^ d_nxt[15] ^ d_nxt[16] ^ d_nxt[20] ^ d_nxt[22] ^ d_nxt[24] ^ d_nxt[25] ^ d_nxt[27] ^ d_nxt[29] ;
   d_rand32[20] = d_nxt[4] ^ d_nxt[8] ^ d_nxt[9] ^ d_nxt[12] ^ d_nxt[16] ^ d_nxt[17] ^ d_nxt[21] ^ d_nxt[23] ^ d_nxt[25] ^ d_nxt[26] ^ d_nxt[28] ^ d_nxt[30] ;
   d_rand32[21] = d_nxt[5] ^ d_nxt[9] ^ d_nxt[10] ^ d_nxt[13] ^ d_nxt[17] ^ d_nxt[18] ^ d_nxt[22] ^ d_nxt[24] ^ d_nxt[26] ^ d_nxt[27] ^ d_nxt[29] ^ d_nxt[31] ;
   d_rand32[22] = d_nxt[0] ^ d_nxt[9] ^ d_nxt[11] ^ d_nxt[12] ^ d_nxt[14] ^ d_nxt[16] ^ d_nxt[18] ^ d_nxt[19] ^ d_nxt[23] ^ d_nxt[24] ^ d_nxt[26] ^ d_nxt[27] ^ d_nxt[29] ^ d_nxt[31] ;
   d_rand32[23] = d_nxt[0] ^ d_nxt[1] ^ d_nxt[6] ^ d_nxt[9] ^ d_nxt[13] ^ d_nxt[15] ^ d_nxt[16] ^ d_nxt[17] ^ d_nxt[19] ^ d_nxt[20] ^ d_nxt[26] ^ d_nxt[27] ^ d_nxt[29] ^ d_nxt[31] ;
   d_rand32[24] = d_nxt[1] ^ d_nxt[2] ^ d_nxt[7] ^ d_nxt[10] ^ d_nxt[14] ^ d_nxt[16] ^ d_nxt[17] ^ d_nxt[18] ^ d_nxt[20] ^ d_nxt[21] ^ d_nxt[27] ^ d_nxt[28] ^ d_nxt[30] ;
   d_rand32[25] = d_nxt[2] ^ d_nxt[3] ^ d_nxt[8] ^ d_nxt[11] ^ d_nxt[15] ^ d_nxt[17] ^ d_nxt[18] ^ d_nxt[19] ^ d_nxt[21] ^ d_nxt[22] ^ d_nxt[28] ^ d_nxt[29] ^ d_nxt[31] ;
   d_rand32[26] = d_nxt[0] ^ d_nxt[3] ^ d_nxt[4] ^ d_nxt[6] ^ d_nxt[10] ^ d_nxt[18] ^ d_nxt[19] ^ d_nxt[20] ^ d_nxt[22] ^ d_nxt[23] ^ d_nxt[24] ^ d_nxt[25] ^ d_nxt[26] ^ d_nxt[28] ^ d_nxt[31] ;
   d_rand32[27] = d_nxt[1] ^ d_nxt[4] ^ d_nxt[5] ^ d_nxt[7] ^ d_nxt[11] ^ d_nxt[19] ^ d_nxt[20] ^ d_nxt[21] ^ d_nxt[23] ^ d_nxt[24] ^ d_nxt[25] ^ d_nxt[26] ^ d_nxt[27] ^ d_nxt[29] ;
   d_rand32[28] = d_nxt[2] ^ d_nxt[5] ^ d_nxt[6] ^ d_nxt[8] ^ d_nxt[12] ^ d_nxt[20] ^ d_nxt[21] ^ d_nxt[22] ^ d_nxt[24] ^ d_nxt[25] ^ d_nxt[26] ^ d_nxt[27] ^ d_nxt[28] ^ d_nxt[30] ;
   d_rand32[29] = d_nxt[3] ^ d_nxt[6] ^ d_nxt[7] ^ d_nxt[9] ^ d_nxt[13] ^ d_nxt[21] ^ d_nxt[22] ^ d_nxt[23] ^ d_nxt[25] ^ d_nxt[26] ^ d_nxt[27] ^ d_nxt[28] ^ d_nxt[29] ^ d_nxt[31] ;
   d_rand32[30] = d_nxt[4] ^ d_nxt[7] ^ d_nxt[8] ^ d_nxt[10] ^ d_nxt[14] ^ d_nxt[22] ^ d_nxt[23] ^ d_nxt[24] ^ d_nxt[26] ^ d_nxt[27] ^ d_nxt[28] ^ d_nxt[29] ^ d_nxt[30] ;
   d_rand32[31] = d_nxt[5] ^ d_nxt[8] ^ d_nxt[9] ^ d_nxt[11] ^ d_nxt[15] ^ d_nxt[23] ^ d_nxt[24] ^ d_nxt[25] ^ d_nxt[27] ^ d_nxt[28] ^ d_nxt[29] ^ d_nxt[30] ^ d_nxt[31] ;
   d_rand={32{d_rand32}};
   d_5={256{4'h5}};
   d_a={256{4'ha}};
end

endmodule
