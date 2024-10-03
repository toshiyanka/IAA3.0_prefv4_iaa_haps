/**********************************************************************************************************************\
|*                                                                                                                    *|
|*  Copyright (c) 2012 by Intel Corporation.  All rights reserved.                                                    *|
|*                                                                                                                    *|
|*  This material constitutes the confidential and proprietary information of Intel Corp and is not to be disclosed,  *|
|*  reproduced, copied, or used in any manner not permitted under license from Intel Corp.                            *|
|*                                                                                                                    *|
\**********************************************************************************************************************/

/**********************************************************************************************************************\
 * ClockDomainDriver
 * @author Jeff Wilcox
 * 
 * 
\**********************************************************************************************************************/
`timescale 1ns/1ps

module ClockDomainDriver #(
    bit     IS_IOSF = 1'b1,
    time    RST_DLY = 100ns,
    int     ACKDLY = 1,
    int     ACK2CLKOFF = 8,
    parameter ISM_AGT_IS_NS = 0
)(  
    input   logic                   pgcb_clk,
    input   logic                   pgcb_reset_b,
    output  Rtb_pkg::CdcCtlIn_t     ctl_in,
    input   Rtb_pkg::CdcCtlOut_t    ctl_out,
    //output  Rtb_pkg::CdcCfg_t       cfg,
    input   time                    tPeriod             
);
    import Rtb_pkg::*;
    logic clock, reset_b, clkreq, clkack, gclock_req_sync, force_clks_on_ack, all_pg_rst_up, fabric_run_clock;
    logic[2:0] ism_fabric, ism_agent;
    logic[Rtb_pkg::AREQ-1:0]   gclock_req_async;
    
    /******************************************************************************************************************\
     *  
     *  Clock Generation
     *  
    \******************************************************************************************************************/
    
    ClockGenerator #(
      .ACKDLY(ACKDLY), 
      .ACK2CLKOFF(ACK2CLKOFF)
    ) u_ClockGenerator(
      // Inputs
      .reset_b(reset_b),
      .clkreq(clkreq),
      .force_on(fabric_run_clock),
      .tPeriod(tPeriod),
      // Outputs
      .clkack(clkack),
      .clock(clock)
    );
    
    /******************************************************************************************************************\
     *  
     *  Control
     *  
    \******************************************************************************************************************/
    
    assign clkreq = ctl_out.clkreq;
    
    assign ctl_in.clock = clock;
    assign ctl_in.reset_b = reset_b;                       
    assign ctl_in.clkack = clkack;
    assign ctl_in.gclock_req_sync = gclock_req_sync;       
    assign ctl_in.gclock_req_async = gclock_req_async;     //TODO
    assign ctl_in.ism_fabric = ism_fabric;                 //TODO
    assign ctl_in.ism_agent = ism_agent;                   //TODO
    assign ctl_in.force_clks_on_ack = force_clks_on_ack;   //TODO
    assign ctl_in.all_pg_rst_up = all_pg_rst_up;           //TODO
    
    //Reset generation
    initial begin
        reset_b = '0;
        forever begin
            @(negedge pgcb_reset_b);
            reset_b = '0;
            @(posedge pgcb_reset_b);
            #RST_DLY;
            reset_b = '1;
        end
    end
    
    //gClock req generation
//    initial begin
//        int sdly, adly;
//        gclock_req_sync = '0;
//        forever begin
//            @(posedge reset_b);
//            fork 
//                @(negedge reset_b);
//                
//                //Sync clock req generation
//                forever begin
//                    //Wait for a random amount of time before asserting the request
//                    sdly = {$random % 2048};
//                    repeat (sdly) #tPeriod;
//                    gclock_req_sync = '1;
//                    //Wait a random amount of time after going active and then clear it
//                    while(!ctl_out.gclock_active) @(posedge clock);
//                    sdly = {$random % 256};
//                    repeat (sdly) @(posedge clock);
//                    gclock_req_sync = '0;
//                end
//            join_any
//            disable fork;
//        end
//    end
//gClock req generation
    initial begin
        int sdly, spdly;
        gclock_req_sync = '0;
        forever begin
            @(posedge reset_b);
            fork
                @(negedge reset_b);

                //ASync clock req generation
                forever begin
                    //Wait for a random amount of time before asserting the request
                    spdly = 80000;
                    sdly = {$random % 2};
                    repeat (spdly) #tPeriod;
                    gclock_req_sync = '1;
                    //Wait a random amount of time after going active and then clear it
                    while(!ctl_out.gclock_active) @(posedge clock);
                    sdly = {$random % 2};
                    repeat (sdly) #tPeriod;
                    gclock_req_sync = '0;
                end
            join_any
            disable fork;
        end
    end

    //gClock req generation
    initial begin
        int asdly, abit;
        int spdly;
        gclock_req_async[Rtb_pkg::AREQ-1:0] = '0;
        forever begin
            @(posedge reset_b);
            fork
                @(negedge reset_b);

                //ASync clock req generation
                forever begin
                    //Wait for a random amount of time before asserting the request
                    //asdly = {$random % 2048};
                    spdly = 80000;
                    asdly = {$random % 2};
                    abit  = {$random % Rtb_pkg::AREQ}; 
                    repeat (spdly) #tPeriod;
                    gclock_req_async[abit] = '1;
                    //Wait a random amount of time after going active and then clear it
                    asdly = {$random % 2};
                    //abit  = {$random % IGCLK_REQ_ASYNC};
                    repeat (asdly) #tPeriod;
                    gclock_req_async[abit] = '0;
                end
            join_any
            disable fork;
        end
    end
    
    //Fabric ISM generation
    if (IS_IOSF) begin :gen_fabric_ism
        initial begin
            int ifdly;
            fabric_run_clock = '0;
            ism_fabric = '0;
            forever begin
                @(posedge reset_b);
                fork 
                    @(negedge reset_b);
                    forever begin
                        ifdly = {$random} % 8192;
                        repeat (ifdly) #tPeriod;
                        fabric_run_clock = '1;
                        @(posedge clock); 
                        ism_fabric = #1 '1;
                        //Wait a random amount of time after going active and then clear it
                        while(!ctl_out.gclock_active) @(posedge clock);
                        fabric_run_clock = '0;
                        ifdly = {$random} % 16;
                        repeat (ifdly) @(posedge clock);
                        ism_fabric = #1 '0;
                    end
                join_any
                disable fork;
            end
        end
    end
    else begin : tieoff_fabric_ism
        assign ism_fabric = '0;
        assign fabric_run_clock = '0;
    end
    
    //Agent ISM generation
    if (IS_IOSF) begin :gen_agent_ism
        initial begin
            int ifdly;
            ism_agent = '0;
            forever begin
                @(posedge (ctl_out.greset_b && gclock_req_sync && gclock_req_async));
                fork 
                    @(negedge (ctl_out.greset_b && gclock_req_sync && gclock_req_async)) ism_agent = '0;
                    forever begin
                        @(posedge ctl_out.gclock); 
                        #1ns;
                        ism_agent = '1 & {3{(ISM_AGT_IS_NS==1 || !ctl_out.ism_locked)}};
                        //Wait a random amount of time after going active and then clear it
                        while(ctl_out.gclock_active==0);
                        @(posedge ctl_out.gclock);
                        ifdly = {$random} % 16;
                        repeat (ifdly) @(posedge ctl_out.gclock);
                        ism_agent = '0;
                    end
                join_any
                disable fork;
            end
        end
    end
    else begin : tieoff_agent_ism
        assign ism_agent = '0;
    end
    
    //TODO - temp tie offs
    //assign gclock_req_async = '0;
    assign all_pg_rst_up = '1;
    
    initial begin
        force_clks_on_ack = '0;
        forever @(ctl_out.force_clks_on) begin
            #500;
            force_clks_on_ack = ctl_out.force_clks_on;
        end
    end
    
    
    /******************************************************************************************************************\
     *  
     *  Configuration
     *  
    \******************************************************************************************************************/  
      
/*    class ClockDomainConfig;
        rand bit       cfg_clkgate_disabled;       //Don't allow idle-based clock gating
        rand bit       cfg_clkreq_ctl_disabled;    //Don't allow de-assertion of clkreq when idle
        rand bit       pwrgate_disabled;    
        rand bit [3:0] cfg_clkgate_holdoff = 4'h3;        //Min time from idle to clock gating; 2^value in clocks
        rand bit [3:0] cfg_pwrgate_holdoff = 4'h4;        //Min time from clock gate to power gate ready; 2^value in clocks
        rand bit [3:0] cfg_clkreq_off_holdoff = 4'h4;     //Min time from locking to !clkreq; 2^value in clocks
        rand bit [3:0] cfg_clkreq_syncoff_holdoff = 4'h4; //Min time from ck gate to !clkreq (powerGateDisabled)

        //bit [3:0] cfg_clkgate_holdoff = 4'h3;        //Min time from idle to clock gating; 2^value in clocks*/
        //bit [3:0] cfg_pwrgate_holdoff = 4'h4;        //Min time from clock gate to power gate ready; 2^value in clocks
        //bit [3:0] cfg_clkreq_off_holdoff = 4'h4;     //Min time from locking to !clkreq; 2^value in clocks
        //bit [3:0] cfg_clkreq_syncoff_holdoff = 4'h4; //Min time from ck gate to !clkreq (powerGateDisabled)

        
        //Sanity liits for timers
/*        constraint TimersMax {
            cfg_clkgate_disabled dist {1 :/ 10, 0 :/90};
            pwrgate_disabled dist {1 :/ 10, 0 :/90};
            cfg_clkreq_ctl_disabled dist {1 :/ 10, 0 :/90};

            (cfg_clkgate_disabled == 1'b1) -> (cfg_clkgate_holdoff <= 3);
            (pwrgate_disabled == 1'b1) -> (cfg_pwrgate_holdoff <= 4);
            (cfg_clkreq_ctl_disabled == 1'b1) -> (cfg_clkreq_off_holdoff <= 4);
            (cfg_clkreq_ctl_disabled == 1'b1) -> (cfg_clkreq_syncoff_holdoff <= 4);
        }
       
    endclass
    
    initial begin
        ClockDomainConfig cfgObj = new;
        cfg.cfg_clkgate_holdoff = 4'h3;
        cfg.cfg_pwrgate_holdoff = 4'h4;
        cfg.cfg_clkreq_off_holdoff = 4'h4;
        cfg.cfg_clkreq_syncoff_holdoff = 4'h4;
        forever begin
            cfgObj.randomize();
            cfg.cfg_clkgate_disabled       = cfgObj.cfg_clkgate_disabled;
            cfg.cfg_clkreq_ctl_disabled    = cfgObj.cfg_clkreq_ctl_disabled;
            cfg.pwrgate_disabled       = cfgObj.pwrgate_disabled;    
           
            fork
                if(cfgObj.cfg_clkgate_disabled == 1'b1) begin
                    repeat (4) @(posedge ctl_in.clock);
                    #1ps;
                    cfg.cfg_clkgate_holdoff        = cfgObj.cfg_clkgate_holdoff;
                end
                
                if(cfgObj.pwrgate_disabled == 1'b1) begin
                    repeat (4) @(posedge ctl_in.clock);
                    #1ps;
                    cfg.cfg_pwrgate_holdoff        = cfgObj.cfg_pwrgate_holdoff;
                end

                if(cfgObj.cfg_clkreq_ctl_disabled == 1'b1) begin
                    repeat (4) @(posedge ctl_in.clock);
                    #1ps;
                    cfg.cfg_clkreq_off_holdoff     = cfgObj.cfg_clkreq_off_holdoff;
                    cfg.cfg_clkreq_syncoff_holdoff = cfgObj.cfg_clkreq_syncoff_holdoff;
                end 
            join

            @(posedge ctl_in.clock); 
            @(posedge ctl_in.clock); 
            @(posedge ctl_in.clock); 
        end
    end
*/    

endmodule
