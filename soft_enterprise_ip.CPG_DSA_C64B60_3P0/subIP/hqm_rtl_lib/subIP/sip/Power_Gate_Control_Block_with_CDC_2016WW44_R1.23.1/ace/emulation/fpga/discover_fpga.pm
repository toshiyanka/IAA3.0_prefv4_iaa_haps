%reconfig = (
   '-config_opt' => {
      '-restart' => "$ENV{'EMUL_RESULTS_DIR/'}/DISCOVER_FPGA/STATE0.pm",
      '-restart_id' => 0,
      '-write_reconfig_proto' => "$ENV{'EMUL_CFG_DIR'}/fpga/reconfig.pm",
      '-write_discover_proto' => "$ENV{'EMUL_CFG_DIR'}/fpga/discover.pm",
   },
);
1;
