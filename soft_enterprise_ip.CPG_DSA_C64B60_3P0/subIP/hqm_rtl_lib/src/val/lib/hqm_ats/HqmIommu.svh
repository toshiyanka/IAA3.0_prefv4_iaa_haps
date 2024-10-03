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
// Description: HQM's IO Memory Management Unit API
//              -----------------------------------
//
//              This testbench component class represents the frontend access to
//              the IOMMU model. It provides helper subroutines that simplify
//              access to and manipulation of the IOMMU's address translation
//              table (i.e. also called the Address Translation Protection Table
//              in PCI-SIG specification "Address Translation Services" (ATS) v1.1.
//
//              An address translation table is indexed through a PASID when
//              creating, writing to, or reading from it.
//
//              A translation table is comprised of 0 or more translation (XLT) entries.
//              An address translation (AT) entry is an address-to-address mapping.
//              For instance the reference address could be a virtual address
//              while the return address could be a physical address.
//              An AT entry can only be added to a PASID-indexed XLT table.
//
//              A translation entry is an element of a lookup table.
//              This element is comprised of a translation address and the
//              following address location attributes, as specified in ATS v1.1:
//
//                  translation size
//                  non_snooped_access
//                  global_mapping
//                  execute_permitted
//                  privileged_mode_access
//                  untranslated_access_only
//                  write_permission
//                  read_permission
//
//              This class provides an interface to:
//
//                  translation_exists              checks the existence of a translation entry in the IOMMU
//                  read_address_translation        from the IOMMU an address translation (AT) entry in class format
//                  write_address_translation       write  to the IOMMU an AT entry
//                  delete_address_translation      delete an IOMMU AT entry from the IOMMU's translation table
//                  print_address_translation       print  an IOMMU AT entry via a user-specified PASID and logical address
//                  print_address_map               print  an IOMMU AT table via a user-specified PASID
//
// -----------------------------------------------------------------------------

//--AY_HQMV30_ATS--  

class HqmIommu extends HqmIommuBase;

    `ovm_component_utils(HqmIommu)

    bit         is_processing_xtl_request;      // Status bit signifying if the IOMMU
                                                // is actively processing a request.

    bit         has_finished_xtl_req_cpl;       // Status sticky bit signifying that an
                                                // Request/Cpl pair has been processed.



    // -------------------------------------------------------------------------
    function new (string name = "HqmIommu", ovm_component parent = null);
        super.new(name, parent);
    endfunction


    // -------------------------------------------------------------------------
    function void build ();
        super.build();

        ovm_report_info(get_type_name(),"build(): ------- BEGIN -------",   OVM_NONE);
        ovm_report_info(get_type_name(),"build(): ------- END   -------\n", OVM_NONE);
    endfunction


    // ------------------------------------------------------------------------
    function void connect ();
        super.connect();

        ovm_report_info(get_type_name(),"connect(): ------- BEGIN -------",   OVM_NONE);
        ovm_report_info(get_type_name(),"connect(): ------- END   -------\n", OVM_NONE);
    endfunction


    // -------------------------------------------------------------------------
    // Function     :   translation_exists()
    // Description  :   Checks to see if the translation entry exists.
    //                  returns 1 for TRUE
    //                  returns 0 for FALSE
    //                  The translation table is indexed through the user-specified
    //                  PASID.
    //                  The translation entry is further located thru the user-specified
    //                  logical address.
    //
    function bit translation_exists (input  bit [15:0]      bdf,
                                            HqmPasid_t      pasidtlp,
                                            bit [63:0]      logical_address);

        bit val;
        val = (tlb_exists(bdf, pasidtlp) && m_map[bdf][get_pasid_str(pasidtlp)].entry_exists(logical_address));
    
        ovm_report_info(get_type_name(), $sformatf("translation_exists() - [BDF=0x%H] [PASID=%s] logical_address=0x%0x : exists=%0d", bdf, get_pasid_str(pasidtlp), logical_address, val), OVM_MEDIUM);
        return val; //(tlb_exists(bdf, pasidtlp) && m_map[bdf][get_pasid_str(pasidtlp)].entry_exists(logical_address));

    endfunction : translation_exists


    // -------------------------------------------------------------------------
    // Function     :   write_address_translation()
    // Description  :   Adds a translation entry to the PASID-indexed translation
    //                  table.
    //
    //                  The user of this method must supply PASID, logical (i.e.
    //                  virtual) address, physical page address
    //                  (i.e. translated address), page size, and page attributes
    //                  (per PCI-SIG's Address Translation Services v1.1).
    //
    //                  A translation (XLT) table is indexed through the PASID.
    //
    //                  The logical-to-physical address mapping is then inserted
    //                  into the translation table.
    //
    //                  The physical page size is specified as a function argument.
    //
    //                  If the XLT table does not exist, it is created before
    //                  the translation entry is added.
    //
    //                  If translation table does exist then an entry is added.
    //
    //                  This function also provides the folowing described controls.
    //                  Enable the controls to enable their respective behaviors.
    //
    //                      entry_overwrite_en: 0 : do not overwrite a preexisting translation entry
    //                                          1 : overwrite a preexisting translation entry
    //
    //                      entry_check_en : 0 : do not check for unknown (X) values in the specified translation entry
    //                                       1 : check for unknown (X) values in the specified translation entry
    //
    //                  Description of function return values:
    //
    //                      -3 : the physical page size is less than the STU.
    //                      -2 : a translation entry already exists at the write logical address
    //                      -1 : the write translation entry contains one or more unknown values (X)
    //                       0 : the translation mapping entry was successfully added to the Page Translation Table
    //                      +1 : the translation mapping entry successfully overwrote a preexisting entry in the Page XLT Table
    //
    //                  +======================================================================+
    //                  |          Control bit values versus function Return values            |
    //                  |=====================================++===============================|
    //                  | entry_overwrite_en | entry_check_en || set of possible return values |
    //                  |====================|================||===============================|
    //                  |         0          |        0       ||            {-3, -2,     0}    |
    //                  |         0          |        1       ||            {-3, -2, -1, 0}    |
    //                  |         1          |        0       ||            {-3,         0, 1} |
    //                  |         1          |        1       ||            {-3,     -1, 0, 1} |
    //                  +====================+================++===============================+
    //
    function int write_address_translation (input bit [15:0]                 bdf,
                                                  HqmPasid_t                 pasidtlp,
                                                  bit [63:0]                 logical_address,
                                                  HqmAtsPkg::PageSize_t      la_pagesize=PAGE_SIZE_4K,
                                                  // Write translation entry
                                                  bit [63:0]                 translation_address,
                                                  HqmAtsPkg::PageSize_t      pa_pagesize=PAGE_SIZE_4K,
                                                  logic                      untranslated_access_only,  // ATS CPL attribute: Untranslated Access Only
                                                  logic                      privileged_mode_access,    // ATS CPL attribute: Privileged Mode
                                                  logic                      execute_permitted,         // ATS CPL attribute: Execute Permitted
                                                  logic                      global_mapping,            // ATS CPL attribute: Global Mapping
                                                  logic                      non_snooped_access,        // ATS CPL attribute: Non-snooped Access
                                                  logic                      write_permission,          // ATS CPL attribute: Write permission
                                                  logic                      read_permission,           // ATS CPL attribute: Read permission
                                                  bit                        entry_overwrite_en=0,      // enable translation entry override - if set to 1, any attempt to change this entry will flag a TB error
                                                  bit                        entry_check_en=1);         // enable translation entry check - when set to 1, any invalid entry will trigger an error

        HqmIommuEntry translation_entry, translation_entry_pre;
        string        pasid_str;
        
        pasidtlp.priv_mode_requested = privileged_mode_access;
        
        pasid_str = get_pasid_str(pasidtlp);
        
        // translation_entry = HqmIommuEntry::type_id::create($sformatf("HqmIommuEntry_PA_0x%H", translation_address));
        // HqmIommuEntry translation_entry = new($sformatf("xlt_entry_PASID_%0d_LADDR=0x%H", pasid, logical_address));

        ovm_report_info(get_type_name(), $sformatf("write_address_translation() - S1: writing Address Translation entry to XLT Table [BDF=0x%H] [PASID=%s] [PRIV=%b], LA = 0x%H, PA = 0x%H\tLA Page Size = %s B.", bdf, pasid_str, privileged_mode_access, logical_address, translation_address, la_pagesize.name()), OVM_LOW);
        ovm_report_info(get_type_name(), $sformatf("AES(): prefix.priv_requested=%b, prefix.exec_requested=%b, prefix.valid=%b prefix.pasid=%h", pasidtlp.priv_mode_requested, pasidtlp.exe_requested, pasidtlp.pasid_en, pasidtlp.pasid), OVM_LOW);

        if (!tlb_exists(bdf, pasidtlp)) begin

            ovm_report_info(get_type_name(), $sformatf("write_address_translation() - S2: tlb_create [BDF=0x%H] [PASID=%s] pasid_en=%0d pasid=0x%0x", bdf, pasid_str, pasidtlp.pasid_en, pasidtlp.pasid), OVM_LOW);
            tlb_create(bdf, pasidtlp, pa_pagesize);

        end else if ( tlb_exists(bdf, pasidtlp) && ( (la_pagesize > m_map[bdf][pasid_str].get_pagesize()) || (pa_pagesize != m_map[bdf][pasid_str].get_pagesize()) ) ) begin
            `ovm_error      (get_type_name(), $sformatf("write_address_translation(): Write was Aborted!"))
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \tThe user-specified write translation entry is in conflict with the existing target Address Mapping Table's attributes"), OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \tOne or more of the following conditions was violated"                                                    )             , OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \t\t(1) write_address_translation_entry's Logical  Page Size <= existing XLT Table Physical Page Size"     )             , OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \t\t(2) write_address_translation_entry's Physical Page Size == existing XLT Table Physical Page Size"     )             , OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \twrite translation entry's Logical  Page Size (%s B)"      , la_pagesize.name())                                         , OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \twrite translation entry's Physical Page Size (%s B)"      , pa_pagesize.name())                                         , OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \tXLT Table [BDF=0x%H] [PASID=%s] Physical Page Size (%s)", bdf, pasid_str, m_map[bdf][pasid_str].get_pagesize()), OVM_MEDIUM );

            return -3;

        end else if ( tlb_exists(bdf, pasidtlp) && (!entry_overwrite_en && m_map[bdf][pasid_str].entry_exists(logical_address)) ) begin
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): Write was Aborted!"), OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \tThe write entry overwrite of an existing entry was aborted in the XLT Table"),                    OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \tXLT Table entry already exists at the specified write entry location")       ,                    OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \tXLT Table [BDF=0x%H] [PASID=%s] [LA = 0x%H]", bdf, pasid_str, logical_address), OVM_MEDIUM);
            m_map[bdf][pasid_str].print_map_entry(logical_address);

            return -2;
        end

        // assign the function arguments to the translation_entry object
        // translation_entry = HqmIommuTLB::create_entry(// prefix,
        if ( m_map[bdf][pasid_str].entry_exists(logical_address) ) begin
            translation_entry_pre       = m_map[bdf][pasid_str].read_entry(logical_address);
            untranslated_access_only    = translation_entry_pre.untranslated_access_only;
        end


        ovm_report_info(get_type_name(), $sformatf("write_address_translation() - S3: create_entry m_map[BDF=0x%H] [PASID=%s] translation_address=0x%0x", bdf, pasid_str, translation_address), OVM_LOW);
        translation_entry = m_map[bdf][pasid_str].create_entry(// prefix,
                                                                       // logical_address,
                                                                       translation_address,
                                                                       pa_pagesize,
                                                                       non_snooped_access,
                                                                       global_mapping,
                                                                       execute_permitted,
                                                                       privileged_mode_access,
                                                                       untranslated_access_only,
                                                                       write_permission,
                                                                       read_permission);


        if (entry_check_en && !translation_entry.is_valid()) begin
            `ovm_error      (get_type_name(), $sformatf("write_address_translation(): Write was Aborted!"))
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \tThe specified write translation entry contains one or more unknown (X) values!")                , OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \t---------------------------------------- BEGIN Trace ----------------------------------------" ), OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \t\ttranslation_entry.translation_address     = 0x%H", translation_entry.translation_address     ), OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \t\ttranslation_entry.translation_size        = 0x%H", translation_entry.translation_size        ), OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \t\ttranslation_entry.non_snooped_access      = %b",   translation_entry.non_snooped_access      ), OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \t\ttranslation_entry.global_mapping          = %b",   translation_entry.global_mapping          ), OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \t\ttranslation_entry.execute_permitted       = %b",   translation_entry.execute_permitted       ), OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \t\ttranslation_entry.privileged_mode_access  = %b",   translation_entry.privileged_mode_access  ), OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \t\ttranslation_entry.untranslated_access_only= %b",   translation_entry.untranslated_access_only), OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \t\ttranslation_entry.write_permission        = %b",   translation_entry.write_permission        ), OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \t\ttranslation_entry.read_permission         = %b",   translation_entry.read_permission         ), OVM_MEDIUM);
            ovm_report_info (get_type_name(), $sformatf("write_address_translation(): \t---------------------------------------- END   Trace ----------------------------------------" ), OVM_MEDIUM);

            return -1;
        end

        if (!entry_overwrite_en && m_map[bdf][pasid_str].entry_exists(logical_address) ) begin

            write_address_translation = -2;  // entry overwritten but return error status
            `ovm_error(get_type_name(), $sformatf("write_address_translation(): \tIOMMU's Entry Overwrite feature has been disabled but write entry collides with a pre-existing entry!"));

        end else if ( entry_overwrite_en && m_map[bdf][pasid_str].entry_exists(logical_address) ) begin
            write_address_translation = 1 ;  // entry overwritten
        end else begin
            write_address_translation = 0;   // entry written
        end

        ovm_report_info(get_type_name(), $sformatf("write_address_translation() - S4: write_entry m_map[BDF=0x%H] [PASID=%s].m_mem[logical_address=0x%0x] with translation_entry having translation_address=0x%0x", bdf, pasid_str, logical_address, translation_address), OVM_LOW);
        void' (m_map[bdf][pasid_str].write_entry(logical_address, translation_entry)) ;
        ovm_report_info(get_type_name(), $sformatf("write_address_translation() - S5: write_entry done m_map[BDF=0x%H] [PASID=%s].m_mem[logical_address=0x%0x] with translation_entry having translation_address=0x%0x", bdf, pasid_str, logical_address, translation_address), OVM_LOW);

    endfunction : write_address_translation



    // -------------------------------------------------------------------------
    // Function     :   read_address_translation()
    // Description  :   Returns the translation entry for a given PASID-index translation table.
    //                  The function call must specify PASID and logical address for dereferencing.
    //                  The translation entry is returned in class type HqmIommuEntry.
    //                  If the translation entry does not exist, a null is returned.
    //
    function HqmIommuEntry read_address_translation (input  bit [15:0]       bdf,
                                                            HqmPasid_t       pasidtlp,
                                                            bit [63:0]       logical_address
                                                            );
        string pasid_str = get_pasid_str(pasidtlp);
        
        if (tlb_exists(bdf, pasidtlp)) begin
            ovm_report_info (get_type_name(), $sformatf("read_address_translation(): XLT Table [BDF=0x%H] [PASID=%s] exists! Attempting to read entry at Logical Address = 0x%H", bdf, pasid_str, logical_address), OVM_LOW);
            return m_map[bdf][pasid_str].read_entry(.logical_address(logical_address), .pasidtlp(pasidtlp));

        end else if (is_device_supported(bdf)) begin
            HqmIommuEntry translation_entry;

            ovm_report_info (get_type_name(), $sformatf("read_address_translation(): XLT Table is supported for [BDF=0x%H], but does not exist for [PASID=%s]. Function is returning a Void Translation Entry (i.e. RW=b00)", bdf, pasid_str), OVM_LOW);
            translation_entry = HqmIommuEntry::type_id::create("IOMMU_ZERO_TRANSLATION_ENTRY");
            translation_entry.privileged_mode_access = pasidtlp.priv_mode_requested;
            translation_entry.read_permission        = 1'b0;
            translation_entry.write_permission       = 1'b0;
            return translation_entry;
        end else begin
            `ovm_error(get_type_name(), $sformatf("read_address_translation(): XLT Table [BDF=0x%H] does not exist", bdf))
            return null;
        end

    endfunction : read_address_translation


    // -------------------------------------------------------------------------
    // Function     :   modify_entry_state()
    // Description  :   changes ats_entry_state and prs_entry_state from its default
    //
    function bit modify_entry_state (input bit [15:0]       bdf,
                                           HqmPasid_t       pasidtlp,
                                           bit [63:0]       logical_address,
                                           AtsCplSts_t      ats_entry_state,
                                           PrsRspSts_t      prs_entry_state);

        string pasid_str = get_pasid_str(pasidtlp);
        
        ovm_report_info (get_type_name(), $sformatf("modify_entry_state(): XLT Table [BDF=0x%H] [PASID=%s] [LA=0x%H] attempting to set to ATS state %s PRS state %s", bdf, pasid_str, logical_address, ats_entry_state.name(), prs_entry_state.name()), OVM_LOW);

        if (  translation_exists(bdf, pasidtlp, logical_address)  ) begin

                HqmIommuEntry translation = read_address_translation(bdf, pasidtlp, logical_address);
                translation.ats_entry_state = ats_entry_state;
                translation.prs_entry_state = prs_entry_state;

                ovm_report_info (get_type_name(), $sformatf("modify_entry_state(): XLT Table [BDF=0x%H] [PASID=%s] Entry at LA = 0x%H exists", bdf, pasid_str, logical_address), OVM_LOW);

                void' (m_map[bdf][pasid_str].write_entry(logical_address, translation)) ;

        end else if ( tlb_exists(bdf, pasidtlp) ) begin

            `ovm_error(get_type_name(), $sformatf("modify_entry_state(): XLT Table [BDF=0x%H] [PASID=%s] Entry at LA = 0x%h does not exist.", bdf, pasid_str, logical_address))

        end else if (is_device_supported(bdf)) begin

            `ovm_error(get_type_name(), $sformatf("modify_entry_state(): XLT Table [BDF=0x%H] Table with PASID = 0x%h does not exist.", bdf, pasid_str))

        end else begin

            `ovm_error(get_type_name(), $sformatf("modify_entry_state(): XLT Table [BDF=0x%H] does not exist", bdf))

        end

    endfunction : modify_entry_state
    
    // -------------------------------------------------------------------------
    // Function     :   modify_write_permission_state()
    // Description  :   change write permissions 
    //
    function bit modify_write_permission_state (input bit [15:0] bdf,
                                                HqmPasid_t       pasidtlp,
                                                bit [63:0]       logical_address,
                                                bit              wr_permission);
        string pasid_str = get_pasid_str(pasidtlp);
        
        ovm_report_info (get_type_name(), $sformatf("modify_write_permission_state(): XLT Table [BDF=0x%H] [PASID=%s] [LA=0x%H] attempting to set write_permissions to %0b", bdf, pasid_str, logical_address, wr_permission), OVM_LOW);

        if (  translation_exists(bdf, pasidtlp, logical_address)  ) begin

                HqmIommuEntry translation = read_address_translation(bdf, pasidtlp, logical_address);
                translation.write_permission |= wr_permission;

                ovm_report_info (get_type_name(), $sformatf("modify_write_permission_state(): XLT Table [BDF=0x%H] [PASID=%s] Entry at LA = 0x%H exists", bdf, pasid_str, logical_address), OVM_LOW);

                void' (m_map[bdf][pasid_str].write_entry(logical_address, translation)) ;

        end else if ( tlb_exists(bdf, pasidtlp) ) begin

            `ovm_error(get_type_name(), $sformatf("modify_write_permission_state(): XLT Table [BDF=0x%H] [PASID=%s] Entry at LA = 0x%h does not exist.", bdf, pasid_str, logical_address));

        end else if (is_device_supported(bdf)) begin

            `ovm_error(get_type_name(), $sformatf("modify_write_permission_state(): XLT Table [BDF=0x%H] Table with PASID = 0x%h does not exist.", bdf, pasid_str));

        end else begin

            `ovm_error(get_type_name(), $sformatf("modify_write_permission_state(): XLT Table [BDF=0x%H] does not exist", bdf));

        end

    endfunction


    // -------------------------------------------------------------------------
    // Function     :   read_entry_state()
    // Description  :   returns ats and prs entry states
    //                  This helps decide on what status to designate to a ATSCPL
    //                  or PRSRSP
    //
    function bit read_entry_state (bit [15:0]             bdf,
                                   HqmPasid_t             pasidtlp,
                                   bit [63:0]             logical_address,
                                   ref  AtsCplSts_t       ats_entry_state,
                                   ref  PrsRspSts_t       prs_entry_state);

        string pasid_str = get_pasid_str(pasidtlp);
        
        ovm_report_info (get_type_name(), $sformatf("read_entry_state(): XLT Table [BDF=0x%H] [PASID=%s] [LA=0x%H] attempting to read ATS / PRS states",
                                                    bdf, get_pasid_str(pasidtlp), logical_address), OVM_LOW);

        if (  translation_exists(bdf, pasidtlp, logical_address)  ) begin
            HqmIommuEntry   translation = read_address_translation(bdf, pasidtlp, logical_address);

            ats_entry_state = translation.ats_entry_state;
            prs_entry_state = translation.prs_entry_state;

            ovm_report_info (get_type_name(), $sformatf("read_entry_state(): XLT Table [BDF=0x%H] [PASID=%s] [LA=0x%H] ATS state %s and PRS state %s",
                                                    bdf, pasid_str, logical_address, ats_entry_state.name(), prs_entry_state.name()), OVM_LOW);

        end else if ( tlb_exists(bdf, pasidtlp) ) begin

            `ovm_info (get_type_name(), $sformatf("read_entry_state(): XLT Table [BDF=0x%H] [PASID=%s] Entry at LA = 0x%h does not exist.", bdf, pasid_str, logical_address), OVM_LOW)

        end else if (is_device_supported(bdf)) begin

            `ovm_error(get_type_name(), $sformatf("read_entry_state(): XLT Table [BDF=0x%H] Table with PASID = %s does not exist.", bdf, pasid_str))

        end else begin

            `ovm_error(get_type_name(), $sformatf("read_entry_state(): XLT Table [BDF=0x%H] does not exist", bdf))

        end

    endfunction : read_entry_state




    // -------------------------------------------------------------------------
    // Function     :   delete_address_translation()
    // Description  :   Permanently removes a translation entry from the BDF-only or
    //                  BDF-and-PASID-indexed Address Translation Map.
    //                  translation table.
    //
    //                  The function call must specify BDF, PASID, and Logical Address.
    //                      BDF:                BDF ID of target Address Map
    //                      prefix:             pasid_valid (1b), pasid (20b)
    //                      logical address:    Logical Address of target entry to remove
    //
    //                  Report is logged on attempt to delete entry, whether or not it exists.
    //
    //                  0 : SUCCESS means entry removal from the table was succsesful.
    //                  1 : FAILURE means entry removal failed due to a non-existent PASID XLT table.
    //
    function bit delete_address_translation (input  bit [15:0]  bdf,
                                             HqmPasid_t         pasidtlp,
                                             bit [63:0]         logical_address);
        string pasid_str = get_pasid_str(pasidtlp);

        ovm_report_info (get_type_name(), $sformatf("delete_address_translation(): XLT Table [BDF=0x%H] [PASID=%s] [LA = 0x%H]", bdf, pasid_str, logical_address), OVM_LOW);

        if ( tlb_exists(bdf, pasidtlp) && m_map[bdf][pasid_str].entry_exists(logical_address) ) begin : SUCCESS
            ovm_report_info (get_type_name(), $sformatf("read_address_translation(): XLT Table [BDF=0x%H] [PASID=%s] exists! Deleting entry at [LA = 0x%H]", bdf, pasid_str, logical_address), OVM_LOW);
            m_map[bdf][pasid_str].delete_entry(logical_address);
            return 0;
        end else begin : FAILURE
            return 1;
        end

    endfunction
    
    function void delete_all_address_translation_with_pasid (input  bit [15:0]  bdf,
                                             HqmPasid_t         pasidtlp);
        string pasid_str = get_pasid_str(pasidtlp);
        HqmIommuTLB  pasid_tlb;
    
        ovm_report_info (get_type_name(), $sformatf("delete_all_address_translation_with_pasid(): XLT Table [BDF=0x%H] [PASID=%s] ", bdf, pasid_str), OVM_LOW);
    
        if ( tlb_exists(bdf, pasidtlp)) begin : SUCCESS
            ovm_report_info (get_type_name(), $sformatf("delete_all_address_translation_with_pasid(): XLT Table [BDF=0x%H] [PASID=%s] ", bdf, pasid_str), OVM_LOW);
            pasid_tlb = m_map[bdf][pasid_str];
            pasid_tlb.delete_all_entry();
        end
    
    endfunction
    
    function void delete_all_address_translation_with_any_pasid (input  bit [15:0]  bdf );
        HqmIommuTLB  pasid_tlb;
    
        ovm_report_info (get_type_name(), $sformatf("delete_all_address_translation_with_any_pasid(): XLT Table [BDF=0x%H] ", bdf), OVM_LOW);
    
        foreach(m_map[bdf][pasid]) begin
           if (pasid != "N/A" ) begin : SUCCESS
               ovm_report_info (get_type_name(), $sformatf("delete_all_address_translation_with_any_pasid(): XLT Table [BDF=0x%H] [PASID=%s] ", bdf, pasid), OVM_LOW);
               pasid_tlb = m_map[bdf][pasid];
               pasid_tlb.delete_all_entry();
           end
        end
    
    endfunction
    
    function void delete_all_address_translation(input  bit [15:0]  bdf);
        HqmIommuTLB  pasid_tlb;
        ovm_report_info (get_type_name(), $sformatf("delete_all_address_translation(): XLT Table [BDF=0x%H]", bdf), OVM_LOW);
        foreach(m_map[bdf][pasid]) begin
            pasid_tlb = m_map[bdf][pasid];
            pasid_tlb.delete_all_entry();
        end
    
    endfunction

    // -------------------------------------------------------------------------
    // Function     :   print_address_translation()
    // Description  :   Prints to the log file, in tabular form, the translation entry
    //                  referenced by the subroutine args of PASID and logical address.
    //                  If the PASID-indexed translation table was not found, an ovm_warning logged.
    //                  If the PASID-indexed translation table was found, but the entry wasn't,
    //                  a warning is logged.
    //
    function void print_address_translation (input  bit [15:0]        bdf,
                                                    HqmPasid_t        pasidtlp,
                                                    bit [63:0]        logical_address);
        string pasid_str = get_pasid_str(pasidtlp);
        
        if (tlb_exists(bdf, pasidtlp)) begin
            m_map[bdf][pasid_str].print_map_entry(logical_address);
        end else begin
            `ovm_error(get_type_name(), $sformatf("print_address_translation(): XLT Table [BDF=0x%H] [PASID=%s] does not exist.", bdf, pasid_str));
        end

    endfunction


    // -------------------------------------------------------------------------
    // Function     :   print_address_map()
    // Description  :   Prints to log file, in tabular form, all translation entries in the
    //                      PASID-indexed translation table.
    //                  No arguments are needed and nothing is returned by the function.
    //                  If a translation table does not exist for a given PASID, an ovm_warning
    //                      is logged.
    //                  If a translation table does exist for the given PASID, but the table
    //                      is empty, only table header is logged.
    //
    function void print_address_map (input  bit [15:0]      bdf,
                                            HqmPasid_t      pasidtlp);
        string pasid_str = get_pasid_str(pasidtlp);
        
        if (tlb_exists(bdf, pasidtlp)) begin
            m_map[bdf][pasid_str].print_map();
        end else begin
            `ovm_error(get_type_name(), $sformatf("print_address_map(): XLT Table [BDF=0x%H] [PASID=%s] does not exist.", bdf, pasid_str));
        end

    endfunction



    // -------------------------------------------------------------------------
    // Function     :   request_address_translation()
    // Description  :
    //
    virtual function bit [63:0] request_address_translation (input  bit [15:0]      bdf,
                                                                    HqmPasid_t      pasidtlp,
                                                                    bit [63:0]      logical_address);
        `ovm_fatal(get_type_name(), "request_address_translation(): Only the overridden method should be invoked!")
    endfunction


    // -------------------------------------------------------------------------
    // Function     :   request_address_translation_4k()
    // Description  :
    //
    virtual function bit [63:0] request_address_translation_4k (input  bit [15:0]      bdf,
                                                                       HqmPasid_t      pasidtlp,
                                                                       bit [63:0]      la_4k);
        `ovm_fatal(get_type_name(), "request_address_translation_4k(): Only the overridden method should be invoked!")
    endfunction

    // -------------------------------------------------------------------------
    // Function     :   request_page()
    // Description  :
    //
    virtual function request_page (input    bit [15:0]                  bdf,
                                            HqmPasid_t                  pasidtlp,
                                            bit [63:0]                  logical_address,
                                   output   HqmAtsPkg::page_request_q_t page_request_q);
        `ovm_fatal(get_type_name(), "request_page(): Only the overridden method should be invoked!")
    endfunction


    // -------------------------------------------------------------------------
    // Function     :   get_prg_response_code
    // Description  :
    //
    virtual function bit [3:0] get_prg_response_code (input HqmAtsPkg::page_request_q_t  page_request_q);
        `ovm_fatal(get_type_name(), "get_prg_response_code(): Only the overridden method should be invoked!")
    endfunction


    // -------------------------------------------------------------------------
    // Function     :   is_proper_privilege()
    // Description  :   determine if priv and pasid match those values associated
    //                  with the logical address mapping
    //
    function bit is_proper_privilege (input bit [15:0] bdf,
                                      HqmPasid_t pasidtlp,
                                      bit priv_to_check,
                                      bit [63:0] logical_address);
        HqmIommuEntry translation;
        string        pasid_str = get_pasid_str(pasidtlp);

        ovm_report_info (get_type_name(), $sformatf("is_proper_privilege(): XLT Table [BDF=0x%H] [PASID=%s] [LA=0x%H] attempting to compare PRIV and PASID",
                                                    bdf, pasid_str, logical_address), OVM_LOW);

        if (translation_exists(bdf, pasidtlp, logical_address)) begin
            translation = read_address_translation(bdf, pasidtlp, logical_address);
        end else if (tlb_exists(bdf, pasidtlp)) begin
            `ovm_error(get_type_name(), $sformatf("is_proper_privilege(): XLT Table [BDF=0x%H] [PASID=%s] Entry at LA = 0x%h does not exist.",
                                                  bdf, pasid_str, logical_address))
        end else if (is_device_supported(bdf)) begin
            `ovm_error(get_type_name(), $sformatf("is_proper_privilege(): XLT Table [BDF=0x%H] Table with PASID = 0x%h does not exist.", bdf, pasid_str))
        end else begin
            `ovm_error(get_type_name(), $sformatf("is_proper_privilege(): XLT Table [BDF=0x%H] does not exist", bdf))
        end

        // PASID check is redundant but is included for completeness
        return (priv_to_check == translation.privileged_mode_access);
    endfunction : is_proper_privilege

endclass : HqmIommu

