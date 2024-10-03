//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2015 Intel Corporation All Rights Reserved.
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

`ifndef HQM_IOSF_PRIM_MON__SV
`define HQM_IOSF_PRIM_MON__SV

import hqm_cfg_pkg::*;
import hqm_tb_cfg_pkg::*;
import hcw_transaction_pkg::*;
import hcw_pkg::*;
import IosfPkg::*;

typedef struct {
    IosfMonTxn       monTxn;
    hqm_trans_type_e trans_type;
} iosf_trans_type_st;

class hqm_iosf_prim_mon extends ovm_monitor;

  `ovm_component_utils(hqm_iosf_prim_mon)

  integer               trk_file;
  string                trk_file_name;

  string                inst_suffix = "";

  IosfFabricVc          iosf_pvc;

  //tlm port
  ovm_analysis_port     #(hcw_transaction)      i_hcw_enq_in_port;
  ovm_analysis_port     #(hcw_transaction)      i_hcw_sch_out_port;
  ovm_analysis_port     #(HqmBusTxn)            i_HqmAtsPort;

  ovm_analysis_port     #(iosf_trans_type_st)   i_iosf_trans_type_port;

  ovm_analysis_export   #(IosfMonTxn)           pvc_mon_export;
  tlm_analysis_fifo     #(IosfMonTxn)           pvc_mon_fifo;

  hqm_tb_cfg                    i_hqm_cfg;

  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;

  hqm_pp_cq_status              i_hqm_pp_cq_status;     // common HQM PP/CQ status class
  hqm_iosf_trans_status         i_hqm_iosf_trans_status; // class to track IOSF transactions

  int                           seq_sch_out_mode;

  cq_gen_info_t cq_gen_info;

  sla_ral_env   ral;

  bit [63:0]    target_iosf_addr_q[$];

  sla_ral_reg   cfg_addr_list[bit [63:0]];
  sla_ral_reg   mem_addr_list[bit [63:0]];

  ovm_event_pool glbl_pool;
  ovm_event      exp_ep_msix[65];
  ovm_event      exp_ep_msi[16];
  ovm_event      exp_ep_ims[160];  //--64
  
  bit           gen_hqm_iosf_prim_trk_file;

  int           ats_invresp_cnt[32];
  int           ats_invresp_num[32];

  
  function new(string name = "hqm_iosf_prim_mon", ovm_component parent = null);
    super.new(name,parent);

    if ($test$plusargs("HQM_IOSF_PRIM_TRK_FILE_DISABLE")) begin
      gen_hqm_iosf_prim_trk_file = 0;
    end else begin
      gen_hqm_iosf_prim_trk_file = 1;
    end
    for(int i=0; i<32; i++) begin
      ats_invresp_cnt[i]=0;
      ats_invresp_num[i]=0;
    end
  endfunction

  function void build();
    ovm_object o_tmp;

    super.build();

    i_hcw_enq_in_port           = new("i_hcw_enq_in_port",this);
    i_hcw_sch_out_port          = new("i_hcw_sch_out_port",this);
    i_HqmAtsPort                = new("i_HqmAtsPort",this);
    i_iosf_trans_type_port      = new("i_iosf_trans_type_port", this);

    pvc_mon_export              = new("pvc_mon_export",this);
    pvc_mon_fifo                = new("pvc_mon_fifo",this);

    cq_gen_reset();

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!get_config_object({"i_hqm_cfg",inst_suffix}, o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("get_config_object(i_hqm_cfg,..) type not hqm_tb_cfg"));
    end

    //-----------------------------
    //-- get iosf_pvc
    //-----------------------------
    if (!get_config_object({"iosf_pvc_tlm",inst_suffix}, o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find iosf_pvc_tlm object");
    end

    if (!$cast(iosf_pvc, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("get_config_object(iosf_pvc_tlm,..) returned type not IosfFabricVc"));
    end

    //-----------------------------
    //-- determine whether Scheduled HCWs are being sent to scoreboard by sequences or this component
    //-- seq_sch_out_mode=0: use IOSF-P mon to pass SCHED HCW to SB
    //-- seq_sch_out_mode=1: use this sequence to pass SCHED HCW to SB
    //-----------------------------
    if (!get_config_int("hqm_seq_sch_out_mode", seq_sch_out_mode)) begin
      seq_sch_out_mode  = 0;
    end
    if($test$plusargs("HQMSEQ_SCH_OUT_MODE_0")) begin
       seq_sch_out_mode    = 1;
    end else if($test$plusargs("HQMSEQ_SCH_OUT_MODE_1")) begin
       seq_sch_out_mode    = 0;
    end
    ovm_report_info(get_full_name(), $psprintf("HQM_IOSF_MON_DEBUG_%0s: hqm_cfg.inst_suffix=%0s; report seq_sch_out_mode=%0d", inst_suffix, i_hqm_cfg.inst_suffix, seq_sch_out_mode), OVM_LOW);
  endfunction

  function void connect();
    ovm_object o_tmp;

    super.connect();

    glbl_pool        = ovm_event_pool::get_global_pool();

    // -- Create/get handles to msi/msix_vector detected triggering -- // 
    foreach (exp_ep_msix[i]) begin
      exp_ep_msix[i] = glbl_pool.get($psprintf("hqm%s_exp_ep_msix_%0d",inst_suffix,i));
    end
    foreach (exp_ep_msi[i]) begin
      exp_ep_msi[i] = glbl_pool.get($psprintf("hqm%s_exp_ep_msi_%0d",inst_suffix,i));
    end
    // -- Create/get handles to ims_vector detected triggering -- // 
    foreach (exp_ep_ims[i]) begin
      exp_ep_ims[i] = glbl_pool.get($psprintf("hqm%s_exp_ep_ims_%0d",inst_suffix,i));
    end


    //IOSF primary connection
    iosf_pvc.iosfMonAnalysisPort.connect(pvc_mon_export);
    pvc_mon_export.connect(pvc_mon_fifo.analysis_export);

    //-----------------------------
    //-- get i_hcw_scoreboard
    //-----------------------------
    if (!get_config_object({"i_hcw_scoreboard",inst_suffix}, o_tmp)) begin
                 ovm_report_fatal(get_full_name(), "Unable to find i_hcw_scoreboard object");
    end

    if (!$cast(i_hcw_scoreboard, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config_i_hcw_scoreboard %s associated with config %s is not same type", o_tmp.sprint(), i_hcw_scoreboard.sprint()));
    end else begin
      ovm_report_info(get_full_name(), $psprintf("i_hcw_scoreboard retrieved"), OVM_DEBUG);
    end

  endfunction

  //--AY_HQMV30_ATS support
  function bit [31:0] reverse_dw ( bit [31:0] dw );
        return { dw[7:0], dw[15:8], dw[23:16], dw[31:24] };
  endfunction

  function void cq_gen_reset();
   `ovm_info(get_full_name(), $psprintf("HQMRST_DEBUG: Issue do_cq_gen_reset() "), OVM_LOW)
    hcw_transaction_pkg::do_cq_gen_reset(cq_gen_info);
  endfunction

  function void hqm_rst_cq_gen();
     if(i_hqm_cfg.hqm_rst_comp==1) begin
	`ovm_info(get_full_name(), $psprintf("HQMRST_DEBUG:hqm_rst_cq_gen- i_hqm_cfg.hqm_rst_comp=1 - call cq_gen_reset() "), OVM_LOW)
        cq_gen_reset();     
	`ovm_info(get_full_name(), $psprintf("HQMRST_DEBUG:hqm_rst_cq_gen- i_hqm_cfg.hqm_rst_comp=2"), OVM_LOW)
        i_hqm_cfg.hqm_rst_comp=2;
     end
  endfunction

  function void end_of_elaboration();

      string str;

      ovm_report_info(get_full_name(), $psprintf("end_of_elaboration -- Start"), OVM_DEBUG);

      // -- Get RAL env
      `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

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
      trk_file_name = $psprintf("hqm%s_iosf_prim.trk",inst_suffix);;
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

    fork
      forever begin
        iosf_trans_type_st iosf_trans_type;

        bit decode_hqm_init_trans;
        bit decode_hqm_recv_trans;
        bit decode_hqm_ats_req_trans;
        bit decode_hqm_ats_resp_trans;

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
        if ( ( (monTxn.eventType == Iosf::MDATA) || (monTxn.eventType == Iosf::MCMD) ) && (monTxn.end_of_transaction == 1) ) begin
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
                end
              end
            
              if (decode_hqm_init_trans == 1'b0) begin
                ovm_report_error(get_full_name(), $psprintf("IOSF Primary Monitor transaction (%0s) generated by HQM couldn't be translated by HQM", monTxn.convert2string()));
                printTxnInIosfTrackerFile(trk_file,monTxn,"Could not be identified");
              end
           end//if ( ({monTxn.format,monTxn.type_i} == Iosf::MRd32) || ({monTxn.format,monTxn.type_i} == Iosf::MRd64) ) 
        end //--Master
	
        //---------------------------------------------------------------------------
        //-- Target
        //---------------------------------------------------------------------------
        else if ( (monTxn.eventType == Iosf::TDATA ) || (monTxn.eventType == Iosf::TCMD) ) begin
             ovm_report_info(get_full_name(), $psprintf("Check_pasid:: monTxn.eventType=%0s monTxn.pasidtlp[22]=%0d", monTxn.eventType.name(), monTxn.pasidtlp[22]), OVM_HIGH);
             ovm_report_info(get_full_name(), $psprintf("HQM_IOSF_MON_DEBUG_%0s:: Target monTxn.eventType=%0s Address=0x%0x length=%0d fbe=0x%0x ", inst_suffix, monTxn.eventType.name(), monTxn.address, monTxn.length, monTxn.first_be), OVM_HIGH);

             if(({monTxn.format,monTxn.type_i} == Iosf::CplD)) begin
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

             end else if(({monTxn.format,monTxn.type_i} == Iosf::Cpl) && (monTxn.end_of_transaction == 1)) begin
             	 //-- Detect ATS Response with Cpl returned by TB
             	 ovm_report_info(get_full_name(), $psprintf("HQMV30_Target_Cpl Tag(0x%0x) req_id(0x%0x) -- call decode_ats_response() ", monTxn.address, monTxn.tag, monTxn.req_id), OVM_MEDIUM);
             	 decode_hqm_ats_resp_trans = decode_ats_response(monTxn, 0, trk_description);
             	 printTxnInIosfTrackerFile(trk_file,monTxn,trk_description);
             	 ovm_report_info(get_full_name(), $psprintf("HQMV30_Target_Cpl Tag(0x%0x) req_id(0x%0x) -- decode_hqm_ats_resp_trans=%0d", monTxn.tag, monTxn.req_id, decode_hqm_ats_resp_trans), OVM_MEDIUM);


             end else if(({monTxn.format,monTxn.type_i} == Iosf::MsgD2)) begin
             	  //-- Detect ATS Invalidation request issued by TB

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
             		decode_hqm_recv_trans	   = 1'b1;
             		iosf_trans_type.monTxn     = monTxn;//.cloneme();
             		iosf_trans_type.trans_type = CSR_READ;
             		ovm_report_info(get_full_name(), $psprintf("Address(0x%0x) decoded as %0s", monTxn.address, iosf_trans_type.trans_type.name()), OVM_HIGH);
             	    end
             	end

             	// -- CfgWr0
             	begin
             	    bit 	      decoded;
             	    hqm_trans_type_e trans_type;
	       
             	    decoded = decode_cfg_wr(monTxn, trans_type);
             	    if (decoded && decode_hqm_recv_trans) begin
             		ovm_report_fatal(get_full_name(), $psprintf("Address(0x%0x) already decoded as mem_write_to_hqm/csr_read", monTxn.address));
             	    end else if (decoded) begin
             		decode_hqm_recv_trans	   = 1'b1;
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
             		decode_hqm_recv_trans	   = 1'b1;
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
             	    printTxnInIosfTrackerFile(trk_file,monTxn,"Could not be identified");
             	end
             end//if(({monTxn.format,monTxn.type_i} == Iosf::CplD)) 
        end//--Target

        //---------------------------------------------------------------------------
        if (iosf_trans_type.monTxn != null) begin
            ovm_report_info(get_full_name(), $psprintf("Sending data to coverage model %p", iosf_trans_type.monTxn, iosf_trans_type.trans_type), OVM_DEBUG);
            i_iosf_trans_type_port.write(iosf_trans_type);
                    i_hqm_iosf_trans_status.inc_cnt(iosf_trans_type.trans_type);
        end

        //---------------------------------------------------------------------------
        //--HQMV25-- if ( (monTxn.eventType == Iosf::TCMD) && ({monTxn.format,monTxn.type_i} == Iosf::CplD)) begin
        //--HQMV25--    if ($test$plusargs("UNWANTED_TXN")) begin //added to check unwanted completion
        //--HQMV25--        `ovm_info(get_full_name(),"Unexpected completion to HQM detected, +UNWANTED_TXN plusarg included",OVM_NONE)
        //--HQMV25--    end else begin
        //--HQMV25--        `ovm_error(get_full_name(),"Unexpected completion to HQM detected, set +UNWANTED_TXN plusarg if this is not an error for this test")
	//--HQMV25--    end 		
        //--HQMV25-- end
	
        //---------------------------------------------------------------------------	
        //--confirm there is no NP cmd sending from HQM to fabric
        //--HQMV25-- if ( ((monTxn.eventType == Iosf::MCMD) || (monTxn.eventType == Iosf::MDATA)) && (({monTxn.format,monTxn.type_i} == Iosf::MRd32) || ({monTxn.format,monTxn.type_i} == Iosf::MRd64) || ({monTxn.format,monTxn.type_i} == Iosf::CfgRd0) || ({monTxn.format,monTxn.type_i} == Iosf::CfgWr0) )) begin
        if ( ((monTxn.eventType == Iosf::MCMD) || (monTxn.eventType == Iosf::MDATA)) && ( ({monTxn.format,monTxn.type_i} == Iosf::CfgRd0) || ({monTxn.format,monTxn.type_i} == Iosf::CfgWr0) ) ) begin
            if ($test$plusargs("UNWANTED_NP_MASTER")) begin //added to check unwanted completion
                `ovm_info(get_full_name(),"Unexpected completion to HQM detected, +UNWANTED_NP_MASTER plusarg included",OVM_NONE)
            end else begin
                `ovm_error(get_full_name(),"Unexpected PN to HQM detected, set +UNWANTED_NP_MASTER plusarg if this is not an error for this test")
            end 		
        end

    end
    join_none
  endtask

  function void reset();

      ovm_report_info(get_full_name(), $psprintf("reset -- Start"), OVM_DEBUG);

      // -- Flush the pvc_mon_fifo
      pvc_mon_fifo.flush();

      // -- Clear the outstanding transactions array
      // -- outstanding_trans.delete();
      ovm_report_info(get_full_name(), $psprintf("reset -- End"), OVM_DEBUG);

  endfunction : reset

  function bit decode_cq_addr(IosfMonTxn monTxn, output string trk_description);

     decode_cq_addr = 1'b0;

     if ( ( monTxn.eventType == Iosf::MDATA)   &&
          ( ( {monTxn.format, monTxn.type_i} == Iosf::MWr32) || ( {monTxn.format, monTxn.type_i} == Iosf::MWr64) ) &&
          ( monTxn.length inside {4, 8, 12, 16} ) &&
          ( (monTxn.first_be == 4'hf) && (monTxn.last_be == 4'hf) )
        ) begin 

        hcw_transaction hcw_trans;
        int             vpp_num;
        int             pp_num;
        int             pp_type;
        bit             credit_type;
        int             vcq_num;
        int             cq_num;
        int             cq_type;
        bit             is_pf;
        int             vf_num;
        int             vas;
        string          hcw_hdr;
        int             cq_index;
        int             max_cq_index;
        bit             first_new_hcw_seen;
        bit             valid_hcw;
        bit             valid_cq_gen;
        string          mbecc_wbuf;

        if (i_hqm_cfg.decode_cq_addr(monTxn.address,4 * monTxn.length,cq_num,cq_type,is_pf,vf_num,vcq_num,cq_index,max_cq_index) == 1) begin

            decode_cq_addr = 1'b1;

            ovm_report_info(get_full_name(), $psprintf("Check for PCIE TLP fields in case of CQ writes (cq_num=0x%0x, is_ldb=%0b, monTxn.pasidtlp[22:0]=0x%0x, monTxn.length=%0d)", cq_num, cq_type, monTxn.pasidtlp[22:0], monTxn.length), OVM_MEDIUM);


            // -- Check for AT in case of CQ writes
            check_for_at   (monTxn.addrTrSvc[1:0], 0);

            // -- Check for PASID in case of CQ writes
            check_for_pasid(monTxn.pasidtlp[22:0], cq_num, cq_type); 

            // -- Check for TC in case of CQ writes
            check_cq_for_tc(monTxn.traffic_class, cq_num, cq_type); 

            vas = i_hqm_cfg.get_vas(cq_type,cq_num);

            // -- Check that all LDB traffic is 16B write (can be 64B if start of cache line)
            if ( cq_type == 1'b1) begin // -- LDB Traffic
                if (!((monTxn.length == 4) || ((monTxn.length == 16) && ((monTxn.address&63) == 0)))) begin
                    ovm_report_error(get_full_name(), $psprintf("LDB CQ(0x%0x) write seen with length(%0d) other than 4 or 16", cq_num, monTxn.length));
                end else begin
                    ovm_report_info(get_full_name(), $psprintf("LDB CQ(0x%0x) write seen with length (%0d) == 4 or 16", cq_num, monTxn.length), OVM_HIGH);
                end
            end

            // -- Update counts hqm_pp_cq_status
            if (cq_type == 1'b1) begin
                case (monTxn.length) 
                    4  : begin
                             i_hqm_pp_cq_status.st_ldbcq_sch_16B_cnt++;    
                             i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].st_sch_16B_cnt++; 
                         end
                    8  : begin
                             i_hqm_pp_cq_status.st_ldbcq_sch_32B_cnt++;
                             i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].st_sch_32B_cnt++;
                         end
                    16 : begin
                             i_hqm_pp_cq_status.st_ldbcq_sch_48B_cnt++;
                             i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].st_sch_48B_cnt++;
                         end
                    32 : begin
                             i_hqm_pp_cq_status.st_ldbcq_sch_64B_cnt++;
                             i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].st_sch_64B_cnt++;
                         end
                endcase
            end else begin
                case (monTxn.length) 
                    4  : begin
                             i_hqm_pp_cq_status.st_dircq_sch_16B_cnt++;    
                             i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].st_sch_16B_cnt++; 
                         end
                    8  : begin
                             i_hqm_pp_cq_status.st_dircq_sch_32B_cnt++;
                             i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].st_sch_32B_cnt++;
                         end
                    16 : begin
                             i_hqm_pp_cq_status.st_dircq_sch_48B_cnt++;
                             i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].st_sch_48B_cnt++;
                         end
                    32 : begin
                             i_hqm_pp_cq_status.st_dircq_sch_64B_cnt++;
                             i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].st_sch_64B_cnt++;
                         end
                endcase
            end

            if (is_pf) begin
              trk_description = $psprintf("PF %s CQ %3d Index %d",cq_type ? "LDB" : "DIR", cq_num,cq_index);
            end else begin
              trk_description = $psprintf("VF %2d %s VCQ %3d (CQ %3d) Index %d",vf_num, cq_type ? "LDB" : "DIR", vcq_num, cq_num,cq_index);
            end

            if (i_hqm_cfg.is_sciov_mode()) begin
              trk_description = $psprintf( "Schedule HCW SCIOV %s CQ 0x%0x VAS 0x%0x PASID 0x%0x",
                                   cq_type ? "LDB" : "DIR",
                                   cq_num,
                                   vas,
                                   monTxn.pasidtlp[22:0]
                                 );
            end else if (is_pf) begin
              trk_description = $psprintf( "Schedule HCW PF %s CQ 0x%0x VAS 0x%0x",
                                   cq_type ? "LDB" : "DIR",
                                   cq_num,
                                   vas
                                 );
            end else begin
              trk_description = $psprintf( "Schedule HCW VF%0d %s VCQ 0x%0x (CQ 0x%0x) VAS 0x%0x",
                                   vf_num,
                                   cq_type ? "LDB" : "DIR",
                                   vcq_num,
                                   cq_num,
                                   vas
                                 );
            end

            valid_hcw    = 1'b0;
            valid_cq_gen = 1'b0;

            hcw_hdr = {"IOSF Primary Monitor Transaction\n",trk_description};

            for (int i = 0; i < (i_hqm_cfg.is_single_hcw_per_cl(cq_type) ? 1 : (monTxn.length/4)); i++) begin

                hcw_trans = hcw_transaction::type_id::create("hcw_trans");
                hcw_trans.randomize();
                hcw_trans.byte_unpack(1, { monTxn.data[4*i + 3], monTxn.data[4*i + 2], monTxn.data[4*i + 1], monTxn.data[4*i + 0] });

                hcw_trans.sai              = monTxn.sai;
            
                hcw_trans.ppid             = is_pf ? cq_num : vcq_num;
                hcw_trans.is_vf            = ~is_pf;
                hcw_trans.vf_num           = vf_num;
                hcw_trans.sch_parity       = 0;
                hcw_trans.sch_error        = 0;
                hcw_trans.sch_cq_occ       = 0;
                hcw_trans.sch_is_ldb       = cq_type;
                hcw_trans.is_ldb           = cq_type;
                hcw_trans.sch_write_status = 0;
                hcw_trans.sch_addr         = cq_index;

                first_new_hcw_seen = 0;

                if (hcw_transaction_pkg::cq_gen_check(cq_gen_info,cq_type,cq_num,cq_index,max_cq_index,hcw_trans.cq_gen,hcw_trans.byte_pack(1))) begin
                  `ovm_info("HQM_BASE_TEST",$psprintf("%s Index %0d Gen %0d \n%s",hcw_hdr,cq_index,hcw_trans.cq_gen,hcw_trans.sprint_hcw_sch()),OVM_LOW)
                  if (seq_sch_out_mode == 0) begin
                    i_hcw_sch_out_port.write(hcw_trans);
                  end
                  if (~i_hqm_pp_cq_status.seq_manage_credits) begin
                    i_hqm_pp_cq_status.put_vas_credit(vas);
                  end
                  i_hqm_pp_cq_status.use_cq_token(cq_type,cq_num,cq_index);
                  first_new_hcw_seen = 1;
                  if (cq_type == 0) begin
                      if (i_hqm_cfg.is_disable_wb_opt(cq_type, cq_num)) begin
                          if (valid_hcw) begin
                              `ovm_error(get_full_name(), $psprintf("%s Index %0d disable wb_opt set and more than one HCWs seen with a single CQ write", hcw_hdr, cq_index))
                          end else begin
                              `ovm_info(get_full_name(), $psprintf("%s Index %0d disable wb_opt set and only single HCW seen with a single CQ write", hcw_hdr, cq_index), OVM_HIGH)
                          end
                      end
                  end
                  valid_hcw    = 1'b1;
                  valid_cq_gen = hcw_trans.cq_gen;
                  if (cq_type == 1) begin
                     i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].mon_sch_cnt++;
                  end else begin
                     i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].mon_sch_cnt++;
                  end
                end else begin
                  if (first_new_hcw_seen) begin // handle re-writing of valid HCWs (cq_gen_check() verifies same value written)
                    i_hqm_pp_cq_status.check_cq_token(cq_type,cq_num,cq_index);
                  end
                  if (valid_hcw) begin
                      if (i_hqm_cfg.is_pad_write(cq_type)) begin

                          bit [127:0] hcw_data;
                          
                          hcw_data = { monTxn.data[4*i + 3], monTxn.data[4*i + 2], monTxn.data[4*i + 1], monTxn.data[4*i + 0] };
                          if ($value$plusargs({"mbecc_wr_buffer", "=%s"},mbecc_wbuf)) begin
                              `ovm_info(get_full_name(),$psprintf("mbecc_wr_buffer %0s, original hcw %0h, valid_cq_gen %0b",mbecc_wbuf, hcw_data, valid_cq_gen), OVM_MEDIUM)
                              if (hcw_data[125]) begin
                                 case (mbecc_wbuf) 
                                   "MB_LS" : begin 
                                               if (hcw_data != { 2'b0, 1'b1, 4'b0, ~valid_cq_gen, 118'b0, 2'b11 }) begin
                                                  `ovm_error(get_full_name(), $psprintf("%s Index %0d is not padded with cq_gen(%0b) bit (hcw_data=0x%0x)", hcw_hdr, cq_index, ~valid_cq_gen, hcw_data));
                                               end
                                             end 
                                   "MB_MS" : begin 
                                               if (hcw_data != { 2'b0, 1'b1, 4'b0, ~valid_cq_gen, 54'b0, 2'b11, 64'b0 }) begin
                                                  `ovm_error(get_full_name(), $psprintf("%s Index %0d is not padded with cq_gen(%0b) bit (hcw_data=0x%0x)", hcw_hdr, cq_index, ~valid_cq_gen, hcw_data));
                                               end
                                             end
                                 endcase
                              end
                          end
                          else begin
                             if (hcw_data != { 7'b0, ~valid_cq_gen, 120'b0 }) begin
                                 `ovm_error(get_full_name(), $psprintf("%s Index %0d is not padded with cq_gen(%0b) bit (hcw_data=0x%0x)", hcw_hdr, cq_index, ~valid_cq_gen, hcw_data));
                             end else begin
                                 `ovm_info(get_full_name(), $psprintf("%s Index %0d is padded with cq_gen(%0b) bit (hcw_data=0x%0x)", hcw_hdr, cq_index, ~valid_cq_gen, hcw_data), OVM_HIGH);
                             end
                          end

                          if (i_hqm_cfg.is_pad_first_write(cq_type)) begin
                              if (monTxn.address[5:0] != 0) begin
                                  `ovm_error(get_full_name(), $psprintf("%s Index %0d pad first write dir is enabled and address(0x%0x) is not cache-aligned", hcw_hdr, cq_index, monTxn.address));
                              end else begin
                                  `ovm_info(get_full_name(), $psprintf("%s Index %0d pad first write dir is enabled and address(0x%0x) is cache-aligned", hcw_hdr, cq_index, monTxn.address), OVM_HIGH);
                              end
                          end 
                      end else begin
                          if (cq_type) begin
                              `ovm_error(get_full_name(), $psprintf("%s Index %0x, padding is disabled, LDB writes should be 16B only(%0d)", hcw_hdr, cq_index, (monTxn.length/4)))
                          end else begin

                              bit [127:0] hcw_data;

                              hcw_data = { monTxn.data[4*i + 3], monTxn.data[4*i + 2], monTxn.data[4*i + 1], monTxn.data[4*i] };
                              if (hcw_data == { 7'b0, ~valid_cq_gen, 120'b0 }) begin
                                  `ovm_error(get_full_name(), $psprintf("%s Index %0d padding is disabled, DIR writes(0x%0x) are seen with padded data", hcw_hdr, cq_index, hcw_data))
                              end
                          end
                      end
                  end
                end
                cq_index++;
            end
        end
     end
     
     //-------------------------
     //-- support vas reset
     //-------------------------
     if(i_hqm_cfg.hqm_proc_vasrst_comp==1) begin
        foreach(i_hqm_cfg.hqmproc_vasrst_dircq[i]) begin
             if(i_hqm_cfg.hqmproc_vasrst_dircq[i]==1) begin
	        hcw_transaction_pkg::do_cq_gen_vas_reset(cq_gen_info,0,i);
             end     	
        end
        foreach(i_hqm_cfg.hqmproc_vasrst_ldbcq[i]) begin
             if(i_hqm_cfg.hqmproc_vasrst_ldbcq[i]==1) begin
	        hcw_transaction_pkg::do_cq_gen_vas_reset(cq_gen_info,1,i);
             end     	
        end		     
	`ovm_info(get_full_name(), $psprintf("VASRST_DEBUG: i_hqm_cfg.hqm_proc_vasrst_comp=2"), OVM_LOW)
        i_hqm_cfg.hqm_proc_vasrst_comp=2;
     end
		     
     //-------------------------
     //-- support  reset
     //-------------------------
     if(i_hqm_cfg.hqm_rst_comp==1) begin
	`ovm_info(get_full_name(), $psprintf("HQMRST_DEBUG: i_hqm_cfg.hqm_rst_comp=1 - call cq_gen_reset() "), OVM_LOW)
        cq_gen_reset();     
	`ovm_info(get_full_name(), $psprintf("HQMRST_DEBUG: i_hqm_cfg.hqm_rst_comp=2"), OVM_LOW)
        i_hqm_cfg.hqm_rst_comp=2;
     end
		     
  endfunction : decode_cq_addr


  task decode_intr_writes(IosfMonTxn monTxn, output hqm_trans_type_e trans_type, output bit decoded, string trk_description);

      decoded = 1'b0;
      if ( (monTxn.eventType == Iosf::MDATA) &&
            (({ monTxn.format, monTxn.type_i } == Iosf::MWr32) ||
             ({ monTxn.format, monTxn.type_i } == Iosf::MWr64) ) &&
             (monTxn.length == 1) &&
             (monTxn.first_be == 4'hf)
           ) begin
           hcw_transaction hcw_trans;
           int             vcq_num;
           int             cq_num;
           int             cq_type;
           bit             is_pf;
           int             vf_num;
           bit             is_ims_int;
           int             int_num;
           bit             trans_decoded;
           int             ims_index;

           if (i_hqm_cfg.decode_cq_int_addr(monTxn.address,monTxn.data[0],monTxn.req_id,is_ims_int,int_num,cq_num,cq_type) == 1) begin
             if (is_ims_int) begin
               `ovm_info(get_full_name(),$psprintf("IMS CQ interrupt %0d SCIOV %s CQ 0x%0x Data 0x%08x", int_num, cq_type ? "LDB" : "DIR", cq_num, monTxn.data[0]),OVM_LOW)

               //--get ims_index
               ims_index =  i_hqm_cfg.get_ims_idx(cq_type,cq_num);                
               if(ims_index<0) 
                    ovm_report_fatal(get_full_name(), $psprintf("IMS CQ Interrupt %0d does not get IMS_IDX %0d, SCIOV %s CQ 0x%0x Data 0x%08x", int_num, ims_index, cq_type ? "LDB" : "DIR", cq_num, monTxn.data[0]));

               trk_description = $psprintf( "IMS CQ Interrupt %0d IMS_IDX %0d SCIOV %s CQ 0x%0x Data 0x%08x", int_num, ims_index, cq_type ? "LDB" : "DIR", cq_num, monTxn.data[0]);
               `ovm_info("HQM_BASE_TEST",$psprintf( "IOSF Primary Monitor Transaction - %s",trk_description),OVM_MEDIUM)
               exp_ep_ims[ims_index].trigger(); 
               trans_type         = CQ_INT;
               decoded = 1'b1;
             end else begin //is_ims_int
               trk_description = $psprintf( "MSIX %0d -> CQ Interrupt PF %s CQ 0x%0x Data 0x%08x", int_num,cq_type ? "LDB" : "DIR", cq_num, monTxn.data[0]);
              `ovm_info("HQM_BASE_TEST",$psprintf( "IOSF Primary Monitor Transaction - %s",trk_description),OVM_MEDIUM)
               exp_ep_msix[int_num].trigger();
               trans_type         = CQ_INT;
               decoded = 1'b1;
             end
           end else if (i_hqm_cfg.decode_comp_msix_cq_int_addr(monTxn.address,monTxn.data[0],monTxn.req_id) == 1) begin
             trk_description = $psprintf( "Compressed CQ Interrupt Data 0x%08x", monTxn.data[0]);

             `ovm_info("HQM_BASE_TEST",$psprintf( "IOSF Primary Monitor Transaction - %s", trk_description),OVM_MEDIUM)

             exp_ep_msix[1].trigger();
             trans_type         = COMP_CQ_INT;
             decoded = 1'b1;
           end else if (i_hqm_cfg.decode_ims_poll_addr(monTxn.address,monTxn.data[0],monTxn.req_id, cq_num, cq_type) == 1) begin
             trk_description = $psprintf( "IMS Poll Mode write %s CQ %0d w/data 0x%08x", cq_type ? "LDB" : "DIR", cq_num, monTxn.data[0]);

             `ovm_info("HQM_BASE_TEST",$psprintf( "IOSF Primary Monitor Transaction - %s", trk_description),OVM_MEDIUM)
             check_for_pasid(monTxn.pasidtlp, cq_num, cq_type);

             trans_type         = IMS_POLL_MODE_WR;
             decoded = 1'b1;
           end else if (i_hqm_cfg.decode_msix_int_addr(monTxn.address,monTxn.data[0],monTxn.req_id, int_num) == 1) begin
             trk_description = $psprintf( "MSIX %0d Interrupt Data 0x%08x", int_num, monTxn.data[0]);

             `ovm_info("HQM_BASE_TEST",$psprintf( "IOSF Primary Monitor Transaction - %s",trk_description),OVM_MEDIUM)

             trans_type         = MSIX_INT;
             decoded = 1'b1;
           end else begin
               ovm_report_info(get_full_name(), $psprintf("Address(0x%0x) -- couldn't be decoded for any of the interrupts", monTxn.address), OVM_HIGH);
           end

           // -- Check for PCIE TLP fields
           if (decoded) begin
             check_for_at(monTxn.addrTrSvc[1:0], 0);

             case (trans_type)
               CQ_INT: begin
                 if (is_ims_int) begin
                   // -- For all the interrupts the PASID and AT bits should be
                   // -- set to '0'
                   // Detect case where pasidtlp[22] is set for an interrupt
                   if (monTxn.pasidtlp[22]) begin
                     `ovm_error(get_full_name(),"HQM issued interrupt write with mpasidtlp[22] set")
                   end

                   check_cq_for_tc(monTxn.traffic_class, cq_num, cq_type);
                 end else begin
                   if (monTxn.pasidtlp[22]) begin
                     `ovm_error(get_full_name(),"HQM issued interrupt write with mpasidtlp[22] set")
                   end

                   // -- Check for TC in case of INT writes
                   check_int_for_tc(monTxn.traffic_class);
                 end
               end
               COMP_CQ_INT,MSI_INT,MSIX_INT: begin
                 if (monTxn.pasidtlp[22]) begin
                   `ovm_error(get_full_name(),"HQM issued interrupt write with mpasidtlp[22] set")
                 end

                 // -- Check for TC in case of INT writes
                 check_int_for_tc(monTxn.traffic_class);
               end
               IMS_POLL_MODE_WR: begin
                 check_cq_for_tc(monTxn.traffic_class, cq_num, cq_type);
               end
               default: begin
                 `ovm_fatal(get_full_name(),$psprintf("Illegal trans_type %s in decode_intr_writes()",trans_type.name()))
               end
             endcase
           end
      end
  endtask : decode_intr_writes

  function bit decode_completions_init_HQM(IosfMonTxn monTxn, output hqm_trans_type_e trans_type);

    decode_completions_init_HQM = 1'b0;
    if ( (monTxn.cmd inside { Iosf::Cpl } ) && (monTxn.eventType == Iosf::MCMD) ) begin
        decode_completions_init_HQM = 1'b1;
        trans_type = HQM_GEN_CPL;
    end
    if ( (monTxn.cmd inside { Iosf::CplD } ) && (monTxn.eventType == Iosf::MDATA) ) begin
        decode_completions_init_HQM = 1'b1;
        trans_type = HQM_GEN_CPLD;
    end
    if ( (monTxn.cmd inside { Iosf::CplLk } ) && (monTxn.eventType == Iosf::MCMD) ) begin
        decode_completions_init_HQM = 1'b1;
        trans_type = HQM_GEN_CPLLK;
        if ($test$plusargs("HQM_GEN_CPLLK_EXP")) begin
            ovm_report_info(get_full_name(), $psprintf("CplLK transaction generated by HQM and it was expected"), OVM_LOW); 
        end else begin
            ovm_report_error(get_full_name(), $psprintf("CplLK transaction generated by HQM, if it's expected, provide the plusargs HQM_GEN_CPLLK_EXP to mask it."));
        end
    end

    if ( (monTxn.cmd inside { Iosf::Cpl, Iosf::CplD, Iosf::CplLk } ) && (monTxn.eventType == Iosf::MCMD) ) begin
      // Detect case where pasidtlp[22] is set for a completion from HQM
      if (monTxn.pasidtlp[22]) begin
        `ovm_error(get_full_name(),"HQM completion with mpasidtlp[22] set")
      end
    end

  endfunction : decode_completions_init_HQM

  function bit decode_mem_write_to_hqm (IosfMonTxn monTxn, output hqm_trans_type_e trans_type, string trk_description);
      sla_ral_reg       my_reg;

      decode_mem_write_to_hqm = 1'b0;

      if ( ( ({ monTxn.format, monTxn.type_i } == Iosf::MWr64) || ({ monTxn.format, monTxn.type_i } == Iosf::MWr32) ) && 
           (monTxn.length inside { 4, 8, 12, 16 } ) &&
           ( (monTxn.first_be == 4'hf) && (monTxn.last_be == 4'hf) )
         ) begin

             hcw_transaction  hcw_trans;
             int              pp_num;
             int              vpp_num;
             int              pp_type;
             bit              is_pf;
             int              vf_num;
             bit              is_nm_pf;
             string           hcw_hdr;

             ovm_report_info(get_full_name(), $psprintf("HQM_IOSF_MON_DEBUG_%0s:: decode_mem_write_to_hqm Target Address=0x%0x length=%0d fbe=0x%0x ", inst_suffix, monTxn.address, monTxn.length, monTxn.first_be), OVM_HIGH);

             if (i_hqm_cfg.decode_pp_addr(monTxn.address,pp_num,pp_type,is_pf,vf_num,vpp_num, is_nm_pf) == 1) begin

                if ( (monTxn.eventType == Iosf::TCMD) && (monTxn.end_of_transaction == 1'b0) ) begin
                    ovm_report_info(get_full_name(), $psprintf("HQM_IOSF_MON_DEBUG_%0s:: decode_mem_write_to_hqm Iosf Primary Transaction HCW Enqueue Address(Address=0x%0x)", inst_suffix,monTxn.address), OVM_HIGH);
                    trans_type              = HCW_ENQ_ADDR;
                    decode_mem_write_to_hqm = 1'b1;
                    target_iosf_addr_q.push_back(monTxn.address);
                end

                if ( (monTxn.eventType == Iosf::TDATA) && (monTxn.end_of_transaction == 1'b1) ) begin
                 
                     if (check_target_iosf_addr_exists(monTxn.address)) begin
                         delete_addr_target_iosf_addr(monTxn.address);
                     end else begin
                         ovm_report_error(get_full_name(), $psprintf("HCW Enqueue Address(Address=0x%0x) doesn't exists in target_iosf_addr_q", monTxn.address));
                     end

                     trans_type              = HCW_ENQ;
                     decode_mem_write_to_hqm = 1'b1;
     
                     if (i_hqm_cfg.is_sciov_mode()) begin
                       trk_description = $psprintf( "Enqueue  HCW SCIOV %s PP 0x%0x SAI 0x%0x",
                                            pp_type ? "LDB" : "DIR",
                                            pp_num,
                                            monTxn.sai
                                          );
                     end else if (is_pf) begin
                       trk_description = $psprintf( "Enqueue  HCW PF %s PP 0x%0x SAI 0x%0x",
                                            pp_type ? "LDB" : "DIR",
                                            pp_num,
                                            monTxn.sai
                                          );
                     end else begin
                       trk_description = $psprintf( "Enqueue  HCW VF%0d %s VPP 0x%0x (PP 0x%0x) SAI 0x%0x",
                                            vf_num,
                                            pp_type ? "LDB" : "DIR",
                                            vpp_num,
                                            pp_num,
                                            monTxn.sai
                                          );
                     end

                     printTxnInIosfTrackerFile(trk_file,monTxn,trk_description);

                     hcw_hdr = $psprintf( "IOSF Primary Monitor Transaction\n%s", trk_description);

                    `ovm_info(get_full_name(), $psprintf("DBGIngress HCW with pp_type=%0d pp_num=%0d addr=0x%0x cacheline_addr=0x%0x len=%0d ", pp_type, pp_num, monTxn.address, monTxn.address[9:6], monTxn.length), OVM_MEDIUM);


                     for (int i = 0; i < (monTxn.length / 4); i++) begin

                         hcw_trans = hcw_transaction::type_id::create("hcw_trans");
                         `ovm_info(get_full_name(), $psprintf("DBGIngress HCW with addr=0x%0x len=%0d data=0x%0x - i=%0d", monTxn.address, monTxn.length, { monTxn.data[4 * i + 3], monTxn.data[4 * i + 2], monTxn.data[4 * i + 1], monTxn.data[4 * i + 0] }, i), OVM_MEDIUM);
                         hcw_trans.byte_unpack(0, { monTxn.data[4 * i + 3], monTxn.data[4 * i + 2], monTxn.data[4 * i + 1], monTxn.data[4 * i + 0] });
                         hcw_trans.sai             = monTxn.sai;
                         hcw_trans.is_nm_pf        = is_nm_pf;
                         hcw_trans.ppid            = is_pf ? pp_num : vpp_num;
                         hcw_trans.is_vf           = ~is_pf;
                         hcw_trans.vf_num          = vf_num;
                         hcw_trans.rtn_credit_only = 0;
                         hcw_trans.is_ldb          = pp_type;
                         hcw_trans.sch_is_ldb      = (hcw_trans.qtype == QDIR) ? 0 : 1;

                         if(monTxn.address[11:10] != 2'b_00) begin
                           hcw_trans.ingress_drop = 1;
                           `ovm_info(get_full_name(), $psprintf("HCW issued @addr(0x%0x) outside doorbell window size of the PP -> ingress_drop(%0d).", monTxn.address, hcw_trans.ingress_drop), OVM_LOW);
                         end

                         `ovm_info("HQM_BASE_TEST",$psprintf("%s\n%s",hcw_hdr,hcw_trans.sprint_hcw_enq()),OVM_MEDIUM)

                         `ovm_info(get_full_name(), $psprintf("DBGIngress HCW with addr=0x%0x len=%0d data=0x%0x - i_hcw_enq_in_port.write: hcw_trans.tbcnt=0x%0x", monTxn.address, monTxn.length, { monTxn.data[4 * i + 3], monTxn.data[4 * i + 2], monTxn.data[4 * i + 1], monTxn.data[4 * i + 0] }, hcw_trans.tbcnt), OVM_MEDIUM);

                         i_hcw_enq_in_port.write(hcw_trans);

                         case ({hcw_trans.qe_valid,hcw_trans.qe_orsp,hcw_trans.qe_uhl,hcw_trans.cq_pop})
                           4'b0001,4'b0011,4'b0111: begin
                             if(hcw_trans.qe_uhl == 1'b1 && hcw_trans.is_ldb==0) begin
                                //--this is illegal HCW (whole drop)
                             end else begin 
                                i_hqm_pp_cq_status.put_cq_tokens(pp_type,pp_num,hcw_trans.lockid[9:0] + 1);
                             end  
                           end
                           4'b1001,4'b1011,4'b1101: begin
                             if(hcw_trans.qe_uhl == 1'b1 && hcw_trans.is_ldb==0) begin 
                                //--this is illegal HCW (whole drop)
                             end else begin 
                                i_hqm_pp_cq_status.put_cq_tokens(pp_type,pp_num,1);
                             end
                           end
                         endcase
                         if (hcw_trans.qe_valid == 1'b1) begin
                             if (hcw_trans.is_ldb) begin
                                 i_hqm_pp_cq_status.ldb_pp_cq_status[pp_num].mon_enq_cnt++;
                             end else begin
                                 i_hqm_pp_cq_status.dir_pp_cq_status[pp_num].mon_enq_cnt++;
                             end
                         end
                     end
                end
             end
      end else if ( ( ({ monTxn.format, monTxn.type_i } == Iosf::MWr64) || ({ monTxn.format, monTxn.type_i } == Iosf::MWr32) ) && 
                    ( monTxn.length inside { 1 } ) && 
                    ( monTxn.first_be == 4'hf) )  begin // -- IA CSR Write
              if ( i_hqm_cfg.decode_func_pf_addr(monTxn.address) || i_hqm_cfg.decode_csr_pf_addr(monTxn.address) ) begin
              ovm_report_info(get_full_name(), $psprintf("HQM_IOSF_MON_DEBUG_%0s:: decode_mem_write_to_hqm CSR Write - Target Address=0x%0x length=%0d fbe=0x%0x ", inst_suffix, monTxn.address, monTxn.length, monTxn.first_be), OVM_HIGH);


                  if ( (monTxn.eventType == Iosf::TCMD) && (monTxn.end_of_transaction == 1'b0) ) begin
                      trans_type              = CSR_WRITE;
                      decode_mem_write_to_hqm = 1'b1;
                      ovm_report_info(get_full_name(), $psprintf("Address(Address=0x%0x) on input side to HQM decoded as CSR_WRITE", monTxn.address), OVM_HIGH);
                      target_iosf_addr_q.push_back(monTxn.address);
                  end
                  
                  if ( (monTxn.eventType == Iosf::TDATA) && (monTxn.end_of_transaction == 1'b1) ) begin
                      trk_description = { "Write - ",get_reg_name_by_addr(monTxn,"MEM")};

                      printTxnInIosfTrackerFile(trk_file,monTxn,trk_description);
                      trans_type              = CSR_WRITE_DATA;
                      decode_mem_write_to_hqm = 1'b1;
                      ovm_report_info(get_full_name(), $psprintf("Address(Address=0x%0x) on input side to HQM decoded as CSR_WRITE_DATA", monTxn.address), OVM_HIGH);
                      if (check_target_iosf_addr_exists(monTxn.address)) begin
                          delete_addr_target_iosf_addr(monTxn.address);
                      end else begin
                          ovm_report_error(get_full_name(), $psprintf("Address doesn't exists (Address=0x%0x) in target_iosf_addr_q", monTxn.address));
                      end
                  end
              end
      end

  endfunction : decode_mem_write_to_hqm

  function bit decode_mem_read_to_hqm(IosfMonTxn monTxn);
      string            trk_description;
      sla_ral_reg       my_reg;

      decode_mem_read_to_hqm = 1'b0;
      if ( (monTxn.eventType == Iosf::TCMD) &&
           ( ({ monTxn.format, monTxn.type_i } == Iosf::MRd64) || ({ monTxn.format, monTxn.type_i } == Iosf::MRd32) ) && 
           ( monTxn.length inside { 1 } ) &&
           ( monTxn.end_of_transaction == 1'b1 )
         ) begin

          if (i_hqm_cfg.decode_func_pf_addr(monTxn.address) || i_hqm_cfg.decode_csr_pf_addr(monTxn.address) ) begin 
              trk_description = { "Read  - ",get_reg_name_by_addr(monTxn,"MEM")};

              printTxnInIosfTrackerFile(trk_file,monTxn,trk_description);
              decode_mem_read_to_hqm = 1'b1;
          end
      end

  endfunction : decode_mem_read_to_hqm

  function bit decode_cfg_wr(IosfMonTxn monTxn, output hqm_trans_type_e trans_type);
      string            trk_description;
      sla_ral_reg       my_reg;

      decode_cfg_wr = 1'b0;

      if ( { monTxn.format, monTxn.type_i } == Iosf::CfgWr0 ) begin
          if ( (i_hqm_cfg.decode_pf_cfg_addr(monTxn.address) == 1'b1) ) begin

              if ( (monTxn.eventType == Iosf::TCMD) && (monTxn.end_of_transaction == 1'b0) ) begin 
                  ovm_report_info(get_full_name(), $psprintf("IOSF Primary Monitor Transaction -- CfgWr0 (Address=0x%0x)", monTxn.address), OVM_HIGH);
                  trans_type    = PCIE_CFG_WR0;
                  decode_cfg_wr = 1'b1;
                  target_iosf_addr_q.push_back(monTxn.address);
              end

              if ( (monTxn.eventType == Iosf::TDATA) && (monTxn.end_of_transaction == 1'b1) )begin
                  string reg_name;
                  reg_name = get_reg_name_by_addr(monTxn,"CFG");
                  trk_description = { "Write - ",reg_name};

                  if ((reg_name.tolower() == "hqm_pf_cfg_i.csr_bar_l") ||
                      (reg_name.tolower() == "hqm_pf_cfg_i.csr_bar_u") ||
                      (reg_name.tolower() == "hqm_pf_cfg_i.func_bar_l") ||
                      (reg_name.tolower() == "hqm_pf_cfg_i.func_bar_l")) begin
                    mem_addr_list.delete();
                  end

                  printTxnInIosfTrackerFile(trk_file,monTxn,trk_description);
                  ovm_report_info(get_full_name(), $psprintf("IOSF Primary Monitor Transaction -- CfgWr0 Data (Address=0x%0x)", monTxn.address), OVM_HIGH);
                  trans_type = PCIE_CFG_WR0_DATA;
                  decode_cfg_wr = 1'b1;
                  if (check_target_iosf_addr_exists(monTxn.address)) begin
                      delete_addr_target_iosf_addr(monTxn.address);
                  end else begin
                      ovm_report_error(get_full_name(), $psprintf("Address phase not seen for PCIE_CFG_WR0(Address=0x%0x)", monTxn.address));
                  end
              end
          end
      end

  endfunction : decode_cfg_wr

  function bit decode_cfg_rd(IosfMonTxn monTxn);
      string            trk_description;
      sla_ral_reg       my_reg;

      decode_cfg_rd = 1'b0;

      if ( (monTxn.eventType == Iosf::TCMD) &&
           ( { monTxn.format, monTxn.type_i } == Iosf::CfgRd0 ) &&
           (monTxn.end_of_transaction == 1'b1)
         ) begin
          ovm_report_info(get_full_name(), $psprintf("IOSF Primary Monitor Transaction - CfgRd0 (Address = 0x%0x)", monTxn.address), OVM_HIGH);
          if ( (i_hqm_cfg.decode_pf_cfg_addr(monTxn.address) == 1'b1) ) begin
              trk_description = { "Read  - ",get_reg_name_by_addr(monTxn,"CFG")};

              printTxnInIosfTrackerFile(trk_file,monTxn,trk_description);
              decode_cfg_rd = 1'b1;
          end
      end

  endfunction : decode_cfg_rd

  function string get_reg_name_by_addr(IosfMonTxn monTxn, string space = "MEM");
    sla_ral_file        files[$];
    sla_ral_reg         regs[$];
    sla_ral_reg         my_reg;
    sla_ral_addr_t      my_addr;
    string              reg_name;
    string              reg_name_tmp;
    bit [3:0]           be_mask;

    if (space == "MEM") begin
      if (mem_addr_list.size() == 0) begin
        files.delete();
        reg_name = "";

        ral.get_reg_files(files);

        foreach (files[i]) begin
          regs.delete();
          files[i].get_regs_by_space( regs, space);
          
          foreach (regs[j]) begin
            my_addr = regs[j].get_addr_val("iosf_pri");

            mem_addr_list[my_addr] = regs[j];
            reg_name_tmp = $psprintf("%s.%s",regs[j].get_file_name(),regs[j].get_name()) ; 
            ovm_report_info(get_full_name(), $psprintf("get_reg_name_by_addr MEM mem_addr_list[addr=0x%0x], reg[%0d]=%0s ", my_addr, j, reg_name_tmp), OVM_HIGH);
          end
        end
      end
    end else begin
      if (cfg_addr_list.size() == 0) begin
        files.delete();
        reg_name = "";

        ral.get_reg_files(files);

        foreach (files[i]) begin
          regs.delete();
          files[i].get_regs_by_space( regs, space);
          
          foreach (regs[j]) begin
            my_addr = regs[j].get_addr_val("iosf_pri");

           `ifdef IP_TYP_TE
              cfg_addr_list[my_addr] = regs[j];
              reg_name_tmp = $psprintf("%s.%s",regs[j].get_file_name(),regs[j].get_name()) ; 
              ovm_report_info(get_full_name(), $psprintf("get_reg_name_by_addr CFG cfg_addr_list[addr=0x%0x], reg[%0d]=%0s ", my_addr, j, reg_name_tmp), OVM_HIGH);
           `else
              if (cfg_addr_list.exists(my_addr)) begin
                 ovm_report_info(get_full_name(), $psprintf("get_reg_name_by_addr CFG cfg_addr_list[addr=0x%0x], reg[%0d]=%0s skip this (this addr exists in cfg_addr_list)", my_addr, j, reg_name_tmp), OVM_LOW);
              end else begin
                 cfg_addr_list[my_addr] = regs[j];
                 reg_name_tmp = $psprintf("%s.%s",regs[j].get_file_name(),regs[j].get_name()) ; 
                 ovm_report_info(get_full_name(), $psprintf("get_reg_name_by_addr CFG cfg_addr_list[addr=0x%0x], reg[%0d]=%0s ", my_addr, j, reg_name_tmp), OVM_LOW);
              end 
           `endif
          
          end
        end
      end
    end

    if (space == "MEM") begin
      ovm_report_info(get_full_name(), $psprintf("get_reg_name_by_addr MEM monTxn.address=0x%0x", monTxn.address), OVM_HIGH);
      if (mem_addr_list.exists(monTxn.address)) begin
        my_reg   = mem_addr_list[monTxn.address];
        reg_name = $psprintf("%s.%s",my_reg.get_file_name(),my_reg.get_name());
      end
    end else begin
      my_addr = monTxn.address;

      if ((monTxn.first_be & 4'b0001) == 4'b0001) begin
        my_addr[1:0] = 2'b00;
      end else if ((monTxn.first_be & 4'b0011) == 4'b0010) begin
        my_addr[1:0] = 2'b01;
      end else if ((monTxn.first_be & 4'b0111) == 4'b0100) begin
        my_addr[1:0] = 2'b10;
      end else if ((monTxn.first_be & 4'b1111) == 4'b1000) begin
        my_addr[1:0] = 2'b11;
      end


      `ifdef IP_TYP_TE
         ovm_report_info(get_full_name(), $psprintf("get_reg_name_by_addr CFG monTxn.address=0x%0x, my_addr=0x%0x", monTxn.address, my_addr), OVM_HIGH);
         if (cfg_addr_list.exists(my_addr)) begin
            my_reg   = cfg_addr_list[my_addr];
            reg_name = $psprintf("%s.%s",my_reg.get_file_name(),my_reg.get_name());
         end
      `else
         ovm_report_info(get_full_name(), $psprintf("get_reg_name_by_addr CFG monTxn.address=0x%0x, my_addr=0x%0x will take lower 24-bit addr=0x%0x", monTxn.address, my_addr, my_addr[23:0]), OVM_LOW);
         if (cfg_addr_list.exists(my_addr[23:0])) begin
            my_reg   = cfg_addr_list[my_addr[23:0]];
            reg_name = $psprintf("%s.%s",my_reg.get_file_name(),my_reg.get_name());
         end
      `endif
    end

    if (reg_name == "") begin
      reg_name = "No register match";
    end

    return(reg_name);
  endfunction : get_reg_name_by_addr

  function void check_for_at(bit [1:0] actual_at, bit [1:0] exp_at);

      string msg;

      msg = $psprintf("check_for_at(actual_at=%0b, exp_at=%0b)", actual_at, exp_at);
      ovm_report_info(get_full_name(), $psprintf("%0s -- Start", msg), OVM_DEBUG);
      if (actual_at == exp_at) begin
          ovm_report_info(get_full_name(), $psprintf("%0s -- actual_at == exp_at", msg), OVM_HIGH);
          end else begin
          ovm_report_error(get_full_name(), $psprintf("%0s -- actual_at != exp_at", msg));
          end
      ovm_report_info(get_full_name(), $psprintf("%0s -- End", msg),   OVM_DEBUG);

  endfunction : check_for_at

  function bit check_target_iosf_addr_exists(bit [63:0] address);

      int qi[$];

      qi = target_iosf_addr_q.find_first_index with (item == address);
      if (qi.size() == 0) begin
          return 1'b0;
      end else begin
          return 1'b1;
      end

  endfunction : check_target_iosf_addr_exists

  function void delete_addr_target_iosf_addr(bit [63:0] address);

      int qi[$];

      qi = target_iosf_addr_q.find_first_index with (item == address);
      target_iosf_addr_q.delete(qi[0]);


  endfunction : delete_addr_target_iosf_addr

  function void check_for_pasid(bit [22:0] pasidtlp, bit [7:0] cq_num, int cq_type);
      bit [22:0] exp_pasid;

      ovm_report_info(get_full_name(), $psprintf("check_for_pasid(pasidtlp=0x%0x, exp_pasid=0x%0x, cq_num=0x%0x cq_type=%s) -- Start", pasidtlp, exp_pasid, cq_num, cq_type ? "LDB" : "DIR"), OVM_MEDIUM);

      if (i_hqm_cfg.is_sciov_mode()) begin
        exp_pasid = i_hqm_cfg.get_pasid(cq_type, cq_num);

        if (pasidtlp[22]  == exp_pasid[22]) begin
            ovm_report_info(get_full_name(), $psprintf("In SCIOV mode, expected fmt2(%0b) equals actual pasid(%0b)", exp_pasid[22], pasidtlp[22]), OVM_HIGH);
        end else if(!$test$plusargs("HQM_SCIOV_BYPASS_PASID_CHECK"))begin
            ovm_report_error(get_full_name(), $psprintf("In SCIOV mode, expected fmt2(%0b) doesn't equal actual pasid(%0b)", exp_pasid[22], pasidtlp[22]));
        end
        if (pasidtlp[22] == 1'b1) begin
           if (pasidtlp[19:0] == exp_pasid[19:0]) begin
               ovm_report_info(get_full_name(), $psprintf("In SCIOV mode, PASID value(0x%0x) matches expected PASID(0x%0x) for %s CQ(0x%0x)", pasidtlp[19:0], exp_pasid, cq_type ? "LDB" : "DIR", cq_num), OVM_HIGH);
           end else if(!$test$plusargs("HQM_SCIOV_BYPASS_PASID_CHECK"))begin
               ovm_report_error(get_full_name(), $psprintf("In SCIOV mode, PASID value(0x%0x) doesn't matches expected PASID(0x%0x) for %s CQ(0x%0x)", pasidtlp[19:0], exp_pasid, cq_type ? "LDB" : "DIR", cq_num));
           end
        end
      end else begin
        if (pasidtlp[22]  == 1'b1) begin
          ovm_report_error(get_full_name(), $psprintf("Not in SCIOV mode, pasid fmt2 is 1 and should be 0, cq_num=0x%0x cq_type=%s", cq_num, cq_type ? "LDB" : "DIR"));
        end else begin
          ovm_report_info(get_full_name(), $psprintf("Not in SCIOV mode, pasid fmt2 is 0, as expected, cq_num=0x%0x cq_type=%s", cq_num, cq_type ? "LDB" : "DIR"), OVM_HIGH);
        end

        if (pasidtlp[19:0] == 0) begin
          ovm_report_info(get_full_name(), $psprintf("Not in SCIOV mode, PASID value (0x%0x) = 0 in case of fmt2=0x%0x, cq_num=0x%0x cq_type=%s", pasidtlp[19:0], pasidtlp[22], cq_num, cq_type ? "LDB" : "DIR"), OVM_HIGH);
        end else begin
          ovm_report_error(get_full_name(), $psprintf("Not in SCIOV mode, PASID value (0x%0x) != 0 in case of fmt2=0x%0x, cq_num=0x%0x cq_type=%s", pasidtlp[19:0], pasidtlp[22], cq_num, cq_type ? "LDB" : "DIR"));
        end
      end

      ovm_report_info(get_full_name(), $psprintf("check_for_pasid(pasidtlp=0x%0x, exp_pasid=0x%0x, cq_num=0x%0x cq_type=%s) -- End", pasidtlp, exp_pasid, cq_num, cq_type ? "LDB" : "DIR"), OVM_HIGH);
  endfunction : check_for_pasid

  function void check_cq_for_tc(bit [3:0] traffic_class, bit [7:0] cq_num, int cq_type);
      sla_ral_field     my_field;
      sla_ral_data_t    ral_data;
      bit [1:0]         cq_hash;
      bit [3:0]         exp_tc;

      if (cq_type) begin
        cq_hash =  cq_num[5:4];
        my_field = ral.find_field_by_name( $psprintf("ldb%0d_tc",cq_hash), "ldb_cq2tc_map", {"*",inst_suffix,".hqm_sif_csr"} );
      end else begin
        cq_hash = {^{cq_num[6],cq_num[4],cq_num[2],cq_num[0]},^{cq_num[5],cq_num[3],cq_num[1]}};
        my_field = ral.find_field_by_name( $psprintf("dir%0d_tc",cq_hash), "dir_cq2tc_map", {"*",inst_suffix,".hqm_sif_csr"} );
      end

      ral_data = my_field.get();

      exp_tc = ral_data[3:0];

      if (exp_tc != traffic_class) begin
        `ovm_error(get_full_name(), $psprintf("check_cq_for_tc(traffic_class=0x%0x, cq_num=0x%0x cq_type=%s) -- Traffic class does not match expected value of 0x%0x", traffic_class, cq_num, cq_type ? "LDB" : "DIR", exp_tc));
      end else begin
        `ovm_info(get_full_name(), $psprintf("check_cq_for_tc(traffic_class=0x%0x, cq_num=0x%0x cq_type=%s) -- Traffic class matches expected value of 0x%0x", traffic_class, cq_num, cq_type ? "LDB" : "DIR", exp_tc),OVM_HIGH);
      end
  endfunction : check_cq_for_tc

  function void check_int_for_tc(bit [3:0] traffic_class);
      sla_ral_field  my_field;
      sla_ral_data_t ral_data;
      bit [3:0] exp_tc;

      my_field = ral.find_field_by_name( "int_tc", "int2tc_map", {"*",inst_suffix,".hqm_sif_csr"} );
      ral_data = my_field.get();

      exp_tc = ral_data[3:0];

      if (exp_tc != traffic_class) begin
        `ovm_error(get_full_name(), $psprintf("check_int_for_tc(traffic_class=0x%0x) -- Traffic class does not match expected value of 0x%0x", traffic_class, exp_tc));
      end else begin
        `ovm_info(get_full_name(), $psprintf("check_int_for_tc(traffic_class=0x%0x) -- Traffic class matches expected value of 0x%0x", traffic_class, exp_tc), OVM_HIGH);
      end
  endfunction : check_int_for_tc

  function sla_ral_reg get_reg_handle(string reg_name, string file_name);

      ovm_report_info(get_full_name(), $psprintf("get_reg_handle(reg_name=%0s, file_name=%0s) -- Start", reg_name, file_name), OVM_DEBUG);
      get_reg_handle = ral.find_reg_by_file_name(reg_name, {"*",inst_suffix,".",file_name});
      if (get_reg_handle == null) begin
          ovm_report_fatal(get_full_name(), $psprintf("get_reg_handle(reg_name=%0s, file_name=%0s) -- Couldn't find reg handle", reg_name, file_name));
      end
      ovm_report_info(get_full_name(), $psprintf("get_reg_handle(reg_name=%0s, file_name=%0s) -- End"  , reg_name, file_name), OVM_DEBUG);

  endfunction : get_reg_handle

  function void report();

      ovm_report_info(get_full_name(), $psprintf("report -- Start"), OVM_DEBUG);

      // -- For DIR traffic
      ovm_report_info(get_full_name(), $psprintf("dircq_sch_16B_cnt=%0d", i_hqm_pp_cq_status.st_dircq_sch_16B_cnt), OVM_MEDIUM);
      foreach (i_hqm_pp_cq_status.dir_pp_cq_status[cq_num]) begin
          if (i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].st_sch_16B_cnt != 0) begin
              ovm_report_info(get_full_name(), $psprintf("dircq_sch_16B_cnt(CQ=0x%0x)-%0d", cq_num, i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].st_sch_16B_cnt), OVM_MEDIUM);
          end
      end
      ovm_report_info(get_full_name(), $psprintf("dircq_sch_32B_cnt=%0d", i_hqm_pp_cq_status.st_dircq_sch_32B_cnt), OVM_MEDIUM);
      foreach (i_hqm_pp_cq_status.dir_pp_cq_status[cq_num]) begin
          if (i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].st_sch_32B_cnt != 0) begin
              ovm_report_info(get_full_name(), $psprintf("dircq_sch_32B_cnt(CQ=0x%0x)-%0d", cq_num, i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].st_sch_32B_cnt), OVM_MEDIUM);
          end
      end
      ovm_report_info(get_full_name(), $psprintf("dircq_sch_48B_cnt=%0d", i_hqm_pp_cq_status.st_dircq_sch_48B_cnt), OVM_MEDIUM);
      foreach (i_hqm_pp_cq_status.dir_pp_cq_status[cq_num]) begin
          if (i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].st_sch_48B_cnt != 0) begin
              ovm_report_info(get_full_name(), $psprintf("dircq_sch_48B_cnt(CQ=0x%0x)-%0d", cq_num, i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].st_sch_48B_cnt), OVM_MEDIUM);
          end
      end
      ovm_report_info(get_full_name(), $psprintf("dircq_sch_64B_cnt=%0d", i_hqm_pp_cq_status.st_dircq_sch_64B_cnt), OVM_MEDIUM);
      foreach (i_hqm_pp_cq_status.dir_pp_cq_status[cq_num]) begin
          if (i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].st_sch_64B_cnt != 0) begin
              ovm_report_info(get_full_name(), $psprintf("dircq_sch_64B_cnt(CQ=0x%0x)-%0d", cq_num, i_hqm_pp_cq_status.dir_pp_cq_status[cq_num].st_sch_64B_cnt), OVM_MEDIUM);
          end
      end

      // -- For LDB traffic
      ovm_report_info(get_full_name(), $psprintf("ldbcq_sch_16B_cnt=%0d", i_hqm_pp_cq_status.st_ldbcq_sch_16B_cnt), OVM_MEDIUM);
      foreach (i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num]) begin
          if (i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].st_sch_16B_cnt != 0) begin
              ovm_report_info(get_full_name(), $psprintf("ldbcq_sch_16B_cnt(CQ=0x%0x)-%0d", cq_num, i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].st_sch_16B_cnt), OVM_MEDIUM);
          end
      end
      ovm_report_info(get_full_name(), $psprintf("ldbcq_sch_32B_cnt=%0d", i_hqm_pp_cq_status.st_ldbcq_sch_32B_cnt), OVM_MEDIUM);
      foreach (i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num]) begin
          if (i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].st_sch_32B_cnt != 0) begin
              ovm_report_info(get_full_name(), $psprintf("ldbcq_sch_32B_cnt(CQ=0x%0x)-%0d", cq_num, i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].st_sch_32B_cnt), OVM_MEDIUM);
          end
      end
      ovm_report_info(get_full_name(), $psprintf("ldbcq_sch_48B_cnt=%0d", i_hqm_pp_cq_status.st_ldbcq_sch_48B_cnt), OVM_MEDIUM);
      foreach (i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num]) begin
          if (i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].st_sch_48B_cnt != 0) begin
              ovm_report_info(get_full_name(), $psprintf("ldbcq_sch_48B_cnt(CQ=0x%0x)-%0d", cq_num, i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].st_sch_48B_cnt), OVM_MEDIUM);
          end
      end
      ovm_report_info(get_full_name(), $psprintf("ldbcq_sch_64B_cnt=%0d", i_hqm_pp_cq_status.st_ldbcq_sch_64B_cnt), OVM_MEDIUM);
      foreach (i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num]) begin
          if (i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].st_sch_64B_cnt != 0) begin
              ovm_report_info(get_full_name(), $psprintf("ldbcq_sch_64B_cnt(CQ=0x%0x)-%0d", cq_num, i_hqm_pp_cq_status.ldb_pp_cq_status[cq_num].st_sch_64B_cnt), OVM_MEDIUM);
          end
      end

      ovm_report_info(get_full_name(), $psprintf("report -- End"),   OVM_DEBUG);
  endfunction : report

/**************************************************************************
 *  Print any string to tracker file and return void
 *  @param trkFileHandle : int handle pointer to tracker file
 *  @param txn                   : iosfMonTxn to print in tracker file
 *  @param iosfTrackCups         : bit when set print CUPs to tracker file 
 **************************************************************************/
function int printTxnInIosfTrackerFile 
                          (int trkFileHandle = 0, 
                           IosfMonTxn txn  = null,
                           string trk_description = "",
                           bit includeCups = 0);
   string myBe, myData, myCmd, myAdrs;
   string myDir, myHit, tmp, out = "";
   IosfMonTxn         txnClone;

   $cast(txnClone, txn);//.cloneme());
   
   if (!gen_hqm_iosf_prim_trk_file) begin
     return(0);
   end

   if (!trkFileHandle)
     `ovm_error (get_full_name(), "no tracker file")   
   if (txnClone == null)
     `ovm_error (get_full_name(), "no monitor packet") 



   if (includeCups && (txnClone.eventType == Iosf::CREDITU)) begin: PRINT_CUP
      string   myCmdDataCrd;        // use rid_tag field to report cups
      $sformat (myCmdDataCrd,  "c=%1b d=%1h", txnClone.crdCmd, txnClone.crdData);
      // pad spaces to end of command name so we can cut them off evenly
      myAdrs = {txnClone.crdRtype.name, "         "};
      myAdrs = myAdrs.substr(0, 15);
      myAdrs = myAdrs.tolower ();
      myCmd  = "CUP     ";
      $sformat (tmp,     "|%15d|", txnClone.crdPutTime); out = {out, tmp};
      tmp =                  "U|";                  out = {out, tmp}; // D is up
      $sformat (tmp,       "%8s|", myCmd);          out = {out, tmp}; // CUP
      tmp =                  " |";                  out = {out, tmp}; // rs
      $sformat (tmp,      "%16s|", myAdrs);         out = {out, tmp}; // rtype
      $sformat (tmp,       "%8s|", myCmdDataCrd);   out = {out, tmp}; // rid_tag
      $sformat (tmp,     "%1h  |", txnClone.crdChid);    out = {out, tmp}; // ch/tc
      tmp =          "         |";                  out = {out, tmp}; // fbe_lbe
      tmp =  "                 |";                  out = {out, tmp}; // data
      tmp =                  " |";                  out = {out, tmp}; // hit
      tmp =          "         |";                  out = {out, tmp}; // d/sId
      tmp =             "      |";                  out = {out, tmp}; // pasidtlp
      tmp =               "    |";                  out = {out, tmp}; // sai
      tmp =              "     |";                  out = {out, tmp}; // cid
      tmp =                  " |";                  out = {out, tmp}; // A
      tmp =              "      |";                  out = {out, tmp}; // CEHIL
      tmp =             "      |";                  out = {out, tmp}; // NORSTG
      tmp =            " |";                  out = {out, tmp}; // cmd parity
      tmp =            "  |";                  out = {out, tmp}; //data parity
      $fdisplay (trkFileHandle, out);
      $fflush   (trkFileHandle);
   end // block: PRINT_CUP

   // ignore packets if end_of_transaction = 0
   if ((txnClone.end_of_transaction == 1) &&
       (txnClone.eventType != Iosf::CREDITU)) begin: PRINT_COMMAND_AND_DATA
      
      if ((txnClone.eventType == Iosf::MCMD) || (txnClone.eventType == Iosf::MDATA))
        myDir    = "U";
      else myDir = "D";

      // pad spaces to end of command name
      myCmd = {txnClone.cmd.name, "       "};
      myCmd = myCmd.substr(0, 7);

      // HSD 2903931 removed cpl status from BE
      // HSD 4548964 added cpl status to upper address bits
      // if completion, replace address[63:32] with completion status 
      if (Iosf::cmdIsCompletion (txnClone.cmd)) begin: PRINT_CPL_STATUS
         Iosf::iosf_status_t cplStatus;
         if ($isunknown (txnClone.first_be[2:0]))
           `ovm_error (get_full_name(), $sformatf("Unknown fbe[2:0]=0x%0h", txnClone.first_be[2:0])) 
         else $cast (cplStatus, txnClone.first_be[2:0]);

         case (cplStatus)
           Iosf::SC:  myBe = "SUC_CPL ";
           Iosf::UR:  myBe = "UR_CPL  ";
           Iosf::CA:  myBe = "CA_CPL  ";
           Iosf::CRS: myBe = "CRS_CPL ";
           default: 
             `ovm_error (get_full_name(), $sformatf("Undefined cplStatus=0x%0h", txnClone.first_be[2:0])) 
         endcase // case (cplStatus)
         $swrite (myAdrs, "%08s%08h", myBe, txnClone.address);
      end // block: PRINT_CPL_STATUS

      // Address[63:0]=0 for Cfg commands, so print BDF instead 
      else if (txnClone.cmd inside {Iosf::CfgRd0,  Iosf::CfgRd1,  
                               Iosf::CfgWr0,  Iosf::CfgWr1})
        $swrite (myAdrs, "%02h:%02h:%01h %08h", txnClone.address[31:24], 
                 txnClone.address[23:19], txnClone.address[18:16], txnClone.address[31:0]);
      else if (txnClone.cmd 
               inside {Iosf::Msg0,  Iosf::Msg1,  Iosf::Msg2,  Iosf::Msg3,
                       Iosf::Msg4,  Iosf::Msg5,  Iosf::Msg6,  Iosf::Msg7,
                       Iosf::MsgD0, Iosf::MsgD1, Iosf::MsgD2, Iosf::MsgD3,
                       Iosf::MsgD4, Iosf::MsgD5, Iosf::MsgD6, Iosf::MsgD7})
        begin: DECODE_PCIE_MSG
           $swrite (myAdrs, "%16h", txnClone.address);
        end // block: DECODE_PCIE_MSG
      else 
        // just print the 64-bit address if not cpl or cfg or msg
        $swrite (myAdrs, "%16h", txnClone.address);

      // replace data field if show command
      if (txnClone.show) myData = "    SHOW_CMD     ";
      else // pad spaces to first two data double words
        if (txnClone.reqContainsData (txnClone.cmd)) begin: PRINT_FIRST_DATA
           // length = 0 is max length
           if (txnClone.length == 1) $sformat (myData, "         %8h",txnClone.data[0]);
           else $sformat (myData, "%8h_%8h", txnClone.data[1], txnClone.data[0]); 
        end
        else myData = {17{" "}};
      myData = myData.toupper ();

      if ($isunknown (txnClone.miss)) myHit = "-"; // special case of X = '-'
      else myHit = (txnClone.miss)? "m" : "h";     // because Master leaves it = x 

      $sformat (tmp, "|%15d|",  txnClone.save_timing_gnt); out = {out, tmp};
      $sformat (tmp,   "%1s|",  myDir);               out = {out, tmp};
      $sformat (tmp,   "%8s|",  myCmd);               out = {out, tmp};
      $sformat (tmp,   "%1h|",  txnClone.root_space);      out = {out, tmp};
      $swrite  (tmp,  "%16s|",  myAdrs);              out = {out, tmp};
      $sformat (tmp,   "%4h_",  txnClone.req_id);          out = {out, tmp};
      $sformat (tmp,   "%3h|",  txnClone.tag);             out = {out, tmp};
      $sformat (tmp,   "%4d|",  txnClone.length);          out = {out, tmp};
      $sformat (tmp,   "%1h/",  txnClone.reqChid);         out = {out, tmp};
      $sformat (tmp,   "%1h|",  txnClone.traffic_class);   out = {out, tmp};
      $sformat (tmp,   "%4b_",  txnClone.first_be);        out = {out, tmp};
      $sformat (tmp,   "%4b|",  txnClone.last_be);         out = {out, tmp};
      $sformat (tmp,  "%17s|",  myData);              out = {out, tmp};
      $sformat (tmp,   "%1s|",  myHit);               out = {out, tmp};
      $sformat (tmp,   "%4h/",  txnClone.destID);          out = {out, tmp};
      $sformat (tmp,   "%4h|",  txnClone.srcID);           out = {out, tmp};
      $sformat (tmp,   "%6h|",  txnClone.pasidtlp);        out = {out, tmp};
      $sformat (tmp,   "%4h|",  txnClone.sai);             out = {out, tmp};
      $sformat (tmp,   "%5h|",  txnClone.cid);             out = {out, tmp};
      // $sformat (tmp,"%4h|",  txnClone.reqAgent);        out = {out, tmp};

      // unknown = "x" blank = zero (deasserted) uppercase = one (active)
        if ($isunknown (txnClone.addrTrSvc))     tmp = "x";
        else $sformat (tmp,   "%0d|",  txnClone.addrTrSvc);  out = {out, tmp};

        if ($isunknown (txnClone.addrTrSvc))     tmp = "x";
        else tmp = (txnClone.addrTrSvc)     ?   "A"  : " ";   out = {out, tmp};
      if (myDir == "U") begin
        if ($isunknown (txnClone.reqChain))      tmp = "x";
        else tmp = (txnClone.reqChain)      ?   "C"  : " ";   
      end
      else if (myDir == "D") begin
        if ($isunknown (txnClone.chain))      tmp = "x";
        else tmp = (txnClone.chain)      ?   "C"  : " ";   
      end
      else tmp = "x"; out = {out, tmp};      
      if ($isunknown (txnClone.error_present)) tmp = "x";
      else tmp = (txnClone.error_present) ?   "E"  : " ";   out = {out, tmp};
      if ($isunknown (txnClone.txn_hint))      tmp = "x";
      else tmp = (txnClone.txn_hint)      ?   "H"  : " ";   out = {out, tmp};
      if ($isunknown (txnClone.reqIdo))        tmp = "x";
      else tmp = (txnClone.reqIdo)        ?   "I"  : " ";   out = {out, tmp};
      if ($isunknown (txnClone.reqLocked))     tmp = "x|";
      else tmp = (txnClone.reqLocked)     ?   "L|" : " |";  out = {out, tmp};
      if (myDir == "U") begin
        if ($isunknown (txnClone.reqNs))         tmp = "x";
        else tmp = (txnClone.reqNs)         ?   "N"  : " ";
      end
      else if (myDir == "D") begin
        if ($isunknown (txnClone.non_snoop))      tmp = "x";
        else tmp = (txnClone.non_snoop)      ?   "N"  : " ";   
      end
      else tmp = "x"; out = {out, tmp};      
      if ($isunknown (txnClone.reqOpp))        tmp = "x";
      else tmp = (txnClone.reqOpp)        ?   "O"  : " ";   out = {out, tmp};
      if (myDir == "U") begin
        if ($isunknown (txnClone.reqRo))         tmp = "x";
        else tmp = (txnClone.reqRo)         ?   "R"  : " ";
      end
      else if (myDir == "D") begin
        if ($isunknown (txnClone.relaxed_ordering))         tmp = "x";
        else tmp = (txnClone.relaxed_ordering)         ?   "R"  : " ";
      end
      else tmp = "x"; out = {out, tmp};      
      if ($isunknown (txnClone.cmd_nfs_err))   tmp = "x";
      else tmp = (txnClone.cmd_nfs_err)   ?   "S"  : " ";   out = {out, tmp};
      if ($isunknown (txnClone.tlp_digest))    tmp = "x";
      else tmp = (txnClone.tlp_digest)    ?   "T" :  " ";   out = {out, tmp};
      if ($isunknown (txnClone.reqAgent))      tmp = "x|";
      else tmp = (txnClone.reqAgent)      ?   "G|" : " |";  out = {out, tmp};

      $sformat (tmp,     "%b|",  txnClone.command_parity);  out = {out, tmp};
      $sformat (tmp,     "%b",  txnClone.dparity[1]);  out = {out, tmp};
      $sformat (tmp,     "%b|", txnClone.dparity[0]);  out = {out, tmp};
      
      out = {out, trk_description};

      if (txnClone.reqContainsData (txnClone.cmd) && !txnClone.show) begin: PRINT_DATA
         int unsigned cnt = 2; // already printed first two above
         // int length = (txnClone.length)? txnClone.length: 1024;
         //int length = txnClone.dataArraySize ();
         int length = Iosf::getActualLength (txnClone.length, txnClone.cmd);
         while (cnt < length) begin 
            if (length < (cnt + 2))
              $sformat (myData, "         %8h", txnClone.data[cnt]);
            else
              $sformat (myData,  "%8h_%8h", txnClone.data[cnt+1], txnClone.data[cnt]);
            myData = myData.toupper ();
            out = {out, "\n"};                                      // line feed
            $sformat (tmp,    "|%15d|", txnClone.dataTime[cnt]); 
            out = {out, tmp};                                       // time
             $sformat (tmp,      "%1s|", myDir);   out = {out, tmp}; // D
            tmp =          "        |";           out = {out, tmp}; // cmd
            tmp =                 " |";           out = {out, tmp}; // root
            tmp =  "                |";           out = {out, tmp}; // address
            tmp =           "        |";           out = {out, tmp}; // rid_tag
            tmp =              "    |";           out = {out, tmp}; // len
            tmp =               "   |";           out = {out, tmp}; // ch/tc
            tmp =         "         |";           out = {out, tmp}; // fbe_lbe
            $sformat (tmp,     "%17s|", myData);  out = {out, tmp}; // data
            tmp =                 " |";           out = {out, tmp}; // hit
            tmp =         "         |";           out = {out, tmp}; // d/sId
            tmp =            "      |";           out = {out, tmp}; // pasidtlp
            tmp =              "    |";           out = {out, tmp}; // sai
            tmp =             "     |";           out = {out, tmp}; // cid
            // tmp =           "    |";           out = {out, tmp}; // agent
            tmp =                " |";           out = {out, tmp}; // A
            tmp =             "      |";           out = {out, tmp}; // ACEHIL
            tmp =            "      |";           out = {out, tmp}; // NORSTG
            tmp =           " |";           out = {out, tmp}; // cmd parity
            tmp =           "  |";           out = {out, tmp}; //data parity
            cnt += 2;
         end // while (cnt < txnClone.length)
      end // block: PRINT_DATA
      $fdisplay (trkFileHandle, out);
      $fflush   (trkFileHandle);
   end // block: PRINT_COMMAND_AND_DATA
   return 1;
endfunction: printTxnInIosfTrackerFile


//--------------------------------------------------------------------------------
//--AY_HQMV30_ATS
//--------------------------------------------------------------------------------
//------------------------------------------------
//--AY_HQMV30_ATS
//-- ATS Request
//------------------------------------------------
function bit decode_ats_request(IosfMonTxn monTxn, output string trk_description);

     decode_ats_request = 1'b0;

     if ( ( monTxn.eventType == Iosf::MCMD)   &&
          ( ( {monTxn.format, monTxn.type_i} == Iosf::MRd32) || ( {monTxn.format, monTxn.type_i} == Iosf::MRd64) ) && ( monTxn.addrTrSvc == 2'b01 ) &&
          ( monTxn.length inside {2} ) &&
          ( (monTxn.first_be == 4'hf) && (monTxn.last_be == 4'hf) )
        ) begin 

        HqmBusTxn       hqmbustxn;
        int             vpp_num;
        int             pp_num;
        int             pp_type;
        int             vcq_num;
        int             cq_num;
        int             cq_type;
        bit             is_pf;
        int             vf_num;
        int             vas;
        string          hcw_hdr;

        if (i_hqm_cfg.decode_cq_ats_request(monTxn.address,4 * monTxn.length,cq_num,cq_type,is_pf,vf_num,vcq_num) == 1) begin

            decode_ats_request = 1'b1;

            ovm_report_info(get_full_name(), $psprintf("decode_ats_request - Captured ATS Request from (is_ldb=%0b cq_num=0x%0x, monTxn.pasidtlp[22:0]=0x%0x, monTxn.length=%0d)", cq_type, cq_num, monTxn.pasidtlp[22:0], monTxn.length), OVM_MEDIUM);

            // -- Check for PASID in case of CQ writes
            check_for_pasid(monTxn.pasidtlp[22:0], cq_num, cq_type); 

            // -- Check for TC in case of CQ writes
            //--AY_HQMV30_ATS:: Do we need to check TC when it's ATS request??   check_cq_for_tc(monTxn.traffic_class, cq_num, cq_type); 

            vas = i_hqm_cfg.get_vas(cq_type,cq_num);

            if (is_pf) begin
              trk_description = $psprintf("PF %s CQ %3d ",cq_type ? "LDB" : "DIR", cq_num);
            end else begin
              trk_description = $psprintf("VF %2d %s VCQ %3d (CQ %3d) ",vf_num, cq_type ? "LDB" : "DIR", vcq_num, cq_num);
            end

            if (i_hqm_cfg.is_sciov_mode()) begin
              trk_description = $psprintf( "ATS Req SCIOV %s CQ 0x%0x VAS 0x%0x PASID 0x%0x",
                                   cq_type ? "LDB" : "DIR",
                                   cq_num,
                                   vas,
                                   monTxn.pasidtlp[22:0]
                                 );
            end else if (is_pf) begin
              trk_description = $psprintf( "ATS Req PF %s CQ 0x%0x VAS 0x%0x PASID 0x%0x",
                                   cq_type ? "LDB" : "DIR",
                                   cq_num,
                                   vas,
                                   monTxn.pasidtlp[22:0]
                                 );
            end else begin
              trk_description = $psprintf( "ATS Req VF%0d %s VCQ 0x%0x (CQ 0x%0x) VAS 0x%0x",
                                   vf_num,
                                   cq_type ? "LDB" : "DIR",
                                   vcq_num,
                                   cq_num,
                                   vas
                                 );
            end

            //--set_ats_req
            i_hqm_cfg.set_ats_request_txn_id(cq_type,cq_num,{monTxn.tag, monTxn.req_id});

            hcw_hdr = {"IOSF Primary Monitor Transaction\n",trk_description};

            //--
                hqmbustxn = HqmBusTxn::type_id::create("hqmbustxn");
                hqmbustxn.randomize();

                hqmbustxn.phase            = HQM_TXN_COMPLETE_PHASE;
                hqmbustxn.direction        = HQM_IP_TX;
                hqmbustxn.address          = monTxn.address;
                hqmbustxn.req_type         = HQM_NONPOSTED;
                hqmbustxn.cmd              = {monTxn.format, monTxn.type_i};
                hqmbustxn.txn_id           = {monTxn.tag, monTxn.req_id};
                hqmbustxn.pasidtlp         = monTxn.pasidtlp;
                hqmbustxn.length           = monTxn.length;
                hqmbustxn.tc               = monTxn.traffic_class;
                hqmbustxn.at               = HQM_AT_TRANSLATION_REQ;
                hqmbustxn.ro               = monTxn.relaxed_ordering;
                hqmbustxn.ns               = monTxn.non_snoop;
                hqmbustxn.ep               = monTxn.error_present;
                hqmbustxn.sai              = monTxn.sai;
                hqmbustxn.fbe              = monTxn.first_be;
                hqmbustxn.lbe              = monTxn.last_be;
                hqmbustxn.cparity          = monTxn.command_parity;
                hqmbustxn.start_time       = ($realtime/1ns); 
                hqmbustxn.chid             = monTxn.reqChid; //--request channel id? 

                hqmbustxn.is_ldb           = cq_type;
                hqmbustxn.cq_num           = cq_num;

                ovm_report_info(get_full_name(), $psprintf("decode_ats_request - Captured ATS Request from (is_ldb=%0b cq_num=0x%0x) : pass to i_HqmAtsPort with hqmbustxn - %s ", cq_type, cq_num, hqmbustxn.toString()), OVM_MEDIUM);
                i_HqmAtsPort.write(hqmbustxn);

        end
     end
  endfunction : decode_ats_request


//------------------------------------------------
//--AY_HQMV30_ATS
//-- ATS Response 
//------------------------------------------------
function bit decode_ats_response(IosfMonTxn monTxn, int is_cpld, output string trk_description);
    HqmBusTxn       hqmbustxn;
    int             vpp_num;
    int             pp_num;
    int             pp_type;
    int             vcq_num;
    int             cq_num;
    int             cq_type;
    bit             is_pf;
    int             vf_num;
    int             vas;
    string          hcw_hdr;
    bit             translation_size;
    bit             translation_nsnp;
    bit             translation_global;
    bit             translation_priv;
    bit             translation_exec;
    bit             translation_u;
    bit             translation_w;
    bit             translation_r;
    bit [63:0]      ats_cpld;
    bit [63:0]      translation_addr;
    HqmAtsPkg::PageSize_t      atsresp_pagesize;
    HqmTxnID_t      txn_id;
    bit             rc;
    HqmPcieCplStatus_t completion_status;

    decode_ats_response = 1'b0;

    txn_id = {monTxn.tag, monTxn.req_id};

    if(is_cpld==1) begin
        completion_status =  HQM_SC;// 3'b000;  

        for (int i = 0; i < (monTxn.length/2); i++) begin
            `ovm_info(get_full_name(), $psprintf("decode_ats_response_CplD - addr=0x%0x len=%0d data=0x%0x - i=%0d", monTxn.address, monTxn.length, {monTxn.data[i + 1], monTxn.data[i]}, i), OVM_MEDIUM);
             ats_cpld = {reverse_dw(monTxn.data[i]),  reverse_dw(monTxn.data[i + 1])}; //--data[i] upper 32-bit; data[i+1] lower 32-bit
        end 
        translation_size = ats_cpld[11];
        translation_nsnp = ats_cpld[10];
        translation_global = ats_cpld[5];
        translation_priv = ats_cpld[4];
        translation_exec = ats_cpld[3];
        translation_u = ats_cpld[2];
        translation_w = ats_cpld[1];
        translation_r = ats_cpld[0];

       `ovm_info(get_full_name(), $psprintf("decode_ats_response_CplD - addr=0x%0x len=%0d - ats_cpld=0x%0x translation_size=%0d nsnp=%0d global=%0d priv=%0d exec=%0d u=%0d w=%0d r=%0d", monTxn.address, monTxn.length, ats_cpld, translation_size, translation_nsnp, translation_global,translation_priv,translation_exec,translation_u,translation_w,translation_r), OVM_MEDIUM);

        if(translation_size==0) begin
           //-- S bit=0 => 4K size
           atsresp_pagesize = HqmAtsPkg::PAGE_SIZE_4K;
           translation_addr[63:0] = {ats_cpld[63:12], 12'h0};
        end else begin
           //-- S bit=1 => > 4K size 0_1111_1111
           if(ats_cpld[12]==0) begin
              atsresp_pagesize = HqmAtsPkg::PAGE_SIZE_8K;
              translation_addr[63:0] = {ats_cpld[63:13], 13'h0};
           end else if(ats_cpld[13:12]==2'b01) begin
              atsresp_pagesize = HqmAtsPkg::PAGE_SIZE_16K;
              translation_addr[63:0] = {ats_cpld[63:14], 14'h0};
           end else if(ats_cpld[14:12]==3'b011) begin
              atsresp_pagesize = HqmAtsPkg::PAGE_SIZE_32K;
              translation_addr[63:0] = {ats_cpld[63:15], 15'h0};
           end else if(ats_cpld[15:12]==4'b0111) begin
              atsresp_pagesize = HqmAtsPkg::PAGE_SIZE_64K;
              translation_addr[63:0] = {ats_cpld[63:16], 16'h0};
           end else if(ats_cpld[16:12]==5'b01111) begin
              atsresp_pagesize = HqmAtsPkg::PAGE_SIZE_128K;
              translation_addr[63:0] = {ats_cpld[63:17], 17'h0};
           end else if(ats_cpld[17:12]==6'b011111) begin
              atsresp_pagesize = HqmAtsPkg::PAGE_SIZE_256K;
              translation_addr[63:0] = {ats_cpld[63:18], 18'h0};
           end else if(ats_cpld[18:12]==7'b0111111) begin
              atsresp_pagesize = HqmAtsPkg::PAGE_SIZE_512K;
              translation_addr[63:0] = {ats_cpld[63:19], 19'h0};
           end else if(ats_cpld[19:12]==8'b01111111) begin
              atsresp_pagesize = HqmAtsPkg::PAGE_SIZE_1M;
              translation_addr[63:0] = {ats_cpld[63:20], 20'h0};
           end else if(ats_cpld[20:12]==9'b011111111) begin
              atsresp_pagesize = HqmAtsPkg::PAGE_SIZE_2M;
              translation_addr[63:0] = {ats_cpld[63:21], 21'h0};
           end else if(ats_cpld[29:12]=='h1ffff) begin
              atsresp_pagesize = HqmAtsPkg::PAGE_SIZE_1G;
              translation_addr[63:0] = {ats_cpld[63:29], 29'h0};
           end else if(ats_cpld[31:12]=='h7ffff) begin
              atsresp_pagesize = HqmAtsPkg::PAGE_SIZE_4G;
              translation_addr[63:0] = {ats_cpld[63:32], 31'h0};
           end else begin
              //-- error report
              `ovm_error(get_full_name(), $psprintf("decode_ats_response_CplD - addr=0x%0x len=%0d - ats_cpld=0x%0x translation_size=%0d not recognized", monTxn.address, monTxn.length, ats_cpld, translation_size));
           end
        end
       `ovm_info(get_full_name(), $psprintf("decode_ats_response_CplD - addr=0x%0x tag=%0d req_id=0x%0x - ats_cpld=0x%0x translation_size=%0d translation_addr=0x%0x atsresp_pagesize=%0s", monTxn.address, monTxn.tag, monTxn.req_id, ats_cpld, translation_size, translation_addr, atsresp_pagesize.name()), OVM_MEDIUM);
    end else begin
        completion_status = HqmPcieCplStatus_t'(monTxn.first_be[2:0]); //-- REVISIT to check the status field of IOSF monTxn
       `ovm_info(get_full_name(), $psprintf("decode_ats_response_Cpl - tag=%0d req_id=0x%0x - Cpl status = %0s ",  monTxn.tag, monTxn.req_id, completion_status.name()), OVM_MEDIUM);
    end //if(is_cpld==1) 

        //--------------------------------
        //-- find cq info by txn_id 
        //--------------------------------
        rc=i_hqm_cfg.decode_cq_by_ats_response_txnid(txn_id, cq_num, cq_type, is_pf, vf_num, vcq_num); 
       `ovm_info(get_full_name(), $psprintf("decode_ats_response - addr=0x%0x tag=%0d req_id=0x%0x - call decode_cq_by_ats_response_txnid txn_id=0x%0x get rc=%0d cq_type=%0d cq_num=%0d", monTxn.address, monTxn.tag, monTxn.req_id, txn_id, rc, cq_type, cq_num), OVM_MEDIUM);

        //--------------------------------
        //--------------------------------
        if (rc == 1) begin
            decode_ats_response = 1'b1;

            //--update_hpa_by_ats_response
            i_hqm_cfg.update_hpa_by_ats_response(cq_type, cq_num, completion_status, translation_addr, atsresp_pagesize);

            ovm_report_info(get_full_name(), $psprintf("decode_ats_response - Captured ATS Reponse send to (is_ldb=%0b cq_num=0x%0x) translation_addr=0x%0x atsresp_pagesize=%0s", cq_type, cq_num, translation_addr, atsresp_pagesize.name()), OVM_MEDIUM);

            vas = i_hqm_cfg.get_vas(cq_type,cq_num);

            if (is_pf) begin
              trk_description = $psprintf("PF %s CQ %3d ",cq_type ? "LDB" : "DIR", cq_num);
            end else begin
              trk_description = $psprintf("VF %2d %s VCQ %3d (CQ %3d) ",vf_num, cq_type ? "LDB" : "DIR", vcq_num, cq_num);
            end

            if (i_hqm_cfg.is_sciov_mode()) begin
              trk_description = $psprintf( "ATS Response %0s Returned to SCIOV %s CQ 0x%0x VAS 0x%0x Translation_Addr 0x%0x", completion_status.name(),
                                   cq_type ? "LDB" : "DIR",
                                   cq_num,
                                   vas,
                                   translation_addr
                                 );
            end else if (is_pf) begin
              trk_description = $psprintf( "ATS Response %0s Returned to PF %s CQ 0x%0x VAS 0x%0x Translation_Addr 0x%0x", completion_status.name(),
                                   cq_type ? "LDB" : "DIR",
                                   cq_num,
                                   vas,
                                   translation_addr
                                 );
            end else begin
              trk_description = $psprintf( "ATS Response %0s Returned to VF%0d %s VCQ 0x%0x (CQ 0x%0x) VAS 0x%0x Translation_Addr 0x%0x", completion_status.name(),
                                   vf_num,
                                   cq_type ? "LDB" : "DIR",
                                   vcq_num,
                                   cq_num,
                                   vas,
                                   translation_addr
                                 );
            end


            hcw_hdr = {"IOSF Primary Monitor Transaction\n",trk_description};

            hqmbustxn = HqmBusTxn::type_id::create("hqmbustxn");
            hqmbustxn.randomize();

            if(is_cpld==1) begin 
                hqmbustxn.phase            = HQM_TXN_COMPLETE_PHASE;
                hqmbustxn.direction        = HQM_IP_RX;
                hqmbustxn.address          = monTxn.address;
                hqmbustxn.req_type         = HQM_COMPLETION;
                hqmbustxn.cmd              = {monTxn.format, monTxn.type_i};
                hqmbustxn.txn_id           = {monTxn.tag, monTxn.req_id};
                hqmbustxn.pasidtlp         = monTxn.pasidtlp;
                hqmbustxn.length           = monTxn.length;
                hqmbustxn.tc               = monTxn.traffic_class;
                hqmbustxn.at               = HQM_AT_TRANSLATION_REQ;
                hqmbustxn.ro               = monTxn.relaxed_ordering;
                hqmbustxn.ns               = monTxn.non_snoop;
                hqmbustxn.ep               = monTxn.error_present;
                hqmbustxn.sai              = monTxn.sai;
                hqmbustxn.fbe              = monTxn.first_be;
                hqmbustxn.lbe              = monTxn.last_be;
                hqmbustxn.cparity          = monTxn.command_parity;
                hqmbustxn.start_time       = ($realtime/1ns); 
                hqmbustxn.chid             = monTxn.reqChid; //--request channel id? 
                hqmbustxn.data_bus_width   = 1;
                hqmbustxn.data.push_back(ats_cpld);
            end else begin
                hqmbustxn.phase            = HQM_TXN_COMPLETE_PHASE;
                hqmbustxn.direction        = HQM_IP_RX;
                hqmbustxn.address          = monTxn.address;
                hqmbustxn.req_type         = HQM_COMPLETION;
                hqmbustxn.cmd              = {monTxn.format, monTxn.type_i};
                hqmbustxn.txn_id           = {monTxn.tag, monTxn.req_id};
                hqmbustxn.pasidtlp         = monTxn.pasidtlp;
                hqmbustxn.length           = monTxn.length;
                hqmbustxn.tc               = monTxn.traffic_class;
                hqmbustxn.at               = HQM_AT_TRANSLATION_REQ;
                hqmbustxn.ro               = monTxn.relaxed_ordering;
                hqmbustxn.ns               = monTxn.non_snoop;
                hqmbustxn.ep               = monTxn.error_present;
                hqmbustxn.sai              = monTxn.sai;
                hqmbustxn.fbe              = monTxn.first_be;
                hqmbustxn.lbe              = monTxn.last_be;
                hqmbustxn.cparity          = monTxn.command_parity;
                hqmbustxn.start_time       = ($realtime/1ns); 
                hqmbustxn.chid             = monTxn.reqChid; //--request channel id? 
            end//if(is_cpld==)  
            
            hqmbustxn.is_ldb           = cq_type;
            hqmbustxn.cq_num           = cq_num;

            ovm_report_info(get_full_name(), $psprintf("decode_ats_response - Captured ATS Reponse send to (is_ldb=%0b cq_num=0x%0x): pass to i_HqmAtsPort with hqmbustxn - %s ", cq_type, cq_num, hqmbustxn.toString()), OVM_MEDIUM);
            i_HqmAtsPort.write(hqmbustxn);
        end else begin
           `ovm_error(get_full_name(), $psprintf("decode_ats_response - addr=0x%0x tag=%0d req_id=0x%0x - call decode_cq_by_ats_response_txnid txn_id=0x%0x didn't find cq_type=%0d cq_num=%0d -- Check!", monTxn.address, monTxn.tag, monTxn.req_id, txn_id, cq_type, cq_num));
        end
  endfunction : decode_ats_response



//------------------------------------------------
//--AY_HQMV30_ATS
//-- ATS INV_REQ 
//------------------------------------------------
function decode_ats_invalidation_request(IosfMonTxn monTxn, output string trk_description);

    HqmBusTxn       hqmbustxn;
    int             vpp_num;
    int             pp_num;
    int             pp_type;
    int             vcq_num;
    int             cq_num;
    int             cq_type;
    bit             is_pf;
    int             vf_num;
    int             vas;
    string          hcw_hdr;

    bit [63:0]      ats_inv_address;
    bit [63:0]      translation_addr;
    HqmTxnID_t      txn_id;
    bit             rc;

    // [PCIE 10.3.1] For Invalidation messages, Device ID (device target) is encoded in Address[31:16]
    // See Figure 2-12 (Signal to transaction type mapping summary) in the IOSF spec
    txn_id = {monTxn.tag, monTxn.address[31:16]};


        for (int i = 0; i < (monTxn.length/2); i++) begin
            `ovm_info(get_full_name(), $psprintf("decode_ats_invalidation_request - addr=0x%0x len=%0d data=0x%0x - i=%0d", monTxn.address, monTxn.length, {monTxn.data[i + 1], monTxn.data[i]}, i), OVM_MEDIUM);
             ats_inv_address = {reverse_dw(monTxn.data[i]),  reverse_dw(monTxn.data[i + 1])}; //--data[i] upper 32-bit; data[i+1] lower 32-bit
        end 
        ovm_report_info(get_full_name(), $psprintf("decode_ats_invalidation_request - Captured ATS INV_REQ to virtual address=0x%0x ITAG=%0d txn_id=0x%0x", ats_inv_address, monTxn.tag, txn_id), OVM_MEDIUM);

        rc = i_hqm_cfg.decode_cq_ats_request(ats_inv_address, 4 * monTxn.length,cq_num,cq_type,is_pf,vf_num,vcq_num);

        if(rc==1) begin
            ovm_report_info(get_full_name(), $psprintf("decode_ats_invalidation_request - Captured ATS INV_REQ sent from is_ldb=%0b cq_num=0x%0x", cq_type, cq_num), OVM_MEDIUM);

            vas = i_hqm_cfg.get_vas(cq_type,cq_num);

            if (is_pf) begin
              trk_description = $psprintf("PF %s CQ %3d ",cq_type ? "LDB" : "DIR", cq_num);
            end else begin
              trk_description = $psprintf("VF %2d %s VCQ %3d (CQ %3d) ",vf_num, cq_type ? "LDB" : "DIR", vcq_num, cq_num);
            end

            if (i_hqm_cfg.is_sciov_mode()) begin
              trk_description = $psprintf( "ATS INV_REQ ITAG 0x%0x Req_id 0x%0x to SCIOV %s CQ 0x%0x VAS 0x%0x", monTxn.tag, monTxn.req_id, 
                                   cq_type ? "LDB" : "DIR",
                                   cq_num,
                                   vas
                                 );
            end else if (is_pf) begin
              trk_description = $psprintf( "ATS INV_REQ ITAG 0x%0x Req_id 0x%0x to PF %s CQ 0x%0x VAS 0x%0x", monTxn.tag, monTxn.req_id,
                                   cq_type ? "LDB" : "DIR",
                                   cq_num,
                                   vas                                 );
            end else begin
              trk_description = $psprintf( "ATS INV_REQ ITAG 0x%0x Req_id 0x%0x to VF%0d %s VCQ 0x%0x (CQ 0x%0x) VAS 0x%0x", monTxn.tag, monTxn.req_id,
                                   vf_num,
                                   cq_type ? "LDB" : "DIR",
                                   vcq_num,
                                   cq_num,
                                   vas
                                 );
            end

            //--set_ats_req
            i_hqm_cfg.set_atsinvreq_txn_id(cq_type, cq_num, txn_id); 

            hcw_hdr = {"IOSF Primary Monitor Transaction\n",trk_description};
        end else begin
            ovm_report_error(get_full_name(), $psprintf("decode_ats_invalidation_request - Captured ATS INV_REQ ats_inv_address=0x%0x but not found which CQ by hqm_cfg.decode_cq_ats_request", ats_inv_address));
        end //if(rc==1) 

            //--
                hqmbustxn = HqmBusTxn::type_id::create("hqmbustxn");
                hqmbustxn.randomize();

                hqmbustxn.phase            = HQM_TXN_COMPLETE_PHASE;
                hqmbustxn.direction        = HQM_IP_RX;
                hqmbustxn.address          = monTxn.address;
                hqmbustxn.req_type         = HQM_POSTED;
                hqmbustxn.cmd              = {monTxn.format, monTxn.type_i};
                hqmbustxn.txn_id           = txn_id; 
                hqmbustxn.pasidtlp         = monTxn.pasidtlp;
                hqmbustxn.length           = monTxn.length;
                hqmbustxn.tc               = monTxn.traffic_class;
                hqmbustxn.at               = HQM_AT_TRANSLATION_REQ;
                hqmbustxn.ro               = monTxn.relaxed_ordering;
                hqmbustxn.ns               = monTxn.non_snoop;
                hqmbustxn.ep               = monTxn.error_present;
                hqmbustxn.sai              = monTxn.sai;
                hqmbustxn.fbe              = monTxn.first_be;
                hqmbustxn.lbe              = monTxn.last_be;
                hqmbustxn.cparity          = monTxn.command_parity;
                hqmbustxn.start_time       = ($realtime/1ns); 
                hqmbustxn.chid             = monTxn.reqChid; //--request channel id? 
                hqmbustxn.data_bus_width   = 1;
                hqmbustxn.data.push_back(ats_inv_address);

                hqmbustxn.is_ldb           = cq_type;
                hqmbustxn.cq_num           = cq_num;

                ovm_report_info(get_full_name(), $psprintf("decode_ats_invalidation_request - Captured ATS INV_REQ issued to (is_ldb=%0b cq_num=0x%0x) : pass to i_HqmAtsPort with hqmbustxn - %s ", cq_type, cq_num, hqmbustxn.toString()), OVM_MEDIUM);
                i_HqmAtsPort.write(hqmbustxn);

  endfunction : decode_ats_invalidation_request

//------------------------------------------------
//--AY_HQMV30_ATS
//-- ATS INV_RESP 
//-- ats_invresp_cnt[32] ats_invresp_num[32]
//------------------------------------------------
function bit decode_ats_invalidation_response(IosfMonTxn monTxn, output string trk_description);

    HqmBusTxn       hqmbustxn;
    int             vpp_num;
    int             pp_num;
    int             pp_type;
    int             vcq_num;
    int             cq_num;
    int             cq_type;
    bit             is_pf;
    int             vf_num;
    int             vas;
    string          hcw_hdr;

    bit [63:0]      ats_inv_address;
    bit [63:0]      translation_addr;
    HqmTxnID_t      txn_id;
    bit             rc;
    bit             clr_queue;
    bit [2:0]       ats_invresp_cc;
    bit [31:0]      ats_invresp_tag;
    bit [4:0]       ats_invresp_itag_val; //--0:31 5-bit ITAG acquired from address[63:32] bit map

    decode_ats_invalidation_response = 0;

    //--
    ats_invresp_tag = monTxn.address[63:32]; //--get 32-bit ITAG from address[63:32]
    ats_invresp_cc  = monTxn.address[2:0];   //--get 3-bit CC from address[2:0]

    //--get ITAG from address[63:32]
    for(int i=0; i<32; i++)  begin
       if (ats_invresp_tag[i] ) begin
            ats_invresp_itag_val = i;
       end
    end

    //txn_id = {monTxn.tag, monTxn.req_id};
    txn_id = {5'h0, ats_invresp_itag_val, monTxn.req_id};

    //--based on CC to count ats_invresp_cnt[ITAG]
    if(ats_invresp_cnt[ats_invresp_itag_val]==0) begin
       if(monTxn.address[2:0]==0) 
         ats_invresp_num[ats_invresp_itag_val] = 8;
       else 
         ats_invresp_num[ats_invresp_itag_val] = 1;
    end 
    
    if(ats_invresp_cnt[ats_invresp_itag_val] == (ats_invresp_num[ats_invresp_itag_val]-1)) begin
      clr_queue=1;
    end else begin
      clr_queue=0;
    end 
    `ovm_info(get_full_name(), $psprintf("decode_ats_invalidation_response - addr=0x%0x -> invresp_tag=0x%0x -> ITAG=%0d CC=%0d; -> ats_invresp_cnt[%0d]=%0d of ats_invresp_num[%0d]=%0d, clr_queue=%0d; with req_id=0x%0x txn_id=0x%0x message_code=0x%0x", monTxn.address, ats_invresp_tag, ats_invresp_itag_val, monTxn.address[2:0], ats_invresp_itag_val, ats_invresp_cnt[ats_invresp_itag_val], ats_invresp_itag_val, ats_invresp_num[ats_invresp_itag_val], clr_queue, monTxn.req_id, txn_id, {monTxn.last_be, monTxn.first_be}), OVM_MEDIUM);


        //--------------------------------
        //-- find cq info by txn_id 
        //--------------------------------
        rc=i_hqm_cfg.decode_cq_by_atsinvresp_txn_id(txn_id, clr_queue, cq_num, cq_type, is_pf, vf_num, vcq_num); 
       `ovm_info(get_full_name(), $psprintf("decode_ats_invalidation_response - addr=0x%0x ITAG=%0d req_id=0x%0x - call decode_cq_by_atsinvresp_txn_id by ITAG=%0d get rc=%0d cq_type=%0d cq_num=%0d", monTxn.address, ats_invresp_itag_val, monTxn.req_id, ats_invresp_itag_val, rc, cq_type, cq_num), OVM_MEDIUM);

        //--------------------------------
        //--------------------------------
        if (rc == 1) begin
            decode_ats_invalidation_response = 1'b1;
            ovm_report_info(get_full_name(), $psprintf("decode_ats_invalidation_response - Captured ATS INV_REQ sent from is_ldb=%0b cq_num=0x%0x", cq_type, cq_num), OVM_MEDIUM);

            vas = i_hqm_cfg.get_vas(cq_type,cq_num);

            if (is_pf) begin
              trk_description = $psprintf("PF %s CQ %3d ",cq_type ? "LDB" : "DIR", cq_num);
            end else begin
              trk_description = $psprintf("VF %2d %s VCQ %3d (CQ %3d) ",vf_num, cq_type ? "LDB" : "DIR", vcq_num, cq_num);
            end

            if (i_hqm_cfg.is_sciov_mode()) begin
              trk_description = $psprintf( "ATS INV_Resp ITAG 0x%0x Req_id 0x%0x to SCIOV %s CQ 0x%0x VAS 0x%0x", ats_invresp_itag_val, monTxn.req_id, 
                                   cq_type ? "LDB" : "DIR",
                                   cq_num,
                                   vas
                                 );
            end else if (is_pf) begin
              trk_description = $psprintf( "ATS INV_Resp ITAG 0x%0x Req_id 0x%0x to PF %s CQ 0x%0x VAS 0x%0x", ats_invresp_itag_val, monTxn.req_id,
                                   cq_type ? "LDB" : "DIR",
                                   cq_num,
                                   vas                                 );
            end else begin
              trk_description = $psprintf( "ATS INV_Resp ITAG 0x%0x Req_id 0x%0x to VF%0d %s VCQ 0x%0x (CQ 0x%0x) VAS 0x%0x", ats_invresp_itag_val, monTxn.req_id,
                                   vf_num,
                                   cq_type ? "LDB" : "DIR",
                                   vcq_num,
                                   cq_num,
                                   vas
                                 );
            end

            hcw_hdr = {"IOSF Primary Monitor Transaction\n",trk_description};
        end else begin
            ovm_report_error(get_full_name(), $psprintf("decode_ats_invalidation_response - Captured ATS INV_REQ ats_inv_address=0x%0x but not found which CQ by hqm_cfg.decode_cq_ats_request", ats_inv_address));
        end //if(rc==1) 

            //--
                hqmbustxn = HqmBusTxn::type_id::create("hqmbustxn");
                hqmbustxn.randomize();

                hqmbustxn.phase            = HQM_TXN_COMPLETE_PHASE;
                hqmbustxn.direction        = HQM_IP_TX;
                hqmbustxn.address          = monTxn.address;
                hqmbustxn.req_type         = HQM_POSTED;
                hqmbustxn.cmd              = {monTxn.format, monTxn.type_i};
                hqmbustxn.txn_id           = {monTxn.tag, monTxn.req_id};
                hqmbustxn.pasidtlp         = monTxn.pasidtlp;
                hqmbustxn.length           = monTxn.length;
                hqmbustxn.tc               = monTxn.traffic_class;
                hqmbustxn.at               = HQM_AT_TRANSLATION_REQ;
                hqmbustxn.ro               = monTxn.relaxed_ordering;
                hqmbustxn.ns               = monTxn.non_snoop;
                hqmbustxn.ep               = monTxn.error_present;
                hqmbustxn.sai              = monTxn.sai;
                hqmbustxn.fbe              = monTxn.first_be;
                hqmbustxn.lbe              = monTxn.last_be;
                hqmbustxn.cparity          = monTxn.command_parity;
                hqmbustxn.start_time       = ($realtime/1ns); 
                hqmbustxn.chid             = monTxn.reqChid; //--request channel id? 

                hqmbustxn.is_ldb           = cq_type;
                hqmbustxn.cq_num           = cq_num;

                ovm_report_info(get_full_name(), $psprintf("decode_ats_invalidation_response - Captured ATS INV_RESP ITAG %0d returned to (is_ldb=%0b cq_num=0x%0x) : pass to i_HqmAtsPort with hqmbustxn - %s ", ats_invresp_itag_val, cq_type, cq_num, hqmbustxn.toString()), OVM_MEDIUM);
                i_HqmAtsPort.write(hqmbustxn);

       //--
       ats_invresp_cnt[ats_invresp_itag_val]++;
       if(ats_invresp_cnt[ats_invresp_itag_val] == ats_invresp_num[ats_invresp_itag_val]) begin
          ats_invresp_cnt[ats_invresp_itag_val]=0;         
       end

  endfunction : decode_ats_invalidation_response



endclass
`endif
