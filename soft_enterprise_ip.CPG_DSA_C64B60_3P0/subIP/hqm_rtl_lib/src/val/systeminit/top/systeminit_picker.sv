//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2013 Intel -- All rights reserved
//-----------------------------------------------------------------
// Author       : Tim Wheeler
// Date Created : 07-2013
//-----------------------------------------------------------------
// Description:
// Top-level picker
//------------------------------------------------------------------

// Systeminit picker is the top-level picker that will create the highest-level pickers
class systeminit_picker extends base_systeminit_picker;

   // reset_picker reset;
    
    function void build();
    //  if (is_stage(RUN_STAGE)) begin
    //    reset = reset_picker::type_id::create("reset_p", this);
    //    reset.randomize();
    //  end
      
        // factory.set_type_override_by_name("base_topology_picker", "topology_picker");
        factory.set_type_override_by_name("base_socket_picker", "socket_picker");
        // factory.set_type_override_by_name("base_rlink_picker", "rlink_picker");
        //factory.set_type_override_by_name("base_reset_picker", "chassis_reset_picker");
      //  factory.set_type_override_by_name("reset_picker_base", "reset_picker");
        super.build();
    endfunction: build

endclass
