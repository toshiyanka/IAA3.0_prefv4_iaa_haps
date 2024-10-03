vpx add ignored inputs  *test_si*            -rev
vpx add ignored outputs *sbe_visa_bypass_cr_out*       -both
vpx add ignored outputs *sbe_visa_serial_rd_out*       -both
vpx add ignored outputs *test_so*            -rev
vpx add ignored outputs *avisa_clk_out*     -both
vpx add ignored outputs *avisa_data_out*    -both
vpx add ignored outputs *visa_port_tier*    -both
vpx add ignored outputs *visa_fifo_tier*    -both
vpx add ignored outputs *visa_agent_tier*    -both
vpx add ignored outputs *visa_reg_tier*    -both
vpx add ignored inputs  visa_all_disable      -both
vpx add ignored inputs  visa_ser_cfg_in*      -both
vpx add ignored inputs  visa_customer_disable -both

vpx add pin constraints 0 *test_si*           -both
vpx add pin constraints 0 test_cgtm           -rev
vpx add pin constraints 0 fdfx_rst_b          -both
vpx add pin constraints 0 fdfx_powergood      -both
vpx add pin constraints 0 fscan_mode          -both
vpx add pin constraints 0 fscan_shiften       -both
vpx add pin constraints 0 fscan_rstbypen      -both
vpx add pin constraints 1 fscan_byprst_b      -both
vpx add pin constraints 0 fscan_clkungate     -both
vpx add pin constraints 0 fscan_clkungate_syn -both
vpx add pin constraints 0 fscan_latchopen     -both
vpx add pin constraints 1 fscan_latchclosed_b -both
