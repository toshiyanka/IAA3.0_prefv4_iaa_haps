//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-03 
//-----------------------------------------------------------------
// Description:
// ccu_seqr class definition as part of ccu_vc_pkg
//------------------------------------------------------------------

`ifndef INC_ccu_seqr
`define INC_ccu_seqr 

/**
 * TODO: Add class description
 */
class ccu_seqr extends ovm_sequencer #(ccu_xaction);
   //------------------------------------------
   // Data Members 
   //------------------------------------------
   
   //------------------------------------------
   // Constraints 
   //------------------------------------------
   
   //------------------------------------------
   // Methods 
   //------------------------------------------
   
   // Standard OVM Methods 
   extern function       new   (string name = "", ovm_component parent = null);
   extern function void  build ();
   
   // APIs 
   
   // OVM Macros 
   `ovm_sequencer_utils (ccu_vc_pkg::ccu_seqr)
endclass :ccu_seqr

/**
 * ccu_seqr Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type ccu_seqr 
 */
function ccu_seqr::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/******************************************************************************
 * ccu_seqr class OVM build phase
 ******************************************************************************/
function void ccu_seqr::build ();
   // Super builder
   // -------------
   super.build ();
   
   // Get configuration
   // -----------------
     
   // Construct children
   // ------------------
   
   // Configure children
   // ------------------
endfunction :build

`endif //INC_ccu_seqr

