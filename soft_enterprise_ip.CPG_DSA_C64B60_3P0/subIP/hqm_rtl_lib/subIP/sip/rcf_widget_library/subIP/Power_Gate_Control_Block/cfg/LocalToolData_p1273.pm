# DO NOT REMOVE!!!  Learn to code warning-free perl instead.
#
use warnings FATAL => 'all';

package ToolData;

my %LocalToolData = (

    tsa_finalized => {
        finalized => {
            pgcbunit => {
                -stdlib_type => "d04",
                -lib_variant        => 'wn',
            },
            ClockDomainController => {
                -stdlib_type => "d04",
                -lib_variant        => 'wn',
            },
        },
    },

    tsa_shell => {
        setenv => [
            'CDC_PROCESS        p1273',
            'CTECH_LIB_NAME_CDC CTECH_p1273_d04_ln_rtl_lib',
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

