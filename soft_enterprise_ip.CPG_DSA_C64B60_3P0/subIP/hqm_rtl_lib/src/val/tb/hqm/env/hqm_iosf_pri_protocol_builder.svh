//--------------------------------------------
//Note for stimulus developers: 
//This file is used as an example in the user guide to show users how the
//add_source function can be used. Please make sure any modifications here are
//in-line with expectations set by the user guide.
//--------------------------------------------

class hqm_iosf_pri_protocol_builder extends iosf_pri_stim_dut_view_builder;

  `ovm_object_utils(hqm_iosf_pri_protocol_builder)

 function new(string name = "");
    super.new(name);
  endfunction
  
  
  virtual function void build_dut_source_cfg(iosf_pri_stim_dut_src_config cfg);
     byte unsigned	   root_bus[int  unsigned];
     byte unsigned	   bus_num_min[int  unsigned]; 
     byte unsigned	   bus_num_max[int unsigned];
     iosf_pri_stim_dut_view_pkg::iosf_pri_stim_dut_src_config::TAG_TYPE 	tag_width[int unsigned]; 
     bit		   b10_tag_enabled[int unsigned];
     bit		   b8_tag_enabled[int unsigned];
     int  unsigned	   valid_traffic_class[int unsigned][$];
     int  unsigned	   enabled_channels[$]; 
     bit		   pasid_capable[int unsigned];
     int  unsigned	   pasid_table_size[int unsigned]; 
     bit		   page_request_capable[int unsigned];
     int  unsigned	   pasid_execute_by_channel[$];
     int  unsigned	   pasid_privileged_mode_by_channel[$]; 


      //--hqm 
      //root_bus[0]=0;

      bus_num_min[0]=0;
      bus_num_min[1]=0;
      bus_num_min[2]=0;
      bus_num_min[3]=0;
      bus_num_min[4]=0;
      bus_num_min[5]=0;
      bus_num_min[6]=0;
      bus_num_min[7]=0;

      bus_num_max[0]=255;
      bus_num_max[1]=255;
      bus_num_max[2]=255;
      bus_num_max[3]=255;
      bus_num_max[4]=255;
      bus_num_max[5]=255;
      bus_num_max[6]=255;
      bus_num_max[7]=255;


      tag_width[0]=iosf_pri_stim_dut_view_pkg::iosf_pri_stim_dut_src_config::TAG_8B;
      tag_width[1]=iosf_pri_stim_dut_view_pkg::iosf_pri_stim_dut_src_config::TAG_8B;
      tag_width[2]=iosf_pri_stim_dut_view_pkg::iosf_pri_stim_dut_src_config::TAG_8B;
      tag_width[3]=iosf_pri_stim_dut_view_pkg::iosf_pri_stim_dut_src_config::TAG_8B;
      tag_width[4]=iosf_pri_stim_dut_view_pkg::iosf_pri_stim_dut_src_config::TAG_8B;
      tag_width[5]=iosf_pri_stim_dut_view_pkg::iosf_pri_stim_dut_src_config::TAG_8B;
      tag_width[6]=iosf_pri_stim_dut_view_pkg::iosf_pri_stim_dut_src_config::TAG_8B;
      tag_width[7]=iosf_pri_stim_dut_view_pkg::iosf_pri_stim_dut_src_config::TAG_8B;

      //enabled_channels = {0};
      enabled_channels[0] = 'h0;

      valid_traffic_class[0] = { 0, 1, 2, 3, 4, 5, 6, 7 };
      valid_traffic_class[1] = { 0, 1, 2, 3, 4, 5, 6, 7 };
      valid_traffic_class[2] = { 0, 1, 2, 3, 4, 5, 6, 7 };
      valid_traffic_class[3] = { 0, 1, 2, 3, 4, 5, 6, 7 };
      valid_traffic_class[4] = { 0, 1, 2, 3, 4, 5, 6, 7 };
      valid_traffic_class[5] = { 0, 1, 2, 3, 4, 5, 6, 7 };
      valid_traffic_class[6] = { 0, 1, 2, 3, 4, 5, 6, 7 };
      valid_traffic_class[7] = { 0, 1, 2, 3, 4, 5, 6, 7 };  

      pasid_capable[0]=0;
      pasid_capable[1]=0;
      pasid_capable[2]=0;
      pasid_capable[3]=0;
      pasid_capable[4]=0;
      pasid_capable[5]=0;
      pasid_capable[6]=0;
      pasid_capable[7]=0; 

      pasid_table_size[0] = 'h2000; //Min Size
      pasid_table_size[1] = 'h2000;
      pasid_table_size[2] = 'h2000;
      pasid_table_size[3] = 'h2000; 
      pasid_table_size[4] = 'h2000; 
      pasid_table_size[5] = 'h2000;
      pasid_table_size[6] = 'h2000;
      pasid_table_size[7] = 'h2000;  

      page_request_capable[0]=0;
      page_request_capable[1]=0;
      page_request_capable[2]=0;
      page_request_capable[3]=0;
      page_request_capable[4]=0;
      page_request_capable[5]=0;
      page_request_capable[6]=0;
      page_request_capable[7]=0;

      pasid_execute_by_channel = { 0, 0, 0, 0, 0, 0, 0, 0 };
      pasid_privileged_mode_by_channel = { 0, 0, 0, 0, 0, 0, 0, 0 };

   //Adding initiators
   begin : src_cfg
    `ovm_info(get_full_name(),$psprintf("build_dut_source_cfg:: start"), OVM_LOW)
        //--------------------- s0 - f0 - iosfp0--------------------------//
        cfg.add_source(
                       0, //socket,
                       0, //fabric,
                       0, //logical_id,
                       iosf_pri_stim_dut_view_pkg::iosf_pri_stim_dut_src_config::FAKE, //sim_type,
                       iosf_pri_stim_dut_view_pkg::iosf_pri_stim_dut_src_config::PCIE, //ip_type,
                       "s0.f0.iosfp0.to_socket", //sequencer_name,
                       8'b0,                     //segment_id,
                       root_bus,
                       bus_num_min, 
                       bus_num_max, 
                       tag_width,
                       valid_traffic_class,
                       enabled_channels,
                       pasid_capable,
                       pasid_table_size,
                       page_request_capable,
                       pasid_execute_by_channel,
                       pasid_privileged_mode_by_channel,
                       1                                  
                      );
    `ovm_info(get_full_name(),$psprintf("build_dut_source_cfg:: done"), OVM_LOW)
    end: src_cfg 
  endfunction



  virtual function void build_dut_addr_map_cfg(iosf_pri_stim_dut_addr_map_config cfg);
    // Build address map rules and add overrides
    iosf_pri_stim_dut_view_pkg::iosf_pri_req_addr_rule_overrides overrides;
    iosf_pri_stim_dut_view_pkg::iosf_pri_req_arch_addr_rules rules;

    $display("[%0t] hqm_iosf_pri_protocol_builder:: build_dut_addr_map_cfg start", $time);


    rules = iosf_pri_stim_dut_view_pkg::iosf_pri_req_arch_addr_rules::type_id::create("hqm_sim_iosf_pri_req_arch_addr_rules");
    `ovm_info(get_full_name(),$psprintf("build_dut_addr_map_cfg:: cfg.set_rules"), OVM_LOW)
    cfg.set_rules(rules);

    overrides = iosf_pri_stim_dut_view_pkg::iosf_pri_req_addr_rule_overrides::type_id::create("hqm_sim_iosf_pri_req_addr_rule_overrides");
    `ovm_info(get_full_name(),$psprintf("build_dut_addr_map_cfg:: cfg.set_overrides"), OVM_LOW)
    cfg.set_overrides(overrides);
  endfunction

endclass
