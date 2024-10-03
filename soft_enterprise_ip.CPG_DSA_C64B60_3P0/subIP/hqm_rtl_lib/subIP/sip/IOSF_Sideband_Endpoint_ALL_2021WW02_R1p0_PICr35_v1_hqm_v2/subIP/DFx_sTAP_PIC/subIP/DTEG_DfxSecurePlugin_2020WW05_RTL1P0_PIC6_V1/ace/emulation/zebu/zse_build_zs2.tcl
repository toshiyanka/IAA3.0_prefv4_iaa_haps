ZEBU_UI ZCUI {2.0}
#V7_3_1
#==========================================================================
## Global
#==========================================================================
ZCUI_set ZcuiWorkingDirectory {./zcui.work}
#==========================================================================
## Design sources
#==========================================================================
#ZCUI_set TopLevel {ccp_top} 
#ZCUI_set MemoryDebugFlag t
ZCUI_add -rtlGroup {Default_RTL_Group} {zFASTUserMode} {} {}
ZCUI_add -rtlGroupCondition {Default_RTL_Group} {t} {f} {10}
ZCUI_add -rtlGenerateGate {Default_RTL_Group} {t} {f}
ZCUI_add -rtlGroupMode {Default_RTL_Group} {t} {block}
ZCUI_add -rtlDesignWare {Default_RTL_Group} {t} {f}
ZCUI_add -rtlLanguageAutoDetect {Default_RTL_Group} {f}
ZCUI_add -rtlVerilogCaseSensitive {Default_RTL_Group} {f}
ZCUI_add -rtlVerilogDefaultNetType {Default_RTL_Group} {unset}
ZCUI_add -rtlLibraryRescan {Default_RTL_Group} {f}
ZCUI_add -rtlVerilogLanguage {Default_RTL_Group} {verilog}
ZCUI_add -rtlVHDLLanguage {Default_RTL_Group} {vhdl}
ZCUI_add -rtlErrorLevel {Default_RTL_Group} {Medium} {Repair} {Error} {Ignore} {Ignore} {Ignore} {Error}
ZCUI_add -rtlStyle {Default_RTL_Group} {<default>} {default} {<default>}
ZCUI_add -rtlSynthVisibilityMode {Default_RTL_Group} {SynthVisibilityNoOptimization}
ZCUI_add -rtlZfsOption {Default_RTL_Group} {zFast.config}
ZCUI_add -rtlZfsZeBuWare {Default_RTL_Group} {f}/
#ZCUI_add -rtlZfsCSAMode {Default_RTL_Group} t
#ZCUI_add -rtlZfsDisableSupportCalculator {Default_RTL_Group} {t}
#ZCUI_add -rtlICSAHeaderMode {Default_RTL_Group} {ICSAHeaderFsdbRtl}
ZCUI_set UseOfflineDebugFlag f
ZCUI_set DisableOutputProbesFlag f
ZCUI_set NoOptimizationFlag t
ZCUI_set EnableBRAMFlag t
ZCUI_set UseCSAFlag t
ZCUI_set EnableCSAPrecalculationFlag f
ZCUI_set GenerateICSAHeaderFlag f
ZCUI_set MemoryIOAccessibilityFlag t
ZCUI_set TopLevelIOAccessibilityFlag t
ZCUI_set UseExpertDebuggingModeFlag f
ZCUI_add -rtlZfsVisibilityMode {Default_RTL_Group} {ZfsVisibilityNoOptimization}
ZCUI_add -rtlZfsSvaMode {Default_RTL_Group} {3}
ZCUI_add -rtlZfsSvaNeverUseFatal {Default_RTL_Group} f
ZCUI_add -rtlZfsSvaReportOnlyFailure {Default_RTL_Group} t
ZCUI_add -rtlZfsSupportDollarDisplay {Default_RTL_Group} f
ZCUI_add -rtlZfsDpiMode {Default_RTL_Group} {4}
ZCUI_add -rtlZfsResourceValue {Default_RTL_Group} {0} {0}
ZCUI_add -rtlZfsRemoveUnconnectedBlackBoxes {Default_RTL_Group} {f}
ZCUI_add -rtlZfsRemoveWriteOnlyMemories {Default_RTL_Group} {f}
#ZCUI_add -rtlZfsUseOfflineDebugger {Default_RTL_Group} {f}
ZCUI_add -rtlZfsStatCollate {Default_RTL_Group} {t}
ZCUI_add -rtlSource {Default_RTL_Group} {efm.tcl} {} -language command
#--------------------------------------------------------------------------
## Back-End default : Architecture
#--------------------------------------------------------------------------
## Back-End default : Timing Options
ZCUI_add -timingComputationParameters  Full
#--------------------------------------------------------------------------
## Back-End default : zTopBuild main parameters
ZCUI_set ZTopBuildNetlistFinalizationFileName {zTopBuild_edit.tcl}
#--------------------------------------------------------------------------
## Back-End default : Environnement
ZCUI_set AutoDVEType {HDL}
#--------------------------------------------------------------------------
## Back-End default : Mapping
ZCUI_set ClusterMode FullAuto
ZCUI_set ClusterAutoOutputMapping {}
ZCUI_set AutoCoreDefinition f
ZCUI_set TopReuseExistingMapping f
#ZCUI_set PopCoreDefinition f
ZCUI_set CorePartitioningMode Dop
ZCUI_set CoreReuseExistingMapping f
#--------------------------------------------------------------------------
## Back-End default : Clock Constraints
ZCUI_set GlobalSkewOffset t
ZCUI_set LocalizeClockTree f
ZCUI_set FilterGlitches On
ZCUI_set ClockCounterFlag f
#--------------------------------------------------------------------------
## Back-End default : Other Constraints
ZCUI_set UseFpgaMultiLaunch f
#--------------------------------------------------------------------------
## Back-End default : ISE Parameters
ZCUI_set ISEFilePolicy Compress
#--------------------------------------------------------------------------
## Back-End default : Debug
ZCUI_set GlobalWriteBackFlag t
ZCUI_set GlobalBramRWFlag f
ZCUI_set TopDebugFlag t
#==========================================================================
## Compiler Options
#==========================================================================
ZCUI_set MaxZebuJob 20
ZCUI_set MaxIseJob 300
ZCUI_set MaxSynthesisJob 300
ZCUI_add -staticRtlBundleMethod Size 23
ZCUI_add -sourcePathConverter Relative
ZCUI_add -zebuPathConverter Relative
ZCUI_set RemoveWhiteSpace f
#ZCUI_set ConfirmCompilerStopFlag t

#==========================================================================
## Back-End default : Architecture
#==========================================================================
ZCUI_set ArchitectureFile {/p/vt/tools/sim/vendor/zse/zse_configurations/10U_config_for_compile_only_V710/config/zse_configuration.tcl}
