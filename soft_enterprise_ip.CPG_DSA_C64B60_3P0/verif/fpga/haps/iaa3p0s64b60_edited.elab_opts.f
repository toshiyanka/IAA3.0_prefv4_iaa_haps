-cm_seqnoconst
-assert enable_diag
-assert enable_hier
#-assert disable_rep_opt
#-assert disable_assert      
-lca
-kdb
-ntb_opts sv_fmt
-j8
+vpi
-picarchive
-licqueue
-debug_access+all
#-fastpartcomp=j8
#-partcomp=autopartdbg
#-partcomp=autopart_relax
-P $VERDI_HOME/share/PLI/VCS/LINUX64/novas.tab $VERDI_HOME/share/PLI/VCS/LINUX64/pli.a
-congruency -cong_hier $WORKAREA/tools/congruency/iax.icxl2.congruency
-xprop=$WORKAREA/tools/vcs/iaa3p0s64b60_xprop.cfg
-power=rtlpg -power=ignore_latch_split -power=attributes_on
+warn=noSVA-TIDE
-error=REO
-error=UNIQUE
-error=TEIF
-error=PRIORITY
#MG-error=ENUMASSIGN
-error=MTOCMUCS
-error=SV-SVPIA
-error=ICTA-SI
-error=SV-SELS
-error=IPC
-error=DPIMI
-error=INAV
-error=FLVU
-error=FVNU
-error=ZONMCM
#TG-error=IPDASP
#-error=AOUP
-error=FRCREF
-error=ISALS
-error=SV-ANDNMD
-error=OSVF-NPVIUFPI
-error=CIWC
#-error=CWUC
-error=MATN
-error=AICE
-error=IUWI
-error=DTIIO
-error=CNST-LOOP-UNUSE
-error=IASC
-error=DTIIC
-error=ECS
-error=MDVMO
-error=DTII
-error=CIWC
#-error=ICTTFC
-error=ENUMASSIGNTYPE
-error=TMPO
-error=IBMAMS
-error=WUIMCM
# Dump RTL hierarchies when VCSSIM make target launched with DUMP_HIERARCHY=1
$XCTDIAG
# Pass in coverage args from makefile
$VCSSIM_COV_ELAB_OPTS
/nfs/site/disks/xne_sv_0001/tgoswami/ev2_dsaiaa_updated/soft_enterprise_ip.CPG_DSA_C64B60_3P0/soft_enterprise_ip.CPG_DSA_C64B60_3P0/subIP/UHFI_v4.13.0/subIP/vc/pcie_bfm/rev099_1/Linux_x86_64/libpcie.so
#For debugging
#-Xctdiag=cfgverbose,vhdl
-debug_access+all 
-config_verbose
#-error=noMPD

#-error=ENUMASSIGN  # Illegal assignment to enum variable

#elab options for HAPS
#-full64
-kdb iaa3p0s64b60_uhfi_ref_design_rtl_lib.uhfi_ref_top 
-syn_dw+dump_dir=$WORKAREA/output/$DUT/fpga/haps_haps/$WORKDIR/dsaiaa_fpga_1/HAPS-80/analyzed_libs
-hw_top=uhfi_ref_top 
-debug_all
-liblist_work 
-liblist_nocelldiff 
+error+1000 
-libmap_verbose 
-force_list 
-config_verbose 
-power=dump_tokens 
-power=rtlpg 
-error=noUPF_PSW_PORT_NOT_FOUND 
-error=noUPF_ISSS 
-error=noUPF_IUO 
-error=noUPF_PDDNE 
-error=noUPF_SS_UPDATE_ND 
-error=noUPF_USS 
-error=noUPF_OBJECT_NOT_FOUND_ERROR 
-error=noUPF_OBJECTS_NOT_FOUND 
-error=noUPF_MULTIPLE_DRIVERS 
-error=noUPF_SDA_TT 
-error=noUPF_RDUO 
-error=noUPF_USN 
-error=noMPD 
-error=noUPF_SDA_ME 
-error=noUPF_SDA_WE 
-power=unified_model 
-power=scm_mem_ret 
-power=disable_boundary_gates 
-xzebu 
-Xkfir=0x100

   
#-Xmf=0x80000
#
#+librescan

