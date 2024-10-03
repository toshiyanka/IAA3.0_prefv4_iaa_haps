class hqm_tap_rtdr_common_val_env extends sla_tb_env;

    // declare OVM int for scoreboard control
    //////////////////////////////////////////////////////////////////////
    `ovm_component_utils(hqm_tap_rtdr_common_val_env)


    // jtag bfm declarations
    //////////////////////////////////////////////////////////////////////
    protected JtagBfmCfg jtag_bfm_cfg_obj;
    protected JtagBfmMasterAgent_T jtag_bfm_agent;
    ovm_analysis_port #(JtagBfmInMonSbrPkt)  jtag_in_port;
    ovm_analysis_port #(JtagBfmOutMonSbrPkt) jtag_out_port;


    // stf bfm declarations
    //////////////////////////////////////////////////////////////////////


    // itpp reader declarations
    //////////////////////////////////////////////////////////////////////

  
    // cabist checker declarations
    //////////////////////////////////////////////////////////////////////


    // public function definitions
    //////////////////////////////////////////////////////////////////////
    function JtagBfmPkg::JtagBfmCfg get_jtag_bfm_config();
        return this.jtag_bfm_cfg_obj;
    endfunction : get_jtag_bfm_config

    function JtagBfmMasterAgent_T get_jtag_bfm_agent();
        return this.jtag_bfm_agent;
    endfunction : get_jtag_bfm_agent

    function JtagBfmPkg::JtagBfmSequencer get_jtag_bfm_sequencer();
        return this.jtag_bfm_agent.Sequencer;
    endfunction : get_jtag_bfm_sequencer




    // constructor definition
    //////////////////////////////////////////////////////////////////////
    protected function new(string name, ovm_component parent);
        super.new(name, parent);
        `ovm_info(get_type_name(), "HQM_RTDR_TAP val environment constructor() complete", OVM_NONE)
    endfunction : new


    // build function definition
    //////////////////////////////////////////////////////////////////////
    protected function void build();

        super.build();

        // jtag bfm setup
        //////////////////////////////////////////////////////////////////
        jtag_bfm_agent = JtagBfmMasterAgent_T::type_id::create("jtag_bfm_agent", this);
        set_config_int("*.Sequencer", "count", 0);

        // jtag tlm setup
        //////////////////////////////////////////////////////////////////
        jtag_in_port   = new("hqm_tap_rtdr_env_jtag_in_port", this);
        jtag_out_port  = new("hqm_tap_rtdr_env_jtag_out_port", this);

        // jtag bfm config object setup
        //////////////////////////////////////////////////////////////////
        jtag_bfm_cfg_obj = JtagBfmCfg::type_id::create("jtag_bfm_cfg_obj", this);
        jtag_bfm_cfg_obj.is_active                      = OVM_ACTIVE;
        jtag_bfm_cfg_obj.enable_clk_gating              = 1;
        jtag_bfm_cfg_obj.park_clk_at                    = 0;
        jtag_bfm_cfg_obj.primary_tracker                = 1;
        jtag_bfm_cfg_obj.tracker_name                   = "hqm_tap_rtdr_common_val_env";
        jtag_bfm_cfg_obj.jtag_bfm_tracker_en            = 1;
        jtag_bfm_cfg_obj.jtag_bfm_runtime_tracker_en    = 1;
        jtag_bfm_cfg_obj.quit_count                     = 0;

        jtag_bfm_cfg_obj.use_rtdr_interface             = 1;

        if ($test$plusargs("USE_HQM_TAP_RTDR_BUS")) begin
           jtag_bfm_cfg_obj.rtdr_is_bussed                 = 1;
        end else begin
           jtag_bfm_cfg_obj.rtdr_is_bussed                 = 0;
        end 


        set_config_object("jtag_bfm_agent*", "JtagBfmCfg", jtag_bfm_cfg_obj, 1);
        set_config_int("jtag_bfm_agent*", "use_rtdr_interface", jtag_bfm_cfg_obj.use_rtdr_interface);
        set_config_int("jtag_bfm_agent*", "rtdr_is_bussed", jtag_bfm_cfg_obj.rtdr_is_bussed);
        `ovm_info(get_type_name(), "HQM_RTDR_TAP JTAG BFM config object info:", OVM_NONE)
        jtag_bfm_cfg_obj.print();

        // stf bfm setup
        //////////////////////////////////////////////////////////////////
      
        // stf bfm config object setup
        //////////////////////////////////////////////////////////////////
        
        // itpp reader setup
        //////////////////////////////////////////////////////////////////

        // cabist fr checker setup
        //////////////////////////////////////////////////////////////////

        `ovm_info(get_type_name(), "HQM_RTDR_TAP val environment build() complete", OVM_NONE)

    endfunction : build


    // ovm connect function definition
    //////////////////////////////////////////////////////////////////////
    protected function void connect();


        super.connect();

        // jtag bfm connections
        //////////////////////////////////////////////////////////////////
        void'(this.add_sequencer("jtag", "jtag_bfm_sequencer_prim", jtag_bfm_agent.Sequencer));

      
        // expose JTAG BFM Monitor TLM ports
        //////////////////////////////////////////////////////////////////
        jtag_bfm_agent.InputMonitor.InputMonitorPort.connect(jtag_in_port);
        jtag_bfm_agent.OutputMonitor.OutputMonitorPort.connect(jtag_out_port);

        `ovm_info(get_type_name(), "HQM_RTDR_TAP val environment connect() complete", OVM_HIGH);

    endfunction : connect


    // ovm run task definition
    //////////////////////////////////////////////////////////////////////
    protected task run();
        super.run();
        //DUT clk en to enable the STF monitor for the FR checker 
        //stf_dut_clk_in_en_seq.set_fields(0,5);
        //stf_dut_clk_in_en_seq.start(stf_bfm_agent.i_STF_BFM_Sequencer);
    endtask:run


endclass : hqm_tap_rtdr_common_val_env
