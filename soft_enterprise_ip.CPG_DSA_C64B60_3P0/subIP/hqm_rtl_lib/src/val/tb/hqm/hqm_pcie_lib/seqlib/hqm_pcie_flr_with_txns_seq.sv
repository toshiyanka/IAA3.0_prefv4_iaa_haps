`ifndef HQM_PCIE_FLR_WITH_TXNS_SEQUENCE_
`define HQM_PCIE_FLR_WITH_TXNS_SEQUENCE_

typedef enum int {  CfgRd_in_FLR       = 0, 
                    CfgWr_in_FLR       = 1,
                    MRd64_in_FLR       = 2,
                    MWr64_in_FLR       = 3,
                    Cpl_in_FLR         = 4
                 } txn_type_in_flr_t ;

`include "stim_config_macros.svh"

class hqm_pcie_flr_with_txns_stim_config extends ovm_object;

  static string stim_cfg_name = "hqm_pcie_flr_with_txns_stim_config";
 
  rand  txn_type_in_flr_t txn_type_in_flr; 
  rand  int               num_txns_in_flr        ;

  `ovm_object_utils_begin(hqm_pcie_flr_with_txns_stim_config)
    `ovm_field_enum(txn_type_in_flr_t   , txn_type_in_flr,  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_txns_in_flr                               , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pcie_flr_with_txns_stim_config)
    `stimulus_config_field_rand_enum(txn_type_in_flr_t,  txn_type_in_flr)
    `stimulus_config_field_rand_int(num_txns_in_flr                             )
  `stimulus_config_object_utils_end
 
  constraint num_txns_in_flr_c      { soft num_txns_in_flr == 'h_1; }

  function new(string name = "hqm_pcie_flr_with_txns_stim_config");
    super.new(name); 
  endfunction

endclass : hqm_pcie_flr_with_txns_stim_config


class hqm_pcie_flr_with_txns_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_pcie_flr_with_txns_seq,sla_sequencer)

  hqm_sla_pcie_init_seq        i_init_seq;
  hqm_ue_cpl_seq               ue_cpl_seq;
  hqm_sla_pcie_flr_sequence    i_flr_trigger;

  rand logic [4:0]	func_no;
  
  constraint soft_qid_pri_type_c	{
	soft func_no	== 0;
	func_no inside { [0 : 16] };
  }

  rand hqm_pcie_flr_with_txns_stim_config cfg;
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pcie_flr_with_txns_stim_config);


  function new(string name = "hqm_pcie_flr_with_txns_seq");
    super.new(name);
    cfg = hqm_pcie_flr_with_txns_stim_config::type_id::create("hqm_pcie_flr_with_txns_stim_config"); 
    apply_stim_config_overrides(0);  // 0 means apply overrides for non-rand variables before seq.randomize() is called

  endfunction

  virtual task body();
	sla_ral_reg  reg_list[$];
	sla_ral_file reg_file;
    int          wait_clk_cfg_txn_in_pf_flr, wait_clk_cfg_txn_in_vf_flr, wait_clk_mem_txn_in_pf_flr, wait_clk_cpl_txn_in_pf_flr, wait_clk_cpl_txn_in_vf_flr;
    bit [31:0] write_data;
    
    apply_stim_config_overrides(1); // (1) below means apply overrides for random variables after seq.randomize() is called
     
    write_data =$urandom();

	if(!$value$plusargs("FLR_W_TXN_FUNC_NO=%d",func_no) && func_no==0 )
	  func_no = 1'b0;	//Set default if not specified on command line//


	`ovm_info(get_name(), $sformatf("Starting FLR check sequence with: func_no(%0d), write_data=%0h",func_no, write_data),OVM_LOW)

        // write the targeted register with some random value
        pf_cfg_regs.INT_LINE.write(status,write_data[7:0],primary_id);
        hqm_msix_mem_regs.MSG_DATA[0].write(status, write_data[31:0], primary_id);

        // check that startFLR bit is not set to 1
	    read_compare(pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL,16'h_0000,16'h_8000,result); //MaxPayloadSize supported is 256B->bit 5 is 1//

	    //Disable Bus Master, INTX and Mem Txn enable bit 
	    pf_cfg_regs.DEVICE_COMMAND.write(status,{1'b_1,10'h_0},primary_id,this,.sai(legal_sai));

	    //Disable MSI in order to avoid any unattended INT later
	    pf_cfg_regs.MSIX_CAP_CONTROL.write(status,16'h_0000,primary_id,this,.sai(legal_sai));

        // Start FLR
	    pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write(status,16'h_8000,primary_id,this,.sai(legal_sai));

	  `ovm_info(get_name(),$sformatf("Done with FLR "),OVM_LOW)


    // -- Default 10 clk ticks
    if (!p_sequencer.get_config_int("wait_clk_cfg_txn_in_pf_flr", wait_clk_cfg_txn_in_pf_flr))
        wait_clk_cfg_txn_in_pf_flr = 10; 

    // -- Default 10 clk ticks
    if (!p_sequencer.get_config_int("wait_clk_cfg_txn_in_vf_flr", wait_clk_cfg_txn_in_vf_flr))
        wait_clk_cfg_txn_in_vf_flr = 10; 

    // -- Default 10 clk ticks
    if (!p_sequencer.get_config_int("wait_clk_mem_txn_in_pf_flr", wait_clk_mem_txn_in_pf_flr))
        wait_clk_mem_txn_in_pf_flr = 10; 

    // -- Default 10 clk ticks
    if (!p_sequencer.get_config_int("wait_clk_cpl_txn_in_pf_flr", wait_clk_cpl_txn_in_pf_flr))
        wait_clk_cpl_txn_in_pf_flr = 10; 

    // -- Default 10 clk ticks
    if (!p_sequencer.get_config_int("wait_clk_cpl_txn_in_vf_flr", wait_clk_cpl_txn_in_vf_flr))
        wait_clk_cpl_txn_in_vf_flr = 10; 

    `ovm_info(get_full_name(),$sformatf("Received cfg.txn_type_in_flr (0x%0x)", cfg.txn_type_in_flr),OVM_LOW)
    `ovm_info(get_full_name(),$sformatf("Received cfg.num_txns_in_flr (0x%0x)", cfg.num_txns_in_flr),OVM_LOW)
    `ovm_info(get_full_name(),$sformatf("Received wait_clk_cfg_txn_in_pf_flr (%0d)",wait_clk_cfg_txn_in_pf_flr),OVM_LOW)
    `ovm_info(get_full_name(),$sformatf("Received wait_clk_cfg_txn_in_vf_flr (%0d)",wait_clk_cfg_txn_in_vf_flr),OVM_LOW)
    `ovm_info(get_full_name(),$sformatf("Received wait_clk_mem_txn_in_pf_flr (%0d)",wait_clk_mem_txn_in_pf_flr),OVM_LOW)

    // -- Waiting for HQM to enter FLR and send txn when in FLR
    wait_sys_clk(30); 

    // send transactions to non FLR funcitons in background
    fork begin 
        send_txn_to_non_flr_func(); 
    end 
    join_none

    case (cfg.txn_type_in_flr)
        CfgRd_in_FLR: begin 
                   wait_sys_clk(wait_clk_cfg_txn_in_pf_flr); 
                   repeat(cfg.num_txns_in_flr) send_tlp(get_tlp(ral.get_addr_val(primary_id,pf_cfg_regs.INT_LINE), Iosf::CfgRd0), .skip_ur_chk(1));
                  // fork begin////pf_cfg_regs.INT_LINE.read(status,rd_val,primary_id);//send_rd(pf_cfg_regs.INT_LINE);// end// join_none 
	       	   hqm_env.hqm_agent_env_handle.iosf_pvc.iosfFabCfg.iosfAgtCfg[0].Disable_Final_Checks=1'b_1;
	       	   hqm_env.hqm_agent_env_handle.iosf_pvc.iosfFabCfg.iosfAgtCfg[1].Disable_Final_Checks=1'b_1;
           end
        CfgWr_in_FLR: begin 
               write_data =$urandom();
                   wait_sys_clk(wait_clk_cfg_txn_in_pf_flr);  
                   repeat(cfg.num_txns_in_flr) send_tlp(get_tlp(ral.get_addr_val(primary_id,pf_cfg_regs.INT_LINE), Iosf::CfgWr0, .i_data({24'h0,write_data[7:0]})), .skip_ur_chk(1));
                  // fork begin // //pf_cfg_regs.INT_LINE.write(status,'h_55,primary_id);// send_wr(pf_cfg_regs.INT_LINE, write_data[7:0]); // end // join_none 
			   hqm_env.hqm_agent_env_handle.iosf_pvc.iosfFabCfg.iosfAgtCfg[0].Disable_Final_Checks=1'b_1;
			   hqm_env.hqm_agent_env_handle.iosf_pvc.iosfFabCfg.iosfAgtCfg[1].Disable_Final_Checks=1'b_1;

           end
        MRd64_in_FLR: begin 
                   wait_sys_clk(wait_clk_mem_txn_in_pf_flr);  
                   repeat(cfg.num_txns_in_flr) send_tlp(get_tlp(ral.get_addr_val(primary_id,hqm_msix_mem_regs.MSG_DATA[0]), Iosf::MRd64), .skip_ur_chk(1));
                  // fork begin   ////hqm_msix_mem_regs.MSG_DATA[0].read(status, rd_val, primary_id); // send_rd(hqm_msix_mem_regs.MSG_DATA[0]); // end //join_none 
           end
        MWr64_in_FLR: begin 
                   wait_sys_clk(wait_clk_mem_txn_in_pf_flr);  
                   //hqm_msix_mem_regs.MSG_DATA[0].write(status, 'h_5555, primary_id);
                   repeat(cfg.num_txns_in_flr) send_wr(hqm_msix_mem_regs.MSG_DATA[0], 'h_5555);
           end
        Cpl_in_FLR: begin 
               sla_ral_addr_t ue_req_id;

                   wait_sys_clk(wait_clk_cpl_txn_in_pf_flr); 

               ue_req_id = func_no ;
               `ovm_info(get_full_name(),$psprintf("Starting hqm_pcie_flr_with_txns_seq with: ue_req_id (0x%0x)",ue_req_id),OVM_LOW)
               repeat(cfg.num_txns_in_flr) `ovm_do_on_with(ue_cpl_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_req_id == ue_req_id; iosf_cpl_status == 'h_0;})

			   hqm_env.hqm_agent_env_handle.iosf_pvc.iosfFabCfg.iosfAgtCfg[0].Disable_Final_Checks=1'b_1;
			   hqm_env.hqm_agent_env_handle.iosf_pvc.iosfFabCfg.iosfAgtCfg[1].Disable_Final_Checks=1'b_1;
           end
    endcase

    // wait for FLR to complete
    wait_sys_clk(7000);  

    // -- Read and check write had no effect after FLR is complete
        case (cfg.txn_type_in_flr)
            // Cfg Rd, Wr
        CfgRd_in_FLR, CfgWr_in_FLR, Cpl_in_FLR: begin 
                 read_compare(pf_cfg_regs.INT_LINE,'h_0,8'h_ff,result);
                 `ovm_do(i_init_seq);
             end
            // Mem Rd, Wr
        MRd64_in_FLR, MWr64_in_FLR: begin
                 `ovm_do(i_init_seq);
                 read_compare(hqm_msix_mem_regs.MSG_DATA[0],'h_0,32'h_ffffffff,result);
             end
        endcase

    `ovm_info(get_full_name(),$psprintf("Done with hqm_pcie_flr_with_txns_seq "),OVM_LOW)
  endtask

  task wait_sys_clk(int ticks=10);
   repeat(ticks) begin @(sla_tb_env::sys_clk_r); end
  endtask

  task send_txn_to_non_flr_func();
    sla_ral_data_t _vf_data_='h_4;
    bit [31:0] write_data1;

    write_data1 =$urandom();

      `ovm_info(get_full_name(),$psprintf("Skipping sending Txns to any function as FLR function num (0x%0x) -> All Functions FLR (IOV spec)",func_no),OVM_LOW);

  endtask

endclass

`endif
