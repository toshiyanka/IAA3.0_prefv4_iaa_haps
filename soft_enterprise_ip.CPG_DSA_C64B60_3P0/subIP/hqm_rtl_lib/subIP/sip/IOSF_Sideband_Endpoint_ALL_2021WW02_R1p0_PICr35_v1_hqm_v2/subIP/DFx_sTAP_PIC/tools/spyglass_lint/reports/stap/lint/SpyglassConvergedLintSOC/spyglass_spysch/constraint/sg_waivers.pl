################################################################################
#This is an internally genertaed by spyglass to populate Waiver Info for Reports
#Note:Spyglass does not support any perl routine like "spyDecompileWaiverInfo"
#     The routine is purely for internal usage of spyglass
################################################################################


use SpyGlass;

spyClearWaiverHashInPerl(0);

spyComputeWaivedViolCount("totalWaivedViolationCount"=>'26',
                          "totalGeneratedCount"=>'0',
                          "totalReportCount"=>'0'
                         );

spyDecompileWaiverInfo("waive_cmd_id"=>'1',
                       "waiverCmd"=>'q%waive  -du "ctech_lib_clk_buf" -rule "60706" -msg "ctech_lib module \'ctech_lib_clk_buf\' should be \'defined\' only inside map file" -comment "Created by adithya1 on 12-Feb-2018 11:28:49"%',
                       "-du"=>'"ctech_lib_clk_buf"',
                       "-rule"=>'"60706"',
                       "-msg"=>'q%ctech_lib module \'ctech_lib_clk_buf\' should be \'defined\' only inside map file%',
                       "-comment"=>'"Created by adithya1 on 12-Feb-2018 11:28:49"',
                       "violations_waived"=>'32',
                       "partial_violations_waived"=>'',
                       "cmd_status"=>'1',
                       "waiverfile"=>'"/nfs/iind/disks/dteg_disk007/users/adithya1/GIT/spyglasscdc/dteg-stap/target/stap/TGL/aceroot/tools/spyglass_lint/sglint_time0_waivers.awl"',
                       "waiverline"=>'1'
                      );

spyDecompileWaiverInfo("waive_cmd_id"=>'2',
                       "waiverCmd"=>'q%waive  -exact  -rule "50002" -comment "Created by adithya1 on 12-Feb-2018 11:56:21 Ctech releated"%',
                       "-rule"=>'"50002"',
                       "-exact"=>'1',
                       "-comment"=>'"Created by adithya1 on 12-Feb-2018 11:56:21 Ctech releated"',
                       "violations_waived"=>'42',
                       "partial_violations_waived"=>'',
                       "cmd_status"=>'1',
                       "waiverfile"=>'"/nfs/iind/disks/dteg_disk007/users/adithya1/GIT/spyglasscdc/dteg-stap/target/stap/TGL/aceroot/tools/spyglass_lint/sglint_time0_waivers.awl"',
                       "waiverline"=>'2'
                      );

spyDecompileWaiverInfo("waive_cmd_id"=>'3',
                       "waiverCmd"=>'q%waive  -exact  -rule "50520" -comment "Created by adithya1 on 12-Feb-2018 11:57:29          Ctech Releated"%',
                       "-rule"=>'"50520"',
                       "-exact"=>'1',
                       "-comment"=>'"Created by adithya1 on 12-Feb-2018 11:57:29          Ctech Releated"',
                       "violations_waived"=>'7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26',
                       "partial_violations_waived"=>'',
                       "cmd_status"=>'1',
                       "waiverfile"=>'"/nfs/iind/disks/dteg_disk007/users/adithya1/GIT/spyglasscdc/dteg-stap/target/stap/TGL/aceroot/tools/spyglass_lint/sglint_time0_waivers.awl"',
                       "waiverline"=>'3'
                      );

spyDecompileWaiverInfo("waive_cmd_id"=>'4',
                       "waiverCmd"=>'q%waive  -exact  -rule "60706" -comment "Created by adithya1 on 12-Feb-2018 11:58:05  Ctech Releated"%',
                       "-rule"=>'"60706"',
                       "-exact"=>'1',
                       "-comment"=>'"Created by adithya1 on 12-Feb-2018 11:58:05  Ctech Releated"',
                       "violations_waived"=>'43 52',
                       "partial_violations_waived"=>'',
                       "cmd_status"=>'1',
                       "waiverfile"=>'"/nfs/iind/disks/dteg_disk007/users/adithya1/GIT/spyglasscdc/dteg-stap/target/stap/TGL/aceroot/tools/spyglass_lint/sglint_time0_waivers.awl"',
                       "waiverline"=>'4'
                      );

spyDecompileWaiverInfo("waive_cmd_id"=>'5',
                       "waiverCmd"=>'q%waive  -exact  -du "stap_ctech_lib_dq" -rule "OneModule-ML" -msg "File \'\$env(stap_MODEL_ROOT)/source/rtl/ctech_lib/stap_ctech_map.sv\' contains more than one module" -comment "Created by adithya1 on 12-Feb-2018 11:58:46  Ctech "%',
                       "-du"=>'"stap_ctech_lib_dq"',
                       "-rule"=>'q%OneModule-ML%',
                       "-exact"=>'1',
                       "-msg"=>'q%File \'/nfs/iind/disks/dteg_disk007/users/adithya1/GIT/spyglasscdc/dteg-stap/source/rtl/ctech_lib/stap_ctech_map.sv\' contains more than one module%',
                       "-comment"=>'"Created by adithya1 on 12-Feb-2018 11:58:46  Ctech "',
                       "violations_waived"=>'6',
                       "partial_violations_waived"=>'',
                       "cmd_status"=>'1',
                       "waiverfile"=>'"/nfs/iind/disks/dteg_disk007/users/adithya1/GIT/spyglasscdc/dteg-stap/target/stap/TGL/aceroot/tools/spyglass_lint/sglint_time0_waivers.awl"',
                       "waiverline"=>'5'
                      );

spyDecompileWaiverInfo("waive_cmd_id"=>'6',
                       "waiverCmd"=>'q%waive  -exact  -du "stap_irdecoder" -rule "UnInitializedReset-ML" -msg "Signal \'stap_irdecoder_drselect\' is not initialized in reset block." -comment "Created by adithya1 on 12-Feb-2018 11:59:11  Fine by design"%',
                       "-du"=>'"stap_irdecoder"',
                       "-rule"=>'q%UnInitializedReset-ML%',
                       "-exact"=>'1',
                       "-msg"=>'q%Signal \'stap_irdecoder_drselect\' is not initialized in reset block.%',
                       "-comment"=>'"Created by adithya1 on 12-Feb-2018 11:59:11  Fine by design"',
                       "violations_waived"=>'36',
                       "partial_violations_waived"=>'',
                       "cmd_status"=>'1',
                       "waiverfile"=>'"/nfs/iind/disks/dteg_disk007/users/adithya1/GIT/spyglasscdc/dteg-stap/target/stap/TGL/aceroot/tools/spyglass_lint/sglint_time0_waivers.awl"',
                       "waiverline"=>'6'
                      );

spyWaiversDataCount("totalWaivers"=>'6',
"totalWaiversApplied"=>'6',
"totalWaiversWithRegExp"=>'0',
"totalWaiversWithRuleSpecified"=>'6',
"totalWaiversWithIpSpecified"=>'0',
"totalWaiversWithFileLine"=>'0',
                         );

spyProhibitWaiverRules(                         );

spySetWaivedViolationNumberHash("");

1;
