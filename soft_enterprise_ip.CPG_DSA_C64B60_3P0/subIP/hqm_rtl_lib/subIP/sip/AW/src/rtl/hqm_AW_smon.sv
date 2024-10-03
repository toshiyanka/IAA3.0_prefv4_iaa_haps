//-----------------------------------------------------------------------------------------------------
//
// inTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
// Purpose:
//
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_smon
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 8
) (
	 input	logic				rst_n
	,input	logic				clk
	,input	logic				disable_smon

	,input	logic	[WIDTH-1:0]		in_mon_v
	,input	logic	[(WIDTH*32)-1:0]	in_mon_comp
	,input	logic	[(WIDTH*32)-1:0]	in_mon_val

	,input	logic				in_smon_cfg0_write
	,input	logic				in_smon_cfg1_write
	,input	logic				in_smon_cfg2_write
	,input	logic				in_smon_cfg3_write
	,input	logic				in_smon_cfg4_write
	,input	logic				in_smon_cfg5_write
	,input	logic				in_smon_cfg6_write
	,input	logic				in_smon_cfg7_write
	,input	logic	[31:0]			in_smon_cfg0_wdata
	,input	logic	[31:0]			in_smon_cfg1_wdata
	,input	logic	[31:0]			in_smon_cfg2_wdata
	,input	logic	[31:0]			in_smon_cfg3_wdata
	,input	logic	[31:0]			in_smon_cfg4_wdata
	,input	logic	[31:0]			in_smon_cfg5_wdata
	,input	logic	[31:0]			in_smon_cfg6_wdata
	,input	logic	[31:0]			in_smon_cfg7_wdata
  
	,output	logic	[31:0]			out_smon_cfg0_data
	,output	logic	[31:0]			out_smon_cfg1_data
	,output	logic	[31:0]			out_smon_cfg2_data
	,output	logic	[31:0]			out_smon_cfg3_data
	,output	logic	[31:0]			out_smon_cfg4_data
	,output	logic	[31:0]			out_smon_cfg5_data
	,output	logic	[31:0]			out_smon_cfg6_data
	,output	logic	[31:0]			out_smon_cfg7_data

	,output	logic				out_smon_interrupt 
	,output	logic				out_smon_enabled
);
  
  //---------------------------------------------------------------------------------------------------
  // declare logic & logic
  //---------------------------------------------------------------------------------------------------

  logic wire_cnt0_v;
  logic [31:0] wire_cnt0_val;
  logic [31:0] wire_cnt0_comp;
  logic wire_cnt1_v;
  logic [31:0] wire_cnt1_val;
  logic [31:0] wire_cnt1_comp;
  logic [31:0] reg_smon_cfg0_q; 
  logic [31:0] reg_smon_cfg0_next;
  logic [31:0] reg_smon_cfg1_q;
  logic [31:0] reg_smon_cfg1_next;

  logic [32:0] reg_smon_cnt0_q; 
  logic [32:0] reg_smon_cnt0_next;
  logic [32:0] reg_smon_cnt1_q; 
  logic [32:0] reg_smon_cnt1_next;
  logic [31:0] reg_smon_comp0_q;
  logic [31:0] reg_smon_comp0_next;
  logic [31:0] reg_smon_comp1_q;
  logic [31:0] reg_smon_comp1_next;
  logic [32:0] reg_smon_timer_q; 
  logic [32:0] reg_smon_timer_next;
  logic [31:0] reg_smon_maxval_q; 
  logic [31:0] reg_smon_maxval_next;

  logic [31:0] reg_smon_freeruntimer_q;
  logic [31:0] reg_smon_freeruntimer_next;
  logic [31:0] reg_smon_latency_freeruntimer_q;
  logic [31:0] reg_smon_latency_freeruntimer_next;
  logic wire_smon_cfg_q_enable;
  logic wire_smon_cfg_q_0autoenable;
  logic [7:0] wire_smon_cfg_q_smon0;
  logic [7:0] wire_smon_cfg_q_smon1;
  logic [4:0] wire_smon_cfg_q_timerprescale;
  logic wire_smon_cfg_q_stopcounterovfl;
  logic wire_smon_cfg_q_intcounterovfl;
  logic wire_smon_cfg_q_statcounter0ovfl;
  logic wire_smon_cfg_q_statcounter1ovfl;
  logic wire_smon_cfg_q_stoptimerovfl;
  logic wire_smon_cfg_q_inttimerovfl;
  logic wire_smon_cfg_q_stattimerovfl;
  logic [3:0] wire_smon_cfg_q_countertype0;
  logic [3:0] wire_smon_cfg_q_countertype1;
  logic [3:0] wire_smon_cfg_q_countermode;

  logic reg_cnt0_switch_next;
  logic reg_cnt0_switch_q;
  logic reg_cnt1_switch_next;
  logic reg_cnt1_switch_q;

  logic reg_smon_latency_switch_next;
  logic reg_smon_latency_switch_q;

  logic reg_smon_latency_on_next;
  logic reg_smon_latency_on_q;

  logic [31:0] wire_mon_val[WIDTH-1:0];
  logic [31:0] wire_mon_comp[WIDTH-1:0];

  logic wire_compare0_v;        
  logic wire_trigger0_v;        
  logic wire_compare1_v;        
  logic wire_trigger1_v;        

  genvar      g;

  //---------------------------------------------------------------------------------------------------
  // Declare & initialize all Flops  
  //---------------------------------------------------------------------------------------------------
  always_ff @ (posedge clk or negedge rst_n) begin
      if (!rst_n) begin
                                         reg_cnt0_switch_q <='0;
                                         reg_cnt1_switch_q <='0;
                                   reg_smon_freeruntimer_q <= '0;
                                 reg_smon_latency_switch_q <= '0;
                                     reg_smon_latency_on_q <= '0;
                           reg_smon_latency_freeruntimer_q <= 32'd1;
                                     reg_smon_cfg0_q[31:0] <= '0;
                                     reg_smon_cfg1_q[31:0] <= '0;
                                    reg_smon_comp0_q[31:0] <= '0;
                                    reg_smon_comp1_q[31:0] <= '0;
                                     reg_smon_cnt0_q[32:0] <= '0;
                                     reg_smon_cnt1_q[32:0] <= '0;
                                    reg_smon_timer_q[32:0] <= '0;
                                   reg_smon_maxval_q[31:0] <= '0;
      end
      else begin

        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg0_write) ) begin       reg_cnt0_switch_q <= 0;                              end else begin reg_cnt0_switch_q <= reg_cnt0_switch_next; end
        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg0_write) ) begin       reg_cnt1_switch_q <= 0;                              end else begin reg_cnt1_switch_q <= reg_cnt1_switch_next; end
        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg0_write) ) begin   reg_smon_freeruntimer_q <= 0;                            end else begin reg_smon_freeruntimer_q <= reg_smon_freeruntimer_next; end
        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg0_write) ) begin reg_smon_latency_switch_q <= 0;                            end else begin reg_smon_latency_switch_q <= reg_smon_latency_switch_next; end
        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg0_write) ) begin reg_smon_latency_on_q <= 0;                                end else begin reg_smon_latency_on_q <= reg_smon_latency_on_next; end
        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg0_write) ) begin reg_smon_latency_freeruntimer_q <= 32'd1;                  end else begin reg_smon_latency_freeruntimer_q <= reg_smon_latency_freeruntimer_next; end

        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg0_write) ) begin   reg_smon_cfg0_q[31:0] <=       in_smon_cfg0_wdata[31:0];  end else begin reg_smon_cfg0_q   <= reg_smon_cfg0_next; end
        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg1_write) ) begin   reg_smon_cfg1_q[31:0] <=       in_smon_cfg1_wdata[31:0];  end else begin reg_smon_cfg1_q   <= reg_smon_cfg1_next; end
        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg2_write) ) begin  reg_smon_comp0_q[31:0] <=       in_smon_cfg2_wdata[31:0];  end else begin reg_smon_comp0_q  <= reg_smon_comp0_next; end
        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg3_write) ) begin  reg_smon_comp1_q[31:0] <=       in_smon_cfg3_wdata[31:0];  end else begin reg_smon_comp1_q  <= reg_smon_comp1_next; end
        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg4_write | (in_smon_cfg0_write & reg_smon_cfg0_q[29])) ) begin   reg_smon_cnt0_q[32:0] <= {1'b0,in_smon_cfg4_wdata[31:0]}; end else begin reg_smon_cnt0_q   <= reg_smon_cnt0_next; end
        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg5_write | (in_smon_cfg0_write & reg_smon_cfg0_q[29])) ) begin   reg_smon_cnt1_q[32:0] <= {1'b0,in_smon_cfg5_wdata[31:0]}; end else begin reg_smon_cnt1_q   <= reg_smon_cnt1_next; end
        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg6_write | (in_smon_cfg0_write & reg_smon_cfg0_q[29])) ) begin  reg_smon_timer_q[32:0] <= {1'b0,in_smon_cfg6_wdata[31:0]}; end else begin reg_smon_timer_q  <= reg_smon_timer_next; end
        if ( ( disable_smon == 1'b0 ) & (in_smon_cfg7_write) ) begin reg_smon_maxval_q[31:0] <=       in_smon_cfg7_wdata[31:0];  end else begin reg_smon_maxval_q <= reg_smon_maxval_next; end

      end
  end



  //---------------------------------------------------------------------------------------------------
  //Decode inputs into COUNTER0 & COUNTER1 inputs 
  //---------------------------------------------------------------------------------------------------
  generate
   for (g=0; g<WIDTH; g=g+1) begin: cfg_arrayon1
    assign wire_mon_val[g] = in_mon_val[(g*32)+31 -: 32];
   end // cfg_arrayon1
  endgenerate
  generate
   for (g=0; g<WIDTH; g=g+1) begin: cfg_arrayon2
    assign wire_mon_comp[g] = in_mon_comp[(g*32)+31 -: 32];
   end // cfg_arrayon2
  endgenerate
 
  assign wire_cnt0_v    = in_mon_v[wire_smon_cfg_q_smon0[7:0]]; 
  assign wire_cnt0_val  = wire_mon_val[wire_smon_cfg_q_smon0[7:0]]; 
  assign wire_cnt0_comp = wire_mon_comp[wire_smon_cfg_q_smon0[7:0]]; 
  
  assign wire_cnt1_v    = in_mon_v[wire_smon_cfg_q_smon1[7:0]]; 
  assign wire_cnt1_val  = wire_mon_val[wire_smon_cfg_q_smon1[7:0]];  
  assign wire_cnt1_comp = wire_mon_comp[wire_smon_cfg_q_smon1[7:0]]; 



    //---------------------------------------------------------------------------------------------------
    // Incrementers and Adders
    //---------------------------------------------------------------------------------------------------

    logic   [31:0]  wire_smon_freeruntimer_p1;
    logic   [31:0]  wire_smon_latency_freeruntimer_p1;
    logic   [32:0]  wire_smon_timer_31_0_p1;
    logic   [32:0]  wire_smon_cnt0_31_0_p1;
    logic   [32:0]  wire_smon_cnt0_31_0_pval0;
    logic   [32:0]  wire_smon_cnt1_31_0_p1;
    logic   [32:0]  wire_smon_cnt1_31_0_pval0;
    logic   [32:0]  wire_smon_cnt1_31_0_pval1;
    logic   [32:0]  wire_smon_cnt1_31_0_plfr;

    hqm_AW_inc #(.WIDTH(32)) i_freeruntimer_p1 (
         .a     (reg_smon_freeruntimer_q)
        ,.sum   (wire_smon_freeruntimer_p1)
    );

    hqm_AW_inc #(.WIDTH(32)) i_latency_freeruntimer_p1 (
         .a     (reg_smon_latency_freeruntimer_q)
        ,.sum   (wire_smon_latency_freeruntimer_p1)
    );

    hqm_AW_inc #(.WIDTH(33)) i_timer_31_0_p1 (
         .a     ({1'b0,reg_smon_timer_q[31:0]})
        ,.sum   (wire_smon_timer_31_0_p1)
    );

    hqm_AW_inc #(.WIDTH(33)) i_cnt0_31_0_p1 (
         .a     ({1'b0,reg_smon_cnt0_q[31:0]})
        ,.sum   (wire_smon_cnt0_31_0_p1)
    );

    hqm_AW_inc #(.WIDTH(33)) i_cnt1_31_0_p1 (
         .a     ({1'b0,reg_smon_cnt1_q[31:0]})
        ,.sum   (wire_smon_cnt1_31_0_p1)
    );

    hqm_AW_add #(.WIDTH(32)) i_cnt0_31_0_pval0 (
         .a     (reg_smon_cnt0_q[31:0])
        ,.b     (wire_cnt0_val)
        ,.ci    ('0)
        ,.sum   (wire_smon_cnt0_31_0_pval0[31:0])
        ,.co    (wire_smon_cnt0_31_0_pval0[32])
    );

    hqm_AW_add #(.WIDTH(32)) i_cnt1_31_0_pval0 (
         .a     (reg_smon_cnt1_q[31:0])
        ,.b     (wire_cnt0_val)
        ,.ci    ('0)
        ,.sum   (wire_smon_cnt1_31_0_pval0[31:0])
        ,.co    (wire_smon_cnt1_31_0_pval0[32])
    );

    hqm_AW_add #(.WIDTH(32)) i_cnt1_31_0_pval1 (
         .a     (reg_smon_cnt1_q[31:0])
        ,.b     (wire_cnt1_val)
        ,.ci    ('0)
        ,.sum   (wire_smon_cnt1_31_0_pval1[31:0])
        ,.co    (wire_smon_cnt1_31_0_pval1[32])
    );

    hqm_AW_add #(.WIDTH(32)) i_cnt1_31_0_plfr (
         .a     (reg_smon_cnt1_q[31:0])
        ,.b     (reg_smon_latency_freeruntimer_q)
        ,.ci    ('0)
        ,.sum   (wire_smon_cnt1_31_0_plfr[31:0])
        ,.co    (wire_smon_cnt1_31_0_plfr[32])
    );

  //---------------------------------------------------------------------------------------------------
  // SMON CONTROL LOGIC
  //---------------------------------------------------------------------------------------------------
  always_comb begin

    out_smon_interrupt                   = 0;
    wire_compare0_v                      = 0;
    wire_trigger0_v                      = 0;
    wire_compare1_v                      = 0;
    wire_trigger1_v                      = 0;

    reg_cnt0_switch_next                 = reg_cnt0_switch_q;
    reg_cnt1_switch_next                 = reg_cnt1_switch_q;
    reg_smon_cfg0_next[31:0]             = reg_smon_cfg0_q[31:0];
    reg_smon_cfg1_next[31:0]             = reg_smon_cfg1_q[31:0];
    reg_smon_comp0_next[31:0]            = reg_smon_comp0_q[31:0];
    reg_smon_comp1_next[31:0]            = reg_smon_comp1_q[31:0];
    reg_smon_cnt0_next[32:0]             = reg_smon_cnt0_q[32:0];
    reg_smon_cnt1_next[32:0]             = reg_smon_cnt1_q[32:0];
    reg_smon_timer_next[32:0]            = reg_smon_timer_q[32:0];
    reg_smon_maxval_next[31:0]           = reg_smon_maxval_q[31:0];
    reg_smon_freeruntimer_next           = reg_smon_freeruntimer_q;
    reg_smon_latency_freeruntimer_next   = reg_smon_latency_freeruntimer_q;
    reg_smon_latency_switch_next         = reg_smon_latency_switch_q;
    reg_smon_latency_on_next             = reg_smon_latency_on_q;


    //---------------------------------------------------------------------------------------------------
    // Decode the CFG register
    //---------------------------------------------------------------------------------------------------
    wire_smon_cfg_q_enable               = reg_smon_cfg0_q[0];
    wire_smon_cfg_q_0autoenable          = reg_smon_cfg0_q[1];
    wire_smon_cfg_q_countertype0[3:0]    = reg_smon_cfg0_q[7:4];
    wire_smon_cfg_q_countertype1[3:0]    = reg_smon_cfg0_q[11:8];
    wire_smon_cfg_q_countermode[3:0]     = reg_smon_cfg0_q[15:12];
    wire_smon_cfg_q_stopcounterovfl      = reg_smon_cfg0_q[16];
    wire_smon_cfg_q_intcounterovfl       = reg_smon_cfg0_q[17];
    wire_smon_cfg_q_statcounter0ovfl     = reg_smon_cfg0_q[18];
    wire_smon_cfg_q_statcounter1ovfl     = reg_smon_cfg0_q[19];
    wire_smon_cfg_q_stoptimerovfl        = reg_smon_cfg0_q[20];
    wire_smon_cfg_q_inttimerovfl         = reg_smon_cfg0_q[21];
    wire_smon_cfg_q_stattimerovfl        = reg_smon_cfg0_q[22];
    wire_smon_cfg_q_timerprescale[4:0]   = reg_smon_cfg0_q[28:24];
    wire_smon_cfg_q_smon0[7:0]           = reg_smon_cfg1_q[7:0];
    wire_smon_cfg_q_smon1[7:0]           = reg_smon_cfg1_q[15:8];


    //---------------------------------------------------------------------------------------------------
    // Check SMON0 & SMON1 & TIMER for overflow
    //---------------------------------------------------------------------------------------------------
    if ( wire_smon_cfg_q_0autoenable & wire_cnt0_v )  begin 
      reg_smon_cfg0_next[0]  = 1'b1;
      reg_smon_cfg0_next[1]  = 1'b0;
    end

    if (wire_smon_cfg_q_enable) begin

        reg_smon_freeruntimer_next           = wire_smon_freeruntimer_p1;
        reg_smon_latency_freeruntimer_next   = wire_smon_latency_freeruntimer_p1;

        // check SMON_TIMER overflow OR exceede maxval
        if (reg_smon_timer_q[32] | (reg_smon_timer_q[31:0] > reg_smon_maxval_q[31:0]) ) begin
            reg_smon_cfg0_next[22] = 1'b1;
            if (wire_smon_cfg_q_stoptimerovfl) begin wire_smon_cfg_q_enable = 1'b0; end
        end
  
        // check SMON_COUNTER0 overflow
        if (reg_smon_cnt0_q[32]) begin
            reg_smon_cfg0_next[18] = 1'b1;
            if (wire_smon_cfg_q_stopcounterovfl) begin wire_smon_cfg_q_enable = 1'b0; end 
        end 
    
        // check SMON_COUNTER1 overflow
        if (reg_smon_cnt1_q[32]) begin
            reg_smon_cfg0_next[19] = 1'b1;
            if (wire_smon_cfg_q_stopcounterovfl) begin wire_smon_cfg_q_enable = 1'b0; end
        end

        if (wire_smon_cfg_q_enable == 1'b0) begin
            reg_smon_cfg0_next[0]  = 1'b0;
        end

    end


    //---------------------------------------------------------------------------------------------------
    // updated TIMER & SMON0 & SMON1
    //---------------------------------------------------------------------------------------------------
    if (wire_smon_cfg_q_enable) begin
        // update SMON_TIMER
        if ( (  wire_smon_cfg_q_timerprescale == 5'd0                                              ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd1 ) & (reg_smon_freeruntimer_q[0]    ==  1'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd2 ) & (reg_smon_freeruntimer_q[1:0]  ==  2'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd3 ) & (reg_smon_freeruntimer_q[2:0]  ==  3'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd4 ) & (reg_smon_freeruntimer_q[3:0]  ==  4'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd5 ) & (reg_smon_freeruntimer_q[4:0]  ==  5'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd6 ) & (reg_smon_freeruntimer_q[5:0]  ==  6'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd7 ) & (reg_smon_freeruntimer_q[6:0]  ==  7'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd8 ) & (reg_smon_freeruntimer_q[7:0]  ==  8'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd9 ) & (reg_smon_freeruntimer_q[8:0]  ==  9'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd10) & (reg_smon_freeruntimer_q[9:0]  == 10'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd11) & (reg_smon_freeruntimer_q[10:0] == 11'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd12) & (reg_smon_freeruntimer_q[11:0] == 12'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd13) & (reg_smon_freeruntimer_q[12:0] == 13'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd14) & (reg_smon_freeruntimer_q[13:0] == 14'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd15) & (reg_smon_freeruntimer_q[14:0] == 15'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd16) & (reg_smon_freeruntimer_q[15:0] == 16'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd17) & (reg_smon_freeruntimer_q[16:0] == 17'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd18) & (reg_smon_freeruntimer_q[17:0] == 18'd0) ) |
             ( (wire_smon_cfg_q_timerprescale == 5'd19) & (reg_smon_freeruntimer_q[18:0] == 19'd0) ) |
             ( (wire_smon_cfg_q_timerprescale >  5'd19) & (reg_smon_freeruntimer_q[19:0] == 20'd0) ) ) begin
                reg_smon_timer_next[32:0] = wire_smon_timer_31_0_p1;
        end


        // SMON_COUNTER0
        if ( wire_cnt0_v & ( wire_smon_cfg_q_countertype0[3]==1'b0 )                                                                      ) begin wire_compare0_v = 1'b1; end
        if ( wire_cnt0_v & ( wire_smon_cfg_q_countertype0[3]==1'b1 ) & ( reg_smon_comp0_q == wire_cnt0_comp )                             ) begin wire_compare0_v = 1'b1; end
 
        if ( (wire_cnt0_v & wire_compare0_v & ( wire_smon_cfg_q_countertype0[2:0] == 3'd0 ) )                                             ) begin wire_trigger0_v = 1'b1; end
        if ( (wire_cnt0_v & wire_compare0_v & ( wire_smon_cfg_q_countertype0[2:0] == 3'd1 ) )                                             ) begin wire_trigger0_v = 1'b1; end
        if ( (wire_cnt0_v & wire_compare0_v & ( wire_smon_cfg_q_countertype0[2:0] == 3'd2 ) ) & ( wire_cnt0_val > reg_smon_cnt0_q[31:0] ) ) begin wire_trigger0_v = 1'b1; end
        if ( (wire_cnt0_v & wire_compare0_v & ( wire_smon_cfg_q_countertype0[2:0] == 3'd3 ) ) & ( reg_cnt0_switch_q == 1'b0 )             ) begin wire_trigger0_v = 1'b1; reg_cnt0_switch_next = 1'b1;end
        if ( (wire_cnt0_v & wire_compare0_v & ( wire_smon_cfg_q_countertype0[2:0] == 3'd4 ) )                                             ) begin wire_trigger0_v = 1'b1; end
        
        
        // SMON_COUNTER1
        if ( wire_cnt1_v & ( wire_smon_cfg_q_countertype1[3] == 1'b0 )                                                                    ) begin wire_compare1_v = 1'b1; end 
        if ( wire_cnt1_v & ( wire_smon_cfg_q_countertype1[3] == 1'b1 ) & (reg_smon_comp1_q == wire_cnt1_comp )                            ) begin wire_compare1_v = 1'b1; end 

        if ( (wire_cnt1_v & wire_compare1_v & ( wire_smon_cfg_q_countertype1[2:0] == 3'd0 ) )                                             ) begin wire_trigger1_v = 1'b1; end
        if ( (wire_cnt1_v & wire_compare1_v & ( wire_smon_cfg_q_countertype1[2:0] == 3'd1 ) )                                             ) begin wire_trigger1_v = 1'b1; end
        if ( (wire_cnt1_v & wire_compare1_v & ( wire_smon_cfg_q_countertype1[2:0] == 3'd2 ) ) & ( wire_cnt1_val > reg_smon_cnt1_q[31:0] ) ) begin wire_trigger1_v = 1'b1; end
        if ( (wire_cnt1_v & wire_compare1_v & ( wire_smon_cfg_q_countertype1[2:0] == 3'd3 ) ) & ( reg_cnt1_switch_q == 1'b0 )             ) begin wire_trigger1_v = 1'b1; reg_cnt1_switch_next = 1'b1;end
        if ( (wire_cnt1_v & wire_compare1_v & ( wire_smon_cfg_q_countertype1[2:0] == 3'd4 ) )                                             ) begin wire_trigger1_v = 1'b1; end


        // Independant mode
        if ( wire_smon_cfg_q_countermode == 4'd0 ) begin
          // SMON_COUNTER0
          if (wire_trigger0_v & (wire_smon_cfg_q_countertype0[2:0]==3'd0)) begin reg_smon_cnt0_next[32:0] = wire_smon_cnt0_31_0_pval0; end
          if (wire_trigger0_v & (wire_smon_cfg_q_countertype0[2:0]==3'd1)) begin reg_smon_cnt0_next[32:0] = wire_smon_cnt0_31_0_p1; end
          if (wire_trigger0_v & (wire_smon_cfg_q_countertype0[2:0]==3'd2)) begin reg_smon_cnt0_next[32:0] = {1'b0,wire_cnt0_val[31:0]}; end
          if (wire_trigger0_v & (wire_smon_cfg_q_countertype0[2:0]==3'd3)) begin reg_smon_cnt0_next[32:0] = {1'b0,reg_smon_timer_q[31:0]}; end
          if (wire_trigger0_v & (wire_smon_cfg_q_countertype0[2:0]==3'd4)) begin reg_smon_cnt0_next[32:0] = {1'b0,reg_smon_timer_q[31:0]}; end
  
          // SMON_COUNTER1
          if (wire_trigger1_v & (wire_smon_cfg_q_countertype1[2:0]==3'd0)) begin reg_smon_cnt1_next[32:0] = wire_smon_cnt1_31_0_pval1; end
          if (wire_trigger1_v & (wire_smon_cfg_q_countertype1[2:0]==3'd1)) begin reg_smon_cnt1_next[32:0] = wire_smon_cnt1_31_0_p1; end
          if (wire_trigger1_v & (wire_smon_cfg_q_countertype1[2:0]==3'd2)) begin reg_smon_cnt1_next[32:0] = {1'b0,wire_cnt1_val[31:0]}; end
          if (wire_trigger1_v & (wire_smon_cfg_q_countertype1[2:0]==3'd3)) begin reg_smon_cnt1_next[32:0] = {1'b0,reg_smon_timer_q[31:0]}; end
          if (wire_trigger1_v & (wire_smon_cfg_q_countertype1[2:0]==3'd4)) begin reg_smon_cnt1_next[32:0] = {1'b0,reg_smon_timer_q[31:0]}; end
        end


        // Average mode
        if ( wire_smon_cfg_q_countermode == 4'd3 ) begin
          if ( wire_trigger0_v ) begin 
              reg_smon_cnt0_next[32:0] = wire_smon_cnt0_31_0_p1;
              reg_smon_cnt1_next[32:0] = wire_smon_cnt1_31_0_pval0;
          end
        end 


        // latency mode 
        if ( (wire_smon_cfg_q_countermode == 4'd1) | (wire_smon_cfg_q_countermode == 4'd2) | (wire_smon_cfg_q_countermode == 4'd4) | (wire_smon_cfg_q_countermode == 4'd5) ) begin

          if (wire_trigger1_v & reg_smon_latency_on_q) begin 

            // ave latency
            if ( (wire_smon_cfg_q_countermode == 4'd1) ) begin
              reg_smon_cnt0_next[32:0] = wire_smon_cnt0_31_0_p1;
              reg_smon_cnt1_next[32:0] = wire_smon_cnt1_31_0_plfr;
            end
  
            // minmax latency
            if ( (wire_smon_cfg_q_countermode == 4'd2) ) begin
              if (reg_smon_latency_freeruntimer_q < reg_smon_cnt0_q[31:0]) begin reg_smon_cnt0_next[32:0] = {1'b0,reg_smon_latency_freeruntimer_q}; end
              if (reg_smon_latency_freeruntimer_q > reg_smon_cnt1_q[31:0]) begin reg_smon_cnt1_next[32:0] = {1'b0,reg_smon_latency_freeruntimer_q}; end
            end

            // ave latency 1start/1stop
            if ( (wire_smon_cfg_q_countermode == 4'd4) & reg_smon_latency_switch_q ) begin
              reg_smon_cnt0_next[32:0] = wire_smon_cnt0_31_0_p1;
              reg_smon_cnt1_next[32:0] = wire_smon_cnt1_31_0_plfr;
            end

            // ave latency incrementals (1start multiple stops)
            if ( (wire_smon_cfg_q_countermode == 4'd5) ) begin
              reg_smon_cnt0_next[32:0] = wire_smon_cnt0_31_0_p1;
              reg_smon_cnt1_next[32:0] = wire_smon_cnt1_31_0_plfr;
              reg_smon_latency_freeruntimer_next = 32'd1;
            end

            reg_smon_latency_switch_next=1'b0;
          end     

          if ( wire_trigger0_v ) begin
            reg_smon_latency_on_next=1'b1;
            reg_smon_latency_switch_next=1'b1;
            reg_smon_latency_freeruntimer_next = 32'd1;
          end

        end


        //---------------------------------------------------------------------------------------------------
        // Assign Interrupt Outputs
        //---------------------------------------------------------------------------------------------------
        out_smon_interrupt = ( (wire_smon_cfg_q_intcounterovfl & wire_smon_cfg_q_statcounter0ovfl) | 
                               (wire_smon_cfg_q_intcounterovfl & wire_smon_cfg_q_statcounter1ovfl) | 
                               (wire_smon_cfg_q_inttimerovfl & wire_smon_cfg_q_stattimerovfl) );

    end
  end

  //---------------------------------------------------------------------------------------------------
  // Assign CFG Outputs
  //---------------------------------------------------------------------------------------------------
  assign out_smon_enabled = wire_smon_cfg_q_enable | wire_smon_cfg_q_0autoenable ;
  assign out_smon_cfg0_data[31:0] = (disable_smon == 1'b0) ? {2'b01,reg_smon_cfg0_q[29:0]} : 32'd0 ;
  assign out_smon_cfg1_data[31:0] = (disable_smon == 1'b0) ? reg_smon_cfg1_q[31:0] : 32'd0 ;
  assign out_smon_cfg2_data[31:0] = (disable_smon == 1'b0) ? reg_smon_comp0_q[31:0] : 32'd0 ;
  assign out_smon_cfg3_data[31:0] = (disable_smon == 1'b0) ? reg_smon_comp1_q[31:0] : 32'd0 ;
  assign out_smon_cfg4_data[31:0] = (disable_smon == 1'b0) ? reg_smon_cnt0_q[31:0] : 32'd0 ;
  assign out_smon_cfg5_data[31:0] = (disable_smon == 1'b0) ? reg_smon_cnt1_q[31:0] : 32'd0 ;
  assign out_smon_cfg6_data[31:0] = (disable_smon == 1'b0) ? reg_smon_timer_q[31:0] : 32'd0 ;
  assign out_smon_cfg7_data[31:0] = (disable_smon == 1'b0) ? reg_smon_maxval_q[31:0] : 32'd0 ;

//--------------------------------------------------------------------------------------------
// Coverage

`ifdef HQM_COVER_ON

  covergroup AW_smon_CG (int index) @(posedge clk);
    option.per_instance = 1;

    AW_smon_CP_mon_v: coverpoint in_mon_v[index] iff ((rst_n === 1'b1) && (wire_mon_val[index] != 0));
  endgroup

  generate
    for (g=0; g<WIDTH; g=g+1) begin: cg

      AW_smon_CG AW_smon_CG_inst = new(g);
    end
 endgenerate

`endif


endmodule 

