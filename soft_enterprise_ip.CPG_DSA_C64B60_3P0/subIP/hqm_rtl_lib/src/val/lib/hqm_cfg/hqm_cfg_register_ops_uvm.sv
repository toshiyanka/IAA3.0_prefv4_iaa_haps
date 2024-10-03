

class hqm_cfg_register_ops extends uvm_object;

    `uvm_object_utils(hqm_cfg_register_ops)

    string               file_name;
    string               reg_name;
    string               field_name;
    longint              offset;
    sla_ral_data_t       exp_rd_val;    
    sla_ral_data_t       exp_rd_mask;    
    int                  poll_timeout;
    int                  poll_delay;
    bit [7:0]            sai;
    hqm_cfg_reg_ops_t    ops;


  function new(string name="hqm_cfg_register_ops");  //[UVM MIGRATION]Added class constructer
     super.new(name);
  endfunction

endclass
