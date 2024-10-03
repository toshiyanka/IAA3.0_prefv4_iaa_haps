#!/usr/bin/perl 

##USAGE hqm_qed_pipe.perl <configs.pl case>

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

##these width do no scale, would require RTL update to change where to extract parity & reqidue

###### local depth parameters
$CRD = $TOTCRD;       



                                                                                                                                                                                      #,END2END       , _ECC  , _RES  , _PARITY , _BCAM
                                                                                                                                                                                      #----------------------------------------
################################################################
# Format of mem info fields in perl output files expected by mem_access.perl is:
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
open OUTPUT, ">hqm_qed_pipe_rfw";

printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)            ,(45)                                          ,"rx_sync_nalb_qed_data"      ,"",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;                #,END2END       ,  ,    ,  ,    ,3 ,42    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)            ,(45)                                          ,"rx_sync_dp_dqed_data"       ,"",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;                #,END2END       ,  ,    ,  ,    ,3 ,42    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)            ,(157)                                         ,"rx_sync_rop_qed_dqed_enq"   ,"",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;                #,END2END       ,16,123 ,  ,    ,1 ,17    ,

printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(8)            ,(123 + 54 +($_PARITY-1)+($_ECC8-8)+($_ECC8-8))      ,"qed_chp_sch_data"           ,"",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                  #,END2END       ,16,123 ,  ,    ,1 ,37    ,





close OUTPUT;

##--------------------------------------------------
## sram RAM
open OUTPUT, ">hqm_qed_pipe_srw";
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($CRD/8)       ,(123+$_ECC8+$_ECC8)                       ,"qed_0"                ,"",0,0,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                   #,END2END       ,16,123 ,  ,    ,         ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($CRD/8)       ,(123+$_ECC8+$_ECC8)                       ,"qed_1"                ,"",0,0,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                   #,END2END       ,16,123 ,  ,    ,         ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($CRD/8)       ,(123+$_ECC8+$_ECC8)                       ,"qed_2"                ,"",0,0,1, 1,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                   #,END2END       ,16,123 ,  ,    ,         ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($CRD/8)       ,(123+$_ECC8+$_ECC8)                       ,"qed_3"                ,"",0,0,1, 1,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                   #,END2END       ,16,123 ,  ,    ,         ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($CRD/8)       ,(123+$_ECC8+$_ECC8)                       ,"qed_4"                ,"",0,0,1, 2,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                   #,END2END       ,16,123 ,  ,    ,         ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($CRD/8)       ,(123+$_ECC8+$_ECC8)                       ,"qed_5"                ,"",0,0,1, 2,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                   #,END2END       ,16,123 ,  ,    ,         ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($CRD/8)       ,(123+$_ECC8+$_ECC8)                       ,"qed_6"                ,"",0,0,1, 3,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                   #,END2END       ,16,123 ,  ,    ,         ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($CRD/8)       ,(123+$_ECC8+$_ECC8)                       ,"qed_7"                ,"",0,0,1, 3,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                   #,END2END       ,16,123 ,  ,    ,         ,

close OUTPUT;

