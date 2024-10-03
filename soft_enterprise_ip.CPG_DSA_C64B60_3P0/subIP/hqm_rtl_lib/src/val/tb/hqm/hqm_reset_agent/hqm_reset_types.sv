`ifndef HQM_RESET_TYPES__SV
`define HQM_RESET_TYPES__SV

typedef enum int {
  POWER_GOOD_ASSERT         = 0,  // assert powergood
  POWER_GOOD_DEASSERT       = 1,  // deassert powergood
  RESET_DEASSERT_PART1      = 2,  // deassert all resets except prim_rst
  RESET_DEASSERT_PART2      = 3,  // deassert prim_rst
  RESET_ASSERT              = 4,  // assert all resets
  PRIM_SIDE_RESET_ASSERT    = 5,  // assert prim_rst only
  PRIM_SIDE_CLKREQ_ASSERT   = 6,  // wait for prim/side clkreq assert
  PRIMARY_RESET             = 7,  // assert and deassert prim_rst only
  SIDEBAND_RESET            = 8,  // assert and deassert side_rst only
  PRIM_SIDE_RESET_DEASSERT  = 9,  // assert side_rst only
  PRIM_SIDE_CLKREQ_DEASSERT = 10, // wait for prim/side clkreq deassert
  POWER_UP                  = 11, // ramp power voltage to on state
  POWER_RETENTION           = 12, // ramp power voltage to retention state
  POWER_DOWN                = 13, // ramp power voltage to off state
  PRIM_CLKREQ_DEASSERT      = 14, // wait for prim clkreq deassert
  PRIM_CLKREQ_ASSERT        = 15, // wait for prim clkreq assert
  LCP_RESET                 = 16,
  PRIM_CLKACK_DEASSERT      = 17, // wait for prim clkack deassert
  PRIM_CLKACK_ASSERT        = 18, // wait for prim clkack assert
  DRIVE_CLK_HALT_B_1        = 19, // drive clk halt signals to 1
  LCP_SHIFT_IN              = 20,  // drive only lcp data shift in
  LCP_SHIFT_OUT             = 21,  // check only lcp data shift out
  RESET_ASSERT_WITH_ILLEGAL_FORCE_POK = 22,  // Assert resets without wating on POK
  PRIM_RESET_ASSERT         = 23,  // assert prim_rst only
  PRIM_RESET_DEASSERT       = 24,  // de-assert prim_rst only
  IP_BLOCK_FP_DEASSERT      = 25,  // de-assert ip_block_fp only
  IP_READY_RESP             = 26,   // wait for ip_ready (former config_ack) assert
  RESET_PREP_ACKED          = 27,   // wait for reset_prep_ack assert
  IP_BLOCK_FP_ASSERT        = 28,   // assert ip_block_fp only
  EARLY_FUSES_ASSERT        = 29,   // assert early_fuses onto hqm port
  HW_RESET_FORCE_PWR_ON_ASSERT    = 30,  // assert hw_reset_force_pwr_on only
  HW_RESET_FORCE_PWR_ON_DEASSERT  = 31   // deassert hw_reset_force_pwr_on only

} reset_flow_t;

`endif
