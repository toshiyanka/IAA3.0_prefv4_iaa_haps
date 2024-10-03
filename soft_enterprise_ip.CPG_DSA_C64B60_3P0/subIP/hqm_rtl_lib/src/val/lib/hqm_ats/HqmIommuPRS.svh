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
// Created On:  2/17/2017
// Description: Page Request Interface -- Outstanding PRG Tracking and VMM invocation
//              --------------------------------------------------------
//
//              This block models IOMMU responses to incoming TLP page requests,
//              per design specfication PCI-SIG Address Translation Services v1.1.
//              Refer to the spec's Page Request Interface subsection for
//              operational design details.
//
//              The follwing description illustrates testbench implementation.
//
//              Incoming page requests are identified by Page Request Group index.
//
//              Page requests that are part of the same PRG index are added
//              to their own queue.
//
//              The last page request of a PRG triggers a VMM invocation to
//              resolve the grouped page requests.
//
//              Since it's possible for a device to transmit a page request
//              for an already resident page, this block only requests that
//              nonresident page requests, or invalid page requests, be resolved.
//
//              The class provides an interface to:
//
//                  push    a page request into a PRG table of queues.
//
//                          A given page may either be resident or nonresident
//                          in the IOMMU. At the last PRG request, the subroutine
//                          invokes the VMM to resolve the page request.
//
//                          The method then forms a PRG response code.
//
//                  get     the response code for a grouping of 1 or more page
//                          requests (PRG).
//


//--AY_HQMV30_ATS--  

class HqmIommuPRS extends HqmIommu;

    `ovm_component_utils(HqmIommuPRS)

    // -------------------------------------------------------------------------
    function new (string name = "HqmIommuPRS", ovm_component parent = null);
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
        ovm_report_info(get_type_name(),"connect(): ------- BEGIN -------", OVM_NONE);
        ovm_report_info(get_type_name(),"connect(): ------- END   -------", OVM_NONE);
    endfunction


    // Page Request Interface API ----------------------------------------------

                                              //             BDF       PRG Idx
    static protected HqmAtsPkg::page_request_q_t   m_prg_table [bit [15:0]][bit [8:0]];
    //                                        Each device can transmit a message with PRG that
    //                                        groups page requests from that device's
    //                                        multi-address spaces.

    // -------------------------------------------------------------------------
    // Function     :   request_page()
    // Description  :   This subroutine performs the following steps:
    //                      (1) form a Page Request data structure
    //                      (2) log the Page Request in a queue of PRG page requests
    //                      (3) if last PRG request, call the vmm to resolve entire PRG
    //                      (4) form PRG response code based on PRG resolution
    //                      (5) delete the PRG queue
    //
    virtual function request_page (input    bit [15:0]                      bdf,
                                            HqmAtsPkg::pasid_prefix_t     prefix,
                                            bit [63:0]                      logical_address,
                                   output   HqmAtsPkg::page_request_q_t   page_request_q);

        // Decode incoming Page Request
        bit [8:0] prg_index                 = logical_address[11:3];    // Page Request Group Index
        bit       prg_is_last_page_request  = logical_address[2];       // last Page Request
        bit       wr_access_requested       = logical_address[1];
        bit       rd_access_requested       = logical_address[0];

        // Additional helper variables that track outstanding page requests
        page_request_t          page_request;
        int                     index_q [$];

        //-------------------------------------
        // (1) Form Page Request data structure
        //-------------------------------------
        // Determine what state the page request is in (i.e. is the page's address translation in IOMMU?)
        page_request.prg_index          = prg_index;
        page_request.bdf                = bdf;
        page_request.prefix             = prefix;
        page_request.logical_address    = logical_address;                

        if (tlb_exists(bdf, prefix) && m_map[bdf][get_pasid_str(prefix)].entry_exists(logical_address)) begin
            page_request.page_is_needed =     (wr_access_requested ? ~(m_map[bdf][get_pasid_str(prefix)].read_entry(logical_address).write_permission                 ) : 'bX)
                                            ||(rd_access_requested ? ~(m_map[bdf][get_pasid_str(prefix)].read_entry(logical_address).read_permission                  ) : 'bX)
                                            ||(prefix.priv_requested   ? ~(m_map[bdf][get_pasid_str(prefix)].read_entry(logical_address).privileged_mode_access  ) : 'bX)
                                            ||(prefix.exec_requested   ? ~(m_map[bdf][get_pasid_str(prefix)].read_entry(logical_address).execute_permitted       ) : 'bX);
            page_request.resolved       = (page_request.page_is_needed) ? 1'b0 : 1'b1;
        end else begin
            page_request.page_is_needed = 1'b1;
            page_request.resolved       = 1'b0;
        end

        //---------------------------------------------------
        // (2) Log Page Request in queue of PRG page requests
        //---------------------------------------------------
        this.m_prg_table[bdf][page_request.prg_index].push_back(page_request);

        //--------------------------------------------------------
        // (3) if last page request, call VMM to resolve entire PRG
        //--------------------------------------------------------
        if (prg_is_last_page_request) begin : LAST_PAGE_REQUEST

            index_q = m_prg_table[bdf][prg_index].unique_index();

            index_q.sort();

            // construct a new temporary page request queue
            foreach (index_q[i]) page_request_q.push_back(m_prg_table[bdf][prg_index][index_q[i]]);

            return 1;

        end : LAST_PAGE_REQUEST
        
    endfunction : request_page



    // -------------------------------------------------------------------------
    // Function     :   get_prg_response_code
    // Description  :   Returns PRG Response Code
    //
    virtual function bit [3:0] get_prg_response_code (input HqmAtsPkg::page_request_q_t  page_request_q);

        if (page_request_q.and() with (item.resolved)) return 4'b0000;   // SUCCESS
        else                                           return 4'b0001;   // INVALID REQUEST

    endfunction



    // // -------------------------------------------------------------------------
    // // Function     :   print_prg_request()
    // // Description  :   print the entire translation table
    // //
    // function void print_prg_request ();
    //     ovm_report_info(get_type_name(),           "\t>--------------------------------------------------------------------------------------", OVM_FULL);
    //     ovm_report_info(get_type_name(), $sformatf("\t> Page Request Group        = %0d", prg_index), OVM_FULL);
    //     ovm_report_info(get_type_name(), $sformatf("\t> Shortest Translation Unit = %s", stu.name()), OVM_FULL);
    //     ovm_report_info(get_type_name(),           "\t>--------------------------------------------------------------------------------------", OVM_FULL);
    //     ovm_report_info(get_type_name(),           "\t> [   PASID   ] [   lookup_address   ] L | W | R", OVM_FULL);
    //     ovm_report_info(get_type_name(),           "\t>--------------------------------------------------------------------------------------", OVM_FULL);
    // endfunction


    // function void print_prg_table_header();
    // endfunction

endclass : HqmIommuPRS
