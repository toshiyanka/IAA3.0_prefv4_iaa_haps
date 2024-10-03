To get latest version, compile & run regression use:
do_simregs_v2
(assumes you are in a directory one level below hqm-srvr10nm-wave3)
Use netbatch to view the progress.

When done, results should be found under hqm-srvr10nm-wave3/regression/hqm

If you create a directory hqm-srvr10nm-wave3/regression/hqm/saved_txts"
you could run the dn_simregs_v2 script from hqm-srvr10nm-wave3/regression/hqm
to organize the results and copy them to that saved_txts directory you created
#############
Alternately,

To compile use:
bman -mc hqm_tb -s all +s collage +s vcs
bman -mc hqm_tb -s all +s collage +s vcs +s nebulon

To run regressions use:

simregress -l verif/tb/hqm/reglist/reg_tests_atr.list -save
simregress -l verif/tb/hqm/reglist/reg_tests_sai.list
simregress -l verif/tb/hqm/reglist/reg_tests_sb_sai.list
simregress -l verif/tb/hqm/reglist/reg_tests_sb.list
simregress -l verif/tb/hqm/reglist/reg_tests.list
simregress -l verif/tb/hqm/reglist/reg_tests_rs1.list
simregress -l verif/tb/hqm/reglist/reg_tests_rs2.list

##########################################################

Registers matching these patterns are excluded from sai & atr testing :

Registers that match these cause resets that modify states of other registers
*RESET*START*
*RESET_UNIT_STAT*

Registers that match these modify control fields with side effects
*IOSF*CGCTL*
*PM_CAP_CONTROL_STATUS*
*CDC_CTL
*CONTROL_GENERAL

Registers that match these trigger errors when written.
*PARITY_CTL*
*R_INJEC*
*SMON*CONFIGURATION0*

Registers that match these modify critical pointers.
*CFG_HBM_RING_TPTR*
*HPTR_UPDATE*
*TPTR_UPDATE*
*TAILPTR_UPDATE*

Registers matching this pattern are excluded except when write_op_mode == 0
(wom == 0 writes the inverse of the default value to the register)

*CFG_*WMSTAT*  //writing 0 to LWM field sets afull field causing mismatch

