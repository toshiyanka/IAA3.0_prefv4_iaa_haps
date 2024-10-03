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
// Description: IOMMU TLB BDF
//              ---------------------------------
//
//              This class maintains the creation and addition of address
//              translation entries into a given translation table.
//
//              This class provides the ability to:
//
//                  read    a translation entry for a given logical address
//                  write   a translation for a given logical address
//                  delete  a translation entry for a given logical address
//                  check   for the existence of a translation entry
//                  print   a translation entry
//                  print   a translation table
//
// -----------------------------------------------------------------------------

//--AY_HQMV30_ATS--  

class HqmIommuTLB extends uvm_report_object;

    `uvm_object_utils(HqmIommuTLB)

    string        iommu_bdf;

    protected uvm_verbosity  _iommuDbg = UVM_DEBUG; // Default verbosity for various printouts
    
    // Logical-to-Physical Address Mapping Table
    local HqmIommuEntry   m_mem [bit [63:0]];

    local struct {
    // Translation Table's Attributes
        string                      bdf;
        string                      pasid;
        HqmAtsPkg::PageSize_t     la_pagesize;     // Address Translation Table's Shortest Translation Unit (i.e. Page Size)
        HqmAtsPkg::PageSize_t     pa_pagesize;     // Address Translation Table's Shortest Translation Unit (i.e. Page Size)
        bit [63:0]                  mask_pa;
        bit [63:0]                  mask_upper;   // Address Translation Table's Page Size 64b alignment Mask
        bit [63:0]                  ats_cpl_mask;   // Address Translation Table's Page Size 64b alignment Mask
    } m_mem_attribute;


    // -------------------------------------------------------------------------
    function new (string name = "HqmIommuTLB");
        string iommuDbgStr = "";
        
        super.new(name);

        
        if ( $value$plusargs("IOMMU_TLB_DBG=%s", iommuDbgStr)) begin
            case ( iommuDbgStr )
                "UVM_NONE"   : _iommuDbg = UVM_NONE;
                "UVM_LOW"    : _iommuDbg = UVM_LOW;
                "UVM_MEDIUM" : _iommuDbg = UVM_MEDIUM;
                "UVM_HIGH"   : _iommuDbg = UVM_HIGH;
                "UVM_FULL"   : _iommuDbg = UVM_FULL;
                default      : `uvm_fatal(get_name(), $sformatf("Invalid verbosity specified: IOMMU_TLB_DBG='%s'", iommuDbgStr))
            endcase 
            `uvm_info(get_name(), $sformatf("Command line override iommuDbgStr=%s  IOMMU_TLB_DBG=%s", iommuDbgStr, _iommuDbg.name()), UVM_LOW);
        end 
    endfunction

    // -------------------------------------------------------------------------
    // Function     :   initialize()
    // Description  :   Subroutine for setting critical Address Map metadata such as
    //                      - BDF#   of the Process Address Space
    //                      - PASID# of the Process Address Space
    //                      - Physical Page Size
    //
    function void initialize  (string       iommu_bdf,
                               string       device_bdf,
                               string       pasid,
                               PageSize_t   pa_pagesize=HqmAtsPkg::PAGE_SIZE_4K
                               );

        this.iommu_bdf = iommu_bdf;

        // Check PA's enumerated-type-defined value
        if ( ($countones(HqmAtsPkg::vector_t'(pa_pagesize))!=1) || (HqmAtsPkg::vector_t'(pa_pagesize)<INCR_SIZE_4K) )
            `uvm_fatal(get_type_name(), "Page Size should be 2^x multiple of 4096.")

        m_mem_attribute.bdf            = device_bdf;
        m_mem_attribute.pasid          = pasid;
        m_mem_attribute.pa_pagesize    = pa_pagesize;
        m_mem_attribute.mask_pa        = -vector_t'(pa_pagesize);
        m_mem_attribute.mask_upper     = MASK_4K;

        begin
            bit [63:0] mask_lower = ~m_mem_attribute.mask_pa;
            int num_ones          = $countones(mask_lower);
            mask_lower[num_ones-1] = 0;

            m_mem_attribute.ats_cpl_mask = MASK_4K & mask_lower;

            m_mem_attribute.mask_upper[num_ones-1] = 0;
        end 

        uvm_report_info(get_type_name(), $sformatf("initialize(): m_mem_attribute.ats_cpl_mask = 0x%H", m_mem_attribute.ats_cpl_mask), UVM_MEDIUM);

    endfunction : initialize



    // -------------------------------------------------------------------------
    // Function     :   entry_exists()
    // Description  :   This method checks to see if the supplied translation
    //                  referenced by the specified logical address
    //                  exists.
    //                  Returns 1 if Logical-to-Physical mapping exists.
    //                  Returns 0 if Logical-to-Physical mapping is nonexistent.
    //
    function bit entry_exists (input bit [63:0] logical_address);

        return m_mem.exists(apply_mask(logical_address));

    endfunction : entry_exists


    // -------------------------------------------------------------------------
    // Function     :   create_entry()
    // Description  :   Returns a new translation table entry of type HqmIommuEntry.
    //
    function HqmIommuEntry create_entry (input // logic [PASID_BITSIZE-1:0] pasid,
                                               // logic [63:0] logical_address,
                                               // Address Translation Entry variables
                                               logic [63:0]              translation_address      ,
                                               HqmAtsPkg::PageSize_t     pagesize                =HqmAtsPkg::PAGE_SIZE_4K,
                                               logic                     non_snooped_access      =0,
                                               logic                     global_mapping          =0,
                                               logic                     execute_permitted       =0,
                                               logic                     privileged_mode_access  =0,
                                               logic                     untranslated_access_only=0,
                                               logic                     write_permission        =0,
                                               logic                     read_permission         =0);

        static HqmIommuEntry    translation_entry;

        translation_entry = HqmIommuEntry::type_id::create($sformatf("HqmIommuEntry_PA_0x%H", translation_address));
        translation_entry.set_report_handler(m_rh);

        // translation_entry.logical_address            = logical_address;
        translation_entry.translation_address        = (translation_address & m_mem_attribute.mask_upper) | m_mem_attribute.ats_cpl_mask;

        translation_entry.translation_size           = (pagesize==HqmAtsPkg::PAGE_SIZE_4K) ? 0 : 1;
        //
        translation_entry.non_snooped_access         = non_snooped_access;
        translation_entry.global_mapping             = global_mapping;
        translation_entry.privileged_mode_access     = privileged_mode_access;
        translation_entry.execute_permitted          = execute_permitted;
        translation_entry.untranslated_access_only   = untranslated_access_only;
        translation_entry.write_permission           = write_permission;
        translation_entry.read_permission            = read_permission;

        uvm_report_info(get_type_name(), $sformatf("create_entry(): entry.translation_address=0x%0x translation_size=%0d", translation_entry.translation_address, translation_entry.translation_size), UVM_MEDIUM);
        return translation_entry;

    endfunction : create_entry


    // -------------------------------------------------------------------------
    // Function     :   write_entry()/nfs/site/disks/sdg74_2152/users/anyan/05312022_hqmv3_ats/hqm-srvr10nm-wave4-v3/target/log/hqm.bman.hqm.vcs.vlogan_hqm_typ_integ_lib.log
    // Description  :   Add a translation entry by specifying logical address,
    //                      translation entry, and whether to enable xlt entry
    //                      checking.
    //                  This returns a 1 (SUCCESS) or 0 (FALURE).
    //                  A failure means the entry failed to pass a check routine.
    //                  A failure will trigger an error output log message.
    //
    function bit write_entry (input bit [63:0]      logical_address,
                                    HqmIommuEntry   entry);

        check_address("write_entry", logical_address);

        // uvm_report_info(get_type_name(), "write_entry(): translation entry in Address Map Table BEFORE write operation > ", UVM_MEDIUM);
        // print_map_entry(logical_address);

        this.m_mem[apply_mask(logical_address)] = entry;

        uvm_report_info(get_type_name(), $sformatf("write_entry(): translation entry in Address Map Table AFTER write operation for '0x%016h' (Masked=0x%016h) > entry.translation_address=0x%0x", logical_address, apply_mask(logical_address), entry.translation_address), UVM_MEDIUM);
        print_map_entry(logical_address);

        return 1;

    endfunction : write_entry


    // -------------------------------------------------------------------------
    // Function     :   read_entry()
    // Description  :
    //
    function HqmIommuEntry read_entry (input bit [63:0] logical_address, HqmPasid_t pasidtlp=0);
        HqmIommuEntry   void_entry;

        check_address("read_entry", logical_address);

        if (m_mem.exists(apply_mask(logical_address))) begin
            read_entry = m_mem[apply_mask(logical_address)];

            uvm_report_info (get_type_name(), $sformatf("read_entry(): Requested translation entry was found for '0x%016h'", logical_address), UVM_MEDIUM);
            print_map_entry (logical_address);

        end else begin
            void_entry = create_entry(// .pasid(),
                                      // .logical_address(),
                                      .translation_address(64'hDEAD_BEEF_DEAD_BEEF),
                                      .pagesize           (),
                                      .non_snooped_access (),
                                      .global_mapping     (),
                                      .execute_permitted  (),
                                      .privileged_mode_access  (pasidtlp.priv_mode_requested),
                                      .untranslated_access_only(),
                                      .write_permission(0),
                                      .read_permission (0));

            uvm_report_info(get_type_name(), $sformatf("read_entry(): Requested translation entry was not found for '0x%016h' (Masked=0x%016h).", logical_address, apply_mask(logical_address)), UVM_MEDIUM);
            uvm_report_info(get_type_name(), "read_entry(): A void read translation entry was returned (R/W=b00).", UVM_MEDIUM);

            print_map_header(.la_en(0));
            print_entry     (logical_address, void_entry);
            print_map_footer();

        end 

    endfunction : read_entry



    // -------------------------------------------------------------------------
    // Function     :   delete_entry()
    // Description  :   delete the translation entry specified by the logical address.
    //
    function void delete_entry (input bit [63:0] logical_address);

        check_address("delete_entry", logical_address);

        uvm_report_info(get_type_name(), $sformatf("delete_entry(): Attempting to delete a translation entry at the following Address Map Table location for '0x%016h'", logical_address), UVM_MEDIUM);
        print_map_entry(logical_address);

        m_mem.delete(apply_mask(logical_address));

    endfunction : delete_entry

   function void delete_all_entry ();

        uvm_report_info(get_type_name(), $sformatf("delete_entry(): Attempting to delete all translation entry"), UVM_LOW);
        m_mem.delete();

   endfunction : delete_all_entry


    // -------------------------------------------------------------------------
    // Function     :   print_map_entry()
    // Description  :   print to log the translation entry in tabular form.
    //
    function void print_map_entry (input bit [63:0] logical_address);

        check_address("print_map_entry", logical_address);

        print_map_header(.la_en(1), .logical_address(logical_address));

        if (m_mem.exists(apply_mask(logical_address)))  print_entry(apply_mask(logical_address), m_mem[apply_mask(logical_address)]);

        print_map_footer();

    endfunction : print_map_entry


    // -------------------------------------------------------------------------
    // Function     :   print_map()
    // Description  :   print the entire translation table
    //
    function void print_map ();

        print_map_header(.la_en(0));

        foreach (m_mem[lookup_address])     print_entry(lookup_address, m_mem[lookup_address]);

        print_map_footer();

    endfunction : print_map



    // -------------------------------------------------------------------------
    // Function     :   print_map_header()
    // Description  :
    //
    function void print_map_header (bit la_en=0, bit [63:0] logical_address='0);

string top_str      = $sformatf(             "+---------------------------------------------------------------------------------------+");
string iommu_bdf_str= $sformatf(             "| IOMMU BDF              = %s"  , this.iommu_bdf                    );
string bdf_str      = $sformatf(             "| I/O Device BDF         = %s"  , m_mem_attribute.bdf               );
string pasid_str    = $sformatf(             "| PASID                  = %s"  , m_mem_attribute.pasid             );
string pagesize_str = $sformatf(             "| Physical Page Size     = %sB" , m_mem_attribute.pa_pagesize.name());
string blank_str    = $sformatf(             "|"                                                                  );
string log_addr_str = $sformatf(             "| Logical Address        = 0x%H", logical_address                   );

uvm_report_info(get_type_name(),         ""                                                                                             , _iommuDbg);
uvm_report_info(get_type_name(),         "\t\t+---------------------------------------------------------------------------------------+", _iommuDbg);
if (la_en)
uvm_report_info(get_type_name(),         "\t\t| >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> IOMMU ADDRESS MAP ENTRY <<<<<<<<<<<<<<<<<<<<<<<<<<<<< |", _iommuDbg);
else
uvm_report_info(get_type_name(),         "\t\t|                                 IOMMU ADDRESS MAP TABLE                               |", _iommuDbg);
uvm_report_info(get_type_name(),       { "\t\t", top_str                                                          },                      _iommuDbg);
uvm_report_info(get_type_name(),       { "\t\t", iommu_bdf_str,{replication_count(top_str, iommu_bdf_str){" "}}, "|"},                    _iommuDbg);
uvm_report_info(get_type_name(),       { "\t\t", bdf_str,      {replication_count(top_str, bdf_str      ){" "}}, "|"},                    _iommuDbg);
uvm_report_info(get_type_name(),       { "\t\t", pasid_str,    {replication_count(top_str, pasid_str    ){" "}}, "|"},                    _iommuDbg);
uvm_report_info(get_type_name(),       { "\t\t", pagesize_str, {replication_count(top_str, pagesize_str ){" "}}, "|"},                    _iommuDbg);

if (la_en) begin
uvm_report_info(get_type_name(),       { "\t\t", blank_str,   {replication_count(top_str, blank_str   ){" "}}, "|"},                      _iommuDbg);
uvm_report_info(get_type_name(),       { "\t\t", log_addr_str,{replication_count(top_str, log_addr_str){" "}}, "|"},                      _iommuDbg);
end 

uvm_report_info(get_type_name(),         "\t\t+---------------------------------------------+---+---+--------+------+-----+---+---+---+", _iommuDbg);
uvm_report_info(get_type_name(),         "\t\t| [   Lookup Address   ]  Translation Address | S | N | Global | Priv | Exe | U | W | R |", _iommuDbg);
uvm_report_info(get_type_name(),         "\t\t+---------------------------------------------|---|---|--------|------|-----|---|---|---+", _iommuDbg);

    endfunction : print_map_header


    function int replication_count  (string a, string b);

        return a.len() - b.len()- 1;

    endfunction : replication_count


    // -------------------------------------------------------------------------
    // Function     :   print_entry
    // Description  :   return the translation entry in tabular string format
    //
    function void print_entry (input bit [63:0] lookup_address, HqmIommuEntry translation_entry);

        string map_entry_str = $sformatf("\t\t| [ 0x%H ] = 0x%H | %0d | %0d | %6d | %4d | %3d | %0d | %0d | %0d |",
                                              lookup_address,
                                              translation_entry.translation_address,
                                              translation_entry.translation_size,
                                              translation_entry.non_snooped_access,
                                              translation_entry.global_mapping,
                                              translation_entry.privileged_mode_access,
                                              translation_entry.execute_permitted,
                                              translation_entry.untranslated_access_only,
                                              translation_entry.write_permission,
                                              translation_entry.read_permission);

        uvm_report_info(get_type_name(), map_entry_str, UVM_NONE);

    endfunction : print_entry



    // -------------------------------------------------------------------------
    // Function     :   print_map_footer()
    // Description  :   print the translation table acronmy description
    //
    local function void print_map_footer ();

// uvm_verbosity verbosity = uvm_pkg::uvm_verbosity'(this.get_report_verbosity_level());

// if (verbosity==UVM_MEDIUM)
uvm_report_info(get_type_name(),           "\t\t+---------------------------------------------------------------------------------------+", _iommuDbg);
uvm_report_info(get_type_name(),           ""                                                                                             , _iommuDbg);
// else if (verbosity==UVM_DEBUG) begin
// uvm_report_info(get_type_name(),           "\t+---------------------------------------------------------------------------------------+", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t| Acronym : Description                                                                 |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t+---------------------------------------------------------------------------------------+", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t| S       : Translation Size        - 0: Translation Applies to 4kB memory range        |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t|                                   - 1: Translation Applies to 4kB memory range        |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t|                                                                                       |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t| N       : Non-snooped Access      - 0: MEM TLP's Non-Snoop is dependent on CSR'       |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t|                                   - 1: MEM TLP's Non-Snoop must be unset              |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t|                                                                                       |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t| Global  : Global Mapping          - 0: PASID-only ATC caching is permitted            |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t|                                   - 1: All-PASID ATC caching is permitted             |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t|                                                                                       |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t| Exe     : Execute Permitted       - 1: address is executable if set                   |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t|                                                                                       |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t| Priv    : Privileged Mode Access  - 1: address is for privileged mode access if set   |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t|                                                                                       |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t| U       : Untranslated Access Only- 0: MEM only accessible thru untranslated requests |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t|                                                                                       |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t| W       : Write Only              - 1: address is Writeable and Zero-length Readable  |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t| R       : Read Only               - 1: address is Readable                            |", UVM_DEBUG);
// uvm_report_info(get_type_name(),           "\t+---------------------------------------------------------------------------------------+", UVM_DEBUG);
// end 

    endfunction



    // -------------------------------------------------------------------------
    // Function     :   get_pagesize()
    // Description  :   returns the pagesize in 64b vector format.
    //
    function HqmAtsPkg::PageSize_t get_pagesize ();
        return m_mem_attribute.pa_pagesize;
    endfunction



    // -------------------------------------------------------------------------
    // Function     :   check_address
    // Description  :
    //
    function bit [63:0] check_address (input string method_name, bit [63:0] logical_address);
        if ($countones(logical_address & ~MASK_4K))
            uvm_report_warning(get_type_name(), $sformatf("%s(): Lower 12 bits of Logical Address contains one or more 1s. Logical Address = 0x%H.", method_name, logical_address));
    endfunction


    // -------------------------------------------------------------------------
    // Function     :   get_effective_address()
    // Description  :   Get effective address from the specified logical address
    //
    function bit [63:0] apply_mask (bit [63:0] logical_address);
        return m_mem_attribute.mask_pa & logical_address;
    endfunction


//     // -------------------------------------------------------------------------
//     // Function     :   has_access_permissions()
//     // Description  :
//     //
//     function bit has_access_permissions (bit [63:0] logical_address);
//         // |============|===================
//         // | RA  | SA   |   has permission?
//         // | W R | W R  |
//         // |============|===================
//         // | 0 1 | 0 1  |   1
//         // | 0 1 | 1 0  |   0
//         // | 0 1 | 1 1  |   1
//         // |-----|------|------
//         // | 1 0 | 0 1  |   0
//         // | 1 0 | 1 0  |   1
//         // | 1 0 | 1 1  |   1
//         // |-----|------|------
//         // | 1 1 | 0 1  |   0
//         // | 1 1 | 1 0  |   0
//         // | 1 1 | 1 1  |   1
//         // |================================
//         // | RA: Request Permission
//         // | SA: Stored  Permission
//
//         // bit [63:0] lookup_address = get_effective_address(logical_address);
//
//         // bit [63:0] physical_address = entry_exists(logical_address) ? m_mem[lookup_address].get_packed() : '0;
//
//         case ({logical_address[1:0]}) inside
//             2'b01   :   begin
//                             case({physical_address[1:0]})
//                                 2'bX1   :   return 1;
//                                 default :   return 0;
//                             endcase
//                         end 
//
//             2'b10   :   begin
//                             case({physical_address[1:0]})
//                                 2'b1X   :   return 1;
//                                 default :   return 0;
//                             endcase
//                         end 
//
//             2'b11   :   begin
//                             case({physical_address[1:0]})
//                                 2'b11   :   return 1;
//                                 default :   return 0;
//                             endcase
//                         end 
//
//             default :   return 0;
//
//         endcase
//     endfunction

endclass : HqmIommuTLB
