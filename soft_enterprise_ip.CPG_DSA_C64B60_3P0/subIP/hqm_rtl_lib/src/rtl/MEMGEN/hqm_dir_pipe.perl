#!/usr/bin/perl 

##USAGE hqm_dir_pipe.perl <configs.pl case>

require "./configs.pl";
$SCALING_CASE = shift;
if ($SCALING_CASE eq "") {$CASE = "HQMv3"; } else {$CASE = $SCALING_CASE}
configs($CASE);

#TYPE,DEPTH,WIDTH,NAME,SUFFIX,ADDRPAD,DATAPAD,INSTANCES
$B2{"2"} = 1; $B2{"4"} = 2; $B2{"8"} = 3; $B2{"16"} = 4; $B2{"32"} = 5; $B2{"64"} = 6; $B2{"96"} = 7; $B2{"128"} = 7; $B2{"192"} = 8; $B2{"256"} = 8; $B2{"384"} = 9; $B2{"512"} = 9; $B2{"1024"} = 10; $B2{"2048"} = 11; $B2{"4096"} = 12; $B2{"5120"} = 13; $B2{"8192"} = 13; $B2{"16384"} = 14; $B2{"32768"} = 15; $B2{"65536"} = 16;
$_PARITY=1;
$_RESIDUE=2;
$_ECC6 = 6;

##these width do no scale, would require RTL update to change where to extract parity & reqidue

###### local depth parameters
$dCRD             = $TOTCRD;  $dCRDpad=$TOTCRDpad;
$dCQ              = $LBCQ;   $dCQpad=$LBCQpad;  ###NOTE: this is LB CQ
$dQID             = $DIRQID; $dQIDpad=$DIRQIDpad;
$dPRI             = $PRI/2;
$dQIDIX           = $QIDIX;
$dQIDPRI          = ($dQID*$dPRI); $dQIDPRIpad =  $B2{(128*8)} - $B2{($dQIDPRI)};
$dCQQIDIX         = ($dCQ*$dQIDIX); $dCQQIDIXpad = $B2{(64*8)} - $B2{($dCQQIDIX)};

$lQID             = $LBQID;  $lQIDpad=$LBQIDpad;
$lQIDPRI = ($lQID*$dPRI); $lQIDPRIpad =  $B2{(128*8)} - $B2{($lQIDPRI)};


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
open OUTPUT, ">hqm_dir_pipe_rfw";

printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dCQQIDIX)    ,(15+$_RESIDUE)                    ,"dir_rofrag_cnt"            ,"",$dCQQIDIXpad,0,1*$ORD_ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                          #,              ,   ,   ,2 ,15  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dCQQIDIX)    ,(14+$_PARITY)                     ,"dir_rofrag_tp"             ,"",$dCQQIDIXpad,0,1*$ORD_ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                          #,              ,   ,   ,  ,    ,1 ,14    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dCQQIDIX)    ,(14+$_PARITY)                     ,"dir_rofrag_hp"             ,"",$dCQQIDIXpad,0,1*$ORD_ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                          #,              ,   ,   ,  ,    ,1 ,14    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($lQID)        ,($dPRI*(15+$_RESIDUE))            ,"dir_replay_cnt"            ,"",$lQIDpad,0,1*$ORD_ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                              #,              ,   ,   ,8,60 ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)            ,(63+37)                           ,"rop_dp_enq_dir"            ,"",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                                 #,END2END       ,   ,   ,2 ,5   ,3 ,90  ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)            ,(63+37)                           ,"rop_dp_enq_ro"             ,"",0,0,1*$ORD_ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                     #,END2END       ,   ,   ,2 ,5   ,3 ,90  ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)            ,(8)                               ,"rx_sync_lsp_dp_sch_rorply" ,"",0,0,1*$ORD_ENABLE,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;                             #,END2END       ,   ,   ,  ,    ,1 ,7     ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)            ,(27)                              ,"rx_sync_lsp_dp_sch_dir"    ,"",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                         #,END2END       ,   ,   ,  ,    ,1 ,26    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)            ,(63+37)                           ,"rx_sync_rop_dp_enq"        ,"",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                         #,END2END       ,   ,   ,2 ,5   ,3 ,90  ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dQID)        ,($dPRI*(15+$_RESIDUE))            ,"dir_cnt"                   ,"",$dQIDpad,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                          #,              ,   ,   ,8,60 ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dQIDPRI)     ,(14+$_PARITY)                     ,"dir_tp"                    ,"",$dQIDPRIpad,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                       #,              ,   ,   ,  ,    ,1 ,14    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($dQIDPRI)     ,(14+$_PARITY)                     ,"dir_hp"                    ,"",$dQIDPRIpad,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                       #,              ,   ,   ,  ,    ,1 ,14    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(32)           ,(45+($_PARITY-1))                 ,"dp_dqed"                   ,"",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                                 #,END2END       ,   ,   ,  ,    ,1 ,44    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(16)           ,(8+($_PARITY-1))                  ,"dp_lsp_enq_dir"            ,"",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                                 #,END2END       ,   ,   ,  ,    ,1 ,7     ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(16)           ,(23+($_PARITY-1))                 ,"dp_lsp_enq_rorply"         ,"",0,0,1*$ORD_ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                     #,END2END       ,   ,   ,  ,    ,1 ,22    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($lQIDPRI)     ,(14+$_PARITY)                     ,"dir_replay_tp"             ,"",$lQIDPRIpad,0,1*$ORD_ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                           #,              ,   ,   ,  ,    ,1 ,14    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($lQIDPRI)     ,(14+$_PARITY)                     ,"dir_replay_hp"             ,"",$lQIDPRIpad,0,1*$ORD_ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                           #,              ,   ,   ,  ,    ,1 ,14    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)            ,(8+($_PARITY-1))                  ,"lsp_dp_sch_rorply"         ,"",0,0,1*$ORD_ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                     #,END2END       ,   ,   ,  ,    ,1 ,7     ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)            ,(27+($_PARITY-1))                 ,"lsp_dp_sch_dir"            ,"",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                                 #,END2END       ,   ,   ,  ,    ,1 ,26    ,

close OUTPUT;


open OUTPUT, ">hqm_dir_pipe_srw";
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"  ,($dCRD)        ,(14+$_PARITY+$_ECC6)                      ,"dir_nxthp"             ,"",$dCRDpad,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                       #,              ,6  ,14 ,  ,    ,1 ,    ,
close OUTPUT;


