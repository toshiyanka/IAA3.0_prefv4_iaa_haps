Module ip {

  ScanInPort     TdiT731L;
  ScanOutPort    TdoT731H { Source NOT_IMPORTANT;}
  TMSPort        TmsT731L;
  TRSTPort       TrstbT731L;
  TCKPort        Tclk;

  ScanInPort     Tdi_2a;
  ScanOutPort    Tdo_2a { Source NOT_IMPORTANT;}
  TMSPort        Tms_2a;
  TRSTPort       Trstb_2a;

  ScanInPort     Tdi_2b;
  ScanOutPort    Tdo_2b { Source NOT_IMPORTANT;}
  TMSPort        Tms_2b;
  TRSTPort       Trstb_2b;

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

  ScanInterface c_tap2a {
    Port Tdi_2a;
    Port Tdo_2a;
    Port Tms_2a;
  }

  ScanInterface c_tap2b {
    Port Tdi_2b;
    Port Tdo_2b;
    Port Tms_2b;
  }

  // Individual TDR ports and interfaces

  CaptureEnPort  cen;
  ShiftEnPort    sen;
  UpdateEnPort   uen;

  ScanInPort     si_A1;
  ScanOutPort    so_A1   { Source NOT_IMPORTANT;}
  SelectPort     sel_A1;

  ScanInterface c_regA1 { 
     Port si_A1; 
     Port so_A1; 
     Port sel_A1;
  }
  
  ScanInPort     si_A2;
  ScanOutPort    so_A2   { Source NOT_IMPORTANT;}
  SelectPort     sel_A2;

  ScanInterface c_regA2 { 
     Port si_A2; 
     Port so_A2; 
     Port sel_A2;
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
