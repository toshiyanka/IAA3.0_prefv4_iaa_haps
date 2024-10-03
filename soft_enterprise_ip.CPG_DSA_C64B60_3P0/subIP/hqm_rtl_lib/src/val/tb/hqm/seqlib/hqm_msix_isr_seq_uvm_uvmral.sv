// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2019) (2019) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
// File   : hqm_msix_isr_seq.sv
//
// Description :
//
// -----------------------------------------------------------------------------

import hqm_cfg_pkg::*;

class hqm_msix_isr_seq extends uvm_sequence;

  `uvm_object_utils(hqm_msix_isr_seq)

  slu_im_env                    im;

  uvm_reg_block                 ral;

  slu_im_isr_object             int_object;

  int                           msix_int_num;
  bit [31:0]                    msix_int_data;

  int                           wdog_cq_msix_int_en;
  int                           wdog_read_loop_num;  

  uvm_event_pool                glbl_pool;
  uvm_event                     exp_msix_0;


  hqm_pp_cq_status              i_hqm_pp_cq_status;     // common HQM PP/CQ status class - updated when sequence is completed
  hqm_cfg                       i_hqm_cfg;

  //-------------------------
  //Function: new 
  //-------------------------
  function new(string name = "hqm_msix_isr_seq");
    super.new(name); 
  endfunction
  
  extern virtual task body();
  extern virtual task comp_msix_cq_int();
  extern virtual task wdog_msix_cq_int();

  extern virtual task msix_cq_int();

endclass : hqm_msix_isr_seq

//-------------------------
//-- body
//-- file format: qtypecode, ppid, pool, is_rtncredonly, reord, frgnum, is_ldb_credit, is_carry_uhl, is_carry_tkn, is_multi_tkn
//-------------------------
task hqm_msix_isr_seq::body();
  uvm_object            o_tmp;
  uvm_sequencer_base    my_sequencer;

  // -- Get IM env
  `slu_assert($cast(im,slu_im_env::get_ptr()), ("Unable to get handle to IM."))

  my_sequencer = get_sequencer();

  if ($value$plusargs("HQM_MSIX_ISR_SEQ_CHK_WDOG_CQ=%d",wdog_cq_msix_int_en) == 0) begin
    wdog_cq_msix_int_en = 0;
  end 

  wdog_read_loop_num=1;
   $value$plusargs("HQM_MSIX_ISR_SEQ_CHK_WDOG_LOOP=%d",wdog_read_loop_num);

  //--08122022   `slu_assert($cast(ral, sla_ral_env::get_ptr()), ("Unable to get RAL handle"))
  `slu_assert($cast(ral, slu_ral_db::get_regmodel()), ("Unable to get RAL handle"))

  im.get_from_test("HQM_MSIX_INT", o_tmp);
  $cast(int_object, o_tmp);

  glbl_pool  = uvm_event_pool::get_global_pool();
  exp_msix_0 = glbl_pool.get($psprintf("hqm%s_exp_ep_msix_0",int_object.trigger_agent));

  //-----------------------------
  //-- get i_hqm_cfg
  //-----------------------------
  if (!my_sequencer.get_config_object({"i_hqm_cfg",int_object.trigger_agent}, o_tmp)) begin
    uvm_report_fatal(get_full_name(), $psprintf("Unable to find i_hqm_cfg%s object",int_object.trigger_agent));
  end 

  if (!$cast(i_hqm_cfg, o_tmp)) begin
    uvm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
  end    

  //-----------------------------
  //-- get i_hqm_pp_cq_status
  //-----------------------------
  if (!my_sequencer.get_config_object({"i_hqm_pp_cq_status",int_object.trigger_agent}, o_tmp)) begin
    uvm_report_fatal(get_full_name(), $psprintf("Unable to find i_hqm_pp_cq_status%s object",int_object.trigger_agent));
  end 

  if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
    uvm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
  end 

  msix_int_num  = int_object.intr_vector;
  msix_int_data = int_object.intr_type;

  `uvm_info(get_full_name(),$psprintf("MSIX interrupt %0d ISR sequence",msix_int_num),UVM_LOW)


  if (msix_int_num == 0) begin
    if (wdog_cq_msix_int_en > 0) begin
      wdog_msix_cq_int();
      exp_msix_0.trigger();
    end else begin
      i_hqm_pp_cq_status.put_msix_int(msix_int_num,msix_int_data);
    end 

   end else if (i_hqm_cfg.msix_mode) begin
    if (msix_int_num == 1) begin
      comp_msix_cq_int();
    end else begin
      `uvm_error(get_full_name(),$psprintf("MSIX interrupt %0d not expected when in compressed msix mode",msix_int_num))
    end 
  end else begin
    if ((msix_int_num > 0) && (msix_int_num < hqm_system_pkg::HQM_SYSTEM_NUM_MSIX)) begin
      msix_cq_int();
    end else begin
      `uvm_error(get_full_name(),$psprintf("Unsupported MSIX interrupt %0d",msix_int_num))
    end 
  end 
endtask : body

task hqm_msix_isr_seq::msix_cq_int();
  int   cq_num;
  int   cq_type;

  if (i_hqm_cfg.decode_msix_cq_int_addr(msix_int_num, cq_num, cq_type)) begin
    i_hqm_pp_cq_status.put_cq_int(cq_type,cq_num,msix_int_data);
  end else begin
    `uvm_error(get_full_name(),$psprintf("NO CQs configured to use MSIX interrupt %0d",msix_int_num))
  end 
endtask : msix_cq_int

task hqm_msix_isr_seq::comp_msix_cq_int();
  uvm_reg_block         hqm_system_csr_file;
  uvm_reg               dir_cq_msix_status_reg[(hqm_pkg::NUM_DIR_CQ + 31)/32];
  uvm_reg               ldb_cq_msix_status_reg[(hqm_pkg::NUM_LDB_CQ + 31)/32];
  uvm_reg               msix_ack_reg;
  slu_ral_sai_t         cq_msix_status_legal_read_sai;
  slu_ral_sai_t         cq_msix_status_legal_write_sai;
  slu_ral_sai_t         msix_ack_legal_write_sai;

  uvm_reg_data_t        rdata;
  logic                 dir_cq_int_status[hqm_pkg::NUM_DIR_CQ];
  logic                 ldb_cq_int_status[hqm_pkg::NUM_LDB_CQ];
  string                primary_id;
  string                msix_1_ack_field_q[$];
  uvm_reg_data_t        msix_1_ack_field_val_q[$];
  uvm_status_e          status;

  `slu_assert($cast(hqm_system_csr_file, ral.get_block_by_name({"*",int_object.trigger_agent,".hqm_system_csr"})), ("cast error trying to get handle to hqm_system_csr."))

  foreach (dir_cq_msix_status_reg[i]) begin
    `slu_assert($cast(dir_cq_msix_status_reg[i], hqm_system_csr_file.get_reg_by_name($psprintf("DIR_CQ_%0d_%0d_OCC_INT_STATUS",(i * 32) + 31,i * 32))), ($psprintf("cast error trying to get handle to register DIR_CQ_%0d_%0d_OCC_INT_STATUS.",(i * 32) + 31,i * 32)))
  end 

  foreach (ldb_cq_msix_status_reg[i]) begin
    `slu_assert($cast(ldb_cq_msix_status_reg[i], hqm_system_csr_file.get_reg_by_name($psprintf("LDB_CQ_%0d_%0d_OCC_INT_STATUS",(i * 32) + 31,i * 32))), ($psprintf("cast error trying to get handle to register LDB_CQ_%0d_%0d_OCC_INT_STATUS.",(i * 32) + 31,i * 32)))
  end 

  `slu_assert($cast(msix_ack_reg, hqm_system_csr_file.get_reg_by_name("MSIX_ACK")), ("cast error trying to get handle to register MSIX_ACK."))

  //--08122022   cq_msix_status_legal_read_sai         = dir_cq_msix_status_reg[0].pick_legal_sai_value(RAL_READ);
  //--08122022   cq_msix_status_legal_write_sai        = dir_cq_msix_status_reg[0].pick_legal_sai_value(RAL_WRITE);
  //--08122022   msix_ack_legal_write_sai              = msix_ack_reg.pick_legal_sai_value(RAL_WRITE);

  msix_1_ack_field_q.delete();
  msix_1_ack_field_q.push_back("MSIX_1_ACK");

  msix_1_ack_field_val_q.delete();
  msix_1_ack_field_val_q.push_back(1);

  primary_id = i_hqm_cfg.ral_access_path;

  `uvm_info(get_full_name(),$psprintf("Received compressed msix CQ interrupt"),UVM_LOW)

  foreach (dir_cq_msix_status_reg[i]) begin
    //--08122022   dir_cq_msix_status_reg[i].read(status,rdata,primary_id,this,.sai(cq_msix_status_legal_read_sai));
    dir_cq_msix_status_reg[i].read(status, rdata, primary_id, .parent(this));
    for (int j = 0 ; j < 32 ; j++) begin
      if (((i * 32) + j) < hqm_pkg::NUM_DIR_CQ) begin
        dir_cq_int_status[(i * 32) + j] = rdata[j];
      end 
    end 

    if (rdata != 0) begin
      //--08122022   dir_cq_msix_status_reg[i].write(status,rdata,primary_id,this,.sai(cq_msix_status_legal_write_sai));
      dir_cq_msix_status_reg[i].write(status, rdata, primary_id, .parent(this));
    end 
  end 

  foreach (ldb_cq_msix_status_reg[i]) begin
    //--08122022   ldb_cq_msix_status_reg[i].read(status,rdata,primary_id,this,.sai(cq_msix_status_legal_read_sai));
    ldb_cq_msix_status_reg[i].read(status, rdata, primary_id, .parent(this));
    for (int j = 0 ; j < 32 ; j++) begin
      if (((i * 32) + j) < hqm_pkg::NUM_LDB_CQ) begin
        ldb_cq_int_status[(i * 32) + j] = rdata[j];
      end 
    end 

    if (rdata != 0) begin
      //--08122022   ldb_cq_msix_status_reg[i].write(status,rdata,primary_id,this,.sai(cq_msix_status_legal_write_sai));
      ldb_cq_msix_status_reg[i].write(status, rdata, primary_id, .parent(this));
    end 
  end 

  foreach (dir_cq_int_status[i]) begin
    if (dir_cq_int_status[i]) begin
      `uvm_info(get_full_name(),$psprintf("Compressed msix CQ interrupt - Setting DIR PP/CQ 0x%0x CQ interrupt", i),UVM_LOW)
      i_hqm_pp_cq_status.put_cq_int(0,i,0);
    end 
  end 

  foreach (ldb_cq_int_status[i]) begin
    if (ldb_cq_int_status[i]) begin
      `uvm_info(get_full_name(),$psprintf("Compressed msix CQ interrupt - Setting LDB PP/CQ 0x%0x CQ interrupt", i),UVM_LOW)
      i_hqm_pp_cq_status.put_cq_int(1,i,0);
    end 
  end 

  //--08122022   msix_ack_reg.write_fields(status,msix_1_ack_field_q,msix_1_ack_field_val_q,primary_id,this,.sai(msix_ack_legal_write_sai));
  slu_ral_db::write_fields(msix_ack_reg, msix_1_ack_field_q, status, msix_1_ack_field_val_q, primary_id);

endtask : comp_msix_cq_int

task hqm_msix_isr_seq::wdog_msix_cq_int();
  uvm_reg_block          hqm_system_csr_file;
  uvm_reg_block          credit_hist_pipe_file;
  uvm_reg           cfg_dir_wdto_reg[3];
  uvm_reg           cfg_dir_wd_disable_reg[3];
  uvm_reg           cfg_ldb_wdto_reg[2];
  uvm_reg           cfg_ldb_wd_disable_reg[2];
  uvm_reg           msix_ack_reg;
  uvm_reg           alarm_hw_synd_reg;
  slu_ral_sai_t         cfg_dir_wdto_legal_read_sai;
  slu_ral_sai_t         cfg_dir_wdto_legal_write_sai;
  slu_ral_sai_t         msix_ack_legal_write_sai;

  uvm_reg_data_t        rdata;
  uvm_reg_data_t        dir_wdto_reg_rdata[3];
  uvm_reg_data_t        ldb_wdto_reg_rdata[2];
  logic [95:0]          dir_cq_int_status;
  logic [63:0]          ldb_cq_int_status;
  string                primary_id;
  string                msix_0_ack_field_q[$];
  uvm_reg_data_t        msix_0_ack_field_val_q[$];
  bit                   do_msix_ack;
  uvm_status_e          status;

  `slu_assert($cast(hqm_system_csr_file,   ral.get_block_by_name({"*",int_object.trigger_agent,".hqm_system_csr"})),   ("cast error trying to get handle to hqm_system_csr."))
  `slu_assert($cast(credit_hist_pipe_file, ral.get_block_by_name({"*",int_object.trigger_agent,".credit_hist_pipe"})), ("cast error trying to get handle to credit_hist_pipe."))

  `slu_assert($cast(cfg_dir_wdto_reg[0], credit_hist_pipe_file.get_reg_by_name("CFG_DIR_WDTO_0")), ("cast error trying to get handle to register CFG_DIR_WDTO_0."))
  `slu_assert($cast(cfg_dir_wdto_reg[1], credit_hist_pipe_file.get_reg_by_name("CFG_DIR_WDTO_1")), ("cast error trying to get handle to register CFG_DIR_WDTO_1."))
  `slu_assert($cast(cfg_dir_wdto_reg[2], credit_hist_pipe_file.get_reg_by_name("CFG_DIR_WDTO_2")), ("cast error trying to get handle to register CFG_DIR_WDTO_2."))

  `slu_assert($cast(cfg_dir_wd_disable_reg[0], credit_hist_pipe_file.get_reg_by_name("CFG_DIR_WD_DISABLE0")), ("cast error trying to get handle to register CFG_DIR_WD_DISABLE0."))
  `slu_assert($cast(cfg_dir_wd_disable_reg[1], credit_hist_pipe_file.get_reg_by_name("CFG_DIR_WD_DISABLE1")), ("cast error trying to get handle to register CFG_DIR_WD_DISABLE1."))
  `slu_assert($cast(cfg_dir_wd_disable_reg[2], credit_hist_pipe_file.get_reg_by_name("CFG_DIR_WD_DISABLE2")), ("cast error trying to get handle to register CFG_DIR_WD_DISABLE2."))

  `slu_assert($cast(cfg_ldb_wdto_reg[0], credit_hist_pipe_file.get_reg_by_name("CFG_LDB_WDTO_0")), ("cast error trying to get handle to register CFG_LDB_WDTO_0."))
  `slu_assert($cast(cfg_ldb_wdto_reg[1], credit_hist_pipe_file.get_reg_by_name("CFG_LDB_WDTO_1")), ("cast error trying to get handle to register CFG_LDB_WDTO_1."))

  `slu_assert($cast(cfg_ldb_wd_disable_reg[0], credit_hist_pipe_file.get_reg_by_name("CFG_LDB_WD_DISABLE0")), ("cast error trying to get handle to register CFG_LDB_WD_DISABLE0."))
  `slu_assert($cast(cfg_ldb_wd_disable_reg[1], credit_hist_pipe_file.get_reg_by_name("CFG_LDB_WD_DISABLE1")), ("cast error trying to get handle to register CFG_LDB_WD_DISABLE1."))

  `slu_assert($cast(msix_ack_reg,      hqm_system_csr_file.get_reg_by_name("MSIX_ACK")),      ("cast error trying to get handle to register MSIX_ACK."))
  `slu_assert($cast(alarm_hw_synd_reg, hqm_system_csr_file.get_reg_by_name("ALARM_HW_SYND")), ("cast error trying to get handle to register ALARM_HW_SYND."))

  //--08122022   cfg_dir_wdto_legal_read_sai   = cfg_dir_wdto_reg[0].pick_legal_sai_value(RAL_READ);
  //--08122022   cfg_dir_wdto_legal_write_sai  = cfg_dir_wdto_reg[0].pick_legal_sai_value(RAL_WRITE);
  //--08122022   msix_ack_legal_write_sai      = msix_ack_reg.pick_legal_sai_value(RAL_WRITE);

  msix_0_ack_field_q.delete();
  msix_0_ack_field_q.push_back("MSIX_0_ACK");

  msix_0_ack_field_val_q.delete();
  msix_0_ack_field_val_q.push_back(1);

  do_msix_ack = 0;

  primary_id = i_hqm_cfg.ral_access_path;


 //-----Murali's FPGA flow
 //This is the procedure that works for this scenario:

 //1)	Receive MSI-X
 //2)	Read the LDB/DIR WDTO vectors
 //3)	Process the CQs with WDTO bits set
 //4)	Re-read the WDTO until it is 0x0 (no msi-x ack is given yet) � This will ensure we pick up any new WDTOs prior to issuing the ACK and do not need to wait for a new MSI-X. (as long there is at least one CQ is set then the IRQ handler is combining all the CQ events into one).  If 0x0 proceed to step 6.
 //5)	Process the new CQs (if any)
 //6)	Issue the MSI-X ack
 //7)	Re-Read the WDTO one more time to ensure that we pick up any new WDTO since step 4.  Any new CQ interrupts just after this will result in a new MSI-X  (due to step 6) so nothing is lost.
 //8)	Process the new CQs (if any).


  // delay to allow other CQ watchdog timeouts to occur
  repeat (wdog_cq_msix_int_en) @(slu_tb_env::sys_clk_r);
  ldb_cq_int_status = 0;
  dir_cq_int_status = 0;
  foreach(dir_wdto_reg_rdata[i]) dir_wdto_reg_rdata[i]=0;
  foreach(ldb_wdto_reg_rdata[i]) ldb_wdto_reg_rdata[i]=0;

  for(int loop=0; loop<=wdog_read_loop_num; loop++) begin
     `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ interrupt start loop=%0d", loop),UVM_LOW)

     foreach (cfg_dir_wdto_reg[i]) begin
       //`uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ DIR cfg_dir_wdto_reg 0x%0x ", i),UVM_LOW)
	//--08122022   cfg_dir_wdto_reg[i].read(status,rdata,primary_id,this,.sai(cfg_dir_wdto_legal_read_sai));
        cfg_dir_wdto_reg[i].read(status, rdata, primary_id, .parent(this));
        dir_wdto_reg_rdata[i]=rdata; 
       `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ DIR get: cfg_dir_wdto_reg[0x%0x].rdata = 0x%0x ", i, rdata),UVM_LOW)
	dir_cq_int_status[(i * 32) +: 32] = dir_cq_int_status[(i * 32) +: 32] | rdata[31:0];
       `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ DIR curr: dir_cq_int_status[0x%0x] = 0x%0x ", i,dir_cq_int_status[(i * 32) +: 32]),UVM_LOW)


       if (rdata != 0) begin
	 `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ DIR curr_status: cfg_dir_wdto_reg[0x%0x].rdata is 0x%0x and write to clear", i, rdata),UVM_LOW)
	  //--08122022   cfg_dir_wdto_reg[i].write(status,rdata,primary_id,this,.sai(cfg_dir_wdto_legal_write_sai));
	  //--08122022   cfg_dir_wd_disable_reg[i].write(status,rdata,primary_id,this,.sai(cfg_dir_wdto_legal_write_sai));
          cfg_dir_wdto_reg[i].write(status, rdata, primary_id, .parent(this));
          cfg_dir_wd_disable_reg[i].write(status, rdata, primary_id, .parent(this));
       end 
     end 

     foreach (cfg_ldb_wdto_reg[i]) begin
       //`uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ LDB cfg_ldb_wdto_reg 0x%0x ", i),UVM_LOW)
	//--08122022   cfg_ldb_wdto_reg[i].read(status,rdata,primary_id,this,.sai(cfg_dir_wdto_legal_read_sai));
        cfg_ldb_wdto_reg[i].read(status, rdata, primary_id, .parent(this));
        ldb_wdto_reg_rdata[i]=rdata; 
       `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ LDB get: cfg_ldb_wdto_reg[0x%0x].rdata = 0x%0x ", i, rdata),UVM_LOW)
	ldb_cq_int_status[(i * 32) +: 32] =  ldb_cq_int_status[(i * 32) +: 32] | rdata[31:0];
       `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ LDB curr: ldb_cq_int_status[0x%0x] = 0x%0x ", i,ldb_cq_int_status[(i * 32) +: 32]),UVM_LOW)

       if (rdata != 0) begin
	 `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ LDB curr_status: cfg_ldb_wdto_reg[0x%0x].rdata is 0x%0x and write to clear", i, rdata),UVM_LOW)
	  //--08122022   cfg_ldb_wdto_reg[i].write(status,rdata,primary_id,this,.sai(cfg_dir_wdto_legal_write_sai));
	  //--08122022   cfg_ldb_wd_disable_reg[i].write(status,rdata,primary_id,this,.sai(cfg_dir_wdto_legal_write_sai));
          cfg_ldb_wdto_reg[i].write(status, rdata, primary_id, .parent(this));
          cfg_ldb_wd_disable_reg[i].write(status, rdata, primary_id, .parent(this));
       end 
     end 
     
     foreach (dir_cq_int_status[i]) begin 
        if (dir_cq_int_status[i]) begin
         `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ DIR collect: dir_cq_int_status[0x%0x] get wdog", i),UVM_LOW) 
          do_msix_ack = 1;
        end 
     end 

     foreach (ldb_cq_int_status[i]) begin 
        if (ldb_cq_int_status[i]) begin 
         `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ LDB collect: ldb_cq_int_status[0x%0x] get wdog", i),UVM_LOW) 	
          do_msix_ack = 1;
        end 
     end     

     if(ldb_wdto_reg_rdata[0]==0 && ldb_wdto_reg_rdata[1]==0 && dir_wdto_reg_rdata[0]==0 && dir_wdto_reg_rdata[1]==0 && dir_wdto_reg_rdata[2]==0 && loop > 5) begin
       `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ interrupt break, end at loop=%0d", loop),UVM_LOW)
       break;
     end else begin
       `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ interrupt end loop=%0d", loop),UVM_LOW)
     end 
  end //--for(loop


  //----------- hqm_pp_cq_status.put_cq_int()
  //----------- MSIX.ACK
  `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ interrupt do_msix_ack=%0d", do_msix_ack),UVM_LOW)
  if (do_msix_ack) begin
     foreach (dir_cq_int_status[i]) begin
        if (dir_cq_int_status[i]) begin
         //`uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ DIR collect: dir_cq_int_status[0x%0x] ", i),UVM_LOW)
         `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ DIR Watchdog CQ interrupt - Setting DIR PP/CQ 0x%0x CQ interrupt", i),UVM_LOW)
          i_hqm_pp_cq_status.put_cq_int(0,i,0);
        end 
     end 

     foreach (ldb_cq_int_status[i]) begin
        if (ldb_cq_int_status[i]) begin
         `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: CQ LDB Watchdog CQ interrupt - Setting LDB PP/CQ 0x%0x CQ interrupt", i),UVM_LOW)
          i_hqm_pp_cq_status.put_cq_int(1,i,0);
        end 
     end 

    `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int: do_msix_ack:: write to ALARM_HW_SYND and MSIX_ACK "),UVM_LOW)
     //--08122022   alarm_hw_synd_reg.write(status,'h80000000,primary_id,this,.sai(msix_ack_legal_write_sai));
     //--08122022   msix_ack_reg.write_fields(status,msix_0_ack_field_q,msix_0_ack_field_val_q,primary_id,this,.sai(msix_ack_legal_write_sai));
     alarm_hw_synd_reg.write(status, 'h80000000, primary_id, .parent(this));
     slu_ral_db::write_fields(msix_ack_reg, msix_0_ack_field_q, status, msix_0_ack_field_val_q, primary_id);
  end 

  //-----------After sending MSIX.ACK, do one more read to  
  //-----------7)	Re-Read the WDTO one more time to ensure that we pick up any new WDTO 
     ldb_cq_int_status = 0;
     dir_cq_int_status = 0;
     `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ interrupt start cleanup"),UVM_LOW)

     foreach (cfg_dir_wdto_reg[i]) begin
       `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ DIR cfg_dir_wdto_reg 0x%0x ", i),UVM_LOW)
	//--08122022   cfg_dir_wdto_reg[i].read(status,rdata,primary_id,this,.sai(cfg_dir_wdto_legal_read_sai));
        cfg_dir_wdto_reg[i].read(status, rdata, primary_id, .parent(this));
       `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ DIR get: cfg_dir_wdto_reg[0x%0x].rdata = 0x%0x ", i, rdata),UVM_LOW)
	dir_cq_int_status[(i * 32) +: 32] = dir_cq_int_status[(i * 32) +: 32] | rdata[31:0];
       `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ DIR curr: dir_cq_int_status[0x%0x] = 0x%0x ", i,dir_cq_int_status[(i * 32) +: 32]),UVM_LOW)

       if (rdata != 0) begin
	 `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ DIR curr_status: cfg_dir_wdto_reg[0x%0x].rdata is 0x%0x and write to clear", i, rdata),UVM_LOW)
	  //--08122022   cfg_dir_wdto_reg[i].write(status,rdata,primary_id,this,.sai(cfg_dir_wdto_legal_write_sai));
	  //--08122022   cfg_dir_wd_disable_reg[i].write(status,rdata,primary_id,this,.sai(cfg_dir_wdto_legal_write_sai));
       end 
     end 

     foreach (cfg_ldb_wdto_reg[i]) begin
       `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ LDB cfg_ldb_wdto_reg 0x%0x ", i),UVM_LOW)
	//--08122022   cfg_ldb_wdto_reg[i].read(status,rdata,primary_id,this,.sai(cfg_dir_wdto_legal_read_sai));
        cfg_ldb_wdto_reg[i].read(status, rdata, primary_id, .parent(this));
       `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ LDB get: cfg_ldb_wdto_reg[0x%0x].rdata = 0x%0x ", i, rdata),UVM_LOW)
	ldb_cq_int_status[(i * 32) +: 32] =  ldb_cq_int_status[(i * 32) +: 32] | rdata[31:0];
       `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ LDB curr: ldb_cq_int_status[0x%0x] = 0x%0x ", i,ldb_cq_int_status[(i * 32) +: 32]),UVM_LOW)

       if (rdata != 0) begin
	 `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ LDB curr_status: cfg_ldb_wdto_reg[0x%0x].rdata is 0x%0x and write to clear", i, rdata),UVM_LOW)
	  //--08122022   cfg_ldb_wdto_reg[i].write(status,rdata,primary_id,this,.sai(cfg_dir_wdto_legal_write_sai));
	  //--08122022   cfg_ldb_wd_disable_reg[i].write(status,rdata,primary_id,this,.sai(cfg_dir_wdto_legal_write_sai));
       end 
     end 
     
     foreach (dir_cq_int_status[i]) begin 
        if (dir_cq_int_status[i]) begin
         `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ DIR collect: dir_cq_int_status[0x%0x] get wdog", i),UVM_LOW) 
         `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ DIR Watchdog CQ interrupt - Setting DIR PP/CQ 0x%0x CQ interrupt", i),UVM_LOW)
          i_hqm_pp_cq_status.put_cq_int(0,i,0);
        end 
     end 

     foreach (ldb_cq_int_status[i]) begin 
        if (ldb_cq_int_status[i]) begin 
         `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ LDB collect: ldb_cq_int_status[0x%0x] get wdog", i),UVM_LOW) 	
         `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ LDB Watchdog CQ interrupt - Setting LDB PP/CQ 0x%0x CQ interrupt", i),UVM_LOW)
          i_hqm_pp_cq_status.put_cq_int(1,i,0);
          do_msix_ack = 1;
        end 
     end     
     `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ interrupt end cleanup"),UVM_LOW)

  `uvm_info(get_full_name(),$psprintf("wdog_msix_cq_int_S2: CQ interrupt done"),UVM_LOW)
endtask : wdog_msix_cq_int
