
class cdnIoWrPcieUserSeq extends cdnPcieOvmUserBaseSeq;

  // ---------------------------------------------------------------
  // The read sequence item (IoTlp) that will be randomized and
  // passed to the driver.
  // ---------------------------------------------------------------
  denaliPcieTlpIoPacket	IoTlp;
  rand logic [31:0] data_ ;
  rand logic [31:0] addr_ ;
  // ---------------------------------------------------------------
  // Use the OVM Sequence macro for this class.
  // ---------------------------------------------------------------
  `ovm_object_utils_begin(cdnIoWrPcieUserSeq)
    `ovm_field_object(IoTlp, OVM_ALL_ON)
  `ovm_object_utils_end
  
  `ovm_declare_p_sequencer(cdnPcieOvmUserSequencer)

  //function void setSequencerCfgs();
    

  // ---------------------------------------------------------------
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ---------------------------------------------------------------
  function new(string name = "cdnIoWrPcieUserSeq");
    super.new(name);
     IoTlp = new(); 
	 
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
            IoTlp.srcConfig = mySequencer.srcConfig;
            IoTlp.dstConfig = mySequencer.dstConfig;
			`ovm_info("pre_do", $sformatf("configuring src and dst"), OVM_LOW)
        end

        IoTlp.easyModeTlpConstraint.constraint_mode(1);
        IoTlp.pktType = DENALI_PCIE__Tlp;
        IoTlp.tlpType = DENALI_PCIE_TL_IOWr;
        IoTlp.pktDelay = 0;
        IoTlp.setRequesterId(tlpReqId);
        IoTlp.setTrafficClass(3'h_0);
        IoTlp.setHasDigest(1'h_0);
        IoTlp.setIsPoisoned(1'h_0);
        IoTlp.setAttr(3'h_0);
        IoTlp.setAddrType(2'h_0);

		IoTlp.tphPresent = 0;
		IoTlp.setLength('h_01);
		IoTlp.setFirstBe('h_f);
		IoTlp.setLastBe(4'h_0);
		IoTlp.setTransactionIdTag(pcie_tag);
		IoTlp.setLastBe(0);
		IoTlp.setAddress(addr_);

		payload_		= new[4];
		payload_[3]		= data_[7:0];
		payload_[2]		= data_[15:8];
		payload_[1]		= data_[23:16];
		payload_[0]		= data_[31:24];

		IoTlp.setPayload(payload_);

		`ovm_info(get_name(), $sformatf("Printing pkt details: \n %0s", IoTlp.sprintInfo()), OVM_LOW)

  endtask : pre_do

  // ---------------------------------------------------------------
  // Method : body
  // Desc.  : Perform Memory Read After Memory Write
  // ---------------------------------------------------------------
  virtual task body();

    `ovm_info(get_name(), $sformatf("Waiting for Device to be active!!"), OVM_LOW)
	wait_for_RC_active();
    `ovm_send(IoTlp)
    `ovm_info(get_name(), $sformatf("Done sending sequence !!"), OVM_LOW)
	
  endtask : body

endclass 

