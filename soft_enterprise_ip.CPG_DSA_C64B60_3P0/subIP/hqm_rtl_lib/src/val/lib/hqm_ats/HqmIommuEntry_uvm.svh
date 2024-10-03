//------------------------------------------------------------------------------
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
// Description: IOMMU Address Translation Table Entry
//              -------------------------------------
//
// -----------------------------------------------------------------------------

//--AY_HQMV30_ATS--  

class HqmIommuEntry extends uvm_report_object;

    `uvm_object_utils_begin(HqmIommuEntry)
        `uvm_field_int    (prs_entry_state, UVM_ALL_ON)
        `uvm_field_int    (ats_entry_state, UVM_ALL_ON)
    `uvm_object_utils_end

    AtsCplSts_t          ats_entry_state = ATSCPL_SUCCESS;    // default. To change this use modify_entry_state()
    PrsRspSts_t          prs_entry_state = PRSRSP_SUCCESS;    // default. To change this use modify_entry_state()

    // Address Translation Indices
    logic [63:0]                logical_address;

    // Address Translation Entry variables
    logic [63:0]  translation_address;
    logic         translation_size;
    logic         non_snooped_access;
    logic         global_mapping;
    logic         execute_permitted;
    logic         privileged_mode_access;
    logic         untranslated_access_only;
    logic         write_permission;
    logic         read_permission;

    // -------------------------------------------------------------------------
    function new (string name = "HqmIommuEntry");
        super.new(name);
    endfunction

    // -------------------------------------------------------------------------
    // Function     :   get_packed()
    //
    function logic [63:0] get_packed ();
        logic [63:0] entry_vector;

        entry_vector = { this.translation_address[63:12],   // bit [63:12]
                         this.translation_size,             // bit 11
                         this.non_snooped_access,           // bit 10
                         4'h0,                              // bit [9: 6]
                         this.global_mapping,               // bit 5
                         this.privileged_mode_access,       // bit 4
                         this.execute_permitted,            // bit 3
                         this.untranslated_access_only,     // bit 2
                         this.write_permission,             // bit 1
                         this.read_permission               // bit 0
                       };

       return entry_vector;

    endfunction

    // -------------------------------------------------------------------------
    // Function     :   is_valid()
    // Description  :   Checks for whether X bits are present in the write translation
    //                  entry.
    //                  This returns a 1 (SUCCESS) or 0 (FAILURE)
    //
    function bit is_valid ();

        if ( $isunknown(this.get_packed()) )
            return 1'b0;
        else if ( execute_permitted && ~read_permission ) begin
            `uvm_error(get_type_name(), $sformatf("Address Translation Servicse v1.1 violation: Read Permission must be set if Execute Permitted is set"))
            uvm_report_info (get_type_name(), $sformatf("\tExecution Permitted (%b)", execute_permitted), UVM_FULL);
            uvm_report_info (get_type_name(), $sformatf("\tRead Permission     (%b)", read_permission  ), UVM_FULL);
            return 1'b0;
        end else
            return 1'b1;

    endfunction : is_valid


endclass : HqmIommuEntry
