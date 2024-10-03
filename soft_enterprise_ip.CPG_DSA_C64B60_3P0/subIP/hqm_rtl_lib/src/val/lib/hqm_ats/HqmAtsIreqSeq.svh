// -----------------------------------------------------------------------------
// Copyright(C) 2018 - 2019 Intel Corporation, Confidential Information
// -----------------------------------------------------------------------------
//
// Owner:       Adil Shaaeldin
// Created On:  8/29/2018
// Description: HQM Work Queue Sequence
// ------------------------------------------------------------------------------


//--AY_HQMV30_ATS--  

class HqmAtsIreqSeq extends sla_sequence;

    // -----------------------------------------------------------------------
    `ovm_object_utils(HqmAtsIreqSeq)


    HqmAtsCfgObj ats_cfg;

    bit [15:0]  requester_id;
    bit [ 4:0]  itag;
    bit [15:0]  destination_id = 16'h0000;
    bit [15:0]  destination_val;

    bit [22:0]  inv_pasid;
    bit [63:0]  inv_addr;
    bit [ 7:0]  message_code = 8'b0000_0001;
    bit [ 7:0]  sai = 8'h03; // $urandom_range(0, 255);
    string      range_str;
    
    // Custom knobs to allow errors to exist in the invalidation message
    bit         enable_dpe_err = 0;
    bit         enable_ep_err = 0;
   
    bit         has_ecrc_err;

    function new(string name = "HqmAtsIreqSeq" );
        super.new(name);

        has_ecrc_err=0;
        $value$plusargs("hqm_atsinvreq_ecrc_err=%d",has_ecrc_err);
        `ovm_info(get_full_name(),$psprintf("HqmAtsIreqSeq: has_ecrc_err=%0d ", has_ecrc_err), OVM_LOW)


        destination_val = 16'h0000;
        $value$plusargs("hqm_atsinvreq_destid=%h",destination_val);
        `ovm_info(get_full_name(),$psprintf("HqmAtsIreqSeq: destination_val=0x%0x ", destination_val), OVM_LOW)
    endfunction




    virtual task body();
        bit rc;
        IosfPkg::IosfAgtSeqr agt_sqr;
        //--AY_TMP_07142022 HqmIosfTxn ireq_txn;
        IosfPkg::IosfTxn ireq_txn;
        bit [63:0]  addr_val;


`ifndef HQM_EXCLUDE_CXL
        icxl_vc_pkg::icxl_vc_sequencer icxl_sqr;
        icxl_vc_pkg::icxl_vc_txn_io  icxl_txn;
`endif

        bit [31:0] inv_addr_upper_dw_reverse = ats_cfg.reverse_dw( inv_addr[63:32]);
        bit [31:0] inv_addr_lower_dw_reverse = ats_cfg.reverse_dw( inv_addr[31: 0]);

        if (ats_cfg.is_bus_iCXL) begin
`ifndef HQM_EXCLUDE_CXL
            rc = $cast(icxl_sqr, ifc_sqr);
            `sla_assert(rc, ("Could not cast 'ifc_sqr' to icxl_vc_sequencer"))
`endif
        end else begin
            rc = $cast(agt_sqr, ifc_sqr);
            `sla_assert(rc, ("Could not cast 'ifc_sqr' to IosfAgtSeqr"))
        end
        
        if (ats_cfg.is_bus_iCXL) begin
`ifndef HQM_EXCLUDE_CXL
            `ovm_create_on(icxl_txn, icxl_sqr)
`endif
        end else begin
            `ovm_create_on(ireq_txn, agt_sqr);
            ireq_txn.adrs_c.constraint_mode(0);
            ireq_txn.setCfg(agt_sqr.getCfg());
        end 
        

        addr_val=0;
        addr_val[31:16] = destination_val; // local::destination_id; // Device ID

        `ovm_info (get_name(), $sformatf("send_txn(): BEGIN - Sending INV Request: \tREQID=0x%h, DSTID=0x%h, TXNADDR=0x%0x, PASID_EN='%s', PASID=0x%h, INV ADDRESS=0x%h (%s) ITAG=%0d",
                               requester_id, destination_val, addr_val, (inv_pasid[22] ? "YES" : "NO"), inv_pasid[19:0], inv_addr, range_str, itag), OVM_LOW)
        

        //--AY_HQMV30_ATS_TMPif ( enable_dpe_err || enable_ep_err ) begin
        //--AY_HQMV30_ATS_TMP    ireq_txn.allowErrs = 1;
        //--AY_HQMV30_ATS_TMPend 

        if (ats_cfg.is_bus_iCXL) begin
`ifndef HQM_EXCLUDE_CXL
            `ovm_rand_send_with(icxl_txn, {
                cmd     == icxl_vc_pkg::icxl::MsgD2;
                rqid    == local::requester_id;
                length  == 2;
                //address == {32'd0, local::destination_id, 16'd0}; // Device ID
                address == addr_val;
                fbe     == local::message_code[3:0];
                lbe     == local::message_code[7:4];
                tag     == { 3'b0, itag};
                pasid   == local::inv_pasid;
                sai     == sai;
                foreach (data[i]) {
                    i == 0 -> data[i] == inv_addr_upper_dw_reverse;
                    i == 1 -> data[i] == inv_addr_lower_dw_reverse;
                }
                tc      == 0; // FIXME : AC : Not sure what tc needs to be -- in IOSF TXN we have HQM wrapper that takes vc_en and tc_vc_map and calcs the traffic class but not sure why
                //FIXME : AC : Come back to error code - will need to support errors like on IOSF version below in future 
            });
`endif
        end else begin
            `ovm_rand_send_with(ireq_txn, {
                reqType       == IosfPkg::Iosf::POSTED;
                cmd           == IosfPkg::Iosf::MsgD2;
                reqID         == local::requester_id;
                length        == 10'h2;
                //address       == {32'd0, local::destination_id, 16'd0}; // Device ID
                address == addr_val;
                first_byte_en == local::message_code[3:0];
                last_byte_en  == local::message_code[7:4];
                tag           == {3'd0, itag};
                pasidtlp      == local::inv_pasid;
                sai           == local::sai;
                reqChId       == 0;
            
                foreach (data[i]) {
                    i == 0 -> data[i] == inv_addr_upper_dw_reverse;
                    i == 1 -> data[i] == inv_addr_lower_dw_reverse;
                }

                  cid           == 0;
                  ecrc          == 0;
                  ecrc_gen      == 0;
                  ecrc_err      == has_ecrc_err; 
                  trafficClass  == 0;
                  tlpDigest     == 0;
                  reqLocked     == 0;  
                  compareCompletion == 0;
                  waitForCompletion == 0;
                  pollingMode       == 0;
                  expectRsp         == 0;
                  driveBadCmd             == 0;
                  driveBadCmdParity       ==  0;
                  driveBadDataParity      ==  0;
                  driveBadDataParityCycle ==  0;
                  driveBadDataParityPct   ==  0;
                  reqGap            ==  0;
                  chain             ==  1'b0;
                  procHint          == 0;
                  errorPresent      == 0;
                  byteEnWithData    == 0;




                
                //--AY_HQMV30_ATS_TMP                if ( allowErrs ) {
                //--AY_HQMV30_ATS_TMP    if ( enable_dpe_err ) {
                //--AY_HQMV30_ATS_TMP        driveBadDataParity      == 1;
                //--AY_HQMV30_ATS_TMP        driveBadDataParityCycle == 0;
                //--AY_HQMV30_ATS_TMP        driveBadDataParityPct   == 100;
                //--AY_HQMV30_ATS_TMP    } else {
                //--AY_HQMV30_ATS_TMP        driveBadDataParity      == 0;
                //--AY_HQMV30_ATS_TMP    }
                //--AY_HQMV30_ATS_TMP    if ( enable_ep_err ) {
                //--AY_HQMV30_ATS_TMP        allowEpErrs  == 1;
                //--AY_HQMV30_ATS_TMP        errorPresent == 1;
                //--AY_HQMV30_ATS_TMP    } else {
                //--AY_HQMV30_ATS_TMP        allowEpErrs == 0;
                //--AY_HQMV30_ATS_TMP    }
                    // allowErrs getting turned on allows the following to also be enabled, so we constrain them to 0
                //--AY_HQMV30_ATS_TMP    allowRsvdErrs == 0;
                //--AY_HQMV30_ATS_TMP    allowMtlpErrs == 0;
                //--AY_HQMV30_ATS_TMP    allowCmdParityErrs == 0;
                //--AY_HQMV30_ATS_TMP    allowUrErrs == 0;
                //--AY_HQMV30_ATS_TMP    allowCaErrs == 0; 
                //--AY_HQMV30_ATS_TMP }
            });
            ireq_txn.sprint();
           `ovm_info (get_name(), $sformatf("send_txn(): END - Sent INV Request: \tREQID=0x%h, DSTID=0x%h, TXNADDR=0x%0x, PASID_EN='%s', PASID=0x%h, INV ADDRESS=0x%h (%s) ITAG=%0d reqChId=%0d",
                               requester_id, destination_val, addr_val, (inv_pasid[22] ? "YES" : "NO"), inv_pasid[19:0], inv_addr, range_str, itag, ireq_txn.reqChId), OVM_LOW)
        end 
    endtask : body

endclass : HqmAtsIreqSeq
