`ifndef HQM_SLA_PCIE_ERR_REPORT_DIS_SEQ__SV
`define HQM_SLA_PCIE_ERR_REPORT_DIS_SEQ__SV

import lvm_common_pkg::*;

class hqm_sla_pcie_err_report_dis_seq extends hqm_sla_pcie_base_seq; 
  `ovm_sequence_utils(hqm_sla_pcie_err_report_dis_seq,sla_sequencer)
  hqm_sla_pcie_cpl_error_seq  ue_cpl_seq;
  hqm_sla_pcie_d3_err_chk_seq d3_ur_seq;
  hqm_sla_pcie_mem_mtlp_seq   mtlp_seq ;
  int sev_mask_val;
  int urro_dis;
  int mtlp_report_dis;
  function new(string name = "hqm_sla_pcie_err_report_dis_seq");
    super.new(name); 
  endfunction

  virtual task body();

    if(!p_sequencer.get_config_int("urro_dis", urro_dis)) urro_dis = 0;

    if(!p_sequencer.get_config_int("mtlp_report_dis", mtlp_report_dis)) mtlp_report_dis = 0;

    if (!p_sequencer.get_config_int("sev_mask_val", sev_mask_val)) begin
        sev_mask_val = 0;
    end

    if(urro_dis == 1) sev_mask_val = 7; // -- Setting this variable locally to 7 to disable/enable URRO bit in DEV_CONTROL

    `ovm_info(get_full_name(), $psprintf("hqm_sla_pcie_err_report_dis_seq variables: sev_mask_val(0x%0x), urro_dis(0x%0x)", sev_mask_val, urro_dis), OVM_LOW)

    // -- Disable error reporting for particular error -- //
    disable_err_reporting(sev_mask_val);
    if(|mtlp_report_dis) begin `ovm_do_with(mtlp_seq,   {reporting_en==1'b_0;}); end
    else if(urro_dis)    begin `ovm_do_with(d3_ur_seq,  {reporting_en==1'b_0;}); end
    else                 begin `ovm_do_with(ue_cpl_seq, {reporting_en==1'b_0;}); end

    // -- Enable error reporting for particular error -- //
    if(mtlp_report_dis == 3) enable_serr();
    else                     enable_err_reporting(sev_mask_val);

    if(|mtlp_report_dis) begin `ovm_do_with(mtlp_seq,   {reporting_en==1'b_1;}); end
    else if(urro_dis)    begin `ovm_do_with(d3_ur_seq,  {reporting_en==1'b_1;}); end
    else                 begin `ovm_do_with(ue_cpl_seq, {reporting_en==1'b_1;}); end

  endtask : body

  task disable_err_reporting(int sev_mask_val);
    case (sev_mask_val)
      0: pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write_fields(status,{"NERE"},{1'b_0},primary_id,this,.sai(legal_sai));
      1: pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write_fields(status,{"FERE"},{1'b_0},primary_id,this,.sai(legal_sai));
      4: pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write_fields(status,{"CERE"},{1'b_0},primary_id,this,.sai(legal_sai));
      7: pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write_fields(status,{"URRO"},{1'b_0},primary_id,this,.sai(legal_sai));
    endcase
  endtask : disable_err_reporting
  
  task enable_serr();
      pf_cfg_regs.DEVICE_COMMAND.write_fields(status,{"SER"},{1'b_1},primary_id,this,.sai(legal_sai));
  endtask : enable_serr

  task enable_err_reporting(int sev_mask_val);
    case (sev_mask_val)
      0: pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write_fields(status,{"NERE"},{1'b_1},primary_id,this,.sai(legal_sai));
      1: pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write_fields(status,{"FERE"},{1'b_1},primary_id,this,.sai(legal_sai));
      4: pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write_fields(status,{"CERE"},{1'b_1},primary_id,this,.sai(legal_sai));
      7: pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write_fields(status,{"URRO"},{1'b_1},primary_id,this,.sai(legal_sai));
    endcase
  endtask : enable_err_reporting

endclass : hqm_sla_pcie_err_report_dis_seq

`endif
