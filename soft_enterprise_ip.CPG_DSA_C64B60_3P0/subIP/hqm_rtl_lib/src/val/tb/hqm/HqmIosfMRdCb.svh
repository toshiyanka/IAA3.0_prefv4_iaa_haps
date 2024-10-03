// -----------------------------------------------------------------------------
//  Copyright(C) 2012, 2017 - 2021 Intel Corporation, all rights reserved.
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY COPYRIGHT LAWS AND
//  IS CONSIDERED A TRADE SECRET BELONGING TO THE INTEL CORPORATION.
//
//  Intel Confidential
// -----------------------------------------------------------------------------
//
// Description : IOSF PVC's callback for MRd64 or MRd32 operations.
//               this is mostly to intercept completions and provide testbench with
//               control for "Completer Abort" (CA) or handling of special addresses.
//
// -----------------------------------------------------------------------------
// customized callback for completions
// CA (UR completions in future...)
// delayed txn within an address range...
//
// Fab VC sends fixed sized split completions (cplBoundary or less)
// Agt VC sends variable sized split completions (n*cplBoundary or less
// where n is a random number between 1 and MPS/cplBoundary)
//
//------------------------------------------------------------------

//-------------------------------------------------------------------
// Override the memory read callback
// for MRd64 as registered below
//-------------------------------------------------------------------

//--AY_HQMV30_ATS
import hqm_cfg_pkg::*;

parameter bit [63:0]        INVALID_ADDR                 = 64'hFFFF_FFFF_FFFF_FFFF;

class HqmIosfMRdCb extends IosfBaseCallBack;
    string                   inst_suffix = "";
    HqmIpCfg                 hqmCfgObj;
    IosfTxn                  saveCACpl  = new();
    bit                      delayCACpl = 'b0;
    bit                      mps2or3Cpl = 'b0;
    HqmAtsPkg::HqmIommuAPI   iommu_api;
    hqm_tb_cfg               i_hqm_tb_cfg;

    //--AY_HQMV30_ATS_REVISIT
    int                      setATSDelay=0;
    int                      atsMinDelay=0;
    int                      atsMaxDelay=500;     

    int                      atsCplNoRWMinProb=0;
    int                      atsCplNoRWMaxProb=0;     
    int                      iosf_cb_ats_cpl_no_rw=0;

    int                      atsCplErrInjMinProb=0;
    int                      atsCplErrInjMaxProb=0;
    int                      iosf_cb_ats_cpl_errinj=0;

    int                      atsCplErrInjPASIDMin=0;
    int                      atsCplErrInjPASIDMax=0;
    int                      iosf_cb_ats_cpl_errinj_pasid=0;

    int                      atsCplErrInjDPEMin=0;
    int                      atsCplErrInjDPEMax=0;
    int                      iosf_cb_ats_cpl_errinj_dpe=0;

    int                      atsCplErrInjEPMin=0;
    int                      atsCplErrInjEPMax=0;
    int                      iosf_cb_ats_cpl_errinj_ep=0;

    int                      atsCplErrInjSTMin=0;
    int                      atsCplErrInjSTMax=0;
    int                      iosf_cb_ats_cpl_errinj_status=0;


    int                      atsCplOOOMin=0;
    int                      atsCplOOOMax=0;
    int                      disable_ooo_ats_cpl=1;

    int                      cq_ats_cpl_errinj_ctrl;
    int                      cq_ats_cpl_errinj_type;

    // -------------------------------------------------------------------------
    `ovm_object_utils(HqmIosfMRdCb)


    // -------------------------------------------------------------------------
    function new(string name = "HqmIosfMRdCb");
        super.new();
        `ovm_info(get_type_name(), "HqmIosfMRdCb created(): new", OVM_LOW)
         atsMinDelay=0;  
         $value$plusargs("HQM_MRDCB_ATSDLY_MIN=%d",atsMinDelay);
         atsMaxDelay=200;     
         $value$plusargs("HQM_MRDCB_ATSDLY_MAX=%d",atsMaxDelay);
        `ovm_info(get_type_name(), $sformatf("HqmIosfMRdCb created(): Completion delay rand settings - atsMinDelay=%0d atsMaxDelay=%0d", atsMinDelay, atsMaxDelay), OVM_LOW);

         atsCplOOOMin=0;
         $value$plusargs("HQM_MRDCB_ATSOOO_MIN=%d",atsCplOOOMin);
         atsCplOOOMax=0;     
         $value$plusargs("HQM_MRDCB_ATSOOO_MAX=%d",atsCplOOOMax);
        `ovm_info(get_type_name(), $sformatf("HqmIosfMRdCb created(): Completion delay rand settings - atsCplOOOMin=%0d atsCplOOOMax=%0d", atsCplOOOMin, atsCplOOOMax), OVM_LOW);

         //--CQ based errinj control
         cq_ats_cpl_errinj_ctrl=0;
         $value$plusargs("HQM_MRDCB_CPLERR_CQCTRL=%d",cq_ats_cpl_errinj_ctrl);
        `ovm_info(get_type_name(), $sformatf("HqmIosfMRdCb created(): Completion no RW rand settings - cq_ats_cpl_errinj_ctrl=%0d",cq_ats_cpl_errinj_ctrl), OVM_LOW);

 
         atsCplNoRWMinProb=0;  
         $value$plusargs("HQM_MRDCB_CPLDNORW_MIN=%d",atsCplNoRWMinProb);
         atsCplNoRWMaxProb=0;     
         $value$plusargs("HQM_MRDCB_CPLDNORW_MAX=%d",atsCplNoRWMaxProb);
        `ovm_info(get_type_name(), $sformatf("HqmIosfMRdCb created(): Completion no RW rand settings - atsCplNoRWMinProb=%0d atsCplNoRWMaxProb=%0d", atsCplNoRWMinProb, atsCplNoRWMaxProb), OVM_LOW);

         atsCplErrInjMinProb=0;  
         $value$plusargs("HQM_MRDCB_CPLERRINJ_MIN=%d",atsCplErrInjMinProb);
         atsCplErrInjMaxProb=0;     
         $value$plusargs("HQM_MRDCB_CPLERRINJ_MAX=%d",atsCplErrInjMaxProb);
        `ovm_info(get_type_name(), $sformatf("HqmIosfMRdCb created(): Completion ERRINJ rand settings - atsCplErrInjMinProb=%0d atsCplErrInjMaxProb=%0d", atsCplErrInjMinProb, atsCplErrInjMaxProb), OVM_LOW);

         atsCplErrInjPASIDMin=0;  
         $value$plusargs("HQM_MRDCB_CPLERRPASID_MIN=%d",atsCplErrInjPASIDMin);
         atsCplErrInjPASIDMax=0;     
         $value$plusargs("HQM_MRDCB_CPLERRPASID_MAX=%d",atsCplErrInjPASIDMax);
        `ovm_info(get_type_name(), $sformatf("HqmIosfMRdCb created(): Completion ERRINJ rand settings - atsCplErrInjPASIDMin=%0d atsCplErrInjPASIDMax=%0d", atsCplErrInjPASIDMin, atsCplErrInjPASIDMax), OVM_LOW);

         atsCplErrInjDPEMin=0;  
         $value$plusargs("HQM_MRDCB_CPLERRDPE_MIN=%d",atsCplErrInjDPEMin);
         atsCplErrInjDPEMax=0;     
         $value$plusargs("HQM_MRDCB_CPLERRDPE_MAX=%d",atsCplErrInjDPEMax);
        `ovm_info(get_type_name(), $sformatf("HqmIosfMRdCb created(): Completion ERRINJ rand settings - atsCplErrInjDPEMin=%0d atsCplErrInjDPEMax=%0d", atsCplErrInjDPEMin, atsCplErrInjDPEMax), OVM_LOW);

         atsCplErrInjEPMin=0;  
         $value$plusargs("HQM_MRDCB_CPLERREP_MIN=%d",atsCplErrInjEPMin);
         atsCplErrInjEPMax=0;     
         $value$plusargs("HQM_MRDCB_CPLERREP_MAX=%d",atsCplErrInjEPMax);
        `ovm_info(get_type_name(), $sformatf("HqmIosfMRdCb created(): Completion ERRINJ rand settings - atsCplErrInjEPMin=%0d atsCplErrInjEPMax=%0d", atsCplErrInjEPMin, atsCplErrInjEPMax), OVM_LOW);

         atsCplErrInjSTMin=0;  
         $value$plusargs("HQM_MRDCB_CPLERRST_MIN=%d",atsCplErrInjSTMin);
         atsCplErrInjSTMax=0;     
         $value$plusargs("HQM_MRDCB_CPLERRST_MAX=%d",atsCplErrInjSTMax);
        `ovm_info(get_type_name(), $sformatf("HqmIosfMRdCb created(): Completion ERRINJ rand settings - atsCplErrInjSTMin=%0d atsCplErrInjSTMax=%0d", atsCplErrInjSTMin, atsCplErrInjSTMax), OVM_LOW);
    endfunction


    // -------------------------------------------------------------------------
    function void set_cfg_obj(HqmIpCfg cfgObj);
        hqmCfgObj = cfgObj;
    endfunction

    // -------------------------------------------------------------------------


    // -------------------------------------------------------------------------
`ifdef HQM_IOSF_2019_BFM
    function void execute(IosfAgtSlvTlm slvHandle, IosfTgtTxn tgtTxn);
`else
    function void execute(IosfAgtTgtTlm tgtHandle, IosfTgtTxn tgtTxn);
`endif
        IosfTxn          myCpl = new;
        IosfTxn          cplArr[$];
        //--AY_HQMV30_ATS_TBD  DsaPrimaryBusRsp_s busRsp;

        // get the range of addresses for delayed txn
        Iosf::address_t  delayed_addr_base    = hqmCfgObj.mem_map_obj.dram_addr_hi;
        Iosf::address_t  delayed_addr_limit   = hqmCfgObj.mem_map_obj.dram_addr_lo;
        time             delayed_addr_delay   = 0;

        //`ovm_info(get_type_name(), $sformatf("execute() -- BEGIN"), OVM_MEDIUM)
        `ovm_info(get_name(), $sformatf("HqmIosfMRdCb execute(): BEGIN -- tgtTxn.cmd=%0s address=0x%0x length=%0d", tgtTxn.cmd, tgtTxn.address, tgtTxn.length), OVM_LOW);
`ifdef HQM_IOSF_2019_BFM
        run_callback_check(slvHandle, tgtTxn);
`else
        run_callback_check(tgtHandle, tgtTxn);
`endif

        //--AY_HQMV30_ATS
        //--AY_HQMV30_ATS_TBD  busRsp = dsaCfgObj.primBusRspObj.getBusRsp(.address(tgtTxn.address), .pasidtlp(tgtTxn.tpasidtlp), .is_ats(0), .is_rb((tgtTxn.tfbe == 0 && tgtTxn.tlbe == 0)));

        // Run iommu_ats Completion Response testing -- Intercept & Modify the upstream TLP
        if (hqmCfgObj.atsCfg.run_iommu_ats_selftest || $test$plusargs("HQMV30_ATS_IOSFCB_MODIFY_TEST")) modify_upstream_tlp(tgtTxn);

        if ( (tgtTxn.cmd==Iosf::MRd64 || tgtTxn.cmd==Iosf::MRd32) && (tgtTxn.tat==2'b01) ) begin : ADDRESS_TRANSLATION_REQUEST
        // Translation Request Detected!
`ifdef HQM_IOSF_2019_BFM
            fork form_ats_response(slvHandle, tgtTxn); join_none
`else
            fork form_ats_response(tgtHandle, tgtTxn); join_none
`endif

        end : ADDRESS_TRANSLATION_REQUEST

//--AY_HQMV30_ATS_PRS_TBD        else if (tgtTxn.cmd==Iosf::Msg0 && {tgtTxn.tlbe, tgtTxn.tfbe}==8'b0000_0100) begin : PAGE_REQUEST
//--AY_HQMV30_ATS_PRS_TBD            // {tgtTxn.tlbe, tgtTxn.tfbe} corresponds to the Message Code
//--AY_HQMV30_ATS_PRS_TBD            // This signifies that incoming ATS Page Request Message has been detected.
//--AY_HQMV30_ATS_PRS_TBD `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_PRS_TBD             form_prs_response(slvHandle, tgtTxn);
//--AY_HQMV30_ATS_PRS_TBD `else
//--AY_HQMV30_ATS_PRS_TBD             form_prs_response(tgtHandle, tgtTxn);
//--AY_HQMV30_ATS_PRS_TBD `endif
//--AY_HQMV30_ATS_PRS_TBD         end : PAGE_REQUEST

//--AY_HQMV30_ATS_COMPLETION        else if( in_range(tgtTxn.address, delayed_addr_base, delayed_addr_limit) ) begin: PARALLEL_DELAY
//--AY_HQMV30_ATS_COMPLETION             // Build a delayed completions
//--AY_HQMV30_ATS_COMPLETION `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_COMPLETION             slvHandle.buildCplD (tgtTxn, cplArr);
//--AY_HQMV30_ATS_COMPLETION `else
//--AY_HQMV30_ATS_COMPLETION             tgtHandle.buildCplD (tgtTxn, cplArr);
//--AY_HQMV30_ATS_COMPLETION `endif            
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION             // the environment should have configured the delay in the DsaConfigObj
//--AY_HQMV30_ATS_COMPLETION             delayed_addr_delay = $urandom_range(dsaCfgObj.memMap.delayed_addr_min_delay,
//--AY_HQMV30_ATS_COMPLETION                 dsaCfgObj.memMap.delayed_addr_max_delay);
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION             while (cplArr.size()) begin
//--AY_HQMV30_ATS_COMPLETION                 myCpl = cplArr.pop_front ();
//--AY_HQMV30_ATS_COMPLETION                 if (dsaCfgObj.memMap.cto_cmp_num == 1) begin
//--AY_HQMV30_ATS_COMPLETION                     // Now overwrite the completion fields
//--AY_HQMV30_ATS_COMPLETION                     myCpl.parallelDelay = delayed_addr_delay; // delay the completion by sim timeunits
//--AY_HQMV30_ATS_COMPLETION                     if ($test$plusargs("CTO_CLKS_RDC")) begin
//--AY_HQMV30_ATS_COMPLETION                         int delay, actual_delay;
//--AY_HQMV30_ATS_COMPLETION                         $value$plusargs("CTO_CLKS_RDC=%0d", delay);
//--AY_HQMV30_ATS_COMPLETION                         actual_delay = $urandom_range(delay - 100, delay + 100);
//--AY_HQMV30_ATS_COMPLETION                         if (tgtTxn.address == delayed_addr_base) begin
//--AY_HQMV30_ATS_COMPLETION                             myCpl.parallelDelay = actual_delay * 1ns; // delay the first completion by sim timeunits
//--AY_HQMV30_ATS_COMPLETION                             `ovm_info(get_name(), $sformatf( "Injected paralleDelay =0x%0h", myCpl.parallelDelay), OVM_LOW)
//--AY_HQMV30_ATS_COMPLETION                         end else begin
//--AY_HQMV30_ATS_COMPLETION                             myCpl.parallelDelay = 0;
//--AY_HQMV30_ATS_COMPLETION                         end
//--AY_HQMV30_ATS_COMPLETION                     end
//--AY_HQMV30_ATS_COMPLETION                 end else begin
//--AY_HQMV30_ATS_COMPLETION                     mps2or3Cpl = 'b1;
//--AY_HQMV30_ATS_COMPLETION                 end
//--AY_HQMV30_ATS_COMPLETION                 if (dsaCfgObj.memMap.cto_rsp_ur_ca_sc != IosfPkg::Iosf::SC) begin
//--AY_HQMV30_ATS_COMPLETION                     myCpl.first_byte_en = {1'b0, dsaCfgObj.memMap.cto_rsp_ur_ca_sc}; // UR cpl
//--AY_HQMV30_ATS_COMPLETION                     myCpl.cmd = Iosf::Cpl;
//--AY_HQMV30_ATS_COMPLETION                     myCpl.length = 0;
//--AY_HQMV30_ATS_COMPLETION                 end
//--AY_HQMV30_ATS_COMPLETION `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_COMPLETION                 sendCompletion (slvHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION `else
//--AY_HQMV30_ATS_COMPLETION                 sendCompletion (tgtHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION `endif
//--AY_HQMV30_ATS_COMPLETION                 dsaCfgObj.memMap.cto_cmp_num--;
//--AY_HQMV30_ATS_COMPLETION             end // while (cplArr.size())
//--AY_HQMV30_ATS_COMPLETION             // $display ("SENT DELAYED COMPLETION!");
//--AY_HQMV30_ATS_COMPLETION             `ovm_info(get_name(), $sformatf( "sent parallel delayed completion by %0d sim timeunits, for addr=0x%0h with mps2or3Cpl = %0d, with cplStatus = %s",
//--AY_HQMV30_ATS_COMPLETION                 delayed_addr_delay, tgtTxn.address, mps2or3Cpl, myCpl.cplStatus.name()), OVM_LOW)
//--AY_HQMV30_ATS_COMPLETION         end // block: PARALLEL_DELAY
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION         else if( in_range(tgtTxn.address, uce_addr_base, uce_addr_limit) ) begin: UNEXPECTED_COMPLETION_ERROR
//--AY_HQMV30_ATS_COMPLETION             bit do_extra_cpl = 'b1;
//--AY_HQMV30_ATS_COMPLETION             `ovm_info(get_name(), $sformatf( "driving unexpected completion err, for addr=0x%0h",
//--AY_HQMV30_ATS_COMPLETION                 tgtTxn.address), OVM_LOW)
//--AY_HQMV30_ATS_COMPLETION             // Build the regular completions
//--AY_HQMV30_ATS_COMPLETION `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_COMPLETION             slvHandle.buildCplD (tgtTxn, cplArr);
//--AY_HQMV30_ATS_COMPLETION `else
//--AY_HQMV30_ATS_COMPLETION             tgtHandle.buildCplD (tgtTxn, cplArr);
//--AY_HQMV30_ATS_COMPLETION `endif
//--AY_HQMV30_ATS_COMPLETION             while (cplArr.size) begin
//--AY_HQMV30_ATS_COMPLETION                 myCpl = cplArr.pop_front();
//--AY_HQMV30_ATS_COMPLETION `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_COMPLETION                 sendCompletion (slvHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION `else
//--AY_HQMV30_ATS_COMPLETION                 sendCompletion (tgtHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION `endif                
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION                 // Send extra completion with bad reqid
//--AY_HQMV30_ATS_COMPLETION                 if (do_extra_cpl) begin
//--AY_HQMV30_ATS_COMPLETION                     myCpl.reqID = 16'hFFFF;
//--AY_HQMV30_ATS_COMPLETION `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_COMPLETION                     sendCompletion (slvHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION `else
//--AY_HQMV30_ATS_COMPLETION                     sendCompletion (tgtHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION `endif
//--AY_HQMV30_ATS_COMPLETION                     do_extra_cpl = 'b0;
//--AY_HQMV30_ATS_COMPLETION                 end
//--AY_HQMV30_ATS_COMPLETION             end
//--AY_HQMV30_ATS_COMPLETION         end // block: UNEXPECTED_COMPLETION_ERROR
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION         else if( in_range(tgtTxn.address, ur_addr_base, ur_addr_limit, .dw_size(tgtTxn.length)) && (!ur_addr_dest_rb_only || (ur_addr_dest_rb_only && tgtTxn.tfbe == 0 && tgtTxn.tlbe == 0)) ) begin: UNSUPPORTED_REQ
//--AY_HQMV30_ATS_COMPLETION `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_COMPLETION             slvHandle.buildCplD (tgtTxn, cplArr);
//--AY_HQMV30_ATS_COMPLETION `else
//--AY_HQMV30_ATS_COMPLETION             tgtHandle.buildCplD (tgtTxn, cplArr);
//--AY_HQMV30_ATS_COMPLETION `endif            
//--AY_HQMV30_ATS_COMPLETION             while (cplArr.size) begin
//--AY_HQMV30_ATS_COMPLETION                 myCpl = cplArr.pop_front ();
//--AY_HQMV30_ATS_COMPLETION                 // formulate a UR_COMPLETION
//--AY_HQMV30_ATS_COMPLETION                 myCpl.first_byte_en = {1'b0, Iosf::UR}; // UR cpl
//--AY_HQMV30_ATS_COMPLETION                 myCpl.cmd = Iosf::Cpl;
//--AY_HQMV30_ATS_COMPLETION                 myCpl.length = 0;
//--AY_HQMV30_ATS_COMPLETION `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_COMPLETION                 sendCompletion (slvHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION `else
//--AY_HQMV30_ATS_COMPLETION                 sendCompletion (tgtHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION `endif
//--AY_HQMV30_ATS_COMPLETION                 ovm_report_info(get_name(), $sformatf( "sent UR completion, for addr=0x%0h",
//--AY_HQMV30_ATS_COMPLETION                                                        tgtTxn.address), OVM_LOW);
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION                 // No need to process the rest of the split completions;
//--AY_HQMV30_ATS_COMPLETION                 // One UR Cpl is enough
//--AY_HQMV30_ATS_COMPLETION                 break;
//--AY_HQMV30_ATS_COMPLETION             end // while (cplArr.size...)
//--AY_HQMV30_ATS_COMPLETION         end // block: UNSUPPORTED_REQ
//--AY_HQMV30_ATS_COMPLETION         else if ( busRsp.rsp_id != -1 ) begin
//--AY_HQMV30_ATS_COMPLETION             string              injected_attr = "";
//--AY_HQMV30_ATS_COMPLETION             Iosf::iosf_cmd_t    iosf_cmd = Iosf::CplD;
//--AY_HQMV30_ATS_COMPLETION             Iosf::iosf_status_t iosf_status = Iosf::SC;
//--AY_HQMV30_ATS_COMPLETION             bit [22:0]          pasidtlp;
//--AY_HQMV30_ATS_COMPLETION             int                 tgt_cpl; // Target completion to inject the error
//--AY_HQMV30_ATS_COMPLETION `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_COMPLETION             slvHandle.buildCplD (tgtTxn, cplArr);         // Begin by building the completion
//--AY_HQMV30_ATS_COMPLETION `else
//--AY_HQMV30_ATS_COMPLETION             tgtHandle.buildCplD (tgtTxn, cplArr);         // Begin by building the completion
//--AY_HQMV30_ATS_COMPLETION `endif
//--AY_HQMV30_ATS_COMPLETION             tgt_cpl = $urandom_range(0, cplArr.size()-1); // Randomize the completion number
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION             void'(std::randomize(pasidtlp) with {pasidtlp[22] == 1;}); // Randomize a PASID to inject
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION             foreach ( cplArr[i] ) begin
//--AY_HQMV30_ATS_COMPLETION                 myCpl = cplArr[i];
//--AY_HQMV30_ATS_COMPLETION                 if ( i == tgt_cpl ) begin
//--AY_HQMV30_ATS_COMPLETION                     foreach ( busRsp.rsp_attr[j] ) begin
//--AY_HQMV30_ATS_COMPLETION                         case ( busRsp.rsp_attr[j] )
//--AY_HQMV30_ATS_COMPLETION                             HQM_PBUS_DPE : begin
//--AY_HQMV30_ATS_COMPLETION                                 myCpl.driveBadDataParity = 1;
//--AY_HQMV30_ATS_COMPLETION                                 myCpl.driveBadDataParityCycle = 1;
//--AY_HQMV30_ATS_COMPLETION                                 injected_attr = $sformatf("%s DPE=1", injected_attr);
//--AY_HQMV30_ATS_COMPLETION                             end
//--AY_HQMV30_ATS_COMPLETION                             HQM_PBUS_EP : begin
//--AY_HQMV30_ATS_COMPLETION                                 myCpl.errorPresent = 'b1;
//--AY_HQMV30_ATS_COMPLETION                                 injected_attr = $sformatf("%s EP=1", injected_attr);
//--AY_HQMV30_ATS_COMPLETION                             end
//--AY_HQMV30_ATS_COMPLETION                             HQM_PBUS_MTLP_PASIDTLP : begin
//--AY_HQMV30_ATS_COMPLETION                                 myCpl.pasidtlp = pasidtlp;
//--AY_HQMV30_ATS_COMPLETION                                 injected_attr = $sformatf("%s PASIDTLP=0x%06h", injected_attr, pasidtlp);
//--AY_HQMV30_ATS_COMPLETION                             end
//--AY_HQMV30_ATS_COMPLETION                             HQM_PBUS_UNSTS : begin
//--AY_HQMV30_ATS_COMPLETION                                 // This case will be CplD with such a status
//--AY_HQMV30_ATS_COMPLETION                                 void'(std::randomize(iosf_status) with {iosf_status != Iosf::SC;});
//--AY_HQMV30_ATS_COMPLETION                                 injected_attr = $sformatf("%s CPLD Status=%s", injected_attr, iosf_status.name());
//--AY_HQMV30_ATS_COMPLETION                             end
//--AY_HQMV30_ATS_COMPLETION                             HQM_PBUS_DELAY : begin
//--AY_HQMV30_ATS_COMPLETION                                 void'(std::randomize(myCpl.parallelDelay) with { myCpl.parallelDelay inside {[busRsp.min_rsp_delay:busRsp.max_rsp_delay]};});
//--AY_HQMV30_ATS_COMPLETION                                 injected_attr = $sformatf("%s CPL Delay=%0t", injected_attr, myCpl.parallelDelay);
//--AY_HQMV30_ATS_COMPLETION                             end 
//--AY_HQMV30_ATS_COMPLETION                             default : `ovm_fatal(get_name(), $sformatf("BusRsp[%0d] : Unsupported RspAttr=%s", busRsp.rsp_id, busRsp.rsp_attr[j].name()))
//--AY_HQMV30_ATS_COMPLETION                         endcase
//--AY_HQMV30_ATS_COMPLETION                     end
//--AY_HQMV30_ATS_COMPLETION                     case ( busRsp.rsp_type )
//--AY_HQMV30_ATS_COMPLETION                         HQM_PBUS_CA : begin // Completer Abort
//--AY_HQMV30_ATS_COMPLETION                             iosf_status = Iosf::CA;
//--AY_HQMV30_ATS_COMPLETION                             iosf_cmd    = Iosf::Cpl;
//--AY_HQMV30_ATS_COMPLETION                         end
//--AY_HQMV30_ATS_COMPLETION                         HQM_PBUS_UR : begin // Unsupported Request
//--AY_HQMV30_ATS_COMPLETION                             iosf_status = Iosf::UR;
//--AY_HQMV30_ATS_COMPLETION                             iosf_cmd    = Iosf::Cpl;
//--AY_HQMV30_ATS_COMPLETION                         end
//--AY_HQMV30_ATS_COMPLETION                         HQM_PBUS_CRS : begin // Config Retry
//--AY_HQMV30_ATS_COMPLETION                             iosf_status = Iosf::CRS;
//--AY_HQMV30_ATS_COMPLETION                             iosf_cmd    = Iosf::Cpl;
//--AY_HQMV30_ATS_COMPLETION                         end
//--AY_HQMV30_ATS_COMPLETION                     endcase
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION                     injected_attr = $sformatf("%s IosfSts=%s  Cmd=%s", injected_attr, iosf_status.name(), iosf_cmd.name());
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION                     if ( iosf_status != Iosf::SC ) begin
//--AY_HQMV30_ATS_COMPLETION                         myCpl.first_byte_en = {1'b0, iosf_status};
//--AY_HQMV30_ATS_COMPLETION                         myCpl.cmd = iosf_cmd;
//--AY_HQMV30_ATS_COMPLETION                         myCpl.length = 0;
//--AY_HQMV30_ATS_COMPLETION                     end
//--AY_HQMV30_ATS_COMPLETION                     // Signal that we have consumed a response from this configuration
//--AY_HQMV30_ATS_COMPLETION                     dsaCfgObj.primBusRspObj.signalResponseSent(busRsp);
//--AY_HQMV30_ATS_COMPLETION                     `ovm_info(get_name(), $sformatf("[0x%04h/0x%03h] Custom Rsp Sent: Cpl[%0d] (Injected: %s) on %p", cplArr[0].reqID, cplArr[0].tag, tgt_cpl, injected_attr, busRsp), OVM_LOW)
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION                     // Don't send further completions if they were aborted with a UR/CA/CRS/unsuccessful status
//--AY_HQMV30_ATS_COMPLETION                     if ( iosf_status != Iosf::SC ) begin
//--AY_HQMV30_ATS_COMPLETION `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_COMPLETION                         sendCompletion (slvHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION `else
//--AY_HQMV30_ATS_COMPLETION                         sendCompletion (tgtHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION `endif
//--AY_HQMV30_ATS_COMPLETION                         break;
//--AY_HQMV30_ATS_COMPLETION                     end 
//--AY_HQMV30_ATS_COMPLETION                 end
//--AY_HQMV30_ATS_COMPLETION `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_COMPLETION                 sendCompletion (slvHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION `else
//--AY_HQMV30_ATS_COMPLETION                 sendCompletion (tgtHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION `endif
//--AY_HQMV30_ATS_COMPLETION             end 
//--AY_HQMV30_ATS_COMPLETION         end 
//--AY_HQMV30_ATS_COMPLETION         // for all else, do the default processing...
//--AY_HQMV30_ATS_COMPLETION         else begin: AUTOMATIC_COMPLETION
//--AY_HQMV30_ATS_COMPLETION             // use regular automatic cpl
//--AY_HQMV30_ATS_COMPLETION `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_COMPLETION             slvHandle.buildCplD (tgtTxn, cplArr);
//--AY_HQMV30_ATS_COMPLETION `else
//--AY_HQMV30_ATS_COMPLETION             tgtHandle.buildCplD (tgtTxn, cplArr);
//--AY_HQMV30_ATS_COMPLETION `endif
//--AY_HQMV30_ATS_COMPLETION             while (cplArr.size) begin
//--AY_HQMV30_ATS_COMPLETION                 myCpl = cplArr.pop_front();
//--AY_HQMV30_ATS_COMPLETION                 if (mps2or3Cpl) begin
//--AY_HQMV30_ATS_COMPLETION                     if (dsaCfgObj.memMap.ep_cmp_num == 1) begin
//--AY_HQMV30_ATS_COMPLETION                         myCpl.errorPresent = 'b1;
//--AY_HQMV30_ATS_COMPLETION                         mps2or3Cpl = 'b0;
//--AY_HQMV30_ATS_COMPLETION                     end
//--AY_HQMV30_ATS_COMPLETION                     if (dsaCfgObj.memMap.cto_cmp_num == 1) begin
//--AY_HQMV30_ATS_COMPLETION                         // the environment should have configured the delay in the DsaConfigObj
//--AY_HQMV30_ATS_COMPLETION                         delayed_addr_delay = $urandom_range(dsaCfgObj.memMap.delayed_addr_min_delay,
//--AY_HQMV30_ATS_COMPLETION                             dsaCfgObj.memMap.delayed_addr_max_delay);
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION                         myCpl.parallelDelay = delayed_addr_delay;
//--AY_HQMV30_ATS_COMPLETION                         if (dsaCfgObj.memMap.cto_rsp_ur_ca_sc != IosfPkg::Iosf::SC) begin
//--AY_HQMV30_ATS_COMPLETION                             myCpl.first_byte_en = {1'b0, dsaCfgObj.memMap.cto_rsp_ur_ca_sc}; // UR cpl
//--AY_HQMV30_ATS_COMPLETION                             myCpl.cmd = Iosf::Cpl;
//--AY_HQMV30_ATS_COMPLETION                             myCpl.length = 0;
//--AY_HQMV30_ATS_COMPLETION                         end
//--AY_HQMV30_ATS_COMPLETION 
//--AY_HQMV30_ATS_COMPLETION                         mps2or3Cpl = 'b0;
//--AY_HQMV30_ATS_COMPLETION                         `ovm_info(get_name(), $sformatf( "sent delayed completion by %0d sim timeunits, for addr=0x%0h with mps2or3Cpl = %0d, with cplStatus = %s",
//--AY_HQMV30_ATS_COMPLETION                             delayed_addr_delay, tgtTxn.address, mps2or3Cpl, myCpl.cplStatus.name()), OVM_LOW)
//--AY_HQMV30_ATS_COMPLETION                     end
//--AY_HQMV30_ATS_COMPLETION                     dsaCfgObj.memMap.ep_cmp_num--;
//--AY_HQMV30_ATS_COMPLETION                         dsaCfgObj.memMap.cto_cmp_num--;
//--AY_HQMV30_ATS_COMPLETION                 end // if (mps2or3Cpl...)
//--AY_HQMV30_ATS_COMPLETION `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_COMPLETION                 sendCompletion (slvHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION                 `ovm_info(get_name(), $sformatf( "HQM_IOSF_2019_BFM"), OVM_HIGH)
//--AY_HQMV30_ATS_COMPLETION `else
//--AY_HQMV30_ATS_COMPLETION                 sendCompletion (tgtHandle, myCpl);
//--AY_HQMV30_ATS_COMPLETION `endif
//--AY_HQMV30_ATS_COMPLETION                 if (delayCACpl) begin
//--AY_HQMV30_ATS_COMPLETION `ifdef HQM_IOSF_2019_BFM
//--AY_HQMV30_ATS_COMPLETION                     sendCompletion (slvHandle, saveCACpl);
//--AY_HQMV30_ATS_COMPLETION `else
//--AY_HQMV30_ATS_COMPLETION                     sendCompletion (tgtHandle, saveCACpl);
//--AY_HQMV30_ATS_COMPLETION `endif
//--AY_HQMV30_ATS_COMPLETION                     delayCACpl = 'b0;
//--AY_HQMV30_ATS_COMPLETION                     `ovm_info(get_name(), $sformatf( "sent delayed CA completion"), OVM_LOW)
//--AY_HQMV30_ATS_COMPLETION                 end // if (delayCACpl...)
//--AY_HQMV30_ATS_COMPLETION             end // while (cplArr.size())
//--AY_HQMV30_ATS_COMPLETION         end // else...AUTOMATIC_COMPLETION

        `ovm_info(get_type_name(), $sformatf("HqmIosfMRdCb execute() -- END"), OVM_MEDIUM)
    endfunction : execute


    // -------------------------------------------------------------------------
`ifdef HQM_IOSF_2019_BFM
    function void run_callback_check(IosfAgtSlvTlm slvHandle, IosfTgtTxn tgtTxn);
`else
    function void run_callback_check(IosfAgtTgtTlm slvHandle, IosfTgtTxn tgtTxn);
`endif

        // ERROR CHECK the function arguments! If any are null pointers, we cannot proceed.
        if (!slvHandle) `ovm_fatal(get_type_name(), "execute(): slvHandle is Null!")
        if (!tgtTxn   ) `ovm_fatal(get_type_name(), "execute(): tgtTxn is Null!")

    endfunction


    // -------------------------------------------------------------------------
    // return 1, if addr is within the supplied address range. Otherwise, return 0
    //
    function bit in_range(Iosf::address_t addr, Iosf::address_t base_addr, Iosf::address_t limit, int dw_size = -1);
        if ( dw_size == -1 ) begin
            // Note: This was the 'normal' behavior
            return (addr >= base_addr) && (addr <= (base_addr + limit));
        end else begin
            // Given a valid size, this will check if addr:addr+(dw_size*4) is within the range.
            if ( base_addr != INVALID_ADDR &&
                ((addr >= base_addr) && (addr <= (base_addr + limit)) ||
                ((addr < base_addr)  && ((addr+(dw_size*4)) > base_addr))) )
            begin
                return 1;
            end
            return 0;
        end
    endfunction : in_range


    // -------------------------------------------------------------------------
    function modify_upstream_tlp(IosfTgtTxn txn);

        int count;

        `ovm_info(get_type_name(), "HqmIosfMRdCb modify_upstream_tlp() -- BEGIN --", OVM_LOW)
        `ovm_info(get_type_name(), $sformatf("\ttxn.length = %d", txn.length), OVM_LOW)

        //--TEMP_FOR_DEBUG--// if (txn.cmd inside {Iosf::MRd32, Iosf::MRd64} && txn.length==128 && count<2) begin
            if (count==0) begin
                txn.cmd         = IosfPkg::Iosf::MRd64;
                txn.tat         = 2'b01;
                txn.trqid       = 'h0100;
                txn.tpasidtlp   = {1'b1, 2'b00, 20'h0};
                txn.address     = {txn.address[63:12], 12'h000};
                //txn.address     = 'hA_2000;
            end else if (count==1) begin
                txn.cmd         = IosfPkg::Iosf::MRd64;
                txn.tat         = 2'b01;
                txn.trqid       = 'h0100; //'hBEEF;
                txn.tpasidtlp   = {1'b1, 2'b00, 20'h0};
                txn.address     = {txn.address[63:12], 12'h000};
                //txn.address     = 'hF_2000;
            end
            txn.length = 2; // single translation request

            `ovm_info(get_type_name(), "HqmIosfMRdCb modify_upstream_tlp() ATS Request TLP:", OVM_LOW)
            `ovm_info(get_type_name(), $sformatf("\n%s", txn.sprint()), OVM_LOW)
            `ovm_info(get_type_name(), "HqmIosfMRdCb modify_upstream_tlp() -- END --", OVM_LOW)

            count++;

        //--TEMP_FOR_DEBUG--// end

    endfunction : modify_upstream_tlp


    // -------------------------------------------------------------------------
//    function void form_ats_response(IosfAgtTgtTlm slvHandle, IosfTgtTxn tgtTxn);
   //Made this a task to add delays to support invalidation flow
`ifdef HQM_IOSF_2019_BFM
    task form_ats_response(IosfAgtSlvTlm slvHandle, IosfTgtTxn tgtTxn);
`else
    task form_ats_response(IosfAgtTgtTlm slvHandle, IosfTgtTxn tgtTxn);
`endif   
       IosfTxn           cplArr[$];

       //--AY_HQMV30_ATS_TBD  DsaPrimaryBusRsp_s busRsp;

       // Decode incoming TLP's PASID bus
       HqmPasid_t    pasidtlp;
       HqmAtsPkg::AtsCplSts_t   ats_entry_state, atscpl_status;
       HqmAtsPkg::AtsCplSts_t   ats_status_q [$];
       HqmAtsPkg::PrsRspSts_t   prs_entry_state;
       string                   id_info_string = "";

       int             vpp_num;
       int             pp_num;
       int             pp_type;
       int             vcq_num;
       int             cq_num;
       int             cq_type;
       bit             is_pf;
       int             vf_num;
       int             vas;
       int             decode_ats_request;

       pasidtlp = tgtTxn.tpasidtlp;
       pasidtlp.pasid = (pasidtlp.pasid_en) ? pasidtlp.pasid : 0;

       `ovm_info(get_name(), $sformatf("HqmIosfMRdCb form_ats_response_S0: BEGIN -- pasid_en=%0d pasid=0x%0x", pasidtlp.pasid_en, pasidtlp.pasid), OVM_LOW);

       if (i_hqm_tb_cfg == null) begin
           `ovm_fatal(get_type_name(), "HqmIosfMRdCb form_ats_response_S0: i_hqm_tb_cfg is Null pointer!")
       end
       if (iommu_api == null) begin
           `ovm_fatal(get_type_name(), "HqmIosfMRdCb form_ats_response_S0: API to Address Translation Service is Null pointer! The pending requesting for address translation will fail!")
       end

       // Get IOMMU Address Translation Service API
       this.iommu_api.is_processing_xtl_request = 1'b1;

       if (tgtTxn.length[0]) begin
           `ovm_fatal(get_type_name(), $sformatf("HqmIosfMRdCb form_ats_response_S0: Request for address translation has length=%0d DWs, however the requested number of DWs is required to be even!", tgtTxn.length))
       end

       if ( ! iommu_api.is_device_supported(.bdf(tgtTxn.trqid))) begin
           ats_status_q.push_back(HqmAtsPkg::ATSCPL_UNSUPPORTED_REQUEST);
       end


       // Clear Split Completions Array
       cplArr.delete();

       // auto-generate CplD TLP(s) shell
       slvHandle.buildCplD(tgtTxn, cplArr);

       //-- Find the CQ
       decode_ats_request = i_hqm_tb_cfg.decode_cq_ats_request(tgtTxn.address, tgtTxn.length, cq_num, cq_type, is_pf, vf_num, vcq_num);

       //--ats response errinj types: 1: r=0/w=0; 2: TBD; 3: data parity error; 4: EP=1; 5: completion status CA/UR/CRS);
       if(cq_type) begin
          cq_ats_cpl_errinj_type = i_hqm_tb_cfg.ldb_pp_cq_cfg[cq_num].cq_ats_resp_errinj;          
       end else begin
          cq_ats_cpl_errinj_type = i_hqm_tb_cfg.dir_pp_cq_cfg[cq_num].cq_ats_resp_errinj;          
       end
       `ovm_info(get_name(), $sformatf("HqmIosfMRdCb form_ats_response_S1: Logical Address=0x%016h return decode_ats_request=%0d : is_ldb=%0b cq_num=0x%0x is_pf=%0d vf_num=%0d vcq_num=%0d, cq_ats_cpl_errinj_type=%0d cq_ats_cpl_errinj_ctrl=%0d", tgtTxn.address, decode_ats_request, cq_type, cq_num, is_pf, vf_num, vcq_num, cq_ats_cpl_errinj_type, cq_ats_cpl_errinj_ctrl), OVM_LOW);



       //Check if this ATS_TREQ is due to Invalidation and relocate if needed.
       //--AY_HQMV30_ATS_TBD  find_and_relocate(.bdf(tgtTxn.trqid), .pasidtlp(pasidtlp), .logical_addr({tgtTxn.address[63:12],12'h0}));

       if (cplArr.size()>1) begin
           // Sanity Check!
           // In most cases, there should be only one CplD TLP. However ECN to IOSF Specification for ATS says the following:
           // Translation Requests...may be completed with one, or in smoe cases, two Completions. If a Translation Completion
           // has a Byte Count greater than 4 times the Length field, then 1 additional Translation Completion is required to
           // complete the Translation Request.
           // TODO: Adil: We will only design for 1 Completion for the time being. This may need to be updated later.
           `ovm_error(get_type_name(), $sformatf("form_ats_response: Warning! cplArr.size() != 1 ... cplArr.size() = %0d, LA addr is 0x%h", cplArr.size(),tgtTxn.address))
       end

       if (cplArr[0].data.size() != tgtTxn.length) begin
           // Sanity Check! Data array's size (DW) should be equal to request TLP's length field (DW).
           `ovm_error(get_type_name(), $sformatf("form_ats_response(): Rule violation: cplArr[0].data.size() != tgtTxn.length."))
           ovm_report_info(get_type_name(), $sformatf("HqmIosfMRdCb form_ats_response(): translation request's TLP's request length sould be equal to the Cpl payload size generated by IOSF Primary BFM"), OVM_LOW);
           ovm_report_info(get_type_name(), $sformatf("HqmIosfMRdCb form_ats_response(): \tcplArr[0].data.size() = %0d", cplArr[0].data.size()), OVM_LOW);
           ovm_report_info(get_type_name(), $sformatf("HqmIosfMRdCb form_ats_response(): \ttgtTxn.length         = %0d", tgtTxn.length        ), OVM_LOW);
       end

       //---------------------------------------       
       // AY_HQMV30_ATS_COMPLETION_DELAY_INJ_W0R0
       setATSDelay=$urandom_range(atsMinDelay, atsMaxDelay);//--AY_HQMV30_ATS_REVISIT
       if (setATSDelay>0) begin
           cplArr[0].parallelDelay = get_ats_delay() * 1ns;
           `ovm_info(get_name(), $sformatf("HqmIosfMRdCb Setting translation delay to %t",  cplArr[0].parallelDelay), OVM_HIGH);
       end else begin
           cplArr[0].parallelDelay = 0;
           `ovm_info(get_name(), $sformatf("HqmIosfMRdCb Setting translation delay to %t (0)",  cplArr[0].parallelDelay), OVM_HIGH);
       end

       //---------------------------------------       
       for (int i=0, j=0; i<((tgtTxn.length)>>1); i++, j+=2) begin
           // If address mapping exists, invoke IOMMU address translation
           // on the pasid and effective logical address.
           bit [63:0] translation_status_qw = iommu_api.request_address_translation(.bdf             (tgtTxn.trqid),
                                                                                    .pasidtlp        (pasidtlp),
                                                                                    .logical_address (tgtTxn.address+(i * 'h1000)));     // TODO: Adil: I have to change 'h1000 to STU

           // Data payload must comply with PCIE spec byte ordering depicted in figure 10-12 HSD # 1507378130
           cplArr[0].data[j]   = hqmCfgObj.atsCfg.reverse_dw(translation_status_qw[63:32]);
           cplArr[0].data[j+1] = hqmCfgObj.atsCfg.reverse_dw(translation_status_qw[31: 0]);
           `ovm_info (get_type_name(), $sformatf("HqmIosfMRdCb form_ats_response_S2: i=%0d j=%0d translation_status_qw=0x%0x -> Translated Address=0x%0x : cplArr[0].data[%0d]=0x%0x cplArr[0].data[%0d]=0x%0x", i, j, translation_status_qw, hqmCfgObj.atsCfg.reverse_qw(translation_status_qw[63:0]), j+1, cplArr[0].data[j+1], j, cplArr[0].data[j]), OVM_MEDIUM)

           // AY_HQMV30_ATS_COMPLETION_ERROR_INJ_W0R0
           // R/W bits are in the last byte of the second DW, first two bits
           // Note: this is implemented as an alternate method to 'fail' all ats requests without going through potentially multiple loops in the driver to achieve the same thing
           //-- AY_HQMV30_ATS: 
           if (($urandom_range(atsCplNoRWMaxProb, atsCplNoRWMinProb))  > ($urandom_range(99,0)) ) iosf_cb_ats_cpl_no_rw = 1;
           else                                                                                   iosf_cb_ats_cpl_no_rw = 0;

           //--cq_ats_cpl_errinj_ctrl=1; cq_ats_cpl_errinj_type:: ats response errinj types: 1: r=0/w=0; 2: TBD; 3: data parity error; 4: EP=1; 5: completion status CA/UR/CRS);
           if ((iosf_cb_ats_cpl_no_rw && cq_ats_cpl_errinj_ctrl==0) || (cq_ats_cpl_errinj_type==1 && cq_ats_cpl_errinj_ctrl==1) || (cq_ats_cpl_errinj_type==10 && iosf_cb_ats_cpl_no_rw==1 && cq_ats_cpl_errinj_ctrl==1)) begin
               cplArr[0].data[1][25:24] = 0; //-- W bit is bit 25; R bit is bit 24
              `ovm_info (get_type_name(), $sformatf("HqmIosfMRdCb form_ats_response_S2_errinj: i=%0d j=%0d force .data[1][25:24]=0  to generate W=0 R=0 case - cplArr[0].data[%0d]=0x%0x cplArr[0].data[%0d]=0x%0x", i, j, j+1, cplArr[0].data[j+1], j, cplArr[0].data[j]), OVM_MEDIUM)
           end  

           //--------------------------------------------
           iommu_api.read_entry_state( .bdf            (tgtTxn.trqid),
                                       .pasidtlp       (pasidtlp),
                                       .logical_address(tgtTxn.address+(i * 'h1000)),
                                       .ats_entry_state(ats_entry_state),
                                       .prs_entry_state(prs_entry_state)
                                       );

           ats_status_q.push_back(ats_entry_state);
       end


       atscpl_status = get_atscpl_status ( ats_status_q );

       case ( atscpl_status )
           HqmAtsPkg::ATSCPL_COMPLETER_ABORT: begin
               cplArr.delete();
               cplArr.push_front(null);
               cplArr[0] = slvHandle.buildCpl(tgtTxn);     // pre-populate Cpl response

               // Sanity Check!
               if (cplArr.size()!=1) begin
                   `ovm_error(get_type_name(), $sformatf("form_ats_response(): Specified PASID is nonexistant; cplArr.size()=%0d should be 1!", cplArr.size()))
               end

               cplArr[0].cmd                = IosfPkg::Iosf::Cpl;
               cplArr[0].reqType            = IosfPkg::Iosf::COMPLETION;
               cplArr[0].address[31:16]     = iommu_api.get_bdf();    // Completion ID
               cplArr[0].reqID              = tgtTxn.trqid;           // Destination ID
               cplArr[0].tag                = tgtTxn.ttag;
               cplArr[0].first_byte_en[2:0] = 3'b100;                 // Completion Status: Completer abort (CA)
               cplArr[0].cplStatus          = IosfPkg::Iosf::CA;      // Completer abort
               `ovm_info(get_type_name(), "HqmIosfMRdCb form_ats_response_S2: Unsuccessful Address Translation Completion was formed with translation address payload >", OVM_LOW);
               `ovm_info(get_type_name(), {"\n", cplArr[0].sprint()}, OVM_LOW);
           end

           HqmAtsPkg::ATSCPL_UNSUPPORTED_REQUEST: begin
               cplArr.delete();
               cplArr.push_front(null);
               cplArr[0] = slvHandle.buildCpl(tgtTxn);     // pre-populate Cpl response

               // Sanity Check!
               if (cplArr.size()!=1) begin
                   `ovm_error(get_type_name(), $sformatf("form_ats_response_S2: Specified PASID is nonexistant; cplArr.size()=%0d should be 1!", cplArr.size()))
               end

               cplArr[0].cmd                = IosfPkg::Iosf::Cpl;
               cplArr[0].reqType            = IosfPkg::Iosf::COMPLETION;
               cplArr[0].address[31:16]     = iommu_api.get_bdf();    // Completion ID
               cplArr[0].reqID              = tgtTxn.trqid;           // Destination ID
               cplArr[0].tag                = tgtTxn.ttag;
               cplArr[0].first_byte_en[2:0] = 3'b001;                 // Completion Status: Unsupported Request (UR)
               cplArr[0].cplStatus          = IosfPkg::Iosf::UR;      // Unsupported Request
               `ovm_info(get_type_name(), "HqmIosfMRdCb form_ats_response_S2: Unsuccessful Address Translation Completion was formed with translation address payload >", OVM_LOW);
               `ovm_info(get_type_name(), {"\n", cplArr[0].sprint()}, OVM_LOW);
           end

           HqmAtsPkg::ATSCPL_CTO : begin
               cplArr[0].cmd               = IosfPkg::Iosf::CplD;
               cplArr[0].reqType           = IosfPkg::Iosf::COMPLETION;
               cplArr[0].address[31:16]    = iommu_api.get_bdf();    // Completion ID
               cplArr[0].reqID             = tgtTxn.trqid;           // Destination ID
               cplArr[0].tag               = tgtTxn.ttag;
               cplArr[0].cplStatus         = IosfPkg::Iosf::SC;      // SUCCESS
               //--AY_HQMV30_ATS_REVISIT  cplArr[0].parallelDelay = ($urandom_range(dsaCfgObj.memMap.delayed_addr_min_delay, dsaCfgObj.memMap.delayed_addr_max_delay)) * 1; // *1ns  is removed
               cplArr[0].parallelDelay = ($urandom_range(atsMinDelay, atsMaxDelay)) * 1; // *1ns  is removed
               `ovm_info(get_name(), $sformatf("HqmIosfMRdCb Setting translation delay to %t",  cplArr[0].parallelDelay), OVM_LOW);
               `ovm_info(get_type_name(), $sformatf ("HqmIosfMRdCb form_ats_response_S2: CTO Successful Address Translation Completion with parallelDelay %0t was formed with translation address payload >", cplArr[0].parallelDelay), OVM_LOW);
               `ovm_info(get_type_name(), {"\n", cplArr[0].sprint()}, OVM_LOW);
           end

           HqmAtsPkg::ATSCPL_SUCCESS : begin
               cplArr[0].cmd               = IosfPkg::Iosf::CplD;
               cplArr[0].reqType           = IosfPkg::Iosf::COMPLETION;
               cplArr[0].address[31:16]    = iommu_api.get_bdf();    // Completion ID
               cplArr[0].reqID             = tgtTxn.trqid;           // Destination ID
               cplArr[0].tag               = tgtTxn.ttag;
               cplArr[0].cplStatus         = IosfPkg::Iosf::SC;      // SUCCESS

               `ovm_info(get_type_name(), $sformatf("HqmIosfMRdCb form_ats_response_S2: Successful Address Translation Completion with parallelDelay %0t was formed with translation address payload >", cplArr[0].parallelDelay), OVM_LOW);
               `ovm_info(get_type_name(), {"\n", cplArr[0].sprint()}, OVM_LOW);
           end

           default : `ovm_error(get_type_name(), $sformatf("HqmIosfMRdCb form_ats_response_S2: Unknown case item = %s", atscpl_status.name()))
       endcase
            

       //------------------------------------------------------------------------------ 
       //------------------------------------------------------------------------------ 
       // AY_HQMV30_ATS_COMPLETION_ERROR_INJ_CTRL (pasid, data parity, EP, cmd and status override)
       if (($urandom_range(atsCplErrInjMaxProb, atsCplErrInjMinProb))  > ($urandom_range(99,0)) ) iosf_cb_ats_cpl_errinj = 1;
       else                                                                                       iosf_cb_ats_cpl_errinj = 0;
       iosf_cb_ats_cpl_errinj_pasid  = 0; 
       iosf_cb_ats_cpl_errinj_dpe    = 0; 
       iosf_cb_ats_cpl_errinj_ep     = 0; 
       iosf_cb_ats_cpl_errinj_status = 0 ; 
        
       if(cq_ats_cpl_errinj_ctrl==1) begin
          //--cq_ats_cpl_errinj_ctrl=1; cq_ats_cpl_errinj_type:: ats response errinj types: 1: r=0/w=0; 2: TBD; 3: data parity error; 4: EP=1; 5: completion status CA/UR/CRS);
          if(cq_ats_cpl_errinj_type==0) begin
             iosf_cb_ats_cpl_errinj=0;
            `ovm_info(get_name(), $sformatf("HqmIosfMRdCb form_ats_response_S2.1: Logical Address=0x%016h is_ldb=%0b cq_num=0x%0x, iosf_cb_ats_cpl_errinj=%0d cq_ats_cpl_errinj_type=%0d cq_ats_cpl_errinj_ctrl=%0d", tgtTxn.address, cq_type, cq_num, iosf_cb_ats_cpl_errinj, cq_ats_cpl_errinj_type, cq_ats_cpl_errinj_ctrl), OVM_LOW);
          end else begin
             if(cq_ats_cpl_errinj_type==3 || cq_ats_cpl_errinj_type==10) begin
                      iosf_cb_ats_cpl_errinj_dpe    =  ($urandom_range(atsCplErrInjDPEMax, atsCplErrInjDPEMin) > 0 ) ?  1 : 0;                       
             end

             if(cq_ats_cpl_errinj_type==4 || cq_ats_cpl_errinj_type==10) begin
                      iosf_cb_ats_cpl_errinj_ep     = ($urandom_range(atsCplErrInjEPMax, atsCplErrInjEPMin) > 0 )?  1 : 0;                       
             end

             if(cq_ats_cpl_errinj_type==5 || cq_ats_cpl_errinj_type==10) begin
                      iosf_cb_ats_cpl_errinj_status = $urandom_range(atsCplErrInjSTMax, atsCplErrInjSTMin) ;                       
             end
            `ovm_info(get_name(), $sformatf("HqmIosfMRdCb form_ats_response_S2.1: Logical Address=0x%016h is_ldb=%0b cq_num=0x%0x, iosf_cb_ats_cpl_errinj=%0d cq_ats_cpl_errinj_type=%0d cq_ats_cpl_errinj_ctrl=%0d iosf_cb_ats_cpl_errinj_dpe=%0d iosf_cb_ats_cpl_errinj_ep=%0d iosf_cb_ats_cpl_errinj_status=%0d", tgtTxn.address, cq_type, cq_num, iosf_cb_ats_cpl_errinj, cq_ats_cpl_errinj_type, cq_ats_cpl_errinj_ctrl, iosf_cb_ats_cpl_errinj_dpe, iosf_cb_ats_cpl_errinj_ep, iosf_cb_ats_cpl_errinj_status), OVM_LOW);
          end
       end else begin
          iosf_cb_ats_cpl_errinj_pasid  = ($urandom_range(atsCplErrInjPASIDMax, atsCplErrInjPASIDMin) > 0 )?  1 : 0; 
          iosf_cb_ats_cpl_errinj_dpe    = ($urandom_range(atsCplErrInjDPEMax, atsCplErrInjDPEMin) > 0 ) ?  1 : 0; 
          iosf_cb_ats_cpl_errinj_ep     = ($urandom_range(atsCplErrInjEPMax, atsCplErrInjEPMin) > 0 )?  1 : 0; 
          iosf_cb_ats_cpl_errinj_status = $urandom_range(atsCplErrInjSTMax, atsCplErrInjSTMin) ; 
       end 

       `ovm_info(get_name(), $sformatf("HqmIosfMRdCb form_ats_response_S2.2: Logical Address=0x%016h is_ldb=%0b cq_num=0x%0x, iosf_cb_ats_cpl_errinj=%0d cq_ats_cpl_errinj_type=%0d cq_ats_cpl_errinj_ctrl=%0d iosf_cb_ats_cpl_errinj_dpe=%0d iosf_cb_ats_cpl_errinj_ep=%0d iosf_cb_ats_cpl_errinj_status=%0d", tgtTxn.address, cq_type, cq_num, iosf_cb_ats_cpl_errinj, cq_ats_cpl_errinj_type, cq_ats_cpl_errinj_ctrl, iosf_cb_ats_cpl_errinj_dpe, iosf_cb_ats_cpl_errinj_ep, iosf_cb_ats_cpl_errinj_status), OVM_LOW);


       if(iosf_cb_ats_cpl_errinj==1 && (iosf_cb_ats_cpl_errinj_dpe>0 || iosf_cb_ats_cpl_errinj_ep>0 || iosf_cb_ats_cpl_errinj_status>0)) begin
           string              injected_attr = "";
           Iosf::iosf_cmd_t    iosf_cmd = Iosf::CplD;
           Iosf::iosf_status_t iosf_status = Iosf::SC;

           if(iosf_cb_ats_cpl_errinj_pasid==1) begin
              bit [22:0]          pasidtlp; 
               void'(std::randomize(pasidtlp) with {pasidtlp[22] == 1;}); // Randomize a PASID to inject to the completion
               cplArr[0].pasidtlp = pasidtlp;
               injected_attr = $sformatf("%s PASIDTLP=0x%06h", injected_attr, pasidtlp);
           end else if(iosf_cb_ats_cpl_errinj_dpe) begin
               cplArr[0].driveBadDataParity = 1;
               cplArr[0].driveBadDataParityCycle = 1;
               injected_attr = $sformatf("%s DPE=1", injected_attr);
           end else if(iosf_cb_ats_cpl_errinj_ep) begin
               cplArr[0].errorPresent = 1;
               injected_attr = $sformatf("%s EP=1", injected_attr);
           end else begin
           end

           if(iosf_cb_ats_cpl_errinj_status>0) begin
               case(iosf_cb_ats_cpl_errinj_status)
                 1 : begin // Completer Abort
                   iosf_status = Iosf::CA;
                   iosf_cmd    = Iosf::Cpl;
                 end
                 2 : begin // Unsupported Request
                   iosf_status = Iosf::UR;
                   iosf_cmd    = Iosf::Cpl;
                 end
                 3 : begin // Config Retry
                   iosf_status = Iosf::CRS;
                   iosf_cmd    = Iosf::Cpl;
                 end
              endcase
              if ( iosf_status != Iosf::SC ) begin
                 cplArr[0].first_byte_en = {1'b0, iosf_status};
                 cplArr[0].cmd = iosf_cmd;
                 cplArr[0].length = 0;
              end
           end 


           i_hqm_tb_cfg.hqm_alarm_issued = 0; //--clear hqm_alarm_issued before ATS_RESP ERRINJ
           if(cq_type) begin
              i_hqm_tb_cfg.ldb_pp_cq_cfg[cq_num].cq_ats_resp_errinj_st=1;
              i_hqm_tb_cfg.ldb_pp_cq_cfg[cq_num].cq_ats_inv_ctrl=2;

              if($test$plusargs("HQMV30_VASRST_TRFCTRL_0")) begin
                 i_hqm_tb_cfg.hqmproc_ldb_trfctrl[cq_num] = 0;
                `ovm_info(get_name(), $sformatf("HqmIosfMRdCb form_ats_response_S2.3: set hqm_tb_cfg.hqmproc_ldb_trfctrl[%0d]=0 ldb_pp_cq_cfg[%0d].cq_ats_resp_errinj_st=%0d cq_ats_inv_ctrl=2 - hqm_tb_cfg.hqm_alarm_issued=%0d clear", cq_num, cq_num, i_hqm_tb_cfg.ldb_pp_cq_cfg[cq_num].cq_ats_resp_errinj_st, i_hqm_tb_cfg.hqm_alarm_issued), OVM_LOW);
              end else begin
                `ovm_info(get_name(), $sformatf("HqmIosfMRdCb form_ats_response_S2.3: set ldb_pp_cq_cfg[%0d].cq_ats_resp_errinj_st=%0d cq_ats_inv_ctrl=2 - hqm_tb_cfg.hqm_alarm_issued=%0d clear", cq_num, i_hqm_tb_cfg.ldb_pp_cq_cfg[cq_num].cq_ats_resp_errinj_st, i_hqm_tb_cfg.hqm_alarm_issued), OVM_LOW);
              end
           end else begin
              i_hqm_tb_cfg.dir_pp_cq_cfg[cq_num].cq_ats_resp_errinj_st=1;
              i_hqm_tb_cfg.dir_pp_cq_cfg[cq_num].cq_ats_inv_ctrl=2;

              if($test$plusargs("HQMV30_VASRST_TRFCTRL_0")) begin 
                  i_hqm_tb_cfg.hqmproc_dir_trfctrl[cq_num] = 0;
                 `ovm_info(get_name(), $sformatf("HqmIosfMRdCb form_ats_response_S2.3: set hqm_tb_cfg.hqmproc_dir_trfctrl[%0d]=0 dir_pp_cq_cfg[%0d].cq_ats_resp_errinj_st=%0d cq_ats_inv_ctrl=2 - hqm_tb_cfg.hqm_alarm_issued=%0d clear", cq_num, cq_num, i_hqm_tb_cfg.dir_pp_cq_cfg[cq_num].cq_ats_resp_errinj_st, i_hqm_tb_cfg.hqm_alarm_issued), OVM_LOW);
              end else begin
                 `ovm_info(get_name(), $sformatf("HqmIosfMRdCb form_ats_response_S2.3: set dir_pp_cq_cfg[%0d].cq_ats_resp_errinj_st=%0d cq_ats_inv_ctrl=2 - hqm_tb_cfg.hqm_alarm_issued=%0d clear",  cq_num, i_hqm_tb_cfg.dir_pp_cq_cfg[cq_num].cq_ats_resp_errinj_st, i_hqm_tb_cfg.hqm_alarm_issued), OVM_LOW);
              end
           end

           injected_attr = $sformatf("%s IosfSts=%s  Cmd=%s", injected_attr, iosf_status.name(), iosf_cmd.name());
           //`ovm_info(get_name(), $sformatf("HqmIosfMRdCb form_ats_response(): [0x%04h/0x%03h] Custom ATS Rsp Sent: (Injected: %s) on %p", cplArr[0].reqID, cplArr[0].tag, injected_attr, cplArr[0]), OVM_LOW);
           `ovm_info(get_name(), $sformatf("HqmIosfMRdCb form_ats_response_S3_errinj: [0x%04h/0x%03h] Ready to sendCompletion with ERRINJ to is_ldb=%0d cq=%0d - Custom ATS Rsp Sent: (Injected: %s)", cplArr[0].reqID, cplArr[0].tag, cq_type, cq_num, injected_attr), OVM_LOW);

       end else begin
           `ovm_info(get_name(), $sformatf("HqmIosfMRdCb form_ats_response_S3: [0x%04h/0x%03h] Ready to sendCompletion with NOERRINJ ", cplArr[0].reqID, cplArr[0].tag), OVM_LOW);
       end //--if(iosf_cb_ats_cpl_errinj==1


        if (hqmCfgObj.atsCfg.run_iommu_ats_selftest || $test$plusargs("HQMV30_ATS_IOSFCB_SEND_TEST")) begin
            `ovm_info(get_type_name(), $sformatf("HqmIosfMRdCb ATS_SELFTEST: \n%s",
                cplArr[0].sprint()), OVM_LOW)
        end else begin
           `ovm_info(get_type_name(), $sformatf("HqmIosfMRdCb form_ats_response_S4: To sendCompletion"), OVM_LOW);
            sendCompletion(slvHandle, cplArr[0]); // Send Response TLP to calling subroutine
        end

        this.iommu_api.is_processing_xtl_request = 1'b0;
        this.iommu_api.has_finished_xtl_req_cpl  = 1'b1;

        `ovm_info(get_type_name(), "HqmIosfMRdCb form_ats_response_S5: END", OVM_LOW)

    endtask : form_ats_response


    // -------------------------------------------------------------------------
    function int get_ats_delay();
        int val;
        //--TMP return $urandom_range(dsaCfgObj.atsMinDelay, dsaCfgObj.atsMaxDelay);
        val = $urandom_range(atsMinDelay, atsMaxDelay);
        return val; //$urandom_range(atsMinDelay, atsMaxDelay);
    endfunction



    // -------------------------------------------------------------------------
    function HqmAtsPkg::AtsCplSts_t get_atscpl_status(HqmAtsPkg::AtsCplSts_t entry_state_q[$]);

        entry_state_q = entry_state_q.unique();

        if ( HqmAtsPkg::ATSCPL_COMPLETER_ABORT inside { entry_state_q } ) begin

            `ovm_info(get_name(), $sformatf("get_atscpl_status(): ATSCPL_COMPLETER_ABORT" ), OVM_LOW)
            return HqmAtsPkg::ATSCPL_COMPLETER_ABORT;

        end else if ( HqmAtsPkg::ATSCPL_UNSUPPORTED_REQUEST inside { entry_state_q } ) begin

            `ovm_info(get_name(), $sformatf("get_atscpl_status(): ATSCPL_UNSUPPORTED_REQUEST" ), OVM_LOW)
            return HqmAtsPkg::ATSCPL_UNSUPPORTED_REQUEST;

        end else if ( HqmAtsPkg::ATSCPL_SUCCESS inside { entry_state_q } ) begin

            `ovm_info(get_name(), $sformatf("get_atscpl_status(): ATSCPL_SUCCESS" ), OVM_LOW)
            return HqmAtsPkg::ATSCPL_SUCCESS;
        end else if ( HqmAtsPkg::ATSCPL_CTO inside { entry_state_q } ) begin

            `ovm_info(get_name(), $sformatf("get_atscpl_status(): ATSCPL_CTO" ), OVM_LOW)
            return HqmAtsPkg::ATSCPL_CTO;

        end else begin

            foreach ( entry_state_q[i] ) begin
                `ovm_error(get_name(), $sformatf("get_atscpl_status(): urecognized value entry_state_q[%0d] = %s", i, entry_state_q[i].name() ) )
            end
        end

    endfunction

//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP     // -------------------------------------------------------------------------
//--AY_HQMV30_ATS_TMP     function HqmAtsPkg::PrsRspSts_t get_prsrsp_status(HqmAtsPkg::PrsRspSts_t entry_state_q[$]);
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP         entry_state_q = entry_state_q.unique();
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP         if ( HqmAtsPkg::PRSRSP_RESPONSE_FAILURE inside { entry_state_q } ) begin
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             `ovm_info(get_name(), $sformatf("get_prsrsp_status(): PRSRSP_RESPONSE_FAILURE" ), OVM_LOW)
//--AY_HQMV30_ATS_TMP             return HqmAtsPkg::PRSRSP_RESPONSE_FAILURE;
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP         end else if ( HqmAtsPkg::PRSRSP_INVALID_REQUEST inside { entry_state_q } ) begin
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             `ovm_info(get_name(), $sformatf("get_prsrsp_status(): PRSRSP_INVALID_REQUEST" ), OVM_LOW)
//--AY_HQMV30_ATS_TMP             return HqmAtsPkg::PRSRSP_INVALID_REQUEST;
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP         end else if ( HqmAtsPkg::PRSRSP_INVALID_PRGI inside { entry_state_q } ) begin
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             `ovm_info(get_name(), $sformatf("get_prsrsp_status(): PRSRSP_INVALID_PRGI" ), OVM_LOW)
//--AY_HQMV30_ATS_TMP             return HqmAtsPkg::PRSRSP_INVALID_PRGI;
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP         end else if ( HqmAtsPkg::PRSRSP_SUCCESS inside { entry_state_q } ) begin
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             `ovm_info(get_name(), $sformatf("get_prsrsp_status(): PRSRSP_SUCCESS" ), OVM_LOW)
//--AY_HQMV30_ATS_TMP             return HqmAtsPkg::PRSRSP_SUCCESS;
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP         end else begin
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             foreach ( entry_state_q[i] ) begin
//--AY_HQMV30_ATS_TMP                 `ovm_error(get_name(), $sformatf("get_prsrsp_status(): urecognized value entry_state_q[%0d] = %s",
//--AY_HQMV30_ATS_TMP                     i, entry_state_q[i].name()));
//--AY_HQMV30_ATS_TMP             end
//--AY_HQMV30_ATS_TMP         end
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP     endfunction
 
 
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
     // UTILITY TO SEND COMPLETION ACROSS ON THE MASTER SIDE:
`ifdef HQM_IOSF_2019_BFM
    function void sendCompletion (IosfAgtSlvTlm slvHandle,
`else
    function void sendCompletion (IosfAgtTgtTlm slvHandle,
`endif
        IosfTxn cplTxn);


        IosfTxn cloneTxn;
        int cplQIdx;
        bit usedTag;
        cplTxn.timeStamp = $time;
        cplTxn.orderStamp = slvHandle.qHandle.orderStamp;
        $cast(cloneTxn, cplTxn.clone());

       //--anyan_ck
       `ovm_info(get_type_name(),$psprintf("HqmIosfMRdCb sendCompletion_Start - Txn.reqType=%0s length=%0d parallelDelay=%0t", cloneTxn.reqType.name, cloneTxn.length, cloneTxn.parallelDelay),OVM_LOW)  
        for(int i=0; i<cloneTxn.length; i++) begin
           `ovm_info(get_type_name(),$psprintf("HqmIosfMRdCb sendCompletion_S1: Txn.reqType=%0s length=%0d data[%0d]=0x%0x", cloneTxn.reqType.name, cloneTxn.length, i, cloneTxn.data[i]),OVM_LOW)  
        end

 
        if (cloneTxn.reqType != Iosf::getReqTypeFromCmd(cloneTxn.cmd)) begin
            `ovm_error(get_type_name(), $sformatf("HqmIosfMRdCb sendCompletion: Txn.reqType=%0s is mismatched with Txn.cmd=%0s",
                cloneTxn.reqType.name, cloneTxn.cmd.name))
        end

        // Out-of-order completions:
        disable_ooo_ats_cpl = (($urandom_range(atsCplOOOMax, atsCplOOOMin)) > 0)? 0 : 1;
       `ovm_info(get_type_name(),$psprintf("HqmIosfMRdCb sendCompletion_S2 - slvHandle.iosfAgtCfg.outOfOrderCompletions=%0d disable_ooo_ats_cpl=%0d slvHandle.qHandle.cQueue[0x%0x].q.size=%0d ", slvHandle.iosfAgtCfg.outOfOrderCompletions, disable_ooo_ats_cpl, cplTxn.reqChId, slvHandle.qHandle.cQueue[cplTxn.reqChId].q.size()),OVM_LOW)  
        if (slvHandle.qHandle.cQueue[cplTxn.reqChId].q.size() &&
            //(cplTxn.reqChId == 2) &&
            slvHandle.iosfAgtCfg.outOfOrderCompletions &&
            !disable_ooo_ats_cpl )
        begin
            usedTag = 0;
            // First find out if the {reqID, tag} is already used:
            for (int i=0; i<=(slvHandle.qHandle.cQueue[cplTxn.reqChId].q.size() - 1); i++) begin
                if ((slvHandle.qHandle.cQueue[cplTxn.reqChId].q[i].reqID == cloneTxn.reqID) &&
                    (slvHandle.qHandle.cQueue[cplTxn.reqChId].q[i].tag== cloneTxn.tag)) begin
                    usedTag = 1;
                    break;
                end
            end

            `ovm_info(get_type_name(),$psprintf("HqmIosfMRdCb sendCompletion_S3 - Allow OOO slvHandle.qHandle.cQueue[0x%0x].q.size=%0d usedTag=%0d", cplTxn.reqChId, slvHandle.qHandle.cQueue[cplTxn.reqChId].q.size(), usedTag),OVM_LOW)  

            // If the tag is already in use, the completion cannot go out-of-order:
            if (usedTag) begin
                int upperIdx;
                upperIdx = -1;
                for (int i=(slvHandle.qHandle.cQueue[cplTxn.reqChId].q.size() - 1); i>=0; i-- ) begin
                    if ((slvHandle.qHandle.cQueue[cplTxn.reqChId].q[i].tag == cloneTxn.tag) &&
                        (!slvHandle.qHandle.cQueue[cplTxn.reqChId].q[i].sent))
                    begin
                        upperIdx =i;
                        break;
                    end
                end

                if (upperIdx != -1) begin
                    cplQIdx = $urandom_range(upperIdx +1, (slvHandle.qHandle.cQueue[cplTxn.reqChId].q.size() ));

                    //entering the cpl behind last position of same tag
                    slvHandle.qHandle.cQueue[cplTxn.reqChId].q.insert(cplQIdx, cloneTxn);
                    for (int i=cplQIdx; i<=(slvHandle.qHandle.cQueue[cplTxn.reqChId].q.size()-2); i++) begin
                        longint unsigned tmp;
                        tmp = slvHandle.qHandle.cQueue[cplTxn.reqChId].q[i].orderStamp;
                        slvHandle.qHandle.cQueue[cplTxn.reqChId].q[i].orderStamp
                            = slvHandle.qHandle.cQueue[cplTxn.reqChId].q[i+1].orderStamp;
                        slvHandle.qHandle.cQueue[cplTxn.reqChId].q[i+1].orderStamp
                            = tmp;
                    end
                end
                else begin
                    slvHandle.qHandle.cQueue[cplTxn.reqChId].q.push_back (cloneTxn);
                end
                // Otherwise, send the completion out of order:
            end
            else begin
                int lowerIdx;
                // Find lowest index of non-sent completion requests in the queue:
                lowerIdx = -1;
                for (int i=0; i<=(slvHandle.qHandle.cQueue[cplTxn.reqChId].q.size() - 1); i++) begin
                    if (!slvHandle.qHandle.cQueue[cplTxn.reqChId].q[i].sent) begin
                        lowerIdx = i;
                        break;
                    end
                end

                // Find a random index between the very first non-sent cpl and
                // the last one in the queue, then insert the new cpl in that index
                if (lowerIdx != -1) begin
                    //Pick a random index in the cpl Q
                    cplQIdx = $urandom_range(lowerIdx, (slvHandle.qHandle.cQueue[cplTxn.reqChId].q.size()));
                    //And insert the cpl inside the Q
                    slvHandle.qHandle.cQueue[cplTxn.reqChId].q.insert(cplQIdx, cloneTxn);
                    for (int i=cplQIdx; i<=(slvHandle.qHandle.cQueue[cplTxn.reqChId].q.size()-2); i++) begin
                        longint unsigned tmp;
                        tmp = slvHandle.qHandle.cQueue[cplTxn.reqChId].q[i].orderStamp;

                        slvHandle.qHandle.cQueue[cplTxn.reqChId].q[i].orderStamp
                            = slvHandle.qHandle.cQueue[cplTxn.reqChId].q[i+1].orderStamp;

                        slvHandle.qHandle.cQueue[cplTxn.reqChId].q[i+1].orderStamp
                            = tmp;
                    end
                end
                // If all completion requests have been sent,
                    // just push it to the back of queue:
                else begin
                    slvHandle.qHandle.cQueue[cplTxn.reqChId].q.push_back (cloneTxn);
                end
            end
        end

        // In-order completions or queue empty, push to the back of queue:
        else begin
            `ovm_info(get_type_name(),$psprintf("HqmIosfMRdCb sendCompletion_S3 - InOrderCompletion "),OVM_LOW)  
            slvHandle.qHandle.cQueue[cplTxn.reqChId].q.push_back (cloneTxn);
        end
        slvHandle.qHandle.txnInQ = 1;
        if (slvHandle.qHandle.orderStamp != 64'hffff_ffff_ffff_fffe)
            slvHandle.qHandle.orderStamp++;
        else slvHandle.qHandle.orderStamp = 1; // wrap around
    endfunction: sendCompletion


    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
//--AY_HQMV30_ATS_TMP     task find_and_relocate(bit [15:0] bdf, DsaCommonPkg::DsaPasid_t pasidtlp, bit [63:0] logical_addr);
//--AY_HQMV30_ATS_TMP         bit                          found_item_utilizing_addr = 0;
//--AY_HQMV30_ATS_TMP         DsaPage                      page = null;
//--AY_HQMV30_ATS_TMP         DsaPage                      tmp_page = null;
//--AY_HQMV30_ATS_TMP         DsaPageTable                 pageTable;
//--AY_HQMV30_ATS_TMP         DsaDescProcessor             desc_proc_relocate;
//--AY_HQMV30_ATS_TMP         DsaDescProcessorMemoryMove   desc_memmove_proc_relocate;
//--AY_HQMV30_ATS_TMP         DsaDescProcessor             desc_proc_relocate_arr[$], desc_proc_arr[$], parent_batch_arr[$];
//--AY_HQMV30_ATS_TMP         DsaDescItemGeneric           item;
//--AY_HQMV30_ATS_TMP         DsaCommonPkg::Err_Inj_Type_t dp_err_inj;
//--AY_HQMV30_ATS_TMP         int item_index[$];
//--AY_HQMV30_ATS_TMP         bit[4:0] ireq_itag;
//--AY_HQMV30_ATS_TMP         ovm_event_pool ev_pool  = ovm_event_pool::get_global_pool();
//--AY_HQMV30_ATS_TMP         ovm_event      ats_irsp_ev;
//--AY_HQMV30_ATS_TMP         string         ev_name;
//--AY_HQMV30_ATS_TMP         string desc_id_info_bm_string;
//--AY_HQMV30_ATS_TMP         bit dp_prs_page_relocation_or = 0;
//--AY_HQMV30_ATS_TMP         bit dp_bof_flag_or = 1;
//--AY_HQMV30_ATS_TMP         bit dp_uta_or;
//--AY_HQMV30_ATS_TMP         bit dp_num_bytes_overlap_or;
//--AY_HQMV30_ATS_TMP         string                 header ; 
//--AY_HQMV30_ATS_TMP         `ovm_info(get_type_name(), $sformatf("find_and_relocate(): Looking for the page %h in the pageTable backup with pasidtlp=0x%p pasid=%h, pasid_en=%h",
//--AY_HQMV30_ATS_TMP             logical_addr, pasidtlp, pasidtlp.pasid, pasidtlp.pasid_en), OVM_LOW)
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP         pageTable = vmm.backupPageTable.find_page_table_with_pasid(pasidtlp);
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP         if ( pageTable != null ) begin
//--AY_HQMV30_ATS_TMP             page = pageTable.get_page_by_address(logical_addr);
//--AY_HQMV30_ATS_TMP         end
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP         if (page != null) begin
//--AY_HQMV30_ATS_TMP             DsaPagePermissions_t permissions = page.get_page_permissions();
//--AY_HQMV30_ATS_TMP             string               id_info_string_arr[$] = DsaPageUtils::get_all_page_desc_id_info(page);
//--AY_HQMV30_ATS_TMP             DsaOpFlags_t         op_flags;
//--AY_HQMV30_ATS_TMP             
//--AY_HQMV30_ATS_TMP             header  = $sformatf("[LA=0x%h],[PASID=0x%h] ,[PASID_EN=%b], [U=%b]",logical_addr,pasidtlp.pasid,pasidtlp.pasid_en,permissions.untranslated );
//--AY_HQMV30_ATS_TMP             
//--AY_HQMV30_ATS_TMP             `ovm_info(get_type_name(), $sformatf("find_and_relocate(): Found the pageTable backup table %s", header), OVM_LOW)
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             foreach (id_info_string_arr[i]) begin
//--AY_HQMV30_ATS_TMP                 desc_proc_arr = acl_driver.find_descriptor_proc_arr(id_info_string_arr[i]);
//--AY_HQMV30_ATS_TMP                 `ovm_info(get_type_name(), $sformatf("find_and_relocate(): id_info_string=%s, desc_proc_arr size is %d", id_info_string_arr[i], desc_proc_arr.size()), OVM_DEBUG)
//--AY_HQMV30_ATS_TMP                 if (desc_proc_arr.size() > 0) begin
//--AY_HQMV30_ATS_TMP                     desc_proc_relocate_arr.push_back(desc_proc_arr[0]);
//--AY_HQMV30_ATS_TMP                 end
//--AY_HQMV30_ATS_TMP             end
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             if (desc_proc_relocate_arr.size() == 0) begin
//--AY_HQMV30_ATS_TMP                 // If There was an invalidation with bigger size and Driver has not finished adding all items to item_mngr then
//--AY_HQMV30_ATS_TMP                 // there could be a first time ATS request which might not exist in item_arr but exist in back up table
//--AY_HQMV30_ATS_TMP                 // There could be a significant delay between Driver sending descriptor to DUT and finally adding it to item_mngr.
//--AY_HQMV30_ATS_TMP                 // `ovm_error(get_type_name(), $sformatf("find_and_relocate(): Unexpected Error: could not find a desc_proc with id_info_string = %s", id_info_string))
//--AY_HQMV30_ATS_TMP                 return;
//--AY_HQMV30_ATS_TMP             end
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             desc_proc_relocate = desc_proc_relocate_arr[0];
//--AY_HQMV30_ATS_TMP             `ovm_info(get_type_name(), $sformatf("find_and_relocate():id_info_string_arr[0]=%s, desc_proc_relocate_arr size is %d", id_info_string_arr[0], desc_proc_relocate_arr.size()), OVM_LOW)
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             foreach (desc_proc_relocate_arr[i]) begin
//--AY_HQMV30_ATS_TMP                 op_flags = desc_proc_relocate_arr[i].get_desc_op_flags();
//--AY_HQMV30_ATS_TMP                 `ovm_info(get_type_name(), $sformatf("find_and_relocate():dp_prs_page_relocation for item=%0d, is %d, bof_flag=%h",
//--AY_HQMV30_ATS_TMP                     i, desc_proc_relocate_arr[i].dp_prs_page_relocation, op_flags.block_on_fault), OVM_DEBUG)
//--AY_HQMV30_ATS_TMP                 dp_prs_page_relocation_or |= desc_proc_relocate_arr[i].dp_prs_page_relocation;
//--AY_HQMV30_ATS_TMP                 dp_uta_or                 |= desc_proc_relocate_arr[i].dp_use_transitory_allocation;
//--AY_HQMV30_ATS_TMP                 
//--AY_HQMV30_ATS_TMP                 if($cast(desc_memmove_proc_relocate,desc_proc_relocate_arr[i])) begin
//--AY_HQMV30_ATS_TMP                     dp_num_bytes_overlap_or |= desc_memmove_proc_relocate.dp_num_bytes_overlap;
//--AY_HQMV30_ATS_TMP                 end
//--AY_HQMV30_ATS_TMP                 
//--AY_HQMV30_ATS_TMP                     
//--AY_HQMV30_ATS_TMP                 if (desc_proc_relocate_arr[i].get_opcode() inside {OPCODE_NOOP, OPCODE_BATCH, OPCODE_DRAIN}) begin
//--AY_HQMV30_ATS_TMP                 `ovm_info(get_type_name(), $sformatf("find_and_relocate():Implicit BOF for opcode =%s",desc_proc_relocate_arr[i].get_opcode()  ), OVM_LOW)
//--AY_HQMV30_ATS_TMP                 end 
//--AY_HQMV30_ATS_TMP                 else begin
//--AY_HQMV30_ATS_TMP                     dp_bof_flag_or &= op_flags.block_on_fault;
//--AY_HQMV30_ATS_TMP                 end
//--AY_HQMV30_ATS_TMP             end
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             `ovm_info(get_type_name(), $sformatf("find_and_relocate(): id_info_string = %s, dp_bof_flag_or=%b, dp_prs_page_relocation_or=%b,dp_uta_or=%b,dp_num_bytes_overlap_or=%b",
//--AY_HQMV30_ATS_TMP                 desc_proc_relocate.dp_id_info_string, dp_bof_flag_or, dp_prs_page_relocation_or,dp_uta_or,dp_num_bytes_overlap_or), OVM_LOW)
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             // Page was found in backup table but  INV has not reached to HW. So just wait for some time to make sure RTL has received IREQ otherwise we fall out of sync.
//--AY_HQMV30_ATS_TMP             if ((!dsa_analysis_checker.inv_addr_q_entry_exists(.address(logical_addr), .pasidtlp(pasidtlp.pasid))) && (desc_proc_relocate.dp_unexpected_partial_cpl_is_ok)) begin
//--AY_HQMV30_ATS_TMP            // if ((!dsa_analysis_checker.inv_addr_q_entry_exists(.address(logical_addr), .pasidtlp(pasidtlp.pasid)))) begin
//--AY_HQMV30_ATS_TMP                 `ovm_info(get_type_name(), $sformatf("find_and_relocate(): INV req has not been sent for id_info_string=%s",
//--AY_HQMV30_ATS_TMP                     id_info_string_arr[0]), OVM_LOW)
//--AY_HQMV30_ATS_TMP                 return;
//--AY_HQMV30_ATS_TMP             end
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             // TODO: I am protecting this with 'desc_proc_relocate != null' I
//--AY_HQMV30_ATS_TMP             // think someone needs to go through the code an see how
//--AY_HQMV30_ATS_TMP             // id_info_string_arr[i] gets populated if the fault occurs on
//--AY_HQMV30_ATS_TMP             // processing of a batch member.
//--AY_HQMV30_ATS_TMP             if ( desc_proc_relocate != null ) begin
//--AY_HQMV30_ATS_TMP                 `ovm_info(get_type_name(), $sformatf("find_and_relocate(): err_type is %s, prs_page_relocation =%0b", desc_proc_relocate.dp_err_inj, dp_prs_page_relocation_or), OVM_LOW)
//--AY_HQMV30_ATS_TMP             end
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             if ( (desc_proc_relocate != null) && (!dp_prs_page_relocation_or) && (permissions.untranslated == 0) ) begin
//--AY_HQMV30_ATS_TMP                 bit [15:0] reqid = dsaCfgObj.getReqId(0);
//--AY_HQMV30_ATS_TMP                 bit        is_a_dest_page = 0;
//--AY_HQMV30_ATS_TMP                 bit        is_a_cpl_page  = 0;
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP                 //// wait some time for  MWr data phase to complete. if VMM relocates too quickly, it will miss data from the last transfer
//--AY_HQMV30_ATS_TMP                 // ?? ANy other way to do this 
//--AY_HQMV30_ATS_TMP                 #100ns;
//--AY_HQMV30_ATS_TMP                 
//--AY_HQMV30_ATS_TMP                 ireq_itag = dsa_analysis_checker.find_inv_itag(logical_addr, pasidtlp);
//--AY_HQMV30_ATS_TMP                 ev_name  = $sformatf("%s__itag_%0d", HqmAtsPkg::HQM_ATS_IRSP_E, ireq_itag);
//--AY_HQMV30_ATS_TMP                 ats_irsp_ev = ev_pool.get(ev_name);
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP                 is_a_dest_page = is_this_a_dest_page(desc_proc_relocate, logical_addr);
//--AY_HQMV30_ATS_TMP                 is_a_cpl_page  = is_this_a_cpl_page(desc_proc_relocate, logical_addr);
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP                 
//--AY_HQMV30_ATS_TMP                 `ovm_info(get_type_name(), $sformatf("find_and_relocate(): %s,  ireq_itag = %0h, itag_outstanding = %b, dp_partial_cpl_is_fine=%0d,is_a_dest_page=%d,is_a_cpl_page=%d",header,
//--AY_HQMV30_ATS_TMP                                                           ireq_itag,dsa_analysis_checker.inv_reqrsp[reqid][ireq_itag].outstanding, desc_proc_relocate.dp_unexpected_partial_cpl_is_ok,is_a_dest_page,is_a_cpl_page), OVM_LOW)
//--AY_HQMV30_ATS_TMP                 // wait for INV RSP before relocating the page
//--AY_HQMV30_ATS_TMP                 // Wait for INV rsp only if page belongs to a DST/CPl. SW modeling to deal with MEM access during INV REQ-RSP window.
//--AY_HQMV30_ATS_TMP                 if (dsa_analysis_checker.inv_reqrsp[reqid][ireq_itag].outstanding && (dp_uta_or || dp_num_bytes_overlap_or || desc_proc_relocate.dp_unexpected_partial_cpl_is_ok || is_a_dest_page || is_a_cpl_page)) begin
//--AY_HQMV30_ATS_TMP                     `ovm_info(get_type_name(), $sformatf("find_and_relocate():%s,  waiting for IRSP with ireq_itag = %0h, dp_partial_cpl_is_fine=%0d, is_a_dest_page=%0d, is_a_cpl_page=%0d",header,
//--AY_HQMV30_ATS_TMP                                                           ireq_itag, desc_proc_relocate.dp_unexpected_partial_cpl_is_ok, is_a_dest_page, is_a_cpl_page), OVM_LOW)
//--AY_HQMV30_ATS_TMP                     ats_irsp_ev.wait_trigger();
//--AY_HQMV30_ATS_TMP                     ats_irsp_ev.reset();
//--AY_HQMV30_ATS_TMP                     `ovm_info(get_type_name(), $sformatf("find_and_relocate():%s,  Done waiting for IRSP with ireq_itag = %0h",header, ireq_itag), OVM_LOW)
//--AY_HQMV30_ATS_TMP                 end
//--AY_HQMV30_ATS_TMP                 `ovm_info(get_type_name(), $sformatf("find_and_relocate():Start relocating page %s",header), OVM_LOW)
//--AY_HQMV30_ATS_TMP                 vmm.set_acl_driver(acl_driver);
//--AY_HQMV30_ATS_TMP                 vmm.relocate( .bdf(bdf), .pasidtlp(pasidtlp), .v_addr(logical_addr));
//--AY_HQMV30_ATS_TMP             end
//--AY_HQMV30_ATS_TMP             else if ( (desc_proc_relocate != null) && (!dp_prs_page_relocation_or) && (permissions.untranslated == 1) ) begin
//--AY_HQMV30_ATS_TMP                 vmm.set_acl_driver(acl_driver);
//--AY_HQMV30_ATS_TMP                 vmm.restore_fault_page( .bdf(bdf), .pasidtlp(pasidtlp), .v_addr(logical_addr));
//--AY_HQMV30_ATS_TMP             end
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP             desc_proc_relocate_arr.delete();
//--AY_HQMV30_ATS_TMP         end
//--AY_HQMV30_ATS_TMP     endtask


    // -------------------------------------------------------------------------
//--AY_HQMV30_ATS_TMP     function bit is_this_a_dest_page(DsaDescProcessor desc_proc, bit[63:0] inv_page_addr);
//--AY_HQMV30_ATS_TMP         int       num_idx;
//--AY_HQMV30_ATS_TMP         DsaPage   pages[$];
//--AY_HQMV30_ATS_TMP         bit[63:0] page_addr;
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP         num_idx = desc_proc.find_num_dests();
//--AY_HQMV30_ATS_TMP         for ( int i = 0; i < num_idx; i++ ) begin
//--AY_HQMV30_ATS_TMP             pages = desc_proc.get_dest_logical_pages(.idx(i));
//--AY_HQMV30_ATS_TMP             foreach (pages[i]) begin
//--AY_HQMV30_ATS_TMP                 page_addr = pages[i].get_page_address();
//--AY_HQMV30_ATS_TMP                 `ovm_info(get_type_name(), $sformatf("find_and_relocate(): page_addr = %0h",
//--AY_HQMV30_ATS_TMP                     page_addr), OVM_DEBUG)
//--AY_HQMV30_ATS_TMP                 //page_addr &= -64'h1000;
//--AY_HQMV30_ATS_TMP                 if (page_addr == inv_page_addr) begin
//--AY_HQMV30_ATS_TMP                     `ovm_info(get_type_name(), "find_and_relocate(): is_a_dest_page= 1", OVM_DEBUG)
//--AY_HQMV30_ATS_TMP                     return 1;
//--AY_HQMV30_ATS_TMP                 end
//--AY_HQMV30_ATS_TMP             end
//--AY_HQMV30_ATS_TMP         end
//--AY_HQMV30_ATS_TMP         return 0;
//--AY_HQMV30_ATS_TMP     endfunction
    
//--AY_HQMV30_ATS_TMP     virtual function bit is_event_log_enabled();
//--AY_HQMV30_ATS_TMP         bit model_supported = dsaCfgObj.tiCfg.isDsa2() | dsaCfgObj.tiCfg.isIax2i64();
//--AY_HQMV30_ATS_TMP         bit els_supported = model_supported & (~dsaCfgObj.coreCfg.deftr_elsdis | (dsaCfgObj.coreCfg.deftr_elsdis & dsaCfgObj.coreCfg.deftr_elsoval>0));
//--AY_HQMV30_ATS_TMP         if(dsaCfgObj.evlCfgObj.eventlog_en && els_supported && !dsaCfgObj.evlCfgObj.no_evl_write_expected)
//--AY_HQMV30_ATS_TMP             return 1;
//--AY_HQMV30_ATS_TMP         else
//--AY_HQMV30_ATS_TMP             return 0;
//--AY_HQMV30_ATS_TMP     endfunction


    // -------------------------------------------------------------------------
//--AY_HQMV30_ATS_TMP     function bit is_this_a_cpl_page(DsaDescProcessor desc_proc, bit[63:0] inv_page_addr);
//--AY_HQMV30_ATS_TMP         int       num_idx;
//--AY_HQMV30_ATS_TMP         DsaPage   pages[$];
//--AY_HQMV30_ATS_TMP         bit[63:0] page_addr;
//--AY_HQMV30_ATS_TMP 
//--AY_HQMV30_ATS_TMP         num_idx = 1;
//--AY_HQMV30_ATS_TMP         for ( int i = 0; i < num_idx; i++ ) begin
//--AY_HQMV30_ATS_TMP             pages = desc_proc.get_cpl_logical_pages(.idx(i));
//--AY_HQMV30_ATS_TMP             foreach (pages[i]) begin
//--AY_HQMV30_ATS_TMP                 page_addr = pages[i].get_page_address();
//--AY_HQMV30_ATS_TMP                 `ovm_info(get_type_name(), $sformatf("find_and_relocate(): page_addr = %0h",
//--AY_HQMV30_ATS_TMP                     page_addr), OVM_DEBUG)
//--AY_HQMV30_ATS_TMP                 //page_addr &= -64'h1000;
//--AY_HQMV30_ATS_TMP                 if (page_addr == inv_page_addr) begin
//--AY_HQMV30_ATS_TMP                     `ovm_info(get_type_name(), "find_and_relocate(): is_a_cpl_page= 1", OVM_DEBUG)
//--AY_HQMV30_ATS_TMP                     return 1;
//--AY_HQMV30_ATS_TMP                 end
//--AY_HQMV30_ATS_TMP             end
//--AY_HQMV30_ATS_TMP         end
//--AY_HQMV30_ATS_TMP         return 0;
//--AY_HQMV30_ATS_TMP     endfunction

endclass: HqmIosfMRdCb
