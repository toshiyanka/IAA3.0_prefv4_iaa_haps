//--################
//-- INTR::detect_alarm_intr
//--################
virtual task detect_alarm_intr(int hqmproc_intr_enable_in);
   bit [31:0]       read_val, read_val0, read_val1, msix_data;

    while(1) begin
        if(hqmproc_intr_enable_in) begin
           if(i_hqm_cfg.i_hqm_pp_cq_status.msix_int_received(0)==1) begin	   
              //`ovm_info(get_full_name(),$psprintf("detect_alarm_intr: msix_int_received "),OVM_LOW)	        
              i_hqm_cfg.i_hqm_pp_cq_status.wait_for_msix_int(0, msix_data);
              `ovm_info(get_full_name(),$psprintf("detect_alarm_intr: msix_int_received msix_data=0x%0x", msix_data),OVM_LOW)	        

              read_reg("ALARM_HW_SYND", read_val0, "hqm_system_csr");
              `ovm_info(get_full_name(),$psprintf("detect_alarm_intr: ALARM_HW_SYND.rd_data=0x%0x", read_val0),OVM_LOW)	        
              read_reg("ALARM_PF_SYND0", read_val1, "hqm_system_csr");
              `ovm_info(get_full_name(),$psprintf("detect_alarm_intr: ALARM_PF_SYND0.rd_data=0x%0x", read_val1),OVM_LOW)	        
              check_alarm_intr(read_val0, read_val1); 
 
              //--clear
              //write_reg("ALARM_PF_SYND0", 32'h0, "hqm_system_csr");
              //read_reg("ALARM_PF_SYND0", read_val0, "hqm_system_csr");
              //`ovm_info(get_full_name(),$psprintf("detect_alarm_intr: ALARM_PF_SYND0.after_clear.rd_data=0x%0x", read_val0),OVM_LOW)	        

              //write_reg("ALARM_HW_SYND", 32'h0, "hqm_system_csr");
              //read_reg("ALARM_HW_SYND", read_val0, "hqm_system_csr");
              //`ovm_info(get_full_name(),$psprintf("detect_alarm_intr: ALARM_HW_SYND.after_clear.rd_data=0x%0x", read_val0),OVM_LOW)	        

              //--clear MSIX_ACK
              read_reg("MSIX_ACK", read_val, "hqm_system_csr");
              `ovm_info(get_full_name(),$psprintf("detect_alarm_intr: MSIX_ACK.rd_data=0x%0x", read_val),OVM_LOW)	        
              write_reg("MSIX_ACK", 32'h1, "hqm_system_csr");
              `ovm_info(get_full_name(),$psprintf("detect_alarm_intr: MSIX_ACK.write 1 to clear"),OVM_LOW)
           end	      	        
           wait_idle (1);
        end else begin
            wait_idle (1000);
        end
    end //while
endtask:detect_alarm_intr


//--################
//-- INTR::check_alarm_intr
//-- read hqm_system_regs.ALARM_HW_SYND 
//--        bit31=1 && bit11=1  => this is a CWDT 
//--        bit31=1 && bit10=1  => this is a hardware alarm (SBE/MBE,
//-- read hqm_system_regs.ALARM_PF_SYND0 
//--        bit31=1 => this is an ingress error		
//--################
virtual task check_alarm_intr(bit [31:0] alarm_hw_synd, bit[31:0] alarm_pf_synd);
   bit [31:0]       read_val;

    //-mailbox-
    if(alarm_hw_synd[31] && alarm_hw_synd[12]) begin
        `ovm_info(get_full_name(),$psprintf("check_alarm_intr: Detect Mailbox Alarm alarm_hw_synd=0x%0x alarm_pf_synd=0x%0x", alarm_hw_synd, alarm_pf_synd),OVM_LOW)
       
    end

    //--CWDI
    if(alarm_hw_synd[31] && alarm_hw_synd[11]) begin
        i_hqm_cfg.cialcwdt_cfg.cwdt_received_cnt++;
        `ovm_info(get_full_name(),$psprintf("check_alarm_intr: Detect CWDI Alarm alarm_hw_synd=0x%0x alarm_pf_synd=0x%0x cialcwdt_cfg.cwdt_received_cnt=%0d cwdt_count_num=%0d", alarm_hw_synd, alarm_pf_synd, i_hqm_cfg.cialcwdt_cfg.cwdt_received_cnt, i_hqm_cfg.cialcwdt_cfg.cwdt_count_num),OVM_LOW)
        cwdi_intr_service();
    end

    //--hardware alarm
    if(alarm_hw_synd[31] && alarm_hw_synd[10]) begin
        `ovm_info(get_full_name(),$psprintf("check_alarm_intr: Detect Hardware Alarm alarm_hw_synd=0x%0x alarm_pf_synd=0x%0x", alarm_hw_synd, alarm_pf_synd),OVM_LOW)
        check_hardware_error_alarm(alarm_hw_synd);

    end

    //--ingress error alarm
    if(alarm_pf_synd[31]) begin
        `ovm_info(get_full_name(),$psprintf("check_alarm_intr: Detect IngressErr Alarm alarm_hw_synd=0x%0x alarm_pf_synd=0x%0x", alarm_hw_synd, alarm_pf_synd),OVM_LOW)
        check_ingress_error_alarm(alarm_pf_synd);
    end
endtask:check_alarm_intr


//--################
//-- cwdi_intr_service
//--################
virtual task cwdi_intr_service();
  sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$], cwdt_wdto_rd_data;
  int                           cqid_tmp, cwdt_interval, cfg_interval, cfg_interval_walk, cwdt_interval_diff;  

          //--------------------------------------
          //--------------------------------------
	  //-- CWDT intr service
          //--------------------------------------
          //--------------------------------------
          //------------------	     
          //--dirCQ[0]~[31] 
          //------------------	  
          read_reg("CFG_DIR_WDTO_0", rd_val , "credit_hist_pipe");
	  ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_0.0: credit_hist_pipe.CFG_DIR_WDTO_0.rd = 0x%08x",  rd_val), OVM_MEDIUM);

          if(rd_val!=0) begin
             //--dirCQ[0]~[31] generates a CWDI 
             wr_val = rd_val;	

             //--------------------------------------------
             //--this does cwintr_b2b_ck for direct test (HQMV2 hqm_proc TB TSTsmk_cialcwdtintr_dirldb_t2_t004) (HQMV25 hqm tb ldb4ppdir4pp_cqdep8_cqthres7_cial_test0_respdly2)
             if($test$plusargs("cwintr_b2b_ck") && cwintr_wdto_dir_cnt==0) begin 	          
               if(rd_val==1) cwintr_wdto_dir_cnt = cwintr_wdto_dir_cnt +1;
               else if(rd_val==3) cwintr_wdto_dir_cnt = cwintr_wdto_dir_cnt +2;
             end

             if(!$test$plusargs("cwintr_noclr")) begin 	          
                write_reg("CFG_DIR_WDTO_0", wr_val, "credit_hist_pipe");
                read_reg("CFG_DIR_WDTO_0", rd_val , "credit_hist_pipe");
	        ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_0.1: write-to-clear credit_hist_pipe.CFG_DIR_WDTO_0.wr = 0x%08x rd = 0x%08x",  wr_val, rd_val), OVM_MEDIUM);
             end	     
	      
             //-- disable register	      
             read_reg("CFG_DIR_WD_DISABLE0", rd_val , "credit_hist_pipe");
	     ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_0.2: credit_hist_pipe.CFG_DIR_WD_DISABLE0.rd = 0x%08x",  rd_val), OVM_MEDIUM);

             if(!$test$plusargs("cwintr_noreena")) begin 
                wr_val = rd_val;	     			  
                write_reg("CFG_DIR_WD_DISABLE0", wr_val, "credit_hist_pipe");
	        ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_0.3_reenable: credit_hist_pipe.CFG_DIR_WD_DISABLE0.wr = 0x%08x",  wr_val), OVM_MEDIUM);
             end else begin
                wr_val = 0;
                write_reg("CFG_DIR_WD_DISABLE0", wr_val, "credit_hist_pipe");
	        ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_0.3_noreenable: credit_hist_pipe.CFG_DIR_WD_DISABLE0.wr = 0x%08x",  wr_val), OVM_MEDIUM);
             end 
          end//--DIR0-31  
	  	     

          //------------------	     
          //--dirCQ[32]~[63] 
          //------------------	  
          read_reg("CFG_DIR_WDTO_1", rd_val , "credit_hist_pipe");
	  ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_1.0: credit_hist_pipe.CFG_DIR_WDTO_1.rd = 0x%08x",  rd_val), OVM_MEDIUM);

          if(rd_val!=0) begin
             //--dirCQ[32]~[63] generates a CWDI 
             wr_val = rd_val;	

             //--------------------------------------------
             if(!$test$plusargs("cwintr_noclr")) begin 	          
                write_reg("CFG_DIR_WDTO_1", wr_val, "credit_hist_pipe");
                read_reg("CFG_DIR_WDTO_1", rd_val , "credit_hist_pipe");
	        ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_1.1: write-to-clear credit_hist_pipe.CFG_DIR_WDTO_1.wr = 0x%08x rd = 0x%08x",  wr_val, rd_val), OVM_MEDIUM);
             end	     
	      
             //-- disable register	      
             read_reg("CFG_DIR_WD_DISABLE1", rd_val , "credit_hist_pipe");
	     ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_1.2: credit_hist_pipe.CFG_DIR_WD_DISABLE1.rd = 0x%08x",  rd_val), OVM_MEDIUM);

             if(!$test$plusargs("cwintr_noreena")) begin 
                wr_val = rd_val;	     			  
                write_reg("CFG_DIR_WD_DISABLE1", wr_val, "credit_hist_pipe");
	        ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_1.3_reenable: credit_hist_pipe.CFG_DIR_WD_DISABLE1.wr = 0x%08x",  wr_val), OVM_MEDIUM);
             end else begin
                wr_val = 0;
                write_reg("CFG_DIR_WD_DISABLE1", wr_val, "credit_hist_pipe");
	        ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_1.3_noreenable: credit_hist_pipe.CFG_DIR_WD_DISABLE1.wr = 0x%08x",  wr_val), OVM_MEDIUM);
             end 
          end//--DIR32-63  


//          //------------------	     
//          //--dirCQ[64]~[95] 
//          //------------------	  
//          read_reg("CFG_DIR_WDTO_2", rd_val , "credit_hist_pipe");
//	  ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_2.0: credit_hist_pipe.CFG_DIR_WDTO_2.rd = 0x%08x",  rd_val), OVM_MEDIUM);
//
//          if(rd_val!=0) begin
//             //--dirCQ[64]~[95] generates a CWDI 
//             wr_val = rd_val;	
//
//             //--------------------------------------------
//             if(!$test$plusargs("cwintr_noclr")) begin 	          
//                write_reg("CFG_DIR_WDTO_2", wr_val, "credit_hist_pipe");
//                read_reg("CFG_DIR_WDTO_2", rd_val , "credit_hist_pipe");
//	        ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_2.1: write-to-clear credit_hist_pipe.CFG_DIR_WDTO_2.wr = 0x%08x rd = 0x%08x",  wr_val, rd_val), OVM_MEDIUM);
//             end	     
//	      
//             //-- disable register	      
//             read_reg("CFG_DIR_WD_DISABLE2", rd_val , "credit_hist_pipe");
//	     ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_2.2: credit_hist_pipe.CFG_DIR_WD_DISABLE2.rd = 0x%08x",  rd_val), OVM_MEDIUM);
//
//             if(!$test$plusargs("cwintr_noreena")) begin 
//                wr_val = rd_val;	     			  
//                write_reg("CFG_DIR_WD_DISABLE2", wr_val, "credit_hist_pipe");
//	        ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_2.3_reenable: credit_hist_pipe.CFG_DIR_WD_DISABLE2.wr = 0x%08x",  wr_val), OVM_MEDIUM);
//             end else begin
//                wr_val = 0;
//                write_reg("CFG_DIR_WD_DISABLE2", wr_val, "credit_hist_pipe");
//	        ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_DIR_2.3_noreenable: credit_hist_pipe.CFG_DIR_WD_DISABLE2.wr = 0x%08x",  wr_val), OVM_MEDIUM);
//             end 
//          end//--DIR64-95 

       	  //--this does cwintr_b2b_ck for direct test (HQMV2  hqm_proc TB TSTsmk_cialcwdtintr_dirldb_t2_t004) (HQMV25 HQM TB ldb4ppdir4pp_cqdep8_cqthres7_cial_test0_respdly4)
          //-- test ldb4ppdir4pp_cqdep8_cqthres7_cial_test0_respdly4 runs with 2 dirCQs and 2 ldbCQs, ldb cwdt occurs eariler than dir cwdt, so, once ldb check is done, start to check dir case
	  //-- support  cwintr_b2b_ck
          if($test$plusargs("cwintr_b2b_ck") && cwintr_wdto_dir_ck == 1 && cwintr_wdto_ldb_ck == 0) begin 	          
              if(cwintr_wdto_dir_cnt<2 ) begin
	         ovm_report_warning(get_full_name(),$psprintf("cwdi_intr_service_DIR_1.4: cwintr_wdto_dir_cnt=%0d expect to get more than 1 wdto due to b2b cwdt", cwintr_wdto_dir_cnt), OVM_LOW);
              end else begin
	         ovm_report_info(get_full_name(),$psprintf("cwdi_intr_service_DIR_1.4: cwintr_wdto_dir_cnt=%0d b2b cwdt pass", cwintr_wdto_dir_cnt), OVM_LOW);
              end
              cwintr_wdto_dir_ck = 0;
          end

          //--------------------------------------
          //--------------------------------------
          //------------------       
	  //--ldbCQ[0]~[31] 
          //------------------  		  
          read_reg("CFG_LDB_WDTO_0", rd_val , "credit_hist_pipe");
	  ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_LDB_0.0: credit_hist_pipe.CFG_LDB_WDTO_0.rd = 0x%08x",  rd_val), OVM_MEDIUM);
          
          if(rd_val!=0) begin
              //--------------------------------------------
              //--this does cwintr_b2b_ck for direct test ldb4ppdir4pp_cqdep8_cqthres7_cial_test0_respdly2
              if($test$plusargs("cwintr_b2b_ck") && cwintr_wdto_ldb_cnt==0) begin 	          
                if(rd_val==1) cwintr_wdto_ldb_cnt = cwintr_wdto_ldb_cnt +1;
                else if(rd_val==3) cwintr_wdto_ldb_cnt = cwintr_wdto_ldb_cnt +2;
              end

              //--------------------------------------------
              //-- check cwdt intervals when running  
              if($test$plusargs("cwintr_interval_ck") && rd_val==1) begin 
                 cwdt_interval_time_start=$time;
                 cwintr_interval_ck_on = 1;		 
                 ovm_report_info("HQMPROC_INTRPOLL_SEQ0", $psprintf("cwdi_intr_service_LDB_1.ckonstart cwdt_interval_time_start=%0d", cwdt_interval_time_start), OVM_LOW);
              end 	  
              if($test$plusargs("cwintr_interval_ck") && cwintr_interval_ck_on==1 && rd_val==2) begin 
                 cwdt_interval_time_end=$time;
                 cwintr_interval_ck_on = 0;		 
		 
                 cfg_interval = i_hqm_cfg.cialcwdt_cfg.ldb_cwdt_intrv;
                 cfg_interval_walk = (cfg_interval+1)*64*8; //--1.25ns*8cycles=10
                 //--acc interval monitored
                 cwdt_interval = (cwdt_interval_time_end - cwdt_interval_time_start)/1250;

                 if(cwdt_interval > cfg_interval_walk) cwdt_interval_diff = cwdt_interval - cfg_interval_walk;
                 else				       cwdt_interval_diff = cfg_interval_walk - cwdt_interval;
                 ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_LDB_1.ckonend cwdt_interval_time_end=%0d", cwdt_interval_time_end), OVM_LOW);
                 ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_LDB_1.ck acc_cwdt_interval=%0d, exp_cfg_interval=%0d, cwdt_interval_diff=%0d/cfg_interval=%0d", cwdt_interval, cfg_interval_walk, cwdt_interval_diff, cfg_interval), OVM_LOW);

                 //-- Check interval btw two CQs : note, no backpressure on intr interface
                 if(cwdt_interval_diff > 32) begin
                   ovm_report_warning(get_full_name(), $psprintf("cwdi_intr_service_LDB_1.ck get acc_cwdt_interval=%0d, exp_cfg_interval=%0d/cwdt_interval_diff=%0d", cwdt_interval, cfg_interval, cwdt_interval_diff), OVM_LOW);
                 end 		 
              end 
	      	      
              //--ldbCQ[0]~[31] generates a CWDI 
              wr_val = rd_val;    
              if(!$test$plusargs("cwintr_noclr")) begin 		      
                write_reg("CFG_LDB_WDTO_0", wr_val, "credit_hist_pipe");
                read_reg("CFG_LDB_WDTO_0", rd_val , "credit_hist_pipe");
	        ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_LDB_0.1: write-to-clear credit_hist_pipe.CFG_LDB_WDTO_0.wr = 0x%08x rd = 0x%08x",  wr_val, rd_val), OVM_MEDIUM);
              end
	  		  
              //-- disable register	      
              read_reg("CFG_LDB_WD_DISABLE0", rd_val , "credit_hist_pipe");
	      ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_LDB_0.2: credit_hist_pipe.CFG_LDB_WD_DISABLE0.rd = 0x%08x",  rd_val), OVM_MEDIUM);

              if(!$test$plusargs("cwintr_noreena")) begin 
                 wr_val = rd_val;	     			  
                 write_reg("CFG_LDB_WD_DISABLE0", wr_val, "credit_hist_pipe");
	         ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_LDB_0.3_reenable: credit_hist_pipe.CFG_LDB_WD_DISABLE0.wr = 0x%08x",  wr_val), OVM_MEDIUM);
              end else begin
                 wr_val = 0;
                 write_reg("CFG_LDB_WD_DISABLE0", wr_val, "credit_hist_pipe");
	         ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_LDB_0.3_noreenable: credit_hist_pipe.CFG_LDB_WD_DISABLE0.wr = 0x%08x",  wr_val), OVM_MEDIUM);
              end 
          end //--LDB[0]-LDB[31] 
	  
          //--------------------------------------
          //------------------		  
	  //--ldbCQ[32]~[63]
          //------------------				       
          read_reg("CFG_LDB_WDTO_1", rd_val , "credit_hist_pipe");
	  ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_LDB_1.0: credit_hist_pipe.CFG_LDB_WDTO_0.rd = 0x%08x",  rd_val), OVM_MEDIUM);
	
          if(rd_val!=0) begin	    
              //--ldbCQ[32]~[63] generates a CWDI 
              wr_val = rd_val;    
              if(!$test$plusargs("cwintr_noclr")) begin 		  
                write_reg("CFG_LDB_WDTO_1", wr_val, "credit_hist_pipe");
                read_reg("CFG_LDB_WDTO_1", rd_val , "credit_hist_pipe");
	        ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_LDB_1.1: write-to-clear credit_hist_pipe.CFG_LDB_WDTO_1.wr = 0x%08x rd = 0x%08x",  wr_val, rd_val), OVM_MEDIUM);
              end    

              //-- disable register	      
              read_reg("CFG_LDB_WD_DISABLE1", rd_val , "credit_hist_pipe");
	      ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_LDB_1.2: credit_hist_pipe.CFG_LDB_WD_DISABLE1.rd = 0x%08x",  rd_val), OVM_MEDIUM);

              if(!$test$plusargs("cwintr_noreena")) begin 
                 wr_val = rd_val;	     			  
                 write_reg("CFG_LDB_WD_DISABLE1", wr_val, "credit_hist_pipe");
	         ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_LDB_1.3_reenable: credit_hist_pipe.CFG_LDB_WD_DISABLE1.wr = 0x%08x",  wr_val), OVM_MEDIUM);
              end else begin
                 wr_val = 0;
                 write_reg("CFG_LDB_WD_DISABLE1", wr_val, "credit_hist_pipe");
	         ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_LDB_1.3_noreenable: credit_hist_pipe.CFG_LDB_WD_DISABLE1.wr = 0x%08x",  wr_val), OVM_MEDIUM);
              end 
          end		    
	  
          //--this does cwintr_b2b_ck for direct test (HQMV2  hqm_proc TB TSTsmk_cialcwdtintr_dirldb_t2_t004) (HQMV25 HQM TB ldb4ppdir4pp_cqdep8_cqthres7_cial_test0_respdly4)
	  //-- support  cwintr_b2b_ck
          if($test$plusargs("cwintr_b2b_ck") && cwintr_wdto_ldb_ck ==1) begin 	          
              if(cwintr_wdto_ldb_cnt<2 ) begin
                 read_reg("CFG_LDB_WDTO_0", rd_val , "credit_hist_pipe");
	         ovm_report_info(get_full_name(), $psprintf("cwdi_intr_service_LDB_0.0: credit_hist_pipe.CFG_LDB_WDTO_0.rd_2nd = 0x%08x",  rd_val), OVM_MEDIUM);
	         ovm_report_warning(get_full_name(),$psprintf("cwdi_intr_service_LDB_1.4: cwintr_wdto_ldb_cnt=%0d expect to get more than 1 wdto due to b2b cwdt",  cwintr_wdto_ldb_cnt), OVM_LOW);
              end else begin
	         ovm_report_info(get_full_name(),$psprintf("cwdi_intr_service_LDB_1.4: cwintr_wdto_ldb_cnt=%0d b2b cwdt pass ",  cwintr_wdto_ldb_cnt), OVM_LOW);
              end
              cwintr_wdto_ldb_ck = 0;
          end
endtask: cwdi_intr_service

//--################
//-- check_hardware_error_alarm
//UNIT_ID                	code
//hqm_aqed_pipe_core	        2
//hqm_credit_hist_pipe_core	4
//hqm_dp_pipe_core       	5
//hqm_dqed_pipe_core	        0
//hqm_list_sel_pipe_core	9
//hqm_lsp_atm_pipe       	3
//hqm_master             	10
//hqm_nalb_pipe_core    	7
//hqm_qed_pipe_core	        6
//hqm_reorder_pipe_core	        8
//hqm_system            	1
//
//--################
virtual task check_hardware_error_alarm(bit[31:0] alarm_synd);
 int multi_val;
 int src_val;
 int unit_val;
 int aid_val;
 int class_val;
 int is_ldb_val;
 int rtype_val;
 bit [7:0] syndrome_val;

     multi_val  = alarm_synd[30];
     src_val	= alarm_synd[29:26]; //--0: hqm_system; 1: hqm_core; 2: iosf
     unit_val	= alarm_synd[25:22]; //--unit: 9 ROP; 4 CHP; 5 DP; 7 NALB;  9 LSP
     aid_val	= alarm_synd[21:16]; //--
     class_val  = alarm_synd[15:14]; //--0: info; 1: correctable; 2:uncorrectable
     is_ldb_val = alarm_synd[13]; 
     rtype_val  = alarm_synd[9:8];   //--0: alarm_specific; 1:cq/pp; 2: qid; 3: vas 
     syndrome_val = alarm_synd[7:0];

     `ovm_info(get_full_name(),$psprintf("check_hardware_error_alarm: Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val),OVM_LOW)

     //-- parity error inj to DQED flid
     if($test$plusargs("has_chp_dqed_parerr_inj") || $test$plusargs("has_chp_qeddqed_parerr_rndinj")) begin
               //--parity error inj from chp to sys  
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect src_val=1 upon chp_dqed_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=4) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect unit_val=4 upon chp_dqed_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
     end

     //-- parity error inj to QED flid
     if($test$plusargs("has_chp_qed_parerr_inj")  || $test$plusargs("has_chp_qeddqed_parerr_rndinj")) begin
               //--parity error inj from chp to sys  
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect src_val=1 upon chp_qed_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=4) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect unit_val=4 upon chp_qed_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
     end

     //-- parity error inj to AQED
     if($test$plusargs("has_aqed_parerr_inj_0") ||  $test$plusargs("has_aqed_parerr_inj_2")) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect src_val=1 upon chp_qed_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=2) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect unit_val=2 upon aqed_parerr_inj_0/_2",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
     end

     //-- parity error inj to AQED bit3, lsp_atm report error
     if($test$plusargs("has_aqed_parerr_inj_3") ) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect src_val=1 upon chp_qed_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=3) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect unit_val=3 upon aqed_parerr_inj_3",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
     end

     //-- parity error inj to AQED bit4,  report error
     if($test$plusargs("has_aqed_parerr_inj_4") ) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect src_val=1 upon chp_qed_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=4 || unit_val!=9) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect unit_val=4/9 upon aqed_parerr_inj_4",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
     end


     //-- when CHP inject parity error to Egress HCW (DATA), hqm_system report alarm with info src=0, unit=1, class=2, aid=9
     //-- when CHP inject parity error to Egress User, 
     if($test$plusargs("has_chp_egrhcw_parerr_inj") || $test$plusargs("has_chp_egrusr_parerr_inj")) begin
         if(src_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect src_val=0 upon has_chp_egrhcw_parerr_inj/has_chp_egrusr_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=1) 
           `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect unit_val=1 upon has_chp_egrhcw_parerr_inj/has_chp_egrusr_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=2) 
           `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect class_val=2 upon has_chp_egrhcw_parerr_inj/has_chp_egrusr_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=9) 
           `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect aid_val=9 upon has_chp_egrhcw_parerr_inj/has_chp_egrusr_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))

     end

     //-- when CHP inject parity error to Ingress HCW (DATA),  CHP report alarm with info src=1, unit=4, class=0, aid=0
     //-- when CHP inject parity error to Ingress User,        CHP report alarm with info src=1, unit=4, class=0, aid=0
     if($test$plusargs("has_chp_inghcw_parerr_inj") || $test$plusargs("has_chp_ingusr_parerr_inj")) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect src_val=1 upon has_chp_inghcw_parerr_inj/has_chp_ingusr_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=4) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect unit_val=4 upon has_chp_inghcw_parerr_inj/has_chp_ingusr_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect class_val=0 upon has_chp_inghcw_parerr_inj/has_chp_ingusr_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect aid_val=0 upon has_chp_inghcw_parerr_inj/has_chp_ingusr_parerr_inj",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))

     end
     
     //---------------------------------------
     //-- parity error inj to NALB
     //---------------------------------------
     if($test$plusargs("has_nalb_parerr_inj_1") || $test$plusargs("has_nalb_parerr_inj_0")) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect src_val=1 upon has_nalb_parerr_inj_1/0",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=7) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect unit_val=7 upon has_nalb_parerr_inj_1/0",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
     end

     //---------------------------------------
     //-- parity error inj to DIR_PIPE 
     //---------------------------------------
     if($test$plusargs("has_dp_parerr_inj_1") || $test$plusargs("has_dp_parerr_inj_0")) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect src_val=1 upon has_dp_parerr_inj_1/0",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=5) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect unit_val=5 upon has_dp_parerr_inj_1/0",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
     end

     //---------------------------------------
     //-- parity error inj to ATM_PIPE 
     //---------------------------------------
     if($test$plusargs("has_atm_parerr_inj_2") || $test$plusargs("has_atm_parerr_inj_1") || $test$plusargs("has_atm_parerr_inj_0")) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect src_val=1 upon has_atm_parerr_inj_1/0",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=3) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect unit_val=3 upon has_atm_parerr_inj_1/0",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
     end

     //---------------------------------------
     //-- parity error inj to LSP
     //---------------------------------------
     if($test$plusargs("has_lsp_parerr_inj_14") || 
        $test$plusargs("has_lsp_parerr_inj_13") || 
        $test$plusargs("has_lsp_parerr_inj_12") || 
        $test$plusargs("has_lsp_parerr_inj_11") || 
        $test$plusargs("has_lsp_parerr_inj_10") || 
        $test$plusargs("has_lsp_parerr_inj_9") || 
        $test$plusargs("has_lsp_parerr_inj_8") || 
        $test$plusargs("has_lsp_parerr_inj_7") || 
        $test$plusargs("has_lsp_parerr_inj_6") || 
        $test$plusargs("has_lsp_parerr_inj_5") || 
        $test$plusargs("has_lsp_parerr_inj_4") || 
        $test$plusargs("has_lsp_parerr_inj_3") || 
        $test$plusargs("has_lsp_parerr_inj_2") || 
        $test$plusargs("has_lsp_parerr_inj_1") || 
        $test$plusargs("has_lsp_parerr_inj_0")) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect src_val=1 upon has_lsp_parerr_inj_*",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=9) 
            `ovm_error(get_full_name(),$psprintf("check_hardware_error_alarm:Detect hardware alarm_hw_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d) expect unit_val=9 upon has_lsp_parerr_inj_*",  alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
     end

endtask: check_hardware_error_alarm

//--################
//-- check_ingress_error_alarm
//--################
virtual task check_ingress_error_alarm(bit[31:0] alarm_synd);
 int multi_val;
 int src_val;
 int unit_val;
 int aid_val;
 int class_val;
 int is_ldb_val;
 int rtype_val;
 bit [7:0] syndrome_val;
 int has_excess_frag, has_unexp_comp, has_excess_token, has_unexp_rels, has_ooc_inj;
 int has_comp_dirpp;
 int has_dis_qid;
 int has_ill_qid;    //-- QID not assigned to VAS
 int has_ill_ldbqid; //-- (UNO/ORD)
 int has_ill_pp;
 int has_ill_dirpp_rels;
 int has_ill_hcw;    //-- illegal HCW (cmd=6/7/14/5) 
 int attacked_cq;
 int attacked_qid, unexp_rels_qid;
 int attacked_pp;

      has_excess_frag = 0;
      has_unexp_comp = 0;
      has_excess_token = 0;
      has_unexp_rels   = 0;
      unexp_rels_qid  = 0;
      has_ooc_inj = 0;
      has_dis_qid = 0;
      has_ill_qid = 0;
      has_ill_ldbqid = 0;
      has_comp_dirpp = 0;
      has_ill_pp = 0;
      has_ill_hcw = 0;
      has_ill_dirpp_rels = 0;


      multi_val  = alarm_synd[30];
      src_val    = alarm_synd[29:26]; //--0: hqm_system; 1: hqm_core; 2: iosf
      unit_val   = alarm_synd[25:22]; //-- 4: CHP; 10: LSP
      aid_val    = alarm_synd[21:16]; //--
      class_val  = alarm_synd[15:14]; //--0: info; 1: correctable; 2:uncorrectable
      is_ldb_val = alarm_synd[13]; 
      rtype_val  = alarm_synd[9:8];   //--0: alarm_specific; 1:cq/pp; 2: qid; 3: vas 
      syndrome_val = alarm_synd[7:0];


      //-- has_excess_frag
      foreach(i_hqm_cfg.ldb_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.ldb_pp_cq_cfg[i].exp_errors.excess_frag==1) begin
            has_excess_frag=1;
            break;
         end
      end
      
      //-- has_unexp_rels,unexp_rels_qid
      foreach(i_hqm_cfg.ldb_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.ldb_pp_cq_cfg[i].exp_errors.unexp_rels==1) begin
            has_unexp_rels=1;
            unexp_rels_qid=i-2; //i_hqm_cfg.ldb_pp_cq_cfg[i].exp_errors.unexp_rels_qid;
           `ovm_info(get_full_name(),$psprintf("check_ingress_error_alarm: ldb_pp_cq_cfg[%0d].unexp_rels=1, unexp_rels_qid=%0d ", i,unexp_rels_qid),OVM_LOW)
            break;
         end
      end

      //-- has_excess_token
      foreach(i_hqm_cfg.ldb_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.ldb_pp_cq_cfg[i].exp_errors.excess_tok==1) begin
            has_excess_token=1;
            break;
         end
      end
      foreach(i_hqm_cfg.dir_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.dir_pp_cq_cfg[i].exp_errors.excess_tok==1) begin
            has_excess_token=1;
            break;
         end
      end

      //-- has_unexp_comp
      foreach(i_hqm_cfg.ldb_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.ldb_pp_cq_cfg[i].exp_errors.unexp_comp==1) begin
            has_unexp_comp=1;
            break;
         end
      end

      //-- has_ooc_inj
      foreach(i_hqm_cfg.ldb_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.ldb_pp_cq_cfg[i].exp_errors.ooc==1) begin
            has_ooc_inj=1;
            break;
         end
      end

      foreach(i_hqm_cfg.dir_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.dir_pp_cq_cfg[i].exp_errors.ooc==1) begin
            has_ooc_inj=1;
            break;
         end
      end

      //-- has_comp_dirpp 
      foreach(i_hqm_cfg.dir_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.dir_pp_cq_cfg[i].exp_errors.ill_hcw_cmd_dir_pp==1) begin
            has_comp_dirpp=1;
            break;
         end
      end

      
      //-- has_ill_qid
      foreach(i_hqm_cfg.ldb_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.ldb_pp_cq_cfg[i].exp_errors.ill_qid==1) begin
            has_ill_qid=1;
            break;
         end
      end

      foreach(i_hqm_cfg.dir_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.dir_pp_cq_cfg[i].exp_errors.ill_qid==1) begin
            has_ill_qid=1;
            break;
         end
      end

      //-- has_dis_qid
      foreach(i_hqm_cfg.ldb_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.ldb_pp_cq_cfg[i].exp_errors.dis_qid==1) begin
            has_dis_qid=1;
            break;
         end
      end

      foreach(i_hqm_cfg.dir_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.dir_pp_cq_cfg[i].exp_errors.dis_qid==1) begin
            has_dis_qid=1;
            break;
         end
      end

      //-- has_ill_pp
      foreach(i_hqm_cfg.ldb_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.ldb_pp_cq_cfg[i].exp_errors.ill_pp==1) begin
            has_ill_pp=1;
            break;
         end
      end

      foreach(i_hqm_cfg.dir_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.dir_pp_cq_cfg[i].exp_errors.ill_pp==1) begin
            has_ill_pp=1;
            break;
         end
      end

      //-- has_ill_hcw
      foreach(i_hqm_cfg.ldb_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.ldb_pp_cq_cfg[i].exp_errors.ill_hcw_cmd==1) begin
            has_ill_hcw=1;
            break;
         end
      end

      foreach(i_hqm_cfg.dir_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.dir_pp_cq_cfg[i].exp_errors.ill_hcw_cmd==1) begin
            has_ill_hcw=1;
            break;
         end
      end

      //-- has_ill_ldbqid
      foreach(i_hqm_cfg.ldb_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.ldb_pp_cq_cfg[i].exp_errors.ill_ldbqid==1) begin
            has_ill_ldbqid=1;
            break;
         end
      end
      foreach(i_hqm_cfg.dir_pp_cq_cfg[i]) begin 
         if(i_hqm_cfg.dir_pp_cq_cfg[i].exp_errors.ill_ldbqid==1) begin
            has_ill_ldbqid=1;
            break;
         end
      end


     `ovm_info(get_full_name(),$psprintf("check_ingress_error_alarm: Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d); check on has_excess_token=%0d has_unexp_comp=%0d has_excess_frag=%0d has_unexp_rels=%0d has_ooc_inj=%0d has_ill_qid=%0d has_dis_qid=%0d has_ill_ldbqid=%0d has_ill_pp=%0d has_comp_dirpp=%0d has_ill_hcw=%0d", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val, has_excess_token, has_unexp_comp, has_excess_frag, has_unexp_rels,has_ooc_inj, has_ill_qid, has_dis_qid, has_ill_ldbqid, has_ill_pp, has_comp_dirpp, has_ill_hcw),OVM_LOW)

      //------------------------
      //--check has_excess_frag
      //------------------------
      if(has_excess_frag) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_frag src_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=4) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_frag unit_val expect 4; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_frag aid_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_frag class_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(rtype_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_frag rtype_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(syndrome_val==0 || syndrome_val[7]==0)  
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_frag syndrome_val expect non-zero, expect syndrome[7]=1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         else begin
            attacked_cq = syndrome_val[5:0];
            if(i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.excess_frag==1 || i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ooc ==1) begin 
              //--both case are accepted
             `ovm_warning(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_frag syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.excess_frag=%0d exp_ooc=%0d", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.excess_frag, i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ooc))
            end else begin 
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_frag syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.excess_frag=%0d exp_ooc=%0d", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.excess_frag, i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ooc))
            end
         end
      end //--has_excess_frag

      //------------------------
      //--check has_unexp_rels
      //------------------------
      if(has_unexp_rels) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_rels src_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=9) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_rels unit_val expect 9; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_rels aid_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_rels class_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(rtype_val!=2) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_rels rtype_val expect 2; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(syndrome_val==0 || syndrome_val[7]==0)  
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_rels syndrome_val expect non-zero, expect syndrome[7]=1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         else begin
            attacked_qid = syndrome_val[5:0];
            if(unexp_rels_qid!=attacked_qid)  
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_rels syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d), attacked_qid=%0d but exp_errors.unexp_rels_qid=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_qid,unexp_rels_qid))
         end
      end //--has_unexp_rels


      //------------------------
      //--check has_excess_token
      //------------------------
      if(has_excess_token && !$test$plusargs("has_illegal_pp") && !$test$plusargs("has_illegal_comp")) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_token src_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=4)  
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_token unit_val expect 4; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=2) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_token aid_val expect 2; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_token class_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(rtype_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_token rtype_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))


         attacked_cq = syndrome_val[5:0];
         if(i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.excess_tok!=1 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.excess_tok!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_token syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.excess_tok=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.excess_tok))
         end
      end //--has_excess_token

      //------------------
      //--coverage +has_illegal_comp
      //------------------
      if(has_excess_token && $test$plusargs("has_illegal_comp")) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_token src_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=4 && unit_val!=9 )  
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_token unit_val expect 4 or 9 (some LSP unexpected comp cases); Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=2 && aid_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_token aid_val expect 2 or 0 (some LSP unexpected comp cases); Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_token class_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(rtype_val!=1 && rtype_val!=2) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_token rtype_val expect 1 or 2 (some LSP unexpected comp cases); Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))


         attacked_cq = syndrome_val[5:0];
         if(i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.excess_tok!=1 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.excess_tok!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_excess_token syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.excess_tok=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.excess_tok))
         end
      end //--has_excess_token

     

      //------------------------
      //--check has_unexp_comp
      //-- unit=4, aid=1 (CHP drops extra comp)
      //------------------------
      if(has_unexp_comp) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_comp src_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=4) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_comp unit_val expect 4; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_comp aid_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_comp class_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(rtype_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_comp rtype_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))


         attacked_cq = syndrome_val[6:0];
         if(syndrome_val[7]==1 && i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.unexp_comp!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_comp syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d, error reported on LDB CQ), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.unexp_comp=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.unexp_comp))
         end
         if(i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.unexp_comp!=1 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.unexp_comp!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_unexp_comp syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.unexp_comp=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.unexp_comp))
         end
      end //--has_unexp_comp

      //------------------------
      //--check has_ooc_inj
      //-- unit=4, aid=1 (CHP drops enq hcw when ooc)
      //------------------------
      if(has_ooc_inj) begin
         if(src_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ooc_inj src_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=4) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ooc_inj unit_val expect 4; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ooc_inj aid_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ooc_inj class_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(rtype_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ooc_inj rtype_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))


         attacked_cq = syndrome_val[6:0];
         if(syndrome_val[7]==1 && i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ooc!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ooc_inj syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d, error reported on LDB CQ), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.ooc=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ooc))
         end
         if(i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ooc!=1 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ooc!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ooc_inj syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.ooc=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ooc))
         end
      end //--has_ooc_inj

      //------------------------
      //--check has_comp_dirpp
      //-- unit=0, aid=0 (system drops whole HCW)
      //-- src=0 unit=0 class=0 is_ldb=IS_LDB rtype=1 aid=0 syndrome=PP
      //------------------------
      if(has_comp_dirpp) begin
         if(src_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_comp_dirpp src_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_comp_dirpp unit_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_comp_dirpp aid_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_comp_dirpp class_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(rtype_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_comp_dirpp rtype_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))


         attacked_cq = syndrome_val[6:0];
         if(is_ldb_val==1 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_hcw_cmd_dir_pp!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_comp_dirpp syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d, exp error reported on LDB PP), but i_hqm_cfg.dir_pp_cq_cfg[%0d].exp_errors.ill_hcw_cmd_dir_pp=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_hcw_cmd_dir_pp))
         end
         if(i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_hcw_cmd_dir_pp != 1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_comp_dirpp syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d), but i_hqm_cfg.dir_pp_cq_cfg[%0d].exp_errors.ill_hcw_cmd_dir_pp=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_hcw_cmd_dir_pp))
         end
      end //--has_comp_dirpp


      //------------------------
      //--check has_ill_qid
      //-- unit=0, aid=3 (system drops ENQ and passes token/comp to CHP)
      //-- src=0 unit=0 class=0 is_ldb=IS_LDB rtype=1 aid=3 syndrome=PP
      //------------------------
      if(has_ill_qid) begin
         if(src_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_qid src_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_qid unit_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=3) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_qid aid_val expect 3; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_qid class_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(rtype_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_qid rtype_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))


         attacked_cq = syndrome_val[6:0];
         if(is_ldb_val==0 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_qid!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_qid syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d, exp error reported on DIR PP), but i_hqm_cfg.dir_pp_cq_cfg[%0d].exp_errors.ill_qid=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_qid))
         end
         if(is_ldb_val==1 && i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_qid!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_qid syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d, exp error reported on LDB PP), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.ill_qid=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_qid))
         end
         if(i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_qid != 1 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_qid != 1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_qid syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.ill_qid=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_qid))
         end
      end //--has_ill_qid



      //------------------------
      //--check has_dis_qid
      //-- unit=0, aid=4 (system drops ENQ and passes token/comp to CHP)
      //-- src=0 unit=0 class=0 is_ldb=IS_LDB rtype=1 aid=4 syndrome=PP
      //------------------------
      if(has_dis_qid) begin
         if(src_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_dis_qid src_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_dis_qid unit_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=4) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_dis_qid aid_val expect 4; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_dis_qid class_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(rtype_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_dis_qid rtype_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))


         attacked_cq = syndrome_val[6:0];
         if(is_ldb_val==0 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.dis_qid!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_dis_qid syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d, exp error reported on DIR PP), but i_hqm_cfg.dir_pp_cq_cfg[%0d].exp_errors.dis_qid=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.dis_qid))
         end
         if(is_ldb_val==1 && i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.dis_qid!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_dis_qid syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d, exp error reported on LDB PP), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.dis_qid=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.dis_qid))
         end
         if(i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.dis_qid != 1 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.dis_qid != 1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_dis_qid syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.dis_qid=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.dis_qid))
         end
      end //--has_dis_qid


      //------------------------
      //--check has_ill_ldbqid
      //-- unit=0, aid=5 (system drops ENQ and passes token/comp to CHP)
      //-- src=0 unit=0 class=0 is_ldb=IS_LDB rtype=1 aid=5 syndrome=PP
      //------------------------
      if(has_ill_ldbqid) begin
         if(src_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_ldbqid src_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_ldbqid unit_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=5) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_ldbqid aid_val expect 5; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_ldbqid class_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(rtype_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_ldbqid rtype_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))


         attacked_cq = syndrome_val[6:0];
         if(is_ldb_val==0 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_ldbqid!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_ldbqid syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d, exp error reported on DIR PP), but i_hqm_cfg.dir_pp_cq_cfg[%0d].exp_errors.ill_ldbqid=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_ldbqid))
         end
         if(is_ldb_val==1 && i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_ldbqid!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_ldbqid syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d, exp error reported on LDB PP), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.ill_ldbqid=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_ldbqid))
         end
         if(i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_ldbqid != 1 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_ldbqid != 1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_ldbqid syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.ill_ldbqid=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_ldbqid))
         end
      end //--has_ill_ldbqid



      //------------------------
      //--check has_ill_pp
      //-- unit=0, aid=1 (system drops whole HCW)
      //-- src=0 unit=0 class=0 is_ldb=IS_LDB rtype=1 aid=1 syndrome=PP
      //------------------------
      if(has_ill_pp) begin
         if(src_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_pp src_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_pp unit_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_pp aid_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_pp class_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(rtype_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_pp rtype_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))


         attacked_cq = syndrome_val[6:0];
         if(is_ldb_val==0 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_pp!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_pp syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d, exp error reported on DIR PP), but i_hqm_cfg.dir_pp_cq_cfg[%0d].exp_errors.ill_pp=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_pp))
         end
         if(is_ldb_val==1 && i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_pp!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_pp syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d, exp error reported on LDB PP), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.ill_pp=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_pp))
         end
         if(i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_pp != 1 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_pp != 1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_pp syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.ill_pp=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_pp))
         end
      end //--has_ill_pp


      //------------------------
      //--check has_ill_hcw
      //-- unit=0, aid=1 (system drops whole HCW)
      //-- src=0 unit=0 class=0 is_ldb=IS_LDB rtype=1 aid=0 syndrome=PP
      //------------------------
      if(has_ill_hcw) begin
         if(src_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_hcw src_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(unit_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_hcw unit_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(aid_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_hcw aid_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(class_val!=0) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_hcw class_val expect 0; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))
         if(rtype_val!=1) 
            `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_hcw rtype_val expect 1; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d)", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val))


         attacked_cq = syndrome_val[6:0];
         if(is_ldb_val==0 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_hcw_cmd!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_hcw syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d, exp error reported on DIR PP), but i_hqm_cfg.dir_pp_cq_cfg[%0d].exp_errors.ill_hcw_cmd=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_hcw_cmd))
         end
         if(is_ldb_val==1 && i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_hcw_cmd!=1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_hcw syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d, exp error reported on LDB PP), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.ill_hcw_cmd=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_hcw_cmd))
         end
         if(i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_hcw_cmd != 1 && i_hqm_cfg.dir_pp_cq_cfg[attacked_cq].exp_errors.ill_hcw_cmd != 1) begin
             `ovm_error(get_full_name(),$psprintf("check_ingress_error_alarm:has_ill_hcw syndrome_val; Detect ingress error alarm_pf_synd=0x%0x (src=%0d unit=%0d class=%0d is_ldb=%0d rtype=%0d aid=%0d syndrome=0x%0x multi=%0d), but i_hqm_cfg.ldb_pp_cq_cfg[%0d].exp_errors.ill_hcw_cmd=%0d ", alarm_synd, src_val, unit_val, class_val, is_ldb_val, rtype_val, aid_val,syndrome_val,multi_val,attacked_cq,i_hqm_cfg.ldb_pp_cq_cfg[attacked_cq].exp_errors.ill_hcw_cmd))
         end
      end //--has_ill_hcw


endtask: check_ingress_error_alarm

