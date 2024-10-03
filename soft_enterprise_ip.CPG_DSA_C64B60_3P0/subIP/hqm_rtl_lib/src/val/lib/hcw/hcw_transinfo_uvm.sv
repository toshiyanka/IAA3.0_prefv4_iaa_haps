//-----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2013) (2013) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
//------------------------------------------------------------------------------
// File   : hcw_transinfo.sv
//
// Description :
//
// This class encapsulate hcw trans infos 
//------------------------------------------------------------------------------
`ifndef HCW_TRANSINFOR__SV
`define HCW_TRANSINFOR__SV

class hcw_transinfo extends uvm_object;

  `uvm_object_utils(hcw_transinfo)


 //------------------------- 
 //-- hcw_transinfo fields
 //-------------------------  
  
 
 //------------------------- 
 //-- hcw supporting fields
 //-------------------------   


 
 bit		   is_enqed;
 bit		   is_toked;
 bit               is_sched;   
 bit		   is_compled;
 
 
 bit               info_isdir;   
 logic [63:0]	   info_tbcnt;

 logic [2:0]       info_msgtype;
 hcw_qtype         info_qtypesch;
 logic [63:0]	   info_tbcntsch;
 logic [15:0]      info_lkid;
 
 bit   [1:0]	   info_enqattr;    
 bit		   info_reord;    
 logic [4:0]	   info_frg_cnt;
 logic [3:0]	   info_frg_ldbcnt; 
 bit		   info_frg_last;
 logic [5:0]	   info_ordqid;  //-- 
 logic [6:0]	   info_ordpri;  //-- 
 logic [15:0]	   info_ordlockid;  //-- 
 logic [15:0]	   info_ordidx;  //-- track ordidx in the same ordqid	   
 
 
 logic [5:0]	   info_ppidx;  //--V2_TB  ENQ ppid 
 logic      	   info_isldb;  //--V2_TB  ENQ is_ldb
 
 //------------------------- 
 //-- hcw descriptor supporting fields
 //-------------------------  

 
  
 
 //------------------------- 
 // Function: new 
 // Class constructor
 //------------------------- 
  function new (string name = "hcw_transinfo_inst");
    super.new(name);
  endfunction : new


  //---------------------------------------------------------------------------- 
  //-- functions 
  //----------------------------------------------------------------------------
  //-- lkid   
  virtual function set_lkid ( bit[15:0] lkidval ) ;
      info_lkid = lkidval ;
  endfunction : set_lkid 

  virtual function bit[15:0] get_lkid ( ) ;
     return info_lkid ;
  endfunction : get_lkid 

  //-- tbcnt   
  virtual function set_tbcnt ( bit[63:0] val ) ;
      info_tbcnt = val ;
  endfunction : set_tbcnt 

  virtual function bit[63:0] get_tbcnt ( ) ;
     return info_tbcnt ;
  endfunction : get_tbcnt 

  //-- ordqid
  virtual function set_ordqid ( bit[5:0] val ) ;
     info_ordqid = val ;
  endfunction : set_ordqid 

  virtual function bit[5:0] get_ordqid ( ) ;
     return info_ordqid ;
  endfunction : get_ordqid 

  //-- ordidx
  virtual function set_ordidx ( bit[15:0] val ) ;
     info_ordidx = val ;
  endfunction : set_ordidx 

  virtual function bit[15:0] get_ordidx ( ) ;
     return info_ordidx ;
  endfunction : get_ordidx   

  //---------------------------------------------------------------------------- 
  //---------------------------------------------------------------------------- 
  //-- other supporting functions 
  //----------------------------------------------------------------------------   
                                
endclass : hcw_transinfo


`endif
