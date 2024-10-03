Module test {

  ScanInPort     TdiT731L;
  ScanOutPort    TdoT731H { Source test;} // Final TDO
  TRSTPort       TrstbT731L;
  TCKPort        Tclk;

  // Standard JTAG interface
  TMSPort        TmsT731L;

  // fdfx_pwrgood
  ResetPort      fdfx_powergood { ActivePolarity 0 ; Attribute intel_TapRegResetType = "pwrgood_1" ;}

  // DFx Secure Plugin - simplified: no latch, fdfx_earlyboot_exit, fdfx_policy_update
  DataInPort     fdfx_secure_policy[3:0];

  // SLVIDCODE strap
  //DataInPort     ftap_slvidcode [31:0] { Attribute intel_signal_type = "slvidcode";  }

  // Client TAP/JTAG interface
  // if exists more then two tap interfaces, naming: 
  //     c_<tap|rtdr instance target>
  // Can include reset signal if necessary
  // No need if only one interface/port bundle
  ScanInterface c_t1 {
    Port TdiT731L;
    Port TdoT731H;
    Port TmsT731L;
  }

  // Taplink interface
  SelectPort    Taplink_ir_sel;

  ScanInterface c_tl { 
    Port TdiT731L;
    Port TdoT731H;
    Port Taplink_ir_sel;
  }

  // Host RTDR interfaces

  ScanInPort     rtdr_so;
  ScanOutPort    rtdr_si { Source rtdr [ 0 ] ;}
  ToSelectPort   rtdr_sel { Source rtdr; }

  ScanInterface h_rtdr { 
     Port rtdr_sel;
     Port rtdr_si; 
     Port rtdr_so; 
  }

  Attribute qq = "q";

  Parameter TAPLINK_MODE = 1'b0;
  LocalParameter IR_SIZE = 8;

  Enum TAP_INSTRUCTIONS {
    BRKPTCTL0_LCLK         = $BRKPTCTL0_LCLK_OPCODE;         
    BRKPTCTL0_SBCLK        = $BRKPTCTL0_SBCLK_OPCODE;        
  }

  Instance IR Of intel_tap_ir {
    Parameter    IR_SIZE        = $IR_SIZE;
    Parameter    IR_RESET_VALUE = $SLVIDCODE_OPCODE;
    Parameter    IR_CAPTURE_SRC = 'hxx;
    InputPort    si             = TdiT731L;
    InputPort    rst            = fsm.tlr;
  }

  Alias IR[$IR_SIZE-1:0] = IR.IR { RefEnum TAP_INSTRUCTIONS; } 

  ScanMux ir_mux SelectedBy fsm.irsel {
     1'b0:    dr_mux;
     1'b1:    IR.so;
  }

  LogicSignal rtdr_sel { (iovbypass | iovctl) & ~IOVCONFIG_0.RTDO_ENABLE_out;}

  ScanRegister DR[0:0] {
     ScanInSource     si;
     CaptureSource    1'b0; 
  }

/*
multiline comment
*/

}
