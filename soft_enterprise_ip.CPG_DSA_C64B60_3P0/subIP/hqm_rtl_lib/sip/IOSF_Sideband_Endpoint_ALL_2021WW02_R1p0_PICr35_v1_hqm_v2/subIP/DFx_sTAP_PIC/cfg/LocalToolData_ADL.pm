# DO NOT REMOVE!!!  Learn to code warning-free perl instead.

use warnings FATAL => 'all';
package ToolData;
#$ToolConfig_tools{ctech_library}{VERSION}        = "c3v18ww27a_hdk153";
#$ToolConfig_tools{ctech}{VERSION}        = "c3v18ww27a_hdk153";
#$ToolConfig_tools{ctech_exp}{VERSION}        = "ctech_exp_c3v18ww27a_hdk153";
#$ToolConfig_tools{coretools}{VERSION}        = "N-2017.12-SP1";
#$ToolConfig_tools{collage}{VERSION}        = "3.7";
#$ToolConfig_tools{isaf}{VERSION}        = "2.2.7.6";
$ToolConfig_tools{spyglass_cdc}->{SUB_TOOLS}->{spyglass}->{VERSION} = "M2017.03-SP2-15-B4";
$ToolConfig_tools{spyglass_cdc}->{VERSION} ="2.00.06"; 
my %LocalToolData = (
stage_collage_build => {
                PATH => "&get_tool_path('rtltools')/stages/collage_build.pm",
                OTHER => {
                     collage_build_enable => "on",
                },
         },
    collage  => {
        OTHER => {
            collage_build_ip => "stap",
            collage_build_script => "tools/collage/build/builder.stap.tcl",
        },
    },




   tsa_finalized => {
       finalized => {
        stap => {
              -lib_variant => 'nn',
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
