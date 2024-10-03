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
// ---------------------------------------------------------------------------
//
// Created By:  Adil Shaaeldin
// Created On:  10/12/2018
// Description: HQM ATS Checker
//              
// Notes/TODOs:
//   'Global' bit not handled robustly as today, IOMMU will never set this bit
//          
// ---------------------------------------------------------------------------

//--AY_HQMV30_ATS--  

class HqmAtsChecker extends ovm_component;

    // -----------------------------------------------------------------------
    `ovm_component_utils(HqmAtsChecker)

    // ATS Checker Filename
    local OVM_FILE _trk_file;
    protected bit  disableSetupReporting;
    
    protected HqmAtsID_t _atsID = 0;
    protected HqmInvID_t _invID = 0;
    protected HqmPrsID_t _prsID = 0;
    
    // -------------------------------------------------------------------------
    // TB Config Object
    HqmAtsCfgObj  ats_cfg;

    // TLM FIFO
    tlm_analysis_fifo #(HqmBusTxn) fifo;

    protected ovm_event_pool _eventPool;   // Handle to the OVM Event Pool

    protected bit [2:0] exp_ats_chid = 2'b00; // In HQM, is there any requirement in terms of channel?  is channel 0 used?  //In DSA: Expected chid to see ATS requests. Default 'chid' is 2
    protected bit [2:0] exp_ats_tc;           // Expected traffic class to see ATS requests

    // TODO: The structure below needs to be reviewed. It has a strange usage that it looks like it is test scenario specific
    //  and not for generic use. 
    // The 'inv_addr_q' gets populated every time an invalidation request is seen. But nothing ever removes an entry
    // from this structure. 
    bit [4:0] inv_addr_q[bit [63:0]][HqmPasid_t];

    HqmAtsReqRsp_t    ats_reqrsp[HqmTxnID_t];        // Indexed by 10-bit tag, contains the outstanding ATS requests
    HqmAtsInvReqRsp_t inv_reqrsp[bit [15:0]][32];    // Indexed by itag (constrained to 0-31 per PCIE spec 10.3.1). Contains the invalidation requests
    HqmAtcEntry_t     atc[bit [63:0]][$];            // Mapping of physical (translated) address to an ATC Entry
    protected bit [63:0] _atc_logical_lookup[HqmAtcLAddrLookup_t]; // Logical address lookup for the ATC entries

    HqmPrsReq_t       _prs_req_q[$];                 // Queue holding the page requests seen
    
    // Acceptable invalidation range list. 
    protected RangeSize_t  acceptable_inv_range [$]; 
    
    // The following represent event names (ovm_event) that this component can use to trigger activities based on a reset. This will help it
    // track when to 'reset' the internal data structures. These events should fire when the HW has effectively been reset. Hash key is the 'BDF'
    // of the device. 
    // 'Chassis' Resets are defined as resets that result in IOSF resets to assert.
    // 'Non-Chassis' Resets are defined as either FLR or SW resets type of resets
    protected string chassis_reset_event_name[bit [15:0]];
    protected string non_chassis_reset_event_name[bit [15:0]];

    // Hash key is the 'BDF' or ReqID of the device. The idea behind this structure is that a device may register a set of addresses it plans
    // to use as 'untranslated' without going through the ATS flow (like if ATS was off). This list can then be queried in the 'processNonAtsMemRequest' 
    // when it does its checks. The reason why this might be useful is that this checker has no idea whether an untranslated address is being 
    // used due to the ATS flow or for some other hardware specific reason. (like ATS is turned off for a specific subsection of the RTL). Because
    // it does not know such intricacies, this means the checks that are done for untranslated addresses is very limited (due to this ambiguity). 
    // This safe list can be used dynamically by the TB to add or remove certain addresses the HW will use as untranslated. Those addresses then get
    // the 'relaxed' checking. Untranslated addresses that are not existing in this list will get the 'strict' checking (i.e. It can only be untranslated
    // if the ATS request said it was untranslated)
    protected bit untranslated_safe_list[bit[15:0]][bit[63:0]];

    // Default verbosity used for OVM_INFO messages. Can be changed via command line to isolate debug
    protected ovm_verbosity    _atcCheckerDbg = OVM_MEDIUM; // Default verbosity (can be controlled by command line)

    // Hash key is the reqid/bdf, address, and the pasidtlp. 
    // With each descriptor submitted to the device, the acl driver will need to call register_legal_translation,
    // to register all the legal ats requests which the RTL can request for the descriptor. 
    // this list will be cleaned up once a reset is asserted
    protected HqmAtsPkg::HqmAtsAddrList_t legal_translations[HqmAtsLegalTranslations_t];
    
    protected ovm_event _ats_req_e; // Event handle to trigger when ATS request is received
    protected ovm_event _ats_cpl_e; // Event handle to trigger when ATS completions are received
    protected ovm_event _inv_req_e; // Event handle to trigger when Invalidation Request is received
    protected ovm_event _inv_rsp_e; // Event handle to trigger when Invalidation Completion is received
    protected ovm_event _prs_req_e; // Event handle to trigger when PRS request is sent
    protected ovm_event _prg_rsp_e; // Event handle to trigger when Page Request Responses are received
    
    ovm_event                                         ats_en_change; // ATS EN went low
    
    // covergroups and related vars 
    HqmAtsReqRsp_t    ats_request_cov;
    HqmAtsReqRsp_t    ats_response_cov;
    RangeSize_t       ats_response_size_cov;
    HqmPrsReq_t       prs_request_cov;
    HqmPrgRsp_t       prs_response_cov;
    HqmAtsInvReqRsp_t inv_request_cov;
    HqmAtsInvReqRsp_t inv_response_cov;
`ifndef EXCLUDE_HQM_TB_CG
    covergroup ats_req_cov ;
        //pasid
        cp_ats_req_pasid : coverpoint ats_request_cov.pasidtlp.pasid {
            bins pasid_0 = {[20'h0:20'hff]};
            bins pasid_1 = {[20'h100:20'hffff]};
            bins pasid_2 = {[20'h10000:20'hfffff]};
        }
        // logical address
        cp_ats_req_l_addr : coverpoint ats_request_cov.l_address_4k {
            bins l_address_4k_0= {[64'h0:64'hffff]};
            bins l_address_4k_1= {[64'h1_0000:64'hffff_ffff]};
            bins l_address_4k_2= {[64'h1_0000_0000:64'hffff_ffff_ffff]};
            bins l_address_4k_3= {[64'h1_0000_0000_0000:64'hffff_ffff_ffff_ffff]};
        }
        // No Write
        cp_ats_req_nw : coverpoint ats_request_cov.nw {
            bins nw[2] = {[0:1]};
        }
        // traffic class
        cp_ats_req_tc : coverpoint ats_request_cov.tc {
            bins tc[4] = {[0:'hf]};
        }// priv
        cp_ats_req_priv : coverpoint ats_request_cov.pasidtlp.priv_mode_requested {
            bins priv[2] = {[0:1]};
        }// priv
        cp_ats_req_exec : coverpoint ats_request_cov.pasidtlp.exe_requested {
            bins exec[2] = {[0:1]};
        }
    endgroup
    
    covergroup ats_rsp_cov ;
        // Physical address
        cp_ats_rsp_p_addr : coverpoint ats_response_cov.p_address {
            bins p_address_0= {[64'h0:64'hffff]};
            bins p_address_1= {[64'h1_0000:64'hffff_ffff]};
            bins p_address_2= {[64'h1_0000_0000:64'hffff_ffff_ffff]};
            bins p_address_3= {[64'h1_0000_0000_0000:64'hffff_ffff_ffff_ffff]};
        }
        // Read Write
        cp_ats_rsp_rw : coverpoint ats_response_cov.cpl_data_fields.read_write {
            bins rw[] = {[ats_response_cov.cpl_data_fields.read_write.first:ats_response_cov.cpl_data_fields.read_write.last]};
        }
        // Field S
        cp_ats_rsp_size : coverpoint ats_response_cov.cpl_data_fields.size_of_xlat {
            bins size_of_xlat[2] = {[0:1]};
        }
        // translation size
        cp_ats_response_size : coverpoint ats_response_size_cov {
            bins ats_response_size_cov[] = {[ats_response_size_cov.first:ats_response_size_cov.last]};
        }
        // Field N
        cp_ats_rsp_non_snoop : coverpoint ats_response_cov.cpl_data_fields.non_snoop_acc {
            bins non_snoop_acc[2] = {[0:1]};
        }
        // Field Global
        cp_ats_rsp_global : coverpoint ats_response_cov.cpl_data_fields.global_mapping {
            bins global_mapping[2] = {[0:1]};
        }
        // Field E
        cp_ats_rsp_e : coverpoint ats_response_cov.cpl_data_fields.execute_permitted {
            bins execute_permitted[2] = {[0:1]};
        }
        // Field P
        cp_ats_rsp_p : coverpoint ats_response_cov.cpl_data_fields.priv_mode_access {
            bins priv_mode_access[2] = {[0:1]};
        }
        // Field U
        cp_ats_rsp_u : coverpoint ats_response_cov.cpl_data_fields.unxlat_access {
            bins unxlat_access[2] = {[0:1]};
        }
    endgroup
    
    covergroup prs_req_cov ;
        //pasid
        cp_prs_req_pasid : coverpoint prs_request_cov.pasidtlp.pasid {
            bins pasid[100] = {[20'h0:20'hfffff]};
        }
        // logical address
        cp_prs_req_l_addr : coverpoint prs_request_cov.address {
            bins l_address_4k_0= {[64'h0:64'hffff]};
            bins l_address_4k_1= {[64'h1_0000:64'hffff_ffff]};
            bins l_address_4k_2= {[64'h1_0000_0000:64'hffff_ffff_ffff]};
            bins l_address_4k_3= {[64'h1_0000_0000_0000:64'hffff_ffff_ffff_ffff]};
        }
        //Read
        cp_prs_req_r : coverpoint prs_request_cov.data_fields.read {
            bins r[] = {[0:1]};
        }
        //Write
        cp_prs_req_w : coverpoint prs_request_cov.data_fields.write {
            bins w[] = {[0:1]};
        }
        //Last
        cp_prs_req_last : coverpoint prs_request_cov.data_fields.last_req {
            bins l[] = {[0:1]};
        }
        //prgi
        cp_prs_req_prgi : coverpoint prs_request_cov.data_fields.page_req_group_index {
            bins prgi[] = {[0:9'h1ff]};
        }
        // traffic class
        cp_prs_req_tc : coverpoint prs_request_cov.tc {
            bins tc[1] = {0};
        }
        
    endgroup
    
    covergroup prs_rsp_cov ;
        //pasid
        cp_prs_rsp_pasid : coverpoint prs_response_cov.pasidtlp {
            bins pasid[100] = {[20'h0:20'hfffff]};
        }
        //prgi
        cp_prs_req_prgi : coverpoint prs_response_cov.data_fields.page_req_group_index {
            bins prgi[] = {[0:9'h1ff]};
        }
        //rsp code
        cp_prs_rsp_code : coverpoint prs_response_cov.data_fields.rsp_code {
            bins rspcode[] = {[prs_response_cov.data_fields.rsp_code.first:prs_response_cov.data_fields.rsp_code.last]};
        }
        //dest device id
        cp_prs_rsp_ddid : coverpoint prs_response_cov.data_fields.dest_devid {
            bins destination_device_id_0 = {16'h0};
            ignore_bins ignr_vals = {[16'h1:16'hf]};
        }
        // traffic class
        cp_prs_req_tc : coverpoint prs_response_cov.tc {
             bins tc[1] = {0};
        }
        
    endgroup
    
    covergroup inv_req_cov ;
        //pasid
        cp_inv_req_pasid : coverpoint inv_request_cov.pasidtlp.pasid {
            bins pasid[100] = {[20'h0:20'hfffff]};
        }
        // logical address
        cp_inv_req_l_addr : coverpoint inv_request_cov.address {
            bins l_address_4k_0= {[64'h0:64'hffff]};
            bins l_address_4k_1= {[64'h1_0000:64'hffff_ffff]};
            bins l_address_4k_2= {[64'h1_0000_0000:64'hffff_ffff_ffff]};
            bins l_address_4k_3= {[64'h1_0000_0000_0000:64'hffff_ffff_ffff_ffff]};
        }
        // global inv
        cp_inv_req_glbl_inv : coverpoint inv_request_cov.global_invalidate {
            bins g[2] = {[0:1]};
        }
        // itag
        cp_inv_req_itag : coverpoint inv_request_cov.itag {
            bins itag[] = {[0:'hf]};
        }
        // size
        cp_inv_req_size : coverpoint inv_request_cov.size {
            bins size[] = {[0:1]};
        }
        // range
        cp_inv_req_range : coverpoint inv_request_cov.range {
            bins range[] = {[inv_request_cov.range.first:inv_request_cov.range.last]};
        }
        
    endgroup
    
    covergroup inv_rsp_cov;
        // itagv
        cp_inv_rsp_itagv : coverpoint inv_response_cov.itag_vector {
            bins itag_vector_0= {[32'h0:32'hff]};
            bins itag_vector_1= {[32'h100:32'hffff]};
            bins itag_vector_2= {[32'h10000:32'hff_ffff]};
            bins itag_vector_3= {[32'h1000000:32'hffff_ffff]};
        }
        // size
        cp_inv_rsp_c : coverpoint inv_response_cov.cc {
            bins cc[] = {[0:7]};
        }
    endgroup
`endif 
    
    // -----------------------------------------------------------------------
    function new(string name = "HqmAtsInvalidationchecker", ovm_component parent = null);
        string debugStr = "";
        
        super.new(name, parent);
        
        if ( $value$plusargs("ATS_CHECKER_DBG=%s", debugStr)) begin
            case ( debugStr )
                "OVM_NONE"   : _atcCheckerDbg = OVM_NONE;
                "OVM_LOW"    : _atcCheckerDbg = OVM_LOW;
                "OVM_MEDIUM" : _atcCheckerDbg = OVM_MEDIUM;
                "OVM_HIGH"   : _atcCheckerDbg = OVM_HIGH;
                "OVM_FULL"   : _atcCheckerDbg = OVM_FULL;
                default      : `ovm_fatal(get_name(), $sformatf("Invalid verbosity specified: ATS_CHECKER_DBG='%s'", _atcCheckerDbg))
            endcase 
            `ovm_info(get_name(), $sformatf("Command line override ATS_CHECKER_DBG=%s", _atcCheckerDbg.name()), OVM_LOW);
        end
`ifndef EXCLUDE_HQM_TB_CG
        ats_req_cov = new();
        ats_rsp_cov = new();
        prs_req_cov = new();
        prs_rsp_cov = new();
        inv_req_cov = new();
        inv_rsp_cov = new();
`endif 
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
        return _trk_file;    
    endfunction
    
    // -------------------------------------------------------------------------
    virtual function void setupReporting();
        if ( _trk_file != 0 ) begin
            set_report_default_file_hier(_trk_file);
        end 

        if ( ! ats_cfg.get_disable_tb_report_severity_settings() ) begin
            set_report_severity_action_hier(OVM_INFO,    OVM_LOG);
            set_report_severity_action_hier(OVM_WARNING, OVM_LOG);
            set_report_severity_action_hier(OVM_ERROR,   OVM_DISPLAY | OVM_LOG);
            set_report_severity_action_hier(OVM_FATAL, OVM_DISPLAY | OVM_LOG | OVM_EXIT);
        end
    endfunction
    
    // -------------------------------------------------------------------------
    // Function     :   init()
    // Description  :
    function void init ();
        bit rc;
        ovm_object obj;

        rc = get_config_object("AtsCfgObj", obj, 0);
        `sla_assert(rc, ("init(): Can't get config object"))

        rc = ( $cast(ats_cfg, obj) > 0 );
        `sla_assert(rc, ("init(): Config object is wrong type"))

        // Set Output File
        _trk_file = $fopen(ats_cfg.CHECKER_FILENAME, "a");

    endfunction : init


    // OVM Phase: build --------------------------------------------------------
    function void build();

        super.build();

        init();

        // IOSF TLM FIFO
        fifo = new("CHECKER_FIFO", this);

        // populate acceptable range of ATS INV
        for ( RangeSize_t range=RANGE_4K; range>range.first(); range=range.next() ) begin
            acceptable_inv_range.push_back(range);
        end

        _eventPool = ovm_event_pool::get_global_pool();

    endfunction : build


    // -----------------------------------------------------------------------
    virtual function void connect();
        super.connect();
        
        if ( ! getDisableSetupReporting() ) begin
            setupReporting();
        end 
    endfunction

    // -----------------------------------------------------------------------
    // Registers the event handle to use for event triggering
    virtual function void registerPrsReqEvent(string name="");
        `ovm_info(get_name(), $sformatf("registerPrsReqEvent(): Registered Event '%s'", name), OVM_LOW);
        _prs_req_e = _eventPool.get(name); 
    endfunction

    // -----------------------------------------------------------------------
    // Registers the event handle to use for event triggering
    virtual function void registerPrgRspEvent(string name="");
        `ovm_info(get_name(), $sformatf("registerPrgRspEvent(): Registered Event '%s'", name), OVM_LOW);
        _prg_rsp_e = _eventPool.get(name); 
    endfunction

    // -----------------------------------------------------------------------
    // Registers the event handle to use for event triggering on ATS Requests
    virtual function void registerAtsReqEvent(string name="");
        `ovm_info(get_name(), $sformatf("registerAtsReqEvent(): Registered Event '%s'", name), OVM_LOW);
        _ats_req_e = _eventPool.get(name); 
    endfunction
    
    // -----------------------------------------------------------------------
    // Registers the event handle to use for event triggering
    virtual function void registerAtsRspEvent(string name="");
        `ovm_info(get_name(), $sformatf("registerAtsRspEvent(): Registered Event '%s'", name), OVM_LOW);
        _ats_cpl_e = _eventPool.get(name); 
    endfunction

    // -----------------------------------------------------------------------
    // Registers the event handle to use for event triggering
    virtual function void registerInvReqEvent(string name="");
        `ovm_info(get_name(), $sformatf("registerInvReqEvent(): Registered Event '%s'", name), OVM_LOW);
        _inv_req_e = _eventPool.get(name); 
    endfunction
    
    // -----------------------------------------------------------------------
    // Registers the event handle to use for event triggering
    virtual function void registerInvRspEvent(string name="");
        `ovm_info(get_name(), $sformatf("registerInvRspEvent(): Registered Event '%s'", name), OVM_LOW);
        _inv_rsp_e = _eventPool.get(name); 
    endfunction

    // -----------------------------------------------------------------------
    function void signalPrsReqEvent(HqmPrsReq_t prsReq);
        if ( _prs_req_e != null ) begin
            HqmAtsEventContainerObj obj = HqmAtsEventContainerObj::type_id::create($sformatf("prs_0x%05h_0x%03h", prsReq.txn_id.req_id, prsReq.txn_id.tag));
            obj.setPageReq(prsReq);
            _prs_req_e.trigger(obj);
        end 
    endfunction
    
    // -----------------------------------------------------------------------
    function void signalPrgRspEvent(HqmPrsReq_t prsReq, HqmPrgRsp_t prgRsp);
        if ( _prg_rsp_e != null ) begin
            HqmAtsEventContainerObj obj = HqmAtsEventContainerObj::type_id::create($sformatf("prs_0x%05h_0x%03h", prgRsp.txn_id.req_id, prgRsp.txn_id.tag));
            obj.setPageGrpReqRsp(prgRsp); 
            obj.setPageReq(prsReq);
            _prg_rsp_e.trigger(obj);
        end 
    endfunction
    
    // -----------------------------------------------------------------------
    function void signalAtsReqEvent(HqmAtsReqRsp_t atsReq);
        if ( _ats_req_e != null ) begin
            HqmAtsEventContainerObj obj = HqmAtsEventContainerObj::type_id::create($sformatf("atsreq_0x%05h_0x%03h", atsReq.txn_id.req_id, atsReq.txn_id.tag));
            obj.setAtsReq(atsReq); 
            _ats_req_e.trigger(obj);
        end 
    endfunction
    
    // -----------------------------------------------------------------------
    function void signalAtsCplEvent(HqmAtsReqRsp_t atsReq, HqmAtsReqRsp_t atsRsp);
        if ( _ats_cpl_e != null ) begin
            HqmAtsEventContainerObj obj = HqmAtsEventContainerObj::type_id::create($sformatf("atscpl_0x%05h_0x%03h", atsReq.txn_id.req_id, atsReq.txn_id.tag));
            obj.setAtsReq(atsReq); 
            obj.setAtsCpl(atsRsp);
            _ats_cpl_e.trigger(obj);
        end 
    endfunction
    
    // -----------------------------------------------------------------------
    function void signalInvReqEvent(HqmAtsInvReqRsp_t invReq);
        if ( _inv_req_e != null ) begin
            HqmAtsEventContainerObj obj = HqmAtsEventContainerObj::type_id::create($sformatf("invreq_0x%05h_0x%03h", invReq.txn_id.req_id, invReq.txn_id.tag));
            obj.setInvReq(invReq); 
            _inv_req_e.trigger(obj);
        end 
    endfunction
    
    // -----------------------------------------------------------------------
    function void signalInvRspEvent(HqmAtsInvReqRsp_t invReq, HqmAtsInvReqRsp_t invRsp);
        if ( _inv_rsp_e != null ) begin
            HqmAtsEventContainerObj obj = HqmAtsEventContainerObj::type_id::create($sformatf("invrsp_0x%05h_0x%03h", invRsp.txn_id.req_id, invRsp.txn_id.tag));
            obj.setInvReq(invReq); 
            obj.setInvRsp(invRsp);
            _inv_rsp_e.trigger(obj);
        end 
    endfunction
    
    // -----------------------------------------------------------------------
    // -----------------------------------------------------------------------
    virtual task run();
        HqmBusTxn  txn;
        fork
            while (1) begin
                fifo.get(txn);

                case (txn.phase)
                    HQM_CMD_PHASE : begin
                        HqmCmdType_t cmd = txn.getCmdType();
                        if ( txn.direction == HQM_IP_TX && (cmd inside {HQM_MRd32, HQM_MRd64, HQM_MWr32, HQM_MWr64}) && (txn.at inside {HQM_AT_UNTRANSLATED, HQM_AT_TRANSLATED}) ) begin
                            processNonAtsMemRequest(txn);
                        end 
                    end 
                    HQM_TXN_COMPLETE_PHASE : begin
                        if ( txn.direction == HQM_IP_TX ) begin
                            processOutTxn(txn);   // Transactions sent by the RTL
                        end else begin
                            processInTxn(txn);    // Transactions sent to the RTL
                        end 
                    end 
                endcase
            end

            monitor_reset();
        join_none
    endtask
    
    // -------------------------------------------------------------------------
    // Registers and address to the safe list that enables the 'relaxed' checking. 
    function void register_unstranslated_safe_list_address(bit [15:0] bdf, bit [63:0] address);
        address = address & ~64'h0FFF;
        untranslated_safe_list[bdf][address] = 1;
    endfunction
    
    // -------------------------------------------------------------------------
    // Removes an address from the safe list 
    function void delete_unstranslated_safe_list_address(bit [15:0] bdf, bit [63:0] address);
        address = address & ~64'h0FFF;
        if ( untranslated_safe_list.exists(bdf) && untranslated_safe_list[bdf].exists(address) ) begin
            untranslated_safe_list[bdf].delete(address);
        end 
    endfunction
    
    // -------------------------------------------------------------------------
    // Function to register chassis reset events. Accepts the following arguments:
    // 'bdf'   - Bus/Dev/Function (or ReqId of the device) 
    // 'name'  - name of event
    function void registerChassisResetEvent(bit [15:0] bdf, string name="");
        `ovm_info(get_name(), $sformatf("registerChassisResetEvent(): [REQID=0x%04h] Registered Reset Event '%s'", bdf, name), OVM_LOW);
        chassis_reset_event_name[bdf] = name;
    endfunction
    
    // -------------------------------------------------------------------------
    // Function to register device reset events. Accepts the following arguments:
    // 'bdf'   - Bus/Dev/Function (or ReqId of the device) 
    // 'name'  - name of event
    function void registerNonChassisResetEvent(bit [15:0] bdf, string name="");
        `ovm_info(get_name(), $sformatf("registerNonChassisResetEvent(): [REQID=0x%04h] Registered Reset Event '%s'", bdf, name), OVM_LOW);
        non_chassis_reset_event_name[bdf] = name;
    endfunction
    
    // -------------------------------------------------------------------------
    //PASID is not part of iosftxn for ATS completion, so adding a new task for perfmon counting
    virtual task trigger_event_with_pasid(string tr_type, bit [63:0] address, HqmBusTxn txn ,bit[22:0] pasidtlp=23'hDEAD, bit[1:0] rw=2'b11);
        ovm_event ats_trsp_e;
        HqmAtsReqRsp_t treq         = generateAtsReq(txn);
        AtsReqInfo   ats_rsp_info   = new();
        AtsCmplInfo  event_info     = new(.addr(address & ~64'h0FFF), .data(txn.data[0]), .txn(txn));
        
        treq.pasidtlp               = pasidtlp;
        ats_rsp_info.set_atsreq(treq,rw);
        ats_trsp_e        = _eventPool.get($sformatf("%s_EVENT", tr_type));
        ats_trsp_e.trigger(ats_rsp_info); 
        `ovm_info(get_name(), $sformatf("Triggered Event (%s) for Address=0x%016h ,pasidtlp=%h" ,  ats_trsp_e.get_name(), address,pasidtlp), OVM_LOW);
    endtask
    
    // -------------------------------------------------------------------------
    //  Trigger the appropriate error injection type event for anyone who is listening (eg: HqmErrDescChecker)
    virtual task trigger_event(string tr_type, bit [63:0] address, HqmBusTxn txn);

        ovm_event mem_e;
        ovm_event ats_mem_e;
        ovm_event ats_treq_e;
        HqmAtsReqRsp_t treq         = generateAtsReq(txn);
        AtsCmplInfo  event_info     = new(.addr(address & ~64'h0FFF), .data(txn.data[0]), .txn(txn));
        
        AtsReqInfo   ats_req_info   = new();
        ats_req_info.set_atsreq(treq);
        
        address[11:0] = 12'h0;
        
       // ats_treq_e = _eventPool.get("ATS_REQ_T");
        mem_e      = _eventPool.get($sformatf("%s_EVENT", tr_type));
        ats_mem_e  = _eventPool.get($sformatf("%s_%0h_EVENT", tr_type,address));

        //ats_treq_e.trigger(ats_req_info); // trigger an event for anyone that cares to listen...
        mem_e.trigger(event_info); // trigger an event for anyone that cares to listen...
        ats_mem_e.trigger(event_info); // trigger an event for anyone that cares to listen...
        
        `ovm_info(get_name(), $sformatf("Triggered Event ats_mem_e (%s) for Address=0x%h" ,  ats_mem_e.get_name(), address), _atcCheckerDbg);
        `ovm_info(get_name(), $sformatf("Triggered Event (%s) for Address=0x%016h" ,  mem_e.get_name(), address), _atcCheckerDbg);
    endtask
    
    // -----------------------------------------------------------------------
    function bit [63:0] get4kAlignedAddr(bit [63:0] address);
        return (address & ~64'h0FFF);
    endfunction
    
    // -------------------------------------------------------------------------
    // Extracts information from the HqmBusTxn and returns a HqmAtsTReq_t type representing the request
    function HqmAtsReqRsp_t generateAtsReq(HqmBusTxn x);
        HqmAtsReqRsp_t treq;
        
        treq.req_time    = x.start_time;
        treq.l_address   = x.address;
        treq.l_address_4k= get4kAlignedAddr(treq.l_address);
        treq.nw          = x.address[0];
        treq.pasidtlp    = x.pasidtlp;
        treq.txn_id      = x.txn_id;
        treq.chid        = x.chid;
        treq.tc          = x.tc;
        treq.dw_length   = x.length;
        
        return treq;
    endfunction
        
    // -------------------------------------------------------------------------
    // Extracts the information from the HqmBusTxn and returns a HqmAtsReqRsp_t type representing the response
    function HqmAtsReqRsp_t generateAtsRsp(HqmBusTxn x);
        HqmAtsReqRsp_t trsp;
        
        trsp.txn_id          = x.txn_id;
        trsp.chid            = x.chid;
        trsp.tc              = x.tc;
        trsp.dw_length       = x.length;
        trsp.cpl_time        = x.start_time;
        // Note: 'reverse_qw' is used due to Endian-ness differences between PCIE and IOSF specs for completion data interpretation
        if ( x.data.size() > 0 ) begin
            trsp.p_address   = x.data[0][63:0]; //-- hqm_iosf_prim_mon.sv decode_ats_response() already converted data to ats_cpld  //-- ats_cfg.reverse_qw( x.data[0][63:0] );
        end 
        trsp.cpl_data_fields = trsp.p_address[11:0];    
        
        `ovm_info(get_name(), $sformatf("generateAtsRsp - trsp.p_address=0x%0x cpl_data_fields=0x%0x" , trsp.p_address, trsp.cpl_data_fields), _atcCheckerDbg);
        return trsp;
    endfunction
    
    // -------------------------------------------------------------------------
    // Extracts information from the HqmBusTxn and returns a HqmPrsReq_t type representing the response
    function HqmPrsReqRsp_t generatePrsRsp(HqmBusTxn x);
        HqmPrsReqRsp_t treq;

        treq.req_time    = x.start_time;
        treq.l_address   = {x.address[31: 0], x.address[63:32]};
        treq.req_prgi    = treq.l_address[8:0];
        treq.pasidtlp    = x.pasidtlp;
        treq.rsp_code    = HqmPciePrgRspCode_t'(treq.l_address[15:12]);
        treq.txn_id      = x.txn_id;
        treq.chid        = x.chid;
        treq.tc          = x.tc;
        
        return treq;
    endfunction
    
    // -------------------------------------------------------------------------
    // Extracts the information from the HqmBusTxn and returns a HqmAtsInvReqRsp_t type representing the invalidation request
    function HqmAtsInvReqRsp_t generateInvReq(HqmBusTxn x);
        HqmAtsInvReqRsp_t invreq;
        HqmTxnID_t        txn_id;

        `ovm_info (get_name(), $sformatf("generateInvReq: txn_id.tag=%0d txn.address=0x%0x txn.data.size=%0d ", x.txn_id.tag, x.address, x.data.size() ), _atcCheckerDbg);
        // [PCIE 10.3.1] For Invalidation messages, Device ID (device target) is encoded in Address[31:16]
        // See Figure 2-12 (Signal to transaction type mapping summary) in the IOSF spec
        txn_id.req_id = x.address[31:16];
        txn_id.tag    = x.txn_id.tag;
        
        invreq.req_time          = x.start_time;
        invreq.pasidtlp          = x.pasidtlp;
        invreq.txn_id            = txn_id;
        invreq.itag              = invreq.txn_id.tag[4:0];
        // Note: this 'reversal' is required due to Endian-ness difference between PCIE and IOSF spec
        if ( x.data.size() > 0 ) begin
            `ovm_info (get_name(), $sformatf("generateInvReq: txn.data=0x%0x ", x.data[0][63:0]), _atcCheckerDbg);
            invreq.address       = x.data[0][63:0]; //--it's converted in HQM's iosf_prim_mon already, if not, use::  ats_cfg.reverse_qw( x.data[0][63:0] );
        end 
        invreq.size              = invreq.address[11];
        invreq.rsvd_10_1         = invreq.address[10:1];
        invreq.global_invalidate = invreq.address[0];
 
        // By default, when an invalidation request is generated, mark it as 'outstanding'
        invreq.outstanding       = 1;
        
        invreq.ep = x.ep;
        invreq.dparity_err = x.dparity_err[0];
        `ovm_info (get_name(), $sformatf("generateInvReq: invreq.txn_id=0x%0x invreq.itag=%0d invreq.address=0x%h invreq.size=%d", invreq.txn_id, invreq.itag, invreq.address, invreq.size), _atcCheckerDbg);
        
        // Store the invalidation base address and range
        ats_cfg.get_baddr_and_range( invreq.aligned_address, invreq.range, invreq.address);
 
        return invreq;
    endfunction
    
    // -------------------------------------------------------------------------
    // Extracts information from the IOSF Monitor Xaction and returns a HqmAtsInvReqRsp type representing the invalidation response
    function HqmAtsInvReqRsp_t generateInvRsp(HqmBusTxn x);
        HqmAtsInvReqRsp_t invrsp;
        
        invrsp.cpl_time = x.start_time;
        invrsp.txn_id   = x.txn_id;
        invrsp.cc       = x.address[2:0];
        // PCIE 10.3.2: Completion count of 0 indicates 8 responses muse be sent
        if ( invrsp.cc == 0 ) begin
            invrsp.cc = 8;
        end 
        invrsp.itag_vector = x.address[63:32];
        invrsp.tc = x.tc;

        return invrsp;
    endfunction
    
    // -------------------------------------------------------------------------
    // Generates and Adds an ATC entry giving the ATS Req/Rsp data
    function void addAtcEntry(HqmAtsReqRsp_t ats);
        HqmAtcEntry_t          entry;
        HqmAtcLAddrLookup_t    lookup;
        RangeSize_t range_size = ats_cfg.get_range(ats.p_address);
        bit [63:0]             mask = ats_cfg.get_mask(range_size);
        string                 pasid_str = genPasidStr(ats.pasidtlp);
        string                 header = $sformatf("[ATC][PASID=%s][TXNID=0x%04h/0x%03h][G=%0d][U=%0d][EXE=%0d][RW=0x%01h]", pasid_str, ats.txn_id.req_id, ats.txn_id.tag, ats.cpl_data_fields.global_mapping, ats.cpl_data_fields.unxlat_access, ats.cpl_data_fields.execute_permitted, ats.cpl_data_fields.read_write );
        
        entry.id             = ats.id;
        entry.reqid          = ats.txn_id.req_id;
        entry.pasidtlp       = ats.pasidtlp;
        entry.range          = range_size;
        entry.cpl            = ats.cpl_data_fields;
        entry.p_address      = (mask & ats.p_address_4k);
        entry.l_address      = (mask & ats.l_address_4k);
        entry.ats_req_time   = ats.req_time;
        entry.ats_cpl_time   = ats.cpl_time;
        entry.invalid        = ats.invalid;
        entry.invalid_req_time = ats.invalid_req_time;
        entry.invalidation_itag = ats.invalidation_itag;
        
        lookup.pasidtlp  = entry.pasidtlp;
        lookup.l_address = entry.l_address;
        
        `ovm_info (get_name(), $sformatf("addAtcEntry - range_size=%0d", range_size), _atcCheckerDbg);

        // Note: for simplicity we add individual 4k entries depending on the range size. This will make lookup of addresses easier in other
        //  sections (so there isn't so much looping for address matches
        for ( bit [63:0] range=0 ; range < range_size ; range += RANGE_4K ) begin
            // Note: 'RCNT' is just a 4k counter that counts up to the total range size. Since the entries are stored on a '4k' boundary (for easier direct address access)
            `ovm_info (get_name(), $sformatf("addAtcEntry:: %s [RCNT=0x%016h] Added ATC Entry for LA(4k)=0x%016h -> PA(4k)=0x%016h", header, range, entry.l_address, entry.p_address), _atcCheckerDbg);
            
            lookup.l_address = entry.l_address;
            _atc_logical_lookup[lookup] = entry.p_address;
            
            // Insert the entry into the ATC
            atc[entry.p_address].push_back(entry);
            
            entry.p_address += RANGE_4K;
            entry.l_address += RANGE_4K;
        end 
        
    endfunction
    
    // -------------------------------------------------------------------------
    // Captures various controls of the defeature bits
    function void captureDefeatureControls();
        sla_ral_reg rega;
        
        if ( ats_cfg.reg_ptr["DEFTR0"] != null ) begin
            sla_ral_field fld;
            // ATS Channel Disable (if set, ATS requests happen on channel 0, otherwise, they happen on channel 2)
            fld = ats_cfg.reg_ptr["DEFTR0"].find_field("ATSCHIDDIS");
            if ( fld != null ) begin
                // If the field is set, then CHID==0, otherwise it remains at 2
                exp_ats_chid = ( fld.get() > 0 ) ? 0 : 2;
            end 
            
            // For LNL, the only channel available is Channel 0
            if (ats_cfg.is_bus_iCXL) begin
                exp_ats_chid = 0;
            end 
            
            // TC Override
            fld = ats_cfg.reg_ptr["DEFTR0"].find_field("ATSTCOVRD");
            if ( fld != null ) begin
                // TC override is only valid if the ATSTCOVRD field is set
                if ( fld.get() > 0 ) begin
                    fld = ats_cfg.reg_ptr["DEFTR0"].find_field("ATSTCOVAL");
                    exp_ats_tc = fld.get();
                end 
            end 
        end 
        
    endfunction
    
    // -------------------------------------------------------------------------
    // Generic function that returns if two ATC key's 'match'
    function bit atcEntryMatch(HqmAtcEntry_t entry1, HqmAtcEntry_t entry2, bit skip_address_check=0, bit skip_priv_check=0, bit skip_reqid_match=0);
        // If the Addresses do not match, then this is not a match
        if ( !skip_address_check && (entry1.l_address != entry2.l_address) ) begin
            return 0;
        end 
        // If the REQIDs do not match, then this is not a match
        if ( !skip_reqid_match && entry1.reqid != entry2.reqid ) begin
            return 0;
        end 
        // If the PASIDEN do not match, then this is not a match
        if ( entry1.pasidtlp.pasid_en != entry2.pasidtlp.pasid_en ) begin
            return 0;
        end 
        // If the Priv Modes do not match, then this is not a match
        if ( !skip_priv_check && (entry1.pasidtlp.priv_mode_requested != entry2.pasidtlp.priv_mode_requested) ) begin
            return 0;
        end 
        // If PASIDEN==1 and the PASID does not match, then this is not a match
        if ( entry1.pasidtlp.pasid_en && (entry1.pasidtlp.pasid != entry2.pasidtlp.pasid) ) begin
            return 0;
        end 
        
        return 1;
    endfunction
    
    // -------------------------------------------------------------------------
    //-------------------------------------------------------------
    // This function accepts an HqmBusTxn type and does the necessary
    // processing for an ATS request. 
    task processAtsRequest(HqmBusTxn txn);
        HqmAtsReqRsp_t treq         = generateAtsReq(txn);
        string         pasid_str    = genPasidStr(treq.pasidtlp);
        string         treq_header  = $sformatf("[ATS_TREQ][PASID=%s][TXNID=0x%04h/0x%03h][NW=%0d]", pasid_str, treq.txn_id.req_id, treq.txn_id.tag, treq.nw);
        HqmAtsLegalTranslations_t transReq;
        
        // Sanity check that were are only processing ATS requests
        if ( txn.at != HQM_AT_TRANSLATION_REQ ) begin
            return;
        end 
        
        // There are defeature bits that can change the expected channel or TC the ATS requests occur on, capture those
        // defeature values here
        captureDefeatureControls();
        
        // Check that the Request occurred on the correct channel
        if ( treq.chid != exp_ats_chid ) begin
            `ovm_error(get_name(), $sformatf("%s [CHID-CHECK] %0d (actual) != %0d (expected)", treq_header, treq.chid, exp_ats_chid));
        end
                    
        // Check that the Request occured on the correct traffic class
        //--AY_HQMV30_ATS  if ( treq.tc != exp_ats_tc ) begin
        //--AY_HQMV30_ATS    `ovm_error(get_name(), $sformatf("%s [TC-CHECK] %0d (actual) != %0d (expected)", treq_header, treq.tc, exp_ats_tc));
        //--AY_HQMV30_ATS  end
        
        // Figure 10-8 Address [11:1] is reserved
        if ( treq.l_address[11:1] != 0 ) begin
            `ovm_error(get_name(), $sformatf("%s [PCIE Fig 10-8] Address[11:1] != 0. Translation Address Seen = 0x%016h", treq_header, treq.l_address));
        end 
         
        // Assign this request an ID
        treq.id = _atsID++;
         
        // Add the ATS request to an associative array that tracks outstanding requests
        ats_reqrsp[treq.txn_id] = treq;
        ats_request_cov = treq;
       `ovm_info(get_name(), $sformatf("processAtsRequest - ats_reqrsp[0x%0x] create treq_header %0s ", treq.txn_id, treq_header), _atcCheckerDbg);
`ifndef EXCLUDE_HQM_TB_CG
        if ( !ats_cfg.disable_cg_sampling ) begin   
            ats_req_cov.sample();
        end 
`endif 
        signalAtsReqEvent(.atsReq(treq));
        
        checkAtsReq(treq, treq_header, transReq);

        trigger_event (.tr_type("ATS_TREQ"), .address(treq.l_address), .txn(txn));
    endtask


    //-------------------------------------------------------------
    function void checkAtsReq(HqmAtsReqRsp_t treq, string treq_header, inout HqmAtsLegalTranslations_t transReq);
        transReq.address = treq.l_address_4k;
        transReq.pasidtlp = treq.pasidtlp;
        transReq.reqid = treq.txn_id.req_id;
        transReq.write = !treq.l_address[0];
        
        if (!legal_translations.exists(transReq)) begin
            // if the ats req is with nw = 1, and then the registered entry in the hash table is with write permission, this check can allow it to be legal, in case if use transitory alloc is on
            // check if the same addr/pasid exists in the legal ats list, with a write permission. if yes, print info, otherwise error out
            transReq.write = 1;
            if (!legal_translations.exists(transReq)) begin
                if (!ats_cfg.disable_legal_ats_check)
                    `ovm_error(get_name(), $sformatf("%s [LEGAL_ATS-CHECK] %p Is Not An Expected Translation Location", treq_header, transReq));
            end else begin
                `ovm_info(get_name(), $sformatf("%s [LEGAL_ATS-CHECK] transreq is legal since Use Tr alloc is on, and tr req with now write is tolerated to pages with r and wr permission : %p, count = %0d", treq_header, transReq, legal_translations[transReq]), _atcCheckerDbg);
                legal_translations[transReq].count++;
            end
        end else begin
            //The following code added for the issue:Ats Req not seen for ENCRYPT Operation due to ATS_IREQ and Data completion issue for DECRYPT Operation.
            HqmAtsLegalTranslations_t newReq = transReq;
            newReq.write = !transReq.write;

            legal_translations[transReq].count++;
            `ovm_info(get_name(), $sformatf("%s [LEGAL_ATS-CHECK] transreq is legal : %p, count = %0d", treq_header, transReq, legal_translations[transReq].count), _atcCheckerDbg);
            
            if (legal_translations.exists(newReq)) begin
                legal_translations[newReq].count++;
                `ovm_info(get_name(), $sformatf("%s [LEGAL_ATS-CHECK] transreq is legal : %p, count = %0d", treq_header, transReq, legal_translations[newReq].count), _atcCheckerDbg);
            end 
        end
    endfunction

    // ------------------------------------------------------------------------- 
    // Function others can call to query the current 'ATC' view from the checker
    // Checker will then return a copy of all ATC entries that satisfy the the 
    // this address
    // Implementation Note: For Simplicity, ATC entries get added on a 4k boundary
    // to make ATC queries easy to access. 
    function void queryATC(bit [63:0] address, HqmPasid_t pasidtlp, bit [15:0] reqid, ref HqmAtcEntry_t entry_q[$]);
        int                 num_atc_entries;
        bit [63:0]          mask = ats_cfg.get_mask(RANGE_4K);
        bit [63:0]          l_address_4k = address & mask;
        HqmAtcLAddrLookup_t lookup = '{ pasidtlp  : pasidtlp,
                                        l_address : l_address_4k };
        bit [63:0]          p_address;
        HqmAtcEntry_t       ref_entry;
        HqmAtcEntry_t       entry;
        
        // No Active lookup entry for this translation, or no valid entries in the ATC
        if ( !_atc_logical_lookup.exists(lookup) ) begin
            return;
        end else if ( !atc.exists(_atc_logical_lookup[lookup]) || atc[_atc_logical_lookup[lookup]].size() == 0 ) begin
            return;
        end 
        p_address = _atc_logical_lookup[lookup];
        ref_entry.pasidtlp  = pasidtlp;
        ref_entry.l_address = l_address_4k;
        ref_entry.reqid     = reqid;
        num_atc_entries = atc[p_address].size();
        for ( int i=0 ; i < num_atc_entries; ++i ) begin
            if ( !atcEntryMatch(.entry1(atc[p_address][i]), .entry2(ref_entry)) ) begin
                continue;
            end 
            entry_q.push_back(atc[p_address][i]); 
        end
    endfunction
    
    // -------------------------------------------------------------------------
    //-------------------------------------------------------------
    // This function accepts an HqmBusTxn type and does the necessary
    // processing for an non-ATS requests. This function assumes qualification
    // of the 'tat' field (either 'b00 or 'b10) as already occurred. 
    task processNonAtsMemRequest(HqmBusTxn txn);
        HqmPasid_t    pasidtlp   = txn.pasidtlp;
        HqmATEnc_t    at_enc     = HqmATEnc_t'(txn.at);
        HqmAtcEntry_t entry;
        HqmCmdType_t  cmd_type = txn.getCmdType();
        bit [63:0]    address_4k = txn.address & ~64'h0FFF;
        string        header     = $sformatf("[IOSF_MEM][%s][Addr=0x%016h][TXNID=0x%04h/0x%03h]", cmd_type.name(), txn.address, txn.txn_id.req_id, txn.txn_id.tag);
        string        atc_header;          // Header used for ATC entries (set later on)
        string        err_msg_q[$];        // Queue of error messages
        string        err_msg = "";        // Error message(s) associated with an entry
        bit           found_atc_entry = 0; // Set if an ATC entry was found for a translated request
        int           num_atc_entries = 0; // Number of ATC entries associated with a given address  
        int unsigned  err_cnt = 0;         // Count of the number of errors encountered for a given ATC entry

        // Sanity check that were are only processing untranslated or translated requests. 
        // TODO: Need to add support for 'HQM_AT_TRANSLATED_MSI'?
        if ( !(at_enc inside { HQM_AT_UNTRANSLATED, HQM_AT_TRANSLATED }) ) begin
            return;
        end 
        
        trigger_event(.tr_type("NON_ATS_MREQ"), .address(address_4k), .txn(txn));
        
        // Skip the checks if the address is in the 'safe' list
        if ( (at_enc == HQM_AT_UNTRANSLATED) && (untranslated_safe_list.exists(txn.txn_id.req_id)) && (untranslated_safe_list[txn.txn_id.req_id].exists(address_4k)) ) begin
            `ovm_info(get_name(), $sformatf("%s Skipping Untranslated Checks Due To Being on the Safe List", header), _atcCheckerDbg);
            return;
        end 
        
        //--AY_HQMV30_ATS  if (cmd_type inside {PCIe::MWr64,PCIe::MWr32} ) begin
        if (cmd_type inside {HQM_MWr32, HQM_MWr64} ) begin
            trigger_event (.tr_type("MEM_WR64"), .address(address_4k), .txn(txn));
            `ovm_info(get_name(), $sformatf("Received MWR to addr 0x%h", address_4k), _atcCheckerDbg);
        end
        // Check if the consumed address exists in the ATC. 
        if ( (! atc.exists(address_4k)) && (atc[address_4k].size() == 0) ) begin
            // If we were not able to find an entry in the ATC and the address used was a translated address,
            // then flag an error
            if ( at_enc inside { HQM_AT_TRANSLATED } ) begin
                `ovm_error(get_name(), $sformatf("%s Found No Matching ATC entry for Addr(4k)=0x%016h", header, address_4k));
            end 
            return;
        end 
            
        // [PCIE 6.20] - PASID TLP Prefix is permitted on:
        //   - Memory Requests /w Untranslated Addresses
        //   - Address Translation Requests, Invalidation Messages, Page Requests/Responses. 
        // (so the PASID TLP does not show up on translated addresses)
        
        // Perform various checks on translated/untranslated addresses
        // Note: Must be careful of the way checks are coded. It is possible that you could have a device configuration
        //   where some WQs do translation, while others do not. (Cannot assume that ATS is on for everything)
        // Iterate through the ATC hash and perform various checks if the ATC key entry matches
        num_atc_entries = atc[address_4k].size();
        for ( int i=0 ; i < num_atc_entries; i++ ) begin
            entry   = atc[address_4k][i]; // For easier access
            err_msg = "";
            
            atc_header = $sformatf("[ATC][REQID=0x%04h][PASID=0x%05h][PASID_EN=0x%01h][PRIV=%0d][G=%0d][U=%0d][EXE=%0d][RW=0x%01h],[la_addr=0x%0h],[pa_addr=0X%0h]", 
                                    atc[address_4k][i].reqid, entry.pasidtlp.pasid, entry.pasidtlp.pasid_en, entry.pasidtlp.priv_mode_requested, entry.cpl.global_mapping, entry.cpl.unxlat_access,
                                    entry.cpl.execute_permitted, entry.cpl.read_write,entry.l_address,entry.p_address);
        
            // Skip over if the REQIDs do not match because this translation does not belong to that
            if ( atc[address_4k][i].reqid != txn.txn_id.req_id ) begin
                `ovm_info(get_name(), $sformatf("%s%s Skipping comparison for ATC entry due to mismatching REQIDs", header, atc_header), OVM_LOW);
                continue;
            end
            `ovm_info(get_name(), $sformatf("%s%s Starting comparison for ATC entry, err_msg : %s ", header, atc_header, err_msg), OVM_LOW);
        
            // [PCIE 10.2.3.5] Check for for Command Legality (RW access)
            // For 'Write Only', zero length reads are allowed
            // Note: HW sends separate translation requests to the same address for source/destination. So the same pasid/logical address may have 
            //   two requests with different attributes returned in the completion. Both are valid in this case. So the checks have to occur on 
            //   all matching entries.
            case (cmd_type)
                HQM_MRd32,
                HQM_MRd64 : begin
                    if ( (!(entry.cpl.read_write inside {HQM_ATSCPL_RD_ONLY, HQM_ATSCPL_RW})) &&
                         // Account for Zero-Length Read case
                         (!(entry.cpl.read_write == HQM_ATSCPL_WR_ONLY && txn.lbe == 0 && txn.fbe == 0)) && (at_enc == HQM_AT_TRANSLATED) ) begin
                        err_msg = $sformatf("  [PCIE 10.2.3.5] ATC may not issue a read request for translation /w RW=%s(0x%01h)\n", entry.cpl.read_write.name(), entry.cpl.read_write);
                    end 
                end 
                HQM_MWr32,
                HQM_MWr64 : begin
                    if ( (!(entry.cpl.read_write inside {HQM_ATSCPL_WR_ONLY, HQM_ATSCPL_RW})) &&
                         // Account for Zero-Length Write case
                         (!(entry.cpl.read_write == HQM_ATSCPL_RD_ONLY && txn.lbe == 0 && txn.fbe == 0)) && (at_enc == HQM_AT_TRANSLATED) ) begin
                        err_msg = $sformatf("  [PCIE 10.2.3.5] ATC may not issue a write request for translation /w RW=%s(0x%01h)\n", entry.cpl.read_write.name(), entry.cpl.read_write);
                    end 
                end 
            endcase
         
            // [PCIE 6.20] PASID TLP Prefix is not permitted on Memory Requests /w AT=Translated (0x2)
            if ( at_enc inside { HQM_AT_TRANSLATED } && txn.pasidtlp != 0 ) begin
                err_msg = $sformatf("  [PCIE 6.20] PASID TLP Prefix is not permitted on Memory Requests /w AT=0x%01h(%s)\n", at_enc, at_enc.name());
            end 
         
            // [PCIE 10.2.3.3] Check for 'non-snooped' field 
            if ( entry.cpl.non_snoop_acc && txn.ns == 1 ) begin
                err_msg = {err_msg, 
                           $sformatf("  [PCIE 10.2.3.3] ATC entry /w Non-Snooped field set implies No Snoop Attribute must be 0 (found '%0d')\n", txn.ns)};
            end 
            
            // [PCIE 10.2.3.4] Check for 'Untranslated' correctness
            // Here, we are checking if the matched ATC entry had the 'untranslated' field set. 
            if ( at_enc == HQM_AT_UNTRANSLATED && !entry.cpl.unxlat_access ) begin
                err_msg = {err_msg, 
                           $sformatf("  [PCIE 10.2.3.4] ATC entry did not have Untranslated field set. But found 'AT' attribute /w '%s'(0x%01h)", at_enc.name(), at_enc)};
            end else if ( at_enc == HQM_AT_TRANSLATED && entry.cpl.unxlat_access ) begin
                err_msg = {err_msg, 
                           $sformatf("  [PCIE 10.2.3.4] ATC entry had Untranslated field set. But found 'AT' attribute /w '%s'(0x%01h)", at_enc.name(), at_enc)};
            end 
            
            // [PCIE 10.3.2] Check that invalidated addresses do not get used
            // [PCIE 10.3.6] 'Invalid' in the ATC is marked at time of Invalidation Request (or other cases like
            //   a UR received as a response to an ATS Request. If the Translation Response is received
            //   before the Invalidate Completion, an implementation is free to issue requests utilizing the 
            //   translation result prior to sending the Invalidation completion. 
            //   The ATC entry gets removed for invalidations when the completion returns.
            if ( entry.invalid ) begin
                if ( entry.invalid_req_time != 0 ) begin
                    `ovm_info(get_name(), $sformatf("%s%s [PCIE 10.3.2] Addr(4k)=0x%016h was marked invalid, but device used the Entry prior to Invalidation Completion (legal)", header, atc_header, address_4k), OVM_LOW);
                end else if ( entry.atc_disable_time != 0 ) begin
                    `ovm_info(get_name(), $sformatf("%s%s [PCIE 10.3.2] Addr(4k)=0x%016h was marked invalid due to ATC being disabled (however HW may completion in-flight transactions)", header, atc_header, address_4k), OVM_LOW);
                end 
            end 
            
            // If we found no error, then delete the contents of err_msg_q and exit the loop because we found a positive match
            if ( err_msg == "" ) begin
                err_msg_q.delete();
                break;
            end else begin
                err_msg = $sformatf("%s\n%s", atc_header, err_msg);
                err_msg_q.push_back(err_msg);
            end 
        end 

        // Final Sanity Check. If 'err_msg_q' is not empty, then that means we did not find a positive match in the ATC. In this
        // case, dump the comparison results with each entry. 
        if ( err_msg_q.size() > 0 ) begin
            err_msg = "Did not find a positive match in the ATC, below are comparison results of each entry:\n";
            foreach ( err_msg_q[i] ) begin
                err_msg = {err_msg, err_msg_q[i]};
            end 
            `ovm_error(get_name(), $sformatf("%s", err_msg));
        end 

    endtask
    
    //-------------------------------------------------------------
    //-------------------------------------------------------------
    // Contains the logic that processes the ATS response from IOSF
    task processAtsResponse(HqmBusTxn txn);
        HqmAtsReqRsp_t trsp      = generateAtsRsp(txn); // Extract data from the response
        HqmAtsReqRsp_t treq;                            // Handle to the matched request
        HqmCmdType_t   cmd_type = txn.getCmdType();
        string         pasid_str;
        string         tcpl_header;
        string         atc_header;
        bit [15:0]     device_bdf_q[$] = ats_cfg.get_device_bdf_q();
        bit            add_atc_entry = 1; // If set, will add an ATC entry on reception of a response

        // Notes: 
        // 1. Only look at ATS responses that have the REQID within the given list
        // 2. Only look at responses for which there exists an associated request with the same tag
        // 3. The 'time' qualifier is to handle a race condition. There exists a case where the RTL may send out a 
        //    large read to memory. When the completion comes back, there may be a lot of data associated with that
        //    completion which cause the data phase to take really long. While the data phase is occurring, it is possible
        //    for RTL to reuse the same tag for an ATS request. When the completion finally comes back, for the previous
        //    read, the new ATS request with the same tag is already pending, which may cause this to track the wrong
        //    completion
        if ( !(trsp.txn_id.req_id inside {device_bdf_q}) || !(ats_reqrsp.exists(trsp.txn_id)) || (trsp.cpl_time <= ats_reqrsp[trsp.txn_id].req_time) || (txn.address[31:16] != ats_cfg.iommu_bdf) ) begin
           `ovm_info(get_name(), $sformatf("processAtsResponse - return!  Check trsp.txn_id=0x%0x trsp.cpl_time=%0d txn.address=0x%0x ats_cfg.iommu_bdf=0x%0x", trsp.txn_id, trsp.cpl_time, txn.address, ats_cfg.iommu_bdf), _atcCheckerDbg);
            return;
        end 
        
        treq      = ats_reqrsp[trsp.txn_id];     // Get a handle to the matched request
        trsp.id   = treq.id;                     // Transfer over the ID
        trsp.cpl_cmd_type = cmd_type;            // Transfer over the command type
        trsp.cpl_sts = txn.getCplStatus();       // Get the completion status
        trsp.cpl_ep = txn.ep;                      // Transfer over 'ep' bit (if detected)
        trsp.cpl_dparity_err = txn.dparity_err[0]; // Transfer over data parity error (if detected)
        pasid_str = genPasidStr(treq.pasidtlp);
        
       `ovm_info(get_name(), $sformatf("processAtsResponse - Start with txn.addr=0x%0x trsp.cpl_data_fields=0x%0x cmd_type=%0s", txn.address, trsp.cpl_data_fields, cmd_type.name() ), _atcCheckerDbg);


        // [PCIE Table 10-2]
        // UR - If a function receives this Completion Code, it must disable its ATC and not send any requests using 
        //   translated addresses until the ATC is re-enabled. 
        // CA - Error reported to device driver
        // CRS- Malformed TLP
        // In any of these cases, we do not continue further
        if ( cmd_type != HQM_CplD ) begin
            tcpl_header  = $sformatf("[ATS_TRSP][PASID=%s][TXNID=0x%04h/0x%03h]", pasid_str, treq.txn_id.req_id, treq.txn_id.tag );
            case ( HqmPcieCplStatus_t'(txn.fbe[2:0]) )
                HQM_UR : begin
                    bit [63:0] atc_addr;
                    // Note: [PCIE Table 10-2] - For transactions 'in flight', the function may terminate or complete them. So we cannot delete the ATC entries
                    //  here, instead, we just mark them invalid.
                    `ovm_info (get_name(), $sformatf("%s [PCIE Table 10-2] UR received on ATS Request. ATC must be disabled.", tcpl_header), _atcCheckerDbg);
                    foreach ( atc[atc_addr,i] ) begin
                        atc[atc_addr][i].atc_disable_time = $time;
                        atc[atc_addr][i].invalid = 1;
                    end 
                end 
            endcase
            
            signalAtsCplEvent(.atsReq(treq), .atsRsp(trsp));
            ats_reqrsp.delete(treq.txn_id); // Remove the ATS request from tracking after having received the completion
            trigger_event (.tr_type("ATS_TCPL_FAIL"), .address(treq.l_address), .txn(txn));
           `ovm_info(get_name(), $sformatf("processAtsResponse - return!  Check cmd_type=%0s", cmd_type.name() ), _atcCheckerDbg);
            return;
        end 
        
        tcpl_header  = $sformatf("[ATS_TRSP][PASID=%s][TXNID=0x%04h/0x%03h][G=%0d][U=%0d][EXE=%0d][RW=0x%01h]", pasid_str, treq.txn_id.req_id, treq.txn_id.tag, trsp.cpl_data_fields.global_mapping, trsp.cpl_data_fields.unxlat_access, trsp.cpl_data_fields.execute_permitted, trsp.cpl_data_fields.read_write );
       `ovm_info(get_name(), $sformatf("processAtsResponse - Start to check with tcpl_header %0s", tcpl_header ), _atcCheckerDbg);

        // Transfer the data extracted from the response over to the request. This allows us to reference a single
        // structure to get all the pertinent information.
        treq.cpl_time        = trsp.cpl_time;
        treq.p_address       = trsp.p_address;
        treq.cpl_data_fields = trsp.cpl_data_fields;
        if ( treq.cpl_data_fields.unxlat_access ) begin
            // PCIE Spec Table 10-3. When this field is set, the indicated range may only  be
            // accessed using untranslated addresses, and the Translated Address field of this
            // translation completion may not be used (dropped). So we store the 'l_address' as the
            // p_address_4k in this instance. 
            `ovm_info (get_name(), $sformatf("processAtsResponse - %s Detected Untranslated Access. Using LogicalAddr(4k)=0x%016h instead of PhysicalAddr=0x%016h in ATC Entry", tcpl_header, treq.l_address_4k, treq.p_address), _atcCheckerDbg);
            treq.p_address_4k    = ats_cfg.get_pa_4k( treq.l_address_4k, treq.l_address );
        end else begin
            treq.p_address_4k    = ats_cfg.get_pa_4k( treq.l_address_4k, treq.p_address );
        end 
                    
        // [PCIE Table 10-3] 
        // Global Mapping: If this bit is Set, the ATC is permitted to cache this mapping entry in all PASIDs.
        //   If Clear, the ATC is permitted to cache this mapping entry only in the PASID associated with the
        //   requesting PASID. This bit may only be set if the associated Translation Request had a PASID
        if ( treq.cpl_data_fields.global_mapping && !treq.pasidtlp.pasid_en ) begin
            `ovm_error(get_name(), $sformatf("processAtsResponse - %s [PCIE Table 10-3] 'Global' bit set but associated Translation Request did not have a valid PASID", tcpl_header));
        end 
        //  Execute Permitted - This bit may only be set if the associated Translation Request had a PASID. 
        //    if this bit is set, 'R' must also be set. 
        if ( treq.cpl_data_fields.execute_permitted && !treq.pasidtlp.pasid_en ) begin
            `ovm_error(get_name(), $sformatf("processAtsResponse - %s [PCIE 10.2.3.6] 'Exe' bit set but associated Translation Request did not have a valid PASID", tcpl_header));
        end 
        if ( !treq.pasidtlp.exe_requested && treq.cpl_data_fields.execute_permitted  ) begin
            `ovm_error(get_name(), $sformatf("processAtsResponse - %s [PCIE 10.2.3.6] [Optional] 'Exe' bit may only be set if the Translation Request has a value of '1' for Execute Requested", tcpl_header));
        end 
        if ( treq.cpl_data_fields.execute_permitted && !(treq.cpl_data_fields.read_write inside {HQM_ATSCPL_RD_ONLY, HQM_ATSCPL_RW}) ) begin
            `ovm_error(get_name(), $sformatf("processAtsResponse - %s [PCIE 10.2.3.6] [Optional] 'Exe' bit set but 'R'(read) was not set", tcpl_header));
        end 
        // RW:
        // 00 - This translation is considered not to be valid. Contents of Translated Address, N,U,Exe fields are undefined. 
        if ( treq.cpl_data_fields.read_write == HQM_ATSCPL_NO_RW ) begin
            `ovm_info (get_name(), $sformatf("processAtsResponse - %s [PCIE Table 10-3] RW=%s, Translation Contents are Undefined", tcpl_header, treq.cpl_data_fields.read_write.name()), _atcCheckerDbg);
            add_atc_entry = 0; // Do not add ATC entry in this case
        end 
        // If the Request was marked invalid and there was an invalidation completion seen, do not add this to the ATC (HW is not supposed to use it) 
        if ( treq.invalid && treq.invalid_cpl_time > 0 ) begin
            // [PCIE 10.3.3]
            `ovm_info (get_name(), $sformatf("processAtsResponse - %s [PCIE 10.3.3] Outstanding ATS request was marked invalid and Invalidation Completion was Received (time=%0t). Not adding entry to ATC.", tcpl_header, treq.invalid_cpl_time), _atcCheckerDbg);
            add_atc_entry = 0; // Do not add ATC entry in this case
        end 
                 
        // Generate an ATC entry based on the ATS Req/Rsp and store it in the 'atc' hash. If a previous
        // entry already existed, this should overwrite the contents.
        if ( add_atc_entry ) begin
            `ovm_info (get_name(), $sformatf("processAtsResponse - add_atc_entry to atc"), _atcCheckerDbg);
            addAtcEntry(treq);
        end else begin
            `ovm_info (get_name(), $sformatf("processAtsResponse - %s Skipped Adding ATC Entry for LA(4k)=0x%016h", tcpl_header, treq.l_address_4k), _atcCheckerDbg);
        end 

        signalAtsCplEvent(.atsReq(treq), .atsRsp(trsp));

        ats_response_cov = trsp;
        ats_response_size_cov = get_tr_size(treq);
`ifndef EXCLUDE_HQM_TB_CG
        if ( !ats_cfg.disable_cg_sampling ) begin
            ats_rsp_cov.sample();
        end 
`endif 
        trigger_event (.tr_type("ATS_TCPL"), .address(treq.l_address), .txn(txn));
        // Note: I changed the name of the below 'tr_type'. If it used the same name, then it should have stuffed the
        //   info needed into the same object, rather than creating a different object type. Do not trigger the same event 
        //   back to back like this, you can get into race conditions where something might think two different things happened.
        //   Additionally, you could get into race conditions where the first event triggered, passed in the original object, 
        //   then the second event triggered and passed in an object of a different type. Meanwhile, a separate thread was waiting
        //   for the first object, but because the simulator scheduled two events to fire back-to-back (since they aren't blocking),
        //   the first object from the first event now is lost and not recoverable.  
        trigger_event_with_pasid (.tr_type("ATS_TCPL_PASIDTLP"), .address(treq.l_address), .txn(txn), .pasidtlp(treq.pasidtlp), .rw(treq.cpl_data_fields.read_write));

       `ovm_info(get_name(), $sformatf("processAtsResponse - ats_reqrsp[0x%0x] delete tcpl_header %0s ", treq.txn_id, tcpl_header), _atcCheckerDbg);
        ats_reqrsp.delete(treq.txn_id); // Remove the ATS request from tracking after having received the completion

    endtask:processAtsResponse
    
    //-------------------------------------------------------------
    // TODO: I don't understand this function. It does not seem correct. Why is it only looking at the upper 32 bits of the address??
    function RangeSize_t get_tr_size(HqmAtsReqRsp_t treq);
        RangeSize_t s = RangeSize_t'(0);
        int sizebit;
        if (treq.cpl_data_fields.size_of_xlat == 0) begin
            s = RANGE_4K;
            return s;
        end
        for (int i = 32; i < 64; i++) begin
            if (treq.l_address_4k[i] == 1'b0) begin
                sizebit = i;
                break; 
            end
        end
        s[sizebit-20] = 1; // As per pcie spec 4.0, section 10.2.3.2
        return s;
    endfunction
    
    //-------------------------------------------------------------
    // Returns a 'formatted' pasidtlp
    function HqmPasid_t get_formatted_pasidtlp(HqmPasid_t pasidtlp);
        HqmPasid_t formatted_pasidtlp = pasidtlp;
        // Format the PASID for when PASID is not enabled. Do not use 'ireq'
        if ( pasidtlp.pasid_en == 0 ) begin
            formatted_pasidtlp = 0;
        end 
        return formatted_pasidtlp;
    endfunction
    
    //-------------------------------------------------------------
    // Registers an itag in the 'inv_addr_q'
    function void register_itag_in_inv_addr_q(bit [63:0] address, HqmPasid_t pasidtlp, bit [4:0] itag);
        pasidtlp = get_formatted_pasidtlp(pasidtlp);
        inv_addr_q[address][pasidtlp] = itag;
    endfunction
    
    //-------------------------------------------------------------
    // Returns whether an Invalidation entry exists
    function bit inv_addr_q_entry_exists(bit [63:0] address, HqmPasid_t pasidtlp);
        pasidtlp = get_formatted_pasidtlp(pasidtlp);
        return ( inv_addr_q.exists(address) && inv_addr_q[address].exists(pasidtlp) );
    endfunction
    
    //-------------------------------------------------------------
    //-------------------------------------------------------------
    // Function that processes the invalidation request on IOSF
    task processInvalidationRequest(HqmBusTxn txn);
        HqmAtsInvReqRsp_t      ireq         = generateInvReq(txn);
        HqmCmdType_t           cmd_type = txn.getCmdType();
        string                 pasid_str    = genPasidStr(ireq.pasidtlp);
        string                 ireq_header  = $sformatf("[ATS_IREQ][PASID=%s][PASID_EN=%b][DEVID=0x%04h][ITAG=0x%03h][G=%0d]", pasid_str,ireq.pasidtlp.pasid_en, ireq.txn_id.req_id, ireq.itag, ireq.global_invalidate );
        string                 atc_header;
        HqmAtcEntry_t          inv_entry;     // Invalidation key, used to access ATC
        bit [63:0]             atc_addr;
        bit [63:0]             inv_req_addr;
        bit [7:0]              message_code = txn.getMsgCode();
        string                 ev_name;
        bit [19:0]             inv_pasid;
        ovm_event              ats_ireq_ev;
        bit [63:0]             inv_addr_low;
        bit [63:0]             inv_addr_high;
        HqmAtsInvReqRsp_t      tmp_ireq         = generateInvReq(txn);
        
        // [PCIE 10.3.1] Qualify that we are dealing with an invalidation request
        if ( cmd_type != HQM_MsgD2 || message_code != 8'b0000_0001) begin
            return;
        end 
        
        // Check that the invalidation request (itag) is not currently in use
        if ( inv_reqrsp[ireq.txn_id.req_id][ireq.itag].outstanding ) begin
            `ovm_error(get_name(), $sformatf("%s [PCIE 10.3.1] ITAG is currently in use (may not be reused until tag has been released)", ireq_header));
        end

        // Check that the reserved bits are driven to 0
        if ( ireq.rsvd_10_1 ) begin
            `ovm_error(get_name(), $sformatf("%s Reserved bits [10:1] of Invalidation Request are non-zero", ireq_header));
        end

        // Check that the invalidation range is within acceptable limits
        if ( ireq.range inside { acceptable_inv_range } ) begin
            `ovm_error(get_name(), $sformatf("%s Address=0x%016h exceeds acceptable_inv_range", ireq_header, ireq.address))
        end

        if ( ireq.global_invalidate ) begin
            if ( ireq.pasidtlp.pasid_en == 0 ) begin
                // [PCIE 10.3.1]: Global Invalidate indicates that the Invalidation Request affects all PASID values
                // This bit is reserved unless the invalidation request as a PASID TLP
                `ovm_error(get_name(), $sformatf("%s [PCIE 10.3.1] GlobalInvalidate=1 but PASID.EN=0", ireq_header));
            end
        end
        
        // Assign this request an ID
        ireq.id = _invID++;
        
        ats_ireq_ev = _eventPool.get("ATS_IREQ");
        ats_ireq_ev.trigger();
        
        inv_entry.reqid     = ireq.txn_id.req_id;
        inv_entry.pasidtlp  = ireq.pasidtlp;
        inv_entry.l_address = ireq.aligned_address;  
        inv_addr_low        = ireq.aligned_address;
        inv_addr_high       = ireq.aligned_address + ireq.range-1;
        
        `ovm_info (get_name(), $sformatf("processInvalidationRequest:: %s inv_addr_low=0x%h, inv_addr_high=0x%h", ireq_header, inv_addr_low, inv_addr_high), _atcCheckerDbg);
        
        // Go through the ATC and mark requests as invalid upon reception of invalidation request
        foreach ( atc[atc_addr, i] ) begin
        //foreach ( atc[atc_addr] ) begin
          //foreach( atc[atc_addr][i] ) begin
            
            atc_header = $sformatf("[ATC][LA=0x%h][REQID=0x%04h][PASID=0x%05h][PASID_EN=0x%01h][PRIV=%0d],[U=%b]",atc[atc_addr][i].l_address, atc[atc_addr][i].reqid, atc[atc_addr][i].pasidtlp.pasid, atc[atc_addr][i].pasidtlp.pasid_en, atc[atc_addr][i].pasidtlp.priv_mode_requested,atc[atc_addr][i].cpl.unxlat_access);
            
            // Check that the BDFs match to make sure it's for the correct device
            if ( atc[atc_addr][i].reqid != ireq.txn_id.req_id ) begin
                `ovm_info (get_name(), $sformatf("processInvalidationRequest:: %s%s Skipping ATC entry for invalidation processing due to mismatching Device IDs", ireq_header, atc_header), _atcCheckerDbg);
                continue;
            end else if ( atc[atc_addr][i].cpl.unxlat_access ) begin
                // If RTL got an untranslated access response, it no longer participates in the invalidation flow. So if an invalidation is received
                // do not mark the entry as invalid
                `ovm_info (get_name(), $sformatf("processInvalidationRequest:: %s%s Skipping ATC entry for invalidation processing due Untranslated Access", ireq_header, atc_header), _atcCheckerDbg);
                continue;
            end
            
            // [PCIE 10.3.1] Global Invalidate bit indicates that the Invalidation request affects all PASID
            //   values. This bit is Reserved unless the Invalidation Request has a PASID TLP Prefix
            if ( ireq.pasidtlp.pasid_en && ireq.global_invalidate && atc[atc_addr][i].pasidtlp.pasid_en && ( atc[atc_addr][i].l_address inside {[inv_addr_low:inv_addr_high]}) ) begin
                `ovm_info (get_name(), $sformatf("processInvalidationRequest:: %s%s Invalidating ATC entry with la= 0x%h due to Global Invalidation", ireq_header, atc_header,atc[atc_addr][i].l_address), _atcCheckerDbg);
                atc[atc_addr][i].invalid = 1;
                atc[atc_addr][i].invalid_req_time = ireq.req_time;
                atc[atc_addr][i].invalidation_itag = ireq.itag;
                ireq.ats_ids[atc[atc_addr][i].id] = 1;
                register_itag_in_inv_addr_q(.address(atc[atc_addr][i].l_address), .pasidtlp(ireq.pasidtlp), .itag(ireq.itag));
            end 
            //TODO how to handle this ? it's kind of tricky.
            //Delete all mapping with PASID and Delete only in range for non-pasid
            else if ( ireq.pasidtlp.pasid_en == 0 ) begin
                `ovm_info (get_name(), $sformatf("processInvalidationRequest:: %s%s Invalidating ATC entry due to INV with no PASID TlP Prefix", ireq_header, atc_header), _atcCheckerDbg);
                if ( (atc[atc_addr][i].pasidtlp.pasid_en) || ( atc[atc_addr][i].l_address inside {[inv_addr_low:inv_addr_high]}) )begin
                    `ovm_info (get_name(), $sformatf("%s%s Marking Invalid  ATC entry with la= 0x%h , PASIDs due to INV with no PASID TlP Prefix", ireq_header, atc_header,atc[atc_addr][i].l_address ), _atcCheckerDbg);
                    atc[atc_addr][i].invalid = 1;
                    atc[atc_addr][i].invalid_req_time = ireq.req_time;
                    atc[atc_addr][i].invalidation_itag = ireq.itag;
                    ireq.ats_ids[atc[atc_addr][i].id] = 1;
                    register_itag_in_inv_addr_q(.address(atc[atc_addr][i].l_address), .pasidtlp(ireq.pasidtlp), .itag(ireq.itag));
                end
            end
            else if ( atcEntryMatch(atc[atc_addr][i], inv_entry, .skip_address_check(1)) ) begin
                // We want to check that the PASID fields match, but need to ignore the address check as the address
                // range in the invalidation may not match the ATC entry. If we find a match (disregarding the address),
                // then we will check address ranges inside
                if ( atc[atc_addr][i].l_address inside {[inv_addr_low:inv_addr_high]} ) begin
                    `ovm_info (get_name(), $sformatf("processInvalidationRequest:: %s%s Invalidating ATC entry due to Addr=0x%016h inside Invalidation Range (0x%016h - 0x%016h)", ireq_header, atc_header, atc[atc_addr][i].l_address, inv_addr_low, inv_addr_high), _atcCheckerDbg);
                    atc[atc_addr][i].invalid_req_time = ireq.req_time;
                    atc[atc_addr][i].invalidation_itag = ireq.itag;
                    atc[atc_addr][i].invalid = 1;
                    ireq.ats_ids[atc[atc_addr][i].id] = 1;
                    register_itag_in_inv_addr_q(.address(atc[atc_addr][i].l_address ), .pasidtlp(ireq.pasidtlp), .itag(ireq.itag));
                end 
            end 
          //end//foreach( atc[atc_addr][i] ) begin
        end//--atc[atc_addr, i] 



        // [PCIE 10.3.3]: If an Invalidate Request overlaps the address range in an outstanding Translation Request,
        //    the translation request must be tagged as invalid and the translation response must be discarded prior
        //    to transmission of the Invalidate Completion. If the Translation Response is received before the 
        //    Invalidate Completion is sent, and implementation is free to issue requests utilizing the translation 
        //    result.
        // Next mark outstanding ATS requests as invalid 
        foreach ( ats_reqrsp[id] ) begin
            bit [63:0] inv_addr_low  = ireq.aligned_address;
            bit [63:0] inv_addr_high = ireq.aligned_address + ireq.range-1;
            HqmAtcEntry_t tmp_entry;
            
            if ( id.req_id != ireq.txn_id.req_id ) begin
                `ovm_info (get_name(), $sformatf("processInvalidationRequest:: %s Skipping Pending ATS Request check for invalidation processing due to mismatching Device IDs (ATS Req TXN_ID=0x%04h/0x%03h)", ireq_header, id.req_id, id.tag), _atcCheckerDbg);
                continue;
            end 
            
            // Manufacture an ATC entry to check for a match
            tmp_entry.reqid    = ats_reqrsp[id].txn_id.req_id;
            tmp_entry.pasidtlp = ats_reqrsp[id].pasidtlp;
            if ( ireq.pasidtlp.pasid_en == 0 ) begin
                if ( (tmp_entry.pasidtlp.pasid_en) || (ats_reqrsp[id].l_address_4k inside {[inv_addr_low:inv_addr_high]}) ) begin
                    `ovm_info (get_name(), $sformatf("processInvalidationRequest:: %s%s Invalidating Outstanding ATS Request with PASIDs and NO PASIDS within range due to Addr=0x%016h inside Invalidation Range (0x%016h - 0x%016h)", ireq_header, atc_header, ats_reqrsp[id].l_address_4k, inv_addr_low, inv_addr_high), _atcCheckerDbg);
                    ats_reqrsp[id].invalid_req_time = ireq.req_time;
                    ats_reqrsp[id].invalid = 1;
                    ats_reqrsp[id].invalidation_itag = ireq.itag;
                    ireq.ats_ids[ats_reqrsp[id].id] = 1;
                    register_itag_in_inv_addr_q(.address(ats_reqrsp[id].l_address_4k), .pasidtlp(ireq.pasidtlp), .itag(ireq.itag));
                end
            end
            else if ( atcEntryMatch(tmp_entry, inv_entry, .skip_address_check(1), .skip_priv_check(1)) && ats_reqrsp[id].l_address_4k inside {[inv_addr_low:inv_addr_high]} ) begin
                atc_header = $sformatf("[ATS][PASID=0x%05h][PASID_EN=0x%01h][PRIV=%0d]", ats_reqrsp[id].pasidtlp.pasid, ats_reqrsp[id].pasidtlp.pasid_en, ats_reqrsp[id].pasidtlp.priv_mode_requested);
                `ovm_info (get_name(), $sformatf("processInvalidationRequest:: %s%s Invalidating Outstanding ATS Request due to Addr=0x%016h inside Invalidation Range (0x%016h - 0x%016h)", ireq_header, atc_header, ats_reqrsp[id].l_address_4k, inv_addr_low, inv_addr_high), _atcCheckerDbg);
                ats_reqrsp[id].invalid_req_time = ireq.req_time;
                ats_reqrsp[id].invalid = 1;
                ats_reqrsp[id].invalidation_itag = ireq.itag;
                ireq.ats_ids[ats_reqrsp[id].id] = 1;
                register_itag_in_inv_addr_q(.address(ats_reqrsp[id].l_address_4k), .pasidtlp(ireq.pasidtlp), .itag(ireq.itag));
            end 
        end //--foreach ( ats_reqrsp[id] )
        
        `ovm_info (get_name(), $sformatf("processInvalidationRequest:: %s Addr=0x%016h (BaseAddr=0x%016h, Range=%s)", ireq_header, ireq.address, ireq.aligned_address, ireq.range.name()), _atcCheckerDbg);
        
        signalInvReqEvent(ireq);
        
        // Apply the new pending invalidation entry
        inv_reqrsp[ireq.txn_id.req_id][ireq.itag] = ireq;
        
       // // TODO: Need to figure out how this structure is used. A quick look at it, appears that it is not being used really correctly by others. 
       // inv_req_addr = ireq.aligned_address;
       //
       // //TODO vk - to fix this for UTA
       // for (bit[63:0] r = 0; r < RANGE_4M; r += int'(RANGE_4K)) begin 
       //     register_itag_in_inv_addr_q(.address(inv_req_addr), .pasidtlp(ireq.pasidtlp), .itag(ireq.itag));
       //     inv_req_addr += RANGE_4K;
       // end
        inv_request_cov = ireq;
`ifndef EXCLUDE_HQM_TB_CG
        if ( !ats_cfg.disable_cg_sampling ) begin
            inv_req_cov.sample();
        end 
`endif
    endtask:processInvalidationRequest
    
    //-------------------------------------------------------------
    // Function that processes the invalidation response on IOSF
    //-------------------------------------------------------------
    task processInvalidationResponse(HqmBusTxn txn);
        HqmAtsInvReqRsp_t irsp = generateInvRsp(txn);
        HqmAtsInvReqRsp_t rst;
        HqmCmdType_t      cmd_type = txn.getCmdType();
        bit               has_itag;
        string            ats_irsp_itagv_str = get_itagv_str(has_itag, irsp.itag_vector);
        string            irsp_header = $sformatf("[ATS_IRSP][DEVID=0x%04h][ITAG=%s][CC=%0d]", irsp.txn_id.req_id, ats_irsp_itagv_str, irsp.cc);
        bit [7:0]         message_code = txn.getMsgCode();

        // [PCIE 10.3.3] Msg2 /w Message code is 0000_0010
        // Do a sanity check that we are processing an invalidation response
        if ( cmd_type != HQM_Msg2 || message_code != 8'b0000_0010 ) begin
            return;
        end 
        
        if ( ! has_itag ) begin
            `ovm_error(get_name(), $sformatf("%s No valid ITAG found (ITagVector=0x%08h)", irsp_header, irsp.itag_vector));
            return;
        end

        foreach ( irsp.itag_vector[itag] ) begin
            // If the vector index is 0, then go to the next entry, as this is not valid
            if ( irsp.itag_vector[itag] == 0 ) begin
                continue;
            end 
            
            irsp.id = inv_reqrsp[irsp.txn_id.req_id][itag].id; // Link the Rsp ID
            
            if ( ! inv_reqrsp[irsp.txn_id.req_id][itag].outstanding ) begin
                // Check that this invalidation request is outstanding if the itag_vector has the bit set
                `ovm_error(get_name(), $sformatf("%s[ITAG=%0d] ITAG is not outstanding in Invalidation Request Table", irsp_header, itag));
            end else begin
                if ( inv_reqrsp[irsp.txn_id.req_id][itag].cc == 0 ) begin
                    // If the completion count has not been set yet, then populate the structure with 
                    // data from the response
                    inv_reqrsp[irsp.txn_id.req_id][itag].cc = irsp.cc;
                    inv_reqrsp[irsp.txn_id.req_id][itag].itag_vector = irsp.itag_vector;
                end 

                // [PCIE 10.3.3] The Completion Count must be set to the Same value for each completion returned for the same ITag
                if ( inv_reqrsp[irsp.txn_id.req_id][itag].cc != irsp.cc ) begin
                    `ovm_error(get_name(), $sformatf("%s[ITAG=%0d] [PCIE 10.3.3] Completion Count Must be Set to the Same Value in Each Copy of the Invalidate Completion (Expected=%0d Seed=%0d)", irsp_header, itag, inv_reqrsp[irsp.txn_id.req_id][itag].cc, irsp.cc));
                end
                
                // Increment the completion counter since we've detected a completion for this itag
                inv_reqrsp[irsp.txn_id.req_id][itag].cc_counter++;
                            
                `ovm_info(get_name(), $sformatf("%s[ITAG=%0d] CompletionCounter=%0d", irsp_header, itag, inv_reqrsp[irsp.txn_id.req_id][itag].cc_counter), _atcCheckerDbg);

                signalInvRspEvent(.invReq(inv_reqrsp[irsp.txn_id.req_id][itag]), .invRsp(irsp));
                
                // If we have reached the end of the completions, then reset/retire the structure, and mark associated 
                // entries in the ATC as invalid
                if ( inv_reqrsp[irsp.txn_id.req_id][itag].cc_counter == irsp.cc ) begin
                    // TODO: This event name name really should be unique to IP instance.  
                    string        ev_name     = $sformatf("%s__itag_%0d", HqmAtsPkg::HQM_ATS_IRSP_E, itag);
                    ovm_event     ats_irsp_ev = _eventPool.get(ev_name);
                    bit [63:0]    atc_addr;
                    int           atc_addr_size = 0;
                    HqmAtcEntry_t inv_entry;
                    HqmAtcEntry_t atc_entry;
                    string        atc_header;
                    bit [63:0]    inv_addr_low  = inv_reqrsp[irsp.txn_id.req_id][itag].aligned_address;
                    bit [63:0]    inv_addr_high = inv_reqrsp[irsp.txn_id.req_id][itag].aligned_address + inv_reqrsp[irsp.txn_id.req_id][itag].range-1;

                    `ovm_info (get_name(), $sformatf("%s ITAG=%0d Retiring Outstanding ATS IREQ trigger ats_irsp_ev with ev_name=%0s", irsp_header, itag, ev_name), _atcCheckerDbg);
                    ats_irsp_ev.trigger(); //-- HqmIommuAPI wait_irsp() wait_on this event

                    inv_entry.reqid     = inv_reqrsp[irsp.txn_id.req_id][itag].txn_id.req_id;
                    inv_entry.pasidtlp  = inv_reqrsp[irsp.txn_id.req_id][itag].pasidtlp;
                    inv_entry.l_address = inv_reqrsp[irsp.txn_id.req_id][itag].aligned_address;  

                    // Go through the ATC and mark the invalidation completion time
                    atc_addr_size = atc[atc_addr].size();
                    foreach ( atc[atc_addr] ) begin
                        atc_addr_size = atc[atc_addr].size();
                        
                        for ( int i=atc_addr_size-1 ; i >= 0 ; i-- ) begin
                            atc_entry = atc[atc_addr][i];
                            atc_header = $sformatf("[ATC][REQID=0x%04h][PASID=0x%05h][PASID_EN=0x%01h][PRIV=%0d][G=%0d][U=%0d][EXE=%0d][RW=0x%01h]", atc_entry.reqid, atc_entry.pasidtlp.pasid, atc_entry.pasidtlp.pasid_en, atc_entry.pasidtlp.priv_mode_requested, atc_entry.cpl.global_mapping, atc_entry.cpl.unxlat_access, atc_entry.cpl.execute_permitted, atc_entry.cpl.read_write);
                            
                            // Do a check that the REQID entry in the ATC matches that of the Invalidation
                            if ( atc_entry.reqid != irsp.txn_id.req_id ) begin
                                `ovm_info(get_name(), $sformatf("%s%s Skip Invalidation Response Handling for ATC Entry due to mismatching REQIDs", irsp_header, atc_header), _atcCheckerDbg);
                                continue;
                            end 
                            
                            // Skip looking at entries not marked invalid or entries that don't have a marked invalidation time
                            if ( atc_entry.invalid != 1 || atc_entry.invalid_req_time == 0 ) begin
                                continue;
                            end 

                            if ( inv_reqrsp[irsp.txn_id.req_id][itag].pasidtlp.pasid_en && inv_reqrsp[irsp.txn_id.req_id][itag].global_invalidate && (atc[atc_addr][i].l_address inside {[inv_addr_low:inv_addr_high]}) ) begin
                                HqmAtcLAddrLookup_t lookup = '{ pasidtlp  : atc[atc_addr][i].pasidtlp,
                                                                l_address : atc[atc_addr][i].l_address };
                                `ovm_info(get_name(), $sformatf("%s Removed ATC entry due to Invalidation (Global) Completion %s Addr=0x%016h", irsp_header, atc_header, atc[atc_addr][i].l_address), _atcCheckerDbg);
                                if ( _atc_logical_lookup.exists(lookup) ) begin
                                    _atc_logical_lookup.delete(lookup);
                                end 
                                atc[atc_addr].delete(i);
                            end else if ( atcEntryMatch(atc_entry, inv_entry, .skip_address_check(1)) ) begin
                                if (atc[atc_addr][i].invalidation_itag == itag && atc[atc_addr][i].l_address inside {[inv_addr_low:inv_addr_high]} ) begin
                                    HqmAtcLAddrLookup_t lookup = '{ pasidtlp  : atc[atc_addr][i].pasidtlp,
                                                                    l_address : atc[atc_addr][i].l_address };
                                    
                                    `ovm_info(get_name(), $sformatf("%s Removed ATC entry due to Invalidation Completion %s Addr=0x%016h", irsp_header, atc_header, atc[atc_addr][i].l_address), _atcCheckerDbg);
                                    if ( _atc_logical_lookup.exists(lookup) ) begin
                                        _atc_logical_lookup.delete(lookup);
                                    end 
                                    atc[atc_addr].delete(i);
                                end 
                            end 
                        end 
                    end 
                    
                    // [PCIE 10.3.3]: If an Invalidate Request overlaps the address range in an outstanding Translation Request,
                    //    the translation request must be tagged as invalid and the translation response must be discarded prior
                    //    to transmission of the Invalidate Completion. If the Translation Response is received before the 
                    //    Invalidate Completion is sent, and implementation is free to issue requests utilizing the translation 
                    //    result.
                    // Next mark outstanding ATS requests with the cpl time. Once this is set, this will prevent 
                    foreach ( ats_reqrsp[id] ) begin
                        if ( id.req_id != irsp.txn_id.req_id ) begin
                            `ovm_info (get_name(), $sformatf("%s Skipping Pending ATS Request check for invalidation processing due to mismatching Device IDs (ATS Req TXN_ID=0x%04h/0x%03h)", irsp_header, id.req_id, id.tag), _atcCheckerDbg);
                            continue;
                        end 
                        
                        if ( ats_reqrsp[id].invalid && ats_reqrsp[id].invalidation_itag == itag && ats_reqrsp[id].l_address_4k inside {[inv_addr_low:inv_addr_high]} ) begin
                            atc_header = $sformatf("[ATS][PASID=0x%05h][PASID_EN=0x%01h][PRIV=%0d]", ats_reqrsp[id].pasidtlp.pasid, ats_reqrsp[id].pasidtlp.pasid_en, ats_reqrsp[id].pasidtlp.priv_mode_requested);
                            
                            `ovm_info (get_name(), $sformatf("%s%s Invalidation Completion Received during Outstanding ATS Request to Addr=0x%016h inside Invalidation Range (0x%016h - 0x%016h)", irsp_header, atc_header, ats_reqrsp[id].l_address_4k, inv_addr_low, inv_addr_high), _atcCheckerDbg);
                            ats_reqrsp[id].invalid_cpl_time = irsp.cpl_time;
                        end 
                    end 
                    
                    inv_reqrsp[irsp.txn_id.req_id][itag] = rst; // Reset the itag entry (set back to all 0's as we are done with this invalidation
                    
                    inv_response_cov = irsp;
`ifndef EXCLUDE_HQM_TB_CG
                    if ( !ats_cfg.disable_cg_sampling ) begin
                        inv_rsp_cov.sample();
                    end 
`endif
                end
            end
        end 
    endtask:processInvalidationResponse
    
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    task processOutTxn (HqmBusTxn txn);
        HqmCmdType_t cmd_type = txn.getCmdType();
        
        // ATS REQ
        case ( cmd_type )

            // Note: Previously, this code has a bug in that the case statement had two sections looking for 
            //   MRd32/64, and thus a MRd /w 'tat!=2' would never go into the second case section
            HQM_MRd32, HQM_MRd64,
            HQM_MWr32, HQM_MWr64 : begin : PCIE_MEM
                if ( cmd_type inside {HQM_MRd32, HQM_MRd64} && (txn.at == HQM_AT_TRANSLATION_REQ) ) begin
                   `ovm_info (get_name(), $sformatf("HQMATSCHECKER_processOutTxn:: captured ATS_REQ - call processAtsRequest "), _atcCheckerDbg);
                    processAtsRequest(txn);
                end
                // processNonAtsMemRequest needs to be moved to execute on the command phase instead of the data phase.see run() task to see processNonAtsMemRequest
                // adding this is run() task should cause the check to execute
                // during command phase and not at end of data phase
                /*else if ( txn.tat inside { 2'b00, 2'b10 } ) begin
                    processNonAtsMemRequest(txn);
                end */
            end
            
            // PRS request 
            HQM_Msg0 : begin : ATS_PREQ
                if ( txn.getMsgCode() == 8'b0000_0100 ) begin
                    processPageRequest(txn);
                end 
            end
            
            // ATS Invalidation Completion Response
            //--AY_HQMV30_ATS   PCIe::Msg2 : begin : ATS_IRSP
            HQM_Msg2 : begin : ATS_IRSP
                bit [ 7:0] ats_irsp_message_code    = txn.getMsgCode();
                bit [63:0] treq_addr= txn.address;

                `ovm_info (get_name(), $sformatf("HQMATSCHECKER_processOutTxn:: captured HQM_Msg2 ats_irsp_message_code=0x%0x ", ats_irsp_message_code), _atcCheckerDbg);
                if ( ats_irsp_message_code==8'b0000_0010 ) begin
                   `ovm_info (get_name(), $sformatf("HQMATSCHECKER_processOutTxn:: captured HQM_Msg2 ats_irsp_message_code=0x%0x - call trigger_event", ats_irsp_message_code), _atcCheckerDbg);
                    trigger_event (.tr_type("ATS_IRSP"), .address(treq_addr), .txn(txn));
                   `ovm_info (get_name(), $sformatf("HQMATSCHECKER_processOutTxn:: captured HQM_Msg2 ats_irsp_message_code=0x%0x - call processInvalidationResponse", ats_irsp_message_code), _atcCheckerDbg);
                    processInvalidationResponse(txn);
                end 
            end

        endcase

    endtask:processOutTxn

    // -------------------------------------------------------------------------
    function string get_itagv_str ( output has_itag, input bit [31:0] itagv );
        string ats_irsp_itagv_str = "";

        for ( int itag=0; itag<32; itag++)  begin
            if ( itagv[itag] ) begin
                if ( ats_irsp_itagv_str == "" ) begin
                    ats_irsp_itagv_str = $sformatf("%0d", itag);
                end else begin
                    ats_irsp_itagv_str = { ats_irsp_itagv_str, "|", $sformatf("%0d", itag) };
                end 
                has_itag = 1;
            end
        end

        return ats_irsp_itagv_str;
    endfunction

    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    task processInTxn (HqmBusTxn txn);
        HqmCmdType_t cmd_type = txn.getCmdType();
        
        case (cmd_type)
            // ATS Address Translation Completion
            HQM_Cpl,
            HQM_CplD  : begin 
               `ovm_info (get_name(), $sformatf("HQMATSCHECKER_processInTxn:: captured ATS_RESP - call processAtsResponse "), _atcCheckerDbg);
                processAtsResponse(txn);
            end
            // ATS Invalidation Request
            HQM_MsgD2 : begin 
               `ovm_info (get_name(), $sformatf("HQMATSCHECKER_processInTxn:: captured ATS_INV_REQ - call processInvalidationRequest "), _atcCheckerDbg);
                processInvalidationRequest(txn);
            end 
            
             // PRS response 
            HQM_Msg2 : begin : ATS_PRSP
               `ovm_info (get_name(), $sformatf("HQMATSCHECKER_processInTxn:: captured ATS_PRSP  "), _atcCheckerDbg);
                if ( txn.getMsgCode() == 8'b0000_0101 ) begin
                    processPageGroupResponse(txn);
                end 
            end
            
        endcase
    endtask:processInTxn

    // -------------------------------------------------------------------------
    // Notes: The usage of this function appears to be where a user provides an address, and it returns an 'itag'
    //   for that address. But this only works for addresses where an invalidation has already been sent. This
    //   structure never gets cleaned up, and if the address does not exist, always returns 0. Accuracy of this 
    //   function is highly suspect. There's probably a better way to do what this was trying to do. 
    function bit [4:0] find_inv_itag(bit[63:0] inv_addr, HqmPasid_t pasidtlp);
        HqmPasid_t formatted_pasidtlp = get_formatted_pasidtlp(pasidtlp);
        bit [4:0]  ireq_itag;
        
        ireq_itag = inv_addr_q[inv_addr][formatted_pasidtlp];
        `ovm_info (get_name(), $sformatf(" ireq_itag is = 0x%h for INV addr 0x%0h", ireq_itag, inv_addr), _atcCheckerDbg);
        return ireq_itag;
        
    endfunction

    // -----------------------------------------------------------------------
    local function string genPasidStr(HqmPasid_t pasidtlp);
        string pasid_str    = (! pasidtlp.pasid_en) ? "0x-----" : $sformatf("0x%05h", pasidtlp.pasid);
        return pasid_str;
    endfunction

    // -----------------------------------------------------------------------
    function void check();
        HqmAtsLegalTranslations_t pg;
        // Check that there are no pending ATS requests at end of simulation
        foreach ( ats_reqrsp[id] ) begin
            `ovm_error(get_name(), $sformatf("check(): Outstanding ATS Request remaining at end of sim (ReqId=0x%04h/Tag=0x%03h Time=%t)", ats_reqrsp[id].txn_id.req_id, ats_reqrsp[id].txn_id.tag, ats_reqrsp[id].req_time));
        end 
        foreach ( inv_reqrsp[id,i] ) begin
            if ( inv_reqrsp[id][i].outstanding ) begin
                `ovm_error(get_name(), $sformatf("check(): Outstanding Invalidation Request remaining at end of sim (ReqId=0x%04h/Tag=0x%03h Time=%t)", inv_reqrsp[id][i].txn_id.req_id, inv_reqrsp[id][i].txn_id.tag, inv_reqrsp[id][i].req_time));
            end
        end
        // check if all the expected ats reqs are seen. 
        //  if an entry in the list is not seen, 
        //    check if the entry is with a read only access
        //    if yes, then check if an entry with the same address, but with rd+wr access exists. if it exists, then it is ok that the entry with rd only permission is not seen
        //    otherwise, it should be seen
        foreach ( legal_translations[page] ) begin
            if (legal_translations[page].count == 0) begin
//                if ($test$plusargs("LEGAL_ATS_CHECK")) begin
                if (legal_translations[page].mustSee) begin
                    if (!ats_cfg.disable_legal_ats_check) begin
                        if (page.write == 0) begin
                            pg = page;
                            pg.write = 1;
                            // if the RTL requested an ATS req with wr access to the same page, then it is ok to not see this entry
                            if (!legal_translations.exists(pg)) begin
                                if (!atcEntryExists(pg)) begin
                                    string info_str;
                                    foreach ( legal_translations[page].id_info_string[i] ) begin
                                        if ( i == 0 ) begin
                                            info_str = legal_translations[page].id_info_string[i];
                                        end else begin
                                            info_str = $sformatf("%s,%s", info_str, legal_translations[page].id_info_string[i]);
                                        end 
                                    end 
                                    `ovm_error(get_name(), $sformatf("check(): ATS Request Not Seen : %p . Used In : %s", page, info_str));
                                end 
                            end 
                        end else begin
                            //      if (!atcEntryExists(page)) begin
                            //    string info_str;
                            //    foreach ( legal_translations[page].id_info_string[i] ) begin
                            //        if ( i == 0 ) begin
                            //            info_str = legal_translations[page].id_info_string[i];
                            //        end else begin
                            //            info_str = $sformatf("%s,%s", info_str, legal_translations[page].id_info_string[i]);
                            //        end 
                            //    end 
                            //    `ovm_error(get_name(), $sformatf("check(): ATS Request Not Seen : %p . Used In : %s", page, info_str));
                            //end
                        //end
                        //The following code added for the issue:Ats Req not seen for ENCRYPT Operation due to ATS_IREQ and Data completion issue for DECRYPT Operation
                        if ( !atcEntryExists(page) ) begin
                                bit found = 0;
                                pg = page; 
                                pg.write = 0; // Alternate page handle with Write=0
                                if ( !legal_translations.exists(pg) ) begin
                                    found = 0;
                                end else if ( atcEntryExists(pg) ) begin
                                    // This means there is a entry that had 'No Write = 1'. Under this condition, RTL may still cache
                                    // the entry for Writes if the Completion came back with W=1
                                    HqmAtcEntry_t entry_q[$] = atc[pg]; 
                                    foreach ( entry_q[k] ) begin
                                        if ( entry_q[k].cpl.read_write inside { HQM_ATSCPL_WR_ONLY, HQM_ATSCPL_RW } ) begin
                                            found = 1;
                                            break;
                                        end 
                                    end 
                                end 
                                
                                if ( !found ) begin
                                    string info_str;
                                    foreach ( legal_translations[page].id_info_string[i] ) begin
                                        if ( i == 0 ) begin
                                            info_str = legal_translations[page].id_info_string[i];
                                        end else begin
                                            info_str = $sformatf("%s,%s", info_str, legal_translations[page].id_info_string[i]);
                                        end 
                                    end 
                                    `ovm_error(get_name(), $sformatf("check(): ATS Request Not Seen : %p . Used In : %s", page, info_str)); 
                                end 
                            end
                        end
                    end
                end else begin
                    `ovm_info(get_name(), $sformatf("check(): ATS Request Not Seen : %p", page), _atcCheckerDbg);
                end
            end
        end 

    endfunction
    
    // check if a txn in legal_translations exists in atc, to be performed at the end of test
    function bit atcEntryExists(HqmAtsLegalTranslations_t ats);
        HqmAtcEntry_t          entry;
        RangeSize_t range_size = ats_cfg.get_range(ats.address);
        bit [63:0]             mask = ats_cfg.get_mask(range_size);
        string                 pasid_str = genPasidStr(ats.pasidtlp);
        int                    ind[$];
        bit                    found = 0;
        
        entry.reqid          = ats.reqid;
        entry.pasidtlp       = ats.pasidtlp;
        entry.l_address      = (mask & ats.address);
        foreach (atc[e]) begin
            ind = atc[e].find_index( x ) with ( x.l_address == entry.l_address && x.pasidtlp == ats.pasidtlp );
            if (ind.size() != 0) begin
                entry = atc[e][ind[0]];
                found = 1;
                break;
            end
        end
        return found;
    endfunction

    // -----------------------------------------------------------------------
    virtual function void report();
        $fclose(_trk_file);
    endfunction

    // This task continously monitors registered reset events to reset internal structures
    virtual task monitor_reset();
        foreach ( chassis_reset_event_name[i] ) begin
            fork
                automatic bit [15:0] bdf = i;
                monitorChassisReset(bdf);
            join_none
        end 
        foreach ( non_chassis_reset_event_name[i] ) begin
            fork
                automatic bit [15:0] bdf = i;
                monitorNonChassisReset(bdf);
            join_none
        end 
    endtask 

    // Monitors the chassis reset flow. When the event fires, the entries in the various structures get reset
    virtual task monitorChassisReset(bit [15:0] bdf);
        ovm_event reset_e;
        ovm_event ats_en_change_ev;
        HqmAtsInvReqRsp_t rst;
        int       size = 0;
        
        if ( ! chassis_reset_event_name.exists(bdf) ) begin
            return;
        end 
        reset_e          = _eventPool.get(chassis_reset_event_name[bdf]);
        ats_en_change_ev = _eventPool.get("ATS_EN_EVENT");
        
        `ovm_info (get_name(), $sformatf("[CHASSIS-RESET][REQID=0x%04h] Begin Detector For Reset Event", bdf), OVM_LOW);
        
        while (1) begin
            fork
              reset_e.wait_trigger();
              ats_en_change_ev.wait_trigger();
            join_any
            // Don't continue if the event was reset
            if ( reset_e.is_off() && ats_en_change_ev.is_off()) begin
                continue;
            end 

            `ovm_info (get_name(), $sformatf("[CHASSIS-RESET][REQID=0x%04h] Detected Reset Event", bdf), OVM_LOW);
            
            foreach ( ats_reqrsp[id] ) begin
                if ( id.req_id == bdf ) begin
                    `ovm_info (get_name(), $sformatf("[CHASSIS-RESET][TXNID=0x%04h/0x%03h] Removing pending ATS Request", id.req_id, id.tag), _atcCheckerDbg);
                    ats_reqrsp.delete(id);
                end 
            end 

            foreach ( inv_reqrsp[reqid, i] ) begin
                if ( reqid == bdf ) begin
                    `ovm_info (get_name(), $sformatf("[CHASSIS-RESET][REQID=0x%04h/0x%03h] Removing pending Invalidation Entry (ITAG=%0d)", inv_reqrsp[reqid][i].txn_id.req_id, inv_reqrsp[reqid][i].txn_id.tag, inv_reqrsp[reqid][i].itag), _atcCheckerDbg);
                    inv_reqrsp[reqid][i] = rst;
                end 
            end 
            
            foreach ( atc[pa] ) begin
                size = atc[pa].size();
                if ( size < 1 ) begin
                    continue;
                end 
                for ( int i=size-1 ; i >= 0 ; i-- )begin
                    if ( atc[pa][i].reqid == bdf ) begin
                        `ovm_info (get_name(), $sformatf("[CHASSIS-RESET][REQID=0x%04h][Addr=0x%016h] Removing ATC Entry", atc[pa][i].reqid, pa), _atcCheckerDbg);
                        atc.delete(i);
                    end 
                end 
            end 
            foreach ( legal_translations[tr] ) begin
                `ovm_info (get_name(), $sformatf("[CHASSIS-RESET] Removing legal_translation : %p", legal_translations[tr]), _atcCheckerDbg);
                legal_translations.delete(tr);
            end
            _prs_req_q.delete();
            _atc_logical_lookup.delete();
        end 
    endtask
    
    // Monitors the chassis reset flow. When the event fires, the entries in the various structures get reset
    // In the case of device reset, we do not reset the invalidation structure (device should still send invalidation completions through the reset)
    virtual task monitorNonChassisReset(bit [15:0] bdf);
        ovm_event reset_e;
        int       size = 0;
        
        if ( ! non_chassis_reset_event_name.exists(bdf) ) begin
            return;
        end 
        
        reset_e = _eventPool.get(non_chassis_reset_event_name[bdf]);
        
        `ovm_info (get_name(), $sformatf("[CHASSIS-RESET][REQID=0x%04h] Begin Detector For Reset Event", bdf), OVM_LOW);
        
        while (1) begin
            reset_e.wait_trigger();
            
            // Don't continue if the event was reset
            if ( reset_e.is_off() ) begin
                continue;
            end 
            
            `ovm_info (get_name(), $sformatf("[DEVICE-RESET][REQID=0x%04h] Detected Reset Event", bdf), OVM_LOW);
            
            foreach ( ats_reqrsp[id] ) begin
                if ( id.req_id == bdf ) begin
                    `ovm_info (get_name(), $sformatf("[DEVICE-RESET][TXNID=0x%04h/0x%03h] Removing pending ATS Request", id.req_id, id.tag), _atcCheckerDbg);
                    ats_reqrsp.delete(id);
                end 
            end 
            
            foreach ( atc[pa] ) begin
                size = atc[pa].size();
                if ( size < 1 ) begin
                    continue;
                end 
                for ( int i=size-1 ; i >= 0 ; i-- )begin
                    if ( atc[pa][i].reqid == bdf ) begin
                        `ovm_info (get_name(), $sformatf("[DEVICE-RESET][REQID=0x%04h] Removing ATC Entry", atc[pa][i].reqid), _atcCheckerDbg);
                        atc.delete(i);
                    end 
                end 
            end 
            foreach ( legal_translations[tr] ) begin
                `ovm_info (get_name(), $sformatf("[DEVICE-RESET] Removing legal_translation : %p", legal_translations[tr]), _atcCheckerDbg);
                legal_translations.delete(tr);
            end
            
            _atc_logical_lookup.delete();
        end 
    endtask
    
    // registers the legal ats requests
    function void registerLegalTranslation(HqmAtsLegalXlatArgs_t args);
        args.xlat.address = get4kAlignedAddr(args.xlat.address);

        if (!args.xlat.pasidtlp.pasid_en)
            args.xlat.pasidtlp.pasid = 0;
        if (!legal_translations.exists(args.xlat)) begin
            legal_translations[args.xlat].count = 0;
            legal_translations[args.xlat].mustSee = args.must_see;
            `ovm_info(get_name(), $sformatf("registerLegalTranslation() : Registered ATS Request : %p, MustSee : %0d  Info : %s %s", args.xlat, legal_translations[args.xlat].mustSee, args.id_info, args.buf_name), _atcCheckerDbg);
        end
        legal_translations[args.xlat].id_info_string.push_back(args.id_info);
//        legal_translations[xlat].mustSee = mustSee;
    endfunction
    
    function void updateLegalTranslation (string idinfo);
        int xlatq[$];
        foreach (legal_translations[xlt]) begin
            xlatq = legal_translations[xlt].id_info_string.find_index( x ) with ( x == idinfo );
            if (xlatq.size() != 0) begin
                legal_translations[xlt].mustSee = 0;
            end
        end
    endfunction
    
    // -----------------------------------------------------------------------
    function HqmPrsReq_t generatePrsReq(HqmBusTxn x);
        // Figure 2-12 in IOSF Spec
        // IOSF Address[31:0]  = Bytes 8-11 
        // IOSF Address[63:32] = Bytes 12-15
        generatePrsReq.req_time    = x.start_time;
        generatePrsReq.address     = {x.address[31:0], x.address[63:44], 12'h0}; // Zero's out the lower address since those are stored elsewhere
        generatePrsReq.data_fields = x.address[43:32];
        generatePrsReq.pasidtlp    = x.pasidtlp;
        generatePrsReq.txn_id      = x.txn_id;
        generatePrsReq.tc          = x.tc;
        
    endfunction
    
    // -----------------------------------------------------------------------
    // 10.4.1 Process Page Request Message. 
    // -----------------------------------------------------------------------
    task processPageRequest(HqmBusTxn x);
        HqmCmdType_t cmd_type = x.getCmdType();
        HqmPrsReq_t  prs_req;
        string       header;
        
        // 10.4.1 Figure 10-16: Msg0 && Message Code = 0000_0100
        if ( !(cmd_type == hcw_transaction_pkg::HQM_Msg0 && (x.getMsgCode() == 8'b0000_0100)) ) begin
            return;
        end 
        
        prs_req = generatePrsReq(x);
        // Assign this request an ID
        prs_req.id = _prsID++;
        prs_request_cov = prs_req;

        header =  $sformatf("[PRS_REQ][DEVID=0x%04h][IDX=0x%03h][R=%0d][W=%0d][L=%0d]", 
                             prs_req.txn_id.req_id, prs_req.data_fields.page_req_group_index, prs_req.data_fields.read, prs_req.data_fields.write, prs_req.data_fields.last_req);

        `ovm_info (get_name(), $sformatf("%s : Saw Page Request", header), _atcCheckerDbg);

        signalPrsReqEvent(.prsReq(prs_req));
        
        _prs_req_q.push_back(prs_req);
        
        trigger_event (.tr_type("ATS_PREQ"), .address(prs_req.address), .txn(x));
`ifndef EXCLUDE_HQM_TB_CG
        if ( !ats_cfg.disable_cg_sampling ) begin
            prs_req_cov.sample();
        end
`endif 
    endtask
    
    // -----------------------------------------------------------------------
    function HqmPrgRsp_t generatePrgRsp(HqmBusTxn x);
        // Figure 2-12 in IOSF Spec
        // IOSF Address[31:0]  = Bytes 8-11 
        // IOSF Address[63:32] = Bytes 12-15
        generatePrgRsp.rsp_time    = x.start_time;
        generatePrgRsp.data_fields = x.address[31:0];
        generatePrgRsp.pasidtlp    = x.pasidtlp;
        generatePrgRsp.txn_id      = x.txn_id;
        generatePrgRsp.tc          = x.tc;
        
    endfunction
    
    // -----------------------------------------------------------------------
    // 10.4.2 Process Page Group Response
    // -----------------------------------------------------------------------
    task processPageGroupResponse(HqmBusTxn x);
        HqmCmdType_t cmd_type = x.getCmdType();
        HqmPrgRsp_t  prg_rsp;
        HqmPrsReq_t  prs_req;
        string       header;
        
        // 10.4.1 Figure 10-18: Msg2 && Message Code = 0000_0101
        if ( !(cmd_type == hcw_transaction_pkg::HQM_Msg2 && (x.getMsgCode() == 8'b0000_0101)) ) begin
            return;
        end 
        
        prg_rsp = generatePrgRsp(x);
        prs_response_cov = prg_rsp;
        
        header =  $sformatf("[PRG_RRSP][REQID=0x%04h][IDX=0x%03h]", prs_req.txn_id.req_id, prs_req.data_fields.page_req_group_index);

        `ovm_info (get_name(), $sformatf("%s : Saw Page Group Response", header), _atcCheckerDbg);
        
        // Find the associated PRS Req and remove it from the queue
        foreach ( _prs_req_q[i] ) begin
            if ( _prs_req_q[i].data_fields.page_req_group_index == prg_rsp.data_fields.page_req_group_index ) begin
                prs_req = _prs_req_q[i];
                _prs_req_q.delete(i);
                break;
            end 
        end 
        
        signalPrgRspEvent(.prgRsp(prg_rsp), .prsReq(prs_req));
        trigger_event (.tr_type("ATS_PRSP"), .address(x.address), .txn(x));
        
`ifndef EXCLUDE_HQM_TB_CG
        if ( !ats_cfg.disable_cg_sampling ) begin
            prs_rsp_cov.sample();
        end 
`endif
    endtask
    
endclass : HqmAtsChecker

