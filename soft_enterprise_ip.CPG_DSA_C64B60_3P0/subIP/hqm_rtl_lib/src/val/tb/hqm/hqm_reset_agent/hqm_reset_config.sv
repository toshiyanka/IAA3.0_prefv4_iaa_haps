`ifndef HQM_RESET_CONFIG__SV
`define HQM_RESET_CONFIG__SV

class hqm_reset_config extends ovm_object;

   ovm_active_passive_enum is_active;

    `ovm_object_utils_begin(hqm_reset_config)
      `ovm_field_enum(ovm_active_passive_enum, is_active, OVM_ALL_ON)
    `ovm_object_utils_end

   extern                   function                new(string name = "hqm_reset_config");

endclass

function hqm_reset_config::new (string name = "hqm_reset_config");
    super.new(name);
    is_active = OVM_ACTIVE;
endfunction

`endif
