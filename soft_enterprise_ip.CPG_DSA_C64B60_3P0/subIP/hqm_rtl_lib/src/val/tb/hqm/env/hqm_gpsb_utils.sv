//=============================================================================
//  Copyright (c) 2012 Intel Corporation, all rights reserved.
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY COPYRIGHT LAWS AND
//  IS CONSIDERED A TRADE SECRET BELONGING TO THE INTEL CORPORATION.
//
//  Intel Confidential
//=============================================================================
//
// hqm_gpsb_utils.sv, 
//-----------------------------------------------------------------------------
// Description : GPSB base connector file that lists out all the connector functions
//
//-----------------------------------------------------------------------------
// Author  :
// Date    :
//=============================================================================
// This is is copied from HQM_SS needed to use iosf_sb_protocol libs

import iosfsbm_cm::*;

class hqm_gpsb_utils extends iosfsb_base_utils;

   static hqm_gpsb_utils singleton;
   string classname;

   `ovm_object_utils(hqm_gpsb_utils)

   function new (string n = "hqm_gpsb_utils");
       super.new (n);
   endfunction : new

   // method returns the sequencer for a particular epid
   virtual function iosfsbm_cm::iosfsbc_sequencer get_iosfsb_register_sequencer(iosfsb_connector_pkg::iosfsb_pid_t epid);

      iosfsbm_cm::iosfsbc_sequencer sb_seqr;
     // pick from saola sequencer
     string epid_s;
      string seqr_tag;

      epid_s.hextoa(epid);
      seqr_tag = {"GPSB_DSTID_",epid_s};
      `ovm_info(get_type_name(), $psprintf("seqr_tag = %s", seqr_tag), OVM_NONE)

      // NOTE: RLINK uses a hard-coded seqr_tag as seen above to workaround a problem here.
      assert($cast(sb_seqr, sla_sequencer::pick_sequencer(seqr_tag)));
      `ovm_info(get_type_name(), $psprintf("picked sequencer = %s",sb_seqr.get_full_name()), OVM_NONE)
      if (sb_seqr == null) begin
          `ovm_warning(classname, $psprintf("No sequencer in SAOLA for DSTID = %s  family",seqr_tag))
          return null;
      end
      else begin 
          return(sb_seqr); 
      end
          
   endfunction : get_iosfsb_register_sequencer


endclass : hqm_gpsb_utils
