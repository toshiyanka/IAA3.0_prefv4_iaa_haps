//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2015 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------

`ifndef HQM_SLA_PCIE_FLR_SEQUENCE__SV
`define HQM_SLA_PCIE_FLR_SEQUENCE__SV

//------------------------------------------------------------------------------
// File        : hqm_sla_pcie_flr_sequence.sv
// Author      : Neeraj Shete
//
// Description : This sequence issues FLR to a function within HQM.
//               Control parameters as below,
//               - func_no     (0-16) -> Targeted function number.
//               - test_regs   (0-1)  -> If 1, test reset values post FLR.
//               - no_sys_init (0-1)  -> If 0, do pcie init after PF FLR.
//               - flr_in_d3hot (0-1)  -> If 1, skip mmio accesses.
//------------------------------------------------------------------------------

class hqm_sla_pcie_flr_sequence extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_flr_sequence,sla_sequencer)

  hqm_sla_pcie_init_seq    sys_init;
  hqm_sla_pcie_bar_cfg_seq pcie_bar_cfg_seq;
  hqm_cfg                  i_hqm_cfg;

  ovm_event_pool glbl_pool;
  ovm_event      ep_start_of_flr[`MAX_NO_OF_VFS+1];
  ovm_event      ep_end_of_flr[`MAX_NO_OF_VFS+1];

  rand logic [4:0]	func_no;
  rand	bit			test_regs;
  rand	bit			no_sys_init;
  rand  bit     flr_in_d3hot;
  
  constraint soft_qid_pri_type_c	{
    soft func_no	 == 0;
    soft test_regs	 == 0;
    soft no_sys_init == 0;
    soft flr_in_d3hot == 0;
	func_no inside { [0 : 16] };
  }

  function new(string name = "hqm_sla_pcie_flr_sequence");
    super.new(name);
    i_hqm_cfg = hqm_cfg::get();

    glbl_pool        = ovm_event_pool::get_global_pool();

    // -- Start/End of FLR events -- //
    foreach(ep_start_of_flr[i]) begin
      ep_start_of_flr[i] = glbl_pool.get($psprintf("ep_start_of_flr_func_%0d",i));
      ep_end_of_flr[i]   = glbl_pool.get($psprintf("ep_end_of_flr_func_%0d",i));
    end

  endfunction

  virtual task body();
    sla_ral_reg reg_list[$];
    sla_ral_file reg_file;

    test_regs |= $value$plusargs("func_no=%d",func_no);

    if(!$value$plusargs("func_no=%d",func_no) && func_no==0 )
	   func_no = 1'b0;	// -- Set default if not specified on command line -- //

          `ovm_info(get_name(), $sformatf("Starting FLR check sequence with: func_no(%0d) and test_regs(%0d)",func_no,test_regs),OVM_LOW)

           ep_start_of_flr[func_no].trigger();

             `ovm_info(get_name(), $sformatf("Starting FLR check sequence with: func_no(%0d)",func_no),OVM_LOW)

	     // -- Check if any transactions are pending, proceed only if none// -- 
             if($test$plusargs("SKIP_POLL_PCIE_CAP_DEVICE_STATUS")) begin
	       `ovm_info(get_name(),$sformatf("Before issuing FLRRST, Skip Poll PCIE_CAP_DEVICE_STATUS"),OVM_LOW)
             end else begin
	       `ovm_info(get_name(),$sformatf("Before issuing FLRRST, Poll PCIE_CAP_DEVICE_STATUS"),OVM_LOW)
	        poll_reg_val(pf_cfg_regs.PCIE_CAP_DEVICE_STATUS,32'h_0,32'h_0020_0000,10000);
             end

	     // -- Disable MSI in order to avoid any unattended INT later// -- 
	    `ovm_info(get_name(),$sformatf("Before issuing FLRRST, MSIX_CAP_CONTROL Disable MSI"),OVM_LOW)
	     pf_cfg_regs.MSIX_CAP_CONTROL.write(status,16'h_0000,primary_id,this,.sai(legal_sai));

	     // -- Disable Bus Master, INTX and Mem Txn enable bit from device_command// -- 
             if($test$plusargs("bme_enable")) begin 
	       `ovm_info(get_name(),$sformatf("Before issuing FLRRST, BME=Enabled"),OVM_LOW)
             end else begin 
	       `ovm_info(get_name(),$sformatf("Before issuing FLRRST, BME=Disabled"),OVM_LOW)
	        pf_cfg_regs.DEVICE_COMMAND.write(status,{1'b_1,10'h_0},primary_id,this,.sai(legal_sai));
             end  

	    `ovm_info(get_name(),$sformatf("Issue FLR withPCIE_CAP_DEVICE_CONTROL[15]=1 "),OVM_LOW)
	     pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write(status,16'h_8000,primary_id,this,.sai(legal_sai));

	    `ovm_info(get_name(),$sformatf("Waiting 200ns for FLR to complete"),OVM_LOW)
	     repeat(100) wait_ns_clk(70); // -- Although FLR requirement is 100ms, dev driver is aware of the time required --//

	     // -- Get regsiters within FLRed function for reset checks. Done if 'test_regs == 1'. -- //
	     pf_cfg_regs.get_regs(reg_list); 
	  

          //****** Start reset val check for reg list ******//

          if(func_no == 0) begin 
            if (!no_sys_init)  begin 
	      `ovm_info(get_name(), $sformatf("Restoring device for previous config after FLR of func #(%0d).",func_no),OVM_LOW)
              `ovm_do_with(sys_init, {sys_init.cfg.skip_pmcsr_disable==1;});
               // -- Reinit hqm_chp_pipe memories -- //
               // -- `ovm_info(get_full_name(), $psprintf("Start backdoor init of memories after PF FLR as hqm_proc is reset !"), OVM_LOW)
               // -- i_hqm_cfg.backdoor_mem_init(); 
               // -- `ovm_info(get_full_name(), $psprintf("Done backdoor init of memories after PF FLR as hqm_proc is reset !"), OVM_LOW)
            end  
         end

    ep_end_of_flr[func_no].trigger();

  endtask


endclass

`endif
