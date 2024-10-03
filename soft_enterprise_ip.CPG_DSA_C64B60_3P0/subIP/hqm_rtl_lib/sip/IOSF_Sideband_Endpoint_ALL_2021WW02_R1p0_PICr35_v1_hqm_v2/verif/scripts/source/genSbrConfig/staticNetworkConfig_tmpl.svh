//--------------------------------------------------------------------------
// Intel Proprietary -- Copyright <%dt_year%> Intel -- All rights reserved
//--------------------------------------------------------------------------
// Date Created : <%dt_mday%> <%dt_month%> <%dt_year%>
//--------------------------------------------------------------------------
// Description:
// staticNetworkConfig class definition
//
//  <%pgm_cmdline%>
//--------------------------------------------------------------------------

`ifndef INC_STATICNETWORKCONFIG
`define INC_STATICNETWORKCONFIG

class staticNetworkConfig extends iosfsbm_rtr::network_cfg;
  
  bit parity_en[string];
  // Name arrays
  svlib_pkg::string_queue_t rtr_list, rtrs_tlm, rtrs_rtl, eps_tlm, eps_rtl;
  //local int rtr_internal_byte_width[string],rtr_external_byte_width[string];
  local svlib_pkg::string_queue_t visited_rtrs;

  extern virtual function void staticCreateNetwork();
  extern virtual function void staticFinalize();
  extern virtual function void staticGetLinks();
  extern virtual function void handle_dangling_port();
  extern virtual function void staticDoProcessVendorExtensions();
  extern virtual function bit check_visited(string rtr_name, iosfsbm_cm::nid_t nid);
  extern virtual function void mark_visited(string rtr_name, iosfsbm_cm::nid_t nid);

<+rtr_instname+>
  extern virtual function iosfsbm_rtr::rtr_cfg <%rtr_instname%>_bld();
<-rtr_instname->
<+ep_instname+>
  extern virtual function iosfsbm_cm::ep_cfg <%ep_instname%>_bld();
<-ep_instname->

  `ovm_object_utils(staticNetworkConfig)

endclass :staticNetworkConfig

function void staticNetworkConfig::staticFinalize();
      finalize();
      
endfunction

function void staticNetworkConfig::staticCreateNetwork();
  // Locals
  // ======

  iosfsbm_rtr::rtr_cfg rtr_cfg_tmp;
  iosfsbm_cm::ep_cfg ep_cfg_tmp;

  // Populate Component Name Arrays
  // ==============================
  rtrs_tlm = '{};
  
  <+rtrtlm_instname+>
  rtrs_tlm = {rtrs_tlm, "<%rtrtlm_instname%>"};
  <-rtrtlm_instname->

  rtrs_rtl = '{};
  <+rtrrtl_instname+>
  rtrs_rtl = {rtrs_rtl, "<%rtrrtl_instname%>"};
  <-rtrrtl_instname->

  eps_tlm = '{};
  <+eptlm_instname+>
  eps_tlm = {eps_tlm, "<%eptlm_instname%>"};
  <-eptlm_instname->

  eps_rtl = '{};
  <+eprtl_instname+>
  eps_rtl = {eps_rtl, "<%eprtl_instname%>"};
  <-eprtl_instname->  

      
  foreach(rtrs_tlm[i])
    add_rtr(rtrs_tlm[i], iosfsbm_cm::ABS_TLM);

  foreach(rtrs_rtl[i])
    add_rtr(rtrs_rtl[i], iosfsbm_cm::ABS_RTL);


  `ifndef EP_TYPE_RTL
  foreach(eps_tlm[i])
    add_ep(eps_tlm[i], iosfsbm_cm::ABS_TLM);
  `else
  foreach(eps_tlm[i])
    add_ep(eps_tlm[i], iosfsbm_cm::ABS_RTL);
  `endif
     
  foreach(eps_rtl[i])
    add_ep(eps_rtl[i], iosfsbm_cm::ABS_RTL);

  set_iosfspec_ver(iosfsbm_cm::IOSF_11);
      
  if (iosfsb_spec_rev >= iosfsbm_cm::IOSF_090)
    begin    
       //Need to set this for agtvc/fbrcvc for rtr_rtr links  
       ext_header_support=1'b1;
    end
  //Enable ordering check, sets field in common_cfg
  `ifdef ENABLE_ORDERING_CHECK
     enable_ordering_check(1'b1);
  `endif
  
<+rtr_instname+>
  rtr_cfg_tmp = <%rtr_instname%>_bld();
  add_rtr_cfg("<%rtr_instname%>", rtr_cfg_tmp);

<-rtr_instname->

<+ep_instname+>
  ep_cfg_tmp = <%ep_instname%>_bld();
  add_ep_cfg("<%ep_instname%>", ep_cfg_tmp);

<-ep_instname->
  
  handle_dangling_port();
  staticGetLinks();
  staticDoProcessVendorExtensions();

endfunction : staticCreateNetwork

<+rtr_instname+>
function iosfsbm_rtr::rtr_cfg staticNetworkConfig::<%rtr_instname%>_bld();
   iosfsbm_rtr::rtr_cfg rtr_cfg_i;
   string pid_range_hash[string];
   int payload_width_hash[string];
   svlib_pkg::string_queue_t str_list;
   iosfsbm_cm::nid_t skip_nid_q[$];
   int index_q[$];
   int i = 0;
   int j = 0;
   int k = 0;
   int l = 0;
   int m = 0;

   // Create cfg object
   assert($cast(rtr_cfg_i, ovm_factory::create_object("iosfsbm_rtr::rtr_cfg")))
     else ovm_report_fatal("CASTING", "Type mismatch");

<+port_parity+>
      parity_en["<(port_parity)>"] = <%port_parity%>;
<-port_parity->

<+skip_node+>
     skip_nid_q.push_back(<%skip_node%>); 
<-skip_node->

<+hbridge_node+>
     rtr_cfg_i.hbridge_node[i++] = <%hbridge_node%>; 
<-hbridge_node->


<+hbridge_pid+>
     rtr_cfg_i.hbridge_pid[j++] = <%hbridge_pid%>; 
<-hbridge_pid->

<+seg_bridge_node+>
     rtr_cfg_i.seg_bridge_node[l++] = <%seg_bridge_node%>; 
<-seg_bridge_node->


<+seg_bridge_pid+>
     rtr_cfg_i.seg_bridge_pid[m++] = <%seg_bridge_pid%>; 
<-seg_bridge_pid->

<+ism_strap_en+>
     rtr_cfg_i.ism_strap_en[k++] = <%ism_strap_en%>; 
<-ism_strap_en->

   if( <?clock_number?> ) //Clock number definition
     rtr_cfg_i.clk_num = <%clock_number%>;

   if( <?pok_ovrd?> ) //Clock number definition
     rtr_cfg_i.pok_ovrd_support = <%pok_ovrd%>;

   if( <?number_of_nodes?> ) //Number of Nodes definition
      for(int i=0; i < <%number_of_nodes%>; i++)
         rtr_cfg_i.nids.push_back(i);
   
   if(skip_nid_q.size > 0) begin
		index_q = skip_nid_q.find_index with (item == 1);
		if(index_q.size > 0) begin
			rtr_cfg_i.num_unused_port = index_q.size;
			foreach(index_q[i])
				rtr_cfg_i.nids.delete(index_q[i] - i);
		end	
   end
   
   if( <?int_byte_width?> ) begin //Internal Byte Width definition
      rtr_internal_byte_width["<%rtr_instname%>"] = <%int_byte_width%>;
      rtr_cfg_i.rtr_internal_byte_width = <%int_byte_width%>;
   end

   if( <?ext_byte_width?> ) //External Byte Width definition
      rtr_external_byte_width["<%rtr_instname%>"] = <%ext_byte_width%>;
   
   rtr_cfg_i.disable_wait_ism_act = 1;

    //Power Well number definition
   if( <?pgcb_enable?> )
      rtr_cfg_i.pgcb_enabled = <%pgcb_enable%>;
   else
      rtr_cfg_i.pgcb_enabled = 0;

   if( <?psmi_enable?> )
      rtr_cfg_i.psmi_enabled = <%psmi_enable%>;
   else
      rtr_cfg_i.psmi_enabled = 0;
   
   if( <?misr_enabled?> )
      rtr_cfg_i.misr_enabled = <%misr_enabled%>;
   else
      rtr_cfg_i.misr_enabled = 0;
   
   if( <?stap_enabled?> )
      rtr_cfg_i.stap_enabled = <%stap_enabled%>;
   else
      rtr_cfg_i.stap_enabled = 0;

   if( <?parity_rtr_en?> ) begin
      rtr_cfg_i.rtr_parity_en = <%parity_rtr_en%>;
      rtr_cfg_i.num_parity_pin = <%num_parity_pin%>;
   end

   rtr_cfg_i.global_rtr = <%global_rtr%>;

   rtr_cfg_i.min_global_pid = <%min_global_pid%>;
   
   rtr_cfg_i.segment_scaling = <%segment_scaling%>;

   rtr_cfg_i.min_gseg_pid = <%min_gseg_pid%>;

   rtr_cfg_i.min_gseg_mcast_pid = 128; //<%min_gseg_mcast_pid%>;
   rtr_cfg_i.max_gseg_mcast_pid = 146; //<%max_gseg_mcast_pid%>;
   rtr_cfg_i.min_lseg_mcast_pid = 111; //<%min_lseg_mcast_pid%>;
   rtr_cfg_i.max_lseg_mcast_pid = 127; //<%max_lseg_mcast_pid%>;
   
   rtr_cfg_i.rtr_type = (<%global_seg_rtr%>  == 1) ? INTER_SEGMENT_RTR : SEGMENT_RTR;

   if(<?chassis_enable?>)
     rtr_cfg_i.chassis_enabled = <%chassis_enable%>;
   else
     rtr_cfg_i.chassis_enabled = 0;  

<+pid_range+>
   pid_range_hash["<(pid_range)>"] = "<%pid_range%>";
<-pid_range->
   if ( pid_range_hash.exists("pid_range_0")) begin
      begin
         rtrtable_map = iosfsbm_cm::NTC_RTR;
         rtr_cfg_i.rtrtable_map = iosfsbm_cm::NTC_RTR;
      end
   end else
     rtr_cfg_i.rtrtable_map = iosfsbm_cm::SEG_RTR;
     
   for (int i=0;i<10;i++) begin
      string pid_range_name;
      $sformat(pid_range_name, "pid_range_%0d",i);   
      if ( pid_range_hash.exists(pid_range_name)) begin
         string value;
         value = pid_range_hash[pid_range_name]; 
         str_list = svlib_pkg::string_to_list(value);                 
         for (int j=str_list[0].atoi();j<=str_list[1].atoi();j++)
           rtr_cfg_i.pid_range.push_back(j);
      end
   end 
    
  

   //Power Well number definition
   if( <?power_well_number?> )
      rtr_cfg_i.pwr_well = <%power_well_number%>;
   else
      rtr_cfg_i.pwr_well = 0;

   // Get nids with IP role in power intf
   rtr_cfg_i.ip_intf_nids = '{<%ip_intfc_nids%>};
 
<+payload_width+>
   payload_width_hash["<(payload_width)>"] = <%payload_width%>;
<-payload_width->

	foreach(rtr_cfg_i.nids[i]) begin
	  string name;
      int value;
      $sformat(name, "payload_width_%0d", rtr_cfg_i.nids[i]);
      if( payload_width_hash.exists(name) ) begin
         value = payload_width_hash[name];
      end else
      	value = 1;
     
       
      // Check if payload width is valid
      if ( ! value inside {1,2,4} ) begin
         string msg;
         $sformat(msg, "Invalid payload width %0d for Router <%rtr_instname%> Node %0d, legal values are 1,2,4", 
                  value, rtr_cfg_i.nids[i]);
         ovm_report_fatal("CFG", msg);
      end
      // Set payload width in rtr_cfg
      rtr_cfg_i.payload_width[rtr_cfg_i.nids[i]] = value * 8;
	end


   if( <?skip_active_req?> ) begin
      bit tmp_skip[];
      string nmarr[string];      
      tmp_skip = new[<%number_of_nodes%>];
      tmp_skip = '{<%skip_active_req%>};
<+node_name+>
      nmarr["<(node_name)>"] = "<%node_name%>";
<-node_name->
      for( int i=0; i < <%number_of_nodes%>; i++ ) begin
         string nm;
         $sformat(nm, "N%0d", i);
         ntw_skip_active_req_q[nmarr[nm]] = tmp_skip[i];
         $display("nmarr[%0s]=%0s skip[%0s]=%0b", nm, nmarr[nm], nmarr[nm], ntw_skip_active_req_q[nmarr[nm]]);
      end
   end

   return rtr_cfg_i;		     
endfunction

<-rtr_instname->
<+ep_instname+>
function iosfsbm_cm::ep_cfg staticNetworkConfig::<%ep_instname%>_bld();
   iosfsbm_cm::ep_cfg ep_cfg_i;
   int total_ep_pids, pid_count;
   string value;
   svlib_pkg::string_queue_t str_list;
   // Create cfg object
   assert($cast(ep_cfg_i, ovm_factory::create_object("iosfsbm_cm::ep_cfg")))
     else ovm_report_fatal("CASTING", "Type mismatch");
   
   if( <?port_unused?> )
      ep_cfg_i.port_unused = <%port_unused%>;
   else
      ep_cfg_i.port_unused = 0;
   

   ep_cfg_i.port_parity_en = parity_en["<%ep_instname%>"];

   //Get number of Port IDs
   if ( <?num_port_ids?> ) //Number of Port Ids definition
     total_ep_pids = <%num_port_ids%>; 
   // Get PIDs
   if ( <?port_ids?> ) //List of Port Ids definition
   begin
     pid_count=0;         
     value = "<%port_ids%>"; 
     str_list = svlib_pkg::string_to_list(value);
     foreach(str_list[j])
       begin
          ep_cfg_i.my_ports.push_back(str_list[j].atoi());
          pid_count++;
       end
   end
    
   if(total_ep_pids != pid_count)
     ovm_report_error("IPXACT", "Number of port IDs != Port Ids defined for <%ep_instname%>",
                      iosfsbm_cm::VERBOSE_ERROR);
      
   if( <?routed_port_ids?> ) //Routed Port Ids definition
   begin
      value = "<%routed_port_ids%>";
      str_list = svlib_pkg::string_to_list(value);
      foreach(str_list[j])
	 ep_cfg_i.routed_ports.push_back(str_list[j].atoi());
   end
   
   if( <?message_port_ids?> ) //Message port Id definition
   begin
      int idx;
      value = "<%message_port_ids%>";
      str_list = svlib_pkg::string_to_list(value);
      idx=0;
      foreach(str_list[j])
         begin
	    if( str_list[j] == "P" )
	       ep_cfg_i.add_pid_to_msgtype_map(ep_cfg_i.routed_ports[idx], iosfsbm_cm::P_MSG);
	    else if( str_list[j] == "NP" )
	       ep_cfg_i.add_pid_to_msgtype_map(ep_cfg_i.routed_ports[idx], iosfsbm_cm::NP_MSG);
	    else if( str_list[j] == "PNP" )
	       ep_cfg_i.add_pid_to_msgtype_map(ep_cfg_i.routed_ports[idx], iosfsbm_cm::PNP_MSG);
	    idx++;
	 end
   end

   if( <?clock_number?> ) //Clock Number definition
      ep_cfg_i.clk_num = <%clock_number%>;

   if( <?np_credit_buffer?> ) //Np Credit buffer definition
      ep_cfg_i.np_crd_buffer = <%np_credit_buffer%>;

   if( <?pc_credit_buffer?> ) //PC Credit buffer definition
      ep_cfg_i.pc_crd_buffer = <%pc_credit_buffer%>;
   
   if( <?dut_pc_credit_buffer?> ) //PC QDepth definition
      ep_cfg_i.dut_exp_pc_credits = <%dut_pc_credit_buffer%>;

   if( <?dut_np_credit_buffer?> ) //NPC QDepth definition
      ep_cfg_i.dut_exp_np_credits = <%dut_np_credit_buffer%>;
   
   if( <?power_well_number?> ) //Power well definition
      ep_cfg_i.pwr_well = <%power_well_number%>;
   
   ep_cfg_i.enable_credit_init_check = 0;

   //set iosfsb spec rev (default to 1.0 for all eps)
   ep_cfg_i.iosfsb_spec_rev = iosfsbm_cm::IOSF_11;
   
   if( iosfsb_spec_rev >= iosfsbm_cm::IOSF_090 )
      ep_cfg_i.ext_header_support=$urandom_range(0,1);

   if( <?skip_active_req?> ) begin
      bit tmp_skip[];
      string nmarr[string];      
      tmp_skip = new[<%number_of_nodes%>];
      tmp_skip = '{<%skip_active_req%>};
<+node_name+>
      nmarr["<(node_name)>"] = "<%node_name%>";
<-node_name->
      for( int i=0; i < <%number_of_nodes%>; i++ ) begin
         string nm;
         $sformat(nm, "N%0d", i);
         ntw_skip_active_req_q[nmarr[nm]] = tmp_skip[i];
         $display("nmarr[%0s]=%0s skip[%0s]=%0b", nm, nmarr[nm], nmarr[nm], ntw_skip_active_req_q[nmarr[nm]]);
      end
   end

   return ep_cfg_i;		     

endfunction

<-ep_instname->

function void staticNetworkConfig::handle_dangling_port();
	int index_q[$];
	string tmp_port_unused_q[$];

	foreach(ep_cfgs[i]) begin
		if(ep_cfgs[i].port_unused) begin
			tmp_port_unused_q.push_back(i);
		end
	end
	foreach(tmp_port_unused_q[i]) begin
		index_q = '{};
		index_q = eps.find_index with (item == tmp_port_unused_q[i]);
		assert(index_q.size == 1) else
		ovm_report_error(get_name(), "more than one matching for dangling port");
		eps.delete(index_q[0]);
		ep_cfgs.delete(tmp_port_unused_q[i]);
	end
endfunction

function void staticNetworkConfig::staticGetLinks();
  string iconn_cref[string];
  string iconn_bref[string];
  string tmp, rtr_name, rtr_intf, other_name, other_intf, ep_name[$];
  iosfsbm_cm::raw_nid_q_t nid_q;
  iosfsbm_cm::nid_queue_t rtr_nid_map[string];
  svlib_pkg::string_queue_t str_list;
  iosfsbm_cm::nid_t other_nid;
  
  rtr_list = {rtrs_tlm, rtrs_rtl};
      
  // interconnections
  // array of rtr "componentRef_busRef" index
  //   ep connected to "componentRef_busRef" value
  <+iconn_name+>
  iconn_cref["<%iconn_cref_int1%>:<%iconn_bref_int1%>"] = "<%iconn_cref_int2%>";
  iconn_cref["<%iconn_cref_int2%>:<%iconn_bref_int2%>"] = "<%iconn_cref_int1%>";
  iconn_bref["<%iconn_cref_int1%>:<%iconn_bref_int1%>"] = "<%iconn_bref_int2%>";
  iconn_bref["<%iconn_cref_int2%>:<%iconn_bref_int2%>"] = "<%iconn_bref_int1%>";
  <-iconn_name->
  
  foreach(rtr_list[i])
  begin
     rtr_name = rtr_list[i];
     rtr_nid_map[rtr_name] = new();

     // Locally associate NIDs with RTRs for use in links fetching
     rtr_nid_map[rtr_name].data = rtr_cfgs[rtr_name].nids;
     nid_q    = rtr_nid_map[rtr_name].data;

    foreach(nid_q[j])
    begin
      // Make sure this link wasn't visited from the other direction
      if ( check_visited(rtr_name, nid_q[j]) )
        continue;

      // Set interface name
      $sformat(rtr_intf, "iosf_sbc_%0d", nid_q[j]);

      // Get connection
      tmp = {rtr_name, ":", rtr_intf};
      if( iconn_cref.exists(tmp) )
      begin
         other_name = iconn_cref[tmp];
	 other_intf = iconn_bref[tmp];
      end 
      else begin
         string msg;
         $sformat(msg, "Port %0d is not connected", nid_q[j]);
         ovm_report_warning("IPXACT", msg, iosfsbm_cm::VERBOSE_WARNING);
        continue;
      end
      
      if(is_ep(other_name))
        begin
	   int search_idx[$];
           search_idx = ep_name.find_index() with (item == other_name);
           if(search_idx.size() !=0) 
             ovm_report_error("IPXACT", 
                          $psprintf("%s is connected more than once to %s in the interconnection part", 
                                    other_name, rtr_name), iosfsbm_cm::VERBOSE_ERROR);
        end
       
      if(is_ep(other_name))   
        ep_name.push_back(other_name);
       
      // Handle RTR-2-EPconnection
      if ( is_ep(other_name) )
        add_link(rtr_name, nid_q[j], other_name);

      // Handle RTR-2-RTR connection
      else if ( is_rtr(other_name))
      begin
        if(rtr_internal_byte_width[other_name] < rtr_external_byte_width[rtr_name])
          ovm_report_error("IPXACT", 
                           $psprintf("%s External byte width is not consistance with Internal byte width of %s",
                                     rtr_name, other_name), iosfsbm_cm::VERBOSE_ERROR);
         
        // Now get NID from the dest RTR intf name (syntax slave_<NID>)
        str_list = svlib_pkg::string_to_list(other_intf, "_"); 
        assert( str_list.size() == 3) else
        begin
	  string msg;
          $sformat(msg, "Unrecognized interface name %s", other_intf);
          ovm_report_fatal("IPXACT", msg);
        end

        other_nid = str_list[2].atoi();
         
        //Do not add link which has ip_intf_nid
         if (rtr_cfgs[rtr_name].is_ip_intf(nid_q[j]))
           continue;

         if (rtr_cfgs[other_name].is_ip_intf(other_nid))         
           continue;

        // Now add link
        add_link(rtr_name, nid_q[j], other_name, str_list[2].atoi());
         
        // Make rtr/nid combination as visited to avoid repetitive visits
        mark_visited(other_name, str_list[2].atoi());
      end

      // Handle case where other_name isn't a valid EP or RTR
      else
      begin
        string msg;
        $sformat(msg, "Connection with unknown contributer %s", other_name);
        ovm_report_fatal("IPXACT", msg);
      end
    end //nid_q[i]
  end // rtr_list[i]

  //Add links for ip_intf_nids
  foreach (rtr_list[i])
  begin
     rtr_name = rtr_list[i];
     nid_q    = rtr_nid_map[rtr_name].data;
     
     foreach (nid_q[j])
     begin
        if (!rtr_cfgs[rtr_name].is_ip_intf(nid_q[j]))
          continue;
        else
          begin
             // Make sure this link wasn't visited from the other direction
             if ( check_visited(rtr_name, nid_q[j]) )
               begin
                  ovm_report_error ("CFG", "Link is already visited");
                  continue;
               end
             
             // Set interface name
             $sformat(rtr_intf, "iosf_sbc_%0d", nid_q[j]);
             
             // Get connection
	     tmp = {rtr_name, ":", rtr_intf};
             if( iconn_cref.exists(tmp) )
             begin
                other_name = iconn_cref[tmp];
	        other_intf = iconn_bref[tmp];
             end 
             else begin
	       string msg;
               $sformat(msg, "Port %0d is not connected", nid_q[j]);
               ovm_report_warning("IPXACT", msg, iosfsbm_cm::VERBOSE_WARNING);
               continue;
             end
      
             // Handle RTR-2-RTR connection
             if ( is_rtr(other_name))
               begin
                  if(rtr_internal_byte_width[other_name] < rtr_external_byte_width[rtr_name])
                    ovm_report_error("IPXACT", 
                                     $psprintf("%s External byte width is not consistance with Internal byte width of %s",
                                               rtr_name, other_name), iosfsbm_cm::VERBOSE_ERROR);
                  
                  // Now get NID from the dest RTR intf name (syntax slave_<NID>)
                  str_list = svlib_pkg::string_to_list(other_intf, "_"); 
                  assert( str_list.size() == 3) else
                    begin
		       string msg;
                       $sformat(msg, "Unrecognized interface name %s", other_intf);
                       ovm_report_fatal("IPXACT", msg);
                    end

                  // Now add link
                  add_link(rtr_name, nid_q[j], other_name, str_list[2].atoi());
                  
                  // Make rtr/nid combination as visited to avoid repetitive visits
                  mark_visited(other_name, str_list[2].atoi());
               end

             // Handle case where other_name isn't a valid EP or RTR
             else
               begin
	          string msg;
                  $sformat(msg, "Connection with unknown contributer1 %s", other_name);
                  ovm_report_fatal("IPXACT", msg);
               end
          end // else: !if(rtr_cfgs[rtr_name].is_ip_intf(i))
     end // nid_q[i]
  end // rtr_list[i] 

endfunction

function void staticNetworkConfig::staticDoProcessVendorExtensions();
   clk_rst::clk_rst_cfg clk_rst_cfg_i;
   int grp_pid_count, subnet_grp_pid_count;
   iosfsbm_cm::pid_queue_t mcast_pid_q;
   svlib_pkg::string_queue_t pid_str_list, subnet_pid_str_list;
   int search_result[$], search_result_mcast[$], power_well_no;
   iosfsbm_cm::pid_t mcast_pid, grp_pid, ssf_pid;
   int pids_in_grp, subnet_pids_in_grp, clk_num;
   int cg_type;
   string ep_name;      
   svlib_pkg::string_queue_t ep_names;
   bit subnet_t = 0;
   bit local_ext = 0;
   iosfsbm_cm::mcast_type mcast_t_l;
   iosfsbm_cm::pid_t  subnet_pid;
   iosfsbm_cm::pid_t  local_pid;

   if( ! <?dsn_vendor_extensions?> ) //Vendor Extension definition
   begin
    ovm_report_info("CFG", "No vendor extensions specified in the IPXACT file", iosfsbm_cm::VERBOSE_DEBUG_2);
    return;
   end
   
   // Create clocks/resets configuration object
   assert( $cast(clk_rst_cfg_i, ovm_factory::create_object("clk_rst_cfg")) ) else
      ovm_report_fatal("CAST", "Type mismatch !!");

   // Pass clocks/resets cfg descriptor to network_cfg
   add_clk_rst_cfg(clk_rst_cfg_i);
   
   // clock reset
   <+clk_reset+>
   //clock Name, Comments, Testbench Half Period, Clock Number definition
   if(!<?clk_name?> || !<?comments?> || !<?tb_half_per?> || !<?clk_number?>)
      ovm_report_error("CFG", "Encountered incomplete reset specification, ignoring !!", iosfsbm_cm::VERBOSE_ERROR);
   else
   begin
      assert(clk_rst_cfg_i.add_clock(<%clk_number%>, "<%clk_name%>", "<%comments%>", 
                                    2*svlib_pkg::atotime("<%tb_half_per%>")))
      else ovm_report_fatal("CFG", "Could not add clock !!");
   end

   //Clock Name, Reset Name, Clock Number definition
   if(!<?clk_name?> || !<?reset_name?> || !<?clk_number?>)
       ovm_report_error("CFG", "Encountered incomplete reset specification, ignoring !!", iosfsbm_cm::VERBOSE_ERROR);
   else
   begin
      int count;
      if( <?reset_cycle_cnt?> ) //reset Cycle count
         count = <%reset_cycle_cnt%>;
      else
         count = $urandom_range(10, 20);
      assert(clk_rst_cfg_i.add_reset(<%clk_number%>, "<%clk_name%>", count))
      else ovm_report_fatal("CFG", "Could not add reset !!");
   end
  <-clk_reset->
  
  // multicast
    <+multi_castSSF+>
  //Group Port ID, Number of Subnet IDs, Subnet IDs, Subnet Type definition
    if(!<?grp_port_id?> || !<?num_subnet_port_ids?> || !<?subnet_port_ids?> || !<?subnet_type?>)
        ovm_report_error("CFG", "Encountered incomplete segment multicast specification, ignoring !!", iosfsbm_cm::VERBOSE_ERROR);
    else begin
     
        grp_pid_count = 0;
        grp_pid = <%grp_port_id%>;
        ssf_pid = <%ssf_port_id%>;
        subnet_t = <%subnet_type%>;
        subnet_pids_in_grp = <%num_subnet_port_ids%>;
        subnet_pid_str_list = svlib_pkg::string_to_list("<%subnet_port_ids%>");
        pids_in_grp = <%num_port_ids%>;
        pid_str_list = svlib_pkg::string_to_list("<%port_ids%>");
        
        if(subnet_t == 0) begin
            mcast_pid = ssf_pid;
            mcast_local.push_back(mcast_pid);
            mcast_all.push_back(mcast_pid);
            foreach(pid_str_list[j]) begin
                subnet_grp_pid_count = 0;
                foreach(subnet_pid_str_list[k]) begin
                    subnet_pid = subnet_pid_str_list[k].atoi();
                    local_pid = pid_str_list[j].atoi();
                    local_network_mcast[mcast_pid][subnet_pid].push_back(local_pid);
                    subnet_grp_pid_count++;
                end
                grp_pid_count++;
            end
        end
        else if(subnet_t == 1) begin
            mcast_pid = grp_pid;
            mcast_global.push_back(mcast_pid);
            mcast_all.push_back(mcast_pid);
            subnet_grp_pid_count = 0;
            foreach(subnet_pid_str_list[k]) begin
                subnet_pid = subnet_pid_str_list[k].atoi();
                global_network_mcast[mcast_pid][subnet_pid].push_back(subnet_pid);
                g2l_network_mcast[mcast_pid][subnet_pid].push_back(subnet_pid);
                subnet_grp_pid_count++;
            end
        end

        if(pids_in_grp != grp_pid_count)
            ovm_report_error("IPXACT", "Number of port IDs != Port Ids defined for local mcast ports",
            iosfsbm_cm::VERBOSE_ERROR);
        if(subnet_pids_in_grp != subnet_grp_pid_count)
            ovm_report_error("IPXACT", "Number of port IDs != Port Ids defined for global mcast ports",
            iosfsbm_cm::VERBOSE_ERROR);
    
        
    end
  <-multi_castSSF->

    <+multi_castG+>
  //Group Port ID, Number of Port IDs, Port IDs definition
    if(!<?grp_port_id?> || !<?num_port_ids?> || !<?port_ids?>)
        ovm_report_error("CFG", "Encountered incomplete hierarchical multicast specification, ignoring !!", iosfsbm_cm::VERBOSE_ERROR);
    else begin
     
        grp_pid_count = 0;
        mcast_pid = <%grp_port_id%>;
        subnet_t = <%subnet_type%>;
        local_ext = <%local_extension%>;
        pids_in_grp = <%num_port_ids%>;
        pid_str_list = svlib_pkg::string_to_list("<%port_ids%>");
        
        if(subnet_t == 0 && local_ext == 0) begin
            mcast_local.push_back(mcast_pid);
            mcast_all.push_back(mcast_pid);
            foreach(pid_str_list[j]) begin
                if(j%2 == 0) subnet_pid = pid_str_list[j].atoi();
                else begin
                    local_pid = pid_str_list[j].atoi();
                    local_network_mcast[mcast_pid][subnet_pid].push_back(local_pid);
                    //network_mcast[mcast_pid][subnet_pid].push_back(local_pid);
                end
                grp_pid_count++;
            end
        end
        else if(subnet_t == 0 && local_ext == 1) begin
            mcast_global.push_back(mcast_pid);
            mcast_all.push_back(mcast_pid);
            foreach(pid_str_list[j]) begin
                if(j%2 == 0) subnet_pid = pid_str_list[j].atoi();
                else begin
                    local_pid = pid_str_list[j].atoi();
                    global_network_mcast[mcast_pid][subnet_pid].push_back(local_pid);
                    //network_mcast[mcast_pid][subnet_pid].push_back(local_pid);
                end    
                grp_pid_count++;
            end
        end
        else begin
            mcast_global.push_back(mcast_pid);
            mcast_all.push_back(mcast_pid);
            subnet_pid = 255;
            foreach(pid_str_list[j]) begin
                local_pid = pid_str_list[j].atoi();
                g2l_network_mcast[mcast_pid][subnet_pid].push_back(local_pid);
                grp_pid_count++;
            end    
        end

        if(pids_in_grp != grp_pid_count)
            ovm_report_error("IPXACT", "Number of port IDs != Port Ids defined for mcast ports",
            iosfsbm_cm::VERBOSE_ERROR);
        
    end
  <-multi_castG->

  <+multi_cast+>
  //Group Port ID, Number of Port IDs, Port IDs definition
  if(!<?grp_port_id?> || !<?num_port_ids?> || !<?port_ids?>)
      ovm_report_error("CFG", "Encountered incomplete multicast specification, ignoring !!", iosfsbm_cm::VERBOSE_ERROR);
  else
  begin
     

     grp_pid_count = 0;
     mcast_pid = <%grp_port_id%>;
     pids_in_grp = <%num_port_ids%>;
     pid_str_list = svlib_pkg::string_to_list("<%port_ids%>");
     mcast_pid_q = '{};
     mcast_all.push_back(mcast_pid);
     foreach (pid_str_list[j])
      begin
         mcast_pid_q.push_back(pid_str_list[j].atoi());
         global_network_mcast[mcast_pid][255].push_back(pid_str_list[j].atoi());
         grp_pid_count++;
      end

     if(pids_in_grp != grp_pid_count)
       ovm_report_error("IPXACT", "Number of port IDs != Port Ids defined for mcast ports",
                    iosfsbm_cm::VERBOSE_ERROR);

     //Add mcast pid to the grp ep's own p_id list
     foreach ( mcast_pid_q[i] )
     begin
        search_result = '{};
        foreach ( ep_cfgs[ep_name])
        begin
           search_result = ep_cfgs[ep_name].my_ports.find_first_index() with (item == mcast_pid_q[i]);
           //add mcast pid to my_ports of matching ep
           if(search_result.size() != 0)
           begin
             search_result_mcast = ep_cfgs[ep_name].my_ports.find_first_index() with (item == mcast_pid);
             if(search_result_mcast.size() == 0)
             begin
               ovm_report_info(get_name(), "not adding");
               //ep_cfgs[ep_name].my_ports.push_back(mcast_pid);
             end
             else
             begin
	       string msg;
               $sformat(msg, "Mcast Group PID (%h) matching same ep(%s) more than once !!",mcast_pid, ep_name ); 
               ovm_report_fatal("CFG", msg);
             end

             break;
           end
        end    
     end    
  end
  <-multi_cast->
  
  // power wells
  <+power_well+>
  // Make sure power well parameters are complete
  //Power Well Number, Power Well Isolation Signal definition
  if( !<?pwr_well_num?> || !<?pwr_well_iso_sig?> )
    ovm_report_error("CFG", "Encountered incomplete Power Well specification, ignoring !!", iosfsbm_cm::VERBOSE_ERROR);
  else
  begin
    // Get Power Well Number
    power_well_no = <%pwr_well_num%>;
    add_pwr_well(power_well_no);
  end

  <-power_well->
  
  // clock gating
  <+clock_gating+>
  //ClockGating definition
  if (!<?clk_gate_en?>)
    ovm_report_error("CFG", 
                     "Encountered incomplete clockGating specification, ignoring !!", 
                     iosfsbm_cm::VERBOSE_ERROR); 
  else
  begin
     cg_type = <%clk_gate_en%>;
     //enable disable clock gating
     if (cg_type == 1)
       set_cg_type(iosf_pmu::CG_ON);
     else
       set_cg_type(iosf_pmu::CG_OFF);
  end
  <-clock_gating->

  //epSpecRev
  //get eps with different spec version defined
  ep_names = svlib_pkg::string_to_list("<%sr_ep_names%>");
  //set spec rev for eps
  foreach (ep_names[i])
      begin
         ep_name = ep_names[i];         
         ep_cfgs[ep_name].iosfsb_spec_rev = iosfsbm_cm::IOSF_11;
      end


    
endfunction

/**
 * Check if the passed RTR Name/NID was visited before or not
 * @param rtr_name name of the router
 * @param nid nid of the router
 * @return Flag 0/1 = unvisited/visited
 */
function bit staticNetworkConfig::check_visited(string rtr_name, iosfsbm_cm::nid_t nid);
  string rtr_nid;
  string search_result[$];

  $sformat(rtr_nid, "%s_%0d", rtr_name, nid);
  search_result = visited_rtrs.find() with (item == rtr_nid);

  return (search_result.size() != 0);
endfunction: check_visited

/**
 * Mark the passed rtr_name/nid combination as visited
 * @param rtr_name name of the router
 * @param nid nid of the router
 */
function void staticNetworkConfig::mark_visited(string rtr_name, iosfsbm_cm::nid_t nid);
  string rtr_nid;
  $sformat(rtr_nid, "%s_%0d", rtr_name, nid);
  visited_rtrs.push_back(rtr_nid);
endfunction :mark_visited

`endif // INC_STATICNETWORKCONFIG
