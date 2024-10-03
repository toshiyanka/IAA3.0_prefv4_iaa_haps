//============================================================
// Copied from:
// fuse_ovrd_config.svh
//
// Original Author   : Ravi Rajaraman 
// Date Created      : 01/01/15
//
// Copyright (c) 2015 Intel Corporation
// Intel Proprietary
//
// Description: defines config object present as part of fuse 
// will be instantiated inside the IP config object and fuses will be pass down via this
//
//============================================================
 
class hqm_fuse_ovrd_config extends uvm_object;

   `uvm_object_utils(hqm_fuse_ovrd_config)

   int Fuse_ovrd_value[string];
   string Fuse_name[$];

   //    `uvm_field_string(Fuse_name, UVM_DEFAULT)
   //    `uvm_field_int(Fuse_ovrd_value, UVM_DEFAULT)
   //`uvm_object_utils_end
   
   function new(string name= "hqm_fuse_ovrd_config"); 
      super.new(name);
   endfunction // new
   
endclass
