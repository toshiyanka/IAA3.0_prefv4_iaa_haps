#!/usr/bin/perl 

##USAGE hqm_aqed_pipe.perl <configs.pl case>

require "./configs.pl";
$SCALING_CASE = shift;
if ($SCALING_CASE eq "") {$CASE = "HQMv3"; } else {$CASE = $SCALING_CASE}
configs($CASE);

#TYPE,DEPTH,WIDTH,NAME,SUFFIX,ADDRPAD,DATAPAD,INSTANCES
$B2{"2"} = 1; $B2{"4"} = 2; $B2{"8"} = 3; $B2{"16"} = 4; $B2{"32"} = 5; $B2{"64"} = 6; $B2{"128"} = 7; $B2{"192"} = 8; $B2{"256"} = 8; $B2{"384"} = 9; $B2{"512"} = 9; $B2{"1024"} = 10; $B2{"2048"} = 11; $B2{"4096"} = 12; $B2{"5120"} = 13; $B2{"8192"} = 13; $B2{"16384"} = 14; $B2{"32768"} = 15; $B2{"65536"} = 16;
$_PARITY=1;
$_RESIDUE=2;
$_ECC8=8;
$_ECC7=7;
$_ECC5=5;
$_BCAM=1;

##these width do no scale, would require RTL update to change where to extract parity & reqidue

###### local depth parameters
$ENABLE = $ATM_ENABLE;
if ($PRI == 8) { $PRI0=1; $PRI1=1; $PRI2=1; $PRI3=1; $PRI4=1; $PRI5=1; $PRI6=1; $PRI7=1; }
if ($PRI == 4) { $PRI0=1; $PRI1=1; $PRI2=1; $PRI3=1; $PRI4=0; $PRI5=0; $PRI6=0; $PRI7=0; }
$dCRD = $ATMCRD; $dCRDpad=$ATMCRDpad;
$dQID = $LBQID; $dQIDpad=$LBQIDpad;
$dFID = $FID; $dFIDpad=$FIDpad;  

$BCAMApad=0; $BCADpad=0; ## depends on HOW BCAM is constructed, support only 2k NOW




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
open OUTPUT, ">hqm_aqed_pipe_bcw";
                                                                                                                                                                                      #,END2END       , _ECC  , _RES  , _PARITY , _BCAM
                                                                                                                                                                                      #----------------------------------------

printf OUTPUT "bcam,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,($dFID)        ,(24+$_BCAM+$_BCAM)                                ,"AW_bcam_2048x26"              ,"",$BCAMApad,$BCADpad,(8*$ENABLE),-1,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","",100 ; #,              ,  ,    ,  ,    ,  ,      ,2 ,24

close OUTPUT;

##--------------------------------------------------
## regfile RAM
open OUTPUT, ">hqm_aqed_pipe_rfw";

printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dFID)        ,(11+$_PARITY)                                     ,"aqed_ll_qe_tp_pri1"           ,"",$dFIDpad,0,$PRI1*$ENABLE, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;       #,              ,  ,    ,  ,    ,1 ,11    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dFID)        ,(11+$_PARITY)                                     ,"aqed_ll_qe_tp_pri3"           ,"",$dFIDpad,0,$PRI3*$ENABLE, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;       #,              ,  ,    ,  ,    ,1 ,11    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dFID)        ,(11+$_PARITY)                                     ,"aqed_ll_qe_tp_pri2"           ,"",$dFIDpad,0,$PRI2*$ENABLE, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;       #,              ,  ,    ,  ,    ,1 ,11    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dFID)        ,(11+$_PARITY)                                     ,"aqed_ll_qe_hp_pri3"           ,"",$dFIDpad,0,$PRI3*$ENABLE, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;       #,              ,  ,    ,  ,    ,1 ,11    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dFID)        ,(11+$_PARITY)                                     ,"aqed_ll_qe_hp_pri2"           ,"",$dFIDpad,0,$PRI2*$ENABLE, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;       #,              ,  ,    ,  ,    ,1 ,11    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dFID)        ,(11+$_PARITY)                                     ,"aqed_ll_qe_hp_pri1"           ,"",$dFIDpad,0,$PRI1*$ENABLE, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;       #,              ,  ,    ,  ,    ,1 ,11    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dFID)        ,(11+$_PARITY)                                     ,"aqed_ll_qe_hp_pri0"           ,"",$dFIDpad,0,$PRI0*$ENABLE, 1,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;       #,              ,  ,    ,  ,    ,1 ,11    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dFID)        ,(12+$_RESIDUE)                                    ,"aqed_ll_cnt_pri1"             ,"",$dFIDpad,0,$PRI1*$ENABLE, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;       #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dFID)        ,(12+$_RESIDUE)                                    ,"aqed_ll_cnt_pri0"             ,"",$dFIDpad,0,$PRI0*$ENABLE, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;       #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dFID)        ,(12+$_RESIDUE)                                    ,"aqed_ll_cnt_pri2"             ,"",$dFIDpad,0,$PRI2*$ENABLE, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;       #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dFID)        ,(12+$_RESIDUE)                                    ,"aqed_ll_cnt_pri3"             ,"",$dFIDpad,0,$PRI3*$ENABLE, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;       #,              ,  ,    ,2 ,12  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dFID)        ,(13+$_RESIDUE)                                    ,"aqed_fid_cnt"                 ,"",$dFIDpad,0,1*$ENABLE, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;           #,              ,  ,    ,2 ,13  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dFID)        ,(11+$_PARITY)                                     ,"aqed_ll_qe_tp_pri0"           ,"",$dFIDpad,0,$PRI0*$ENABLE, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",2,"hqm_clk","pg",100 ;       #,              ,  ,    ,  ,    ,1 ,11    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,(4)            ,(123 + 16 + ($_ECC8-8)+($_ECC8-8))                ,"rx_sync_qed_aqed_enq"         ,"",0,0,1*$ENABLE,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;    #,END2END       ,16,123 ,  ,    ,  ,      , 
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,($dQID)        ,(13+$_RESIDUE)                                    ,"aqed_qid_cnt"                 ,"",$dQIDpad,0,1*$ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,              ,  ,    ,2 ,13  ,  ,      ,
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"  ,($dQID)        ,(13+$_PARITY)                                     ,"aqed_qid_fid_limit"           ,"",$dQIDpad,0,1*$ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,              ,  ,    ,  ,    ,1 ,13    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,(16)           ,(32)                                              ,"aqed_fifo_freelist_return"    ,"",0,0,1*$ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                  #,              ,  ,    ,  ,    ,2 ,30    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,(16)           ,(35)                                              ,"aqed_fifo_lsp_aqed_cmp"       ,"",0,0,1*$ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                  #,              ,  ,    ,  ,    ,1 ,34    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,(16)           ,(45+($_PARITY-1))                                 ,"aqed_fifo_ap_aqed"            ,"",0,0,1*$ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                  #,END2END       ,  ,    ,  ,    ,2 ,43    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,(16)           ,(24+($_PARITY-1))                                 ,"aqed_fifo_aqed_ap_enq"        ,"",0,0,1*$ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                  #,END2END       ,  ,    ,  ,    ,1 ,23    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,(4)            ,(123 + 16 + $_ECC8+$_ECC8)          ,"aqed_fifo_qed_aqed_enq"       ,"",0,0,1*$ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                #,END2END       ,16,123 ,  ,    ,1 ,15    , 
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,(8)            ,(123 + 14 + $_ECC8+$_ECC8)          ,"aqed_fifo_qed_aqed_enq_fid"   ,"",0,0,1*$ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                #,END2END       ,16,123 ,  ,    ,1 ,13    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"     ,(16)           ,(123 + 41 + $_ECC8+$_ECC8)          ,"aqed_fifo_aqed_chp_sch"       ,"",0,0,1*$ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                #,END2END       ,16,123 ,  ,    ,1 ,40    ,

close OUTPUT;


##aqed_fifo_qed_aqed_enq, aqed_fifo_qed_aqed_enq_fid,  fid extracted from HCW and stored in FIFOs


##--------------------------------------------------
## sram RAM
open OUTPUT, ">hqm_aqed_pipe_srw";
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,($dCRD)        ,(123+$_ECC8+$_ECC8)       ,"aqed"                         ,"",$dCRDpad,0,1*$ENABLE, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                 #,END2END       ,16,123 ,  ,    ,  ,      ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,($dCRD)        ,(11+$_ECC5)               ,"aqed_freelist"                ,"",$dCRDpad,0,1*$ENABLE, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                 #,END2END       ,5 ,11  ,  ,    ,  ,      ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"   ,($dCRD)        ,(11+$_ECC5)               ,"aqed_ll_qe_hpnxt"             ,"",$dCRDpad,0,1*$ENABLE, 0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                 #,END2END       ,5 ,11  ,  ,    ,  ,      ,
close OUTPUT;


