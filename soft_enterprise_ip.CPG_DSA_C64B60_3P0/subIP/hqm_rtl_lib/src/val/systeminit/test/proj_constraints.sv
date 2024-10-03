`constraint_class_begin(proj_topo_constraints, base_topology_picker, topology)
	constraint socket_c {
		topology.num_socket == 1;
                topology.sriov_enable == 1;
	};
`constraint_class_end

`constraint_wrapper_class_begin(proj_constraints)
   `apply_constraint_class(proj_topo_constraints)
   `apply_constraint_class(default_base_system_constraints)
   `apply_constraint_class(default_hqm_constraints)
`constraint_wrapper_class_end
