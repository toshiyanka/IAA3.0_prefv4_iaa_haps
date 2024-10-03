#!/usr/bin/perl 

##USAGE hqm_system.perl <case>

$SCALING_CASE = shift;
$DM_INCLUDE = shift;
if ($SCALING_CASE eq "") {$CASE = "HQMv3"; } else {$CASE = $SCALING_CASE}
$DM = 0;

#                  A   B   C   D   E   F
# VFs             16  16  16  16  64  64
# VAS             32  32  32  32  128 128
# DIR Ports/QIDs  128 64  64  64  64  32
# LB Ports        64  32  32  16  64  32
# LB QIDs         64  64  64  32  64  32

#Case                A   B   C   D   E HQM   Z HQMV2
#VFs                16  16  16  16  16  16  16    16
#VAS                32  32  32  32  32  32  32    32
#DIR Ports/QIDs    128  64  64  64  64 128 128    64
#LB Ports           64  32  32  16  16  64  64    64
#LB QIDs            64  64  64  32  32 128 128    64

$NUM_VF   =  16;
$NUM_VAS  =  32;
$DIR_PP   = 128;
$LDB_PP   =  64;
$DIR_CQ   = 128;
$LDB_CQ   =  64;
$DIR_QID  = 128;
$LDB_QID  = 128;

require "./configs.pl";
configs($CASE);

 $NUM_VF   =  $VF;
 $NUM_VAS  =  $VAS;
 $DIR_PP   =  $DIRCQ ;
 $LDB_PP   =  $LBCQ ;
 $DIR_CQ   =  $DIRCQ ;
 $LDB_CQ   =  $LBCQ ;
 $DIR_QID  =  $DIRQID ;
 $LDB_QID  =  $LBQID ;

printf "\nGenerating for CASE=%s %s DM: VF=%d VAS=%d DIR(PP=%d QID=%d) LDB(PP=%d QID=%d)\n",
$CASE,(($DM)?"w/":"w/o"),$NUM_VF,$NUM_VAS,$DIR_PP,$DIR_QID,$LDB_PP,$LDB_QID;

$B2{1}=1; for ($i=1;$i<=16;$i++) {$B2{2**$i}=$i;}

$NUM_VFb2   = $B2{$NUM_VF};
$NUM_VASb2  = $B2{$NUM_VAS};
$DIR_PPb2   = $B2{$DIR_PP};   
$LDB_PPb2   = $B2{$LDB_PP};   
$DIR_CQb2   = $B2{$DIR_CQ};   
$LDB_CQb2   = $B2{$LDB_CQ};   
$DIR_QIDb2  = $B2{$DIR_QID};  
$LDB_QIDb2  = $B2{$LDB_QID};  
$VPP_WIDTH  = ($DIR_PPb2 > $LDB_PPb2) ? $DIR_PPb2 : $LDB_PPb2;
 
$P1    =  1; #parity 1b
$P2    =  2; #parity 2b
$P4    =  4; #parity 4b
$R     =  2; #residue
$ECC6  =  6; #ecc  6b
$ECC7  =  7; #ecc  7b
$ECC8  =  8; #ecc  8b
$ECC16 = 16; #ecc 16b

$CSR_RAM_DEPTH        = 2048;                 $CSR_RAM_WIDTH        =  32;

# Format of the END2END comments is:

# ,END2END    ,ECC bits, bits covered by ECC,residue bits, bits covered by residue,parity bits,bits covered by parity,0,0

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
#5=APAD
#6=DPAD
#7=FEAT_EN
#8=0?
#9=CFG ACCESS
#10=rclk
#11=rrst
#12=wclk
#13=wrst
#14=ipar

$ROB_MEM_DEPTH          = ($DIR_PP+$LDB_PP)*4*4     ; $ROB_MEM_WIDTH          = 133+$VPP_WIDTH  ; # 128 hcw + (10+VPP_WIDTH) hdr

open(OUTPUT, ">hqm_system_srw");
printf OUTPUT "sram,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($ROB_MEM_DEPTH ), ($ROB_MEM_WIDTH  + $ECC16 + $P1), "rob_mem","",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,16  ,128  ,0  ,0  ,1  ,11,0  ,0
close(OUTPUT);
printf "\nGenerated hqm_system_srw input for RAMGEN.hqm_system.perl\n";

$ALARM_VF_SYND0_DEPTH   = $NUM_VF                   ; $ALARM_VF_SYND0_WIDTH   = 30              ;
$ALARM_VF_SYND1_DEPTH   = $NUM_VF                   ; $ALARM_VF_SYND1_WIDTH   = 32              ;
$ALARM_VF_SYND2_DEPTH   = $NUM_VF                   ; $ALARM_VF_SYND2_WIDTH   = 32              ;
$DIR_CQ2VF_PF_DEPTH     = $DIR_CQ               /  2; $DIR_CQ2VF_PF_WIDTH     =($NUM_VFb2+2)*  2;
$DIR_CQ_ADDR_L_DEPTH    = $DIR_CQ                   ; $DIR_CQ_ADDR_L_WIDTH    = 26              ;
$DIR_CQ_ADDR_U_DEPTH    = $DIR_CQ                   ; $DIR_CQ_ADDR_U_WIDTH    = 32              ;
$DIR_CQ_AI_ADDR_L_DEPTH = $DIR_CQ                   ; $DIR_CQ_AI_ADDR_L_WIDTH = 30              ;
$DIR_CQ_AI_ADDR_U_DEPTH = $DIR_CQ                   ; $DIR_CQ_AI_ADDR_U_WIDTH = 32              ;
$DIR_CQ_AI_DATA_DEPTH   = $DIR_CQ                   ; $DIR_CQ_AI_DATA_WIDTH   = 32              ;
$DIR_CQ_ISR_DEPTH       = $DIR_CQ                   ; $DIR_CQ_ISR_WIDTH       = 12              ;
$DIR_CQ_PASID_DEPTH     = $DIR_CQ                   ; $DIR_CQ_PASID_WIDTH     = 23              ;
$DIR_PP2VAS_DEPTH       = $DIR_PP               /  2; $DIR_PP2VAS_WIDTH       = $NUM_VASb2  *  2;
$DIR_PP_V_DEPTH         = $DIR_PP               / 16; $DIR_PP_V_WIDTH         = 1           * 16;
$DIR_QID_V_DEPTH        = $DIR_QID              / 16; $DIR_QID_V_WIDTH        = 1           * 16;
$DIR_VASQID_V_DEPTH     = $NUM_VAS  * $DIR_QID  / 32; $DIR_VASQID_V_WIDTH     = 1           * 32;
$DIR_VPP2PP_DEPTH       = $NUM_VF   * $DIR_PP   /  4; $DIR_VPP2PP_WIDTH       = $DIR_PPb2   *  4;
$DIR_VPP_V_DEPTH        = $NUM_VF   * $DIR_PP   / 16; $DIR_VPP_V_WIDTH        = 1           * 16;
$DIR_VQID2QID_DEPTH     = $NUM_VF   * $DIR_QID  /  4; $DIR_VQID2QID_WIDTH     = $DIR_QIDb2  *  4;
$DIR_VQID_V_DEPTH       = $NUM_VF   * $DIR_QID  / 16; $DIR_VQID_V_WIDTH       = 1           * 16;
$HCW_ENQ_FIFO_DEPTH     = 256                       ; $HCW_ENQ_FIFO_WIDTH     = 144             ;
$LDB_CQ2VF_PF_DEPTH     = $LDB_CQ               /  2; $LDB_CQ2VF_PF_WIDTH     =($NUM_VFb2+2)*  2;
$LDB_CQ_ADDR_L_DEPTH    = $LDB_CQ                   ; $LDB_CQ_ADDR_L_WIDTH    = 26              ;
$LDB_CQ_ADDR_U_DEPTH    = $LDB_CQ                   ; $LDB_CQ_ADDR_U_WIDTH    = 32              ;
$LDB_CQ_AI_ADDR_L_DEPTH = $LDB_CQ                   ; $LDB_CQ_AI_ADDR_L_WIDTH = 30              ;
$LDB_CQ_AI_ADDR_U_DEPTH = $LDB_CQ                   ; $LDB_CQ_AI_ADDR_U_WIDTH = 32              ;
$LDB_CQ_AI_DATA_DEPTH   = $LDB_CQ                   ; $LDB_CQ_AI_DATA_WIDTH   = 32              ;
$LDB_CQ_ISR_DEPTH       = $LDB_CQ                   ; $LDB_CQ_ISR_WIDTH       = 12              ;
$LDB_CQ_PASID_DEPTH     = $LDB_CQ                   ; $LDB_CQ_PASID_WIDTH     = 23              ;
$LDB_PP2VAS_DEPTH       = $LDB_PP               /  2; $LDB_PP2VAS_WIDTH       = $NUM_VASb2  *  2;
$LDB_PP_V_DEPTH         = $LDB_PP               / 16; $LDB_PP_V_WIDTH         = 1           * 16;
$LDB_QID2VQID_DEPTH     = $LDB_QID              /  4; $LDB_QID2VQID_WIDTH     = $LDB_QIDb2  *  4;
$LDB_QID_CFG_V_DEPTH    = $LDB_QID              /  8; $LDB_QID_CFG_V_WIDTH    = 2           *  8;
$LDB_QID_V_DEPTH        = $LDB_QID              /  8; $LDB_QID_V_WIDTH        = 1           *  8;
$LDB_VASQID_V_DEPTH     = $NUM_VAS  * $LDB_QID  / 16; $LDB_VASQID_V_WIDTH     = 1           * 16;
$LDB_VPP2PP_DEPTH       = $NUM_VF   * $LDB_PP   /  4; $LDB_VPP2PP_WIDTH       = $LDB_PPb2   *  4;
$LDB_VPP_V_DEPTH        = $NUM_VF   * $LDB_PP   / 16; $LDB_VPP_V_WIDTH        = 1           * 16;
$LDB_VQID2QID_DEPTH     = $NUM_VF   * $LDB_QID  /  4; $LDB_VQID2QID_WIDTH     = $LDB_QIDb2  *  4;
$LDB_VQID_V_DEPTH       = $NUM_VF   * $LDB_QID  / 16; $LDB_VQID_V_WIDTH       = 1           * 16;
$MSIX_TBL_WORD_DEPTH    = 64                        ; $MSIX_TBL_WORD_WIDTH    = 32              ;
$SCH_OUT_FIFO_DEPTH     = 128                       ; $SCH_OUT_FIFO_WIDTH     = 246             ;
$DIR_WB_DEPTH           = $DIR_CQ                   ; $DIR_WB_WIDTH           = 128             ;
$LDB_WB_DEPTH           = $LDB_CQ                   ; $LDB_WB_WIDTH           = 128             ;

open(OUTPUT, ">hqm_system_rfw");
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($MSIX_TBL_WORD_DEPTH ), ($MSIX_TBL_WORD_WIDTH  + $P1   ), "msix_tbl_word1",         "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,32 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($MSIX_TBL_WORD_DEPTH ), ($MSIX_TBL_WORD_WIDTH  + $P1   ), "msix_tbl_word2",         "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,32 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($MSIX_TBL_WORD_DEPTH ), ($MSIX_TBL_WORD_WIDTH  + $P1   ), "msix_tbl_word0",         "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,32 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($ALARM_VF_SYND0_DEPTH), ($ALARM_VF_SYND0_WIDTH         ), "alarm_vf_synd0",         "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,29 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($ALARM_VF_SYND2_DEPTH), ($ALARM_VF_SYND2_WIDTH         ), "alarm_vf_synd2",         "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,31 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($ALARM_VF_SYND1_DEPTH), ($ALARM_VF_SYND1_WIDTH         ), "alarm_vf_synd1",         "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,31 ,0  ,0

printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_CQ_ADDR_L_DEPTH ), ($LDB_CQ_ADDR_L_WIDTH  + $P1   ), "lut_ldb_cq_addr_l",      "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,26 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_CQ_PASID_DEPTH  ), ($LDB_CQ_PASID_WIDTH   + $P1   ), "lut_ldb_cq_pasid",       "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,23 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_CQ_AI_ADDR_L_DEPTH), ($LDB_CQ_AI_ADDR_L_WIDTH + $P1   ), "lut_ldb_cq_ai_addr_l",     "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,30 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_CQ_AI_ADDR_U_DEPTH), ($LDB_CQ_AI_ADDR_U_WIDTH + $P1   ), "lut_ldb_cq_ai_addr_u",     "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,32 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_CQ_AI_DATA_DEPTH), ($LDB_CQ_AI_DATA_WIDTH + $P1   ), "lut_ldb_cq_ai_data",     "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,32 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_VASQID_V_DEPTH  ), ($LDB_VASQID_V_WIDTH   + $P1   ), "lut_ldb_vasqid_v",       "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,16 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_CQ_ISR_DEPTH    ), ($LDB_CQ_ISR_WIDTH     + $P1   ), "lut_ldb_cq_isr",         "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,12 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_CQ_ADDR_U_DEPTH ), ($LDB_CQ_ADDR_U_WIDTH  + $P1   ), "lut_ldb_cq_addr_u",      "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,32 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_QID2VQID_DEPTH  ), ($LDB_QID2VQID_WIDTH   + $P1   ), "lut_ldb_qid2vqid",       "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,20 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_CQ2VF_PF_DEPTH  ), ($LDB_CQ2VF_PF_WIDTH   + $P1   ), "lut_ldb_cq2vf_pf_ro",       "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,12 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_PP2VAS_DEPTH    ), ($LDB_PP2VAS_WIDTH     + $P1   ), "lut_ldb_pp2vas",         "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,10 ,0  ,0

printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_VQID_V_DEPTH    ), ($LDB_VQID_V_WIDTH     + $P1   ), "lut_vf_ldb_vqid_v",      "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,16 ,0  ,0

printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_PP_V_DEPTH      ), ($DIR_PP_V_WIDTH       + $P1   ), "lut_dir_pp_v",           "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,16 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_CQ_ISR_DEPTH    ), ($DIR_CQ_ISR_WIDTH     + $P1   ), "lut_dir_cq_isr",         "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,12 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_CQ_PASID_DEPTH  ), ($DIR_CQ_PASID_WIDTH   + $P1   ), "lut_dir_cq_pasid",       "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,23 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_CQ_ADDR_L_DEPTH ), ($DIR_CQ_ADDR_L_WIDTH  + $P1   ), "lut_dir_cq_addr_l",      "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,26 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_VASQID_V_DEPTH  ), ($DIR_VASQID_V_WIDTH   + $P1   ), "lut_dir_vasqid_v",       "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,32 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_CQ_ADDR_U_DEPTH ), ($DIR_CQ_ADDR_U_WIDTH  + $P1   ), "lut_dir_cq_addr_u",      "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,32 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_CQ_AI_ADDR_L_DEPTH), ($DIR_CQ_AI_ADDR_L_WIDTH + $P1   ), "lut_dir_cq_ai_addr_l",     "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,30 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_CQ_AI_ADDR_U_DEPTH), ($DIR_CQ_AI_ADDR_U_WIDTH + $P1   ), "lut_dir_cq_ai_addr_u",     "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,32 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_CQ_AI_DATA_DEPTH), ($DIR_CQ_AI_DATA_WIDTH + $P1   ), "lut_dir_cq_ai_data",     "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,32 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_PP2VAS_DEPTH    ), ($DIR_PP2VAS_WIDTH     + $P1   ), "lut_dir_pp2vas",         "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,10 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_CQ2VF_PF_DEPTH  ), ($DIR_CQ2VF_PF_WIDTH   + $P1   ), "lut_dir_cq2vf_pf_ro",       "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,12 ,0  ,0

printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_VPP_V_DEPTH     ), ($LDB_VPP_V_WIDTH      + $P1   ), "lut_vf_ldb_vpp_v",       "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,16 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_VQID_V_DEPTH    ), ($DIR_VQID_V_WIDTH     + $P1   ), "lut_vf_dir_vqid_v",      "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,16 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_VPP_V_DEPTH     ), ($DIR_VPP_V_WIDTH      + $P1   ), "lut_vf_dir_vpp_v",       "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,16 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_VQID2QID_DEPTH  ), ($LDB_VQID2QID_WIDTH   + $ECC7 ), "lut_vf_ldb_vqid2qid",    "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,7  ,20 ,0  ,0  ,0  ,0  ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_VPP2PP_DEPTH    ), ($DIR_VPP2PP_WIDTH     + $ECC7 ), "lut_vf_dir_vpp2pp",      "",  0, 0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,7  ,24 ,0  ,0  ,0  ,0  ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($DIR_VQID2QID_DEPTH  ), ($DIR_VQID2QID_WIDTH   + $ECC7 ), "lut_vf_dir_vqid2qid",    "",  0, 0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,7  ,24 ,0  ,0  ,0  ,0  ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",  ($LDB_VPP2PP_DEPTH    ), ($LDB_VPP2PP_WIDTH     + $P1   ), "lut_vf_ldb_vpp2pp",      "",  0,0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,24 ,0  ,0

printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",   ($SCH_OUT_FIFO_DEPTH  ), ($SCH_OUT_FIFO_WIDTH   + $ECC16), "sch_out_fifo",           "",  0, 0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",8,"hqm_clk","pg",100 ;    # ,END2END  ,16 ,128,2  ,60 ,1  ,55 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",   ($DIR_WB_DEPTH        ), ($DIR_WB_WIDTH         + $ECC16), "dir_wb0",                "",  0, 0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,16 ,128,0  ,0  ,0  ,0  ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",   ($DIR_WB_DEPTH        ), ($DIR_WB_WIDTH         + $ECC16), "dir_wb1",                "",  0, 0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,16 ,128,0  ,0  ,0  ,0  ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",   ($DIR_WB_DEPTH        ), ($DIR_WB_WIDTH         + $ECC16), "dir_wb2",                "",  0, 0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,16 ,128,0  ,0  ,0  ,0  ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",   ($LDB_WB_DEPTH        ), ($LDB_WB_WIDTH         + $ECC16), "ldb_wb0",                "",  0, 0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,16 ,128,0  ,0  ,0  ,0  ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",   ($LDB_WB_DEPTH        ), ($LDB_WB_WIDTH         + $ECC16), "ldb_wb1",                "",  0, 0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,16 ,128,0  ,0  ,0  ,0  ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",   ($LDB_WB_DEPTH        ), ($LDB_WB_WIDTH         + $ECC16), "ldb_wb2",                "",  0, 0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","","",0,"hqm_clk","pg",100 ;    # ,END2END  ,16 ,128,0  ,0  ,0  ,0  ,0  ,0
close(OUTPUT);
printf "Generated hqm_system_rfw input for RAMGEN.hqm_system.perl\n";

open(OUTPUT, ">hqm_system_dc_rfw");
printf OUTPUT "rf_dc,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($HCW_ENQ_FIFO_DEPTH  ), ($HCW_ENQ_FIFO_WIDTH   + $ECC16 + $P1), "hcw_enq_fifo",           "",  0, 0,0,0,0,"hqm_gated_clk","hqm_gated_rst_n","prim_gated_clk","prim_gated_rst_n",6,"prim_clk","pg",100 ;    # ,END2END  ,16 ,128,0  ,0  ,1  ,16 ,0  ,0
close(OUTPUT);
printf "Generated hqm_system_dc_rfw input for RAMGEN.hqm_system.perl\n";

#printf "\nPlease run the following:\n\n";
#printf "RAMGEN.hqm_system.perl hqm_system 1\n\n";
#printf "cp ./hqm_system_srw.sv          ../system/.\n";
#printf "cp ./hqm_system_srw_top.sv      ../system/.\n";
#printf "cp ./hqm_system_rfw.sv          ../system/.\n";
#printf "cp ./hqm_system_rfw_top.sv      ../system/.\n";
#printf "cp ./hqm_repair_fuses_system.vh ../.\n";
