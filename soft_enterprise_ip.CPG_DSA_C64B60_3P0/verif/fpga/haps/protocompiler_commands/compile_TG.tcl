source $env(TARGET_DIR)/protocompiler_commands/database_load.tcl
source $env(TARGET_DIR)/protocompiler_commands/options.tcl

if {[info exists ::env(ENABLE_CDPL)] && $env(ENABLE_CDPL) == 1 && [file exists $env(TARGET_DIR)/vendor_distrib_src/cdpl_hostfile_HapsCompile.txt]} {
    set env(CDPL_FPGA_HOST) [file normalize $env(TARGET_DIR)/vendor_distrib_src/cdpl_hostfile_HapsCompile.txt]
}

if {[info exists ::env(UNIFIED_COMPILE)] && [string compare $env(UNIFIED_COMPILE) ""] != 0} {
puts "compiling in UC flow"
# support for haps_uc 2.0
    database set_state {root}
    launch uc -utf project.utf -ucdb vcs_output.db -v $env(UNIFIED_COMPILE)

    set compile_cmd_str " run compile -ucdb vcs_output.db "
    if {[info exists ::env(IDC_FILE)] && [string compare $env(IDC_FILE) ""] != 0} {
        append compile_cmd_str "-idc \$env(IDC_FILE) -srclist /nfs/site/disks/xne_sv_0001/ankitdh/iaa_haps/soft_enterprise_ip.CPG_DSA_C64B60_3P0/verif/fpga/edif_list.f -src /nfs/site/disks/xne_sv_0001/ankitdh/iaa_haps/soft_enterprise_ip.CPG_DSA_C64B60_3P0/subIP/fpga/cfg/vivado/xcvu440_pcie_phy/xcvu440_pcie_phy.edf"
    }

    if {[info exists ::env(EDIF_FILE)] && [string compare $env(EDIF_FILE) ""] != 0} {
        append compile_cmd_str "-srclist /nfs/site/disks/xne_sv_0001/ankitdh/iaa_haps/soft_enterprise_ip.CPG_DSA_C64B60_3P0/verif/fpga/edif_list.f -src /nfs/site/disks/xne_sv_0001/ankitdh/iaa_haps/soft_enterprise_ip.CPG_DSA_C64B60_3P0/subIP/fpga/cfg/vivado/xcvu440_pcie_phy/xcvu440_pcie_phy.edf"
    }

    append compile_cmd_str " -out compile "
    if {[catch $compile_cmd_str err ]} {
        puts "@E compile stage failed"
        export report -path $env(TARGET_DIR)/rtl_diag/ -all
        exit [error $err]
    }
} else {
puts "compiling in native flow"
# support for haps_legacy
    if {[info exists ::env(IDC_FILE)] && [string compare $env(IDC_FILE) ""] != 0} {
        database set_state {pre_instrument}
        if {[catch { run compile -idc $env(IDC_FILE) -out compile} err ]} {
            puts "@E compile stage failed"
            export report -path $env(TARGET_DIR)/rtl_diag/ -all
            exit [error $err]
        }
    } else {
        set upf_info ""
        if {[info exists ::env(NLP)] && $env(NLP) == 1} {
            if {[info exists ::env(UPF_FILE)] && [string compare $env(UPF_FILE) ""] != 0} {
                set upf_info "-upf \"$env(UPF_FILE)\""
            } else {
                puts "@W Though NLP is set but no UPF_FILE is provided."
            }
        }

        #ANK if {[catch { run compile -srclist $env(ANALYZE_INPUTS)/rtl_sources.pfl -top_module $env(top_module_names) -lmf $env(ANALYZE_INPUTS)/project.lmf  -hdl_define {__USELIBGROUPORDER__ __SYN_COMPATIBLE_INCLUDEPATH__} $upf_info -out compile} err ]} {
        if {[catch { run compile -srclist $env(ANALYZE_INPUTS)/rtl_sources.pfl -top_module $env(top_module_names) -lmf $env(ANALYZE_INPUTS)/project.lmf  -hdl_define {__USELIBGROUPORDER__ __SYN_COMPATIBLE_INCLUDEPATH__} $upf_info -out compile} err ]} {
            

            if {[info exists ::env(IDC_FILE)] && [string compare $env(IDC_FILE) ""] != 0} {
                append compile_cmd_str "-idc \$env(IDC_FILE) -srclist /nfs/site/disks/xne_sv_0001/ankitdh/iaa_haps/soft_enterprise_ip.CPG_DSA_C64B60_3P0/verif/fpga/edif_list.f -src /nfs/site/disks/xne_sv_0001/ankitdh/iaa_haps/soft_enterprise_ip.CPG_DSA_C64B60_3P0/subIP/fpga/cfg/vivado/xcvu440_pcie_phy/xcvu440_pcie_phy.edf"}
            if {[info exists ::env(EDIF_FILE)] && [string compare $env(EDIF_FILE) ""] != 0} {
               append compile_cmd_str "-srclist /nfs/site/disks/xne_sv_0001/ankitdh/iaa_haps/soft_enterprise_ip.CPG_DSA_C64B60_3P0/verif/fpga/edif_list.f -src /nfs/site/disks/xne_sv_0001/ankitdh/iaa_haps/soft_enterprise_ip.CPG_DSA_C64B60_3P0/subIP/fpga/cfg/vivado/xcvu440_pcie_phy/xcvu440_pcie_phy.edf"
              }

            puts "@E compile stage failed"
            export report -path $env(TARGET_DIR)/rtl_diag/ -all
            exit [error $err]
        }
    }
 }

export report -path $env(TARGET_DIR)/rtl_diag/ -all

source $env(TARGET_DIR)/protocompiler_commands/database_close.tcl
