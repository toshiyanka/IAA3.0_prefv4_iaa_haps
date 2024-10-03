package ToolData;

$ToolConfig_tools{vcs}->{VERSION}   = 'J-2014.12-SP3';

$ToolConfig_tools{flowbee}{OTHER}{default_dut} = "AW";
$ToolConfig_tools{runtools}{OTHER}{default_dut} = "AW";

if (defined $ENV{RTLDEBUG}) {
  $ToolConfig_tools{ace}{VERSION} = "2.01.34";
  $ToolConfig_tools{ace}{ENV}{ACE_PROJECT} = "AW";
}

1;
