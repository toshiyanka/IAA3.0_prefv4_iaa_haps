`ifndef HQM_RESET_DRIVER__SV
`define HQM_RESET_DRIVER__SV

class hqm_reset_driver extends ovm_driver#(hqm_reset_transaction);

    virtual hqm_reset_if  reset_if;

    bit lcp_shift_check;
    bit ignore_due_to_sideband_reset;
    int has_wait_pok;
    bit default_ip_block_fp;
    bit [15:0] default_early_fuses;
    bit pwrgood_reset_early_fuses; 
    int early_fuses_ctrl;
    int boot_seq_ctrl;
    int side_clk_ctrl;
    int side_rst_dly_num;

    `ovm_component_utils_begin(hqm_reset_driver)
    `ovm_component_utils_end

    extern         function                new(string name = "hqm_reset_driver", ovm_component parent = null);
    extern virtual function void           build();
    extern virtual function void           end_of_elaboration();

    extern virtual protected task          drive_default(logic [0:0] reset_early_fuses);
    extern virtual protected task          drive_prim_rst_b(logic [0:0] value, int num_clk_dly);
    extern virtual protected task          drive_side_rst_b(logic [0:0] value, logic [15:0] early_fuses_value, int num_clk_dly, int boot_ctrl);
    extern virtual protected task          drive_ip_block_fp(logic [0:0] value, int num_clk_dly);
    extern virtual protected task          drive_early_fuses(logic [15:0] value, int num_clk_dly);
    extern virtual protected task          drive_power(real value, int num_clk_dly = 40, int side_clk_ctrl);
    extern         protected function int  num_clk_dly();
    extern         protected function int  num_clk_dly_short();
    extern virtual protected task          drive_lcp_data(input bit [(`LCP_DEPTH - 1):0] LcpDatIn);
    extern virtual protected task          check_lcp_data(input bit [(`LCP_DEPTH - 1):0] LcpDatIn);
    extern virtual protected task          clk_skew();
    extern virtual           task          run();

endclass:hqm_reset_driver

//.............
function hqm_reset_driver::new (string name = "hqm_reset_driver", ovm_component parent = null);
    super.new(name, parent);
    lcp_shift_check = $test$plusargs("LCP_SHIFT_CHECK");
    ignore_due_to_sideband_reset = $test$plusargs("IGNORE_DUE_TO_SIDEBAND_RESET");
    has_wait_pok                 = $test$plusargs("RESET_ASSERT_WAIT_POK");    
    default_ip_block_fp = $test$plusargs("HQM_ENABLE_DELAY_FUSE_PULL");
    pwrgood_reset_early_fuses=0; 
    $value$plusargs("HQM_PWRGOOD_RESET_EARLY_FUSE=%0d",   pwrgood_reset_early_fuses);
    default_early_fuses = 16'h0;
    $value$plusargs("HQM_TB_FUSE_VALUES=%0h",  default_early_fuses);
    boot_seq_ctrl  = 0;
    $value$plusargs("HQM_BOOT_CTRL=%0d",  boot_seq_ctrl);
    side_clk_ctrl  = 0;
    $value$plusargs("HQM_SIDE_CLK_CTRL=%0d",  side_clk_ctrl);
    side_rst_dly_num  = 40;
    $value$plusargs("HQM_SIDE_CLK_DLY=%0d",  side_rst_dly_num);
    `ovm_info(get_full_name(),$psprintf("HQM_TB_FUSE_VALUES: default_early_fuses=0x%0x boot_seq_ctrl=%0d side_clk_ctrl=%0d, side_rst_dly_num=%0d, ignore_due_to_sideband_reset=%0d, has_wait_pok=%0d", default_early_fuses, boot_seq_ctrl, side_clk_ctrl, side_rst_dly_num, ignore_due_to_sideband_reset, has_wait_pok),OVM_LOW)

    early_fuses_ctrl=0;
    //-- change early_fuses only before side_rst=1, don't change it during uncertain window after side_rst=1  --//$value$plusargs("HQM_ASSERT_FUSE_CTRL=%0d",  early_fuses_ctrl);
endfunction:new

//.............
function void hqm_reset_driver::build();
    super.build();
endfunction:build

//.............
function void hqm_reset_driver::end_of_elaboration();
  string reset_if_name;

  super.end_of_elaboration();
  if (!get_config_string("reset_if_handle",reset_if_name)) begin 
    `ovm_fatal(get_full_name(), "Unable to find reset_if_handle config string ");
  end

  `sla_get_db(reset_if,virtual hqm_reset_if, reset_if_name);
  assert(reset_if) `ovm_info(get_full_name(), "hqm_reset_if has been obtained", OVM_DEBUG) else
                   `ovm_error(get_full_name(), "Couldn't get hqm_reset_if")

endfunction:end_of_elaboration

// Drive the default values
task hqm_reset_driver::drive_default(logic [0:0] reset_early_fuses);
  reset_if.powergood_rst_b <= 0;
  reset_if.prim_pwrgate_pmc_wake <= 0;
  reset_if.side_pwrgate_pmc_wake <= 0;
  reset_if.side_rst_b <= 0;
  reset_if.prim_rst_b <= 0;
  reset_if.ip_block_fp <= default_ip_block_fp;
  if(reset_early_fuses==1) reset_if.early_fuses <= default_early_fuses;
  else                     reset_if.early_fuses <= 16'h0; 
  reset_if.fdfx_sync_rst <= 0;
  reset_if.pm_ip_clk_halt_b_2 <= 1'b0;
  reset_if.pm_ip_vdom_xclk_halt_b_2 <= 1'b0;
  reset_if.flcp_reset_b <= 0;
  reset_if.flcp_slsr_in <= 1'b0;
  reset_if.lcp_shift_done_status <= 1'b0;
endtask:drive_default

// Drive Primary reset with the given value
task hqm_reset_driver::drive_prim_rst_b(logic [0:0] value, int num_clk_dly);
  repeat(num_clk_dly) @(posedge reset_if.clk);
  clk_skew(); 
  reset_if.prim_rst_b <= value;
endtask:drive_prim_rst_b

// Drive Sideband reset with the given value
// reset early_fuses
task hqm_reset_driver::drive_side_rst_b(logic [0:0] value, logic [15:0] early_fuses_value, int num_clk_dly, int boot_ctrl);
  `ovm_info(get_full_name(),$psprintf("drive_side_rst_b: start side_rst=%0d early_fuses=0x%0x num_clk_dly=%0d boot_ctrl=%0d", value, early_fuses_value, num_clk_dly, boot_ctrl),OVM_MEDIUM)
  if(value==0) begin
     repeat(num_clk_dly) @(posedge reset_if.clk);
     clk_skew();
     reset_if.side_rst_b <= value;
     
     drive_early_fuses(early_fuses_value, num_clk_dly);
  end else begin
     fork
     begin
        repeat(num_clk_dly) @(posedge reset_if.clk);
        clk_skew();
       `ovm_info(get_full_name(),$psprintf("drive_side_rst_b: side_rst_deassert_wait done"),OVM_MEDIUM)
     end
     begin
       `ovm_info(get_full_name(),$psprintf("drive_side_rst_b: drive early_fuses_value start"),OVM_MEDIUM)
        drive_early_fuses(early_fuses_value, 0);
        repeat(4) @(posedge reset_if.side_clk);
       `ovm_info(get_full_name(),$psprintf("drive_side_rst_b: drive early_fuses_value done"),OVM_MEDIUM)
     end
     join

     `ovm_info(get_full_name(),$psprintf("drive_side_rst_b: side_rst_deassert and/or prim_rst_deassert "),OVM_MEDIUM)
     if(boot_ctrl==1) begin
        `ovm_info(get_full_name(),$psprintf("drive_side_rst_b: boot_ctrl=1:: side_rst_deassert and prim_rst_deassert at the same time"),OVM_MEDIUM)
         reset_if.side_rst_b <= value;
         reset_if.prim_rst_b <= value;
     end else if(boot_ctrl==2) begin
        `ovm_info(get_full_name(),$psprintf("drive_side_rst_b: boot_ctrl=2:: 1_prim_rst_deassert first then wait %0d before side_rst_deassert", side_rst_dly_num),OVM_MEDIUM)
         reset_if.prim_rst_b <= value;
         repeat(side_rst_dly_num) @(posedge reset_if.side_clk);
        `ovm_info(get_full_name(),$psprintf("drive_side_rst_b: boot_ctrl=2:: 2_side_rst_deassert "),OVM_MEDIUM)
         reset_if.side_rst_b <= value;
     end else begin
        `ovm_info(get_full_name(),$psprintf("drive_side_rst_b: side_rst_deassert before prim_rst_deassert (default)"),OVM_MEDIUM)
         reset_if.side_rst_b <= value;
     end
  end
endtask:drive_side_rst_b

// Drive ip_block_fp with the given value
task hqm_reset_driver::drive_ip_block_fp(logic [0:0] value, int num_clk_dly);
  repeat(num_clk_dly) @(posedge reset_if.clk);
  clk_skew();
  reset_if.ip_block_fp <= value;
endtask:drive_ip_block_fp

// Drive early_fuses with the given value
task hqm_reset_driver::drive_early_fuses(logic [15:0] value, int num_clk_dly);
  repeat(num_clk_dly) @(posedge reset_if.side_clk);
  reset_if.early_fuses <= value;
    `ovm_info(get_full_name(),$psprintf("drive_early_fuses: drive early_fuses=0x%0x num_clk_dly=%0d", value, num_clk_dly),OVM_LOW)
endtask:drive_early_fuses

function int hqm_reset_driver::num_clk_dly();
  return $urandom_range(1,10);
endfunction


function int hqm_reset_driver::num_clk_dly_short();
  return $urandom_range(0,2);
endfunction

task hqm_reset_driver::clk_skew();
   real clk_skew;
   // reset_if.clk is connected to a 400MHz clock which has period of 2.5; so introduce a skew between 0 - 2.5
   clk_skew = ($urandom_range(0,24)/10.0);
   #(clk_skew * 1ns);
endtask:clk_skew


task hqm_reset_driver::drive_power(real value, int num_clk_dly = 40, int side_clk_ctrl=0);
  real cur_voltage;
  real voltage_step;

  cur_voltage = reset_if.vcccfn_voltage;

  `ovm_info(get_full_name(),$psprintf("reset_flow_type drive_power start side_clk_ctrl=%0d", side_clk_ctrl),OVM_MEDIUM)
  if ((cur_voltage > reset_if.vcccfn_ret_thresh_out) && (value <= reset_if.vcccfn_ret_thresh_out)) begin
    `ovm_info(get_full_name(),$psprintf("reset_flow_type drive_power pm_ip_clk_halt_b_2=0: stop side_clk"),OVM_MEDIUM)
    reset_if.pm_ip_clk_halt_b_2 <= 1'b0;
    reset_if.pm_ip_vdom_xclk_halt_b_2 <= 1'b0;
  end

  voltage_step = (value - cur_voltage) / num_clk_dly;

  for (int i= 0 ; i < (num_clk_dly - 1) ; i++) begin
    @(posedge reset_if.aon_clk);
    //reset_if.vcccfn_voltage += voltage_step;
  end

  reset_if.vcccfn_voltage = value;

  repeat(8) @(posedge reset_if.aon_clk);

  if ((cur_voltage <= reset_if.vcccfn_ret_thresh_out) && (value > reset_if.vcccfn_ret_thresh_out)) begin
    if(side_clk_ctrl==2) begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type drive_power pm_ip_clk_halt_b_2=1: don't resume side_clk"),OVM_MEDIUM)
      //reset_if.pm_ip_clk_halt_b_2 <= 1'b1;
      reset_if.pm_ip_vdom_xclk_halt_b_2 <= 1'b1;
    end else begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type drive_power pm_ip_clk_halt_b_2=1: resume side_clk"),OVM_MEDIUM)
      reset_if.pm_ip_clk_halt_b_2 <= 1'b1;
      reset_if.pm_ip_vdom_xclk_halt_b_2 <= 1'b1;
    end
  end

  repeat(192) @(posedge reset_if.aon_clk);      // 64 400MHz side_clk cycles
  `ovm_info(get_full_name(),$psprintf("reset_flow_type drive_power done"),OVM_MEDIUM)
endtask

task hqm_reset_driver::drive_lcp_data(input bit [(`LCP_DEPTH - 1):0] LcpDatIn);

    `ovm_info(get_full_name(),$psprintf("LCP Shift Start: LcpDatIn = %b", LcpDatIn),OVM_LOW)
    for(int i=0;i<`LCP_DEPTH;i++) begin
        @(posedge reset_if.flcp_clk);
        reset_if.flcp_slsr_in <= LcpDatIn[i];
    end
endtask

task hqm_reset_driver::check_lcp_data(input bit [(`LCP_DEPTH - 1):0] LcpDatIn);
    bit [(`LCP_DEPTH - 1):0] LcpDatOut;
    repeat(1) @(posedge reset_if.flcp_clk_out);
    for(int i=0;i<`LCP_DEPTH;i++) begin
        @(negedge reset_if.flcp_clk_out);
        LcpDatOut[i] = reset_if.flcp_slsr_out;
    end
    `ovm_info(get_full_name(),$psprintf("LCP Shift End: LcpDatIn = %b, LcpDatOut = %b, lcp_shift_check = %d", LcpDatIn, LcpDatOut, lcp_shift_check),OVM_LOW)
    if ((LcpDatOut!=LcpDatIn) && lcp_shift_check) 
        `ovm_error(get_full_name(),$psprintf( "Expected Non-Zero shift out, received Zeros shifting out:LcpDatIn = %b, LcpDatOut = %b", LcpDatIn, LcpDatOut))

endtask

//.............
task hqm_reset_driver::run();

  super.run();
  drive_default(pwrgood_reset_early_fuses);
  reset_if.vcccfn_voltage <= 0; // -- VCCCFN voltage set to 0 at start of test

  forever begin
    seq_item_port.get_next_item(req);

    case (req.reset_flow_type)
    // deassert powergood reset
    POWER_GOOD_DEASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=POWER_GOOD_DEASSERT start"),OVM_MEDIUM)
      repeat(num_clk_dly()) @(posedge reset_if.clk);
      clk_skew();
      reset_if.powergood_rst_b <= 1;
      repeat(num_clk_dly()) @(posedge reset_if.clk);
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=POWER_GOOD_DEASSERT done"),OVM_MEDIUM)
    end

    // assert powergood reset
    POWER_GOOD_ASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=POWER_GOOD_ASSERT start"),OVM_MEDIUM)
      clk_skew();
      reset_if.powergood_rst_b <= 0;
      repeat(num_clk_dly()) @(posedge reset_if.clk);
      drive_default(pwrgood_reset_early_fuses);
      repeat(num_clk_dly()) @(posedge reset_if.clk);
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=POWER_GOOD_ASSERT done"),OVM_MEDIUM)
    end

    // deassert pgcb_rst, assert ip (prim/side) wake, wait on prim/side clkreq/ack to be high, deassert side_rst, wait for prim/side_pok to be asserted
    RESET_DEASSERT_PART1: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_DEASSERT_PART1 start with EarlyFuseIn = 0x%0x boot_seq_ctrl=%0d", req.EarlyFuseIn,  boot_seq_ctrl), OVM_MEDIUM)
     
      //--resume side_clk 
      if(side_clk_ctrl > 0) begin
         `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_DEASSERT_PART1 side_clk_ctrl=%0d: resume side_clk", side_clk_ctrl),OVM_MEDIUM)
          reset_if.pm_ip_clk_halt_b_2 <= 1'b1;
      end

      repeat(num_clk_dly()) @(posedge reset_if.clk);
      reset_if.fdfx_sync_rst <= 1;
      repeat(num_clk_dly()) @(posedge reset_if.clk);
      reset_if.prim_pwrgate_pmc_wake <= 1;
      reset_if.side_pwrgate_pmc_wake <= 1;
     `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_DEASSERT_PART1 before deassert side_rst, assert EarlyFuseIn = 0x%0x boot_seq_ctrl=%0d", req.EarlyFuseIn, boot_seq_ctrl),OVM_MEDIUM)
      if(boot_seq_ctrl==1) begin
          drive_side_rst_b(1, req.EarlyFuseIn, num_clk_dly(), 1);
         `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_DEASSERT_PART1 issue side_rst_b=1 and prim_rst_b=1 at the same time when boot_seq_ctrl=1, and bypass side_clkreq/clkack/pok poll and check"),OVM_MEDIUM)
      end else if(boot_seq_ctrl==2) begin
          drive_side_rst_b(1, req.EarlyFuseIn, num_clk_dly(), 2);
         `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_DEASSERT_PART1 issue prim_rst_b=1 and then side_rst_1= when boot_seq_ctrl=2, and bypass side_clkreq/clkack/pok poll and check"),OVM_MEDIUM)
      end else if(boot_seq_ctrl==3) begin
          drive_side_rst_b(1, req.EarlyFuseIn, num_clk_dly(), 0);
         `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_DEASSERT_PART1 issue side_rst_1= when boot_seq_ctrl=3, and bypass side_clkreq/clkack/pok poll and check"),OVM_MEDIUM)
      end else begin
          drive_side_rst_b(1, req.EarlyFuseIn, num_clk_dly(), 0);
          wait (reset_if.side_clkreq==`HQM_SB_DEASSERT_CLK_SIGS_DEFAULT) ;
          wait (reset_if.side_clkack==`HQM_SB_DEASSERT_CLK_SIGS_DEFAULT) ;
          wait (reset_if.side_pok==`HQM_SB_DEASSERT_CLK_SIGS_DEFAULT) ;
      end 

      `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_DEASSERT_PART1 done"),OVM_MEDIUM)
    end

    // deassert prim_rst, deassert ip (prim/side) wake
    RESET_DEASSERT_PART2: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_DEASSERT_PART2 start"),OVM_MEDIUM)
      if(boot_seq_ctrl==1 || boot_seq_ctrl==2) begin
          //drive_prim_rst_b(1, 0);
         `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_DEASSERT_PART2 skip prim_rst_b=1 when boot_seq_ctrl=1/2, and bypass prim_clkreq/clkack/pok poll and check"),OVM_MEDIUM)
      end else if(boot_seq_ctrl==3) begin
          drive_prim_rst_b(1, num_clk_dly());
         `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_DEASSERT_PART2 issue prim_rst_b=1 when boot_seq_ctrl=3, and bypass prim_clkreq/clkack/pok poll and check"),OVM_MEDIUM)
      end else begin
          drive_prim_rst_b(1, num_clk_dly());
          wait (reset_if.prim_clkreq==`HQM_PRIM_DEASSERT_CLK_SIGS_DEFAULT) ;
          wait (reset_if.prim_clkack==`HQM_PRIM_DEASSERT_CLK_SIGS_DEFAULT) ;
          wait (reset_if.prim_pok==`HQM_PRIM_DEASSERT_CLK_SIGS_DEFAULT) ;
      end
      repeat(100) @(posedge reset_if.clk);  // Revisit: T_rst2wakedrop=5us (minimum)
      reset_if.prim_pwrgate_pmc_wake <= 0;
      reset_if.side_pwrgate_pmc_wake <= 0;
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_DEASSERT_PART2 done"),OVM_MEDIUM)
    end

    // wait on prim/side_pok, wait on prim/side clkreq/ack to be low, assert pgcb_rst, assert prim/side_rst
    RESET_ASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_ASSERT start"),OVM_MEDIUM)
      if(ignore_due_to_sideband_reset) begin 
        `ovm_info(get_full_name(),$psprintf("Sideband is in hung state. To take it out, the only way it to apply the primary and sideband resets."),OVM_MEDIUM)
        if(has_wait_pok) begin
            `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_ASSERT wait for prim_pok=0 and side_pok=0"),OVM_MEDIUM)
            wait ((reset_if.prim_pok==0) && (reset_if.side_pok==0)) ;
            `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_ASSERT get prim_pok=0 and side_pok=0"),OVM_MEDIUM)
        end
      end else begin    
         wait ((reset_if.prim_pok==0) && (reset_if.side_pok==0)) ;
         wait ((reset_if.prim_clkreq==0) && (reset_if.side_clkreq==0)) ;
         wait ((reset_if.prim_clkack==0) && (reset_if.side_clkack==0)) ;      
      end 
      repeat(100) @(posedge reset_if.clk); // Revisit: T_ipdone2rst=10us (minimum)
      reset_if.flcp_reset_b <= 0;
      drive_prim_rst_b(0, num_clk_dly());
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_ASSERT prim_rst_b=0"),OVM_MEDIUM)
      reset_if.lcp_shift_done_status <= 1'b0;
      drive_side_rst_b(0, 0, num_clk_dly(), 0);
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_ASSERT side_rst_b=0"),OVM_MEDIUM)
      reset_if.fdfx_sync_rst <= 0;
      repeat(num_clk_dly()) @(posedge reset_if.clk);

      //--stop side_clk if(side_clkreq=0)
      if(side_clk_ctrl > 0) begin
         `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_ASSERT side_clk_ctrl=%0d: check side_clkreq=0", side_clk_ctrl),OVM_MEDIUM)
          wait (reset_if.side_clkreq==0) ;
         `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_ASSERT side_clk_ctrl=%0d: stop side_clk", side_clk_ctrl),OVM_MEDIUM)
          reset_if.pm_ip_clk_halt_b_2 <= 1'b0;
      end
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_ASSERT done"),OVM_MEDIUM)
    end

    // Don't wait on prim/side_pok & Don't wait on prim/side clkreq/ack to be low, assert pgcb_rst, assert prim/side_rst
    RESET_ASSERT_WITH_ILLEGAL_FORCE_POK: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_ASSERT_WITH_ILLEGAL_FORCE_POK start"),OVM_MEDIUM)
      repeat(1000) @(posedge reset_if.clk); 
      reset_if.flcp_reset_b <= 0;
      drive_prim_rst_b(0, num_clk_dly());
      reset_if.lcp_shift_done_status <= 1'b0;
      drive_side_rst_b(0, 0, num_clk_dly(), 0);
      reset_if.fdfx_sync_rst <= 0;
      repeat(num_clk_dly()) @(posedge reset_if.clk);
      repeat(1000) @(posedge reset_if.clk); 
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_ASSERT_WITH_ILLEGAL_FORCE_POK done"),OVM_MEDIUM)
    end

    // assert side/prim_rst
     PRIM_SIDE_RESET_ASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_SIDE_RESET_ASSERT start"),OVM_MEDIUM)
      drive_prim_rst_b(0, num_clk_dly());
      repeat(100) @(posedge reset_if.clk); 
      drive_side_rst_b(0, 0, num_clk_dly(), 0);
      repeat(100) @(posedge reset_if.clk); 
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_SIDE_RESET_ASSERT done"),OVM_MEDIUM)
    end

    // assert side/prim_rst
     PRIM_RESET_ASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_RESET_ASSERT start"),OVM_MEDIUM)
      drive_prim_rst_b(0, num_clk_dly());
      repeat(100) @(posedge reset_if.clk); 
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_RESET_ASSERT done"),OVM_MEDIUM)
    end

    // wait on prim/side clkreq to be high
    PRIM_SIDE_CLKREQ_ASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_SIDE_CLKREQ_ASSERT start"),OVM_MEDIUM)
      repeat(100) @(posedge reset_if.clk); 
      wait ((reset_if.prim_clkreq==1) && (reset_if.side_clkreq==1)) ;
      repeat(100) @(posedge reset_if.clk); 
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_SIDE_CLKREQ_ASSERT done"),OVM_MEDIUM)
    end

    // wait on prim/side clkreq to be low
    PRIM_SIDE_CLKREQ_DEASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_SIDE_CLKREQ_DEASSERT start"),OVM_MEDIUM)
      repeat(100) @(posedge reset_if.clk); 
      wait ((reset_if.prim_clkreq==0) && (reset_if.side_clkreq==0)) ;
      repeat(100) @(posedge reset_if.clk); 
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_SIDE_CLKREQ_DEASSERT done"),OVM_MEDIUM)
    end

    // deassert side/prim_rst
    PRIM_SIDE_RESET_DEASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_SIDE_RESET_DEASSERT start"),OVM_MEDIUM)
      repeat(100) @(posedge reset_if.clk); 
      if(boot_seq_ctrl==1 || boot_seq_ctrl==2 ) begin
          drive_side_rst_b(1, 0, num_clk_dly(), boot_seq_ctrl);
         `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_SIDE_RESET_DEASSERT issue side_rst_b=1 and prim_rst_b=1 when boot_seq_ctrl=%0d", boot_seq_ctrl),OVM_MEDIUM)
      end else begin
          drive_side_rst_b(1, 0, num_clk_dly(), 0);
      end 
      repeat(500) @(posedge reset_if.clk); 
      if(boot_seq_ctrl==1) begin
         `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_SIDE_RESET_DEASSERT issue side_rst_b=1 and prim_rst_b=1 when boot_seq_ctrl=1, skip this step"),OVM_MEDIUM)
      end else begin
          drive_prim_rst_b(1, num_clk_dly());
      end
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_SIDE_RESET_DEASSERT done"),OVM_MEDIUM)
    end

    // deassert side/prim_rst
    PRIM_RESET_DEASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_RESET_DEASSERT start"),OVM_MEDIUM)
      repeat(500) @(posedge reset_if.clk); 
      drive_prim_rst_b(1, num_clk_dly());
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_RESET_DEASSERT done"),OVM_MEDIUM)
    end

    // deassert ip_block_fp
    IP_BLOCK_FP_DEASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=IP_BLOCK_FP_DEASSERT start"),OVM_MEDIUM)
      repeat(32) @(posedge reset_if.clk); 
      drive_ip_block_fp(0, num_clk_dly());
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=IP_BLOCK_FP_DEASSERT done"),OVM_MEDIUM)
    end

    // Assert ip_block_fp
    IP_BLOCK_FP_ASSERT: begin 
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=IP_BLOCK_FP_ASSERT start"),OVM_MEDIUM)
      drive_ip_block_fp(1, num_clk_dly());
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=IP_BLOCK_FP_ASSERT done"),OVM_MEDIUM)
    end

    // Assert early_fuses
    EARLY_FUSES_ASSERT: begin 
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=EARLY_FUSES_ASSERT start with EarlyFuseIn = 0x%0x", req.EarlyFuseIn),OVM_MEDIUM)
      drive_early_fuses(req.EarlyFuseIn, num_clk_dly());
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=EARLY_FUSES_ASSERT done with EarlyFuseIn = 0x%0x", req.EarlyFuseIn),OVM_MEDIUM)
    end

    // assert prim_rst, wait for prim clkreq/pok to be high, deassert prim_rst
    PRIMARY_RESET: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIMARY_RESET start"),OVM_MEDIUM)
      drive_prim_rst_b(0, num_clk_dly());
      wait (reset_if.prim_clkreq==!`HQM_PRIM_DEASSERT_CLK_SIGS_DEFAULT) ;
      wait (reset_if.prim_clkack==!`HQM_PRIM_DEASSERT_CLK_SIGS_DEFAULT) ;
      wait (reset_if.prim_pok==!`HQM_PRIM_DEASSERT_CLK_SIGS_DEFAULT) ;
      wait (reset_if.side_pok==`HQM_SB_DEASSERT_CLK_SIGS_DEFAULT) ;
      drive_prim_rst_b(1, num_clk_dly());
      wait (reset_if.prim_pok==`HQM_PRIM_DEASSERT_CLK_SIGS_DEFAULT) ;
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIMARY_RESET done"),OVM_MEDIUM)
    end

    // assert side_rst, wait for side clkreq to be high, deassert side_rst, wait for side pok to be high
    SIDEBAND_RESET: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=SIDEBAND_RESET start"),OVM_MEDIUM)
      drive_side_rst_b(0, 0, num_clk_dly(), 0);
      wait (reset_if.side_clkreq==!`HQM_SB_DEASSERT_CLK_SIGS_DEFAULT) ;
      wait (reset_if.side_clkack==!`HQM_SB_DEASSERT_CLK_SIGS_DEFAULT) ;
      wait (reset_if.side_pok==!`HQM_SB_DEASSERT_CLK_SIGS_DEFAULT) ;
      drive_side_rst_b(1, 0, num_clk_dly(), 0);
      wait (reset_if.side_pok==`HQM_SB_DEASSERT_CLK_SIGS_DEFAULT) ;
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=SIDEBAND_RESET done"),OVM_MEDIUM)
    end

    POWER_UP: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=POWER_UP start"),OVM_MEDIUM)
      drive_power(reset_if.vcccfn_on_thresh_out, 40, side_clk_ctrl);
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=POWER_UP done"),OVM_MEDIUM)
    end

    POWER_RETENTION: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=POWER_RETENTION start"),OVM_MEDIUM)
      drive_power(reset_if.vcccfn_ret_thresh_out, 40, 0);
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=POWER_RETENTION done"),OVM_MEDIUM)
    end

    POWER_DOWN: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=POWER_DOWN start"),OVM_MEDIUM)
      drive_power(0.0, 40, side_clk_ctrl);
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=POWER_DOWN done"),OVM_MEDIUM)
    end

    // wait on prim clkreq to be high
    PRIM_CLKREQ_ASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_CLKREQ_ASSERT start"),OVM_MEDIUM)
      @(posedge reset_if.clk); 
      wait (reset_if.prim_clkreq==1) ;
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_CLKREQ_ASSERT done"),OVM_MEDIUM)
    end

    // wait on prim clkreq to be low
    PRIM_CLKREQ_DEASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_CLKREQ_DEASSERT start"),OVM_MEDIUM)
      @(posedge reset_if.clk); 
      wait (reset_if.prim_clkreq==0) ;
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_CLKREQ_DEASSERT done"),OVM_MEDIUM)
    end

    LCP_RESET: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=LCP_RESET start"),OVM_MEDIUM)
      repeat(10) @(posedge reset_if.flcp_clk);
      reset_if.flcp_reset_b <= 1;
      repeat(10) @(posedge reset_if.flcp_clk);
      reset_if.lcp_shift_done_status <= 1'b0;
      `ovm_info(get_full_name(),$sformatf("reset_flow_type=LCP_RESET inside reset driver LCP_RESET:LcpDatIn = %b", req.LcpDatIn),OVM_MEDIUM)
      drive_lcp_data(req.LcpDatIn);
      check_lcp_data(req.LcpDatIn);
      repeat(10) @(posedge reset_if.flcp_clk);
      reset_if.lcp_shift_done_status <= 1'b1;
      repeat(10) @(posedge reset_if.flcp_clk);
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=LCP_RESET done"),OVM_MEDIUM)
    end

    // wait on prim clkack to be high
    PRIM_CLKACK_ASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_CLKACK_ASSERT start"),OVM_MEDIUM)
      @(posedge reset_if.aon_clk); 
      wait (reset_if.prim_clkack==1) ;
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_CLKACK_ASSERT done"),OVM_MEDIUM)
    end

    // wait on prim clkack to be low
    PRIM_CLKACK_DEASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_CLKACK_DEASSERT start"),OVM_MEDIUM)
      @(posedge reset_if.aon_clk);
      wait (reset_if.prim_clkack==0) ;
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=PRIM_CLKACK_DEASSERT done"),OVM_MEDIUM)
    end

    DRIVE_CLK_HALT_B_1: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=DRIVE_CLK_HALT_B_1 start"),OVM_MEDIUM)
       reset_if.pm_ip_clk_halt_b_2 <= 1'b1;
       reset_if.pm_ip_vdom_xclk_halt_b_2 <= 1'b1;
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=DRIVE_CLK_HALT_B_1 done"),OVM_MEDIUM)
    end    

    LCP_SHIFT_IN: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=LCP_SHIFT_IN start"),OVM_MEDIUM)
      repeat(10) @(posedge reset_if.flcp_clk);
      reset_if.flcp_reset_b <= 1;
      repeat(10) @(posedge reset_if.flcp_clk);
      reset_if.lcp_shift_done_status <= 1'b0;
      drive_lcp_data(req.LcpDatIn);
      //repeat(1) @(posedge reset_if.flcp_clk);
      //reset_if.lcp_shift_done_status <= 1'b1;
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=LCP_SHIFT_IN done"),OVM_MEDIUM)
    end    

    LCP_SHIFT_OUT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=LCP_SHIFT_OUT start"),OVM_MEDIUM)
      check_lcp_data(req.LcpDatIn);
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=LCP_SHIFT_OUT done"),OVM_MEDIUM)
    end    

    // wait on ip_ready to be high
    IP_READY_RESP: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=IP_READY_RESP start"),OVM_MEDIUM)
      @(posedge reset_if.aon_clk); 
      wait (reset_if.ip_ready==1) ;
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=IP_READY_RESP done ip_ready=1"),OVM_MEDIUM)
    end

    // wait on reset_prep_ack to be high
    RESET_PREP_ACKED: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_PREP_ACKED start"),OVM_MEDIUM)
      @(posedge reset_if.aon_clk); 
      wait (reset_if.reset_prep_ack==1) ;
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=RESET_PREP_ACKED done"),OVM_MEDIUM)
    end

    // force  hw_reset_force_pwr_on=1
    HW_RESET_FORCE_PWR_ON_ASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=HW_RESET_FORCE_PWR_ON_ASSERT start"),OVM_MEDIUM)
      @(posedge reset_if.clk); 
      reset_if.hw_reset_force_pwr_on <= 1'b1; 
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=HW_RESET_FORCE_PWR_ON_ASSERT done hw_reset_force_pwr_on=1"),OVM_MEDIUM)
    end

    // force  hw_reset_force_pwr_on=0
    HW_RESET_FORCE_PWR_ON_DEASSERT: begin
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=HW_RESET_FORCE_PWR_ON_DEASSERT start"),OVM_MEDIUM)
      @(posedge reset_if.clk); 
      reset_if.hw_reset_force_pwr_on <= 1'b0; 
      `ovm_info(get_full_name(),$psprintf("reset_flow_type=HW_RESET_FORCE_PWR_ON_DEASSERT done hw_reset_force_pwr_on=0"),OVM_MEDIUM)
    end

    default: begin
      `ovm_error(get_name(),"Invalid Reset Flow type!!")
    end
    endcase
    seq_item_port.item_done();
  end //forever
endtask:run

`endif

