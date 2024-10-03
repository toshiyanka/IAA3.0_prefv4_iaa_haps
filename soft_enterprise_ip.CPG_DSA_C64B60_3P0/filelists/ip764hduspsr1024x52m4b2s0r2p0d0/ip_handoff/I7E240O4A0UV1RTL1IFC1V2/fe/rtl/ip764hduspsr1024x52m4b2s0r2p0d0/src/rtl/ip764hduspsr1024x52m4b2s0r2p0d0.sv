//==============================================================
/////////////////////////////////////////////////////////////////////////////////////////////
// Intel Confidential                                                                      //
/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2023 Intel Corporation. The information contained herein is the proprietary   //
// and confidential information of Intel or its licensors, and is supplied subject to, and //
// may be used only in accordance with, previously executed agreements with Intel.         //
// EXCEPT AS MAY OTHERWISE BE AGREED IN WRITING: (1) ALL MATERIALS FURNISHED BY INTEL      //
// HEREUNDER ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND; (2) INTEL SPECIFICALLY     //
// DISCLAIMS ANY WARRANTY OF NONINFRINGEMENT, FITNESS FOR A PARTICULAR PURPOSE OR          //
// MERCHANTABILITY; AND (3) INTEL WILL NOT BE LIABLE FOR ANY COSTS OF PROCUREMENT OF       //
// SUBSTITUTES, LOSS OF PROFITS, INTERRUPTION OF BUSINESS, OR FOR ANY OTHER SPECIAL,       //
// CONSEQUENTIAL OR INCIDENTAL DAMAGES, HOWEVER CAUSED, WHETHER FOR BREACH OF WARRANTY,    //
// CONTRACT, TORT, NEGLIGENCE, STRICT LIABILITY OR OTHERWISE.                              //
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//  Vendor:                Intel Corporation                                               //
//  Product:               c764hduspsr                                                     //
//  Version:               r1.0.0                                                          //
//  Technology:            p1276.4                                                         //
//  Celltype:              MemoryIP                                                        //
//  IP Owner:              Intel CMO                                                       //
//  Creation Time:         Tue Mar 28 2023 19:16:06                                        //
//  Memory Name:           ip764hduspsr1024x52m4b2s0r2p0d0                                 //
//  Memory Name Generated: ip764hduspsr1024x52m4b2s0r2p0d0                                 //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////

//==============================================================

//lintra push -60039, -2165, -50004


//---------------------------------------------------------------------------
// control the defines for FPGA/Emulation usage
//---------------------------------------------------------------------------
`ifdef INTEL_FPGA
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_TESTMODE
  `ifdef INTC_MEM_ESP
    `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
    `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_SIM
  `endif
`else
  `ifdef INTEL_EMULATION
    `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EMULATION
    `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
    `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
    `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_TESTMODE
    `ifdef INTC_MEM_ESP
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_SIM
    `endif
  `else
    `ifdef INTC_MEM_FAST_SIM
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EMULATION
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_TESTMODE
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_SIM
      `ifdef INTC_MEM_ESP
        `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
      `endif
    `else
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
    `endif
  `endif
`endif
`ifdef INTEL_SVA_OFF
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
`endif // INTEL_SVA_OFF
`ifdef INTC_MEM_TESTMODE
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_TESTMODE
`endif // INTC_MEM_TESTMODE
`ifdef INTC_MEM_EF_SIM
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_SIM
`endif // INTC_MEM_EF_SIM

//---------------------------------------------------------------------------
// FI ARRAY setting
//---------------------------------------------------------------------------
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS

`ifdef INTC_MEM_fault_norepair
  `define INTC_ip764hduspsr1024x52m4b2s0r2p0d0_local_fi_nrep
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
`endif
`ifdef INTC_MEM_fault_repair
  `define INTC_ip764hduspsr1024x52m4b2s0r2p0d0_local_fi_rep
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
`endif
`ifdef INTC_MEM_fault_single
  `define INTC_ip764hduspsr1024x52m4b2s0r2p0d0_local_fi_srep
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
`endif

`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_fault_norepair
  `define INTC_ip764hduspsr1024x52m4b2s0r2p0d0_local_fi_nrep
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
`endif
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_fault_repair
  `define INTC_ip764hduspsr1024x52m4b2s0r2p0d0_local_fi_rep
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
`endif
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_fault_single
  `define INTC_ip764hduspsr1024x52m4b2s0r2p0d0_local_fi_srep
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
`endif

`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS

//pd0 - primary supply
//pd1 - array supply if dual power
//pd2 - gated supply if power gate

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// VCCSOC
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
module ip764hduspsr1024x52m4b2s0r2p0d0_output (
  input  wire [52:0]  rd_clkq,
  input  wire shutoff,
  input  wire shutoffout,
  input  wire fwen,
  input  wire cks02hrdm1n44,
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  input  wire cks02hrdm1n44_np,
`endif // INTC_MEM_LINT
  input  wire deepslp,
  input  wire sleep,
  input  wire pd0, // primary supply monitor
  input  wire pd1, // array supply monitor
  input  wire pd2, // gated supply monitor
  input  wire stbyp,
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  input  wire ren,
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

  output wire [52:0] q
  );
//--------------------------------------------------------------------------
//                             MAIN Procedure
//--------------------------------------------------------------------------
  reg shutoff_ds_fw;

`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  reg  Xbit;
  reg  [52:0]  Xreg;
`endif
  reg  [52:0]  datas_ms02h;
  reg  hold;
  wire readclock;

`ifndef INTC_MEM_LINT // Required to prevent Lintra hangup
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  assign readclock = cks02hrdm1n44 | (ip764hduspsr1024x52m4b2s0r2p0d0.parg === 1'b1 & ip764hduspsr1024x52m4b2s0r2p0d0.xclk === 1'bx);
`else
  assign readclock = cks02hrdm1n44;
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  wire readclock_np;
  assign readclock_np = cks02hrdm1n44_np;
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
`else
  assign readclock = cks02hrdm1n44;
`endif // INTC_MEM_LINT

`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

`ifndef INTC_MEM_LINT
  initial
  begin
    // initialize output hold flag (upf sims will re-execute when domain power is restored)
    hold <= 1'b0;
  end
`endif // INTC_MEM_LINT

//lintra push -50000
always @(pd0 or fwen or shutoff or shutoffout or deepslp)
begin
  if (pd0 === 1'b1)
  begin
    if (fwen | shutoff | shutoffout | deepslp)
    begin
      shutoff_ds_fw = 1'b1;
    end
    else
    begin
      shutoff_ds_fw = 1'b0;
    end
  end
  else
  begin
    shutoff_ds_fw = 1'b0;
  end
end
//lintra pop
`endif

// Final Output Latch
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
//lintra push -50000, -60029, -60062, -0529, -0566
  always @(readclock or rd_clkq or fwen or deepslp or shutoff or shutoffout or sleep or pd0 or pd1 or pd2 or stbyp) // OUTPUT_XLATCH
    begin
      if (pd0 === 1'b1) begin // gated supply on
        if ((^{fwen,deepslp,shutoff,shutoffout,sleep} !== 1'b1) && (^{fwen,deepslp,shutoff,shutoffout,sleep} !== 1'b0)) begin
          hold <= 1'b1;
          datas_ms02h <= Xreg; // set output latch to 'bx when pme X
        end

        else if (hold) begin
          if (~(fwen | deepslp | shutoff | shutoffout | sleep)) begin
            hold <= 1'b0;
          end

          if (readclock !== 1'b0) begin // hazard
            datas_ms02h <= Xreg;
          end
        end

        else if ((fwen | deepslp | shutoff | shutoffout | sleep) && ~(hold)) begin

          if (readclock !== 1'b0) begin // hazard
            hold <= 1'b1;
            datas_ms02h <= Xreg;
          end
          else if (readclock === 1'b0) begin
            if (sleep && ~(fwen | deepslp | shutoff | shutoffout)) begin
              datas_ms02h <= datas_ms02h;
            end
            else if (fwen | deepslp | shutoff | shutoffout) begin
              datas_ms02h <= {53{1'b0}};
            end
          end
          else begin
            datas_ms02h <= datas_ms02h;
          end
        end

        else begin
          hold <= 1'b0;

          if (readclock !== 1'b0) begin
            if (stbyp === 1'b0) datas_ms02h <= rd_clkq; // data launch on rising edge
            else datas_ms02h <= datas_ms02h;
          end
          else if (readclock === 1'b0) begin
            if (stbyp === 1'b0) datas_ms02h <= datas_ms02h;
            else datas_ms02h <= rd_clkq;               // data launch on falling edge
          end

        end
      end
      else begin
        hold <= 1'b0;
        datas_ms02h <= Xreg;
      end
    end

    assign q = datas_ms02h;
//lintra pop
`endif

`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
// -------------------------------------------------------------------
// EFFM version of output latch
// -------------------------------------------------------------------
//  event rdqs, rdq;
  wire s_or_f, s_or_f_b, rdclk;
//lintra push -60003
  or   or_l_sf        (s_or_f, sleep, deepslp, shutoff, fwen);
  not  inv_l_sf       (s_or_f_b, s_or_f);
  // effect of sleep on read
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  and  and_rdclk      (rdclk, s_or_f_b, readclock_np);
`else
  and  and_rdclk      (rdclk, s_or_f_b, readclock);
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
//lintra pop

  reg [52:0] q_s;
//lintra push -60029, -50000
  always @(rdclk, shutoff_ds_fw, rd_clkq) begin
    if (shutoff_ds_fw)
      q_s <= {53{1'b0}};
    else if (rdclk)
      q_s <= rd_clkq;
//      -> rdqs; end
    else
      q_s <= q_s;
  end

//  reg  ren_fl;
////lintra push -60041, -50000
//  always @(posedge readclock) begin
//    if (readclock) ren_fl <= ren;
//    else ren_fl <= ren_fl;
//  end
////lintra pop

  wire stbyp_l;
  assign stbyp_l = ~(stbyp & rdclk);
`ifndef INTC_MEM_LINT // 70023 error
//lintra push -68096
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  always @(negedge readclock_np or posedge shutoff_ds_fw) begin
`else
  always @(negedge readclock or posedge shutoff_ds_fw) begin
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
    if (shutoff_ds_fw)
      datas_ms02h <= {53{1'b0}};
//  else if (stbyp & ~sleep & ren_fl)
    else if (stbyp & ~sleep)
      datas_ms02h <= q_s;
//      -> rdq; end
    else
      datas_ms02h <= datas_ms02h;
  end
//lintra pop

  assign q = stbyp ? datas_ms02h : q_s;

//lintra pop
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
`endif // INTC_MEM_LINT


endmodule // ip764hduspsr1024x52m4b2s0r2p0d0_output

//=============================================================================
// End of VCCSOC
//=============================================================================

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// VCCSOC or VCCSRAM depending on mode
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
module ip764hduspsr1024x52m4b2s0r2p0d0_func_input (
  input  wire        clk,
  input  wire [9:0] adr,
  input  wire [52:0] din,
  input  wire        mce,
  input  wire        stbyp,
  input  wire [3:0]  rmce,
  input  wire [1:0]  wmce,
  input  wire [2:0]  wpulse,
  input  wire [2:0]  wa,
  input  wire [1:0]  ra,
  input  wire        ren,
  input  wire        wen,

  input  wire [1:0] redrowen,
  output wire       ckenfw_vs_m1n22,

  output wire [9:0] addr_fwls,
  output wire [52:0] data_fwls,
  output wire       mce_fwls,
  output wire       stbyp_fwls,
  output wire [3:0] rmce_fwls,
  output wire [1:0] wmce_fwls,
  output wire [2:0] wpulse_fwls,
  output wire [2:0] wa_fwls,
  output wire [1:0] ra_fwls,
  output wire       ren_fwls,
  output wire       wen_fwls,

  output wire [1:0] redrowen_fwls,
  output wire       pd2 // Secondary supply monitor
  );
//--------------------------------------------------------------------------
//                             MAIN Procedure
//--------------------------------------------------------------------------

  reg pd_func_input;


//`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
// wire for virtual supply monitor used for input functional signals
//  wire pd2;
//`endif


// clock
  assign ckenfw_vs_m1n22 = clk;

  assign addr_fwls = adr;
  assign data_fwls = din;
  assign mce_fwls = mce;
  assign stbyp_fwls = stbyp;
  assign rmce_fwls = rmce;
  assign wmce_fwls = wmce;
  assign wpulse_fwls = wpulse;
  assign wa_fwls = wa;
  assign ra_fwls = ra;
  assign ren_fwls = ren;
  assign wen_fwls = wen;

  assign redrowen_fwls = redrowen;
//`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
//`ifndef INTC_MEM_LINT
//  assign pd0 = pd0i; // soc supply monitor
//`endif
//`else
//  assign pd0 = 1'b1; // soc supply monitor (constrained for emulation mode)
//`endif

//lintra push -60029, -50000
  always @(clk)
  begin
    pd_func_input = 1'b1;
  end
//lintra pop

//assign pd2 = 1'b1; // Secondary supply monitor for functional input signals
  assign pd2 = pd_func_input; // Secondary supply monitor for functional input signals

endmodule // ip764hduspsr1024x52m4b2s0r2p0d0_func_input

//=============================================================================
// End of VCCSOC or VCCSRAM
//=============================================================================

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// VCCSRAM
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
module ip764hduspsr1024x52m4b2s0r2p0d0_input (
  input  wire       clk,
  input  wire       shutoff,                // active low power gate
  input  wire       deepslp,
  input  wire       sleep,
  input  wire [1:0] sbc,
  input  wire       fwen,

  output wire       shutoff_ls,             // active low power gate
  output wire       endeepsleep_ls,
  output wire       ensleep_ls,
  output wire [1:0] sbc_ls,
  output wire       fwen_ls,
  output wire       shutoffout,
  output wire       pd0                     // primary power supply monitor
  );

//--------------------------------------------------------------------------
//                             MAIN Procedure
//--------------------------------------------------------------------------

  reg pd_input;

  assign fwen_ls = fwen;
  assign endeepsleep_ls = deepslp;
  assign ensleep_ls = sleep;
  assign sbc_ls = sbc;
  assign shutoff_ls = shutoff;
// shutoffout is daisy chain from shutoff
//benign logic gate added to force UPF sim corruption when power domain is off (not feed-through)
  assign shutoffout = shutoff & 1'b1;  /*synthesis syn_noprune*/

//lintra push -60029, -50000
  always @(clk)
  begin
    pd_input = 1'b1;
  end
//lintra pop

//assign pd0 = 1'b1 ; // primary power supply monitor
  assign pd0 = pd_input; // primary power supply monitor

endmodule // ip764hduspsr1024x52m4b2s0r2p0d0_input

//=============================================================================
// End of VCCSRAM
//=============================================================================

//=============================================================================
// End of VCCSRAMGTRET
//=============================================================================

`ifndef INTC_MEM_PATH_SIZE
`define INTC_MEM_PATH_SIZE 256
`endif // INTC_MEM_PATH_SIZE

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// MAIN RTL
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//--------------------------------------------------------------------------
//                     VCCSRAMGT
//--------------------------------------------------------------------------
module ip764hduspsr1024x52m4b2s0r2p0d0_bmod (
  input  wire        clk,          // baseline clock
  input  wire        fwen,         // active high I/O firewall enable
  input  wire        shutoff,            // active low power gate
  input  wire        deepslp,    // deep sleep enable (periphery all off)
  input  wire [52:0]  din,           // input data
  input  wire        ren,           // read enable
  input  wire        wen,           // global write enable

  input  wire [1:0]  redrowen,       // redundant row enable

  input  wire [9:0]  adr,           // set to access data array
  input  wire        sleep,        // data sleep enable
  input  wire [1:0]  sbc,         // data sleep strength
//lintra push -0527
  input  wire        mce,      // data sct pulse select
  input  wire        stbyp,    // data sct pulse select
  input  wire [3:0]  rmce,     // data sct pulse select
  input  wire [1:0]  wmce,     // data sct pulse select
  input  wire [2:0]  wpulse,   // SRAMVCC droop pulse width for WA
  input  wire [1:0]  ra,       // WL VCC droop for read assist.
  input  wire [2:0]  wa,       // SRAMVCC droop level for WA
//lintra pop

  output wire        shutoffout,               // daisy chain active low power gate
  output wire [52:0]   q            // data output
  );

//--------------------------------------------------------------------------
//                     Local logic Declarations
//--------------------------------------------------------------------------
  wire  [52:0]  rd_q;
  wire  [52:0]  rd_clkq;
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  reg                cks02hwrm1n44;
  reg                       cks02hrdm1n44;
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  wire         cks02hrdm1n44;
  wire         cks02hrdm1n44_np;
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  wire         cks02hwlm1n44;
  wire         en_ms01l;
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
//`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
//  wire         en_clkrd_ms02h;
//`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE

  reg          wen_fwls_ms01l;
  reg          ren_fwls_ms01l;
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE

//  wire         wen_fwls_ms01l;
  reg          ren_fwls_ms01l;
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  wire         wen_ms01l;
  wire         ren_ms01l;
  wire         wen_fwls;
  wire         ren_fwls;
//wire         enblfloat_fwvs_mnnh;
  wire  [1:0]  redrowen_fwls;
//  wire         wakeup_fwls; //lintra s-0531
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  reg          wakeup_fwls_ms01l;
  reg   [9:0]  addr_mnn1l;
  reg   [52:0]  data_ms01l;
  reg   [1:0]  redrowen_ms01l;
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  reg          wakeup_fwls_ms01l;
//  wire  [9:0]  addr_mnn1l;
//  wire  [52:0]  data_ms01l;
//  wire  [1:0]  redrowen_ms01l;
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  wire  [9:0]  addr_fwls;
  wire  [52:0]  data_fwls;
  wire         mce_fwls;
  wire         stbyp_fwls;
  wire  [3:0]  rmce_fwls;
  wire  [1:0]  wmce_fwls;
  wire  [2:0]  wpulse_fwls;
  wire  [2:0]  wa_fwls;
  wire  [1:0]  ra_fwls;

  wire         shutoff_ls;
//  reg   [52:0]  datas_ms02h;
  wire         wakeup;
  wire         ckenfw_vs_m1n22_wu;
  wire         ckenfw_vs_m1n22;
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  wire         ckenfw_vs_m1n22_wunp;
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  wire         secwake;

  wire         secwake_vs;
  wire         ckwrenfw_vs_m1n44;   // global write enable

  wire         fwen_ls;    // internal active low I/O firewall enable
  wire         ensleep_ls;
  wire  [1:0]  sbc_ls;
  wire         endeepsleep_ls;

// create conditional for assertions

//wire        enblfloat_mnnh;       // enable bit line float
  wire        pd0;                  // primary supply monitor
  wire        pd1;                  // array supply monitor
  wire        pd2;                  // func input supply monitor

`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
  wire         noaccess;
  wire         addrx;
  wire         noassert;

//  assign noaccess = ~((en_clkrd_ms02h & ~shutoff_ls) | ((cks02hwrm1n44 & cks02hwlm1n44) & ~fwen));
//assign noaccess = ~((cks02hrdm1n44 & ~shutoff_ls & ~endeepsleep_ls) | ((cks02hwrm1n44 & cks02hwlm1n44) & ~fwen));
  assign noaccess = ~((cks02hrdm1n44 & ~shutoff_ls & ~endeepsleep_ls) | ((cks02hwrm1n44 & cks02hwlm1n44) ));
  assign addrx = ~(^addr_mnn1l !== 1'bx); //lintra s-50002, s-0566
  assign noassert = noaccess | addrx;
`endif

  wire         dspb;

//assign dspb = deepslp | shutoff;
  assign dspb = fwen | sleep | deepslp | shutoff;
//assign enblfloat_mnnh = 1'b0;


//--------------------------------------------------------------------------
//              Primary supply domain for input signals
//              Level-Shifted signals from vccsoc --> vccsram domain
//--------------------------------------------------------------------------
  ip764hduspsr1024x52m4b2s0r2p0d0_input ip764hduspsr1024x52m4b2s0r2p0d0_input (
    .clk (clk),
    .shutoff (shutoff),
    .deepslp (deepslp),
    .sleep (sleep),
    .sbc (sbc),
    .fwen (fwen),
    .shutoff_ls (shutoff_ls),
    .endeepsleep_ls (endeepsleep_ls),
    .ensleep_ls (ensleep_ls),
    .sbc_ls (sbc_ls),
    .fwen_ls (fwen_ls),
    .shutoffout (shutoffout),
    .pd0(pd0)
  );

//--------------------------------------------------------------------------
//              Primary supply domain for output signals
//--------------------------------------------------------------------------
  ip764hduspsr1024x52m4b2s0r2p0d0_output ip764hduspsr1024x52m4b2s0r2p0d0_output (
  .rd_clkq (rd_clkq),
  .shutoff (shutoff),
  .shutoffout (shutoffout),
  .fwen (fwen),
  .cks02hrdm1n44 (cks02hrdm1n44),
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  .cks02hrdm1n44_np (cks02hrdm1n44_np),
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  .deepslp (deepslp),
  .sleep (sleep),
  .pd0(pd0),
  .pd1(pd1),
  .pd2(pd2),
  .stbyp(stbyp),
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  .ren(ren),
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

  .q (q)
  );

//--------------------------------------------------------------------------
//              Logic in vccsoc or vccsram domain depending on mode
//              Level-Shifted signals from vccsramgt --> vccsoc domain
//--------------------------------------------------------------------------
  ip764hduspsr1024x52m4b2s0r2p0d0_func_input ip764hduspsr1024x52m4b2s0r2p0d0_func_input (
    .clk (clk),
    .adr (adr),
    .din (din),
    .mce(mce),
    .stbyp(stbyp),
    .rmce(rmce),
    .wmce(wmce),
    .wpulse(wpulse),
    .ra(ra),
    .wa(wa),
    .ren (ren),
    .wen (wen),
    .redrowen (redrowen),


    .ckenfw_vs_m1n22 (ckenfw_vs_m1n22),
    .addr_fwls (addr_fwls),
    .data_fwls (data_fwls),
    .mce_fwls (mce_fwls),
    .stbyp_fwls (stbyp_fwls),
    .rmce_fwls (rmce_fwls),
    .wmce_fwls (wmce_fwls),
    .wpulse_fwls (wpulse_fwls),
    .wa_fwls (wa_fwls),
    .ra_fwls (ra_fwls),
    .ren_fwls (ren_fwls),
    .wen_fwls (wen_fwls),

    .redrowen_fwls (redrowen_fwls),
    .pd2(pd2)
  );

//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//                     Clocks / Latches
//--------------------------------------------------------------------------
// ---------
// wakeup & enables
// ---------
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
//assign wakeup = (ren_fwls_ms01l | wen_fwls_ms01l) & ~(ensleep_ls);
  assign wakeup = (ren_fwls_ms01l | wen_fwls_ms01l);
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  assign wakeup = (ren_fwls | wen_fwls) & ~(ensleep_ls) & ~(endeepsleep_ls) & ~(shutoff_ls) & ~(fwen_ls);
//assign wakeup = (ren_fwls | wen_fwls);
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

//`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE

//lintra push -2165, -60029, -70024, -50000, -0566
  always @(ckenfw_vs_m1n22,wakeup)      // LATCH_P
    begin
      if (ckenfw_vs_m1n22 !== 1'b1) wakeup_fwls_ms01l <= wakeup;
    end
//lintra pop

//`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
//  assign wakeup_fwls_ms01l = wakeup;
//`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE

//assign secwake = wakeup | wakeup_fwls_ms01l;
//assign secwake_vs = secwake & fwen_ls;

  assign secwake = wakeup | wakeup_fwls_ms01l;
  assign secwake_vs = secwake;

`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  assign ren_ms01l = ren_fwls_ms01l & secwake_vs;
  assign wen_ms01l = wen_fwls_ms01l & secwake_vs;
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  assign ren_ms01l = ren_fwls & secwake_vs;
  assign wen_ms01l = wen_fwls & secwake_vs;
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  assign en_ms01l = wen_ms01l | ren_ms01l;
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

// ---------
// Clock & Wakeup
// ---------
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  assign ckenfw_vs_m1n22_wu = ckenfw_vs_m1n22 & wakeup_fwls_ms01l; /* lintra s-30003, s-30004, s-31500, s-31503 */
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
// short pulse generation to emulate self timing
  wire ckenfw_vs_m1n22_p /* keep_net */;
  reg  halfclock /* preserve */;
  wire halfclock_b /* keep_net */;
  wire halfclock_2 /* keep_net */;
  wire halfclock_3 /* keep_net */;
  not (halfclock_b, halfclock); //lintra s-60003
  initial begin halfclock = 1'b0; end //lintra s-2041 // for ESP simulation
  // clock divider
  always @(posedge ckenfw_vs_m1n22) //lintra s-50000
    begin
      halfclock <= halfclock_b;
    end
  // two unit dlys needed to get past buffer added to output path by synthesis
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_SIM
  buf #1 (halfclock_2, halfclock) /*synthesis syn_noprune*/; //lintra s-60003
  buf #1 (halfclock_3, halfclock_2)/*synthesis syn_noprune*/; //lintra s-60003
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_SIM
  buf #1 (halfclock_2, halfclock)/*synthesis syn_noprune*/; //lintra s-60003
  buf #1 (halfclock_3, halfclock_2)/*synthesis syn_noprune*/; //lintra s-60003
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_SIM
  xor (ckenfw_vs_m1n22_p, halfclock_3, halfclock); //lintra s-60003
  and (ckenfw_vs_m1n22_wu, ckenfw_vs_m1n22_p, wakeup_fwls_ms01l); //lintra s-60003
  and (ckenfw_vs_m1n22_wunp, ckenfw_vs_m1n22, wakeup_fwls_ms01l); //lintra s-60003
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE

// ---------
// addr, wen, ren, redrowen
// ---------


`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE

//lintra push -2165, -60029, -70024, -50000, -0566
  always @(ckenfw_vs_m1n22_wu,wen_fwls)      // LATCH_P
    begin
      if (ckenfw_vs_m1n22_wu !== 1'b1) wen_fwls_ms01l <= wen_fwls;
    end
//lintra pop


//lintra push -2165, -60029, -70024, -50000, -0566
  always @(ckenfw_vs_m1n22_wu,ren_fwls)      // LATCH_P
    begin
      if (ckenfw_vs_m1n22_wu !== 1'b1) ren_fwls_ms01l <= ren_fwls;
    end
//lintra pop


//lintra push -2165, -60029, -70024, -50000, -0566
  always @(ckenfw_vs_m1n22_wu,addr_fwls)      // LATCH_P
    begin
      if (ckenfw_vs_m1n22_wu !== 1'b1) addr_mnn1l <= addr_fwls;
    end
//lintra pop


//lintra push -2165, -60029, -70024, -50000, -0566
  always @(ckenfw_vs_m1n22_wu,redrowen_fwls)      // LATCH_P
    begin
      if (ckenfw_vs_m1n22_wu !== 1'b1) redrowen_ms01l <= redrowen_fwls;
    end
//lintra pop

`else

//lintra push -2165, -60029, -70024, -50000, -0566
  always @(ckenfw_vs_m1n22,ren_fwls)      // LATCH_P
    begin
      if (ckenfw_vs_m1n22 !== 1'b1) ren_fwls_ms01l <= ren_fwls;
    end
//lintra pop

`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE

// ---------
// data, web
// ---------

`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  assign ckwrenfw_vs_m1n44 = ckenfw_vs_m1n22_wu & wen_ms01l; /* lintra s-30003, s-30004, s-31500, s-31503 */


//lintra push -2165, -60029, -70024, -50000, -0566
  always @(ckwrenfw_vs_m1n44,data_fwls)      // LATCH_P
    begin
      if (ckwrenfw_vs_m1n44 !== 1'b1) data_ms01l <= data_fwls;
    end
//lintra pop


`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  assign data_ms01l = data_fwls;

`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE

// ---------
// Write clock
// ---------
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE

//lintra push -50000
  always @(ckenfw_vs_m1n22_wu or wen_ms01l or ren_ms01l)
  begin
    cks02hwrm1n44 = ckenfw_vs_m1n22_wu & wen_ms01l;
    cks02hrdm1n44 = ckenfw_vs_m1n22_wu & ren_ms01l;
  end
//lintra pop -50000
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
// ---------
// Read clock
// ---------
  assign cks02hrdm1n44 = ckenfw_vs_m1n22_wu & ren_ms01l; /* lintra s-30003, s-30004, s-31500, s-31503 */
  assign cks02hrdm1n44_np = ckenfw_vs_m1n22_wunp & ren_fwls_ms01l; /* lintra s-30003, s-30004, s-31500, s-31503 */
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE

//lintra push -2046, -1308

// ---------
// WL clock
// ---------
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  assign cks02hwlm1n44 = ckenfw_vs_m1n22_wu & en_ms01l; /* lintra s-30003, s-30004, s-31500, s-31503 */
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

// ---------
// Read clock
// ---------
//assign cks02hrdm1n44 = ckenfw_vs_m1n22_wu & ren_ms01l; /* lintra s-30003, s-30004, s-31500, s-31503 */

//--------------------------------------------------------------------------
//  Assertions & X-propagation
//--------------------------------------------------------------------------
//Assertions for X or unknown input on fuse ports
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF

property atclk_prop(clk, rst, prop);
  @(posedge clk)
    // disable for reset or clock X
    disable iff (rst | $isunknown(clk)) prop;
endproperty : atclk_prop


  // ASSERT_KNOWN_DRIVEN
KD_sbc: assert property (atclk_prop (ckenfw_vs_m1n22_wu, noassert, (!($isunknown(sbc))))) else $error("SVA FATAL ERROR: %s -- %m at %0t", "sbc is unknown at posedge clock", $time);


  // ASSERT_KNOWN_DRIVEN
KD_mce: assert property (atclk_prop (ckenfw_vs_m1n22_wu, noassert, (!($isunknown(mce))))) else $error("SVA FATAL ERROR: %s -- %m at %0t", "mce is unknown at posedge clock", $time);


  // ASSERT_KNOWN_DRIVEN
KD_stbyp: assert property (atclk_prop (ckenfw_vs_m1n22_wu, noassert, (!($isunknown(stbyp))))) else $error("SVA FATAL ERROR: %s -- %m at %0t", "stbyp is unknown at posedge clock", $time);


  // ASSERT_KNOWN_DRIVEN
KD_rmce: assert property (atclk_prop (ckenfw_vs_m1n22_wu, noassert, (!($isunknown(rmce))))) else $error("SVA FATAL ERROR: %s -- %m at %0t", "rmce is unknown at posedge clock", $time);


  // ASSERT_KNOWN_DRIVEN
KD_wmce: assert property (atclk_prop (ckenfw_vs_m1n22_wu, noassert, (!($isunknown(wmce))))) else $error("SVA FATAL ERROR: %s -- %m at %0t", "wmce is unknown at posedge clock", $time);


  // ASSERT_KNOWN_DRIVEN
KD_wpulse: assert property (atclk_prop (ckenfw_vs_m1n22_wu, noassert, (!($isunknown(wpulse))))) else $error("SVA FATAL ERROR: %s -- %m at %0t", "wpulse is unknown at posedge clock", $time);


  // ASSERT_KNOWN_DRIVEN
KD_ra: assert property (atclk_prop (ckenfw_vs_m1n22_wu, noassert, (!($isunknown(ra))))) else $error("SVA FATAL ERROR: %s -- %m at %0t", "ra is unknown at posedge clock", $time);


  // ASSERT_KNOWN_DRIVEN
KD_wa: assert property (atclk_prop (ckenfw_vs_m1n22_wu, noassert, (!($isunknown(wa))))) else $error("SVA FATAL ERROR: %s -- %m at %0t", "wa is unknown at posedge clock", $time);


`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF

//Assertions for multiple redundant row enables in high phase
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
//L_0in_rdwrclk_redrowenbit_mutex: `ip764hduspsr1024x52m4b2s0r2p0d0_ASSERT_AT_MOST_BITS_HIGH(({redrowen_ms01l[1],redrowen_ms01l[0]}),1,noassert) `ip764hduspsr1024x52m4b2s0r2p0d0_ERR_MSG($psprintf(""));

  // ASSERT_AT_MOST_BITS_HIGH
`ifdef INTC_MEM_MODEL_TECH
  `ifndef INTC_MEM_FEV
L_0in_rdwrclk_redrowenbit_mutex: assert #0(`ifndef INTC_MEM_FEV noassert || `endif $countones({redrowen_ms01l[1],redrowen_ms01l[0]}) <= 1) else $error("SVA FATAL ERROR: %s -- %m at %0t", "", $time);
  `else
L_0in_rdwrclk_redrowenbit_mutex: assert #0(`ifndef INTC_MEM_FEV noassert || `endif $countones({redrowen_ms01l[1],redrowen_ms01l[0]}) <= 1);
  `endif
`else
  `ifndef INTC_MEM_FEV
L_0in_rdwrclk_redrowenbit_mutex: assert final(`ifndef INTC_MEM_FEV noassert || `endif $countones({redrowen_ms01l[1],redrowen_ms01l[0]}) <= 1) else $error("SVA FATAL ERROR: %s -- %m at %0t", "", $time);
  `else
L_0in_rdwrclk_redrowenbit_mutex: assert final(`ifndef INTC_MEM_FEV noassert || `endif $countones({redrowen_ms01l[1],redrowen_ms01l[0]}) <= 1);
  `endif
`endif

`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_TESTMODE
//lintra push -50000
  always @(redrowen_ms01l) begin
   if((redrowen_ms01l[0] === 1'b1) & (redrowen_ms01l[1] === 1'b1)) begin //lintra s-68092
`ifndef INTC_MEM_LINT
     $display("-E- : %m : @ %0d : Multiple redundant row enables",$time); //lintra s-1308, s-1309
`endif // INTC_MEM_LINT
   end
  end //end always
//lintra pop
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF

//Assertions for multiple redundant row enables in low phase
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
//L_0in_rdwrclk_redrowenbit_l_mutex: `ip764hduspsr1024x52m4b2s0r2p0d0_ASSERT_AT_MOST_BITS_HIGH(({redrowen_ms01l[1],redrowen_ms01l[0]}),1,noassert) `ip764hduspsr1024x52m4b2s0r2p0d0_ERR_MSG($psprintf(""));

  // ASSERT_AT_MOST_BITS_HIGH
`ifdef INTC_MEM_MODEL_TECH
  `ifndef INTC_MEM_FEV
L_0in_rdwrclk_redrowenbit_l_mutex: assert #0(`ifndef INTC_MEM_FEV noassert || `endif $countones({redrowen_ms01l[1],redrowen_ms01l[0]}) <= 1) else $error("SVA FATAL ERROR: %s -- %m at %0t", "", $time);
  `else
L_0in_rdwrclk_redrowenbit_l_mutex: assert #0(`ifndef INTC_MEM_FEV noassert || `endif $countones({redrowen_ms01l[1],redrowen_ms01l[0]}) <= 1);
  `endif
`else
  `ifndef INTC_MEM_FEV
L_0in_rdwrclk_redrowenbit_l_mutex: assert final(`ifndef INTC_MEM_FEV noassert || `endif $countones({redrowen_ms01l[1],redrowen_ms01l[0]}) <= 1) else $error("SVA FATAL ERROR: %s -- %m at %0t", "", $time);
  `else
L_0in_rdwrclk_redrowenbit_l_mutex: assert final(`ifndef INTC_MEM_FEV noassert || `endif $countones({redrowen_ms01l[1],redrowen_ms01l[0]}) <= 1);
  `endif
`endif

`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_TESTMODE
//lintra push -50000
   always @(redrowen_ms01l) begin
     if((redrowen_ms01l[0] === 1'b1) & (redrowen_ms01l[1] === 1'b1)) begin //lintra s-68092
`ifndef INTC_MEM_LINT
       $display("-E- : %m : @ %0d : Multiple redundant row enables",$time); //lintra s-1308, s-1309
`endif // INTC_MEM_LINT
     end
    end //end always
//lintra pop
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF

`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
  generate
   genvar wen_bit;



  // ASSERT_AT_MOST_BITS_HIGH
`ifdef INTC_MEM_MODEL_TECH
  `ifndef INTC_MEM_FEV
L_0in_rdwrclk_wrbiten_bit_mutex: assert #0(`ifndef INTC_MEM_FEV noassert || `endif $countones({wen_ms01l,cks02hrdm1n44}) <= 1) else $error("SVA FATAL ERROR: %s -- %m at %0t", "", $time);
  `else
L_0in_rdwrclk_wrbiten_bit_mutex: assert #0(`ifndef INTC_MEM_FEV noassert || `endif $countones({wen_ms01l,cks02hrdm1n44}) <= 1);
  `endif
`else
  `ifndef INTC_MEM_FEV
L_0in_rdwrclk_wrbiten_bit_mutex: assert final(`ifndef INTC_MEM_FEV noassert || `endif $countones({wen_ms01l,cks02hrdm1n44}) <= 1) else $error("SVA FATAL ERROR: %s -- %m at %0t", "", $time);
  `else
L_0in_rdwrclk_wrbiten_bit_mutex: assert final(`ifndef INTC_MEM_FEV noassert || `endif $countones({wen_ms01l,cks02hrdm1n44}) <= 1);
  `endif
`endif


  endgenerate
`endif
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_TESTMODE
  generate
   genvar wen_bit1;

      always @(wen_ms01l,cks02hrdm1n44) begin //lintra s-50000
        if((wen_ms01l === 1'b1) & (cks02hrdm1n44 === 1'b1)) begin //lintra s-68092
`ifndef INTC_MEM_LINT
          $display("-E- : %m : @ %0d : Read and Write enable on at same time!  Read data, array contents, or both may become corrupted.",$time); //lintra s-1308, s-1309
`endif // INTC_MEM_LINT
        end
      end // always

 endgenerate
`endif

//lintra pop





//--------------------------------------------------------------------------
//     ARRAY    Logic in vccsramgtret domain
//--------------------------------------------------------------------------
ip764hduspsr1024x52m4b2s0r2p0d0_array ip764hduspsr1024x52m4b2s0r2p0d0_array (
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  .addr1 (addr_mnn1l),
  .data (data_ms01l),
  .redrowen (redrowen_ms01l),
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  .addr1 (addr_fwls),
  .data (data_fwls),
  .redrowen (redrowen_fwls),
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  .ckfw (ckenfw_vs_m1n22),
  .wren (wen_ms01l),
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  .wrclk (cks02hwrm1n44),
  .rdclk (cks02hrdm1n44),
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

  .ren (ren_ms01l),
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
//<< saveText >>>
//`ifndef INTC_MEM_NOXHANDLING
//`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
//  .pwrenb (shutoffout),
//`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
//`endif // INTC_MEM_NOXHANDLING
//<< /saveText [expr 1 - $nopgate] >>>
  .nowrite (1'b0),
//.dsrwin (1'b0),
  .dsrwin (dspb),
  .pd1(pd1),
  .pd2(pd2),
  .qo (rd_q)
);

  // Anding clock with data to model sense amp precharge
//  assign rd_clkq = rd_q & {53{cks02hrdm1n44}}; /* lintra s-30003, s-30004, s-31500, s-31503 */
  assign rd_clkq = rd_q; /* lintra s-30003, s-30004, s-31500, s-31503 */

//  // Final Output Latch
//  `ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LATCH(datas_ms02h, rd_clkq, cks02hrdm1n44 , shutoff_ls)
//

endmodule // ip764hduspsr1024x52m4b2s0r2p0d0_bmod

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// Memory Core
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//--------------------------------------------------------------------------
// part of VCCSRAMGTRET domain
//--------------------------------------------------------------------------
module ip764hduspsr1024x52m4b2s0r2p0d0_array (
  input  wire  [9:0] addr1,
  input  wire  [52:0] data,  // input data
  input  wire  [1:0]  redrowen,  // redundant row enable\n
  input  wire    ckfw,          // isolated (firewalled) clock
  input  wire    wren,
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  input  wire    wrclk, // cks02hwrm1n44
  input  wire    rdclk, // cks02hrdm1n44
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

  input  wire    ren,
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
//<< saveText >>>
//`ifndef INTC_MEM_NOXHANDLING
//`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
//  input  wire    pwrenb,   //lintra s-0527  // active low power gate
//`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
//`endif // INTC_MEM_NOXHANDLING
//<< /saveText [expr 1 - $nopgate] >>>
  input  wire    nowrite,                   // e.g. stmen_vs_ms00l
  input  wire    dsrwin,
  input wire     pd2,          // gated input supply monitor
  output  wire   pd1,          // array supply monitor
  output wire  [52:0] qo            // data output
);

reg  [52:0] q;

reg pd_array;

`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
reg pd0fi;
reg last_pd0fi;
//integer word, fcol, frow0, frow1;
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS

wire dsrw;

//event t_setarray;
//event t_setredarray;
//event dsrw_write;
//event dsrw_read;
//event write_dsrw;
//event read_dsrw;
//event valid_write;
//event valid_read;

`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
reg dsrwflop;

`ifndef INTC_MEM_LINT
initial begin
  // initialize pme hazard flag (upf sims will re-execute when domain power is restored)
  dsrwflop = 1'b0;
end
`endif // INTC_MEM_LINT

always @(posedge ckfw) begin //lintra s-50000
  dsrwflop <= dsrwin;
end

  assign dsrw = dsrwin | dsrwflop;
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  assign dsrw = dsrwin;
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

//--------------------------------------------------------------------------
//                     Local logic Declarations
//--------------------------------------------------------------------------

//lintra push -0564
//lintra push -0510
//---------------------
// ARRAY
//---------------------
  (* memory *) reg [52:0] array[0:1023]; //lintra s-2028
// pragma attribute array ND_RAM 1
// pragma attribute array ram_block 1

//---------------------
// REDUNDANT ROW ARRAY
//---------------------
  (* memory *) reg [52:0] array_r[0:7]; //lintra s-2028
// pragma attribute array_r ND_RAM 1
// pragma attribute array_r ram_block 1

//---------------------
// Fault Injection ARRAY
//---------------------
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
  (* memory *) reg [52:0] array_f[0:1023]; //lintra s-2028
// pragma attribute array_f ND_RAM 1
// pragma attribute array_f ram_block 1
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS

//lintra pop
//lintra pop

`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  wire wrclknor;
  assign wrclknor = wrclk;
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

`ifndef INTC_MEM_LINT

assign qo = q;

`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
//lintra push -60029, -50000
always @(wrclk or rdclk)
begin
  pd_array = 1'b1;
end
//assign pd1 = 1'b1 ; // array supply monitor
assign pd1 = pd_array; // array supply monitor
`else
assign pd1 = 1'b1 ; // array supply monitor
//lintra pop
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
// DSRW Hazard during Wr/Rd
always @(dsrw)
begin
  // DSWR condition
  // wrclk is X OR wrclk enabled AND dsrw
  if( (dsrw !== 1'b0) && (((^wrclk !== 1'b1) & (^wrclk !== 1'b0)) | (|wrclk === 1'b1)) ) begin  : x_ds_wr
//  -> dsrw_write;
    setarray(1'bx,1024); //lintra s-50002
    setredarray(1'bx,8); //lintra s-50002
  end
  // DSRD condition
  // rdclk is X OR rdclk enabled AND dsrw
  if( (dsrw !== 1'b0) & (rdclk !== 1'b0) ) begin : x_ds_rd
//  -> dsrw_read;
    q = {53{1'bx}}; //lintra s-50002, s-0384
    setarray(1'bx,1024); //lintra s-50002
    setredarray(1'bx,8); //lintra s-50002
  end
end
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
always @(ckfw) begin : dual_redrow
  // Both the redundant rows enabled?
  //  If both redundant rows are enabled, all colmux locationa are enabled with
  //  a word line and therefore subject to a fake read, and therefore corruption
  //  as well.  This includes the bits masked out by the bit enables.
  if( (wren !== 1'b0) | (ckfw !== 1'b0) ) begin
    // Both redundant rows enabled
    if( (redrowen[1] !== 1'b0) & (redrowen[0] !== 1'b0) ) begin : wren_multiple_redrow
      setredarray(1'bx,8); //lintra s-50002
    end
  end
end
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

//------------------------------------------------//
//  Data Array Write                              //
//------------------------------------------------//
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
// --------------------------------------------
// Behavioral MODE
// --------------------------------------------
//lintra push -0305, -60029, -50000, -1460, -1461, -2165, -2047, -2056
//  always @(*) begin
always @(rdclk, redrowen, wrclk, addr1, data, nowrite) begin

  if (|wrclk !== 1'b0) begin  // write?

    if ((pd1 !== 1'b0) & (pd2 !== 1'b0)) begin // array periphery and array must have power

      // DSWR write condition
      // wrclk is X OR wrclk enabled AND dsrw
      if( (((^wrclk !== 1'b1) & (^wrclk !== 1'b0)) | (|wrclk === 1'b1)) & (dsrw !== 1'b0) ) begin  : x_wr_ds
//      -> write_dsrw;
        setarray(1'bx,1024); //lintra s-50002
        setredarray(1'bx,8); //lintra s-50002
      end // DSWR write condition

      // Write with bad address condition
      if( (^addr1 !== 1'b1) & (^addr1 !== 1'b0) ) begin : x_add
        // wrclk is X OR wrclk enabled
        if( (((^wrclk !== 1'b1) & (^wrclk !== 1'b0)) | (|wrclk === 1'b1)) ) begin  : x_add_wr
          setarray(1'bx,1024); //lintra s-50002
          if( (redrowen[1] !== 1'b0) | (redrowen[0] !== 1'b0) ) begin
            // X both redrows even though other redrow may not be enabled
            setredarray(1'bx,8); //lintra s-50002
          end
        end
      end


// Case where write is X
      if( ((wrclk !== 1'b1) & (wrclk !== 1'b0)) & (rdclk !== 1'b1) & (dsrw !== 1'b1) ) begin  : x_wr

        // Bad redrowen 2 X condition
        // redrowen can be X from DFX wrapper from redrow enable X and/or redrow address X
        if( (redrowen[1] !== 1'b0) & (redrowen[1] !== 1'b1) ) begin : x_wr_redrow_2
          array_r[{addr1[1:0],1'b1}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047
          array[addr1] <= {53{1'bx}}; //lintra s-0384, s-2055, s-0241, s-50002
        end

        // Bad redrowen 1 X condition
        // redrowen can be X from DFX wrapper from redrow enable X and/or redrow address X
        else if( (redrowen[0] !== 1'b0) & (redrowen[0] !== 1'b1) ) begin : x_wr_redrow_1
          array_r[{addr1[1:0],1'b0}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047
          array[addr1] <= {53{1'bx}}; //lintra s-0384, s-2055, s-0241, s-50002
        end

        else if( (redrowen[1] === 1'b0) & (redrowen[0] === 1'b0) )
          array[addr1] <= {53{1'bx}}; //lintra s-0384, s-2055, s-0241, s-50002

        // Write the redundant row instead
        else if( (redrowen[1] === 1'b1) & (redrowen[0] === 1'b0) )
          array_r[{addr1[1:0],1'b1}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047

        else if( (redrowen[1] === 1'b0) & (redrowen[0] === 1'b1) )
          array_r[{addr1[1:0],1'b0}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047
      end // Case where write is X

      // Valid write condition
      else if( (wrclk === 1'b1) & (rdclk === 1'b0) & (dsrw === 1'b0) ) begin

//      -> valid_write;

        // Bad redrowen 2 X condition
        // redrowen can be X from DFX wrapper from redrow enable X and/or redrow address X
        if( (redrowen[1] !== 1'b0) & (redrowen[1] !== 1'b1) ) begin : x_wr_redrow_2
          array_r[{addr1[1:0],1'b1}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047
          array[addr1] <= {53{1'bx}}; //lintra s-0384, s-2055, s-0241, s-50002
        end

        // Bad redrowen 1 X condition
        // redrowen can be X from DFX wrapper from redrow enable X and/or redrow address X
        else if( (redrowen[0] !== 1'b0) & (redrowen[0] !== 1'b1) ) begin : x_wr_redrow_1
          array_r[{addr1[1:0],1'b0}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047
          array[addr1] <= {53{1'bx}}; //lintra s-0384, s-2055, s-0241, s-50002
        end

        else if( (redrowen[1] === 1'b0) & (redrowen[0] === 1'b0) )
          array[addr1] <= data;

        // Write the redundant row instead
        else if( (redrowen[1] === 1'b1) & (redrowen[0] === 1'b0) )
          array_r[{addr1[1:0],1'b1}] <= data;

        else if( (redrowen[1] === 1'b0) & (redrowen[0] === 1'b1) )
          array_r[{addr1[1:0],1'b0}] <= data;
      end // // Valid write condition

    end // array periphery and array up?
  end // write?
end // End always_latch


//lintra pop -0305, -60029, -50000, -1460, -1461, -2165, -2047, -2056

`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
// --------------------------------------------
// EFFM WRITE
// --------------------------------------------
always @(posedge ckfw) begin //lintra s-50000
  if (wren) begin: wr
//    if( ~redrowen\[1] & ~redrowen\[0] & ~nowrite )
    if( (~|redrowen) & ~nowrite )
      array[addr1] <= data; //lintra s-0241
// Write the redundant row instead
    if( (^redrowen) & ~nowrite )
      array_r[{addr1[1:0],redrowen[1]}] <= data;
// Both the redundant rows are enabled
//-//      if( (&redrowen) & ~nowrite  )
//-//        begin
//-////          array_r\[{addr1\[[expr $col_bits - 1]:0],1'b0}] <= ({$nbtot{1'bx}} & byten) | (array_r\[{addr1\[[expr $col_bits - 1]:0],1'b0}] & ~byten); //lintra s-0384, s-2055, s-50002
//-////          array_r\[{addr1\[[expr $col_bits - 1]:0],1'b1}] <= ({$nbtot{1'bx}} & byten) | (array_r\[{addr1\[[expr $col_bits - 1]:0],1'b1}] & ~byten); //lintra s-0384, s-2055, s-50002
//-////  If both redundant rows are enabled, all colmux locationa are enabled wit
//-////  a word line and therefore subject to a fake read, and therefore corruption
//-////  as well.  This includes the bits masked out by the bit enables.
//-////          array_r <= {[expr $nbtot * $cmux * 2]{1'bx}}; //lintra s-0384, s-2055, s-50002
//-//          setredarray(1'bx,[expr $cmux*2]); //lintra s-50002
//-//        end
  end
end // End always_ff
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

//------------------------------------------------//
//  Data Array Read                               //
//------------------------------------------------//

//lintra push -2165, -60032, -60062, -50000
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
// --------------------------------------------
// Behavioral MODE
// --------------------------------------------
// Clock anding function required to match schematic
always @(rdclk, redrowen , wrclknor, addr1) begin
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
// try to override pd0fi, if OK , pd0fi is live and Fault injection can occur
  pd0fi = 1'b1;
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
  if( (rdclk !== 1'b0) & (dsrw !== 1'b0) ) begin : x_rd_ds
//  -> read_dsrw;
    q = {53{1'bx}}; //lintra s-50002, s-0384
    setarray(1'bx,1024); //lintra s-50002
    setredarray(1'bx,8); //lintra s-50002
  end
//else if( (rdclk !== 1'b0) & (wrclknor !== 1'b0) ) begin : xwr_rd
  else if( (rdclk !== 1'b0) & (wren !== 1'b0) ) begin : xwr_rd
    q = {53{1'bx}}; //lintra s-50002, s-0384
    // Check for bad address
    if( (^addr1 !== 1'b1) & (^addr1 !== 1'b0) ) begin : rdwr_x_add_bit
      setarray(1'bx,1024); //lintra s-50002
      if( (redrowen[1] !== 1'b0) | (redrowen[0] !== 1'b0) ) begin
        // X both redrows even though other redrow may not be enabled
        setredarray(1'bx,8); //lintra s-50002
      end
    end
//  Write/Read collision needed here to cover all cases including bit-write
    else if( (redrowen[1] === 1'b0) & (redrowen[0] === 1'b0) ) // 0,0
      array[addr1] <= {53{1'bx}}; //lintra s-0384, s-2055, s-0241, s-50002
    else if( (redrowen[1] === 1'b1) & (redrowen[0] === 1'b0) ) begin // 1,0
      array_r[{addr1[1:0],1'b1}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047
    end
    else if( (redrowen[1] === 1'b0) & (redrowen[0] === 1'b1) ) begin // 0,1
      array_r[{addr1[1:0],1'b0}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047
    end
    else if( (redrowen[1] === 1'b1) & (redrowen[0] === 1'b1) ) begin // 1,1
      array_r[{addr1[1:0],1'b1}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047
      array_r[{addr1[1:0],1'b0}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047
    end
    else if( (redrowen[1] !== 1'b0) & (redrowen[0] !== 1'b0) ) begin // x,1 ; 1,x ; x,x
      array[addr1] <= {53{1'bx}}; //lintra s-0384, s-2055, s-0241, s-50002
      array_r[{addr1[1:0],1'b1}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047
      array_r[{addr1[1:0],1'b0}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047
    end
    else if( (redrowen[1] !== 1'b0) && (redrowen[0] === 1'b0) ) begin // x,0
      array[addr1] <= {53{1'bx}}; //lintra s-0384, s-2055, s-0241, s-50002
      array_r[{addr1[1:0],1'b1}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047
    end
    else if( (redrowen[1] === 1'b0) && (redrowen[0] !== 1'b0) ) begin // 0,x
      array[addr1] <= {53{1'bx}}; //lintra s-0384, s-2055, s-0241, s-50002
      array_r[{addr1[1:0],1'b0}] <= {53{1'bx}}; //lintra s-0384, s-2055, s-50002, s-2047
    end
  end
// Both redundant rows enabled
  else if( (rdclk !== 1'b0) & (redrowen[1] !== 1'b0) & (redrowen[0] !== 1'b0) ) begin : rd_multiple_redrow
    q = {53{1'bx}}; //lintra s-50002, s-0384
//  setredarray(1'bx,8); //lintra s-50002
  end
// Bad redrowen 2 X condition
  else if( (rdclk !== 1'b0) & (redrowen[1] !== 1'b0) & (redrowen[1] !== 1'b1) ) begin : x_rd_redrow_2
    q = {53{1'bx}}; //lintra s-50002, s-0384
  end
// Bad redrowen 1 X condition
  else if( (rdclk !== 1'b0) & (redrowen[0] !== 1'b0) & (redrowen[0] !== 1'b1) ) begin : x_rd_redrow_1
    q = {53{1'bx}}; //lintra s-50002, s-0384
  end
// Valid read condition (Write-Read condition covered by prior conditional
  else if( (rdclk === 1'b1) & (dsrw === 1'b0) ) begin: rd
//  -> valid_read;
    if( (redrowen[1] === 1'b0) & (redrowen[0] === 1'b0) ) begin
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
//      if( |array_f[addr1] ) begin
//        $display ("Fault on read at address %0d",addr1);
//      end
      q = array[addr1] ^ array_f[addr1]; //lintra s-0241
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
      q = array[addr1]; //lintra s-0241
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
      q = array[addr1]; //lintra s-0241
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
    end
    else if ( (redrowen[1] === 1'b1) )
      q = array_r[{addr1[1:0],1'b1}] ; //lintra s-0241
    else if( (redrowen[0] === 1'b1) )
      q = array_r[{addr1[1:0],1'b0}] ; //lintra s-0241
  end
  else if( (rdclk !== 1'b1) & (rdclk !== 1'b0) ) begin: x_rd
    q = {53{1'bx}}; //lintra s-50002, s-0384
  end
end
// --------------------------------------------
// EFFM READ
// --------------------------------------------
`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
always @(posedge ckfw) begin //lintra s-50000
  if ( ren ) begin: rd
    q <= (^redrowen)
      ? array_r[{addr1[1:0],redrowen[1]}]
      : array[addr1]; //lintra s-0241
  end // End if
end // End always_comb
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
//lintra pop

//---------------------------------------------------------------------------
// ARRAY setting/loading tasks
//---------------------------------------------------------------------------
//lintra push -60051, -60118, -81061
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
// VCS X-prop waiver - "a non-instrumentable task call: setarray"
task setarray(input reg val, input integer rng);
  integer idx;
  begin
//  -> t_setarray;
    for (idx=0; idx < rng; idx=idx+1)
      begin
//        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.array[idx] <= {53{val}};
        array[idx] <= {53{val}};
      end
  end
endtask

// VCS X-prop waiver - "a non-instrumentable task call: setredarray"
task setredarray(input reg val, input integer rng);
  integer idx;
  begin
//  -> t_setredarray;
    for (idx=0; idx< rng; idx=idx+1)
      begin
//        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.array_r[idx] <= {53{val}};
        array_r[idx] <= {53{val}};
      end
  end
endtask

`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
// VCS X-prop waiver - "a non-instrumentable task call: setfiarray"
task setfiarray(input reg val, input integer rng);
  integer idx;
  begin
    for (idx=0; idx < rng; idx=idx+1)
      begin
        array_f[idx] = {53{val}};
      end
  end
endtask


//---------------------------------------------------------------------------
// FI ARRAY setting
//---------------------------------------------------------------------------
integer word, fcol, frow0, frow1;
integer midbit, fcol1, fcol0, midrow, cbit1row, cbit0row, cmux;
integer rbit2col1, rbit1col1, rbit0col1;
integer rbit2colm, rbit1colm, rbit0colm;
integer rbit2col0, rbit1col0, rbit0col0;
always @(pd0fi) begin
  if ((pd0fi !== last_pd0fi) & (pd0fi === 1'b1)) begin  // pd0fi up?
    $srandom(10);
//    $display ("---- Fault Calculations ----");
    setfiarray(1'b0,1024); //lintra s-50002
//    $display ("max word address: %0d",1023);
//    $display ("                  x ");
//    $display ("     max DFX bit: %0d",51);
//    $display ("------ cols ------");
    midbit = 26;
    fcol1 = $urandom_range(51,midbit+1);
//    $display ("          COL #1: %0d",fcol1);
//    $display ("  middle DFX bit: %0d",midbit);
    fcol0 = $urandom_range(midbit-1,0);
//    $display ("          COL #0: %0d",fcol0);
//    $display ("------ rows ------");
//    $display ("         MAX row: %0d  (words %0d -> %0d)",255,1020,1023);
    frow1 = $urandom_range(254,midrow+1);
    cbit1row = $urandom_range(255,frow1 + 1);
//    $display ("ROW #1 in Column: %0d  (words %0d -> %0d)",cbit1row,cbit1row*4,(cbit1row*4)+3);
//    $display ("   RANDOM row #1: %0d  (words %0d -> %0d)",frow1,frow1*4,(frow1*4)+3);
    midrow = 128;
//    $display ("      middle ROW: %0d  (words %0d -> %0d)",midrow,midrow*4,(midrow*4)+3);
    frow0 = $urandom_range(midrow-1,1);
//    $display ("   RANDOM row #0: %0d  (words %0d -> %0d)",frow0,frow0*4,(frow0*4)+3);
    cbit0row = $urandom_range(frow0 - 1, 0);
//    $display ("ROW #0 in Column: %0d  (words %0d -> %0d)",cbit0row,cbit0row*4,(cbit0row*4)+3);
// presidence order : rep > srep > nrep
`ifdef INTC_ip764hduspsr1024x52m4b2s0r2p0d0_local_fi_nrep
    begin
      // 3 rows and 2 columns
      // steps
      // 1 select 2 columns for column redundancy (use fcol0, fcol1)
      // 2 select 3 rows for row redundancy (use frow1, midrow, frow0)
      // 3 select bits in the column not in same rows (use cbit0row, cbit1row)
      // 4 select bits in the rows not in the column if possible
//      $display ("---- bits in row ----");
      rbit2col1 = $urandom_range(fcol1, midbit+1);
//      $display (" COL #2 in ROW 1: %0d",rbit2col1);
      rbit1col1 = midbit;
//      $display (" COL #1 in ROW 1: %0d",rbit1col1);
      rbit0col1 = $urandom_range(midbit-1, 0);
//      $display (" COL #0 in ROW 1: %0d",rbit0col1);
      rbit2colm = $urandom_range(fcol1, midbit+1);
//      $display (" COL #2 in ROW mid: %0d",rbit2colm);
      rbit1colm = midbit;
//      $display (" COL #1 in ROW mid: %0d",rbit1colm);
      rbit0colm = $urandom_range(midbit-1, 0);
//      $display (" COL #0 in ROW mid: %0d",rbit0colm);
      rbit2col0 = $urandom_range(fcol1, midbit+1);
//      $display (" COL #2 in ROW 0: %0d",rbit2col0);
      rbit1col0 = midbit;
//      $display (" COL #1 in ROW 0: %0d",rbit1col0);
      rbit0col0 = $urandom_range(midbit-1, 0);
//      $display (" COL #0 in ROW 0: %0d",rbit0col0);
      // set the fault array bits
//-----------------------------------------------------
//-- Fault injection table for \TB_IP756UHD2P11RF_32X4M2B1C0S0_T0R0P0D0A1M0L_FAULT_SINGLE.U1 .iarraytop
//-- Type of fault : Repairable 
//-- Word 0,  I/O 2  
//-- Word 1,  I/O 2
//-- Word 30,  I/O 2
//-----------------------------------------------------
      $display ("-----------------------------------------------------");
      $display ("-- Fault injection table for %m");
      $display ("-- Type of fault : Unrepairable");
      for (cmux=3; cmux>=0; cmux=cmux-1) begin: ip764hduspsr1024x52m4b2s0r2p0d0_fi_loop1
//        $display ("---------- CMUX %0d ----------",cmux);
        // first the columns
        array_f[(cbit1row*4)+cmux][fcol1] = 1'b1;
        array_f[(cbit0row*4)+cmux][fcol1] = 1'b1;
        array_f[(cbit1row*4)+cmux][fcol0] = 1'b1;
        array_f[(cbit0row*4)+cmux][fcol0] = 1'b1;
//        $display ("  -- ROW 1 in Fault COL 1 --");
        $display ("-- Word %0d, I/O %0d",(cbit1row*4)+cmux, fcol1);
//        $display ("  -- ROW 0 in Fault COL 1 --");
        $display ("-- Word %0d, I/O %0d",(cbit0row*4)+cmux, fcol1);
//        $display ("  -- ROW 1 in Fault COL 0 --");
        $display ("-- Word %0d, I/O %0d",(cbit1row*4)+cmux, fcol0);
//        $display ("  -- ROW 0 in Fault COL 0 --");
        $display ("-- Word %0d, I/O %0d",(cbit0row*4)+cmux, fcol0);
        // then the rows
        array_f[(frow1*4)+cmux][rbit2col1] = 1'b1;
        array_f[(frow1*4)+cmux][rbit1col1] = 1'b1;
        array_f[(frow1*4)+cmux][rbit0col1] = 1'b1;
        array_f[(midrow*4)+cmux][rbit2colm] = 1'b1;
        array_f[(midrow*4)+cmux][rbit1colm] = 1'b1;
        array_f[(midrow*4)+cmux][rbit0colm] = 1'b1;
        array_f[(frow0*4)+cmux][rbit2col0] = 1'b1;
        array_f[(frow0*4)+cmux][rbit1col0] = 1'b1;
        array_f[(frow0*4)+cmux][rbit0col0] = 1'b1;
//        $display ("  -- COLs  in Fault ROW 1 --");
        $display ("-- Word %0d, COL %0d",(frow1*4)+cmux, rbit2col1);
        $display ("-- Word %0d, COL %0d",(frow1*4)+cmux, rbit1col1);
        $display ("-- Word %0d, COL %0d",(frow1*4)+cmux, rbit0col1);
//        $display ("  -- COLs  in Fault ROW mid --");
        $display ("-- Word %0d, COL %0d",(midrow*4)+cmux, rbit2colm);
        $display ("-- Word %0d, COL %0d",(midrow*4)+cmux, rbit1colm);
        $display ("-- Word %0d, COL %0d",(midrow*4)+cmux, rbit0colm);
//        $display ("  -- COLs  in Fault ROW 0 --");
        $display ("-- Word %0d, COL %0d",(frow0*4)+cmux, rbit2col0);
        $display ("-- Word %0d, COL %0d",(frow0*4)+cmux, rbit1col0);
        $display ("-- Word %0d, COL %0d",(frow0*4)+cmux, rbit0col0);

      end
      $display ("-----------------------------------------------------");
    end
`else
  `ifdef INTC_ip764hduspsr1024x52m4b2s0r2p0d0_local_fi_rep
      begin
        // 2 rows and one column used up
        // steps
        // 1 select 1 column for column redundancy (use midbit)
        // 2 select 2 rows for row redundancy (use frow1, frow0)
        // 3 select bits in the column not in same rows (use cbit0row, cbit1row)
        // 4 select at least 3 bits in the rows not in the column if possible
//        $display ("---- bits in row ----");
//        $display ("- row 1 -");
        rbit2col1 = $urandom_range(fcol1, midbit+1);
//        $display (" COL #2 in ROW 1: %0d",rbit2col1);
        rbit1col1 = midbit;
//        $display (" COL #1 in ROW 1: %0d",rbit1col1);
        rbit0col1 = $urandom_range(midbit-1, 0);
//        $display (" COL #0 in ROW 1: %0d",rbit0col1);
//        $display ("- row 0 -");
        rbit2col0 = $urandom_range(fcol1, midbit+1);
//        $display (" COL #2 in ROW 0: %0d",rbit2col0);
        rbit1col0 = midbit;
//        $display (" COL #1 in ROW 0: %0d",rbit1col0);
        rbit0col0 = $urandom_range(midbit-1, 0);
//        $display (" COL #0 in ROW 0: %0d",rbit0col0);
        // set the fault array bits
        $display ("-----------------------------------------------------");
        $display ("-- Fault injection table for %m");
        $display ("-- Type of fault : Repairable");
        for (cmux=3; cmux>=0; cmux=cmux-1) begin: ip764hduspsr1024x52m4b2s0r2p0d0_fi_loop1
//          $display ("---------- CMUX %0d ----------",cmux);
        // first the columns
          array_f[(cbit1row*4)+cmux][midbit] = 1'b1;
          array_f[(cbit0row*4)+cmux][midbit] = 1'b1;
//          $display ("  -- ROW 1 in Fault COL 0 --");
          $display ("-- Word %0d, I/O %0d",(cbit1row*4)+cmux, midbit);
//          $display ("  -- ROW 0 in Fault COL 0 --");
          $display ("-- Word %0d, I/O %0d",(cbit0row*4)+cmux, midbit);
        // then the rows
          array_f[(frow1*4)+cmux][rbit2col1] = 1'b1;
          array_f[(frow1*4)+cmux][rbit1col1] = 1'b1;
          array_f[(frow1*4)+cmux][rbit0col1] = 1'b1;
          array_f[(frow0*4)+cmux][rbit2col0] = 1'b1;
          array_f[(frow0*4)+cmux][rbit1col0] = 1'b1;
          array_f[(frow0*4)+cmux][rbit0col0] = 1'b1;
//          $display ("  -- COLs  in Fault ROW 1 --");
          $display ("-- Word %0d, I/O %0d",(frow1*4)+cmux, rbit2col1);
          $display ("-- Word %0d, I/O %0d",(frow1*4)+cmux, rbit1col1);
          $display ("-- Word %0d, I/O %0d",(frow1*4)+cmux, rbit0col1);
//          $display ("  -- COLs  in Fault ROW 0 --");
          $display ("-- Word %0d, I/O %0d",(frow0*4)+cmux, rbit2col0);
          $display ("-- Word %0d, I/O %0d",(frow0*4)+cmux, rbit1col0);
          $display ("-- Word %0d, I/O %0d",(frow0*4)+cmux, rbit0col0);

        end
        $display ("-----------------------------------------------------");
      end
  `else
    `ifdef INTC_ip764hduspsr1024x52m4b2s0r2p0d0_local_fi_srep
        begin
          $display ("-----------------------------------------------------");
          $display ("-- Fault injection table for %m");
          $display ("-- Type of fault : Single");
          // single bit near middle
          // steps
          // 1 select a word address
          word = $urandom_range(1023,0);
//          $display ("RANDOM word value %0d",word);
          // 1 select a COL
          fcol = $urandom_range(51,0);
//          $display (" RANDOM fcol value %0d",fcol);
          // set the fault array bits
//          $display ("array_f [%0d] : %b",word,array_f[word]);
          array_f[word][fcol] = 1'b1;
//          $display ("array_f [%0d] : %b",word,array_f[word]);
//          $display ("  -- Single bit Fault --");
          $display ("-- Word %0d, I/O %0d",word, fcol);
          $display ("-----------------------------------------------------");
        end
    `endif
  `endif
`endif
  end
  last_pd0fi = pd0fi;
end // pd0fi change
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FI
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
//lintra pop

`endif // INTC_MEM_LINT

endmodule // ip764hduspsr1024x52m4b2s0r2p0d0_array

//=============================================================================
// End of MAIN RTL
//=============================================================================

//lintra push -1318, -1324
`celldefine

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// Timing Wrapper (GLS)
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//---------------------------------------------------------------------------
// control the defines for FPGA/Emulation usage
//---------------------------------------------------------------------------
`ifdef INTEL_FPGA
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_FPGA_MODE
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_TESTMODE
  `ifdef INTC_MEM_ESP
    `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
    `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_SIM
  `endif
`else
  `ifdef INTEL_EMULATION
    `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EMULATION
    `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
    `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
    `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_TESTMODE
    `ifdef INTC_MEM_ESP
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_SIM
    `endif
  `else
    `ifdef INTC_MEM_FAST_SIM
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EMULATION
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_TESTMODE
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_SIM
      `ifdef INTC_MEM_ESP
        `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
      `endif
    `else
      `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
    `endif
  `endif
`endif
`ifdef INTC_MEM_GLS
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_GLS
`endif // INTC_MEM_GLS
`ifdef INTEL_SVA_OFF
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_SVA_OFF
`endif // INTEL_SVA_OFF
`ifdef INTC_MEM_XINPUT_CHECK
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_XINPUT_CHECK
`endif
`ifdef INTC_MEM_NOXHANDLING
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_NOXHANDLING
`endif // INTC_MEM_NOXHANDLING
`ifdef INTC_MEM_TESTMODE
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_TESTMODE
`endif // INTC_MEM_TESTMODE
`ifdef INTC_MEM_EF_SIM
  `define INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_SIM
`endif // INTC_MEM_EF_SIM

module ip764hduspsr1024x52m4b2s0r2p0d0 (
// INPUTS
  input  wire  clk,           // Clock input
`ifndef INTEL_NO_PWR_PINS
`ifdef INTC_ADD_VSS
  input  wire  vss, //lintra s-0527, s-60010
`endif

  input  wire  vddp,     //lintra s-0527, s-60010 // Memory Periphery Power Supply
`endif
  input  wire  wen,          // Write enable
  input  wire  ren,          // Read enable
  input  wire  [9:0] adr,            // Address Bus

  input  wire  [52:0] din, // Data Input Bus
  input  wire  async_reset,   // Firewall signal to firewall inputs and reset outputs

  input  wire  arysleep,     // Enables array sleep mode
  input  wire  [1:0] sbc,    // Sleep bias level control bus
  input  wire  mce,          // Enables pin programmable control of timing margin settings (fusedatsa_mc00b[5])
  input  wire  stbyp,        // Overrides self-timed clocking to support debug (fusedatsa_mc00b[4])
  input  wire  [3:0] rmce,   // Read margin control bus (fusedatsa_mc00b[3:0])
  input  wire  [1:0] wmce,   // Write margin control bus (sramvccpwmod[3:2])
  input  wire  [2:0] wpulse, // Write pulse control bus (sramvccbiasen, sramvccpwmod[1:0])
  input  wire  [1:0] ra,     // Read assist level control bus (sramwlbiasloc)
  input  wire  [2:0] wa,     // Write assist level control bus (sramvccbias)
  input  wire  [1:0] redrowen,        // redundant row enable

// OUTPUTS

  output wire  [52:0] q // Data Output Bus
); //lintra s-68000

  wire pshutoff;
  wire shutoff;
  wire shutoffout;
  assign pshutoff = 1'b0;
  assign shutoff = 1'b0;


//lintra push -60010
// unused port for -ack_port option to create_power_switch command in UPF file
wire vccsramgtret_out_unused;
wire vccsramgt_out_unused;
//lintra pop

//wire vddgt_power_switch_control;
//assign vddgt_power_switch_control = shutoff | pshutoff;

`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  `ifndef INTC_MEM_LINT
  initial begin
    // initialize pme hazard flag (upf sims will re-execute when domain power is restored)
    ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.dsrwflop = 1'b0;
  end
  `endif // INTC_MEM_LINT
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE


`ifndef INTC_MEM_GLS
`else
// dummy notifier from specify blobk timing checks
  reg notf;
// notifiers from specify block timing checks
  reg       async_reset_n__;
  reg       arysleep_n__;
  reg       sbc_n_0_;
  reg       sbc_n_1_;
  reg       ren_n__;
  reg       wen_n__;
  reg       adr_n_0_;
  reg       adr_n_1_;
  reg       adr_n_2_;
  reg       adr_n_3_;
  reg       adr_n_4_;
  reg       adr_n_5_;
  reg       adr_n_6_;
  reg       adr_n_7_;
  reg       adr_n_8_;
  reg       adr_n_9_;
  reg       din_n_0_;
  reg       din_n_1_;
  reg       din_n_2_;
  reg       din_n_3_;
  reg       din_n_4_;
  reg       din_n_5_;
  reg       din_n_6_;
  reg       din_n_7_;
  reg       din_n_8_;
  reg       din_n_9_;
  reg       din_n_10_;
  reg       din_n_11_;
  reg       din_n_12_;
  reg       din_n_13_;
  reg       din_n_14_;
  reg       din_n_15_;
  reg       din_n_16_;
  reg       din_n_17_;
  reg       din_n_18_;
  reg       din_n_19_;
  reg       din_n_20_;
  reg       din_n_21_;
  reg       din_n_22_;
  reg       din_n_23_;
  reg       din_n_24_;
  reg       din_n_25_;
  reg       din_n_26_;
  reg       din_n_27_;
  reg       din_n_28_;
  reg       din_n_29_;
  reg       din_n_30_;
  reg       din_n_31_;
  reg       din_n_32_;
  reg       din_n_33_;
  reg       din_n_34_;
  reg       din_n_35_;
  reg       din_n_36_;
  reg       din_n_37_;
  reg       din_n_38_;
  reg       din_n_39_;
  reg       din_n_40_;
  reg       din_n_41_;
  reg       din_n_42_;
  reg       din_n_43_;
  reg       din_n_44_;
  reg       din_n_45_;
  reg       din_n_46_;
  reg       din_n_47_;
  reg       din_n_48_;
  reg       din_n_49_;
  reg       din_n_50_;
  reg       din_n_51_;
  reg       din_n_52_;
  reg       redrowen_n_0_;
  reg       redrowen_n_1_;
  reg       mce_n__;
  reg       stbyp_n__;

  reg       rmce_n_0_;
  reg       rmce_n_1_;
  reg       rmce_n_2_;
  reg       rmce_n_3_;
  reg       wmce_n_0_;
  reg       wmce_n_1_;
  reg       wpulse_n_0_;
  reg       wpulse_n_1_;
  reg       wpulse_n_2_;
  reg       ra_n_0_;
  reg       ra_n_1_;
  reg       wa_n_0_;
  reg       wa_n_1_;
  reg       wa_n_2_;
// notifier collectors to XBUF UDPs
  wire       async_reset_n;
  wire       arysleep_n;
  wire [1:0] sbc_n;
  wire       ren_n;
  wire       wen_n;
  wire [9:0] adr_n;
  wire [52:0] din_n;

  wire [1:0] redrowen_n;
  wire      mce_n;
  wire      stbyp_n;
  wire [3:0] rmce_n;
  wire [1:0] wmce_n;
  wire [2:0] wpulse_n;
  wire [1:0] ra_n;
  wire [2:0] wa_n;
// Buffered versions of signals from primary I/O ports
// OUTPUTS
  wire       shutoffout_i;
  wire [52:0] q_i;

// INPUTS
  wire       async_reset_i;                 // static
  wire       shutoff_i;              // static
  wire [52:0] din_i;
  wire       ren_i;
  wire       wen_i;
  wire [1:0] redrowen_i;
  wire [9:0] adr_i;
  wire arysleep_i;                  // static
  wire pshutoff_i;                // static
  wire [1:0] sbc_i;             // static
  wire mce_i;                    // static
  wire stbyp_i;                  // static
  wire [1:0] wmce_i;            // static
  wire [3:0] rmce_i;            // static
  wire [2:0] wpulse_i;          // static
  wire [1:0] ra_i;              // static
  wire [2:0] wa_i;              // static

//// I/O Buffers
//lintra push -60003
// OUTPUT Buffers
  buf shutoffout_buf (shutoffout, shutoffout_i);
  buf q_buf [52:0] (q, q_i);

// INPUT Buffers for SDF annotation
  buf async_reset_buf (async_reset_i, async_reset);
  buf shutoff_buf (shutoff_i, shutoff);
  buf din_buf [52:0] (din_i, din);
  buf ren_buf (ren_i, ren);
  buf wen_buf (wen_i, wen);
  buf redrowen_buf [1:0] (redrowen_i, redrowen);
  buf adr_buf [9:0] (adr_i, adr);
  buf arysleep_buf (arysleep_i, arysleep);
  buf pshutoff_buf (pshutoff_i, pshutoff);
  buf sbc_buf [1:0] (sbc_i, sbc);
  buf mce_buf (mce_i, mce);
  buf stbyp_buf (stbyp_i, stbyp);
  buf rmce_buf [3:0] (rmce_i, rmce);
  buf wmce_buf [1:0] (wmce_i, wmce);
  buf wpulse_buf [2:0] (wpulse_i, wpulse);
  buf ra_buf [1:0] (ra_i, ra);
  buf wa_buf [2:0] (wa_i, wa);
//lintra pop

// Xed versions of signals from XBUF
// INPUTS
  wire clk_ix;
  wire async_reset_ix;
  wire shutoff_ix;
  wire pshutoff_ix;
  wire arysleep_ix;
  wire [1:0] sbc_ix;
  wire ren_ix;
  wire wen_ix;
  wire [9:0] adr_ix;
  wire [52:0] din_ix;
  wire [1:0] redrowen_ix;
  wire mce_ix;
  wire stbyp_ix;
  wire [1:0] wmce_ix;
  wire [3:0] rmce_ix;
  wire [2:0] wpulse_ix;
  wire [1:0] ra_ix;
  wire [2:0] wa_ix;
  reg  clk_sdd;
// Delayed versions of signals from specify block
// (for "negative" timing checks, <Inputs> only)
// INPUTS
  wire clk_sd;
  wire async_reset_sd;
  wire shutoff_sd;
  wire pshutoff_sd;
  wire arysleep_sd;
  wire [52:0] din_sd;
  wire [1:0] sbc_sd;
  wire ren_sd;
  wire wen_sd;
  wire [9:0] adr_sd;
  wire [1:0] redrowen_sd;
  wire mce_sd;
  wire stbyp_sd;
  wire [3:0] rmce_sd;
  wire [1:0] wmce_sd;
  wire [2:0] wpulse_sd;
  wire [1:0] ra_sd;
  wire [2:0] wa_sd;
// Default assignment for no power gate signals
  assign shutoff_sd = 1'b0;
  assign pshutoff_sd = 1'b0;
// INPUT X Buffers for _sd signals for neg timing setting
`ifndef INTC_MEM_LINT
  ip764hduspsr1024x52m4b2s0r2p0d0_XBUF async_reset_bufX (async_reset_ix, async_reset_sd, clk, async_reset_n);
  ip764hduspsr1024x52m4b2s0r2p0d0_XBUF arysleep_bufX (arysleep_ix, arysleep_sd, clk, arysleep_n);
  ip764hduspsr1024x52m4b2s0r2p0d0_XBUF sbc_bufX [1:0] (sbc_ix, sbc_sd, clk, sbc_n);
  buf shutoff_bufX (shutoff_ix, shutoff_sd);
  buf pshutoff_bufX (pshutoff_ix, pshutoff_sd);
  buf wen_bufX (wen_ix, wen_sd);
  buf ren_bufX (ren_ix, ren_sd);
  buf adr_bufX [9:0] (adr_ix, adr_sd);
  buf din_bufX [52:0] (din_ix, din_sd);
  buf redrowen_bufX [1:0] (redrowen_ix, redrowen_sd);
  ip764hduspsr1024x52m4b2s0r2p0d0_XBUF mce_bufX (mce_ix, mce_sd, clk, mce_n);
  ip764hduspsr1024x52m4b2s0r2p0d0_XBUF stbyp_bufX (stbyp_ix, stbyp_sd, clk, stbyp_n);
  ip764hduspsr1024x52m4b2s0r2p0d0_XBUF rmce_bufX [3:0] (rmce_ix, rmce_sd, clk, rmce_n);
  ip764hduspsr1024x52m4b2s0r2p0d0_XBUF wmce_bufX [1:0] (wmce_ix, wmce_sd, clk, wmce_n);
  ip764hduspsr1024x52m4b2s0r2p0d0_XBUF wpulse_bufX [2:0] (wpulse_ix, wpulse_sd, clk, wpulse_n);
  ip764hduspsr1024x52m4b2s0r2p0d0_XBUF ra_bufX [1:0] (ra_ix, ra_sd, clk, ra_n);
  ip764hduspsr1024x52m4b2s0r2p0d0_XBUF wa_bufX [2:0] (wa_ix, wa_sd, clk, wa_n);
  always @(clk_sd)
    begin
      clk_sdd <= clk_sd;
    end
`endif // INTC_MEM_LINT

`endif // INTC_MEM_GLS


`ifndef INTC_MEM_GLS
`else
`ifndef INTC_MEM_LINT
// assign notifiers from specify block to bused notifiers
  assign async_reset_n = async_reset_n__;
  assign arysleep_n = arysleep_n__;

  assign sbc_n[0] = sbc_n_0_;
  assign sbc_n[1] = sbc_n_1_;
  assign ren_n = ren_n__;
  assign wen_n = wen_n__;

  assign adr_n[0] = adr_n_0_;
  assign adr_n[1] = adr_n_1_;
  assign adr_n[2] = adr_n_2_;
  assign adr_n[3] = adr_n_3_;
  assign adr_n[4] = adr_n_4_;
  assign adr_n[5] = adr_n_5_;
  assign adr_n[6] = adr_n_6_;
  assign adr_n[7] = adr_n_7_;
  assign adr_n[8] = adr_n_8_;
  assign adr_n[9] = adr_n_9_;
  assign din_n[0] = din_n_0_;
  assign din_n[1] = din_n_1_;
  assign din_n[2] = din_n_2_;
  assign din_n[3] = din_n_3_;
  assign din_n[4] = din_n_4_;
  assign din_n[5] = din_n_5_;
  assign din_n[6] = din_n_6_;
  assign din_n[7] = din_n_7_;
  assign din_n[8] = din_n_8_;
  assign din_n[9] = din_n_9_;
  assign din_n[10] = din_n_10_;
  assign din_n[11] = din_n_11_;
  assign din_n[12] = din_n_12_;
  assign din_n[13] = din_n_13_;
  assign din_n[14] = din_n_14_;
  assign din_n[15] = din_n_15_;
  assign din_n[16] = din_n_16_;
  assign din_n[17] = din_n_17_;
  assign din_n[18] = din_n_18_;
  assign din_n[19] = din_n_19_;
  assign din_n[20] = din_n_20_;
  assign din_n[21] = din_n_21_;
  assign din_n[22] = din_n_22_;
  assign din_n[23] = din_n_23_;
  assign din_n[24] = din_n_24_;
  assign din_n[25] = din_n_25_;
  assign din_n[26] = din_n_26_;
  assign din_n[27] = din_n_27_;
  assign din_n[28] = din_n_28_;
  assign din_n[29] = din_n_29_;
  assign din_n[30] = din_n_30_;
  assign din_n[31] = din_n_31_;
  assign din_n[32] = din_n_32_;
  assign din_n[33] = din_n_33_;
  assign din_n[34] = din_n_34_;
  assign din_n[35] = din_n_35_;
  assign din_n[36] = din_n_36_;
  assign din_n[37] = din_n_37_;
  assign din_n[38] = din_n_38_;
  assign din_n[39] = din_n_39_;
  assign din_n[40] = din_n_40_;
  assign din_n[41] = din_n_41_;
  assign din_n[42] = din_n_42_;
  assign din_n[43] = din_n_43_;
  assign din_n[44] = din_n_44_;
  assign din_n[45] = din_n_45_;
  assign din_n[46] = din_n_46_;
  assign din_n[47] = din_n_47_;
  assign din_n[48] = din_n_48_;
  assign din_n[49] = din_n_49_;
  assign din_n[50] = din_n_50_;
  assign din_n[51] = din_n_51_;
  assign din_n[52] = din_n_52_;
  assign redrowen_n[0] = redrowen_n_0_;
  assign redrowen_n[1] = redrowen_n_1_;
  assign mce_n = mce_n__;
  assign stbyp_n = stbyp_n__;

  assign rmce_n[0] = rmce_n_0_;
  assign rmce_n[1] = rmce_n_1_;
  assign rmce_n[2] = rmce_n_2_;
  assign rmce_n[3] = rmce_n_3_;
  assign wmce_n[0] = wmce_n_0_;
  assign wmce_n[1] = wmce_n_1_;
  assign wpulse_n[0] = wpulse_n_0_;
  assign wpulse_n[1] = wpulse_n_1_;
  assign wpulse_n[2] = wpulse_n_2_;
  assign ra_n[0] = ra_n_0_;
  assign ra_n[1] = ra_n_1_;
  assign wa_n[0] = wa_n_0_;
  assign wa_n[1] = wa_n_1_;
  assign wa_n[2] = wa_n_2_;
`endif // INTC_MEM_LINT
`endif // INTC_MEM_GLS

`ifndef INTC_MEM_GLS

`else // INTC_MEM_GLS
  wire tm3;
  wire tm1;
  wire tm2;
  assign tm3 = mce&!rmce[3]&rmce[2]&!rmce[1]&rmce[0]&!ra[1]&ra[0]&wmce[1]&wmce[0]&!wpulse[2]&!wpulse[1]&wpulse[0]&!wa[2]&!wa[1]&!wa[0]&!stbyp;
  assign tm1 = !mce|(mce&!rmce[3]&!rmce[2]&rmce[1]&rmce[0]&!ra[1]&ra[0]&wmce[1]&wmce[0]&!wpulse[2]&!wpulse[1]&wpulse[0]&!wa[2]&wa[1]&wa[0]&!stbyp);
  assign tm2 = mce&!rmce[3]&!rmce[2]&!rmce[1]&rmce[0]&!ra[1]&ra[0]&wmce[1]&wmce[0]&!wpulse[2]&!wpulse[1]&wpulse[0]&!wa[2]&!wa[1]&!wa[0]&!stbyp;

// Specify block
// --------------------
  specify

`ifndef INTC_MEM_LINT
  specparam tcc = 0.0; //lintra s-8213, s-1307
  specparam tch = 0.0; //lintra s-8213, s-1307
  specparam tcl = 0.0; //lintra s-8213, s-1307
  specparam tsh = 0.0; //lintra s-8213, s-1307
  specparam trr = 0.0; //lintra s-8213, s-1307
  specparam tcq = 1.0; //lintra s-8213, s-1307
  specparam tcx = 1.0; //lintra s-8213, s-1307
`endif // INTC_MEM_LINT

// =========================================================
// Clock Timing Checks (Non-Conditional)
// =========================================================
//  $period(posedge clk, tcc);  // see ifnone section for this check
  $width(posedge clk, tch);
  $width(negedge clk, tcl);

// =========================================================
// Timing Checks (Non-Conditional)
// =========================================================
  $setuphold(posedge clk, posedge adr[0], tsh, tsh, adr_n_0_,,, clk_sd, adr_sd[0]);
  $setuphold(posedge clk, negedge adr[0], tsh, tsh, adr_n_0_,,, clk_sd, adr_sd[0]);
  $setuphold(posedge clk, posedge adr[1], tsh, tsh, adr_n_1_,,, clk_sd, adr_sd[1]);
  $setuphold(posedge clk, negedge adr[1], tsh, tsh, adr_n_1_,,, clk_sd, adr_sd[1]);
  $setuphold(posedge clk, posedge adr[2], tsh, tsh, adr_n_2_,,, clk_sd, adr_sd[2]);
  $setuphold(posedge clk, negedge adr[2], tsh, tsh, adr_n_2_,,, clk_sd, adr_sd[2]);
  $setuphold(posedge clk, posedge adr[3], tsh, tsh, adr_n_3_,,, clk_sd, adr_sd[3]);
  $setuphold(posedge clk, negedge adr[3], tsh, tsh, adr_n_3_,,, clk_sd, adr_sd[3]);
  $setuphold(posedge clk, posedge adr[4], tsh, tsh, adr_n_4_,,, clk_sd, adr_sd[4]);
  $setuphold(posedge clk, negedge adr[4], tsh, tsh, adr_n_4_,,, clk_sd, adr_sd[4]);
  $setuphold(posedge clk, posedge adr[5], tsh, tsh, adr_n_5_,,, clk_sd, adr_sd[5]);
  $setuphold(posedge clk, negedge adr[5], tsh, tsh, adr_n_5_,,, clk_sd, adr_sd[5]);
  $setuphold(posedge clk, posedge adr[6], tsh, tsh, adr_n_6_,,, clk_sd, adr_sd[6]);
  $setuphold(posedge clk, negedge adr[6], tsh, tsh, adr_n_6_,,, clk_sd, adr_sd[6]);
  $setuphold(posedge clk, posedge adr[7], tsh, tsh, adr_n_7_,,, clk_sd, adr_sd[7]);
  $setuphold(posedge clk, negedge adr[7], tsh, tsh, adr_n_7_,,, clk_sd, adr_sd[7]);
  $setuphold(posedge clk, posedge adr[8], tsh, tsh, adr_n_8_,,, clk_sd, adr_sd[8]);
  $setuphold(posedge clk, negedge adr[8], tsh, tsh, adr_n_8_,,, clk_sd, adr_sd[8]);
  $setuphold(posedge clk, posedge adr[9], tsh, tsh, adr_n_9_,,, clk_sd, adr_sd[9]);
  $setuphold(posedge clk, negedge adr[9], tsh, tsh, adr_n_9_,,, clk_sd, adr_sd[9]);
  $setuphold(posedge clk, posedge din[0], tsh, tsh, din_n_0_,,, clk_sd, din_sd[0]);
  $setuphold(posedge clk, negedge din[0], tsh, tsh, din_n_0_,,, clk_sd, din_sd[0]);
  $setuphold(posedge clk, posedge din[1], tsh, tsh, din_n_1_,,, clk_sd, din_sd[1]);
  $setuphold(posedge clk, negedge din[1], tsh, tsh, din_n_1_,,, clk_sd, din_sd[1]);
  $setuphold(posedge clk, posedge din[2], tsh, tsh, din_n_2_,,, clk_sd, din_sd[2]);
  $setuphold(posedge clk, negedge din[2], tsh, tsh, din_n_2_,,, clk_sd, din_sd[2]);
  $setuphold(posedge clk, posedge din[3], tsh, tsh, din_n_3_,,, clk_sd, din_sd[3]);
  $setuphold(posedge clk, negedge din[3], tsh, tsh, din_n_3_,,, clk_sd, din_sd[3]);
  $setuphold(posedge clk, posedge din[4], tsh, tsh, din_n_4_,,, clk_sd, din_sd[4]);
  $setuphold(posedge clk, negedge din[4], tsh, tsh, din_n_4_,,, clk_sd, din_sd[4]);
  $setuphold(posedge clk, posedge din[5], tsh, tsh, din_n_5_,,, clk_sd, din_sd[5]);
  $setuphold(posedge clk, negedge din[5], tsh, tsh, din_n_5_,,, clk_sd, din_sd[5]);
  $setuphold(posedge clk, posedge din[6], tsh, tsh, din_n_6_,,, clk_sd, din_sd[6]);
  $setuphold(posedge clk, negedge din[6], tsh, tsh, din_n_6_,,, clk_sd, din_sd[6]);
  $setuphold(posedge clk, posedge din[7], tsh, tsh, din_n_7_,,, clk_sd, din_sd[7]);
  $setuphold(posedge clk, negedge din[7], tsh, tsh, din_n_7_,,, clk_sd, din_sd[7]);
  $setuphold(posedge clk, posedge din[8], tsh, tsh, din_n_8_,,, clk_sd, din_sd[8]);
  $setuphold(posedge clk, negedge din[8], tsh, tsh, din_n_8_,,, clk_sd, din_sd[8]);
  $setuphold(posedge clk, posedge din[9], tsh, tsh, din_n_9_,,, clk_sd, din_sd[9]);
  $setuphold(posedge clk, negedge din[9], tsh, tsh, din_n_9_,,, clk_sd, din_sd[9]);
  $setuphold(posedge clk, posedge din[10], tsh, tsh, din_n_10_,,, clk_sd, din_sd[10]);
  $setuphold(posedge clk, negedge din[10], tsh, tsh, din_n_10_,,, clk_sd, din_sd[10]);
  $setuphold(posedge clk, posedge din[11], tsh, tsh, din_n_11_,,, clk_sd, din_sd[11]);
  $setuphold(posedge clk, negedge din[11], tsh, tsh, din_n_11_,,, clk_sd, din_sd[11]);
  $setuphold(posedge clk, posedge din[12], tsh, tsh, din_n_12_,,, clk_sd, din_sd[12]);
  $setuphold(posedge clk, negedge din[12], tsh, tsh, din_n_12_,,, clk_sd, din_sd[12]);
  $setuphold(posedge clk, posedge din[13], tsh, tsh, din_n_13_,,, clk_sd, din_sd[13]);
  $setuphold(posedge clk, negedge din[13], tsh, tsh, din_n_13_,,, clk_sd, din_sd[13]);
  $setuphold(posedge clk, posedge din[14], tsh, tsh, din_n_14_,,, clk_sd, din_sd[14]);
  $setuphold(posedge clk, negedge din[14], tsh, tsh, din_n_14_,,, clk_sd, din_sd[14]);
  $setuphold(posedge clk, posedge din[15], tsh, tsh, din_n_15_,,, clk_sd, din_sd[15]);
  $setuphold(posedge clk, negedge din[15], tsh, tsh, din_n_15_,,, clk_sd, din_sd[15]);
  $setuphold(posedge clk, posedge din[16], tsh, tsh, din_n_16_,,, clk_sd, din_sd[16]);
  $setuphold(posedge clk, negedge din[16], tsh, tsh, din_n_16_,,, clk_sd, din_sd[16]);
  $setuphold(posedge clk, posedge din[17], tsh, tsh, din_n_17_,,, clk_sd, din_sd[17]);
  $setuphold(posedge clk, negedge din[17], tsh, tsh, din_n_17_,,, clk_sd, din_sd[17]);
  $setuphold(posedge clk, posedge din[18], tsh, tsh, din_n_18_,,, clk_sd, din_sd[18]);
  $setuphold(posedge clk, negedge din[18], tsh, tsh, din_n_18_,,, clk_sd, din_sd[18]);
  $setuphold(posedge clk, posedge din[19], tsh, tsh, din_n_19_,,, clk_sd, din_sd[19]);
  $setuphold(posedge clk, negedge din[19], tsh, tsh, din_n_19_,,, clk_sd, din_sd[19]);
  $setuphold(posedge clk, posedge din[20], tsh, tsh, din_n_20_,,, clk_sd, din_sd[20]);
  $setuphold(posedge clk, negedge din[20], tsh, tsh, din_n_20_,,, clk_sd, din_sd[20]);
  $setuphold(posedge clk, posedge din[21], tsh, tsh, din_n_21_,,, clk_sd, din_sd[21]);
  $setuphold(posedge clk, negedge din[21], tsh, tsh, din_n_21_,,, clk_sd, din_sd[21]);
  $setuphold(posedge clk, posedge din[22], tsh, tsh, din_n_22_,,, clk_sd, din_sd[22]);
  $setuphold(posedge clk, negedge din[22], tsh, tsh, din_n_22_,,, clk_sd, din_sd[22]);
  $setuphold(posedge clk, posedge din[23], tsh, tsh, din_n_23_,,, clk_sd, din_sd[23]);
  $setuphold(posedge clk, negedge din[23], tsh, tsh, din_n_23_,,, clk_sd, din_sd[23]);
  $setuphold(posedge clk, posedge din[24], tsh, tsh, din_n_24_,,, clk_sd, din_sd[24]);
  $setuphold(posedge clk, negedge din[24], tsh, tsh, din_n_24_,,, clk_sd, din_sd[24]);
  $setuphold(posedge clk, posedge din[25], tsh, tsh, din_n_25_,,, clk_sd, din_sd[25]);
  $setuphold(posedge clk, negedge din[25], tsh, tsh, din_n_25_,,, clk_sd, din_sd[25]);
  $setuphold(posedge clk, posedge din[26], tsh, tsh, din_n_26_,,, clk_sd, din_sd[26]);
  $setuphold(posedge clk, negedge din[26], tsh, tsh, din_n_26_,,, clk_sd, din_sd[26]);
  $setuphold(posedge clk, posedge din[27], tsh, tsh, din_n_27_,,, clk_sd, din_sd[27]);
  $setuphold(posedge clk, negedge din[27], tsh, tsh, din_n_27_,,, clk_sd, din_sd[27]);
  $setuphold(posedge clk, posedge din[28], tsh, tsh, din_n_28_,,, clk_sd, din_sd[28]);
  $setuphold(posedge clk, negedge din[28], tsh, tsh, din_n_28_,,, clk_sd, din_sd[28]);
  $setuphold(posedge clk, posedge din[29], tsh, tsh, din_n_29_,,, clk_sd, din_sd[29]);
  $setuphold(posedge clk, negedge din[29], tsh, tsh, din_n_29_,,, clk_sd, din_sd[29]);
  $setuphold(posedge clk, posedge din[30], tsh, tsh, din_n_30_,,, clk_sd, din_sd[30]);
  $setuphold(posedge clk, negedge din[30], tsh, tsh, din_n_30_,,, clk_sd, din_sd[30]);
  $setuphold(posedge clk, posedge din[31], tsh, tsh, din_n_31_,,, clk_sd, din_sd[31]);
  $setuphold(posedge clk, negedge din[31], tsh, tsh, din_n_31_,,, clk_sd, din_sd[31]);
  $setuphold(posedge clk, posedge din[32], tsh, tsh, din_n_32_,,, clk_sd, din_sd[32]);
  $setuphold(posedge clk, negedge din[32], tsh, tsh, din_n_32_,,, clk_sd, din_sd[32]);
  $setuphold(posedge clk, posedge din[33], tsh, tsh, din_n_33_,,, clk_sd, din_sd[33]);
  $setuphold(posedge clk, negedge din[33], tsh, tsh, din_n_33_,,, clk_sd, din_sd[33]);
  $setuphold(posedge clk, posedge din[34], tsh, tsh, din_n_34_,,, clk_sd, din_sd[34]);
  $setuphold(posedge clk, negedge din[34], tsh, tsh, din_n_34_,,, clk_sd, din_sd[34]);
  $setuphold(posedge clk, posedge din[35], tsh, tsh, din_n_35_,,, clk_sd, din_sd[35]);
  $setuphold(posedge clk, negedge din[35], tsh, tsh, din_n_35_,,, clk_sd, din_sd[35]);
  $setuphold(posedge clk, posedge din[36], tsh, tsh, din_n_36_,,, clk_sd, din_sd[36]);
  $setuphold(posedge clk, negedge din[36], tsh, tsh, din_n_36_,,, clk_sd, din_sd[36]);
  $setuphold(posedge clk, posedge din[37], tsh, tsh, din_n_37_,,, clk_sd, din_sd[37]);
  $setuphold(posedge clk, negedge din[37], tsh, tsh, din_n_37_,,, clk_sd, din_sd[37]);
  $setuphold(posedge clk, posedge din[38], tsh, tsh, din_n_38_,,, clk_sd, din_sd[38]);
  $setuphold(posedge clk, negedge din[38], tsh, tsh, din_n_38_,,, clk_sd, din_sd[38]);
  $setuphold(posedge clk, posedge din[39], tsh, tsh, din_n_39_,,, clk_sd, din_sd[39]);
  $setuphold(posedge clk, negedge din[39], tsh, tsh, din_n_39_,,, clk_sd, din_sd[39]);
  $setuphold(posedge clk, posedge din[40], tsh, tsh, din_n_40_,,, clk_sd, din_sd[40]);
  $setuphold(posedge clk, negedge din[40], tsh, tsh, din_n_40_,,, clk_sd, din_sd[40]);
  $setuphold(posedge clk, posedge din[41], tsh, tsh, din_n_41_,,, clk_sd, din_sd[41]);
  $setuphold(posedge clk, negedge din[41], tsh, tsh, din_n_41_,,, clk_sd, din_sd[41]);
  $setuphold(posedge clk, posedge din[42], tsh, tsh, din_n_42_,,, clk_sd, din_sd[42]);
  $setuphold(posedge clk, negedge din[42], tsh, tsh, din_n_42_,,, clk_sd, din_sd[42]);
  $setuphold(posedge clk, posedge din[43], tsh, tsh, din_n_43_,,, clk_sd, din_sd[43]);
  $setuphold(posedge clk, negedge din[43], tsh, tsh, din_n_43_,,, clk_sd, din_sd[43]);
  $setuphold(posedge clk, posedge din[44], tsh, tsh, din_n_44_,,, clk_sd, din_sd[44]);
  $setuphold(posedge clk, negedge din[44], tsh, tsh, din_n_44_,,, clk_sd, din_sd[44]);
  $setuphold(posedge clk, posedge din[45], tsh, tsh, din_n_45_,,, clk_sd, din_sd[45]);
  $setuphold(posedge clk, negedge din[45], tsh, tsh, din_n_45_,,, clk_sd, din_sd[45]);
  $setuphold(posedge clk, posedge din[46], tsh, tsh, din_n_46_,,, clk_sd, din_sd[46]);
  $setuphold(posedge clk, negedge din[46], tsh, tsh, din_n_46_,,, clk_sd, din_sd[46]);
  $setuphold(posedge clk, posedge din[47], tsh, tsh, din_n_47_,,, clk_sd, din_sd[47]);
  $setuphold(posedge clk, negedge din[47], tsh, tsh, din_n_47_,,, clk_sd, din_sd[47]);
  $setuphold(posedge clk, posedge din[48], tsh, tsh, din_n_48_,,, clk_sd, din_sd[48]);
  $setuphold(posedge clk, negedge din[48], tsh, tsh, din_n_48_,,, clk_sd, din_sd[48]);
  $setuphold(posedge clk, posedge din[49], tsh, tsh, din_n_49_,,, clk_sd, din_sd[49]);
  $setuphold(posedge clk, negedge din[49], tsh, tsh, din_n_49_,,, clk_sd, din_sd[49]);
  $setuphold(posedge clk, posedge din[50], tsh, tsh, din_n_50_,,, clk_sd, din_sd[50]);
  $setuphold(posedge clk, negedge din[50], tsh, tsh, din_n_50_,,, clk_sd, din_sd[50]);
  $setuphold(posedge clk, posedge din[51], tsh, tsh, din_n_51_,,, clk_sd, din_sd[51]);
  $setuphold(posedge clk, negedge din[51], tsh, tsh, din_n_51_,,, clk_sd, din_sd[51]);
  $setuphold(posedge clk, posedge din[52], tsh, tsh, din_n_52_,,, clk_sd, din_sd[52]);
  $setuphold(posedge clk, negedge din[52], tsh, tsh, din_n_52_,,, clk_sd, din_sd[52]);
  $setuphold(posedge clk, posedge ren, tsh, tsh, ren_n__,,, clk_sd, ren_sd);
  $setuphold(posedge clk, negedge ren, tsh, tsh, ren_n__,,, clk_sd, ren_sd);
  $setuphold(posedge clk, posedge wen, tsh, tsh, wen_n__,,, clk_sd, wen_sd);
  $setuphold(posedge clk, negedge wen, tsh, tsh, wen_n__,,, clk_sd, wen_sd);
  $setuphold(posedge clk, posedge redrowen[0], tsh, tsh, redrowen_n_0_,,, clk_sd, redrowen_sd[0]);
  $setuphold(posedge clk, negedge redrowen[0], tsh, tsh, redrowen_n_0_,,, clk_sd, redrowen_sd[0]);
  $setuphold(posedge clk, posedge redrowen[1], tsh, tsh, redrowen_n_1_,,, clk_sd, redrowen_sd[1]);
  $setuphold(posedge clk, negedge redrowen[1], tsh, tsh, redrowen_n_1_,,, clk_sd, redrowen_sd[1]);
  $setuphold(posedge clk, posedge mce, tsh, tsh, mce_n__,,, clk_sd, mce_sd);
  $setuphold(posedge clk, negedge mce, tsh, tsh, mce_n__,,, clk_sd, mce_sd);
  $setuphold(posedge clk, posedge stbyp, tsh, tsh, stbyp_n__,,, clk_sd, stbyp_sd);
  $setuphold(posedge clk, negedge stbyp, tsh, tsh, stbyp_n__,,, clk_sd, stbyp_sd);
  $setuphold(posedge clk, posedge rmce[0], tsh, tsh, rmce_n_0_,,, clk_sd, rmce_sd[0]);
  $setuphold(posedge clk, negedge rmce[0], tsh, tsh, rmce_n_0_,,, clk_sd, rmce_sd[0]);
  $setuphold(posedge clk, posedge rmce[1], tsh, tsh, rmce_n_1_,,, clk_sd, rmce_sd[1]);
  $setuphold(posedge clk, negedge rmce[1], tsh, tsh, rmce_n_1_,,, clk_sd, rmce_sd[1]);
  $setuphold(posedge clk, posedge rmce[2], tsh, tsh, rmce_n_2_,,, clk_sd, rmce_sd[2]);
  $setuphold(posedge clk, negedge rmce[2], tsh, tsh, rmce_n_2_,,, clk_sd, rmce_sd[2]);
  $setuphold(posedge clk, posedge rmce[3], tsh, tsh, rmce_n_3_,,, clk_sd, rmce_sd[3]);
  $setuphold(posedge clk, negedge rmce[3], tsh, tsh, rmce_n_3_,,, clk_sd, rmce_sd[3]);
  $setuphold(posedge clk, posedge wmce[0], tsh, tsh, wmce_n_0_,,, clk_sd, wmce_sd[0]);
  $setuphold(posedge clk, negedge wmce[0], tsh, tsh, wmce_n_0_,,, clk_sd, wmce_sd[0]);
  $setuphold(posedge clk, posedge wmce[1], tsh, tsh, wmce_n_1_,,, clk_sd, wmce_sd[1]);
  $setuphold(posedge clk, negedge wmce[1], tsh, tsh, wmce_n_1_,,, clk_sd, wmce_sd[1]);
  $setuphold(posedge clk, posedge async_reset, tsh, tsh, async_reset_n__,,, clk_sd, async_reset_sd);
  $setuphold(posedge clk, negedge async_reset, tsh, tsh, async_reset_n__,,, clk_sd, async_reset_sd);
  $setuphold(posedge clk, posedge arysleep, tsh, tsh, arysleep_n__,,, clk_sd, arysleep_sd);
  $setuphold(posedge clk, negedge arysleep, tsh, tsh, arysleep_n__,,, clk_sd, arysleep_sd);
  $setuphold(posedge clk, posedge sbc[0], tsh, tsh, sbc_n_0_,,, clk_sd, sbc_sd[0]);
  $setuphold(posedge clk, negedge sbc[0], tsh, tsh, sbc_n_0_,,, clk_sd, sbc_sd[0]);
  $setuphold(posedge clk, posedge sbc[1], tsh, tsh, sbc_n_1_,,, clk_sd, sbc_sd[1]);
  $setuphold(posedge clk, negedge sbc[1], tsh, tsh, sbc_n_1_,,, clk_sd, sbc_sd[1]);
  $setuphold(posedge clk, posedge wa[0], tsh, tsh, wa_n_0_,,, clk_sd, wa_sd[0]);
  $setuphold(posedge clk, negedge wa[0], tsh, tsh, wa_n_0_,,, clk_sd, wa_sd[0]);
  $setuphold(posedge clk, posedge wa[1], tsh, tsh, wa_n_1_,,, clk_sd, wa_sd[1]);
  $setuphold(posedge clk, negedge wa[1], tsh, tsh, wa_n_1_,,, clk_sd, wa_sd[1]);
  $setuphold(posedge clk, posedge wa[2], tsh, tsh, wa_n_2_,,, clk_sd, wa_sd[2]);
  $setuphold(posedge clk, negedge wa[2], tsh, tsh, wa_n_2_,,, clk_sd, wa_sd[2]);
  $setuphold(posedge clk, posedge wpulse[0], tsh, tsh, wpulse_n_0_,,, clk_sd, wpulse_sd[0]);
  $setuphold(posedge clk, negedge wpulse[0], tsh, tsh, wpulse_n_0_,,, clk_sd, wpulse_sd[0]);
  $setuphold(posedge clk, posedge wpulse[1], tsh, tsh, wpulse_n_1_,,, clk_sd, wpulse_sd[1]);
  $setuphold(posedge clk, negedge wpulse[1], tsh, tsh, wpulse_n_1_,,, clk_sd, wpulse_sd[1]);
  $setuphold(posedge clk, posedge wpulse[2], tsh, tsh, wpulse_n_2_,,, clk_sd, wpulse_sd[2]);
  $setuphold(posedge clk, negedge wpulse[2], tsh, tsh, wpulse_n_2_,,, clk_sd, wpulse_sd[2]);
  $setuphold(posedge clk, posedge ra[0], tsh, tsh, ra_n_0_,,, clk_sd, ra_sd[0]);
  $setuphold(posedge clk, negedge ra[0], tsh, tsh, ra_n_0_,,, clk_sd, ra_sd[0]);
  $setuphold(posedge clk, posedge ra[1], tsh, tsh, ra_n_1_,,, clk_sd, ra_sd[1]);
  $setuphold(posedge clk, negedge ra[1], tsh, tsh, ra_n_1_,,, clk_sd, ra_sd[1]);

// =========================================================
// Clock Period (tcc) Timing Checks for "ifnone" conditional
// =========================================================
  $period(posedge clk, tcc);

// =========================================================
// Timing ARCs (tcq) for "ifnone" conditional
// =========================================================
  ifnone (posedge clk => (q[0] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[1] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[2] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[3] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[4] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[5] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[6] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[7] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[8] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[9] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[10] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[11] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[12] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[13] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[14] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[15] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[16] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[17] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[18] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[19] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[20] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[21] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[22] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[23] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[24] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[25] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[26] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[27] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[28] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[29] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[30] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[31] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[32] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[33] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[34] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[35] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[36] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[37] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[38] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[39] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[40] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[41] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[42] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[43] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[44] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[45] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[46] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[47] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[48] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[49] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[50] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[51] : 1'bx)) = (tcq,tcq);
  ifnone (posedge clk => (q[52] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[0] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[1] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[2] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[3] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[4] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[5] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[6] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[7] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[8] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[9] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[10] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[11] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[12] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[13] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[14] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[15] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[16] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[17] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[18] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[19] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[20] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[21] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[22] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[23] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[24] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[25] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[26] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[27] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[28] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[29] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[30] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[31] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[32] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[33] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[34] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[35] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[36] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[37] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[38] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[39] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[40] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[41] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[42] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[43] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[44] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[45] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[46] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[47] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[48] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[49] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[50] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[51] : 1'bx)) = (tcq,tcq);
  ifnone (posedge async_reset => (q[52] : 1'bx)) = (tcq,tcq);

// =========================================================
// Clock Period (tcc) Timing Checks for "tm3" conditional
// =========================================================
  $period(posedge clk &&& tm3, tcc);

// =========================================================
// Timing ARCs (tcq) for "tm3" conditional
// =========================================================
  if ( tm3 )(posedge clk => (q[0] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[1] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[2] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[3] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[4] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[5] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[6] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[7] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[8] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[9] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[10] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[11] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[12] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[13] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[14] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[15] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[16] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[17] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[18] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[19] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[20] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[21] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[22] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[23] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[24] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[25] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[26] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[27] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[28] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[29] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[30] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[31] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[32] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[33] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[34] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[35] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[36] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[37] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[38] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[39] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[40] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[41] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[42] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[43] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[44] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[45] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[46] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[47] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[48] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[49] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[50] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[51] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge clk => (q[52] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[0] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[1] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[2] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[3] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[4] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[5] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[6] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[7] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[8] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[9] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[10] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[11] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[12] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[13] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[14] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[15] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[16] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[17] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[18] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[19] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[20] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[21] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[22] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[23] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[24] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[25] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[26] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[27] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[28] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[29] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[30] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[31] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[32] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[33] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[34] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[35] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[36] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[37] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[38] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[39] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[40] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[41] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[42] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[43] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[44] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[45] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[46] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[47] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[48] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[49] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[50] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[51] : 1'bx)) = (tcq,tcq);
  if ( tm3 )(posedge async_reset => (q[52] : 1'bx)) = (tcq,tcq);

// =========================================================
// Clock Period (tcc) Timing Checks for "tm1" conditional
// =========================================================
  $period(posedge clk &&& tm1, tcc);

// =========================================================
// Timing ARCs (tcq) for "tm1" conditional
// =========================================================
  if ( tm1 )(posedge clk => (q[0] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[1] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[2] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[3] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[4] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[5] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[6] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[7] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[8] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[9] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[10] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[11] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[12] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[13] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[14] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[15] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[16] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[17] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[18] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[19] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[20] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[21] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[22] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[23] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[24] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[25] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[26] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[27] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[28] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[29] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[30] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[31] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[32] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[33] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[34] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[35] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[36] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[37] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[38] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[39] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[40] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[41] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[42] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[43] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[44] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[45] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[46] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[47] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[48] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[49] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[50] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[51] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge clk => (q[52] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[0] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[1] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[2] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[3] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[4] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[5] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[6] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[7] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[8] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[9] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[10] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[11] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[12] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[13] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[14] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[15] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[16] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[17] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[18] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[19] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[20] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[21] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[22] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[23] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[24] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[25] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[26] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[27] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[28] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[29] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[30] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[31] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[32] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[33] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[34] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[35] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[36] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[37] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[38] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[39] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[40] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[41] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[42] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[43] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[44] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[45] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[46] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[47] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[48] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[49] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[50] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[51] : 1'bx)) = (tcq,tcq);
  if ( tm1 )(posedge async_reset => (q[52] : 1'bx)) = (tcq,tcq);

// =========================================================
// Clock Period (tcc) Timing Checks for "tm2" conditional
// =========================================================
  $period(posedge clk &&& tm2, tcc);

// =========================================================
// Timing ARCs (tcq) for "tm2" conditional
// =========================================================
  if ( tm2 )(posedge clk => (q[0] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[1] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[2] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[3] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[4] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[5] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[6] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[7] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[8] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[9] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[10] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[11] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[12] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[13] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[14] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[15] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[16] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[17] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[18] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[19] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[20] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[21] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[22] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[23] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[24] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[25] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[26] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[27] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[28] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[29] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[30] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[31] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[32] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[33] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[34] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[35] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[36] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[37] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[38] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[39] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[40] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[41] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[42] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[43] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[44] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[45] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[46] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[47] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[48] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[49] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[50] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[51] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge clk => (q[52] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[0] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[1] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[2] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[3] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[4] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[5] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[6] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[7] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[8] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[9] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[10] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[11] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[12] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[13] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[14] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[15] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[16] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[17] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[18] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[19] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[20] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[21] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[22] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[23] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[24] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[25] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[26] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[27] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[28] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[29] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[30] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[31] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[32] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[33] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[34] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[35] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[36] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[37] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[38] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[39] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[40] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[41] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[42] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[43] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[44] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[45] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[46] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[47] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[48] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[49] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[50] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[51] : 1'bx)) = (tcq,tcq);
  if ( tm2 )(posedge async_reset => (q[52] : 1'bx)) = (tcq,tcq);

  endspecify
`endif // INTC_MEM_GLS


//lintra push -1461, -1460
//lintra push -0566, -50005, -2048, -60029, -60211
`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// X handling
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------

`ifdef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_XINPUT_CHECK
`ifndef INTC_MEM_LINT
  always @(posedge clk)
  begin
    if (clk === 1'bx)
      begin
        $display ("-W- : %m : @ %0t : X-state detected for input signal : clock",$time);
      end
    if (ren === 1'bx)
      begin
        $display ("-W- : %m : @ %0t : X-state detected for input signal : read",$time);
      end
    if (wen === 1'bx)
      begin
        $display ("-W- : %m : @ %0t : X-state detected for input signal : write",$time);
      end
    if (^adr === 1'bx)
      begin
        $display ("-W- : %m : @ %0t : X-state detected for input signal : address[9:0] : %b",$time,adr);
      end
    if (^redrowen === 1'bx)
      begin
        $display ("-W- : %m : @ %0t : X-state detected for row redundancy input signal [1:0] : %b",$time,redrowen);
      end
  end

  always @(async_reset)
  begin
    if (async_reset === 1'bx)
      begin
        $display ("-W- : %m : @ %0t : X-state detected for async_reset input signal",$time);
      end
  end

  always @(arysleep)
  begin
    if (arysleep === 1'bx)
      begin
        $display ("-W- : %m : @ %0t : X-state detected for arysleep input signal",$time);
      end
  end


`endif //LINT
`endif //INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_XINPUT_CHECK

//--------------------------------
// PME Hazards section
//--------------------------------



`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_NOXHANDLING
//--------------------------------
// X array on firewall X
//--------------------------------
//lintra push -0564, -50002, -50000, -68092
always @(async_reset)
  begin
    if ((async_reset !== 1'b0) && (async_reset !== 1'b1)) //lintra s-8213
      begin
`ifndef INTC_MEM_LINT // Required to prevent Lintra hangup
        // X the array
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setarray(1'bx,1024);
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setredarray(1'bx,8);
`endif //LINT
      end
  end
//lintra pop
`endif //INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_NOXHANDLING



`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_NOXHANDLING
//------------------------------------
// X array on sleep X or sleep bias X
//------------------------------------
//lintra push -0564, -50002, -50000, -68092
always @(arysleep or sbc[1:0])
  begin
    if ((arysleep !== 1'b0) && (arysleep !== 1'b1)) //lintra s-8213
      begin
        // X the array
`ifndef INTC_MEM_LINT // Required to prevent Lintra hangup
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setarray(1'bx,1024);
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setredarray(1'bx,8);
`endif //LINT
      end
    else if (arysleep === 1'b1) //lintra s-8213
      begin
      if ((^sbc[1:0] !== 1'b0) && (^sbc[1:0] !== 1'b1)) //lintra s-8213
        begin
          // X the array
`ifndef INTC_MEM_LINT // Required to prevent Lintra hangup
          ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setarray(1'bx,1024);
          ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setredarray(1'bx,8);
`endif //LINT
        end
      end
  end
//lintra pop
`endif //INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_NOXHANDLING

//--------------------------------
// Default fuse checking
//--------------------------------

//lintra push -0564, -50002, -50000, -68092
initial
  begin
`ifndef INTC_MEM_LINT // Required to prevent Lintra hangup
    #1;
    if ((^{mce,stbyp,rmce,wmce,wpulse,ra,wa} !== 1'b0) && (^{mce,stbyp,rmce,wmce,wpulse,ra,wa} !== 1'b1)) // X-state  check of fuse inputs
    begin
      $display ("-W- : %m : @ %0t : X-state detected on fuse inputs : mce,stbyp,rmce,wmce,wpulse,ra,wa : %b",$time,{mce,stbyp,rmce,wmce,wpulse,ra,wa});
    end
`endif //LINT
  end

always @(mce,stbyp,rmce,wmce,wpulse,ra,wa)
  begin
`ifndef INTC_MEM_LINT // Required to prevent Lintra hangup

    if ((shutoff === 1'b0) && (pshutoff === 1'b0))
    begin
      #1;
      if ((^{mce,stbyp,rmce,wmce,wpulse,ra,wa} !== 1'b0) && (^{mce,stbyp,rmce,wmce,wpulse,ra,wa} !== 1'b1)) // X-state  check of fuse inputs
      begin
        $display ("-W- : %m : @ %0t : X-state detected on fuse inputs : mce,stbyp,rmce,wmce,wpulse,ra,wa : %b",$time,{mce,stbyp,rmce,wmce,wpulse,ra,wa});
      end
    end
`endif //LINT
  end
//lintra pop

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// X handling for SDF annotation notifiers to corrupt latches
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------

`ifndef INTC_MEM_GLS
`else
`ifdef INTC_MEM_ENABLE_GLS_XPROP
`ifndef INTC_MEM_LINT
// handle notifiers from specify block timing checks and corrupt latches in
//  lower level _bmod
  always @ (async_reset_n__)
    begin
      force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wen_fwls_ms01l=1'bx;
      release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wen_fwls_ms01l;
      force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ren_fwls=1'bx;
      release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ren_fwls;
// corrupt wakeup latch
      force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wakeup_fwls_ms01l=1'bx;
      release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wakeup_fwls_ms01l;
    end
  always @ (arysleep_n__)
    begin
      force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wen_fwls_ms01l=1'bx;
      release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wen_fwls_ms01l;
      force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ren_fwls=1'bx;
      release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ren_fwls;
// corrupt wakeup latch
      force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wakeup_fwls_ms01l=1'bx;
      release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wakeup_fwls_ms01l;
    end

// reset latches with data input when no notifier action
  always @ (clk)
    begin
      force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ren_fwls_ms01l=ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ren_fwls;
      release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ren_fwls_ms01l;
      force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wakeup_fwls_ms01l=ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wakeup;
      release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wakeup_fwls_ms01l;
    end
  always @ (clk)
    begin
      force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wen_fwls_ms01l=ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wen_fwls;
      release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wen_fwls_ms01l;
      force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wakeup_fwls_ms01l=ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wakeup;
      release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.wakeup_fwls_ms01l;
    end
`endif // INTC_MEM_LINT
`endif // INTC_MEM_ENABLE_GLS_XPROP
`endif // INTC_MEM_GLS




//lintra push -0564, -50002, -50000, -68092

`ifndef INTEL_NO_PWR_PINS  // if non-upf flow is enabled
`else
//--------------------------------
// X array when all functional inputs are X (input supply gated)
//--------------------------------
always @(clk,ren,wen,din,adr,mce,stbyp,rmce,wmce,wpulse,ra,wa,redrowen,sbc,arysleep)
  begin
    casez ({clk,ren,wen,^din,^adr,mce,stbyp,^rmce,^wmce,^wpulse,^ra,^wa,^redrowen,^sbc,arysleep})
      15'bxxxxxxxxxxxxxxx : begin
          // X the array due to VCCSOC_GT power down or all inputs X
`ifndef INTC_MEM_LINT // Required to prevent Lintra hangup
          ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setarray(1'bx,1024);
          ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setredarray(1'bx,8);
`endif //INTC_MEM_LINT
        end
      default : begin
      end
    endcase
  end
`endif // power pins

`ifndef INTC_MEM_NOXHANDLING

reg dsflop;
wire dsfl;

`ifndef INTC_MEM_LINT
initial begin
  dsflop = 1'b0;
end
`endif // INTC_MEM_LINT

always @(posedge clk) begin
//  if (pshutoff !== 1'b0)
    dsflop <= pshutoff;
end

assign dsfl = pshutoff | dsflop;



always @(wmce[1:0], wpulse[1:0], dsfl)
  begin
    casez ({wmce[1:0],wpulse[1:0],dsfl})
      5'b????0 ,
      5'b000?1 : begin
      end
      5'b??1?1 ,
      5'b?1??1 ,
      5'b1???1 : begin
`ifndef INTC_MEM_LINT
//        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.array[adr] <= {53{1'bx}};
//        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setarray(1'bx,1024);
//        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setredarray(1'bx,8);
`endif // INTC_MEM_LINT
      end
      default : begin
      end
    endcase
  end
`endif // INTC_MEM_NOXHANDLING
//lintra pop
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_ESP_TASKS
//
//lintra pop // -0566, -50005, -2048, -60029, -60211

`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
//==========================================================
// Task for array loading from HEX file
//==========================================================
task automatic INTC_MEM_INIT;
  input [`INTC_MEM_PATH_SIZE*8:0] infile; //lintra s-60114
  reg [51:0] mem_tmp[0:1023]; //lintra s-2028
  integer k, address;
//  (* memory *) reg [51:0] mem_tmp[0:1023]; //lintra s-2028

begin
  // load 2D flat array data from hex file into temp location
  //   (does not include any redundant column information)
  $readmemh(infile,mem_tmp);

  // move the array across from 2d flat into regular array
  address = 0;
  for (k = 0; k < 1024; k = k + 1) //lintra s-60118
    begin
      // add an extra X in msb to cover column redundancy
      ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.array[k] = {1'bx,mem_tmp[address]}; //lintra s-50002
      address = address + 1;
    end
end
endtask
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

//lintra pop // -1461, -1460

//==========================================================
// Power Aware Verilog (PAV)
//==========================================================
`ifndef INTC_MEM_LINT
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
  `ifndef INTEL_NO_PWR_PINS
wire pwron, fwds;

event case_110;
event case_q10;
event case_1q0;
event case_11q;
event case_qq0;
event case_q1q;
event case_1qq;
event case_qqq;

wire  vddary; // Single rail FUB does not have VCCSRAM
assign vddary = 1'b1;
`ifndef INTC_ADD_VSS
wire vss; // vss not on main interface
assign vss = 1'b0; // VSS ON
`endif
assign fwds = async_reset | pshutoff;
assign pwron = 1'b1;

reg last_vddp;
reg last_vddary;
reg last_vss;

always @(vddp or vddary or vss)
  begin
    casez ({vddp,vddary,vss})
      3'b110: begin // All power ON
        -> case_110;
        release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.pd0;
        release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.pd1;
        release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_func_input.pd2;
        release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.dsrwin;
        release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.shutoff;

        if (last_vddp !== 1'b1) // code to specifically handle dsrw hazard after power on
        begin
          force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.ckfw = 1'b1;
       #0 release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.ckfw;
          last_vddp <= 1'b1;
        end
        else if (last_vddary !== 1'b1) // code to specifically handle dsrw hazard after power on
        begin
          force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.ckfw = 1'b1;
       #0 release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.ckfw;
          last_vddary <= 1'b1;
        end
        else if (last_vss !== 1'b0) // code to specifically handle dsrw hazard after power on
        begin
          force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.ckfw = 1'b1;
       #0 release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.ckfw;
          last_vss <= 1'b0;
        end
        else
        begin
        end

      end
      3'b?10: begin  // SOC = 0,X,Z  SRAM = 1 SRAMGT = 1 VSS = 0
        -> case_q10;
        // X the array
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setarray(1'bx,1024);
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setredarray(1'bx,8);
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.pd0 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.pd1 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_func_input.pd2 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.dsrwin = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.shutoff = 1'bx;
        last_vddp <= 1'b0;
      end
      3'b1?0: begin  // SOC = 1  SRAM = 0,X,Z  VSS = 0
        -> case_1q0;
        // X the array
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setarray(1'bx,256);
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setredarray(1'bx,8);
        release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.pd0;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.pd1 = 1'bx;
        release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_func_input.pd2;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.dsrwin = 1'bx;
        release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.shutoff;
        last_vddary <= 1'b0;
      end
      3'b11?: begin  // SOC = 1  SRAM = 1 SRAMGT = 1 VSS = 0,X,Z
        -> case_11q;
        // X the array
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setarray(1'bx,1024);
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setredarray(1'bx,8);
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.pd0 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.pd1 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_func_input.pd2 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.dsrwin = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.shutoff = 1'bx;
        last_vss <= 1'b1;
      end
      3'b?1?: begin  // SOC = 1  SRAM = 1 SRAMGT = 1 VSS = 0,X,Z
        -> case_q1q;
        // X the array
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setarray(1'bx,1024);
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setredarray(1'bx,8);
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.pd0 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.pd1 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_func_input.pd2 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.dsrwin = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.shutoff = 1'bx;
        last_vddp <= 1'b0;
        last_vss <= 1'b1;
      end
      3'b1??: begin  // SOC = 1  SRAM = 1 SRAMGT = 1 VSS = 0,X,Z
        -> case_1qq;
        // X the array
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setarray(1'bx,1024);
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setredarray(1'bx,8);
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.pd0 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.pd1 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_func_input.pd2 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.dsrwin = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.shutoff = 1'bx;
        last_vddary <= 1'b0;
        last_vss <= 1'b1;
      end
      3'b???: begin // SOC = 0,X,Z  SRAM = 0,X,Z  SRAMGT = 0,X,Z  VSS = 0,1,X,Z
        -> case_qqq;
        // X the array
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setarray(1'bx,1024);
        ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setredarray(1'bx,8);
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.pd0 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.pd1 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_func_input.pd2 = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.dsrwin = 1'bx;
        force ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.shutoff = 1'bx;
        last_vss <= 1'b1;
      end
      default: begin
        release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.pd0;
        release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.pd1;
        release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_func_input.pd2;
        release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.dsrwin;
        release ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_input.shutoff;
      end
    endcase
  end
`endif // PWR PINS
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
`endif // INTC_MEM_LINT
//============================
// End PAV
//============================

//==========================================================
// Clock Counting
//==========================================================
`ifndef INTC_MEM_LINT
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

integer async_reset_cnt;
integer shutoff_cnt;
integer pshutoff_cnt;
integer arysleep_cnt;
event   CCFAIL;

// set macros for clock counting
`ifdef INTC_MEM_async_reset_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_async_reset_cnt `INTC_MEM_async_reset_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_en_count
`endif // async_reset global
`ifdef ip764hduspsr1024x52m4b2s0r2p0d0_async_reset_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_async_reset_cnt `ip764hduspsr1024x52m4b2s0r2p0d0_async_reset_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_en_count
`endif // async_reset local

`ifdef INTC_MEM_shutoff_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_shutoff_cnt `INTC_MEM_shutoff_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_en_count
`endif // shutoff global
`ifdef ip764hduspsr1024x52m4b2s0r2p0d0_shutoff_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_shutoff_cnt `ip764hduspsr1024x52m4b2s0r2p0d0_shutoff_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_en_count
`endif // shutoff local

`ifdef INTC_MEM_pshutoff_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_pshutoff_cnt `INTC_MEM_pshutoff_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_en_count
`endif // pshutoff global
`ifdef ip764hduspsr1024x52m4b2s0r2p0d0_pshutoff_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_pshutoff_cnt `ip764hduspsr1024x52m4b2s0r2p0d0_pshutoff_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_en_count
`endif // pshutoff local

`ifdef INTC_MEM_arysleep_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_arysleep_cnt `INTC_MEM_arysleep_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_en_count
`endif // arysleep global
`ifdef ip764hduspsr1024x52m4b2s0r2p0d0_arysleep_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_arysleep_cnt `ip764hduspsr1024x52m4b2s0r2p0d0_arysleep_count
  `define ip764hduspsr1024x52m4b2s0r2p0d0_en_count
`endif // arysleep local

`ifdef ip764hduspsr1024x52m4b2s0r2p0d0_en_count
initial
//always @(ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_func_input.pd2)
  begin
    shutoff_cnt = 0;
    async_reset_cnt = 0;
    pshutoff_cnt = 0;
    arysleep_cnt = 0;
  end
`endif

`ifdef ip764hduspsr1024x52m4b2s0r2p0d0_async_reset_cnt
always @(async_reset)
  begin
    if (async_reset !== 1) async_reset_cnt = 0;
  end
`endif



`ifdef ip764hduspsr1024x52m4b2s0r2p0d0_arysleep_cnt
always @(arysleep)
  begin
    if (arysleep !== 1) arysleep_cnt = 0;
  end
`endif

// clock counting and checking
`ifdef ip764hduspsr1024x52m4b2s0r2p0d0_en_count
always @(posedge clk)
  begin
`ifdef ip764hduspsr1024x52m4b2s0r2p0d0_async_reset_cnt
    begin
      if (async_reset !== 0) async_reset_cnt = 0;
      if (ren | wen) begin
        if (async_reset_cnt < `ip764hduspsr1024x52m4b2s0r2p0d0_async_reset_cnt) begin
          $display ("-E- : %m : @ %0d : Memory access after async_reset LOW and before clock count greater than programmed value: %0d", $time, `ip764hduspsr1024x52m4b2s0r2p0d0_async_reset_cnt);
          #1 INTC_CC_FAIL;
        end
      end
      if (async_reset === 0) async_reset_cnt = async_reset_cnt + 1;
    end
`endif



`ifdef ip764hduspsr1024x52m4b2s0r2p0d0_arysleep_cnt
    begin
      if (arysleep !== 0) arysleep_cnt = 0;
      if (ren | wen) begin
        if (arysleep_cnt < `ip764hduspsr1024x52m4b2s0r2p0d0_arysleep_cnt) begin
          $display ("-E- : %m : @ %0d : Memory access after arysleep LOW and before clock count greater than programmed value: %0d", $time, `ip764hduspsr1024x52m4b2s0r2p0d0_arysleep_cnt);
          #1 INTC_CC_FAIL;
        end
      end
      if (arysleep === 0) arysleep_cnt = arysleep_cnt + 1;
    end
`endif
  end // posedge clk

task automatic INTC_CC_FAIL;
  begin
    if (wen !== 0) begin
      ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.setarray(1'bx,1024);
    end
    if (ren !== 0) begin
      ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_output.datas_ms02h[52:0] = {53{1'bx}};
      ip764hduspsr1024x52m4b2s0r2p0d0_bmod.ip764hduspsr1024x52m4b2s0r2p0d0_array.q[52:0] = {53{1'bx}};
//      ip764hduspsr1024x52m4b2s0r2p0d0_bmod.rd_clkq[52:0] = {53{1'bx}};
    end
    -> CCFAIL;
  end
endtask
`endif // ip764hduspsr1024x52m4b2s0r2p0d0_en_count

`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
`endif // INTC_MEM_LINT
//============================
// End Clock Counting
//============================

//==========================================================
// Clock Reset Checks
//==========================================================
// This block is used to perform clock reset related paranoia checks

wire pclk, clkg;
`ifndef INTC_MEM_GLS
  assign clkg  = clk;
`else // INTC_MEM_GLS
  assign clkg = clk_sdd; //lintra s-0529
`endif // INTC_MEM_GLS


`ifndef INTC_MEM_LINT
`ifndef INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE

wire ends, ensl, pbin, pbout, fwen;
reg  parg;
reg  gclk, gclklus, gclkluc;
reg  old_pwslfw;
wire ppwron;
wire pwslfw;

initial
  begin
    if ($test$plusargs("INTC_MEM_ENABLE_CLK_CHECKS")) begin
       parg = 1'b1;
       gclk = 1'bx;
//       gclkpoff = 1'bx;
       $display ("-I- : %m : @ %0d : Memory clock latched up by default to check for valid reset capability via pwrenb_in, ensleep, and/or firewall toggle from Non 0 to 0 state.  To disable this check, remove the INTC_MEM_ENABLE_CLK_CHECKS plusarg from your simulation command line.", $time);
    end
    else begin // plusarg disabled, clocks not gated
       parg = 1'b0;
       gclk = 1'b1;
//       gclkpoff = 1'b1;
    end
    old_pwslfw = 1'bx;
    gclklus = 1'b1;
    gclkluc = 1'b1;
  end

`ifndef INTC_MEM_GLS
  assign ends  = pshutoff;
  assign ensl  = arysleep;
  assign pbin  = shutoff;
  assign pbout = shutoffout;
  assign fwen  = async_reset;
`else // INTC_MEM_GLS
  assign ends  = pshutoff_i;
  assign ensl  = arysleep_i;
  assign pbin  = shutoff_i;
  assign pbout = shutoffout_i;
  assign fwen  = async_reset_i;
`endif // INTC_MEM_GLS


assign ppwron = 1'b1;

always @(ppwron or ends or clkg or parg or pwslfw or old_pwslfw)
  begin
   if ($test$plusargs("INTC_MEM_ENABLE_CLK_CHECKS")) begin
    parg = 1'b1;
    if (ppwron === 1'b1) begin              // check for power on conditions
      // check for pwr|sleep|fw transition non-X high to 0
      if (old_pwslfw === 1'b1 && pwslfw === 1'b0) begin
        gclk <= 1'b1;
        $display ("-I- : %m : @ %0d : Memory clock clear due to valid shutoff, pshutoff, and/or async_reset toggle Non 0 to 0 after power up", $time);
        if ($test$plusargs("INTC_MEM_ENABLE_PSLU_RECOVERY")) begin
          gclklus <= 1'b1;  // this masks out pshutoff check X response
          $display ("-I- : %m : @ %0d :   from previous latch up due to pshutoff assertion in power low to high region.", $time);
        end
        if ($test$plusargs("INTC_MEM_ENABLE_CKLU_RECOVERY")) begin
          gclkluc <= 1'b1;  // this masks out clock check X response
          $display ("-I- : %m : @ %0d :   from previous latch up due to clock assertion in power low to high region.", $time);
        end
      end
    end
    old_pwslfw <= pwslfw;
   end
   else
    gclk <= 1'b1;
  end

  //assign pwslfw = pbin | ensl | ends | fwen;  // for future
assign pwslfw = pbin | ends | ensl;

reg  xclk;
reg  xclkf;
wire xclko;
initial begin
  xclk  = 1'b0;
  xclkf = 1'b0;
end

//assign xclk = ~(gclk & gclklus & gclkluc);
always @(gclk or gclklus or gclkluc)
  begin
    if ($test$plusargs("INTC_MEM_ENABLE_CLK_CHECKS")) begin
      xclk <= ~(gclk & gclklus & gclkluc);
    end
    else begin
      xclk <= 1'b0;
    end
  end

always @(posedge clkg) begin
  xclkf <= xclk;
end

assign xclko = xclkf | xclk;

assign pclk = ~xclko !== 1'b1 ? 1'bx : clkg;

`else // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
assign pclk = clkg;
//assign xclk = 1'b0;
`endif // INTC_MEM_ip764hduspsr1024x52m4b2s0r2p0d0_EF_MODE
`else // INTC_MEM_LINT
assign pclk = clkg;
//assign xclk = 1'b0;
`endif // INTC_MEM_LINT

//============================
// End Clock Reset Checks
//============================

// ---------------------------------------------------------------------------
// Instantiate "RTL" behavioral model
// ----------------------------------
ip764hduspsr1024x52m4b2s0r2p0d0_bmod ip764hduspsr1024x52m4b2s0r2p0d0_bmod (
`ifndef INTC_MEM_GLS
   .clk(pclk)
  ,.fwen(async_reset)
  ,.shutoff(shutoff)
  ,.deepslp(pshutoff)
  ,.din(din)
  ,.ren(ren)
  ,.wen(wen)

  ,.redrowen(redrowen)

  ,.adr(adr)
  ,.sleep(arysleep)
  ,.sbc(sbc)
  ,.mce(mce)
  ,.stbyp(stbyp)
  ,.wmce(wmce)
  ,.rmce(rmce)
  ,.wpulse(wpulse)
  ,.ra(ra)
  ,.wa(wa)
  ,.shutoffout(shutoffout)
  ,.q(q)
`else // INTC_MEM_GLS
//lintra push -0529
   .clk(pclk)
  ,.fwen(async_reset_ix)
  ,.shutoff(shutoff_ix)
  ,.din(din_ix)
  ,.ren(ren)
  ,.wen(wen_ix)
  ,.redrowen(redrowen_ix)

  ,.adr(adr_ix)
  ,.sleep(arysleep_ix)
  ,.deepslp(pshutoff_ix)
  ,.sbc(sbc_ix)
  ,.mce(mce_ix)
  ,.stbyp(stbyp_ix)
  ,.wmce(wmce_ix)
  ,.rmce(rmce_ix)
  ,.wpulse(wpulse_ix)
  ,.ra(ra_ix)
  ,.wa(wa_ix)
  ,.shutoffout(shutoffout_i)
  ,.q(q_i)
//lintra pop
`endif // INTC_MEM_GLS
);

endmodule

//=============================================================================
// ------------------------------------------------
// Primitives
// ------------------------------------------------
`ifndef INTC_MEM_LINT
primitive ip764hduspsr1024x52m4b2s0r2p0d0_XBUF (q, data, ck, notif);
  output q;
  input data, ck, notif;
  reg q;
  table
// data  ck  notif : q : q+ ;
//                              pass data change
   (?0)   ?    ?   : ? : 0  ;
   (?1)   ?    ?   : ? : 1  ;
   (?x)   ?    ?   : ? : x  ;
//                              clear buffer X on posedge clock
     0    p    ?   : ? : 0  ;
     1    p    ?   : ? : 1  ;
     x    p    ?   : ? : x  ;
//                              ignore negedge clock
     ?    n    ?   : ? : -  ;
//                              X output on notifier toggle
     ?    ?    *   : ? : x  ;
  endtable
endprimitive
`endif // INTC_MEM_LINT

//=============================================================================

//=============================================================================
// End of Timing Wrapper (GLS)
//=============================================================================

`endcelldefine
//lintra pop


//=============================================================================
// End of File
//=============================================================================

//lintra pop


