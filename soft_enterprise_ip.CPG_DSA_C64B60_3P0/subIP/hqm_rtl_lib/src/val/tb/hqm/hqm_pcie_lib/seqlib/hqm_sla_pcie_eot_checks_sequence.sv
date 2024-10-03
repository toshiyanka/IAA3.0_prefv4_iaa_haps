`ifndef HQM_SLA_PCIE_EOT_CHECKS_SEQUENCE_
`define HQM_SLA_PCIE_EOT_CHECKS_SEQUENCE_

class hqm_sla_pcie_eot_checks_sequence extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_eot_checks_sequence,sla_sequencer)

  rand logic [4:0]	func_no;
  rand bit test_induced_dpe;
  rand bit test_induced_sse;
  rand bit test_induced_rma;
  rand bit test_induced_rta;
  rand bit test_induced_sta;
  rand bit test_induced_mdpe;
  rand bit test_induced_intsts;
  rand bit test_induced_urd;
  rand bit test_induced_fed;
  rand bit test_induced_ned;
  rand bit test_induced_ced;
  rand bit test_induced_ieunc;
  rand bit test_induced_ur;
  rand bit test_induced_ecrcc;
  rand bit test_induced_mtlp;
  rand bit test_induced_ec;
  rand bit test_induced_ca;
  rand bit test_induced_ct;
  rand bit test_induced_ptlpr;
  rand bit test_induced_iecor;
  rand bit test_induced_anfes;
  rand bit test_induced_tlppflogp;
  rand bit en_H_FP_check;
  rand bit [127:0] exp_header_log;
  rand bit [4:0] test_induced_fep; 
  rand bit [127:0] exp_tlp_prefix_log;
  rand bit skip_status_clear;
 
  constraint soft_qid_pri_type_c	{
	soft func_no	  == 0;
  }

  constraint soft_skip_status_clear_c	{
	soft skip_status_clear	  == 0;
  }

  constraint soft_constraint_err {
	soft test_induced_dpe==0;
	soft test_induced_sse==0;
	soft test_induced_rma==0;
	soft test_induced_rta==0;
	soft test_induced_sta==0;
	soft test_induced_mdpe==0;
	soft test_induced_intsts==0;
	soft test_induced_urd==0;
	soft test_induced_fed==0;
	soft test_induced_ned==0;
	soft test_induced_ced==0;
	soft test_induced_ieunc==0;
	soft test_induced_ur==0;
	soft test_induced_ecrcc==0;
	soft test_induced_mtlp==0;
	soft test_induced_ec==0;
	soft test_induced_ca==0;
	soft test_induced_ct==0;
	soft test_induced_ptlpr==0;
	soft test_induced_iecor==0;
	soft test_induced_anfes==0;
	soft test_induced_tlppflogp==0;
	soft en_H_FP_check==0;
	soft exp_header_log==128'b0;
	soft test_induced_fep==5'b11111;
	soft exp_tlp_prefix_log==128'b0;
  }

  function new(string name = "hqm_sla_pcie_eot_checks_sequence");
    super.new(name);
  endfunction

  virtual task body();
	bit	  rslt;
	bit	  use_plusargs;
    bit [4:0] first_pointer;
    bit [4:0] exp_first_pointer;
    bit [127:0] header_log;
    logic [4:0]  eot_vf_num;
	logic [31:0] compare_data, compare_mask ;
    logic [31:0] exp_header_log_0=0, exp_header_log_1=0, exp_header_log_2=0, exp_header_log_3=0;

     bit obs_tlppflogp;
     bit [127:0] tlp_prefix_log;
     bit [31:0] exp_tlp_prefix_log_0=0,exp_tlp_prefix_log_1=0,exp_tlp_prefix_log_2=0,exp_tlp_prefix_log_3=0;
     sla_ral_data_t rd_val;
     eot_vf_num = 0;  
     
     if($test$plusargs("expect_completion_timeout")) primary_id=iosf_sb_sla_pkg::get_src_type(); 
     `ovm_info(get_full_name(),$sformatf("Setting primary_id as %s",primary_id),OVM_LOW)

     if($test$plusargs("eot_vf")) begin $value$plusargs("eot_vf=%0d",eot_vf_num); eot_vf_num++; end 

     use_plusargs = (func_no==0) ? $test$plusargs($sformatf("eot_pf")) : ( (func_no == eot_vf_num) || $test$plusargs($sformatf("pcie_eot_vf%0d",func_no-1)) );

	`ovm_info(get_name(), $sformatf("Starting EOT status reg check sequence for PCIE func #(%0d) and use_plusargs (%0d)",func_no,use_plusargs),OVM_LOW)

if(use_plusargs)	begin
	if($test$plusargs("pcie_dpe") ) test_induced_dpe=1;
	if($test$plusargs("pcie_sse") ) test_induced_sse=1;
	if($test$plusargs("pcie_rma") ) test_induced_rma=1;
	if($test$plusargs("pcie_rta") ) test_induced_rta=1;
	if($test$plusargs("pcie_sta") ) test_induced_sta=1;
	if($test$plusargs("pcie_mdpe") ) test_induced_mdpe=1;
	if($test$plusargs("pcie_intsts") ) test_induced_intsts=1;
	if($test$plusargs("pcie_urd") ) test_induced_urd=1;
	if($test$plusargs("pcie_fed") ) test_induced_fed=1;
	if($test$plusargs("pcie_ned") ) test_induced_ned=1;
	if($test$plusargs("pcie_ced") ) test_induced_ced=1;
	if($test$plusargs("pcie_ieunc") ) test_induced_ieunc=1;
	if($test$plusargs("pcie_ur_unc")	  ) test_induced_ur=1;
	if($test$plusargs("pcie_unc_ecrc") ) test_induced_ecrcc=1;
	if($test$plusargs("pcie_mtlp")  ) test_induced_mtlp=1;
	if($test$plusargs("pcie_ec")	  ) test_induced_ec=1;
	if($test$plusargs("pcie_ca")	  ) test_induced_ca=1;
	if($test$plusargs("pcie_ct")	  ) test_induced_ct=1;
	if($test$plusargs("pcie_ptlpr") ) test_induced_ptlpr=1;
	if($test$plusargs("pcie_iecor")	  ) test_induced_iecor=1;
	if($test$plusargs("pcie_anfes")	  ) test_induced_anfes=1;
	if($test$plusargs("pcie_tlppflogp")	  ) test_induced_tlppflogp=1;
	if($test$plusargs("pcie_en_H_FP_check")	  ) en_H_FP_check=1;
	if(!$value$plusargs("pcie_tfep=%0d",test_induced_fep)) test_induced_fep = 5'b11111;
	exp_header_log_0 = get_plusarg_val("pcie_exp_header_log_0",0);  
	exp_header_log_1 = get_plusarg_val("pcie_exp_header_log_1",0); 
	exp_header_log_2 = get_plusarg_val("pcie_exp_header_log_2",0); 
	exp_header_log_3 = get_plusarg_val("pcie_exp_header_log_3",0); 
    exp_header_log  = {exp_header_log_3, exp_header_log_2, exp_header_log_1, exp_header_log_0};

	exp_tlp_prefix_log_0 = get_plusarg_val("pcie_exp_tlp_prefix_log_0", 0);  
	exp_tlp_prefix_log_1 = get_plusarg_val("pcie_exp_tlp_prefix_log_1", 0); 
	exp_tlp_prefix_log_2 = get_plusarg_val("pcie_exp_tlp_prefix_log_2", 0); 
	exp_tlp_prefix_log_3 = get_plusarg_val("pcie_exp_tlp_prefix_log_3", 0); 
    exp_tlp_prefix_log  = {exp_tlp_prefix_log_3, exp_tlp_prefix_log_2, exp_tlp_prefix_log_1, exp_tlp_prefix_log_0};
    
end

	`ovm_info(get_name(), $sformatf( "EOT checks as : test_induced_dpe = %0d, test_induced_sse = %0d, test_induced_rma = %0d, test_induced_rta = %0d, test_induced_sta = %0d, test_induced_mdpe = %0d, test_induced_intsts = %0d, test_induced_urd = %0d, test_induced_fed = %0d, test_induced_ned = %0d, test_induced_ced = %0d, test_induced_ieunc = %0d, test_induced_ur = %0d, test_induced_ecrcc = %0d, test_induced_mtlp = %0d, test_induced_ec = %0d, test_induced_ca = %0d, test_induced_ct = %0d, test_induced_ptlpr = %0d, test_induced_iecor = %0d, test_induced_anfes = %0d, en_H_FP_check = %0h, exp_header_log = %0h, test_induced_fep = %h, exp_tlp_prefix_log = %0h, test_induced_tlppflogp = %0h, skip_status_clear=%h",test_induced_dpe, test_induced_sse, test_induced_rma, test_induced_rta, test_induced_sta, test_induced_mdpe, test_induced_intsts, test_induced_urd, test_induced_fed, test_induced_ned, test_induced_ced, test_induced_ieunc, test_induced_ur, test_induced_ecrcc, test_induced_mtlp, test_induced_ec, test_induced_ca, test_induced_ct, test_induced_ptlpr, test_induced_iecor,test_induced_anfes, en_H_FP_check, exp_header_log, test_induced_fep, exp_tlp_prefix_log, test_induced_tlppflogp, skip_status_clear), OVM_LOW); 

	if(func_no==0)  begin
			compare_data = {
							(test_induced_dpe),
							(test_induced_sse),
							(test_induced_rma),
							(test_induced_rta),
							(test_induced_sta),
							2'h_0,	/*NA for PCIe*/
							(test_induced_mdpe),
							3'h_0,	/*NA for PCIe*/
							1'h_1,  /*Hardwired to 1*/
							(test_induced_intsts),
							3'h_0 /*RSVD*/
							};
			compare_mask = {
							5'h_1f,
							2'h_0,	/*NA for PCIe*/
							1'b_1,
							3'h_0,	/*NA for PCIe*/
							1'h_1,  /*Hardwired to 1*/
							1'b_1,
							3'h_0 /*RSVD*/
							};
		
			read_compare(pf_cfg_regs.DEVICE_STATUS,compare_data,compare_mask,rslt);
            if (!skip_status_clear) begin
		    	pf_cfg_regs.DEVICE_STATUS.write(status,compare_data,primary_id,this,.sai(legal_sai));
		    	read_compare(pf_cfg_regs.DEVICE_STATUS,32'h_10,compare_mask,rslt);
            end
		
			compare_data = {
							12'h_0,
							(test_induced_urd),
							(test_induced_fed),
							(test_induced_ned),
							(test_induced_ced)
							};
			compare_mask = {
							16'h_ffff
							};
                        `ovm_info(get_name(), $sformatf( "EOT checks pf_cfg_regs.PCIE_CAP_DEVICE_STATUS :compare_data=0x%0x compare_mask=0x%0x - test_induced_urd=%0d, test_induced_fed=%0d test_induced_ned=%0d test_induced_ced=%0d", compare_data, compare_mask, test_induced_urd,test_induced_fed,test_induced_ned,test_induced_ced), OVM_LOW); 
		
			read_compare(pf_cfg_regs.PCIE_CAP_DEVICE_STATUS,compare_data,compare_mask,rslt);
            if (!skip_status_clear) begin
		    	pf_cfg_regs.PCIE_CAP_DEVICE_STATUS.write(status,compare_data,primary_id,this,.sai(legal_sai));
		    	read_compare(pf_cfg_regs.PCIE_CAP_DEVICE_STATUS,32'h_0,compare_mask,rslt);
	        end
			
			compare_data = 32'h_0;
			compare_mask = 32'h_ffff_ffff;
            send_tlp(get_tlp( (ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL_2) + 'h_4), Iosf::CfgRd0), .compare(1), .comp_val(32'h_0));
	
			compare_data = 32'h_0;
			compare_mask = 32'h_ffff_fff4;
			read_compare(pf_cfg_regs.PM_CAP_CONTROL_STATUS,compare_data,compare_mask,rslt);
			
			compare_data = {
							9'h_0,	/*RSVD*/
							(test_induced_ieunc),
							1'b_0, /*RSVD: NA for IOSF*/
							(test_induced_ur),
							(test_induced_ecrcc),
							(test_induced_mtlp),
							1'b_0, /*RSVD: NA for IOSF*/
							(test_induced_ec),
							(test_induced_ca),
							(test_induced_ct),
							1'b_0, /*fcpes not supp*/
							(test_induced_ptlpr),
							6'h_0, /*RSVD*/
							6'b_0 /*RSVD or NA for IOSF*/
							};
			compare_mask = 32'h_ffff_ffff;
			read_compare(pf_cfg_regs.AER_CAP_UNCORR_ERR_STATUS,compare_data,compare_mask,rslt);
      if (test_induced_fep == 5'b11111) begin
	       pf_cfg_regs.AER_CAP_UNCORR_ERR_STATUS.read(status,rd_val,primary_id,this,.sai(legal_sai));
         exp_first_pointer = $clog2(rd_val);
      end
      else if (test_induced_fep == 5'b11110) begin  exp_first_pointer = 0; end
      else begin
         exp_first_pointer = test_induced_fep;
      end 

	  pf_cfg_regs.AER_CAP_CONTROL.read(status,rd_val,primary_id,this,.sai(legal_sai));
      first_pointer = rd_val[4:0]; 
      obs_tlppflogp = rd_val[11]; 

      if (first_pointer != exp_first_pointer)
         `ovm_error(get_name(), $psprintf("Register check failed for reg AER_CAP_CONTROL.FP FP = %h, Ex_FP = %h",first_pointer,exp_first_pointer))

      if (!skip_status_clear) begin
   	      pf_cfg_regs.AER_CAP_UNCORR_ERR_STATUS.write(status,compare_data,primary_id,this,.sai(legal_sai));
	      read_compare(pf_cfg_regs.AER_CAP_UNCORR_ERR_STATUS,32'h_0,compare_mask,rslt);
      end 
	
      if (en_H_FP_check) begin 
          if (obs_tlppflogp != test_induced_tlppflogp)
              `ovm_error(get_name(), $psprintf("Register check failed for reg AER_CAP_CONTROL.TLPPFLOGP observed_tlppflogp = %0h, expected_tlppflogp = %h", obs_tlppflogp, test_induced_tlppflogp))
	        pf_cfg_regs.AER_CAP_HEADER_LOG_0.read(status,rd_val,primary_id,this,.sai(legal_sai));
          header_log[31:0] = rd_val;
	        pf_cfg_regs.AER_CAP_HEADER_LOG_1.read(status,rd_val,primary_id,this,.sai(legal_sai));
          header_log[63:32] = rd_val;
	        pf_cfg_regs.AER_CAP_HEADER_LOG_2.read(status,rd_val,primary_id,this,.sai(legal_sai));
          header_log[95:64] = rd_val;
	        pf_cfg_regs.AER_CAP_HEADER_LOG_3.read(status,rd_val,primary_id,this,.sai(legal_sai));
          header_log[127:96] = rd_val;
          if (header_log != exp_header_log)
              `ovm_error(get_name(), $psprintf("Register check failed for reg AER_CAP_HEADER_LOG HL = %h, Ex_HL = %h", header_log, exp_header_log))/*refer HSD 1406509041*/ 

          if (obs_tlppflogp) begin
	          pf_cfg_regs.AER_CAP_TLP_PREFIX_LOG_0.read(status,rd_val,primary_id,this,.sai(legal_sai));
            tlp_prefix_log[31:0] = rd_val;
	          pf_cfg_regs.AER_CAP_TLP_PREFIX_LOG_1.read(status,rd_val,primary_id,this,.sai(legal_sai));
            tlp_prefix_log[63:32] = rd_val;
	          pf_cfg_regs.AER_CAP_TLP_PREFIX_LOG_2.read(status,rd_val,primary_id,this,.sai(legal_sai));
            tlp_prefix_log[95:64] = rd_val;
	          pf_cfg_regs.AER_CAP_TLP_PREFIX_LOG_3.read(status,rd_val,primary_id,this,.sai(legal_sai));
            tlp_prefix_log[127:96] = rd_val;
            if (tlp_prefix_log !=  exp_tlp_prefix_log)
                `ovm_error(get_name(), $psprintf("Register check failed for AER_CAP_TLP_PREFIX_LOG: Expect = %h, Observed = %h", exp_tlp_prefix_log, tlp_prefix_log))
          end 
      end

			compare_data = {
							17'h_0,
							(test_induced_iecor),
							(test_induced_anfes),
							13'h_0 /*NA for IOSF*/
							};
			compare_mask = 32'h_ffff_ffff;
			read_compare(pf_cfg_regs.AER_CAP_CORR_ERR_STATUS,compare_data,compare_mask,rslt);
            if (!skip_status_clear) begin
		    	pf_cfg_regs.AER_CAP_CORR_ERR_STATUS.write(status,compare_data,primary_id,this,.sai(legal_sai));
		    	read_compare(pf_cfg_regs.AER_CAP_CORR_ERR_STATUS,32'h_0,compare_mask,rslt);
            end

	end	



  endtask

endclass

`endif
