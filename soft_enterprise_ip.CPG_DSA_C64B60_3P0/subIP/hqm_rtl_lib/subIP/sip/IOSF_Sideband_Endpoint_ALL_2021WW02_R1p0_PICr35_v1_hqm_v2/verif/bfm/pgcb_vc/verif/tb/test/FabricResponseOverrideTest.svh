
//this is the new resposne seq item and it extends from the PGCBAgentResponseItem
class PGCBAgentResponseSeqItemNew extends PGCBAgentResponseSeqItem;


	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_object_utils_begin(PGCBAgentResponseSeqItemNew)
		//`ovm_field_int(delay , OVM_ALL_ON)
	`ovm_object_utils_end
	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name="PGCBAgentXaction");
		super.new(name);
	endfunction : new

	/*constraint delay_c {
		delay > 0; delay < 5;
	}
	*/
	//Setting noRespnse to 1. So the respnder will not send any responses.
	constraint noResponse_c {
		noResponse == 1;
	}

endclass: PGCBAgentResponseSeqItemNew


	class FabricResponseOverrideTest extends PowerGatingBaseTest;
		`ovm_component_utils(PowerGatingSaolaPkg::FabricResponseOverrideTest)
	
		function new(string name = "FabricResponseOverrideTest", ovm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build();
			set_config_int("sla_env", "data_phase_mode", SLA_RANDOM_NONE );
			set_config_int("*", "count", 0);
			set_config_int("*","recording_detail", OVM_FULL);
	  		ovm_top.set_report_verbosity_level(OVM_FULL);   
			
			super.build();
			//Override the response seq item
			set_type_override_by_type(PGCBAgentResponseSeqItem::get_type(), PGCBAgentResponseSeqItemNew::get_type(), 1);

		endfunction

		function void connect();
			super.connect();   
		endfunction
  
  		task run();
  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#100us;
			//TODO:
			#300us;
			global_stop_request();
  		endtask

		function void report();
			ovm_report_info("FabricResponseOverrideTest", "Test Passed!");
		endfunction

	endclass
	


		
