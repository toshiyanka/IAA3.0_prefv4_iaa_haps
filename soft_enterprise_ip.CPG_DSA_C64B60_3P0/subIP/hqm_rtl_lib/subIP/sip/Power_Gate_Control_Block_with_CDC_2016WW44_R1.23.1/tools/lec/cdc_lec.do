set log file -replace $MODEL_ROOT/results/fv/cdc/cdc_lec.log
set dofile abort off

add search path -golden $MODEL_ROOT/src/rtl/ClockDomainController

read library /p/lptlp/env/lib/fso/core/p1269.8_yd8hbn_1.1v_11.0.0/std/src/yd8hbn_ln_p1269_8x1r0_tttt_1.05v_110.00c_core.lib \
   -lib -nosensitive -both -append

//------------------------------------------------------
// Read Golden RTL
//------------------------------------------------------
read design -SystemVerilog -golden -root ClockDomainController -file $MODEL_ROOT/tools/lec/cdc.filelist

//------------------------------------------------------
// Read Revised Gate-Level Netlist
//------------------------------------------------------
read design -verilog2k -revised -root ClockDomainController $MODEL_ROOT/results/syn/cdc/outputs/ClockDomainController.syn.vg


add renaming rule rtl_gate_vector %u_%d @1[@2] -revised
set mapping method -name first -nets -name_effort hi
set compare effort auto


set system mode lec
add compare points -all
compare -abort_stop 1
report compare data -sum
usage

//------------------------------------------------------
// LEC Reports
//------------------------------------------------------

report design data                              > $MODEL_ROOT/results/fv/cdc/reports/cdc.design_data.rpt
report datapath resource -verbose         	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.datapath.rpt
report ignored output                     	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.ignored.rpt
report rule check -design -verbose        	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.rule.chk.rpt

report tied signals                       	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.tied.signals.rpt
report verification                       	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.verification.rpt
report statistics                         	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.statistics.rpt
report compare data -class equi           	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.compare_data_equivalent.rpt
report compare data -class noneq          	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.compare_data_non_equivalent.rpt
report unmapped points -sum -golden       	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.unmapped_gold_summary.rpt
report unmapped points -sum -revised      	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.unmapped_rev_summary.rpt
report unmapped points -extra             	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.unmapped_extra.rpt
report unmapped points -unreachable -golden     > $MODEL_ROOT/results/fv/cdc/reports/cdc.unmapped_unreach_gold.rpt
report unmapped points -unreachable -revised    > $MODEL_ROOT/results/fv/cdc/reports/cdc.unmapped_unreach_rev.rpt
report unmapped points -notmapped -revised 	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.unmapped_notmapped_rev.rpt
report unmapped points -notmapped -golden 	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.unmapped_notmapped_gold.rpt
report mapped points                      	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.mapped.rpt
report messages -revised                  	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.message_rev.rpt
report messages -compare -both -summary   	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.message_compare.rpt
report messages -mapping -verbose -both   	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.message_mapping.rpt
report messages -model                    	   > $MODEL_ROOT/results/fv/cdc/reports/cdc.message_model.rpt

report hier result -equivalent -usage 	         > $MODEL_ROOT/results/fv/cdc/reports/cdc.hier.equiv.usage.rpt
report hier result -noneq      -usage 	         > $MODEL_ROOT/results/fv/cdc/reports/cdc.hier.noneq.usage.rpt
report hier result -abort      -usage 	         > $MODEL_ROOT/results/fv/cdc/reports/cdc.hier.abort.usage.rpt
report hier result -all        -usage 	         > $MODEL_ROOT/results/fv/cdc/reports/cdc.hier.all.usage.rpt

exit -f
set gui on
