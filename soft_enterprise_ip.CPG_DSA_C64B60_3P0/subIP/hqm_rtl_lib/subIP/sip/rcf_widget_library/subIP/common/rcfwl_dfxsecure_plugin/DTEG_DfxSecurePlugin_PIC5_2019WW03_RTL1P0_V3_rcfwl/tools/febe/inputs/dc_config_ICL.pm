package dc_config_ICL;

sub get_data {
    my $data = {
        'SETUP' => {
            -setup_source    => '/p/hdk/bin/setproj',
            -setup_milestone => 'HDK1.2.1_74P0',
        },
        'SYN_CALIBER' => {
			-extra_commands1 => [
			   'setenv CIM_CFG /p/hdk/cad/stdcells/e05/15ww24.5_e05_e.0.p1_cnlgt/cim/e05_cim.cfg.tcl',
			   'setenv CIM_DB /p/hdk/cad/stdcells/e05/15ww24.5_e05_e.0.p1_cnlgt/cim/e05_cim.db.tcl',
            ],
        },
    };
    return $data;
}

1;
