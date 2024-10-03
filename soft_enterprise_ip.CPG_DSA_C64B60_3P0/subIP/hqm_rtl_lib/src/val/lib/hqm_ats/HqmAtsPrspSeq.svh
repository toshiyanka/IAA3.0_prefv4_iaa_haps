// -----------------------------------------------------------------------------
// Copyright(C) 2012,2015,2016 Intel Corporation, Confidential Information
// -----------------------------------------------------------------------------
//
// Owner:       Adil Shaaeldin updated by Adam Conyers
// Created On:  8/29/2018 (01/19/2022)
// Description: Sends ATS messages back to Agent - used in HqmIOMMUAPI
// ------------------------------------------------------------------------------


//--AY_HQMV30_ATS--  

class HqmAtsPrspSeq extends sla_sequence;

    // -----------------------------------------------------------------------
    `ovm_object_utils(HqmAtsPrspSeq)

    bit wait_for_complete;

    // protected IosfPkg::Iosf::data_t iosfData[]; // DW based
    protected int unsigned          prsp_txn_id;

    // IosfPkg::Iosf::iosf_status_t    cplStatus = IosfPkg::Iosf::SC;
    bit [15:0] requestor_id;
    bit [ 7:0] tag;
    bit [15:0] destination_id;
    bit [ 3:0] response_code;
    bit [ 8:0] prg_index;
    bit [22:0] pasidtlp;
    bit [ 7:0] message_code = 8'b0000_0101;

    int  prs_min_delay;
    int  prs_max_delay;
    
    bit is_icxl;

    function new(string name = "HqmAtsPrspSeq" );
        super.new(name);
        is_icxl = 0;
    endfunction


    virtual task body();
        bit rc;
        IosfPkg::IosfAgtSeqr            agt_sqr;

//--AY_HQMV30_ATS--         IosfPvcUtilsPkg::IosfPvcTxn     prsp_txn;
        IosfPkg::IosfTxn                prsp_txn;

 
`ifndef HQM_EXCLUDE_CXL
        icxl_vc_pkg::icxl_vc_sequencer  icxl_sqr;
        icxl_vc_pkg::icxl_vc_txn_io     icxl_txn;
`endif

        // HqmAtsPkg::PrspIosfTxn        prsp_txn;
        bit [ 7:0]  sai = $urandom_range(0, 255);

        if (is_icxl) begin
`ifndef HQM_EXCLUDE_CXL
            rc = $cast(icxl_sqr, ifc_sqr);
            `sla_assert(rc, ("Could not cast 'ifc_sqr' to iclx_vc_sequencer"))
`endif
        end else begin
            rc = $cast(agt_sqr, ifc_sqr);
            `sla_assert(rc, ("Could not cast 'ifc_sqr' to IosfAgtSeqr"))
        end

        if (is_icxl) begin
`ifndef HQM_EXCLUDE_CXL
            `ovm_create_on(icxl_txn, icxl_sqr);
            `ovm_rand_send_with(icxl_txn, {
                cmd      == icxl_vc_pkg::icxl::Msg2;
                msg_type == icxl_vc_pkg::icxl::PRG_RSP;
                rqid     == requestor_id;
                tag      == local::tag;
                tc       == 0;
                length   == 0;
                address  == {32'd0, destination_id, response_code, 3'b0, prg_index};
                pasid    == local::pasidtlp;
                sai      == local::sai;
            });
`endif
        end else begin
           `ovm_create_on(prsp_txn, agt_sqr);
           prsp_txn.adrs_c.constraint_mode(0);
           prsp_txn.sprint();
           `ovm_rand_send_with(prsp_txn, {
               cmd           == IosfPkg::Iosf::Msg2;
               reqID         == requestor_id;
               tag           == local::tag;
               trafficClass  == 0;
               length        == '0;
               address       == {32'd0, destination_id, response_code, 3'b0, prg_index};
               pasidtlp      == local::pasidtlp;
               first_byte_en == message_code[3:0];
               last_byte_en  == message_code[7:4];
               sai           == local::sai;
           });
            prsp_txn_id = prsp_txn.get_transaction_id();
        end 

        `ovm_info(get_name(), $sformatf("body(): BEGIN - Sending PRS Response: \tREQID=0x%h, DSTID=0x%h, PRG Index=0x%h, Response Code=%0d, PASIDTLP=0x%h,  wfc=%0d",
                                        requestor_id, destination_id, prg_index, response_code, pasidtlp, wait_for_complete), OVM_LOW)


        // if ( wait_for_complete ) begin
        //     IosfPkg::IosfTgtTxn    rxRspTgtTxn;
        //     ovm_sequence_item      rsp;

        //     `ovm_info(get_name(), $sformatf("Waiting for Completion /w address=0x%0h  pasidtlp=0x%0h  prsp_txn_id=%0d",
        //                                     address, pasidtlp, prsp_txn_id), OVM_HIGH);
        //
        //     get_response (rsp, prsp_txn_id);
        //
        //     `sla_assert($cast(rxRspTgtTxn, rsp), ("Could not cast prsp_txn_id=%0d to IosfTgtTxn", prsp_txn_id));
        //
        // end

        `ovm_info(get_name(), $sformatf("send_txn(): END   - Sending PRS Response: \tREQID=0x%h, DSTID=0x%h, PRG Index=0x%h, Response Code=%0d, PASIDTLP=0x%h ],  wfc=%0d",
                                        requestor_id, destination_id, prg_index, response_code, pasidtlp, wait_for_complete), OVM_LOW)

        // status = (cplStatus == IosfPkg::Iosf::SC);
        // status = 1;

    endtask : body

endclass : HqmAtsPrspSeq
