`ifndef HQM_RESET_MONITOR__SV
`define HQM_RESET_MONITOR__SV

class hqm_reset_monitor extends  ovm_monitor;

    int                   got_fuse_pull;
    int                   got_ip_ready;
    bit                   hqm_non_std_warm_rst_seq = $test$plusargs("HQM_NON_STD_WARM_RST_SEQ");
    bit                   deassert_prim_rst_b      = $test$plusargs("HQM_TB_DEASSERT_PRIM_RST_B");
    bit                   ignore_due_to_sideband_reset;
    bit                   default_strap_no_mgmt_acks;
    bit                   default_ip_ready;
    bit                   default_clk_checks;
    protected bit         disable_pok_chk = 0;
    int boot_seq_ctrl;

    virtual hqm_reset_if  reset_if;

    ovm_event_pool        global_pool;
    ovm_event             hqm_ip_ready;
    ovm_event             hqm_config_acks;
    ovm_event             hqm_fuse_download_req;
    ovm_event             hqm_prim_rst_assert;
    ovm_event             hqm_side_rst_assert;
    ovm_event             hqm_prim_pok_assert;
    ovm_event             hqm_side_pok_assert;
    ovm_event             hqm_prim_pok_deassert;
    ovm_event             hqm_side_pok_deassert;
    ovm_event             hqm_waive_pok_check;
    ovm_event             hqm_re_enable_pok_check;

    `ovm_component_utils_begin(hqm_reset_monitor)
    `ovm_component_utils_end
    
    extern                   function                new(string name = "hqm_reset_monitor", ovm_component parent = null);
    extern virtual           function void           build();
    extern virtual           function void           end_of_elaboration();
    extern virtual           task                    run();
    extern virtual           task                    check_default();
    extern virtual           task                    clkreq_check(logic value, string check_type = "all");
    extern virtual           task                    prim_clkreq_check(logic value, string check_type = "all");
    extern virtual           task                    side_clkreq_check(logic value, string check_type = "all");
    extern virtual           task                    pok_check(logic value, string check_type = "all");
    extern virtual           task                    prim_pok_check(logic value, string check_type = "all");
    extern virtual           task                    side_pok_check(logic value, string check_type = "all");
    extern virtual           task                    fuse_ip_ready_check(int exp_value);
    extern virtual           task                    boot_flow_check();
    extern virtual           task                    reset_entry_flow_check();
    extern virtual           task                    waive_pok_chk();
    extern virtual           task                    re_enable_pok_chk();
    extern virtual           task                    checks_on_prim_rst_assert();
    extern virtual           task                    checks_on_prim_rst_deassert();
    extern virtual           task                    checks_on_side_rst_assert();
    extern virtual           task                    checks_on_side_rst_deassert();
    extern virtual           task                    checks_on_prim_pok_deassert();
    extern virtual           task                    checks_on_prim_pok_assert();
    extern virtual           task                    checks_on_side_pok_deassert();
    extern virtual           task                    checks_on_side_pok_assert();
    extern virtual           task                    checks_on_ip_ready_event();
    extern virtual           task                    checks_on_fuse_pull_event();
    extern virtual           task                    checks_on_prim_side_clkack_low();
    extern virtual           task                    checks_on_prim_clkack_low();
    extern virtual           task                    checks_on_side_clkack_low();
    extern virtual           task                    checks_on_prim_side_clkack_high();
    extern virtual           task                    checks_on_prim_clkack_high();
    extern virtual           task                    checks_on_side_clkack_high();
    extern virtual           task                    checks_on_pwrgood_rst_assert();
    extern virtual           task                    checks_on_pwrgood_rst_deassert();
    extern virtual           task                    cold_reset_entry_flow_check();
    extern virtual           task                    checks_on_config_ack(); 
    extern virtual           task                    checks_on_reset_prep_ack();

endclass:hqm_reset_monitor

//.............
function hqm_reset_monitor::new (string name = "hqm_reset_monitor", ovm_component parent = null);
    super.new(name, parent);
    global_pool  = ovm_event_pool::get_global_pool();
    hqm_ip_ready = global_pool.get("hqm_ip_ready");
    hqm_config_acks = global_pool.get("hqm_config_acks");
    hqm_fuse_download_req = global_pool.get("hqm_fuse_download_req");
    hqm_prim_rst_assert   = global_pool.get("hqm_prim_rst_assert");
    hqm_side_rst_assert   = global_pool.get("hqm_side_rst_assert");
    hqm_prim_pok_assert   = global_pool.get("hqm_prim_pok_assert");
    hqm_side_pok_assert   = global_pool.get("hqm_side_pok_assert");
    hqm_prim_pok_deassert = global_pool.get("hqm_prim_pok_deassert");
    hqm_side_pok_deassert = global_pool.get("hqm_side_pok_deassert");
    hqm_waive_pok_check   = global_pool.get("hqm_waive_pok_check");
    hqm_re_enable_pok_check = global_pool.get("hqm_re_enable_pok_check");

    ignore_due_to_sideband_reset = $test$plusargs("IGNORE_DUE_TO_SIDEBAND_RESET");
    default_strap_no_mgmt_acks = 0;
    $value$plusargs("HQM_STRAP_NO_MGMT_ACKS=%d", default_strap_no_mgmt_acks);

    //--AY after fuse puller removal, default_ip_ready = 1 always, there is no fp/sb path in HQMV25
    default_ip_ready = 1;
    $value$plusargs("HQM_USE_IP_READY=%d", default_ip_ready);

    default_clk_checks=0;
    $value$plusargs("HQM_CLK_CHECKS=%d", default_clk_checks);

    //-- when +HQM_BOOT_CTRL=2: issue prim_rst_b deassert first, issue side_rst_b later
    boot_seq_ctrl  = 0;
    $value$plusargs("HQM_BOOT_CTRL=%0d",  boot_seq_ctrl);

    got_fuse_pull = 0;
    got_ip_ready  = 0;
endfunction:new

//.............
function void hqm_reset_monitor::build();
    super.build();
endfunction:build

//.............
function void hqm_reset_monitor::end_of_elaboration();
  string reset_if_name;

  super.end_of_elaboration();
  if (!get_config_string("reset_if_handle",reset_if_name)) begin 
    `ovm_fatal(get_full_name(), "Unable to find reset_if_handle config string ");
  end

  `sla_get_db(reset_if,virtual hqm_reset_if, reset_if_name);
  assert(reset_if) `ovm_info(get_full_name(), "hqm_reset_if has been obtained", OVM_LOW) else
                   `ovm_error(get_full_name(), "Couldn't get hqm_reset_if")

endfunction:end_of_elaboration

// check for stable default values on all driver signals
task hqm_reset_monitor::check_default();
 wait(reset_if.powergood_rst_b == 0);
 wait(reset_if.side_rst_b == 0);
 wait(reset_if.prim_rst_b == 0);
 // wait(reset_if.prim_clkack == 0);
 // wait(reset_if.side_clkack == 0);
 wait(reset_if.prim_pok == 0);
 wait(reset_if.side_pok == 0);
endtask:check_default

//.............
task hqm_reset_monitor::run();

  `ovm_info(get_full_name(), "reset_checks: Start", OVM_LOW)
  check_default();
  fork
    // checks on powergood_rst deassert
    forever begin
      checks_on_pwrgood_rst_deassert();
    end
   
    // checks on powergood_rst assert
    forever begin
      checks_on_pwrgood_rst_assert();
    end
   
/*
    // checks on prim clkack high
    forever begin
      checks_on_prim_clkack_high();
      wait(reset_if.prim_clkack==0) ;
    end
   
    // checks on side clkack high
    forever begin
      checks_on_side_clkack_high();
      wait (reset_if.side_clkack==0) ;
    end
   
    // checks on prim clkack low
    forever begin
      checks_on_prim_clkack_low();
      wait (reset_if.prim_clkack==1) ;
    end

    // checks on side clkack low
    forever begin
      checks_on_side_clkack_low();
      wait (reset_if.side_clkack==1) ;
    end
*/

    // checks after fuse pull 
    forever begin
      checks_on_fuse_pull_event();
    end
    
    // checks after ip_ready
    forever begin
      checks_on_ip_ready_event();
    end
   
    // checks after side_pok assert
    forever begin
      checks_on_side_pok_assert();
    end
   
    // checks after side_pok deassert
    forever begin
      checks_on_side_pok_deassert();
    end
   
    // checks after prim_pok assert
    forever begin
      checks_on_prim_pok_assert();
    end
   
    // checks after prim_pok deassert
    forever begin
      checks_on_prim_pok_deassert();
    end
   
    // checks after side_rst deassert
    forever begin
      checks_on_side_rst_deassert();
    end
   
    // checks after side_rst assert
    forever begin
      checks_on_side_rst_assert();
    end
   
    // checks after prim_rst deassert
    forever begin
      checks_on_prim_rst_deassert();
    end
   
    // checks after prim_rst assert
    forever begin
      checks_on_prim_rst_assert();
    end

    // Boot flow check
    forever begin
      boot_flow_check();
    end

    // Reset Entry flow check
    forever begin
      reset_entry_flow_check();
    end

    // Waive pok related checks due to illegal ForcePok msg sent to HQM    
    forever begin
      waive_pok_chk();
    end
 
    // Re-enable pok related checks due to illegal ForcePok msg sent to HQM    
    forever begin
      re_enable_pok_chk();
    end
   
    if (default_strap_no_mgmt_acks) begin
    forever begin
      checks_on_config_ack();
    end
    end
   
    if (default_strap_no_mgmt_acks) begin
    forever begin
      checks_on_reset_prep_ack();
    end
    end
   
  join_none
endtask:run
 
task hqm_reset_monitor::waive_pok_chk();
  hqm_waive_pok_check.wait_trigger();
  `ovm_info(get_full_name(), "Received trigger to waive_pok_chk", OVM_LOW)
  disable_pok_chk=1;
endtask
 
task hqm_reset_monitor::re_enable_pok_chk();
  hqm_re_enable_pok_check.wait_trigger();
  `ovm_info(get_full_name(), "Received trigger to re_enable_pok_chk", OVM_LOW)
  disable_pok_chk=0;
endtask

task hqm_reset_monitor::boot_flow_check();
  checks_on_pwrgood_rst_deassert();
  checks_on_prim_side_clkack_high();
  checks_on_side_rst_deassert();
  fork 
    checks_on_side_pok_assert();
    checks_on_prim_pok_assert();
  join
  checks_on_fuse_pull_event();
  checks_on_ip_ready_event();
  checks_on_prim_rst_deassert();
  `ovm_info(get_full_name(), "Boot Flow Sequence checking done", OVM_LOW)
endtask

task hqm_reset_monitor::reset_entry_flow_check();
  fork 
    checks_on_side_pok_deassert();
    checks_on_prim_pok_deassert();
  join
  checks_on_prim_side_clkack_low();
  checks_on_prim_rst_deassert();
  checks_on_side_rst_deassert();
  `ovm_info(get_full_name(), "Reset Entry Flow Sequence checking done", OVM_LOW)
endtask

task hqm_reset_monitor::cold_reset_entry_flow_check();
  fork 
    checks_on_side_pok_deassert();
    checks_on_prim_pok_deassert();
  join
  checks_on_prim_side_clkack_low();
  checks_on_prim_rst_deassert();
  checks_on_side_rst_deassert();
  checks_on_pwrgood_rst_assert();
  `ovm_info(get_full_name(), "Cold Reset Entry Flow Sequence checking done", OVM_LOW)
endtask

task hqm_reset_monitor::checks_on_prim_rst_assert();
      @(negedge reset_if.prim_rst_b);
      hqm_prim_rst_assert.trigger();
      @(posedge reset_if.clk);
      if(!disable_pok_chk)  prim_pok_check(!`HQM_PRIM_DEASSERT_CLK_SIGS_DEFAULT, "prim_rst is asserted"); else `ovm_info(get_full_name(), $psprintf("prim_pok_check skip as disable_pok_chk(0x%0x)",disable_pok_chk), OVM_LOW)
      fuse_ip_ready_check(1);
endtask

task hqm_reset_monitor::checks_on_prim_rst_deassert();
  @(posedge reset_if.prim_rst_b);
  @(posedge reset_if.clk);
  fuse_ip_ready_check(1);
  prim_clkreq_check(1'b0, "prim_rst is deasserted");
  prim_pok_check   (1'b0, "prim_rst is deasserted");
  repeat (60) @(posedge reset_if.clk);
  //-- 01072020: Bill reviewed reset sanity checks, and suggested to eliminate all checks that specify clocks. "Since these  checks are not defined by any architectural spec- they should be eliminated."
  ////--AY_01032020_TOBEREVIEWED  prim_clkreq_check(1'b1, "60 clocks after prim_rst is deasserted");
  prim_pok_check   (1'b1, "60 clocks after prim_rst is deasserted");
endtask

task hqm_reset_monitor::checks_on_side_rst_assert();
  @(negedge reset_if.side_rst_b);
  hqm_side_rst_assert.trigger();
  @(posedge reset_if.clk);
  side_pok_check   (!`HQM_SB_DEASSERT_CLK_SIGS_DEFAULT, "side_rst is asserted");
  prim_pok_check   (!`HQM_PRIM_DEASSERT_CLK_SIGS_DEFAULT, "side_rst is asserted");
  got_fuse_pull = 0;
  got_ip_ready  = 0;

endtask


task hqm_reset_monitor::checks_on_side_rst_deassert();
/*--
  @(posedge reset_if.side_rst_b);
  @(posedge reset_if.clk);
  side_pok_check   (1'b0, "side_rst is deasserted");
  prim_pok_check   (1'b0, "side_rst is deasserted");
  side_clkreq_check(1'b0, "side_rst is deasserted");
  prim_clkreq_check(1'b0, "side_rst is deasserted");
  fuse_ip_ready_check(0);
  repeat (60) @(posedge reset_if.clk);
  if(default_clk_checks) begin
    prim_pok_check   (1'b0, "60 clocks after side_rst is deasserted");
    prim_clkreq_check(1'b0, "60 clocks after side_rst is deasserted");
  end
  repeat (60) @(posedge reset_if.clk);
  if(default_clk_checks) begin
  side_pok_check   (1'b1, "120 clocks after side_rst is deasserted");
  side_clkreq_check(1'b1, "120 clocks after side_rst is deasserted");
  end
--*/

  @(posedge reset_if.side_rst_b);
  @(posedge reset_if.clk);
  side_pok_check   (1'b0, "side_rst is deasserted");
  prim_pok_check   (1'b0, "side_rst is deasserted");
  side_clkreq_check(1'b0, "side_rst is deasserted");
  prim_clkreq_check(1'b0, "side_rst is deasserted");

  //-- check ip_ready (former config_ack)
  @(posedge reset_if.ip_ready);
 `ovm_info(get_full_name(), $psprintf("checks_on_side_rst_deassert ip_ready received"), OVM_LOW)
  

  //-- 01072020: Bill reviewed reset sanity checks, and suggested to eliminate all checks that specify clocks. "Since these  checks are not defined by any architectural spec- they should be eliminated."
  //-- check prim_pok and prim_clkreq
  repeat (30) @(posedge reset_if.clk);
  if(default_clk_checks) begin
    prim_pok_check   (1'b0, "60 clocks after side_rst is deasserted");
    prim_clkreq_check(1'b0, "60 clocks after side_rst is deasserted");
  end

  repeat (60) @(posedge reset_if.clk);
  //-- check side_pok and side_clkreq
  if(default_clk_checks) begin
    side_pok_check   (1'b1, "120 clocks after side_rst is deasserted");
    side_clkreq_check(1'b1, "120 clocks after side_rst is deasserted");
  end

endtask

task hqm_reset_monitor::checks_on_prim_pok_deassert();
  @(negedge reset_if.prim_pok);
  hqm_prim_pok_deassert.trigger();
  @(posedge reset_if.clk);
  //prim_clkreq_check(1'b1, "prim_pok is deasserted");
  if(!disable_pok_chk) fuse_ip_ready_check(1); else `ovm_info(get_full_name(), $psprintf("fuse_ip_ready_check skip as disable_pok_chk(0x%0x)",disable_pok_chk), OVM_LOW)
endtask

task hqm_reset_monitor::checks_on_prim_pok_assert();
  @(posedge reset_if.prim_pok);
  hqm_prim_pok_assert.trigger();
  @(posedge reset_if.clk);
  prim_clkreq_check(1'b1, "prim_pok is asserted");
  fuse_ip_ready_check(1);
endtask

task hqm_reset_monitor::checks_on_side_pok_deassert();
  @(negedge reset_if.side_pok);
  hqm_side_pok_deassert.trigger();
  @(posedge reset_if.clk);
  //side_clkreq_check(1'b1, "side_pok is deasserted");
  if(!disable_pok_chk) fuse_ip_ready_check(1); else `ovm_info(get_full_name(), $psprintf("fuse_ip_ready_check skip as disable_pok_chk(0x%0x)",disable_pok_chk), OVM_LOW)
endtask

task hqm_reset_monitor::checks_on_side_pok_assert();
  @(posedge reset_if.side_pok);
  hqm_side_pok_assert.trigger();
  @(posedge reset_if.clk);
  side_clkreq_check(1'b1, "side_pok is asserted");
  fuse_ip_ready_check(0);
endtask

task hqm_reset_monitor::checks_on_ip_ready_event();
    if (default_strap_no_mgmt_acks || default_ip_ready) begin
        //wait(reset_if.config_ack==1) ;
        @(posedge reset_if.ip_ready) ;
        @(posedge reset_if.clk);
        hqm_config_acks.trigger();
        `ovm_info(get_full_name(), $psprintf("checks_on_ip_ready_event config_ack received"), OVM_LOW)
    end
    else begin
        hqm_ip_ready.wait_trigger();
        `ovm_info(get_full_name(), $psprintf("checks_on_ip_ready_event hqm_ip_ready received"), OVM_LOW)
        got_ip_ready  = 1;
        side_clkreq_check(1'b1, "ip_ready");
        side_pok_check   (1'b1, "ip_ready");
    end

    got_ip_ready  = 1;
endtask

task hqm_reset_monitor::checks_on_fuse_pull_event();
  hqm_fuse_download_req.wait_trigger();
  got_fuse_pull = 1;
  side_clkreq_check(1'b1, "fuse pull");
  side_pok_check   (1'b1, "fuse pull");
endtask

task hqm_reset_monitor::checks_on_prim_side_clkack_low();
  fork 
    //checks_on_prim_clkack_low();
    //checks_on_side_clkack_low();
  join
endtask

task hqm_reset_monitor::checks_on_prim_clkack_low();
  wait (reset_if.prim_clkack==0) ;
  @(posedge reset_if.clk);
  if (reset_if.prim_clkack==0)
      prim_clkreq_check(1'b0, "clkack is 0");
endtask

task hqm_reset_monitor::checks_on_side_clkack_low();
  wait(reset_if.side_clkack==0) ;
  @(posedge reset_if.clk);
  if (reset_if.side_clkack==0)
      side_clkreq_check(1'b0, "clkack is 0");
endtask

task hqm_reset_monitor::checks_on_prim_side_clkack_high();
  fork 
      //checks_on_prim_clkack_high();
      //checks_on_side_clkack_high();
  join
endtask

task hqm_reset_monitor::checks_on_prim_clkack_high();
  wait (reset_if.prim_clkack==1) ;
  @(posedge reset_if.clk);
  if (reset_if.prim_clkack==1)
      prim_clkreq_check(1'b1, "clkack is 1");
endtask

task hqm_reset_monitor::checks_on_side_clkack_high();
  wait(reset_if.side_clkack==1) ;
  @(posedge reset_if.clk);
  if (reset_if.side_clkack==1)
      side_clkreq_check(1'b1, "clkack is 1");
endtask

task hqm_reset_monitor::checks_on_pwrgood_rst_assert();
  @(negedge reset_if.powergood_rst_b);
  @(posedge reset_if.clk);
  clkreq_check(1'b0, "powergood rst just got asserted"); // need clock always
  pok_check   (1'b0, "powergood rst just got asserted");
  got_fuse_pull = 0;
  got_ip_ready  = 0;
endtask

task hqm_reset_monitor::checks_on_pwrgood_rst_deassert();
  @(posedge reset_if.powergood_rst_b);
  @(posedge reset_if.clk);
  clkreq_check(1'b0, "powergood rst just got deasserted");
  pok_check   (1'b0, "powergood rst just got deasserted");
  fuse_ip_ready_check(0);
endtask
 
task hqm_reset_monitor::checks_on_config_ack();
    @(posedge reset_if.ip_ready);
    @(negedge reset_if.ip_ready);
    if (reset_if.side_rst_b!=1'b0)
        `ovm_error(get_full_name(),$psprintf( "side_rst_b 0x%0x should be 0x0 after ip_ready (ip_ready wire) goes from 1 to 0",reset_if.side_rst_b))
endtask

task hqm_reset_monitor::checks_on_reset_prep_ack();
    @(posedge reset_if.reset_prep_ack);
    @(negedge reset_if.reset_prep_ack);
    if (reset_if.side_rst_b!=1'b0)
         `ovm_error(get_full_name(),$psprintf( "side_rst_b 0x%0x should be 0x0 after reset_prep_ack wire goes from 1 to 0",reset_if.side_rst_b))
endtask

// Fuse pull, ip_ready check
task hqm_reset_monitor::fuse_ip_ready_check(int exp_value);
  if(ignore_due_to_sideband_reset) begin 
    `ovm_info(get_full_name(),$psprintf("Either sideband was hung because of parity error on sideband or there was command parity error on primary interface."),OVM_LOW)
  end else if(default_ip_ready) begin    
    `ovm_info(get_full_name(),$psprintf("Bypass fuse_ip_ready_check default_ip_ready=1"),OVM_LOW)
  end else begin    
  if ((got_fuse_pull!=exp_value) && (reset_if.pm_ip_clk_halt_b_2 == 1) && (reset_if.pm_ip_vdom_xclk_halt_b_2 == 1) && ~hqm_non_std_warm_rst_seq && ~deassert_prim_rst_b )
    `ovm_error(get_full_name(),$psprintf( "Expected Fuse pull = %d; got_fuse_pull = %d", exp_value, got_fuse_pull))

  if ((got_ip_ready!=exp_value) && (reset_if.pm_ip_clk_halt_b_2 == 1) && (reset_if.pm_ip_vdom_xclk_halt_b_2 == 1) && ~hqm_non_std_warm_rst_seq && ~deassert_prim_rst_b)
    `ovm_error(get_full_name(),$psprintf( "Expected ip_ready = %d; got_ip_ready = %d", exp_value, got_ip_ready))
  end    
endtask:fuse_ip_ready_check

// prim/side clkreq check
task hqm_reset_monitor::clkreq_check(logic value, string check_type);
  fork
    prim_clkreq_check(value, check_type);
    side_clkreq_check(value, check_type);
  join
endtask:clkreq_check
 
// prim clkreq check
task hqm_reset_monitor::prim_clkreq_check(logic value, string check_type);
  if ((reset_if.prim_clkreq!==value) && (reset_if.pm_ip_clk_halt_b_2 == 1) && (reset_if.pm_ip_vdom_xclk_halt_b_2 == 1) && ~hqm_non_std_warm_rst_seq) begin
     if(boot_seq_ctrl!=2) 
       `ovm_error(get_full_name(),$psprintf( "Prim_clkreq 0x%0x should be 0x%0x after %s",reset_if.prim_clkreq, value, check_type))
     else
       `ovm_warning(get_full_name(),$psprintf("Prim_clkreq 0x%0x should be 0x%0x after %s",reset_if.prim_clkreq, value, check_type));
  end
endtask:prim_clkreq_check

// side clkreq check
task hqm_reset_monitor::side_clkreq_check(logic value, string check_type);
  if ((reset_if.side_clkreq!==value) && (reset_if.pm_ip_clk_halt_b_2 == 1) && (reset_if.pm_ip_vdom_xclk_halt_b_2 == 1) && ~hqm_non_std_warm_rst_seq) begin
       `ovm_error(get_full_name(),$psprintf( "side_clkreq 0x%0x should be 0x%0x after %s",reset_if.side_clkreq, value, check_type))
  end
endtask:side_clkreq_check
 
// prim/side pok check
task hqm_reset_monitor::pok_check(logic value, string check_type);
  fork
      prim_pok_check(value, check_type);
      side_pok_check(value, check_type);
  join
endtask:pok_check
 
// prim pok check
task hqm_reset_monitor::prim_pok_check(logic value, string check_type);

      if(ignore_due_to_sideband_reset) begin 
        `ovm_info(get_full_name(),$psprintf("Either sideband was hung because of parity error on sideband or there was command parity error on primary interface."),OVM_LOW)
      end else begin    
        if ((reset_if.prim_pok!==value) && (reset_if.pm_ip_clk_halt_b_2 == 1) && (reset_if.pm_ip_vdom_xclk_halt_b_2 == 1)) begin
          if(boot_seq_ctrl!=2) 
             `ovm_error(get_full_name(),$psprintf( "Prim_pok 0x%0x should be 0x%0x after %s",reset_if.prim_pok, value, check_type))
          else
             `ovm_warning(get_full_name(),$psprintf( "Prim_pok 0x%0x should be 0x%0x after %s",reset_if.prim_pok, value, check_type))
        end
      end    
endtask:prim_pok_check
 
// prim/side pok check
task hqm_reset_monitor::side_pok_check(logic value, string check_type);

      if(ignore_due_to_sideband_reset) begin 
        `ovm_info(get_full_name(),$psprintf("Either sideband was hung because of parity error on sideband or there was command parity error on primary interface."),OVM_LOW)
      end else begin    
        if ((reset_if.side_pok!==value) && (reset_if.pm_ip_clk_halt_b_2 == 1) && (reset_if.pm_ip_vdom_xclk_halt_b_2 == 1))
          `ovm_error(get_full_name(),$psprintf( "side_pok 0x%0x should be 0x%0x after %s",reset_if.side_pok, value, check_type))
      end    
endtask:side_pok_check

`endif

