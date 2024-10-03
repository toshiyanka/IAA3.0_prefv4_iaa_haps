`ifndef HQM_IP_TB_OVM
class hqm_sla_env extends slu_tb_env;

   `uvm_component_utils(hqm_sla_env)

   function new(string name = "hqm_slu_env", uvm_component parent = null);
      super.new(name, parent);
      ral_type = "hqm_ral_env";
   endfunction // new
endclass

`else 
class hqm_sla_env extends sla_tb_env;

   `ovm_component_utils(hqm_sla_env)
   
   function new(string name = "hqm_sla_env", ovm_component parent = null);
      super.new(name, parent);
      ral_type = "hqm_ral_env";      
   endfunction // new
endclass
`endif 
