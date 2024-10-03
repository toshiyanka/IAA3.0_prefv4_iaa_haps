
##..........FEV_SETUP..............

vpx set log file logs/lec.log -replace
vpx !date
tclmode
vpx set system mode setup
vpx usage -auto -elapse
vpx set verification information uvi_17.20-s300
vpx set rule handling RTL7.14 -Error
vpx set hdl option -max_for_loop_size 50000
vpx set hdl option -use_library_first on
vpx set dofile abort exit
vpx set flatten model -nodff_to_dlat_zero
vpx set flatten model -nodff_to_dlat_feedback
vpx set flatten model -seq_constant
vpx set flatten model -latch_fold
vpx set flatten model -latch_transparent
vpx set flatten model -gated_clock
vpx set wire resolution wire
vpx set compare effort low
vpx set flatten model

##//........Reading libray files..........

vpx read library /p/hdk/cad/stdcells/e05/18ww08.3_e05_j.1_tglgt/lib/nldm/p1274d7/nn/e05_nn_p1274d7_tttt_v065_to_v065_t100_max.lib /p/hdk/cad/stdcells/e05/18ww08.3_e05_j.1_tglgt/lib/nldm/p1274d7/nn/e05_nn_p1274d7_tttt_v065_t100_max.lib /p/hdk/cad/stdcells/e05/18ww08.3_e05_j.1_tglgt/lib/nldm/p1274d7/wn/e05_wn_p1274d7_tttt_v065_t100_max.lib /p/hdk/cad/stdcells/e05/18ww08.3_e05_j.1_tglgt/lib/nldm/p1274d7/ln/e05_ln_p1274d7_tttt_v065_to_v065_t100_max.lib /p/hdk/cad/stdcells/e05/18ww08.3_e05_j.1_tglgt/lib/nldm/p1274d7/ln/e05_ln_p1274d7_tttt_v065_t100_max.lib -liberty -nosensitive -both  -pg_pin
vpx read library /p/hdk/cad/stdcells/e05/18ww08.3_e05_j.1_tglgt/v/primitives/e05_primitives_verilog.v /p/hdk/cad/stdcells/e05/18ww08.3_e05_j.1_tglgt/v/nn/e05_nn_core.v /p/hdk/cad/stdcells/e05/18ww08.3_e05_j.1_tglgt/v/ln/e05_ln_core.v /p/hdk/cad/stdcells/e05/18ww08.3_e05_j.1_tglgt/v/wn/e05_wn_core.v -verilog -define functional -lastmod  -nosensitive -both -append
vpx report rule check LIB_LINT* -verbose > reports/dfxsecure_plugin.lib_lint.rpt

##//........Reading Golden design..........

vpx set hdl options -include_src_dir off
vpx add search path /nfs/iind/disks/dteg_disk007/users/adithya1/srinidh/TSA/dteg-dfxsecure_plugin/source/rtl/include -golden
vpx add search path /nfs/iind/disks/dteg_disk007/users/adithya1/srinidh/TSA/dteg-dfxsecure_plugin/target/dfxsecure_plugin/ADL/mat1.5.3.p0_p1274.7/aceroot/results/DC/dfxsecure_plugin/collateral/rtl -golden
vpx read design  /nfs/iind/disks/dteg_disk007/users/adithya1/srinidh/TSA/dteg-dfxsecure_plugin/source/rtl/dfxsecure_plugin/dfxsecure_plugin.sv -sv09 -noelaborate -golden -functiondefault z -define INTEL_SVA_OFF   
vpx elaborate design -root dfxsecure_plugin  -golden -rootonly

##//........Reading Revised design..........

vpx read design /nfs/iind/disks/dteg_disk007/users/adithya1/srinidh/TSA/dteg-dfxsecure_plugin/target/dfxsecure_plugin/ADL/mat1.5.3.p0_p1274.7/aceroot/results/DC/dfxsecure_plugin/syn/outputs/dfxsecure_plugin.syn_final.vg -verilog -revised -noelaborate -nobboxempty 
vpx elaborate design -root dfxsecure_plugin -revised -rootonly
vpx report modules -inst -library -both > reports/dfxsecure_plugin.lib.inst.rpt
vpx uniquify -nolib -all -verbose 
vpx report rule check HRC3.10 -verbose > reports/dfxsecure_plugin.paranoia.hrc3.10.rpt
vpx report rule check IGN1.1 -verbose > reports/dfxsecure_plugin.paranoia.ign1.1.rpt
vpx report rule check RTL9.10a -verbose > reports/dfxsecure_plugin.rtl9.10a.rpt
vpx report rule check RTL20.* -verbose > reports/dfxsecure_plugin.rtl20.liblistcheck.rpt
vpx report black box -module -detail -nohidden -reason
vpx report black box -module -detail -nohidden -reason > reports/dfxsecure_plugin.bbox.details.rpt
vpx report black box -inst -detail >> reports/dfxsecure_plugin.bbox.details.rpt
vpx report design data -verbose > reports/dfxsecure_plugin.design_data.rpt
vpx report modules -inst -golden > reports/dfxsecure_plugin.inst.golden.rpt
vpx report modules -inst -revised > reports/dfxsecure_plugin.inst.revised.rpt
vpx report modules -paraminfo -inst -source -library -both > reports/dfxsecure_plugin.hierfile

##//........Setting up mapping ..........

vpx add mapping model *ctech_lib_clk_div2_reset* -inverted -design -both
vpx set mapping method -phasemapmodel
vpx add renaming rule -PIN_MULTIDIM_TO_1DIM
vpx set mapping method -nophase -BBOX_NAME_MATCH -name first -nounreach
vpx set multibit option -prefix \"auto_vector_\" -delimiter \"__\"
vpx set analyze option -auto -analyze_abort
vpx set analyze option -auto -analyze_setup 
vpx set compare options -threads 1
vpx set compare options -report_bbox_input -verify_disabled_ports
vpx set mapping method -nophase
vpx vpxmode
vpx write hier_compare dofile dfxsecure_plugin.hiercomp.do -noexact_pin_match -constraint  -balanced_extractions -function_pin_mapping -input_output_pin_equivalence  -replace -usage -verbose -append_string " dofile /nfs/iind/disks/dteg_disk007/users/adithya1/srinidh/TSA/dteg-dfxsecure_plugin/target/dfxsecure_plugin/ADL/mat1.5.3.p0_p1274.7/aceroot/results/DC/dfxsecure_plugin/fev/outputs/hier_fev_append.do" -prepend_string " dofile /nfs/iind/disks/dteg_disk007/users/adithya1/srinidh/TSA/dteg-dfxsecure_plugin/target/dfxsecure_plugin/ADL/mat1.5.3.p0_p1274.7/aceroot/results/DC/dfxsecure_plugin/fev/outputs/hier_fev_prepend.do"  -print CPU -print MEMORY -print ELAPSED -compare_string "dofile /nfs/iind/disks/dteg_disk007/users/adithya1/srinidh/TSA/dteg-dfxsecure_plugin/target/dfxsecure_plugin/ADL/mat1.5.3.p0_p1274.7/aceroot/results/DC/dfxsecure_plugin/fev/outputs/compare.do"
vpx tclmode
vpx vpxmode
vpx run hier_compare dfxsecure_plugin.hiercomp.do -check_noneq -verbose 
vpx tclmode
vpx report hier_compare result
vpx set system mode lec
vpx write verification information uvi_17.20-s300
vpx report floating signals -root -undriven -full -both > reports/dfxsecure_plugin.undriven.rpt
vpx report floating signals -root -unused -full -revised > reports/dfxsecure_plugin.unused.rpt
vpx report environment                >  reports/dfxsecure_plugin.summary.rpt
vpx report verification               >> reports/dfxsecure_plugin.summary.rpt
vpx report statistics                 >  reports/dfxsecure_plugin.statistics.rpt
vpx report messages -nosummary        >  reports/dfxsecure_plugin.messages.rpt
vpx report black box -nohidden -both  >  reports/dfxsecure_plugin.blackbox.rpt
vpx report pin constraints -both      >  reports/dfxsecure_plugin.const.rpt
vpx report primary inputs             >  reports/dfxsecure_plugin.primary_inputs.rpt
vpx report primary outputs            >  reports/dfxsecure_plugin.primary_outputs.rpt
vpx report pin equivalences           >  reports/dfxsecure_plugin.pin.equiv.rpt
vpx report compare data -summary	     >  reports/dfxsecure_plugin.compare.data.rpt
vpx report compare data 		    >>  reports/dfxsecure_plugin.compare.data.rpt
vpx report mapped points -TYPE PI PO bbox -class user > reports/dfxsecure_plugin.user.interface.mapped.rpt
vpx report rule check IGN3.2 -design -verbose > reports/dfxsecure_plugin.ign3.2.rpt
vpx report renaming rule   > reports/dfxsecure_plugin.renaming_rules.rpt
vpx report compare data -long -class noneq  >  reports/dfxsecure_plugin.noneq.rpt
vpx report compare data -long -class abort  >  reports/dfxsecure_plugin.abort.rpt
vpx report unmapped points -Golden    >  reports/dfxsecure_plugin.unmapped.rpt
vpx report unmapped points -Revised   >> reports/dfxsecure_plugin.unmapped.rpt
vpx report unmapped points -type pi   >> reports/dfxsecure_plugin.unmapped.rpt
vpx report unmapped points -type po   >> reports/dfxsecure_plugin.unmapped.rpt
vpx report unmapped points -extra     >> reports/dfxsecure_plugin.extra.rpt
vpx report unmapped points -notmapped >> reports/dfxsecure_plugin.notmapped.rpt
vpx write mapped points reports/dfxsecure_plugin.mapped.rpt -replace
vpx report mapped points -method > reports/dfxsecure_plugin.debug.mapped.rpt
vpx report mapped points -type Z -long > reports/dfxsecure_plugin.zmapped.rpt
vpx report unmapped points -type Z > reports/dfxsecure_plugin.unmapped.undriven.rpt
vpx report unmapped points -notmapped -type Z -Golden > reports/dfxsecure_plugin.notmapped.Z.rtl.rpt
vpx report output stuck_at -all > reports/dfxsecure_plugin.stuck_at.rpt
vpx report mapped points -method -summary > reports/dfxsecure_plugin.mapped.method.summary.rpt
vpx report messages -modeling -rule F18 -verbose -golden > reports/dfxsecure_plugin.constants.golden.rpt
vpx report messages -modeling -rule F18 -verbose -revised > reports/dfxsecure_plugin.constants.revised.rpt
vpx report messages -modeling -rule F1 -verbose -golden > reports/dfxsecure_plugin.multidriven.golden.rpt
vpx report messages -modeling -rule F1 -verbose -revised > reports/dfxsecure_plugin.multidriven.revised.rpt
vpx report mapped points -property > reports/dfxsecure_plugin.cone_size.rpt
vpx report mapped points -functional_mapped -verbose > reports/dfxsecure_plugin.mapped.functional.rpt
vpx checkpoint checkpt.lec -replace
vpx !date
