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
//  Date    : November 4, 2013
//  Desc    : HIP PG Monitor
//------------------------------------------------------------------------------

`ifndef HIP_PG_MONITOR__SV
`define HIP_PG_MONITOR__SV

//------------------------------------------------------------------------------
// class: hip_pg_monitor
//
// Monitors the HIP PG interface
//------------------------------------------------------------------------------
class hip_pg_monitor extends ovm_monitor;

  //---------------------------------------------------------------------------
  // OVM Config
  //---------------------------------------------------------------------------

  // variable: file_name
  // Name of the file the pipe monitor writes its log to
  protected string file_name = "hip_pg_monitor";
  
  // variable: disable_log
  // If set, prevents the monitor from outputting transactions to a log file
  protected bit disable_log  = 0;

  // variable: _vif
  // virtual interface
  protected virtual hip_pg_if _vif;

  // variable: _file
  // file handle
  protected integer _file;

  // variable: hip_pg_cfg
  // Config object containing driver configuration
  protected hip_pg_config hip_pg_cfg;

  `ovm_component_utils_begin(hip_pg_monitor)
    `ovm_field_string(file_name,   OVM_ALL_ON)
    `ovm_field_int   (disable_log, OVM_ALL_ON)
    `ovm_field_object(hip_pg_cfg,  OVM_ALL_ON)
  `ovm_component_utils_end


  //---------------------------------------------------------------------------
  // TLM Ports
  //---------------------------------------------------------------------------
  
  // port: query_mon_imp
  // Port for querying monitor.
  ovm_blocking_transport_imp #(hip_pg_xaction_mon, hip_pg_xaction_mon, hip_pg_monitor) query_mon_imp;
  
  // port: an_port
  // Analysis output port.  All transactions go to this port
  ovm_analysis_port          #(hip_pg_xaction_mon)                                     an_port;
  
 
  //---------------------------------------------------------------------------
  // Variables
  //---------------------------------------------------------------------------
   
  // variable: interface_value
  // Holds the current interface value for each interface signal
  protected logic interface_value[hip_pg::hip_pg_mon_op_t];

 
  //---------------------------------------------------------------------------
  // Methods
  //---------------------------------------------------------------------------

  //---------------------------------------------------------------------------
  // Function: new
  //
  //
  // Description:
  //   Constructor
  //
  // Inputs:
  //   name, parent
  //
  // Returns:
  //   Void
  //
  // Error Conditions:
  //   N/A
  //
  //---------------------------------------------------------------------------
  function new(string name, ovm_component parent = null);
    super.new(name, parent);
    
    // create ports
    an_port       = new("an_port",       this);
    query_mon_imp = new("query_mon_imp", this);
  endfunction : new

  //---------------------------------------------------------------------------
  // Function: build
  //
  //
  // Description:
  //   Creates HIP PG tracker log file.
  //
  // Inputs:
  //   N/A
  //
  // Returns:
  //   Void
  //
  // Error Conditions:
  //   N/A
  //
  //---------------------------------------------------------------------------
  virtual function void build();
    hip_pg_agent agent;
    
    super.build();

    // get handle to virtual interface from agent
    $cast(agent, get_parent());
    _vif = agent._vif;
    
    if (!disable_log) begin
     // add lane num and extension to file name
     _file = $fopen($psprintf("%0s.out", file_name), "w");
    end
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
  // Task: run
  //
  //
  // Description:
  //   Launches all monitor analysis threads:
  //
  // Inputs:
  //   N/A
  //
  // Outputs:
  //   N/A
  //
  // Depends on:
  //   N/A
  //
  // Modifies:
  //   N/A
  //
  //---------------------------------------------------------------------------
  virtual task run();
    fork

      // monitor each signal independently; send hip_pg_mon_xactions as they're generated

      forever begin
        @(_vif.pmc_phy_pwr_en);
	if (_vif.pmc_phy_pwr_en !== interface_value[hip_pg::HIP_PG_MON_PMC_PHY_PWR_EN]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_PMC_PHY_PWR_EN]))
            send_mon_xaction(hip_pg::HIP_PG_MON_PMC_PHY_PWR_EN, _vif.pmc_phy_pwr_en);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_PMC_PHY_PWR_EN] = _vif.pmc_phy_pwr_en;
    	end
      end

      forever begin
        @(_vif.phy_pmc_pwr_stable);
	if (_vif.phy_pmc_pwr_stable !== interface_value[hip_pg::HIP_PG_MON_PHY_PMC_PWR_STABLE]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_PHY_PMC_PWR_STABLE]))
            send_mon_xaction(hip_pg::HIP_PG_MON_PHY_PMC_PWR_STABLE, _vif.phy_pmc_pwr_stable);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_PHY_PMC_PWR_STABLE] = _vif.phy_pmc_pwr_stable;
    	end
      end

      forever begin
        @(_vif.pmc_phy_reset_b);
	if (_vif.pmc_phy_reset_b !== interface_value[hip_pg::HIP_PG_MON_PMC_PHY_RESET_B]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_PMC_PHY_RESET_B]))
            send_mon_xaction(hip_pg::HIP_PG_MON_PMC_PHY_RESET_B, _vif.pmc_phy_reset_b);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_PMC_PHY_RESET_B] = _vif.pmc_phy_reset_b;
    	end
      end

      forever begin
        @(_vif.pmc_phy_fw_en_b);
	if (_vif.pmc_phy_fw_en_b !== interface_value[hip_pg::HIP_PG_MON_PMC_PHY_FW_EN_B]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_PMC_PHY_FW_EN_B]))
            send_mon_xaction(hip_pg::HIP_PG_MON_PMC_PHY_FW_EN_B, _vif.pmc_phy_fw_en_b);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_PMC_PHY_FW_EN_B] = _vif.pmc_phy_fw_en_b;
    	end
      end

      forever begin
        @(_vif.pmc_phy_sbwake);
	if (_vif.pmc_phy_sbwake !== interface_value[hip_pg::HIP_PG_MON_PMC_PHY_SBWAKE]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_PMC_PHY_SBWAKE]))
            send_mon_xaction(hip_pg::HIP_PG_MON_PMC_PHY_SBWAKE, _vif.pmc_phy_sbwake);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_PMC_PHY_SBWAKE] = _vif.pmc_phy_sbwake;
    	end
      end

      forever begin
        @(_vif.phy_pmc_sbpwr_stable);
	if (_vif.phy_pmc_sbpwr_stable !== interface_value[hip_pg::HIP_PG_MON_PHY_PMC_SBPWR_STABLE]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_PHY_PMC_SBPWR_STABLE]))
            send_mon_xaction(hip_pg::HIP_PG_MON_PHY_PMC_SBPWR_STABLE, _vif.phy_pmc_sbpwr_stable);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_PHY_PMC_SBPWR_STABLE] = _vif.phy_pmc_sbpwr_stable;
    	end
      end

      forever begin
        @(_vif.iosf_side_pok_h);
	if (_vif.iosf_side_pok_h !== interface_value[hip_pg::HIP_PG_MON_IOSF_SIDE_POK_H]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_IOSF_SIDE_POK_H]))
            send_mon_xaction(hip_pg::HIP_PG_MON_IOSF_SIDE_POK_H, _vif.iosf_side_pok_h);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_IOSF_SIDE_POK_H] = _vif.iosf_side_pok_h;
    	end
      end

      forever begin
        @(_vif.iosf_side_rst_b);
	if (_vif.iosf_side_rst_b !== interface_value[hip_pg::HIP_PG_MON_IOSF_SIDE_RST_B]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_IOSF_SIDE_RST_B]))
            send_mon_xaction(hip_pg::HIP_PG_MON_IOSF_SIDE_RST_B, _vif.iosf_side_rst_b);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_IOSF_SIDE_RST_B] = _vif.iosf_side_rst_b;
    	end
      end

      forever begin
        @(_vif.soc_phy_pwr_req);
	if (_vif.soc_phy_pwr_req !== interface_value[hip_pg::HIP_PG_MON_SOC_PHY_PWR_REQ]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_SOC_PHY_PWR_REQ]))
            send_mon_xaction(hip_pg::HIP_PG_MON_SOC_PHY_PWR_REQ, _vif.soc_phy_pwr_req);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_SOC_PHY_PWR_REQ] = _vif.soc_phy_pwr_req;
    	end
      end

      forever begin
        @(_vif.phy_soc_pwr_ack);
	if (_vif.phy_soc_pwr_ack !== interface_value[hip_pg::HIP_PG_MON_PHY_SOC_PWR_ACK]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_PHY_SOC_PWR_ACK]))
            send_mon_xaction(hip_pg::HIP_PG_MON_PHY_SOC_PWR_ACK, _vif.phy_soc_pwr_ack);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_PHY_SOC_PWR_ACK] = _vif.phy_soc_pwr_ack;
    	end
      end

      forever begin
        @(_vif.pmc_phy_pmctrl_en);
	if (_vif.pmc_phy_pmctrl_en !== interface_value[hip_pg::HIP_PG_MON_PMC_PHY_PMCTRL_EN]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_PMC_PHY_PMCTRL_EN]))
            send_mon_xaction(hip_pg::HIP_PG_MON_PMC_PHY_PMCTRL_EN, _vif.pmc_phy_pmctrl_en);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_PMC_PHY_PMCTRL_EN] = _vif.pmc_phy_pmctrl_en;
    	end
      end

      forever begin
        @(_vif.pmc_phy_pmctrl_pwr_en);
	if (_vif.pmc_phy_pmctrl_pwr_en !== interface_value[hip_pg::HIP_PG_MON_PMC_PHY_PMCTRL_PWR_EN]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_PMC_PHY_PMCTRL_PWR_EN]))
            send_mon_xaction(hip_pg::HIP_PG_MON_PMC_PHY_PMCTRL_PWR_EN, _vif.pmc_phy_pmctrl_pwr_en);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_PMC_PHY_PMCTRL_PWR_EN] = _vif.pmc_phy_pmctrl_pwr_en;
    	end
      end

      forever begin
        @(_vif.phy_pmc_pmctrl_pwr_stable);
	if (_vif.phy_pmc_pmctrl_pwr_stable !== interface_value[hip_pg::HIP_PG_MON_PHY_PMC_PMCTRL_PWR_STABLE]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_PHY_PMC_PMCTRL_PWR_STABLE]))
            send_mon_xaction(hip_pg::HIP_PG_MON_PHY_PMC_PMCTRL_PWR_STABLE, _vif.phy_pmc_pmctrl_pwr_stable);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_PHY_PMC_PMCTRL_PWR_STABLE] = _vif.phy_pmc_pmctrl_pwr_stable;
    	end
      end

      forever begin
        @(_vif.forcePwrGatePOK);
	if (_vif.forcePwrGatePOK !== interface_value[hip_pg::HIP_PG_MON_FORCEPWRGATEPOK]) begin

      	  // if this is the initial clk, suppress the transaction
      	  if (!$isunknown(interface_value[hip_pg::HIP_PG_MON_FORCEPWRGATEPOK]))
            send_mon_xaction(hip_pg::HIP_PG_MON_FORCEPWRGATEPOK, _vif.forcePwrGatePOK);

      	  // update the new interface value
      	  interface_value[hip_pg::HIP_PG_MON_FORCEPWRGATEPOK] = _vif.forcePwrGatePOK;
    	end
      end

    join_none

/*
    forever begin
      fork
        // thread to track the HIP PG interface
        track_hip_pg_if_activity();
      join_any
    end
*/
  endtask : run
/*
  //---------------------------------------------------------------------------
  // Task: track_hip_pg_if_activity
  //
  //
  // Description:
  //   Tracks the mPhy PCS <-> Rx interface
  //
  // Inputs:
  //   N/A
  //
  // Outputs:
  //   N/A
  //
  // Depends on:
  //   mPhy virtual interface signals.  Runs on <mphy_pcs_rx_if::i_ck_pclk>
  //
  // Modifies:
  //   N/A
  //
  //---------------------------------------------------------------------------
  virtual task track_hip_pg_if_activity();
      // bind operations to interface signals
      track_op(hip_pg::HIP_PG_MON_PMC_PHY_PWR_EN,            _vif.pmc_phy_pwr_en);
      track_op(hip_pg::HIP_PG_MON_PHY_PMC_PWR_STABLE, 	     _vif.phy_pmc_pwr_stable);
      track_op(hip_pg::HIP_PG_MON_PMC_PHY_RESET_B, 	     _vif.pmc_phy_reset_b);
      track_op(hip_pg::HIP_PG_MON_PMC_PHY_FW_EN_B, 	     _vif.pmc_phy_fw_en_b);
      track_op(hip_pg::HIP_PG_MON_PMC_PHY_SBWAKE, 	     _vif.pmc_phy_sbwake);
      track_op(hip_pg::HIP_PG_MON_PHY_PMC_SBPWR_STABLE,      _vif.phy_pmc_sbpwr_stable);
      track_op(hip_pg::HIP_PG_MON_IOSF_SIDE_POK_H, 	     _vif.iosf_side_pok_h);
      track_op(hip_pg::HIP_PG_MON_IOSF_SIDE_RST_B, 	     _vif.iosf_side_rst_b);
      track_op(hip_pg::HIP_PG_MON_SOC_PHY_PWR_REQ, 	     _vif.soc_phy_pwr_req);
      track_op(hip_pg::HIP_PG_MON_PHY_SOC_PWR_ACK, 	     _vif.phy_soc_pwr_ack);
      track_op(hip_pg::HIP_PG_MON_PMC_PHY_PMCTRL_EN,	     _vif.pmc_phy_pmctrl_en);
      track_op(hip_pg::HIP_PG_MON_PMC_PHY_PMCTRL_PWR_EN,     _vif.pmc_phy_pmctrl_pwr_en);
      track_op(hip_pg::HIP_PG_MON_PHY_PMC_PMCTRL_PWR_STABLE, _vif.phy_pmc_pmctrl_pwr_stable);
      track_op(hip_pg::HIP_PG_MON_FORCEPWRGATEPOK,           _vif.forcePwrGatePOK);
  endtask : track_hip_pg_if_activity


  //---------------------------------------------------------------------------
  // Function: track_op
  //
  //
  // Description:
  //   Monitor the interface for any changes.
  //
  // Inputs:
  //   triggered_op - Operation of type <hip_pg::hip_pg_mon_op_t> which is being evaluated for a change.
  //   value - logic value containing the interface value related to the triggered_op
  //
  // Returns:
  //   Void
  //
  // Error Conditions:
  //   N/A
  //
  //---------------------------------------------------------------------------
  virtual function void track_op(hip_pg::hip_pg_mon_op_t triggered_op, logic value);

    // check if the interface value has changed since the last clk
    if (value !== interface_value[triggered_op]) begin

      // if this is the initial clk, suppress the transaction
      if (!$isunknown(interface_value[triggered_op]))
          send_mon_xaction(triggered_op, value);

      // update the new interface value
      interface_value[triggered_op] = value;
           
    end
  endfunction : track_op
*/
  //---------------------------------------------------------------------------
  // Function: send_mon_xaction
  //
  //
  // Description:
  //   Creates a new monitor transaction of type <hip_pg::hip_pg_xaction_mon>
  //   and pushes it out the analysis port 
  //
  // Inputs:
  //   triggered_op - Operation of type <hip_pg::hip_pg_mon_op_t> which is being evaluated for a change.
  //   value - logic value containing the interface value related to the triggered_op
  //
  // Returns:
  //   Void
  //
  // Error Conditions:
  //   N/A
  //
  //---------------------------------------------------------------------------
  virtual function void send_mon_xaction(hip_pg::hip_pg_mon_op_t op, logic value);
    hip_pg_xaction_mon hip_pg_mon_x;
    
    // create a new transaction
    hip_pg_mon_x           = hip_pg_xaction_mon::type_id::create("hip_pg_mon_x");
    hip_pg_mon_x.op        = op;
    hip_pg_mon_x.value     = value;
    hip_pg_mon_x.timestamp = $realtime;
    
    // populate current interface values
    sample_if(hip_pg_mon_x);
    
    // write this xaction to a log file
    if (!disable_log)
      write_log(hip_pg_mon_x);
    
    // send it out on the analysis port
    an_port.write(hip_pg_mon_x);    
  endfunction : send_mon_xaction


  //---------------------------------------------------------------------------
  // Function: sample_if
  //
  //
  // Description:
  //   Populates a monitor transaction object with current interface values 
  //
  // Inputs:
  //   hip_pg_mon_x - Object to be populated
  //
  // Returns:
  //   Void
  //
  // Error Conditions:
  //   N/A
  //
  //---------------------------------------------------------------------------
  virtual function void sample_if(ref hip_pg_xaction_mon hip_pg_mon_x);    
    // hip_pg_vif
    hip_pg_mon_x.pmc_phy_pwr_en = _vif.pmc_phy_pwr_en;
    hip_pg_mon_x.phy_pmc_pwr_stable = _vif.phy_pmc_pwr_stable;
    hip_pg_mon_x.pmc_phy_reset_b = _vif.pmc_phy_reset_b;
    hip_pg_mon_x.pmc_phy_fw_en_b = _vif.pmc_phy_fw_en_b;
    hip_pg_mon_x.pmc_phy_sbwake = _vif.pmc_phy_sbwake;
    hip_pg_mon_x.phy_pmc_sbpwr_stable = _vif.phy_pmc_sbpwr_stable;
    hip_pg_mon_x.iosf_side_pok_h = _vif.iosf_side_pok_h;
    hip_pg_mon_x.iosf_side_rst_b = _vif.iosf_side_rst_b;
    hip_pg_mon_x.soc_phy_pwr_req = _vif.soc_phy_pwr_req;
    hip_pg_mon_x.phy_soc_pwr_ack = _vif.phy_soc_pwr_ack;
    hip_pg_mon_x.pmc_phy_pmctrl_en = _vif.pmc_phy_pmctrl_en;
    hip_pg_mon_x.pmc_phy_pmctrl_pwr_en = _vif.pmc_phy_pmctrl_pwr_en;
    hip_pg_mon_x.phy_pmc_pmctrl_pwr_stable = _vif.phy_pmc_pmctrl_pwr_stable;
    hip_pg_mon_x.forcePwrGatePOK = _vif.forcePwrGatePOK;
  endfunction : sample_if

  //---------------------------------------------------------------------------
  // Function: write_log
  //
  //
  // Description:
  //   Prints the raw transaction information to a log file
  //
  // Inputs:
  //   hip_pg_mon_x - xaction to be printed
  //
  // Returns:
  //   Void
  //
  // Error Conditions:
  //   N/A
  //
  //---------------------------------------------------------------------------
  virtual function void write_log(ref hip_pg_xaction_mon hip_pg_mon_x);
    // set time format
    $timeformat(-9, 3, "ns", 8);
    // print it out
    $fwrite(_file, "%t\t%-40s%10h\n", hip_pg_mon_x.timestamp, hip_pg_mon_x.op.name(), hip_pg_mon_x.value);
  endfunction : write_log

  //----------------------------------------------------------------------------
  // Task: transport 
  // 
  // Description: 
  //   Provides a path to request the monitor to perform certain functions.
  //
  //   Services the following operations
  // 
  // Inputs: 
  //   req - Requested PCS Monitor transaction <hip_pg_xaction_mon>
  // 
  // Outputs: 
  //   rsp - PCS Monitor response transaction <hip_pg_xaction_mon>
  // 
  // Depends on: 
  //   N/A
  // 
  // Modifies: 
  //   N/A
  //----------------------------------------------------------------------------
  virtual task automatic transport(input  hip_pg_xaction_mon req,
                                   output hip_pg_xaction_mon rsp);

    // pipe monitor transaction
    hip_pg_xaction_mon hip_pg_mon_x;
    
    // watchdog timer for wait ops
    // mphy_utils_pkg::watchdog_timer wdtimer;

    // create new transaction
    hip_pg_mon_x = hip_pg_xaction_mon::type_id::create("hip_pg_mon_x");
      
    // instantiate watchdog timer
    // wdtimer = watchdog_timer::type_id::create("wdtimer", this);
    
    // set the timeout for this request
    // void'(wdtimer.set_wait_time(req.timeout_value_ps*1ps));
    
    // parse monitor op
    case(req.op)

      hip_pg::HIP_PG_MON_WAIT_FOR_PHY_PMC_PWR_STABLE : begin
        fork
	  begin
	    do
	      @(_vif.phy_pmc_pwr_stable);
	    while (_vif.phy_pmc_pwr_stable != req.value);
	    hip_pg_mon_x.op = hip_pg::HIP_PG_MON_OP_COMPLETE;
	  end
	  begin
	    #(req.timeout_value_ps*1ps)
	    hip_pg_mon_x.op = hip_pg::HIP_PG_MON_OP_FAIL_TIMEOUT;
	  end
	join_any
	disable fork;
      end

      hip_pg::HIP_PG_MON_WAIT_FOR_PHY_PMC_SBPWR_STABLE : begin
        fork
	  begin
	    @(_vif.phy_pmc_sbpwr_stable);
	    hip_pg_mon_x.op = hip_pg::HIP_PG_MON_OP_COMPLETE;
	  end
	  begin
	    #(req.timeout_value_ps*1ps)
	    hip_pg_mon_x.op = hip_pg::HIP_PG_MON_OP_FAIL_TIMEOUT;
	  end
	join_any
	disable fork;
      end

      hip_pg::HIP_PG_MON_WAIT_FOR_IOSF_SIDE_POK_H : begin
        fork
	  begin
	    @(_vif.iosf_side_pok_h);
	    hip_pg_mon_x.op = hip_pg::HIP_PG_MON_OP_COMPLETE;
	  end
	  begin
	    #(req.timeout_value_ps*1ps)
	    hip_pg_mon_x.op = hip_pg::HIP_PG_MON_OP_FAIL_TIMEOUT;
	  end
	join_any
	disable fork;
      end

      hip_pg::HIP_PG_MON_WAIT_FOR_PHY_SOC_PWR_ACK : begin
        fork
	  begin
	    @(_vif.phy_soc_pwr_ack);
	    hip_pg_mon_x.op = hip_pg::HIP_PG_MON_OP_COMPLETE;
	  end
	  begin
	    #(req.timeout_value_ps*1ps)
	    hip_pg_mon_x.op = hip_pg::HIP_PG_MON_OP_FAIL_TIMEOUT;
	  end
	join_any
	disable fork;
      end

      hip_pg::HIP_PG_MON_WAIT_FOR_PHY_PMC_PMCTRL_PWR_STABLE : begin
        fork
	  begin
	    @(_vif.phy_pmc_pmctrl_pwr_stable);
	    hip_pg_mon_x.op = hip_pg::HIP_PG_MON_OP_COMPLETE;
	  end
	  begin
	    #(req.timeout_value_ps*1ps)
	    hip_pg_mon_x.op = hip_pg::HIP_PG_MON_OP_FAIL_TIMEOUT;
	  end
	join_any
	disable fork;
      end

      default : extra_mon_transport_ops();
    endcase

    // grab current interface values
    sample_if(hip_pg_mon_x);
    
    // flag error if timeout occured
    if (hip_pg_mon_x.op != hip_pg::HIP_PG_MON_OP_COMPLETE)
      `ovm_error(get_type_name(),
                 $psprintf("%0s op was not successful. timeout value = %0dps", req.op.name(), req.timeout_value_ps))
      
    // return transaction
    rsp = hip_pg_mon_x;    
  endtask : transport

  //---------------------------------------------------------------------------
  // task: extra_mon_transport_ops
  //
  // Purpose:
  //   Blank virtual task to handle any additional monitor ops in derived classes
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
  virtual task extra_mon_transport_ops();
  
  endtask : extra_mon_transport_ops

endclass : hip_pg_monitor

`endif //  `ifndef HIP_PG_MONITOR__SV
