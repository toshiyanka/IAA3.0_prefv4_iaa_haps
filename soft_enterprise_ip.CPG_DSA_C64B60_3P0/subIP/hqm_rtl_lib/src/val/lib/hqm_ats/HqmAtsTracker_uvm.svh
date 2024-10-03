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
// Created By:  Adil Shaaeldin
// Created On:  1/12/2017
// Description: HQM ATS Tracker
//              -----------------------------------
//
//              The ATS Tracker logs detected Address Translation, Page
//              Request Service, and Page Invalidation transactions.
//
// -----------------------------------------------------------------------------

//--AY_HQMV30_ATS--  

class HqmAtsTracker extends uvm_component;

    `uvm_component_utils(HqmAtsTracker)

    // ATS Tracker Filename
    local UVM_FILE _trk_file;

    // TLM FIFO
    uvm_tlm_analysis_fifo #(HqmAtsAnalysisTxn) fifo;

    HqmAtsCfgObj  ats_cfg;

    // Queue for storing incoming TLPs
    HqmAtsAnalysisTxn      txn_q [$];

    local string        tmpstr[$];

    // -------------------------------------------------------------------------
    function new (string name = "HqmAtsTracker", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    // -------------------------------------------------------------------------
function void init (); 
        bit rc;
        uvm_object obj;

        // Get IOMMU CFG
        rc = uvm_config_object::get(this, "","AtsCfgObj", obj);
        `slu_assert(rc, ("init(): Can't get config object"))

        rc = ($cast(ats_cfg, obj) > 0);
        `slu_assert(rc, ("init(): Config object is wrong type"))

        // Set Output File
        _trk_file = $fopen(ats_cfg.TRACKER_FILENAME, "a");
        // set_report_default_file(_trk_file);
        // set_report_severity_action(UVM_INFO,    UVM_LOG);
        // set_report_severity_action(UVM_WARNING, UVM_LOG);
        // set_report_severity_action(UVM_ERROR,   UVM_DISPLAY | UVM_LOG);
        // set_report_severity_action(UVM_FATAL,   UVM_DISPLAY | UVM_LOG | UVM_EXIT);
    endfunction


    // --------------------------------------------------------
    function void build_phase (uvm_phase phase);

        super.build_phase(phase);

        init();

        // IOSF TLM FIFO
        fifo = new("TRACKER_FIFO", this);

    endfunction

    // ------------------------------------------
    function void end_of_elaboration_phase (uvm_phase phase);
        init();

        uvm_report_info(get_type_name(),"end_of_elaboration(): ------- BEGIN -------", UVM_LOW);

        uvm_report_info(get_type_name(),"end_of_elaboration(): ------- END   -------\n", UVM_LOW);
    endfunction



    // ----------------------------------------------------------
    task run_phase  (uvm_phase phase);
        HqmAtsAnalysisTxn ats_txn;
        
        print_ats_table_header();
        fork
            while(1) begin
                // Get seq_item from FIFO
                fifo.get(ats_txn);         // get the txn from the FIFO

                if (ats_txn == null) begin
                    `uvm_fatal(get_full_name(), "run():ATS Txn was Null!")
                    continue;
                end 
                
                if ( ats_txn.ats_cmd inside { [ATS_TREQ:ATS_IRSP] } ) begin
                    for (int row=0; row<=ats_txn.num_tracker_row_entries; row++) begin
                        $fdisplay(_trk_file, sprint_txn_info(ats_txn, row));
                    end 
                end 
                                         
            end 
        join_none

    endtask



    // UVM Phase: report -------------------------------------------------------
    function void report_phase (uvm_phase phase);
        print_ats_table_footer();
        $fclose(_trk_file);
    endfunction : report_phase


    // -------------------------------------------------------------------------
    // Function     :   print_ats_table_header
    // Description  :
    //
    function void print_ats_table_header ();

//                            0        1      2     3       4         5       6   7         8       ---- 9 ----       10        ------- 11 -------
$fdisplay(_trk_file, "+==================================================================================================================================+"); 
$fdisplay(_trk_file, "|                Address Translation Tracker ( see table description below for help in decoding each each TLP row)                 |");
$fdisplay(_trk_file, "+==================================================================================================================================+"); 
$fdisplay(_trk_file, "|               |U| ATS_TREQ | | MRd32/64  | REQID TG   |TC| DLEN |            | PASID|V|P|X|       ADDRESS    |                   |");
$fdisplay(_trk_file, "|               |-|----------| |----------------------  ---------------------------------------------------------------------------|");
$fdisplay(_trk_file, "|               |D| ATS_TCPL | | CplX  sts | REQID TG   |TC| DLEN |            |      | | | | CPLID BC LA      |                   |");
$fdisplay(_trk_file, "|               | |          |C|   XLTADDR |            |  |      |            |      | | | |       ADDRESS    | size|N|G|P|U|R|W|X|");
$fdisplay(_trk_file, "|               |-|----------| |----------------------  ---------------------------------------------------------------------------|");
$fdisplay(_trk_file, "|               |U| ATS_PREQ |H| Msg0      | REQID TG   |TC| DLEN | PRGI |L|W|R| PASID|V|P|X|  PageAddr[63:0]  |                   |");
$fdisplay(_trk_file, "|     TIME      |-|----------| |----------------------  ---------------------------------------------------------------------------|");
$fdisplay(_trk_file, "|               |D| ATS_PRSP | | Msg2      | REQID TG   |TC| DLEN | PRGI       |      | | | | DSTID            |                   |");
$fdisplay(_trk_file, "|               |-|----------| |----------------------  ---------------------------------------------------------------------------|");
$fdisplay(_trk_file, "|               |D| ATS_IREQ | | MsgD2     | REQID ITG  |TC| DLEN |            |      | | | | DSTID            |                   |");
$fdisplay(_trk_file, "|               |-|          | |   ADDRESS |            |  |      |            |      | | | |       ADDRESS    | size|N|G|P|U|R|W|X|");
$fdisplay(_trk_file, "|               |-|----------| |----------------------  -------------------------------------------------------|-----|-|-|-|-|-|-|-|");
$fdisplay(_trk_file, "|               |U| ATS_IRSP | | Msg2  RC  | REQID      |TC| DLEN |            |      | | | | DSTID cc  ITAGV  |     | | | | | | | |");
$fdisplay(_trk_file, "+===============+=+==========+=+===========+===base=16===+base10+==============+======+=+=+=+==================|=====|=|=|=|=|=|=|=|");
//                    | ------------- |U|  [ 0]MEM_MOVE |0| WRK_DISP  | 9876  03 |00|    2 |  --- |-|-|-| 00001|1|0|0| 0000CD53 3FEA1F80 |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |    8697.30 ns |D| CC R SO ICVBF |2|  B[ 3: 0] | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 0076321B 91B9F003 | 4k |0|0|0|0|1|1|0|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |    8697.30 ns |D| ST Tag CPL DST|2|  B[ 7: 4] | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 0076321B 91B9F003 | 4k |0|0|0|0|1|1|0|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |    8697.30 ns |D| TC Sel A123 C |2|  B[11: 8] | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 0076321B 91B9F003 | 4k |0|0|0|0|1|1|0|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |    8697.30 ns |D| DRB           |2|  B[15:12] | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 0076321B 91B9F003 | 4k |0|0|0|0|1|1|0|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |    8697.30 ns |D|               |2|  B[19:16] | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 0076321B 91B9F003 | 4k |0|0|0|0|1|1|0|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |    8697.30 ns |D|               |2|  B[23:20] | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 0076321B 91B9F003 | 4k |0|0|0|0|1|1|0|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |    8697.30 ns |D|               |2|  B[27:24] | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 0076321B 91B9F003 | 4k |0|0|0|0|1|1|0|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |    8697.30 ns |D|               |2|  B[31:28] | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 0076321B 91B9F003 | 4k |0|0|0|0|1|1|0|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |               | |               | |           |          |  |      |      | | | |      | | | |                   |    | | | | | | | |--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |U|  [ 0]ATS_TREQ |0| MRd64   - | 9876  03 |00|    2 |  --- |-|-|-| 00001|1|0|0| 00000000 0000A000 |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |D|  [ 0]ATS_TCPL |0| CplD   SC | 9876  03 |00|    2 |  --- |-|-|-| -----|-|-|-| CCAA 008  00      |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |    8697.30 ns |D|               |2|  B[ 3: 0] | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 0076321B 91B9F003 | 4k |0|0|0|0|1|1|0|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |U|  [ 0]ATS_TREQ |0| MRd64   - | 9876  03 |00|    8 |  --- |-|-|-| 00002|1|0|0| 00000000 0000A000 |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |U|  [ 0]ATS_TREQ |0| CplD    0 | 9876  03 |00|    8 |  --- |-|-|-| -----|-|-|-| CCAA 020  00      |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |U|  [ 0]ATS_TREQ |0|   XLTADDR | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 00000000 0000B000 | 4k |0|0|0|0|0|0|0|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |D|  [ 0]ATS_TREQ |0|   XLTADDR | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 00000000 0000C000 | 4k |0|0|0|0|1|0|1|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |D|  [ 0]ATS_TREQ |0|   XLTADDR | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 00000000 0000D000 | 4k |0|0|0|0|1|0|1|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |D|  [ 0]ATS_TREQ |0|   XLTADDR | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 00000000 0000E000 | 4k |0|0|0|0|1|0|1|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |               | |               | |           |          |  |      |      | | | |      | | | |                   |    | | | | | | | |--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |U|      ATS_TREQ |0| MRd64   - | 9876  DD |00|    2 |  --- |-|-|-| 00002|1|0|0| 00000000 0000B000 |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |D|      ATS_TREQ |0| Cpl    UR | 9876  DD |00|    0 |  --- |-|-|-| -----|-|-|-| CCAA 000 0 00     |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |    8697.30 ns |D|      ATS_TREQ |2|   XLTADDR | -------- |--| ---- |  --- |-|-|-| -----|-|-|-| 0076321B 91B9F003 | 4k |0|0|0|0|1|1|0|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |               | |               | |           |          |  |      |      | | | |      | | | |                   |    | | | | | | | |--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |U|      ATS_TREQ |0| MRd64   - | 9876  D4 |00|    2 |  --- |-|-|-| 00002|1|0|0| 000000000000 C000 |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |D|      ATS_TREQ |0| Cpl    CA | 9876  D4 |00|    0 |  --- |-|-|-| -----|-|-|-| CCAA 0000 00      |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |               | |               | |           |          |  |      |      | | | |      | | | |                   |    | | | | | | | |--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |U|      ATS_PREQ |0| Msg4    - | 9876  05 |00|    0 |  006 |1|0|0| 00001|1|0|0| 00000000 0000A000 |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |D|      ATS_PRSP |0| Msg5   SC | CCAA  02 |00|    0 |  006 |0|-|-| 00001|1|-|-| 9876              |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |               | |               | |           |          |  |      |      | | | |      | | | |                   |    | | | | | | | |--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |U|      ATS_PREQ |0| Msg4    - | 9876  05 |00|    0 |  00A |0|0|0| 0000A|1|0|0| 00000000 0000C000 |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |U|      ATS_PREQ |0| Msg4    - | 9876  05 |00|    0 |  00A |1|0|0| 0000A|1|0|0| 00000000 0000D000 |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |D|      ATS_PRSP |0| Msg5   IR | CCAA  AF |00|    0 |  00A |1|-|-| 0000A|-|-|-| 9876              |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    |               | |               | |           |          |  |      |      | | | |      | | | |                   |    | | | | | | | |--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |D|      ATS_IREQ |0| Msg1    - | CCAA  01 |00|    4 |  --- |-|-|-| 00002|1|0|0| 9876              |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |D|      ATS_IREQ |0|   ADDRESS | -------- |--| -----|  --- |-|-|-| -----|-|-|-| 00000000 0000B000 | 4k |-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |D|      ATS_IREQ |0|   ADDRESS | -------- |--| -----|  --- |-|-|-| -----|-|-|-| 00000000 0000C000 | 4k |-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |D|      ATS_IREQ |1| Msg1    - | CCAA  03 |00|    2 |  --- |-|-|-| 00001|1|0|0| 9876              |----|-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |D|      ATS_IREQ |1|   ADDRESS | -------- |--| -----|  --- |-|-|-| -----|-|-|-| 00000000 0000D000 | 4k |-|-|-|-|-|-|-|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
//                    | ------------- |U|      ATS_IRSP |0| Msg2    - | 9876     |00|    0 |  --- |-|-|-| -----|-|-|-| CCAA            2 |----|-|-|-|-|-|-|-| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 1| 0| 0| 0| 0|
//                    | ------------- |U|      ATS_IRSP |1| Msg2    - | 9876     |00|    0 |  --- |-|-|-| -----|-|-|-| CCAA            2 |----|-|-|-|-|-|-|-| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 1| 0| 0| 0| 0|
    endfunction : print_ats_table_header

    // -------------------------------------------------------------------------
    // Function     :   print_atstxn_table_header
    // Description  :
    //
    function string sprint_txn_info (HqmAtsAnalysisTxn txn, int sub_row);

        // // List of active columns for the ATS Txn

        return {
                  sprint_col_0 (txn         ),
                  sprint_col_1 (txn, sub_row),
                  sprint_col_2 (txn, sub_row),
                  sprint_col_3 (txn         ),
                  sprint_col_4 (txn, sub_row),
                  sprint_col_5 (txn, sub_row),
                  sprint_col_6 (txn, sub_row),
                  sprint_col_7 (txn, sub_row),
                  sprint_col_8 (txn         ),
                  sprint_col_9 (txn, sub_row),
                  sprint_col_10(txn, sub_row),
                  sprint_col_11(txn, sub_row)
                  // sprint_col_12(txn, sub_row)
               };

    endfunction : sprint_txn_info




    // -------------------------------------------------------------------------
    // Function     :   print_ats_table_footer
    // Description  :
    //
    function void print_ats_table_footer();
$fdisplay(_trk_file, "|==============================================================================================================|=====|=|=|=|=|=|=|=|");
$fdisplay(_trk_file, "|                                                                                                              |     | | | | | | |X|ecute Permitted",     );
$fdisplay(_trk_file, "|PASID |V|P|X| - PASID, Valid PASID, Privilege Mode Requested (1b), Execute Requested (1b)                     |     | | | | | |W|rite Access Permission",);
$fdisplay(_trk_file, "|sts     = Completion Status code (3b): SC is SUCCESS, UR is Unsupported Request, CA is Completer Abort        |     | | | | |R|ead Access Permission",   );
$fdisplay(_trk_file, "|RC      = Message Response code  (9b): SC is SUCCESS, IR is Invalid Request    , RF is Response Failure       |     | | | |U|ntranslated Access Only",   );
$fdisplay(_trk_file, "|TG      = Tag  (4b)                                                                                           |     | | |P|rivileged Mode Access",       );
$fdisplay(_trk_file, "|ITG     = ITag (5b, Invalidation Request TLP Tag)                                                             |     | |G|lobal Mapping",                 );
$fdisplay(_trk_file, "|ITAGV   = ITag Vector (32b, Invalidation Response bit-mapped vector)                                          |     |N|on-snooped",                      );
$fdisplay(_trk_file, "|PRGI    = Page Request Group Index (9b)                                                                       |",                                        );
$fdisplay(_trk_file, "|LWR     = Last Page Request (1b), Write Access Permission (1b), Read Access Permission (1b)                   |",                                        );
$fdisplay(_trk_file, "|DSTID   = Destination Device ID (32b)                                                                         |",                                        );
$fdisplay(_trk_file, "|CC      = Completion Count (3b)                                                                               |",                                        );
$fdisplay(_trk_file, "|*For additional description of encodings see PCI-SIG 'Address Translation Services r1.1'                      |",                                        );
$fdisplay(_trk_file, "+==============================================================================================================+",                                        );
    endfunction


    // ============================  NOTE   ====================================
    //
    // The remaining code prints each column of a given ATS TLP. It's tedious
    // to read, but gets the job done.
    //
    // =========================================================================

    // -------------------------------------------------------------------------
    // Function     :   sprint_col_0
    // Description  :
    //
    function string sprint_col_0 (HqmAtsAnalysisTxn txn);
        // return $sformatf("| ------------- ");
        return $sformatf("|%-11.2f ns ", txn.simulation_time/1000);
    endfunction : sprint_col_0


    // -------------------------------------------------------------------------
    // Function     :   sprint_col_1
    // Description  :   SOURCE AGENT
    //
    function string sprint_col_1 (HqmAtsAnalysisTxn txn, int sub_row);

        case (txn.ats_cmd)
            ATS_TREQ    :   return "|U";
            ATS_TCPL    :   begin
                                            if ( sub_row==0 ) begin
                                                return "|D";
                                            end else begin
                                                return "| ";
                                            end 
                                                end 
            ATS_PREQ    :   return "|U";
            ATS_PRSP    :   return "|D";
            ATS_IREQ    :   begin
                                            if ( sub_row==0 ) begin
                                                return "|D";
                                            end else begin
                                                return "| ";
                                            end 
                                                end 
            ATS_IRSP    :   return "|U";
            // default                            :   return "|?";
        endcase
    endfunction : sprint_col_1



    // -------------------------------------------------------------------------
    // Function     :   sprint_col_2
    // Description  :   ATS CMD
    //
    function string sprint_col_2 (HqmAtsAnalysisTxn txn, int sub_row);
        case (txn.ats_cmd)
            ATS_TREQ    :   return $sformatf("| %s ", txn.ats_cmd.name());

            ATS_TCPL    :   begin
                                            if (sub_row==0) begin
                                                    return $sformatf("| %s ", txn.ats_cmd.name());
                                            end else begin
                                                    return $sformatf("|          ");
                                            end 
                                                end 

            ATS_PREQ    :   return $sformatf("| %s ", txn.ats_cmd.name());
            ATS_PRSP    :   return $sformatf("| %s ", txn.ats_cmd.name());
            ATS_IREQ    :   begin
                                            if (sub_row==0) begin
                                                    return $sformatf("| %s ", txn.ats_cmd.name());
                                            end 
                                                    return $sformatf("|          ");
                                                end 
            ATS_IRSP    :   return $sformatf("| %s ", txn.ats_cmd.name());
            // default                                 :   return "|                  ";
        endcase
    endfunction : sprint_col_2


    // -------------------------------------------------------------------------
    // Function     :   sprint_col_3
    // Description  :
    //
    function string sprint_col_3 (HqmAtsAnalysisTxn txn);
        case (txn.ats_cmd)
            ATS_TREQ    ,
            ATS_TCPL    ,
            ATS_PREQ    ,
            ATS_PRSP    ,
            ATS_IREQ    ,
            ATS_IRSP    :   return $sformatf("|%0d", txn.chid);
            // default                                 :   return "|";
        endcase
    endfunction : sprint_col_3



    // -------------------------------------------------------------------------
    // Function     :   sprint_col_4
    // Description  :   SOURCE AGENT
    //
    function string sprint_col_4 (HqmAtsAnalysisTxn txn, int sub_row);
        HqmCmdType_t bus_cmd = txn.getCmdType();
        string simple_cmd_name = bus_cmd.name();
        simple_cmd_name = simple_cmd_name.substr(4, simple_cmd_name.len()-1); // Parse out the 'HQM_'
        
        case (txn.ats_cmd)
            //                                                     | MRd64   - |
            ATS_TREQ     :  return $sformatf("| %s   - ", simple_cmd_name);

            ATS_TCPL     :   begin
                if (sub_row==0) begin
                            return $sformatf("| %s   %s ", simple_cmd_name, txn.get_tcpl_sts_abbrev());
                end else begin
                                                 return           "|   XLTADDR ";
                end 
            end 

            //                                                    | Msg4    - |
            ATS_PREQ    :   return $sformatf("| %s    - ", simple_cmd_name);

            //                                                    | Msg5    0 |
            ATS_PRSP    :   return $sformatf("| %s   %s ", simple_cmd_name, txn.get_prsp_rc_abbrev());

            ATS_IREQ    :   begin
            //                                                    | Msg1    - |
                if (sub_row==0)                 return $sformatf("| %s   - ", simple_cmd_name);
                else                            return           "|   ADDRESS ";
            end 

            //                                                    | Msg2    - |
            ATS_IRSP    :   return $sformatf("| %s    - ", simple_cmd_name);

        endcase
    endfunction : sprint_col_4



    // -------------------------------------------------------------------------
    // Function     :   sprint_col_5
    // Description  :   REQID TG / REQID ITG
    //
    function string sprint_col_5 (HqmAtsAnalysisTxn txn, int sub_row);
        tmpstr.delete();
        tmpstr.push_back($sformatf("%h", txn.txn_id.req_id));
        //tmpstr.push_back($sformatf("%h", txn.ttag ));
        tmpstr.push_back($sformatf("%h", {txn.txn_id.tag}));//10 bit tag

        case (txn.ats_cmd)
            ATS_TREQ    : return $sformatf("| %s  %s ", tmpstr[0].toupper(), tmpstr[1].toupper());
                                                      // return $sformatf("| %s  %s ", txn.trqid)., txn.ttag);
            ATS_TCPL    :
                if (sub_row==0)               return $sformatf("| %s  %s ", tmpstr[0].toupper(), tmpstr[1].toupper());
                else                          return           "| --------- ";

            ATS_PREQ    : return $sformatf("| %s  %s ", tmpstr[0].toupper(), tmpstr[1].toupper());
            ATS_PRSP    : return $sformatf("| %s  %s ", tmpstr[0].toupper(), tmpstr[1].toupper());

            ATS_IREQ    :
                if (sub_row==0)               return $sformatf("| %s  %s ", tmpstr[0].toupper(), tmpstr[1].toupper());
                else                          return           "| --------- ";

            ATS_IRSP    : return $sformatf("| %s     ", tmpstr[0].toupper());
        endcase
    endfunction : sprint_col_5


    // -------------------------------------------------------------------------
    // Function     :   sprint_col_6
    // Description  :   Traffic Class
    //
    function string sprint_col_6 (HqmAtsAnalysisTxn txn, int sub_row);
        case (txn.ats_cmd)
            ATS_TREQ    : return $sformatf(" |0%H", txn.tc);
            ATS_TCPL    : begin
                if (sub_row==0)               return $sformatf(" |0%H", txn.tc);
                else                          return           " |--";
            end 
            ATS_PREQ    : return $sformatf(" |0%H", txn.tc);
            ATS_PRSP    : begin
                if (sub_row==0)               return $sformatf(" |0%H", txn.tc);
                else                          return           " |--";
            end 
            ATS_IREQ    : return $sformatf(" |0%H", txn.tc);
            ATS_IRSP    : return $sformatf("  |0%H", txn.tc);
            // default                                 :
        endcase
    endfunction : sprint_col_6



    // -------------------------------------------------------------------------
    // Function     :   sprint_col_7
    // Description  :   SOURCE AGENT
    //
    function string sprint_col_7 (HqmAtsAnalysisTxn txn, int sub_row);
        case (txn.ats_cmd)
            ATS_TREQ    : return $sformatf("| %4d ", txn.length);
            ATS_TCPL    : begin
                if (sub_row==0)               return $sformatf("| %4d ", txn.length);
                else                          return           "| ---- ";
            end 
            ATS_PREQ    : return $sformatf("| %4d ", txn.length);
            ATS_PRSP    : return $sformatf("| %4d ", txn.length);
            ATS_IREQ    : begin
                if (sub_row==0)               return $sformatf("| %4d ", txn.length);
                else                          return           "| -----";
            end 
            ATS_IRSP    : return $sformatf("| %4d ", txn.length);
            // default                                 :
        endcase
    endfunction : sprint_col_7



    // -------------------------------------------------------------------------
    // Function     :   sprint_col_8
    // Description  :   PRG Index, L, W, R
    //
    function string sprint_col_8 (HqmAtsAnalysisTxn txn);
        tmpstr.delete();
        case (txn.ats_cmd)
            ATS_TREQ    : return $sformatf("|  --- |-|-|-" );
            ATS_TCPL    : return $sformatf("|  --- |-|-|-");

            ATS_PREQ    : begin
                                              tmpstr.push_back($sformatf("%h", txn.PrsPreq_s.prg_index));
                                              return $sformatf("|  %s |%b|%b|%b", tmpstr[0].toupper(), txn.PrsPreq_s.last_page_req, txn.PrsPreq_s.write_access_requested, txn.PrsPreq_s.read_access_requested);
                                              end 

            ATS_PRSP    : begin
                                              tmpstr.push_back($sformatf("%h", txn.PrsPrgRsp_s.prg_index));
                                              return $sformatf("|  %s | | | "   , tmpstr[0].toupper());
                                              end 

            ATS_IREQ    : return $sformatf("|  --- |-|-|-");
            ATS_IRSP    : return $sformatf("|  --- |-|-|-");
            // default                                 :
        endcase
    endfunction : sprint_col_8


    // -------------------------------------------------------------------------
    // Function     :   sprint_col_9
    // Description  :   PASID V P X
    //
    function string sprint_col_9 (HqmAtsAnalysisTxn txn, int sub_row);
        tmpstr.delete();
        tmpstr.push_back($sformatf("%h", txn.pasidtlp.pasid));

        case (txn.ats_cmd)
            ATS_TREQ    : return $sformatf("| %s|%b|%b|%b", tmpstr[0].toupper(), txn.pasidtlp.pasid_en, txn.pasidtlp.priv_mode_requested, txn.pasidtlp.exe_requested);
            ATS_TCPL    : return $sformatf("| -----|-|-|-");
            ATS_PREQ    : return $sformatf("| %s|%b|%b|%b", tmpstr[0].toupper(), txn.pasidtlp.pasid_en, txn.pasidtlp.priv_mode_requested, txn.pasidtlp.exe_requested);
            ATS_PRSP    : return $sformatf("| %s|%b|%b|%b", tmpstr[0].toupper(), txn.pasidtlp.pasid_en, txn.pasidtlp.priv_mode_requested, txn.pasidtlp.exe_requested);
            ATS_IREQ    : begin
                if (sub_row==0)               return $sformatf("| %s|%b|%b|%b", tmpstr[0].toupper(), txn.pasidtlp.pasid_en, txn.pasidtlp.priv_mode_requested, txn.pasidtlp.exe_requested);
                else                          return           "| -----|-|-|-";
                                              end 
            ATS_IRSP    : return $sformatf("| -----|-|-|-");
            // default                                 :
        endcase
    endfunction : sprint_col_9



    // -------------------------------------------------------------------------
    // Function     :   sprint_col_10
    // Description  :   Address / CPLID / DSTID
    //
    function string sprint_col_10 (HqmAtsAnalysisTxn txn, int sub_row);
        tmpstr.delete();
        case (txn.ats_cmd)
            ATS_TREQ     : begin
                                               tmpstr.push_back($sformatf("%h", txn.address));
                                               return $sformatf("| %s "         ,  tmpstr[0].toupper());
                                               end 

            ATS_TCPL     : begin
                            if (sub_row==0) begin
                                              tmpstr.push_back($sformatf("%h", txn.AtsTcpl_s.completer_id));
                                              tmpstr.push_back($sformatf("%h", txn.AtsTcpl_s.byte_count));
                                              tmpstr.push_back($sformatf("%h", txn.AtsTcpl_s.lower_address));
                                              return $sformatf("| %s %s %s      " ,  tmpstr[0].toupper(), tmpstr[1].toupper(), tmpstr[2].toupper());
                            end else begin
                                              tmpstr.push_back($sformatf("%h", txn.get_data_beat(.data_bitwidth(ats_cfg.iosfpif_t_params.data_bitwidth), .row(sub_row-1))));
                                              // txn.get_data_beat() will return 64b Hexadecimal Value
                                              // |   ADDRESS (hex)
                                              // |000000000000B000
                                              return $sformatf("| %s "            ,  tmpstr[0].toupper());
                            end 
                                              end 

            ATS_PREQ    : begin
                                              tmpstr.push_back($sformatf("%h", txn.PrsPreq_s.page_address_masked));
                                              return $sformatf("| %s "            ,  tmpstr[0].toupper());
                                              end 

            ATS_PRSP    : begin
                                              tmpstr.push_back($sformatf("%h", txn.PrsPrgRsp_s.destination_device_id));
                                              return $sformatf("| %s             ",  tmpstr[0].toupper());
                                              end 

            ATS_IREQ    : begin
                            if (sub_row==0) begin
                                              tmpstr.push_back($sformatf("%h", txn.AtsIReq_s.destination_device_id));
                                              return $sformatf("| %s             ",  tmpstr[0].toupper());
                                              // txn.get_data_beat() will return 64b Hexadecimal Value
                                              // |   ADDRESS (hex)
                                              // |000000000000B000
                            end else begin
                                              tmpstr.push_back($sformatf("%h", txn.get_data_beat(.data_bitwidth(ats_cfg.iosfpif_t_params.data_bitwidth), .row(sub_row-1))));
                                              return $sformatf("| %s "         ,  tmpstr[0].toupper());
                            end 
                                              end 

            ATS_IRSP    : begin
                                                     tmpstr.push_back($sformatf("%h", txn.AtsIRsp_s.destination_device_id));
                                                     return $sformatf("| %s %d %h ",tmpstr[0].toupper(), txn.AtsIRsp_s.completion_count, txn.AtsIRsp_s.itagv);
                                              end 
            // default                                 :
        endcase
    endfunction : sprint_col_10



    // -------------------------------------------------------------------------
    // Function     :   sprint_col_11
    // Description  :   size|N|G|P|U|R|W|X|
    //
    function string sprint_col_11 (HqmAtsAnalysisTxn txn, int sub_row);
        case (txn.ats_cmd)
            ATS_TREQ     : return $sformatf("|-----|-|-|-|-|-|-|-|");
            ATS_TCPL     : begin
                if (sub_row==0)                      return     "|-----|-|-|-|-|-|-|-|";

                else                                 begin
                                                     bit [63:0] translated_address = txn.get_data_beat(.data_bitwidth(ats_cfg.iosfpif_t_params.data_bitwidth), .row(sub_row-1));
                                                     return $sformatf("|%s|%b|%b|%b|%b|%b|%b|%b|", range_str(translated_address),
                                                                                                   translated_address[10], // N
                                                                                                   translated_address[ 5],  // G
                                                                                                   translated_address[ 4],  // P
                                                                                                   translated_address[ 2],  // U
                                                                                                   translated_address[ 0],  // R
                                                                                                   translated_address[ 1],  // W
                                                                                                   translated_address[ 3]); // X
                                                     end 
            end 

            ATS_PREQ    : return $sformatf("|-----|-|-|-|-|-|-|-|");
            ATS_PRSP    : return $sformatf("|-----|-|-|-|-|-|-|-|");

            ATS_IREQ    : begin
                if (sub_row==0)                      return $sformatf("|-----|-|-|-|-|-|-|-|");
                else                                 return $sformatf("|%s|-|-|-|-|-|-|-|", range_str(txn.get_data_beat(.data_bitwidth(ats_cfg.iosfpif_t_params.data_bitwidth), .row(sub_row-1))));
            end 

            ATS_IRSP    : return $sformatf("|-----|-|-|-|-|-|-|-|");
            // default                                 :
        endcase
    endfunction : sprint_col_11


    // -------------------------------------------------------------------------
    // Function     :   range_str
    // Description  :   Address / CPLID / DSTID
    //
    local function string range_str (bit [63:0] address);

        case ( {address[31:12], address[11]} ) inside
            {21'bXXXX_XXXX_XXXX_XXXX_XXXX, 1'b0}   : range_str = " 4k  ";
            {21'bXXXX_XXXX_XXXX_XXXX_XXX0, 1'b1}   : range_str = " 8k  ";
            {21'bXXXX_XXXX_XXXX_XXXX_XX01, 1'b1}   : range_str = " 16k ";
            {21'bXXXX_XXXX_XXX0_1111_1111, 1'b1}   : range_str = " 2M  ";
            {21'bXX01_1111_1111_1111_1111, 1'b1}   : range_str = " 1G  ";
            {21'b0111_1111_1111_1111_1111, 1'b1}   : range_str = " 4G  ";
            {21'bXXXX_XXXX_XXXX_XXXX_XXXX, 1'b0}   : range_str = " 4K  ";
            {21'bXXXX_XXXX_XXXX_XXXX_XXX0, 1'b1}   : range_str = " 8K  ";
            {21'bXXXX_XXXX_XXXX_XXXX_XX01, 1'b1}   : range_str = " 16k ";
            {21'bXXXX_XXXX_XXXX_XXXX_X011, 1'b1}   : range_str = " 32k ";
            {21'bXXXX_XXXX_XXXX_XXXX_0111, 1'b1}   : range_str = " 64k ";
            {21'bXXXX_XXXX_XXXX_XXX0_1111, 1'b1}   : range_str = " 128k";
            {21'bXXXX_XXXX_XXXX_XX01_1111, 1'b1}   : range_str = " 256k";
            {21'bXXXX_XXXX_XXXX_X011_1111, 1'b1}   : range_str = " 512k";
            {21'bXXXX_XXXX_XXXX_0111_1111, 1'b1}   : range_str = " 1M  ";
            {21'bXXXX_XXXX_XXX0_1111_1111, 1'b1}   : range_str = " 2M  ";
            {21'bXXXX_XXXX_XX01_1111_1111, 1'b1}   : range_str = " 4M  ";
            {21'bXXXX_XXXX_X011_1111_1111, 1'b1}   : range_str = " 8M  ";
            {21'bXXXX_XXXX_0111_1111_1111, 1'b1}   : range_str = " 16M ";
            {21'bXXXX_XXX0_1111_1111_1111, 1'b1}   : range_str = " 32M ";
            {21'bXXXX_XX01_1111_1111_1111, 1'b1}   : range_str = " 64M ";
            {21'bXXXX_X011_1111_1111_1111, 1'b1}   : range_str = " 128M";
            {21'bXXXX_0111_1111_1111_1111, 1'b1}   : range_str = " 256M";
            {21'bXXX0_1111_1111_1111_1111, 1'b1}   : range_str = " 512M";
            {21'bXX01_1111_1111_1111_1111, 1'b1}   : range_str = " 1G  ";
            {21'bX011_1111_1111_1111_1111, 1'b1}   : range_str = " 2G  ";
            {21'b0111_1111_1111_1111_1111, 1'b1}   : range_str = " 4G  ";
            default                                : range_str = " ?   ";
        endcase

    endfunction : range_str




    // -------------------------------------------------------------------------
    // Function     :   sprint_col_12
    // Description  :   ITag Vector
    //
    function string sprint_col_12 (HqmAtsAnalysisTxn txn, int sub_row);
        case (txn.ats_cmd)
            ATS_TREQ     : return           "|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|";
            ATS_TCPL     : return           "|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|";
            ATS_PREQ     : return           "|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|";
            ATS_PRSP     : return           "|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|";
            ATS_IREQ     : return           "|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|";

            ATS_IRSP     : begin
                          //                  31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16  15  14  13  12  11  10   9   8   7   6   5   4   3   2   1   0
                           return $sformatf("| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b| %b|",
                                                                    txn.AtsIRsp_s.itagv[31],
                                                                    txn.AtsIRsp_s.itagv[30],
                                                                    txn.AtsIRsp_s.itagv[29],
                                                                    txn.AtsIRsp_s.itagv[28],
                                                                    txn.AtsIRsp_s.itagv[27],
                                                                    txn.AtsIRsp_s.itagv[26],
                                                                    txn.AtsIRsp_s.itagv[25],
                                                                    txn.AtsIRsp_s.itagv[24],
                                                                    txn.AtsIRsp_s.itagv[23],
                                                                    txn.AtsIRsp_s.itagv[22],
                                                                    txn.AtsIRsp_s.itagv[21],
                                                                    txn.AtsIRsp_s.itagv[20],
                                                                    txn.AtsIRsp_s.itagv[19],
                                                                    txn.AtsIRsp_s.itagv[18],
                                                                    txn.AtsIRsp_s.itagv[17],
                                                                    txn.AtsIRsp_s.itagv[16],
                                                                    txn.AtsIRsp_s.itagv[15],
                                                                    txn.AtsIRsp_s.itagv[14],
                                                                    txn.AtsIRsp_s.itagv[13],
                                                                    txn.AtsIRsp_s.itagv[12],
                                                                    txn.AtsIRsp_s.itagv[11],
                                                                    txn.AtsIRsp_s.itagv[10],
                                                                    txn.AtsIRsp_s.itagv[ 9],
                                                                    txn.AtsIRsp_s.itagv[ 8],
                                                                    txn.AtsIRsp_s.itagv[ 7],
                                                                    txn.AtsIRsp_s.itagv[ 6],
                                                                    txn.AtsIRsp_s.itagv[ 5],
                                                                    txn.AtsIRsp_s.itagv[ 4],
                                                                    txn.AtsIRsp_s.itagv[ 3],
                                                                    txn.AtsIRsp_s.itagv[ 2],
                                                                    txn.AtsIRsp_s.itagv[ 1],
                                                                    txn.AtsIRsp_s.itagv[ 0]);
            end 
            // default                                 :
        endcase
    endfunction : sprint_col_12


endclass : HqmAtsTracker
