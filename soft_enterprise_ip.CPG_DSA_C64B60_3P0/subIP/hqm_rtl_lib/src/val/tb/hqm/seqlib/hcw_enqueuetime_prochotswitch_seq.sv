`ifndef HCW_ENQUEUETIME_PROCHOTSWITCH_SEQ__SV
`define HCW_ENQUEUETIME_PROCHOTSWITCH_SEQ__SV

//----------------------------------------------------------------------------------------------------------------------------//
// INTENT OF THE SEQUENCE : 
// Send 100 HCWs with and without prochot pin being asserted to find the multiplier in performance 
// cfg_prochot_disable when set the prochot behaviour will not be seen even though the Prochot pin is set. The 
// performance is checked with and without cfg_prochot_disable being set.
//----------------------------------------------------------------------------------------------------------------------------//
class hcw_enqueuetime_prochotswitch_seq extends hqm_base_seq;


  `ovm_sequence_utils(hcw_enqueuetime_prochotswitch_seq, sla_sequencer)



      bit            is_ldb;
      bit [7:0]      dqid[hqm_pkg::NUM_DIR_CQ];
      bit [7:0]      lqid[hqm_pkg::NUM_LDB_QID];
      bit [9:0]      nhcw;
      bit [63:0]     cnt_val;
      bit [63:0]     cnt_value;
      bit [31:0]     counter;
      bit            status_bit;
      sla_ral_env                   ral;
      sla_ral_data_t            read_val[1]; 
      int unsigned iteration = 1;
      int unsigned factor ;
      int unsigned rate   ;
      int          prochot_disable;
      int          count = 0;
      sla_ral_data_t   rd_data;
      sla_ral_data_t   read_data;
      hqm_tb_env                    hqm_env;
      virtual hqm_misc_if           pins;
      realtime         goldtime;
      realtime         prochotentime;
      realtime         prochotdistime;
      realtime         endtime;
      realtime         starttime;
      realtime         expectedtime; 
      realtime         prochot_mode_on_1,prochot_mode_on_2,prochot_mode_on_3;
      realtime         prochot_mode_off_1,prochot_mode_off_2;
      extern task                      body();
      extern task                      prochot_check();
      extern task                      iterative();
      extern task                      cfg_prochot_disable_check();
      extern task                      status_check(input bit pm_status , input bit [1:0] prochot_event_cnt);
      extern task                      time_check(input realtime time1, input realtime time2, input bit [1:0] quantifier);
function new(string name = "hcw_enqueuetime_prochotswitch_seq");
  super.new(name);

    `sla_assert( $cast(hqm_env,   sla_utils::get_comp_by_name("i_hqm_tb_env")), (("Could not find i_hqm_tb_env\n")));
    if(hqm_env   == null) `ovm_error(get_full_name(),$psprintf("i_hqm_tb_env ptr is null")) else 
                          `ovm_info(get_full_name(),$psprintf("i_hqm_tb_env ptr is not null"),OVM_MEDIUM) 

   `sla_assert( $cast(pins, hqm_env.pins),  (("Could not find hqm_misc_if pointer \n")));
    if(pins      == null) `ovm_error(get_full_name(),$psprintf("hqm_misc_if ptr is null"))    else
                          `ovm_info(get_full_name(),$psprintf("hqm_misc_if ptr is not null"),OVM_MEDIUM)   

    prochot_disable=0;
    $value$plusargs("hqm_prochot_disable=%d",prochot_disable);
endfunction

endclass : hcw_enqueuetime_prochotswitch_seq

task hcw_enqueuetime_prochotswitch_seq::body();

    ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);
    get_hqm_cfg();

    // -- Start traffic with the default bus number for VF and PF
    ovm_report_info(get_full_name(), $psprintf("Starting traffic on HQM "), OVM_MEDIUM);

     // -- get the DIR/PP QID Number
     for (int i=0;i<1;i++) begin //:dir_qid num
        if (i_hqm_cfg.get_name_val($psprintf("DQID%0d",i),dqid[i])) begin
          `ovm_info(get_full_name(), $psprintf("Logical DIR PP %0d maps to physical PP %0d",i,dqid[i]),OVM_DEBUG)
        end else begin
         `ovm_error(get_full_name(), $psprintf("DQID%0d name not found in hqm_cfg",i))
        end
     end //:dir_qid_num 
      wait_for_clk(100);
       if($test$plusargs("TGL_CFG_PROCHOT_DISABLED"))begin
          cfg_prochot_disable_check();
       end
       else begin
          prochot_check();
       end
  endtask: body





task hcw_enqueuetime_prochotswitch_seq::prochot_check();

      ovm_report_info(get_full_name(), $psprintf(" --prochot_check start task and iteration:%d; prochot_disable=%0d",iteration, prochot_disable), OVM_MEDIUM);
//without prochot enable
//sample ref time
      
         iterative();
         goldtime=expectedtime;
         ovm_report_info(get_full_name(), $psprintf(" goldtime:%0t",goldtime), OVM_MEDIUM);

//reg_time2
//enable prochot 
      pins.prochot=1 ;
//with prochot enable 
           
      ovm_report_info(get_full_name(), $psprintf(" --prochot_check start task with prochot enable and iteration:%d",iteration), OVM_MEDIUM);
      iterative();
      prochotentime=expectedtime;
      ovm_report_info(get_full_name(), $psprintf(" prochotentime:%0t",prochotentime), OVM_MEDIUM);

  
//prochot disable
      pins.prochot= 0;
      
      
//without prochot 

  ovm_report_info(get_full_name(), $psprintf(" --prochot_check start task without prochot enable and iteration:%d; prochot_disable=%0d",iteration, prochot_disable), OVM_MEDIUM);
  iterative();  
  prochotdistime=expectedtime;
  ovm_report_info(get_full_name(), $psprintf(" prochotdistime:%0t",prochotdistime), OVM_MEDIUM);

  factor= prochotentime/goldtime ;
  rate  =prochotdistime/goldtime ;
  
  ovm_report_info(get_full_name(), $psprintf("factor:%0d,rate:%0d",factor,rate), OVM_MEDIUM);
  if(prochot_disable==0) begin
     if(prochotentime > (5*goldtime))
        ovm_report_info(get_full_name(), $psprintf("prochotentime is 5 times more than the golden time "), OVM_MEDIUM);
     else
       `ovm_error(get_full_name(), $psprintf("prochot functionality error "))

     if(prochotdistime < (2*goldtime))
         ovm_report_info(get_full_name(), $psprintf("distime is less than twice golden"), OVM_MEDIUM);
     else
       `ovm_error(get_full_name(), $psprintf("prochot functionality error prochot_disable=0"))
  end else begin
       if((prochotentime < ((1.5)*goldtime)) || (prochotentime > ((1.5)*goldtime)))
         ovm_report_info(get_full_name(), $psprintf("prochotentime is 1.5 times less/more than the golden time "), OVM_MEDIUM);
       else
        `ovm_error(get_full_name(), $psprintf("prochot functionality error when prochot_disable=1 "))
       if((prochotdistime < ((1.5)*goldtime)) || (prochotdistime > ((1.5)*goldtime)))
         ovm_report_info(get_full_name(), $psprintf("prochotdistime is 1.5 times less/more than the golden time "), OVM_MEDIUM);
       else
        `ovm_error(get_full_name(), $psprintf("prochot functionality error when prochot_disable=1 "))
  end
  
endtask:prochot_check
//-----------------------------------------------------------------------------------//
//cfg_prochot_disable when set, the register bit config_master.cfg_pm_status.prochot 
//readout will be 0 even though prochot input port is 1’b1
//
//This task verifies the prochot behaviour while toggling cfg_prochot_disable bit.
//-----------------------------------------------------------------------------------//
task hcw_enqueuetime_prochotswitch_seq::cfg_prochot_disable_check();
//Prochot pin enabled throughout and cfg_prochot_disable follows the pattern 0->1->0->1->0
//Prochot Pin is set to 1
    pins.prochot=1 ;
    write_fields("cfg_control_general",{"CFG_PROCHOT_DISABLE"},{1'b0},"config_master");
    iterative();
    prochot_mode_on_1=expectedtime;
    status_check(.pm_status(1),.prochot_event_cnt(2'h1));
    count++;

    write_fields("cfg_control_general",{"CFG_PROCHOT_DISABLE"},{1'b1},"config_master");
    iterative();
    prochot_mode_off_1=expectedtime;
    status_check(.pm_status(0),.prochot_event_cnt(2'h1));
    time_check(prochot_mode_on_1,prochot_mode_off_1,10);
    count++;

    write_fields("cfg_control_general",{"CFG_PROCHOT_DISABLE"},{1'b0},"config_master");
    iterative();
    prochot_mode_on_2=expectedtime;
    status_check(.pm_status(1),.prochot_event_cnt(2'h2));
    time_check(prochot_mode_off_1,prochot_mode_on_2,01);
    time_check(prochot_mode_on_1,prochot_mode_on_2,11);
    count++;

    write_fields("cfg_control_general",{"CFG_PROCHOT_DISABLE"},{1'b1},"config_master");
    iterative();
    prochot_mode_off_2=expectedtime;
    status_check(.pm_status(0),.prochot_event_cnt(2'h2));
    time_check(prochot_mode_on_2,prochot_mode_off_2,10);
    time_check(prochot_mode_off_1,prochot_mode_off_2,11);
    count++;

    write_fields("cfg_control_general",{"CFG_PROCHOT_DISABLE"},{1'b0},"config_master");
    iterative();
    prochot_mode_on_3=expectedtime;
    status_check(.pm_status(1),.prochot_event_cnt(2'h3));
    time_check(prochot_mode_off_2,prochot_mode_on_3,01);
    time_check(prochot_mode_on_2,prochot_mode_on_3,11);
    count++;
  
    ovm_report_info(get_full_name(), $psprintf("prochot_mode_on_1:%0t,prochot_mode_off_1:%0t,prochot_mode_on_2:%0t,prochot_mode_off_2:%0t,prochot_mode_on_3:%0t",prochot_mode_on_1,prochot_mode_off_1,prochot_mode_on_2,prochot_mode_off_2,prochot_mode_on_3),OVM_MEDIUM);
    if((prochot_mode_on_1 > (5*prochot_mode_off_1)) && (prochot_mode_on_2 > (5*prochot_mode_off_1)) && (prochot_mode_on_2 > (5*prochot_mode_off_2)) && (prochot_mode_on_3 > 5*prochot_mode_off_2))begin
         ovm_report_info(get_full_name(), $psprintf("prochot functionality is proper "), OVM_MEDIUM);
    end else begin
        `ovm_error(get_full_name(), $psprintf("prochot functionality error"))
    end

endtask:cfg_prochot_disable_check

task hcw_enqueuetime_prochotswitch_seq::status_check(input bit pm_status, input bit [1:0] prochot_event_cnt);

    read_reg("cfg_prochot_cnt_l",rd_data,"config_master");
    cnt_val[31:0] = rd_data[31:0];
    read_reg("cfg_prochot_cnt_h",rd_data,"config_master");
    cnt_val[63:32] = rd_data[31:0];
    if(count == 0)begin
      if(cnt_val[31:0] !=0)begin
         ovm_report_info(get_full_name(), $psprintf("prochot_cnt:0x%0x is incrementing when cfg_prochot_disable=0 and count:%0d",cnt_val,count), OVM_MEDIUM);
         counter[31:0]=cnt_val[31:0];
      end
      else begin
        `ovm_error(get_full_name(), $psprintf("prochot_cnt:0x%0x is not incrementing when cfg_prochot_disable=0 and count:%0d",cnt_val,count))
      end
    end else begin
        if((cnt_val[31:0] != 0) && (cnt_val[31:0] > counter[31:0]))begin
         ovm_report_info(get_full_name(), $psprintf("prochot_cnt:0x%0x is incrementing when cfg_prochot_disable=0 and count:%0d",cnt_val,count), OVM_MEDIUM);
         counter[31:0] = cnt_val[31:0];
        end
        else begin
         `ovm_error(get_full_name(), $psprintf("prochot_cnt:0x%0x is not incrementing when cfg_prochot_disable=0 and count:%0d",cnt_val,count))
        end
     end
    ovm_report_info(get_full_name(), $psprintf("cfg_prochot_cnt counter value is :0x%0x",cnt_val), OVM_MEDIUM);
    read_reg("cfg_prochot_event_cnt_l",read_data,"config_master");
    cnt_value[31:0] = read_data[31:0];
    read_reg("cfg_prochot_event_cnt_h",read_data,"config_master");
    cnt_value[63:32] = read_data[31:0];
    if(cnt_value[31:0] == prochot_event_cnt)begin
      ovm_report_info(get_full_name(), $psprintf("prochot_event_cnt:0x%0x matches with the desired",prochot_event_cnt), OVM_MEDIUM);
    end else begin
      `ovm_error(get_full_name(), $psprintf("prochot_event_cnt:0x%0x does not match with the desired and count:%0d",prochot_event_cnt,count))
    end
    ovm_report_info(get_full_name(), $psprintf("cfg_prochot_event_cnt counter value is :0x%0x",cnt_value), OVM_MEDIUM);
    compare_fields("cfg_pm_status",{"PROCHOT"},pm_status ? {1} : {0} ,read_val,"config_master");

endtask:status_check

task hcw_enqueuetime_prochotswitch_seq::time_check(input realtime time1 , input realtime time2 , input bit [1:0] quantifier);

    case(quantifier)
    2'b10: if(5*time2 < time1)begin
         ovm_report_info(get_full_name(), $psprintf("case 0x%0x: prochot functionality is correct (time1 > 5*time2) time1:%0t and time2:%0t count=%0d ",quantifier,time1,time2,count), OVM_MEDIUM);
       end else begin 
         `ovm_error(get_full_name(), $psprintf("case 0x%0x: time1 is not 5 times of time2 (time1 > 5*time2) time1:%0t , time2:%0t and count=%0d ",quantifier,time1,time2,count))
       end
    2'b01: if(time2 > 5*time1)begin
         ovm_report_info(get_full_name(), $psprintf("case 0x%0x: prochot functionality is correct (time2 > 5*time1) time1:%0t and time2:%0t count=%0d ",quantifier,time1,time2,count), OVM_MEDIUM);
       end else begin 
         `ovm_error(get_full_name(), $psprintf("case 0x%0x: time2 is not 5 times of time1 (time2 > 5*time1) time1:%0t , time2:%0t and count=%0d",quantifier,time1,time2,count))
       end
    2'b11: if(((time1 > (1*time2)) && (time1 < (1.5*time2))) || ((time2 > (1*time1)) && (time2 < (1.5*time1))) || (time1 == time2)) begin
         ovm_report_info(get_full_name(), $psprintf("case 0x%0x: prochot functionality is correct (time1 = time2) time1:%0t and time2:%0t count=%0d ",quantifier,time1,time2,count), OVM_MEDIUM);
       end else begin 
         `ovm_error(get_full_name(), $psprintf("case 0x%0x: time2 is not equal to time1 (time1 != time2) time1:%0t, time2:%0t and count=%0d",quantifier,time1,time2,count))
       end
    default:
         `ovm_error(get_full_name(), $psprintf("None of the above scenario is true"))
    endcase
endtask

task hcw_enqueuetime_prochotswitch_seq::iterative();

      nhcw=100;
      starttime=($realtime);
      send_new_pf(.pp_num(dqid[0]), .qid(dqid[0]), .rpt(nhcw), .is_ldb(0));
      execute_cfg_cmds();
      poll_sch( .cq_num(dqid[0]), .exp_cnt(nhcw*iteration), .is_ldb(0) ); 
      send_bat_t_pf(.pp_num(dqid[0]), .tkn_cnt(nhcw-1), .is_ldb(0));
      poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[0]), 'h0, "credit_hist_pipe");  
      iteration++;
      endtime=($realtime);
      expectedtime=(endtime-starttime);
endtask:iterative
  
`endif
