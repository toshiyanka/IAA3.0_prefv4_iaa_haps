#!/usr/bin/perl 

##USAGE hqm_reorder_pipe.perl <configs.pl case>

require "./configs.pl";
$SCALING_CASE = shift;
if ($SCALING_CASE eq "") {$CASE = "HQMv3"; } else {$CASE = $SCALING_CASE}
configs($CASE);

#TYPE,DEPTH,WIDTH,NAME,SUFFIX,ADDRPAD,DATAPAD,INSTANCES
$B2{"2"} = 1; $B2{"4"} = 2; $B2{"8"} = 3; $B2{"16"} = 4; $B2{"32"} = 5; $B2{"64"} = 6; $B2{"128"} = 7; $B2{"192"} = 8; $B2{"256"} = 8; $B2{"384"} = 9; $B2{"512"} = 9; $B2{"1024"} = 10; $B2{"2048"} = 11; $B2{"4096"} = 12; $B2{"5120"} = 13; $B2{"8192"} = 13; $B2{"16384"} = 14; $B2{"32768"} = 15; $B2{"65536"} = 16;

$_PARITY=1; #parity
$_RESIDUE=2; #residue
$ECC=8; #ecc

##these width do no scale, would require RTL update to change where to extract parity & reqidue

###### local depth parameters




################################################################
# Format expected by mem_access.perl is:
#0   ,1    ,2    ,3   ,4 ,5         ,6         ,7       ,8 ,9  ,10    ,11    ,12    ,13    ,14  ,15     ,16,17
#type,depth,width,name,4?,awidth_pad,dwidth_pad,bcam_num,8?,cfg,rd_clk,rd_rst,wr_clk,wr_rst,ipar,top_clk,pg,util%
#
# Format of mem comment fields in perl input files expected by mem_access.perl after processing is:
# IGNORE        ECCECC  RESRES   PARPAR    BCBC     APP NOT_APP
#               D  P    D  P     D  P      D P      Pr  Pr
# 1             2  3    4  5     6  7      8 9      10  11
################################################################
##--------------------------------------------------
## regfile RAM
open OUTPUT, ">hqm_reorder_pipe_rfw";

                                                                                                                                                              	#,END2END       , _ECC  , _RES  , _PARITY , _BCAM
                                                                                                                                                              	#------------------------------------------------

printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(4)      ,(203+$_PARITY)              ,"rop_chp_rop_hcw_fifo_mem" ,""    ,0    ,0    ,1            ,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;      	#,              ,  ,    ,  ,    ,1 ,203   ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(2048)   ,(14+$_PARITY)               ,"reord_lbhp_mem"           ,""    ,0    ,0    ,1*$ORD_ENABLE, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;           #,              ,  ,    ,  ,    ,1 ,14    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(2048)   ,(22+$_PARITY)               ,"reord_st_mem"             ,""    ,0    ,0    ,1*$ORD_ENABLE, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;       	#,              ,  ,    ,  ,    ,1 ,22    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(8)      ,(59+$_PARITY)               ,"dir_rply_req_fifo_mem"    ,""    ,0    ,0    ,1            ,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;       	#,END2END       ,  ,    ,  ,    ,1 ,59    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(8)      ,(59+$_PARITY)               ,"ldb_rply_req_fifo_mem"    ,""    ,0    ,0    ,1            ,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;       	#,END2END       ,  ,    ,  ,    ,1 ,59    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(32)     ,(12+$_PARITY)               ,"sn_ordered_fifo_mem"      ,""    ,0    ,0    ,1*$ORD_ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;       	#,              ,  ,    ,  ,    ,1 ,12    , 
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(8)      ,(18+$_PARITY)               ,"lsp_reordercmp_fifo_mem"  ,""    ,0    ,0    ,1            ,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;       	#,END2END       ,  ,    ,  ,    ,1 ,18    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(4)      ,(20+$_PARITY)               ,"sn_complete_fifo_mem"     ,""    ,0    ,0    ,1            ,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;       	#,              ,  ,    ,  ,    ,1 ,20    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(16)     ,(10+$_RESIDUE)              ,"sn1_order_shft_mem"    ,""    ,0    ,0    ,1*$ORD_ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;       	#,              ,  ,    ,2 ,10  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(16)     ,(10+$_RESIDUE)              ,"sn0_order_shft_mem"    ,""    ,0    ,0    ,1*$ORD_ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;       	#,              ,  ,    ,2 ,10  ,  ,      ,
##printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(4)      ,(196)                       ,"rx_sync_chp_rop_hcw_mem"  ,""    ,0    ,0    ,1            ,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ; 	#,END2END       ,  ,    ,  ,    ,1 ,195     ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(2048)   ,(14+$_PARITY)               ,"reord_lbtp_mem"           ,""    ,0    ,0    ,1*$ORD_ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;            #,              ,  ,    ,  ,    ,1 ,14    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(2048)   ,(14+$_PARITY)               ,"reord_dirhp_mem"          ,""    ,0    ,0    ,1*$ORD_ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;            #,              ,  ,    ,  ,    ,1 ,14    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(2048)   ,(14+$_PARITY)               ,"reord_dirtp_mem"          ,""    ,0    ,0    ,1*$ORD_ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;            #,              ,  ,    ,  ,    ,1 ,14    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,(2048)   ,(5+$_RESIDUE+5+$_RESIDUE)    ,"reord_cnt_mem"            ,""    ,0    ,0    ,1*$ORD_ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;           #,END2END       ,  ,    ,4 ,10  ,  ,      ,
close OUTPUT;

##--------------------------------------------------
## sram RAM
# open OUTPUT, ">hqm_reorder_pipe_srw";
# close OUTPUT;

