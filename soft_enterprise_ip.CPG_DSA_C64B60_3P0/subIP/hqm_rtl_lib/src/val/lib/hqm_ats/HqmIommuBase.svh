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
// Created On:  1/25/2017
// Description: PASID Translation Table API
//              ---------------------------
//
//              This base class contains functions that allow for the creation
//              and maintenance of the PASID-indexed table. Each table entry
//              indexed by PASID points to a page address translation table.
//
//              This class provides the ability to:
//
//                  tlb_create      create a new PASID index
//                  tlb_delete      delete a specific PASID indexed TLB
//                  tlb_delete_all  deletes all TLBs associated with the device BDF
//                  tlb_purge       deletes all TLBs
//                  tlb_print_all   Print each stored TLB's address mapping
//                  get_bdf         get this IOMMU's BDF number
//                  get_pagesize    returns TLB's (indexed by BDF+PASID) physical page size in 64b bit type format
//
// -----------------------------------------------------------------------------

//--AY_HQMV30_ATS--  


class HqmIommuBase extends ovm_agent;

    `ovm_component_utils(HqmIommuBase)

    local OVM_FILE       log_file;
    protected bit        disableSetupReporting;

    // Address Translation Page Table (ATPT)
    protected HqmIommuTLB    m_map [bit [15:0]][string];
    //                             [ BDF #    ][PASID#]


    // TB Config Object
    HqmAtsCfgObj  ats_cfg;

    // -------------------------------------------------------------------------
    function new (string name = "HqmIommuBase", ovm_component parent = null);
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
        return log_file;    
    endfunction
    
    // ------------------------------------------------------------------------
    virtual function void setupReporting();
        if ( log_file != 0 ) begin
            set_report_default_file_hier(log_file);
        end 
        
        if ( ! ats_cfg.get_disable_tb_report_severity_settings ) begin
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

        // Get IOMMU CFG
        rc = get_config_object("AtsCfgObj", obj, 0);
        `sla_assert(rc, ("init(): Can't get config object"))

        rc = ($cast(ats_cfg, obj) > 0);
        `sla_assert(rc, ("init(): Config object is wrong type"))

        // Set Output File
        log_file = $fopen(ats_cfg.IOMMU_FILENAME, "a");
        set_report_default_file_hier(log_file);

    endfunction


    // -------------------------------------------------------------------------
    function void build ();

        init();

        super.build();

        ovm_report_info(get_type_name(),"build(): ------- BEGIN -------",   OVM_NONE);
        ovm_report_info(get_type_name(),"build(): ------- END   -------\n", OVM_NONE);
    endfunction


    // -------------------------------------------------------------------------
    function void connect ();
        ovm_report_info(get_type_name(),"connect(): ------- BEGIN -------",  OVM_NONE);
        
        super.connect();
        
        if ( ! getDisableSetupReporting() ) begin
            setupReporting();
        end 

        ovm_report_info(get_type_name(),"connect(): ------- END   -------\n",OVM_NONE);

    endfunction


    // Helper Functions --------------------------------------------------------

    // -------------------------------------------------------------------------
    // Function     :   get_pasid_str()
    // Description  :
    //
    function string get_pasid_str (HqmPasid_t pasidtlp);

        if (! pasidtlp.pasid_en ) begin
            return "N/A";
        end else begin
            return $sformatf("0x%H", {pasidtlp.priv_mode_requested,pasidtlp.pasid});
        end

    endfunction


    // -------------------------------------------------------------------------
    // Function     :   is_function_supported()
    // Description  :   returns 1 if IOMMU supports the specified device function
    //
    function bit is_device_supported (input  bit [15:0] bdf);

        return m_map.exists(bdf);

    endfunction



    // -------------------------------------------------------------------------
    // Function     :   tlb_exists()
    // Description  :   verify whether the translation table indexed by BDF & PASID exists.
    //                  returns 1 (TRUE), or 0 (FALSE)
    //
    function bit tlb_exists (input  bit [15:0]       bdf,
                                    HqmPasid_t       pasidtlp);
        bit val;
        val = m_map.exists(bdf) && m_map[bdf].exists(get_pasid_str(pasidtlp));
       
        ovm_report_info (get_type_name(), $sformatf("tlb_exists(): [BDF=0x%H] [PASID=%s] : exists=%0d", bdf, get_pasid_str(pasidtlp), val), OVM_MEDIUM);
        return val; //m_map.exists(bdf) && m_map[bdf].exists(get_pasid_str(pasidtlp));

    endfunction



    // -------------------------------------------------------------------------
    // Function     :   tlb_create()
    // Description  :   Create a Logical-to-Physical Page Address Mapping Table
    //                  A mapping table translates virtual addresses from the
    //                  virtual address domain to the system physical address
    //                  domain.
    //
    //                  The method requires arguments bdf and the pasid prefix
    //                  in order to uniquely identify the logical address
    //                  space being mapped.
    //
    //                  pa_pagesize defines the increment size for addresses
    //                  specified in the system physical address domain.
    //
    function void tlb_create (input bit [15:0]                  bdf,
                                    HqmPasid_t                  pasidtlp,
                                    HqmAtsPkg::PageSize_t       pa_pagesize);

        string pasid_str = get_pasid_str(pasidtlp);
        
        ovm_report_info (get_type_name(), $sformatf("tlb_create(): Creating Address Mapping Table [BDF=0x%H] [PASID=%s] with Physical Page Size = %sB", bdf, pasid_str, pa_pagesize.name()), OVM_MEDIUM);

        if (tlb_exists(bdf, pasidtlp)) begin
            `ovm_error(get_type_name(), "tlb_create(): Overwriting existing Address Mapping Table >")
            m_map[bdf][pasid_str].print_map_header();
        end

        // Create and Initialize new TLB
        m_map[bdf][pasid_str] = HqmIommuTLB::type_id::create($sformatf("HqmIommuTLB_BDF_0x%H_PASID_%s", bdf, pasid_str), this);
        m_map[bdf][pasid_str].set_report_handler(m_rh);

        m_map[bdf][pasid_str].initialize(.iommu_bdf($sformatf("0x%H", ats_cfg.get_iommu_bdf)), .device_bdf($sformatf("0x%H", bdf)), .pasid( pasid_str ), .pa_pagesize( pa_pagesize) );

        // Report Success
        ovm_report_info(get_type_name(), $sformatf("tlb_create(): Successfully created Address Mapping Table >"), OVM_MEDIUM);
        m_map[bdf][pasid_str].print_map_header();

    endfunction




    // -------------------------------------------------------------------------
    // Function     :   tlb_delete()
    // Description  :   remove a translation table specified by the PASID.
    //
    function void tlb_delete (input   bit [15:0]     bdf,
                                      HqmPasid_t     pasidtlp);
        string pasid_str = get_pasid_str(pasidtlp);
        
        if (tlb_exists(bdf, pasidtlp)) begin

            m_map[bdf].delete(pasid_str);
            ovm_report_info(get_type_name(), $sformatf("tlb_delete(): Successfully deleted Address Mapping Table [BDF=0x%H] [PASID=%s]", bdf, pasid_str), OVM_MEDIUM);

        end else begin
            `ovm_error(get_type_name(), $sformatf("tlb_delete(): Did not find Address Mapping Table [BDF=0x%H] [PASID=%s]", bdf, pasid_str))
        end

    endfunction


    // -------------------------------------------------------------------------
    // Function     :   tlb_delete_all()
    // Description  :   remove all translation tables.
    //
    function void tlb_delete_all (input   bit [15:0] bdf);

        if (m_map.exists(bdf)) begin

            ovm_report_info(get_type_name(), $sformatf("tlb_delete_all(): Deleted all Address Mapping Tables for [BDF=0x%H]", bdf), OVM_MEDIUM);
            m_map[bdf].delete();

        end else begin
            `ovm_error(get_type_name(), $sformatf("tlb_delete_all(): Did not find Address Mapping Table [BDF=0x%H]", bdf))
        end

    endfunction


    // -------------------------------------------------------------------------
    // Function     :   tlb_purge ()
    // Description  :   remove all translation tables.
    //
    function void tlb_purge ();

        m_map.delete();

        ovm_report_info(get_type_name(), $sformatf("tlb_purge(): Deleted all Address Mapping Table(s)"), OVM_MEDIUM);

    endfunction


    // -------------------------------------------------------------------------
    // Function     :   tlb_print_all()
    // Description  :   print all translation entries for each XLT table.
    //
    function void tlb_print_all ();

            foreach (m_map[bdf,pasid]) begin
                m_map[bdf][pasid].print_map();
            end

    endfunction

    // -------------------------------------------------------------------------
    // Function     :   get_bdf
    // Description  :
    //
    function bit [15:0] get_bdf ();
        ovm_report_info(get_type_name(), "get_bdf(): returning IOMMU Routing ID to caller.", OVM_MEDIUM);
        return ats_cfg.get_iommu_bdf();
    endfunction


    // -------------------------------------------------------------------------
    // Function     :   get_pagesize()
    // Description  :
    //
    function bit [63:0] get_pagesize (input  bit [15:0]      bdf,
                                             HqmPasid_t      pasidtlp);

        string pasid_str = get_pasid_str(pasidtlp);
        
        if ( tlb_exists (bdf, pasidtlp ) ) begin

            return HqmAtsPkg::vector_t'( m_map[bdf][pasid_str].get_pagesize() );

        end else begin
            `ovm_info (get_type_name(), "get_pagesize(): Address Mapping Table does not exist >", OVM_LOW)
            // m_map[bdf][get_pasid_str(prefix)].print_map_header();
            `ovm_info (get_type_name(), $sformatf("get_pagesize(): \tXLT Table [BDF=0x%H] [PASID=%s]", bdf, pasid_str), OVM_LOW)
            `ovm_fatal(get_type_name(), "get_pagesize(): \tterminating test")
        end

    endfunction

endclass : HqmIommuBase
