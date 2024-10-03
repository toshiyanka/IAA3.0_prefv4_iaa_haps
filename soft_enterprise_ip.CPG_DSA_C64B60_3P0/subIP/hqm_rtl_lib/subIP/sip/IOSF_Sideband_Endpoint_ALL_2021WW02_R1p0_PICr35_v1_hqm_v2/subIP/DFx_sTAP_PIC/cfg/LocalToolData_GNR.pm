# DO NOT REMOVE!!!  Learn to code warning-free perl instead.

use warnings FATAL => 'all';
package ToolData;

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





 );
&hash_merge(
    -type => 'APPEND',
    -src  => \%LocalToolData,
    -dest => \%ToolConfig_tools,
);

1;
