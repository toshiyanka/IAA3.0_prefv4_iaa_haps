################################################################################
#  Intel Top Secret
################################################################################
#  Copyright (C) 2009, Intel Corporation.  All rights reserved.
#
#  This is the property of Intel Corporation and may only be utilized
#  pursuant to a written Restricted Use Nondisclosure Agreement
#  with Intel Corporation.  It may not be used, reproduced, or
#  disclosed to others except in accordance with the terms and 
#  conditions of such agreement.
################################################################################
# Script: reports_utils.tcl
#
# Description: This file contains report related procedures which are commom 
#              to syn and apr flows.
#
# Support Contact : Angadi, Madhumati C <madhumati.c.angadi@intel.com>
#
################################################################################
# Script generates qor reports for ICC mw cel.

######
################################################################################
# Procedure   : report_cell_usage #{{{
# Description : This procedure returns the cell usage statistics and summary.
# Author      : Dror Leon / Soma Kalvala

::parseOpt::cmdSpec report_cell_usage {
    -help "Processes the default timing report, and adds a formatted summary table"
    -opt {
        {-optname show_progress -type boolean -default 0 -required 0 -help "Print out progress in 10% increments when going through the cell list"}
        {-optname breakdown -type boolean -default 1 -required 0 -help "Report design break down to cell groups"}
        {-optname families  -type boolean -default 1 -required 0 -help "Report cell family usage statistics"}
        {-optname detailed  -type boolean -default 0 -required 0 -help "Create detailed cell usage statistics"}
    }
}
proc report_cell_usage {args} {
	set func_name [string trimleft [lindex [info level [info level]] 0] ::]
	if { ![::parseOpt::parseOpts $func_name opt $args] } { return 0 }
    ### The following text contains all the hardcoded data
    ### it should go somewhere like the library define files
    ### where it may be better maintained with lib changes/updates.

    global synopsys_program_name 
	global DATA
	global REF_GROUPS
    
    if {[regexp {^[db]0[24]} [getvar -quiet G_LIBRARY_TYPE]]} {
       array unset DATA
       array unset REF_GROUPS
        # Use STDCELL_BREAK to describe the naming convention of your standard cell library
        # This variable should be treated as a full blown regexp command that will be eval'd
        # Make sure to preserve this form and only manipulate the regular expression itself
        # Any other change will require a matching code change in several places!
        set STDCELL_BREAK {regexp {^([db]0[24])([a-z]{3}\w{2})([xwln]\w)(\w)(\w\d+)$} $ref match lib fam vt grp size}
        # Use REF_GROUPS to define cell groups according to their library cell name (ref_name/template)
        array set REF_GROUPS {
            rpt          {{^[db]0[24](bf|in)}}
            seq          {{^[db]0[24]([x][as]|l[rbty]|f[24rksycou])}}
            clock        {{^[db]0[24](g[in]|g[bf]|cgc)}}
            nac          {{^[db]0[24](gnc|bgn)}}
            tap          {{^[db]0[24](tap)}}
            fib          {{^[db]0[24](qin|qbf|qna|qno|qly|qpd|qct|qsw)}}
            bonus        {{^[db]0[24](bar)}}
            halo         {{^[db]0[24]hl}}
            tie          {{^[db]0[24]tih}}
            spacer       {{^[db]0[24]spc}}
            decap        {{^[db]0[24](dcp|bdc)}}
            power-switch {{^[db]0[24]pws}}
            self-iso-clk {{^[db]0[24]sc[ib]}}
            self-iso-rpt {{^[db]0[24](sw[ib]|dly)}}
            firewall     {{^[db]0[24](sw[ao]|ani|ori|sc[ao])}}
            lvl-shifter  {{^[db]0[24](sv[abco]|slg)}}
            rf           {{^c73p[14]rf(slvm1r1|shdm2r2|elvm1r1|ct1r1)}}
            rom			 {{^c73p[14]rfshdmrom}}
            sram         {{^isr73}}
            idv 		 {{^d8xsidv}}
			localfid     {{^[db]0[24]qfd}}
			globalfid    {{^bsxfbfid}}
        }
        # Use NAME_GROUPS to define cell groups according to their cell name (instance name)
#        array set NAME_GROUPS {
#            filler       {{^xofiller_\w+_\d+$}}
#        }
        # Use COMBOS to define groups of groups that should be accumulated together.
        array set COMBOS {
            all_logic  {logic rpt seq clock self-iso-rpt self-iso-clk firewall nac lvl-shifter power-switch}
            all_macros     {rf sram rom ebb idv }
            all_fcspecialcells    {globalfid localfid}
            all_physical   {tap halo spacer bonus decap}
        }
        # Use LIB_GROUPS to define lib/power groups (according to lib/vt derived from $STDCELL_BREAK)
        array set LIB_GROUPS {
            wn    "Ultra-low leakage stdcells"
            ln    "Low leakage stdcells"
            nn    "Nominal leakage stdcells"
            xn    "Ultra-low leakage stdcells thick gate"
	    d02   "d02 stdcells"
            d04   "d04 stdcells"
			b04   "b04 stdcells"
        }
        ## PLEASE NOTE: In addition to the groups defined above
        ## the total, logic, ebb groups are predefined ones
        ## so they should not be touched

        # The following list describes how the main break down report
        # should be written out (in terms of order of groups)
        set TOP_BREAKDOWN_LIST {
            total break
            logic rpt clock seq power-switch self-iso-clk self-iso-rpt firewall lvl-shifter ebb rf sram rom idv localfid globalfid bonus decap tap spacer fib halo break
            all_fcspecialcells all_macros all_logic all_physical break
            wn ln nn xn break
            d02 d04 b04 break
        }
    } elseif {[regexp {^[fe]} [getvar -quiet G_LIBRARY_TYPE]]} {
       array unset DATA
       array unset REF_GROUPS
        # Use STDCELL_BREAK to describe the naming convention of your standard cell library
        # This variable should be treated as a full blown regexp command that will be eval'd
        # Make sure to preserve this form and only manipulate the regular expression itself
        # Any other change will require a matching code change in several places!
        # e05inv000al1n02x5
        set STDCELL_BREAK {regexp {^([fe][cxa0][0579])(\w{6})(\w)([xwln])(\w)(\w)(\w\w)(\w)(\w)$} $ref match lib fam sch vt m1 height size spacer speed}
        # Use REF_GROUPS to define cell groups according to their library cell name (ref_name/template)
        array set REF_GROUPS {
            rpt          {{^[fe][cxa0][0579](bfn|inv)}}
            hold         {{^[fe][cxa0][0579](bfm|inm)}}
            sseq         {{^[fe][cxa0][0579](x[as]|l[arbtysm]|f[^m])\w0\w{2}[^xyz]}}
            vseq         {{^[fe][cxa0][0579](x[as]|l[arbtysm]|f[^m])\w[2-9]\w{2}[^xyz]}}
            srts         {{^[fe][cxa0][0579](x[as]|l[arbtysm]|f[^m])\w0\w{2}x}}
            vrts         {{^[fe][cxa0][0579](x[as]|l[arbtysm]|f[^m])\w[2-9]\w{2}x}}
            srcc         {{^[fe][cxa0][0579](x[as]|l[arbtysm]|f[^m])\w0\w{2}y}}
            vrcc         {{^[fe][cxa0][0579](x[as]|l[arbtysm]|f[^m])\w[2-9]\w{2}y}}
            sseut        {{^[fe][cxa0][0579](x[as]|l[arbtysm]|f[^m])\w0\w{2}z}}
            vseut        {{^[fe][cxa0][0579](x[as]|l[arbtysm]|f[^m])\w[2-9]\w{2}z}}
            synchronizer {{^[fe][cxa0][0579]fm\w{4}[^xyz]}}
            clock        {{^[fe][cxa0][0579](c[bilmnr]|glbclk)}}
            nac          {{^[fe][cxa0][0579][ypzu](gnc|dpd)}}
            tap          {{^[fe][cxa0][0579](ztp)}}
            fib          {{^[fe][cxa0][0579](qflc|qol)}}
            bonus        {{^[fe][cxa0][0579](qb|bar|qs)}}
            halo         {{^[fe][cxa0][0579](hl|zh|mh)}}
	    hold-fix-buf {{(^[fe]05(inm301a|bfm[246]0[12]a))|(fa0(inv0[234]0a|bfn030))}}
            tie          {{^[fe][cxa0][0579](tih|til|set)}}
            spacer       {{^[fe][cxa0][0579](zspc|zdnn|zdf)}}
            decap        {{^[fe][cxa0][0579]([uz]dc|qg|zdn\d)}}
            power-switch {{^[fe][cxa0][0579]psbf[12]}}
            self-iso-clk {{^[fe][cxa0][0579]cps[ib]}}
            self-iso-rpt {{^[fe][cxa0][0579](psin|psbf0)}}
            firewall     {{^[fe][cxa0][0579](psan|psor)}}
            lvl-shifter  {{^[fe][cxa0][0579](csgld|sgl|sll0|sg00)}}
            rf           {{^ip7\d\d?rf(slvm|shdm|elvm|ct|shpm)\dr\dw}}
            rom          {{^ip7\d\d?rf(shdm|shpm)rom}}
            sram         {{^ip7\d\d?sr}}
            idv          {{^[de]8x[sm]idv}}
            odi          {{^ip74xodi}}
            vdm          {{^ip74xvdm}}
            dic          {{^[de]8xldic}}
	    localfid     {{^[fe][cxa0][0579](qflf|qfd\d)}}
	    globalfid    {{^(bsxfbfid|[fe][cxa0][0579]qfdg)}}
        }
        
        if { 0 == 1} {
	set ps_ref ""
	foreach sw [get_object_name [get_power_switches -hierarchical -quiet  -filter "within_ilm==false"]] {
	    redirect /dev/null {apr_ps_get_settings_from_upf -ps_name $sw}
	    ## get power switch ref name from ::ps::ps_ref_name
	    lappend ps_ref "$::ps::ps_ref_name" 
	}
	if {[llength $ps_ref] > 0} {
	    set ps_ref [join $ps_ref "|"]
	    set REF_GROUPS(power-switch) $ps_ref
	}
        }

    set halo_ref [getvar -quiet G_CUSTOM_HALO_CELLS_REGEXP]
    set def_halo_patrn {^[fe][cxa0][0579](hl|zh|mh)}
    if {[llength $halo_ref] > 0} {
        set halo_ref [join $halo_ref "|"]
        set REF_GROUPS(halo) $halo_ref|$def_halo_patrn
    } else {
        set REF_GROUPS(halo) $def_halo_patrn
    }

# Use NAME_GROUPS to define cell groups according to their cell name (instance name)
#        array set NAME_GROUPS {
#            filler       {{^xofiller_\w+_\d+$}}
#        }
        # Use COMBOS to define groups of groups that should be accumulated together.
        array set COMBOS {
            stdcell        {logic rpt hold sseq vseq srts vrts srcc vrcc sseut vseut synchronizer clock self-iso-rpt self-iso-clk firewall nac lvl-shifter power-switch hold-fix-buf tie}
            seq            {sseq vseq srts vrts srcc vrcc sseut vseut synchronizer}
            all_vseq       {vseq vrts vrcc vseut}
            ser            {srts vrts srcc vrcc sseut vseut}
            all_vser       {vrts vrcc vseut}
            macro          {rf sram rom ebb idv odi vdm}
            fcspecialcells {globalfid localfid dic}
            physicalonly   {tap halo spacer decap bonus fib}
        }
        # Use LIB_GROUPS to define lib/power groups (according to lib/vt derived from $STDCELL_BREAK)
        array set LIB_GROUPS {
            wn    "Ultra-low leakage stdcells"
            ln    "Low leakage stdcells"
            nn    "Nominal leakage stdcells"
            xn    "Ultra-low leakage stdcells thick gate"
            m1v1  "metal1 variant 1"
            m1v2  "metal1 variant 2"
            e05   "e05 stdcells"
            ec0   "ec0 stdcells"
	    fa0   "fa0 stdcells"
	    f05   "f05 stdcells" 
	    fa9   "fa9 stdcells"
	    e07   "e07 stdcells" 
            ex5   "ex5 stdcells"

        }
        ## PLEASE NOTE: In addition to the groups defined above
        ## the total, logic, ebb groups are predefined ones
        ## so they should not be touched

        # The following list describes how the main break down report
        # should be written out (in terms of order of groups)
        set TOP_BREAKDOWN_LIST {
            total break
            logic rpt hold clock sseq vseq srts vrts srcc vrcc sseut vseut synchronizer power-switch hold-fix-buf self-iso-clk self-iso-rpt firewall lvl-shifter ebb rf sram rom idv odi vdm dic localfid globalfid bonus nac decap tie tap spacer fib halo break
            fcspecialcells macro stdcell physicalonly break
            seq all_vseq ser all_vser break
            wn ln nn xn m1v1 m1v2 break
            ec0 e05 fa0 f05 fa9 e07 ex5 break
        }
    
    } else {
        echo "Fatal error - unrecognized G_LIBRARY_TYPE encountered!"
        return 0
    }
    ### End of hardcoded data section
    ### Code should be pretty much generic from hereon.

    # adding the common groups
    array set COMMON_GROUPS {
        total "All Cells"
        logic "All uncategorized stdcells"
        ebb   "All uncategorized non-stdcells"
    }

    array set DATA {}
    foreach group [concat [array names REF_GROUPS] [array names NAME_GROUPS] [array names LIB_GROUPS] [array names COMMON_GROUPS]] {
        set DATA($group,z) 0.0
        set DATA($group,area) 0.0
        set DATA($group,count) 0
    }
    if { [regexp {^dc} $synopsys_program_name] } {
        set allCells [get_cells -quiet -hierarchical -filter {is_hierarchical==false && within_block_abstraction==false && ref_name!=**logic_0** && ref_name!=**logic_1**}]
    } else {
        set allCells [get_cells -quiet -all -hierarchical -filter {is_hierarchical==false && within_block_abstraction==false && ref_name!=**logic_0** && ref_name!=**logic_1**}]
    }
    set nextPoint 10.0
    set i 0
    set tcc [sizeof_collection $allCells]
    # main loop - go over all cells
    foreach_in_collection c $allCells {
        incr i
        # progress monitor
        if {$opt(-show_progress)} {
            if {[expr (100.0*$i/$tcc)>$nextPoint]} {
                echo "${nextPoint}% done"
                #                               if {$nextPoint>50} {break}
                set nextPoint [expr $nextPoint+10.0]
            }
        }

        set name [get_object_name $c]
        set ref [get_attribute $c ref_name]

        # first try to identify cell group by name
        set groupByName 0
        foreach {group res} [array get NAME_GROUPS] {
            foreach re $res {
                if {[regexp $re $name]} {
                    append ref .$group
                    set groupByName 1
                    break
                }
            }
            if {$groupByName} {break}
        }
        if {[info exists DATA($ref,area)]} {
            # already encountered ref - count
            set cArea $DATA($ref,area)
            set cZ $DATA($ref,z)
            incr DATA($ref,count)
            set group $DATA($ref,group)
        } else {
            # first encounter - identify area, group and initialize
            #Area
            set cWidth  [get_attribute -quiet $c width]
            set cHeight [get_attribute -quiet $c height]
            if {$cWidth!="" && $cHeight!=""} {
                set cArea [expr $cWidth*$cHeight]
            } else {
                set cArea [get_attribute $c area]
                if {$cArea==""} {set cArea 0.0}
            }
            set DATA($ref,area) $cArea
            #Count
            set DATA($ref,count) 1
            #Z
            set cZ 0.0
            redirect /dev/null {set libcellref [get_lib_cells -quiet -of_objects $c]}
            if { [sizeof_collection $libcellref] == 1 } {
                foreach zattr {tg_nominal_n_device_total_width tg_nominal_p_device_total_width tg_svt_n_device_total_width tg_svt_p_device_total_width tg_hvt_n_device_total_width tg_hvt_p_device_total_width} {
                    set z [get_attribute -quiet $libcellref $zattr]
                    if { $z == "" } { set z 0.0 }
                    set cZ [expr $cZ + $z] 
                    unset z
                }
            }
            unset libcellref
            set DATA($ref,z) $cZ

            if {!$groupByName} {
                # identify group
                # search through array of groups
                set found 0
                foreach {group res} [array get REF_GROUPS] {
                    foreach re $res {
                        if {[regexp $re $ref]} {
                            set found 1
                            break
                        }
                    }
                    if {$found} {break}
                }
                if {!$found} {
                    if {[eval $STDCELL_BREAK]} {
                        set group logic
                    } else {
                        set group ebb
                    }
                }
            }
            set DATA($ref,group) $group
        }

        # sum total
        set DATA(total,area) [expr $DATA(total,area)+$cArea]
        set DATA(total,z) [expr $DATA(total,z)+$cZ]
        incr DATA(total,count)

        # sum group data
        set DATA($group,area) [expr $DATA($group,area)+$cArea]
        set DATA($group,z) [expr $DATA($group,z)+$cZ]
        incr DATA($group,count)

        # handle std cells
        if {[eval $STDCELL_BREAK]} {
            # sum vt/lib data
            set vt "[string index $vt 0]n"
            incr DATA($vt,count)
            set DATA($vt,area) [expr $DATA($vt,area)+$cArea]
            set DATA($vt,z) [expr $DATA($vt,z)+$cZ]
            incr DATA($lib,count)
            set DATA($lib,area) [expr $DATA($lib,area)+$cArea]
            set DATA($lib,z) [expr $DATA($lib,z)+$cZ]

            if { [info exists m1] } {
                set variant m1v$m1
                incr DATA($variant,count)
                set DATA($variant,area) [expr $DATA($variant,area)+$cArea]
                set DATA($variant,z) [expr $DATA($variant,z)+$cZ]
            }
            # sum family data
            if { [info exists sch] } {
                set family "$lib$fam$sch"
            } else {
                set family "$lib$fam$grp"
            }
            if {![info exists DATA($family,count)]} {
                set DATA($family,count) 0
                set DATA($family,family) 1
                set DATA($family,area) 0.0
                set DATA($family,z) 0.0
                set DATA($family,group) ""
            }
            incr DATA($family,count)
            set DATA($family,area) [expr $DATA($family,area)+$cArea]
            set DATA($family,z) [expr $DATA($family,z)+$cZ]
            lappend DATA($family,group) $group
        }
    }


    # prepare break down table
    if {$opt(-breakdown)} {
        set table [list]
        foreach group $TOP_BREAKDOWN_LIST {
            if {$group=="break"} {
                lappend table "break"
            } else {
                set includes ""
                if {[info exists REF_GROUPS($group)]} {
                    set includes "ref =~ [join $REF_GROUPS($group) { | }]"
                } elseif {[info exists NAME_GROUPS($group)]} {
                    set includes "name =~ [join $NAME_GROUPS($group) { | }]"
                } elseif {[info exists COMBOS($group)]} {
                    # Sum up combos
                    set DATA($group,count) 0
                    set DATA($group,area) 0.0
                    set DATA($group,z) 0.0
                    set includes $COMBOS($group)
                    foreach from $includes {
                        set DATA($group,count) [expr $DATA($group,count)+$DATA($from,count)]
                        set DATA($group,area)  [expr $DATA($group,area) +$DATA($from,area)]
                        set DATA($group,z)  [expr $DATA($group,z) +$DATA($from,z)]
                    }
                } elseif {[info exists LIB_GROUPS($group)]} {
                    set includes $LIB_GROUPS($group)
                } elseif {[info exists COMMON_GROUPS($group)]} {
                    set includes $COMMON_GROUPS($group)
                }
                set tL $group
                if {$DATA(total,count) == 0} {
                    lappend tL $DATA($group,count) ""
                } else {
                    lappend tL $DATA($group,count) [format "%.2f%%" [expr 100.0*$DATA($group,count)/$DATA(total,count)]]
                }
                if {$DATA(total,area) == "0.0"} {
                   lappend tL [format "%.2f" $DATA($group,area)] ""
                } else {
                   lappend tL [format "%.2f" $DATA($group,area)] [format "%.2f%%" [expr 100.0*$DATA($group,area)/$DATA(total,area)]]
                }
                if {$DATA(total,z) == "0.0"} {
                   lappend tL [format "%.2f" $DATA($group,z)] ""
                } else {
                   lappend tL [format "%.2f" $DATA($group,z)] [format "%.2f%%" [expr 100.0*$DATA($group,z)/$DATA(total,z)]]
                }
                lappend tL $includes
                lappend table $tL
                unset tL
            }
        }
        echo "\n\n\n"
        rls_table -title "Break down:" -header {{Group} {Cell count / %} - {Area / %} - {Z / %} - {Includes what}} -table $table -spacious -breaks
    }

    # prepare family table
    if {$opt(-families)} {
        set table [list]
        foreach fRef [lsort -dictionary [array names DATA *,family]] {
            regsub {,family} $fRef {} family
            # create family out of group numbers
            set groups [lsort -unique $DATA($family,group)]
            set groupsCount 0
            set groupsArea 0.0
            set groupsZ 0.0
            foreach group $groups {
                set groupsCount [expr $groupsCount+$DATA($group,count)]
                set groupsArea  [expr $groupsArea +$DATA($group,area)]
                set groupsZ  [expr $groupsZ +$DATA($group,z)]
            }
            #if {$groupsCount==0 || $groupsArea=="0.0"} {
            #    lappend table [list $family $groups $DATA($family,count) "" $DATA($family,area) ""]
            #} else {
            #    lappend table [list $family $groups $DATA($family,count) [format "%.2f%%" [expr 100.0*$DATA($family,count)/$groupsCount]] $DATA($family,area) [format "%.2f%%" [expr 100.0*$DATA($family,area)/$groupsArea]]]
            #}
            set tL [list $family $groups]
            if {$groupsCount==0} {
                lappend tL $DATA($family,count) ""
            } else {
                lappend tL $DATA($family,count) [format "%.2f%%" [expr 100.0*$DATA($family,count)/$groupsCount]]
            }
            if {$groupsArea=="0.0"} {
                lappend tL $DATA($family,area) ""
            } else {
                lappend tL $DATA($family,area) [format "%.2f%%" [expr 100.0*$DATA($family,area)/$groupsArea]]
            }
            if {$groupsZ=="0.0"} {
                lappend tL $DATA($family,z) ""
            } else {
                lappend tL $DATA($family,z) [format "%.2f%%" [expr 100.0*$DATA($family,z)/$groupsZ]]
            }
            lappend table $tL
            unset tL
        }

        echo "\n\n\n"
        rls_table -title "Cell family usage: (and family percentage of group)" -header {{Cell Family} {Group} {Instance Count / %} - {Total Area / %} - {Total Z / %}} -table [lsort -index 1 [lsort -dictionary $table]] -spacious -breaks
    }

    # prepare cell table
    if {$opt(-detailed)} {
        set table [list]
        foreach fRef [lsort -dictionary [array names DATA *,group]] {
            regsub {,group} $fRef {} ref
            if {![info exists DATA($ref,family)]} {
                set actualArea [expr $DATA($ref,area)*$DATA($ref,count)]
                set actualZ [expr $DATA($ref,z)*$DATA($ref,count)]
                if {[eval $STDCELL_BREAK]} {
                    if { [info exists sch] } {
                        set family "$lib$fam$sch"
                    } else {
                        set family "$lib$fam$grp"
                    }
                    #lappend table [list $ref $DATA($fRef) $DATA($ref,count) [format "%.2f%%" [expr 100.0*$DATA($ref,count)/$DATA($family,count)]] $actualArea [format "%.2f%%" [expr 100.0*$actualArea/$DATA($family,area)]] $actualZ [format "%.2f%%" [expr 100.0*$actualZ/$DATA($family,z)]]]
                    set tL [list $ref $DATA($fRef)]
                    if {$DATA($family,count)=="0.0"} {
                        lappend tL $DATA($ref,count) ""
                    } else {
                        lappend tL $DATA($ref,count) [format "%.2f%%" [expr 100.0*$DATA($ref,count)/$DATA($family,count)]]
                    }
                    if {$DATA($family,area)=="0.0"} {
                        lappend tL $actualArea ""
                    } else {
                        lappend tL $actualArea [format "%.2f%%" [expr 100.0*$actualArea/$DATA($family,area)]]
                    }
                    if {$DATA($family,z)=="0.0"} {
                        lappend tL $actualZ ""
                    } else {
                        lappend tL $actualZ [format "%.2f%%" [expr 100.0*$actualZ/$DATA($family,z)]]
                    }
                    lappend table $tL
                    unset tL
                } else {
                    lappend table [list $ref $DATA($fRef) $DATA($ref,count) "" $actualArea "" $actualZ ""]
                }
            }
        }
        echo "\n\n\n"
        rls_table -title "Detailed cell usage: (and percentage from family)" -header {{Cell Template} {Group} {Instance Count / %} - {Total Area / %} - {Total Z / %}} -table [lsort -index 1 [lsort -dictionary $table]] -spacious -breaks
    }
}

