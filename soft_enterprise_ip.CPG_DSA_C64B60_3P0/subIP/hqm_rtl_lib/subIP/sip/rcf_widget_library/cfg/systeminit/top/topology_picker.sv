`picker_class_begin(topology_picker, base_topology_picker)

 virtual function sim_type_t get_sim_type(string childPath, sim_type_t parentSimType);
 if (strMatch(childPath, "rcfwl")) begin
        // Make it RTL
        return RTL;
      end
    return BFM;

 endfunction: get_sim_type

`picker_class_end
