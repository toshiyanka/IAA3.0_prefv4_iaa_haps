//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved
// Author: melmalaki -- Created: 2010-03-17
//-----------------------------------------------------------------

// Test package
package tst_pkg;
   import ovm_pkg::*;
   import sla_pkg::*;
   `include "ovm_macros.svh"
   
   // Regular test showing correct use model
   class normal_test extends ovm_test;
      virtual interface bus         vintf;
      virtual interface pbus #(8)   vintf_8;
      virtual interface pbus #(16)  vintf_16;
      virtual interface lparam #(1,2,3,4,5,6,7)       lparam1;
      virtual interface lparam #(8,9,10,11,12,13,14)  lparam2;

      function new(string name = "", ovm_component parent = null);
         super.new(name, parent);
      endfunction : new

      function void build();
         super.build();

         // Get correctly
         vintf    = sla_vintf_proxy#(virtual bus)::get("bus", `__FILE__, `__LINE__);
         vintf_8  = sla_vintf_proxy#(virtual pbus #(8))::get("pbus8", `__FILE__, `__LINE__);
         vintf_16 = sla_vintf_proxy#(virtual pbus #(16))::get("pbus16", `__FILE__, `__LINE__);

         lparam1  = sla_vintf_proxy#(virtual lparam #(.A(1),.B(2),.C(3),.D(4),.E(5),.F(6),.G(7)))::get("lparam1", `__FILE__, `__LINE__);
         lparam2  = sla_vintf_proxy#(virtual lparam #(8,9,10,11,12,13,14))::get("lparam2", `__FILE__, `__LINE__);
         
      endfunction :build

      task run();
         #10;
         vintf.x    = 1;
         vintf_8.x  = 2;
         vintf_16.x = 3;

         lparam1.a = 1;
         lparam2.b = 2;
         #10;
         global_stop_request();
      endtask :run

      `ovm_component_utils(normal_test)

   endclass : normal_test

   // Faulty test to trigger different wrong behaviors and see how vintf 
   // manager deal with that
   class faulty_test extends ovm_test;
      virtual interface bus         vintf;
      virtual interface pbus #(8)   vintf_8;
      virtual interface pbus #(16)  vintf_16;

      function new(string name = "", ovm_component parent = null);
         super.new(name, parent);
      endfunction : new

      function void build();
         super.build();

         // Index not found
         vintf = sla_vintf_proxy#(virtual bus)::get("bus1", `__FILE__, `__LINE__);

         // Incorrect type
         vintf = sla_vintf_proxy#(virtual bus)::get("pbus8", `__FILE__, `__LINE__);

         // Same bus but incorrect parameter 
         vintf_8 = sla_vintf_proxy#(virtual pbus #(8))::get("pbus16", `__FILE__, `__LINE__);
         
      endfunction :build

      task run();
         global_stop_request();
      endtask :run

      `ovm_component_utils(faulty_test)

   endclass : faulty_test

endpackage :tst_pkg

