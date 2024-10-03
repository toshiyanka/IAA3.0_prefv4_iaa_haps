//--------------DO NOT EDIT COMMENT LINES--------------//


//begin PRE.read_lib
vpx set rule handling HRC3.3 -Warning
vpx set rule handling RTL19.3 -Warning
vpx set compare option -allgenlatch
vpx set undriven signal 0 -golden
//vpx add notranslate -module sbebulkrdwrwrapper -both

//begin POST.read_lib


//begin PRE.read_golden


//begin POST.read_golden


//begin PRE.read_revised


//begin POST.read_revised


//begin PRE.read_upf


//begin POST.read_upf


//begin PRE.power_check_one


//begin POST.power_check_one


//begin PRE.map

//From FEBE hier_fev_append.do
//vpx analyze abort -compare -threads 4 -verbose

//From FEBE renaming_rules.tcl
vpx add renaming rule dot2und {"\."} {"_"} -both
vpx add renaming rule bra2und {"\[%w\]"} {"_@1"} -notype pi po -both
//vpx add renaming rule -pin_multidim_to_1dim
vpx add renaming rule pinrul1 {"\[%w\]"} {"_@1"} -pin -both
//vpx add renaming rule n1 "sync_reg_1_0\/dff0\/U\\\$1" "sync_reg_0_0" -rev
//vpx add renaming rule n2 "sync_reg_1_0\/dff1\/U\\\$1" "sync_reg_1_0" -rev

vpx add mapping model *ctech_lib_doublesync_setb_* *ctech_lib_doublesync_set_*  -inverted -design -revised
vpx set mapping method -phasemapmodel

//From FEBE pin_constraints.tcl
//vpx add ignored inputs  *tx_ext_headers*     -both
//vpx add ignored inputs  *test_si*            -both
vpx add ignored outputs *sbe_visa_bypass_cr_out*       -both
vpx add ignored outputs *sbe_visa_serial_rd_out*       -both

//vpx add ignored outputs *treg_ext_header*    -both
//vpx add ignored outputs *\/treg_ext_header*    -rev
//vpx add ignored outputs *\/treg_ext_header\[*\]\[*\]    -rev
vpx add ignored outputs *test_so*            -both
vpx add ignored outputs *avisa_clk_out*     -both
vpx add ignored outputs *avisa_data_out*    -both
//vpx add ignored outputs *visa_reg_tier*    -both

//vpx add ignored outputs *visa_port_tier*    -both
//vpx add ignored outputs *visa_fifo_tier*    -both
//vpx add ignored outputs *visa_agent_tier*    -both
//vpx add ignored outputs *visa_reg_tier*    -both
//vpx add ignored inputs  visa_all_disable      -both
//vpx add ignored inputs  visa_ser_cfg_in*      -both
//vpx add ignored inputs  visa_customer_disable -both

//vpx add pin constraints 0 *tx_ext_headers*    -both
vpx add pin constraints 0 *test_si*           -both
//vpx add pin constraints 0 test_cgtm           -both
//vpx add pin constraints 0 fdfx_rst_b          -both
//vpx add pin constraints 0 fdfx_powergood      -both
//vpx add pin constraints 0 fscan_mode          -both
//vpx add pin constraints 0 fscan_shiften       -both
//vpx add pin constraints 0 fscan_rstbypen      -both
//vpx add pin constraints 1 fscan_byprst_b      -both
//vpx add pin constraints 0 fscan_clkungate     -both
//vpx add pin constraints 0 fscan_clkungate_syn -both
//vpx add pin constraints 0 fscan_latchopen     -both
//vpx add pin constraints 1 fscan_latchclosed_b -both

//From training slides
//vpx set undefined cell black_box -both
vpx add pin con 0 fscan_clkungate_syn -both
vpx add pin con 0 fscan_shiften -both
//vpx set undefined cell black_box -both
//vpx set undriven sig 0 -gold

//vpx analyze datapath -module sbebulkrdwrwrapper.sv -resource /gen_rata.gen_bulk_widget.sbebulkrdwrwrapper -threads 4 -verbose 
//vpx analyze datapath -wdfg -verbose


//begin POST.map


//begin PRE.switch2lec


//begin mapping


//begin POST.switch2lec


//begin PRE.verify


//begin POST.verify


//begin PRE.report


//begin POST.report


//begin PRE.power_check_two


//begin POST.power_check_two
