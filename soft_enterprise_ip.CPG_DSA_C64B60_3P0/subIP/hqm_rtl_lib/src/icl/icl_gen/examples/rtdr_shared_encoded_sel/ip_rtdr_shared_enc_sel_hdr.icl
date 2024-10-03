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

  ScanInPort     si_ABC;
  ScanOutPort    so_ABC  { Source NOT_IMPORTANT;}
  
  // Note: Selection of the registers is based on encoding, provided through Enum definition
  // which links register names in the RDL with the required values of the selector bus.
  // Enum is referenced using standard ICL RefEnum property, applied to the selector bus.

  DataInPort     sel_ABC[1:0] { RefEnum IP_REGISTERS;}

  ScanInterface c_ip { 
     Port si_ABC; 
     Port so_ABC; 
     Port sen;
  }

  Enum IP_REGISTERS {
     regA   = 'b01;
     regB   = 'b10;
     regC   = 'b11;
  }

}
