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

  // fdfx_pwrgood resets 
  // Port with intel_signal_type attribute 'powergood_<domain>' corresponds to the reset type 'PWRGOOD_<domain>' in the RDL.
  // Port with intel_signal_type attribute 'powergood' corresponds to the reset type 'PWRGOOD' in the RDL.

  ResetPort      fdfx_powergood { ActivePolarity 0 ; Attribute intel_signal_type = "powergood";}
  ResetPort      fdfx_powergood_d1 { ActivePolarity 0 ; Attribute intel_signal_type = "powergood_d1";}
  ResetPort      fdfx_powergood_d2 { ActivePolarity 0 ; Attribute intel_signal_type = "powergood_d2";}

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
