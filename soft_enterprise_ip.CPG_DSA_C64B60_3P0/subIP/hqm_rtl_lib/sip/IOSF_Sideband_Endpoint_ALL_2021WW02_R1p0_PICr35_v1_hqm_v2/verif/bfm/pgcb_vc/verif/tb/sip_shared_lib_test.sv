
module sip_shared_lib_tb();
   // Associated ENV name in OVM hierarchy
   parameter string IP_ENV = "sip_shared_tb";
   
   // get the imports and macros from sip_shared_lib dependent libs
   // (timesaver reuse of content to ensure this tb is pulling in same imports)
   `include "sip_shared_lib_pkg.sv"

   //// instantiate interfaces
   //<ip_name>_ifc <ip_name>_ifc
   //// Register the  Interface with OVM
   //set_config_string(IP_ENV, \"<IP_NAME>_IFC_NAME\", \$psprintf(\"\%m.<ip_name>_ifc\"));

   
endmodule