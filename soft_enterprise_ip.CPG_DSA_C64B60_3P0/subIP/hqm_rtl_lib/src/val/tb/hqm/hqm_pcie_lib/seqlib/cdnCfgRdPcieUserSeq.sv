`ifndef _CDNCFGRDPCIEUSERSEQ
`define _CDNCFGRDPCIEUSERSEQ

class cdnCfgRdPcieUserSeq extends cdnPcieOvmUserBaseSeq;

  // ---------------------------------------------------------------
  // The read sequence item (CfgTlp) that will be randomized and
  // passed to the driver.
  // ---------------------------------------------------------------
  denaliPcieTlpCfgPacket CfgTlp;
  rand logic [31:0] data_ ;
  rand logic [31:0] addr_ ;
  rand bit is_compare ;
  // ---------------------------------------------------------------
  // Use the OVM Sequence macro for this class.
  // ---------------------------------------------------------------
  `ovm_object_utils_begin(cdnCfgRdPcieUserSeq)
    `ovm_field_object(CfgTlp, OVM_ALL_ON)
  `ovm_object_utils_end
  
  `ovm_declare_p_sequencer(cdnPcieOvmUserSequencer)

  //function void setSequencerCfgs();
    

  // ---------------------------------------------------------------
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ---------------------------------------------------------------
  function new(string name = "cdnCfgRdPcieUserSeq");
    super.new(name);
     CfgTlp = new(); 
	 
  endfunction : new

  // ***************************************************************
  // Method : pre_do
  // Desc.  : Set the source and destination configuration spaces,
  //          and the packet and TLP types.  Also enable the Easy
  //          Mode constraint.
  // ***************************************************************
  virtual task pre_do(bit is_item);
    cdnPcieOvmUserSequencer mySequencer;
	logic[7:0] payload_ [];

        if ($cast(mySequencer,get_sequencer())) begin
            CfgTlp.srcConfig = mySequencer.srcConfig;
            CfgTlp.dstConfig = mySequencer.dstConfig;
			`ovm_info("pre_do", $sformatf("configuring src and dst"), OVM_LOW)
        end

        CfgTlp.easyModeTlpConstraint.constraint_mode(1);
        CfgTlp.pktType = DENALI_PCIE__Tlp;
        CfgTlp.tlpType = DENALI_PCIE_TL_CfgRd0;
        CfgTlp.pktDelay = 0;
        CfgTlp.setRequesterId(tlpReqId);
		//Implies->pcie_func_no is not assigned a value via constraints; ran via RAL.
		if(is_ral)	  pcie_func_no = (addr_[23:16]-func_base); // (>7) means function is not PF
		`ovm_info("PCIE Function number:",$sformatf("0x%0x",pcie_func_no),OVM_LOW);
        CfgTlp.setCompleterId(tlpCplId[pcie_func_no]);
        CfgTlp.setTrafficClass(3'h_0);
        CfgTlp.setHasDigest(1'h_0);
        CfgTlp.setIsPoisoned(1'h_0);
        CfgTlp.setAttr(3'h_0);
        CfgTlp.setAddrType(2'h_0);

		CfgTlp.setLength('h_01);
		CfgTlp.setFirstBe(4'h_f);
		CfgTlp.setLastBe(4'h_0);
		//CfgTlp.setModelGensTag(0);
		//CfgTlp.setTransactionIdTag(pcie_tag);
		CfgTlp.setLastBe(0);
		CfgTlp.setRegisterNumber(addr_[5:0]);
		CfgTlp.setExtRegisterNumber(addr_[9:6]);
		/*
		CfgTlp.completerId.setBusNumber(addr_[31:24]);
		CfgTlp.completerId.setDeviceNumber(addr_[23:19]);
		CfgTlp.completerId.setFunctionNumber(addr_[18:16]);
		*/
		CfgTlp.tphPresent = 0;

		if(is_compare)	begin
			payload_ = new[4];
			if(|mask_) begin
			  payload_[3]		= data_[7:0]  & mask_[07:00];
			  payload_[2]		= data_[15:8] & mask_[15:08];
			  payload_[1]		= data_[23:16]& mask_[23:16];
			  payload_[0]		= data_[31:24]& mask_[31:24];
			end else  begin
			  payload_[3]		= data_[7:0];
			  payload_[2]		= data_[15:8];
			  payload_[1]		= data_[23:16];
			  payload_[0]		= data_[31:24];
			end
			CfgTlp.setPayloadExpected(payload_);
		end

		User_Data = new();	User_Data.intData = exp_err;
		CfgTlp.setUserData(User_Data);

	    //`ovm_info(get_name(), $sformatf("Printing pkt details: \n %0s", CfgTlp.sprintInfo()), OVM_LOW)

  endtask : pre_do

  // ---------------------------------------------------------------
  // Method : body
  // Desc.  : Perform Memory Read After Memory Write
  // ---------------------------------------------------------------
  virtual task body();

    `ovm_info(get_name(), $sformatf("Waiting for Device to be active!!"), OVM_LOW)
	wait_for_RC_active();
    `ovm_send(CfgTlp)
    `ovm_info(get_name(), $sformatf("Done sending sequence !!"), OVM_LOW)
	
  endtask : body

endclass 

`endif
