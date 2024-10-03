//------------------------------------------------------------------------------
//  Copyright (c) 
//  2010 Intel Corporation, all rights reserved.
//
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY 
//  PROTECTED BY COPYRIGHT LAWS AND IS CONSIDERED A 
//  TRADE SECRET BELONGING TO THE INTEL CORPORATION.
//------------------------------------------------------------------------------
// 
//  Author  : Bill Bradley
//  Email   : william.l.bradley@intel.com
//  Date    : February 18, 2014
//  Desc    : Config Descriptor for HIP PG Agent
//------------------------------------------------------------------------------

`ifndef HIP_PG_VC_CONFIG__SV
`define HIP_PG_VC_CONFIG__SV

//------------------------------------------------------------------------------
// class: hip_pg_vc_config
//
// This class provides all necessary variables required for configuring the HIP
// PG agent (mainly just a wrapper around the configs[$] queue).
//------------------------------------------------------------------------------
class hip_pg_vc_config extends ovm_object;

  //----------------------------------------------------------------------------
  // Variable: name
  //
  // Name of this VC instantiation
  //----------------------------------------------------------------------------
  string name;

  //----------------------------------------------------------------------------
  // Variable: configs
  //
  // config objects for each domain
  //----------------------------------------------------------------------------
  hip_pg_config configs[string];

  `ovm_object_utils_begin(hip_pg_vc_config)
    `ovm_field_string          (name,   OVM_PRINT)
    `ovm_field_aa_object_string(configs,OVM_PRINT)
  `ovm_object_utils_end

  //----------------------------------------------------------------------------
  // Function: new
  //
  // Description:
  //   Creates a new instance of this type giving it the optional ~name~.
  //
  // Inputs:
  //   name_in - Instance name for this class
  //
  // Returns:
  //   void
  //----------------------------------------------------------------------------
  function new(string name_in = "hip_pg_vc_config");
    super.new(name_in);
    name = name_in;
    configs.delete();
  endfunction : new

endclass : hip_pg_vc_config

`endif //  `ifndef HIP_PG_VC_CONFIG__SV
