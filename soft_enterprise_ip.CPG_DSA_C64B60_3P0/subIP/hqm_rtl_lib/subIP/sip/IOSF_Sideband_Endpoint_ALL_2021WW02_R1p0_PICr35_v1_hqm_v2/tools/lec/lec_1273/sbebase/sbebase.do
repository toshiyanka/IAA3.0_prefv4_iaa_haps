set dofile abort exit
set log file sbebase_lec.log -replace

// Load Designs
add search path $lec_stdcells -both

read library $lec_libs -both -define functional

read design -File $lec_rtl_list \
            -SystemVerilog      \
            -gol                \
            -sensitive          \
            -root sbebase $lec_defs

// Read Design Parameter List
// ===============
// ASYNCENDPT
//    if 1 generates an asynchronous endpoint and inserts clock crossing logic
//    if 0 will produce a fully synchronous endpoint for the -Golden
// USYNC_ENABLE
//    if 1 uses usyncs for the asynchronous fifos when ASYNCENDPT is 1
// TX_EXT_HEADER_SUPPORT
//    if 1 will use extra logic for inserting extended headers
//    if 0 will end up with optimizations that result in extra logic for *_eh_cnt_reg in -Golden

read design $lec_netlist -Verilog   \
                         -rev       \
                         -sensitive \
                         -root sbebase

//---------------------------------------------------------------------------------------//
//                    PIN CONSTRAINTS
//---------------------------------------------------------------------------------------//
add ignored inputs  test_si* -rev
add ignored outputs test_so* -rev

add pin constraints 0 test_cgtm           -rev
add pin constraints 0 fdfx_rst_b          -both
add pin constraints 0 fdfx_powergood      -both
add pin constraints 0 fscan_mode          -both
add pin constraints 0 fscan_shiften       -both
add pin constraints 0 fscan_rstbypen      -both
add pin constraints 1 fscan_byprst_b      -both
add pin constraints 0 fscan_clkungate     -both
add pin constraints 0 fscan_clkungate_syn -both
add pin constraints 0 fscan_latchopen     -both
add pin constraints 1 fscan_latchclosed_b -both


//------------------------------- OPTIONS  ----------------------------------------------//
set flatten model -gated_clock -seq_constant
uniquify -all -gol
set analyze option -auto -noanalyze_abort -analyze_setup
set mapping method -name first

//---------------------------------------------------------------------------------------//
//                    RENAMING RULES
//---------------------------------------------------------------------------------------//

add renaming rule r1 \. _ -gol -replace -notype PI PO
add renaming rule r2 genblk%d\[%d\] genblk@1_@2 -gol
add renaming rule r3 __ _ -gol
add renaming rule r4 reg\[%d\]\[%d\] reg_@1_@2 -gol
add renaming rule r5 reg\[%u\]\[%d\] reg_@1_@2 -gol
add renaming rule -pin_multidim_to_1dim

//---------------------------------------------------------------------------------------//
//                    LEC MODE : RUN LEC
//---------------------------------------------------------------------------------------//
set sys mo lec

map key points
add mapped points tx_ext_headers[0][31] tx_ext_headers[31] -noinvert
add mapped points tx_ext_headers[0][30] tx_ext_headers[30] -noinvert
add mapped points tx_ext_headers[0][29] tx_ext_headers[29] -noinvert
add mapped points tx_ext_headers[0][28] tx_ext_headers[28] -noinvert
add mapped points tx_ext_headers[0][27] tx_ext_headers[27] -noinvert
add mapped points tx_ext_headers[0][25] tx_ext_headers[25] -noinvert
add mapped points tx_ext_headers[0][26] tx_ext_headers[26] -noinvert
add mapped points tx_ext_headers[0][24] tx_ext_headers[24] -noinvert
add mapped points tx_ext_headers[0][23] tx_ext_headers[23] -noinvert
add mapped points tx_ext_headers[0][22] tx_ext_headers[22] -noinvert
add mapped points tx_ext_headers[0][21] tx_ext_headers[21] -noinvert
add mapped points tx_ext_headers[0][20] tx_ext_headers[20] -noinvert
add mapped points tx_ext_headers[0][19] tx_ext_headers[19] -noinvert
add mapped points tx_ext_headers[0][18] tx_ext_headers[18] -noinvert
add mapped points tx_ext_headers[0][17] tx_ext_headers[17] -noinvert
add mapped points tx_ext_headers[0][16] tx_ext_headers[16] -noinvert
add mapped points tx_ext_headers[0][15] tx_ext_headers[15] -noinvert
add mapped points tx_ext_headers[0][14] tx_ext_headers[14] -noinvert
add mapped points tx_ext_headers[0][13] tx_ext_headers[13] -noinvert
add mapped points tx_ext_headers[0][12] tx_ext_headers[12] -noinvert
add mapped points tx_ext_headers[0][11] tx_ext_headers[11] -noinvert
add mapped points tx_ext_headers[0][10] tx_ext_headers[10] -noinvert
add mapped points tx_ext_headers[0][9]  tx_ext_headers[9]  -noinvert
add mapped points tx_ext_headers[0][8]  tx_ext_headers[8]  -noinvert
add mapped points tx_ext_headers[0][7]  tx_ext_headers[7]  -noinvert
add mapped points tx_ext_headers[0][6]  tx_ext_headers[6]  -noinvert
add mapped points tx_ext_headers[0][5]  tx_ext_headers[5]  -noinvert
add mapped points tx_ext_headers[0][3]  tx_ext_headers[3]  -noinvert
add mapped points tx_ext_headers[0][4]  tx_ext_headers[4]  -noinvert
add mapped points tx_ext_headers[0][2]  tx_ext_headers[2]  -noinvert
add mapped points tx_ext_headers[0][1]  tx_ext_headers[1]  -noinvert
add mapped points tx_ext_headers[0][0]  tx_ext_headers[0]  -noinvert
add comp point -all
comp -NONEQ_print

report key point -unmapped -both > results/sbebase_unmapped.rpt
report floating signals -undriven -both > results/sbebase_undriven.rpt

// save session compare2.save
set comp effort ultra
comp -NONEQ_print

analyze abort -comp

report compare data -nonequivalent > results/sbebase_compare_data.rpt

exit -force
