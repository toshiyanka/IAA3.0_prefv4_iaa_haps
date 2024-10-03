`ifndef HQM_REGISTER_ALIASING_CHECK_SEQ__SV
`define HQM_REGISTER_ALIASING_CHECK_SEQ__SV

//------------------------------------------------------------------------------
// File        : hqm_register_aliasing_check_seq.sv
// Author      : Amol Raghuwanshi 
//
// Description : This sequence is to check the register aliasing in HQM
//               TODO: 1.Registers in exclude list to be verified        
//                     2.Maintain a queue of user updated registers to
//                       comp against get_actual -> Done 
//                     3.Implement tracker  to maintain the registers being written via 
//                       front door and read back via backdoor 
//                     4.Counter to display number of reg access through front door 
//                       and backdoor -> Done
//                     5.Last register segment check: like fin in sla attr seq. To Be Implemented  
//                     6.Accessing Unimplemented spaces for aliasing check  
//                       UAT + followed by background read of all registers 
//                     7.Accessing reg via SB. To Be Implemented  
//                     8.For excluded registers compare with actual value  
//                     9. Provision of adding registers in modified/exclude list via simvarg 
//                     10. Instead of putting registers in exclude_reg queue which scrib in HQM EOT, maintain a different task which will reset those registers before exiting USER_DATA_PHASE
//------------------------------------------------------------------------------

class hqm_register_aliasing_check_seq extends hqm_ral_base_seq; 

   `ovm_sequence_utils(hqm_register_aliasing_check_seq, sla_sequencer)

   hqm_backdoor_register_access_seq  backdoor_reg_access;
   int  final_seg;

   function new(string name = "hqm_register_aliasing_check_seq");

      super.new(name);

      $value$plusargs({"registers_per_seg","=%d"}, this.registers_per_seg); //count of regisers to be included //By default pass some no
      $value$plusargs({"segment_number","=%d"}, this.segment_number); //count of regisers to be included  
      $value$plusargs({"final_segment","=%d"}, this.final_seg); //final register segment

   endfunction

virtual task body(); 

   register_wr_index = registers_per_seg*segment_number;
   `ovm_info(get_name(), $psprintf("Register index is %d",register_wr_index),OVM_LOW)

   excluded_reg_list(); 

   for(int index = register_wr_index; index < register_wr_index + registers_per_seg; index++) begin



      if(index >= reg_list.size() && final_seg == 1) begin
         break; 
      end else if(index >= reg_list.size() && final_seg == 0) begin
         `ovm_error(get_type_name(), $psprintf("User trying to access more than existing registers"));
         break; 
      end     


      if($value$plusargs("HQM_RAL_ACCESS_PATH=%s",primary_id)) begin
        primary_id = iosf_sb_sla_pkg::get_src_type();
       `ovm_info(get_name(), $psprintf("Access Path is Sideband %s",primary_id),OVM_LOW)
      end else begin
        primary_id = sla_iosf_pri_reg_lib_pkg::get_src_type();
       `ovm_info(get_name(), $psprintf("Access Path is Primary %s",primary_id),OVM_LOW)
      end 

      updated_register = reg_list[index].get_name();  
      reg_addr = ral.get_addr_val(primary_id, reg_list[index]);
      `ovm_info(get_name(), $sformatf("register name %s address 0x%0x and value 0x%0x",updated_register, reg_addr, reg_list[index].get_reset_val()),OVM_LOW)

      if(exclude_reg.exists(updated_register)) begin
         continue;  
      end   

      regs_written++;

      legal_sai = reg_list[index].pick_legal_sai_value(RAL_WRITE);
      wr_val    =  ~reg_list[index].get_reset_val();
      reg_list[index].write(status, wr_val, primary_id, this, .sai(legal_sai));

      legal_sai = reg_list[index].pick_legal_sai_value(RAL_READ);
      reg_list[index].read(status, rd_val, primary_id, this, .sai(legal_sai));

      reconfig_excluded_reg_list();
      if(reconfig_reg.exists(updated_register))
         reconfig_registers.push_back(reg_list[index]); 

      modified_reg_list();
      modified_reg[updated_register] = 10000;     //TODO not required

      `ovm_do(backdoor_reg_access);

      legal_sai = reg_list[index].pick_legal_sai_value(RAL_WRITE);
      wr_val    =  reg_list[index].get_reset_val();
      reg_list[index].write(status, wr_val, primary_id, this, .sai(legal_sai));
   end

   `ovm_info(get_name(), $sformatf("Total registers written: %0d for segment number: %d",regs_written, segment_number),OVM_LOW)

   if($test$plusargs("REG_ALIAS_CHK_WITH_PP_ADDR")) begin
      legal_sai = pf_cfg_regs.CSR_BAR_U.pick_legal_sai_value(RAL_WRITE);
      pf_cfg_regs.CSR_BAR_U.write(status,32'h_0000_0001,primary_id,this, .sai(legal_sai)); 
      legal_sai = pf_cfg_regs.CSR_BAR_L.pick_legal_sai_value(RAL_WRITE);
      pf_cfg_regs.CSR_BAR_L.write(status,32'h_0000_0000,primary_id,this, .sai(legal_sai)); 
   end

   foreach(reconfig_registers[j]) begin
      legal_sai = reconfig_registers[j].pick_legal_sai_value(RAL_WRITE);
      wr_val    = reconfig_registers[j].get_reset_val();
      reconfig_registers[j].write(status, wr_val, primary_id, this, .sai(legal_sai));
   end    


endtask 

endclass

`endif
