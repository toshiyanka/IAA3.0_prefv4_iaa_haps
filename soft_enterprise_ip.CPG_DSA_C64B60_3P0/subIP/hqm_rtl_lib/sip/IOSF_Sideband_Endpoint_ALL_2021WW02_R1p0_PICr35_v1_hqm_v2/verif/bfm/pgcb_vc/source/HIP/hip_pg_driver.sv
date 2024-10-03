//------------------------------------------------------------------------------
//  Copyright (c)
//  2010 Intel Corporation, all rights reserved.
//
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY
//  PROTECTED BY COPYRIGHT LAWS AND IS CONSIDERED A
//  TRADE SECRET BELONGING TO THE INTEL CORPORATION.
//------------------------------------------------------------------------------
//  Author  : Bill Bradley
//  Email   : william.l.bradley@intel.com
//  Date    : June 05, 2013
//  Desc    : HIP PG Driver.  Transaction based access to the HIP PG interface
//            signals.
//------------------------------------------------------------------------------

`ifndef HIP_PG_DRIVER__SV
`define HIP_PG_DRIVER__SV

//------------------------------------------------------------------------------
// class: hip_pg_driver
//------------------------------------------------------------------------------
class hip_pg_driver extends ovm_driver #(hip_pg_xaction);

  //----------------------------------------------------------------------------
  // Variables
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // variable: _vif
  //
  // HIP PG virtual interface
  //----------------------------------------------------------------------------
  protected virtual hip_pg_if _vif;

  //----------------------------------------------------------------------------
  // variable: config
  //
  // HIP PG config object
  //----------------------------------------------------------------------------
  protected hip_pg_config config;
  
  `ovm_component_utils_begin(hip_pg_driver)
    `ovm_field_object(config, OVM_ALL_ON)
  `ovm_component_utils_end


  //----------------------------------------------------------------------------
  // function: new
  //
  // Purpose:
  //   Constructor
  //
  // Inputs:
  //   Name of component and parent
  //
  // Returns:
  //
  // Depends on:
  //
  // Modifies:
  //
  // Operation:
  //
  //---------------------------------------------------------------------------
  function new(string name = "hip_pg_driver", ovm_component parent=null);
    super.new (name, parent);
    
    // build config object
    config = hip_pg_config::type_id::create("config");
    void'(config.randomize());
  endfunction : new

  //---------------------------------------------------------------------------
  // function: build
  //
  // Purpose:
  //   Standard build function
  //
  // Inputs:
  //   None
  //
  // Returns:
  //
  // Depends on:
  //
  // Modifies:
  //
  //---------------------------------------------------------------------------
  virtual function void build();
    hip_pg_agent agent;

    super.build();

    // get handle to virtual interface from agent
    $cast(agent, get_parent());
    _vif = agent._vif;
    config = agent.config;
  endfunction : build

  //----------------------------------------------------------------------
  // Function: apply_config_settings                    
  // 
  // 
  // Description:
  //   Called when new configs are applied.
  // 
  // Inputs: 
  //   N/A
  // 
  // Returns: 
  //   Void
  // 
  //----------------------------------------------------------------------
  virtual function void apply_config_settings(bit verbose=1);
    super.apply_config_settings(verbose);
  endfunction : apply_config_settings

  //---------------------------------------------------------------------------
  // task: run
  //
  // Purpose:
  //   Main process for driving HIP PG interface signals
  //
  // Inputs:
  //   None
  //
  // Outputs:
  //   None
  //
  // Depends on:
  //   See individual tasks.
  //
  // Modifies:
  //   See individual tasks.
  //
  //---------------------------------------------------------------------------
  virtual task run();
    
    fork
      // set initial interface values
      set_initial_intf_values();
    
      // main thread to handle driver ops
      process_driver_ops_tsk();
    join
      
  endtask : run

  //---------------------------------------------------------------------------
  // task: process_driver_ops
  //
  // Purpose:
  //   Main process for driving HIP PG interface signals
  //
  // Inputs:
  //   None
  //
  // Outputs:
  //   None
  //
  // Depends on:
  //   See individual tasks.
  //
  // Modifies:
  //   See individual tasks.
  //
  //---------------------------------------------------------------------------
  virtual task process_driver_ops_tsk();
    forever begin
      // next transaction item
      hip_pg_xaction hip_pg_x;
      
      // driver response
      hip_pg_xaction hip_pg_rsp;
      
      //Pull packet from the sequencer fifo
      seq_item_port.get_next_item(req);
      
      if (req != null) begin
        // copy sequencer item
        $cast(hip_pg_x, req);

        // create the response
        hip_pg_rsp = hip_pg_xaction::type_id::create("hip_pg_rsp");
        hip_pg_rsp.copy(req);
        hip_pg_rsp.set_id_info(req);
        hip_pg_rsp.op = hip_pg::HIP_PG_OP_COMPLETE;
      
        // process HIP_PG ops for xactions that drive signals
        case (hip_pg_x.op)
	  hip_pg::HIP_PG_PMC_PHY_PWR_EN        : _vif.pmc_phy_pwr_en        = hip_pg_x.value;
	  hip_pg::HIP_PG_PMC_PHY_RESET_B       : _vif.pmc_phy_reset_b       = hip_pg_x.value;
	  hip_pg::HIP_PG_PMC_PHY_FW_EN_B       : _vif.pmc_phy_fw_en_b       = hip_pg_x.value;
	  hip_pg::HIP_PG_PMC_PHY_SBWAKE        : _vif.pmc_phy_sbwake        = hip_pg_x.value;
	  hip_pg::HIP_PG_IOSF_SIDE_RST_B       : _vif.iosf_side_rst_b       = hip_pg_x.value;
	  hip_pg::HIP_PG_SOC_PHY_PWR_REQ       : _vif.soc_phy_pwr_req       = hip_pg_x.value;
	  hip_pg::HIP_PG_PMC_PHY_PMCTRL_EN     : _vif.pmc_phy_pmctrl_en     = hip_pg_x.value;
	  hip_pg::HIP_PG_PMC_PHY_PMCTRL_PWR_EN : _vif.pmc_phy_pmctrl_pwr_en = hip_pg_x.value;
	  hip_pg::HIP_PG_FORCEPWRGATEPOK       : _vif.forcePwrGatePOK       = hip_pg_x.value;

          default : extra_driver_ops_tsk();
        endcase
        
        seq_item_port.item_done(hip_pg_rsp);
      end
    end
  endtask : process_driver_ops_tsk

  //---------------------------------------------------------------------------
  // task: extra_driver_ops
  //
  // Purpose:
  //   Blank virtual task to handle any additional driver ops in derived classes
  //
  // Inputs:
  //   None
  //
  // Outputs:
  //   None
  //
  // Depends on:
  //   
  //
  // Modifies:
  //   
  //
  //---------------------------------------------------------------------------
  virtual task extra_driver_ops_tsk();
   
  endtask : extra_driver_ops_tsk


  //---------------------------------------------------------------------------
  // Function: set_initial_intf_values
  //
  // Purpose:
  //   Set initial values for the HIP PG interface
  //
  // Inputs:
  //   None
  //
  // Outputs:
  //   None
  //
  // Depends on:
  //   
  //
  // Modifies:
  //   
  //
  //---------------------------------------------------------------------------
  virtual function void set_initial_intf_values();

    _vif.pmc_phy_pwr_en        = 1'b0;
    _vif.pmc_phy_reset_b       = 1'b0;
    _vif.pmc_phy_fw_en_b       = 1'b0;
    _vif.pmc_phy_sbwake        = 1'b0;
    _vif.iosf_side_rst_b       = 1'b0;
    _vif.soc_phy_pwr_req       = 1'b0;
    _vif.pmc_phy_pmctrl_en     = 1'b0;
    _vif.pmc_phy_pmctrl_pwr_en = 1'b0;
    _vif.forcePwrGatePOK       = 1'b0;

  endfunction : set_initial_intf_values

endclass : hip_pg_driver

`endif //  `ifndef HIP_PG_DRIVER__SV
