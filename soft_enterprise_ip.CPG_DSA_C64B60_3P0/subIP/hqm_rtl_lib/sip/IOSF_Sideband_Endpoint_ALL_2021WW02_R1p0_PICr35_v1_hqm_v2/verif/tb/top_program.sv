
class ovm_run_test_disable;
    function new();
        ovm_pkg::ovm_root::ignore_run_test();
    endfunction
    local static ovm_run_test_disable _instance = new;
endclass

program top_program();

import ovm_pkg::*;
import ovm_ml::*;

class dummy_top extends ovm_test;
    function new(string name, ovm_component parent = null);
	    string real_test_name;
		ovm_object real_test_obj = null;
		
	    super.new(name, parent);

		if (!$value$plusargs ("OVM_TESTNAME=%S", real_test_name)) 
 	    begin
            `ovm_fatal("test_lib", "+OVM_TESTNAME not defined on the command line");
        end

        real_test_obj = ovm_factory::get().create_component_by_name(real_test_name, "", "atest", this);
		if (real_test_obj == null) begin
		    `ovm_fatal("test_lib", $sformatf("Couldn't create test %s from factory", real_test_name));
		end
	endfunction
	`ovm_component_utils(dummy_top)
endclass


initial begin
    string tops[1];
    
	if (!$value$plusargs ("OVM_TESTNAME=%S", tops[0])) 
	begin
         `ovm_fatal("test_lib", "+OVM_TESTNAME not defined in command line");
    end
    tops[0] = "SV:dummy_top";
  
    ovm_ml_run_test(tops, "");
end

endprogram

