dump -add { pcgu_fpv_wrapper } -depth 0 -scope "."
force pcgu_fpv_wrapper.clock 1 0, 0 2 -repeat 5
force pcgu_fpv_wrapper.reset_b 0
run 100ns
force pcgu_fpv_wrapper.reset_b 1
run 200ns
force pcgu_fpv_wrapper.pgcb_clkreq 0
run 200ns
force pcgu_fpv_wrapper.pgcb_clkreq 1
run 200ns

