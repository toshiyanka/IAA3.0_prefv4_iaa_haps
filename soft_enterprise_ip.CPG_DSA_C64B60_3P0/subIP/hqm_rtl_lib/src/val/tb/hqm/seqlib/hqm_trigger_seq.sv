// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
// File   : hqm_trigger_seq.sv
// Author : dsuvvari 
//
// Description :
//
//   Hqm trigger scenario seq
//	 1. Boot up hqm.
//	 2. Configure CFG_MASTER_TRIGGER_CTL to 10'h3ff.
//	 3. clear CFG_PM_PMCSR_DISABLE[0]
//	 4. Issue 4000 prim_clks. Monitor hqm_triggers. Send Jerry the vpd.  If he approves the hqm_trigger wavefors, , make the "post- CFG_PM_PMCSR_DISABLE clear" hqm_trigger trace the "expected result." Use the1st hqm_trigger transition after clearing PMCSR_DISABLE the beginning of the "defined expected result " to avoid false failures due to TB  timing changes (e.g. initialization, different preambles, ¿)

//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_trigger_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_trigger_seq_stim_config";

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";
  rand bit                      skip_pmcsr_disable       ;  
  rand bit                      trigger_on;  
  rand bit                      issue_hw_reset_force_pwr_on;  


  `ovm_object_utils_begin(hqm_trigger_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(skip_pmcsr_disable , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(trigger_on ,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(issue_hw_reset_force_pwr_on , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_trigger_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(skip_pmcsr_disable)
    `stimulus_config_field_rand_int(trigger_on)
    `stimulus_config_field_rand_int(issue_hw_reset_force_pwr_on)
  `stimulus_config_object_utils_end

  constraint _pmcsr_dis_    { soft skip_pmcsr_disable == 1'b_0; }
  constraint trigger_on_c   { soft trigger_on == 1'b_1; }
  constraint hw_reset_force_pwr_on_c    { soft issue_hw_reset_force_pwr_on == 1'b_0; }


  function new(string name = "hqm_trigger_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_trigger_seq_stim_config

class hqm_trigger_seq extends hqm_sla_pcie_base_seq;
  `ovm_object_utils(hqm_trigger_seq)

  rand hqm_trigger_seq_stim_config        cfg;

  hcw_sciov_test_cfg_seq                i_hcw_sciov_test_cfg_seq;
  hcw_sciov_test_hcw_seq                i_hcw_sciov_test_hcw_seq;

  hqm_sla_pcie_init_seq                 hqm_pcie_init;
  
  hqm_hw_agitate_seq                    agitate_seq;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_trigger_seq_stim_config);

  function new(string name = "hqm_trigger_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name); 

    cfg = hqm_trigger_seq_stim_config::type_id::create("i_hqm_trigger_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();

endclass : hqm_trigger_seq

task hqm_trigger_seq::body();
    bit [31:0] cfg_master_ctl_wr_data;
    int  trigger_count[10], trigger_count_t[10];
  
    `ovm_info(get_full_name(),$sformatf("\n hqm_trigger_seq started \n"),OVM_LOW)
    apply_stim_config_overrides(1);
    
    `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
    	
    pf_cfg_regs.FUNC_BAR_L.write(status,32'h_00000000,primary_id,this,.sai(legal_sai));
    pf_cfg_regs.FUNC_BAR_U.write(status,32'h_00000001,primary_id,this,.sai(legal_sai));
 
    pf_cfg_regs.CSR_BAR_L.write(status,32'h_0000_0000,primary_id,this,.sai(legal_sai));
    pf_cfg_regs.CSR_BAR_U.write(status,32'h_00000002,primary_id,this,.sai(legal_sai));

    pf_cfg_regs.DEVICE_COMMAND.write(status,32'h_00000046,primary_id,this,.sai(legal_sai));

    //4000 prim_clk = 4000*1.25ns = 5000ns
    //wait_ns_clk(5000);

    `ovm_info(get_full_name(),$sformatf("\n hqm_trigger_seq start counting\n"),OVM_LOW)
    fork 
    begin
       if(cfg.trigger_on == 1'b_1) begin
          // Should instead use RTDR taptrigger register
          //master_regs.CFG_MASTER_TRIGGER_CTL.write(status,10'h_3ff, iosf_sb_sla_pkg::get_src_type(),this,.sai(legal_sai));
          //master_regs.CFG_MASTER_TRIGGER_CTL.readx(status, 10'h_3ff,10'h_3ff,rd_val, iosf_sb_sla_pkg::get_src_type(),.sai(legal_sai));

          //VISA_SW_CONTROL[1]=SW_TRIGGER, VISA_SW_CONTROL[2]=PH_TRIGGER_ENABLE
          `ovm_info(get_full_name(), $psprintf("trigger_on:: hqm_sif_csr_regs.VISA_SW_CONTROL"), OVM_LOW);
          hqm_sif_csr_regs.VISA_SW_CONTROL.write(status,32'h_6, iosf_sb_sla_pkg::get_src_type(),this,.sai(legal_sai));
          hqm_sif_csr_regs.VISA_SW_CONTROL.readx(status,32'h_6, 32'h_6,rd_val, iosf_sb_sla_pkg::get_src_type(),.sai(legal_sai));
       end else begin
          `ovm_info(get_full_name(), $psprintf("Bypass trigger_on setting"), OVM_LOW);
       end

       if(cfg.skip_pmcsr_disable == 1'b_0) begin
          `ovm_info(get_full_name(), $psprintf("CFG_PM_PMCSR_DISABLE=0"), OVM_LOW);
          master_regs.CFG_PM_PMCSR_DISABLE.write(status,32'h_0,primary_id,this,.sai(legal_sai));
          read_compare(master_regs.CFG_PM_PMCSR_DISABLE,32'h_0,.result(result));
          poll_reg_val(master_regs.CFG_DIAGNOSTIC_RESET_STATUS,'h_8000_0bff,'h_ffff_ffff,1000);
       end else begin
          `ovm_info(get_full_name(), $psprintf("Bypass CFG_PM_PMCSR_DISABLE=0"), OVM_LOW);
       end

       wait_ns_clk(20); 
      `ovm_do(hqm_pcie_init);

       //--HW agitator configuration--//
      `ovm_do_with(agitate_seq, {{agitate_seq.start_stop == START};})

       wait_ns_clk(20); 
      `ovm_do(i_hcw_sciov_test_cfg_seq); 

       wait_ns_clk(20); 
      `ovm_do(i_hcw_sciov_test_hcw_seq);

       wait_ns_clk(15000);
      `ovm_info(get_full_name(),$sformatf("\n trigger_count[0]=%0d \n", trigger_count[0]),OVM_LOW)
    end

    begin
        for (int i=0;i<10;i++) begin
            fork
            begin
                automatic int j = i;
                forever begin
                    @(posedge pins.hqm_triggers[j]);
                    trigger_count_t[j]++;
                end
            end
            join_none
        end
        wait fork;
    end
    begin
        forever begin
            @(posedge pins.hqm_triggers[0]);
            trigger_count[0]++;
        end
    end
    begin
        forever begin
            @(posedge pins.hqm_triggers[1]);
            trigger_count[1]++;
        end
    end
    begin
        forever begin
            @(posedge pins.hqm_triggers[2]);
            trigger_count[2]++;
        end
    end
    begin
        forever begin
            @(posedge pins.hqm_triggers[3]);
            trigger_count[3]++;
        end
    end
    begin
        forever begin
            @(posedge pins.hqm_triggers[4]);
            trigger_count[4]++;
        end
    end
    begin
        forever begin 
            //--bit5=1 always
            if(pins.hqm_triggers[5]==1'b1) trigger_count[5]++;
            @(posedge pins.hqm_triggers[5]);
            trigger_count[5]++;
        end
    end
    begin
        forever begin
            //--bit6=1 always
            if(pins.hqm_triggers[6]==1'b1) trigger_count[6]++;
            @(posedge pins.hqm_triggers[6]);
            trigger_count[6]++;
        end
    end
    begin
        forever begin
            @(posedge pins.hqm_triggers[7]);
            trigger_count[7]++;
        end
    end
    begin
        forever begin
            @(posedge pins.hqm_triggers[8]);
            trigger_count[8]++;
        end
    end
    begin
        forever begin
            @(posedge pins.hqm_triggers[9]);
            trigger_count[9]++;
        end
    end
    join_any
    for (int i=0;i<10;i++) begin
        if (trigger_count[i]==0 && cfg.trigger_on==1) begin
             `ovm_error(get_full_name(),$psprintf("trigger_count[%0d] is %0d. should have triggered according to configuration  ", i, trigger_count[i]))
        end
        `ovm_info(get_full_name(),$sformatf("\n trigger_count[%0d]=%0d, trigger_count_t[i]=%0d \n", i, trigger_count[i], trigger_count_t[i]),OVM_LOW)
    end
     
    `ovm_info(get_full_name(),$sformatf("\n hqm_trigger_seq ended\n"),OVM_LOW)
endtask : body
