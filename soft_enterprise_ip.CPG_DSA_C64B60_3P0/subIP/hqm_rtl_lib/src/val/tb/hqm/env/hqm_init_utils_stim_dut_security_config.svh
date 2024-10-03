class hqm_init_utils_stim_dut_security_config extends init_utils_stim_dut_view_pkg::init_utils_stim_dut_security_config;

    `ovm_object_utils(hqm_init_utils_stim_dut_security_config)



    function new(string name = "hqm_init_utils_stim_dut_security_config");
        super.new(name);
    endfunction



    //override function
    virtual function longint unsigned get_mem_encrypt_key_id(longint unsigned addr);

        get_mem_encrypt_key_id = 0;//cfgMgr.get_tme_keyid_by_address(addr);

    endfunction

endclass

//------------------------------------------------------------------------------
// Class: hqm_init_utils_req_security_config_registrar
// Registers a factory override for <hqm_init_utils_req_security_config>
//------------------------------------------------------------------------------

class hqm_init_utils_req_security_config_registrar;
    // Variable: registrar
    // Static data member constructed by new to invoke OVM factory override immediately without user intervention
    static hqm_init_utils_req_security_config_registrar registrar = new;

    //------------------------------------------------------------------------------
    // Function: new
    // Constructor which executes OVM factory override
    //------------------------------------------------------------------------------
    function new();
        ovm_factory::get().set_type_override_by_type(init_utils_stim_dut_view_pkg::init_utils_stim_dut_security_config::get_type(), hqm_init_utils_stim_dut_security_config::get_type(), 1);
    endfunction : new
endclass : hqm_init_utils_req_security_config_registrar
