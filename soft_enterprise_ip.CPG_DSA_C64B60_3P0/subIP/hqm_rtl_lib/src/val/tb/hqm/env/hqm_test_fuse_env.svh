`ifndef INC_hqm_test_fuse_env
`define INC_hqm_test_fuse_env 

`include "fusegen_param.vh"

class hqm_test_fuse_env extends toplevel_fuse_env;
   `ovm_component_utils( hqm_test_fuse_env )

   // 2.1.5.0 and olde looks to be using SOCFUSEGEN_API_VH
   `undef SOCFUSEGEN_API_VH
   // 2.1.8 and newer looks to be using FUSEGEN_SOCFUSEGEN_API_VH
   `undef FUSEGEN_SOCFUSEGEN_API_VH

   `include "fusegen_api.vh"

   ////////////////////////////////////////////////////////////////////////////
   // constraints
   ////////////////////////////////////////////////////////////////////////////

   ////////////////////////////////////////////////////////////////////////////
   function void pre_randomize();
      super.pre_randomize();

      foreach( fuses[i] )
      begin
         fuses[i].default_c.constraint_mode( 1 );
      end

   endfunction

   /////////////////////////////////////////////////////////////////////////////
   function void post_randomize();
      super.post_randomize();

      foreach( fuses[i] )
      begin
         fuses[i].mirror_desired();
      end

   endfunction : post_randomize

   ////////////////////////////////////////////////////////////////////////////
   function new( string name = "hqm_test_fuse_env", ovm_component parent = null );
      super.new( name, parent );
   endfunction : new

   ////////////////////////////////////////////////////////////////////////////
   function void end_of_elaboration();
      super.end_of_elaboration();
   endfunction : end_of_elaboration

endclass : hqm_test_fuse_env

`endif
