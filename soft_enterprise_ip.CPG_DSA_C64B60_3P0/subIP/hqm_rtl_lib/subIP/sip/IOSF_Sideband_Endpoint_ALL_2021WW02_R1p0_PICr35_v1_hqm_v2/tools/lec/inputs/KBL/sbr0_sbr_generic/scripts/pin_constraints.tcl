# PIN Constraints
vpx add ignored outputs *avisa_clk_out*       -both
vpx add ignored outputs *avisa_data_out*      -both
vpx add ignored inputs  test_si*              -rev
vpx add ignored outputs test_so*              -rev
vpx add ignored inputs  visa_all_disable      -both
vpx add ignored inputs  visa_ser_cfg_in*      -both
vpx add ignored inputs  visa_customer_disable -both

vpx add pin constraints 1 fscan_byprst_b      -both
vpx add pin constraints 0 fscan_clkungate     -both
vpx add pin constraints 0 fscan_clkungate_syn -both
vpx add pin constraints 0 fscan_latchopen     -both
vpx add pin constraints 1 fscan_latchclosed_b -both
vpx add pin constraints 0 fscan_mode          -both
vpx add pin constraints 0 fscan_ret_ctrl      -both
vpx add pin constraints 0 fscan_rstbypen      -both
vpx add pin constraints 0 fscan_shiften       -both
vpx add pin constraints 0 pgcb_tck            -both
vpx add pin constraints 1 fdfx_powergood      -both
vpx add pin constraints 0 fdfx_pgcb_bypass    -both
vpx add pin constraints 0 fdfx_pgcb_ovr       -both
vpx add pin constraints 1 fdfx_rst_b          -both
vpx add pin constraints 0 fdfx_policy_update  -both
vpx add pin constraints 0 fdfx_secure_policy* -both
vpx add pin constraints 0 fdfx_earlyboot_exit -both
vpx add pin constraints 0 oem_secure_policy*  -both

