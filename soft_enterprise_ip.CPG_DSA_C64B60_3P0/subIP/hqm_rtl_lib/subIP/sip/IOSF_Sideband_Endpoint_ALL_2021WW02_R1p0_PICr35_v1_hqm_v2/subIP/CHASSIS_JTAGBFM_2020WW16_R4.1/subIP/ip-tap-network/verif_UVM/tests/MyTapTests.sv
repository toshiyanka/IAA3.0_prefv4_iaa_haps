//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : TapTests.sv
//    DESIGNER    : S.RajaNataraj
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : Tests 
//    DESCRIPTION : This component has all the test present in the ENV.
//                  Each Tests call for the corresponding sequneces. 
//----------------------------------------------------------------------
class MyNewSequence extends JtagBfmSequences;
   
   JtagBfmSeqDrvPkt Packet;
   function new(string name = "MyNewSequence");
      super.new(name);
      Packet = new;
   endfunction  : new   

   `uvm_object_utils(MyNewSequence)    

   `uvm_declare_p_sequencer(JtagBfmSequencer);

   virtual task body();
        Reset(2'b11);
        //MultipleTapRegisterAccess(NO_RST,IR_val, DR_val, IR_len, DR_len);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h0040,8,16);
        MultipleTapRegisterAccess(NO_RST,16'hFFA4,33'h0_ABCD1234,16,33);
    endtask : body

endclass : MyNewSequence

//------------------------------------------------------------------------------------------

class MyTapTest extends TapBaseTest;

    `uvm_component_utils(MyTapTest)

    MyNewSequence SP;

   function new (string name = "MyTapTest", uvm_component parent = null);
       super.new(name,parent);
   endfunction : new

   // This call does not send JTAG traffic.
   // Test bench has no indication to flag an error when no traffic is sent.
   // Use the .start method to send traffic.

   virtual function void build_phase(uvm_phase phase);  
        super.build_phase(phase);
        uvm_config_int::set(this, "*", "max_run_clocks", 20000);
        uvm_config_int::set(this, "Env.*", "enable_clk_gating", UVM_PASSIVE);
        //uvm_config_string::set(this, "Env.MasterAgent.Sequencer", "default_sequence", "SP");
   endfunction : build_phase

   //virtual task run_phase (uvm_phase phase);
   //     #2000000000;
   //     uvm_report_info("MyTapTest","MyTapTest Completed!!!");
   //     //global_stop_request();
   //endtask

   virtual task run_phase (uvm_phase phase);
        uvm_report_info("MyTapTest","Test Starts!!!",UVM_NONE);
        SP = new("My New test");
        SP.start(Env.PriMasterAgent.Sequencer);
        uvm_report_info("MyTapTest","MyTapTest Completed!!!",UVM_NONE);
        #2000ns;
        SP.start(Env.PriMasterAgent.Sequencer);
        //global_stop_request();
   endtask

endclass : MyTapTest
//------------------------------------------------------------------------------------------


class TapSequenceOddStap extends JtagBfmSequences;
   
   JtagBfmSeqDrvPkt Packet;
   function new(string name = "TapSequenceOddStap");
      super.new(name);
      Packet = new;
   endfunction  : new   

   `uvm_object_utils(TapSequenceOddStap)    

   `uvm_declare_p_sequencer(JtagBfmSequencer);

   virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h4444,8,16);
        MultipleTapRegisterAccess(NO_RST,40'hFF_A2_A4_A2_A4,129'h0_AAAAAAAA_55555555_88888888_11111111,40,129);
    endtask : body

endclass : TapSequenceOddStap

//------------------------------------------------------------------------------------------

class MyOddTapTest extends TapBaseTest;
   
   `uvm_component_utils(MyOddTapTest)

   TapSequenceOddStap SP;

   function new (string name = "MyOddTapTest", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("MyOddTapTest", "Test Starts!!!",UVM_NONE);
      SP = new("My New Test");
      SP.start(Env.PriMasterAgent.Sequencer);
      uvm_report_info("MyOddTapTest", "MyOddTapTest Completed",UVM_NONE);
      //global_stop_request();
   endtask

endclass : MyOddTapTest
//------------------------------------------------------------------------------------------

class TapSequenceRandData extends JtagBfmSequences;
   
   JtagBfmSeqDrvPkt Packet;
   function new(string name = "TapSequenceRandData");
      super.new(name);
      Packet = new;
   endfunction  : new   

   `uvm_object_utils(TapSequenceRandData)    

   `uvm_declare_p_sequencer(JtagBfmSequencer);

   virtual task body();
        logic [31:0] tdodata;
        logic [31:0] compare_mask, allzeros, allones, datain, dataout;
        logic [31:0] pattern1;

        allzeros = 32'h00000000;
        allones  = 32'hFFFFFFFF;
        
        Reset(2'b11);

        MultipleTapRegisterAccessRand(NO_RST,8'h34,8,32);

        datain       = 32'h1234_5678;
        dataout      = allzeros;
        compare_mask = allzeros;
        ReturnTDO_ExpData_MultipleTapRegisterAccess(NO_RST, 8'h34, 8, datain, dataout, compare_mask, 32, tdodata); Goto(UPDR,1); 
        $display("test1 point1: tdodata got: %0h\n", tdodata);

        datain       = tdodata;
        dataout      = 32'h1234_5678;
        compare_mask = allones;
        ReturnTDO_ExpData_MultipleTapRegisterAccess(NO_RST, 8'h34, 8, datain, dataout, compare_mask, 32, tdodata); Goto(UPDR,1); 
        $display("test1 point2: tdodata got: %0h\n", tdodata);

        #1000ns;
    endtask : body

endclass : TapSequenceRandData

//----------------------------------------------------------------------------

class MyRandTapTest extends TapBaseTest;
   
   `uvm_component_utils(MyRandTapTest)

   TapSequenceRandData SP;

   function new (string name = "MyRandTapTest", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("MyRandTapTest", "Test Starts!!!",UVM_NONE);
      SP = new("My New Test");
      SP.start(Env.PriMasterAgent.Sequencer);
      uvm_report_info("MyRandTapTest", "MyRandTapTest Completed",UVM_NONE);
      //global_stop_request();
   endtask

endclass : MyRandTapTest

//------------------------------------------------------------------------------------------


class TapSequenceEvenStap extends JtagBfmSequences;
   
   JtagBfmSeqDrvPkt Packet;
   function new(string name = "TapSequenceEvenStap");
      super.new(name);
      Packet = new;
   endfunction  : new   

   `uvm_object_utils(TapSequenceEvenStap)    

   `uvm_declare_p_sequencer(JtagBfmSequencer);

   virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h1111,8,16);
        MultipleTapRegisterAccess(NO_RST,40'hFF_A2_A4_A2_A4,129'h0_11111111_55555555_AAAAAAAA_88888888,40,129);
    endtask : body

endclass : TapSequenceEvenStap

//------------------------------------------------------------------------------------------

class MyEvenTapTest extends TapBaseTest;
   
   `uvm_component_utils(MyEvenTapTest)

   TapSequenceEvenStap SP;

   function new (string name = "MyEvenTapTest", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);
      uvm_report_info("MyEvenTapTest", "Test Starts!!!",UVM_NONE);
      SP = new("My New Test");
      SP.start(Env.PriMasterAgent.Sequencer);
      uvm_report_info("MyEvenTapTest", "MyEvenTapTest Completed",UVM_NONE);
      //global_stop_request();
   endtask

endclass : MyEvenTapTest
//------------------------------------------------------------------------------------------

class TapConfigSequence extends JtagBfmSequences;

   JtagBfmSeqDrvPkt Packet;
   function new(string name = "TapConfigSequence");
      super.new(name);
      Packet = new;
   endfunction  : new   

   `uvm_object_utils(TapConfigSequence)    

   `uvm_declare_p_sequencer(JtagBfmSequencer);

   virtual task body();
        MultipleTapRegisterAccess(NO_RST,8'h10,8'h01,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h0001,8,16);
   endtask : body

endclass : TapConfigSequence
//------------------------------------------------------------------------------------------
class TapSequencePrimStap extends JtagBfmSequences;
   
   JtagBfmSeqDrvPkt Packet;
   function new(string name = "TapSequencePrimStap");
      super.new(name);
      Packet = new;
   endfunction  : new   

   `uvm_object_utils(TapSequencePrimStap)    

   `uvm_declare_p_sequencer(JtagBfmSequencer);

   virtual task body();
        reg [31:0] pattern1, pattern2;
        reg [31:0] allones;
        reg [31:0] allzeros;
        reg [31:0] expdata;

        allzeros = 32'h00000000;
        allones  = 32'hFFFFFFFF;

/*
        // Cltap in Bypass
        pattern = 32'hFFFFFFFF;
        expdata = pattern << 1; 
        ExpData_MultipleTapRegisterAccess(NO_RST,
                                          8'hA1, 8,
                                          pattern, expdata, allones, 32); Goto (UPDR,1);
*/

        pattern1 = 32'h4321DCBA;
        expdata  = allzeros; 
        ExpData_MultipleTapRegisterAccess(NO_RST,
                                          8'hA0, 8,
                                          pattern1, expdata, allones, 32); Goto (UPDR,1);

        pattern2 = 32'h87654321;
        ExpData_MultipleTapRegisterAccess(NO_RST,
                                          8'hA0, 8,
                                          pattern2, pattern1, allones, 32); Goto (UPDR,1);

        Goto(RUTI,11);

    endtask : body

endclass : TapSequencePrimStap


//------------------------------------------------------------------------------------------
class TapSequenceSecStap extends JtagBfmSequences;
   
   JtagBfmSeqDrvPkt Packet;
   function new(string name = "TapSequenceSecStap");
      super.new(name);
      Packet = new;
   endfunction  : new   

   `uvm_object_utils(TapSequenceSecStap)    

   `uvm_declare_p_sequencer(JtagBfmSequencer);

   virtual task body();
        reg [31:0] pattern;
        reg [31:0] allones;
        reg [31:0] allzeros;
        reg [31:0] expdata;

        allzeros = 32'h00000000;
        allones  = 32'hFFFFFFFF;
/*
        // S0 in Bypass
        pattern = 32'hFFFFFFFF;
        expdata = pattern << 1; 
        Goto (TLRS, 1);
        ExpData_MultipleTapRegisterAccess(NO_RST,
                                          8'hA0, 8,
                                          pattern, expdata, allones, 32); Goto (UPDR,1);
        Goto(RUTI,11);
*/


        pattern = 32'h11223344;
        expdata = allzeros; 
        ExpData_MultipleTapRegisterAccess(NO_RST,
                                          8'hA1, 8,
                                          pattern, expdata, allones, 32); Goto (UPDR,1);
        Goto(RUTI,11);

    endtask : body

endclass : TapSequenceSecStap

//------------------------------------------------------------------------------------------

class MySecTapTest extends TapBaseTest;
   
   `uvm_component_utils(MySecTapTest)

   TapSequenceReset    SRP,SRS;
   TapConfigSequence   SP_Config;
   TapSequencePrimStap SP_Prim;
   TapSequenceSecStap  SP_Seco;

   function new (string name = "MySecTapTest", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase); 
      super.build_phase(phase);
      uvm_config_int::set(this, "Env", "has_scoreboard",    UVM_PASSIVE);
      //Env.ReportComponent.set_max_quit_count(32);
   endfunction : build_phase

   virtual task run_phase (uvm_phase phase);

      uvm_report_info("MySecTapTest", "Test Starts!!!",UVM_NONE);

      SRP = new("Reset Primary");
      SRS = new("Reset Secondary");
      SP_Config = new(" Config Sequence");
      SP_Prim = new(" Primary STAPs Sequence");
      SP_Seco = new(" Secondary STAPs Sequence");

      SRP.start(Env.PriMasterAgent.Sequencer);
      SRS.start(Env.SecMasterAgent.Sequencer);

      SP_Config.start(Env.PriMasterAgent.Sequencer);
      fork
         SP_Prim.start(Env.PriMasterAgent.Sequencer);
         SP_Seco.start(Env.SecMasterAgent.Sequencer);
      join   

      uvm_report_info("MySecTapTest", "MySecTapTest Completed",UVM_NONE);
      //global_stop_request();
   endtask

endclass : MySecTapTest
//------------------------------------------------------------------------------------------

