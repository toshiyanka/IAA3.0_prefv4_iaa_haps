`constraint_begin(proj_topology_constraints, topology_picker, topology)
     topology.num_socket == 1;
    `constraint_end


`constraint_wrapper_class_begin(proj_constraints)
    `apply_constraint_class(default_base_system_constraints)
    `apply_constraint_class(default_rcfwl_constraints)
`apply_constraint_class(proj_topology_constraints)

    `include "apply_default_clock_constraints.sv"
    
`constraint_wrapper_class_end

