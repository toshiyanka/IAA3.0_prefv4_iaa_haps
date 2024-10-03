`ifndef HQM_REG_ALIASING_TEST__SV
`define HQM_REG_ALIASING_TEST__SV

import hqm_tb_cfg_sequences_pkg::*;

class hqm_reg_aliasing_test extends hqm_base_test;

   `ovm_component_utils(hqm_reg_aliasing_test)

   function new(string name = "hqm_reg_aliasing_test", ovm_component parent = null);
      super.new(name,parent);
   endfunction : new

   function void build();
      super.build();
   endfunction : build

   function void connect();

      super.connect();

      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_opt_file_mode_seq");

      if($test$plusargs("PP_ADDR_ALIASING_TO_REGS_CHK")) begin
         i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_hcw_cfg_seq");
         i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_tb_cfg_user_data_file_mode_seq");

         i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","EXTRA_DATA_PHASE","hqm_backdoor_register_access_seq");
      end else begin
         i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_register_aliasing_check_seq");
      end

      if($test$plusargs("REG_ALIAS_CHK_WITH_PP_ADDR")) begin
         i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "EXTRA_DATA_PHASE", "hqm_iosf_tb_file_seq");
      end

      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_hcw_eot_file_mode_seq");

   endfunction    

   function void do_config();
 
   endfunction

   function void set_config();  

   endfunction

   function void set_override();

   endfunction

endclass
`endif
