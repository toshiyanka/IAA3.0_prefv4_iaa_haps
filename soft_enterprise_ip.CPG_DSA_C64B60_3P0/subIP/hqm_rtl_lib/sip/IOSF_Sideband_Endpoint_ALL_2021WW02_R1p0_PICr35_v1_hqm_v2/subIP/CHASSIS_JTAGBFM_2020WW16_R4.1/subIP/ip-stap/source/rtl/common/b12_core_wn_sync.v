`ifdef no_unit_delay
	`define cell_delay_value 
	`define mux_assign_type =
	`define seq_delay_value 
`elsif seq_unit_delay 
	`define cell_delay_value 
	`define mux_assign_type =
	`define seq_delay_value #1
`else	`define cell_delay_value #1
	`define seq_delay_value #1
	`define mux_assign_type <=
`endif

module b12mas2wnx10 (ck, d, rb, si, ss, so, o, vcc);
  input  vcc, ck, d, rb, si, ss;
  output so, o;
  reg notifier; 
  reg  o1, o2;
   

  // behavioral representation of pin 'o1', output pin 'o'
  // sequential pin function: if not(rb) then val0 else (si*ss+d*!ss) on rising ck
  // sequential pin function: if not(rb) then val0 else (d) on rising ck
`ifdef functional
    //assign d_in =(((~ss) & ~d) | (ss & ~si)) ; 
  always @ (negedge (rb) or posedge ck)
  if (~(rb)) 
   begin
    o1 <= `seq_delay_value 1'b1;
    o2 <= `seq_delay_value 1'b1;
   end
  else
   begin
       
      o1<= `seq_delay_value (((~ss) & ~d) | (ss & ~si)) ;     
       o2 <= `seq_delay_value o1;
   end
  // behavioral representation of output pin 'so'
  // pin function: output o or ss inverted
  assign so = ~(o2 & (ss));
  assign o = ~o2;
`else
  buf b_ck (ck_buf,delay_ck);
  buf b_d (d_buf,delay_d);
  buf b_rb (rb_buf,delay_rb);
  buf b_si (si_buf,delay_si);
  buf b_ss (ss_buf,delay_ss);
  
  always @ (negedge (rb_buf) or posedge ck_buf)
  if (~(rb_buf)) 
   begin
    o1 <= 1'b1;
    o2 <= 1'b1;
   end
  else
   begin
        
      o1 <= (((~ss_buf) & ~d_buf) |  (ss_buf & ~si_buf) );    
      o2 <= o1;
   end
  // behavioral representation of output pin 'so'
  // pin function: output o or ss inverted
  assign so = ~(o2 & (ss_buf));
  assign o = ~o2;

specify
// parameter declarations
specparam delay_ck_o_01_19=0.01, delay_ck_o_01_21=0.01, delay_ck_o_10_20=0.01, delay_ck_o_10_22=0.01, delay_rb_o_10_23=0.01, delay_rb_so_10_24=0.01,delay_ck_so_01_18=0.0, delay_ck_so_10_19=0.0,delay_ck_so_01_16=0.0, delay_ck_so_10_17=0.0, t_pulse_ck_negedge_1=0.0, t_pulse_ck_posedge_0=0.0, t_pulse_rb_negedge_2=0.0,t_pulse_rb_posedge_1=0.0, thold_ck_posedge_d_negedge_6=0.0, thold_ck_posedge_d_posedge_4=0.0, thold_ck_posedge_rb_posedge_8=0.0, thold_ck_posedge_si_negedge_14=0.0, thold_ck_posedge_si_posedge_12=0.0, thold_ck_posedge_ss_negedge_18=0.0, thold_ck_posedge_ss_posedge_16=0.0, tsetup_d_negedge_ck_posedge_5=0.0, tsetup_d_posedge_ck_posedge_3=0.0, tsetup_rb_posedge_ck_posedge_7=0.0, tsetup_si_negedge_ck_posedge_13=0.0, tsetup_si_posedge_ck_posedge_11=0.0, tsetup_ss_negedge_ck_posedge_17=0.0, tsetup_ss_posedge_ck_posedge_15=0.0, delay_ss_so_01_24=0.0, delay_ss_so_10_25=0.0 ;


$setuphold (posedge ck, negedge d, tsetup_d_negedge_ck_posedge_5, thold_ck_posedge_d_negedge_6, notifier,,,delay_ck, delay_d);

$setuphold (posedge ck, negedge si, tsetup_si_negedge_ck_posedge_13, thold_ck_posedge_si_negedge_14, notifier,,,delay_ck, delay_si);

$setuphold (posedge ck, negedge ss, tsetup_ss_negedge_ck_posedge_17, thold_ck_posedge_ss_negedge_18, notifier,,,delay_ck, delay_ss);

$setuphold (posedge ck, posedge d, tsetup_d_posedge_ck_posedge_3, thold_ck_posedge_d_posedge_4, notifier,,,delay_ck, delay_d);

$recrem (posedge rb, posedge ck, tsetup_rb_posedge_ck_posedge_7, thold_ck_posedge_rb_posedge_8, notifier,,,delay_rb, delay_ck);

$setuphold (posedge ck, posedge si, tsetup_si_posedge_ck_posedge_11, thold_ck_posedge_si_posedge_12, notifier,,,delay_ck, delay_si);

$setuphold (posedge ck, posedge ss, tsetup_ss_posedge_ck_posedge_15, thold_ck_posedge_ss_posedge_16, notifier,,,delay_ck, delay_ss);

$width (negedge ck, t_pulse_ck_negedge_1, 0, notifier);

$width (negedge rb, t_pulse_rb_negedge_2, 0, notifier);

$width (posedge ck, t_pulse_ck_posedge_0, 0, notifier);

$width (posedge rb, t_pulse_rb_posedge_1, 0, notifier);

(rb *> o) = (0.0, delay_rb_o_10_23);
(rb *> so) = (0.0, delay_rb_so_10_24);
   
if ((ss == 1'b0))
    (ck *> o) = (delay_ck_o_01_19, delay_ck_o_10_20);
if ((ss==1'b1))
    (ck +*> so) = (delay_ck_so_01_18, delay_ck_so_10_19);

ifnone (ck *> o) = (delay_ck_o_01_21, delay_ck_o_10_22);
ifnone (ck *> so) = (delay_ck_so_01_16, delay_ck_so_10_17);

(ss -*> so) = (delay_ss_so_01_24, delay_ss_so_10_25);

   
endspecify
`endif
endmodule



module b12ma12wnd3 (ck, db, rb, o, vcc);
  input  vcc, ck, db, rb;
  output o;
  reg notifier; 
  reg o1;

  // behavioral representation of output pin 'o'
  // sequential pin function: if not(rb) then val0 else (db) on rising ck
`ifdef functional
  always @ (negedge (rb) or posedge ck)
  if (~(rb)) 
    o1 <= `seq_delay_value 1'b1;
  else
    o1 <= `seq_delay_value (db);
          assign  o = (~o1);
`else
  buf b_ck (ck_buf,delay_ck);
  buf b_db (db_buf,delay_db);
  buf b_rb (rb_buf,delay_rb);
  always @ (negedge (rb_buf) or posedge ck_buf)
  if (~(rb_buf)) 
      o1 <= 1'b1;
  else
          o1 <= (db_buf);
          assign  o = (~o1);
specify
// parameter declarations
specparam delay_ck_o_01_7=0.01, delay_ck_o_10_8=0.01, delay_rb_o_10_6=0.01, thold_ck_posedge_db_negedge_3=0.0, thold_ck_posedge_db_posedge_1=0.0, thold_ck_posedge_rb_posedge_5=0.0, tsetup_db_negedge_ck_posedge_2=0.0, tsetup_db_posedge_ck_posedge_0=0.0, tsetup_rb_posedge_ck_posedge_4=0.0, t_pulse_ck_posedge_1=0.0,t_pulse_ck_negedge_2=0.0, t_pulse_rb_negedge_3=0.0;


$recrem (posedge rb, posedge ck,tsetup_rb_posedge_ck_posedge_4, thold_ck_posedge_rb_posedge_5, notifier,,,delay_rb, delay_ck);

$setuphold (posedge ck, negedge db, tsetup_db_negedge_ck_posedge_2, thold_ck_posedge_db_negedge_3, notifier,,,delay_ck, delay_db);

$setuphold (posedge ck, posedge db, tsetup_db_posedge_ck_posedge_0, thold_ck_posedge_db_posedge_1, notifier,,,delay_ck, delay_db);

(ck *> o) = (delay_ck_o_01_7, delay_ck_o_10_8);


(rb *> o) = (0.0, delay_rb_o_10_6);

$width (posedge ck, t_pulse_ck_posedge_1, 0, notifier);

$width (negedge ck, t_pulse_ck_negedge_2, 0, notifier);

$width (negedge rb, t_pulse_rb_negedge_3, 0, notifier);  

endspecify
`endif
endmodule

