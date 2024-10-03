#!/usr/bin/perl 

##USAGE hqm_credit_hist_pipe.perl <configs.pl case>

require "./configs.pl";
$SCALING_CASE = shift;
if ($SCALING_CASE eq "") {$CASE = "HQMv3"; } else {$CASE = $SCALING_CASE}
configs($CASE);

$_PARITY=1;
$_RESIDUE=2;
$_ECC8=8;

#TYPE,DEPTH,WIDTH,NAME,SUFFIX,ADDRPAD,DATAPAD,INSTANCES
$B2{"2"} = 1; $B2{"4"} = 2; $B2{"8"} = 3; $B2{"16"} = 4; $B2{"32"} = 5; $B2{"64"} = 6; $B2{"128"} = 7; $B2{"192"} = 8; $B2{"256"} = 8; $B2{"384"} = 9; $B2{"512"} = 9; $B2{"1024"} = 10;  $B2{"1536"} = 11; $B2{"2048"} = 11; $B2{"4096"} = 12; $B2{"5120"} = 13; $B2{"8192"} = 13; $B2{"16384"} = 14; $B2{"32768"} = 15; $B2{"65536"} = 16;
$_PARITY=1;
$_RESIDUE=2;
$_ECC7=7;
$_ECC6=6;
$_ECC5=5;
$_ECC8=8;
$_BCAM=1;

##these width do no scale, would require RTL update to change where to extract parity & reqidue

###### local depth parameters
$DIRLDBCQ = $DIRCQ + $LBCQ; $DIRLDBCQpad = $B2{192}-$B2{$DIRLDBCQ};

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
open OUTPUT, ">hqm_credit_hist_pipe_rfw";



                                                                                                                      #,END2END       , _ECC  , _RES  , _PARITY , _BCAM
                                                                                                                      #------------------------------------------------

##delete
$VAS=32;


printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",(8),(200),"chp_sys_tx_fifo_mem","",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                           #,              ,  ,    ,  ,    ,4 ,196    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",(16),(201),"chp_chp_rop_hcw_fifo_mem","",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                      #,              ,16,123 ,  ,    ,4 ,58    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",(8),(177),"qed_chp_sch_rx_sync_mem","",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                    #,              ,16,123 ,   ,   ,3 ,35    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",(4),(26),"qed_chp_sch_flid_ret_rx_sync_mem","",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                    #,              ,  ,    ,   ,   ,1 ,15 ,,   ,10,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",(4),(179),"aqed_chp_sch_rx_sync_mem","",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                   #,              ,16,123 ,   ,   ,3 ,37    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",(16),(160),"hcw_enq_w_rx_sync_mem","",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                    #,              ,  ,    ,   ,   ,3 ,157   ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",(8),(197),"qed_to_cq_fifo_mem","",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                         #,              ,16,123 ,  ,    ,3 ,35    ,,,0,20
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",(16),(160),"outbound_hcw_fifo_mem","",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                        #,              ,16,123 ,  ,    ,2 ,19     ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBQID),(12),"ord_qid_sn_map","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                            #,              ,  ,    ,  ,    ,2 ,10    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBQID),(12),"ord_qid_sn","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                                #,END2END       ,  ,    ,2 ,10  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",(16),(74),"chp_lsp_ap_cmp_fifo_mem","",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                       #,              ,  ,    ,  ,    ,3 ,71    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($DIRCQ),(6),"dir_cq_token_depth_select","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                  #,              ,  ,    ,  ,    ,2 ,4     ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBCQ),(32),"ldb_cq_on_off_threshold","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                                #,END2END       ,  ,    ,2 ,30  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBCQ),(2),"cmp_id_chk_enbl_mem","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                         #,              ,  ,    ,  ,    ,1 ,1      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBCQ),(6),"ldb_cq_token_depth_select","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                   #,              ,  ,    ,  ,    ,2 ,4     ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBCQ),(13),"ldb_cq_wptr","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                                #,END2END       ,  ,    ,2 ,11  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBCQ),(13),"ldb_cq_depth","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                               #,              ,  ,    ,2 ,11  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBCQ),(13+1+$_RESIDUE+13+1+$_RESIDUE),"hist_list_ptr","",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;            #,END2END       ,  ,    ,4 ,28  ,  ,      ,
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBCQ),(13+$_RESIDUE+13+$_RESIDUE),"hist_list_minmax","",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;          #,              ,  ,    ,4 ,26  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBCQ),(13+1+$_RESIDUE+13+1+$_RESIDUE),"hist_list_a_ptr","",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;            #,END2END       ,  ,    ,4 ,28  ,  ,      ,
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBCQ),(13+$_RESIDUE+13+$_RESIDUE),"hist_list_a_minmax","",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;          #,              ,  ,    ,4 ,26  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",(16),(29),"chp_lsp_tok_fifo_mem","",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                          #,              ,  ,    ,2 ,13  ,1 ,13    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($DIRCQ),(13),"dir_cq_depth","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                              #,              ,  ,    ,2 ,11  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($DIRCQ),(13),"dir_cq_wptr","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                               #,END2END       ,  ,    ,2 ,11  ,  ,      ,

##CIAL
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($DIRCQ),(15),"dir_cq_intr_thresh","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                        #,              ,  ,    ,  ,    ,1 ,14    ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBCQ),(13),"ldb_cq_intr_thresh","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                         #,              ,  ,    ,  ,    ,1 ,12    ,
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($DIRCQ),(14),"threshold_r_pipe_dir_mem","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                               #,              ,  ,    ,  ,    ,1  ,13      ,
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBCQ),(14),"threshold_r_pipe_ldb_mem","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                #,              ,  ,    ,  ,    ,1  ,13      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($DIRCQ),(16),"count_rmw_pipe_dir_mem","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                    #,              ,  ,    ,2 ,14  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBCQ),(16),"count_rmw_pipe_ldb_mem","",0,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                                     #,              ,  ,    ,2 ,14  ,  ,      ,

##WD & CQ occupancy RAMS
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($DIRCQ),(10),"count_rmw_pipe_wd_dir_mem","",0,0,1,0,0,"hqm_pgcb_clk","hqm_pgcb_rst_n","","",0,"pgcb_clk","pg",100 ;                                   #,              ,  ,    ,2  ,8  ,  ,      ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($LBCQ),(10),"count_rmw_pipe_wd_ldb_mem","",0,0,1,0,0,"hqm_pgcb_clk","hqm_pgcb_rst_n","","",0,"pgcb_clk","pg",100 ;                                    #,              ,  ,    ,2  ,8  ,  ,      ,

close OUTPUT;


##--------------------------------------------------
## sram RAM
open OUTPUT, ">hqm_credit_hist_pipe_srw";

printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($HIST)                  ,(35+$_ECC8+4+16+2+$_PARITY)        ,"hist_list"             ,"",$HISTpad  ,0,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,END2END       ,8 ,58  ,  ,    ,  ,      ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($HIST)                  ,(35+$_ECC8+4+16+2+$_PARITY)        ,"hist_list_a"           ,"",$HISTpad  ,0,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,END2END       ,8 ,58  ,  ,    ,  ,      ,


$NUM_CREDITS_PBANK = 2048,100 ;
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($NUM_CREDITS_PBANK)     ,(11+$_ECC5)                      ,"freelist_0"                ,"",0         ,0,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,              ,5 ,11  ,  ,    ,  ,      ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($NUM_CREDITS_PBANK)     ,(11+$_ECC5)                      ,"freelist_1"                ,"",0         ,0,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,              ,5 ,11  ,  ,    ,  ,      ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($NUM_CREDITS_PBANK)     ,(11+$_ECC5)                      ,"freelist_2"                ,"",0         ,0,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,              ,5 ,11  ,  ,    ,  ,      ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($NUM_CREDITS_PBANK)     ,(11+$_ECC5)                      ,"freelist_3"                ,"",0         ,0,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,              ,5 ,11  ,  ,    ,  ,      ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($NUM_CREDITS_PBANK)     ,(11+$_ECC5)                      ,"freelist_4"                ,"",0         ,0,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,              ,5 ,11  ,  ,    ,  ,      ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($NUM_CREDITS_PBANK)     ,(11+$_ECC5)                      ,"freelist_5"                ,"",0         ,0,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,              ,5 ,11  ,  ,    ,  ,      ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($NUM_CREDITS_PBANK)     ,(11+$_ECC5)                      ,"freelist_6"                ,"",0         ,0,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,              ,5 ,11  ,  ,    ,  ,      ,
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($NUM_CREDITS_PBANK)     ,(11+$_ECC5)                      ,"freelist_7"                ,"",0         ,0,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,              ,5 ,11  ,  ,    ,  ,      ,
close OUTPUT;


