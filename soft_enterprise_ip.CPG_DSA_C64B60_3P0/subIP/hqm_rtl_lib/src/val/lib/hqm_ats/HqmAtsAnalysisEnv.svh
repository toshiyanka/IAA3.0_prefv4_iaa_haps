// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright 2010 - 2016 Intel Corporation
//
// The  source  code  contained or described herein and all documents related to
// the source code ("Material") are  owned by Intel Corporation or its suppliers
// or  licensors. Title to  the  Material  remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets  and proprietary
// and confidential information of Intel or  its  suppliers  and  licensors. The
// Material is protected by worldwide copyright and trade secret laws and treaty
// provisions.  No  part  of  the  Material  may  be used,   copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No  license  under  any patent, copyright, trade secret or other intellectual
// property  right is granted to or conferred upon you by disclosure or delivery
// of  the  Materials, either  expressly,  by  implication, inducement, estoppel
// or  otherwise. Any  license  under  such intellectual property rights must be
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
//
// Owner:       Adil Shaaeldin
// Created On:  1/12/2017
// Description: HQM Environment Verification Component
//              ---------------------------------------
//
//
// -----------------------------------------------------------------------------
// CLASS: HqmAtsAnalysisEnv

//--AY_HQMV30_ATS--  

//
class HqmAtsAnalysisEnv extends ovm_component;

    `ovm_component_utils(HqmAtsAnalysisEnv)

    // -------------------------------------------------------------------------
    // Analysis Export
    ovm_analysis_export #(HqmBusTxn)    primBus_export;

    // -------------------------------------------------------------------------
    // TB Config Object
    HqmAtsCfgObj                  ats_cfg;

    // TLM FIFO storing IOSF Txn
    tlm_analysis_fifo #(HqmBusTxn)  prim_fifo;

    // HQM Analysis Tracker
    HqmAtsTracker      hqm_analysis_tracker;

    // HQM Analysis Checker
    HqmAtsChecker      hqm_analysis_checker;


    // Log filename for this environment
    local OVM_FILE          _hqm_analysis_file;
    protected bit           disableSetupReporting;

    HqmIommuAPI                  iommu_api;

    // -------------------------------------------------------------------------
    function new (string name = "HqmAtsAnalysisEnv", ovm_component parent = null);
        super.new(name, parent);
    endfunction

    // -----------------------------------------------------------------------
    virtual function void setDisableSetupReporting(bit dis=1);
        disableSetupReporting = dis;
    endfunction
    
    // -----------------------------------------------------------------------
    virtual function bit getDisableSetupReporting();
        return disableSetupReporting;
    endfunction

    // -----------------------------------------------------------------------
    virtual function OVM_FILE getFile();
        return _hqm_analysis_file;    
    endfunction
    
    // -------------------------------------------------------------------------
    virtual function void setupReporting();
        // First setup reporting for this component and down
        if ( _hqm_analysis_file != 0 ) begin
            set_report_default_file_hier(_hqm_analysis_file);
        end 
        if ( ! ats_cfg.get_disable_tb_report_severity_settings() ) begin
            set_report_severity_action_hier(OVM_INFO,    OVM_LOG);
            set_report_severity_action_hier(OVM_WARNING, OVM_LOG);
            set_report_severity_action_hier(OVM_ERROR,   OVM_DISPLAY | OVM_LOG);
            set_report_severity_action_hier(OVM_FATAL, OVM_DISPLAY | OVM_LOG | OVM_EXIT);
        end 
        
        // Now set up for the lower level components
        hqm_analysis_checker.setupReporting();
    endfunction

    // -------------------------------------------------------------------------
    // Function     :   init()
    // Description  :
    function void init ();
        ovm_object obj;
        bit rc;

        // Get IOMMU CFG
        rc = get_config_object("AtsCfgObj", obj, 0);
        `sla_assert(rc, ("init(): Can't get config object"))

        rc = ($cast(ats_cfg, obj) > 0);
        `sla_assert(rc, ("init(): Config object is wrong type"))

        // Set Output File
        _hqm_analysis_file = $fopen(ats_cfg.ENV_FILENAME, "a");

    endfunction : init


    // OVM Phase: build --------------------------------------------------------
    function void build ();

        super.build();

        init();

        ovm_report_info(get_type_name(),"build(): ------- BEGIN -------", OVM_NONE);

        if ( ats_cfg.disable_tracker && ats_cfg.disable_checker ) begin
            `ovm_fatal(get_type_name(), $sformatf("build(): '%s' was created without setting the HQM Analysis Tracker or Checker Enables in HqmIommuAnalysisCfgObj.", get_name()))
        end

        ovm_report_info(get_type_name(), $sformatf("build(): HQM_ANALYSIS_TRACKER_EN = %b", ~ats_cfg.disable_tracker), OVM_LOW);
        ovm_report_info(get_type_name(), $sformatf("build(): HQM_ANALYSIS_CHECKER_EN = %b", ~ats_cfg.disable_checker), OVM_LOW);

        // Primary Export
        primBus_export       = new("primBus_export", this);

        // Primary Bus FIFO
        prim_fifo            = new("prim_fifo", this);

        // IOMMU Tracker
        if (! ats_cfg.disable_tracker) begin
            hqm_analysis_tracker = HqmAtsTracker::type_id::create("hqm_analysis_tracker", this);
        end


        // IOMMU Checker
        if (! ats_cfg.disable_checker) begin
            hqm_analysis_checker = HqmAtsChecker::type_id::create("hqm_analysis_checker", this);
            hqm_analysis_checker.setDisableSetupReporting();
        end

        ovm_report_info(get_type_name(),"build(): ------- END   -------\n", OVM_NONE);

    endfunction : build


    // OVM Phase: connect ------------------------------------------------------
    function void connect ();
        super.connect();

        if ( ! getDisableSetupReporting() ) begin
            setupReporting();
        end 
            
        primBus_export.connect    (prim_fifo.analysis_export);

        // Connect AE to ATS Checker
        primBus_export.connect    (hqm_analysis_checker.fifo.analysis_export);

    endfunction : connect

    // ----------------------------------------------------------
    task run();
        int id = 0;

        fork
            while (1) begin
                 HqmBusTxn         txn;
                HqmAtsAnalysisTxn ats_txn;
                if ( ats_cfg.disable_tracker ) begin
                    break;
                end 
                prim_fifo.get(txn);
    
                ats_txn = gen_ats_packet(txn);
                
                if ( ats_txn != null ) begin
                    ats_txn.id = id;
                    hqm_analysis_tracker.fifo.write(ats_txn);
                    id++;
                end 
            end 
        join_none
    endtask : run

    function HqmAtsAnalysisTxn gen_ats_packet(HqmBusTxn x, int id=0);
        HqmCmdType_t cmd = x.getCmdType();
        
        if ( x.phase != HQM_TXN_COMPLETE_PHASE ) begin
            return null;
        end 
        
        gen_ats_packet = new($sformatf("ats_pkt"));
        
        if ( ats_cfg.is_ats_request(x) ) begin // Translation Requests
            gen_ats_packet.ats_cmd = ATS_TREQ;
        end else if ( ats_cfg.is_ats_response(x) ) begin // Translation Completions
            gen_ats_packet.ats_cmd = ATS_TCPL;
            if ( cmd == HQM_CplD) gen_ats_packet.num_tracker_row_entries = x.length>>1;
            gen_ats_packet.AtsTcpl_s.completer_id        = x.address[31:16];
            gen_ats_packet.AtsTcpl_s.completion_status   = HqmPcieCplStatus_t'(x.fbe[3:0]);
            gen_ats_packet.AtsTcpl_s.byte_count          = {x.address[15:8], x.lbe[3:0]};
            gen_ats_packet.AtsTcpl_s.lower_address       = x.address[6:0]; 
        end else if ( ats_cfg.is_page_request(x) ) begin // Page Request Messages
            gen_ats_packet.ats_cmd = ATS_PREQ;
            gen_ats_packet.PrsPreq_s.page_address               = {x.address[31: 0], x.address[63:32]};  // IOSF does not conform to PCIE on message payload. Must swap upper/lower DW.
            gen_ats_packet.PrsPreq_s.page_address_masked        = {gen_ats_packet.PrsPreq_s.page_address[63:12], 12'h000};
            gen_ats_packet.PrsPreq_s.prg_index                  = gen_ats_packet.PrsPreq_s.page_address[11: 3];
            gen_ats_packet.PrsPreq_s.last_page_req              = gen_ats_packet.PrsPreq_s.page_address[    2];
            gen_ats_packet.PrsPreq_s.write_access_requested     = gen_ats_packet.PrsPreq_s.page_address[    1];
            gen_ats_packet.PrsPreq_s.read_access_requested      = gen_ats_packet.PrsPreq_s.page_address[    0];
        end else if ( ats_cfg.is_page_group_response(x) ) begin // Page Group Response Message
            gen_ats_packet.ats_cmd = ATS_PRSP;
            gen_ats_packet.PrsPrgRsp_s.destination_device_id = x.address[31:16];                        // see IOSF Specification r1.2 (Table 2-12: Message Format, page 81)
            gen_ats_packet.PrsPrgRsp_s.response_code         = HqmPciePrgRspCode_t'(x.address[15:12]);  // see IOSF Specification r1.2 (Table 2-12: Message Format, page 81)
            gen_ats_packet.PrsPrgRsp_s.prg_index             = x.address[ 8: 0];                        // see IOSF Specification r1.2 (Table 2-12: Message Format, page 81)
        end else if ( ats_cfg.is_invalidation_request(x) ) begin
            gen_ats_packet.ats_cmd = ATS_IREQ;
            gen_ats_packet.num_tracker_row_entries         = x.length>>1;
            gen_ats_packet.AtsIReq_s.destination_device_id = x.address[31:16];   // see IOSF Specification r1.2 (Table 2-12: Message Format, page 81)
            gen_ats_packet.AtsIReq_s.itag                  = x.txn_id.tag[4:0];  // Tag field for Invalidation only occupies [4:0]
        end else if ( ats_cfg.is_invalidation_response(x) ) begin
            gen_ats_packet.ats_cmd = ATS_IRSP;
            gen_ats_packet.AtsIRsp_s.destination_device_id = x.address[31:16];   // see IOSF Specification r1.2 (Table 2-12: Message Format, page 81)
            gen_ats_packet.AtsIRsp_s.completion_count      = x.address[ 2: 0];   // see IOSF Specification r1.2 (Table 2-12: Message Format, page 81)
            gen_ats_packet.AtsIRsp_s.itagv                 = x.address[63:32];   // see IOSF Specification r1.2 (Table 2-12: Message Format, page 81)
        end else begin
            gen_ats_packet = null;
        end 

        // Fill in the rest of the fields
        if ( gen_ats_packet != null ) begin
            // copy IOSF Primary's Txn seq_item to new seq_item of the same class family
            gen_ats_packet.do_copy(x);
            gen_ats_packet.ats_cfg = ats_cfg;
            gen_ats_packet.simulation_time = $realtime;
        end 

    endfunction

endclass : HqmAtsAnalysisEnv
