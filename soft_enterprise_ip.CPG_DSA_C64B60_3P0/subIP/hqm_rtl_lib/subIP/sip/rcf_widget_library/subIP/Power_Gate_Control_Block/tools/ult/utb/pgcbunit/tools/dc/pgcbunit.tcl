
set top pgcbunit

proc run_analyze {} {

    set acmd {  analyze -format sverilog -vcs "+define+INTEL_SVA_OFF +define+SVA_LIB_SVA2005 \
    +define+INSTANTIATE_HIERDUMP 
                +incdir+../../../../../../../../../../../../site/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-ww17.2/src/rtl/pgcbunit
                -y ../../../../../../../../../../../../site/disks/hdk.cad.2/linux_2.6.16_x86-64/ctech/c2v16ww27e_hdk136/source/v \
    -y ../../../../../../../../../../../../site/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-ww17.2/src/rtl/pgcbunit
                +libext+.sv+.sva
                ../../../../../../../../../../../../site/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-ww17.2/src/rtl/common/pgcb_ctech_map.sv
                ../../../../../../../../../../../../site/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-ww17.2/src/rtl/pgcbunit/pgcbunit.sv " 
             }

    eval $acmd
    return $acmd
}

proc run_elaborate {{elab_switches_list ""}} {

    run_analyze

    if { [llength $elab_switches_list] > 0 } {
        set ecmd [concat "elaborate pgcbunit" $elab_switches_list]
        puts "The elab cmd: $ecmd"
    } else {
        set ecmd "elaborate pgcbunit"
    }
    eval $ecmd
    return $ecmd
}

run_elaborate

source pgcbunit_user.tcl


