#tsetup spyglass 4.4.1
modpath -n 1 /p/cse/asic/spyglass/MCP/docs
modpath -n 1 /p/cse/asic/spyglass/MCP/scripts/rev1.2
source /nfs/site/eda/group/cse/setups/synopsys/syn_Z-2007.03-SP4_FP_setup
setenv SPYGLASS_DC_PATH /nfs/site/eda/group/cse/synopsys/syn/Z_2007.03-SP4_FP/suse64
setenv ATRENTA_LICENSE_FILE 21717@chlslic01.ch.intel.com:7594@plxs0317.pdx.intel.com:7595@plxs0317.pdx.intel.com:7595@fmylic06c.fm.intel.com:7595@fmylic06b.fm.intel.com:7595@fmylic06a.fm.intel.com
unlimit
source /nfs/site/eda/group/cse/setups/atrenta/spyglass_4.1.1_setup
