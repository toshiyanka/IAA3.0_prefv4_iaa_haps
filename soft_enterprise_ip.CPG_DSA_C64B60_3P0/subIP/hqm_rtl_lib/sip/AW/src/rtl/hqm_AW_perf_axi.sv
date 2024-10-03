module hqm_AW_perf_axi (
 input wire clk
,input wire rst_n
,input wire valid
,input wire ready
);

reg [(1)-1:0] valid_nxt; reg [(1)-1:0] valid_f;
reg [(1)-1:0] ready_nxt; reg [(1)-1:0] ready_f;

reg [(1)-1:0] on_nxt; reg [(1)-1:0] on_f;

reg [(32)-1:0] timer_nxt; reg [(32)-1:0] timer_f;
reg [(32)-1:0] timer_timer_nxt; reg [(32)-1:0] timer_timer_f;

reg [(32)-1:0] ready_high_nxt; reg [(32)-1:0] ready_high_f;
reg [(32)-1:0] ready_low_nxt; reg [(32)-1:0] ready_low_f;
reg [(32*100)-1:0] ready_dist_nxt; reg [(32*100)-1:0] ready_dist_f;
reg [(32)-1:0] ready_dist_timer_nxt; reg [(32)-1:0] ready_dist_timer_f;
reg [(1)-1:0] ready_dist_toggle_nxt; reg [(1)-1:0] ready_dist_toggle_f;

reg [(32)-1:0] rav_high_nxt; reg [(32)-1:0] rav_high_f;
reg [(32)-1:0] rav_low_nxt; reg [(32)-1:0] rav_low_f;
reg [(32*100)-1:0] rav_dist_nxt; reg [(32*100)-1:0] rav_dist_f;
reg [(32)-1:0] rav_dist_timer_nxt; reg [(32)-1:0] rav_dist_timer_f;
reg [(1)-1:0] rav_dist_toggle_nxt; reg [(1)-1:0] rav_dist_toggle_f;

always_ff @(posedge clk) begin
  if (~rst_n) begin
    valid_f<=0;
    ready_f<=0;
    on_f<=0;
    timer_f<=0;
    timer_timer_f<=0;
    ready_high_f<=0;
    ready_low_f<=0;
    ready_dist_f<=0;
    ready_dist_timer_f<=0;
    ready_dist_toggle_f<=0;
    rav_high_f<=0;
    rav_low_f<=0;
    rav_dist_f<=0;
    rav_dist_timer_f<=0;
    rav_dist_toggle_f<=0;
  end
  else begin
    valid_f<=valid_nxt;
    ready_f<=ready_nxt;
    on_f<=on_nxt;
    timer_f<=timer_nxt;
    timer_timer_f<=timer_timer_nxt;
    ready_high_f<=ready_high_nxt;
    ready_low_f<=ready_low_nxt;
    ready_dist_f<=ready_dist_nxt;
    ready_dist_timer_f<=ready_dist_timer_nxt;
    ready_dist_toggle_f<=ready_dist_toggle_nxt;
    rav_high_f<=rav_high_nxt;
    rav_low_f<=rav_low_nxt;
    rav_dist_f<=rav_dist_nxt;
    rav_dist_timer_f<=rav_dist_timer_nxt;
    rav_dist_toggle_f<=rav_dist_toggle_nxt;
  end
end

always_comb begin
  valid_nxt=valid;
  ready_nxt=ready;
  on_nxt=on_f;
  timer_nxt=timer_f;
  timer_timer_nxt=timer_timer_f;
  ready_high_nxt=ready_high_f;
  ready_low_nxt=ready_low_f;
  ready_dist_nxt=ready_dist_f;
  ready_dist_timer_nxt=ready_dist_timer_f;
  ready_dist_toggle_nxt=ready_dist_toggle_f;
  rav_high_nxt=rav_high_f;
  rav_low_nxt=rav_low_f;
  rav_dist_nxt=rav_dist_f;
  rav_dist_timer_nxt=rav_dist_timer_f;
  rav_dist_toggle_nxt=rav_dist_toggle_f;

  if ( (on_f==1'd0) & (valid_f==1'd1) & (ready_f==1'd1) ) begin on_nxt=1'd1; ready_dist_nxt[(0)*32+:32]=ready_dist_nxt[(0)*32+:32]+1'd1; rav_dist_nxt[(0)*32+:32]=rav_dist_nxt[(0)*32+:32]+1'd1;  end

  if ( (on_nxt==1'd1) ) begin

    if ( (ready_f==1'd1) ) begin ready_high_nxt=ready_high_nxt+1'd1; end else begin ready_low_nxt=ready_low_nxt+1'd1; end
    ready_dist_timer_nxt=ready_dist_timer_nxt+1'd1;
    if ( (ready_dist_toggle_f==1'd1) & (ready_f==1'd1) ) begin
      ready_dist_toggle_nxt=1'd0;
      if (ready_dist_timer_f > 32'd99) begin ready_dist_nxt[(99)*32+:32]=ready_dist_nxt[(99)*32+:32]+1'd1; end else begin ready_dist_nxt[(ready_dist_timer_f)*32+:32]=ready_dist_nxt[(ready_dist_timer_f)*32+:32]+1'd1; end
    end
    if ( (valid_f==1'd1) & (ready_f==1'd1) ) begin
      ready_dist_toggle_nxt=1'd1;
      ready_dist_timer_nxt=32'd0;
    end

    timer_timer_nxt=timer_timer_nxt+1'd1;
    if ( (valid_f==1'd1) & (ready_f==1'd1) ) begin
      timer_timer_nxt = 32'd1;
      timer_nxt = timer_nxt + timer_timer_f;
    end

    if ( (valid_f==1'd1) & (ready_f==1'd1) ) begin rav_high_nxt=rav_high_nxt+1'd1; end 
    if ( (valid_f==1'd1) & (ready_f==1'd0) ) begin rav_low_nxt=rav_low_nxt+1'd1; end

    rav_dist_timer_nxt=rav_dist_timer_nxt+1'd1;
    if ( (rav_dist_toggle_f==1'd1) & (valid_f==1'd1) & (ready_f==1'd1) ) begin
      rav_dist_toggle_nxt=1'd0;
      if (rav_dist_timer_f > 32'd99) begin rav_dist_nxt[(99)*32+:32]=rav_dist_nxt[(99)*32+:32]+1'd1; end else begin rav_dist_nxt[(rav_dist_timer_f)*32+:32]=rav_dist_nxt[(rav_dist_timer_f)*32+:32]+1'd1; end
    end
    if ( (valid_f==1'd1) & (ready_f==1'd1) ) begin
      rav_dist_toggle_nxt=1'd1;
      rav_dist_timer_nxt=32'd0;
    end

  end
end

integer XI;
final begin
if ( on_f ) begin
$display( "perf_axi  %m ---------------------------------------------------------------------------------------------------- ");
$display( "perf_axi  %m ready = 1 & valid = 1   : %d %d ",rav_high_f,timer_f);
$display( "perf_axi  %m ready = 0 & valid = 1   : %d %d ",rav_low_f,timer_f);
////$display( "perf_axi  %m ready = 1               : %d",ready_high_f);
////$display( "perf_axi  %m ready = 0               : %d",ready_low_f);
//for (XI=0; XI<100; XI=XI+1)  begin
//$display( "perf_axi  %m ready & valid  dist %03d : %d",XI,rav_dist_f[XI*32+:32]);
//end
//$display( "perf_axi  %m ");
//for (XI=0; XI<100; XI=XI+1)  begin
//$display( "perf_axi  %m ready          dist %03d : %d",XI,ready_dist_f[XI*32+:32]);
//end
//$display( "perf_axi  %m ");
end
end
endmodule
