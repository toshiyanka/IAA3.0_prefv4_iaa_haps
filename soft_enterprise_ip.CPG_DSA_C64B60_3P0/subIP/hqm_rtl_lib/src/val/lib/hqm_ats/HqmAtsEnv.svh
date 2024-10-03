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
// Description: IOMMU Env Verfication Component
//              -------------------------------
//
//              This ENV contains:
//                  + handle to an IOMMU memory model.
//                      IOMMU model contains API to read/write/delete/etc translation entries
//                  + handle to Page Request Interface
//
//              Sample code shows how to obtain a handle to the IOMMU Address
//              Translation Services Interface (i.e. API) that is used to populate
//              the ATS Address Translation Map.
//
//              bit          rc;
//              ovm_object   tmpObj;
//              HqmAtsEnv    iommu_env;
//              HqmIommuATS  iommu_ats;
//                  ... ... ...
//              rc = get_config_object(HqmSharedParamPkg::HQM_IOMMUENV_NAME, tmpObj);
//              `sla_assert(rc, ("Could not find HQM_IOMMUENV_NAME"))
//              rc = $cast(iommu_env, tmpObj);
//              `sla_assert(rc, ("Couldn't typecast object"))
//                  ... ... ...
//              iommu = iommu_env.get_iommu();
//
// -----------------------------------------------------------------------------
// CLASS: HqmAtsEnv
//

//--AY_HQMV30_ATS--  

class HqmAtsEnv extends ovm_component;

    `ovm_component_utils(HqmAtsEnv)

    // TB Config Object
    HqmAtsCfgObj    ats_cfg;

    HqmIommu        m_iommu;
    HqmIommuAPI     m_iommu_api;

    // ATS Tracker Filename
    local OVM_FILE       _hqm_iommu_file;
    protected bit        disableSetupReporting;

    // // HQM-IOMMU Analysis Environment ------------------
    HqmAtsAnalysisEnv     ats_analysis_env;

    // -------------------------------------------------------------------------
    function new (string name = "HqmAtsEnv", ovm_component parent = null);
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
        return _hqm_iommu_file;
    endfunction

    // -------------------------------------------------------------------------
    virtual function void setupReporting();
        // First setup reporting for this component and down
        if ( _hqm_iommu_file != 0 ) begin
            set_report_default_file_hier(_hqm_iommu_file);
        end
        if ( ! ats_cfg.get_disable_tb_report_severity_settings() ) begin
            set_report_severity_action_hier(OVM_INFO,    OVM_LOG);
            set_report_severity_action_hier(OVM_WARNING, OVM_LOG);
            set_report_severity_action_hier(OVM_ERROR,   OVM_DISPLAY | OVM_LOG);
            set_report_severity_action_hier(OVM_FATAL, OVM_DISPLAY | OVM_LOG | OVM_EXIT);
        end

        // Now set up for the lower level components
        if ( m_iommu_api != null ) begin
            m_iommu_api.setupReporting();
        end
        if ( ats_analysis_env != null ) begin
            ats_analysis_env.setupReporting();
        end
    endfunction

    // -------------------------------------------------------------------------
    // Function     :   init()
    // Description  :
    function void init ();
        bit rc;
        ovm_object obj;

        // Get IOMMU CFG
        rc = get_config_object("AtsCfgObj", obj, 0);
        `sla_assert(rc, ("init(): Can't get config object"))

        rc = $cast(ats_cfg, obj);
        `sla_assert(rc, ("init(): Config object is wrong type"))

        ats_cfg.env = this;

        // Set Output File
        _hqm_iommu_file = $fopen(ats_cfg.ENV_FILENAME, "a");
        set_report_default_file_hier(_hqm_iommu_file);

    endfunction : init


    // OVM Phase: build --------------------------------------------------------
    function void build ();

        init();

        super.build();

        ovm_report_info(get_type_name(),"build(): ------- BEGIN -------", OVM_LOW);

        // Create Root Complex Page Request Service BFM
        if (ats_cfg.is_active) begin

            m_iommu_api = HqmIommuAPI::type_id::create($sformatf("m_iommu_BDF_0x%H", ats_cfg.iommu_bdf), this);
            m_iommu_api.setDisableSetupReporting();

            m_iommu     = m_iommu_api;

            if ( ats_cfg.agent_name=="" ) begin
                `ovm_fatal(get_type_name(),"build(): ats_cfg.agent_name = \"\"")
            end else begin
                ovm_report_info(get_type_name(), $sformatf("build(): ats_cfg.agent_name = %s", ats_cfg.agent_name), OVM_LOW);
            end
        end

        if (! (ats_cfg.disable_tracker && ats_cfg.disable_checker) ) begin
            ats_analysis_env  = HqmAtsAnalysisEnv#()::type_id::create("AtsAnalysisEnv", this);
            ats_analysis_env.iommu_api = m_iommu_api;
            ats_analysis_env.setDisableSetupReporting();
        end

        ovm_report_info(get_type_name(),"build(): ------- END   -------\n", OVM_LOW);

    endfunction : build


    // OVM Phase: connect ------------------------------------------------------
    function void connect ();
        ovm_report_info(get_type_name(),"connect(): ------- BEGIN -------", OVM_LOW);

        super.connect();

        if ( ! getDisableSetupReporting() ) begin
            setupReporting();
        end

        ovm_report_info(get_type_name(),"connect(): ------- END   -------\n", OVM_LOW);
    endfunction

    // OVM Phase: End of Elaboration  ------------------------------------------
    function void end_of_elaboration ();

        ovm_report_info(get_type_name(),"end_of_elaboration(): ------- BEGIN -------", OVM_LOW);

        ovm_report_info(get_type_name(),"end_of_elaboration(): ------- END   -------\n", OVM_LOW);
    endfunction


    // OVM Phase: Start of Simulation ------------------------------------------
    function void start_of_simulation ();

        ovm_report_info(get_type_name(),"start_of_simulation(): ------- BEGIN -------", OVM_LOW);
        ats_cfg.print_device_ats_csr();

         if (ats_cfg.run_iommu_mem_selftest) run_iommu_test();

        ovm_report_info(get_type_name(),"start_of_simulation(): ------- END   -------\n", OVM_LOW);
    endfunction


    // OVM Phase: Run ----------------------------------------------------------
    task run ();
        ovm_report_info(get_type_name(),"run(): ------- BEGIN -------"  , OVM_LOW);
        ovm_report_info(get_type_name(),"run(): ------- END   -------\n", OVM_LOW);
    endtask : run


    // -------------------------------------------------------------------------
    // Function     :   run_iommu_test
    // Description  :   Runs Basic IOMMU Test
    //
    function void run_iommu_test ();
        HqmPasid_t pasidtlp;
        pasidtlp.pasid_en = 1;
        pasidtlp.pasid    = 4;
        
        ovm_report_info(get_name(), "run_iommu_test(): BEGIN    self-test.", OVM_MEDIUM);
       
        // Populate IOMMU Translation Table and Print them to Simulation Output Log
        this.add_address_translation(.bdf('hBEEF), .pasidtlp(pasidtlp), .num_xlt_entries(10), .base_lpa('hA_1000), .la_pagesize(PAGE_SIZE_4K), .base_ppa('hB_1000), .pa_pagesize(PAGE_SIZE_4K));
        m_iommu_api.print_address_map (.bdf('hBEEF), .pasidtlp(pasidtlp));

        // Add m_iommu_api Translation Table Entry
        m_iommu_api.print_address_translation  (.bdf('hBEEF), .pasidtlp(pasidtlp), .logical_address('hA_1000));   // print
        m_iommu_api.read_address_translation   (.bdf('hBEEF), .pasidtlp(pasidtlp), .logical_address('hA_1000));
        m_iommu_api.delete_address_translation (.bdf('hBEEF), .pasidtlp(pasidtlp), .logical_address('hA_1000));   // delete
        m_iommu_api.print_address_map          (.bdf('hBEEF), .pasidtlp(pasidtlp));                               // print all
        m_iommu_api.read_address_translation   (.bdf('hBEEF), .pasidtlp(pasidtlp), .logical_address('hA_1000));

        ovm_report_info(get_name(), "run_iommu_test(): END      self-test.", OVM_MEDIUM);
    endfunction : run_iommu_test



    // *************************************************************************
    //              IOMMU Environment API
    // *************************************************************************



    // -------------------------------------------------------------------------
    // Function     :   add_address_translation
    // Description  :
    //
    function void add_address_translation (input int         num_xlt_entries,           // Number of Address Translation (XLT) Entries
                                                 bit [15:0]  bdf,                       // Bus Device Function number
                                                 HqmPasid_t  pasidtlp,                  // PASIDTLP
                                                 // Logical Address and Page Size
                                                 bit [63:0]  base_lpa,                  // base logical page address (LPA)
                                                 PageSize_t  la_pagesize=PAGE_SIZE_4K,  // logical  page size
                                                 // Physical Address and Page Size
                                                 bit [63:0]  base_ppa,                  // base physical page address (PPA)
                                                 PageSize_t  pa_pagesize=PAGE_SIZE_4K); // physical page size

        for (int i=0; i<num_xlt_entries; i++) begin
            m_iommu_api.write_address_translation(.bdf                        (bdf),
                                                  .pasidtlp                   (pasidtlp),
                                                  .logical_address            ((base_lpa+(i*HqmAtsPkg::vector_t'(la_pagesize)))),
                                                  .la_pagesize                (la_pagesize),
                                                  .translation_address        ((base_ppa+(i*HqmAtsPkg::vector_t'(pa_pagesize)))),
                                                  .pa_pagesize                (pa_pagesize),
                                                  .untranslated_access_only   (0),
                                                  .privileged_mode_access     (0),
                                                  .execute_permitted          (0),
                                                  .global_mapping             (0),
                                                  .non_snooped_access         (0),
                                                  .write_permission           (1),    // Physical Page Write Permission
                                                  .read_permission            (1),    // Physical Page Read  Permission
                                                  .entry_overwrite_en         (0),    // Enable Overwriting of an entry if it exists
                                                  .entry_check_en             (1));   // Check the translation entry upon insertion into the Address Map
        end

    endfunction : add_address_translation


    // -------------------------------------------------------------------------
    // Function     :   get_bdf
    // Description  :
    //
    function bit [15:0] get_bdf ();
        ovm_report_info(get_type_name(), "get_bdf(): returning IOMMU Routing ID to caller.", OVM_FULL);
        return ats_cfg.get_iommu_bdf();
    endfunction


    // -------------------------------------------------------------------------
    // Function     :   get_iommu
    // Description  :   return handle to IOMMU ATS Interface
    //
    function HqmIommu get_iommu ();
        ovm_report_info(get_type_name(), "get_iommu(): returning handle to IOMMU", OVM_HIGH);
        return this.m_iommu;
    endfunction

    function void set_iommu_api(HqmIommuAPI iommu_api);
        this.m_iommu_api = iommu_api;

        if ( ats_analysis_env != null ) begin
            ats_analysis_env.iommu_api = iommu_api;
        end
    endfunction

    // -------------------------------------------------------------------------
    // Function     :   get_iommu_api
    // Description  :   return handle to IOMMU ATS and PRS API
    //
    function HqmIommuAPI get_iommu_api ();
        ovm_report_info(get_type_name(), "get_iommu_api(): returning handle to IOMMU API", OVM_HIGH);
        return this.m_iommu_api;
    endfunction


endclass : HqmAtsEnv
