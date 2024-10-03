#!/usr/bin/perl 

##USAGE hqm_sif.perl <case>

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
$DIR_CQID = 128;
$LDB_CQID = 128;



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
 $DIR_CQID =  $DIRQID ;
 $LDB_CQID =  $LBQID ;

printf "\nGenerating for CASE=%s %s DM: VF=%d VAS=%d DIR(PP=%d QID=%d) LDB(PP=%d QID=%d)\n\n",
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
$DIR_CQIDb2 = $B2{$DIR_CQID}; 
$LDB_CQIDb2 = $B2{$LDB_CQID}; 
$CQb2       = $B2{$DIR_CQ+$LDB_CQ};
 
$P1    =  1; #parity 1b
$P2    =  2; #parity 2b
$P4    =  4; #parity 4b
$P5    =  5; #parity 5b
$P8    =  8; #parity 8b
$R     =  2; #residue
$ECC7  =  7; #ecc  7b
$ECC8  =  8; #ecc  8b
$ECC16 = 16; #ecc 16b

# Format of the END2END comments is:

# ,END2END    ,bits covered by ECC,ECC bits,bits covered by residue,residue bits,bits covered by parity,parity bits,0,0


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
$SCRBD_MEM_DEPTH        = 256                     ; $SCRBD_MEM_WIDTH        = $CQb2+2         ; # CQ#, SRC
$IBCPL_HDR_FIFO_DEPTH   = $SCRBD_MEM_DEPTH        ; $IBCPL_HDR_FIFO_WIDTH   = 19              ; # BAD_LEN, TO, EP, STAT[2:0], LEN[4:0] TAG[7:0]
$IBCPL_DATA_FIFO_DEPTH  = $SCRBD_MEM_DEPTH        ; $IBCPL_DATA_FIFO_WIDTH  = 64              ;
$RI_TLQ_PHDR_DEPTH      = 16                      ; $RI_TLQ_PHDR_WIDTH      = 148             ;
$RI_TLQ_PDATA_DEPTH     = 32                      ; $RI_TLQ_PDATA_WIDTH0    = 256             ;
$RI_TLQ_NPHDR_DEPTH     = 8                       ; $RI_TLQ_NPHDR_WIDTH     = 153             ;
$RI_TLQ_NPDATA_DEPTH    = 8                       ; $RI_TLQ_NPDATA_WIDTH    = 32              ;
$MSTR_LL_DEPTH          = 256                     ;
$MSTR_LL_HPA_DEPTH      = $DIR_CQ+$LDB_CQ         ; $MSTR_LL_HPA_WIDTH      = 34              ;
$MSTR_LL_HDR_DEPTH      = $MSTR_LL_DEPTH          ; $MSTR_LL_HDR_WIDTH      = 152             ; # HDR, PASIDTLP, TLB_REQD
$MSTR_LL_DATA_DEPTH     = $MSTR_LL_DEPTH          ; $MSTR_LL_DATA_WIDTH     = 128             ;
$TLB_TAG_4K_DEPTH       = 16                      ; $TLB_TAG_4K_WIDTH       = 84              ;
$TLB_DATA_4K_DEPTH      = 16                      ; $TLB_DATA_4K_WIDTH      = 38              ;

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

open(OUTPUT, ">hqm_sif_rfw");
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($SCRBD_MEM_DEPTH      ), ($SCRBD_MEM_WIDTH       + $P1), "scrbd_mem",           "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,9  ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($IBCPL_HDR_FIFO_DEPTH ), ($IBCPL_HDR_FIFO_WIDTH  + $P1), "ibcpl_hdr_fifo",      "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,19 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($IBCPL_DATA_FIFO_DEPTH), ($IBCPL_DATA_FIFO_WIDTH + $P2), "ibcpl_data_fifo",     "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,2  ,64 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($RI_TLQ_PHDR_DEPTH    ), ($RI_TLQ_PHDR_WIDTH     + $P5), "ri_tlq_fifo_phdr",    "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,5  ,148,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($RI_TLQ_PDATA_DEPTH   ), ($RI_TLQ_PDATA_WIDTH0   + $P8), "ri_tlq_fifo_pdata",   "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,8  ,256,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($RI_TLQ_NPHDR_DEPTH   ), ($RI_TLQ_NPHDR_WIDTH    + $P5), "ri_tlq_fifo_nphdr",   "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,5  ,153,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($RI_TLQ_NPDATA_DEPTH  ), ($RI_TLQ_NPDATA_WIDTH   + $P1), "ri_tlq_fifo_npdata",  "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,32 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($MSTR_LL_HPA_DEPTH    ), ($MSTR_LL_HPA_WIDTH     + $P1), "mstr_ll_hpa",         "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,34 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($MSTR_LL_HDR_DEPTH    ), ($MSTR_LL_HDR_WIDTH     + $P1), "mstr_ll_hdr",         "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,152,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($MSTR_LL_DATA_DEPTH   ), ($MSTR_LL_DATA_WIDTH    + $P1), "mstr_ll_data0",       "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,128,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($MSTR_LL_DATA_DEPTH   ), ($MSTR_LL_DATA_WIDTH    + $P1), "mstr_ll_data1",       "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,128,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($MSTR_LL_DATA_DEPTH   ), ($MSTR_LL_DATA_WIDTH    + $P1), "mstr_ll_data2",       "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,128,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($MSTR_LL_DATA_DEPTH   ), ($MSTR_LL_DATA_WIDTH    + $P1), "mstr_ll_data3",       "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,128,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_TAG_4K_DEPTH     ), ($TLB_TAG_4K_WIDTH      + $P1), "tlb_tag0_4k",         "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,84 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_TAG_4K_DEPTH     ), ($TLB_TAG_4K_WIDTH      + $P1), "tlb_tag1_4k",         "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,84 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_TAG_4K_DEPTH     ), ($TLB_TAG_4K_WIDTH      + $P1), "tlb_tag2_4k",         "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,84 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_TAG_4K_DEPTH     ), ($TLB_TAG_4K_WIDTH      + $P1), "tlb_tag3_4k",         "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,84 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_TAG_4K_DEPTH     ), ($TLB_TAG_4K_WIDTH      + $P1), "tlb_tag4_4k",         "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,84 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_TAG_4K_DEPTH     ), ($TLB_TAG_4K_WIDTH      + $P1), "tlb_tag5_4k",         "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,84 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_TAG_4K_DEPTH     ), ($TLB_TAG_4K_WIDTH      + $P1), "tlb_tag6_4k",         "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,84 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_TAG_4K_DEPTH     ), ($TLB_TAG_4K_WIDTH      + $P1), "tlb_tag7_4k",         "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,84 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_DATA_4K_DEPTH    ), ($TLB_DATA_4K_WIDTH     + $P1), "tlb_data0_4k",        "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,38 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_DATA_4K_DEPTH    ), ($TLB_DATA_4K_WIDTH     + $P1), "tlb_data1_4k",        "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,38 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_DATA_4K_DEPTH    ), ($TLB_DATA_4K_WIDTH     + $P1), "tlb_data2_4k",        "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,38 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_DATA_4K_DEPTH    ), ($TLB_DATA_4K_WIDTH     + $P1), "tlb_data3_4k",        "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,38 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_DATA_4K_DEPTH    ), ($TLB_DATA_4K_WIDTH     + $P1), "tlb_data4_4k",        "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,38 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_DATA_4K_DEPTH    ), ($TLB_DATA_4K_WIDTH     + $P1), "tlb_data5_4k",        "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,38 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_DATA_4K_DEPTH    ), ($TLB_DATA_4K_WIDTH     + $P1), "tlb_data6_4k",        "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,38 ,0  ,0
printf OUTPUT "rf,%d,%d,%s,%s,%d,%d,%d,%d,%d,%s,%s,%s,%s,%d,%s,%s,%d\n",($TLB_DATA_4K_DEPTH    ), ($TLB_DATA_4K_WIDTH     + $P1), "tlb_data7_4k",        "",  0,0,0,0,0,"prim_nonflr_clk","prim_gated_rst_b","","",0,"prim_clk","",100 ;    # ,END2END  ,0  ,0  ,0  ,0  ,1  ,38 ,0  ,0
close(OUTPUT);
printf "Generated hqm_sif_rfw input for RAMGEN.hqm_sif.perl\n";

