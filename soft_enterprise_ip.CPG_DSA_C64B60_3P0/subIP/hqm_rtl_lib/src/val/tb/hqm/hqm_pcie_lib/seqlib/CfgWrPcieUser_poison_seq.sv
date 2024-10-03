`ifndef INCLUDE_CDN_USER_ERROR_SEQ_LIB_
`define INCLUDE_CDN_USER_ERROR_SEQ_LIB_

class CfgWrPcieUser_poison_seq extends cdnPcieOvmUserBaseSeq;

  // ---------------------------------------------------------------
  // The read sequence item (CfgTlp) that will be randomized and
  // passed to the driver.
  // ---------------------------------------------------------------
  denaliPcieTlpCfgPacket CfgTlp;
  rand logic [31:0] data_ ;
  rand logic [31:0] addr_ ;
  // ---------------------------------------------------------------
  // Use the OVM Sequence macro for this class.
  // ---------------------------------------------------------------
  `ovm_object_utils_begin(CfgWrPcieUser_poison_seq)
    `ovm_field_object(CfgTlp, OVM_ALL_ON)
  `ovm_object_utils_end
  
  `ovm_declare_p_sequencer(cdnPcieOvmUserSequencer)

  //function void setSequencerCfgs();
    

  // ---------------------------------------------------------------
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ---------------------------------------------------------------
  function new(string name = "CfgWrPcieUser_poison_seq");
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
        CfgTlp.tlpType = DENALI_PCIE_TL_CfgWr0;
        CfgTlp.pktDelay = 0;
        CfgTlp.setRequesterId(tlpReqId);
        CfgTlp.setCompleterId(tlpCplId[pcie_func_no]);
        CfgTlp.setTrafficClass(3'h_0);
        CfgTlp.setHasDigest(1'h_0);
        CfgTlp.setIsPoisoned(1'h_1);
        CfgTlp.setAttr(3'h_0);
        CfgTlp.setAddrType(2'h_0);

		CfgTlp.tphPresent = 0;
		CfgTlp.setLength('h_01);
		CfgTlp.setFirstBe('h_f);
		CfgTlp.setLastBe(4'h_0);
		CfgTlp.setTransactionIdTag(pcie_tag);
		CfgTlp.setLastBe(0);
		CfgTlp.setRegisterNumber(addr_[5:0]);
		CfgTlp.setExtRegisterNumber(addr_[9:6]);

		payload_		= new[4];
		payload_[3]		= data_[7:0];
		payload_[2]		= data_[15:8];
		payload_[1]		= data_[23:16];
		payload_[0]		= data_[31:24];

		CfgTlp.setPayload(payload_);
                 User_Data = new();
                 User_Data.intData = exp_err;
		CfgTlp.setUserData(User_Data);


		`ovm_info(get_name(), $sformatf("Printing pkt details: \n %0s", CfgTlp.sprintInfo()), OVM_LOW)

  endtask : pre_do

  // ---------------------------------------------------------------
  // Method : body
  // Desc.  : Perform Memory Read After Memory Write
  // ---------------------------------------------------------------
  virtual task body();

    `ovm_info(get_name(), $sformatf("Waiting for Device to be active!!"), OVM_LOW)
	wait_for_RC_active();
    `ovm_info(get_name(), $sformatf("Starting sequence !!"), OVM_LOW)
    `ovm_send(CfgTlp)
    `ovm_info(get_name(), $sformatf("Done sending sequence !!"), OVM_LOW)
	
	//p_sequencer.
  endtask : body

endclass 

`endif
