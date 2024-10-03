//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved
// Author: melmalaki -- Created: 2010-03-17
//-----------------------------------------------------------------

// Example interface
interface bus;
   bit x;
endinterface : bus

// Example param interface
interface pbus;
   parameter int unsigned W = 8;

   bit [W-1:0] x;
endinterface : pbus

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

      function new(string name = "", ovm_component parent = null);
         super.new(name, parent);
      endfunction : new

      function void build();
         super.build();

         // Get correctly
         vintf    = sla_vintf_proxy#(virtual bus)::get("bus", `__FILE__, `__LINE__);
         vintf_8  = sla_vintf_proxy#(virtual pbus #(8))::get("pbus8", `__FILE__, `__LINE__);
         vintf_16 = sla_vintf_proxy#(virtual pbus #(16))::get("pbus16", `__FILE__, `__LINE__);
         
      endfunction :build

      task run();
         #10;
         vintf.x    = 1;
         vintf_8.x  = 2;
         vintf_16.x = 3;
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

// Normal Top level
import ovm_pkg::*;
import sla_pkg::*;
import tst_pkg::*;

module normal;
   // Bus instance
   bus         bus();
   pbus #(8)   pbus8();
   pbus #(16)  pbus16();

   initial begin
      // Pass Interfaces 
      sla_vintf_proxy #(virtual bus)::add        ("bus",    bus,     `__FILE__, `__LINE__);
      sla_vintf_proxy #(virtual pbus #(8))::add  ("pbus8",  pbus8,   `__FILE__, `__LINE__);
      sla_vintf_proxy #(virtual pbus #(16))::add ("pbus16", pbus16,  `__FILE__, `__LINE__);

      // Run test
      run_test("normal_test");

      // Exit
      $finish(2);
   end

endmodule :normal


// Faulty Top level
module faulty;
   // Bus instance
   bus         bus();
   pbus #(8)   pbus8();
   pbus #(16)  pbus16();

   initial begin
      // Pass Interfaces 
      sla_vintf_proxy #(virtual bus)::add        ("bus",    bus,     `__FILE__, `__LINE__);
      sla_vintf_proxy #(virtual bus)::add        ("bus5",    bus,     `__FILE__, `__LINE__); // will not be accessed
      sla_vintf_proxy #(virtual bus)::add        ("pbus8",  bus,     `__FILE__, `__LINE__); //will be overridden
      sla_vintf_proxy #(virtual pbus #(16))::add ("pbus16", pbus16,  `__FILE__, `__LINE__);

      // Dublicate interface
      sla_vintf_proxy #(virtual pbus #(8))::add  ("pbus8",  pbus8,   `__FILE__, `__LINE__);

      // Run test
      run_test("faulty_test");

      // Exit
      $finish(2);
   end

endmodule :faulty

