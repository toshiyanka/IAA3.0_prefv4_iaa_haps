// Example interface
interface bus;
   bit x;
endinterface : bus

// Example param interface
interface pbus;
   parameter int unsigned W = 8;

   bit [W-1:0] x;
endinterface : pbus

// Example long param interface
interface lparam;
   parameter int unsigned A = 1;
   parameter int unsigned B = 1;
   parameter int unsigned C = 1;
   parameter int unsigned D = 1;
   parameter int unsigned E = 1;
   parameter int unsigned F = 1;
   parameter int unsigned G = 1;

   bit [A-1:0] a;
   bit [B-1:0] b;
   bit [C-1:0] c;
   bit [D-1:0] d;
   bit [E-1:0] e;
   bit [F-1:0] f;
   bit [G-1:0] g;

endinterface : lparam


// Normal Top level
module normal;
   import ovm_pkg::*;
   import sla_pkg::*;
   import tst_pkg::*;

   // Bus instance
   bus         bus();
   pbus #(8)   pbus8();
   pbus #(16)  pbus16();

   lparam #(1,2,3,4,5,6,7)       lparam1();
   lparam #(8,9,10,11,12,13,14)  lparam2();

   initial begin
      // Pass Interfaces 
      sla_vintf_proxy #(virtual bus)::add        ("bus",    bus,     `__FILE__, `__LINE__);
      sla_vintf_proxy #(virtual pbus #(8))::add  ("pbus8",  pbus8,   `__FILE__, `__LINE__);
      sla_vintf_proxy #(virtual pbus #(16))::add ("pbus16", pbus16,  `__FILE__, `__LINE__);
      sla_vintf_proxy #(virtual lparam #(1,2,3,4,5,6,7))::add       ("lparam1", lparam1,  `__FILE__, `__LINE__);
      sla_vintf_proxy #(virtual lparam #(8,9,10,11,12,13,14))::add  ("lparam2", lparam2,  `__FILE__, `__LINE__);

      // Run test
      run_test("normal_test");

      // Exit
      $finish(2);
   end

endmodule :normal


// Faulty Top level
module faulty;
   import ovm_pkg::*;
   import sla_pkg::*;
   import tst_pkg::*;

   // Bus instance
   bus         bus();
   pbus #(8)   pbus8();
   pbus #(16)  pbus16();
   lparam #(1,2,3,4,5,6,7)       lparam1();
   lparam #(8,9,10,11,12,13,14)  lparam2();

   initial begin
      // Pass Interfaces 
      sla_vintf_proxy #(virtual bus)::add        ("bus",    bus,     `__FILE__, `__LINE__);
      sla_vintf_proxy #(virtual bus)::add        ("bus5",    bus,     `__FILE__, `__LINE__); // will not be accessed
      sla_vintf_proxy #(virtual bus)::add        ("pbus8",  bus,     `__FILE__, `__LINE__); //will be overridden
      sla_vintf_proxy #(virtual pbus #(16))::add ("pbus16", pbus16,  `__FILE__, `__LINE__);

      sla_vintf_proxy #(virtual lparam #(1,2,3,4,5,6,7))::add       ("lparam1", lparam1,  `__FILE__, `__LINE__);
      sla_vintf_proxy #(virtual lparam #(8,9,10,11,12,13,14))::add  ("lparam2", lparam2,  `__FILE__, `__LINE__);

      // Dublicate interface
      sla_vintf_proxy #(virtual pbus #(8))::add  ("pbus8",  pbus8,   `__FILE__, `__LINE__);

      // Run test
      run_test("faulty_test");

      // Exit
      $finish(2);
   end

endmodule :faulty

