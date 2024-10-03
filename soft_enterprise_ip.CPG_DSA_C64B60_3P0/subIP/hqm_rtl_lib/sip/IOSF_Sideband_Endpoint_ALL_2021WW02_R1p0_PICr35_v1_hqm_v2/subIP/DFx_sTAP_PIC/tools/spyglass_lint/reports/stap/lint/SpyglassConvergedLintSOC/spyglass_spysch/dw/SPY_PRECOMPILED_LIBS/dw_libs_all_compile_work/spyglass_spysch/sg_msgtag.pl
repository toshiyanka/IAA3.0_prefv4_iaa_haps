################################################################################
#This is an internally genertaed by SpyGlass for Message Tagging Support
################################################################################


use spyglass;
use SpyGlass;
use SpyGlass::Objects;
spyRebootMsgTagSupport();

spySetMsgTagCount(0,35);
spyParseTextMessageTagFile("./stap/stap/lint/SpyglassConvergedLintSOC/spyglass_spysch/dw/SPY_PRECOMPILED_LIBS/dw_libs_all_compile_work/spyglass_spysch/sg_msgtag.txt");

if(!defined $::spyInIspy || !$::spyInIspy)
{
    spyDefineReportGroupingOrder("ALL",
(
"BUILTIN"   => [SGTAGTRUE, SGTAGFALSE]
)
);
}
spyMessageTagTestBenchmark(1,"./stap/stap/lint/SpyglassConvergedLintSOC/spyglass_spysch/dw/SPY_PRECOMPILED_LIBS/dw_libs_all_compile_work/spyglass.vdb");

1;
