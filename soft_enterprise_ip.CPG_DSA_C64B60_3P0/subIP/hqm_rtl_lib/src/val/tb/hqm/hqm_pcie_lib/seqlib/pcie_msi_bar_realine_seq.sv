`ifndef PCIE_MSI_BAR_REALINE_SEQ
`define PCIE_MSI_BAR_REALINE_SEQ

class pcie_msi_bar_realine_seq extends cdnPcieOvmUserBaseSeq;
  `ovm_sequence_utils(pcie_msi_bar_realine_seq,cdnPcieOvmUserSequencer)
  rand integer CfgId;
  rand bit	   isRC;

  constraint is_rc_constraint	{ soft isRC == 1'b0; }

  function new(string name = "pcie_msi_bar_realine_seq");
    super.new(name);
  endfunction

  virtual task body();
	string access_path;
	reg [31:0]  status;

	wait_for_RC_active();
	`ovm_info(get_name(),"Started Deassigning MSI BAR mapping ",OVM_LOW);


	$value$plusargs("HQM_RAL_ACCESS_PATH=%s",access_path);
	`ovm_info(get_name(),$sformatf("HQM_RAL_ACCESS_PATH=%s",access_path),OVM_LOW)
	if(access_path == "pcie") begin
		`ovm_info(get_name()," -------------- Deassigning MSI BAR mapping in RC ---------------- ",OVM_LOW);
		if(isRC)  status = $mmwriteword4(CfgId, PCIE_REG_DEN_BAR_MSI64, PCIE_BARTYPE_UNDEFINED);
		if(isRC)  status = $mmwriteword4(CfgId, PCIE_REG_DEN_INTR_CTRL, (PCIE_Rmask__DEN_INTR_CTRL_disMSIX | PCIE_Rmask__DEN_INTR_CTRL_disMSI ));
		status = $mmwriteword4(CfgId, PCIE_REG_DEN_BAR_0	, PCIE_BARTYPE_UNDEFINED);
		status = $mmwriteword4(CfgId, PCIE_REG_DEN_BAR_1	, PCIE_BARTYPE_UNDEFINED);
		status = $mmwriteword4(CfgId, PCIE_REG_DEN_BAR_2	, PCIE_BARTYPE_UNDEFINED);
		status = $mmwriteword4(CfgId, PCIE_REG_DEN_BAR_3	, PCIE_BARTYPE_UNDEFINED);
	end
	#1;
  endtask

endclass

`endif
