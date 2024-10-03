#!/usr/intel/bin/tclsh

proc print_help {} {
    puts "get_dp_collateral <process n3/n5p/n6> <dp version> <views.csv> <output path> <dp_root_path>"
    exit 1
}

set process [lindex $argv 0]
if {[string match "*help*" $process]} {
    print_help
    exit
}

set dp_version [lindex $argv 1]
# Example non Intel tech dp_root_path - set dp_root_path "/p/tech/$process/tech-prerelease/$dp_version/flowinterface"
# Example Intel tech dp_root_path - set dp_root_path "/p/hdk/cad/eou_tech_config_1276/2020.eou_integ_1276_ww19.p1.eb/runs/dhm/1276.31/scripts/vars.tcl"
set dp_root_path [lindex $argv 4]

if {! [file exists $dp_root_path]}  {
    error "Unable to read $dp_root_path. Check if you have $process permission"
    exit
}

## List the vars.tcl source based on technology
if {$process == "true"} {
    set list_of_vars_tcl [split [eval exec "find -L $dp_root_path -type f -name vars.tcl | grep dp"] \n]
} else {
    set list_of_vars_tcl [split [eval exec "find -L $dp_root_path -type f -name vars.tcl"] \n]
}

foreach vars_tcl $list_of_vars_tcl {    
    puts "Sourcing $vars_tcl"
    if {[lindex $argv 3] == ""} {
	set outpath "output"
    } else {
	set outpath [lindex $argv 3]
	
    }    
    ## Determine output files path
    if {$process == "true"} {
	regexp {eou_tech_config_1276(.*)vars\.tcl} $vars_tcl all match
    } else {
	regexp {flowinterface(.*)vars\.tcl} $vars_tcl all match
    }
    set outpath [file normalize $outpath]
    set outpath $outpath$match
    file mkdir $outpath

    ## Get the views.csv file
    if {[lindex $argv 2] == ""} {
	set query_file "./views.csv"
    } else {
	
	set query_file [file normalize [lindex $argv 2]]
    }
    
    if {![file exists $query_file]} {
	puts "Error: $query_file does not exit";
	print_help
	
    }
    set qf [open $query_file r]
    
    while {[gets $qf line] >= 0 } {
	
	if {[string trim $line] == ""} {
	    continue
	} 
	
	if {[string match "#*" [string trim $line]]} {
	    continue
	} 
	
	puts "------------------------------------------------------------------------------------------------------"
	set view_type [string trim [lindex [split $line ,] 0]]
	puts "View Type: $view_type"
	
	## Waive EOU design components - FIXME
	set waived_vars {pscript_dir build_dir build_name bscript_dir gscript_dir tscript_dir PDK_DIR g1m g1mls g1mspecial g1mhs g1mglbclk}
	foreach dummy $waived_vars {
	    if {! [info exists ivar($dummy)] } {
		set ivar($dummy) "waived"
		set env($dummy) "waived"
	    }
	}
	
	if {[catch {source $vars_tcl} issue] } {
	    puts "Error: $issue"
	    exit
	}
	
	if {$view_type == ""}  {
	    error "4th argument can't be empty"
	    exit
	    
	}
	set corner  [string trim [lindex [split $line ,] 1]]
	set corner_name [join $corner .]

	set lib_type  [string trim [lindex [split $line ,] 2]]
	set lib_name [join $lib_type .]
	
	set all_view_names [array names ivar]

	### Search for the views in the source ivar array
	set outfile "$outpath$view_type.list"
	if {$lib_type != "" && $corner != ""} {
	    set view_path_query ""
	    foreach lib $lib_type {
		foreach current $corner {
		    puts "Lib Type: $lib and RC/OC Type: $current"  
		    set outfile "$outpath$view_type.$lib_name.$corner_name.list"
		    append view_path_query "$view_path_query [lsearch -all -inline $all_view_names "*,$lib,$view_type,$current"]"
		}
	    }	    
	} elseif {$lib_type != ""} {
	    set view_path_query ""
	    foreach lib $lib_type {
		puts "Lib Type: $lib"
		set outfile "$outpath$view_type.$lib_name.list"
		append view_path_query "$view_path_query [lsearch -all -inline $all_view_names "*,$lib,$view_type*"]"
	    }
	} elseif {$corner != ""} {
	    set view_path_query ""
	    foreach current $corner {
		puts "RC/OC Type: $current"
		set outfile "$outpath$view_type.$corner_name.list"
		append view_path_query "$view_path_query [lsearch -all -inline $all_view_names "*,$view_type,$current"]"
	    }
	} else {
	    set view_path_query [lsearch -all -inline $all_view_names "*,$view_type*"]
	}
	
	### Sort the search result and ignore duplicate result
	set view_path_query [lsort -unique [string trim $view_path_query]]
	
	## Write the output view.list file
	puts "Writing $outfile"
	#puts "------------------------------------------------------------------------------------------------------"
	set fp [open $outfile w+]
	foreach query $view_path_query {
	    if {[string trim $ivar($query)] != ""} {
		#puts $fp $ivar($query)
		set query_item [regexp -inline -all -- {\S+} $ivar($query)]
		foreach item $query_item {
		    puts $fp $item
		}
	    }
	}
	close $fp
    }
    puts "Source File Done"
    
    array unset ivar
}
close $qf
