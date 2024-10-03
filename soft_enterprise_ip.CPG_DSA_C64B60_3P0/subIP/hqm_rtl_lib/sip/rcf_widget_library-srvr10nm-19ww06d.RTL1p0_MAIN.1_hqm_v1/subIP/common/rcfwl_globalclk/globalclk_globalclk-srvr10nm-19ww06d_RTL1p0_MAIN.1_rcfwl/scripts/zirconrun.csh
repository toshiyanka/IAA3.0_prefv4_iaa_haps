#alias zircon /p/com/eda/intel/zircon/15.13.0_p3/bin/zirconQA
#setenv PERL5LIB /p/hdk/rtl/proj_tools/proj_binx/shdk74/latest

#zircon -ipconfigid 88817 -subipconfig 'refclkdist' -alias refclkdist -app 'SIP' -ms 'RTL0P0' -verbose3 -rpt -dssmsid 52511 -ovf tools/zirconqa/refclkdist_override_14.33.0.dat -env DUT=refclkdist
#zircon -ipconfigid 88817 -subipconfig 'ccdu_clkdist' -alias ccdu_clkdist -app 'SIP' -ms 'RTL0P0' -verbose3 -rpt -dssmsid 52511 -ovf tools/zirconqa/ccdu_clkdist_override_14.33.0.dat -env DUT=ccdu_clkdist
#zircon -ipconfigid 88817 -subipconfig 'mesh_clkdist' -alias mesh_clkdist -app 'SIP' -ms 'RTL0P0' -verbose3 -rpt -dssmsid 52511 -ovf tools/zirconqa/mesh_clkdist_override_14.33.0.dat -env DUT=mesh_clkdist


#zircon -ipconfigid 88817 -subipconfig 'refclkdist' -alias refclkdist -app 'SIP' -ms 'RTL0P5' -verbose3 -rpt -dssmsid 52513 -ovf tools/zirconqa/refclkdist_override_15.13.0.dat -env DUT=refclkdist
#zircon -ipconfigid 88817 -subipconfig 'pccdu'      -alias pccdu      -app 'SIP' -ms 'RTL0P5' -verbose3 -rpt -dssmsid 52513 -ovf tools/zirconqa/pccdu_override_15.13.0.dat -env DUT=pccdu  
#zircon -ipconfigid 88817 -subipconfig 'pclkdist'   -alias pclkdist   -app 'SIP' -ms 'RTL0P5' -verbose3 -rpt -dssmsid 52513 -ovf tools/zirconqa/pclkdist_override_15.13.0.dat -env DUT=pclkdist
#zircon -ipconfigid 88817 -subipconfig 'clkreqaggr' -alias clkreqaggr -app 'SIP' -ms 'RTL0P5' -verbose3 -rpt -dssmsid 52513 -ovf tools/zirconqa/clkreqaggr_override_15.13.0.dat -env DUT=clkreqaggr

#zircon -ipconfigid 88817 -app 'SIP' -ms 'RTL0P5' -verbose3 -rpt -dssmsid 52512 -ipDashUpload

/p/hdk/rtl/proj_tools/zircon/master/2.10.04/bin/zirconQA -ovf tools/zirconqa/inputs/globalclk_override_2.10.ini -ms RTL0P8 -subipconfig glitchfree_clkmux_w3 -alias glitchfree_clkmux -ipconfigid 94515 -dssmsid 87351 -output ZQA -verbose -auto
/p/hdk/rtl/proj_tools/zircon/master/2.10.04/bin/zirconQA -ovf tools/zirconqa/inputs/globalclk_override_2.10.ini -ms RTL0P8 -subipconfig clkreqaggr_w3 -alias clkreqaggr -ipconfigid 94515 -dssmsid 87351 -output ZQA -verbose -auto
/p/hdk/rtl/proj_tools/zircon/master/2.10.04/bin/zirconQA -ovf tools/zirconqa/inputs/globalclk_override_2.10.ini -ms RTL0P8 -subipconfig pccdu_w3 -alias pccdu -ipconfigid 94515 -dssmsid 87351 -output ZQA -verbose -auto
/p/hdk/rtl/proj_tools/zircon/master/2.10.04/bin/zirconQA -ovf tools/zirconqa/inputs/globalclk_override_2.10.ini -ms RTL0P8 -subipconfig psyncdist_w3 -alias psyncdist -ipconfigid 94515 -dssmsid 87351 -output ZQA -verbose -auto
