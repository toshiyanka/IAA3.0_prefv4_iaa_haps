`ifndef HQM_BACKDOOR_REGISTER_ACCESS_SEQ__SV
`define HQM_BACKDOOR_REGISTER_ACCESS_SEQ__SV

//------------------------------------------------------------------------------
// File        : hqm_backdoor_register_access_seq.sv
// Author      : Amol Raghuwanshi 
//
// Description : This sequence is to read all RAL registers via backdoor 
//------------------------------------------------------------------------------

class hqm_backdoor_register_access_seq extends hqm_ral_base_seq; 

   `ovm_sequence_utils(hqm_backdoor_register_access_seq, sla_sequencer)

function new(string name = "hqm_backdoor_register_access_seq");

   super.new(name);
   backdoor_id = "backdoor";

endfunction   

virtual task body(); 

   foreach(pf_cfg_reg_list[i])           compare_data_via_backdoor(pf_cfg_reg_list[i]); 
   foreach(list_sel_pipe_reg_list[i])    compare_data_via_backdoor(list_sel_pipe_reg_list[i]); 
   foreach(qed_pipe_reg_list[i])         compare_data_via_backdoor(qed_pipe_reg_list[i]); 
   foreach(dir_pipe_reg_list[i])         compare_data_via_backdoor(dir_pipe_reg_list[i]); 
   foreach(nalb_pipe_reg_list[i])        compare_data_via_backdoor(nalb_pipe_reg_list[i]); 
   foreach(atm_pipe_reg_list[i])         compare_data_via_backdoor(atm_pipe_reg_list[i]); 
   foreach(aqed_pipe_reg_list[i])        compare_data_via_backdoor(aqed_pipe_reg_list[i]); 
   foreach(reorder_pipe_reg_list[i])     compare_data_via_backdoor(reorder_pipe_reg_list[i]); 
   foreach(credit_hist_pipe_reg_list[i]) compare_data_via_backdoor(credit_hist_pipe_reg_list[i]); 
   foreach(config_master_reg_list[i])    compare_data_via_backdoor(config_master_reg_list[i]); 
   foreach(system_csr_reg_list[i])       compare_data_via_backdoor(system_csr_reg_list[i]); 
   foreach(sif_csr_reg_list[i])          compare_data_via_backdoor(sif_csr_reg_list[i]); 
   foreach(msix_mem_reg_list[i])         compare_data_via_backdoor(msix_mem_reg_list[i]); 


endtask

virtual task compare_data_via_backdoor(sla_ral_reg register);       

      if(read_counter == 0) 
         regs_read_via_backdoor++; 

      reg_name = register.get_name();
      `ovm_info(get_name(), $sformatf("Register file is %s, Register name is %s",reg_name, register.get_file_name),OVM_MEDIUM)

      modified_reg_list();
      excluded_reg_list(); 

      if(|register.get_attr_mask("RW")) begin
         if($test$plusargs("PP_ADDR_ALIASING_TO_REGS_CHK")) begin
            comp_val = register.get(); 
         end else if(modified_reg.exists(reg_name)) begin
            comp_val = register.get(); 
         end else if(exclude_reg.exists(reg_name))  begin  
            comp_val = register.get_reset_val(); 
         end else begin
            comp_val = register.get(); 
         end   

         mask = register.get_attr_mask("RW");

         legal_sai = register.pick_legal_sai_value(RAL_READ);
         register.readx(status,comp_val,mask,rd_val,backdoor_id,.sai(legal_sai));

         log = $psprintf("while doing read_compare of reg (%s) with comp_val(0x%0x), rd_val(0x%0x), mask(0x%0x)",register.get_name(),comp_val,rd_val,mask);

         if(status != sla_pkg::SLA_OK) begin
            `ovm_error(get_name(), $sformatf("Received (%s) status %s",status.name(), log))
         end else if((rd_val & mask) != (comp_val & mask))    begin
            `ovm_error(get_name(), $sformatf("Read mismatched %s",log))
         end else begin
            `ovm_info(get_name(), $sformatf("Read matched %s",log),OVM_MEDIUM)
         end
      end

   read_counter = 1;
   `ovm_info(get_name(), $sformatf("Total registers read via backdoor %d",regs_read_via_backdoor),OVM_LOW)

endtask

endclass

`endif
