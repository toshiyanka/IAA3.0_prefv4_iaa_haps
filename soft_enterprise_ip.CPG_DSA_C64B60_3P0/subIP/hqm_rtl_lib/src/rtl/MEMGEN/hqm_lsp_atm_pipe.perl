#!/usr/bin/perl 

##USAGE hqm_lsp_atm_pipe.perl <configs.pl case>

require "./configs.pl";
$SCALING_CASE = shift;
if ($SCALING_CASE eq "") {$CASE = "HQMv3"; } else {$CASE = $SCALING_CASE}
configs($CASE);

#TYPE,DEPTH,WIDTH,NAME,SUFFIX,ADDRPAD,DATAPAD,INSTANCES
$B2{"2"} = 1; $B2{"4"} = 2; $B2{"8"} = 3; $B2{"16"} = 4; $B2{"32"} = 5; $B2{"64"} = 6; $B2{"128"} = 7; $B2{"192"} = 8; $B2{"256"} = 8; $B2{"384"} = 9; $B2{"512"} = 9; $B2{"1024"} = 10; $B2{"2048"} = 11; $B2{"4096"} = 12; $B2{"5120"} = 13; $B2{"8192"} = 13; $B2{"16384"} = 14; $B2{"32768"} = 15; $B2{"65536"} = 16;
$_PARITY=1;
$_RESIDUE=2;

##these width do no scale, would require RTL update to change where to extract parity & reqidue
$wIF = 2048+1; $wIFB2P1 = 13; ##support 2048 inflight
$wFID = 4096; $wFIDB2 = 12; $wFIDpad = 1;
$wCRD = 2048; $wCRDB2P1 = 12;

###### local depth parameters
$ENABLE=$ATM_ENABLE;
$dQID = $LBQID; $dQIDpad=$LBQIDpad;
$dFID = $FID; $dFIDpad=$FIDpad;
$dCQ = $LBCQ; $dCQpad=$LBCQpad;
$dQIDIX = $QIDIX; 

$QIDIX_PER_SLICE  = 32;        # Implementation detail independent of arch scaling
$CQ2QIDIX         = $LBCQ * $QIDIX;
$CQ2QIDIX_PARITY  = $CQ2QIDIX  / $QIDIX_PER_SLICE;
$CQ2QIDIX_PAD     =  ( ( 64 * 8 ) + ( 64 * 8 / $QIDIX_PER_SLICE ) ) - ($CQ2QIDIX + $CQ2QIDIX_PARITY);

                                                                                                                                                                                       #,END2END       , _ECC  , _RES  , _PARITY , _BCAM
                                                                                                                                                                                       #----------------------------------------
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
open OUTPUT, ">hqm_lsp_atm_pipe_rfw";



printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($dQID)        ,($CQ2QIDIX+$CQ2QIDIX_PARITY)  ,"aqed_qid2cqidix"        ,"",$dQIDpad,$CQ2QIDIX_PAD,1*$ENABLE, 3,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                 #,              ,  ,    ,  ,    ,16,512   , 
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(16)           ,(45+($_PARITY-1))            ,"atm_fifo_ap_aqed"       ,"",0,0,1*$ENABLE,1,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                                     #,END2END       ,  ,    ,  ,    ,1 ,44    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dCQ*$dQIDIX) ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_hp_bin3"      ,"",$dCQpas,0,1*$ENABLE*$BIN3,2,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                         #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dCQ*$dQIDIX) ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_tp_bin2"      ,"",$dCQpas,0,1*$ENABLE*$BIN2,2,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                         #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dCQ*$dQIDIX) ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_hp_bin1"      ,"",$dCQpas,0,1*$ENABLE*$BIN1,3,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                         #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dCQ*$dQIDIX) ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_tp_bin0"      ,"",$dCQpas,0,1*$ENABLE*$BIN0,2,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                         #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dCQ*$dQIDIX) ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_tp_bin3"      ,"",$dCQpas,0,1*$ENABLE*$BIN3,2,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                         #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dCQ*$dQIDIX) ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_hp_bin2"      ,"",$dCQpas,0,1*$ENABLE*$BIN2,2,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                         #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dCQ*$dQIDIX) ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_tp_bin1"      ,"",$dCQpas,0,1*$ENABLE*$BIN1,2,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                         #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dCQ*$dQIDIX) ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_hp_bin0"      ,"",$dCQpas,0,1*$ENABLE*$BIN0,3,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                         #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_hpnxt_bin3"   ,"",$dFIDpad,0,1*$ENABLE*$BIN3, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_hpnxt_bin2"   ,"",$dFIDpad,0,1*$ENABLE*$BIN2, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_hpnxt_bin1"   ,"",$dFIDpad,0,1*$ENABLE*$BIN1, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_hpnxt_bin0"   ,"",$dFIDpad,0,1*$ENABLE*$BIN0, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_tpprv_bin0"   ,"",$dFIDpad,0,1*$ENABLE*$BIN0, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_tpprv_bin1"   ,"",$dFIDpad,0,1*$ENABLE*$BIN1, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_tpprv_bin2"   ,"",$dFIDpad,0,1*$ENABLE*$BIN2, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_schlst_tpprv_bin3"   ,"",$dFIDpad,0,1*$ENABLE*$BIN3, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wIFB2P1+$_RESIDUE)          ,"ll_sch_cnt_dup2"        ,"",$dFIDpad,0,1*$ENABLE, 3,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                             #,              ,  ,    ,2 ,13  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wIFB2P1+$_RESIDUE)          ,"ll_sch_cnt_dup3"        ,"",$dFIDpad,0,1*$ENABLE, 3,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                             #,              ,  ,    ,2 ,13  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dCQ*$dQIDIX) ,($BIN*($wCRDB2P1+$_RESIDUE)) ,"ll_slst_cnt"            ,"",$dCQpad,0,1*$ENABLE, 2,0,"hqm_gated_clk","hqm_gated_rst_n","","",4,"hqm_clk","pg",100 ;                                               #,              ,  ,    ,8 ,48  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(32)           ,(24+($_PARITY-1))            ,"atm_fifo_aqed_ap_enq"   ,"",0,0,1*$ENABLE,1,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                                     #,END2END       ,  ,    ,  ,    ,2 ,22    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dQID)        ,(5+$_PARITY)                  ,"qid_rdylst_clamp"       ,"",$dQIDpad,0,1*$ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                             #,              ,  ,    ,  ,    ,1 ,5     ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dQID)        ,($BIN*($wCRDB2P1+$_RESIDUE)) ,"ll_rlst_cnt"            ,"",$dQIDpad,0,1*$ENABLE,1,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                              #,              ,  ,    ,8 ,48  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dQID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_rdylst_hp_bin2"      ,"",$dQIDpad,0,1*$ENABLE*$BIN2,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dQID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_rdylst_hp_bin1"      ,"",$dQIDpad,0,1*$ENABLE*$BIN1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dQID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_rdylst_tp_bin1"      ,"",$dQIDpad,0,1*$ENABLE*$BIN1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dQID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_rdylst_hp_bin0"      ,"",$dQIDpad,0,1*$ENABLE*$BIN0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dQID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_rdylst_tp_bin0"      ,"",$dQIDpad,0,1*$ENABLE*$BIN0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dQID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_rdylst_tp_bin3"      ,"",$dQIDpad,0,1*$ENABLE*$BIN3,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dQID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_rdylst_tp_bin2"      ,"",$dQIDpad,0,1*$ENABLE*$BIN2,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dQID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_rdylst_hp_bin3"      ,"",$dQIDpad,0,1*$ENABLE*$BIN3,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wIFB2P1+$_RESIDUE)          ,"ll_sch_cnt_dup1"        ,"",$dFIDpad,0,1*$ENABLE, 3,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                             #,              ,  ,    ,2 ,13  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wIFB2P1+$_RESIDUE)          ,"ll_sch_cnt_dup0"        ,"",$dFIDpad,0,1*$ENABLE, 3,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                             #,              ,  ,    ,2 ,13  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_rdylst_hpnxt_bin3"   ,"",$dFIDpad,0,1*$ENABLE*$BIN3, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_rdylst_hpnxt_bin2"   ,"",$dFIDpad,0,1*$ENABLE*$BIN2, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_rdylst_hpnxt_bin1"   ,"",$dFIDpad,0,1*$ENABLE*$BIN1, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wFIDB2+$_PARITY+$_PARITY)  ,"ll_rdylst_hpnxt_bin0"   ,"",$dFIDpad,0,1*$ENABLE*$BIN0, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,INTERLEAVE    ,  ,    ,  ,    ,2 ,12    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin0_dup0" ,"",$dFIDpad,0,1*$ENABLE*$BIN0, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin0_dup1" ,"",$dFIDpad,0,1*$ENABLE*$BIN0, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin0_dup2" ,"",$dFIDpad,0,1*$ENABLE*$BIN0, 2,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin0_dup3" ,"",$dFIDpad,0,1*$ENABLE*$BIN0, 2,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_s_bin0"      ,"",$dFIDpad,0,1*$ENABLE*$BIN0, 3,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin1_dup0" ,"",$dFIDpad,0,1*$ENABLE*$BIN1, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin1_dup1" ,"",$dFIDpad,0,1*$ENABLE*$BIN1, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin1_dup2" ,"",$dFIDpad,0,1*$ENABLE*$BIN1, 2,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin1_dup3" ,"",$dFIDpad,0,1*$ENABLE*$BIN1, 2,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_s_bin1"      ,"",$dFIDpad,0,1*$ENABLE*$BIN1, 3,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin2_dup0" ,"",$dFIDpad,0,1*$ENABLE*$BIN2, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin2_dup1" ,"",$dFIDpad,0,1*$ENABLE*$BIN2, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin2_dup2" ,"",$dFIDpad,0,1*$ENABLE*$BIN2, 2,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin2_dup3" ,"",$dFIDpad,0,1*$ENABLE*$BIN2, 2,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_s_bin2"      ,"",$dFIDpad,0,1*$ENABLE*$BIN2, 3,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_s_bin3"      ,"",$dFIDpad,0,1*$ENABLE*$BIN3, 3,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin3_dup3" ,"",$dFIDpad,0,1*$ENABLE*$BIN3, 2,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin3_dup2" ,"",$dFIDpad,0,1*$ENABLE*$BIN3, 2,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin3_dup1" ,"",$dFIDpad,0,1*$ENABLE*$BIN3, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,(9+$_PARITY)                  ,"fid2cqqidix"            ,"",$dFIDpad,0,1*$ENABLE, 3,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                             #,              ,  ,    ,  ,    ,1 ,9     ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dFID)        ,($wCRDB2P1+$_RESIDUE)        ,"ll_enq_cnt_r_bin3_dup0" ,"",$dFIDpad,0,1*$ENABLE*$BIN3, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,2 ,12  ,  ,      ,

close OUTPUT;


#open OUTPUT, ">hqm_lsp_atm_pipe_srw";
#close OUTPUT;

