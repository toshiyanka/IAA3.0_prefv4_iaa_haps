
set top 

proc run_analyze {} {

    set acmd {  analyze -format sverilog -vcs "+define+INTEL_SVA_OFF  
                
                
                
                
                 " 
             }

    eval $acmd
    return $acmd
}

proc run_elaborate {{elab_switches_list ""}} {

    run_analyze

    if { [llength $elab_switches_list] > 0 } {
        set ecmd [concat "elaborate " $elab_switches_list]
        puts "The elab cmd: $ecmd"
    } else {
        set ecmd "elaborate "
    }
    eval $ecmd
    return $ecmd
}

run_elaborate

source _user.tcl


