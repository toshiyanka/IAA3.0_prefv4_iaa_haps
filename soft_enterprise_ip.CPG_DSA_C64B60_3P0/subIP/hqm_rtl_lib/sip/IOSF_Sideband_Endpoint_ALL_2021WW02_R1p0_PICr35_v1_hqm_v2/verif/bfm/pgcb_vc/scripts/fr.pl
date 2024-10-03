#!/usr/bin/env perl                                                                                             
########################################################
# all the stuff that is common between all the SIP files
########################################################
sub common_sip_fr {
   	$line =~ s/cfg.cfg_sip_pgcb\[i\].initial_state/cfg.cfg_sip_pgcb_n\[name\].initial_state/g;		
	$line =~ s/vif.fet_en_b\[cfg.cfg_sip_pgcb\[i\].getFETNum\(\)]/sip_if.fet_en_b/g;
   	$line =~ s/vif.fet_en_ack_b\[cfg.cfg_sip_pgcb\[i\].getFETNum\(\)]/sip_if.fet_en_ack_b/g;	
   	$line =~ s/vif.pmc_ip_pg_ack_b\[i\]/sip_if.pmc_ip_pg_ack_b/g;
   	$line =~ s/vif.ip_pmc_pg_req_b\[i\]/sip_if.ip_pmc_pg_req_b/g;
   	$line =~ s/vif.pmc_ip_restore_b\[i\]/sip_if.pmc_ip_restore_b/g;
   	$line =~ s/vif.restore_next_wake\[i\]/sip_if.restore_next_wake/g;
	$line =~ s/vif.fdfx_pgcb_bypass\[i\]/sip_if.fdfx_pgcb_bypass/g;
	$line =~ s/vif.fdfx_pgcb_ovr\[i\]/sip_if.fdfx_pgcb_ovr/g;
	#$line =~ s/vif.pmc_ip_sw_pg_req_b\[i\]/sip_if.pmc_ip_sw_pg_req_b/g;	
	$line =~ s/vif.pmc_ip_sw_pg_req_b\[cfg.cfg_sip_pgcb\[i\].sw_ent_index\]/sip_if.pmc_ip_sw_pg_req_b/g;
    $line =~ s/vif.pmc_ip_pg_wake\[cfg.cfg_sip_pgcb\[i\].pmc_wake_index\]/sip_if.pmc_ip_pg_wake/g;
    $line =~ s/cfg.cfg_sip_pgcb\[i\].getName\(\)/name/g;
    $line =~ s/cfg.cfg_sip_pgcb\[i\].name/name/g;	
#$line =~ s/x.source = i;/x.source = cfg.sip_index\[name\];x.sourceName = name;/g;
	$line =~ s/x.source = i;/x.source = i;x.sourceName = name;/g;
	$line =~ s/vif.reset_b/sip_if.reset_b/g;
	$line =~ s/vif.clk/sip_if.clk/g;
	$line =~ s/vif.jtag_tck/sip_if.jtag_tck/g;

}
########################################################
# all the stuff that is common between all the fabric files
########################################################
sub common_fab_fr {
   	$line =~ s/cfg.cfg_fab_pgcb\[i\].initial_state/cfg.cfg_fab_pgcb_n\[name\].initial_state/g;		
   	$line =~ s/vif.fab_pmc_idle\[i\]/fab_if.fab_pmc_idle/g;
	#TODO: is sip_dependency stuff needed?
	#$line =~ s/cfg.cfg_fab_pgcb\[i\].sip_pgcb_dependency/cfg.cfg_fab_pgcb_n\[name\].sip_pgcb_dependency/g;
	$line =~ s/\/\/ START collage comment out/\/\* START collage comment out/g;	
	$line =~ s/\/\/ END collage comment out/ END collage comment out\*\//g;
   	$line =~ s/vif.fab_pmc_idle\[i\]/fab_if.fab_pmc_idle/g;
   	$line =~ s/vif.pmc_fab_pg_rdy_req_b\[i\]/fab_if.pmc_fab_pg_rdy_req_b/g;
   	$line =~ s/vif.fab_pmc_pg_rdy_ack_b\[i\]/fab_if.fab_pmc_pg_rdy_ack_b/g;
   	$line =~ s/vif.fab_pmc_pg_rdy_nack_b\[i\]/fab_if.fab_pmc_pg_rdy_nack_b/g;
    $line =~ s/cfg.cfg_fab_pgcb\[i\].getName\(\)/name/g;
    $line =~ s/cfg.cfg_fab_pgcb\[i\].name/name/g;
	$line =~ s/vif.pmc_ip_pg_ack_b\[cfg.sip_belongs_to_fabric\[i\]\]/sip_if.pmc_ip_pg_ack_b/g;
	$line =~ s/vif.ip_pmc_pg_req_b\[cfg.sip_belongs_to_fabric\[i\]\]/sip_if.ip_pmc_pg_req_b/g;
	$line =~ s/\[\%\-d\]/\[\%\-s\]/g;
	$line =~ s/i, cfg.sip_belongs_to_fabric\[i\]/name, cfg.sip_belongs_to_fabric_n\[name\]/g;
#$line =~ s/x.source = i;/x.source = cfg.fab_index\[name\];x.sourceName = name;/g;
	$line =~ s/x.source = i;/x.source = i;x.sourceName = name;/g;
	$line =~ s/vif.reset_b/fab_if.reset_b/g;
	$line =~ s/vif.clk/fab_if.clk/g;

}
########################################################
# sub routine to open a file 
########################################################
sub open_files {
	open(FILE,$_[0]) || die("Cannot Open File");
	my(@fcont) = <FILE>;
	close FILE;
	print ("Filename:",$_[0],"\n");
	open(FOUT,">$_[1]") || die("Cannot Open File");
	print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";
}

########################################################
# 	SIP(CC) DONE 
########################################################
#&open_files("CCAgentSIPFSM.svh", "CCAgentSIPFSM_Col.svh");
	open(FILE,"source/CC/CCAgentSIPFSM.svh") || die("Cannot Open File");
	my(@fcont) = <FILE>;
	close FILE;
	print ("Filename:","source/CC/CCAgentSIPFSM.svh","\n");
	open(FOUT,">CCAgentSIPFSM_Col.svh") || die("Cannot Open File");
	print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

foreach $line (@fcont) {	
	&common_sip_fr;
 	$line =~ s/CCAgentSIPFSM/CCAgentSIPFSM_Col/g;
    print FOUT $line;
}
close FOUT;
`mv CCAgentSIPFSM_Col.svh source/CC`;

########################################################
# SIP(PGCB)
#########################################################
	open(FILE,"source/PGCB/PGCBAgentSIPFSM.svh") || die("Cannot Open File");
	my(@fcont) = <FILE>;
	close FILE;
	print ("Filename:","source/PGCB/PGCBAgentSIPFSM.svh","\n");
	open(FOUT,">PGCBAgentSIPFSM_Col.svh") || die("Cannot Open File");
	print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

foreach $line (@fcont) {	
	&common_sip_fr;
 	$line =~ s/PGCBAgentSIPFSM/PGCBAgentSIPFSM_Col/g;
    print FOUT $line;
}
close FOUT;
`mv PGCBAgentSIPFSM_Col.svh source/PGCB`;
########################################################
# SIP monitor DONE 
########################################################
my $fileName = "source/Common/PowerGatingSIPFSM.svh";
my $fileName_new = "PowerGatingSIPFSM_Col.svh";
open(FILE,$fileName) || die("Cannot Open File");
my(@fcont) = <FILE>;
close FILE;
print ("Filename:",$fileName,"\n");
open(FOUT,">$fileName_new") || die("Cannot Open File");
print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

foreach $line (@fcont) {
	&common_sip_fr;

     $line =~ s/cfg.cfg_sip_pgcb\[i\].SB_index.size\(\)/cfg.cfg_sip_pgcb_n\[name\].num_side/g;
     $line =~ s/cfg.cfg_sip_pgcb\[i\].prim_index.size\(\)/cfg.cfg_sip_pgcb_n\[name\].num_prim/g;
	#$line =~ s/x.source = i;/x.source = cfg.sip_index\[name\];x.sourceName = name;/g;
     $line =~ s/x.fabricIndex/\/\//g;
     $line =~ s/cfg.cfg_sip_pgcb\[i\].fabric_index != -1/cfg.cfg_sip_pgcb_n\[name\].fabric_name != ""/g;
     $line =~ s/cfg.cfg_sip_pgcb\[i\].fabric_index == -1/cfg.cfg_sip_pgcb_n\[name\].fabric_name == ""/g;	 
     $line =~ s/vif.pmc_fab_pg_rdy_req_b\[cfg.cfg_sip_pgcb\[i\].fabric_index\]/fab_if.pmc_fab_pg_rdy_req_b/g;
     $line =~ s/foreach\(cfg.cfg_sip_pgcb\[i\].SB_index\[n\]\)/if\(1\)/g;
     $line =~ s/vif.side_pok\[cfg.cfg_sip_pgcb\[i\].SB_index\[n\]\] !== 0/\$countones\(sip_if.side_pok\) != 0/g;
     $line =~ s/foreach\(cfg.cfg_sip_pgcb\[i\].prim_index\[n\]\) /if\(1\)/g;
     $line =~ s/vif.prim_pok\[cfg.cfg_sip_pgcb\[i\].prim_index\[n\]\] !== 0/\$countones\(sip_if.prim_pok\) != 0/g;

	 $line =~ s/vif.side_pok\[cfg.cfg_sip_pgcb\[i\].SB_index\[n\]\] === 0/\$countones\(sip_if.side_pok\) == 0/g;
     $line =~ s/vif.prim_pok\[cfg.cfg_sip_pgcb\[i\].prim_index\[n\]\] === 0/\$countones\(sip_if.prim_pok\) == 0/g;
     $line =~ s/vif.side_pok\[cfg.cfg_sip_pgcb\[i\].SB_index\[n\]\] === 1/\$countones\(sip_if.side_pok\) == cfg.cfg_sip_pgcb_n\[name\].num_side/g;
     $line =~ s/vif.prim_pok\[cfg.cfg_sip_pgcb\[i\].prim_index\[n\]\] === 1/\$countones\(sip_if.prim_pok\) == cfg.cfg_sip_pgcb_n\[name\].num_prim/g;	 
     $line =~ s/vif.fet_en_b\[cfg.cfg_sip_pgcb\[i\].fet_index\]/sip_if.fet_en_b/g;
     $line =~ s/vif.fet_en_ack_b\[cfg.cfg_sip_pgcb\[i\].fet_index\]/sip_if.fet_en_ack_b/g;

	#monitor changes
		  
	$line =~ s/\/\/`include "PowerGatingMonitorInclude_Col.svh"/`include "PowerGatingMonitorInclude_Col.svh"/g;
	$line =~ s/\/\*START collage uncomment out/\/\/START collage uncomment out/g;	
	$line =~ s/END collage uncomment out\*\//\/\/END collage uncomment out/g;
	#this needs to be done last
    $line =~ s/cfg.cfg_sip_pgcb\[i\].fabric_index/cfg.cfg_sip_pgcb_n\[name\].fabric_name/g;

	#the cfg needs to be at the end becasue fet_en[cfg..] exists 
    $line =~ s/cfg.cfg_sip_pgcb\[i\]/cfg.cfg_sip_pgcb_n\[name\]/g;	
	
    $line =~ s/PowerGatingSIPFSM/PowerGatingSIPFSM_Col/g;	

    print FOUT $line;
}
close FOUT;
`mv PowerGatingSIPFSM_Col.svh source/Common`;

########################################################
#Fabric(CC)
#########################################################
open(FILE,"source/CC/CCAgentFabricFSM.svh") || die("Cannot Open File");
my(@fcont) = <FILE>;
close FILE;
print ("Filename:","source/CC/CCAgentFabricFSM.svh","\n");
open(FOUT,">CCAgentFabricFSM_Col.svh") || die("Cannot Open File");
print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

foreach $line (@fcont) {	
	&common_fab_fr;
 	$line =~ s/CCAgentFabricFSM/CCAgentFabricFSM_Col/g;
    print FOUT $line;
}
close FOUT;
`mv CCAgentFabricFSM_Col.svh source/CC`;
########################################################
#Fabric(PGCB)
#########################################################
open(FILE,"source/PGCB/PGCBAgentFabricFSM.svh") || die("Cannot Open File");
my(@fcont) = <FILE>;
close FILE;
print ("Filename:","source/PGCB/PGCBAgentFabricFSM.svh","\n");
open(FOUT,">PGCBAgentFabricFSM_Col.svh") || die("Cannot Open File");
print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

foreach $line (@fcont) {	
	&common_fab_fr;
 	$line =~ s/PGCBAgentFabricFSM/PGCBAgentFabricFSM_Col/g;
    print FOUT $line;
}
close FOUT;
`mv PGCBAgentFabricFSM_Col.svh source/PGCB`; 
########################################################
#Fabric monitor
#########################################################
open(FILE,"source/Common/PowerGatingFabricFSM.svh") || die("Cannot Open File");
my(@fcont) = <FILE>;
close FILE;
print ("Filename:","source/Common/PowerGatingFabricFSM.svh","\n");
open(FOUT,">PowerGatingFabricFSM_Col.svh") || die("Cannot Open File");
print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

foreach $line (@fcont) {	
	&common_fab_fr;

 	$line =~ s/PowerGatingFabricFSM/PowerGatingFabricFSM_Col/g;
    print FOUT $line;
}
close FOUT;
`mv PowerGatingFabricFSM_Col.svh source/Common`; 

########################################################
#Main monitor
#########################################################
#open(FILE,"source/Common/PowerGatingMonitorInclude.svh") || die("Cannot Open File");
#my(@fcont) = <FILE>;
#close FILE;
#print ("Filename:","source/Common/PowerGatingMonitorInclude.svh","\n");
#open(FOUT,">PowerGatingMonitorInclude_Col.svh") || die("Cannot Open File");
#print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

#foreach $line (@fcont) {	


#}
#close FOUT;
#`mv PowerGatingMonitorInclude_Col.svh source/Common`; 

#########################################################
#open(FILE,"source/Common/PowerGatingMonitor.svh") || die("Cannot Open File");
#my(@fcont) = <FILE>;
#close FILE;
#print ("Filename:","source/Common/PowerGatingMonitor.svh","\n");
#open(FOUT,">PowerGatingMonitor_Col.svh") || die("Cannot Open File");
#print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

#foreach $line (@fcont) {	
#	$line =~ s/\`include \"PowerGatingMonitorInclude.svh\"//g;
#	$line =~ s/\/\/COLLAGE COMMENT OUT/\/*\/\/COLLAGE COMMENT OUT/g;
#	$line =~ s/\/\/END COLLAGE COMMENT OUT/\/\/END COLLAGE COMMENT OUT *\//g;
#}
#close FOUT;
#`mv PowerGatingMonitor_Col.svh source/Common`;

########################################################
#Main FSM
#########################################################
#########################################################
#CC Drivers
#########################################################

sub common_driver_fr {
#SIP include
	$line =~ s/arb_sem/arb_sem_c/g;
	$line =~ s/int source/string source_name/g;
	$line =~ s/source = req_arg.source/source_name = req_arg.sourceName/g;
	$line =~ s/\/\/wait\(sip_vif\[source_name\].pmc_ip_pg_ack_b === 1\)/wait\(sip_vif\[source_name\].pmc_ip_pg_ack_b === 1\)/g;
	$line =~ s/\/\/START collage comment out/\/\*START collage comment out/g;	
	$line =~ s/\/\/END collage comment out/END collage comment out\*\//g;
	$line =~ s/_vif.pmc_ip_pg_wake\[source\]/sip_vif\[source_name\].pmc_ip_pg_wake/g;
	$line =~ s/for\(int i \= 0; i \< cfg.num_pmc_wake; i \+\+\)/foreach\(cfg.cfg_sip_pgcb_n\[source_name\]\)/g;
	$line =~ s/_vif.pmc_ip_pg_wake\[i\]/sip_vif\[source_name\].pmc_ip_pg_wake/g;
	$line =~ s/\/\*START collage uncomment out/\/\/START collage uncomment out/g;	
	$line =~ s/END collage uncomment out\*\//\/\/END collage uncomment out/g;
	$line =~ s/_vif.fet_en_b\[fet_index\] !== 0/sip_vif\[source_name\].fet_en_b !== 0/g;
#replace driving fet wiht a for loop of all sip interfaces
	$line =~ s/_vif.fet_en_b\[fet_index\] = 0;/foreach(cfg.cfg_sip_pgcb_n_all\[n\]) begin if(fet_name == cfg.cfg_sip_pgcb_n_all\[n\].fet_name) begin sip_vif_all\[n\].fet_en_b = 0; end end/g;
	$line =~ s/int fet_index/string fet_name/g;
	$line =~ s/fet_index = /fet_name =/g; 
	$line =~ s/req_arg.source;/req_arg.sourceName;/g;
	$line =~ s/cfg.cfg_sip_pgcb\[source\].fet_index/cfg.cfg_sip_pgcb_n\[source_name\].fet_name/g;
#$line =~ s/_vif.fet_en_ack_b\[fet_index\]/fet_vif\[fet_name\].fet_en_ack_b/g;
	$line =~ s/wait\(_vif.fet_en_ack_b\[fet_index\] === 0\);/foreach\(cfg.cfg_sip_pgcb_n_all\[n\]\) begin if(fet_name == cfg.cfg_sip_pgcb_n_all\[n\].fet_name\) begin wait\(sip_vif_all\[n\].fet_en_ack_b === 0\); end end/g;
	$line =~ s/_vif.restore_next_wake\[source\]/sip_vif\[source_name\].restore_next_wake/g;
	$line =~ s/_vif.pmc_ip_restore_b\[source\]/sip_vif\[source_name\].pmc_ip_restore_b/g;
	$line =~ s/_vif.pmc_ip_pg_ack_b\[source\]/sip_vif\[source_name\].pmc_ip_pg_ack_b/g;

	$line =~ s/DriveFetOffIndex\(req_arg.delay_fet_dis, fet_index\)/DriveFetOffIndex\(req_arg.delay_fet_dis, fet_name\)/g;
	$line =~ s/_vif.SIG_NAME\[source\]/sip_vif\[source_name\].SIG_NAME/g;
	$line =~ s/pg_driver_task\(driveSideRst, side_rst_b\)/pg_rst_driver_task\(driveSideRst, side_rst_b, num_side\)/g;
	$line =~ s/pg_driver_task\(drivePrimRst, prim_rst_b\)/pg_rst_driver_task\(drivePrimRst, prim_rst_b, num_prim\)/g;
	$line =~ s/pg_driver_task/pg_driver_task_col/g;
	$line =~ s/pg_rst_driver_task/pg_rst_driver_task_col/g;
	$line =~ s/pg_dfx_driver_task/pg_dfx_driver_task_col/g;

#fet
	$line =~ s/_vif.pmc_ip_pg_ack_b\[i\]/sip_vif_all\[source_name\].pmc_ip_pg_ack_b/g;
	$line =~ s/cfg.cfg_sip_pgcb\[i\].fet_index === fet_index/cfg.cfg_sip_pgcb_n_all\[source_name\].fet_name == fet_name/g;
	$line =~ s/fetCanBeTurnedOff\(int fet_index\)/fetCanBeTurnedOff(string fet_name)/g;
	$line =~ s/fetCanBeTurnedOff\(fet_index\)/fetCanBeTurnedOff(fet_name)/g;
	$line =~ s/for\(int i \= 0; i \< cfg.num_sip_pgcb ; i \+\+\)/foreach\(cfg.cfg_sip_pgcb_n\[source_name\]\)/g;
	$line =~ s/fetONMode\[fet_index\]/cfg.fetONMode_n\[fet_name\]/g;
	$line =~ s/DriveFetOffIndex\(delay_arg, fet_index\)/DriveFetOffIndex\(delay_arg, fet_name\)/g;
	$line =~ s/_vif.fet_en_b\[fet_index\] = 1;/foreach(cfg.cfg_sip_pgcb_n_all\[n\]) begin if(fet_name == cfg.cfg_sip_pgcb_n_all\[n\].fet_name) begin sip_vif_all\[n\].fet_en_b = 1; end end/g;
	$line =~ s/wait\(_vif.fet_en_ack_b\[fet_index\] === 1\);/foreach(cfg.cfg_sip_pgcb_n_all\[n\]) begin if\(fet_name == cfg.cfg_sip_pgcb_n_all\[n\].fet_name\) begin wait\(sip_vif_all\[n\].fet_en_ack_b === 1\); end end/g;
	
#fab
	$line =~ s/cfg.cfg_fab_pgcb\[source\].getHys/cfg.cfg_fab_pgcb_n\[source_name\].getHys/g;	
	$line =~ s/_vif.fab_pmc_idle\[source\]/fab_vif\[source_name\].fab_pmc_idle/g;
	$line =~ s/_vif.fab_pmc_pg_rdy_ack_b\[source\]/fab_vif\[source_name\].fab_pmc_pg_rdy_ack_b/g;
	$line =~ s/_vif.fab_pmc_pg_rdy_nack_b\[source\]/fab_vif\[source_name\].fab_pmc_pg_rdy_nack_b/g;
	$line =~ s/_vif.pmc_fab_pg_rdy_req_b\[source\]/fab_vif\[source_name\].pmc_fab_pg_rdy_req_b/g;

#PGCB driver
	$line =~ s/cfg.sip_belongs_to_fabric.exists\(source\)/cfg.sip_belongs_to_fabric_n.exists\(source_name\)/g;
	$line =~ s/_vif.ip_pmc_pg_req_b\[cfg.sip_belongs_to_fabric\[source\]\]/sip_vif\[cfg.sip_belongs_to_fabric_n\[source_name\]\].ip_pmc_pg_req_b/g;
	$line =~ s/_vif.pmc_ip_pg_ack_b\[cfg.sip_belongs_to_fabric\[source\]\]/sip_vif\[cfg.sip_belongs_to_fabric_n\[source_name\]\].pmc_ip_pg_ack_b/g;
	
	$line =~ s/_vif.ip_pmc_pg_req_b\[source\]/sip_vif\[source_name\].ip_pmc_pg_req_b/g;	
#drive all poks
#logic'{defaul:value}
	$line =~ s/_vif.side_pok\[source\]  = value/sip_vif\[source_name\].side_pok = value/g;	
	$line =~ s/_vif.prim_pok\[source\]  = value/sip_vif\[source_name\].prim_pok = value/g;		
	$line =~ s/source\)\)/source_name\)\)/g;
	}

#Driver
open(FILE,"source/CC/CCAgentDriver.svh") || die("Cannot Open File");
my(@fcont) = <FILE>;
close FILE;
print ("Filename:","source/CC/CCAgentDriver.svh","\n");
open(FOUT,">CCAgentDriver_Col.svh") || die("Cannot Open File");
print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

foreach $line (@fcont) {	

 	$line =~ s/CCAgentDriverSIPInclude/CCAgentDriverSIPInclude_Col/g;
 	$line =~ s/CCAgentDriverFabInclude/CCAgentDriverFabInclude_Col/g; 
 	$line =~ s/CCAgentDriverFetInclude/CCAgentDriverFetInclude_Col/g; 
 	$line =~ s/class CCAgentDriver /class CCAgentDriver_Col /g;	
	$line =~ s/endclass \: CCAgentDriver/endclass \: CCAgentDriver_Col/g;	
	$line =~ s/\(CCAgentDriver/\(CCAgentDriver_Col/g;	

    print FOUT $line;
}
close FOUT;
`mv CCAgentDriver_Col.svh source/CC`;
#########################################################
#SIP include 
open(FILE,"source/CC/CCAgentDriverSIPInclude.svh") || die("Cannot Open File");
my(@fcont) = <FILE>;
close FILE;
print ("Filename:","source/CC/CCAgentDriverSIPInclude.svh","\n");
open(FOUT,">CCAgentDriverSIPInclude_Col.svh") || die("Cannot Open File");
print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

foreach $line (@fcont) {	
	&common_driver_fr;
	$line =~ s/_vif.clk/sip_vif\[source_name\].clk/g;
	$line =~ s/delay_sip\(delay\);/delay_sip\(delay, source_name\);/g;
	$line =~ s/delay_wake\(delay\);/delay_wake\(delay, source_name\);/g;
	$line =~ s/delay_dfx\(delay\);/delay_dfx\(delay, source_name\);/g;

 	$line =~ s/CCAgentDriverSIPInclude/CCAgentDriverSIPInclude_Col/g;
    print FOUT $line;
}
close FOUT;
`mv CCAgentDriverSIPInclude_Col.svh source/CC`;
#########################################################
#Fab include 
open(FILE,"source/CC/CCAgentDriverFabInclude.svh") || die("Cannot Open File");
my(@fcont) = <FILE>;
close FILE;
print ("Filename:","source/CC/CCAgentDriverFabInclude.svh","\n");
open(FOUT,">CCAgentDriverFabInclude_Col.svh") || die("Cannot Open File");
print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

foreach $line (@fcont) {	
	&common_driver_fr;
	$line =~ s/_vif.clk/fab_vif\[source_name\].clk/g;
	$line =~ s/delay_fab\(req_arg.delayComplete\);/delay_fab\(req_arg.delayComplete, source_name\);/g;
	$line =~ s/delay_fab\(delay_arg\);/delay_fab\(delay_arg, source_name\);/g;
 	$line =~ s/CCAgentDriverFabInclude/CCAgentDriverFabInclude_Col/g;
    print FOUT $line;
}
close FOUT;
`mv CCAgentDriverFabInclude_Col.svh source/CC`;
#########################################################
#Fab include 
open(FILE,"source/CC/CCAgentDriverFetInclude.svh") || die("Cannot Open File");
my(@fcont) = <FILE>;
close FILE;
print ("Filename:","source/CC/CCAgentDriverFetInclude.svh","\n");
open(FOUT,">CCAgentDriverFetInclude_Col.svh") || die("Cannot Open File");
print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

foreach $line (@fcont) {	
	&common_driver_fr;
	$line =~ s/foreach\(cfg.cfg_sip_pgcb_n\[source_name\]\)/foreach\(cfg.cfg_sip_pgcb_n_all\[source_name\]\)/g;
 	$line =~ s/CCAgentDriverFetInclude/CCAgentDriverFetInclude_Col/g;
    print FOUT $line;
}
close FOUT;
`mv CCAgentDriverFetInclude_Col.svh source/CC`;

########################################################
#PGCB Drivers
#########################################################
open(FILE,"source/PGCB/PGCBAgentDriver.svh") || die("Cannot Open File");
my(@fcont) = <FILE>;
close FILE;
print ("Filename:","source/PGCB/PGCBAgentDriver.svh","\n");
open(FOUT,">PGCBAgentDriver_Col.svh") || die("Cannot Open File");
print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

foreach $line (@fcont) {	

 	$line =~ s/PGCBAgentDriverSIPInclude/PGCBAgentDriverSIPInclude_Col/g;
 	$line =~ s/PGCBAgentDriverFabInclude/PGCBAgentDriverFabInclude_Col/g; 
#$line =~ s/PGCBAgentDriverFetInclude/PGCBAgentDriverFetInclude_Col/g; 
 	$line =~ s/class PGCBAgentDriver /class PGCBAgentDriver_Col /g;	
	$line =~ s/endclass \: PGCBAgentDriver/endclass \: PGCBAgentDriver_Col/g;	
	$line =~ s/\(PGCBAgentDriver/\(PGCBAgentDriver_Col/g;	

    print FOUT $line;
}
close FOUT;
`mv PGCBAgentDriver_Col.svh source/PGCB`;
#########################################################
#SIP include 
open(FILE,"source/PGCB/PGCBAgentDriverSIPInclude.svh") || die("Cannot Open File");
my(@fcont) = <FILE>;
close FILE;
print ("Filename:","source/PGCB/PGCBAgentDriverSIPInclude.svh","\n");
open(FOUT,">PGCBAgentDriverSIPInclude_Col.svh") || die("Cannot Open File");
print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

foreach $line (@fcont) {	
	&common_driver_fr;
	$line =~ s/_vif.clk/sip_vif\[source_name\].clk/g;
	$line =~ s/delay_sip\(delay\);/delay_sip\(delay, source_name\);/g;
 	$line =~ s/PGCBAgentDriverSIPInclude/PGCBAgentDriverSIPInclude_Col/g;
    print FOUT $line;
}
close FOUT;
`mv PGCBAgentDriverSIPInclude_Col.svh source/PGCB`;
#########################################################
#Fab include 
open(FILE,"source/PGCB/PGCBAgentDriverFabInclude.svh") || die("Cannot Open File");
my(@fcont) = <FILE>;
close FILE;
print ("Filename:","source/PGCB/PGCBAgentDriverFabInclude.svh","\n");
open(FOUT,">PGCBAgentDriverFabInclude_Col.svh") || die("Cannot Open File");
print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

foreach $line (@fcont) {	
	&common_driver_fr;
	$line =~ s/_vif.clk/fab_vif\[source_name\].clk/g;
	$line =~ s/delay_fab\(delay\);/delay_fab\(delay, source_name\);/g;
 	$line =~ s/PGCBAgentDriverFabInclude/PGCBAgentDriverFabInclude_Col/g;
    print FOUT $line;
}
close FOUT;
`mv PGCBAgentDriverFabInclude_Col.svh source/PGCB`;
#########################################################
#Fet include 
#open(FILE,"source/PGCB/PGCBAgentDriverFetInclude.svh") || die("Cannot Open File");
#my(@fcont) = <FILE>;
#close FILE;
#print ("Filename:","source/PGCB/PGCBAgentDriverFetInclude.svh","\n");
#open(FOUT,">PGCBAgentDriverFetInclude_Col.svh") || die("Cannot Open File");
#print FOUT "/*THIS FILE IS GENERATED. DO NOT MODIFY*/\n";

#foreach $line (@fcont) {	
#	&common_driver_fr;
# 	$line =~ s/PGCBAgentDriverFetInclude/PGCBAgentDriverFetInclude_Col/g;
#    print FOUT $line;
#}
#close FOUT;
#`mv PGCBAgentDriverFetInclude_Col.svh source/PGCB`;
