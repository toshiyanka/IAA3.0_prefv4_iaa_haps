/**********************************************************************************************************************\
|*                                                                                                                    *|
|*  Copyright (c) 2012 by Intel Corporation.  All rights reserved.                                                    *|
|*                                                                                                                    *|
|*  This material constitutes the confidential and proprietary information of Intel Corp and is not to be disclosed,  *|
|*  reproduced, copied, or used in any manner not permitted under license from Intel Corp.                            *|
|*                                                                                                                    *|
\**********************************************************************************************************************/

/**********************************************************************************************************************\
 * PgdTestbench
 * @author Jeff Wilcox
 * 
 * 
\**********************************************************************************************************************/
`timescale 1ns/1ns

module PgdTestbench #(
    DEF_PWRON = 1,                                  //Default to a powered-on state after reset
    ICDC=2,                                         //Number of CDCs that control IOSF domains
    NCDC=2                                          //Number of CDCs that control non-IOSF domains
)(
	
    
);
    import Rtb_pkg::*;

    logic early_reset_b, pgcb_raw_rst_b, pok_reset_b;
    logic pgcb_clkreq, pgcb_clkack; 

//IOSF CDC Clocks, Resets and Controls
    CdcCtlIn_t[ICDC-1:0]   ictl_in;
    CdcCtlOut_t[ICDC-1:0]  ictl_out;
    
//Non-IOSF CDC Clocks, Resets and Controls
    CdcCtlIn_t[NCDC-1:0]   nctl_in;
    CdcCtlOut_t[NCDC-1:0]  nctl_out;
    
//PGCB Config and Control
    PgcbCfg_t              pcfg;
    PgdCtlIn_t             pctl_in;
    PgdCtlOut_t            pctl_out;

//CDC Config Control
    CdcCfg_t               cfg;
        
    initial begin
        early_reset_b = '0;
        pgcb_raw_rst_b = '0;
        pok_reset_b = '0;
        #10ns;
        early_reset_b = '1;
        #95ns;
        pgcb_raw_rst_b = '1;
        pok_reset_b = '1;
    end

    ClockGenerator #(
      .ACKDLY(1), 
      .ACK2CLKOFF(8)
    ) u_PgcbClockGenerator(
      // Inputs
      .reset_b(early_reset_b),
      .clkreq(pgcb_clkreq),
      .force_on('0),
      // Outputs
      .clkack(pgcb_clkack),        
      .clock(pgcb_clk),
      .tPeriod(100ns)
    );

//amshah2 - Separating out the Config block for CDC
//Everything within Config block with a general broadcast for CDC's
    ClockDomainConfig #(
    ) u_ClockDomainConfig(
      // Inputs
      //Moving the value of the tPeriod from 30ns to 100ns 
      //Matching the PGCB clock to resolve PWV
      .tPeriod(30ns),
      // Output Config Block
      .cfg(cfg)
    );    
        
    PowerDomainControl #(
      .DEF_PWRON(DEF_PWRON), 
      .ICDC(ICDC), 
      .NCDC(NCDC)
    ) u_PowerDomainControl(
      // Inputs
      .pgcb_clk(pgcb_clk),
      .pgcb_raw_rst_b(pgcb_raw_rst_b),
      .pok_reset_b(pok_reset_b),
      .pgcb_clkreq(pgcb_clkreq),
      .pgcb_clkack(pgcb_clkack),
      .ictl_in(ictl_in),
      .nctl_in(nctl_in),
      .pcfg(pcfg),
      .pctl_in(pctl_in),
      // Outputs
      .ictl_out(ictl_out),
      .nctl_out(nctl_out),
      .pctl_out(pctl_out),
      // Input Config Block
      .cfg(cfg) 
    );

    for(genvar i = 0; i < ICDC; i++) begin
        ClockDomainDriver #(
          .IS_IOSF(1'b1), 
          .RST_DLY(100ns), 
          .ACKDLY(1), 
          .ACK2CLKOFF(8)
        ) u_ClockDomainDriver(
          // Inputs
          .pgcb_clk(pgcb_clk),
          .pgcb_reset_b(pgcb_raw_rst_b),
          .ctl_out(ictl_out[i]),
          .tPeriod(6ns * (i+1)), 
          // Outputs
          .ctl_in(ictl_in[i])
        );
    end
    
    for(genvar n = 0; n < NCDC; n++) begin
        ClockDomainDriver #(
          .IS_IOSF(1'b0), 
          .RST_DLY(100ns), 
          .ACKDLY(1), 
          .ACK2CLKOFF(8)
        ) u_ClockDomainDriver(
          // Inputs
          .pgcb_clk(pgcb_clk),
          .pgcb_reset_b(pgcb_raw_rst_b),
          .ctl_out(nctl_out[n]),
          .tPeriod(5ns * (n+1)), 
          // Outputs
          .ctl_in(nctl_in[n])
        );
    end
    
    PowerDomainDriver #(
      .DEF_PWRON(DEF_PWRON)
    ) u_PowerDomainDriver(
      // Inputs
      .pgcb_clk(pgcb_clk),
      .pctl_out(pctl_out),
      .pgcb_clkreq(pgcb_clkreq),
      //.pgcb_clkack(pgcb_clkack),
      // Outputs
      .pcfg(pcfg),
      .pctl_in(pctl_in)
    );


//BRINGING OUT SPY SIGNALS FOR THE TRACKERS
    logic[ICDC-1:0][3:0]  cdc_cs;
    logic[NCDC-1:0][3:0]  ncdc_cs;
 
    for (genvar i = 0; i < ICDC; i++) begin : TRCK_A
        //assign cdc_cs[i][3:0]  = RandTestbench.u_PgdTbDefPowerOn.u_PowerDomainControl.IosfCdc[i].u_IosfCdc.current_state[3:0];
        assign cdc_cs[i][3:0]  = '0;
    end
    for (genvar j = 0; j < NCDC; j++) begin : TRCK_B
        //assign ncdc_cs[j][3:0] = RandTestbench.u_PgdTbDefPowerOn.u_PowerDomainControl.NonIosfCdc[j].u_NonIosfCdc.current_state[3:0];     
        assign ncdc_cs[j][3:0] = '0;
    end
    
    Tracker #(    
              .DEF_PWRON(DEF_PWRON) ,                                  
              .ICDC(ICDC),                                         
              .NCDC(NCDC)
    ) u_Tracker (
      .early_reset_b(early_reset_b),
      .cdc_cs(cdc_cs[ICDC-1:0]),
      .ncdc_cs(ncdc_cs[NCDC-1:0]),
      .pgcb_clk(pgcb_clk),
      .ictl_in(ictl_in),
      .ictl_out(ictl_out),
      .nctl_in(nctl_in),
      .nctl_out(nctl_out),
      .cfg(cfg),
      .pcfg(pcfg),
      .pctl_in(pctl_in),
      .pctl_out(pctl_out)
        );               
                                          
endmodule
