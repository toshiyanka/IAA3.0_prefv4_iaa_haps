# DO NOT REMOVE!!!  Learn to code warning-free perl instead.
use warnings FATAL => 'all';
package ToolData;
$ToolConfig_tools{collage}{VERSION}        = "3.7";
#$general_vars{"PROCESS"}                              = 'p1273';
#$general_vars{"CTECH_TYPE"}                           = 'd04';
#$general_vars{"PROCESS_NAME"}                         = 'p1273';

my %LocalToolData = (

	stage_collage_build => {
                PATH => "&get_tool_path('rtltools')/stages/collage_build.pm",
                OTHER => {
                     collage_build_enable => "on",
                },
         },
    collage  => {
        OTHER => {
            collage_build_ip => "dfxsecure_plugin",
            collage_build_script => "tools/collage/build/builder.dfxsecure_plugin.tcl",
        },
    },

tsa_finalized => {
       finalized => {
        dfxsecure_plugin => {
              -lib_variant => 'wn',
		-stdlib_type => 'd04',
        },
      },
   },
);

&hash_merge(
    -type => 'APPEND',
    -src  => \%LocalToolData,
    -dest => \%ToolConfig_tools,
);

1;
