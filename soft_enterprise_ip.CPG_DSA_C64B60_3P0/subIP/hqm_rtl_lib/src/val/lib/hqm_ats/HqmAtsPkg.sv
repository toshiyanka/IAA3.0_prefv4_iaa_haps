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
// Owner:       Adil Shaaeldin
// Created On:  5/1/2017
// Description: ATS Package
//              --------------------------
//                  + IOMMU layers and its API
//                  + ATS Tracker
//                  + ATS sequences - Page Response (PRSP) and Invalidation Request (IREQ)
//
//              Refer to PCI-SIG specification Address Translation Services v.1.1
//
// -----------------------------------------------------------------------------

// -- AY_HQMV30_ATS -- 

package HqmAtsPkg;



  `include "sla_defines.svh"

  `import_base(uvm_pkg::*)
  `include_base("uvm_macros.svh")
  `include_base("sla_macros.svh")

  `import_base(sla_pkg::*)
  `include_base("slu_macros.svh")

`ifdef XVM
  `import_base(ovm_pkg::*)
  `import_base(xvm_pkg::*)
  `include_base("ovm_macros.svh")
  `include_base("sla_macros.svh")
`endif


//--AY_HQMV30_ATS-- `ifdef IOSFTRKCHK_NO_DEPENDENCIES
//--AY_HQMV30_ATS--     import iosf_trkchk_wrapper_pkg::*;
//--AY_HQMV30_ATS-- `else
//--AY_HQMV30_ATS--     import PCIEPkg::*;
//--AY_HQMV30_ATS--     import IOSFPkg::*;
//--AY_HQMV30_ATS--     import IOSFTrkChkPkg::*;
//--AY_HQMV30_ATS-- `endif


    import IosfPkg::*;

//--AY_HQMV30_ATS--    import IosfPvcUtilsPkg::*;
//--AY_HQMV30_ATS--     import DsaCommonPkg::*;
    
    import hcw_transaction_pkg::*; 

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

`ifndef HQM_IP_TB_OVM
    `include_mid("HqmAtsTypes_uvm.svh")
    `include_mid("HqmAtsCfgObj_uvm.svh")
    `include_mid("HqmAtsEventContainerObj_uvm.svh")
    `include_mid("HqmIosfTxn_uvm.svh")
    `include_mid("HqmAtsAnalysisTxn_uvm.svh")   
    `include_mid("HqmAtsPrspSeq_uvm.svh")          
    `include_mid("HqmAtsIreqSeq_uvm.svh")           
    `include_mid("HqmAtsChecker_uvm.svh")
    `include_mid("HqmAtsTracker_uvm.svh")
    `include_mid("HqmAtsAnalysisEnv_uvm.svh")
    `include_mid("HqmIommuEntry_uvm.svh")    
    `include_mid("HqmIommuTLB_uvm.svh")      
    `include_mid("HqmIommuBase_uvm.svh")     
    `include_mid("HqmIommu_uvm.svh")         
    `include_mid("HqmIommuAPI_uvm.svh")      
    `include_mid("HqmAtsEnv_uvm.svh")
`else
    `include_mid("HqmAtsTypes.svh")
    `include_mid("HqmAtsCfgObj.svh")
    `include_mid("HqmAtsEventContainerObj.svh")
    
// -----------------------------------------------------------------------------

    `include_mid("HqmIosfTxn.svh")
    `include_mid("HqmAtsAnalysisTxn.svh")    // depends on IosfPkg for IOSFPkg, PCIEPkg

// -----------------------------------------------------------------------------
    // ATS Sequences
    //--AY_HQMV30_ATS--  These two put to TYP level 

     `include_mid("HqmAtsPrspSeq.svh")          // ATS Page Response Message
     `include_mid("HqmAtsIreqSeq.svh")           // ATS Invalidation Request Message

// -----------------------------------------------------------------------------

     `include_mid("HqmAtsChecker.svh")
     `include_mid("HqmAtsTracker.svh")
     `include_mid("HqmAtsAnalysisEnv.svh")

// -----------------------------------------------------------------------------

    // IOMMU Cache Memories for storing Logical-to-Physical (L2P) Address Map
    `include_mid("HqmIommuEntry.svh")    // This stores a single Address Map Entry
    `include_mid("HqmIommuTLB.svh")      // This stores an Address Map (indexed by Logial Address), as well as the API to access it

    // IOMMU Classes
    `include_mid("HqmIommuBase.svh")     // This stores a 2-D array (i.e. [BDF][PASID] of Address Maps and common API
    `include_mid("HqmIommu.svh")         // Stores additional APIs
    `include_mid("HqmIommuAPI.svh")      // Address Translation Service API

    // IOMMU OVM Environment----------------------------------------------------
    `include_mid("HqmAtsEnv.svh")

`endif

endpackage : HqmAtsPkg
