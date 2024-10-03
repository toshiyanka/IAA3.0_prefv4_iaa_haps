Module ip {

  ScanInPort     TdiT731L;
  ScanOutPort    TdoT731H { Source NOT_IMPORTANT;}
  TMSPort        TmsT731L;
  TRSTPort       TrstbT731L;
  TCKPort        Tclk;

  // fdfx_pwrgood
  ResetPort      fdfx_powergood { ActivePolarity 0 ; Attribute intel_signal_type = "powergood";}

  // DFx Secure feature enable (no DFx Secure plugin interface)
  DataInPort     feature_en[2:2] { Attribute intel_signal_type = "secure_red" ;}
  DataInPort     feature_en[1:1] { Attribute intel_signal_type = "secure_orange" ;}
  DataInPort     feature_en[0:0] { Attribute intel_signal_type = "secure_green" ;}

  // SLVIDCODE strap
  DataInPort     ftap_slvidcode [31:0] { Attribute intel_signal_type = "slvidcode";  }

  // Client TAP/JTAG interface
  // if IP has more then one TAPs/interfaces, ScanInterface should use c_<tap_in_rdl> naming convention
  // No need of ScanInterface if only one interface/port bundle exists

  ScanInterface c_tap {
    Port TdiT731L;
    Port TdoT731H;
    Port TmsT731L;
  }

}
