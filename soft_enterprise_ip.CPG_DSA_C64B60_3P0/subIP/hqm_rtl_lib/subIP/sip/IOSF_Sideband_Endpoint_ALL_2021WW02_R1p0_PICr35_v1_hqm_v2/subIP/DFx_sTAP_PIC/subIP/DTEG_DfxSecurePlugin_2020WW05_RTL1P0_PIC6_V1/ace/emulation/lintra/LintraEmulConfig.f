<?xml version="1.0"?>
<LINTRA_CONFIGURATION>

<!--
  Emulation/FPGA Rule Deck Version: v2011ww19 Tested with Lintra version:11.1
  This file is part of EFM Framework, maintained and released by Emulation CoE. 
  To obtain this file from the CoE SVN Repository or for more info visit http://goto/emulation 
  For more info on this Rule Deck, visit: https://wiki.ith.intel.com/display/EMUL/Emulation+Friendly+Methodology 
  For detailed rule explanations and code examples, pls visit: 
  http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintra_errors_crm_frame.html
  For a Emulation RTL check - you may disable FPGA category checks.
  For a FPGA RTL Check - you need to enable both EMUL & FPGA checks.
  To disable individual rule, simple change active="no"
  This rule deck typically resides in $MODEL_ROOT/cfg/emul directory. 
  To temporarily override RTL errors in a file, list it as a black-box in the lintra_emul.bb file.
  Emul RTL Check flow also accepts existing RTL waivers. 
--> 

 <!-- Emulation Rule Categories Behavior Control -->
  <severity name="EMUL_FATAL" level="1" cause_failure="yes"/>
  <severity name="EMUL_ERROR" level="1" cause_failure="yes"/>
  <severity name="EMUL_WARNING" level="1" cause_failure="no"/>
  <severity name="EMUL_TEMP" level="1" cause_failure="no"/>
  <severity name="EMUL_INFO" level="1" cause_failure="no"/>

  <!-- FPGA only Rule Categories Behavior Control -->
  <severity name="FPGA_FATAL" level="1" cause_failure="no"/>
  <severity name="FPGA_ERROR" level="1" cause_failure="no"/>
  <severity name="FPGA_WARNING" level="1" cause_failure="no"/>
  <severity name="FPGA_INFO" level="1" cause_failure="no"/>


  <!-- Lira Internal Error Behavior Control -->
  <severity name="error" level="1" cause_failure="yes"/>
  <severity name="Fatal" level="1" cause_failure="yes"/>
  
  <!-- UDR Errors Behavior Control -->
  <severity name="Error" level="2" cause_failure="yes"/>
  <severity name="Error_Gating" level="3" cause_failure="yes"/>
  <severity name="Error_Fix" level="3" cause_failure="yes"/>
  <severity name="Error_NB2" level="3" cause_failure="yes"/>
  <severity name="Error_Clock" level="3" cause_failure="yes"/>

  <!--LIRA warning Behavior Control -->
  <severity name="Warning" level="4" cause_failure="no"/>
  <severity name="warning" level="4" cause_failure="no"/>
  <severity name="Warning_v1" level="5" cause_failure="no"/> 
  <severity name="Warning_v2" level="6" cause_failure="no"/> 
  <severity name="Warning_v3" level="7" cause_failure="no"/> 
  <severity name="Information" level="8" cause_failure="no"/> 
  <severity name="ToolDev" level="8" cause_failure="no"/> 


  <!-- When multiple config files are passed to lintra, make sure
       this is the last config file, so that these rules override prior rule decks.  
       Turning OFF all lint rules from any other file sourced
       before this file. This is so we can control behavior of emul
       specific rules for an emulation RTL Check run.       --> 
  <rule_group id="Lintra Built-in Rules" active="no" />
  <rule_group id="INVOCATION " active="no" />
  <rule_group id="CODING_STYLE " active="no" />
  <rule_group id="Coding Style Basic" active="no"/>
  <rule_group id="GENERAL " active="no" />
  <rule_group id="LIRA_API " active="no" />
  <rule_group id="LANGUAGE " active="no" />
  <rule_group id="TOOL_LIMITATION " active="no" />
  <rule_group id="SYNTHESIS " active="no" />
  <rule_group id="Vams Coding Style" active="no" />
  <rule_group id="SVA Coding Style" active="no" />
  <rule_group id="Project Rules" active="no" />
  <rule_group id="Partitioner Rules" active="no"/>
  <rule_group id="Connectivity Rules" active="no"/>


<!-- EMULATION Rules START HERE   -->

<rule id="0227" active="yes" severity="EMUL_FATAL"/>
<!-- 0227 %s: Recursive calls are not synthesizable.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0227.html?zoom_highlight=0227   -->
<rule id="0266" active="yes" severity="EMUL_FATAL"/>
<!-- 0266 Non synthesizable do-while statement. Only do-while statements in which the condition evaluates to 0 are synthesized.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0266.html?zoom_highlight=0266   -->
<rule id="0288" active="yes" severity="EMUL_FATAL"/>
<!-- 0288 Non synthesizable while statement. Only while statements in which the condition evaluates to 0 are synthesized.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0288.html?zoom_highlight=0288   -->
<rule id="0289" active="yes" severity="EMUL_FATAL"/>
<!-- 0289 Non synthesizable repeat statement. Only repeat statements in which the repetition numbers are constants are synthesized.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0289.html?zoom_highlight=0289   -->
<rule id="0292" active="yes" severity="EMUL_FATAL"/>
<!-- 0292 Forever statements are non synthesizable.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0292.html?zoom_highlight=0292   -->
<rule id="0310" active="yes" severity="EMUL_FATAL"/>
<!-- 0310 Non synthesizable disable statement: a disable statement of the block %s that is not an enclosing block is not supported.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0310.html?zoom_highlight=0310   -->
<rule id="0518" active="yes" severity="EMUL_FATAL"/>
<!-- 0518 Illegal sensitivity list for the signal %s, combining edge and level events is not allowed.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0518.html?zoom_highlight=0518   -->
<rule id="0564" active="yes" severity="EMUL_FATAL"/>
<!-- 0564 %s: Multiply driven signal that is driven by a latch or a flop is illegal. The driver list: %s -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0564.html?zoom_highlight=0564   -->
<rule id="0568" active="yes" severity="EMUL_FATAL"/>
<!-- 0568 Failed to synthesize a nonsynthesizable system function %s.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0568.html?zoom_highlight=0568   -->
<rule id="0569" active="yes" severity="EMUL_FATAL"/>
<!-- 0569 Failed to synthesize a nonsynthesizable user-defined PLI system function %s.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0569.html?zoom_highlight=0569   -->
<rule id="1221" active="yes" severity="EMUL_FATAL"/>
<!-- 1221 Illegal UDP table - failed to infer hardware modeling for this UDP coding style.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1221.html?zoom_highlight=1221   -->
<rule id="1340" active="yes" severity="EMUL_FATAL"/>
<!-- 1340 Illegal edge-sensitive device modeling: the condition does not match the polarity of %s in the process sensitivity list at %s; the condition may be either the expression tested for posedge, its equality to a single-bit constant one, or its inequality to a single-bit constant zero.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1340.html?zoom_highlight=1340   -->
<rule id="1341" active="yes" severity="EMUL_FATAL"/>
<!-- 1341 Illegal edge-sensitive device modeling: the condition does not match the polarity of %s in the process sensitivity list at %s; the condition may be either the negation of the expression tested for negedge, its equality to a single-bit constant zero, or its inequality to a single-bit constant one.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1341.html?zoom_highlight=1341   -->
<rule id="1342" active="yes" severity="EMUL_FATAL"/>
<!-- 1342 %s: illegal edge-sensitive device modeling - cannot infer a clock. Check that all but one event expression in the process sensitivity list has a matching conditional within the process. unmatched event expressions: %s.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1342.html?zoom_highlight=1342   -->
<rule id="2030" active="yes" severity="EMUL_FATAL"/>
<!-- 2030 Assignment to input signal %s -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2030.html?zoom_highlight=2030   -->
<rule id="2082" active="yes" severity="EMUL_FATAL"/>
<!-- 2082 macromodule declaration is not synthesizable. It will be replaced by Lira with a module declaration.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2082.html?zoom_highlight=2082   -->
<rule id="2166" active="yes" severity="EMUL_FATAL"/>
<!-- 2166 The symbol %s is used before its definition (at %s).  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2166.html?zoom_highlight=2166   -->
<rule id="60078" active="yes" severity="EMUL_FATAL"/>
<!-- 60078 Limit number of read and write operations per memory instance -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/60078.html?zoom_highlight=60078   -->

<rule id="0241" active="yes" severity="EMUL_ERROR"/>
<!-- 0241 %s: part select might be out of bounds (index bounds are [%d:%d])%s -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0241.html?zoom_highlight=0241   -->
<rule id="0384" active="yes" severity="EMUL_WARN"/>
<!-- 0384 Using x-values or z-values with the operators or mixing it with other expressions is not part of the Verilog synthesis level. It is supported by Lira, but might not be supported by other synthesis tools.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0384.html?zoom_highlight=0384   -->
<rule id="0506" active="yes" severity="EMUL_ERROR"/>
<!-- 0506 %s: could not resolve the multiply driven signal, it is not a bus or a memory.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0506.html?zoom_highlight=0506   -->
<rule id="0507" active="yes" severity="EMUL_ERROR"/>
<!-- 0507 Signal %s does not have a synchronous part in a block controlled by edge-sensitive condition. Lira will model the signal as a latch.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0507.html?zoom_highlight=0507   -->
<rule id="0517" active="yes" severity="EMUL_ERROR"/>
<!-- 0517 %s is assigned using blocking and non-blocking statements in the same always block. Blocking assignment at %s; non-blocking assignment at %s.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0517.html?zoom_highlight=0517   -->
<rule id="0524" active="yes" severity="EMUL_ERROR"/>
<!-- 0524 Edge-sensitive bus %s is not supported.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0524.html?zoom_highlight=0524   -->
<rule id="0536" active="yes" severity="EMUL_ERROR"/>
<!-- 0536 Signal %s, driven in a block controlled by edge sensitive logic, is driven only by an explicit retain, without an asynchronous part. It will be ignored by Lira.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0536.html?zoom_highlight=0536   -->
<rule id="0559" active="yes" severity="EMUL_ERROR"/>
<!-- 0559 Signal %s represents a non combinational logic in an always_comb block.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0559.html?zoom_highlight=0559   -->
<rule id="0560" active="yes" severity="EMUL_ERROR"/>
<!-- 0560 %s - a non latch is driven within an always_latch.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0560.html?zoom_highlight=0560   -->
<rule id="0561" active="yes" severity="EMUL_ERROR"/>
<!-- 0561 %s - a non flop is driven within an always_ff.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0561.html?zoom_highlight=0561   -->
<rule id="0566" active="yes" severity="EMUL_WARN"/>
<!-- 0566 Non-synthesizable case equality/inequality (comparing x or z values with a non constant expression). Synthesis of such expressions may be inaccurate.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0566.html?zoom_highlight=0566   -->
<rule id="0567" active="yes" severity="EMUL_ERROR"/>
<!-- 0567 Trying to synthesize a nonsynthesizable case in/equality (the use of x or z values may not be used within a non constant expression) or wild equality operator. Synthesis of such expressions may not be accurate.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0567.html?zoom_highlight=0567   -->
<rule id="0725" active="yes" severity="EMUL_ERROR"/>
<!-- 0725 Synthesis flow: Unable to find an appropriate cell for signal %s.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0725.html?zoom_highlight=0725   -->
<rule id="0726" active="yes" severity="EMUL_ERROR"/>
<!-- 0726 Synthesis flow: Clock/Qclock %s is driven by an unmapped statement.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0726.html?zoom_highlight=0726   -->
<rule id="0727" active="yes" severity="EMUL_ERROR"/>
<!-- 0727 Synthesis flow: Control of a latch must contain a clock.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0727.html?zoom_highlight=0727   -->
<rule id="0728" active="yes" severity="EMUL_ERROR"/>
<!-- 0728 Synthesis flow: Control of a latch cannot contain multiple clocks.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0728.html?zoom_highlight=0728   -->
<rule id="0730" active="yes" severity="EMUL_ERROR"/>
<!-- 0730 Synthesis flow: Unable to find an appropriate cell for combinational signal %s. Keeping the original logic.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0730.html?zoom_highlight=0730   -->
<rule id="0731" active="yes" severity="EMUL_ERROR"/>
<!-- 0731 Synthesis flow: Inverted mux mapping is not adjustable. Ignoring the attribute on signal %s.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0731.html?zoom_highlight=0731   -->
<rule id="0732" active="yes" severity="EMUL_ERROR"/>
<!-- 0732 Synthesizing a %d bit wide division or modulus expression. This may result in running out of memory.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0732.html?zoom_highlight=0732   -->
<rule id="0816" active="yes" severity="EMUL_ERROR"/>
<!-- 0816 %s: Type mismatch - no implicit conversion exists to convert the value of the expression of type %s into the type required by the context %s.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0816.html?zoom_highlight=0816   -->
<rule id="0895" active="yes" severity="EMUL_ERROR"/>
<!-- 0895 Packed array type cannot have an unpacked base type.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0895.html?zoom_highlight=0895   -->
<rule id="1254" active="yes" severity="EMUL_ERROR"/>
<!-- 1254 %s: undefined symbol; considered a signal of default_nettype.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1254.html?zoom_highlight=1254   -->
<rule id="1257" active="yes" severity="EMUL_ERROR"/>
<!-- 1257 Events on statements are ignored.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1257.html?zoom_highlight=1257   -->
<rule id="1307" active="yes" severity="EMUL_ERROR"/>
<!-- 1307 Real constants are ignored (or rounded to an unsigned and unsized number), non-synthesizable feature.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1307.html?zoom_highlight=1307   -->
<rule id="1460" active="yes" severity="EMUL_ERROR"/>
<!-- 1460 A write was identified to the cross module reference %s. This is an unrecommended coding style.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1460.html?zoom_highlight=1460   -->
<rule id="1461" active="yes" severity="EMUL_ERROR"/>
<!-- 1461 %s, hierarchial identifiers arent part of the Verilog synthesis level. They are supported by Lira, but might not be supported by other synthesis tools.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1461.html?zoom_highlight=1461   -->
<rule id="1467" active="yes" severity="EMUL_ERROR"/>
<!-- 1467 %s statements arent part of the Verilog synthesis level.They are supported by Lira, but might not be supported by other synthesis tools.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1467.html?zoom_highlight=1467   -->
<rule id="2023" active="yes" severity="EMUL_ERROR"/>
<!-- 2023 The cross module reference %s is multiple driven which is currently not supported -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2023.html?zoom_highlight=2023   -->
<rule id="2042" active="yes" severity="EMUL_ERROR"/>
<!-- 2042 An assignment pattern without preceding apostrophe is an obsolete syntax.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2042.html?zoom_highlight=2042   -->
<rule id="2044" active="yes" severity="EMUL_ERROR"/>
<!-- 2044 The case statement is marked as full but does not cover all cases -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2044.html?zoom_highlight=2044   -->
<rule id="2047" active="yes" severity="EMUL_ERROR"/>
<!-- 2047 Nonsynthesizable use of constants with x or z values in an equality operator. The result will be treated as x (or false condition for conditional statement).  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2047.html?zoom_highlight=2047   -->
<rule id="2048" active="yes" severity="EMUL_ERROR"/>
<!-- 2048 Use of x value in the case item expression of a casez statement is nonsynthesizable -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2048.html?zoom_highlight=2048   -->
<rule id="2084" active="yes" severity="EMUL_ERROR"/>
<!-- 2084 Signal %s, driven in a block controlled by edge-sensitive logic, has a synchronous part which is only an explicit retain. Lira will model the signal as a latch.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2084.html?zoom_highlight=2084   -->
<rule id="2089" active="yes" severity="EMUL_ERROR"/>
<!-- 2089 Wide divide or modulus operation (%d) will not be synthesized according to -dsa switch (%d).  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2089.html?zoom_highlight=2089   -->
<rule id="2116" active="yes" severity="EMUL_ERROR"/>
<!-- 2116 Drive strength used in continuous assignment to %s does not match iHDL bus inference rules.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2116.html?zoom_highlight=2116   -->
<rule id="2128" active="yes" severity="EMUL_ERROR"/>
<!-- 2128 The drive strength of the assignment to %s will be ignored.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2128.html?zoom_highlight=2128   -->
<rule id="8212" active="yes" severity="EMUL_ERROR"/>
<!-- 8212 Illegal use of a non synthesis level construct %s.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/8212.html?zoom_highlight=8212   -->
<rule id="8213" active="yes" severity="EMUL_ERROR"/>
<!-- 8213 Use of a non synthesis level construct %s - construct is ignored.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/8213.html?zoom_highlight=8213   -->
<rule id="50542" active="yes" severity="EMUL_ERROR"/>
<!-- 50542 Variable declared inside an unscoped generate block. Please move it outside that scope or name that scope -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/50542.html?zoom_highlight=50542   -->
<rule id="60000" active="yes" severity="EMUL_ERROR"/>
<!-- 60000 Syntax - Read before write in always_comb block not allowed -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/60000.html?zoom_highlight=60000   -->
<rule id="60077" active="yes" severity="EMUL_ERROR"/>
<!-- 60077 Limit compiler generated variables per always_comb block -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/60077.html?zoom_highlight=60077   -->
<rule id="60079" active="yes" severity="EMUL_ERROR"/>
<!-- 60079 MDA accessed with constant values only in left-most index.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/60079.html?zoom_highlight=60079   -->
<rule id="60099" active="yes" severity="EMUL_ERROR"/>
<!-- 60099 A wrap for invocation on lira_run_zero_delay_loop_check() -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/60099.html?zoom_highlight=60099   -->
<rule id="60130" active="yes" severity="EMUL_ERROR"/>
<!-- 60130 Unnamed generate blocks including declarations or instantiations are not allowed -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/60130.html?zoom_highlight=60i130  -->
<!-- rule id="0843" active="yes" severity="EMUL_ERROR"/ jk too many violations -->
<!-- 0843 %s: event on complex expression %s is non-synthesizable.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0843.html?zoom_highlight=0843   -->
<!-- rule id="816" active="yes" severity="EMUL_ERROR"/ rule exists, but running into error -->
<!-- 0816 %s: Type mismatch - no implicit conversion exists to convert the value of the expression of type %s into the type required by the context %s.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0816.html?zoom_highlight=0816   -->
<!-- rule id="2028" active="yes" severity="EMUL_ERROR"/ rule does not exist -->
<!-- 2028 Declaration of array %s range [%s] has LSB greater than the MSB. This is an unconventional range declaration.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2028.html?zoom_highlight=2028   -->

<rule id="0505" active="yes" severity="EMUL_WARN"/>
<!-- 0505 Nonsynthesizable power operator: the base must be 2.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0505.html?zoom_highlight=0505   -->
<rule id="1312" active="yes" severity="EMUL_WARN"/>
<!-- 1312 Initial blocks and initialization values are non-synthesizable (using the -treat_initial abort switch causes Lira to abort).  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1312.html?zoom_highlight=1312   -->
<rule id="1462" active="yes" severity="EMUL_WARN"/>
<!-- 1462 Trireg nets are not part of the Verilog synthesis level. They are supported by Lira, but might not be supported by other synthesis tools.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1462.html?zoom_highlight=1462   -->
<rule id="1464" active="yes" severity="EMUL_WARN"/>
<!-- 1464 Tri0 nets arent part of the Verilog synthesis level. They are supported by Lira, but might not be supported by other synthesis tools.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1464.html?zoom_highlight=1464   -->
<rule id="1465" active="yes" severity="EMUL_WARN"/>
<!-- 1465 Tri1 nets arent part of the Verilog synthesis level. They are supported by Lira, but might not be supported by other synthesis tools.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1465.html?zoom_highlight=1465   -->
<rule id="1466" active="yes" severity="EMUL_WARN"/>
<!-- 1466 UDPs arent part of the Verilog synthesis level.They are supported by Lira, but might not be supported by other synthesis tools.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1466.html?zoom_highlight=1466   -->
<rule id="1490" active="yes" severity="EMUL_WARN"/>
<!-- 1490 Do while statements arent part of the Verilog synthesis level. They are partially supported by Lira, but might not be supported by other synthesis tools.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1490.html?zoom_highlight=1490   -->
<rule id="1491" active="yes" severity="EMUL_WARN"/>
<!-- 1491 While statements arent part of the Verilog synthesis level. They are partially supported by Lira, but might not be supported by other synthesis tools.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1491.html?zoom_highlight=1491   -->
<rule id="1492" active="yes" severity="EMUL_WARN"/>
<!-- 1492 Repeat statements arent part of the Verilog synthesis level. They are partially supported by Lira, but might not be supported by other synthesis tools.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1492.html?zoom_highlight=1492   -->
<rule id="2028" active="yes" severity="EMUL_WARN"/>
<!-- 2028 Declaration of array %s range [%s] has LSB greater than the MSB. This is an unconventional range declaration.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2028.html?zoom_highlight=2028   -->


<!-- emulation rules recommended by SNB folks -->
<!-- rule id="816" active="yes" severity="EMUL_ERROR"/ rule exists, but running into error -->
<!-- 0816 %s: Type mismatch - no implicit conversion exists to convert the value of the expression of type %s into the type required by the context %s.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/0816.html?zoom_highlight=0816   -->
<!-- rule id="2028" active="yes" severity="EMUL_ERROR"/ rule does not exist -->
<!-- 2028 Declaration of array %s range [%s] has LSB greater than the MSB. This is an unconventional range declaration.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/2028.html?zoom_highlight=2028   -->


<rule id="1308" active="yes" severity="EMUL_INFO"/>
<!-- 1308 Non-synthesizable system function %s is ignored, a 0 return value is assumed.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1308.html?zoom_highlight=1308   -->
<rule id="1309" active="yes" severity="EMUL_INFO"/>
<!-- 1309 Non-synthesizable system task %s is ignored.  -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/1309.html?zoom_highlight=1309   -->



<!-- FPGA Rules START HERE   -->
<!-- rule id="55500" active="no" severity="FPGA_ERROR"/   -->
<!-- 55500: gated/generated clock not generated from top-level block -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/55500.html?zoom_highlight=55500   --> 

<!-- rule id="55501" active="no" severity="FPGA_ERROR"/    -->
<!-- 55501 clocks must not be gated by flip-flops capturing on the same clock -->
<!-- More info: http://www.iil.intel.com/pvpd/itpt/docs/crm/lintra/lintrafiles/55501.html?zoom_highlight=55501   -->



<!-- PROJECT specific RULES START HERE -->






</LINTRA_CONFIGURATION>

