// IP with single IJTAG chain (no TAP)

Module ip {

  TCKPort        Tclk;

  CaptureEnPort       cen;
  ShiftEnPort         sen;
  UpdateEnPort        uen;

  // fdfx_pwrgood
  ResetPort      fdfx_powergood { ActivePolarity 0 ; Attribute intel_TapRegResetType = "powergood" ;}

  // IJTAG Reset - required if IP has IJTAG chain(s)
  ResetPort      ijtag_reset_b    { ActivePolarity 0 ; Attribute intel_TapRegResetType = "tlr" ;}

  // Client IJTAG interfaces

  ScanInPort     ijtag_si;
  ScanOutPort    ijtag_so  { Source NOT_IMPORTANT;}
  
  // Note: intel_tdr_dest attribute is not required if registers have
  // individual interfacee and use c_<target_tdr> ScanInterface naming style
  // or if IP has just one si/so chain
  // IMPORTANT: Attributes must reference existing register INSTANCES in TAP RDL
  SelectPort     ijtag_sel;

  ScanInterface c_ip { 
     Port ijtag_si; 
     Port ijtag_so; 
     Port ijtag_sel;
  }

}
