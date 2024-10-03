// ----------------------------------------------------------------------------
// Class : cdnPcieOvmTLReadAfterWriteSeq
// This class extends the ovm_sequence and implements a TLP.
// ----------------------------------------------------------------------------
class MemWrPCie_seq extends cdnPcieOvmUserBaseSeq;

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
	`ovm_object_utils_begin(MemWrPCie_seq)
		`ovm_field_object(wrTlp, OVM_ALL_ON)
		`ovm_field_object(rdTlp, OVM_ALL_ON)
	`ovm_object_utils_end
  
	`ovm_declare_p_sequencer(cdnPcieOvmUserSequencer)

	// ---------------------------------------------------------------
	// Method : new
	// Desc.  : Call the constructor of the parent class.
	// ---------------------------------------------------------------
	function new(string name = "MemWrPCie_seq");
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
                        //wrTlp.setIsPoisoned(1'h_1);  // added to check the posion memory writes
			//wrTlp.setLength(data_.size()/4);
                        wrTlp.setLength(1);
                        wrTlp.setLastBe(4'h0);
 
			//if(data_.size()<=4)
			  //wrTlp.setLastBe(4'h0);

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

	  `ovm_info(get_name(), $sformatf("Done sequence"), OVM_LOW)
	endtask : body
endclass : MemWrPCie_seq


