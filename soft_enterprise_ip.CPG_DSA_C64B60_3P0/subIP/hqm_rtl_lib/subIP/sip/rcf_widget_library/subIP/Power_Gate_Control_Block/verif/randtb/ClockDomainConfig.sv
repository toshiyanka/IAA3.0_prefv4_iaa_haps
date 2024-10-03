//`timescale 1ns/1ps

module ClockDomainConfig #(
        )(
    input   time                 tPeriod,
    output  Rtb_pkg::CdcCfg_t    cfg
    ); 


    class ClockDomainConfig;
        rand bit       cfg_clkgate_disabled;              //Don't allow idle-based clock gating
        rand bit       cfg_clkreq_ctl_disabled;           //Don't allow de-assertion of clkreq when idle
        rand bit       pwrgate_disabled;
        rand bit [3:0] cfg_clkgate_holdoff = 4'h3;        //Min time from idle to clock gating; 2^value in clocks
        rand bit [3:0] cfg_pwrgate_holdoff = 4'h4;        //Min time from clock gate to power gate ready; 2^value in clocks
        rand bit [3:0] cfg_clkreq_off_holdoff = 4'h4;     //Min time from locking to !clkreq; 2^value in clocks
        rand bit [3:0] cfg_clkreq_syncoff_holdoff = 4'h4; //Min time from ck gate to !clkreq (powerGateDisabled)

        //Sanity limits for timers
        constraint TimersMax {
            cfg_clkgate_disabled dist {1 :/10, 0 :/90};
            pwrgate_disabled dist {1 :/10, 0 :/90};
            cfg_clkreq_ctl_disabled dist {1 :/10, 0 :/90};

            (cfg_clkgate_disabled == 1'b1) -> (cfg_clkgate_holdoff <= 3);
            (pwrgate_disabled == 1'b1) -> (cfg_pwrgate_holdoff <= 4);
            (cfg_clkreq_ctl_disabled == 1'b1) -> (cfg_clkreq_off_holdoff <= 4);
            (cfg_clkreq_ctl_disabled == 1'b1) -> (cfg_clkreq_syncoff_holdoff <= 4);
        }

    endclass

//tPeriod should be the assumed time period of the slowest clock 
// 6ns * (Max. No. of CDC) 
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
                    repeat (16) #tPeriod;
                    #1ps;
                    cfg.cfg_clkgate_holdoff        = cfgObj.cfg_clkgate_holdoff;
                end

                if(cfgObj.pwrgate_disabled == 1'b1) begin
                    repeat (16) #tPeriod ;
                    #1ps;
                    cfg.cfg_pwrgate_holdoff        = cfgObj.cfg_pwrgate_holdoff;
                end

                if(cfgObj.cfg_clkreq_ctl_disabled == 1'b1) begin
                    repeat (16) #tPeriod;
                    #1ps;
                    cfg.cfg_clkreq_off_holdoff     = cfgObj.cfg_clkreq_off_holdoff;
                    cfg.cfg_clkreq_syncoff_holdoff = cfgObj.cfg_clkreq_syncoff_holdoff;
                end
            join

            repeat (128) #tPeriod;
            //#tPeriod;
            //#tPeriod;

        end
    end


endmodule
