class dummy_simfigen_test extends uvm_test;
   `uvm_component_utils(dummy_simfigen_test)
   function new(string name = "", uvm_component parent=null);
      super.new(name, parent);
   endfunction :new

`include "/p/cse/asic/simfigen/latest/dummy_simfigen_test.inc"
endclass: dummy_simfigen_test

