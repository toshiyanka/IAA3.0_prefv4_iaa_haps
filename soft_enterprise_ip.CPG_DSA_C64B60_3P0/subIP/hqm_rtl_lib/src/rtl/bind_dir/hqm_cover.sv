
`ifdef HQM_COVER_ON

module hqm_cover();

  // Insert coverage code here
  // Refer to signals defined in hqm with 'hqm.' prefix
  // Refer to signals defined in sub-modules of hqm with 'hqm.<sub-module instance name>.' prefix (substitute <sub-module instance name> with actual sub-module instance name)

endmodule

bind hqm_sip hqm_cover i_hqm_cover();

`endif
