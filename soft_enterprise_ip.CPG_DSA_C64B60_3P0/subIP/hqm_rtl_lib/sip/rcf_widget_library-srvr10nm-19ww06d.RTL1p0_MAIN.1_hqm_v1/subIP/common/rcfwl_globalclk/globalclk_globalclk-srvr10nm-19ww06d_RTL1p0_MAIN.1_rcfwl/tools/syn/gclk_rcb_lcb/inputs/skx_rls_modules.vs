// ##########################################################################
// # Intel Top Secret
// ###########################################################################
// # Copyright (C) 2011, Intel Corporation. All rights reserved.
// #
// # This is the property of Intel Corporation and may only be utilized pursuant to a written
// # Restricted Use Nondisclosure Agreement with Intel Corporation. It may not be used,
// # reproduced, or disclosed to others except in accordance with the terms and
// # conditions of such agreement
// ##########################################################################
// #
// # File        : skx_rls_modules.vs  
// #
// # Description : Server mappings for modules referenced in macros 
// #
// # Inputs      :
// #
// # Returns     : n/a
// #
// # Note        :
// #
// # Owner       : Michael Brown (michael.j.brown@intel.com)
// #
// # Last Updated: 10/18/13
// #
// ##########################################################################

`ifndef SKX_RLS_MODULES
`define SKX_RLS_MODULES

`ifdef USE_LL_CLOCK
    `ifdef USE_RBCX
        `define RBC_CELL ec0crb0a2al1n05x5
    `else
        `define RBC_CELL ec0crb0a2al1n05x5
    `endif
	`define BFC_CELL ec0cbf000al1n05x5
	`define NAC_CELL ec0cnan02al1n05x5 
	`define INC_CELL ec0cinv00al1n05x5
	`define LBC_CELL ec0clb0a2al1n05x5 
`else
    `ifdef USE_RBC01
       `define RBC_CELL ec0crb0o2al1n05x5
    `else
       `ifdef USE_RBCX
          `define RBC_CELL ec0crb1a2al1d05x5
       `else
          `define RBC_CELL ec0crb0a2al1n05x5
       `endif
    `endif
	`define BFC_CELL ec0cbf000al1n05x5
	`define NAC_CELL ec0cnan02al1n05x5 
	`define INC_CELL ec0cinv00al1n05x5
	`define LBC_CELL ec0clb0a2al1n05x5 
`endif


module rls_and2ori_latch_mod (input bit da, input bit db, input bit dc, input bit dd, input bit clk, output bit o);

 ec0lsn000al1n05x5 rls_temp_macro_name (.d(~((dd&dc)|(db&da))), .clk(clk), .o(o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_aoi_latch_mod (input bit da, input bit db, input bit dc, input bit clk, output bit o);

 ec0lsn000al1n05x5 rls_temp_macro_name (.d(~(da|(db&dc))), .clk(clk), .o(o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_async_rst_latch_p_mod (input bit d, input bit clk, input bit rst, output bit o);

 ec0lan083al1n05x5 rls_temp_macro_name (.clkb(clk),.d(d),.rb(~rst),.o(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true */

endmodule 
module rls_async_rst_msff_mod (input bit d, input bit clk, input bit rst, output bit o);

  ec0fan003al1n05x5 rls_temp_macro_name (.clk(clk),.d(d),.rb(~rst),.o(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true */

endmodule 
module rls_async_rstd_msff_mod (input bit d, input bit clk, input bit rst, input bit rstd, output bit o);

  bit qual_rst;
  bit qual_set;

  always_comb begin
     qual_rst = rst & (~rstd);
     qual_set = rst & (rstd);
  end

  ec0fan07bal1d05x5 rls_temp_macro_name (.clk(clk),.d(~d),.rb(~qual_rst),.enb(1'b0),.s(qual_set),.o1(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true */

endmodule 
module rls_async_set_msff_mod (input bit d, input bit clk, input bit set, output bit o);

 ec0fan008al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .s(set), .o(o)); 

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true */
endmodule 
module rls_async_set_rst_msff_mod (input bit d, input bit clk, input bit rst, input bit set, output bit o);

  ec0fan07bal1d05x5 rls_temp_macro_name (.clk(clk),.d(~d),.rb(~rst),.enb(1'b0),.s(set),.o1(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true */

endmodule 

module rls_bfc_mod (input bit clk, output bit o);

  `BFC_CELL rls_temp_macro_name (.clk(clk), .clkout(o)); 

endmodule 
module rls_biginv_mod (output bit out, input bit in);

    ec0inv000al1n05x5 rls_temp_macro_name (.o1(out),.a(in));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_buf_keep_nets_in_mod (output bit out, input bit in);

  ec0bfn000al1n05x5 rls_temp_macro_name (.o(out),.a(in));

  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_pins rls_temp_macro_name/a ] -type string dcsv_dont_touch_pin_net true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_buf_keep_nets_mod (output bit out, input bit in);

  ec0bfn000al1n05x5 rls_temp_macro_name (.o(out),.a(in));

  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_pins rls_temp_macro_name/a ] -type string dcsv_dont_touch_pin_net true
    set_attribute [ get_pins rls_temp_macro_name/o ] -type string dcsv_dont_touch_pin_net true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_buf_keep_nets_out_mod (output bit out, input bit in);

  ec0bfn000al1n05x5 rls_temp_macro_name (.o(out),.a(in));

  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_pins rls_temp_macro_name/o ] -type string dcsv_dont_touch_pin_net true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_buf_mod (output bit out, input bit in);

  ec0bfn000al1n05x5 rls_temp_macro_name (.o(out),.a(in));

  // set attribute del_unloaded_gate_off to false, so the cell is pruned by RLS if its dangling

  /* synopsys dc_tcl_script_begin
    set_size_only [ get_cells rls_temp_macro_name ]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] del_unloaded_gate_off false */

endmodule


module rls_clk_msff_mod (input bit i_pin, input bit clock_pin, output bit q_pin);

  ec0cfsn00al1n05x5 rls_temp_macro_name (.d((i_pin)), .clk(clock_pin), .clkout((q_pin)));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */

endmodule 

module rls_clknand_mod (input bit clk, input bit en, output bit o);

  `NAC_CELL rls_temp_macro_name (.clk(clk), .en(en), .clkout(o)); 

  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */

endmodule 
module rls_clknor_mod (input bit clk, input bit en, output bit o);

  ec0cnor02al1n06x5 rls_temp_macro_name (.clk(clk), .enb(en), .clkout(o)); 

  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */

endmodule 
module rls_dhc_mod (input bit clk, input bit r, output bit o);
  // Original was cc0gtn00nn0c5
  // In cc0 gtn00 is clock divide by 2, synchronous, active high reset
  ec0cdvsr2al1n03x5 rls_temp_macro_name (.clkout(o),.clk(clk),.r(r));
  /* synopsys dc_tcl_script_begin  \
      set_size_only [get_cells rls_temp_macro_name ] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
      set_attribute -type string [ get_cells rls_temp_macro_name ] div_clock_generator true 
      set_attribute -type string [ get_cells rls_temp_macro_name ] clock_div_val 2 
      set_attribute -type string [ get_cells rls_temp_macro_name ] clock_div_phase phase1  */

endmodule 
module rls_div_clk_mod (output bit o, input bit clk, input bit en);

  ec0clb0a2an1n05x5 rls_temp_macro_name (.clkout(o),.clk(clk),.en(en));

  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] rls_div_clk is_div_clk 
    set_size_only [ get_cells rls_temp_macro_name ] */

endmodule

module rls_div4_clk_gen_mod(output bit outclk_pin,input bit inclk_pin,input bit reset_pin);
    //bit reset_pin_b;
    //ec0inv000al1n05x5  rls_temp_macro_name2 (.o1(reset_pin_b),.a(reset_pin));
    //cc0gtn04nd0e0  rls_temp_macro_name  (.clkout(outclk_pin),.clk(inclk_pin),.rb(reset_pin_b));
   
    /* brownmic FIXME: cc0gtn04 is a synchronous, div-by-4, with active high reset       */
    /*        There is NO equivalent in ec0 (in fact, no div-by-4 cells at all) */
    wire qa, qa_b, rst_b;
    ec0inv000al1n05x5 rst_inv  (.o1(rst_b), .a(reset_pin));
    ec0fan003al1n05x5 qa_flop ( .d(qa_b), .o(qa), .clk(inclk_pin), .rb(rst_b)); 
    ec0inv000al1n05x5 qa_inv  (.o1(qa_b), .a(qa));
    ec0fan003al1n05x5 qb_flop ( .d(qa), .o(outclk_pin), .clk(inclk_pin), .rb(rst_b)); 
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ current_design ] -type string skx_legacy_macro true 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true 
      set_attribute -type string [ get_cells qb_flop ] div_clock_generator true 
      set_attribute -type string [ get_cells qb_flop ] clock_div_val 4
      set_attribute -type string [ get_cells qb_flop ] clock_div_phase phase1 
      set_dont_touch [get_cells *] true  */

  /* brownmic FIXME: ORIGINAL-SCRIPT: synopsys dc_tcl_script_begin  \
      set_attribute -type string [ get_cells rls_temp_macro_name ] div_clock_generator true 
      set_attribute -type string [ get_cells rls_temp_macro_name ] clock_div_val 4 
      set_attribute -type string [ get_cells rls_temp_macro_name ] clock_div_phase phase1  */

endmodule

module rls_dt_msff_mod (input bit i_pin, input bit clock_pin, output bit q_pin);

  ec0fsn000al1n05x5 rls_temp_macro_name (.o(q_pin),.clk(clock_pin),.d(i_pin));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
     set_dont_touch [ get_cells rls_temp_macro_name ]
     set_attribute  [ get_cells rls_temp_macro_name ] hc_dont_touch true */


endmodule 
module rls_en_async_rst_msff_mod (input bit d, input bit clk, input bit en, input bit rst, output bit o);

  bit dat;

  always_comb begin
    if ( en ) dat = d;
    else      dat = o;
  end

  ec0fan003al1n05x5 rls_temp_macro_name (.clk(clk),.d(dat),.rb(~rst),.o(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true */

endmodule 
module rls_en_async_rstd_msff_mod (input bit d, input bit clk, input bit en, input bit rst, input bit rstd, output bit o);

  bit qual_rst;
  bit qual_set;

  always_comb begin
     qual_rst = rst & (~rstd);
     qual_set = rst & (rstd);
  end

 ec0fan07bal1d05x5 rls_temp_macro_name (.clk(clk),.d(~d),.rb(~qual_rst),.enb(~en),.s(qual_set),.o1(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true */

endmodule 
module rls_en_async_set_msff_mod (input bit d, input bit clk, input bit en, input bit set, output bit o);

  bit dat;

  always_comb begin
    if ( en ) dat = d;
    else      dat = o;
  end

  ec0fan008al1n05x5 rls_temp_macro_name (.clk(clk),.d(dat),.s(set),.o(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true */

endmodule 

module rls_en_latch_mod (input bit d, input bit clk, input bit en, output bit o);

  ec0lsn040al1n05x5  rls_temp_macro_name (.d(d), .clk(clk), .o(o), .en(en)); 

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ]  -type string dcsv_force_non_rcc true */

endmodule 

module rls_en_msff_mod (input bit d, input bit clk, input bit en, output bit o);

  ec0fsn070al1n05x5 rls_temp_macro_name (.clk(clk),.d(~d),.enb(~en),.o1(o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */


endmodule

module rls_dfx_en_msff_mod (input bit d, input bit clk, input bit en, output bit o);

  bit d_int;

  always_comb
   if ( en )
    d_int = d;
   else    
    d_int = o;


  ec0fsn000al1n05x5 rls_temp_macro_name (.d(d_int), .clk(clk), .o(o));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
       set_size_only [get_cells rls_temp_macro_name] true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dfx_margin_sequential true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dont_vec_seq true
    */

endmodule 
 
module rls_en_rst_latch_mod (input bit d, input bit clk, input bit en, input bit rst, output bit o);

 ec0lsn043al1n05x5 rls_temp_macro_name (.clk(clk),.d(d),.en(en),.rb(~rst),.o(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ]  -type string dcsv_force_non_rcc true */
endmodule 

module rls_en_rst_msff_mod (input bit d, input bit clk, input bit en, input bit rst, output bit o);
   bit dat;
    
       always_comb begin
         if ( en ) dat = d;
         else      dat = o;
       end

 ec0fsn053al1n05x5 rls_temp_macro_name (.clk(clk),.d(~d),.rb(~rst),.en(en),.o1(o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */
  

endmodule 

module rls_dfx_en_rst_msff_mod (input bit d, input bit clk, input bit en, input bit rst, output bit o);

  bit d_int;

  always_comb
    if ( rst )     d_int = '0;
    else if ( en ) d_int = d;
    else           d_int = o;

 ec0fsn000al1n05x5 rls_temp_macro_name (.d(d_int), .clk(clk), .o(o));
    
  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
       set_size_only [get_cells rls_temp_macro_name] true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dfx_margin_sequential true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dont_vec_seq true
    */

endmodule 


module rls_en_rstd_msff_mod (input bit d, input bit clk, input bit en, input bit rst, input bit rstd, output bit o);

  bit dat;
  bit enable;

  always_comb begin
    enable = en | rst;    
    if ( rst ) dat = rstd;
    else       dat = d;
  end

 ec0fsn070al1n05x5 rls_temp_macro_name (.clk(clk),.d(~dat),.enb(~enable),.o1(o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */


endmodule 
module rls_en_set_latch_mod (input bit d, input bit clk, input bit en, input bit s, output bit o);

 ec0lsn048al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .en(en), .s(s), .o(o)); 
  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ]  -type string dcsv_force_non_rcc true */

endmodule 
module rls_en_set_msff_mod (input bit d, input bit clk, input bit en, input bit set, output bit o);

  ec0fsn078al1n05x5 rls_temp_macro_name (.clk(clk),.d(~d),.enb(~en),.s(set),.o1(o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 

module rls_inc_mod (input bit clk, output bit o);

  `INC_CELL rls_temp_macro_name (.clk(clk), .clkout(o)); 
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true */

endmodule 
module rls_infer_async_rst_msff_mod (input bit d, input bit clk, input bit rst, output bit o);

  always_ff @(posedge clk or posedge rst) 
    begin 
      if ( rst ) o <= '0;
      else       o <= d;
    end

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dcsv_force_non_rcc true */

endmodule 
module rls_infer_async_rstd_msff_mod (input bit d, input bit clk, input bit rst, input bit rstd, output bit o);

  always_ff @(posedge clk or posedge rst)
    begin
      if ( rst ) o <= rstd;
      else       o <= d;
    end

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dcsv_force_non_rcc true */

endmodule 
module rls_infer_async_set_msff_mod (input bit d, input bit clk, input bit set, output bit o);

  always_ff @(posedge clk or posedge set)
    begin
      if ( set ) o <= '1;
      else       o <= d;
    end

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dcsv_force_non_rcc true */

endmodule 
module rls_infer_async_set_rst_msff_mod (input bit d, input bit clk, input bit en, input bit rst, input bit set, output bit o);

  always_ff @(posedge clk or posedge set or posedge rst)
    begin
      if      ( set ) o <= '1;
      else if ( rst ) o <= '0;
      else            o <= d;
    end

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dcsv_force_non_rcc true */

endmodule 
module rls_infer_en_async_rst_msff_mod (input bit d, input bit clk, input bit en, input bit rst, output bit o);

  always_ff @(posedge clk or posedge rst)
    begin
      if      ( rst ) o <= '0;
      else if ( en )  o <= d;
    end

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dcsv_force_non_rcc true */

endmodule 
module rls_infer_en_async_rstd_msff_mod (input bit d, input bit clk, input bit en, input bit rst, input bit rstd, output bit o);

  always_ff @(posedge clk or posedge rst)
    begin
      if      ( rst ) o <= rstd;
      else if ( en )  o <= d;
    end

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dcsv_force_non_rcc true */

endmodule 
module rls_infer_en_async_set_msff_mod (input bit d, input bit clk, input bit en, input bit set, output bit o);

  always_ff @(posedge clk or posedge set)
    begin
      if      ( set ) o <= '1;
      else if ( en )  o <= d;
    end

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dcsv_force_non_rcc true */

endmodule 
module rls_infer_en_msff_mod (input bit d, input bit clk, input bit en, output bit o);

  always_ff @(posedge clk)
    begin
      if ( en ) o <= d;
    end
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_infer_en_rst_msff_mod (input bit d, input bit clk, input bit en, input bit rst, output bit o);

  always_ff @(posedge clk)
    begin
      if      ( rst ) o <= '0;
      else if ( en  ) o <= d;
    end
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_infer_en_rstd_msff_mod (input bit d, input bit clk, input bit en, input bit rst, input bit rstd, output bit o);

  always_ff @(posedge clk)
    begin
      if      ( rst ) o <= rstd;
      else if ( en  ) o <= d;
    end
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_infer_en_set_msff_mod (input bit d, input bit clk, input bit en, input bit set, output bit o);

  always_ff @(posedge clk)
    begin
      if      ( set ) o <= '1;
      else if ( en  ) o <= d;
    end
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_infer_msff_b_mod (input bit d, input bit clk, output bit o);

  always_ff @(negedge clk)
    o <= d;
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_infer_msff_mod (input bit d, input bit clk, output bit o);

  always_ff @(posedge clk)
    o <= d;
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
// MSFF with dont_prune_dangling_sequential attribute
module rls_infer_msff_obs_mod (input bit d, input bit clk, output bit o);

  always_ff @(posedge clk)
    o <= d;

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
       set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dont_prune_dangling_sequential true
       set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dcsv_force_non_rcc true
    */

endmodule 
module rls_infer_dfx_msff_mod (input bit d, input bit clk, output bit o);

  always_ff @(posedge clk)
    o <= d;

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
       set_size_only [ get_cells * -filter "is_sequential==true" ] true
       set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dfx_margin_sequential true
       set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dcsv_force_non_rcc true
       set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dont_vec_seq true
    */


endmodule 
module rls_infer_ncc_msff_mod (input bit d, input bit clk, output bit o);

  always_ff @(posedge clk)
    o <= d;

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells * ] -type string dcsv_waive_clock_check true */

endmodule 
module rls_infer_ns_async_rst_msff_mod (input bit d, input bit clk, input bit rst, output bit o);

  always_ff @(posedge clk or posedge rst) 
    begin 
      if ( rst ) o <= '0;
      else       o <= d;
    end

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells * ] -type string dcsv_non_scan_sequential true  */


endmodule 
module rls_infer_ns_async_set_msff_mod (input bit d, input bit clk, input bit s, output bit o);

  always_ff @(posedge clk or posedge s)
    begin
      if ( s ) o <= '1;
      else     o <= d;
    end

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells * ] -type string dcsv_non_scan_sequential true  */

endmodule 
module rls_infer_ns_msff_mod (input bit d, input bit clk, output bit o);

  always_ff @(posedge clk)
    o <= d;

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells * ] -type string dcsv_non_scan_sequential true  */

endmodule 
module rls_infer_rst_msff_mod (input bit d, input bit clk, input bit rst, output bit o);

  always_ff @(posedge clk)
    begin
      if ( rst ) o <= '0;
      else       o <= d;
    end
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_infer_rst_set_msff_mod (input bit d, input bit clk, input bit set, input bit rst, output bit o);

  always_ff @(posedge clk)
    begin
      if      ( set ) o <= '1;
      else if ( rst ) o <= '0;
      else            o <= d;
    end
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_infer_rstd_msff_mod (input bit d, input bit clk, input bit rst, input bit rstd, output bit o);

  always_ff @(posedge clk)
    begin
      if ( rst ) o <= rstd;
      else       o <= d;
    end
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_infer_set_msff_mod (input bit d, input bit clk, input bit set, output bit o);

  always_ff @(posedge clk)
    begin
      if ( set ) o <= '1;
      else       o <= d;
    end
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_infer_set_rst_msff_mod (input bit d, input bit clk, input bit set, input bit rst, output bit o);

  always_ff @(posedge clk)
    begin
      if      ( rst ) o <= '0;
      else if ( set ) o <= '1;
      else            o <= d;
    end
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_inv_dont_touch_mod (output bit out, input bit in);

    ec0inv000al1n05x5 rls_temp_macro_name (.o1(out),.a(in));

  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_dont_touch [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_inv_keep_nets_in_mod (output bit out, input bit in);

    ec0inv000al1n05x5 rls_temp_macro_name (.o1(out),.a(in));

  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_pins rls_temp_macro_name/a  ] -type string dcsv_dont_touch_pin_net true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_inv_keep_nets_mod (output bit out, input bit in);

    ec0inv000al1n05x5 rls_temp_macro_name (.o1(out),.a(in));

  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_pins rls_temp_macro_name/a  ] -type string dcsv_dont_touch_pin_net true
    set_attribute [ get_pins rls_temp_macro_name/o1 ] -type string dcsv_dont_touch_pin_net true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_inv_keep_nets_out_mod (output bit out, input bit in);

    ec0inv000al1n05x5 rls_temp_macro_name (.o1(out),.a(in));

  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_pins rls_temp_macro_name/o1 ] -type string dcsv_dont_touch_pin_net true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_inv_mod (output bit out, input bit in);

    ec0inv000al1n05x5 rls_temp_macro_name (.o1(out),.a(in));

  // set attribute del_unloaded_gate_off to false, so the cell is pruned by RLS if its dangling

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ]
    set_attribute [ get_cells rls_temp_macro_name ] del_unloaded_gate_off false */

endmodule


module rls_inv_stdcell_mod (output bit out_pin, input bit a);

  ec0inv000al1n05x5 rls_temp_macro_name (.o1(out_pin),.a(a));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule
module rls_iso_high_mod (output bit out, input bit in, input bit ctrl);

  bit ctrl_inv;

  assign out = in;
  //ec0inv000al1n05x5 rls_temp_macro_name  (.o1(ctrl_inv),.a(ctrl));
  //ec0nor002al1n08x5 rls_temp_macro_name2 (.a(ctrl_inv),.b(in),.o1(out)); 
  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true */

endmodule


module rls_iso_low_mod (output bit out, input bit in, input bit ctrl);

  bit out_inv;

  assign out = in;
  //ec0nand02al1n08x5 rls_temp_macro_name  (.o1(out_inv),.a(ctrl),.b(in));
  //ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(out),.a(out_inv));
  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true */

endmodule


module rls_latch_mod (input bit d, input bit clk, output bit o);

  ec0lsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o)); 
  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule

module rls_latch_obs_mod (input bit d, input bit clk, output bit o);

  ec0lsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o));
  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dont_prune_dangling_sequential true
       set_attribute [ get_cells * -filter "is_sequential==true" ] -type string dcsv_force_non_rcc true
    */

endmodule 

module rls_dfx_latch_mod (input bit d, input bit clk, output bit o);

  ec0lsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o));
  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
       set_size_only [get_cells rls_temp_macro_name] true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dfx_margin_sequential true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dont_vec_seq true
    */

endmodule 
module rls_latch_p_mod (input bit d, input bit clkb, output bit o);

  ec0lsn080al1n05x5 rls_temp_macro_name (.d(d), .clkb(clkb), .o(o)); 
  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design]*/

endmodule 
module rls_dfx_latch_p_mod (input bit d, input bit clkb, output bit o);

  ec0lsn080al1n05x5 rls_temp_macro_name (.d(d), .clkb(clkb), .o(o)); 
  
  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
       set_size_only [get_cells rls_temp_macro_name] true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dfx_margin_sequential true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dont_vec_seq true
    */

endmodule
module rls_lbc_mod (input bit clk, input bit en, output bit o);

  `LBC_CELL rls_temp_macro_name (.clk(clk), .en(en), .clkout(o)); 
  
  /*  synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
      set_size_only [get_cells rls_temp_macro_name] true */

endmodule 
module rls_lbc_or_mod (input bit clk, input bit en, output bit o);

  ec0clb0o2al1n05x5 rls_temp_macro_name  (.clk(clk),.enb(en),.clkout(o));
  
  /*  synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
      set_size_only [get_cells rls_temp_macro_name] true */

endmodule 
module rls_metaflop_1_mod (input bit d, input bit clk, output bit o);
  //brownmic: was ec0fmn100al1n05x5, but dropped from library in 14ww32.1 ec0 release
  //   replacing with vanilla flop to prevent breaking macro
  ec0fsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o)); 
  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design]*/

endmodule 
module rls_metaflop_1 (input bit d, input bit clk, output bit o);

  ec0fmn100al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o)); 
  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design]*/

endmodule 
module rls_metaflop_2_mod (input bit d, input bit clk, output bit o);

  ec0fmn200al1n04x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o)); 
  //brownmic: FIXME cc0fmn02 is a jammed-keeper, 2-stage sync. It was dropped from
  //                 the ec0 lib.  Closest match now is interrupted-keeper, 2-stage sync.
  //                 Only question then is what is the difference and do we care?
  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule 
module rls_metaflop_2 (input bit d, input bit clk, output bit o);

 ec0fmn200al1n04x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o)); 
  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule 
module rls_metaflop_3_mod (input bit d, input bit clk, output bit o);

 ec0fmn300al1n04x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o)); 
  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule 
module rls_metaflop_3 (input bit d, input bit clk, output bit o);

 ec0fmn300al1n04x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o)); 
  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule 
module rls_msff_b_mod (input bit d, input bit clk, output bit o);

  always_ff @ ( negedge clk )
    begin
      o <= d;
    end
  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design]*/

endmodule 
module rls_msff_gen_clk_mod (input bit d, input bit clk, output bit o);

 ec0fsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o));
 //ec0cfsn00al1n05x5 rls_temp_macro_name (.d((i_pin)), .clk(clock_pin), .clkout((q_pin)));
 //brownmic: Should gen_clk_mod also use cfsn?

    /* synopsys dc_tcl_script_begin
       set_size_only [get_cells rls_temp_macro_name ] 
       set_attribute [get_pins rls_temp_macro_name/o] -type boolean rls_gen_clock_source true 
    */
endmodule
module rls_msff_mod (input bit d, input bit clk, output bit o);

  ec0fsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o)); 
  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design]*/

endmodule 

// MSFF with scan fully modeled
module rls_proxy_msff_mod (input bit d, input bit clk, output bit o, input bit sca, input bit scb, input bit si, output bit so);

//commented as scan flop is not in library  
//ec0fsx000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o), .sca(sca), .scb(scb), .si(si), .so(so));
  ec0fsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o)); 

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
       set_size_only [ get_cells rls_temp_macro_name ] true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dont_vec_seq true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    */


endmodule 
// MSFF with dont_prune_dangling_sequential attribute
module rls_msff_obs_mod (input bit d, input bit clk, output bit o);
    
  ec0fsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dont_prune_dangling_sequential true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dont_vec_seq true
    */
  
endmodule 
module rls_dfx_msff_mod (input bit d, input bit clk, output bit o);
  
  ec0fsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
       set_size_only [get_cells rls_temp_macro_name] true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dfx_margin_sequential true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dont_vec_seq true
    */

endmodule
module rls_dfx_ns_rst_msff_mod (input bit d, input bit clk, input bit rst, output bit o);

  bit d_int;

  always_comb d_int = d & ~rst;
  ec0fsn000al1n05x5 rls_temp_macro_name (.d(d_int), .clk(clk), .o(o));


  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ]
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dfx_margin_sequential true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true
    */


endmodule 
module rls_dfx_ns_set_msff_mod (input bit d, input bit clk, input bit set, output bit o);

  bit d_int;

  always_comb d_int = d | set;

  ec0fsn000al1n05x5 rls_temp_macro_name (.d(d_int), .clk(clk), .o(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ]
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dfx_margin_sequential true
    */


endmodule 



module rls_mux2_1_dec_buf_mod (output bit out, input bit a, input bit b, input bit sa);

  ec0mbn022al1n05x5 rls_temp_macro_name  (.o(out),.a(a),.b(b),.sa(sa));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_mux2_1_dec_inv_stdcell_mod (output bit q_pin, input bit a, input bit b, input bit sa);
  

  ec0mbn022al1n05x5 rls_temp_macro_name  (.o(q_pin),.a(a),.b(b),.sa(sa));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_mux2_1_pgm_mod (output bit out, input bit a, input bit b, input bit sa, input bit sb);

  bit out_inv;
  ec0mdn002al1n05x5 rls_temp_macro_name  (.o1(out_inv),.a(a),.b(b),.sa(sa),.sb(sb));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(out),.a(out_inv));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_mux2_1_stdcell_pg_mod (output bit o, input bit a, input bit b, input bit sa, input bit sb);

  bit out_inv;

  ec0mdn002al1n05x5 rls_temp_macro_name  (.o1(out_inv),.a(a),.b(b),.sa(sa),.sb(sb));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(o),.a(out_inv));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_inv_mux2_1_stdcell_pg_mod (output bit o, input bit a, input bit b, input bit sa, input bit sb);


  ec0mdn002al1n05x5 rls_temp_macro_name  (.o1(o),.a(a),.b(b),.sa(sa),.sb(sb));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_mux2_1_dec_inv_pg_mod (output bit out, input bit a, input bit b, input bit sa);

  ec0mdn022al1n05x5 rls_temp_macro_name  (.o1(out),.a(a),.b(b),.sa(sa));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
     set_size_only [ get_cells rls_temp_macro_name ] */

endmodule


module rls_mux2_1_dec_pg_inv_mod (output bit out, input bit a, input bit b, input bit sa);

  ec0mxn022al1n05x5 rls_temp_macro_name  (.o1(out),.a(a),.b(b),.sa(sa));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
     set_size_only [ get_cells rls_temp_macro_name ] */

endmodule
	

module rls_mux3_1_pgm_mod (output bit out, input bit a, input bit b, input bit c, input bit sa, input bit sb, input bit sc);

  bit out_inv;

  ec0mdn003al1n05x5 rls_temp_macro_name  (.o1(out_inv),.a(a),.b(b),.c(c),.sa(sa),.sb(sb),.sc(sc));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(out),.a(out_inv));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_mux3_1_stdcell_pg_mod (output bit o, input bit a, input bit b, input bit c, input bit sa, input bit sb, input bit sc);

  bit out_inv;

  ec0mdn003al1n05x5 rls_temp_macro_name  (.o1(out_inv),.a(a),.b(b),.c(c),.sa(sa),.sb(sb),.sc(sc));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(o),.a(out_inv));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule

module rls_inv_mux3_1_stdcell_pg_mod (output bit o, input bit a, input bit b, input bit c, input bit sa, input bit sb, input bit sc);


  ec0mdn003al1n05x5 rls_temp_macro_name  (.o1(o),.a(a),.b(b),.c(c),.sa(sa),.sb(sb),.sc(sc));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule

module rls_mux4_1_pg_inv_mod (output bit out, input bit a, input bit b, input bit c, input bit d, input bit sa, input bit sb, input bit sc, input bit sd);


  ec0mxn004al1n05x5 rls_temp_macro_name  (.o1(out),.a(a),.b(b),.c(c),.d(d),.sa(sa),.sb(sb),.sc(sc),.sd(sd));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */

endmodule

module rls_mux4_1_pgm_mod (output bit out, input bit a, input bit b, input bit c, input bit d, input bit sa, input bit sb, input bit sc, input bit sd);

  bit out_inv;

  ec0mdn004al1n05x5 rls_temp_macro_name  (.o1(out_inv),.a(a),.b(b),.c(c),.d(d),.sa(sa),.sb(sb),.sc(sc),.sd(sd));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(out),.a(out_inv));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_mux4_1_stdcell_pg_mod (output bit o, input bit a, input bit b, input bit c, input bit d, input bit sa, input bit sb, input bit sc, input bit sd);

  bit out_inv;

  ec0mdn004al1n05x5 rls_temp_macro_name  (.o1(out_inv),.a(a),.b(b),.c(c),.d(d),.sa(sa),.sb(sb),.sc(sc),.sd(sd));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(o),.a(out_inv));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule

module rls_inv_mux4_1_stdcell_pg_mod (output bit o, input bit a, input bit b, input bit c, input bit d, input bit sa, input bit sb, input bit sc, input bit sd);


  ec0mdn004al1n05x5 rls_temp_macro_name  (.o1(o),.a(a),.b(b),.c(c),.d(d),.sa(sa),.sb(sb),.sc(sc),.sd(sd));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_mux5_1_pgm_mod (output bit out, input bit a, input bit b, input bit c, input bit d, input bit e, input bit sa, input bit sb, input bit sc, input bit sd, input bit se);

  bit out_inv;

  ec0mdn005al1d05x5 rls_temp_macro_name  (.o1(out_inv),.a(a),.b(b),.c(c),.d(d),.e(e),.sa(sa),.sb(sb),.sc(sc),.sd(sd),.se(se));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(out),.a(out_inv));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_mux5_1_stdcell_pg_mod (output bit o, input bit a, input bit b, input bit c, input bit d, input bit e, input bit sa, input bit sb, input bit sc, input bit sd, input bit se);

  bit out_inv;

  ec0mdn005al1d05x5 rls_temp_macro_name  (.o1(out_inv),.a(a),.b(b),.c(c),.d(d),.e(e),.sa(sa),.sb(sb),.sc(sc),.sd(sd),.se(se));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(o),.a(out_inv));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule

module rls_inv_mux5_1_stdcell_pg_mod (output bit o, input bit a, input bit b, input bit c, input bit d, input bit e, input bit sa, input bit sb, input bit sc, input bit sd, input bit se);


  ec0mdn005al1d05x5 rls_temp_macro_name  (.o1(o),.a(a),.b(b),.c(c),.d(d),.e(e),.sa(sa),.sb(sb),.sc(sc),.sd(sd),.se(se));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_mux6_1_pgm_mod (output bit out, input bit a, input bit b, input bit c, input bit d, input bit e, input bit f, input bit sa, input bit sb, input bit sc, input bit sd, input bit se, input bit sf);

  bit out_inv;

  ec0mdn006al1d05x5 rls_temp_macro_name  (.o1(out_inv),.a(a),.b(b),.c(c),.d(d),.e(e),.f(f),.sa(sa),.sb(sb),.sc(sc),.sd(sd),.se(se),.sf(sf));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(out),.a(out_inv));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_mux6_1_stdcell_pg_mod (output bit o, input bit a, input bit b, input bit c, input bit d, input bit e, input bit f, input bit sa, input bit sb, input bit sc, input bit sd, input bit se, input bit sf);

  bit out_inv;

  ec0mdn006al1d05x5 rls_temp_macro_name  (.o1(out_inv),.a(a),.b(b),.c(c),.d(d),.e(e),.f(f),.sa(sa),.sb(sb),.sc(sc),.sd(sd),.se(se),.sf(sf));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(o),.a(out_inv));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule

module rls_inv_mux6_1_stdcell_pg_mod (output bit o, input bit a, input bit b, input bit c, input bit d, input bit e, input bit f, input bit sa, input bit sb, input bit sc, input bit sd, input bit se, input bit sf);


  ec0mdn006al1d05x5 rls_temp_macro_name  (.o1(o),.a(a),.b(b),.c(c),.d(d),.e(e),.f(f),.sa(sa),.sb(sb),.sc(sc),.sd(sd),.se(se),.sf(sf));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule


module rls_na2_latch_mod (input bit da, input bit db, input bit clk, output bit o);

  cc0luna12al1n05x5 rls_temp_macro_name (.da(da), .db(db), .clk(clk), .o1(o)); 
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true */

endmodule 
module rls_na2_latch_p_mod (input bit da, input bit db, input bit clkb, output bit o);

  cc0luna92al1n05x5 rls_temp_macro_name (.da(da), .db(db), .clkb(clkb), .o1(o)); 
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true */

endmodule 
module rls_na3_latch_mod (input bit da, input bit db, input bit dc, input bit clk, output bit o);

  cc0luna13al1n05x5 rls_temp_macro_name (.da(da), .db(db), .dc(dc), .clk(clk), .o1(o)); 
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true */

endmodule 
module rls_nand2_mod (output bit out, input bit a, b);

  ec0nand02al1n08x5 rls_temp_macro_name (.a(a),.b(b),.o1(out)); 

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
     set_size_only [ get_cells rls_temp_macro_name ] */

endmodule

module rls_nand2_stdcell_mod (output bit out_pin, input bit a, b);

  ec0nand02al1n08x5 rls_temp_macro_name (.a(a),.b(b),.o1(out_pin)); 

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
     set_size_only [ get_cells rls_temp_macro_name ] */

endmodule
module rls_nand3_mod (output bit out, input bit a, b, c);

  ec0nand03al1n05x5 rls_temp_macro_name (.a(a),.b(b),.c(c),.o1(out)); 

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
     set_size_only [ get_cells rls_temp_macro_name ] */

endmodule

module rls_nand3_stdcell_mod (output bit out_pin, input bit a, b, c);

  ec0nand03al1n05x5 rls_temp_macro_name (.a(a),.b(b),.c(c),.o1(out_pin)); 

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
     set_size_only [ get_cells rls_temp_macro_name ] */

endmodule

module rls_nand4_mod (output bit out, input bit a, b, c, d);

  ec0nand04al1n05x5 rls_temp_macro_name (.a(a),.b(b),.c(c),.d(d),.o1(out)); 

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
     set_size_only [ get_cells rls_temp_macro_name ] */

endmodule

module rls_nand_inv_mux4_1_bar_mod (output bit out, input bit a, b, c, d, e, sa, sb, sc, sd);

  ec0mxn004al1n05x5 rls_temp_macro_name (.a(a),.sa(sa),.b(b),.sb(sb),.c(c),.sc(sc),.d(d&e),.sd(sd),.o1(out)); 

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
     set_size_only [ get_cells rls_temp_macro_name ] */

endmodule

module rls_mux2_1_mod(inclk0_pin, select0_pin, inclk1_pin, select1_pin, outclk_pin);
output bit    outclk_pin;
input  bit    inclk0_pin;
input  bit    select0_pin;
input  bit    inclk1_pin;
input  bit    select1_pin;

   ec0cmbn02al1n09x5  rls_temp_macro_name (.o(outclk_pin), .a(inclk0_pin), .sa(select0_pin), .b(inclk1_pin), .sb(select1_pin));
  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule
module rls_ncc_msff_mod (input bit d, input bit clk, output bit o);

  ec0fsn000al1n05x5 rls_temp_macro_name (.o(o),.clk(clk),.d(d));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_waive_clock_check true */

endmodule 
module rls_no2_latch_mod (input bit da, input bit db, input bit clk, output bit o);

  ec0luno12al1n05x5 rls_temp_macro_name (.da(da), .db(db), .clk(clk), .o1(o)); 
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true */
  
endmodule 
module rls_no2_latch_p_mod (input bit da, input bit db, input bit clkb, output bit o);

  ec0luno92al1n05x5 rls_temp_macro_name (.da(da), .db(db), .clkb(clkb), .o1(o)); 
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true */

endmodule 
module rls_nor2_mod (output bit out, input bit a, b);

  ec0nor002al1n05x5 rls_temp_macro_name (.a(a),.b(b),.o1(out)); 

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
     set_size_only [ get_cells rls_temp_macro_name ] */

endmodule

module rls_nor2_stdcell_mod (output bit out_pin, input bit a, b);

  ec0nor002al1n05x5 rls_temp_macro_name (.a(a),.b(b),.o1(out_pin)); 

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
     set_size_only [ get_cells rls_temp_macro_name ] */

endmodule
module rls_nor3_mod (output bit out, input bit a, b, c);

  ec0nor003al1n05x5 rls_temp_macro_name (.a(a),.b(b),.c(c),.o1(out)); 

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
     set_size_only [ get_cells rls_temp_macro_name ] */

endmodule

module rls_ns_async_rst_msff_mod (input bit d, input bit clk, input bit rst, output bit o);

  ec0fan003al1n05x5 rls_temp_macro_name (.clk(clk),.d(d),.rb(~rst),.o(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_ns_async_set_msff_mod (input bit d, input bit clk, input bit set, output bit o);

  ec0fan008al1n03x5 rls_temp_macro_name (.d(d), .clk(clk), .s(set), .o(o)); 


  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_ns_async_set_rst_msff_mod (input bit d, input bit clk, input bit rst, input bit set, output bit o);

  ec0fan07bal1d05x5 rls_temp_macro_name (.clk(clk),.d(~d),.rb(~rst),.enb(1'b0),.s(set),.o1(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_ns_en_async_rst_msff_mod (input bit d, input bit clk, input bit en, input bit rst, output bit o);

  bit dat;

  always_comb begin
    if ( en ) dat = d;
    else      dat = o;
  end

  ec0fan003al1n05x5 rls_temp_macro_name (.clk(clk),.d(dat),.rb(~rst),.o(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_ns_en_async_set_msff_mod (input bit d, input bit clk, input bit en, input bit set, output bit o);

  bit dat;

  always_comb begin
    if ( en ) dat = d;
    else      dat = o;
  end

  ec0fan008al1n05x5 rls_temp_macro_name (.clk(clk),.d(d),.s(set),.o(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_ns_en_latch_mod (input bit d, input bit clk, input bit en, output bit o);

  ec0lsn040al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .en(en), .o(o)); 

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_ns_en_msff_mod (input bit d, input bit clk, input bit en, output bit o);

  ec0fsn070al1n05x5 rls_temp_macro_name (.clk(clk),.d(~d),.enb(~en),.o1(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_ns_en_rst_msff_mod (input bit d, input bit clk, input bit en, input bit rst, output bit o);
  bit dat;

      always_comb begin
        if ( en ) dat = d;
        else      dat = o;
      end

  ec0fsn053al1n05x5 rls_temp_macro_name (.clk(clk),.d(~d),.rb(~rst),.en(en),.o1(o));
  
  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_ns_en_set_msff_mod (input bit d, input bit clk, input bit en, input bit set, output bit o);

  ec0fsn078al1n05x5 rls_temp_macro_name (.clk(clk),.d(~d),.enb(~en),.s(set),.o1(o));
  
  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_ns_latch_mod (input bit d, input bit clk, output bit o);

  ec0lsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o)); 

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 

module rls_dfx_ns_latch_mod (input bit d, input bit clk, output bit o);

  ec0lsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o)); 

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [get_cells rls_temp_macro_name] true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dfx_margin_sequential true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dont_vec_seq true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_ns_latch_p_mod (input bit d, input bit clkb, output bit o);

  ec0lsn080al1n05x5 rls_temp_macro_name (.d(d), .clkb(clkb), .o(o)); 

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_dfx_ns_latch_p_mod (input bit d, input bit clkb, output bit o);

  ec0lsn080al1n05x5 rls_temp_macro_name (.d(d), .clkb(clkb), .o(o)); 

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ]
    set_attribute [ get_cells rls_temp_macro_name ] -type string dfx_margin_sequential true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 

module rls_ns_async_rst_latch_p_mod (input bit d, input bit clk, input bit rst, output bit o);

  ec0lan083al1n05x5 rls_temp_macro_name (.clkb(clk),.d(d),.rb(~rst),.o(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */

endmodule 
module rls_ns_msff_mod (input bit d, input bit clk, output bit o);

  ec0fsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o)); 

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule

module rls_dfx_ns_msff_mod (input bit d, input bit clk, output bit o);

  ec0fsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ]
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dfx_margin_sequential true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
 
module rls_ns_rst_msff_mod (input bit d, input bit clk, input bit rst, output bit o);

  ec0fsn013al1n05x5 rls_temp_macro_name (.clk(clk),.d(~d),.rb(~rst),.o1(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_ns_rst_set_msff_mod (input bit d, input bit clk, input bit set, input bit rst, output bit o);

  bit dat;

  always_comb begin
    if ( set )      dat = '1;
    else if ( rst ) dat = '0;
    else            dat = d;
  end

  ec0fsn000al1n05x5 rls_temp_macro_name (.o(o),.clk(clk),.d(dat));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_ns_set_msff_mod (input bit d, input bit clk, input bit set, output bit o);

  bit dat;

  always_comb begin
    if ( set )      dat = '1;
    else            dat = d;
  end

  ec0fsn018al1n05x5 rls_temp_macro_name (.clk(clk),.d(~d),.s(set),.o1(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_ns_set_rst_msff_mod (input bit d, input bit clk, input bit set, input bit rst, output bit o);

  bit dat;

  always_comb begin
    if ( rst )      dat = '0;
    else if ( set ) dat = '1;
    else            dat = d;
  end

  ec0fsn000al1n05x5 rls_temp_macro_name (.o(o),.clk(clk),.d(dat));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_oai_latch_mod (input bit da, input bit db, input bit dc, input bit clk, output bit o);

  ec0lsn000al1n05x5 rls_temp_macro_name (.d(~(da&(db|dc))), .clk(clk), .o(o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_rbc_3_mod (input bit clk, input bit en, input bit en_2, input bit fd0, input bit fd1, input bit rd0, input bit rd1, output bit o);

  `RBC_CELL rls_temp_macro_name (.clk(clk), .en(en & en_2), .fd(fd0), .rd(rd0), .clkout(o));
  
  /*  synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
      set_size_only [get_cells rls_temp_macro_name] true */

endmodule 

module rls_rbc_mod (input bit clk, input bit en, input bit fd0, input bit fd1, input bit rd0, input bit rd1, output bit o);

  `RBC_CELL rls_temp_macro_name (.clk(clk), .en(en), .fd(fd0), .rd(rd0), .clkout(o)); 

  /*  synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
      set_size_only [get_cells rls_temp_macro_name] true */

endmodule 
module rls_rbc_or_mod (input bit clk, input bit en, input bit fd0, input bit fd1, input bit rd0, input bit rd1, output bit o);

  //brownmic FIXME: RBC cells in 1274 only have 1 fd and 1 rd
  //                RBC cells in 1272      have 2 fd and 2 rd
  //cc0rbc01nn0d0 rls_temp_macro_name (.clk(clk), .en(en), .fd0(fd0), .fd1(fd1), .rd0(rd0), .rd1(rd1), .clkout(o));
  ec0crb0a2al1n05x5 rls_temp_macro_name (.clk(clk), .en(en), .clkout(o), .fd(fd0), .rd(rd0));

  /*  synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
      set_size_only [get_cells rls_temp_macro_name] true 
      set_attribute [ get_cells rls_temp_macro_name ]  -type string dcsv_or_rcb_error true */

endmodule 
module rls_rst_latch_mod (input bit d, input bit clk, input bit rst, output bit o);

  ec0lsn003al1n05x5 rls_temp_macro_name (.clk(clk),.d(d),.rb(~rst),.o(o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_rst_latch_p_mod (input bit d, input bit clk, input bit rst, output bit o);

  ec0lsn083al1n05x5 rls_temp_macro_name (.clkb(clk),.d(d),.rb(~rst),.o(o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_rst_msff_mod (input bit d, input bit clk, input bit rst, output bit o);

  ec0fsn013al1n05x5 rls_temp_macro_name (.clk(clk),.d(~d),.rb(~rst),.o1(o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule
module rls_dfx_rst_msff_mod (input bit d, input bit clk, input bit rst, output bit o);

  bit d_int;

  always_comb d_int = d & ~rst;

  ec0fsn000al1n05x5 rls_temp_macro_name (.d(d_int), .clk(clk), .o(o));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ]
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dfx_margin_sequential true
    */

endmodule 
 
module rls_rst_set_msff_mod (input bit d, input bit clk, input bit set, input bit rst, output bit o);

  bit dat;

  always_comb begin
    if ( set )      dat = '1;
    else if ( rst ) dat = '0;
    else            dat = d;
  end

  ec0fsn000al1n05x5 rls_temp_macro_name (.o(o),.clk(clk),.d(dat));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_rstd_msff_mod (input bit d, input bit clk, input bit rst, input bit rstd, output bit o);

  bit dat;

  always_comb begin
    if ( rst ) dat = rstd;
    else       dat = d;
  end

  ec0fsn000al1n05x5 rls_temp_macro_name  (.o(o),.clk(clk),.d(dat));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule
module rls_dfx_rstd_msff_mod (input bit d, input bit clk, input bit rst, input bit rstd, output bit o);

  bit dat;

  always_comb begin
    if ( rst ) dat = rstd;
    else       dat = d;
  end

  ec0fsn000al1n05x5 rls_temp_macro_name  (.o(o),.clk(clk),.d(dat));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design] 
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
       set_size_only [get_cells rls_temp_macro_name] true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dfx_margin_sequential true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dont_vec_seq true
    */

endmodule 
module rls_set_latch_mod (input bit d, input bit clk, input bit s, output bit o);

 ec0lsn008al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .s(s), .o(o)); 
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_set_msff_mod (input bit d, input bit clk, input bit set, output bit o);
  
  ec0fsn018al1n05x5 rls_temp_macro_name (.clk(clk),.d(~d),.s(set),.o1(o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_set_rst_latch_cell_mod (input bit d, input bit clk, input bit s, input bit rst, output bit o);
  
  wire nor_op, or_op;
  
  ec0nor002al1n05x5 rls_temp_macro_name (.a(d),.b(s),.o1(nor_op)); 
  ec0inv000al1n03x5 rls_temp_macro_name1 (.o1(nor_op),.a(or_op));
  ec0lsn003al1n05x5 rls_temp_macro_name2 (.clk(clk),.d(or_op),.o(o),.rb(~rst));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_set_rst_latch_mod (input bit d, input bit clk, input bit s, input bit rst, output bit o);

  bit dat;

  always_comb begin
    if ( rst )    dat = '0;
    else if ( s ) dat = '1;
    else          dat = d;
  end

  ec0lsn000al1n05x5 rls_temp_macro_name (.d(dat), .clk(clk), .o(o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_set_rst_msff_mod (input bit d, input bit clk, input bit set, input bit rst, output bit o);

  bit dat;

  always_comb begin
    if ( rst )      dat = '0;
    else if ( set ) dat = '1;
    else            dat = d;
  end

  ec0fsn000al1n05x5 rls_temp_macro_name (.o(o),.clk(clk),.d(dat));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 

module rls_dfx_set_rst_msff_mod (input bit d, input bit clk, input bit set, input bit rst, output bit o);

  bit dat;

  always_comb begin
    if ( rst )      dat = '0;
    else if ( set ) dat = '1;
    else            dat = d;
  end

  ec0fsn000al1n05x5 rls_temp_macro_name (.o(o),.clk(clk),.d(dat));
  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
       set_size_only [get_cells rls_temp_macro_name] true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dfx_margin_sequential true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
       set_attribute [ get_cells rls_temp_macro_name ] -type string dont_vec_seq true
    */

endmodule 

module rls_so_msff_mask_mod (input bit sigdin, input bit somaskclk, input bit sigsin, input bit soclk, input bit soshift, input bit sigload, output bit sigdout);

  bit sigvalid;

  ec0lsn010al1n02x5 rls_temp_macro_name1  (.o1(sigvalid),.clk(somaskclk),.d(sigdout));
  ec0fsn000al1n05x5 rls_temp_macro_name (.clk(sigload), .d(sigdin), .o(sigdout)); 
  //ec0fso002al1n04x5 rls_temp_macro_name2 (.sigdin(sigdin), .sigload(sigload), .sigsin(sigsin), .sigvalid(sigvalid), .soclk(soclk), .soshift(soshift), .sigdout(sigdout));
  //brownmic: ec0fso001* was dropped from 14ww32.1 release
  //brownmic: changed to vanilla flop just to keep macros from breaking

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ]  -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name2 ] -type string dcsv_force_non_rcc true */

endmodule

// the nv "no valid" masked SROSL has a mask output for use in group/bus masking
module rls_so_msff_mask_nv_mod (input bit sigdin, input bit somaskclk, input bit sigsin, input bit soclk, input bit soshift, input bit sigload, output bit sigdout, output bit mask);

  ec0lsn010al1n02x5 rls_temp_macro_name1  (.o(mask),.clk(somaskclk),.db(sigdout));
  ec0fsn000al1n05x5 rls_temp_macro_name (.clk(sigload), .d(sigdin), .o(sigdout)); 
  //ec0fso002al1n04x5 rls_temp_macro_name2 (.sigdin(sigdin), .sigload(sigload), .sigsin(sigsin), .sigvalid(mask), .soclk(soclk), .soshift(soshift), .sigdout(sigdout));
  //brownmic: ec0fso001* was dropped from 14ww32.1 release
  //brownmic: changed to vanilla flop just to keep macros from breaking

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ]  -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name2 ] -type string dcsv_force_non_rcc true */

endmodule 
 
module rls_so_msff_mod (input bit sigdin, input bit sigload, input bit sigsin, input bit sigvalid, input bit soclk, input bit soshift, output bit sigdout);

  ec0fsn000al1n05x5 rls_temp_macro_name (.clk(sigload), .d(sigdin), .o(sigdout)); 
  //ec0fso002al1n04x5 rls_temp_macro_name (.sigdin(sigdin), .sigload(sigload), .sigsin(sigsin), .sigvalid(sigvalid), .soclk(soclk), .soshift(soshift), .sigdout(sigdout)); 
  //brownmic: ec0fso001* was dropped from 14ww32.1 release
  //brownmic: changed to vanilla flop just to keep macros from breaking

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ]  -type string dcsv_force_non_rcc true */

endmodule 
module rls_so_msff_novalid_mod (input bit sigdin, input bit sigload, input bit sigsin, input bit soclk, input bit soshift, output bit sigdout);

  ec0fsn000al1n05x5 rls_temp_macro_name (.clk(sigload), .d(sigdin), .o(sigdout)); 
  //ec0fso001al1n05x5 rls_temp_macro_name (.sigdin(sigdin), .sigload(sigload), .sigsin(sigsin), .soclk(soclk), .soshift(soshift), .sigdout(sigdout)); 
  //brownmic: ec0fso001* was dropped from 14ww32.1 release
  //brownmic: changed to vanilla flop just to keep macros from breaking

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ]  -type string dcsv_force_non_rcc true */
endmodule 
module rls_so_msff_snapshot_mod (input bit sigdin, input bit sigload, input bit sigsin, input bit soclk, input bit soshift, output bit sigdout);

  ec0fsn000al1n05x5 rls_temp_macro_name (.clk(sigload), .d(sigdin), .o(sigdout)); 
  //ec0fso005al1n05x5 rls_temp_macro_name (.sigdin(sigdin), .sigload(sigload), .sigsin(sigsin), .soclk(soclk), .soshift(soshift), .sigdout(sigdout)); 
  //brownmic: ec0fso001* was dropped from 14ww32.1 release
  //brownmic: changed to vanilla flop just to keep macros from breaking

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ]  -type string dcsv_force_non_rcc true */

endmodule 
module rls_xnor2_mod (output bit out, input bit a, b);

  ec0xnr002al1n05x5 rls_temp_macro_name (.a(a),.b(b),.out(out)); 

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
     set_size_only [ get_cells rls_temp_macro_name ] */

endmodule
module rls_srep_en_latch_mod (input bit d, input bit clk, input bit en, output bit o);

  bit d_inv;
  bit o_inv;

  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */
  ec0inv000al1n05x5 rls_temp_macro_name (.o1(d_inv),.a(d));
  ec0lsn040al1n05x5 rls_temp_macro_name1 (.d(d_inv), .clk(clk), .en(en), .o(o_inv)); 
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(o),.a(o_inv));

endmodule
module rls_srep_en_msff_mod (input bit d, input bit clk, input bit en, output bit o);
 
  bit d_inv;
  bit e_inv;

  ec0inv000al1n05x5 rls_temp_macro_name (.o1(e_inv),.a(en));
  ec0fsn070al1n05x5 rls_temp_macro_name1(.clk(clk),.d(d),.enb(e_inv),.o1(d_inv));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(o),.a(d_inv));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule
module rls_srep_latch_mod (input bit d, input bit clk, output bit o);

 bit o_pre;

  ec0lsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o_pre));
  ec0bfn000al1n05x5 rls_temp_macro_name1 (.o(o),.a(o_pre));

 /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
	         set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_waive_clock_check true */

endmodule
module rls_srep_latch_p_mod (input bit d, input bit clkb, output bit o);

  bit d_inv;
  bit o_inv;
  
  ec0inv000al1n05x5 rls_temp_macro_name (.o1(d_inv),.a(d));
  ec0lsn080al1n05x5 rls_temp_macro_name1 (.d(d_inv), .clkb(clkb), .o(o_inv)); 
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(o),.a(o_inv));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule
module rls_srep_msff_mod (input bit d, input bit clk, output bit o);

 bit d_inv;
 bit o_inv;

  ec0inv000al1n05x5 rls_temp_macro_name (.o1(d_inv),.a(d));
  ec0fsn000al1n05x5 rls_temp_macro_name1 (.o(o_inv),.clk(clk),.d(d_inv));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(o),.a(o_inv));

 /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
		       set_attribute [ get_cells rls_temp_macro_name1 ] -type string dcsv_waive_clock_check true */

endmodule
module rls_dfx_srep_msff_mod (input bit d, input bit clk, output bit o);

 bit d_inv;
 bit o_inv;

  ec0inv000al1n05x5 rls_temp_macro_name (.o1(d_inv),.a(d));
  ec0fsn000al1n05x5 rls_temp_macro_name1 (.o(o_inv),.clk(clk),.d(d_inv));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(o),.a(o_inv));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name* ]
    set_attribute [ get_cells rls_temp_macro_name1 ] -type string dfx_margin_sequential true
    set_attribute [ get_cells rls_temp_macro_name1 ] -type string dcsv_waive_clock_check true */

endmodule
module rls_srep_rst_msff_mod (input bit d, input bit clk, input bit rst, output bit o);

  bit d_inv;
  bit r_inv;
  bit pre_o;

  ec0inv000al1n05x5 rls_temp_macro_name (.o1(d_inv),.a(d));
  ec0inv000al1n05x5 rls_temp_macro_name1 (.o1(r_inv),.a(rst));
  ec0fsn013al1n05x5 rls_temp_macro_name2(.clk(clk),.d(d_inv),.rb(r_inv),.o1(pre_o));
  ec0bfn000al1n05x5 rls_temp_macro_name3 (.o(o),.a(pre_o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule
module rls_srep_rst_latch_mod (input bit d, input bit clk, input bit rst, output bit o);

  bit r_inv;
  bit pre_o;

  ec0inv000al1n05x5 rls_temp_macro_name (.o1(r_inv),.a(rst));
  ec0lsn003al1n05x5 rls_temp_macro_name1 (.clk(clk),.d(d),.rb(r_inv),.o(pre_o));
  ec0bfn000al1n05x5 rls_temp_macro_name2 (.o(o),.a(pre_o));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule
module rls_srep_biglatch_mod (input bit d, input bit clk, output bit o);

  ec0lsn000al1n48x5 rls_temp_macro_name (.o(o),.clk(clk),.d(d));

 /* synopsys dc_tcl_script_begin 
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
               set_attribute [ get_cells rls_temp_macro_name ] -type string dont_downsize_sequential true
               set_attribute [ get_cells rls_temp_macro_name ] -type string srep_dont_buffer true 
               set_attribute [ get_pins rls_temp_macro_name/d ] -type string dcsv_dont_touch_pin_net true 
               set_attribute [ get_pins rls_temp_macro_name/o ] -type string dcsv_dont_touch_pin_net true
               set_size_only [ get_cells rls_temp_macro_name ] */

endmodule
module rls_srep_ns_latch_mod (input bit d, input bit clk, output bit o);
  
  bit o_pre;
  
  ec0lsn000al1n05x5 rls_temp_macro_name (.d(d), .clk(clk), .o(o_pre)); 
  ec0bfn000al1n05x5 rls_temp_macro_name1 (.o(o),.a(o_pre));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name ] -type string dcsv_non_scan_sequential true  */
endmodule 
module rls_srep_ns_msff_mod (input bit d, input bit clk, output bit o);

 bit d_inv;
 bit o_inv;
  
  ec0inv000al1n05x5 rls_temp_macro_name (.o1(d_inv),.a(d));
  ec0fsn000al1n05x5 rls_temp_macro_name1 (.o(o_inv),.clk(clk),.d(d_inv));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(o),.a(o_inv));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_cells rls_temp_macro_name1 ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name1 ] -type string dcsv_non_scan_sequential true  */
endmodule
module rls_dfx_srep_ns_msff_mod (input bit d, input bit clk, output bit o);

 bit d_inv;
 bit o_inv;

  ec0inv000al1n05x5 rls_temp_macro_name (.o1(d_inv),.a(d));
  ec0fsn000al1n05x5 rls_temp_macro_name1 (.o(o_inv),.clk(clk),.d(d_inv));
  ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(o),.a(o_inv));

  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name* ]
    set_attribute [ get_cells rls_temp_macro_name1 ] -type string dfx_margin_sequential true
    set_attribute [ get_cells rls_temp_macro_name1 ] -type string dcsv_force_non_rcc true
    set_attribute [ get_cells rls_temp_macro_name1 ] -type string dcsv_non_scan_sequential true  */
endmodule
module rls_clkmux2_1_mod(inclk0_pin, select0_pin, inclk1_pin, select1_pin, outclk_pin);
output bit    outclk_pin;
input  bit    inclk0_pin;
input  bit    select0_pin;
input  bit    inclk1_pin;
input  bit    select1_pin;
   ec0cmbn02al1n09x5  rls_temp_macro_name (.o(outclk_pin), .a(inclk0_pin), .sa(select0_pin), .b(inclk1_pin), .sb(select1_pin));
  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */
endmodule
module rls_clkmux3_1_mod(inclk0_pin, select0_pin, inclk1_pin, select1_pin, inclk2_pin, select2_pin, outclk_pin);
output bit    outclk_pin;
input  bit    inclk0_pin;
input  bit    select0_pin;
input  bit    inclk1_pin;
input  bit    select1_pin;
input  bit    inclk2_pin;
input  bit    select2_pin;
   ec0cmbn03al1n09x5 rls_temp_macro_name (.o(outclk_pin), .a(inclk0_pin), .sa(select0_pin), .b(inclk1_pin), .sb(select1_pin), .c(inclk2_pin), .sc(select2_pin));
  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */
endmodule
module rls_clkmux4_1_mod(inclk0_pin, select0_pin, inclk1_pin, select1_pin, inclk2_pin, select2_pin, inclk3_pin, select3_pin, outclk_pin);
output bit    outclk_pin;
input  bit    inclk0_pin;
input  bit    select0_pin;
input  bit    inclk1_pin;
input  bit    select1_pin;
input  bit    inclk2_pin;
input  bit    select2_pin;
input  bit    inclk3_pin;
input  bit    select3_pin;
   ec0cmbn04al1n09x5 rls_temp_macro_name (.o(outclk_pin), .a(inclk0_pin), .sa(select0_pin), .b(inclk1_pin), .sb(select1_pin), .c(inclk2_pin), .sc(select2_pin), .d(inclk3_pin), .sd(select3_pin));
  /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */
endmodule
// brownmic: ec0 does not have a stdcell for 5-to-1, one-hot, clk mux 
//module rls_clkmux5_1_mod(inclk0_pin, select0_pin, inclk1_pin, select1_pin, inclk2_pin, select2_pin, inclk3_pin, select3_pin, inclk4_pin, select4_pin, outclk_pin);
//output bit    outclk_pin;
//input  bit    inclk0_pin;
//input  bit    select0_pin;
//input  bit    inclk1_pin;
//input  bit    select1_pin;
//input  bit    inclk2_pin;
//input  bit    select2_pin;
//input  bit    inclk3_pin;
//input  bit    select3_pin;
//input  bit    inclk4_pin;
//input  bit    select4_pin;
//   ec0cmbn05al1n09x5 rls_temp_macro_name (.o(outclk_pin), .a(inclk0_pin), .sa(select0_pin), .b(inclk1_pin), .sb(select1_pin), .c(inclk2_pin), .sc(select2_pin), .d(inclk3_pin), .sd(select3_pin), .e(inclk4_pin), .se(select4_pin));
//endmodule


`ifdef RBC_CELL
   `undef RBC_CELL 
`endif

`ifdef BFC_CELL
   `undef BFC_CELL 
`endif

`ifdef NAC_CELL
   `undef NAC_CELL 
`endif

`ifdef INC_CELL
   `undef INC_CELL 
`endif

`ifdef LBC_CELL
   `undef LBC_CELL 
`endif

module rls_ls_mod(in_pin,out_pin)  ;

 output bit out_pin ;
 input bit in_pin ;

 
 
  /* synopsys dc_tcl_script_begin
    set_attribute [ current_design ] -type string skx_legacy_macro true
    */
  assign out_pin = in_pin;
 // ec0sg00ndal1d12x5 rls_temp_macro_name  (.in(in_pin),.out0(out_pin));
 // brownmic: NEEDS REVIEW - used to be cc0slsndld0f5
 // Special-cell, Level Shifter, Non-Deterministic, Double height, large size

endmodule
module rls_ls_iso_high_mod(out_pin,in_pin,ctrl_pin)  ;

 output bit out_pin ;
 input bit in_pin ;
 input bit ctrl_pin ;

 assign out_pin = in_pin;
  /* synopsys dc_tcl_script_begin
    set_attribute [ current_design ] -type string skx_legacy_macro true
    */
 // ec0sg00d1al1d12x5 rls_temp_macro_name  (.out0(out_pin),.in(in_pin),.force1b(ctrl_pin));
 // brownmic: NEEDS REVIEW - used to be cc0slsd1ld0f5
 // Special-cell, Level Shifter, Deterministic 1,   Double height, large size

endmodule
module rls_ls_iso_low_mod(in_pin,out_pin,ctrl_pin)  ;

 output bit out_pin ;
 input bit in_pin ;
 input bit ctrl_pin ;

 assign out_pin = in_pin;
  /* synopsys dc_tcl_script_begin
    set_attribute [ current_design ] -type string skx_legacy_macro true
    */
 // ec0sg00d0al1d12x5 rls_temp_macro_name  (.out0(out_pin),.in(in_pin),.force0(~ctrl_pin));
 // brownmic: NEEDS REVIEW - used to be cc0slsd0ld0f5
 // Special-cell, Level Shifter, Deterministic 0,   Double height, large size

endmodule
module rls_ls_clk_low_mod(in_pin,out_pin,ctrl_pin)  ;

 output bit out_pin ;
 input bit in_pin ;
 input bit ctrl_pin ;

 assign out_pin = in_pin;
  // ec0csb0d0al1d41x5 rls_temp_macro_name  (.in(in_pin),.out0(out_pin),.force0(~ctrl_pin));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */
 // brownmic: NEEDS REVIEW - used to be cc0slsc0ld0f5 
 // Special-cell, Level Shifter, Clock deterministic 0,   Double height, large size, unbuffered

endmodule
module rls_ls_weak_high_mod(in_pin,out_pin)  ;

 output bit out_pin ;
 input bit in_pin ;

 assign out_pin = in_pin;
  /* synopsys dc_tcl_script_begin
    set_attribute [ current_design ] -type string skx_legacy_macro true
    */
 // ec0sg00ndal1d12x5 rls_temp_macro_name  (.in(in_pin),.out0(out_pin));
 // brownmic: NEEDS REVIEW - used to be cc0slss1ld0f5 
 // Special-cell, Level Shifter, ?? Self-deterministic 1, Double height, large size
 // There are no self-deterministic in current ec0. Picked non-deterministic instead

endmodule
module rls_infer_latch_mod (input bit d, input bit clk, output bit o);

  always_latch
      if (clk) o <= d;
     /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_infer_latch_p_mod (input bit d, input bit clkb, output bit o);

  always_latch
      if (~clkb) o <= d;
     /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_ungroup [current_design] */

endmodule 
module rls_clk2nor_mod(output bit outclk_pin, input bit inclk1_pin, input bit inclk2_pin);

 //   ec0cnorc2al1n03x5 rls_temp_macro_name (.ck1(inclk1_pin), .clkout(outclk_pin), .ck2(inclk2_pin));
    ec0cnor02al1n03x5 rls_temp_macro_name (.enb(inclk1_pin), .clkout(outclk_pin), .clk(inclk2_pin));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */

endmodule
module rls_clk2nand_mod(output bit outclk_pin, input bit inclk1_pin, input bit inclk2_pin);

    ec0cnanc2al1n05x5 rls_temp_macro_name (.clk1(inclk1_pin), .clkout(outclk_pin), .clk2(inclk2_pin));
  /* synopsys dc_tcl_script_begin  \
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */

endmodule
module rls_muxlatch2_1_mod(output bit out, input bit iclka, input bit ia, input bit iclkb , input bit ib);
    bit a_inv;
    bit b_inv;
    ec0inv000al1n05x5 rls_temp_macro_name1 (.o1(a_inv),.a(ia));
    ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(b_inv),.a(ib));
    ec0lsn000al1n05x5 rls_temp_macro_name (.o(out), .clk(iclka), .d(a_inv));
    //ec0lmn012al1n03x5 rls_temp_macro_name (.o1(out), .clka(iclka), .a(a_inv), .clkb(iclkb), .b(b_inv));

     /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name* ] */
endmodule

module rls_muxlatch2_1_p_mod(output bit out, input bit iclka, input bit ia, input bit iclkb , input bit ib);
    bit a_inv;
    bit b_inv;
    ec0inv000al1n05x5 rls_temp_macro_name1 (.o1(a_inv),.a(ia));
    ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(b_inv),.a(ib));
    ec0lsn000al1n05x5 rls_temp_macro_name (.o(out), .clk(iclka), .d(a_inv));
    //ec0lmn092al1n05x5 rls_temp_macro_name (.o1(out), .clkab(iclka), .a(a_inv), .clkbb(iclkb), .b(b_inv));

     /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name* ] */
endmodule

module rls_muxlatch3_1_mod(output bit out, input bit iclka, input bit ia, input bit iclkb , input bit ib, input bit iclkc, input bit ic);
    bit a_inv;
    bit b_inv;
    bit c_inv;
    ec0inv000al1n05x5 rls_temp_macro_name1 (.o1(a_inv),.a(ia));
    ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(b_inv),.a(ib));
    ec0inv000al1n05x5 rls_temp_macro_name3 (.o1(c_inv),.a(ic));
    ec0lsn000al1n05x5 rls_temp_macro_name (.o(out), .clk(iclka), .d(a_inv));
    //ec0lmn013al1n05x5 rls_temp_macro_name (.o1(out), .clka(iclka), .a(a_inv), .clkb(iclkb), .b(b_inv), .clkc(iclkc), .c(c_inv));

     /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name* ] */
endmodule

module rls_muxlatch3_1_p_mod(output bit out, input bit iclka, input bit ia, input bit iclkb , input bit ib, input bit iclkc, input bit ic);
    bit a_inv;
    bit b_inv;
    bit c_inv;
    ec0inv000al1n05x5 rls_temp_macro_name1 (.o1(a_inv),.a(ia));
    ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(b_inv),.a(ib));
    ec0inv000al1n05x5 rls_temp_macro_name3 (.o1(c_inv),.a(ic));
    ec0lsn000al1n05x5 rls_temp_macro_name (.o(out), .clk(iclka), .d(a_inv));
    //ec0lmn093al1n05x5 rls_temp_macro_name (.o1(out), .clkab(iclka), .a(a_inv), .clkbb(iclkb), .b(b_inv), .clkcb(iclkc), .c(c_inv));

     /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name* ] */
endmodule


module rls_muxlatch4_1_mod(output bit out, input bit iclka, input bit ia, input bit iclkb , input bit ib, input bit iclkc, input bit ic, input bit id, input bit iclkd);
    bit a_inv;
    bit b_inv;
    bit c_inv;
    bit d_inv;

    ec0inv000al1n05x5 rls_temp_macro_name1 (.o1(a_inv),.a(ia));
    ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(b_inv),.a(ib));
    ec0inv000al1n05x5 rls_temp_macro_name3 (.o1(c_inv),.a(ic));
    ec0inv000al1n05x5 rls_temp_macro_name4 (.o1(d_inv),.a(id));
    ec0lsn000al1n05x5 rls_temp_macro_name (.o(out), .clk(iclka), .d(a_inv));
    //ec0lmn014al1n05x5 rls_temp_macro_name (.o1(out), .clka(iclka), .a(a_inv), .clkb(iclkb), .b(b_inv), .clkc(iclkc), .c(c_inv), .clkd(iclkd), .d(d_inv));

     /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name* ] */
endmodule

module rls_muxlatch4_1_p_mod(output bit out, input bit iclka, input bit ia, input bit iclkb , input bit ib, input bit iclkc, input bit ic, input bit id, input bit iclkd);
    bit a_inv;
    bit b_inv;
    bit c_inv;
    bit d_inv;

    ec0inv000al1n05x5 rls_temp_macro_name1 (.o1(a_inv),.a(ia));
    ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(b_inv),.a(ib));
    ec0inv000al1n05x5 rls_temp_macro_name3 (.o1(c_inv),.a(ic));
    ec0inv000al1n05x5 rls_temp_macro_name4 (.o1(d_inv),.a(id));
    ec0lsn000al1n05x5 rls_temp_macro_name (.o(out), .clk(iclka), .d(a_inv));
    //ec0lmn094al1n05x5 rls_temp_macro_name (.o1(out), .clkab(iclka), .a(a_inv), .clkbb(iclkb), .b(b_inv), .clkcb(iclkc), .c(c_inv), .clkdb(iclkd), .d(d_inv));

     /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name* ] */
endmodule

module rls_muxlatch5_1_mod(output bit out, input bit iclka, input bit ia, input bit iclkb , input bit ib, input bit iclkc, input bit ic, input bit id, input bit iclkd, input bit iclke, input bit ie);
    bit a_inv;
    bit b_inv;
    bit c_inv;
    bit d_inv;
    bit e_inv;


    ec0inv000al1n05x5 rls_temp_macro_name1 (.o1(a_inv),.a(ia));
    ec0inv000al1n05x5 rls_temp_macro_name2 (.o1(b_inv),.a(ib));
    ec0inv000al1n05x5 rls_temp_macro_name3 (.o1(c_inv),.a(ic));
    ec0inv000al1n05x5 rls_temp_macro_name4 (.o1(d_inv),.a(id));
    ec0inv000al1n05x5 rls_temp_macro_name5 (.o1(e_inv),.a(ie));
    ec0lsn000al1n05x5 rls_temp_macro_name (.o(out), .clk(iclka), .d(a_inv));
    //ec0lmn015al1n05x5 rls_temp_macro_name (.o1(out), .clka(iclka), .a(a_inv), .clkb(iclkb), .b(b_inv), .clkc(iclkc), .c(c_inv), .clkd(iclkd), .d(d_inv), .clke(iclke), .e(e_inv));

     /* synopsys dc_tcl_script_begin  \
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name* ] */
endmodule

module rls_mux2_1_nn (output bit out, input bit clk1, input bit clk2, input bit sa);

  ec0mbn022al1d32x5 rls_temp_macro_name  (.o(out),.a(~clk1),.b(~clk2),.sa(sa));

  /* synopsys dc_tcl_script_begin
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_size_only [ get_cells rls_temp_macro_name ] */     

endmodule

module rls_inv_stdcell_keep_nets_mod (output bit out_pin, input bit a);

  ec0inv000al1n05x5 inv_hsx_keep_nets (.o1(out_pin),.a(a));

  /* synopsys dc_tcl_script_begin
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
    set_attribute [ get_pins inv_hsx_keep_nets/a  ] -type string dcsv_dont_touch_pin_net true
    set_attribute [ get_pins inv_hsx_keep_nets/o1 ] -type string dcsv_dont_touch_pin_net true
    set_size_only [ get_cells inv_hsx_keep_nets ] */


endmodule


module rlsattr_dummy_bb (input bit q_pin) ; 
  /* synopsys dc_tcl_script_begin
    set_attribute [ current_design ] -type string skx_legacy_macro true
    */
endmodule
module rlsattr_non_scan (input bit q_pin) ;
        rlsattr_dummy_bb  rlsattr_dummy_bb_inst (.*);
      /* synopsys dc_tcl_script_begin  
    set_ungroup [current_design]
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
           set_attribute [get_cells {rlsattr_dummy_bb_inst}] -type boolean non_scan true */ 

endmodule // rlsattr_non_scan
`ifdef NEED_TO_SUPPORT_LEGACY_SKL
// ----------------------------------------------------------------------
// Ported over from SKL for compile
// NO functional support in RLS flow
// Scan attributes 
module rlsattr_array_slave (input bit q_pin) ;
        rlsattr_dummy_bb  rlsattr_dummy_bb_inst (.*);
      /* synopsys dc_tcl_script_begin  
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
           set_attribute [get_cells {rlsattr_dummy_bb_inst}] -type boolean array_slave true */ 

endmodule // rlsattr_array_slave
module rlsattr_lp_lcb (input bit q_pin) ;
        rlsattr_dummy_bb  rlsattr_dummy_bb_inst (.*);
      /* synopsys dc_tcl_script_begin             
    set_attribute [ get_cells * ] -type string skx_legacy_macro true
    set_attribute [ current_design ] -type string skx_legacy_macro true
      set_attribute [get_cells {rlsattr_dummy_bb_inst}] -type boolean lp_lcb  true */ 

endmodule

// ----------------------------------------------------------------------

`ifndef NHM_RLS_CELL_MACROS_VH
`define NHM_RLS_CELL_MACROS_VH


////// BSM MACROS

module rls_bsm00nn0b0 (bscapt, bsin, bsout, bsshift, bsupdt, din, dout, tck);

input  bscapt, bsin, bsshift, bsupdt, din, tck;
output  bsout, dout;

wire  bsout_buf, dout_buf, datain, datain_buf, datain_minbuf0, enb_bsout, 
    enb_updtdata, \ib_bsout[0] , \ib_updtdata[0] , tckb;

 cc0bfn11nn0b0 datain_minbuf (
    .a(datain_minbuf0),
    .o(datain_buf)
);


 cc0mbn22nn0b0 mux0 (
    .a(bsin),
    .b(din),
    .o(datain),
    .sa(bsshift)
);

 cc0inn00nn0c0 ibinv_bsout (
    .a(datain_buf),
    .o1(\ib_bsout[0] )
);

 cc0inn00nn0c7 inn0 (
    .a(bsupdt),
    .o1(enb_updtdata)
);

 cc0inn00nn0c7 ibinv_updtdata (
    .a(bsout),
    .o1(\ib_updtdata[0] )
);

 cc0bfn00nn0h5 bufout (
    .a(bsout_buf),
    .o(bsout)
);

 cc0fsn70nd4b0 regbsout (
    .clk(tck),
    .d(\ib_bsout[0] ),
    .enb(enb_bsout),
    .o1(bsout_buf)
);


 cc0fsn70nd4b0 regupdtdata (
    .clk(tckb),
    .d(\ib_updtdata[0] ),
    .enb(enb_updtdata),
    .o1(dout_buf)
);

 cc0non02nn0c5 non (
    .a(bscapt),
    .b(bsshift),
    .o1(enb_bsout)
);


 cc0gin00nn0c0 inn (
    .clk(tck),
    .clkout(tckb)
);

 cc0bfn11nn0b0 datain_buf0 (
    .a(datain),
    .o(datain_minbuf0)
);

 cc0bfn00nn0d5 cell_dout_buf (
   .a(dout_buf),
   .o(dout)
);
/* synopsys dc_tcl_script_begin
set_size_only -all_instances [get_cells -hier *]
dcsv_set_dont_touch_nets_p {bsout_buf}
dcsv_set_dont_touch_nets_p {datain}
dcsv_set_dont_touch_nets_p {datain_buf}
dcsv_set_dont_touch_nets_p {datain_minbuf0}
dcsv_set_dont_touch_nets_p {enb_bsout}
dcsv_set_dont_touch_nets_p {enb_updtdata}
dcsv_set_dont_touch_nets_p {\ib_bsout[0] }
dcsv_set_dont_touch_nets_p {\ib_updtdata[0] }
dcsv_set_dont_touch_nets_p {tckb}
dcsv_set_dont_touch_nets_p {bsout}
dcsv_set_dont_touch_nets_p {dout}
dcsv_set_dont_touch_nets_p {bscapt}
dcsv_set_dont_touch_nets_p {bsin}
dcsv_set_dont_touch_nets_p {bsshift}
dcsv_set_dont_touch_nets_p {bsupdt}
dcsv_set_dont_touch_nets_p {din}
dcsv_set_dont_touch_nets_p {tck}
dcsv_set_dont_touch_nets_p {dout_buf}
*/
endmodule


module rls_bsm01nn0b0 (bscapt, bsin, bsout, bsshift, bsupdt, d6actestsig, d6sel, din, dout, 
    tck);

input  bscapt, bsin, bsshift, bsupdt, d6actestsig, d6sel, din, tck;
output  bsout, dout;

wire  bsout_b, dout_buf, bsout_bf, bsout_st, bsupdt_b, n0, n1, n3, n4, n5, n6, 
    tck_b, updtdata;

supply1 vcc;
supply0 vss;


 cc0nan02nn0c0 na2 (
    .a(d6sel),
    .b(n1),
    .o1(n4)
);

 cc0nan02nn0c0 na1 (
    .a(n4),
    .b(n3),
    .o1(dout_buf)
);


 cc0nan02nn0c0 na0 (
    .a(d6actestsig),
    .b(updtdata),
    .o1(n3)
);

 cc0gin00nn0c0 gin0 (
    .clk(tck),
    .clkout(tck_b)
);


 cc0inn00nn0c0 in9 (
    .a(bsupdt),
    .o1(bsupdt_b)
);

 cc0inn00nn0c0 in8 (
    .a(bsout),
    .o1(bsout_b)
);

 cc0non02nn0b0 no1 (
    .a(d6actestsig),
    .b(updtdata),
    .o1(n1)
);

 cc0non02nn0b0 no0 (
    .a(bsshift),
    .b(bscapt),
    .o1(n0)
);

 cc0mdn22nn0b0 md0 (
    .a(bsin),
    .b(din),
    .o1(n5),
    .sa(bsshift)
);


 cc0fsn70nd4b0 fs1 (
    .clk(tck_b),
    .d(bsout_b),
    .enb(bsupdt_b),
    .o1(updtdata)
);

 cc0fsn70nd4b0  fs0 (
    .clk(tck),
    .d(n6),
    .enb(n0),
    .o1(bsout_st)
);

 cc0bfn11nn0b0 bf0 (
    .a(bsout_st),
    .o(bsout_bf)
);

 cc0bfn11nn0b0 bf1 (
    .a(bsout_bf),
    .o(bsout)
);

 cc0bfn11nn0b0 bf2 (
    .a(n5),
    .o(n6)
);

 cc0bfn00nn0d5 cell_dout_buf (
   .a(dout_buf),
   .o(dout)
);

/* synopsys dc_tcl_script_begin
set_size_only -all_instances [get_cells -hier *]
dcsv_set_dont_touch_nets_p {bsout_b}
dcsv_set_dont_touch_nets_p {bsout_bf}
dcsv_set_dont_touch_nets_p {bsout_st}
dcsv_set_dont_touch_nets_p {bsupdt_b}
dcsv_set_dont_touch_nets_p {n0}
dcsv_set_dont_touch_nets_p {n1}
dcsv_set_dont_touch_nets_p {n3}
dcsv_set_dont_touch_nets_p {n4}
dcsv_set_dont_touch_nets_p {n5}
dcsv_set_dont_touch_nets_p {n6}
dcsv_set_dont_touch_nets_p {tck_b}
dcsv_set_dont_touch_nets_p {updtdata}
dcsv_set_dont_touch_nets_p {dout_buf}

*/

endmodule
  

module rls_bsm02nn0b0 (bscapt, bsin, bsout, bsshift, bsupdt, d6actestsig, d6sel, din, dout, 
    tck);

input  bscapt, bsin, bsshift, bsupdt, d6actestsig, d6sel, din, tck;
output  bsout, dout;

wire  bsout_buf, dout_buf, datain, datain_buf, datain_minbuf0, enb_bsout, 
    enb_updtdata, gen_dout, gen_doutb, \ib_bsout[0] , \ib_updtdata[0] , tckb, 
    updtdata;

 cc0bfn11nn0b0 datain_buf0 (
    .a(datain),
    .o(datain_minbuf0)
);


 cc0gin00nn0c0 inn (
    .clk(tck),
    .clkout(tckb)
);


 cc0nan02nn0c0 nan11 (
    .a(d6actestsig),
    .b(updtdata),
    .o1(gen_doutb)
);

 cc0mbn22nn0c7 mux1 (
    .a(updtdata),
    .b(gen_dout),
    .o(dout_buf),
    .sa(d6sel)
);

 cc0non02nn0c5 non (
    .a(bscapt),
    .b(bsshift),
    .o1(enb_bsout)
);

 cc0fsn70nd4b0 regupdtdata (
    .clk(tckb),
    .d(\ib_updtdata[0] ),
    .enb(enb_updtdata),
    .o1(updtdata)
);

 cc0fsn70nd4b0 regbsout (
    .clk(tck),
    .d(\ib_bsout[0] ),
    .enb(enb_bsout),
    .o1(bsout_buf)
); 

 cc0bfn00nn0h5 bufout (
    .a(bsout_buf),
    .o(bsout)
);

 cc0inn00nn0c7 ibinv_updtdata (
    .a(bsout),
    .o1(\ib_updtdata[0] )
);

 cc0inn00nn0c7 inn1 (
    .a(gen_doutb),
    .o1(gen_dout)
);

 cc0inn00nn0c7 inn0 (
    .a(bsupdt),
    .o1(enb_updtdata)
);

 cc0inn00nn0c0 ibinv_bsout (
    .a(datain_buf),
    .o1(\ib_bsout[0] )
);

 cc0mbn22nn0b0 mux0 (
    .a(bsin),
    .b(din),
    .o(datain),
    .sa(bsshift)
);

 cc0bfn11nn0b0 datain_minbuf (
    .a(datain_minbuf0),
    .o(datain_buf)
);

 cc0bfn00nn0d5 cell_dout_buf (
   .a(dout_buf),
   .o(dout)
);
/* synopsys dc_tcl_script_begin
set_size_only -all_instances [get_cells -hier *]
dcsv_set_dont_touch_nets_p {bsout_buf}
dcsv_set_dont_touch_nets_p {datain}
dcsv_set_dont_touch_nets_p {datain_buf}
dcsv_set_dont_touch_nets_p {datain_minbuf0}
dcsv_set_dont_touch_nets_p {enb_bsout}
dcsv_set_dont_touch_nets_p {enb_updtdata}
dcsv_set_dont_touch_nets_p {gen_dout}
dcsv_set_dont_touch_nets_p {gen_doutb}
dcsv_set_dont_touch_nets_p {\ib_bsout[0] }
dcsv_set_dont_touch_nets_p {\ib_updtdata[0] }
dcsv_set_dont_touch_nets_p {tckb}
dcsv_set_dont_touch_nets_p {updtdata}
dcsv_set_dont_touch_nets_p {dout_buf}
*/

endmodule

`endif

`endif // NEED_TO_SUPPORT_LEGACY_SKL

`endif
