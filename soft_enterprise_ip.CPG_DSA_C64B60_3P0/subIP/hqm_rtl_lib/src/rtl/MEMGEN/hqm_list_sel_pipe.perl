#!/usr/bin/perl 

##USAGE hqm_list_sel_pipe.perl <configs.pl case>

require "./configs.pl";
$SCALING_CASE = shift;
if ($SCALING_CASE eq "") {$CASE = "HQMv3"; } else {$CASE = $SCALING_CASE}
configs($CASE);

#TYPE,DEPTH,WIDTH,NAME,SUFFIX,ADDRPAD,DATAPAD,INSTANCES
$B2{"2"} = 1; $B2{"4"} = 2; $B2{"8"} = 3; $B2{"16"} = 4; $B2{"32"} = 5; $B2{"64"} = 6; $B2{"128"} = 7; $B2{"192"} = 8; $B2{"256"} = 8; $B2{"384"} = 9; $B2{"512"} = 9; $B2{"1024"} = 10; $B2{"2048"} = 11; $B2{"4096"} = 12; $B2{"5120"} = 13; $B2{"8192"} = 13; $B2{"16384"} = 14; $B2{"32768"} = 15; $B2{"65536"} = 16;
$_PARITY=1;
$_RESIDUE=2;
$_ECC8=8;

##these width do no scale, would require RTL update to change where to extract parity & reqidue


###### local depth parameters
$LBPCQ            = $LBCQ / 2 ;         # "paired" CQ
$QIDIX_PER_SLICE  = 32;        # Implementation detail independent of arch scaling
$CQ2QIDIX         = $LBCQ * $QIDIX;
$CQ2QIDIX_PARITY  = $CQ2QIDIX  / $QIDIX_PER_SLICE;
$CQ2QIDIX_PAD     =  ( ( 64 * 8 ) + ( 64 * 8 / $QIDIX_PER_SLICE ) ) - ($CQ2QIDIX + $CQ2QIDIX_PARITY);


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
open OUTPUT, ">hqm_list_sel_pipe_rfw";

# ,END2END       , _ECC  , _RES  , _PARITY , IGNORE , UNPROTECTED
# max_depth memories are for diagnostics only and have no coverage
# pri_arbindex has no coverage, only impact of a failure is a one-time, possibly unfair LDB scheduling arbiter selection

# qid2cqidix memories each consist of multiple physical memories
# cq2priov and cq2qid_* were modified after v25 to support paired CQ mode, requiring 16 QID's worth of info read out in a single clock
#   - config interface must appear the same to SW as before
#   - memory aspect ratio changed to make half as deep and 2x wide
#   - sidecar cfg access does not support > 32 bits
#   - cfg acceses are done by intercepting the sidecar and hijacking the func intf, which is the full (2x) width
#   - in this file pretend only the "even" half is cfg accessible, that name "hits" with the regs spreadsheet
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBQID)   ,($CQ2QIDIX+$CQ2QIDIX_PARITY)  ,"cfg_qid_ldb_qid2cqidix2_mem" ,"",$LBQIDpad,$CQ2QIDIX_PAD,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;        #,END2END       , ,     , ,     ,16,512
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBQID)   ,($CQ2QIDIX+$CQ2QIDIX_PARITY)  ,"cfg_qid_ldb_qid2cqidix_mem"  ,"",$LBQIDpad,$CQ2QIDIX_PAD,1, 0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;        #,END2END       , ,     , ,     ,16,512
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBQID)   ,($_PARITY+12)           ,"cfg_qid_aqed_active_limit_mem"     ,"",$LBQIDpad,0,1*$ATM_ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;#,END2END       , ,     , ,     ,1,12
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBQID)   ,($_RESIDUE+15)          ,"qid_atq_enqueue_count_mem"         ,"",$LBQIDpad,0,1*$ATM_ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;#,END2END       , ,     ,2,15   , ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBQID)   ,($_RESIDUE+12)          ,"qid_aqed_active_count_mem"         ,"",$LBQIDpad,0,1*$ATM_ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;#,END2END       , ,     ,2,12   , ,
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($DIRQID)  ,($_PARITY+15)           ,"cfg_dir_qid_dpth_thrsh_mem"        ,"",$DIRQIDpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;              #,              , ,     , ,     ,1,15
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBCQ)    ,($_PARITY+13)           ,"cfg_cq_ldb_inflight_limit_mem"     ,"",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     , ,     ,1,13
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBCQ)    ,($_PARITY+13)           ,"cfg_cq_ldb_inflight_threshold_mem" ,"",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     , ,     ,1,13
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBPCQ)   ,($_PARITY+32)           ,"cfg_cq2priov_mem"                  ,"",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     , ,     ,1,32
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBPCQ)   ,($_PARITY+32)           ,"cfg_cq2priov_odd_mem"              ,"",$LBCQpad,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     , ,     ,1,32
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBPCQ)   ,($_PARITY+28)           ,"cfg_cq2qid_1_mem"                  ,"",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     , ,     ,1,28
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBPCQ)   ,($_PARITY+28)           ,"cfg_cq2qid_1_odd_mem"              ,"",$LBCQpad,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     , ,     ,1,28
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBPCQ)   ,($_PARITY+28)           ,"cfg_cq2qid_0_mem"                  ,"",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     , ,     ,1,28
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBPCQ)   ,($_PARITY+28)           ,"cfg_cq2qid_0_odd_mem"              ,"",$LBCQpad,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     , ,     ,1,28
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBQID)   ,($_PARITY+15)           ,"cfg_nalb_qid_dpth_thrsh_mem"       ,"",$LBQIDpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;               #,              , ,     , ,     ,1,15
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBQID)   ,($_PARITY+15)           ,"cfg_atm_qid_dpth_thrsh_mem"        ,"",$LBQIDpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;               #,              , ,     , ,     ,1,15
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBCQ)    ,($_RESIDUE+13)          ,"cq_ldb_inflight_count_mem"         ,"",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     ,2,13   , ,
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBQID)   ,($_PARITY+12)           ,"cfg_qid_ldb_inflight_limit_mem"    ,"",$LBQIDpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;            #,END2END       , ,     , ,     ,1,12
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBQID)   ,($_RESIDUE+12)          ,"qid_ldb_inflight_count_mem"        ,"",$LBQIDpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;            #,END2END       , ,     ,2,12   , ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBQID)   ,($_RESIDUE+15)          ,"qid_dir_replay_count_mem"          ,"",$LBQIDpad,0,1*$ORD_ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;#,END2END    , ,     ,2,15   , ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($DIRQID)  ,(15)                    ,"qid_dir_max_depth_mem"             ,"",$DIRQIDpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,IGNORE        , ,     , ,     , , , , ,15,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)        ,($_PARITY+9)             ,"nalb_lsp_enq_lb_rx_sync_fifo_mem"      ,"",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;               #,END2END       , ,     , ,     ,1,9
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)        ,($_PARITY+7)             ,"dp_lsp_enq_dir_rx_sync_fifo_mem"       ,"",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;               #,END2END       , ,     , ,     ,1,7
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)        ,($_PARITY+$_RESIDUE+20)  ,"dp_lsp_enq_rorply_rx_sync_fifo_mem"    ,"",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;               #,END2END       , ,     ,2,13   ,1,7
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(16)       ,($_PARITY+$_PARITY+25)  ,"nalb_sel_nalb_fifo_mem"            ,"",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                    #,END2END       , ,     , ,     ,2,25
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)        ,($_PARITY+$_RESIDUE+24)  ,"nalb_lsp_enq_rorply_rx_sync_fifo_mem"  ,"",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;               #,END2END       , ,     ,2,15   ,1,9
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)        ,($_PARITY+$_PARITY+33)   ,"send_atm_to_cq_rx_sync_fifo_mem"       ,"",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;               #,END2END       , ,     , ,     ,2,33
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBCQ)    ,($_RESIDUE+64)          ,"cq_ldb_tot_sch_cnt_mem"            ,"",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     ,2,64   , ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($DIRCQ)   ,($_RESIDUE+64)          ,"cq_dir_tot_sch_cnt_mem"            ,"",$DIRCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;            #,END2END       , ,     ,2,64   , ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($DIRQID)  ,($_RESIDUE+64)          ,"qid_dir_tot_enq_cnt_mem"           ,"",$DIRQIDpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,END2END       , ,     ,2,64   , ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBQID)   ,($_RESIDUE+64)          ,"qid_naldb_tot_enq_cnt_mem"         ,"",$LBQIDpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;              #,END2END       , ,     ,2,64   , ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBQID)   ,($_RESIDUE+64)          ,"qid_atm_tot_enq_cnt_mem"           ,"",$LBQIDpad,0,1*$ATM_ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;#,END2END       , ,     ,2,64   , ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBCQ)    ,($_RESIDUE+11)          ,"cq_ldb_token_count_mem"            ,"",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     ,2,11   , ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(8)        ,($_PARITY+17)           ,"nalb_cmp_fifo_mem"                 ,"",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                    #,END2END       , ,     , ,     ,1,17
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)        ,($_PARITY+9)            ,"enq_nalb_fifo_mem"                 ,"",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                    #,END2END       , ,     , ,     ,1,9
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($DIRQID)  ,($_RESIDUE+15)          ,"dir_enq_cnt_mem"                   ,"",$DIRQIDpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;           #,END2END       , ,     ,2,15   , ,
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($DIRCQ)   ,($_PARITY+7)            ,"dir_tok_lim_mem"                   ,"",$DIRCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;            #,END2END       , ,     , ,     ,1,7
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBQID)   ,($_RESIDUE+15)          ,"qid_ldb_replay_count_mem"          ,"",$LBQIDpad,0,1*$ORD_ENABLE,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;#,END2END       , ,     ,2,15   , ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBQID)   ,($_RESIDUE+15)          ,"qid_atm_active_mem"                ,"",$LBQIDpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;               #,              , ,     ,2,15   , ,
printf OUTPUT "rf_rw,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n" ,($LBCQ)    ,($_PARITY+4)            ,"cfg_cq_ldb_token_depth_select_mem" ,"",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     , ,     ,1,4
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBQID)   ,(15)                    ,"qid_naldb_max_depth_mem"           ,"",$LBQIDpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;            #,IGNORE        , ,     , ,     , , , , ,15,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBQID)   ,($_RESIDUE+15)          ,"qid_ldb_enqueue_count_mem"         ,"",$LBQIDpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;            #,END2END       , ,     ,2,15   , ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBPCQ)   ,(96)                    ,"cq_nalb_pri_arbindex_mem"          ,"",$LBCQpad,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,IGNORE        , ,     , ,     , , , , , 48 ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBPCQ)   ,(96)                    ,"cq_atm_pri_arbindex_mem"           ,"",$LBCQpad,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,IGNORE        , ,     , ,     , , , , , 48 ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($DIRCQ)   ,($_RESIDUE+11)          ,"dir_tok_cnt_mem"                   ,"",$DIRCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;            #,END2END       , ,     ,2,11   , ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(8)        ,($_PARITY+19)           ,"uno_atm_cmp_fifo_mem"              ,"",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                    #,END2END       , ,     , ,     ,1,19
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(8)        ,($_PARITY+16)            ,"rop_lsp_reordercmp_rx_sync_fifo_mem"   ,"",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;               #,END2END       , ,     , ,     ,1,16
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(8)        ,($_PARITY+$_PARITY+$_PARITY+$_PARITY+51) ,"atm_cmp_fifo_mem" ,"",0,0,1*$ATM_ENABLE,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;        #,END2END       , ,     , ,     ,4,51
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(8)        ,($_PARITY+$_RESIDUE+22) ,"ldb_token_rtn_fifo_mem"            ,"",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                    #,END2END       , ,     ,2,13   ,1,9
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)        ,($_PARITY+$_RESIDUE+22) ,"chp_lsp_token_rx_sync_fifo_mem"         ,"",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;               #,END2END       , ,     ,2,13   ,1,9
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(4)        ,($_PARITY+$_PARITY+$_PARITY+70) ,"chp_lsp_cmp_rx_sync_fifo_mem"   ,"",0,0,1,0,0,"hqm_inp_gated_clk","hqm_inp_gated_rst_n","","",0,"hqm_clk","pg",100 ;               #,END2END       , ,     , ,     ,3,70
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(24)       ,($_PARITY+8)            ,"qed_lsp_deq_fifo_mem"              ,"",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                    #,END2END       , ,     , ,     ,1,8
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,(24)       ,($_PARITY+8)            ,"aqed_lsp_deq_fifo_mem"             ,"",0,0,1,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;                    #,END2END       , ,     , ,     ,1,8
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBCQ)    ,($_RESIDUE+17)          ,"cq_ldb_wu_count_mem"               ,"",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     ,2,17   , ,
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n"    ,($LBCQ)    ,($_PARITY+16)           ,"cfg_cq_ldb_wu_limit_mem"           ,"",$LBCQpad,0,1,0,1,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;             #,END2END       , ,     , ,     ,1,16



close OUTPUT;

##--------------------------------------------------
## sram RAM
# open OUTPUT, ">hqm_list_sel_pipe_srw";
# close OUTPUT;

