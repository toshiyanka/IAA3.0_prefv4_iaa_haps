`ifndef HQM_PCIE_UNALLOC_BAR_ACCESS_SEQUENCE_
`define HQM_PCIE_UNALLOC_BAR_ACCESS_SEQUENCE_
`include "stim_config_macros.svh"

typedef enum int {  
                   Unalloc_func_pf_bar       = 0, 
                   Unalloc_csr_bar           = 1
                 } bar_access_type_t ;

class hqm_pcie_unalloc_bar_access_stim_config extends ovm_object;

  static string stim_cfg_name = "hqm_pcie_unalloc_bar_access_stim_config";

  rand bar_access_type_t bar_access_type;
 
  `ovm_object_utils_begin(hqm_pcie_unalloc_bar_access_stim_config)
      `ovm_field_enum(bar_access_type_t,  bar_access_type,  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pcie_unalloc_bar_access_stim_config)
      `stimulus_config_field_rand_enum(bar_access_type_t,  bar_access_type)
  `stimulus_config_object_utils_end
 
  function new(string name = "hqm_pcie_unalloc_bar_access_stim_config");
    super.new(name); 
  endfunction

endclass : hqm_pcie_unalloc_bar_access_stim_config


class hqm_pcie_unalloc_bar_access_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_pcie_unalloc_bar_access_seq,sla_sequencer)

    hqm_sla_pcie_init_seq           pcie_init_seq;

  rand hqm_pcie_unalloc_bar_access_stim_config cfg;
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pcie_unalloc_bar_access_stim_config);

  function new(string name = "hqm_pcie_unalloc_bar_access_seq");
    super.new(name);
    cfg = hqm_pcie_unalloc_bar_access_stim_config::type_id::create("hqm_pcie_unalloc_bar_access_stim_config"); 
    apply_stim_config_overrides(0);  // 0 means apply overrides for non-rand variables before seq.randomize() is called

  endfunction

  virtual task body();

      bit [31:0] write_data, func_pf_bar_reg_exp, csr_bar_reg_exp;
      apply_stim_config_overrides(1); // (1) below means apply overrides for random variables after seq.randomize() is called
     

	  `ovm_info(get_name(), $sformatf("Starting MMIO unallocated access sequence "),OVM_LOW)

      // check that startFLR bit is not set to 1
	  read_compare(pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL,16'h_0000,16'h_8000,result);

	  //Disable Bus Master, INTX and Mem Txn enable bit 
	  pf_cfg_regs.DEVICE_COMMAND.write(status,{1'b_1,10'h_0},primary_id,this,.sai(legal_sai));

	  //Disable MSI in order to avoid any unattended INT later
	  pf_cfg_regs.MSIX_CAP_CONTROL.write(status,16'h_0000,primary_id,this,.sai(legal_sai));

      // Start FLR
	  pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write(status,16'h_8000,primary_id,this,.sai(legal_sai));

      // Waiting for HQM to come out of FLR 
      wait_sys_clk(7000); 

	  `ovm_info(get_name(),$sformatf("Done with FLR "),OVM_LOW)

      write_data =$urandom();
      func_pf_bar_reg_exp = write_data[31:0];
      csr_bar_reg_exp     = write_data[31:0];

      // program BARS depending of bar_access_type config (Example:for bar_access_type==Unalloc_func_pf_bar, program CSR & VF bars, but don't programm PF FUNC BAR).
      case (cfg.bar_access_type)
          Unalloc_func_pf_bar: begin
              pf_cfg_regs.CSR_BAR_U.write(status,32'h_0000_0002,primary_id);
              pf_cfg_regs.CSR_BAR_L.write(status,32'h_0000_0000,primary_id);
              func_pf_bar_reg_exp=0;
          end
          Unalloc_csr_bar: begin
              pf_cfg_regs.FUNC_BAR_U.write(status,32'h_0000_0001,primary_id);
              pf_cfg_regs.FUNC_BAR_L.write(status,32'h_0000_0000,primary_id);
              csr_bar_reg_exp=0;
          end
      endcase

      // set MEM space enable, Bus Master ENable, NUM VFs, VFE, VF MSE, VF ARI to 1
	  pf_cfg_regs.DEVICE_COMMAND.write(status,16'h0006,primary_id);

      wait_sys_clk(20000); // PCIe spec, section:9.3.3.3.1 - VFE going from 1 to 0 is similar to FLR, need to wait 100ms before sending any Txns after VFE 0 to 1

      // write some random data to both BARs
      send_wr(hqm_msix_mem_regs.MSG_DATA[0], write_data[31:0]);
      send_wr(hqm_system_csr_regs.AI_DATA[0], {16'h0,write_data[15:0]});
	  pf_cfg_regs.DEVICE_COMMAND.read(status,rd_val,primary_id);

      // send reads to both BARs & expect UR from Unprogrammed BAR, Successful Cpl from programmed BARs
      send_rd(hqm_msix_mem_regs.MSG_DATA[0],                  .ur((cfg.bar_access_type==Unalloc_func_pf_bar)));
      send_rd(hqm_system_csr_regs.AI_DATA[0],                 .ur((cfg.bar_access_type==Unalloc_csr_bar)));
	  pf_cfg_regs.DEVICE_COMMAND.read(status,rd_val,primary_id);

      // program both BARs
      pf_cfg_regs.FUNC_BAR_U.write(status,32'h_0000_0001,primary_id);
      pf_cfg_regs.FUNC_BAR_L.write(status,32'h_0000_0000,primary_id);
      pf_cfg_regs.CSR_BAR_U.write(status,32'h_0000_0002,primary_id);
      pf_cfg_regs.CSR_BAR_L.write(status,32'h_0000_0000,primary_id);

      // set MEM space enable, Bus Master ENable, NUM VFs, VFE, VF MSE, VF ARI to 1
	  pf_cfg_regs.DEVICE_COMMAND.write(status,16'h0006,primary_id);

      // read & check for reset/default value
      read_compare(hqm_msix_mem_regs.MSG_DATA[0], func_pf_bar_reg_exp,32'h_ffffffff,result);
      read_compare(hqm_system_csr_regs.AI_DATA[0], {16'h0,csr_bar_reg_exp[15:0]},32'h_ffffffff,result);

      write_data =$urandom();
      // write random data to both BARs
      send_wr(hqm_msix_mem_regs.MSG_DATA[0], write_data[31:0]);
      send_wr(hqm_system_csr_regs.AI_DATA[0], {16'h0,write_data[15:0]});
	  pf_cfg_regs.DEVICE_COMMAND.read(status,rd_val,primary_id);

      // read & check for written value
      read_compare(hqm_msix_mem_regs.MSG_DATA[0], write_data[31:0],32'h_ffffffff,result);
      read_compare(hqm_system_csr_regs.AI_DATA[0], {16'h0,write_data[15:0]},32'h_ffffffff,result);

      `ovm_info(get_full_name(),$psprintf("Done with hqm_pcie_unalloc_bar_access_seq "),OVM_LOW)
  endtask

  task wait_sys_clk(int ticks=10);
   repeat(ticks) begin @(sla_tb_env::sys_clk_r); end
  endtask
 
endclass

`endif
