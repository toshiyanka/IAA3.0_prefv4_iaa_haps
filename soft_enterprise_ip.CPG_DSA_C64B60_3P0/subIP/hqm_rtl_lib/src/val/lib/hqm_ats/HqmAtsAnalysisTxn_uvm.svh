// -----------------------------------------------------------------------------
// Copyright(C) 2016 - 2021 Intel Corporation, Confidential Information
// -----------------------------------------------------------------------------
// Created by:  Adil Shaaeldin
// Created On:  1/12/2017
// Description: ATS Txn formed from decoding IOSF Txn on the monitor
// -----------------------------------------------------------------------------

//--AY_HQMV30_ATS--  

class HqmAtsAnalysisTxn extends HqmBusTxn;

    `uvm_object_utils(HqmAtsAnalysisTxn)

    HqmAtsCfgObj        ats_cfg;

    int                 id;     // ATS TXN Identifier
    int                 num_tracker_row_entries = 0;
    realtime            simulation_time;

    // ATS Command
    HqmAtsCmdType_t     ats_cmd;

    // -------------------------------------------------------------------------
    struct {
        // Completer ID
        bit [15:0]              completer_id;
        HqmPcieCplStatus_t      completion_status;
        bit [11:0]              byte_count;
        bit [ 6:0]              lower_address;
    } AtsTcpl_s; // Translation Completion TLP fields

    // Page Request Message fields
    struct {
        bit [63:0]              page_address;
        bit [63:0]              page_address_masked;
        bit [ 8:0]              prg_index;
        bit                     last_page_req;
        bit                     write_access_requested;
        bit                     read_access_requested;
    } PrsPreq_s;

    struct {
        bit [15:0]              destination_device_id;
        HqmPciePrgRspCode_t     response_code;
        bit [ 8:0]              prg_index;
    } PrsPrgRsp_s;

    // Invalidation Request TLP fields
    struct {
        bit [ 4:0]              itag;
        bit [15:0]              destination_device_id;
    } AtsIReq_s;

    // Invalidation Response TLP fields
    struct {
        bit [15:0]              destination_device_id;
        bit [ 3:0]              completion_count;
        bit [31:0]              itagv;
    } AtsIRsp_s;


    // -------------------------------------------------------------------------
    function new (string name="HqmAtsAnalysisTxn");
        super.new(name);
    endfunction

        // -------------------------------------------------------------------------
        // Function     :   get_data_beat
        // Description  :   returns the appropriate 64b data slice in tdata (ATS Completion data)
        //
        //                  More details
        //
        //                  tdata is the data field/payload for an ATS completion.
        //                  Note PCIE completion TLP could be returned in one or more
        //                  beats and IOSF Completion aggregates all beats into
        //                  tdata[beat#].
        //
        //                  With ATS Completions, we expect only 1 beat with 64 bits
        //                  of ATS Translated Address.
        //
        //                  This function is over-designed to cycle through a generic tdata[]
        //                  data structure and return each 64-bit slice of ATS completion data.
        //
        //
        //                  Example:
        //
        //                  Data bus width  = 256 bits
        //                  NUM_QW_PER_BEAT = 256 / (64 bits per WQ) = 4 QW
        //
        //                  if tdata[0] = { 0xCAFE_CAFE_BAD1_BAD1,
        //                                  0xFEED_BEEF_FEBE_FEBE,
        //                                  0xADEF_AD11_FFBB_AFAF
        //                                  0x1FCA_BAD1_BABA_AAAA }
        //
        //                  get_data_beat( .data_bitwidth(256), .row(0) )   returns     0x1FCA_BAD1_BABA_AAAA
        //                  get_data_beat( .data_bitwidth(256), .row(1) )   returns     0xADEF_AD11_FFBB_AFAF
        //                  get_data_beat( .data_bitwidth(256), .row(2) )   returns     0xFEED_BEEF_FEBE_FEBE,
        //                  get_data_beat( .data_bitwidth(256), .row(3) )   returns     0xCAFE_CAFE_BAD1_BAD1,
        //
        //                  ** Note: The above example of tdata is in fact a slight
        //                          deviation from reality. In fact, ATS Completion
        //                          Addresses are QW. But in PCIE the most significant
        //                          DW comes first. So we need to swap the DWs
        //                          of the 64-bit slice to get the correctly
        //                          formatted address.
        //                  
        //
        function bit [63:0] get_data_beat (int data_bitwidth, int row);

            int NUM_QW_PER_BEAT = (data_bitwidth>>6);

            int base  = (row%NUM_QW_PER_BEAT)*64;

            int index = row/NUM_QW_PER_BEAT;

            bit [63:0] physical_address = data[index][base+:64];

            physical_address = ats_cfg.reverse_qw( physical_address );

            return physical_address;

        endfunction : get_data_beat


        // -------------------------------------------------------------------------
        // Function     :   get_tcpl_sts_abbrev
        // Description  :   Decodes IOSF txn and populates ATS txn accordingly
        //
        function string get_tcpl_sts_abbrev ();
            case (AtsTcpl_s.completion_status)
                HQM_SC  :   return "SC";
                HQM_UR  :   return "UR";
                HQM_CA  :   return "CA";
                default :   return "??";
            endcase
        endfunction : get_tcpl_sts_abbrev


        // -------------------------------------------------------------------------
        // Function     :   get_prsp_rc_abbrev
        // Description  :   Decodes IOSF txn and populates ATS txn accordingly
        //
        function string get_prsp_rc_abbrev ();
            case (PrsPrgRsp_s.response_code)
                HQM_PRG_RC_SUCCESS             :   return "SC";
                HQM_PRG_RC_INVALID_REQUEST     :   return "IR";
                HQM_PRG_RC_RESPONSE_FAILURE    :   return "RF";
                default                        :   return "??";
            endcase
        endfunction : get_prsp_rc_abbrev

    endclass : HqmAtsAnalysisTxn
