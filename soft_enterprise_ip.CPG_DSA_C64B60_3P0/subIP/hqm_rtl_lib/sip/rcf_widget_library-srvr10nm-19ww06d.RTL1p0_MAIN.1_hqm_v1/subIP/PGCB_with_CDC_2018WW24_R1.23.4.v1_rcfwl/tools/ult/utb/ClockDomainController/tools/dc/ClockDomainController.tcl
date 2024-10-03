
set top ClockDomainController

proc run_analyze {} {

    set acmd {  analyze -format sverilog -vcs "+define+INTEL_SVA_OFF +define+SVA_LIB_SVA2005 \
    +define+INSTANTIATE_HIERDUMP 
                +incdir+../../../../../../src/rtl/ClockDomainController
                -y ../../../../../../../../../../../../site/disks/hdk.cad.2/linux_2.6.16_x86-64/ctech/c2v16ww27e_hdk136/source/v \
    -y ../../../../../../src/rtl/ClockDomainController
                +libext+.sv
                ../../../../../../src/rtl/common/pgcb_ctech_map.sv
                ../../../../../../src/rtl/ClockDomainController/ClockDomainController.sv " 
             }

    eval $acmd
    return $acmd
}

proc run_elaborate {{elab_switches_list ""}} {

    run_analyze

    if { [llength $elab_switches_list] > 0 } {
        set ecmd [concat "elaborate ClockDomainController" $elab_switches_list]
        puts "The elab cmd: $ecmd"
    } else {
        set ecmd "elaborate ClockDomainController"
    }
    eval $ecmd
    return $ecmd
}

run_elaborate

source ClockDomainController_user.tcl


