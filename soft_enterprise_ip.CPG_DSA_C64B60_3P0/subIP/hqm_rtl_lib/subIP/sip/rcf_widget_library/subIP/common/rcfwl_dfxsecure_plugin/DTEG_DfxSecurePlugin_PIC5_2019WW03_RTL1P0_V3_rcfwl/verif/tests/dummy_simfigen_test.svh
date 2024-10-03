class dummy_simfigen_test extends ovm_test;
   `ovm_component_utils(dummy_simfigen_test)
   function new(string name = "", ovm_component parent=null);
      super.new(name, parent);
   endfunction :new

`include "/p/cse/asic/simfigen/latest/dummy_simfigen_test.inc"
endclass: dummy_simfigen_test

