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

	function void build();

		factory.set_type_override_by_name("base_topology_picker", "topology_picker");
   	   factory.set_type_override_by_name("base_socket_picker", "socket_picker");
		super.build();

	endfunction: build  


endclass: systeminit_picker
