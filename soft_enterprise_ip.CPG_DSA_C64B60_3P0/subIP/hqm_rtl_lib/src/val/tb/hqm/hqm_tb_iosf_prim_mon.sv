//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2018 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
//-- Test
//-----------------------------------------------------------------------------------------------------

import hqm_cfg_pkg::*;
import hqm_tb_cfg_pkg::*;
import hcw_transaction_pkg::*;
import hcw_pkg::*;
import hqm_integ_pkg::*;
import IosfPkg::*;

class hqm_tb_iosf_prim_mon extends hqm_iosf_prim_mon;

  `ovm_component_utils(hqm_tb_iosf_prim_mon)

  virtual hqm_misc_if  pins;
  virtual hqm_reset_if reset_if;

  // -- Variables related to ADR
  bit            ip_pm_adr_req;
  bit            ip_pm_adr_ack;
  bit            first_ur_after_pm_adr_ack;
// --  bit            outstanding_trans[bit [15:0]][bit [9:0]];

  function new(string name = "hqm_tb_iosf_prim_mon", ovm_component parent = null);
    super.new(name,parent);
    ip_pm_adr_req = 1'b0;
    ip_pm_adr_ack = 1'b0;
  endfunction

  function void end_of_elaboration();

      string str;

      super.end_of_elaboration();

      // -- get pins interface
      if (!get_config_string({"hqm_misc_if_handle",inst_suffix}, str)) begin
          ovm_report_fatal(get_full_name(), $psprintf("get_config_string failed for hqm_misc_if_handle"));
      end
      `sla_get_db(pins, virtual hqm_misc_if, str)
      if (pins == null) begin
         ovm_report_fatal(get_full_name(), $psprintf("pins is null"));
      end

      // -- get reset_if interface
      if (!get_config_string({"reset_if_handle",inst_suffix}, str)) begin
         ovm_report_fatal(get_full_name(), $psprintf("get_config_string failed for reset_if_handle"));
      end 
      `sla_get_db(reset_if, virtual hqm_reset_if, str)
      if (reset_if == null) begin
          ovm_report_fatal(get_full_name(), $psprintf("reset_if is null"));
      end

      ovm_report_info(get_full_name(), $psprintf("end_of_elaboration -- End"),   OVM_DEBUG);

  endfunction : end_of_elaboration

  virtual task run();
    IosfMonTxn  monTxn;
    ovm_object  o_tmp;
    string      trk_description;

    //-----------------------------
    //-- get i_hqm_pp_cq_status
    //-----------------------------
    if (!get_config_object({"i_hqm_pp_cq_status",inst_suffix}, o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
    end

    if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
    end

    if (!get_config_object({"i_hqm_iosf_trans_status",inst_suffix}, o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_iosf_trans_status object");
    end

    if (!$cast(i_hqm_iosf_trans_status, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_iosf_trans_status not compatible with type of i_hqm_iosf_trans_status"));
    end

    if (gen_hqm_iosf_prim_trk_file) begin
      trk_file_name = "hqm_iosf_prim.trk";
      $value$plusargs("HQM_IOSF_PRIM_TRK_FILE=%s",trk_file_name);

      trk_file = $fopen(trk_file_name);

      if (trk_file == 0) begin
        `ovm_fatal(get_full_name(), $psprintf("Unable to open %s file",trk_file_name))
      end

      $fdisplay(trk_file,"HQM IOSF Primary Tracker File\n");
      $fdisplay(trk_file,"| time          |D|command |r|    address     |rid_tag |lth |c/t| fbe_lbe |      data       |h|dst/srcId| pasid|sai | cid |A|ACEHIL|NORSTG|P|DP|Description");
      $fdisplay(trk_file,"|---------------|-|--------|-|----------------|--------|----|---|---------|-----------------|-|---------|------|----|-----|-|------|------|-|--|");

      $fflush(trk_file);
    end

    forever begin
      fork 
        fork
          forever begin
            iosf_trans_type_st iosf_trans_type;

            bit decode_hqm_init_trans;
            bit decode_hqm_recv_trans;
            bit decode_hqm_ats_req_trans;
            bit decode_hqm_ats_resp_trans;
            bit decode_ats_invalidation_response_trans;
            bit rc;

            pvc_mon_fifo.get(monTxn);

            hqm_rst_cq_gen(); //--HQMRST_DEBUG

            //---------------------------------------------------------------------------
            // -- debug for all the transactions that are generated by HQM
            if ( monTxn.eventType == Iosf::MCMD ) 
                ovm_report_info(get_full_name(), $psprintf("IOSF_Master_monTxn.eventType=Iosf::MCMD -- format=%0b type=%0b -- Address(0x%0x) end_of_transaction=%0d", monTxn.format, monTxn.type_i, monTxn.address, monTxn.end_of_transaction), OVM_HIGH);
            if ( monTxn.eventType == Iosf::MDATA )
                ovm_report_info(get_full_name(), $psprintf("IOSF_Master_monTxn.eventType=Iosf::MDATA -- format=%0b type=%0b -- Address(0x%0x) end_of_transaction=%0d", monTxn.format, monTxn.type_i, monTxn.address, monTxn.end_of_transaction), OVM_HIGH);
            if ( monTxn.eventType == Iosf::TCMD ) 
                ovm_report_info(get_full_name(), $psprintf("IOSF_Target_monTxn.eventType=Iosf::TCMD -- format=%0b type=%0b -- Address(0x%0x) end_of_transaction=%0d",  monTxn.format, monTxn.type_i, monTxn.address, monTxn.end_of_transaction), OVM_HIGH);
            if ( monTxn.eventType == Iosf::TDATA ) 
                ovm_report_info(get_full_name(), $psprintf("IOSF_Target_monTxn.eventType=Iosf::TDATA -- format=%0b type=%0b -- Address(0x%0x) end_of_transaction=%0d", monTxn.format, monTxn.type_i, monTxn.address, monTxn.end_of_transaction), OVM_HIGH);

            //---------------------------------------------------------------------------
            //-- Master 
            //---------------------------------------------------------------------------
            // -- Check for all the transactions that are generated by HQM
            if ( ( (monTxn.eventType == Iosf::MDATA) || (monTxn.eventType == Iosf::MCMD) ) && (monTxn.end_of_transaction == 1) )begin

               if ( ({monTxn.format,monTxn.type_i} == Iosf::MRd32) || ({monTxn.format,monTxn.type_i} == Iosf::MRd64) ) begin
                  //--HQMV30_ATS_Request
                  ovm_report_info(get_full_name(), $psprintf("HQMV30_Read Request Address(0x%0x) -- call decode_ats_request() ", monTxn.address), OVM_MEDIUM);
                  decode_hqm_ats_req_trans = decode_ats_request(monTxn, trk_description);

                  if(decode_hqm_ats_req_trans==0) begin
                      trk_description = $psprintf( "ATS Req CQ/VAS Not Found!");
                  end
       
                  printTxnInIosfTrackerFile(trk_file,monTxn,trk_description);
                  ovm_report_info(get_full_name(), $psprintf("HQMV30_Read Request Address(0x%0x) -- decode_hqm_ats_req_trans=%0d", monTxn.address, decode_hqm_ats_req_trans), OVM_MEDIUM);
  
               end else if(({monTxn.format,monTxn.type_i} == Iosf::Msg2)) begin
                 //-- Detect ATS Invalidation response returned by HQMV30 DUT
                  decode_ats_invalidation_response_trans = decode_ats_invalidation_response(monTxn, trk_description);

                  if(decode_ats_invalidation_response_trans ==0) begin
                      trk_description = $psprintf( "ATS INV_CPL Msg2 with TAG 0x%0x Req_id 0x%0x - CQ/VAS Not Found! ", monTxn.tag, monTxn.req_id);
                  end
                  printTxnInIosfTrackerFile(trk_file,monTxn,trk_description);
                  ovm_report_info(get_full_name(), $psprintf("HQMV30_ATS_INV_CPL Request Address(0x%0x) -- INV_CPL returned by HQM DUT ", monTxn.address), OVM_MEDIUM);

               end else begin
                  // -- Check for CQ write
                  begin
                    ovm_report_info(get_full_name(), $psprintf("Address(0x%0x) -- Checking for decoding CQ Address", monTxn.address), OVM_HIGH);
                    decode_hqm_init_trans = decode_cq_addr(monTxn,trk_description);
                    if (decode_hqm_init_trans) begin
                      printTxnInIosfTrackerFile(trk_file,monTxn,trk_description);
    
                      iosf_trans_type.monTxn     = monTxn;//.cloneme();
                      iosf_trans_type.trans_type = HCW_SCH;
                      ovm_report_info(get_full_name(), $psprintf("Address(0x%0x) decoded as %0s", monTxn.address, iosf_trans_type.trans_type.name()), OVM_HIGH);
                    end
                  end
    
                  // -- Check for Interrupt Writes
                  begin
                    bit              trans_decoded;
                    hqm_trans_type_e trans_type;
    
                    ovm_report_info(get_full_name(), $psprintf("Address(0x%0x) -- Checking for decoding Interrupts writes", monTxn.address), OVM_HIGH);
                    decode_intr_writes(monTxn, trans_type, trans_decoded,trk_description);
                    if (trans_decoded && decode_hqm_init_trans) begin
                      ovm_report_fatal(get_full_name(), $psprintf("Address decoded by CQ also decoded as interrupt writes(Address=0x%0x)", monTxn.address));
                    end else if (trans_decoded) begin
                      printTxnInIosfTrackerFile(trk_file,monTxn,trk_description);
    
                      decode_hqm_init_trans = 1'b1;
                      iosf_trans_type.monTxn     = monTxn;//.cloneme();
                      iosf_trans_type.trans_type = trans_type;
                      ovm_report_info(get_full_name(), $psprintf("Address(0x%0x) decoded as %0s", monTxn.address, iosf_trans_type.trans_type.name()), OVM_HIGH);
                    end
                  end
    
                  // -- Completions generated by HQM
                  begin
                    hqm_trans_type_e trans_type;
                    bit              trans_decoded;
    
                    trans_decoded = decode_completions_init_HQM(monTxn, trans_type);
    
                    if (trans_decoded && decode_hqm_init_trans) begin
                      ovm_report_fatal(get_full_name(), $psprintf("Address generated by HQM already decoded (Address=0x%0x)", monTxn.address));
                    end else if( trans_decoded ) begin
                      printTxnInIosfTrackerFile(trk_file,monTxn,"");
    
                      decode_hqm_init_trans      = 1'b1;
                      iosf_trans_type.monTxn     = monTxn;//.cloneme();
                      case (monTxn.cmd)
                        Iosf::Cpl   : trans_type = HQM_GEN_CPL;
                        Iosf::CplD  : trans_type = HQM_GEN_CPLD;
                        Iosf::CplLk : trans_type = HQM_GEN_CPLLK;
                      endcase
                      iosf_trans_type.trans_type = trans_type; 
                      ovm_report_info(get_full_name(), $psprintf("Address(0x%0x) decoded as %0s", monTxn.address, iosf_trans_type.trans_type.name()), OVM_HIGH);
                   
                      // -- After ip_pm_adr_ack is asserted, all the completions should
                      // -- be generated with UR
                      if (ip_pm_adr_ack) begin
                        if ( Iosf::iosf_status_t'(monTxn.first_be[2:0]) == Iosf::UR) begin
                          ovm_report_info(get_full_name(), $psprintf("Completion received with a UR"), OVM_HIGH);
                        end else begin
                            // HSD#1607650866 -- check comments from Steve: post first UR after adr_req/ack, all subsequent completions should be UR
                            if (first_ur_after_pm_adr_ack)
                                ovm_report_error(get_full_name(), $psprintf("Completion not received with a UR\n%0s", monTxn.convert2string()));
                        end
                      end
                    end
    
                    // -- In case of ADR flow, no master requests should be generated
                    if (ip_pm_adr_ack) begin
                      if ( !( (iosf_trans_type.trans_type == HQM_GEN_CPL) || (iosf_trans_type.trans_type == HQM_GEN_CPLD) || (iosf_trans_type.trans_type == HQM_GEN_CPLLK) ) ) begin
                        ovm_report_error(get_full_name(), $psprintf("Transaction other than completion generated by HQM after ip_pm_adr_req\n%0s", monTxn.convert2string()));
                      end
                    end
                    if (ip_pm_adr_ack) begin
                      if ( (iosf_trans_type.trans_type == HQM_GEN_CPL) || (iosf_trans_type.trans_type == HQM_GEN_CPLD) || (iosf_trans_type.trans_type == HQM_GEN_CPLLK) ) begin
                        if (!first_ur_after_pm_adr_ack && ( Iosf::iosf_status_t'(monTxn.first_be[2:0]) == Iosf::UR)) begin
                            first_ur_after_pm_adr_ack=1;
                        end
                        ovm_report_info(get_full_name(), $psprintf("Completion generated by HQM after ip_pm_adr_ack is asserted\n%0s, first_ur_after_pm_adr_ack=%0d", monTxn.convert2string(), first_ur_after_pm_adr_ack), OVM_HIGH);
                      end
                    end
                  end
                    
                  if (decode_hqm_init_trans == 1'b0) begin
                    ovm_report_error(get_full_name(), $psprintf("IOSF Primary Monitor transaction (%0s) generated by HQM couldn't be translated by HQM", monTxn.convert2string()));
                  end
               end//if ( ({monTxn.format,monTxn.type_i} == Iosf::MRd32) || ({monTxn.format,monTxn.type_i} == Iosf::MRd64) ) 
            end //--Master 
            //---------------------------------------------------------------------------
            //-- Target
            //---------------------------------------------------------------------------
            else if ( (monTxn.eventType == Iosf::TDATA ) || (monTxn.eventType == Iosf::TCMD) ) begin

                if(({monTxn.format,monTxn.type_i} == Iosf::CplD) && i_hqm_cfg.ats_enabled) begin
                    //--HQMV30_ATS_Response
                    //-- Detect ATS Response with CplD returned by TB
                    if(monTxn.end_of_transaction == 1) begin
                       ovm_report_info(get_full_name(), $psprintf("HQMV30_Target_CplD Address(0x%0x) Tag(0x%0x) req_id(0x%0x) -- end_of_transaction=1 : call decode_ats_response() ", monTxn.address, monTxn.tag, monTxn.req_id), OVM_MEDIUM);
                       decode_hqm_ats_resp_trans = decode_ats_response(monTxn, 1, trk_description);

                       if(decode_hqm_ats_resp_trans==0) begin
                           trk_description = $psprintf( "ATS Response TAG 0x%0x Req_id 0x%0x Not Found! or CQ/VAS Not Found!", monTxn.tag, monTxn.req_id);
                       end

                       printTxnInIosfTrackerFile(trk_file,monTxn,trk_description);
                       ovm_report_info(get_full_name(), $psprintf("HQMV30_Target_CplD Address(0x%0x) Tag(0x%0x) req_id(0x%0x) -- decode_hqm_ats_resp_trans=%0d", monTxn.address, monTxn.tag, monTxn.req_id, decode_hqm_ats_resp_trans), OVM_MEDIUM);
                    end else begin
                       ovm_report_info(get_full_name(), $psprintf("HQMV30_Target_CplD Address(0x%0x) Tag(0x%0x) req_id(0x%0x) -- end_of_transaction=%0d : cont", monTxn.address, monTxn.tag, monTxn.req_id, monTxn.end_of_transaction), OVM_MEDIUM);
                    end 

                end else if(({monTxn.format,monTxn.type_i} == Iosf::Cpl) && (monTxn.end_of_transaction == 1) && i_hqm_cfg.ats_enabled) begin
                    //-- Detect ATS Response with Cpl returned by TB
                    ovm_report_info(get_full_name(), $psprintf("HQMV30_Target_Cpl Tag(0x%0x) req_id(0x%0x) -- call decode_ats_response() ", monTxn.address, monTxn.tag, monTxn.req_id), OVM_MEDIUM);
                    decode_hqm_ats_resp_trans = decode_ats_response(monTxn, 0, trk_description);
                    printTxnInIosfTrackerFile(trk_file,monTxn,trk_description);
                    ovm_report_info(get_full_name(), $psprintf("HQMV30_Target_Cpl Tag(0x%0x) req_id(0x%0x) -- decode_hqm_ats_resp_trans=%0d", monTxn.tag, monTxn.req_id, decode_hqm_ats_resp_trans), OVM_MEDIUM);


                end else if(({monTxn.format,monTxn.type_i} == Iosf::MsgD2) && i_hqm_cfg.ats_enabled) begin
                    if(monTxn.end_of_transaction == 1) begin
                       //-- Detect ATS Invalidation request issued by TB
                       //trk_description = $psprintf( "ATS INV_REQ MsgD2 with TAG 0x%0x Req_id 0x%0x", monTxn.tag, monTxn.req_id);

                       decode_ats_invalidation_request(monTxn, trk_description);

                       printTxnInIosfTrackerFile(trk_file,monTxn,trk_description);
                       ovm_report_info(get_full_name(), $psprintf("HQMV30_Target_ATS_INV_Req Request Address(0x%0x) -- INV_REQ sent to HQM DUT ", monTxn.address), OVM_MEDIUM);
                    end else begin
                       ovm_report_info(get_full_name(), $psprintf("HQMV30_Target_ATS_INV_Req Request Address(0x%0x) -- INV_REQ with monTxn.end_of_transaction=0", monTxn.address), OVM_MEDIUM);
                    end 
                end else begin
                     // Detect case where pasidtlp[22] is set and we are not in SCIOV mode
                     if (monTxn.eventType == Iosf::TCMD) begin
                       if (!(i_hqm_cfg.is_sciov_mode()) && monTxn.pasidtlp[22]) begin
                         if ($test$plusargs("HQM_EXP_PASID_ERROR")) begin
                           `ovm_info(get_full_name(),"Not in SCIOV mode and received command with tpasidtlp[22] set, +HQM_EXP_PASID_ERROR plusarg included",OVM_LOW)
                         end else begin
                           `ovm_error(get_full_name(),"Not in SCIOV mode and received command with tpasidtlp[22] set, +HQM_EXP_PASID_ERROR plusarg not set")
                         end 		
                       end
                     end
       
                     // -- Categorize transaction on input side to HQM
                     begin
                       hqm_trans_type_e trans_type;
       
                       decode_hqm_recv_trans = decode_mem_write_to_hqm(monTxn, trans_type, trk_description);
                       if (decode_hqm_recv_trans == 1'b1) begin
                         iosf_trans_type.trans_type = trans_type;
                         iosf_trans_type.monTxn     = monTxn;//.cloneme();
                         ovm_report_info(get_full_name(), $psprintf("Address(0x%0x) decoded as %0s", monTxn.address, iosf_trans_type.trans_type.name()), OVM_HIGH);
                       end
                     end
       
                     // -- IA CSR Read
                     begin
                       bit decoded;
       
                       decoded = decode_mem_read_to_hqm(monTxn);
                       if (decoded && decode_hqm_recv_trans) begin
                         ovm_report_fatal(get_full_name(), $psprintf("Address(0x%0x) already decoded as mem_write_to_hqm", monTxn.address));
                       end else if (decoded) begin
                         decode_hqm_recv_trans      = 1'b1;
                         iosf_trans_type.monTxn     = monTxn;//.cloneme();
                         iosf_trans_type.trans_type = CSR_READ;
                         ovm_report_info(get_full_name(), $psprintf("Address(0x%0x) decoded as %0s", monTxn.address, iosf_trans_type.trans_type.name()), OVM_HIGH);
                       end
                     end
       
                     // -- CfgWr0
                     begin
                       bit               decoded;
                       hqm_trans_type_e trans_type;
       
                       decoded = decode_cfg_wr(monTxn, trans_type);
                       if (decoded && decode_hqm_recv_trans) begin
                         ovm_report_fatal(get_full_name(), $psprintf("Address(0x%0x) already decoded as mem_write_to_hqm/csr_read", monTxn.address));
                       end else if (decoded) begin
                         decode_hqm_recv_trans      = 1'b1;
                         iosf_trans_type.monTxn     = monTxn;//.cloneme();
                         iosf_trans_type.trans_type = trans_type;
                         ovm_report_info(get_full_name(), $psprintf("Address(0x%0x) decoded as %0s", monTxn.address, iosf_trans_type.trans_type.name()), OVM_HIGH);
                       end
                     end
       
                     // -- CfgRd0
                     begin
                       bit decoded;
       
                       decoded = decode_cfg_rd(monTxn);
                       if (decoded && decode_hqm_recv_trans) begin
                         ovm_report_fatal(get_full_name(), $psprintf("Address (0x%0x) already decoded previously", monTxn.address));
                       end else if (decoded) begin
                         decode_hqm_recv_trans      = 1'b1;
                         iosf_trans_type.monTxn     = monTxn;//.cloneme();
                         iosf_trans_type.trans_type = PCIE_CFG_RD0;
                         ovm_report_info(get_full_name(), $psprintf("Address(0x%0x) decoded as %0s", monTxn.address, iosf_trans_type.trans_type.name()), OVM_HIGH);
                       end
                     end
       
                     if (decode_hqm_recv_trans == 1'b0) begin
                       if ($test$plusargs("EXP_UNWANTED_TXN_TO_HQM")) begin
                         ovm_report_warning(get_full_name(), $psprintf("Address(0x%0x) is an unsupported transaction on input side to HQM", monTxn.address));
                       end else begin
                         ovm_report_error(get_full_name(), $psprintf("Address(0x%0x) is an unsupported transaction on input side to HQM", monTxn.address));
                       end
                       iosf_trans_type.monTxn = monTxn;//.cloneme();
                       iosf_trans_type.trans_type = UNKWN_TRANS_TO_HQM;
                       ovm_report_info(get_full_name(), $psprintf("Address(0x%0x) decoded as %0s", monTxn.address, iosf_trans_type.trans_type.name()), OVM_HIGH);
                     end
                end//if(({monTxn.format,monTxn.type_i} == Iosf::CplD)) 
            end //--Target

            //---------------------------------------------------------------------------
            if (iosf_trans_type.monTxn != null) begin
                ovm_report_info(get_full_name(), $psprintf("Sending data to coverage model %p", iosf_trans_type.monTxn, iosf_trans_type.trans_type), OVM_DEBUG);
                i_iosf_trans_type_port.write(iosf_trans_type);
                        i_hqm_iosf_trans_status.inc_cnt(iosf_trans_type.trans_type);
            end

            //---------------------------------------------------------------------------
            //-- Target interface, TB returned CplD (with HQMV30_ATS added these are not needed)
            if ( (monTxn.eventType == Iosf::TCMD) && ({monTxn.format,monTxn.type_i} == Iosf::CplD) && !i_hqm_cfg.ats_enabled) begin
                if ($test$plusargs("UNWANTED_TXN")) begin //added to check unwanted completion
                    `ovm_info(get_full_name(),"Unexpected completion to HQM detected, +UNWANTED_TXN plusarg included",OVM_NONE)
                end else begin
                    `ovm_error(get_full_name(),"Unexpected completion to HQM detected, set +UNWANTED_TXN plusarg if this is not an error for this test")
                end 		
            end

            //---------------------------------------------------------------------------
            //--confirm there is no NP cmd sending from HQM to fabric
            //--HQMV25 -- if ( ((monTxn.eventType == Iosf::MCMD) || (monTxn.eventType == Iosf::MDATA)) && (({monTxn.format,monTxn.type_i} == Iosf::MRd32) || ({monTxn.format,monTxn.type_i} == Iosf::MRd64) || ({monTxn.format,monTxn.type_i} == Iosf::CfgRd0) || ({monTxn.format,monTxn.type_i} == Iosf::CfgWr0) ) ) begin
            if ( ((monTxn.eventType == Iosf::MCMD) || (monTxn.eventType == Iosf::MDATA)) && ( ({monTxn.format,monTxn.type_i} == Iosf::CfgRd0) || ({monTxn.format,monTxn.type_i} == Iosf::CfgWr0) ) ) begin
                if ($test$plusargs("UNWANTED_NP_MASTER")) begin //added to check unwanted completion
                    `ovm_info(get_full_name(),"Unexpected completion to HQM detected, +UNWANTED_NP_MASTER plusarg included",OVM_NONE)
                end else begin
                    `ovm_error(get_full_name(),"Unexpected PN to HQM detected, set +UNWANTED_NP_MASTER plusarg if this is not an error for this test")
                end 		
            end

          end//--forever

          forever begin
            adr_flow();
          end
        join

        begin
          wait_for_rstn_assertion();
        end

      join_any

      disable fork;
      reset();
      wait_for_rstn_deassertion();
    end
  endtask

  function void reset();

      super.reset();

      if (ip_pm_adr_req && !ip_pm_adr_ack) begin
          ovm_report_error(get_full_name(), $psprintf("No ip_pm_adr_ack seen for ip_pm_adr_req"));
      end
      // -- Clear the ADR bits
      ip_pm_adr_req = 1'b0;
      ip_pm_adr_ack = 1'b0;
      first_ur_after_pm_adr_ack = 1'b0;

  endfunction : reset

  task wait_for_rstn_assertion();

      ovm_report_info(get_full_name(), $psprintf("wait_for_rstn_assertion -- Start"), OVM_DEBUG);
      wait (!reset_if.powergood_rst_b || !reset_if.prim_rst_b);
      ovm_report_info(get_full_name(), $psprintf("wait_for_rstn_assertion -- End"),   OVM_DEBUG);

  endtask : wait_for_rstn_assertion

  task wait_for_rstn_deassertion();

      ovm_report_info(get_full_name(), $psprintf("wait_for_rstn_deassertion -- Start"), OVM_DEBUG);
      wait (reset_if.powergood_rst_b && reset_if.prim_rst_b);
      ovm_report_info(get_full_name(), $psprintf("wait_for_rstn_deassertion -- End"),   OVM_DEBUG);

  endtask : wait_for_rstn_deassertion

  task adr_flow();

      ovm_report_info(get_full_name(), $psprintf("ADR flow -- Start"), OVM_DEBUG);
      fork
         begin
             pins.wait_for_pm_adr_req();
             ip_pm_adr_req = 1'b1;
             ovm_report_info(get_full_name(), $psprintf("ip_pm_adr_req=%b", ip_pm_adr_req), OVM_LOW);
         end

         begin
             pins.wait_for_pm_adr_ack();
             ip_pm_adr_ack = 1'b1;
             if ( !(ip_pm_adr_req) ) begin
                 ovm_report_error(get_full_name(), $psprintf("ip_pm_adr_ack was generated without ip_pm_adr_req"), OVM_LOW);
             end else begin
                 ovm_report_info(get_full_name(), $psprintf("ip_pm_adr_ack=%0b", ip_pm_adr_ack), OVM_LOW);
             end
             // -- if (outstanding_trans.num() != 0) begin
             // --     ovm_report_error(get_full_name(), $psprintf("Completions not sent and ip_pm_adr_ack is asserted"));
             // -- end else begin
             // --     ovm_report_info(get_full_name(), $psprintf("Completions sent before ip_pm_adr_ack asserted"), OVM_LOW);
             // -- end
         end
      join
      ovm_report_info(get_full_name(), $psprintf("ADR flow -- End"), OVM_DEBUG);

  endtask : adr_flow

endclass
