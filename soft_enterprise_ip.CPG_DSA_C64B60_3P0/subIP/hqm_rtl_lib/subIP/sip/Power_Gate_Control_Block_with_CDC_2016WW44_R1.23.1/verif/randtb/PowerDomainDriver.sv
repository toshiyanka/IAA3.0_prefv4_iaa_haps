/**********************************************************************************************************************\
|*                                                                                                                    *|
|*  Copyright (c) 2012 by Intel Corporation.  All rights reserved.                                                    *|
|*                                                                                                                    *|
|*  This material constitutes the confidential and proprietary information of Intel Corp and is not to be disclosed,  *|
|*  reproduced, copied, or used in any manner not permitted under license from Intel Corp.                            *|
|*                                                                                                                    *|
\**********************************************************************************************************************/

/**********************************************************************************************************************\
 * PowerDomainDriver
 * @author Jeff Wilcox
 * 
 * 
\**********************************************************************************************************************/
`timescale 1ns/1ns

module PowerDomainDriver #(
    DEF_PWRON = 1
)(
    input   logic                           pgcb_clk,
    input   logic                           pgcb_clkreq,
    //output  logic                           pgcb_clkack,
    output  Rtb_pkg::PgcbCfg_t              pcfg,
    output  Rtb_pkg::PgdCtlIn_t             pctl_in,
    input   Rtb_pkg::PgdCtlOut_t            pctl_out
);

    /******************************************************************************************************************\
     *  
     *  Control
     *  
    \******************************************************************************************************************/
    
    logic   pmc_ip_pg_ack_b, pmc_ip_restore_b, pmc_ip_wake, pg_disable, force_warm_reset;
    logic   force_ip_inaccessible;
    logic   fdfx_pgcb_bypass, fdfx_pgcb_ovr, fscan_isol_ctrl, fscan_isol_lat_ctrl, fscan_ret_ctrl, fscan_mode, fdfx_powergood_rst_b;
    
    assign pctl_in.pmc_ip_pg_ack_b = pmc_ip_pg_ack_b;
    assign pctl_in.pmc_ip_restore_b = pmc_ip_restore_b;
    assign pctl_in.pmc_ip_wake = pmc_ip_wake; 
    assign pctl_in.pg_disable = pg_disable;
    assign pctl_in.force_warm_reset=force_warm_reset;
    assign pctl_in.force_ip_inaccessible = force_ip_inaccessible;
    assign pctl_in.fdfx_pgcb_bypass = fdfx_pgcb_bypass;
    assign pctl_in.fdfx_pgcb_ovr = fdfx_pgcb_ovr;
    assign pctl_in.fscan_isol_ctrl = fscan_isol_ctrl;
    assign pctl_in.fscan_isol_lat_ctrl = fscan_isol_lat_ctrl;
    assign pctl_in.fscan_ret_ctrl = fscan_ret_ctrl;
    assign pctl_in.fscan_mode = fscan_mode;
    assign pctl_in.fdfx_powergood_rst_b = fdfx_powergood_rst_b;

    initial begin
     fdfx_powergood_rst_b = '0;
     #100ns;
     fdfx_powergood_rst_b = '1;
    end
     
    
    initial begin
        int delay;
        pg_disable = '0;
        forever begin
            delay = {$random()} % 1024;
            repeat(delay) @(posedge pgcb_clk);
            pg_disable++;
        end
    end

    //DFX overrides - assign fdfx_powergood_rst_b
    initial begin
      int delay;
      fdfx_pgcb_bypass    = '0;
      fdfx_pgcb_ovr       = '0;
      fscan_isol_ctrl     = '0;
      fscan_isol_lat_ctrl = '0;
      fscan_ret_ctrl      = '0;
      fscan_mode          = '0;
    if ($test$plusargs("dfx_en")) begin
      @(posedge pctl_in.fdfx_powergood_rst_b);
      forever begin
         #200us;
         fdfx_pgcb_bypass    = '1;
         repeat(3) @(posedge pgcb_clk);
         fdfx_pgcb_ovr       = '1;  //forced off
         repeat (2) @(posedge pgcb_clk);
         fscan_isol_lat_ctrl = '1;
         fscan_ret_ctrl      = '1;
         @(posedge pgcb_clk);
         fscan_mode          = '1;
         fscan_isol_ctrl     = '1;
         repeat (50) @(posedge pgcb_clk);
         fdfx_pgcb_ovr       = '0; //forced on

         repeat (20) @(posedge pgcb_clk);
         fdfx_pgcb_bypass    = '0;
         repeat (20) @(posedge pgcb_clk);
         fscan_isol_lat_ctrl = '0;
         fscan_ret_ctrl      = '0;
         fscan_mode          = '0;
         fscan_isol_ctrl     = '0;
     end
    end
  end

             
       
        
         

    //initial begin
    //    int delay;
    //    pgcb_clkack = '0;
    //    forever begin
    //        do #1us;
    //        while (pgcb_clkreq);
    //        #1ns;
    //        pgcb_clkack = '1; 
    //    end
    //end
 
    initial begin
        int delay;
        pmc_ip_pg_ack_b = DEF_PWRON;
        pmc_ip_restore_b = '1;
        //Initial power up if not defaulting to power on
        if (!DEF_PWRON) begin
            do #1us;
            while (!pctl_out.pgcb_pmc_pg_req_b);
            #500ns;
            pmc_ip_pg_ack_b = '1;
        end
        forever begin
            //Wait until a power down request happens
            do #1us;
            while (pctl_out.pgcb_pmc_pg_req_b);
            #500ns;
            pmc_ip_pg_ack_b = '0;
            
            //Wait until a power up request happens
            do #1us;
            while (!pctl_out.pgcb_pmc_pg_req_b);
            pmc_ip_restore_b = pctl_out.all_poks_deasserted ? {$random} %2 : '1;
            #500ns;
            pmc_ip_pg_ack_b = '1;
           
            if (!pmc_ip_restore_b) begin
                do @(posedge pgcb_clk);
                while (!pctl_out.pgcb_restore);
                fork
                    begin
                        do @(posedge pgcb_clk);
                        while (!pctl_out.all_isms_unlocked);
                    end
                    begin
                        #10us;
                        restoreTimeout: assert (1'b0);
                    end
                join_any
                disable fork;
                delay = {$random} % 16;
                repeat(delay) @(posedge pgcb_clk);
                pmc_ip_restore_b = '1;
            end
        end
    end
    
    initial begin
        int delay;
	int rand_time_reset_entry;
	int rand_time_ip_inaccess_entry;
	longint rand_time_wake;
        pmc_ip_wake = '0;
        force_warm_reset = '0;
        force_ip_inaccessible = '0;
        #2us;
        //Wait until the power domain is up and then drop the wake request some time after
        if (pctl_out.pgcb_pwrgate_active) begin
            pmc_ip_wake = '1;
            @(negedge pctl_out.pgcb_pwrgate_active);
            #200ns;
	     pmc_ip_wake = '0;
        end
        forever begin
            //Wait a bit of time then do warm reset entry and exit
	    //[Aparna] Added ranom delay
	     // std::randomize(rand_time_reset_entry) with {rand_time_reset_entry <700000 && rand_time_reset_entry > 50000;}; 
	     //May be add 50us-700us.
	     //#rand_time_reset_entry; 
	     #200us;
            @(posedge pgcb_clk);
            //wake up the domain
            pmc_ip_wake = '1;
            do @(posedge pgcb_clk);
            while (pctl_out.pgcb_pwrgate_active );
            //Assert the warm reset and clear the wake
            @(posedge pgcb_clk);
            pmc_ip_wake = '0;
            @(posedge pgcb_clk);
            @(posedge pgcb_clk);
            @(posedge pgcb_clk);
            force_warm_reset = '1;
            do @(posedge pgcb_clk);
            while (!pctl_out.all_poks_deasserted);
            force_warm_reset = '0;
	    //Aparna to do add random delay
	     std::randomize(rand_time_wake) with {rand_time_wake <100000 && rand_time_wake >50000 ;}; 
	     $display("rand_time_value is %d",rand_time_wake);
	    #rand_time_wake;
            //#10us;
            pmc_ip_wake = '1;
            do @(posedge pgcb_clk);
            while (pctl_out.pgcb_pwrgate_active);
            #200ns;
            pmc_ip_wake = '0;
            
            //Wait a bit of time then do IP-INACC entry
	    //[Aparna] Added ranom delay
	      //std::randomize(rand_time_ip_inaccess_entry) with {rand_time_ip_inaccess_entry <700000 && rand_time_ip_inaccess_entry > 50000;}; 
	     //#rand_time_ip_inaccess_entry;		
		#200us;
            @(posedge pgcb_clk);
            //wake up the domain
            pmc_ip_wake = '1;
            do @(posedge pgcb_clk);
            while (pctl_out.pgcb_pwrgate_active);
            @(posedge pgcb_clk);
            pmc_ip_wake = '0;
            @(posedge pgcb_clk);
            @(posedge pgcb_clk);
            @(posedge pgcb_clk);
            //Assert the ip-inacc and clear the wake
            force_ip_inaccessible = '1;
            do @(posedge pgcb_clk);
            while (!pctl_out.all_poks_deasserted);
            force_ip_inaccessible = '0;
	    //Aparna to do add random delay
	    //assert( std::randomize(rand_time_wake) with {rand_time_wake <10000000 && rand_time_wake >10000000 ;} )
	    #rand_time_wake;
            //#10us;
            pmc_ip_wake = '1;
            do @(posedge pgcb_clk);
            while (pctl_out.pgcb_pwrgate_active);
            #200ns;
            pmc_ip_wake = '0;

	  /*  #200us;
            @(posedge pgcb_clk);
            //wake up the domain
            pmc_ip_wake = '1;
	    @(posedge pctl_out.pgcb_pwrgate_active)
	    	#10us;	
            //Assert the warm reset and clear the wake
            force_warm_reset = '1;
            pmc_ip_wake = '0;
            do @(posedge pgcb_clk);
            while (!pctl_out.all_poks_deasserted);
            force_warm_reset = '0;
	    //Aparna to do add random delay
	     std::randomize(rand_time_wake) with {rand_time_wake <100000 && rand_time_wake >50000 ;}; 
	     $display("rand_time_value is %d",rand_time_wake);
	    #rand_time_wake;
            //#10us;
            pmc_ip_wake = '1;
            do @(posedge pgcb_clk);
            while (pctl_out.pgcb_pwrgate_active);
            #200ns;
            pmc_ip_wake = '0;*/

	
        end
        
    end
    
    /******************************************************************************************************************\
     *  
     *  Configuration
     *  
    \******************************************************************************************************************/
    logic reconfigOk;
    
    class PowerDomainConfig;
        rand bit [1:0] cfg_tsleepinactiv;
        rand bit [1:0] cfg_tdeisolate;
        rand bit [1:0] cfg_tpokup;
        rand bit [1:0] cfg_tinaccrstup;
        rand bit [1:0] cfg_taccrstup;
        rand bit [1:0] cfg_tlatchen;
        rand bit [1:0] cfg_tpokdown;
        rand bit [1:0] cfg_tlatchdis;
        rand bit [1:0] cfg_tsleepact;
        rand bit [1:0] cfg_tisolate;
        rand bit [1:0] cfg_trstdown;
        rand bit [1:0] cfg_tclksonack_srst;
        rand bit [1:0] cfg_tclksoffack_srst;
        rand bit [1:0] cfg_tclksonack_cp;
        rand bit [1:0] cfg_trstup2frcclks;
        rand bit [1:0] cfg_trsvd0;
        rand bit [1:0] cfg_trsvd1;
        rand bit       ip_pgcb_frc_clk_srst_en;
        rand bit       ip_pgcb_frc_clk_cp_en;
    endclass
    
    assign reconfigOk = ~pctl_out.pgcb_pwrgate_active && pctl_out.pgcb_idle;
    
    initial begin
        PowerDomainConfig cfg = new;
        forever begin
            cfg.randomize();
            pcfg.cfg_tsleepinactiv = cfg.cfg_tsleepinactiv;
            pcfg.cfg_tdeisolate = cfg.cfg_tdeisolate;
            pcfg.cfg_tpokup = cfg.cfg_tpokup;
            pcfg.cfg_tinaccrstup = cfg.cfg_tinaccrstup;
            pcfg.cfg_taccrstup = cfg.cfg_taccrstup;
            pcfg.cfg_tlatchen = cfg.cfg_tlatchen;
            pcfg.cfg_tpokdown = cfg.cfg_tpokdown;
            pcfg.cfg_tlatchdis = cfg.cfg_tlatchdis;
            pcfg.cfg_tsleepact = cfg.cfg_tsleepact;
            pcfg.cfg_tisolate = cfg.cfg_tisolate;
            pcfg.cfg_trstdown = cfg.cfg_trstdown;
            pcfg.cfg_tclksonack_srst = cfg.cfg_tclksonack_srst;
            pcfg.cfg_tclksoffack_srst = cfg.cfg_tclksoffack_srst;
            pcfg.cfg_tclksonack_cp = cfg.cfg_tclksonack_cp;
            pcfg.cfg_trstup2frcclks = cfg.cfg_trstup2frcclks;
            pcfg.cfg_trsvd0 = cfg.cfg_trsvd0;
            pcfg.cfg_trsvd1 = cfg.cfg_trsvd1;
            pcfg.ip_pgcb_frc_clk_srst_en = cfg.ip_pgcb_frc_clk_srst_en;
            pcfg.ip_pgcb_frc_clk_cp_en = cfg.ip_pgcb_frc_clk_cp_en;
            //Wait until reconfig ok goes away
            do @(posedge pgcb_clk);
            while (reconfigOk);
            //Wait until its ok to update
            do @(posedge pgcb_clk);
            while (!reconfigOk);
        end
    end
    
endmodule
