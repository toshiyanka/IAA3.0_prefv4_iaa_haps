class PowerGatingBaseTest extends ovm_test;

  `ovm_component_utils(PowerGatingSaolaPkg::PowerGatingBaseTest)

  PowerGatingSaolaEnv sla_env;

  // Indicates pass/fail.  
  bit test_pass = 1;
  
  ovm_table_printer printer;

  function new(string name = "PowerGatingBaseTest", 
      ovm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build();
    super.build();
    
    // Enable transaction recording for everything
    set_config_int("*", "recording_detail", OVM_FULL);

    // Create the sla_env
    sla_env = PowerGatingSaolaEnv::type_id::create("sla_env", this);
    `ovm_info(get_type_name(),"sla env created",OVM_LOW)

    // Create a specific depth printer for printing the created topology
    printer = new();
    printer.knobs.depth = 3;
  endfunction : build

  function void connect();
    super.connect();   


   endfunction


  function void end_of_elaboration();

       
    // Print the test topology
    `ovm_info(get_type_name(),$psprintf("Printing the test topology :\n%s", this.sprint(printer)), OVM_LOW)
  endfunction

  function void report();
    if(test_pass) begin
      `ovm_info(get_type_name(), "** OVM TEST PASSED **", OVM_NONE)
    end
    else begin
      `ovm_error(get_type_name(), "** OVM TEST FAIL **")
    end
  endfunction

endclass : PowerGatingBaseTest
