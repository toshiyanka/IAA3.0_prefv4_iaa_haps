////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 1999 - 2020 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Nitin Mhamunkar  Sept 1999
//
// VERSION:   Simulation Architecture
//
// DesignWare_version: b7619314
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////
//#include "DW_crc_s.lbls"
//----------------------------------------------------------------------------
// ABSTRACT: Generic CRC 
//
// MODIFIED:
//
//      02/03/2016  Liming SU   Eliminated function calling from sequential
//                              always block in order for NLP tool to correctly
//                              infer FFs
//
//      07/09/2015  Liming SU   Changed for compatibility with VCS Native Low
//                              Power
//
//	09/19/2002  Rick Kelly  Fixed behavior of enable (STAR 147315) as well
//                              as discrepencies in other control logic.  Also
//			        updated to current simulation code guidelines.
//
//----------------------------------------------------------------------------
module DW_crc_s
    (
     clk ,rst_n ,init_n ,enable ,drain ,ld_crc_n ,data_in ,crc_in ,
     draining ,drain_done ,crc_ok ,data_out ,crc_out 
     );

parameter integer data_width = 16;
parameter integer poly_size  = 16;
parameter integer crc_cfg    = 7;
parameter integer bit_order  = 3;
parameter integer poly_coef0 = 4129;
parameter integer poly_coef1 = 0;
parameter integer poly_coef2 = 0;
parameter integer poly_coef3 = 0;
   
input clk, rst_n, init_n, enable, drain, ld_crc_n;
input [data_width-1:0] data_in;
input [poly_size-1:0]  crc_in;
   
output draining, drain_done, crc_ok;
output [data_width-1:0] data_out;
output [poly_size-1:0]  crc_out;
   
//   synopsys translate_off


  wire 			   clk, rst_n, init_n, enable, drain, ld_crc_n;
  wire [data_width-1:0]    data_in;
  wire [poly_size-1:0]     crc_in;
   
  reg			   drain_done_int;
  reg 			   draining_status;
   
  wire [poly_size-1:0]     crc_result;
   
  integer 		   drain_pointer, data_pointer;
  integer 		   drain_pointer_next, data_pointer_next;
  reg 			   draining_status_next;
  reg 			   draining_next;
  reg 			   draining_int;
  reg 			   crc_ok_result;
  wire [data_width-1:0]    insert_data;
  reg [data_width-1:0]     data_out_next;
  reg [data_width-1:0]     data_out_int;
  reg [poly_size-1:0] 	   crc_out_int;
  reg [poly_size-1:0] 	   crc_out_info; 
  reg [poly_size-1:0] 	   crc_out_info_next;
  reg [poly_size-1:0] 	   crc_out_info_temp;
   
  reg [poly_size-1:0] 	   crc_out_next;
  reg [poly_size-1:0] 	   crc_out_temp;
  wire [poly_size-1:0]     insert_crc_info;
  wire [poly_size-1:0]     crc_swaped_info; 
  wire [poly_size-1:0]     crc_out_next_shifted;
  wire [poly_size-1:0]     crc_swaped_shifted;
  reg 			   drain_done_next;
  reg 			   crc_ok_int;
   
`ifdef UPF_POWER_AWARE
  `protected
D+R_4]caO<)O4PbLTb4#N<cJU=C&Lb5RQDBP[1Y+\Be:[bD-FAb[7)F.RCA;8:U6
6]VDDTPI7VY_KBaS0Ig+_=N)GP5^NgGNM-5=3-T[2PG\0L5>eQN[2WO?JJ2M1MRH
]Qa[9[MI)3>,+>+7X4@L\NaK.A<<BQc7\99b:1e>\+79Q;@M34+-&:BCN4.f>B(I
RUWR)?Ib:e&7U[SM5)&OHgMc)^IV-0D#B5GE\DK_.81[.HI#<19Z3/;0Cf3QL.5T
<0,S]\,D#_WYF34XU(0#XJ:[eIPZZ#NZAR/:]4,D.6He.O<R356JMB=AOIDX(+AY
+;TDOJQYA7ORMY+0R4]7MA;26FO,AAV4@@ER@NcQ)BPN,WK[8deK8_Oa;<+1+b&J
2C&RI@fF._1BB?G]<];^5.8D6]I)LQP:\#]\f5LI)ZeCgA&fAI@PFIF\@/)8L9NN
P9W=FYNFEVB[@ca^_I45+D[>O]X^YC+H0&FDd8X&gYg8]Y>PT8.IL[[P(8)5cN^+
bJ:E8O.-DC89[NW=H9XI.X3GA(H?_+SEf:=/0HG\/EMI8H[MO@-/^DX(JC:C2-<A
RCTQF<U<^>0,f53L/JH6R^D;X/1>VAKVBJT;]?#+]#+6_)NeY?302\MMgSOF_NG5
WVNS.3\;-G<b;/FVA233V?R3gH1D>5JA0c]&^E\]2@ZOg92[JX6LB+,aJfQ6DBSQ
(:-D_+A?ON&RP)[M23G)X_\0bCcR?d+#06BGOUegBcTc;2fTgdWddUbN83aLHgIM
@[53Qa?_+UND2E<c7b(CcMEDL]]IfW#BRUeC>[H=@IFa;LNBLa_0>_QDZABU6a20
US?O]EWIc>4]5@+b[8^/#-(H\-A_+<CNe[NW2T-0Qf?W7V(g?B2b[YXOVe2DdgH]
gK\A2Ub_W]TQc4&C/HX;81eO\8@DB)Y-TI38=A\,>8V,=O/2<0KUE:&@bO@O@WDI
<D_7@X&BfXeO30QP7-J#AEIQ>#7Ag,aBC,AH;QJY@g\B.E7B>YV5T9g]FAR7\:2_
2YQ[._3NLV/R7+L=WL-gd]fLQJCM?/</0?B9)fEc\X72;>G2+4,;1F.9JHAb>4=0
1^Y,]WFNZK+F:JLF6]+(O>TBgPPTH/ge<Ub\BO(H\(T[aAVG^YIYgSgK.MG5E645
;&Oc+A?2CSMFP/,4W/I]F,Ig^N+/FR3cO6RQA@Df#AIJ2,&S8TNfdd7[bCJKHNfa
WFNdV^+3[.3IVdUcH/C[EdPA;0+_YgDgfPKaecCd#R(]U6.)=4D[;S+<^D5SVA]X
eMT=VC:UYE^E@XV9F<(>Y4A(+:/Q8\FI^?YgAN#+VF_93L,9^DSXMU+E2NBJTL/C
T9XCOce@YEJg_c<gTJJ[]:1@AB>I]QaW?)X;f9QE8@P5Lb>[:\<Kd6=a-M]B;FTY
4[Z2XRd5;AW1-@(5;C(E9?V25Gc5e3OEd77+-BA<LH]26\5+-RC8E8I)0cBQMD3:
Y4B4.[X.SfFf9;aQfTE&)ZN6c)Y_X;0ASG=+NSbXe@3A5NL@^_7/-W_[cRIPPH&d
&&^KfKN6\@2VDgYPIRg@R59+gXV6SRaX[+f[C,((5^,&70_<9_)-eVBb(_>N(BC,
:ACM[Z:O-+8W.BC]QUC(bRN6,<R\3IL(#+BBL4^;QBINCE2@Z0YFM@>Lfb)4\)+8
f,=<)5Q5fdLCP^/_/RXee_&A&g.L=#d7L_U6dKe/0[eAO5FRcVB1eDY[9fE0]765
K.+R(HWUc7D=U88)4BB@9D-_XS;/#3IFcf<cW(cD=]eFJAGAbDaVJU3,&HHNWdd=
aEeCG9<cC@eHeM.Z6PHM5/-Ub_JNLFDIQHKZ/-fR9-27F7P7Q)(M2\XQJ1+VYIRY
DD#XHKBL];GNGSKL(Y()E>]a<f#^c?GQS:&^M42BC45+BG;:Tc,)P0+#])(3gaRO
[-^Nd^E42@9O9>&_/?6b>#8Z+VTN1??Tg1UD:48gUD##UIIYHP=N4\d:;>;14:/)
]6[\=K1WOLJ_8GPO#d&g=A#aSUN(E5>Z7cX.3f,SEFa?(E1Z:<;N0^)OaK4=@JD8
0@9VSG8#Pa;BZ4?a_+CW>,)Y5H[+]<-G2KM98)D#PC@89)C@9R&b3RP0SQ-c@f:/
7H8+L:bU:ES.&^HZ<I_CA<.U18(RC,XIH7O3U+4M/ZC>a5JJe<R+;K;cQMEbOIbV
9:-@;/KQQ=1-8I[__<dag.d(QRa_2Xb//G?UP8fIRGHN\?16<<f0;/0+[0Z^e?;J
DB,N8?-g1,UXH1:g6+G0JB)FDG7>5HbXdDLRRW>K6bQXY#&gL^(F(#6WG;)7UG31
P5GLCfR<?1g5]7\c3bZPU4.5/bY<T0f[OXXf3_bMb?_]ZRY0I1IQ)L&[g_FF;4#_
G5-Xg<;b[SU:R8C0g(_8SbdQ9S]XLB#If1SL9Q0-MfDQPXWMRCfN,8P2&L:,NT&E
RdE3WJRfSf\:-$
`endprotected

`else
  reg [poly_size-1:0]      reset_crc_reg;
  reg [poly_size-1:0]      crc_polynomial;
  reg [poly_size-1:0] 	   crc_xor_constant;
  reg [poly_size-1:0]      crc_ok_info;
`endif
 

  function [poly_size-1:0] fswap_bytes_bits;
    input [poly_size-1:0] swap_bytes_of_word;
    input [1:0] bit_order;
    begin : FUNC_SWAP_INPUT_DATA 
      reg[data_width-1:0] swaped_word;
      integer 	     no_of_bytes;
      integer 	     byte_boundry1;
      integer 	     byte_boundry2;
      integer 	     i, j;
     
      byte_boundry1 = 0;
      byte_boundry2 = 0;
     
      no_of_bytes = data_width/8;
	if(bit_order == 0)
	  swaped_word = swap_bytes_of_word; 
	else if(bit_order == 1) begin
	  for(i=0;i<=(data_width-1);i=i+1) begin
	    swaped_word[(data_width-1)-i] = swap_bytes_of_word[i];
	  end 
	end  
	else if(bit_order == 3) begin
	  for(i=1;i<=no_of_bytes;i=i+1) begin 
	    byte_boundry1 = (i * 8) - 1;
	    byte_boundry2 = (i - 1)* 8;
	    for (j=0;j<8;j=j+1) begin 
	      swaped_word [(byte_boundry2  + j)] = 
		      swap_bytes_of_word [(byte_boundry1  - j)];
	    end
	  end
	end
	else begin
	  for(i=1;i<=no_of_bytes;i=i+1) begin
	    byte_boundry1 = data_width - (i*8);
	    byte_boundry2 = ((i - 1)* 8);
	    for(j=0;j<8;j=j+1) begin 
	      swaped_word [(byte_boundry2 + j)] = 
      	      	      swap_bytes_of_word [(byte_boundry1  + j)];
	    end
	  end
	end
	 
	fswap_bytes_bits = swaped_word;
      end
  endfunction // FUNC_SWAP_INPUT_DATA





  function [poly_size-1:0] fswap_crc;
    input [poly_size-1:0] swap_crc_data;
    begin : FUNC_SWAP_CRC
      reg[data_width-1:0]   swap_data;
      reg [data_width-1:0] swaped_data;
      reg [poly_size-1:0]  swaped_crc;
      integer 	           no_of_words;
      integer 	           data_boundry1;
      integer 	           data_boundry2;
      integer 	           i, j;
     
      no_of_words = poly_size/data_width;
     
      data_boundry1 = (poly_size-1) + data_width;
      while (no_of_words > 0) begin 
	data_boundry1 = data_boundry1 - data_width;
	data_boundry2 = data_boundry1 - (data_width-1);
	j=0;
	for(i=data_boundry2;i<=data_boundry1;i = i + 1) begin
	  swap_data[j] = swap_crc_data[i];
	  j = j + 1;
	end      
	    
	swaped_data = fswap_bytes_bits (swap_data, bit_order);
	    
	j=0;
	for(i=data_boundry2;i<=data_boundry1;i = i + 1) begin
	  swaped_crc[i] = swaped_data[j];
	  j = j + 1;
	end   
	
	no_of_words = (no_of_words  -  1);
      end
     
      fswap_crc = swaped_crc;
    end
  endfunction // FUNC_SWAP_CRC


  function [poly_size-1:0] fcalc_crc;
    input [data_width-1:0] data_in;
    input [poly_size-1:0] crc_temp_data;
    input [poly_size-1:0] crc_polynomial;
    input [1:0]  bit_order;
    begin : FUNC_CAL_CRC
      reg[data_width-1:0] swaped_data_in;
      reg [poly_size-1:0] crc_data;
      reg 		     xor_or_not;
      integer 	     i;
     
     
     
      swaped_data_in = fswap_bytes_bits (data_in ,bit_order);
      crc_data = crc_temp_data ;
      i = 0 ;
      while (i < data_width ) begin 
	xor_or_not = 
	  swaped_data_in[(data_width-1) - i] ^ crc_data[(poly_size-1)];
	crc_data = {crc_data [((poly_size-1)-1):0],1'b0 };
	if(xor_or_not === 1'b1)
	  crc_data = (crc_data ^ crc_polynomial);
	else if(xor_or_not !== 1'b0)
	  crc_data = {data_width{xor_or_not}} ;
	i = i + 1;
      end
      fcalc_crc = crc_data ;
    end
  endfunction // FUNC_CAL_CRC





  function check_crc;
    input [poly_size-1:0] crc_out_int;
    input [poly_size-1:0] crc_ok_info;
    begin : FUNC_CRC_CHECK
      integer i;
      reg 	 crc_ok_func;
      reg [poly_size-1:0] data1;
      reg [poly_size-1:0] data2;
      data1 = crc_out_int ;
      data2 = crc_ok_info ;
     
      i = 0 ;
      while(i < poly_size) begin 
	if(data1[i] === 1'b0  || data1[i] === 1'b1) begin 
	  if(data1[i] === data2 [i]) begin
	    crc_ok_func = 1'b1;
	  end
	  else begin
	    crc_ok_func = 1'b0;
	    i = poly_size;
	  end 
	end
	else begin
	  crc_ok_func = data1 [i];
	  i = poly_size;
	end 
	i = i + 1;
      end
     
      check_crc = crc_ok_func ;
    end
  endfunction // FUNC_CRC_CHECK



   
  always @(drain or
           draining_status or
           drain_done_int or
           data_pointer or
           drain_pointer or
           insert_data or
           crc_out_next_shifted or
           crc_out_info or
           data_in or
           crc_result or
           ld_crc_n or
           crc_in or
           crc_ok_info)
  begin: PROC_DW_crc_s_sim_com

    if(draining_status === 1'b0) begin
      if((drain & ~drain_done_int) === 1'b1) begin
       draining_status_next = 1'b1;
       draining_next = 1'b1;
       drain_pointer_next = drain_pointer + 1;
       data_pointer_next = data_pointer  - 1;
       data_out_next = insert_data;
       crc_out_next = crc_out_next_shifted;
       crc_out_info_next = crc_out_info; 
       drain_done_next = drain_done_int;
      end  
      else if((drain & ~drain_done_int) === 1'b0) begin
       draining_status_next = 1'b0;
       draining_next = 1'b0;
       drain_pointer_next = 0;
       data_pointer_next = (poly_size/data_width) ; 
       data_out_next = data_in ;
       crc_out_next = crc_result;
       crc_out_info_next = crc_result;
       drain_done_next = drain_done_int;
      end  
      else begin
       draining_status_next = 1'bx ;
       draining_next = 1'bx ;
       drain_pointer_next = 0;
       data_pointer_next = 0 ; 
       data_out_next = {data_width {1'bx}};
       crc_out_next = {poly_size {1'bx}};
       crc_out_info_next = {poly_size {1'bx}}; 
       drain_done_next = 1'bx;
      end  
    end
    else if(draining_status === 1'b1) begin 
      if(data_pointer == 0) begin 
       draining_status_next = 1'b0 ;
       draining_next = 1'b0 ;
       drain_pointer_next = 0 ;
       data_pointer_next = 0 ; 
       data_out_next = data_in ;
       crc_out_next = crc_result;
       crc_out_info_next = crc_result; 
       drain_done_next = 1'b1;
      end
      else begin
       draining_status_next = 1'b1 ;
       draining_next = 1'b1 ;
       drain_pointer_next = drain_pointer + 1;
       data_pointer_next = data_pointer  - 1;
       data_out_next = insert_data ;
       crc_out_next = crc_out_next_shifted;
       crc_out_info_next = crc_out_info;
       drain_done_next = drain_done_int;
      end   
    end   // draining_status === 1'b1
    else begin 
      draining_status_next = 1'bx ;
      draining_next = 1'bx ;
      drain_pointer_next = data_pointer ;
      data_pointer_next = drain_pointer;
      data_out_next = {data_width{1'bx}} ;
      crc_out_next = {poly_size{1'bx}}  ;
      crc_out_info_next = {poly_size{1'bx}}  ; 
      drain_done_next = 1'bx ;
    end   

    if(ld_crc_n === 1'b0) begin
      crc_out_temp = crc_in;
      crc_out_info_temp = crc_in;
    end
    else if(ld_crc_n === 1'b1) begin
      crc_out_temp = crc_out_next;
      crc_out_info_temp = crc_out_info_next;
    end
    else begin
      crc_out_temp = {poly_size{1'bx}};
      crc_out_info_temp = {poly_size{1'bx}}; 
    end 

    crc_ok_result = check_crc(crc_out_temp ,crc_ok_info);

  end // PROC_DW_crc_s_sim_com

  always @ (posedge clk or negedge rst_n) begin : DW_crc_s_sim_seq_PROC
        
    if(rst_n === 1'b0) begin
      draining_status <= 1'b0 ;
      draining_int <= 1'b0 ;
      drain_pointer <= 0 ;
      data_pointer <= (poly_size/data_width) ;
      data_out_int <= {data_width{1'b0}} ;
      crc_out_int <= reset_crc_reg ; 
      crc_out_info <= reset_crc_reg ;  
      drain_done_int <= 1'b0 ;
      crc_ok_int <= 1'b0;   
    end else if(rst_n === 1'b1) begin 
      if(init_n === 1'b0) begin
        draining_status <= 1'b0 ;
        draining_int <= 1'b0 ;
        drain_pointer <= 0 ;
        data_pointer <= (poly_size/data_width) ;
        data_out_int <= {data_width{1'b0}} ;
        crc_out_int <= reset_crc_reg ;
        crc_out_info <= reset_crc_reg ; 
        drain_done_int <= 1'b0 ;
        crc_ok_int <= 1'b0;
      end else if(init_n === 1'b1) begin 
        if(enable === 1'b1) begin
          draining_status <= draining_status_next;
          draining_int <= draining_next ;
          drain_pointer <= drain_pointer_next ;
          data_pointer <= data_pointer_next ;
          data_out_int <= data_out_next ;
          crc_out_int <= crc_out_temp ;
          crc_out_info <= crc_out_info_temp ;
          drain_done_int <= drain_done_next ;
          crc_ok_int <= crc_ok_result;
        end else if(enable === 1'b0) begin
           draining_status <= draining_status ;
           draining_int <= draining_int ;
           drain_pointer <= drain_pointer ;
           data_pointer <= data_pointer ;
           data_out_int <= data_out_int ;
           crc_out_int <= crc_out_int ;
           crc_out_info <= crc_out_info ;
           drain_done_int <= drain_done_int ;
           crc_ok_int <= crc_ok_int ;
        end else begin
           draining_status <= 1'bx ;
           draining_int <= 1'bx ;
           drain_pointer <= 0 ;
           data_pointer <= (poly_size/data_width) ;
           data_out_int <= {data_width{1'bx}} ;
           crc_out_int <= {poly_size{1'bx}} ;
           crc_out_info <= {poly_size{1'bx}} ; 
           drain_done_int <= 1'bx ;
           crc_ok_int <= 1'bx ; 
        end
      end else begin 
        draining_status <= 1'bx ;
        draining_int <= 1'bx ;
        drain_pointer <= 0 ;
        data_pointer <= (poly_size/data_width) ;
        data_out_int <= {data_width{1'bx}} ;
        crc_out_int <= {poly_size{1'bx}} ;
        crc_out_info <= {poly_size{1'bx}} ; 
        drain_done_int <= 1'bx ;
        crc_ok_int <= 1'bx ; 
      end      
    end else begin
      draining_status <= 1'bx ;
      draining_int <= 1'bx ;
      drain_pointer <= 0 ;
      data_pointer <= 0 ;
      data_out_int <= {data_width{1'bx}} ;
      crc_out_int <= {poly_size{1'bx}} ;
      crc_out_info <= {poly_size{1'bx}} ; 
      drain_done_int <= 1'bx ;
      crc_ok_int <= 1'bx ;
    end 
       
  end // PROC_DW_crc_s_sim_seq

   assign crc_out_next_shifted = crc_out_int << data_width; 
   assign crc_result = fcalc_crc (data_in ,crc_out_int ,crc_polynomial ,bit_order);
   assign insert_crc_info = (crc_out_info ^ crc_xor_constant);
   assign crc_swaped_info = fswap_crc (insert_crc_info);
   assign crc_swaped_shifted = crc_swaped_info << (drain_pointer*data_width);
   assign insert_data = crc_swaped_shifted[poly_size-1:poly_size-data_width];

   assign crc_out = crc_out_int;
   assign draining = draining_int;
   assign data_out = data_out_int;
   assign crc_ok = crc_ok_int;
   assign drain_done = drain_done_int;
   
   
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
      
       
    if ( (poly_size < 2) || (poly_size > 64 ) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter poly_size (legal range: 2 to 64 )",
	poly_size );
    end
       
    if ( (data_width < 1) || (data_width > poly_size ) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter data_width (legal range: 1 to poly_size )",
	data_width );
    end
       
    if ( (bit_order < 0) || (bit_order > 3 ) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter bit_order (legal range: 0 to 3 )",
	bit_order );
    end
       
    if ( (crc_cfg < 0) || (crc_cfg > 7 ) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter crc_cfg (legal range: 0 to 7 )",
	crc_cfg );
    end
       
    if ( (poly_coef0 < 0) || (poly_coef0 > 65535 ) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter poly_coef0 (legal range: 0 to 65535 )",
	poly_coef0 );
    end
       
    if ( (poly_coef1 < 0) || (poly_coef1 > 65535 ) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter poly_coef1 (legal range: 0 to 65535 )",
	poly_coef1 );
    end
       
    if ( (poly_coef2 < 0) || (poly_coef2 > 65535 ) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter poly_coef2 (legal range: 0 to 65535 )",
	poly_coef2 );
    end
       
    if ( (poly_coef3 < 0) || (poly_coef3 > 65535 ) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter poly_coef3 (legal range: 0 to 65535 )",
	poly_coef3 );
    end
       
    if ( (poly_coef0 % 2) == 0 ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m : Invalid parameter (poly_coef0 value MUST be an odd number)" );
    end
       
    if ( (poly_size % data_width) > 0 ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m : Invalid parameter combination (poly_size MUST be a multiple of data_width)" );
    end
       
    if ( (data_width % 8) > 0 && (bit_order > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m : Invalid parameter combination (crc_cfg > 1 only allowed when data_width is multiple of 8)" );
    end

   
    if ( param_err_flg == 1) begin
      $display(
        "%m :\n  Simulation aborted due to invalid parameter value(s)");
      $finish;
    end

  end // parameter_check 

      

`ifndef UPF_POWER_AWARE
  initial begin : init_vars
	
    reg [63:0]			con_poly_coeff;
    reg [15:0]			v_poly_coef0;
    reg [15:0]			v_poly_coef1;
    reg [15:0]			v_poly_coef2;
    reg [15:0]			v_poly_coef3; 
    reg [poly_size-1:0 ]	int_ok_calc;
    reg[poly_size-1:0]		x;
    reg				xor_or_not_ok;
    integer			i;
	
    v_poly_coef0 = poly_coef0;
    v_poly_coef1 = poly_coef1;
    v_poly_coef2 = poly_coef2;
    v_poly_coef3 = poly_coef3;
	
    con_poly_coeff = {v_poly_coef3, v_poly_coef2,
			v_poly_coef1, v_poly_coef0 };

    crc_polynomial = con_poly_coeff [poly_size-1:0];
	
    if(crc_cfg % 2 == 0)
      reset_crc_reg = {poly_size{1'b0}};
    else
      reset_crc_reg = {poly_size{1'b1}};
	 
    
    if(crc_cfg == 0 || crc_cfg == 1) begin 
      x = {poly_size{1'b0}};
    end
    else if(crc_cfg == 6 || crc_cfg == 7) begin 
      x = {poly_size{1'b1}};
    end
    else begin
      if(crc_cfg == 2 || crc_cfg == 3) begin 
        x[0] = 1'b1;
      end
      else begin 
        x[0] = 1'b0;
      end 
       
      for(i=1;i<poly_size;i=i+1) begin 
        x[i] = ~x[i-1];
      end
    end
    
    crc_xor_constant = x;

    int_ok_calc = crc_xor_constant;
    i = 0;
    while(i < poly_size) begin 
      xor_or_not_ok = int_ok_calc[(poly_size-1)];
      int_ok_calc = { int_ok_calc[((poly_size-1)-1):0], 1'b0};
      if(xor_or_not_ok === 1'b1)
	int_ok_calc = (int_ok_calc ^ crc_polynomial);
      i = i + 1; 
    end
    crc_ok_info = int_ok_calc;
	
   end  // init_vars
`endif
   
   
`ifndef DW_DISABLE_CLK_MONITOR
`ifndef DW_SUPPRESS_WARN
  always @ (clk) begin : clk_monitor 
    if ( (clk !== 1'b0) && (clk !== 1'b1) && ($time > 0) )
      $display ("WARNING: %m:\n at time = %0t: Detected unknown value, %b, on clk input.", $time, clk);
    end // clk_monitor 
`endif
`endif

 // synopsys translate_on
      
endmodule
