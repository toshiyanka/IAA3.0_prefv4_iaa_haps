//-----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2013) (2013) Intel Corporation All Rights Reserved. 
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
//------------------------------------------------------------------------------
// File   : hqm_sm_env.sv
// Author : Nikhil Tambekar
//
// Description : This is a container env for Saola system memory manager integration for HQM,DM verification.
//
//------------------------------------------------------------------------------


`ifndef HQM_SM_ENV__SV
`define HQM_SM_ENV__SV

import IosfPkg::*;
import srvr_sm_env_pkg::*;

//-- by using addr_utils dut_view_builder (option 2), no need to import server_sim_address_map_dut_view_builder_pkg::* (for option 1)
//import server_sim_address_map_dut_view_builder_pkg::*; // prevent optimization out

class hqm_tb_sm_env extends srvr_sm_env;

   `ovm_component_utils(hqm_tb_sm_env)

   hqm_tb_env          env;

   extern                   function      new(string name="hqm_tb_sm_env", 
                                              ovm_component parent = null
                                              );
   
   extern virtual function void build();

   extern virtual function void connect();

   extern virtual task do_read(input addr_t addr, input addr_t length, 
                               output byte_t data[$], input string region, 
                               bit backdoor, input string map_name, 
                               input string allocated_name = "", 
                               input  ovm_object user_object=null);
   

   extern virtual function do_read_backdoor(input addr_t addr, input addr_t length, 
                                                 output byte_t data[$], input string region, 
                                                 input string map_name, 
                                                 input string allocated_name = "", 
                                                 input  ovm_object user_object=null);
   

   extern virtual task do_write(input addr_t addr, input byte_t data[$], 
                                input bit be[$], input string region, bit backdoor, 
                                input string map_name, input string allocated_name = "", 
                                input  ovm_object user_object=null);


   extern virtual function do_write_backdoor(input addr_t addr, input byte_t data[$], 
                                                  input bit be[$], input string region,
                                                  input string map_name, input string allocated_name = "", 
                                                  input  ovm_object user_object=null);


   extern virtual task do_load(input string format, input string filename, input string region, bit backdoor, 
                               input addr_t start_addr='0, input string map_name, input string allocated_name = "", 
                               input  ovm_object user_object=null );


   extern virtual task do_dump(input string filename, input string region, bit backdoor, 
                                           input string map_name, input string allocated_name = "", 
                                           input  ovm_object user_object=null); 
   
endclass // hqm_tb_sm_env

function hqm_tb_sm_env::new(string name, 
                         ovm_component parent
                         );

   super.new(name, parent);
   
   
endfunction // new

function void hqm_tb_sm_env::build();

   sla_sm_am_tagmap memmap;
   sla_sm_am_tagmap cfgmap;
   sla_sm_am_tagmap iomap;

   sla_sm_am_tag tag;
   sla_sm_ag_result ag_result;

   int status;
   super.build();

   memmap = this.am.find_map("memmap");

   `sla_info(get_name(),("Printing Tag maps"));
    
   print_tagmap();


endfunction // build

function void hqm_tb_sm_env::connect();

   sla_tb_env   tb_env;

   super.connect();

   tb_env = sla_tb_env::get_top_tb_env();

   assert($cast(env,tb_env))
   else `ovm_fatal(get_name(), "BAD TOP env")

endfunction // connect

task hqm_tb_sm_env::do_read(input addr_t addr, input addr_t length, output byte_t data[$], input string region, 
                         bit backdoor, input string map_name, input string allocated_name, 
                         input  ovm_object user_object);

   do_read_backdoor(addr, length, data, region, map_name, allocated_name, user_object);

endtask

function hqm_tb_sm_env::do_read_backdoor(input addr_t addr, input addr_t length, output byte_t data[$], input string region, 
                                              input string map_name, input string allocated_name, 
                                              input  ovm_object user_object);

   automatic    bit                     alloc_status;
   automatic    int                     counter;
   automatic    logic [7:0]             data_arr[];
   automatic    logic [31:0]            tmp_data;
   automatic    sla_pkg::addr_t         inc_addr;
   automatic    int                     dw_offset;
   automatic    int                     i;
   
   `sla_msg( OVM_HIGH, get_name(),  ("HQM: do_read_backdoor addr=0x%x, length=0x%x, region=%s, map_name=%s", addr, length, region, map_name));

   counter = length;
   inc_addr = addr;
   inc_addr[1:0] = 2'b00;
   dw_offset = {30'h0,addr[1:0]};

   while (counter > 0) begin
     `ifdef HQM_IOSF_2019_BFM
     tmp_data = env.hqm_agent_env_handle.iosf_pvc.readSlaveMemory(Iosf::MEM, inc_addr);
     `else
     tmp_data = env.hqm_agent_env_handle.iosf_pvc.readTargetMemory(Iosf::MEM, inc_addr);
     `endif
     //sla_msg( OVM_LOW, get_name(),  ("HQM: readTargetMemory inc_addr=0x%x, tmp_data=0x%02x", inc_addr, tmp_data));
     for (i = dw_offset ; i < 4 ; i++) begin
       if (counter > 0) begin
         data.push_back(tmp_data[(i*8) +: 8]);
         counter--;
       end
     end
     inc_addr = inc_addr + 4;
     dw_offset = '0;
   end
  `ovm_info(get_name(), $sformatf("HQM: do_read_backdoor: addr=0x%0h length=%0d data=%p from region=%s map_name=%s allocated_name=%s", addr, length, data, region, map_name, allocated_name), OVM_HIGH);

endfunction

task hqm_tb_sm_env::do_write(input addr_t addr, input byte_t data[$], 
                          input bit be[$], input string region, bit backdoor, 
                          input string map_name, input string allocated_name = "", 
                          input  ovm_object user_object=null);

   do_write_backdoor(addr, data, be, region, map_name, allocated_name, user_object);

endtask

function hqm_tb_sm_env::do_write_backdoor(input addr_t addr, input byte_t data[$], 
                                               input bit be[$], input string region,
                                               input string map_name, input string allocated_name = "", 
                                               input  ovm_object user_object=null);

   automatic    bit                     alloc_status;
   automatic    int                     counter;
   automatic    logic [7:0]             data_arr[];
   automatic    logic [31:0]            tmp_data;
   automatic    sla_pkg::addr_t         inc_addr;
   automatic    int                     dw_offset;
   automatic    int                     i;
   
   `sla_msg( OVM_HIGH, get_name(),  ("HQM: do_write_backdoor addr=0x%x, length=0x%x, data=0x%02x...%02x region=%s, map_name=%s", addr, data.size(), data[0], data[data.size()-1], region, map_name));

   counter = data.size();;
   inc_addr = addr;
   inc_addr[1:0] = 2'b00;
   dw_offset = {30'h0,addr[1:0]};

   while (counter > 0) begin
     if ((dw_offset > 0) || (counter < 4)) begin
       `ifdef HQM_IOSF_2019_BFM
          tmp_data = env.hqm_agent_env_handle.iosf_pvc.readSlaveMemory(Iosf::MEM, inc_addr);
       `else
          tmp_data = env.hqm_agent_env_handle.iosf_pvc.readTargetMemory(Iosf::MEM, inc_addr);
       `endif
     end

     for (i = dw_offset ; i < 4 ; i++) begin
       if (counter > 0) begin
         tmp_data[(i*8) +: 8] = data.pop_front();
         counter--;
       end
     end

     //sla_msg( OVM_LOW, get_name(),  ("HQM: writeTargetMemory inc_addr=0x%x, tmp_data=0x%02x", inc_addr, tmp_data));
     `ifdef HQM_IOSF_2019_BFM
        env.hqm_agent_env_handle.iosf_pvc.writeSlaveMemory(Iosf::MEM, inc_addr, tmp_data);
     `else
        env.hqm_agent_env_handle.iosf_pvc.writeTargetMemory(Iosf::MEM, inc_addr, tmp_data);
     `endif

     inc_addr = inc_addr + 4;
     dw_offset = '0;
   end

endfunction

   

task hqm_tb_sm_env::do_load(input string format, input string filename, input string region, bit backdoor, 
                         input addr_t start_addr, 
                         input string map_name, input string allocated_name, input  ovm_object user_object );

//NMT:: To be implemented
endtask // hqm_tb_sm_env

task hqm_tb_sm_env::do_dump(input string filename, input string region, bit backdoor, input string map_name, 
                         input string allocated_name, input  ovm_object user_object); 

//NMT:: To be implemented   
endtask // hqm_tb_sm_env   


`endif
