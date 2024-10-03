`ifndef HQM_BOOT_SEQUENCE__SV 
`define HQM_BOOT_SEQUENCE__SV

import hqm_tb_sequences_pkg::*;
import hqm_tb_cfg_sequences_pkg::*;

// Cold Boot Flow Sequence
class hqm_boot_sequence extends ovm_sequence;

  `ovm_sequence_utils(hqm_boot_sequence, sla_sequencer);

  rand bit en_lcp_shift_in;
  rand bit [(`LCP_DEPTH - 1):0] lcp_shift_in_data;
  rand bit [15:0] early_fuses_load;

  constraint dflt_val {
      soft en_lcp_shift_in == 1'b0;
      soft lcp_shift_in_data == 'h0;
  }
  constraint dflt_early_fuses {
      soft early_fuses_load == 16'h0;
  }

  hqm_integ_pkg::HqmIntegEnv agent_env; 
  ovm_event_pool  global_pool;
  ovm_event       hqm_ip_ready;
  ovm_event       hqm_fuse_download_req;
  sla_fuse_env    fuse_env;

  function new(string name = "hqm_boot_sequence");
    super.new(name);
    global_pool  = ovm_event_pool::get_global_pool();
    hqm_ip_ready = global_pool.get("hqm_ip_ready");
    hqm_fuse_download_req = global_pool.get("hqm_fuse_download_req");
  endfunction: new

  hqm_reset_unit_sequence       powergood_deassert_seq;
  hqm_reset_unit_sequence       reset_deassert_part1_seq;
  hqm_reset_unit_sequence       reset_deassert_part2_seq;
  hqm_reset_unit_sequence       ip_block_fp_deassert_seq;
  hqm_reset_unit_sequence       ip_block_fp_assert_seq;
  hqm_reset_unit_sequence       early_fuses_assert_seq;
  hqm_reset_unit_sequence       ip_ready_seq;
`ifdef IP_TYP_TE
  hqm_fuse_bypass_seq           fbp_seq;
  hqm_iosf_sb_fuse_download_seq fuse_download_seq;
`endif
  hqm_reset_unit_sequence       lcp_reset_seq;
   

  virtual task body();

    int           second_fuse_data_cmpl;
    bit           deassert_prim_rst_b;  
    int           default_ip_block_fp;
    bit           default_strap_no_mgmt_acks;
    bit [15:0]    default_early_fuses;
    bit           has_default_early_fuses;
    bit [15:0]    early_fuses_rnd;
    bit [15:0]    early_fuses_load_data;
    bit           default_ip_ready;
    bit           has_false_fuses_after_ipready;  
    bit [(`LCP_DEPTH - 1):0] LcpDatIn;

    super.body();

    second_fuse_data_cmpl = $test$plusargs("HQM_TB_SECOND_FUSE_DATA_CMPL");
    deassert_prim_rst_b    = $test$plusargs("HQM_TB_DEASSERT_PRIM_RST_B");
    default_ip_block_fp = 0;
    if ($value$plusargs("HQM_ENABLE_DELAY_FUSE_PULL=%d", default_ip_block_fp)) begin
      if ((default_ip_block_fp < 0) || (default_ip_block_fp > 2)) begin
        `ovm_error(get_type_name(),$psprintf("+HQM_ENABLE_DELAY_FUSE_PULL=%0d is unsupported (0, 1, or 2 valid)",default_ip_block_fp))
        default_ip_block_fp = 0;
      end

      `ovm_do_on_with(ip_block_fp_assert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==IP_BLOCK_FP_ASSERT;}); 
    end

    has_default_early_fuses=0;
    $value$plusargs("HQM_USE_TB_FUSE_VALUES=%d", has_default_early_fuses);

    default_early_fuses=0;
    if ($value$plusargs("HQM_TB_FUSE_VALUES=%h", default_early_fuses)) begin
      `ovm_info(get_full_name(),$psprintf("HQM_TB_FUSE_VALUES default value to drive early_fuses = 0x%0x", default_early_fuses),OVM_LOW)
      //`ovm_do_on_with(early_fuses_assert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==EARLY_FUSES_ASSERT; EarlyFuseIn_l==default_early_fuses;}); 
    end

    default_strap_no_mgmt_acks = 0;
    $value$plusargs("HQM_STRAP_NO_MGMT_ACKS=%d", default_strap_no_mgmt_acks);

    default_ip_ready = 1;
    $value$plusargs("HQM_USE_IP_READY=%d", default_ip_ready);

    has_false_fuses_after_ipready=0;
    $value$plusargs("HQM_FALSE_FUSE_AFTIPRDY=%d", has_false_fuses_after_ipready);

    `sla_assert($cast(agent_env, sla_utils::get_comp_by_name("hqm_agent_env_handle")), (("Could not find hqm_agent_env_handle\n")));
         
`ifdef IP_TYP_TE
    if (agent_env.hqmCfg.hqm_fuse_no_bypass == 0) begin
      `ovm_info(get_name(), "HQM fuse bypass enabled. Bypassing fuse pull", OVM_LOW)
      fork
        fuse_env = agent_env.get_fuse_env( ); 
        fbp_seq =  hqm_fuse_bypass_seq::type_id::create("fbp_seq");
        fbp_seq.set_sla_fuse_env(fuse_env); 
        `ovm_send(fbp_seq)
      join_none       
    end
`endif //`ifdef IP_TYP_TE
     
    if(has_default_early_fuses)  
       early_fuses_load_data = default_early_fuses;
    else                         
       early_fuses_load_data = early_fuses_load;

    `ovm_info(get_type_name(),$psprintf("Starting hqm_boot_sequence early_fuses_load=0x%0x default_early_fuses=0x%0x has_default_early_fuses=%0d, get early_fuses_load_data=0x%0x, has_false_fuses_after_ipready=%0d", early_fuses_load, default_early_fuses, has_default_early_fuses, early_fuses_load_data, has_false_fuses_after_ipready),OVM_LOW)

     
    // Deassert Powergood Reset
    `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Start powergood_deassert_seq", OVM_MEDIUM);
    `ovm_do_on_with(powergood_deassert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==POWER_GOOD_DEASSERT;}); 
    `ovm_info(get_type_name(),"completed powergood_deassert_seq", OVM_MEDIUM);

    // Deassert LCP Reset
    sla_vpi_put_value_by_name("hqm_tb_top.force_flcp_clk_en", 1'b1);
    if (en_lcp_shift_in) begin 
       `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Start hqm_lcp_reset_sequence with LCP_SHIFT_IN", OVM_MEDIUM);
       `ovm_do_on_with(lcp_reset_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==LCP_SHIFT_IN; LcpDatIn_l==lcp_shift_in_data;}); 
    end else if($test$plusargs("HQM_BYPASS_LCP_RESET")) begin 
       `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Start Bypass hqm_lcp_reset_sequence", OVM_MEDIUM);
    end else begin 
       `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Start hqm_lcp_reset_sequence with LCP_RESET", OVM_MEDIUM);
       LcpDatIn = {$urandom(), $urandom(), $urandom()};
       `ovm_do_on_with(lcp_reset_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==LCP_RESET; LcpDatIn_l==LcpDatIn;}); 
    end 
    sla_vpi_put_value_by_name("hqm_tb_top.force_flcp_clk_en", 1'b0);
    `ovm_info(get_type_name(),"completed lcp_reset_seq", OVM_MEDIUM);
    `ovm_info(get_type_name(),"Done with hqm_lcp_reset_sequence", OVM_LOW);

    // De assert all resets except Primary reset
    //  will try to load EarlyFuseIn_l==early_fuses_load
    `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Start reset_deassert_part1_seq", OVM_MEDIUM);
    `ovm_do_on_with(reset_deassert_part1_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==RESET_DEASSERT_PART1; EarlyFuseIn_l==early_fuses_load_data;}); 
    `ovm_info(get_type_name(),"completed reset_deassert_part1_seq", OVM_MEDIUM);

`ifdef IP_TYP_TE
    //--after fuse pull removed, there is no test to do default_ip_block_fp=1
    if (default_ip_block_fp == 1) begin
       hqm_tb_cfg_file_mode_seq boot_file_mode_seq;
       boot_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("boot_file_mode_seq");
       boot_file_mode_seq.set_cfg("HQM_BOOT_FILE", 1'b0);
       boot_file_mode_seq.start(get_sequencer());
       if (deassert_prim_rst_b==1) begin
         `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Start reset_deassert_part2_seq deassert prim_rst_b before fuse download", OVM_MEDIUM);
         `ovm_do_on_with(reset_deassert_part2_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==RESET_DEASSERT_PART2;}); 
       end  
       `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Start ip_block_fp_deassert_seq deassert prim_rst_b before fuse download", OVM_MEDIUM);
       `ovm_do_on_with(ip_block_fp_deassert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==IP_BLOCK_FP_DEASSERT;}); 
    end
`endif //`ifdef IP_TYP_TE



    if (default_ip_block_fp != 2) begin
      if (agent_env.hqmCfg.hqm_fuse_no_bypass == 1) begin
        if(default_ip_ready==0) begin 
           // wait for Fuse pull message if not bypassed
            hqm_fuse_download_req.wait_trigger();
           `ovm_info(get_type_name(),"Got hqm_fuse_download_req request", OVM_MEDIUM);
        end else begin
           `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Bypass hqm_fuse_download_req request, check ip_ready", OVM_MEDIUM);
           `ovm_do_on_with(ip_ready_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==IP_READY_RESP;}); 
           `ovm_info(get_type_name(),"Completed ip_ready_seq", OVM_MEDIUM);
        end
      end

      if(default_strap_no_mgmt_acks==1 || default_ip_ready==1) begin
         `ovm_do_on_with(ip_ready_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==IP_READY_RESP;}); 
         `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Completed ip_ready_seq resp", OVM_MEDIUM);

         if(has_false_fuses_after_ipready) begin
            //-- issue another early_fuses (shouldn't be sampled by RTL)
            early_fuses_rnd = $urandom_range(0, 16'hffff);
            `ovm_info(get_full_name(),$psprintf("HQM_BOOT_SEQ_After ip_ready asserted, issue a false EARLY_FUSES_ASSERT seq to drive early_fuses = 0x%0x", early_fuses_rnd),OVM_LOW)
            `ovm_do_on_with(early_fuses_assert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==EARLY_FUSES_ASSERT; EarlyFuseIn_l==early_fuses_rnd;}); 
         end 
      end else begin
         // Wait for IP_READY from IP
         hqm_ip_ready.wait_trigger();
         `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Got hqm_ip_ready request", OVM_MEDIUM);
      end

`ifdef IP_TYP_TE
      if (second_fuse_data_cmpl==1) begin
          `ovm_do(fuse_download_seq);
          `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Done fuse_download_seq ", OVM_MEDIUM);
      end
`endif
      if (agent_env.hqmCfg.hqm_fuse_no_bypass == 0) begin 
         if(default_ip_ready==0) begin
            // IF bypass set trigger for checkers
            hqm_fuse_download_req.trigger();
           `ovm_info(get_type_name(),"Got hqm_fuse_download_req trigger", OVM_MEDIUM);
         end else begin   
           `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Bypass hqm_fuse_download_req trigger, check ip_ready ", OVM_MEDIUM);
           `ovm_do_on_with(ip_ready_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==IP_READY_RESP;}); 
           `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Completed ip_ready_seq", OVM_MEDIUM);
         end
      end
    end

    // Deassert Primary reset
    if (deassert_prim_rst_b !=1) begin
      `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Start reset_deassert_part2_seq ", OVM_MEDIUM);
      `ovm_do_on_with(reset_deassert_part2_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==RESET_DEASSERT_PART2;}); 
      `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Completed reset_deassert_part2_seq", OVM_MEDIUM);
    end

`ifdef IP_TYP_TE
    //--after fuse pull removed, there is no test to do default_ip_block_fp=2
    if (default_ip_block_fp == 2) begin
      hqm_tb_cfg_file_mode_seq boot_file_mode_seq;

      boot_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("boot_file_mode_seq");
      boot_file_mode_seq.set_cfg("HQM_BOOT_FILE", 1'b0);
      boot_file_mode_seq.start(get_sequencer());

      `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Start ip_block_fp_deassert_seq ", OVM_MEDIUM);
      `ovm_do_on_with(ip_block_fp_deassert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==IP_BLOCK_FP_DEASSERT;}); 

      if (agent_env.hqmCfg.hqm_fuse_no_bypass == 1) begin
        if(default_ip_ready==0) begin 
            // wait for Fuse pull message if not bypassed
            hqm_fuse_download_req.wait_trigger();
            `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Got hqm_fuse_download_req request", OVM_MEDIUM);
        end else if(default_ip_ready==1) begin   
           `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Bypass hqm_fuse_download_req request when default_ip_block_fp=2, check ip_ready", OVM_MEDIUM);
           `ovm_do_on_with(ip_ready_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==IP_READY_RESP;}); 
           `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Completed ip_ready_seq", OVM_MEDIUM);
        end
      end

      if(default_ip_ready==1) begin
         `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Start ip_ready_seq ", OVM_MEDIUM);
         `ovm_do_on_with(ip_ready_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==IP_READY_RESP;}); 
         `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Completed ip_ready_seq", OVM_MEDIUM);
      end else begin
         // Wait for IP_READY from IP
         hqm_ip_ready.wait_trigger();
         `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Completed hqm_ip_ready triggered", OVM_MEDIUM);
      end

`ifdef IP_TYP_TE
      if (second_fuse_data_cmpl==1) begin
          `ovm_do(fuse_download_seq);
      end
`endif

      if (agent_env.hqmCfg.hqm_fuse_no_bypass == 0) begin
         if(default_ip_ready==0) begin
            // IF bypass set trigger for checkers
            hqm_fuse_download_req.trigger();
           `ovm_info(get_type_name(),"Got hqm_fuse_download_req trigger when default_ip_block_fp=2", OVM_MEDIUM);
         end else begin   
           `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Bypass hqm_fuse_download_req trigger when default_ip_block_fp=2, check ip_ready", OVM_MEDIUM);
           `ovm_do_on_with(ip_ready_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==IP_READY_RESP;}); 
           `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Completed ip_ready_seq", OVM_MEDIUM);
         end
      end   
      `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Got hqm_ip_ready request", OVM_MEDIUM);
    end
`endif //`ifdef IP_TYP_TE

    `ovm_info(get_type_name(),"HQM_BOOT_SEQ_Done with hqm_boot_sequence", OVM_LOW);

  endtask: body

endclass:hqm_boot_sequence

`endif

