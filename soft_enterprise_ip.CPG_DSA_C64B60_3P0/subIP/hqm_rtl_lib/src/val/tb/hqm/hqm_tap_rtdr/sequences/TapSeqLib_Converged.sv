//------------------------------------------------------------------------------
//  %header_copyright%
//
//  Collateral Description:
//  dteg-jtag_bfm
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  CHASSIS_JTAGBFM_2018WW12_R3.3
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2018 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : TapSequences.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : Sequences for the ENV 
//    DESCRIPTION : This Component defines various sequences that are 
//                  needed to drive and test the DUT including the Random
//------------------------------------------------------------------------
//------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------
// Sequence to do a Power Good and TRST_B resets 
//-----------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------
class TapSequencePrimaryOnly extends JtagBfmPkg::JtagBfmSequences#(ovm_sequence_item);

    function new(string name = "TapSequencePrimaryOnly");
        super.new(name);
    endfunction : new

    `ovm_sequence_utils(TapSequencePrimaryOnly, JtagBfmPkg::JtagBfmSequencer)

    virtual task body();
      Idle(30);
      Idle(30);
      Idle(30);
      Idle(30);
      //ForceClockGatingOff(1'b1);
      //Reset(2'b11);
      //All In Primary
      MultipleTapRegisterAccess(2'b00,8'h00,8'h00,8,8);

      //All Normal
      MultipleTapRegisterAccess(2'b00,8'h00,16'haaaa,8,16);
      //MultipleTapRegisterAccess(2'b00,8'h14,1'b1,8,1);
      
      //All Bypass
      MultipleTapRegisterAccess(2'b00,56'h_FF_FF_FF_FF_FF_FF_FF,64'h0000_0000_0000_0000,56,64);
      //ForceClockGatingOff(1'b0);
      Idle(3000);
      MultipleTapRegisterAccess(2'b00,56'h_FF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,56,64);
      //ForceClockGatingOff(1'b0);
      Idle(3000);

      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'h0000_0000_0000_0000,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,56,64);
      
      //All In Primary
      MultipleTapRegisterAccess(2'b00,8'h10,8'h00,8,8);

      //All Normal
      MultipleTapRegisterAccess(2'b00,8'h11,16'h5555,8,16);

      //All Bypass
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'h0000_0000_0000_0000,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,56,64);

      //All Register Access ADDR A0
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'h0000_0000_0000_0000,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'h5555_5555_5555_5555,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'h5555_5555_5555_5555,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'hAAAA_AAAA_AAAA_AAAA,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'hAAAA_AAAA_AAAA_AAAA,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'hFFFF_FFFF_FFFF_FFFF,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'hFFFF_FFFF_FFFF_FFFF,56,64);
      //All Register Access ADDR Ax
      MultipleTapRegisterAccess(2'b00,56'h02_0C_0C_0C_0C_0C_0C,224'h0000_0000_0000_0000,56,224);

//      LoadIR_idle(2'b00,16'hFF_FF,16'h01_01,16'hFFFF,16);
//      //Goto(RUTI,1);
//      LoadDR_idle(2'b00,32'h0123_4567,32'h048D_159C,32'hFFFF_FFFF,32);
//      //Goto(RUTI,1);
//      LoadIR(2'b00,16'h0F_0F,16'h01_01,16'hFFFF,16);
//      Goto(E2IR,1);
//      tms_tdi_stream(22'h3E0000,22'h0,22);
//      ExpData_MultipleTapRegisterAccess(2'b00,8'h11,8,16'hFFFD,16'h0000,16'hFFFF,16);
//      Goto(RUTI,1);
//      ExpData_MultipleTapRegisterAccess(2'b00,16'hFF_FF,16,32'hFFFF_FFFF,32'hFFFF_FFFC,32'hFFFF_FFFF,32);
      `ovm_info(get_type_name(),"TapSequencePrimaryOnly Completed",OVM_NONE); 
      Idle(1000);

    endtask : body

endclass : TapSequencePrimaryOnly

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
class TapDataLoadSeq_T0 extends JtagBfmPkg::JtagBfmSequences#(ovm_sequence_item);
    int fdfx_secure_policy_value;
    int secure_policy_enabled;
    int fdfx_secure_policy_value_2nd;
    int secure_policy_enabled_2nd;
    int task2_wait_num;

    bit [7:0] rtdr_addr;
    bit[31:0] rtdr_data, exp_rtdr_data, mask_rtdr_data, rtdr_tdo_data;

    bit[31:0] rtdr_data0_0;
    bit[31:0] rtdr_data0_1;
    bit[31:0] rtdr_data0_2;
    bit[31:0] rtdr_data0_3;
    bit[31:0] rtdr_data1_0;
    bit[31:0] rtdr_data1_1;
    bit[31:0] rtdr_data1_2;
    bit[31:0] rtdr_data1_3;
    bit[31:0] rtdr_data1_4;
    bit[31:0] rtdr_data1_5;
    bit[31:0] rtdr_data1_6;
    bit[31:0] rtdr_data1_7;
    bit[31:0] rtdr_data2_0;
    bit[31:0] rtdr_data2_1;
    bit[31:0] rtdr_data2_2;
    bit[31:0] rtdr_data2_3;
    bit[31:0] rtdr_data2_4;
    bit[31:0] rtdr_data2_5;
    bit[31:0] rtdr_data2_6;
    bit[31:0] rtdr_data2_7;
    int rtdr_data2_2nd;
    int rtdr_data2_3rd;
    int rtdr_data2_4th;

    bit[2:0]  tapconfig_view_sel0, tapconfig_view_sel1; 

    int rtdr_reg0_cfg_wait_num0, rtdr_reg0_cfg_wait_num1;
    int rtdr_reg1_cfg_wait_num0, rtdr_reg1_cfg_wait_num1, rtdr_reg1_cfg_wait_num2, rtdr_reg1_cfg_wait_num3, rtdr_reg1_cfg_wait_num4;
    int rtdr_reg2_cfg_wait_num0;
 

///////////////////////////////////////////////////////////////////////////////////////////    
function new(string name = "TapDataLoadSeq_T0");
        super.new(name);
        fdfx_secure_policy_value = 0;
        $value$plusargs("HQM_FDFX_SECURE_POLICY_CTRL=%d", fdfx_secure_policy_value);

        //--01082020 RTL has been changed on secure_policy, any color is able to access via RTDR interface
        if(fdfx_secure_policy_value==2 || fdfx_secure_policy_value==4 || fdfx_secure_policy_value==7) secure_policy_enabled = 1;
        else secure_policy_enabled=1;

        task2_wait_num = 200;
        $value$plusargs("HQM_FDFX_SECURE_POLICY_CTRL_2_wait=%d", task2_wait_num);

        fdfx_secure_policy_value_2nd = 0;
        $value$plusargs("HQM_FDFX_SECURE_POLICY_CTRL_2=%d", fdfx_secure_policy_value_2nd);
        if(fdfx_secure_policy_value_2nd==2 || fdfx_secure_policy_value_2nd==4 || fdfx_secure_policy_value_2nd==7) secure_policy_enabled_2nd = 1;
        else secure_policy_enabled_2nd=1;


       `ovm_info(get_type_name(),$psprintf("Set fdfx_secure_policy_value=%0d secure_policy_enabled=%0d task2_wait_num=%0d secure_policy_enabled_2nd=%0d",fdfx_secure_policy_value, secure_policy_enabled, task2_wait_num, secure_policy_enabled_2nd),OVM_LOW)

        $value$plusargs("HQM_RTDR_DATA0_0=%x", rtdr_data0_0);
        $value$plusargs("HQM_RTDR_DATA0_1=%x", rtdr_data0_1);
        $value$plusargs("HQM_RTDR_DATA0_2=%x", rtdr_data0_2);
        $value$plusargs("HQM_RTDR_DATA0_3=%x", rtdr_data0_3);
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data0_0=0x%0x",rtdr_data0_0),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data0_1=0x%0x",rtdr_data0_1),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data0_2=0x%0x",rtdr_data0_2),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data0_3=0x%0x",rtdr_data0_3),OVM_LOW)


        $value$plusargs("HQM_RTDR_DATA1_0=%x", rtdr_data1_0);
        $value$plusargs("HQM_RTDR_DATA1_1=%x", rtdr_data1_1);
        $value$plusargs("HQM_RTDR_DATA1_2=%x", rtdr_data1_2);
        $value$plusargs("HQM_RTDR_DATA1_3=%x", rtdr_data1_3);
        $value$plusargs("HQM_RTDR_DATA1_4=%x", rtdr_data1_4);
        $value$plusargs("HQM_RTDR_DATA1_5=%x", rtdr_data1_5);
        $value$plusargs("HQM_RTDR_DATA1_6=%x", rtdr_data1_6);
        $value$plusargs("HQM_RTDR_DATA1_7=%x", rtdr_data1_7);

      if ($test$plusargs("has_tapconfig_rand_task")) begin
            tapconfig_view_sel0=$urandom_range(0, 7);
            tapconfig_view_sel1=$urandom_range(0, 7);
            rtdr_data1_0[7:5]   = tapconfig_view_sel0;
            rtdr_data1_0[10:8]  = tapconfig_view_sel1;

            tapconfig_view_sel0=$urandom_range(0, 7);
            tapconfig_view_sel1=$urandom_range(0, 7);
            rtdr_data1_1[7:5]   = tapconfig_view_sel0;
            rtdr_data1_1[10:8]  = tapconfig_view_sel1;

            tapconfig_view_sel0=$urandom_range(0, 7);
            tapconfig_view_sel1=$urandom_range(0, 7);
            rtdr_data1_2[7:5]   = tapconfig_view_sel0;
            rtdr_data1_2[10:8]  = tapconfig_view_sel1;

            tapconfig_view_sel0=$urandom_range(0, 7);
            tapconfig_view_sel1=$urandom_range(0, 7);
            rtdr_data1_3[7:5]   = tapconfig_view_sel0;
            rtdr_data1_3[10:8]  = tapconfig_view_sel1;

            tapconfig_view_sel0=$urandom_range(0, 7);
            tapconfig_view_sel1=$urandom_range(0, 7);
            rtdr_data1_4[7:5]   = tapconfig_view_sel0;
            rtdr_data1_4[10:8]  = tapconfig_view_sel1;

            tapconfig_view_sel0=$urandom_range(0, 7);
            tapconfig_view_sel1=$urandom_range(0, 7);
            rtdr_data1_5[7:5]   = tapconfig_view_sel0;
            rtdr_data1_5[10:8]  = tapconfig_view_sel1;

            tapconfig_view_sel0=$urandom_range(0, 7);
            tapconfig_view_sel1=$urandom_range(0, 7);
            rtdr_data1_6[7:5]   = tapconfig_view_sel0;
            rtdr_data1_6[10:8]  = tapconfig_view_sel1;

            tapconfig_view_sel0=$urandom_range(0, 7);
            tapconfig_view_sel1=$urandom_range(0, 7);
            rtdr_data1_7[7:5]   = tapconfig_view_sel0;
            rtdr_data1_7[10:8]  = tapconfig_view_sel1;
      end

       `ovm_info(get_type_name(),$psprintf("Set rtdr_data1_0=0x%0x",rtdr_data1_0),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data1_1=0x%0x",rtdr_data1_1),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data1_2=0x%0x",rtdr_data1_2),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data1_3=0x%0x",rtdr_data1_3),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data1_4=0x%0x",rtdr_data1_4),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data1_5=0x%0x",rtdr_data1_5),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data1_6=0x%0x",rtdr_data1_6),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data1_7=0x%0x",rtdr_data1_7),OVM_LOW)

   
        $value$plusargs("HQM_RTDR_DATA2_0=%x", rtdr_data2_0);
        $value$plusargs("HQM_RTDR_DATA2_1=%x", rtdr_data2_1);
        $value$plusargs("HQM_RTDR_DATA2_2=%x", rtdr_data2_2);
        $value$plusargs("HQM_RTDR_DATA2_3=%x", rtdr_data2_3);
        $value$plusargs("HQM_RTDR_DATA2_4=%x", rtdr_data2_4);
        $value$plusargs("HQM_RTDR_DATA2_5=%x", rtdr_data2_5);
        $value$plusargs("HQM_RTDR_DATA2_6=%x", rtdr_data2_6);
        $value$plusargs("HQM_RTDR_DATA2_7=%x", rtdr_data2_7);

        rtdr_data2_2nd=0;
        rtdr_data2_3rd=0;
        rtdr_data2_4th=0;

        if(rtdr_data2_2>0 || rtdr_data2_3>0) rtdr_data2_2nd=1;
        if(rtdr_data2_4>0 || rtdr_data2_5>0) rtdr_data2_3rd=1;
        if(rtdr_data2_6>0 || rtdr_data2_7>0) rtdr_data2_4th=1;
        
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data2_0=0x%0x",rtdr_data2_0),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data2_1=0x%0x",rtdr_data2_1),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data2_2=0x%0x",rtdr_data2_2),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data2_3=0x%0x",rtdr_data2_3),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data2_4=0x%0x",rtdr_data2_4),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data2_5=0x%0x",rtdr_data2_5),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data2_6=0x%0x",rtdr_data2_6),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data2_7=0x%0x",rtdr_data2_7),OVM_LOW)

        rtdr_reg0_cfg_wait_num0=500;
        rtdr_reg0_cfg_wait_num1=500;
        $value$plusargs("HQM_RTDR_DATA0_CFG_wait_0=%d", rtdr_reg0_cfg_wait_num0);
        $value$plusargs("HQM_RTDR_DATA0_CFG_wait_1=%d", rtdr_reg0_cfg_wait_num1);
       `ovm_info(get_type_name(),$psprintf("Set rtdr_reg0_cfg_wait_num0=%0d",rtdr_reg0_cfg_wait_num0),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_reg0_cfg_wait_num1=%0d",rtdr_reg0_cfg_wait_num1),OVM_LOW)

        rtdr_reg1_cfg_wait_num0=100;
        rtdr_reg1_cfg_wait_num1=10;
        rtdr_reg1_cfg_wait_num2=100;
        rtdr_reg1_cfg_wait_num3=3000;
        rtdr_reg1_cfg_wait_num4=500;
        $value$plusargs("HQM_RTDR_DATA1_CFG_wait_0=%d", rtdr_reg1_cfg_wait_num0);
        $value$plusargs("HQM_RTDR_DATA1_CFG_wait_1=%d", rtdr_reg1_cfg_wait_num1);
        $value$plusargs("HQM_RTDR_DATA1_CFG_wait_2=%d", rtdr_reg1_cfg_wait_num2);
        $value$plusargs("HQM_RTDR_DATA1_CFG_wait_3=%d", rtdr_reg1_cfg_wait_num3);
        $value$plusargs("HQM_RTDR_DATA1_CFG_wait_4=%d", rtdr_reg1_cfg_wait_num4);
       `ovm_info(get_type_name(),$psprintf("Set rtdr_reg1_cfg_wait_num0=%0d",rtdr_reg1_cfg_wait_num0),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_reg1_cfg_wait_num1=%0d",rtdr_reg1_cfg_wait_num1),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_reg1_cfg_wait_num2=%0d",rtdr_reg1_cfg_wait_num2),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_reg1_cfg_wait_num3=%0d",rtdr_reg1_cfg_wait_num3),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_reg1_cfg_wait_num4=%0d",rtdr_reg1_cfg_wait_num4),OVM_LOW)

        rtdr_reg2_cfg_wait_num0=10;
        $value$plusargs("HQM_RTDR_DATA2_CFG_wait_0=%d", rtdr_reg2_cfg_wait_num0);
       `ovm_info(get_type_name(),$psprintf("Set rtdr_reg2_cfg_wait_num0=%0d",rtdr_reg2_cfg_wait_num0),OVM_LOW)

endfunction : new

    `ovm_sequence_utils(TapDataLoadSeq_T0, JtagBfmPkg::JtagBfmSequencer)


///////////////////////////////////////////////////////////////////////////////////////////    
virtual task body();
      `ovm_info(get_type_name(),"TapDataLoadSeq_T0 Start",OVM_NONE); 
      Idle(30);
      Idle(30);
      Idle(30);
      Idle(30);

      //---------------------------------------------------------------------------------------------------
      //---------------------------------------------------------------------------------------------------
      `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S1: Reset_PWRGOOD",OVM_NONE); 
      Reset(2'b11);

      //---------------------------------------------------------------------------------------------------
      //---------------------------------------------------------------------------------------------------
      Idle(300);
      if ($test$plusargs("has_tap_loaddr_task")) begin
          `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S2.1: LoadDR",OVM_NONE); 
           LoadDR(2'b00, 32'h01234567, 32'h048d159c, 32'hffffffff, 32);

           Idle(100);
           LoadDR(2'b00, 16'h4567, 16'h159c, 16'hffff, 16);
           Idle(100);
           `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S2.2: LoadDR",OVM_NONE); 
           LoadDR(2'b00, 16'h0123, 16'h048d, 16'hffff, 16);
      end


      //---------------------------------------------------------------------------------------------------
      //-- program reg1 : fdfx_pgcb_bypass(bit1) fdfx_pgcb_ovr (bit2)
      //---------------------------------------------------------------------------------------------------
      if ($test$plusargs("has_rtdr_reg0_cfg_task0")) begin
        `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S4.1: TapRegister_Access_reg0_task0",OVM_NONE); 
        TapRegister_Access_reg0_task0(rtdr_data0_0);
      end

      if ($test$plusargs("has_rtdr_reg0_cfg_task1")) begin
        `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S4.1: TapRegister_Access_reg0_task1",OVM_NONE); 
        TapRegister_Access_reg0_task1(rtdr_data0_0, rtdr_data0_1);
      end


      //---------------------------------------------------------------------------------------------------
      //-- program reg1 : fdfx_pgcb_bypass(bit1) fdfx_pgcb_ovr (bit2)
      //---------------------------------------------------------------------------------------------------
      if ($test$plusargs("has_rtdr_reg1_cfg_task0")) begin
        `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S3: TapRegister_Access_reg1_task0",OVM_NONE); 
        TapRegister_Access_reg1_task0(rtdr_data1_0, rtdr_data1_1, rtdr_data1_2, rtdr_data1_3);
      end

      if ($test$plusargs("has_rtdr_reg1_cfg_task1")) begin
        `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S4.1: TapRegister_Access_reg1_task1",OVM_NONE); 
        TapRegister_Access_reg1_task1(rtdr_data1_0, rtdr_data1_1, rtdr_data1_2, rtdr_data1_3, rtdr_data1_4, rtdr_data1_5, rtdr_data1_6, rtdr_data1_7);
        Idle(800);
        `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S4.2: TapRegister_Access_reg1_task1",OVM_NONE); 
        TapRegister_Access_reg1_task1(rtdr_data1_7, rtdr_data1_6, rtdr_data1_5, rtdr_data1_4, rtdr_data1_3, rtdr_data1_2, rtdr_data1_1, rtdr_data1_0);
      end

      if ($test$plusargs("has_rtdr_reg1_cfg_task2")) begin
        `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S4.1: TapRegister_Access_reg1_task2",OVM_NONE); 
        TapRegister_Access_reg1_task2(rtdr_data1_0);
      end

      if ($test$plusargs("has_rtdr_reg1_cfg_force_pwr_on")) begin
        `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S4.1: TapRegister_Access_reg1_task2: program rtdr_reg1_cfg_force_pwr_on",OVM_NONE); 
        TapRegister_Access_reg1_force_pwr_on_task(rtdr_data1_0, rtdr_data1_1, rtdr_data1_2);
      end

      //---------------------------------------------------------------------------------------------------
      //-- program reg2 : taptrigger [30:0]
      //---------------------------------------------------------------------------------------------------
      if ($test$plusargs("has_rtdr_reg2_cfg_trigger")) begin
        `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S4.reg2_trigger: TapRegister_Access_reg2_taptrigger_task",OVM_NONE); 
        TapRegister_Access_reg2_trigger_task(rtdr_data2_0, rtdr_data2_1);
      end

      if ($test$plusargs("has_rtdr_reg2_cfg_trigger_2nd") || ($test$plusargs("has_rtdr_reg2_cfg_trigger") && rtdr_data2_2nd==1)) begin
        `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S4.reg2_trigger: TapRegister_Access_reg2_taptrigger_task 2nd",OVM_NONE); 
        TapRegister_Access_reg2_trigger_task(rtdr_data2_2, rtdr_data2_3);
      end

      if ($test$plusargs("has_rtdr_reg2_cfg_trigger_3rd") || ($test$plusargs("has_rtdr_reg2_cfg_trigger") && rtdr_data2_3rd==1)) begin
        `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S4.reg2_trigger: TapRegister_Access_reg2_taptrigger_task 3rd",OVM_NONE); 
        TapRegister_Access_reg2_trigger_task(rtdr_data2_4, rtdr_data2_5);
      end

      if ($test$plusargs("has_rtdr_reg2_cfg_trigger_4th") || ($test$plusargs("has_rtdr_reg2_cfg_trigger") && rtdr_data2_4th==1)) begin
        `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S4.reg2_trigger: TapRegister_Access_reg2_taptrigger_task 4th",OVM_NONE); 
        TapRegister_Access_reg2_trigger_task(rtdr_data2_6, rtdr_data2_7);
      end

      //---------------------------------------------------------------------------------------------------
      //---------------------------------------------------------------------------------------------------
      if ($test$plusargs("has_rtdr_reg2_cfg_trigger") || $test$plusargs("has_rtdr_reg1_cfg_force_pwr_on")) begin
         `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S5: Skip TapRegister_Access_task",OVM_NONE); 
      end else begin
         `ovm_info(get_type_name(),"TapDataLoadSeq_T0 S5: TapRegister_Access_task",OVM_NONE); 
         TapRegister_Access_task(secure_policy_enabled, rtdr_data0_0, rtdr_data0_1, rtdr_data1_0, rtdr_data1_1, rtdr_data2_0, rtdr_data2_1);
      end


      //---------------------------------------------------------------------------------------------------
      //---------------------------------------------------------------------------------------------------
      if ($test$plusargs("has_tap_exp_seq")) begin
          Idle(1000);
          //---------------------------------
          //---------------------------------
          Idle(300);
          rtdr_addr=0;
          rtdr_data=rtdr_data0_0;
          exp_rtdr_data=(secure_policy_enabled==0)? 0 : rtdr_data;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S6.10: ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32);

          rtdr_addr=1;
          rtdr_data=rtdr_data1_0;
          exp_rtdr_data=(secure_policy_enabled==0)? 0 : rtdr_data;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S6.11: ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32);

          rtdr_addr=2;
          rtdr_data=rtdr_data2_0;
          exp_rtdr_data=(secure_policy_enabled==0)? 0 : rtdr_data;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S6.12: ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32);
       end


      //---------------------------------------------------------------------------------------------------
      //---------------------------------------------------------------------------------------------------
      if ($test$plusargs("has_rtdr_reg_access_rnd2")) begin
       `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S7.0: TapRegister_Access_task wait %0d", task2_wait_num), OVM_NONE); 
        Idle(task2_wait_num);

//-- https://hsdes.intel.com/appstore/article/#/22010115567
//--removed fdfx_xxx       `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S7.1: reset fdfx_secure control"), OVM_NONE); 
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_earlyboot_exit", 0);
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_policy_update", 0);
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_secure_policy", 0);
//--removed fdfx_xxx        Idle(50);
//--removed fdfx_xxx        
//--removed fdfx_xxx       `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S7.2: update fdfx_secure_policy to fdfx_secure_policy_value_2nd=%0d", fdfx_secure_policy_value_2nd), OVM_NONE); 
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_earlyboot_exit", 0);
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_policy_update", 1);
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_secure_policy", fdfx_secure_policy_value_2nd);
//--removed fdfx_xxx        Idle(50);
//--removed fdfx_xxx
//--removed fdfx_xxx       `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S7.2: exit fdfx_secure_policy to lock fdfx_secure_policy_value_2nd=%0d", fdfx_secure_policy_value_2nd), OVM_NONE); 
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_earlyboot_exit", 1);
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_policy_update", 0);
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_secure_policy", fdfx_secure_policy_value_2nd);
//--removed fdfx_xxx        Idle(50);
//--removed fdfx_xxx

       `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S7.3: TapRegister_Access_task ", task2_wait_num), OVM_NONE); 
        TapRegister_Access_task(secure_policy_enabled_2nd, rtdr_data0_2, rtdr_data0_3, rtdr_data1_2, rtdr_data1_3, rtdr_data2_2, rtdr_data2_3);
      end



      //---------------------------------------------------------------------------------------------------
      //---------------------------------------------------------------------------------------------------
      if ($test$plusargs("has_rtdr_reg_access_rnd3")) begin
       `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S8.0: TapRegister_Access_task wait %0d", task2_wait_num), OVM_NONE); 
        Idle(task2_wait_num);
//--removed fdfx_xxx       `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S8.1: reset fdfx_secure control"), OVM_NONE); 
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_earlyboot_exit", 0);
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_policy_update", 0);
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_secure_policy", 0);
//--removed fdfx_xxx        Idle(50);
        
//--removed fdfx_xxx       `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S8.2: update fdfx_secure_policy to fdfx_secure_policy_value=%0d", fdfx_secure_policy_value), OVM_NONE); 
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_earlyboot_exit", 0);
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_policy_update", 1);
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_secure_policy", fdfx_secure_policy_value);
//--removed fdfx_xxx        Idle(50);

//--removed fdfx_xxx       `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S8.2: exit fdfx_secure_policy to lock fdfx_secure_policy_value=%0d", fdfx_secure_policy_value), OVM_NONE); 
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_earlyboot_exit", 1);
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_policy_update", 0);
//--removed fdfx_xxx        sla_vpi_force_value_by_name("hqm_tb_top.fdfx_secure_policy", fdfx_secure_policy_value);
//--removed fdfx_xxx        Idle(50);

       `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S8.3: TapRegister_Access_task ", task2_wait_num), OVM_NONE); 
        TapRegister_Access_task(secure_policy_enabled, rtdr_data0_0, rtdr_data0_1, rtdr_data1_4, rtdr_data1_5, rtdr_data2_4, rtdr_data2_5);
      end


      //---------------------------------------------------------------------------------------------------
      //---------------------------------------------------------------------------------------------------
      if ($test$plusargs("has_rtdr_reg_access_rnd4")) begin
       `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S8.0: TapRegister_Access_task wait %0d", task2_wait_num), OVM_NONE); 
        Idle(task2_wait_num);

       `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_T0 S8.3: TapRegister_Access_task ", task2_wait_num), OVM_NONE); 
        TapRegister_Access_task(secure_policy_enabled, rtdr_data0_2, rtdr_data0_3, rtdr_data1_6, rtdr_data1_7, rtdr_data2_6, rtdr_data2_7);
      end

      //---------------------------------------------------------------------------------------------------
      //---------------------------------------------------------------------------------------------------
      //---------------------------------------------------------------------------------------------------
      //---------------------------------------------------------------------------------------------------

      `ovm_info(get_type_name(),"TapDataLoadSeq_T0 Completed",OVM_NONE); 
      Idle(1000);

endtask : body


//----------------------------------------------------------------------
//-- TapRegister_Access_reg0_task0
//----------------------------------------------------------------------
task TapRegister_Access_reg0_task0(bit[31:0] rtdr_data0_0);
      //---------------------------------
      //-- Access iosfsb_ism 
      //---------------------------------
         Idle(rtdr_reg0_cfg_wait_num0); //
         rtdr_addr=0;
         rtdr_data=rtdr_data0_0;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg0_task0 SW1.iosfsb_ism: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

endtask: TapRegister_Access_reg0_task0


//----------------------------------------------------------------------
//-- TapRegister_Access_reg0_task1
//----------------------------------------------------------------------
task TapRegister_Access_reg0_task1(bit[31:0] rtdr_data0_0, bit[31:0] rtdr_data0_1);
      //---------------------------------
      //-- Access iosfsb_ism 
      //---------------------------------
         Idle(rtdr_reg0_cfg_wait_num0); //
         rtdr_addr=0;
         rtdr_data=rtdr_data0_0;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg0_task1 SW1.iosfsb_ism: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

         Idle(rtdr_reg0_cfg_wait_num1);
          //--write 2nd
         rtdr_data=rtdr_data0_1;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg0_task1 SW2.iosfsb_ism: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);
endtask: TapRegister_Access_reg0_task1

//----------------------------------------------------------------------
//-- TapRegister_Access_reg1_task0
//----------------------------------------------------------------------
task TapRegister_Access_reg1_task0(bit[31:0] rtdr_data1_0, bit[31:0] rtdr_data1_1, bit[31:0] rtdr_data1_2, bit[31:0] rtdr_data1_3);
      //---------------------------------
      //-- Access tapconfig 
      //---------------------------------
         Idle(1000);
         rtdr_addr=1;
         rtdr_data=rtdr_data1_0;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_task0 SW1.W1: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

         Idle(rtdr_reg1_cfg_wait_num0);
          //--write 1st
         rtdr_data=rtdr_data1_1;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_task0 SW1.W2: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

         Idle(rtdr_reg1_cfg_wait_num1); //10
          //--write 2nd
         rtdr_data=rtdr_data1_2;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_task0 SW1.W3: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

         Idle(rtdr_reg1_cfg_wait_num2);
          //--write 3rd
         rtdr_data=rtdr_data1_3;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_task0 SW1.W4: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);


endtask: TapRegister_Access_reg1_task0


//----------------------------------------------------------------------
//-- TapRegister_Access_reg1_task1
//----------------------------------------------------------------------
task TapRegister_Access_reg1_task1(bit[31:0] rtdr_data1_0, bit[31:0] rtdr_data1_1, bit[31:0] rtdr_data1_2, bit[31:0] rtdr_data1_3, bit[31:0] rtdr_data1_4, bit[31:0] rtdr_data1_5, bit[31:0] rtdr_data1_6, bit[31:0] rtdr_data1_7);
      //---------------------------------
      //-- Access tapconfig 
      //---------------------------------
         Idle(rtdr_reg1_cfg_wait_num3); //3000
         rtdr_addr=1;
         rtdr_data=rtdr_data1_0;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_task1 SW1.W4: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

         Idle(rtdr_reg1_cfg_wait_num4);
          //--write 2nd
         rtdr_data=rtdr_data1_1;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_task1 SW1.W5: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

         Idle(rtdr_reg1_cfg_wait_num4);
          //--write 3rd
         rtdr_data=rtdr_data1_2;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_task1 SW1.W6: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

      if ($test$plusargs("has_rtdr_reg1_write_cont")) begin
         Idle(rtdr_reg1_cfg_wait_num4);
          //--write 3rd
         rtdr_data=rtdr_data1_3;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_task1 SW1.W7: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);


         Idle(rtdr_reg1_cfg_wait_num4);
          //--write 4th
         rtdr_data=rtdr_data1_4;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_task1 SW1.W7: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);


         Idle(rtdr_reg1_cfg_wait_num4);
          //--write 5th
         rtdr_data=rtdr_data1_5;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_task1 SW1.W7: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

         Idle(rtdr_reg1_cfg_wait_num4);
          //--write 6th
         rtdr_data=rtdr_data1_6;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_task1 SW1.W7: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

         Idle(rtdr_reg1_cfg_wait_num4);
          //--write 7th
         rtdr_data=rtdr_data1_7;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_task1 SW1.W7: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

      end//if ($test$plusargs("has_rtdr_reg1_write_cont")) begin

endtask: TapRegister_Access_reg1_task1


//----------------------------------------------------------------------
//-- TapRegister_Access_reg1_task2
//----------------------------------------------------------------------
task TapRegister_Access_reg1_task2(bit[31:0] rtdr_data1_0);
      //---------------------------------
      //-- Access tapconfig 
      //---------------------------------
         Idle(rtdr_reg1_cfg_wait_num3); //3000
         rtdr_addr=1;
         rtdr_data=rtdr_data1_0;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_task2 SW1.tapconfig: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

endtask: TapRegister_Access_reg1_task2

//----------------------------------------------------------------------
//-- TapRegister_Access_reg1_force_pwr_on_task
//----------------------------------------------------------------------
task TapRegister_Access_reg1_force_pwr_on_task(bit[31:0] rtdr_data1_0, bit[31:0] rtdr_data1_1, bit[31:0] rtdr_data1_2);
      //---------------------------------
      //-- Access tapconfig 
      //---------------------------------
         Idle(rtdr_reg1_cfg_wait_num0); 
         rtdr_addr=1;
         rtdr_data=rtdr_data1_0;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_force_pwr_on_task SW1.tapconfig: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

         Idle(rtdr_reg1_cfg_wait_num1);
          //--write 2nd
         rtdr_data=rtdr_data1_1;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_force_pwr_on_task SW2.tapconfig: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

         Idle(rtdr_reg1_cfg_wait_num2);
          //--write 2nd
         rtdr_data=rtdr_data1_2;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg1_force_pwr_on_task SW3.tapconfig: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

endtask: TapRegister_Access_reg1_force_pwr_on_task

//----------------------------------------------------------------------
//-- TapRegister_Access_reg2_trigger_task
//----------------------------------------------------------------------
task TapRegister_Access_reg2_trigger_task(bit[31:0] rtdr_data2_0, bit[31:0] rtdr_data2_1);
      //---------------------------------
      //-- Access tapconfig 
      //---------------------------------
         Idle(rtdr_reg2_cfg_wait_num0); 
         rtdr_addr=2;
         rtdr_data=rtdr_data2_0;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg2_trigger_task SW1.tapconfig: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

         Idle(rtdr_reg2_cfg_wait_num0);
          //--write 2nd
         rtdr_data=rtdr_data2_1;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_reg2_trigger_task SW2: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

endtask: TapRegister_Access_reg2_trigger_task

//----------------------------------------------------------------------
//-- TapRegister_Access_task
//----------------------------------------------------------------------
task TapRegister_Access_task(bit sp_enabled, bit[31:0] rtdr_data0_0, bit[31:0] rtdr_data0_1, bit[31:0] rtdr_data1_0, bit[31:0] rtdr_data1_1, bit[31:0] rtdr_data2_0, bit[31:0] rtdr_data2_1);

      //---------------------------------
      //-- Access iosfsb_ism 
      //---------------------------------
      if ($test$plusargs("has_rtdr_reg0_write_task_0")) begin
         Idle(300);
         rtdr_addr=0;
         rtdr_data=rtdr_data0_0;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SW0.1: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);
      end 
      if ($test$plusargs("has_rtdr_reg0_read_task_0")) begin
          Idle(300);
          rtdr_addr=0;
          rtdr_data=rtdr_data0_1;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data0_0;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR0.R1: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR0.R1.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)


          rtdr_data=rtdr_data0_2;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data0_1;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR0.R2: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR0.R2.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)

      end

      if ($test$plusargs("has_rtdr_reg0_write_task_1")) begin
         Idle(100);
         rtdr_addr=0;
         rtdr_data=rtdr_data0_3;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SW0.W2: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);
      end
      if ($test$plusargs("has_rtdr_reg0_read_task_1")) begin
          Idle(300);
          rtdr_addr=0;
          rtdr_data=rtdr_data0_0;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data0_3;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR0.R3: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR0.R3.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)


          rtdr_data=rtdr_data0_1;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data0_0;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR0.R4: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR0.R4.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)

      end

      //---------------------------------
      //-- Access tapconfig 
      //---------------------------------
      if ($test$plusargs("has_rtdr_reg1_write_task_0")) begin
         Idle(300);
         rtdr_addr=1;
         rtdr_data=rtdr_data1_0;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SW1.W1: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

         Idle(100);
          //--write 2nd
         rtdr_data=rtdr_data1_1;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SW1.W2: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);
      end 

      if ($test$plusargs("has_rtdr_reg1_read_task_0")) begin
         Idle(100);
          //-- read1
          rtdr_addr=1;
          rtdr_data=rtdr_data1_2;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data1_1;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR1.R1: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR1.R1.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)


          //-- read2
          rtdr_data=rtdr_data1_3;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data1_2;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR1.R2: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR1.R2.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)

          //-- read3
          rtdr_data=rtdr_data1_0;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data1_3;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR1.R3: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR1.R3.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)
      end

      if ($test$plusargs("has_rtdr_reg1_write_task_1")) begin
         Idle(100);
         rtdr_addr=1;
         rtdr_data=rtdr_data1_2;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SW1.W3: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);

         Idle(100);
         //--
         rtdr_data=rtdr_data1_3;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SW1.W4: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);
      end
      if ($test$plusargs("has_rtdr_reg1_read_task_1")) begin
          rtdr_addr=1;
          rtdr_data=rtdr_data1_0;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data1_3;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR1.R4: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR1.R4.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)

          //--
          rtdr_data=rtdr_data1_1;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data1_0;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR1.R5: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR1.R5.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)
      end

      //---------------------------------
      //-- Access tapstatus 
      //---------------------------------
      if ($test$plusargs("has_rtdr_reg2_write_task_0")) begin
         Idle(300);
         rtdr_addr=2;
         rtdr_data=rtdr_data2_0;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SW2.W1: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);
      end

      if ($test$plusargs("has_rtdr_reg2_read_task_0")) begin
          rtdr_addr=2;

          //--read 1st round
          rtdr_data=rtdr_data2_1;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data2_0;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR2.R1: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR2.R1.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)

          //--read 2nd round
          rtdr_data=rtdr_data2_2;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data2_1;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR2.R2: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR2.R2.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)
      end

      if ($test$plusargs("has_rtdr_reg2_write_task_1")) begin
         Idle(100);
         rtdr_addr=2;
         rtdr_data=rtdr_data2_3;
         `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SW2.W2: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
         MultipleTapRegisterAccess(2'b00, rtdr_addr, rtdr_data, 8, 32);
      end
      if ($test$plusargs("has_rtdr_reg2_read_task_1")) begin
          rtdr_addr=2;

          //--read 1st round
          rtdr_data=rtdr_data2_0;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data2_3;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR2.R3: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR2.R3.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)

          //--read 2nd round
          rtdr_data=rtdr_data2_1;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data2_0;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR2.R4: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR2.R4.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)

          //--read 3rd round
          rtdr_data=rtdr_data2_2;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data2_1;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR2.R5: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR2.R5.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)

          //--read 4th round
          rtdr_data=rtdr_data2_3;
          exp_rtdr_data=(sp_enabled==0)? 0 : rtdr_data2_2;
          mask_rtdr_data=32'hffff_ffff;
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR2.R6: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x", rtdr_addr, rtdr_data),OVM_LOW)
          ReturnTDO_ExpData_MultipleTapRegisterAccess(2'b00, rtdr_addr, 8, rtdr_data, exp_rtdr_data, mask_rtdr_data, 32, rtdr_tdo_data);
          `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Access_task SR2.R6.o: ReturnTDO_ExpData_MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x rtdr_tdo_data=0x%0x", rtdr_addr, rtdr_data, rtdr_tdo_data),OVM_LOW)

      end


endtask:TapRegister_Access_task 

//----------------------------------------------------------------------
//-- TapRegister_Write_task(bit[1:0] reset_val, bit [7:0] rtdr_addr, bit [31:0] rtdr_data, int data_len);
//----------------------------------------------------------------------
task TapRegister_Write_task(bit[1:0] reset_val, bit [7:0] rtdr_addr, bit [31:0] rtdr_data, int addr_len, int data_len);
      `ovm_info(get_type_name(),$psprintf("TapDataLoadSeq_TapRegister_Write_task: MultipleTapRegisterAccess to addr=0x%0x rtdr_data=0x%0x addr_len=%0d data_len=%0d reset_val=%0d", rtdr_addr, rtdr_data, addr_len, data_len, reset_val),OVM_LOW)
       MultipleTapRegisterAccess(reset_val, rtdr_addr, rtdr_data, addr_len, data_len);

endtask:TapRegister_Write_task 

endclass : TapDataLoadSeq_T0


//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
class MultipleTapRegisterAccessSeq_T0 extends JtagBfmPkg::JtagBfmSequences#(ovm_sequence_item);
    bit [7:0] rtdr_addr;
    bit[31:0] rtdr_data;

    bit[31:0] rtdr_data0_0;
    bit[31:0] rtdr_data0_1;
    bit[31:0] rtdr_data0_2;
    bit[31:0] rtdr_data0_3;
    bit[31:0] rtdr_data1_0;
    bit[31:0] rtdr_data1_1;
    bit[31:0] rtdr_data1_2;
    bit[31:0] rtdr_data1_3;
    bit[31:0] rtdr_data2_0;
    bit[31:0] rtdr_data2_1;
    bit[31:0] rtdr_data2_2;
    bit[31:0] rtdr_data2_3;

    function new(string name = "MultipleTapRegisterAccessSeq_T0");
        super.new(name);

        $value$plusargs("HQM_RTDR_DATA0_0=%x", rtdr_data0_0);
        $value$plusargs("HQM_RTDR_DATA0_1=%x", rtdr_data0_1);
        $value$plusargs("HQM_RTDR_DATA0_2=%x", rtdr_data0_2);
        $value$plusargs("HQM_RTDR_DATA0_3=%x", rtdr_data0_3);
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data0_0=0x%0x",rtdr_data0_0),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data0_1=0x%0x",rtdr_data0_1),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data0_2=0x%0x",rtdr_data0_2),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data0_3=0x%0x",rtdr_data0_3),OVM_LOW)
   
        $value$plusargs("HQM_RTDR_DATA1_0=%x", rtdr_data1_0);
        $value$plusargs("HQM_RTDR_DATA1_1=%x", rtdr_data1_1);
        $value$plusargs("HQM_RTDR_DATA1_2=%x", rtdr_data1_2);
        $value$plusargs("HQM_RTDR_DATA1_3=%x", rtdr_data1_3);
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data1_0=0x%0x",rtdr_data1_0),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data1_1=0x%0x",rtdr_data1_1),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data1_2=0x%0x",rtdr_data1_2),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data1_3=0x%0x",rtdr_data1_3),OVM_LOW)

   
        $value$plusargs("HQM_RTDR_DATA2_0=%x", rtdr_data2_0);
        $value$plusargs("HQM_RTDR_DATA2_1=%x", rtdr_data2_1);
        $value$plusargs("HQM_RTDR_DATA2_2=%x", rtdr_data2_2);
        $value$plusargs("HQM_RTDR_DATA2_3=%x", rtdr_data2_3);
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data2_0=0x%0x",rtdr_data2_0),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data2_1=0x%0x",rtdr_data2_1),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data2_2=0x%0x",rtdr_data2_2),OVM_LOW)
       `ovm_info(get_type_name(),$psprintf("Set rtdr_data2_3=0x%0x",rtdr_data2_3),OVM_LOW)

    endfunction : new

    `ovm_sequence_utils(MultipleTapRegisterAccessSeq_T0, JtagBfmPkg::JtagBfmSequencer)



    virtual task body();
      `ovm_info(get_type_name(),"MultipleTapRegisterAccessSeq_T0 Start",OVM_NONE); 
      Idle(30);
      Idle(30);
      Idle(30);
      Idle(30);

      `ovm_info(get_type_name(),"MultipleTapRegisterAccessSeq_T0 S1: Reset_PWRGOOD",OVM_NONE); 
      Reset(2'b11);

      Idle(300);
      

      //---------------------------------
      //-- Access tapstatus 
      //---------------------------------
      if ($test$plusargs("has_tap_exp_seq")) begin
          Idle(1000);
         `ovm_info(get_type_name(),"MultipleTapRegisterAccessSeq_T0 S5.1: LoadIR_idle",OVM_NONE); 
          LoadIR_idle(2'b00, 8'h0, 8'h0, 8'hFF, 8);
          //      //Goto(RUTI,1);
         `ovm_info(get_type_name(),"MultipleTapRegisterAccessSeq_T0 S5.2: LoadDR_idle",OVM_NONE); 
          LoadDR_idle(2'b00, 32'h0123_4567,  32'h048D_159C,  32'hFFFF_FFFF,  32);
          //      //Goto(RUTI,1);
         `ovm_info(get_type_name(),"MultipleTapRegisterAccessSeq_T0 S5.3: LoadIR",OVM_NONE); 
          LoadIR(2'b00, 8'h1, 8'h1, 8'hFF, 8);

         //`ovm_info(get_type_name(),"MultipleTapRegisterAccessSeq_T0 S5.4: Goto E2IR",OVM_NONE); 
         // Goto(E2IR,1);
         `ovm_info(get_type_name(),"MultipleTapRegisterAccessSeq_T0 S5.5: tms_tdi_stream",OVM_NONE); 
          tms_tdi_stream(22'h3E0000,22'h0,32);

         `ovm_info(get_type_name(),"MultipleTapRegisterAccessSeq_T0 S5.6: ExpData_MultipleTapRegisterAccess",OVM_NONE); 
          ExpData_MultipleTapRegisterAccess(2'b00,   8'h00,  8,  32'hF0F0F0F0, 32'hF0F0F0F0, 32'hFFFFFFFF, 32);

         //`ovm_info(get_type_name(),"MultipleTapRegisterAccessSeq_T0 S5.7: Goto RUTI",OVM_NONE); 
         // Goto(RUTI,1);

         `ovm_info(get_type_name(),"MultipleTapRegisterAccessSeq_T0 S5.8: ExpData_MultipleTapRegisterAccess",OVM_NONE); 
          ExpData_MultipleTapRegisterAccess(2'b00,   8'h0,   8,  32'hFFFF_FFFF,32'hFFFF_FFFC,32'hFFFF_FFFF,32);
       end


      `ovm_info(get_type_name(),"MultipleTapRegisterAccessSeq_T0 Completed",OVM_NONE); 
      Idle(1000);

    endtask : body

endclass : MultipleTapRegisterAccessSeq_T0


