
///
///  INTEL CONFIDENTIAL
///
///  Copyright 2015 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///
//`timescale 1 ns / 100 ps

// clk_reset_filter.vs
// 1 nov 2011  clint hastings


// Don't lint the instrumentation code
`ifndef LINT_ON

module hqm_clk_reset_filter (rtl_reset_in,        // rtl reset
                            tb_reset_in,         // tb reset in - not filtered
                            clk_in,              // rtl clock
                            power_present_in,
                            qual_reset_out,
                            unqual_reset_out,
                            qual_clk_out,
                            unqual_clk_out,
                            reset_start,
                            reset_end,
                            qualified_time
);

//
// PARAMETERS
//

// The number of clocks before a reset is considered 'qualified'.  This only
// is applicable to determining whether a reset de-assertion is a 'reset_end' event
// or not.
// Default:  16 Clocks
parameter reset_filter_width = 16;

// The active level used for the reset RTL signal.
// Default:  ACTIVE_HIGH
parameter active_reset_level = 1;

// The voltage domain this clk_reset_filter is instantiated in.
// Default:  "NO_VOLTAGE_DOMAIN_SPECIFIED"
parameter voltage_domain     = "NO_VOLTAGE_DOMAIN_SPECIFIED";  


//
// OUTPUTS
//
output  qual_reset_out;
output  unqual_reset_out;
output  qual_clk_out;
output  unqual_clk_out;
output  reset_start;
output  qualified_time;
  
output  reset_end;


//
//INPUTS
//
input  logic  rtl_reset_in; // depends on active_reset_level
input  logic  tb_reset_in;  // always active high
input  logic  clk_in;
input  logic  power_present_in;  //0=power lost  1=power good


//
// INTERNAL
//
logic   rtl_reset_in_q;
logic   rtl_reset_in_qq;
int     reset_cnt, reset_cnt_q, reset_cnt_qq;
logic   reset_seen_tmp2;
logic   reset_start_tmp, reset_end_tmp2;
reg     sticky_power_present;
reg     qual_for_clk_use;
reg     power_present_in_q;
reg     reset_done_seen;
reg     reset_asserted_initially;
reg     reset_flag;
reg     initial_reset_pulse;
int     my_reset_filter_width;  // so it can be changed
reg     qual_reset_out_tmp;

// Count of clocks
int     qual_clk_count;
int     unqual_clk_count;


// wires for outputs
wire    qual_reset_out;
wire    unqual_reset_out;
wire    qual_clk_out;
wire    unqual_clk_out;
wire    reset_start;
wire    reset_end;
wire    qualified_time_raw;
wire    qualified_time;

//`ifdef MPP
//import UPF::*;
//power_state_simstate upf_simstate;
//`endif
logic power_present_simstate;
logic power_present_simstate_q;
//`ifdef
//initial begin 
//    #0;
//    if(upf_simstate == UPF::NORMAL) power_present_simstate = 1; else power_present_simstate = 0;
//    $display($time, " fs %m: [CRA] power present = %0d", power_present_simstate);
//end 
//always_comb begin //@(upf_simstate) begin
//    if(upf_simstate == UPF::NORMAL) power_present_simstate = 1; else power_present_simstate = 0;
//    $display($time, " fs %m: [CRA] power present = %0d", power_present_simstate);
//end
//`else
    always_comb begin
       power_present_simstate = power_present_in;
       $display($time, " fs %m: [CRA] NO UPF: power present = %0d", power_present_simstate);
    end
//`endif
initial begin

    reset_cnt             = 0;
    reset_cnt_q              = 0;
    reset_cnt_qq             = 0;
    reset_seen_tmp2          = 0;
    rtl_reset_in_q           = rtl_reset_in;
    rtl_reset_in_qq          = rtl_reset_in;
    reset_start_tmp          = 0;
    reset_end_tmp2           = 0;
    reset_done_seen          = 1;  // so first reset_start will be asserted
    power_present_simstate_q       = 0; //power_present_simstate;
    sticky_power_present     = 0; //power_present_simstate;  // 1 ???
    my_reset_filter_width    = reset_filter_width;
    reset_flag               = 1;
    initial_reset_pulse      = 0;
    reset_asserted_initially = (rtl_reset_in === active_reset_level);
    qual_reset_out_tmp       = 1;
    qual_clk_count           = 0;
    unqual_clk_count         = 0;
end


// Due to a potential VCS race condition between clk_in, rtl_reset_in,
// and rtl_reset_in_q causing reset_start_tmp to not be asserted, some
// new code is used to both use a non-blocking clk_in_tmp as well
// as a negedge to latch rtl_reset_in_q
logic clk_in_tmp ;
always @(clk_in) begin
    clk_in_tmp <= (clk_in === 1'b1) ? 1 : 0;
end

always @(negedge clk_in_tmp) begin

    // The rtl_reset_in latchign is done here to make sure it is seen on the 
    // posedge logic, and combinatorial logic behaves as expected.  The
    // main dependent piece of logic is the reset_start_tmp ... that is the
    // main timing issue to deal with for these latches.
    rtl_reset_in_q      <= rtl_reset_in;
    rtl_reset_in_qq     <= rtl_reset_in_q;

end


always @(posedge clk_in_tmp) begin
    // do not increment reset counter when
    //   1. current or previous values of reset do not match the active value
    //   2. or power was lost
    // ELSE increment when reset counter is less than reset_filter_width
    reset_cnt        <= ((rtl_reset_in != active_reset_level) || (rtl_reset_in_qq != active_reset_level) || !power_present_simstate) ? 0 : (reset_cnt < my_reset_filter_width) ? (reset_cnt + 1) : reset_cnt;

    // reset detected when reset is active value  AND
    //  reset counter matches the filter width (-2 due to blocking assignments)
    reset_seen_tmp2  <= (rtl_reset_in == active_reset_level) && (reset_cnt >= (my_reset_filter_width - 2));


`ifdef EMULATION
    // detect first cycle of reset - FOR EMULATION
    reset_start_tmp  <= ((rtl_reset_in == active_reset_level) &&
                         (rtl_reset_in_qq != active_reset_level));
`endif

`ifndef EMULATION
    // detect first cycle of reset - NOT for emulation
    reset_start_tmp  <= ((rtl_reset_in == active_reset_level) &&
                         ((rtl_reset_in_qq != active_reset_level) ||
                          (rtl_reset_in_qq === 1'bx) ||
                          (rtl_reset_in_qq === 1'bz)) &&
                         (rtl_reset_in_q !== 1'bz) &&
                         (rtl_reset_in_q !== 1'bx) &&
                         (rtl_reset_in !== 1'bz) &&
                         (rtl_reset_in !== 1'bx));
`endif


    // detect last cycle of reset_seen_tmp2 - where previous==1,current==0
    reset_end_tmp2   <= (reset_seen_tmp2 && ((rtl_reset_in != active_reset_level) && (rtl_reset_in_qq == active_reset_level)));

    reset_cnt_qq        <= reset_cnt_q;
    reset_cnt_q         <= reset_cnt;
    power_present_simstate_q  <= power_present_simstate;
    if (reset_start_tmp)
        reset_done_seen = 0;
    else if (reset_end_tmp2)
        reset_done_seen = 1;

    // code to help assert reset_start for one clock if reset is initially asserted
    initial_reset_pulse <= reset_flag & reset_asserted_initially;
    reset_flag <= 0;  // only one time

end  // posedge clk_in_tmp loop


//
// sticky_power_present is used to qualify the QUAL_CLK_OUT signal
//
always @(reset_end_tmp2 or power_present_simstate) begin
    if (power_present_simstate !== 1'b1)   //negedge
        begin
            sticky_power_present <= 1'b0;
            $display("[%10t] [CRA] (%m) QUAL CLK OFF because negedge power_present_simstate=%b sticky=%b",$time,power_present_simstate,sticky_power_present);
        end
    else if (reset_end_tmp2)  // posedge
        begin
            sticky_power_present <= 1'b1;
            //$display("[%10t] [CRA] (%m) sticky_power_present=>1  power_present_simstate=%b sticky=%b",$time,power_present_simstate,sticky_power_present);
        end
end  // reset_end_tmp2/power_present_simstate loop


    always_comb begin
        if ((power_present_simstate !== 1'b1) || (rtl_reset_in === active_reset_level))
            begin
                // turn off qualified clock if power fails or if reset is asserted
                qual_for_clk_use = 1'b0;
            end
        else if ((reset_end_tmp2) || ((reset_cnt == 0) && (reset_cnt_q < (my_reset_filter_width - 2))))
            begin
                // turn on qualified clock when detecting valid reset deassertion or after glitch
                if (reset_end_tmp2)
                    begin
                        // Only enable qualified clocks on a qualified reset de-assertion
                        qual_for_clk_use = 1'b1;
                    end
            end
    end  // always_comb


    //
    // The QUAL_RESET_OUT signal is to be asserted on the reset_start assertion and remain asserted
    // until the RESET_END assertion.
    //
    always @(reset_start or reset_end) begin
        if (reset_start === 1'b1) begin
            qual_reset_out_tmp <= 1'b1;
        end else if (reset_end === 1'b1) begin
            qual_reset_out_tmp <= 1'b0;
        end
    end



    // qualified_time
    //   - Defines the timeframe post-reset de-assertion that is 'qualified'
    assign qualified_time_raw  = qual_for_clk_use & !tb_reset_in &
                                 (sticky_power_present ||
                                 (reset_end_tmp2 && !sticky_power_present));
    assign qualified_time      = (qualified_time_raw === 1'b1) ? 1 : 0;

    always @(negedge qualified_time) begin
        if (qualified_time === 1'b0) begin
            $display("[%10t] [CRA] Leaving  Qualified time (%m)",$time);
        end
    end
    always @(posedge qualified_time) begin
        if (qualified_time === 1'b1) begin
            $display("[%10t] [CRA] Entering Qualified time (%m)",$time);
        end
    end

    // Reset outputs
    assign unqual_reset_out = active_reset_level ? (rtl_reset_in || tb_reset_in) : (rtl_reset_in && tb_reset_in);
    assign qual_reset_out   = (qual_reset_out_tmp === 1'b1) ? 1 : 0;
    assign reset_start      = (((reset_start_tmp & reset_done_seen) | initial_reset_pulse) === 1'b1) ? 1 : 0;
    assign reset_end        = (reset_end_tmp2 === 1'b1) ? 1 : 0;

    // Clk outputs
    assign unqual_clk_out   = clk_in;
    assign qual_clk_out     = ((clk_in === 1'b1) & (qualified_time === 1'b1)) ? 1 : 0;



    always @(posedge qual_clk_out) begin
        qual_clk_count <= qual_clk_count + 1;
    end

    always @(posedge clk_in_tmp) begin
        if (clk_in_tmp === 1'b1) begin
            unqual_clk_count <= unqual_clk_count + 1;
        end
    end

    //
    // This code is to dump CLOCK/TIME/WALLCLOCK information to a text file when enabled
    //
    integer return_val_inst; 
    bit     cra_profiling_dump_enable;
    int     cra_profiling_dump_mod;
    initial begin
        cra_profiling_dump_mod = 8;
        if (cra_profiling_dump_enable == 1'b1) begin
            $display("[%10t] [CRA] (%m) CRA will dump profiling date to universal_timestamp.txt",$time);
        end
    end

    bit WriteTrig;
    assign WriteTrig = (cra_profiling_dump_enable == 1) && ((unqual_clk_count % cra_profiling_dump_mod) == 0);

    // write timestamp to separate file
    always @(posedge WriteTrig)
    begin
       // output is <wall sec>s:<sim time>
       // vcs system task
       return_val_inst = $systemf("/bin/date +'%s, %f, %d' >> universal_timestamps.txt", "%s.%N", $realtime, unqual_clk_count);
    end

    // write out timestamp at the end of simulation
`ifndef KNL_UNIPHY_BDX_STANDALONE
    `ifdef INST_ON
        `ifndef EMULATION
        final begin
            if (cra_profiling_dump_enable == 1) begin
                return_val_inst = $systemf("/bin/date +'%s, %f, %d' >> universal_timestamps.txt", "%s.%N", $realtime, unqual_clk_count);
            end
        end
    `endif
    `endif
`endif

endmodule  // clk_reset_filter

`endif // LINT_ON


