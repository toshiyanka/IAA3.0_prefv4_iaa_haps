// -------------------------------------------------------------------------------
// Class : cdnPcieOvmUserBaseSeq
// This class extends the ovm_sequence and should act base for all other sequences
// -------------------------------------------------------------------------------

//import hqm_rndcfg_pkg::*;
//typedef class event_data;

class cdnPcieOvmUserBaseSeq extends ovm_sequence #(denaliPciePacket);
//class cdnPcieOvmUserBaseSeq extends cdnPcieOvmSequence;

	//***********************************
	cdnPcieOvmUserAgent 	activeAgent;
	denaliPcieConfig 		srcCfg;
	denaliPcieConfig 		dstCfg;
	cdnPcieOvmUserSequencer mySequencer;
	cdnPcieOvmUserMemInstance 	memInst;
	denaliPcieUserData User_Data;

	denaliPcieTlpIdInfo     tlpReqId;
	denaliPcieTlpIdInfo     tlpCplId[`MAX_NO_OF_VFS+1];

	rand logic [31:0]	mask_;
	rand logic [7:0]	pcie_func_no;
	rand bit			is_ral;
	rand bit	[8:0]	exp_err;
	bit [7:0]		  func_base;
    bit               hqm_is_reg_ep_arg;
	sla_ral_env           ral;
    
    // hqm_sys_rndcfg     i_rndcfg;
    //hqm_pcie_tb_cfg    i_hqm_cfg;
    hqm_tb_cfg    i_hqm_cfg;
    ovm_event_pool     event_pool;
    ovm_event          schedular_ev;
    ovm_event          done_ev;
    protected string   pool_id;

	constraint default_func_no  {
		soft pcie_func_no == 0;
		soft mask_		  == 0;
		soft is_ral		  == 0;
		soft exp_err		  == 0;
	}


	//***********************************
	static bit	 [7:0]    pcie_tag=0;
	//static bit	 [7:0]    pcie_tag[17];
	static bit			  pcie_tag_init = 0;

	`ovm_object_utils_begin(cdnPcieOvmUserBaseSeq)
		`ovm_field_object(activeAgent, OVM_ALL_ON)
		`ovm_field_object(mySequencer, OVM_ALL_ON)
		`ovm_field_object(memInst, OVM_ALL_ON)
	`ovm_object_utils_end
	
	`ovm_declare_p_sequencer(cdnPcieOvmUserSequencer)

	function new(string name = "cdnPcieOvmUserBaseSeq");
		sla_ral_reg       my_reg;
		sla_ral_data_t    ral_data;
		
		super.new(name);
		`sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

        hqm_is_reg_ep_arg = '0; $value$plusargs("hqm_is_reg_ep=%d",hqm_is_reg_ep_arg);

        if(hqm_is_reg_ep_arg) begin func_base = 8'h00; end       // EP Base function number
        else                  begin 
                                    func_base = 8'h07;           // RCIEP Base function number
                                    $value$plusargs("hqm_func_base_strap=%d",func_base);
        end

	    tlpReqId = new();
		foreach(tlpCplId[i])  begin
			tlpCplId[i] = new();  
			tlpCplId[i].setBusNumber(1); //Bus Number is 1 as RCIEP isn't supported by Denali, otherwise it would be 0.//
			tlpCplId[i].setDeviceNumber(0);
			tlpCplId[i].setFunctionNumber(0);
		end

		/********* Setting req and completer id for this PCIe configuration *********/
        tlpReqId.setBusNumber(0);
        tlpReqId.setFunctionNumber(0);
        tlpReqId.setDeviceNumber(0);
        tlpCplId[0].setBusNumber(1);
        tlpCplId[0].setFunctionNumber(0);
        tlpCplId[0].setDeviceNumber(0);
        event_pool      = event_pool.get_global_pool();
        done_ev         = event_pool.get("done_ev");

	   //if(!$cast(i_rndcfg, hqm_sys_rndcfg::get()))
       //     `ovm_error(get_name(), "Failed to get hqm randconfig handle");

	   if(!$cast(i_hqm_cfg, hqm_tb_cfg::get()))
            `ovm_error(get_name(), "Failed to get hqm_cfg handle");

	endfunction : new

	function set_pool_id(string pid);
        pool_id = pid;
    endfunction: set_pool_id;

  task wait_for_schedular();
/* NS: rdncfg fix
    event_data sel_thread;

     string self = get_name(); 

     schedular_ev    = event_pool.get("schedular_ev");

     if(!$cast(sel_thread, schedular_ev.get_trigger_data))
         `ovm_error(get_name(), "Failed to cast trigger data");

     if((sel_thread != null) && (self== sel_thread.seq_name))begin
         schedular_ev.reset();
         done_ev.trigger();
     end

      while(1) begin
         schedular_ev.wait_on();
         if(!$cast(sel_thread, schedular_ev.get_trigger_data))
             `ovm_error(get_name(), "Failed to cast trigger data");
          if((sel_thread != null) && (self== sel_thread.seq_name))
              break;
         schedular_ev.wait_off();
      end
      `ovm_info(get_name(),$psprintf("Received Trigger <%s> Data<%s>", self, sel_thread.seq_name),OVM_LOW)
*/
  endtask: wait_for_schedular;



	virtual task pre_do(bit is_item);

		if ( !$cast(mySequencer, get_sequencer() ) ) `ovm_error("BASE_SEQ", "mySequencer is of wrong type");
		if ( !$cast(activeAgent, mySequencer.pAgent) ) `ovm_error("SEQ_LIB", "activeAgent is of wrong type");
		if ( !$cast(memInst, activeAgent.regInst) ) `ovm_error("BASE_SEQ", "Failed to cast memInst");

		wait_for_RC_active();
		`ovm_info(get_name(),"waiting some time",OVM_LOW)
		wait_for_RC_active();
	endtask : pre_do

	task wait_for_RC_active();
		reg [31:0]	device_state;

		if ( !$cast(mySequencer, get_sequencer() ) ) `ovm_error("BASE_SEQ", "mySequencer is of wrong type");
		if ( !$cast(activeAgent, mySequencer.pAgent) ) `ovm_error("SEQ_LIB", "activeAgent is of wrong type");
		if ( !$cast(memInst, activeAgent.regInst) ) `ovm_error("BASE_SEQ", "Failed to cast memInst");

		device_state = memInst.readReg(PCIE_REG_DEN_DEV_ST);
		if ( denaliPcieDeviceStateT'(device_state[3:0]) != PCIE_DEVICE_STATE_Active)  begin 
			`ovm_info("BASE_SEQ", "Device is not Active", OVM_LOW)
			`ovm_info("BASE_SEQ", "Wait for RC Active State", OVM_LOW);
			memInst.wait_device_active();
		end
		else
			`ovm_info("BASE_SEQ", "Device is already Active", OVM_LOW)

	endtask : wait_for_RC_active

	virtual function void post_do(ovm_sequence_item this_item);
		pcie_tag++;
		//pcie_tag[pcie_func_no]++;
	endfunction: post_do

endclass : cdnPcieOvmUserBaseSeq

// ----------------------------------------------------------------------------
// Class : cdnPcieOvmTLReadAfterWriteSeq
// This class extends the ovm_sequence and implements a TLP.
// ----------------------------------------------------------------------------
class cdnPcieOvmUserTLMemReadAfterWriteSeq extends cdnPcieOvmUserBaseSeq;

	// ---------------------------------------------------------------
	// The read\write sequence items (rdTlp\wrTlp) that will be randomized and
	// passed to the driver.
	// ---------------------------------------------------------------
	denaliPcieTlpMemPacket rdTlp;
	denaliPcieTlpMemPacket wrTlp;
	rand logic [7:0] data_ [] ;
	rand logic [63:0] addr_ ;
	rand bit do_read_ ;
	rand bit do_write_ ;
	rand bit is_compare ;
	rand bit zero_length_read ;

	constraint soft_mem_constraints	{
		soft is_compare		  == 0;
		soft zero_length_read == 0;
		soft do_read_		  == 1;
		soft do_write_		  == 0;
	}
	// ---------------------------------------------------------------
	// Use the OVM Sequence macro for this class.
	// ---------------------------------------------------------------
	`ovm_object_utils_begin(cdnPcieOvmUserTLMemReadAfterWriteSeq)
		`ovm_field_object(wrTlp, OVM_ALL_ON)
		`ovm_field_object(rdTlp, OVM_ALL_ON)
	`ovm_object_utils_end
  
	`ovm_declare_p_sequencer(cdnPcieOvmUserSequencer)

	// ---------------------------------------------------------------
	// Method : new
	// Desc.  : Call the constructor of the parent class.
	// ---------------------------------------------------------------
	function new(string name = "cdnPcieOvmUserTLMemReadAfterWriteSeq");
		super.new(name);
		rdTlp=new();
		wrTlp=new();
	endfunction : new
	
	// ----------------------------------------------------------------------------
	// Method : pre_do
	// Desc.  : Set the source and destination configuration spaces, and the packet
	//			and TLP types. Also enable the Easy Mode constraint.
	// ----------------------------------------------------------------------------
	virtual task pre_do(bit is_item);
		cdnPcieOvmUserSequencer mySequencer;
		logic[7:0] payload_ [];
		
		if (rdTlp) begin
			if ($cast(mySequencer,get_sequencer())) begin
				rdTlp.srcConfig = mySequencer.srcConfig;
				rdTlp.dstConfig = mySequencer.dstConfig;
			end

			rdTlp.pktType = DENALI_PCIE__Tlp;
			rdTlp.setLength(data_.size()/4);
			if(data_.size()<=4)
			  rdTlp.setLastBe(4'h0);

			if(zero_length_read)
			  rdTlp.setFirstBe(4'h0);

			if(|addr_[63:32])	begin
			  rdTlp.tlpType = DENALI_PCIE_TL_MRd_64;
			  rdTlp.setAddressHigh(addr_[63:32]) ;
			end
			else  begin
			  rdTlp.tlpType = DENALI_PCIE_TL_MRd_32;
			  rdTlp.setAddressHigh(32'h_0) ;
			end

			rdTlp.setAddress(addr_[31:0]) ;
			//rdTlp.setModelGensTag(0);
			//rdTlp.setTransactionIdTag(pcie_tag);
			rdTlp.easyModeTlpConstraint.constraint_mode(1);

		  if(is_compare && rdTlp.getLength()!= 1) begin
			`ovm_error(get_name(), $sformatf("Cannot compare read value if length(%0d) > 1",rdTlp.getLength()))
		  end else if(is_compare && rdTlp.getLength()== 1)	begin
			`ovm_info(get_name(), $sformatf("Comparing read value for length(%0d) == 1",rdTlp.getLength()),OVM_LOW)
			if(|mask_) begin
			  payload_[3]		= data_[3]	& mask_[07:00];
			  payload_[2]		= data_[2]	& mask_[15:08];
			  payload_[1]		= data_[1]	& mask_[23:16];
			  payload_[0]		= data_[0]	& mask_[31:24];
			end else  begin
			  payload_[3]		= data_[3];
			  payload_[2]		= data_[2];
			  payload_[1]		= data_[1];
			  payload_[0]		= data_[0];
			end

			  rdTlp.setPayloadExpected(payload_);
		  end

		end 
		if (wrTlp) begin
			if ($cast(mySequencer,get_sequencer())) begin
				wrTlp.srcConfig = mySequencer.srcConfig;
				wrTlp.dstConfig = mySequencer.dstConfig;
			end

			wrTlp.pktType = DENALI_PCIE__Tlp;
			wrTlp.setPayload(data_);
			wrTlp.setLength(data_.size()/4);
			if(data_.size()<=4)
			  wrTlp.setLastBe(4'h0);

			if(|addr_[63:32])	begin
			  wrTlp.tlpType = DENALI_PCIE_TL_MWr_64;
			  wrTlp.setAddressHigh(addr_[63:32]) ;
			end
			else  begin
			  wrTlp.tlpType = DENALI_PCIE_TL_MWr_32;
			  wrTlp.setAddressHigh(32'h_0) ;
			end

			wrTlp.setAddress(addr_[31:0]) ;

			wrTlp.easyModeTlpConstraint.constraint_mode(1);
		end

		User_Data = new();	User_Data.intData = exp_err;
		rdTlp.setUserData(User_Data);
		wrTlp.setUserData(User_Data);

	endtask : pre_do

  // ---------------------------------------------------------------
  // Method : body
  // Desc.  : Perform Memory Read After Memory Write
  // ---------------------------------------------------------------
	virtual task body();
		`ovm_info(get_name(), $sformatf("Starting sequence with do_write=(%0d) and do_read(%0d)",do_write_,do_read_), OVM_LOW)
			`ovm_info(get_name(), "Wait for active RC", OVM_LOW);
			wait_for_RC_active();
			if(do_write_)
				`ovm_send(wrTlp)
			
			if(do_read_)
				`ovm_send(rdTlp)
			else
				  pcie_tag--;

	  `ovm_info(get_name(), $sformatf("Done sequence"), OVM_LOW)
	endtask : body
endclass : cdnPcieOvmUserTLMemReadAfterWriteSeq

// ----------------------------------------------------------------------------
// Class : cdnPcieOvmUser_ECRCerrorInj
//
// This sequence will send a TLP from the BFM and will damage it's ECRC.
// ----------------------------------------------------------------------------
class cdnPcieOvmUser_ECRCerrorInj extends cdnPcieOvmUserBaseSeq;

	rand denaliPcieTlpMemPacket pkt;
  	`ovm_object_utils_begin(cdnPcieOvmUser_ECRCerrorInj)
    	`ovm_field_object(pkt, OVM_ALL_ON)
  	`ovm_object_utils_end
	int unsigned seqNum;
  	`ovm_declare_p_sequencer(cdnPcieOvmUserSequencer)

	function new(string name = "cdnPcieOvmUser_ECRCerrorInj");
		super.new(name);
	endfunction : new

	virtual task pre_do(bit is_item);
		cdnPcieOvmUserSequencer mySequencer;
		
		pkt.pktType = DENALI_PCIE__Tlp;
		pkt.tlpType = DENALI_PCIE_TL_MRd_32;
		pkt.easyModeTlpConstraint.constraint_mode(1);
		pkt.errInjects = new[3];
		// To ease BFM checkings on the Tx packet.
		pkt.errInjects[2] = PCIE_EI_RELAX_CHK;
		if ($cast(mySequencer,get_sequencer())) begin
			pkt.srcConfig = mySequencer.srcConfig;
			pkt.dstConfig = mySequencer.dstConfig;
		end
	endtask : pre_do

	virtual task body();
		`ovm_info(get_name(), $sformatf("Starting sequence"), OVM_LOW)
		`ovm_info(get_name(),"Starting Sequence cdnPcieOvmUser_ECRCerrorInj",OVM_LOW);
		wait_for_RC_active();
		
		// Send a pkt with bad-ECRC
		`ovm_do_with(pkt, {pkt.errInjects[0] == PCIE_EI_TLP_ENABLE_ECRC;
						   pkt.errInjects[1] == PCIE_EI_TLP_ECRC;
						  } );
		
		`ovm_info(get_name(),"Finished Sequence cdnPcieOvmUser_ECRCerrorInj",OVM_LOW);
	endtask : body

endclass : cdnPcieOvmUser_ECRCerrorInj

// ----------------------------------------------------------------------------
// Class : cdnPcieOvmUser_FundReset
//
// This sequence implemets Fundamental Reset
// ----------------------------------------------------------------------------
//class cdnPcieOvmUser_FundReset extends cdnPcieOvmUserBaseSeq;
//
//	cdnPcieOvmUserTLMemReadAfterWriteSeq memSeq;
//	int unsigned delay;
//	rand denaliPcieTlpMemPacket wrTlp;
//
//	`ovm_object_utils_begin(cdnPcieOvmUser_FundReset)
//		`ovm_field_object(wrTlp, OVM_ALL_ON)
//    	`ovm_field_int(delay, OVM_ALL_ON)
//  	`ovm_object_utils_end
//  
//  	`ovm_declare_p_sequencer(cdnPcieOvmUserSequencer)
//
//	function new(string name = "cdnPcieOvmUser_FundReset");
//		super.new(name);
//	endfunction : new
//
//	task do_fundamental_reset();
//		`ovm_info(get_name(),"Starting to Assert PERST_ Fundamental Reset",OVM_LOW);
//		tb.PERST_n = 0;
//		#500
//		tb.PERST_n = 1;
//		`ovm_info(get_name(),"Finished to Assert PERST_ Fundamental Reset",OVM_LOW);
//	endtask : do_fundamental_reset
//
//	virtual task body();
//		`ovm_info(get_name(),"Starting Sequence cdnPcieOvmUser_FundReset",OVM_LOW);
//		fork 
//			begin
//				`ovm_do(memSeq)
//			end
//			begin
//				// Wait a random time before pulling reset
//				assert(randomize(delay) with {delay > 10; delay < 50;} );
//				`ovm_info(get_name(), $sformatf("Wait %d before initiating reset..",delay), OVM_LOW);
//				#delay;
//				do_fundamental_reset();
//				`ovm_info(get_name(),"Booting from the beginning..", OVM_LOW);
//				`ovm_do(memSeq)
//			end
//		join_any
//		`ovm_info(get_name(),"Finished Sequence cdnPcieOvmUser_FundReset", OVM_LOW);
//	endtask : body
//
//endclass : cdnPcieOvmUser_FundReset

// ----------------------------------------------------------------------------
// Class : cdnPcieOvmUser_TxVDM
//
// This sequence implemets Vendor Defined Message
// ----------------------------------------------------------------------------

class denaliPcieOvmVDMSequence extends cdnPcieOvmUserBaseSeq;

	denaliPcieTlpMsgPacket Msg;

    rand integer   regAddr;
    rand integer   sizeInBytes;

    `ovm_object_utils_begin(denaliPcieOvmVDMSequence)
       `ovm_field_int(regAddr, OVM_ALL_ON)
       `ovm_field_int(sizeInBytes, OVM_ALL_ON)
    `ovm_object_utils_end

  	`ovm_declare_p_sequencer(cdnPcieOvmUserSequencer)

    function new(string name = "denaliPcieOvmVDMSequence");
        super.new(name);
    endfunction : new

    virtual task pre_do(bit is_item);

        Msg.srcConfig = p_sequencer.srcConfig;
        Msg.dstConfig = p_sequencer.dstConfig;

        // Set fields and enable constraints in the packet.
        Msg.pktType = DENALI_PCIE__Tlp;
        Msg.tlpType = DENALI_PCIE_TL_MsgD;
        Msg.messageType = DENALI_PCIE_TL_MSG_VD_Type0;
        Msg.vdMsgRouting = DENALI_PCIE_TL_VDMSG_ROUT_local_terminate;
        Msg.length = 0;
        Msg.easyModeTlpConstraint.constraint_mode(1);

    endtask : pre_do

    virtual task body();

		`ovm_info(get_name(), $sformatf("Starting sequence"), OVM_LOW)
        wait_for_RC_active();

		`ovm_info(get_name(),"Send a Vendor Defined Message from BFM", OVM_LOW);
        `ovm_do(Msg)
		Msg.print();
		`ovm_info(get_name(), $sformatf("Starting sequence"), OVM_LOW)
    endtask : body
endclass : denaliPcieOvmVDMSequence
