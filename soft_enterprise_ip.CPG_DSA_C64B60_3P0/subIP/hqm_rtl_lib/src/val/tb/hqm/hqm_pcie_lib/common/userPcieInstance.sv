
`ifndef USER_PCIE_INSTANCE_SV
`define USER_PCIE_INSTANCE_SV

// ***************************************************************
// class: userPcieInstance
// This class is a wrapper for the model core, and provides an API for it. 
// ***************************************************************
class userPcieInstance extends denaliPcieInstance;

 
  // ***************************************************************
  // Use the OVM registration macro for this class. 
  // ***************************************************************
  `ovm_component_utils(userPcieInstance)

  event TL_transmit_queue_enterCbFEvent; 

  mailbox #(denaliPciePacket) PciePacket_mb;
  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "userPcieInstance", ovm_component parent = null);
    super.new(name, parent);
	super.post_new();
	PciePacket_mb = new();
  endfunction : new
  
 


  // ***************************************************************
  // Method : end_of_elaboration/end_of_elaboration
  // Desc.  : Apply configuration settings in this phase
  // ***************************************************************
  virtual function void end_of_elaboration();
    super.end_of_elaboration();
  endfunction : end_of_elaboration
  
  
  // ***************************************************************
  // Method : DefaultCbF
  // Desc.  : callback function overloading
  //          This function is called whenever any of the other callback functions is called
  // ***************************************************************
  virtual function int DefaultCbF(ref denaliPciePacket trans);
    int status;
    status = super.DefaultCbF(trans);
	//`ovm_info(get_name(), $sformatf("DefaultCbF for %s",trans.sprintInfo()), OVM_LOW);
    
    return status;
  endfunction : DefaultCbF

  // ***************************************************************
  // Method : errorCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int errorCbF(ref denaliPciePacket trans);
    int status;
    status = super.errorCbF(trans);
    
    
    return status;    
  endfunction : errorCbF
  
  // ***************************************************************
  // Method : TX_errorCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TX_errorCbF(ref denaliPciePacket trans);
    int status;
    status = super.TX_errorCbF(trans);
    
    
    return status;    
  endfunction : TX_errorCbF
  
  // ***************************************************************
  // Method : RX_errorCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int RX_errorCbF(ref denaliPciePacket trans);
    int status;
    status = super.RX_errorCbF(trans);
    
    
    return status;    
  endfunction : RX_errorCbF
  
  // ***************************************************************
  // Method : TX_discardCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TX_discardCbF(ref denaliPciePacket trans);
    int status;
    status = super.TX_discardCbF(trans);
    
    
    return status;    
  endfunction : TX_discardCbF
  
  // ***************************************************************
  // Method : RX_discardCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int RX_discardCbF(ref denaliPciePacket trans);
    int status;
    status = super.RX_discardCbF(trans);
    
    
    return status;    
  endfunction : RX_discardCbF
  
  // ***************************************************************
  // Method : assert_passCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int assert_passCbF(ref denaliPciePacket trans);
    int status;
    status = super.assert_passCbF(trans);
    
    
    return status;    
  endfunction : assert_passCbF
  
  // ***************************************************************
  // Method : TL_user_queue_enterCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_user_queue_enterCbF(ref denaliPciePacket trans);
    int status;
    status = super.TL_user_queue_enterCbF(trans);
	//`ovm_info(get_name(), $sformatf("TL_user_queue_enterCbF for %s",trans.sprintInfo()), OVM_LOW);
    
    
    return status;    
  endfunction : TL_user_queue_enterCbF
  
  // ***************************************************************
  // Method : TL_user_queue_exitCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_user_queue_exitCbF(ref denaliPciePacket trans);
    int status;
    status = super.TL_user_queue_exitCbF(trans);
	//`ovm_info(get_name(), $sformatf("TL_user_queue_exitCbF for %s",trans.sprintInfo()), OVM_LOW);
    
    
    return status;    
  endfunction : TL_user_queue_exitCbF
  
  // ***************************************************************
  // Method : TL_transmit_queue_enterCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_transmit_queue_enterCbF(ref denaliPciePacket trans);
    int status;
    status = super.TL_transmit_queue_enterCbF(trans);
	->TL_transmit_queue_enterCbFEvent;
	//`ovm_info(get_name(), $sformatf("TL_transmit_queue_enterCbF for %s",trans.sprintInfo()), OVM_LOW);
    
    
    return status;    
  endfunction : TL_transmit_queue_enterCbF
  
  // ***************************************************************
  // Method : TL_transmit_queue_exitCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_transmit_queue_exitCbF(ref denaliPciePacket trans);
    int status;
/*	PciePacket_mb.try_put(trans);
	`ovm_info(get_name(), $sformatf("TL_transmit_queue_exitCbF called for %s",trans.sprintInfo()), OVM_LOW)
	`ovm_info(get_name(), $sformatf("PCIe packet added to mb -> size (%0d)",PciePacket_mb.num()), OVM_LOW)
*/  
  status = super.TL_transmit_queue_exitCbF(trans);
    
    
    return status;    
  endfunction : TL_transmit_queue_exitCbF
  
  // ***************************************************************
  // Method : TL_TX_completion_queue_enterCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_TX_completion_queue_enterCbF(ref denaliPciePacket trans);
    int status;
    status = super.TL_TX_completion_queue_enterCbF(trans);
    
    
    return status;    
  endfunction : TL_TX_completion_queue_enterCbF
  
  // ***************************************************************
  // Method : TL_TX_completion_queue_exitCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_TX_completion_queue_exitCbF(ref denaliPciePacket trans);
    int status;
    status = super.TL_TX_completion_queue_exitCbF(trans);
    
    
    return status;    
  endfunction : TL_TX_completion_queue_exitCbF
  
  // ***************************************************************
  // Method : TL_RX_completion_queue_enterCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_RX_completion_queue_enterCbF(ref denaliPciePacket trans);
    int status;
    status = super.TL_RX_completion_queue_enterCbF(trans);
    
    
    return status;    
  endfunction : TL_RX_completion_queue_enterCbF
  
  // ***************************************************************
  // Method : TL_RX_completion_queue_exitCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_RX_completion_queue_exitCbF(ref denaliPciePacket trans);
    int status;
    status = super.TL_RX_completion_queue_exitCbF(trans);
    
    
    return status;    
  endfunction : TL_RX_completion_queue_exitCbF
  
  // ***************************************************************
  // Method : TL_RX_packetCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_RX_packetCbF(ref denaliPciePacket trans);
    int status;
    status = super.TL_RX_packetCbF(trans);
    
    
    return status;    
  endfunction : TL_RX_packetCbF
  
  // ***************************************************************
  // Method : TL_TX_packetCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_TX_packetCbF(ref denaliPciePacket trans);
    int status;
	PciePacket_mb.try_put(trans);
	`ovm_info(get_name(), $sformatf("TL_TX_packetCbF called for %s",trans.sprintInfo()), OVM_HIGH)
	`ovm_info(get_name(), $sformatf("PCIe packet added to mb -> size (%0d)",PciePacket_mb.num()), OVM_HIGH)

    status = super.TL_TX_packetCbF(trans);
    
    
    return status;    
  endfunction : TL_TX_packetCbF
  
  // ***************************************************************
  // Method : DL_TX_queue_enterCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int DL_TX_queue_enterCbF(ref denaliPciePacket trans);
    int status;
    status = super.DL_TX_queue_enterCbF(trans);
    
    
    return status;    
  endfunction : DL_TX_queue_enterCbF
  
  // ***************************************************************
  // Method : DL_TX_queue_exitCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int DL_TX_queue_exitCbF(ref denaliPciePacket trans);
    int status;
    status = super.DL_TX_queue_exitCbF(trans);
    
    
    return status;    
  endfunction : DL_TX_queue_exitCbF
  
  // ***************************************************************
  // Method : DL_TX_retry_buffer_enterCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int DL_TX_retry_buffer_enterCbF(ref denaliPciePacket trans);
    int status;
    status = super.DL_TX_retry_buffer_enterCbF(trans);
    
    
    return status;    
  endfunction : DL_TX_retry_buffer_enterCbF
  
  // ***************************************************************
  // Method : DL_TX_retry_buffer_exitCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int DL_TX_retry_buffer_exitCbF(ref denaliPciePacket trans);
    int status;
    status = super.DL_TX_retry_buffer_exitCbF(trans);
    
    
    return status;    
  endfunction : DL_TX_retry_buffer_exitCbF
  
  // ***************************************************************
  // Method : DL_TX_retry_buffer_purgeCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int DL_TX_retry_buffer_purgeCbF(ref denaliPciePacket trans);
    int status;
    status = super.DL_TX_retry_buffer_purgeCbF(trans);
    
    
    return status;    
  endfunction : DL_TX_retry_buffer_purgeCbF
  
  // ***************************************************************
  // Method : DL_RX_queue_enterCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int DL_RX_queue_enterCbF(ref denaliPciePacket trans);
    int status;
    status = super.DL_RX_queue_enterCbF(trans);
    
    
    return status;    
  endfunction : DL_RX_queue_enterCbF
  
  // ***************************************************************
  // Method : DL_RX_queue_exitCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int DL_RX_queue_exitCbF(ref denaliPciePacket trans);
    int status;
    status = super.DL_RX_queue_exitCbF(trans);
    
    
    return status;    
  endfunction : DL_RX_queue_exitCbF
  
  // ***************************************************************
  // Method : PL_TX_start_packetCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int PL_TX_start_packetCbF(ref denaliPciePacket trans);
    int status;
    status = super.PL_TX_start_packetCbF(trans);
    
    
    return status;    
  endfunction : PL_TX_start_packetCbF
  
  // ***************************************************************
  // Method : PL_TX_end_packetCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int PL_TX_end_packetCbF(ref denaliPciePacket trans);
    int status;
    status = super.PL_TX_end_packetCbF(trans);
    
    
    return status;    
  endfunction : PL_TX_end_packetCbF
  
  // ***************************************************************
  // Method : PL_RX_start_packetCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int PL_RX_start_packetCbF(ref denaliPciePacket trans);
    int status;
    status = super.PL_RX_start_packetCbF(trans);
    
    
    return status;    
  endfunction : PL_RX_start_packetCbF
  
  // ***************************************************************
  // Method : PL_RX_end_packetCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int PL_RX_end_packetCbF(ref denaliPciePacket trans);
    int status;
    status = super.PL_RX_end_packetCbF(trans);
    
    
    return status;    
  endfunction : PL_RX_end_packetCbF
  
  // ***************************************************************
  // Method : TL_to_DLCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_to_DLCbF(ref denaliPciePacket trans);
    int status;
    status = super.TL_to_DLCbF(trans);
    
    
    return status;    
  endfunction : TL_to_DLCbF
  
  // ***************************************************************
  // Method : DL_to_PLCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int DL_to_PLCbF(ref denaliPciePacket trans);
    int status;
    status = super.DL_to_PLCbF(trans);
    
    
    return status;    
  endfunction : DL_to_PLCbF
  
  // ***************************************************************
  // Method : PL_to_DLCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int PL_to_DLCbF(ref denaliPciePacket trans);
    int status;
    status = super.PL_to_DLCbF(trans);
    
    
    return status;    
  endfunction : PL_to_DLCbF
  
  // ***************************************************************
  // Method : DL_to_TLCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int DL_to_TLCbF(ref denaliPciePacket trans);
    int status;
    status = super.DL_to_TLCbF(trans);
    
    
    return status;    
  endfunction : DL_to_TLCbF
  
  // ***************************************************************
  // Method : TX_trans_doneCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TX_trans_doneCbF(ref denaliPciePacket trans);
    int status;
    status = super.TX_trans_doneCbF(trans);
    
    
    return status;    
  endfunction : TX_trans_doneCbF
  
  // ***************************************************************
  // Method : RX_trans_doneCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int RX_trans_doneCbF(ref denaliPciePacket trans);
    int status;
    status = super.RX_trans_doneCbF(trans);
    
    
    return status;    
  endfunction : RX_trans_doneCbF
  
  // ***************************************************************
  // Method : TL_receive_queue_enterCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_receive_queue_enterCbF(ref denaliPciePacket trans);
    int status;
    status = super.TL_receive_queue_enterCbF(trans);
	//`ovm_info(get_name(), $sformatf("TL_receive_queue_enterCbF for %s",trans.sprintInfo()), OVM_LOW);
    
    
    return status;    
  endfunction : TL_receive_queue_enterCbF
  
  // ***************************************************************
  // Method : TL_receive_queue_exitCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_receive_queue_exitCbF(ref denaliPciePacket trans);
    int status;
    status = super.TL_receive_queue_exitCbF(trans);
	//`ovm_info(get_name(), $sformatf("TL_receive_queue_exitCbF for %s",trans.sprintInfo()), OVM_LOW);
    
    
    return status;    
  endfunction : TL_receive_queue_exitCbF
  
  // ***************************************************************
  // Method : TL_api_queue_enterCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_api_queue_enterCbF(ref denaliPciePacket trans);
    int status;
    status = super.TL_api_queue_enterCbF(trans);
    
    
    return status;    
  endfunction : TL_api_queue_enterCbF
  
  // ***************************************************************
  // Method : TL_api_queue_exitCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int TL_api_queue_exitCbF(ref denaliPciePacket trans);
    int status;
    status = super.TL_api_queue_exitCbF(trans);
    
    
    return status;    
  endfunction : TL_api_queue_exitCbF
  
  // ***************************************************************
  // Method : PL_TX_packetCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int PL_TX_packetCbF(ref denaliPciePacket trans);
    int status;
    status = super.PL_TX_packetCbF(trans);
    
    
    return status;    
  endfunction : PL_TX_packetCbF
  
  // ***************************************************************
  // Method : PL_RX_packetCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int PL_RX_packetCbF(ref denaliPciePacket trans);
    int status;
    status = super.PL_RX_packetCbF(trans);
    
    
    return status;    
  endfunction : PL_RX_packetCbF
  
  // ***************************************************************
  // Method : NVME_TX_packetCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int NVME_TX_packetCbF(ref denaliPciePacket trans);
    int status;
    status = super.NVME_TX_packetCbF(trans);
    
    
    return status;    
  endfunction : NVME_TX_packetCbF
  
  // ***************************************************************
  // Method : NVME_RX_packetCbF
  // Desc.  : A callback function overloading.
  //          
  // ***************************************************************
  virtual function int NVME_RX_packetCbF(ref denaliPciePacket trans);
    int status;
    status = super.NVME_RX_packetCbF(trans);
    
    
    return status;    
  endfunction : NVME_RX_packetCbF
  

endclass : userPcieInstance

`endif // CDN_PCIE_OVM_INSTANCE_SV
