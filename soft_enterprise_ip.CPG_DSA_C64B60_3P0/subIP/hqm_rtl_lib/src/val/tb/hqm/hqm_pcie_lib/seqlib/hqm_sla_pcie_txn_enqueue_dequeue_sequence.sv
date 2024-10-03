`ifndef HQM_SLA_PCIE_TXN_ENQ_DEQ_SEQUENCE_
`define HQM_SLA_PCIE_TXN_ENQ_DEQ_SEQUENCE_

class hqm_sla_pcie_txn_enqueue_dequeue_sequence extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_txn_enqueue_dequeue_sequence,sla_sequencer)

  hqm_sla_pcie_hcw_enqueue_sequence hcw_enq_seq ;
  hqm_sla_pcie_mem_seq	mem_wr_rd_seq; 
  hcw_transaction			hcw_trans_;
  rand logic [63:0]			_address;
  
  function new(string name = "hqm_sla_pcie_txn_enqueue_dequeue_sequence");
    super.new(name);
  endfunction

  virtual task body();

	byte_t        loc_data[$];
  

	sm.do_read(	.addr(32'h_80200000)
				,.length(4)
				,.data(loc_data)
				,.region("")
				,.backdoor(1)
				,.map_name("")	  
			  );

	  `ovm_info(get_name(),$sformatf("Data received from SM @ addr(0x%0x)",32'h_80200000),OVM_LOW);
	foreach(loc_data[i])
	  `ovm_info(get_name(),$sformatf("Data[%0d]=(%0d)",i,loc_data[i]),OVM_LOW);

	hcw_trans_ = hcw_transaction::type_id::create("hcw_trans_");

	hcw_trans_.randomize();

	hcw_trans_.rsvd0		  = '0;
	hcw_trans_.dsi_error	  = '0;
	hcw_trans_.cq_int_rearm	  = '0;
	hcw_trans_.no_inflcnt_dec = '0;
	hcw_trans_.dbg		= '0;
	hcw_trans_.cmp_id	= 'h_0;
	hcw_trans_.is_vf	= '0;
	hcw_trans_.ppid		= 'h_0; 
	hcw_trans_.is_ldb	= 'h_0; 
	hcw_trans_.is_pf	= '1;
	hcw_trans_.vf_num	= 'h_0;
	hcw_trans_.sai		= 'h_03;
	hcw_trans_.qe_valid = 'h_01;
	hcw_trans_.qe_orsp	= 'h_00;
	hcw_trans_.qe_uhl	= 'h_0;
	hcw_trans_.cq_pop	= 'h_0;
	hcw_trans_.meas		= 'h_0;
	hcw_trans_.lockid	= 'h_303;
	hcw_trans_.msgtype	= 0; 
	hcw_trans_.qpri		= 0;
	hcw_trans_.qtype	= QDIR; 
	hcw_trans_.qid		= 0; 
	hcw_trans_.idsi		= 'h_302; 
	hcw_trans_.iptr		= 'h_01234567;

	_address = 'h_123456;
	`ovm_create(hcw_enq_seq);
	hcw_enq_seq.hcw_trans=hcw_trans_;
	//hcw_enq_seq.enqueue_address=0;
    `ovm_send(hcw_enq_seq); 
	hcw_trans_.iptr		= 'h_abcdef;
	hcw_enq_seq.hcw_trans=hcw_trans_;
    `ovm_send(hcw_enq_seq); 
	hcw_trans_.cq_pop	= 'h_1;
	hcw_trans_.iptr		= 'h_0;
	hcw_enq_seq.hcw_trans=hcw_trans_;
    `ovm_send(hcw_enq_seq); 

	sm.do_read(	.addr(32'h_80200000)
				,.length(4)
				,.data(loc_data)
				,.region("")
				,.backdoor(1)
				,.map_name("")	  
			  );
	  `ovm_info(get_name(),$sformatf("Data received from SM @ addr(0x%0x)",32'h_80200000),OVM_LOW);
	foreach(loc_data[i])
	  `ovm_info(get_name(),$sformatf("Data[%0d]=(%0d)",i,loc_data[i]),OVM_LOW);

	sm.do_read(	.addr(32'h_80200010)
				,.length(4)
				,.data(loc_data)
				,.region("")
				,.backdoor(1)
				,.map_name("")	  
			  );
	  `ovm_info(get_name(),$sformatf("Data received from SM @ addr(0x%0x)",32'h_80200010),OVM_LOW);
	foreach(loc_data[i])
	  `ovm_info(get_name(),$sformatf("Data[%0d]=(%0d)",i,loc_data[i]),OVM_LOW);

    //`ovm_do_with(mem_wr_rd_seq,{data.size()==1;data[0]==32'h_0000_81ff;address==(32'h_80200000>>2); do_write==1'b0; do_read==1'b1;}); 
    //`ovm_do_with(mem_wr_rd_seq,{data.size()==1;data[0]==32'h_0000_81ff;address==(32'h_80200010>>2); do_write==1'b0; do_read==1'b1;}); 
  
  endtask

endclass

`endif
