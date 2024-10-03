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

`ifndef HQM_IOSF_SB_DECODER__SV 
`define HQM_IOSF_SB_DECODER__SV 

//------------------------------------------------------------------------------
// File        : hqm_iosf_sb_decoder.sv
// Author      : Neeraj Shete
//
// Description : This class is derived form ovm_component and it intends to
//               decode txns seen on sideband interface and write to 
//               hqm_iosf_sb_txn_port for analysis.
//------------------------------------------------------------------------------

import ovm_pkg::*;
`include "ovm_macros.svh"
import IosfPkg::*;
import sla_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;
import iosfsbm_fbrc::*;
import iosfsbm_agent::*;

`include "hqm_sif_defines.sv"

typedef enum {
               IP_CFGWR0  = 0,  IP_CFGRD0  = 1,   IP_MWR    = 2,  IP_MRD  = 3,  IP_PWRGATEPOK = 4,     IP_RESETPREP  = 5, 
               OP_FUSEMSG = 6,  OP_IPREADY = 7,   OP_CPL    = 8,  OP_CPLD = 9,  OP_RESETPREPACK = 10,  OP_PCIEERRMSG = 11,
               OP_DOSERR  = 12, IP_UNKNOWN = 13,  OP_UNKNOWN=14,  IP_CPLD = 15,  IP_CPL = 16
             } hqm_sb_opcode_t;

typedef struct {
    iosfsbm_cm::xaction  sb_txn;
    hqm_sb_opcode_t      opcode;
} iosf_sb_txn_t;

class hqm_iosf_sb_decoder extends ovm_component;

  `ovm_component_utils(hqm_iosf_sb_decoder)
  // -- SVC handle for analysis ports -- //
  iosfsbm_fbrcvc        iosf_svc_tlm;
  
  ovm_analysis_port     #(iosf_sb_txn_t)   i_iosf_sb_txn_port;
  
  // -- analysis export for monitor
  ovm_analysis_export   #(iosfsbm_cm::xaction)    fab_sbc_montxrcv_export; 
  ovm_analysis_export   #(iosfsbm_cm::xaction)    agt_sbc_montxrcv_export; 

  // -- fifo to store xactions received from monitor
  tlm_analysis_fifo     #(iosfsbm_cm::xaction)    fab_sbc_afifo; 
  tlm_analysis_fifo     #(iosfsbm_cm::xaction)    agt_sbc_afifo; 

  ovm_event_pool                      global_pool;
  ovm_event                           hqm_ForcePwrGatePOK;
  extern    function                  new( string name = "hqm_iosf_sb_decoder", ovm_component parent = null);
  extern    virtual    function void  build();
  extern               function void  connect ();
  extern    virtual    task           run();
  extern    virtual    task           get_sb_fab_mon_txn ();
  extern    virtual    task           get_sb_agt_mon_txn ();
  extern               function void  send_valid_ip_opcode(iosfsbm_cm::xaction mon_txn);
  extern               function void  send_valid_op_opcode(iosfsbm_cm::xaction mon_txn);


endclass : hqm_iosf_sb_decoder

  // ***************************************************************
  // new - constructor
  // ***************************************************************
  function hqm_iosf_sb_decoder::new (string name = "hqm_iosf_sb_decoder", ovm_component parent = null);
    super.new(name, parent);
    global_pool  = ovm_event_pool::get_global_pool();
    hqm_ForcePwrGatePOK = global_pool.get("hqm_ForcePwrGatePOK");
  endfunction : new

  // -----------------------------------------------------------------------------
  // -- Builds components used 
  // -----------------------------------------------------------------------------

  function void hqm_iosf_sb_decoder::build();

    super.build();

    // -- 
    i_iosf_sb_txn_port  = new("i_iosf_sb_txn_port", this);
	// Construct monitor com channels
	fab_sbc_montxrcv_export = new ("fab_sbc_montxrcv_export", this);
	agt_sbc_montxrcv_export = new ("agt_sbc_montxrcv_export", this);
	fab_sbc_afifo       = new ("fab_sbc_afifo",       this);
	agt_sbc_afifo       = new ("agt_sbc_afifo",       this);

  endfunction : build

  // -----------------------------------------------------------------------------
  // -- Connect components
  // -----------------------------------------------------------------------------

  function void hqm_iosf_sb_decoder::connect ();
	ovm_object temp_iosf_svc_tlm;
    super.connect();
    // -- Get handles from parent env to SVC -- //
	if(get_config_object("iosf_svc_tlm",temp_iosf_svc_tlm))	begin
	  if(!$cast(iosf_svc_tlm,temp_iosf_svc_tlm))
		`ovm_error(get_name(),"Config setting for 'iosf_svc_tlm' not of type iosfsbm_fbrcvc")
      if(iosf_svc_tlm == null) `ovm_error(get_full_name(),$psprintf("iosf_svc_tlm ptr is null"))  
      else                     `ovm_info(get_full_name() ,$psprintf("iosf_svc_tlm ptr is not null"),OVM_LOW)

	end
	else begin 
		`ovm_error(get_name(),"No set_config_object method found for setting iosf_svc_tlm")
	end

	iosf_svc_tlm.fbrc_monitor_i.fab_agt_ap.connect(fab_sbc_montxrcv_export);
	fab_sbc_montxrcv_export.connect(fab_sbc_afifo.analysis_export);

	iosf_svc_tlm.fbrc_monitor_i.agt_fab_ap.connect(agt_sbc_montxrcv_export);
	agt_sbc_montxrcv_export.connect(agt_sbc_afifo.analysis_export);

  endfunction : connect


  // -----------------------------------------------------------------------------
  // -- Run phase, Spawns always ON tasks to receive and decode txns from SVC  
  // -----------------------------------------------------------------------------

 task hqm_iosf_sb_decoder::run();

   `ovm_info("hqm_iosf_sb_decoder", $sformatf("Entered run phase of hqm_iosf_sb_decoder "), OVM_LOW)
   fork
    get_sb_fab_mon_txn ();
    get_sb_agt_mon_txn ();
   join_none
 endtask : run

  // -----------------------------------------------------------------------------
  // -- Receive OP txns from DUT and send to decode
  // -----------------------------------------------------------------------------

 task hqm_iosf_sb_decoder::get_sb_agt_mon_txn ();
    iosfsbm_cm::xaction mon_txn;
    forever begin
      agt_sbc_afifo.get (mon_txn);
      `ovm_info ($psprintf("%s",this.get_name()), $psprintf("iosf_sb_agt_mon Observed %s", mon_txn.sprint_header()), OVM_DEBUG)
      send_valid_op_opcode(mon_txn);
    end
 endtask: get_sb_agt_mon_txn

  // -----------------------------------------------------------------------------
  // -- Receive IP txns to DUT and send to decode
  // -----------------------------------------------------------------------------

 task hqm_iosf_sb_decoder::get_sb_fab_mon_txn ();
    iosfsbm_cm::xaction mon_txn;
    forever begin
      fab_sbc_afifo.get (mon_txn);
      `ovm_info ($psprintf("%s",this.get_name()), $psprintf("iosf_sb_fab_mon Observed %s", mon_txn.sprint_header()), OVM_DEBUG)
      send_valid_ip_opcode(mon_txn);
    end
 endtask: get_sb_fab_mon_txn

  // -----------------------------------------------------------------------------
  // -- Detect txns sent to DUT and write to analysis port. Warn if unsupported.
  // -----------------------------------------------------------------------------

 function void hqm_iosf_sb_decoder::send_valid_ip_opcode(iosfsbm_cm::xaction mon_txn);
    iosf_sb_txn_t obs_txn;
    obs_txn.sb_txn = mon_txn; // -- review: Have a cloned txn sent out -- //
    case(mon_txn.opcode)
       'h_04  : obs_txn.opcode = IP_CFGWR0      ;
       'h_05  : obs_txn.opcode = IP_CFGRD0      ;
       'h_01  : obs_txn.opcode = IP_MWR         ;
       'h_00  : obs_txn.opcode = IP_MRD         ;
       'h_21  : obs_txn.opcode = IP_CPLD        ;
       'h_20  : obs_txn.opcode = IP_CPL         ;
       'h_2e  : obs_txn.opcode = IP_PWRGATEPOK  ;
       'h_2a  : obs_txn.opcode = IP_RESETPREP   ;
       default: obs_txn.opcode = IP_UNKNOWN     ;
    endcase
    if (obs_txn.opcode == IP_PWRGATEPOK) begin
        hqm_ForcePwrGatePOK.trigger();
        `ovm_info(get_type_name(),"triggered ForcePwrGatePOK event", OVM_LOW);
    end 
    if(obs_txn.opcode == IP_UNKNOWN) `ovm_warning(get_full_name(), $sformatf("Received illegal sideband opcode on IP of HQM for txn: %s", mon_txn.sprint_header()))
    i_iosf_sb_txn_port.write(obs_txn);
 endfunction : send_valid_ip_opcode

  // -----------------------------------------------------------------------------
  // -- Detect OP txns from DUT and write to analysis port. Error if unsupported.
  // -----------------------------------------------------------------------------

 function void hqm_iosf_sb_decoder::send_valid_op_opcode(iosfsbm_cm::xaction mon_txn);
    iosf_sb_txn_t obs_txn;
    obs_txn.sb_txn = mon_txn; 
    case(mon_txn.opcode)
       'h_45  : obs_txn.opcode = OP_FUSEMSG      ;
       'h_d0  : obs_txn.opcode = OP_IPREADY      ;
       'h_20  : obs_txn.opcode = OP_CPL          ;
       'h_21  : obs_txn.opcode = OP_CPLD         ;
       'h_2b  : obs_txn.opcode = OP_RESETPREPACK ;
       'h_49  : obs_txn.opcode = OP_PCIEERRMSG   ;
       'h_88  : obs_txn.opcode = OP_DOSERR       ;
       default: obs_txn.opcode = OP_UNKNOWN      ;
    endcase
    if(obs_txn.opcode == OP_UNKNOWN) `ovm_error(get_full_name(), $sformatf("Received invalid sideband opcode on OP of HQM for txn: %s", mon_txn.sprint_header()))
    i_iosf_sb_txn_port.write(obs_txn);
 endfunction : send_valid_op_opcode

`endif
