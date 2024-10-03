set log file -replace $MODEL_ROOT/results/fv/tooltb/tooltb_lec.log
set dofile abort off

add search path -golden $MODEL_ROOT/src/rtl/pgcbunit
add search path -golden $MODEL_ROOT/src/rtl/pcguunit
add search path -golden $MODEL_ROOT/src/rtl/ClockDomainController
add search path -golden $MODEL_ROOT/verif/pcgu_ref/rtl

read library /p/kits/intel/p1273/p1273_1.8.0/stdcells/d04/default/latest/lib/ln/d04_ln_1273_1x1r3_tttt_v075_t70_min.lib \
   -lib -nosensitive -both -append

//------------------------------------------------------
// Read Golden RTL
//------------------------------------------------------
read design -SystemVerilog -golden -root tooltb -file $MODEL_ROOT/tools/lec/tooltb.filelist

//------------------------------------------------------
// Read Revised Gate-Level Netlist
//------------------------------------------------------
read design -verilog2k -revised -root tooltb $MODEL_ROOT/tools/syn/tooltb/outputs/tooltb.syn_final.vg


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

report design data                              > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.design_data.rpt
report datapath resource -verbose         	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.datapath.rpt
report ignored output                     	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.ignored.rpt
report rule check -design -verbose        	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.rule.chk.rpt

report tied signals                       	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.tied.signals.rpt
report verification                       	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.verification.rpt
report statistics                         	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.statistics.rpt
report compare data -class equi           	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.compare_data_equivalent.rpt
report compare data -class noneq          	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.compare_data_non_equivalent.rpt
report unmapped points -sum -golden       	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.unmapped_gold_summary.rpt
report unmapped points -sum -revised      	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.unmapped_rev_summary.rpt
report unmapped points -extra             	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.unmapped_extra.rpt
report unmapped points -unreachable -golden     > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.unmapped_unreach_gold.rpt
report unmapped points -unreachable -revised    > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.unmapped_unreach_rev.rpt
report unmapped points -notmapped -revised 	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.unmapped_notmapped_rev.rpt
report unmapped points -notmapped -golden 	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.unmapped_notmapped_gold.rpt
report mapped points                      	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.mapped.rpt
report messages -revised                  	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.message_rev.rpt
report messages -compare -both -summary   	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.message_compare.rpt
report messages -mapping -verbose -both   	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.message_mapping.rpt
report messages -model                    	   > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.message_model.rpt

report hier result -equivalent -usage 	         > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.hier.equiv.usage.rpt
report hier result -noneq      -usage 	         > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.hier.noneq.usage.rpt
report hier result -abort      -usage 	         > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.hier.abort.usage.rpt
report hier result -all        -usage 	         > $MODEL_ROOT/results/fv/tooltb/reports/tooltb.hier.all.usage.rpt

exit -f
set gui on
