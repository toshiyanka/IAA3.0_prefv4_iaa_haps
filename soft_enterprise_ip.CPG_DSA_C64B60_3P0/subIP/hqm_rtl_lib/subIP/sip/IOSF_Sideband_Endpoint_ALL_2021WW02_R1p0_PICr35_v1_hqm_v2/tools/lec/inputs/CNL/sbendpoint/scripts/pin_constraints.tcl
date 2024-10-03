vpx add ignored inputs  test_si* -rev
vpx add ignored outputs test_so* -rev

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
