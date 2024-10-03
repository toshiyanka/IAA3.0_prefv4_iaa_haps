package VTEToolsConfig;

use vars qw(@ISA @EXPORT_OK);
require Exporter;

@ISA = qw(Exporter);

use vars qw(
    $dsn
    $hsd_env
    $sku
    %env_data
    %ipconfig_excludes
    %model_data
    %test_header_data
    @contact_list
);

@EXPORT_OK = qw(
    $dsn
    $hsd_env
    $sku
    %env_data
    %ipconfig_excludes
    %model_data
    %test_header_data
    @contact_list
);

# ------------------------------------------------------------------------------
# get_var subroutine returns value of the specified variable
# ------------------------------------------------------------------------------
sub get_var(@) {
    my ($var, $print, $hash, $arg) = @_;

    if ($hash) {
        print ${$var}{$arg}  if defined $print;
        return ${$var}{$arg} if !defined $print;
    } else {
        print ${$var}  if defined  $print;
        return ${$var} if !defined $print;
    }

}

# This indicates to scripts that the SKU field is used instead of the project
#   field in HSD.  This would typically be 1 only for full chip environments.
$sku = 0;

$dsn = "pcg_vte";

# This is used by the test upload script. It helps pare down the tests in HSD
#   since the database is shared by multiple environments.
$hsd_environment = "devtlb";
$hsd_project = "ip,lunarlake,graniterapids-d";

# default contact for errors and obsoletions
@contact_list = ("jcurtiss");

%model_data = (
    devtlb => {
        hsdenv     => "devtlb",
        hsdproject => "ip",
        runmodes   => "eip",
        branch     => "master",
    },
    devtlb_ovm => {
        hsdenv     => "devtlb",
        hsdproject => "ip",
        runmodes   => "eip",
        branch     => "master",
    },
    devtlb_ipu => {
        hsdenv     => "devtlb",
        hsdproject => "lunarlake",
        runmodes   => "lnl",
        branch     => "master",
    },
    devtlb_vpu => {
        hsdenv     => "devtlb",
        hsdproject => "lunarlake",
        runmodes   => "lnl",
        branch     => "master",
    },
    devtlb_tip => {
        hsdenv     => "devtlb",
        hsdproject => "graniterapids-d",
        runmodes   => "gnr-d",
        branch     => "master",
    },
);

%test_header_data = (
    "devtlb" => { # environment
        ip => {
        },
        lunarlake => {
        },
        "graniterapids-d" => {
        },
    },
);

%env_data = (
    release_path       => "/nfs/site/disks/cct.gkrel.000/devtlb-eip/",
    setup_cmd          => "source /p/acd/proj/cct/tools/bin/cct.env",
    cc_opts            => "assert+line+cond+branch",
    tgl_opts           => "assert+tgl",
    all_cc_opts        => "assert+line+cond+branch+tgl",
    code_hier          => "tools/vcs/vcscodecov.hier",
    tgl_hier           => "tools/vcs/vcstglcov.hier",
    code_collect_dir   => "/p/acd/proj/cct/fe/coverage_data/code/collect",
    toggle_collect_dir => "/p/acd/proj/cct/fe/coverage_data/toggle/collect",
    event_collect_dir  => "/p/acd/proj/cct/fe/coverage_data/event/collect",
    event_map_file     => "/p/acd/proj/cct/val/tools/scripts/klv2fcmap.txt",
    unix_group         => "cct",
);

%ipconfig_excludes = (
    GLOBAL => [
        "/p/kits",              # Ignores all releases from kits
        "/p/acd/proj/cct/lib",  # Never release stuff from cct/lib
        ".*subip", # Never release local subip
        "/p/hdk/", # Or common release libraries
        "/p/com/", # Or other common release libraries
        ".*lintra",
        "devtlb_ROOT",
    ],
    # Project specific excludes
    mtl => [

    ],
);

1;
