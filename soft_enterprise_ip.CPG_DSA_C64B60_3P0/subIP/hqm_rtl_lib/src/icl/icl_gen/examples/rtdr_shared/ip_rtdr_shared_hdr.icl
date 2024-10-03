// IP with shared interfaces for TDR/IJTAG registers (no TAP)
// IMPORTANT: ScanInterface must include ShiftEn (Shift_DR) signal and have NO Select (IrDec) signals!

Module ip {

  TCKPort        Tclk;

  CaptureEnPort       cen;
  ShiftEnPort         sen;
  UpdateEnPort        uen;

  // fdfx_pwrgood
  ResetPort      fdfx_powergood { ActivePolarity 0 ; Attribute intel_TapRegResetType = "powergood" ;}

  // IJTAG Reset - required if IP has IJTAG chain(s)
  //ResetPort      ijtag_reset_b    { ActivePolarity 0 ; Attribute intel_TapRegResetType = "tlr" ;}

  // Client IJTAG interfaces

  ScanInPort     si_AB;
  ScanOutPort    so_AB  { Source NOT_IMPORTANT;}
  
  // Note: intel_tdr_dest attribute is not required if registers have
  // individual interfacee and use c_<target_tdr> ScanInterface naming style
  // or if IP has just one si/so chain
  // IMPORTANT: Attributes must reference existing register INSTANCES in TAP RDL
  SelectPort     sel_A { Attribute intel_tdr_dest = "regA"; }
  SelectPort     sel_B { Attribute intel_tdr_dest = "regB"; }

  ScanInterface c_ip { 
     Port si_AB; 
     Port so_AB; 
     Port sen;
  }

}
