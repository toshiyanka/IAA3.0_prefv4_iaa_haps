package dfxsecure_plugin_final_cfg;

use vars qw (@ISA @EXPORT_OK $dc_cfg);
@EXPORT_OK = qw($dc_cfg);

$dc_cfg = {
    -owner           => [ '' ],
    project          => 'ANY',
    ace_lib          => 'dfxsecure_plugin_rtl_lib',
    -opus_lib        => '',
    -enable_sg_dft   => 1,
    -enable_gkturnin => 1,
    -rm_ctech_files  => ['\/ctech_lib*.v',],
	-lib_variant     =>  (defined $ENV{ONECFG_CUST} && $ENV{ONECFG_CUST} eq "TGL") ? "ln,nn" : "wn",
    -stdlib_type     =>  (defined $ENV{ONECFG_CUST} && $ENV{ONECFG_CUST} eq "TGL") ?  "e05" :"d04",
};

1;
