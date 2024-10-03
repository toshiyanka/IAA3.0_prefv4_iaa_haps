Module ip {

  ScanInPort     TdiT731L;
  ScanOutPort    TdoT731H { Source NOT_IMPORTANT;}
  TMSPort        TmsT731L;
  TRSTPort       TrstbT731L;
  TCKPort        Tclk;

  ScanInPort     Tdi_2;
  ScanOutPort    Tdo_2 { Source NOT_IMPORTANT;}
  TMSPort        Tms_2;
  TRSTPort       Trstb_2;

  // fdfx_pwrgood
  ResetPort      fdfx_powergood { ActivePolarity 0 ; Attribute intel_signal_type = "powergood";}

  // DFx Secure Plugin - simplified: no latch, fdfx_earlyboot_exit, fdfx_policy_update
  DataInPort     fdfx_secure_policy[3:0] { Attribute intel_signal_type = "secure_policy";}

  // Client TAP/JTAG interface
  // if IP has more then one TAPs/interfaces, ScanInterface should use c_<tap_in_rdl> naming convention
  // No need of ScanInterface if only one interface/port bundle exists

  ScanInterface c_tap1 {
    Port TdiT731L;
    Port TdoT731H;
    Port TmsT731L;
  }

  ScanInterface c_tap2 {
    Port Tdi_2;
    Port Tdo_2;
    Port Tms_2;
  }

  // In/Out Ports exported from tdr_in/tdr_out of TAP registers/fields
  // Export can be done for full register or per field.
  // Specified path should reference the existing instance of register/field in RDL
  // IMPORTANT: port size should match target register/field size

  // Target: full register
  DataInPort      ftap_slvidcode_1[31:0]  { DefaultLoadValue 32'h0a1; Attribute intel_tdr_dest = "tap1.SLVIDCODE"; }
  DataInPort      ftap_slvidcode_2[31:0]  { DefaultLoadValue 32'h0a3; Attribute intel_tdr_dest = "tap2.SLVIDCODE"; }
  DataOutPort     enable_1[3:0]           { Attribute intel_tdr_dest = "tap1.regA.f1"; }

  // Target: register field
  DataInPort      status[7:0]    { DefaultLoadValue 8'h0; Attribute intel_tdr_dest = "regB.f2"; }
  DataOutPort     enable_A[3:0]  { Attribute intel_tdr_dest = "regA.f1"; }

  // Individual TDR ports and interfaces

  CaptureEnPort  cen;
  ShiftEnPort    sen;
  UpdateEnPort   uen;

  ScanInPort     si_A;
  ScanOutPort    so_A   { Source NOT_IMPORTANT;}
  SelectPort     sel_A;

  ScanInterface c_regA { 
     Port si_A; 
     Port so_A; 
     Port sel_A;
  }
  
  ScanInPort     si_B;
  ScanOutPort    so_B   { Source NOT_IMPORTANT;}
  SelectPort     sel_B;

  ScanInterface c_regB { 
     Port si_B; 
     Port so_B; 
     Port sel_B;
  }
}
