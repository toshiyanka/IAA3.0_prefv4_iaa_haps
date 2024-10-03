
###==== BEGIN Header

# Synopsys, Inc. constraint file

# Custom constraint commands may be added outside of the SCOPE tab sections bounded with BEGIN/END.
# These sections are generated from SCOPE spreadsheet tabs.

###==== END Header

###==== BEGIN Collections - (Populated from tab in SCOPE, do not edit)
###==== END Collections

###==== BEGIN Clocks - (Populated from tab in SCOPE, do not edit)

create_clock  -name {phy_ref_in_clk} {p:pcie_ref_clk_p} -period {10.0}
create_clock  -name {ddr_clk_top} {p:ddr_clk_p} -period {5.0}

#create_clock  -name {xilinx_gthe3_sysclk}          [get_pins -hier {*refclk_ibuf.O}]                            -period {10}
# 12Apr Per Rodrigo, the next line is to be used.  Removing this line.  create_clock  -name {xilinx_pcie_userclk} -period 16  [get_pins -hier {*i_pcie3_ultrascale_0.user_clk}]]
create_clock -name {xilinx_pcie_userclk}  [get_pins  {t:i_pcie3_ultrascale_0.inst.gt_top_i.phy_clk_i.bufg_gt_userclk.O}] -period 16 
create_clock -name {xilinx_pcie_gt_sysclk} [get_pins {t:i_pcie3_ultrascale_0.inst.bufg_gt_sysclk.O}] -period 10
create_clock -name {xilinx_pcie_gt_pcllk} [get_pins {t:i_pcie3_ultrascale_0.inst.gt_top_i.phy_clk_i.bufg_gt_pclk.O}] -period 4 
create_clock -name {xilinx_pcie_gt_coreclk} [get_pins {t:i_pcie3_ultrascale_0.inst.gt_top_i.phy_clk_i.bufg_gt_coreclk.O}] -period 4 

#create_clock  -name {hci_pclk}          [get_pins -hier {*pcie_phy_wrapper.pcie_phy.u_xcvu440_pcie_phy.phy_pclk}]                 -period {8}
#create_clock  -name {uhfi_userclk} -period 8  [get_pins -hier {*i_aalpcie_top_xcvu440.i_pcie_top_xcvu440.user_clk}

###==== nss_lce_clk - 12 MHz (83.33), 8 MHz (125),  5 MHz (200), 4 MHz (250)
create_clock  -name {nss_lce_clk} {p:nss_lce_clk} -period {83.33}
#create_clock  -name {nss_lce_clk} {p:nss_lce_clk} -period {125.0}
#create_clock  -name {nss_lce_clk} {p:nss_lce_clk} -period {200.0}
#create_clock  -name {nss_lce_clk} {p:nss_lce_clk} -period {250.0}

###==== nss_core_clk - 10.8 MHz (92.59), 7.2 MHz (138.88), 9 MHz (111.11), 4 MHz (222.2) 3.6MHz (277.7)
create_clock  -name {nss_core_clk} {p:nss_core_clk} -period {92.59}
#create_clock  -name {nss_core_clk} {p:nss_core_clk} -period {138.88}
#create_clock  -name {nss_core_clk} {p:nss_core_clk} -period {277.7}

###==== nss_per_clk - 1.35 MHz (740.74), 900 KHz (1111.11) 1.125 MHz (888.88), 562.5 khz (1777.7)
create_clock  -name {nss_per_clk} {p:nss_per_clk} -period {740.74}
#create_clock  -name {nss_per_clk} {p:nss_per_clk} -period {1111.11}

###==== BEGIN "Generated Clocks" - (Populated from tab in SCOPE, do not edit)

###==== Derived clocks from nss_lce_clk 
#create_generated_clock -name {lce_hiri_clk} -source { p:nss_lce_clk } {t:i_cpm_top.i_hi_top.parcpmhiri.i_cpm_hiri_crdu.i_h_clk_ctech_clk_dop_div2.i_cpm_ctech_clk_divider2_rstb.clkout.Q[0]} -master_clock {c:nss_lce_clk} -divide_by {2}
create_generated_clock -name {lce_hiri_clk} -source { p:nss_lce_clk } {t:i_cpm_top.i_hi_top.parcpmhiri.i_cpm_hiri_crdu.i_h_clk_ctech_clk_dop_div2_nonscan.i_cpm_ctech_clk_divider2_rstb.clkout.Q[0]} -master_clock {c:nss_lce_clk} -divide_by {2}
#create_generated_clock -name {lce_hiti_clk} -source { p:nss_lce_clk } {t:i_cpm_top.i_hi_top.parcpmhiti.i_cpm_hiti_crdu.i_h_clk_ctech_clk_dop_div2.i_cpm_ctech_clk_divider2_rstb.clkout.Q[0]} -master_clock {c:nss_lce_clk} -divide_by {2}
create_generated_clock -name {lce_hiti_clk} -source { p:nss_lce_clk } {t:i_cpm_top.i_hi_top.parcpmhiti.i_cpm_hiti_crdu.i_h_clk_ctech_clk_dop_div2_nonscan.i_cpm_ctech_clk_divider2_rstb.clkout.Q[0]} -master_clock {c:nss_lce_clk} -divide_by {2}
#create_generated_clock -name {lce_wqm_clk} -source { p:nss_lce_clk } {t:i_cpm_top.i_hi_top.parcpmhiwqm.i_cpm_wqm_crdu.i_h_clk_ctech_clk_dop_div2.i_cpm_ctech_clk_divider2_rstb.clkout.Q[0]} -master_clock {c:nss_lce_clk} -divide_by {2}
#create_generated_clock -name {lce_wqm_clk} -source { p:nss_lce_clk } {t:i_cpm_top.i_hi_top.parcpmhiwqm.i_cpm_wqm_crdu.i_h_clk_ctech_clk_dop_div2_nonscan.i_cpm_ctech_clk_divider2_rstb.clkout.Q[0]} -master_clock {c:nss_lce_clk} -divide_by {2}
#create_generated_clock -name {lce_aram_clk} -source { p:nss_lce_clk } {t:i_cpm_top.i_hi_top.parcpmhiaram.i_cpm_aram_crdu.i_h_clk_ctech_clk_dop_div2.i_cpm_ctech_clk_divider2_rstb.clkout.Q[0]} -master_clock {c:nss_lce_clk} -divide_by {2}
create_generated_clock -name {lce_aram_clk} -source { p:nss_lce_clk } {t:i_cpm_top.i_hi_top.parcpmhiaram.i_cpm_aram_crdu.i_h_clk_ctech_clk_dop_div2_nonscan.i_cpm_ctech_clk_divider2_rstb.clkout.Q[0]} -master_clock {c:nss_lce_clk} -divide_by {2}
#create_generated_clock -name {axi3_ddr_clk} -source { p:ddr_clk_p } {t:i_lce_gskt_top.i_axi_ddr3.c0_ddr3_ui_clk} -master_clock {c:ddr_clk} -divide_by {2}

#create_generated_clock -name {axi3_ddr_clk} -source { p:ddr_clk_p } [get_pins {i_lce_gskt_top.i_axi_ddr3.inst.u_ddr3_infrastructure.u_bufg_divClk.O}] -master_clock {c:ddr_clk} -divide_by {2}
create_generated_clock -name {axi3_ddr_clk} [get_pins {t:i_lce_fpga_top.i_lce_gskt_top.i_axi_ddr3.inst.u_ddr3_infrastructure.gen_mmcme3\.u_mmcme_adv_inst.CLKOUT0}]
create_generated_clock -name {axi3_ddr_adn_ui_clk} [get_pins {t:i_lce_fpga_top.i_lce_gskt_top.i_axi_ddr3.inst.u_ddr3_infrastructure.gen_mmcme3\.u_mmcme_adv_inst.CLKOUT1}]

#create_generated_clock -name lce_wqm_clk [get_nets {i_cpm_top.i_hi_top.parcpmhiwqm.i_cpm_wqm_crdu.i_h_clk_ctech_clk_dop_div2_nonscan.i_cpm_ctech_clk_divider2_rstb.clkout}] -source [get_ports {nss_lce_clk}] -divide_by 2
create_generated_clock -name lce_wqm_clk [get_pins {t:i_cpm_top.i_hi_top.parcpmhiwqm.i_cpm_wqm_crdu.i_h_clk_ctech_clk_dop_div2_nonscan.i_cpm_ctech_clk_divider2_rstb.clkout.Q[0]}] -divide_by {2} -master_clock {c:nss_lce_clk}
create_generated_clock -name {lce_wqmarb_clk} -source { p:nss_lce_clk } {t:i_cpm_top.i_hi_top.parcpmhiwqmarb.i_cpm_hiwqmarb_crdu.i_h_clk_ctech_clk_dop_div2_nonscan.i_cpm_ctech_clk_divider2_rstb.clkout.Q[0]} -master_clock {c:nss_lce_clk} -divide_by {2}

###==== END "Generated Clocks"
##set_clock_groups -derive -asynchronous -name {phy_ref_in_clk_grp} -group { {c:phy_ref_in_clk} }
##set_clock_groups -derive -asynchronous -name {xilinx_gthe3_sysclk_grp} -group { {c:xilinx_gthe3_sysclk} }
##set_clock_groups -derive -asynchronous -name {xilinx_pcie_userclk_grp} -group { {c:xilinx_pcie_userclk} }

#set_clock_groups -derive -asynchronous -name {phy_ref_in_clk_grp} -group [get_clocks {phy_ref_in_clk xilinx_pcie_userclk}]
#set_clock_groups -derive -asynchronous -name {phy_ref_in_clk_grp} -group [get_clocks {phy_ref_in_clk} -include_generated_clocks]

##set_clock_groups -derive -asynchronous -group [get_clocks {phy_ref_in_clk xilinx_pcie_userclk xilinx_pcie_gt_sysclk xilinx_pcie_gt_pcllk xilinx_pcie_gt_coreclk}] 

#set_clock_groups -derive -asynchronous -name {nss_lce_clk_grp} -group { {c:nss_lce_clk} {lce_hiri_clk} {lce_hiti_clk} {lce_wqm_clk} {lce_aram_clk} {lce_h_clk} {lce_wqmarb_clk} }
#set_clock_groups -derive -asynchronous -name {nss_core_clk_grp} -group { {c:nss_core_clk} }
#set_clock_groups -derive -asynchronous -name {nss_per_clk_grp} -group { {c:nss_per_clk} }

set_clock_groups -derive -asynchronous -name {ehb_clk_grp} -group [get_clocks {ddr_clk_top axi3_ddr_clk axi3_ddr_adn_ui_clk}]

###For PCIE
set_datapathonly_delay -from [get_clocks {xilinx_pcie_userclk}] -to   [get_clocks {HAPS_umr_clk}] 10.0 
set_datapathonly_delay -to [get_clocks {xilinx_pcie_userclk}] -from   [get_clocks {HAPS_umr_clk}] 10.0 

set_datapathonly_delay -from   [get_clocks {xilinx_pcie_gt_pcllk}] -to [get_clocks {HAPS_umr_clk}] 4.0
set_datapathonly_delay -to   [get_clocks {xilinx_pcie_gt_pcllk}] -from [get_clocks {HAPS_umr_clk}] 4.0

set_datapathonly_delay -from [get_clocks {xilinx_pcie_userclk}] -to   [get_clocks {nss_core_clk}] 16.0 
set_datapathonly_delay -to   [get_clocks {xilinx_pcie_userclk}] -from [get_clocks {nss_core_clk}] 16.0

set_datapathonly_delay -from [get_clocks {xilinx_pcie_userclk}] -to   [get_clocks {nss_per_clk}] 16.0 
set_datapathonly_delay -to   [get_clocks {xilinx_pcie_userclk}] -from [get_clocks {nss_per_clk}] 16.0

###5Mhz
set_datapathonly_delay -from [get_clocks {xilinx_pcie_userclk}] -to   [get_clocks {nss_lce_clk}] 16.0 
set_datapathonly_delay -to   [get_clocks {xilinx_pcie_userclk}] -from [get_clocks {nss_lce_clk}] 16.0

set_datapathonly_delay -from [get_clocks {xilinx_pcie_userclk}] -to   [get_clocks {lce_hiri_clk}] 16.0 
set_datapathonly_delay -to   [get_clocks {xilinx_pcie_userclk}] -from [get_clocks {lce_hiri_clk}] 16.0


set_datapathonly_delay -from [get_clocks {xilinx_pcie_userclk}] -to   [get_clocks {lce_hiti_clk}] 16.0
set_datapathonly_delay -to   [get_clocks {xilinx_pcie_userclk}] -from [get_clocks {lce_hiti_clk}] 16.0


set_datapathonly_delay -from [get_clocks {xilinx_pcie_userclk}] -to   [get_clocks {lce_wqm_clk}] 16.0
set_datapathonly_delay -to   [get_clocks {xilinx_pcie_userclk}] -from [get_clocks {lce_wqm_clk}] 16.0


set_datapathonly_delay -from [get_clocks {xilinx_pcie_userclk}] -to   [get_clocks {lce_aram_clk}] 16.0
set_datapathonly_delay -to   [get_clocks {xilinx_pcie_userclk}] -from [get_clocks {lce_aram_clk}] 16.0

set_datapathonly_delay -from [get_clocks {xilinx_pcie_userclk}] -to   [get_clocks {lce_wqmarb_clk}] 16.0
set_datapathonly_delay -to   [get_clocks {xilinx_pcie_userclk}] -from [get_clocks {lce_wqmarb_clk}] 16.0
################################################################################################################


set_datapathonly_delay -from [get_clocks {HAPS_umr_clk}] -to   [get_clocks {nss_core_clk}] 10.0 
set_datapathonly_delay -to   [get_clocks {HAPS_umr_clk}] -from [get_clocks {nss_core_clk}] 10.0

set_datapathonly_delay -from [get_clocks {HAPS_umr_clk}] -to   [get_clocks {nss_per_clk}] 10.0 
set_datapathonly_delay -to   [get_clocks {HAPS_umr_clk}] -from [get_clocks {nss_per_clk}] 10.0

###5Mhz
set_datapathonly_delay -from [get_clocks {HAPS_umr_clk}] -to   [get_clocks {nss_lce_clk}] 10.0 
set_datapathonly_delay -to   [get_clocks {HAPS_umr_clk}] -from [get_clocks {nss_lce_clk}] 10.0

set_datapathonly_delay -from [get_clocks {HAPS_umr_clk}] -to   [get_clocks {lce_hiri_clk}] 10.0 
set_datapathonly_delay -to   [get_clocks {HAPS_umr_clk}] -from [get_clocks {lce_hiri_clk}] 10.0


set_datapathonly_delay -from [get_clocks {HAPS_umr_clk}] -to   [get_clocks {lce_hiti_clk}] 10.0
set_datapathonly_delay -to   [get_clocks {HAPS_umr_clk}] -from [get_clocks {lce_hiti_clk}] 10.0


set_datapathonly_delay -from [get_clocks {HAPS_umr_clk}] -to   [get_clocks {lce_wqm_clk}] 10.0
set_datapathonly_delay -to   [get_clocks {HAPS_umr_clk}] -from [get_clocks {lce_wqm_clk}] 10.0


set_datapathonly_delay -from [get_clocks {HAPS_umr_clk}] -to   [get_clocks {lce_aram_clk}] 10.0
set_datapathonly_delay -to   [get_clocks {HAPS_umr_clk}] -from [get_clocks {lce_aram_clk}] 10.0

set_datapathonly_delay -from [get_clocks {HAPS_umr_clk}] -to   [get_clocks {lce_wqmarb_clk}] 10.0
set_datapathonly_delay -to   [get_clocks {HAPS_umr_clk}] -from [get_clocks {lce_wqmarb_clk}] 10.0

################################################################################################################3

###nss_core_clk to other clocks
set_datapathonly_delay -from [get_clocks {nss_core_clk}] -to   [get_clocks {nss_per_clk}] 92.59 
set_datapathonly_delay -to   [get_clocks {nss_core_clk}] -from [get_clocks {nss_per_clk}] 92.59

###5Mhz
set_datapathonly_delay -from [get_clocks {nss_core_clk}] -to   [get_clocks {nss_lce_clk}] 83.33 
set_datapathonly_delay -to   [get_clocks {nss_core_clk}] -from [get_clocks {nss_lce_clk}] 83.33

set_datapathonly_delay -from [get_clocks {nss_core_clk}] -to   [get_clocks {lce_hiri_clk}] 92.59 
set_datapathonly_delay -to   [get_clocks {nss_core_clk}] -from [get_clocks {lce_hiri_clk}] 92.59


set_datapathonly_delay -from [get_clocks {nss_core_clk}] -to   [get_clocks {lce_hiti_clk}] 92.59
set_datapathonly_delay -to   [get_clocks {nss_core_clk}] -from [get_clocks {lce_hiti_clk}] 92.59


set_datapathonly_delay -from [get_clocks {nss_core_clk}] -to   [get_clocks {lce_wqm_clk}] 92.59
set_datapathonly_delay -to   [get_clocks {nss_core_clk}] -from [get_clocks {lce_wqm_clk}] 92.59


set_datapathonly_delay -from [get_clocks {nss_core_clk}] -to   [get_clocks {lce_aram_clk}] 92.59
set_datapathonly_delay -to   [get_clocks {nss_core_clk}] -from [get_clocks {lce_aram_clk}] 92.59

set_datapathonly_delay -from [get_clocks {nss_core_clk}] -to   [get_clocks {lce_wqmarb_clk}] 92.59
set_datapathonly_delay -to   [get_clocks {nss_core_clk}] -from [get_clocks {lce_wqmarb_clk}] 92.59
 

###nss_per_clk to other clocks
###5Mhz
set_datapathonly_delay -from [get_clocks {nss_per_clk}] -to   [get_clocks {nss_lce_clk}] 83.33 
set_datapathonly_delay -to   [get_clocks {nss_per_clk}] -from [get_clocks {nss_lce_clk}] 83.33

set_datapathonly_delay -from [get_clocks {nss_per_clk}] -to   [get_clocks {lce_hiri_clk}] 166.66
set_datapathonly_delay -to   [get_clocks {nss_per_clk}] -from [get_clocks {lce_hiri_clk}] 166.66


set_datapathonly_delay -from [get_clocks {nss_per_clk}] -to   [get_clocks {lce_hiti_clk}] 166.66
set_datapathonly_delay -to   [get_clocks {nss_per_clk}] -from [get_clocks {lce_hiti_clk}] 166.66


set_datapathonly_delay -from [get_clocks {nss_per_clk}] -to   [get_clocks {lce_wqm_clk}] 166.66
set_datapathonly_delay -to   [get_clocks {nss_per_clk}] -from [get_clocks {lce_wqm_clk}] 166.66


set_datapathonly_delay -from [get_clocks {nss_per_clk}] -to   [get_clocks {lce_aram_clk}] 166.66
set_datapathonly_delay -to   [get_clocks {nss_per_clk}] -from [get_clocks {lce_aram_clk}] 166.66


set_datapathonly_delay -from [get_clocks {nss_per_clk}] -to   [get_clocks {lce_wqmarb_clk}] 166.66
set_datapathonly_delay -to   [get_clocks {nss_per_clk}] -from [get_clocks {lce_wqmarb_clk}] 166.66



# 12Apr Adding per Rodrigo
set_clock_groups -asynchronous -group [get_clocks HAPS_umr_clkin] 
###==== END Clocks



###==== BEGIN Inputs/Outputs - (Populated from tab in SCOPE, do not edit)
###==== END Inputs/Outputs

###==== BEGIN Registers - (Populated from tab in SCOPE, do not edit)
###==== END Registers

###==== BEGIN "Delay Paths" - (Populated from tab in SCOPE, do not edit)
###==== END "Delay Paths"
# 15Apr Per Visal to resolve timing in FPGA A
# 16Apr bllem removed to compare set_false_path -from [get_clocks {HAPS_umr_clk}] -to [get_clocks {pcie3_ultrascale_0_gtwizard_ultrascale_v1_7_5_gthe3_channel|txoutclk_out_derived_clock[0]}]
#17Apr Per Visal remove the above line and add the following
#set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pcie_ref_clk_p}] -group [get_clocks {HAPS_umr_clk}]

###==== BEGIN Attributes - (Populated from tab in SCOPE, do not edit)
#define_global_attribute syn_reduce_controlset_size {15}
define_global_attribute {syn_useioff} {true}
define_global_attribute {syn_auto_insert_bufg} {0}

#define_attribute [get_pins {I_axi_pcie_endpoint_xtor.I_axi_pcie_endpoint.axi_aclk}] {syn_noclockbuf} {1}

define_attribute {p:pcie_ref_clk_n} {syn_insert_pad} {0}
define_attribute {p:pcie_ref_clk_p} {syn_insert_pad} {0}
define_attribute {p:pcie_txp}    {syn_insert_pad} {0}
#define_attribute {p:pcie_txp[1]}    {syn_insert_pad} {0}
#define_attribute {p:pcie_txp[2]}    {syn_insert_pad} {0}
#define_attribute {p:pcie_txp[3]}    {syn_insert_pad} {0}
define_attribute {p:pcie_txn}    {syn_insert_pad} {0}
#define_attribute {p:pcie_txn[1]}    {syn_insert_pad} {0}
#define_attribute {p:pcie_txn[2]}    {syn_insert_pad} {0}
#define_attribute {p:pcie_txn[3]}    {syn_insert_pad} {0}

###==== END Attributes

###==== BEGIN "I/O Standards" - (Populated from tab in SCOPE, do not edit)
###==== END "I/O Standards"

###==== BEGIN "Compile Points" - (Populated from tab in SCOPE, do not edit)
###==== END "Compile Points"
