// IP with separate interfaces for TDR/IJTAG registers (no TAP controller)

Module ip {

  TCKPort        Tclk;

  // fdfx_pwrgood
  ResetPort      fdfx_powergood { ActivePolarity 0 ; Attribute intel_TapRegResetType = "powergood" ;}

  // IJTAG Reset - required if IP has IJTAG chain(s)
  //ResetPort      ijtag_reset_b    { ActivePolarity 0 ; Attribute intel_TapRegResetType = "tlr" ;}

  // Client RTDR/IJTAG interfaces
  //
  // Note: intel_tdr_dest attribute is not required if registers have
  // individual interfacee and use c_<target_tdr> ScanInterface naming style
  // or if IP has just one si/so chain
  // IMPORTANT: <target_tdr> must be existing register INSTANCE in TAP RDL!

  ScanInPort     si[0:0];
  ScanOutPort    so[0:0]   { Source NOT_IMPORTANT;}
  SelectPort     sel[0:0];
  CaptureEnPort  cen[0:0];
  ShiftEnPort    sen[0:0];
  UpdateEnPort   uen[0:0];


  ScanInterface c_regA { 
     Port si[0:0]; 
     Port so[0:0]; 
     Port sel[0:0];
     Port cen[0:0];
     Port sen[0:0];
     Port uen[0:0];
  }
  
  ScanInPort     si[1:1];
  ScanOutPort    so[1:1]   { Source NOT_IMPORTANT;}
  SelectPort     sel[1:1];
  CaptureEnPort  cen[1:1];
  ShiftEnPort    sen[1:1];
  UpdateEnPort   uen[1:1];


  ScanInterface c_regB { 
     Port si[1:1]; 
     Port so[1:1]; 
     Port sel[1:1];
     Port cen[1:1];
     Port sen[1:1];
     Port uen[1:1];
  }

}
