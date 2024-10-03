# DO NOT REMOVE!!!  Learn to code warning-free perl instead.

use warnings FATAL => 'all';
package ToolData;
$ToolConfig_tools{spyglass_cdc}->{SUB_TOOLS}->{spyglass}->{VERSION} = "M2017.03-SP2-15";
$ToolConfig_tools{spyglass_cdc}->{VERSION} ="2.00.05"; 
#$ToolConfig_tools{collage}{VERSION}        = "3.7";
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
              -lib_variant => 'ln,nn,wn',
		-stdlib_type => 'e05',
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
