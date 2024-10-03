
// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2016) Intel Corporation All Rights Reserved.
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
// File   : HqmIpCfg.sv
// Author : 
//
// Description :
//
// -----------------------------------------------------------------------------
`ifndef __HqmIpCfg__
`define __HqmIpCfg__

import hqm_integ_cfg_pkg::*;
import HqmAtsPkg::*;
import hqm_cfg_pkg::*;
import hqm_tb_cfg_pkg::*;

import IosfPkg::*;


class HqmIpCfg extends uvm_object;
  `uvm_object_utils(HqmIpCfg)
 
   //--iosf cfg
   IosfFabCfg            iosf_pvc_cfg;
   IosfAgtCfg            iosf_pagt_upnode_cfg;   
   IosfAgtCfg            iosf_pagt_dut_cfg;   
 
   //--ats cfg
   HqmAtsPkg::HqmAtsCfgObj atsCfg;

   //--hqm_base
   int id = 0;
   int gpsb_portid = -1;

   string ral_file;
   string sim_type;
   string rtl_path;
   string tb_top_path;   
   string access_type;
   string inst_suffix;
   string sla_env_name;
   string reset_type;   
   int    inst_id;
   int    driver_id;
   int    ral_portid;
   int    disable_update_ral;
   int    rootbus;
   int    secbus;
   int    subordbus;
   int    has_busnum_ctrl;
   int    has_ralbdf_ctrl;
   int    has_raloverride_ctrl;
   bit [15:0] hqm_bdf;
   
   //--fuse
   hqm_fuse_ovrd_config hqm_fuses;
   string hqm_fuse_rtl_path;  

   bit hqm_fuse_no_bypass;
   bit fuse_speedup_en;

   string hqm_fuse_group;

   string fuse_puller_inst_name;
   string fuse_puller_type_name;
   string fuse_ip_instance_name;

   //--mem_map_obj
   hqm_mem_map_cfg mem_map_obj;   
 
 
  //---
  function new(string name = "HqmIpCfg");
    super.new(name);
    //--03082021 access_type = "BACKDOOR";
    ral_portid = -1;      
    hqm_fuses = hqm_fuse_ovrd_config::type_id::create("hqm_fuses");
    mem_map_obj  = hqm_mem_map_cfg::type_id::create("mem_map_obj");
//--AY_O2U_moved to build_phase  super.build_phase(phase); //[UVM MIGRATION]Added super.build_phase(phase)
  endfunction: new

  //---
  function void get_gpsb_port_id();
      gpsb_portid = 33;
  endfunction: get_gpsb_port_id

  //---
  function void pre_randomize();
    super.pre_randomize();
  endfunction: pre_randomize

  //---
  function void post_randomize();
    super.post_randomize();
  endfunction : post_randomize 
   
  //---
  function void build_phase(uvm_phase phase);
    //super.build_phase(phase); //[UVM MIGRATION]Added super.build_phase(phase)
  endfunction
   
  //-------------------------
  function void set_reset_type(string rst_type);
      reset_type = rst_type;
  endfunction // set_reset_type

  //-------------------------
  function string get_reset_type();
      return reset_type;
  endfunction
   
  //-------------------------
  virtual function void get_values_from_config_db(string configPath);
      `uvm_warning(get_full_name(), {"get_values_from_config_db was not implemented for this class on config path: ", configPath} );
  endfunction
   
  //-------------------------
  virtual function void update_dut_view();
      `uvm_info(get_full_name(), "Not implemented", UVM_DEBUG);      
  endfunction
   
  //-------------------------
  function void set_inst_suffix(string inst);      
     inst_suffix = inst;      
     sla_env_name = {"hqm_tb_env"};
     `uvm_info(get_name(), {"My sla env name is: ", sla_env_name}, UVM_DEBUG);      
  endfunction

  //-------------------------
  function string get_inst_suffix();      
     return(inst_suffix);
  endfunction

  //-------------------------
  //function string get_register_access_type();
  //    return access_type;
  //endfunction // get_register_access_type
   
  //-------------------------
  //function void set_register_access_type();
  //endfunction // set_register_access_type                        

  //-------------------------
  function bit is_rtl();
	if(sim_type == "RTL") begin
	  return 1;
	end 
	return 0;
  endfunction
	
  function int is_bfm();
	if(sim_type == "BFM") begin
	  return 1;
	end 
	return 0;
  endfunction
	
  function bit get_disable_ral_update();
	if(disable_update_ral == 1) begin
          return 1;
	end 
	return 0;
  endfunction
	
  //-------------------------
  virtual function int extract_socket_id_from_tb_path(string tb_path);
	 int  socketID = -1;
     
     for (int i = 0 ; i < tb_path.len() ; i++) begin
        if (tb_path[i] == ".") begin
           // Extract the socket ID as an integer.  Expecting format s# as the
           // socket ID.
           string socketIDStr = tb_path.substr(i+2, i+2);
           int    tmpSocketID = socketIDStr.atoi();
           
           // Since atoi() will return zero (0) if unable to convert to an
           // integer (which is a valid socket ID), check that tmpSocketID
           // matches socketIDStr when converted back to a string
           string checkSocketID;
           checkSocketID.itoa(tmpSocketID);
           if (checkSocketID == socketIDStr) socketID = tmpSocketID;
           break;
        end 
     end 
     
     // if we didn't find the socket ID the first time 
     // try this next method
     if(socketID == -1) begin
       for ( int i = 0; i < tb_path.len(); i++ ) begin
         if(tb_path.substr(i, i+5) == "socket") begin
           // Extract the socket ID as an integer.  Expecting format s# as the
           // socket ID.
           string socketIDStr = tb_path.substr(i+6, i+6);
           int    tmpSocketID = socketIDStr.atoi();
           
           // Since atoi() will return zero (0) if unable to convert to an
           // integer (which is a valid socket ID), check that tmpSocketID
           // matches socketIDStr when converted back to a string
           string checkSocketID;
           checkSocketID.itoa(tmpSocketID);
           if (checkSocketID == socketIDStr) socketID = tmpSocketID;
           break;
        end 
       end 
     end 
     // Verify a socket ID was extracted from tbPath
     if (socketID == -1)
       `uvm_fatal(get_name(), $psprintf("no socket-ID in tb_path (%s). Verify ::tb_path includes socket ID (ex. ::tb_path = s0.*) for each cms", tb_path))
       
     `uvm_info(get_name(), $psprintf("extracting socket ID from TB_PATH: %s", tb_path), UVM_LOW)
    
     return(socketID);
     
  endfunction

  //---------------	
  virtual        function int extract_port_id_from_tb_path(string tb_path);
      int         portID = -1;
      
      for (int i = 0 ; i < tb_path.len() ; i++) begin
         if (tb_path.substr(i, i+3) == "port") begin
            // Extract the socket ID as an integer.  Expecting format s# as the
            // socket ID.
            string portIDStr = tb_path.substr(i+4, i+4);
            int    tmpPortID = portIDStr.atoi();
           
            // Since atoi() will return zero (0) if unable to convert to an
            // integer (which is a valid socket ID), check that tmpSocketID
            // matches socketIDStr when converted back to a string
            string checkPortID;
            checkPortID.itoa(tmpPortID);
            if (checkPortID == portIDStr) portID = tmpPortID;
            break;
         end 
      end 
      // Verify a socket ID was extracted from tbPath
      if (portID == -1)
       `uvm_fatal(get_name(), $psprintf("no port-ID in tb_path (%s). Verify ::tb_path includes port ID (ex. ::tb_path = s0.*) for each cms", tb_path))
      
      `uvm_info(get_name(), $psprintf("extracting port ID from TB_PATH: %s", tb_path), UVM_LOW)
      
      return(portID);      
      
      
  endfunction // extract_port_id_from_tb_path

  //-------------------------
  virtual         function int extract_remote_socket_and_port_id(string key, output int socket, output int port);
      // key s0::qpi0
      socket = -1;
      port = -1;      
      for(int i = 0; i < key.len(); i++) begin
         if(key.substr(i, i+1) == "::") begin
            socket = key.substr(i-1, i-1).atoi();
            port = key.substr(i+5, i+5).atoi();            
         end 
      end 
      
      if(socket == -1 || port == -1) begin
         `uvm_warning(get_name(), $psprintf("Did not get a valid path %s", key))
         return 0;
      end 
      
      return 1;
  endfunction
   
   
endclass: HqmIpCfg
`endif
