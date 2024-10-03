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
// File   : hqm_pwr_prochot_user_data_seq.sv
// Author : rsshekha
// Description :
//
//   prochot assertion deassertion seq.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------
`include "stim_config_macros.svh"

typedef enum int {
    TOGGLE_PROCHOT           = 0,
    TGL_PH_AFTER_ENQ_DIR     = 1,
    TGL_PH_AFTER_ENQ_LDB     = 2, 
    TGL_PH_AFTER_DEQ_DIR     = 3, 
    TGL_PH_AFTER_DEQ_LDB     = 4,
    TGL_PH_AFTER_PCIE_CFG_RD = 5,
    TGL_PH_AFTER_MMIO_CFG_RD = 6,
    TGL_PH_AFTER_MMIO_CFG_WR = 7,
    TGL_PH_AFTER_PCIE_CFG_WR = 8,
    SKIP                    = 9
}  prochot_variation_t;

class hqm_pwr_prochot_user_data_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pwr_prochot_user_data_seq_stim_config";

  `ovm_object_utils_begin(hqm_pwr_prochot_user_data_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(check_phcnt_regs,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(seq_num,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_enum(prochot_variation_t, ph_var,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(prochot_disable,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pwr_prochot_user_data_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(check_phcnt_regs)
    `stimulus_config_field_rand_int(seq_num)
    `stimulus_config_field_rand_enum(prochot_variation_t, ph_var)
    `stimulus_config_field_rand_int(prochot_disable)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";
  rand int                      check_phcnt_regs = 0;
  rand int                      seq_num = 0;
  rand int                      prochot_disable;
  rand prochot_variation_t ph_var = TOGGLE_PROCHOT;
  constraint soft_check_phcnt_regs { soft check_phcnt_regs == 0;}       
  constraint soft_ph_var { soft ph_var == TOGGLE_PROCHOT;}       
  constraint soft_seq_num { soft seq_num == 5;}       
  constraint soft_ph_cfgdis { soft prochot_disable == 0;}       

  function new(string name = "hqm_pwr_prochot_user_data_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pwr_prochot_user_data_seq_stim_config

class hqm_pwr_prochot_user_data_seq extends hqm_pwr_base_seq;
  `ovm_sequence_utils(hqm_pwr_prochot_user_data_seq,sla_sequencer)

  int random_number = 0;

  bit [63:0] ph_event_cnt = 64'h0;
  bit [63:0] ph_event_init_val = 64'h0;
  bit [63:0] ph_high_clk_cnt = 64'h0;
  bit [63:0] ph_high_clk_cnt_init_val = 64'h0;
  bit [63:0] ph_high_clk_cnt_reg_val = 64'h0;
  bit [63:0] proc_on_clk_cnt_init_val = 64'h0;
  bit [63:0] proc_on_clk_cnt_reg_val = 64'h0;
  bit [63:0] clk_on_cnt_init_val = 64'h0;
  bit [63:0] clk_on_cnt_reg_val = 64'h0;
  bit [63:0] prochot_cnt_save = 64'h0;
  bit [63:0] prochot_event_cnt_save = 64'h0;
  bit [63:0] prochot_on_cnt_save = 64'h0;

  rand hqm_pwr_prochot_user_data_seq_stim_config        cfg;

    hqm_tb_cfg_file_mode_seq i_usr_file_mode_seq;

    `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pwr_prochot_user_data_seq_stim_config);

  function new(string name = "hqm_pwr_prochot_user_data_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_pwr_prochot_user_data_seq_stim_config::type_id::create("hqm_pwr_prochot_user_data_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction


  extern virtual task body();

  extern virtual task drive_ph_and_update_counters(int val = 0, int dly_min = 100, int dly_max = 400, int skip_wait = 0);

  extern virtual task drv_ph_and_chk_ph_reg_field();

  extern virtual task prochot_process();
endclass : hqm_pwr_prochot_user_data_seq


//----------------------------------------------------
task hqm_pwr_prochot_user_data_seq::drive_ph_and_update_counters(int val = 0, int dly_min = 100, int dly_max = 400, int skip_wait = 0); 
  pins.prochot = val;
  random_number = $urandom_range(dly_min,dly_max);
  if (val) begin 
     ph_event_cnt = ph_event_cnt + 64'h1;
     ph_high_clk_cnt = ph_high_clk_cnt + random_number;
     `ovm_info(get_full_name(),$sformatf("ph_high_clk_cnt=%d, random_number = %d",ph_high_clk_cnt, random_number),OVM_LOW)
  end
  if (!skip_wait) begin 
     wait_for_clk(random_number);
  end 
endtask : drive_ph_and_update_counters

//----------------------------------------------------
task hqm_pwr_prochot_user_data_seq::drv_ph_and_chk_ph_reg_field();
  pins.prochot = 1'b1;
  if(cfg.prochot_disable==0)
     compare("config_master","cfg_pm_status","prochot",SLA_FALSE,1'b1);
  else
     compare("config_master","cfg_pm_status","prochot",SLA_FALSE,1'b0);

  pins.prochot = 1'b0;
  compare("config_master","cfg_pm_status","prochot",SLA_FALSE,1'b0);
endtask: drv_ph_and_chk_ph_reg_field

//----------------------------------------------------
task hqm_pwr_prochot_user_data_seq::prochot_process();
  sla_ral_data_t   rd_data;

  `ovm_info(get_full_name(),$sformatf("prochot_process:: cfg.ph_var=%s",cfg.ph_var),OVM_LOW)

  case(cfg.ph_var)

      TOGGLE_PROCHOT: begin    
         `ovm_info(get_full_name(),$sformatf("\n TOGGLE_PROCHOT started \n"),OVM_LOW)

         `ovm_info(get_full_name(),$sformatf("cfg.seq_num=%d",cfg.seq_num),OVM_LOW)

         repeat (cfg.seq_num) begin 
            drive_ph_and_update_counters(.val(1));
            drive_ph_and_update_counters(.val(0));
            drive_ph_and_update_counters(.val(1));
            drive_ph_and_update_counters(.val(0));
         end 

         `ovm_info(get_full_name(),$sformatf("\n TOGGLE_PROCHOT ended \n"),OVM_LOW)
      end 

      // use registers cfg_qid_dir_tot_enq_cntl & all to see that what is the state of hcws
      // e) Enque legal HCW form PP to hqm; Dequed from the CQ; assert PROC_HOT; completion & token return should not be effected by CT;
      // f) Enque legal HCWs form PP to hqm; before dequed from CQ; assert PROC_HOT;
      // pins.prochot = '1;
      TGL_PH_AFTER_ENQ_DIR: begin 
         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_ENQ_DIR started \n"),OVM_LOW)

         while (!(rd_data > 0)) begin   
              ReadReg("list_sel_pipe","cfg_qid_dir_enqueue_count[0]",SLA_FALSE,rd_data);
              `ovm_info(get_full_name(),$sformatf("cfg_qid_dir_enqueue_count[0]=%h",rd_data),OVM_LOW)
         end

         WriteField("list_sel_pipe","cfg_cq_dir_disable[0]","disabled",1'b0);
         read_and_check_reg("list_sel_pipe","cfg_cq_dir_disable[0]",SLA_FALSE,rd_data);

         drive_ph_and_update_counters(.val(1));
         drive_ph_and_update_counters(.val(0),.skip_wait(1));

         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_ENQ_DIR ended \n"),OVM_LOW)
      end   

      TGL_PH_AFTER_ENQ_LDB: begin 
         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_ENQ_LDB started \n"),OVM_LOW)

         while (!(rd_data > 0)) begin   
              ReadReg("list_sel_pipe","cfg_qid_ldb_enqueue_count[0]",SLA_FALSE,rd_data);
              `ovm_info(get_full_name(),$sformatf("cfg_qid_ldb_enqueue_count[0]=%h",rd_data),OVM_LOW)
         end

         WriteField("list_sel_pipe","cfg_cq_ldb_disable[0]","disabled",1'b0);
         read_and_check_reg("list_sel_pipe","cfg_cq_ldb_disable[0]",SLA_FALSE,rd_data);

         drive_ph_and_update_counters(.val(1));
         drive_ph_and_update_counters(.val(0),.skip_wait(1));

         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_ENQ_LDB ended \n"),OVM_LOW)
      end   

      TGL_PH_AFTER_DEQ_DIR: begin 
         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_DEQ_DIR started \n"),OVM_LOW)

         WriteField("list_sel_pipe","cfg_cq_dir_disable[0]","disabled",1'b0);
         read_and_check_reg("list_sel_pipe","cfg_cq_dir_disable[0]",SLA_FALSE,rd_data);

         while (!(rd_data > 0)) begin   
              ReadReg("list_sel_pipe","cfg_cq_dir_tot_sch_cntl[0]",SLA_FALSE,rd_data);
              `ovm_info(get_full_name(),$sformatf("cfg_cq_dir_tot_sch_cntl[0]=%h",rd_data),OVM_LOW)
         end

         drive_ph_and_update_counters(.val(1));
         drive_ph_and_update_counters(.val(0),.skip_wait(1));

         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_DEQ_DIR ended \n"),OVM_LOW)
      end  

      TGL_PH_AFTER_DEQ_LDB: begin 
         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_DEQ_LDB started \n"),OVM_LOW)

         WriteField("list_sel_pipe","cfg_cq_ldb_disable[0]","disabled",1'b0);
         read_and_check_reg("list_sel_pipe","cfg_cq_ldb_disable[0]",SLA_FALSE,rd_data);

         while (!(rd_data > 0)) begin   
              ReadReg("list_sel_pipe","cfg_cq_ldb_inflight_count[0]",SLA_FALSE,rd_data);
              `ovm_info(get_full_name(),$sformatf("cfg_cq_ldb_inflight_count[0]=%h",rd_data),OVM_LOW)
         end

         drive_ph_and_update_counters(.val(1));
         drive_ph_and_update_counters(.val(0),.skip_wait(1));

         `ovm_info(get_full_name(),$sformatf("\n  TGL_PH_AFTER_DEQ_LDB ended \n"),OVM_LOW)
      end

      TGL_PH_AFTER_PCIE_CFG_RD: begin     
         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_PCIE_CFG_RD started \n"),OVM_LOW)

          fork

             begin ReadReg("hqm_pf_cfg_i","device_command",SLA_FALSE,rd_data); 
               `ovm_info(get_full_name(),$sformatf("device_command=%h",rd_data),OVM_LOW)
             end 

             begin wait_for_clk(2); 
                   drive_ph_and_update_counters(.val(1));
                   drive_ph_and_update_counters(.val(0),.skip_wait(1));
             end 

          join 

         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_PCIE_CFG_RD ended \n"),OVM_LOW)
      end   

      TGL_PH_AFTER_MMIO_CFG_RD: begin     
         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_MMIO_CFG_RD started \n"),OVM_LOW)

          fork 

             begin ReadReg("config_master","cfg_pm_status",SLA_FALSE,rd_data); 
               `ovm_info(get_full_name(),$sformatf("cfg_pm_status=%h",rd_data),OVM_LOW)
             end 

             begin wait_for_clk(2); 
                   drive_ph_and_update_counters(.val(1));
                   drive_ph_and_update_counters(.val(0),.skip_wait(1));
             end 

          join 

         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_MMIO_CFG_RD ended \n"),OVM_LOW)
      end 

      TGL_PH_AFTER_MMIO_CFG_WR: begin     
         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_MMIO_CFG_WR started \n"),OVM_LOW)

          fork

             begin WriteReg("credit_hist_pipe","cfg_patch_control",32'h39); end 

             begin wait_for_clk(2); 
                   drive_ph_and_update_counters(.val(1));
                   drive_ph_and_update_counters(.val(0),.skip_wait(1));
             end 

          join

          ReadReg("credit_hist_pipe","cfg_patch_control",SLA_FALSE,rd_data);

          if (rd_data != 32'h39) begin 
             `ovm_error(get_full_name(),$sformatf(" cfg_patch_control write data 0x39 doesn't match read data 0x%h", rd_data))
          end  

         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_MMIO_CFG_WR ended \n"),OVM_LOW)
      end   

      TGL_PH_AFTER_PCIE_CFG_WR: begin     
         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_PCIE_CFG_WR started \n"),OVM_LOW)

          fork 

             begin WriteReg("hqm_pf_cfg_i","cache_line_size",8'h4); end 

             begin wait_for_clk(2); 
                   drive_ph_and_update_counters(.val(1));
                   drive_ph_and_update_counters(.val(0),.skip_wait(1));
             end 

          join   

          ReadReg("hqm_pf_cfg_i","cache_line_size",SLA_FALSE,rd_data);

          if (rd_data != 32'h4) begin 
             `ovm_error(get_full_name(),$sformatf(" cache_line_size write data 0x4 doesn't match read data 0x%h", rd_data))
          end 

         `ovm_info(get_full_name(),$sformatf("\n TGL_PH_AFTER_PCIE_CFG_WR ended \n"),OVM_LOW)
      end

      SKIP: 
         `ovm_info(get_full_name(),$sformatf("\n prochot thread skipped \n"),OVM_LOW)

   endcase
endtask:prochot_process

//----------------------------------------------------
task hqm_pwr_prochot_user_data_seq::body();
  sla_ral_data_t   rd_data;
  // configure the pcie; Move hqm from D0uninit to D0active
  // configure the hqm;

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_prochot_user_data_seq started \n"),OVM_LOW)
  `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
  apply_stim_config_overrides(1);
  ral_access_path = cfg.access_path;
  base_tb_env_hier = cfg.tb_env_hier;

  // enable the clock cnt for prochot events and check it.  
  `ovm_info(get_full_name(),$sformatf("cfg.check_phcnt_regs=%d",cfg.check_phcnt_regs),OVM_LOW)

  if (!cfg.check_phcnt_regs) begin 

     WriteField("config_master","cfg_clk_cnt_disable","disable",1'b1);
     read_and_check_reg("config_master","cfg_clk_cnt_disable",SLA_FALSE,rd_data);

     ReadReg("config_master","cfg_prochot_event_cnt_l",SLA_FALSE,rd_data);
     ph_event_init_val[31:0] = rd_data[31:0];
     ReadReg("config_master","cfg_prochot_event_cnt_h",SLA_FALSE,rd_data);
     ph_event_init_val[63:32] = rd_data[31:0];

     ReadReg("config_master","cfg_prochot_cnt_l",SLA_FALSE,rd_data);
     ph_high_clk_cnt_init_val[31:0] = rd_data[31:0];
     ReadReg("config_master","cfg_prochot_cnt_h",SLA_FALSE,rd_data);
     ph_high_clk_cnt_init_val[63:32] = rd_data[31:0];

     ReadReg("config_master","cfg_proc_on_cnt_l",SLA_FALSE,rd_data);
     proc_on_clk_cnt_init_val[31:0] = rd_data[31:0];
     ReadReg("config_master","cfg_proc_on_cnt_h",SLA_FALSE,rd_data);
     proc_on_clk_cnt_init_val[63:32] = rd_data[31:0];

     ReadReg("config_master","cfg_clk_on_cnt_l",SLA_FALSE,rd_data);
     clk_on_cnt_init_val[31:0] = rd_data[31:0];
     ReadReg("config_master","cfg_clk_on_cnt_h",SLA_FALSE,rd_data);
     clk_on_cnt_init_val[63:32] = rd_data[31:0];
  end

  else begin 
     WriteField("hqm_sif_csr","prim_cdc_ctl","clkreq_ctl_disabled",1'b1);
     WriteField("hqm_sif_csr","prim_cdc_ctl","clkgate_disabled",1'b1);
     read_and_check_reg("hqm_sif_csr","prim_cdc_ctl", SLA_FALSE,rd_data);
     ReadReg("config_master","cfg_clk_on_cnt_l",SLA_FALSE,rd_data);
     clk_on_cnt_init_val[31:0] = rd_data[31:0];
     ReadReg("config_master","cfg_clk_on_cnt_h",SLA_FALSE,rd_data);
     clk_on_cnt_init_val[63:32] = rd_data[31:0];
     ReadReg("config_master","cfg_proc_on_cnt_l",SLA_FALSE,rd_data);
     proc_on_clk_cnt_init_val[31:0] = rd_data[31:0];
     ReadReg("config_master","cfg_proc_on_cnt_h",SLA_FALSE,rd_data);
     proc_on_clk_cnt_init_val[63:32] = rd_data[31:0];
  end 



  `ovm_info(get_full_name(),$sformatf("cfg.ph_var=%s call prochot_process",cfg.ph_var),OVM_LOW)
  prochot_process();
  
  
  //if enabled earlier read_and_predict(prochotcounter_registers);
  
  if (!cfg.check_phcnt_regs) begin

      ph_event_cnt = ph_event_init_val;
      ph_high_clk_cnt = ph_high_clk_cnt_init_val;

      ReadReg("config_master","cfg_prochot_cnt_l",SLA_FALSE,rd_data);
      `ovm_info(get_full_name(),$sformatf("cfg_prochot_cnt_l=%h",rd_data),OVM_LOW)
      prochot_cnt_save[31:0] = rd_data[31:0];

      if (rd_data[31:0] != ph_high_clk_cnt[31:0]) begin 
         `ovm_error(get_full_name(),$sformatf(" cfg_prochot_cnt_l read data 0x%h doesn't match expected 0x%h", rd_data[31:0], ph_high_clk_cnt[31:0]))
      end 

      ReadReg("config_master","cfg_prochot_cnt_h",SLA_FALSE,rd_data);
      `ovm_info(get_full_name(),$sformatf("cfg_prochot_cnt_h=%h",rd_data),OVM_LOW)
      prochot_cnt_save[63:32] = rd_data[31:0];

      if (rd_data[31:0] != ph_high_clk_cnt[63:32]) begin 
         `ovm_error(get_full_name(),$sformatf(" cfg_prochot_cnt_h read data 0x%h doesn't match expected 0x%h", rd_data[31:0], ph_high_clk_cnt[63:32]))
      end  
  end 
  else begin  
      ReadReg("config_master","cfg_prochot_cnt_l",SLA_FALSE,rd_data);
      ph_high_clk_cnt_reg_val[31:0] = rd_data[31:0];
      `ovm_info(get_full_name(),$sformatf("cfg_prochot_cnt_l=%h",rd_data),OVM_LOW)
      prochot_cnt_save[31:0] = rd_data;

      ReadReg("config_master","cfg_prochot_cnt_h",SLA_FALSE,rd_data);
      ph_high_clk_cnt_reg_val[63:32] = rd_data[31:0];
      `ovm_info(get_full_name(),$sformatf("cfg_prochot_cnt_h=%h",rd_data),OVM_LOW)
      prochot_cnt_save[63:32] = rd_data;

      if (((ph_high_clk_cnt * 8) >= ph_high_clk_cnt_reg_val) && (ph_high_clk_cnt_reg_val > 0)) begin 
         `ovm_info(get_full_name(),$sformatf(" cfg_prochot_cnt read data 0x%h match expected 0x%h", ph_high_clk_cnt_reg_val, (ph_high_clk_cnt * 8)), OVM_LOW)
      end 
      else begin 
        if(cfg.prochot_disable==0) 
          `ovm_error(get_full_name(),$sformatf(" cfg_prochot_cnt read data 0x%h doesn't match expected 0x%h", ph_high_clk_cnt_reg_val, (ph_high_clk_cnt * 8)))
      end 
  end 

  ReadReg("config_master","cfg_prochot_event_cnt_l",SLA_FALSE,rd_data);
  `ovm_info(get_full_name(),$sformatf("cfg_prochot_event_cnt_l=%h",rd_data),OVM_LOW)
  prochot_event_cnt_save[31:0] = rd_data[31:0];

  if (rd_data[31:0] != ph_event_cnt[31:0] && cfg.prochot_disable==0) begin 
     `ovm_error(get_full_name(),$sformatf(" cfg_prochot_event_cnt_l read data 0x%h doesn't match expected 0x%h", rd_data[31:0], ph_event_cnt[31:0]))
  end   

  ReadReg("config_master","cfg_prochot_event_cnt_h",SLA_FALSE,rd_data);
  `ovm_info(get_full_name(),$sformatf("cfg_prochot_event_cnt_h=%h",rd_data),OVM_LOW)

  if (rd_data[31:0] != ph_event_cnt[63:32] && cfg.prochot_disable==0) begin 
     `ovm_error(get_full_name(),$sformatf(" cfg_prochot_event_cnt_h read data 0x%h doesn't match expected 0x%h", rd_data[31:0], ph_event_cnt[63:32]))
  end
  prochot_event_cnt_save[63:32] = rd_data[31:0];

  ReadReg("config_master","cfg_proc_on_cnt_l",SLA_FALSE,rd_data);
  `ovm_info(get_full_name(),$sformatf("cfg_proc_on_cnt_l=%h",rd_data),OVM_LOW)
  proc_on_clk_cnt_reg_val[31:0] = rd_data[31:0];

  ReadReg("config_master","cfg_proc_on_cnt_h",SLA_FALSE,rd_data);
  `ovm_info(get_full_name(),$sformatf("cfg_proc_on_cnt_h=%h",rd_data),OVM_LOW)
  proc_on_clk_cnt_reg_val[63:32] = rd_data[31:0];

  if ((cfg.check_phcnt_regs) && (proc_on_clk_cnt_init_val >= proc_on_clk_cnt_reg_val) && cfg.prochot_disable==0) begin 
     `ovm_error(get_full_name(),$sformatf(" cfg_proc_on_cnt read data 0x%h doesn't match expected, initial value proc_on_clk_cnt_init_val 0x%h", proc_on_clk_cnt_reg_val, proc_on_clk_cnt_init_val))
  end

  else if ((!cfg.check_phcnt_regs) && (proc_on_clk_cnt_init_val != proc_on_clk_cnt_reg_val) && cfg.prochot_disable==0) begin 
     `ovm_error(get_full_name(),$sformatf(" cfg_proc_on_cnt read data 0x%h doesn't match expected 0x%h", proc_on_clk_cnt_reg_val, proc_on_clk_cnt_init_val))
  end 


  ReadReg("config_master","cfg_clk_on_cnt_l",SLA_FALSE,rd_data);
  `ovm_info(get_full_name(),$sformatf("cfg_clk_on_cnt_l=%h",rd_data),OVM_LOW)
  clk_on_cnt_reg_val[31:0] = rd_data[31:0];
  prochot_on_cnt_save[31:0] = rd_data[31:0];
  ReadReg("config_master","cfg_clk_on_cnt_h",SLA_FALSE,rd_data);
  `ovm_info(get_full_name(),$sformatf("cfg_clk_on_cnt_h=%h",rd_data),OVM_LOW)
  clk_on_cnt_reg_val[63:32] = rd_data[31:0];
  prochot_on_cnt_save[63:32] = rd_data[31:0];

  if ((cfg.check_phcnt_regs) && (clk_on_cnt_init_val >= clk_on_cnt_reg_val) && cfg.prochot_disable==0) begin 
     `ovm_error(get_full_name(),$sformatf(" cfg_clk_on_cnt read data 0x%h doesn't match expected, initial value clk_on_cnt_init_val 0x%h ", clk_on_cnt_reg_val, clk_on_cnt_init_val))
  end

  else if ((!cfg.check_phcnt_regs) && (clk_on_cnt_init_val != clk_on_cnt_reg_val) && cfg.prochot_disable==0) begin 
     `ovm_error(get_full_name(),$sformatf(" cfg_clk_on_cnt read data 0x%h doesn't match expected 0x%h", clk_on_cnt_reg_val, clk_on_cnt_init_val))
  end 

  if (cfg.check_phcnt_regs) begin 
     WriteField("hqm_sif_csr","prim_cdc_ctl","clkreq_ctl_disabled",1'b0);
     WriteField("hqm_sif_csr","prim_cdc_ctl","clkgate_disabled",1'b0);
     read_and_check_reg("hqm_sif_csr","prim_cdc_ctl", SLA_FALSE,rd_data);
  end

  //--disable prochot by config at beginning, counter expect zero
  if(cfg.prochot_disable==1) begin
     if(prochot_cnt_save != 0)
       `ovm_error(get_full_name(),$sformatf("prochot_disable_2:: prochot_cnt_save=%0h not expected", prochot_cnt_save))
     else
       `ovm_info(get_full_name(),$sformatf("prochot_disable_2:: prochot_cnt_save=%0h",prochot_cnt_save),OVM_LOW)

     if(prochot_event_cnt_save != 0)
       `ovm_error(get_full_name(),$sformatf("prochot_disable_2:: prochot_event_cnt_save=%0h not expected", prochot_event_cnt_save))
     else
       `ovm_info(get_full_name(),$sformatf("prochot_disable_2:: prochot_event_cnt_save=%0h", prochot_event_cnt_save),OVM_LOW)
  end

  //--disable prochot by config and verify the prochot counter doesn't incr
  if(cfg.prochot_disable==2) begin
    `ovm_info(get_full_name(),$sformatf("prochot_disable_2:: config_master.cfg_control_general.cfg_prochot_disable set to 1"),OVM_LOW)
     WriteField("config_master","cfg_control_general","cfg_prochot_disable",1'b1);
     read_and_check_reg("config_master","cfg_control_general",SLA_FALSE,rd_data);
    `ovm_info(get_full_name(),$sformatf("prochot_disable_2:: config_master.cfg_control_general.rd=0x%0x",rd_data),OVM_LOW)


    `ovm_info(get_full_name(),$sformatf("prochot_disable_2:: cfg.ph_var=%s call prochot_process 2nd time",cfg.ph_var),OVM_LOW)
     prochot_process();
  
     ReadReg("config_master","cfg_prochot_cnt_l",SLA_FALSE,rd_data);
     if(prochot_cnt_save != rd_data)
       `ovm_error(get_full_name(),$sformatf("prochot_disable_2:: cfg_prochot_cnt_l=%0h, prochot_cnt_save=%0h mismatched",rd_data, prochot_cnt_save))
     else
       `ovm_info(get_full_name(),$sformatf("prochot_disable_2:: cfg_prochot_cnt_l=%0h, prochot_cnt_save=%0h",rd_data, prochot_cnt_save),OVM_LOW)

     ReadReg("config_master","cfg_prochot_event_cnt_l",SLA_FALSE,rd_data);
     if(prochot_event_cnt_save != rd_data) 
       `ovm_error(get_full_name(),$sformatf("prochot_disable_2:: cfg_prochot_event_cnt_l=%0h, prochot_event_cnt_save=%0h mismatched",rd_data, prochot_event_cnt_save))
     else
       `ovm_info(get_full_name(),$sformatf("prochot_disable_2:: cfg_prochot_event_cnt_l=%0h, prochot_event_cnt_save=%0h",rd_data, prochot_event_cnt_save),OVM_LOW)

     ReadReg("config_master","cfg_proc_on_cnt_l",SLA_FALSE,rd_data);
     `ovm_info(get_full_name(),$sformatf("prochot_disable_2:: cfg_proc_on_cnt_l=%0h, prochot_on_cnt_save=%0h",rd_data, prochot_on_cnt_save),OVM_LOW)
  end //--cfg.prochot_disable==2

  //--
  drv_ph_and_chk_ph_reg_field();
  // predict_approx_performance_with_prochot;
  /* { 
    } 
  */
 `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_prochot_user_data_seq ended \n"),OVM_LOW)
endtask: body

