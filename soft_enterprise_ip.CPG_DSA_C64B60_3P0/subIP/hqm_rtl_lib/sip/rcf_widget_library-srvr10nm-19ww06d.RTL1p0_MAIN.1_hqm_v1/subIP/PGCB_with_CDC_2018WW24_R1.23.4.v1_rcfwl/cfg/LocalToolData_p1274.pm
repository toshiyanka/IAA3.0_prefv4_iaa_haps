# DO NOT REMOVE!!!  Learn to code warning-free perl instead.
#
use warnings FATAL => 'all';

package ToolData;

my %LocalToolData = (

    tsa_finalized => {
        finalized => {
            pgcbunit => {
                -stdlib_type => "ec0",
            },
            ClockDomainController => {
                -stdlib_type => "ec0",
            },
        },
    },

tsa_dc_config => {
                SETUP => {
                        -be_tool_override => {
			#	"blocks_info" => "3.0.9",
			#	"blocks_info.pl" => "3.0.4",
                        },
                },
        },


    tsa_shell => {
        setenv => [
            'CDC_PROCESS        p1274',
            'CTECH_LIB_NAME_CDC CTECH_p1274_ec0_ln_rtl_lib',
        ],
    },
);
#---------------
&hash_merge(
    -type => 'APPEND',
    -src  => \%LocalToolData,
    -dest => \%ToolConfig_tools,
);

1;

