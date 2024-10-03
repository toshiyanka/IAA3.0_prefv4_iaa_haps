//----------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intels prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//----------------------------------------------------------------------------

package hqm_system_func_pkg;

`include "hqm_system_def.vh"

import hqm_pkg::*, hqm_sif_pkg::*, hqm_system_type_pkg::*;

//------------------------------------------------------------
// TLP Decoding Helper Functions
//------------------------------------------------------------

function automatic logic f_hqm_ttype_has_data
  ( input logic [6:0] fmt_ttype );
   return ( fmt_ttype[6] );
endfunction

function automatic logic f_hqm_ttype_4dw_hdr
  ( input logic [6:0] fmt_ttype );
   return ( fmt_ttype[5] );
endfunction

function automatic logic f_hqm_ttype_is_memrdlk
  ( input hqm_pcie_type_e_t ttype );
   return (( ttype == HQM_MRDLK3 ) || ( ttype == HQM_MRDLK4 ));
endfunction
    
// Lock completion
// LA - 10/20/2008
function automatic logic f_hqm_ttype_is_cpllk
  ( input hqm_pcie_type_e_t ttype );
   return (( ttype == HQM_CPLLK ) || ( ttype == HQM_CPLDLK ));
endfunction
    
function automatic logic f_hqm_ttype_is_completion
  ( input hqm_pcie_type_e_t ttype );
   return (( ttype == HQM_CPL       ) || ( ttype == HQM_CPLD      ) ||
           ( ttype == HQM_CPLLK     ) || ( ttype == HQM_CPLDLK    ));
endfunction
   
// Msg3 - broadcast from root complex
// LA - 04/27/2011
function automatic logic f_hqm_msg3 (   
    hqm_pcie_hdr_t h,
    output logic drop
);
   hqm_pcie_type_e_t ttype;
   hqm_pcie_msg_code_e_t mcode;
   hqm_pcie_msg_route_e_t mroute;

   ttype  = hqm_pcie_type_e_t'( {h.pciemsg.fmt, h.pciemsg.ttype} & {2'b11,5'b11000} ); // Gate off route bits
   mroute = hqm_pcie_msg_route_e_t'(h.pciemsg.ttype[2:0]);
   mcode  = hqm_pcie_msg_code_e_t'(h.pciemsg.msgcode);
   drop   = (( ttype == HQM_MSG ) | ( ttype == HQM_MSGD )) & 
            ( mroute == HQM_BROADCAST ) & (mcode == HQM_VENDOR_TYPE1);

   return ((( ttype == HQM_MSG ) || ( ttype == HQM_MSGD )) && ( mroute == HQM_BROADCAST ) && ~drop);
endfunction

// Msg - term at recvr
// This function is used in the target block to UR/Drop any msg4 rcvd.
// LA - 08/14/2009
function automatic logic f_hqm_msg4_ur (    
    hqm_pcie_hdr_t h,
    output logic drop
);
   hqm_pcie_type_e_t ttype;
   hqm_pcie_msg_code_e_t mcode;
   hqm_pcie_msg_route_e_t mroute;
   logic supported_msg;

   ttype  = hqm_pcie_type_e_t'( {h.pciemsg.fmt, h.pciemsg.ttype} & {2'b11,5'b11000} ); // Gate off route bits
   mroute = hqm_pcie_msg_route_e_t'(h.pciemsg.ttype[2:0]);
   mcode  = hqm_pcie_msg_code_e_t'(h.pciemsg.msgcode);
   drop   = (( ttype == HQM_MSG ) | ( ttype == HQM_MSGD )) & 
            ( mroute == HQM_LOCAL ) & (mcode == HQM_VENDOR_TYPE1);

   // These messages are supported and will get handled by other functions/blocks.
   supported_msg =  ( mcode == HQM_ASRT_INTA )                  | ( mcode == HQM_ASRT_INTB )     |  // handled by Master
                    ( mcode == HQM_ASRT_INTC )                  | ( mcode == HQM_ASRT_INTD )     |  // handled by Master
                    ( mcode == HQM_DSRT_INTA )                  | ( mcode == HQM_DSRT_INTB )     |  // handled by Master
                    ( mcode == HQM_DSRT_INTC )                  | ( mcode == HQM_DSRT_INTD )     |  // handled by Master
                    ( mcode == HQM_ATTENTION_INDICATOR_ON )     | ( mcode == HQM_POWER_INDICATOR_ON )       | // handled by f_hqm_ignmsg_dec
                    ( mcode == HQM_ATTENTION_INDICATOR_BLINK )  | ( mcode == HQM_POWER_INDICATOR_BLINK )    | // handled by f_hqm_ignmsg_dec
                    ( mcode == HQM_ATTENTION_INDICATOR_OFF )    | ( mcode == HQM_POWER_INDICATOR_OFF )      | // handled by f_hqm_ignmsg_dec
                    ( mcode == HQM_ATTN_BUTTON )                | // handled by f_hqm_ignmsg_dec
                    ( mcode == HQM_LTR )                        | // handled by f_hqm_msg_ltr
                    ( mcode == HQM_PM_ACTIVE_STATE_NAK ) ; // handled by f_hqm_msg_pm_nak

   return ((( ttype == HQM_MSG ) || ( ttype == HQM_MSGD )) && 
           ( mroute == HQM_LOCAL ) && ~drop && ~supported_msg);
endfunction

// Msg - LTR
// LA - 04/15/2009
function automatic logic f_hqm_msg_ltr (    
    hqm_pcie_hdr_t h
);
   hqm_pcie_type_e_t ttype;
   hqm_pcie_msg_code_e_t mcode;
   hqm_pcie_msg_route_e_t mroute;

   ttype  = hqm_pcie_type_e_t'( {h.pciemsg.fmt, h.pciemsg.ttype} & {2'b11,5'b11000} ); // Gate off route bits
   mroute = hqm_pcie_msg_route_e_t'(h.pciemsg.ttype[2:0]);
   mcode  = hqm_pcie_msg_code_e_t'(h.pciemsg.msgcode);

   return (( ttype == HQM_MSG ) && ( mroute == HQM_LOCAL ) && ( mcode == HQM_LTR ));
endfunction

// LA - 08/20/2008
// PM Active State NAK
function automatic logic f_hqm_msg_pm_nak   
  ( logic [6:0] fmt_ttype,
    logic [7:0] msgcode );
   hqm_pcie_type_e_t ttype;
   hqm_pcie_msg_route_e_t mroute;
   hqm_pcie_msg_code_e_t mcode;

   ttype  = hqm_pcie_type_e_t'( fmt_ttype & {2'b11,5'b11000} ); // Gate off route bits
   mroute = hqm_pcie_msg_route_e_t'(fmt_ttype[2:0]);
   mcode  = hqm_pcie_msg_code_e_t'(msgcode);
   return ((ttype == HQM_MSG ) && (mroute == HQM_LOCAL) && (mcode == HQM_PM_ACTIVE_STATE_NAK));
endfunction

// LA - 11/05/2008
// PM turn off
function automatic logic f_hqm_msg_pm_turn_off  
  ( logic [6:0] fmt_ttype,
    logic [7:0] msgcode );
   hqm_pcie_type_e_t ttype;
   hqm_pcie_msg_route_e_t mroute;
   hqm_pcie_msg_code_e_t mcode;

   ttype  = hqm_pcie_type_e_t'( fmt_ttype & {2'b11,5'b11000} ); // Gate off route bits
   mroute = hqm_pcie_msg_route_e_t'(fmt_ttype[2:0]);
   mcode  = hqm_pcie_msg_code_e_t'(msgcode);
   return ((ttype == HQM_MSG) && (mroute == HQM_BROADCAST) && (mcode == HQM_PM_TURN_OFF));
endfunction

// Compute IOSF command parity
function automatic logic f_hqm_iosf_cmd_par (hqm_iosf_cmd_t iosf_cmd);  
    logic parity;
    parity =    (^iosf_cmd.cfmt) ^
                (^iosf_cmd.ctype) ^
                (^iosf_cmd.ctc) ^
                (^iosf_cmd.cth) ^
                (^iosf_cmd.cep) ^
                (^iosf_cmd.cro) ^
                (^iosf_cmd.cns) ^
                (^iosf_cmd.cido) ^
                (^iosf_cmd.cat) ^
                (^iosf_cmd.clength) ^
                (^iosf_cmd.crqid) ^
                (^iosf_cmd.ctag) ^
                (^iosf_cmd.clbe) ^
                (^iosf_cmd.cfbe) ^
                (^iosf_cmd.caddress) ^
                (^iosf_cmd.ctd) ^
                (^iosf_cmd.crsvd0_7) ^
                (^iosf_cmd.crsvd1_7) ^
                (^iosf_cmd.crsvd1_3) ^
                (^iosf_cmd.crsvd1_1) ;
    return(parity);
endfunction

// Calculating byte count
//  From Table 2-22 of PCIe Spec
function automatic logic [11:0] f_hqm_pcie_bytecnt 
  ( input logic [3:0] fbe,
    input logic [3:0] lbe,
    input logic [9:0] len );
   begin
      logic [11:0] bc;
      casez ( { fbe, lbe } )
        8'b1??1_0000: bc = 12'd4;
        8'b01?1_0000: bc = 12'd3;
        8'b1?10_0000: bc = 12'd3;
        8'b0011_0000: bc = 12'd2;
        8'b0110_0000: bc = 12'd2;
        8'b1100_0000: bc = 12'd2;
        8'b0001_0000: bc = 12'd1;
        8'b0010_0000: bc = 12'd1;
        8'b0100_0000: bc = 12'd1;
        8'b1000_0000: bc = 12'd1;
        8'b0000_0000: bc = 12'd1;
        8'b???1_1???: bc = {len,2'b00};         //len * 4;      
        8'b???1_01??: bc = {len,2'b00} - 12'd1; //(len * 4) - 1;
        8'b???1_001?: bc = {len,2'b00} - 12'd2; //(len * 4) - 2;
        8'b???1_0001: bc = {len,2'b00} - 12'd3; //(len * 4) - 3;
        8'b??10_1???: bc = {len,2'b00} - 12'd1; //(len * 4) - 1;
        8'b??10_01??: bc = {len,2'b00} - 12'd2; //(len * 4) - 2;
        8'b??10_001?: bc = {len,2'b00} - 12'd3; //(len * 4) - 3;
        8'b??10_0001: bc = {len,2'b00} - 12'd4; //(len * 4) - 4;
        8'b?100_1???: bc = {len,2'b00} - 12'd2; //(len * 4) - 2;
        8'b?100_01??: bc = {len,2'b00} - 12'd3; //(len * 4) - 3;
        8'b?100_001?: bc = {len,2'b00} - 12'd4; //(len * 4) - 4;
        8'b?100_0001: bc = {len,2'b00} - 12'd5; //(len * 4) - 5;
        8'b1000_1???: bc = {len,2'b00} - 12'd3; //(len * 4) - 3;
        8'b1000_01??: bc = {len,2'b00} - 12'd4; //(len * 4) - 4;
        8'b1000_001?: bc = {len,2'b00} - 12'd5; //(len * 4) - 5;
        8'b1000_0001: bc = {len,2'b00} - 12'd6; //(len * 4) - 6;
        default:      bc = 12'd0;
      endcase // casez ( { fbe, lbe } )
      f_hqm_pcie_bytecnt = bc;
   end
endfunction // logic

// Calculating lower address field
//  From Table 2-23 of PCIe Spec
function automatic logic [6:0] f_hqm_pcie_lowaddr
  ( input logic [3:0] fbe,
    input logic [6:2] addr );
   begin
      casez ( fbe )
        4'b0000: f_hqm_pcie_lowaddr = { addr, 2'b00 };
        4'b???1: f_hqm_pcie_lowaddr = { addr, 2'b00 };
        4'b??10: f_hqm_pcie_lowaddr = { addr, 2'b01 };
        4'b?100: f_hqm_pcie_lowaddr = { addr, 2'b10 };
        4'b1000: f_hqm_pcie_lowaddr = { addr, 2'b11 };
      endcase // casez ( fbe )
   end
endfunction // logic

//----------------------------------------------------------------------------
// Functions to return number of header and data credits needed for a request
//----------------------------------------------------------------------------

// Function returns the number of headers based on request
function automatic logic [6:0] f_hqmrt_hdr_cnt
  ( input hqm_pcie_hdr_t hdr,
    input logic           ncc );
   begin
      hqm_pcie_type_e_t hdr_cnt_ttype;
      hdr_cnt_ttype = hqm_pcie_type_e_t'({ hdr.pcie32.fmt, hdr.pcie32.ttype });
      if (( hdr_cnt_ttype == HQM_MRD3 ) || ( hdr_cnt_ttype == HQM_LTMRD3) || ( hdr_cnt_ttype == HQM_MRDLK3 ))
        return f_hqmrt_hcdt_cnt(hdr.pcie32.len,hdr.pcie32.addr[5:2],ncc);
      if (( hdr_cnt_ttype == HQM_MRD4 ) || ( hdr_cnt_ttype == HQM_LTMRD4) || ( hdr_cnt_ttype == HQM_MRDLK4 ))
        return f_hqmrt_hcdt_cnt(hdr.pcie64.len,hdr.pcie64.addr[5:2],ncc);
      return 7'd1;
   end
endfunction
  
// Function returns the number of data credits based on request
function automatic logic [8:0] f_hqmrt_data_cnt
  ( input hqm_pcie_hdr_t hdr,
    input logic           ncc );
   begin
      hqm_pcie_type_e_t dat_cnt_ttype;
      dat_cnt_ttype = hqm_pcie_type_e_t'({ hdr.pcie32.fmt, hdr.pcie32.ttype });
      if (( dat_cnt_ttype == HQM_MRD3 ) || ( dat_cnt_ttype == HQM_LTMRD3 ) || ( dat_cnt_ttype == HQM_MRDLK3 ))
        return f_hqmrt_dcdt_cnt(hdr.pcie32.len,hdr.pcie32.addr[3:2],ncc);
      if (( dat_cnt_ttype == HQM_MRD4 ) || ( dat_cnt_ttype == HQM_LTMRD4 ) || ( dat_cnt_ttype == HQM_MRDLK4 ))
        return f_hqmrt_dcdt_cnt(hdr.pcie64.len,hdr.pcie64.addr[3:2],ncc);
      if (( dat_cnt_ttype == HQM_FETCHADD3 ) || ( dat_cnt_ttype == HQM_FETCHADD4 ) ||
          ( dat_cnt_ttype == HQM_SWAP3     ) || ( dat_cnt_ttype == HQM_SWAP4     ) ||
          ( dat_cnt_ttype == HQM_CAS3      ) || ( dat_cnt_ttype == HQM_CAS4      ) ||
          ( dat_cnt_ttype == HQM_IORD      ) || ( dat_cnt_ttype == HQM_CFGRD0    ) ||
          ( dat_cnt_ttype == HQM_CFGRD1    ))
        return 9'd1;
      return 9'd0; // Zero for IOWr, & CfgWr0/1
   end
endfunction

// Function returns the number of headers based on length and lower address
function automatic logic [6:0] f_hqmrt_hcdt_cnt
  ( input      logic [9:0] len,
    input      logic [5:2] laddr,
    input      logic       ncc );
   begin
      logic [10:0] dw_cnt;

      // DW cnt from offset of cache line
      dw_cnt = (( len == '0 ) ? 11'd1024 : {1'b0,len} ) + {7'd0,laddr[5:2]};
      // Count cache lines it covers
      //  This is a divide by 64B (16DW) with rounding
      f_hqmrt_hcdt_cnt = ( ncc == 1'b0 ) ? (dw_cnt[10:4] +
                                            ((|dw_cnt[3:0]) ? 7'd1 : 7'd0)) :
                         // With ncc, only one completion expected
                         7'd1;

   end
endfunction

// Function returns the number of data credits based on length and lower address
function automatic logic [8:0] f_hqmrt_dcdt_cnt
  ( input logic [9:0] len,
    input logic [3:2] laddr,
    input logic       ncc );
   begin
      logic [10:0] dw_cnt;
      
      // DW cnt from offset for data credit consumed cnt
      dw_cnt = (( len == '0 ) ? 11'd1024 : {1'b0,len} ) + {9'd0,laddr[3:2]};
      // 4DW per credit so divide by 4 with rounding
      f_hqmrt_dcdt_cnt = dw_cnt[10:2] + ((|dw_cnt[1:0]) ? 9'd1 : 9'd0);
      f_hqmrt_dcdt_cnt = ( ncc == 1'b0 ) ? (dw_cnt[10:2] + 
                                            ((|dw_cnt[1:0]) ? 9'd1 : 9'd0)) :
                         // With ncc, len <= 16 dwords and aligned
                         ( {6'd0,len[4:2]} + ((|len[1:0]) ? 9'd1 : 9'd0));
   end
endfunction

// Function to decode the portmode
function automatic void f_hqm_expand_portmode   
  ( input  int unsigned HQMIOSF_PORTS,
    input  int unsigned PORTMODE_OR,
    input  int unsigned PORTMODE_AND,
    input  int unsigned portmode,
    output logic         qw,
    output logic [1:0]   dw,
    output logic [3:0]   sw );
   begin
      int unsigned pm;
      pm = ( portmode | PORTMODE_OR ) & PORTMODE_AND;
      qw = '0; dw = '0; sw = '0;
      if ( HQMIOSF_PORTS == 4 ) begin
         qw    = ( pm[3:0] == 4'b0001 );
         dw[0] = ( pm[2:0] == 3'b101  );
         dw[1] = ( pm[3:2] == 2'b01   );
         sw[0] = ( pm[1:0] == 2'b11   );
         sw[1] = ( pm[1:0] == 2'b11   );
         sw[2] = ( pm[3:2] == 2'b11   );
         sw[3] = ( pm[3:2] == 2'b11   );
      end else if ( HQMIOSF_PORTS == 2 ) begin
         dw[0] = ( pm[1:0] == 2'b01 );
         sw[0] = ( pm[1:0] != 2'b01 );
         sw[1] = ( pm[1:0] != 2'b01 );
      end else if ( HQMIOSF_PORTS == 1 ) begin
         sw[0] = 1'b1;
      end
   end
endfunction

///////////////////////////////////////////////////////////////
// Function to decode Flowclass
//////////////////////////////////////////////////////////////
// Modified from iosf_swf

function automatic logic [1:0] f_hqm_flowclass ( logic [1:0]fmt, logic [4:0]ttype );
      f_hqm_flowclass = 2'b00;
      case({fmt,ttype}) 
      // lookup C possibilities
        `HQM_CPL,       `HQM_CPLD,    `HQM_CPLLK,   `HQM_CPLDLK
            : f_hqm_flowclass = `HQM_FC_C;
      // lookup NP possibilities
        `HQM_MRD32,     `HQM_MRD64,   `HQM_LTMRD32, `HQM_LTMRD64,
        `HQM_NPMWR32,   `HQM_NPMWR64,
        `HQM_MRDLK32,   `HQM_MRDLK64, `HQM_IORD,    `HQM_IOWR,
        `HQM_CFGRD0,    `HQM_CFGWR0,  `HQM_CFGRD1,  `HQM_CFGWR1
            : f_hqm_flowclass = `HQM_FC_NP;
      // lookup P possibilities
        `HQM_MWR32,     `HQM_MWR64,   `HQM_LTMWR32, `HQM_LTMWR64,
        `HQM_MSG_RC,    `HQM_MSG_AD,  `HQM_MSG_ID,  `HQM_MSG_BC,
        `HQM_MSG_TERM,  `HQM_MSG_5,   `HQM_MSG_6,   `HQM_MSG_7,
        `HQM_MSGD_RC,   `HQM_MSGD_AD, `HQM_MSGD_ID, `HQM_MSGD_BC,
        `HQM_MSGD_TERM, `HQM_MSGD_5,  `HQM_MSGD_6,  `HQM_MSGD_7
            : f_hqm_flowclass = `HQM_FC_P;
        default 
            : f_hqm_flowclass = 2'b00; // jbdiethe copied the default for litra otherwise it fatals
      endcase
endfunction // f_hqm_flowclass

//////////////////////////////////////////////////////////////
// Functions to convert IOSF cmd to PCIE header
/////////////////////////////////////////////////////////////

function automatic hqm_pciecfg_hdr_t f_hqm_iosf_pcie_cfghdr 
(input hqm_iosf_tgt_cmd_t iosf_cmd );
 hqm_pciecfg_hdr_t cfg_hdr;

    begin
            cfg_hdr.rsvd0   = iosf_cmd.trsvd1_1;
            cfg_hdr.fmt     = iosf_cmd.tfmt;
            cfg_hdr.ttype   = iosf_cmd.ttype;
    // Byte 1
            cfg_hdr.tc  = iosf_cmd.ttc;
            cfg_hdr.rsvd2   = iosf_cmd.trsvd1_3;
        cfg_hdr.rsvd3   = iosf_cmd.trsvd1_7; 
        cfg_hdr.rsvd4   = iosf_cmd.trsvd0_7;
            cfg_hdr.oh  = iosf_cmd.tth;
                cfg_hdr.attr2   = iosf_cmd.tido;
    // Byte 2-3
                // LA - HSD2619460 - Adding IOSF 1.0 support of ECRC generation.
            cfg_hdr.td      = iosf_cmd.tecrc_generate ? 1'b1 : iosf_cmd.ttd;
            cfg_hdr.ep  = iosf_cmd.tep;
            cfg_hdr.attr    = {iosf_cmd.tro,iosf_cmd.tns};
            cfg_hdr.at      = iosf_cmd.tat;
            cfg_hdr.len = iosf_cmd.tlength;
    // Byte 4-5
            cfg_hdr.rqid    = iosf_cmd.trqid;
    // Byte 6
            cfg_hdr.tag = iosf_cmd.ttag;
    // Byte 7
            cfg_hdr.lbe = iosf_cmd.tlbe;
            cfg_hdr.fbe = iosf_cmd.tfbe;
    // Byte 8
            cfg_hdr.bus = iosf_cmd.taddress[31:24];
    // Byte 9
            cfg_hdr.dev = iosf_cmd.taddress[23:19];
            cfg_hdr.funcn   = iosf_cmd.taddress[18:16];
    // Byte 10
            cfg_hdr.rsvd5   = iosf_cmd.taddress[15];
            cfg_hdr.rsvd6   = iosf_cmd.taddress[14];
            cfg_hdr.rsvd7   = iosf_cmd.taddress[13];
            cfg_hdr.rsvd8   = iosf_cmd.taddress[12];
            cfg_hdr.extregnum   = iosf_cmd.taddress[11:8];
    // Byte 11
            cfg_hdr.regnum  = iosf_cmd.taddress[7:2];
            cfg_hdr.rsvd9   = iosf_cmd.taddress[1];
            cfg_hdr.rsvd10  = iosf_cmd.taddress[0];
    // Byte 12-15
            cfg_hdr.rsvd11  = 32'b0;
      return (cfg_hdr);
     end 
endfunction // f_hqm_iosf_pcie_cfghdr  



function automatic hqm_pciemem32_hdr_t f_hqm_iosf_pcie_mem32hdr (
   input hqm_iosf_tgt_cmd_t iosf_cmd);
  hqm_pciemem32_hdr_t mem32_hdr ;
        begin
            mem32_hdr.rsvd0      = iosf_cmd.trsvd1_1;
            mem32_hdr.fmt        = iosf_cmd.tfmt ;
            mem32_hdr.ttype      = iosf_cmd.ttype;
    // Byte 1
            mem32_hdr.tc         = iosf_cmd.ttc;
            mem32_hdr.rsvd2      = iosf_cmd.trsvd1_3;
        mem32_hdr.rsvd3      = iosf_cmd.trsvd1_7;
        mem32_hdr.rsvd4      = iosf_cmd.trsvd0_7;
            mem32_hdr.oh         = iosf_cmd.tth;
                mem32_hdr.attr2      = iosf_cmd.tido;
    // Byte 2-3
                // LA - HSD2619460 - Adding IOSF 1.0 support of ECRC generation.
            mem32_hdr.td         = iosf_cmd.tecrc_generate ? 1'b1 : iosf_cmd.ttd;
            mem32_hdr.ep         = iosf_cmd.tep;
            mem32_hdr.attr       = {iosf_cmd.tro,iosf_cmd.tns};
            mem32_hdr.at         = iosf_cmd.tat;
            mem32_hdr.len        = iosf_cmd.tlength;
    // Byte 4-5
            mem32_hdr.rqid       = iosf_cmd.trqid;
    // Byte 6
            mem32_hdr.tag        = iosf_cmd.ttag;
    // Byte 7
            mem32_hdr.lbe        = iosf_cmd.tlbe;
            mem32_hdr.fbe        = iosf_cmd.tfbe;
    // Byte 8 thru 11
            mem32_hdr.addr       = iosf_cmd.taddress[31:2];
            mem32_hdr.rsvd5      =  iosf_cmd.taddress[1];
        mem32_hdr.rsvd6     = iosf_cmd.taddress[0];
    // Byte 12-15
            mem32_hdr.rsvd7      = 32'b0;
       return (mem32_hdr);
        end     
endfunction // f_hqm_iosf_pcie_mem32hdr

////////////////////////////////////////////////////////////////////////////////

function automatic hqm_pciemem64_hdr_t f_hqm_iosf_pcie_mem64hdr (
   input hqm_iosf_tgt_cmd_t iosf_cmd);
 hqm_pciemem64_hdr_t mem64_hdr ;
        begin
    // Byte 0
            mem64_hdr.rsvd0      = iosf_cmd.trsvd1_1;
            mem64_hdr.fmt        = iosf_cmd.tfmt ;
            mem64_hdr.ttype      = iosf_cmd.ttype;
    // Byte 1
            mem64_hdr.tc         = iosf_cmd.ttc;
            mem64_hdr.rsvd2      = iosf_cmd.trsvd1_3;
        mem64_hdr.rsvd3      = iosf_cmd.trsvd1_7;
        mem64_hdr.rsvd4      = iosf_cmd.trsvd0_7;
        mem64_hdr.oh         = iosf_cmd.tth;
        mem64_hdr.attr2      = iosf_cmd.tido;
    // Byte 2-3
                // LA - HSD2619460 - Adding IOSF 1.0 support of ECRC generation.
            mem64_hdr.td         = iosf_cmd.tecrc_generate ? 1'b1 : iosf_cmd.ttd;
            mem64_hdr.ep         = iosf_cmd.tep;
            mem64_hdr.attr       = {iosf_cmd.tro,iosf_cmd.tns};
            mem64_hdr.at         = iosf_cmd.tat;
            mem64_hdr.len        = iosf_cmd.tlength;
    // Byte 4-5
            mem64_hdr.rqid       = iosf_cmd.trqid;
    // Byte 6
            mem64_hdr.tag        = iosf_cmd.ttag;
    // Byte 7
            mem64_hdr.lbe        = iosf_cmd.tlbe;
            mem64_hdr.fbe        = iosf_cmd.tfbe;
    // Byte 8 thru 15
            mem64_hdr.addr       = iosf_cmd.taddress[63:2];
            mem64_hdr.rsvd5      = iosf_cmd.taddress[1];
        mem64_hdr.rsvd6      = iosf_cmd.taddress[0];

     return (mem64_hdr);
       end
endfunction //f_hqm_iosf_pcie_mem64hdr
////////////////////////////////////////////////////////////////////////////////
function automatic hqm_pcieatomic32_hdr_t f_hqm_iosf_pcie_atm32hdr (
   input hqm_iosf_tgt_cmd_t iosf_cmd);
  hqm_pcieatomic32_hdr_t atm32_hdr ;
        begin
            atm32_hdr.rsvd0      = iosf_cmd.trsvd1_1;
            atm32_hdr.fmt        = iosf_cmd.tfmt ;
            atm32_hdr.ttype      = iosf_cmd.ttype;
    // Byte 1
            atm32_hdr.tc         = iosf_cmd.ttc;
            atm32_hdr.rsvd2      = iosf_cmd.trsvd1_3;
        atm32_hdr.rsvd3      = iosf_cmd.trsvd1_7;
        atm32_hdr.rsvd4      = iosf_cmd.trsvd0_7;
            atm32_hdr.oh         = iosf_cmd.tth;
            atm32_hdr.attr2      = iosf_cmd.tido;
    // Byte 2-3
                // LA - HSD2619460 - Adding IOSF 1.0 support of ECRC generation.
            atm32_hdr.td         = iosf_cmd.tecrc_generate ? 1'b1 : iosf_cmd.ttd;
            atm32_hdr.ep         = iosf_cmd.tep;
            atm32_hdr.attr       = {iosf_cmd.tro,iosf_cmd.tns};
            atm32_hdr.at         = iosf_cmd.tat;
            atm32_hdr.len        = iosf_cmd.tlength;
    // Byte 4-5
            atm32_hdr.rqid       = iosf_cmd.trqid;
    // Byte 6
            atm32_hdr.tag        = iosf_cmd.ttag;
    // Byte 7
            atm32_hdr.lbe        = iosf_cmd.tlbe;
            atm32_hdr.fbe        = iosf_cmd.tfbe;
    // Byte 8 thru 11
            atm32_hdr.addr       = iosf_cmd.taddress[31:2];
            atm32_hdr.rsvd5      =  iosf_cmd.taddress[1];
        atm32_hdr.rsvd6     = iosf_cmd.taddress[0];
    // Byte 12-15
            atm32_hdr.rsvd7      = 32'b0;
       return (atm32_hdr);
        end     
endfunction // f_hqm_iosf_pcie_atm32hdr

////////////////////////////////////////////////////////////////////////////////

function automatic hqm_pcieatomic64_hdr_t f_hqm_iosf_pcie_atm64hdr (
   input hqm_iosf_tgt_cmd_t iosf_cmd);
 hqm_pcieatomic64_hdr_t atm64_hdr ;
        begin
    // Byte 0
            atm64_hdr.rsvd0      = iosf_cmd.trsvd1_1;
            atm64_hdr.fmt        = iosf_cmd.tfmt ;
            atm64_hdr.ttype      = iosf_cmd.ttype;
    // Byte 1
            atm64_hdr.tc         = iosf_cmd.ttc;
            atm64_hdr.rsvd2      = iosf_cmd.trsvd1_3;
        atm64_hdr.rsvd3      = iosf_cmd.trsvd1_7;
        atm64_hdr.rsvd4      = iosf_cmd.trsvd0_7;
        atm64_hdr.oh         = iosf_cmd.tth;
        atm64_hdr.attr2      = iosf_cmd.tido;
    // Byte 2-3
                // LA - HSD2619460 - Adding IOSF 1.0 support of ECRC generation.
            atm64_hdr.td         = iosf_cmd.tecrc_generate ? 1'b1 : iosf_cmd.ttd;
            atm64_hdr.ep         = iosf_cmd.tep;
            atm64_hdr.attr       = {iosf_cmd.tro,iosf_cmd.tns};
            atm64_hdr.at         = iosf_cmd.tat;
            atm64_hdr.len        = iosf_cmd.tlength;
    // Byte 4-5
            atm64_hdr.rqid       = iosf_cmd.trqid;
    // Byte 6
            atm64_hdr.tag        = iosf_cmd.ttag;
    // Byte 7
            atm64_hdr.lbe        = iosf_cmd.tlbe;
            atm64_hdr.fbe        = iosf_cmd.tfbe;
    // Byte 8 thru 15
            atm64_hdr.addr       = iosf_cmd.taddress[63:2];
            atm64_hdr.rsvd5      = iosf_cmd.taddress[1];
        atm64_hdr.rsvd6      = iosf_cmd.taddress[0];

     return (atm64_hdr);
       end
endfunction //f_hqm_iosf_pcie_atm64hdr

////////////////////////////////////////////////////////////////////////////////
function automatic hqm_pciemsg_hdr_t f_hqm_iosf_pcie_msghdr (
   input hqm_iosf_tgt_cmd_t iosf_cmd);
  hqm_pciemsg_hdr_t msg_hdr ;
        begin

            msg_hdr.rsvd0      = iosf_cmd.trsvd1_1;
            msg_hdr.fmt        = iosf_cmd.tfmt;
            msg_hdr.ttype      = iosf_cmd.ttype;
    // Byte 1
            msg_hdr.tc         = iosf_cmd.ttc;
            msg_hdr.rsvd2      = iosf_cmd.trsvd1_3;
        msg_hdr.rsvd3      = iosf_cmd.trsvd1_7;
        msg_hdr.rsvd4      = iosf_cmd.trsvd0_7;
            msg_hdr.oh         = iosf_cmd.tth;
            msg_hdr.attr2      = iosf_cmd.tido;
    // Byte 2-3
                // LA - HSD2619460 - Adding IOSF 1.0 support of ECRC generation.
            msg_hdr.td         = iosf_cmd.tecrc_generate ? 1'b1 : iosf_cmd.ttd;
            msg_hdr.ep         = iosf_cmd.tep;
            msg_hdr.attr       = {iosf_cmd.tro,iosf_cmd.tns};
            msg_hdr.at         = iosf_cmd.tat;
            msg_hdr.len        = iosf_cmd.tlength;
    // Byte 4-5
            msg_hdr.rqid       = iosf_cmd.trqid;
    // Byte 6
            msg_hdr.tag        = iosf_cmd.ttag;
    // Byte 7
            msg_hdr.msgcode    = {iosf_cmd.tlbe, iosf_cmd.tfbe};
    // Byte 8 thru 15
                msg_hdr.rsvd5[63:32]= iosf_cmd.taddress[31:0];
                msg_hdr.rsvd5[31:0] = iosf_cmd.taddress[63:32];
             //msg_hdr.rsvd5      = iosf_cmd.taddress;
         return (msg_hdr);
       end
endfunction // f_hqm_iosf_pcie_msghdr
////////////////////////////////////////////////////////////////////////////////


function automatic hqm_pcieio_hdr_t f_hqm_iosf_pcie_iohdr (
   input hqm_iosf_tgt_cmd_t iosf_cmd);
 hqm_pcieio_hdr_t io_hdr ;
        begin

    // Byte 0
            io_hdr.rsvd0    = iosf_cmd.trsvd1_1;
            io_hdr.fmt      = iosf_cmd.tfmt ;
            io_hdr.ttype    = iosf_cmd.ttype;
    // Byte 1
            io_hdr.tc       = iosf_cmd.ttc;
            io_hdr.rsvd2    = iosf_cmd.trsvd1_3; 
        io_hdr.rsvd3    = iosf_cmd.trsvd1_7; 
        io_hdr.rsvd4    = iosf_cmd.trsvd0_7;
            io_hdr.oh       = iosf_cmd.tth;
            io_hdr.attr2    = iosf_cmd.tido;
    // Byte 2-3
                // LA - HSD2619460 - Adding IOSF 1.0 support of ECRC generation.
            io_hdr.td       = iosf_cmd.tecrc_generate ? 1'b1 : iosf_cmd.ttd;
            io_hdr.ep       = iosf_cmd.tep;
            io_hdr.attr     = {iosf_cmd.tro,iosf_cmd.tns};
            io_hdr.at       = iosf_cmd.tat;
            io_hdr.len      = iosf_cmd.tlength;
    // Byte 4-5
            io_hdr.rqid     = iosf_cmd.trqid;
    // Byte 6
            io_hdr.tag      = iosf_cmd.ttag;
    // Byte
            io_hdr.lbe      = iosf_cmd.tlbe;
            io_hdr.fbe      = iosf_cmd.tfbe;
    // Byte 8 thru 11
            io_hdr.addr     = iosf_cmd.taddress[31:2];
            io_hdr.rsvd5    = iosf_cmd.taddress[1]; 
        io_hdr.rsvd6    = iosf_cmd.taddress[0];
    // Byte 12-15
            io_hdr.rsvd7    = 32'b0;

         return (io_hdr); 
       end
endfunction // f_hqm_iosf_pcie_iohdr
////////////////////////////////////////////////////////////////////////////////
function automatic hqm_pciecpl_hdr_t f_hqm_iosf_pcie_cplhdr (
   input hqm_iosf_tgt_cmd_t iosf_cmd); 
    hqm_pciecpl_hdr_t cpl_hdr ;
        begin
    // Byte 0
            cpl_hdr.rsvd0      = iosf_cmd.trsvd1_1;
            cpl_hdr.fmt        = iosf_cmd.tfmt ;
            cpl_hdr.ttype      = iosf_cmd.ttype;
    // Byte 1
            cpl_hdr.tc         = iosf_cmd.ttc;
            cpl_hdr.rsvd2      = iosf_cmd.trsvd1_3;
        cpl_hdr.rsvd3      = iosf_cmd.trsvd1_7;
        cpl_hdr.rsvd4      = iosf_cmd.trsvd0_7;
            cpl_hdr.oh         = iosf_cmd.tth;
            cpl_hdr.attr2      = iosf_cmd.tido;
    // Byte 2-3
                // LA - HSD2619460 - Adding IOSF 1.0 support of ECRC generation.
            cpl_hdr.td         = iosf_cmd.tecrc_generate ? 1'b1 : iosf_cmd.ttd;
            cpl_hdr.ep         = iosf_cmd.tep;
            cpl_hdr.attr       = {iosf_cmd.tro,iosf_cmd.tns};
            cpl_hdr.at         = iosf_cmd.tat;
            cpl_hdr.len        = iosf_cmd.tlength;
    // Byte 4-5
            cpl_hdr.cplid   = iosf_cmd.taddress[31:16];
    // Byte 6-7
            cpl_hdr.cplstat    = iosf_cmd.tfbe[2:0];
            cpl_hdr.bcm = iosf_cmd.tfbe[3];
            cpl_hdr.bytecnt[3:0] = iosf_cmd.tlbe;
        cpl_hdr.bytecnt[11:4] = iosf_cmd.taddress[15:8];
    // Byte 8-9
            cpl_hdr.rqid       = iosf_cmd.trqid;
    // Byte 10
            cpl_hdr.tag        = iosf_cmd.ttag;
    // Byte 11
            cpl_hdr.rsvd5      = iosf_cmd.taddress[7];
            cpl_hdr.lowaddr = iosf_cmd.taddress[6:0];
    // Byte 12-15
            cpl_hdr.rsvd6   = 32'b0;

        return (cpl_hdr);
      end
endfunction // f_hqm_iosf_pcie_cplhdr

////////////////////////////////////////////////////////////////////////////////////
// Function to compute bytecount for Memory and Atomic Operations that return UR/CA
////////////////////////////////////////////////////////////////////////////////////

function automatic logic [11:0] f_hqm_bytecount (

input [9:0] len,
input [3:0] lbe,
input [3:0] fbe);

      casez ({fbe,lbe})
           8'b1??10000 : f_hqm_bytecount = 12'd4;
           8'b01?10000 : f_hqm_bytecount = 12'd3;
           8'b1?100000 : f_hqm_bytecount = 12'd3;
           8'b00110000 : f_hqm_bytecount = 12'd2;
           8'b01100000 : f_hqm_bytecount = 12'd2;
           8'b11000000 : f_hqm_bytecount = 12'd2;
           8'b00010000 : f_hqm_bytecount = 12'd1;
           8'b00100000 : f_hqm_bytecount = 12'd1;
           8'b01000000 : f_hqm_bytecount = 12'd1;
           8'b10000000 : f_hqm_bytecount = 12'd1;
           8'b00000000 : f_hqm_bytecount = 12'd1;
           8'b???11??? : f_hqm_bytecount = {len,2'b0};
           8'b???101?? : f_hqm_bytecount = {len,2'b0} - 12'd1;
           8'b???1001? : f_hqm_bytecount = {len,2'b0} - 12'd2;
           8'b???10001 : f_hqm_bytecount = {len,2'b0} - 12'd3;
           8'b??101??? : f_hqm_bytecount = {len,2'b0} - 12'd1; 
           8'b??1001?? : f_hqm_bytecount = {len,2'b0} - 12'd2;
           8'b??10001? : f_hqm_bytecount = {len,2'b0} - 12'd3;
           8'b??100001 : f_hqm_bytecount = {len,2'b0} - 12'd4;
           8'b?1001??? : f_hqm_bytecount = {len,2'b0} - 12'd2;
           8'b?10001?? : f_hqm_bytecount = {len,2'b0} - 12'd3;
           8'b?100001? : f_hqm_bytecount = {len,2'b0} - 12'd4;
           8'b?1000001 : f_hqm_bytecount = {len,2'b0} - 12'd5;
           8'b10001??? : f_hqm_bytecount = {len,2'b0} - 12'd3;
           8'b100001?? : f_hqm_bytecount = {len,2'b0} - 12'd4;
           8'b1000001? : f_hqm_bytecount = {len,2'b0} - 12'd5;
           8'b10000001 : f_hqm_bytecount = {len,2'b0} - 12'd6;
           default     : f_hqm_bytecount = 12'd0; 
     endcase   
endfunction // f_hqm_bytecount

///////////////////////////////////////////////////////////////////////////////////////
// Function to compute Lower Address for Memory transactions that return UR/CA
///////////////////////////////////////////////////////////////////////////////////////

function automatic logic [6:0] f_hqm_loweraddr (

input [4:0] address,
input [3:0] fbe);

        casez (fbe)
         4'b0000 : f_hqm_loweraddr = {address, 2'b00};
         4'b???1 : f_hqm_loweraddr = {address, 2'b00};
         4'b??10 : f_hqm_loweraddr = {address, 2'b01};
         4'b?100 : f_hqm_loweraddr = {address, 2'b10};
         4'b1000 : f_hqm_loweraddr = {address, 2'b11};
        endcase
endfunction // f_hqm_loweraddr   
  
 

/////////////////////////////////////////////////////////////////////
//  Arbitration Function
////////////////////////////////////////////////////////////////////

function automatic int f_hqm_rr_arb (   
  int arb_winner, logic [(HQMIOSF_VC*HQMIOSF_PORTS*3)-1:0] enable);
  int  arb_winner_nxt;
    begin
        for (int j=1; j < (HQMIOSF_VC*HQMIOSF_PORTS*3); j++) begin
         if (enable [arb_winner+j] == 1'b1) begin
                if((arb_winner+j)<(HQMIOSF_VC*HQMIOSF_PORTS*3)) arb_winner_nxt = arb_winner+j;
            else arb_winner_nxt = ((arb_winner+j)-(HQMIOSF_VC*HQMIOSF_PORTS*3)); end
                else arb_winner_nxt = 0;  
        end
        return (arb_winner_nxt);
 end
endfunction // f_hqm_rr_arb

////////////////////////////////////////////////////////////////////
// 2 bit binary value from integer : Credit rtype decode from index value
///////////////////////////////////////////////////////////////////
function automatic logic[1:0] f_hqm_rtype_func (
 input int index);
     case (index)
        0:       f_hqm_rtype_func = `HQM_FC_P;
        1:       f_hqm_rtype_func = `HQM_FC_NP;
        2:       f_hqm_rtype_func = `HQM_FC_C;
        default: f_hqm_rtype_func = `HQM_FC_RSV;
     endcase
endfunction // f_hqm_rtype_func         

////////////////////////////////////////////////////////////////////
// Channel ID decode Functions
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// Index value from binary: Channel ID decode 
////////////////////////////////////////////////////////////////////
function automatic int f_hqm_chid_index_func (  
 input logic[2:0] vc, logic[1:0] numports);
    int chid_index, sum1, sum2, sum3, sum4, sum5;   
    begin
    if (vc[2] == 1'b1) sum5=16; else sum5=0;
    if (vc[1] == 1'b1) sum4=8; else sum4=0;
    if (vc[0] == 1'b1) sum3=4; else sum3=0;
        if (numports[1] == 1'b1) sum2=2; else sum2=0;
        if (numports[0] == 1'b1) sum1=1; else sum1=0;
        chid_index = (sum5+sum4+sum3+sum2+sum1);
       end
return (chid_index);
endfunction //f_hqm_chid_index_func

//////////////////////////////////////////////
// Integer chid index from vc and ports
//////////////////////////////////////////////
 
function automatic logic[2:0] f_hqm_chid_func_1 (
input logic[`HQM_L2CEIL(HQMIOSF_VC*HQMIOSF_PORTS)-1:0] chid,
output logic[1:0] chid_lsb); 
logic [2:0] chid_msb;
        begin
        {chid_msb,chid_lsb} = {{(5-`HQM_L2CEIL(HQMIOSF_VC*HQMIOSF_PORTS)){1'b0}}, chid};
        return(chid_msb);
       end
endfunction //f_hqm_chid_func_1


///////////////////////////////////////////////

///////////////////////////////////////////////
// 5 bit Binary value from integer index
////////////////////////////////////////////////
function automatic logic[4:0] f_hqm_chid_func_2 (
input int index);
        case (index)
             0       : f_hqm_chid_func_2 = 5'b000_00 ;
             1       : f_hqm_chid_func_2 = 5'b000_01 ;
             2       : f_hqm_chid_func_2 = 5'b000_10 ;
             3       : f_hqm_chid_func_2 = 5'b000_11 ;
             4       : f_hqm_chid_func_2 = 5'b001_00 ;
             5       : f_hqm_chid_func_2 = 5'b001_01 ;
             6       : f_hqm_chid_func_2 = 5'b001_10 ;
             7       : f_hqm_chid_func_2 = 5'b001_11 ;
             8       : f_hqm_chid_func_2 = 5'b010_00 ;
             9       : f_hqm_chid_func_2 = 5'b010_01 ;
             10      : f_hqm_chid_func_2 = 5'b010_10 ;
             11      : f_hqm_chid_func_2 = 5'b010_11 ;
             12      : f_hqm_chid_func_2 = 5'b011_00 ;
             13      : f_hqm_chid_func_2 = 5'b011_01 ;
             14      : f_hqm_chid_func_2 = 5'b011_10 ;
             15      : f_hqm_chid_func_2 = 5'b011_11 ;
             16      : f_hqm_chid_func_2 = 5'b100_00 ;
             17      : f_hqm_chid_func_2 = 5'b100_01 ;
             18      : f_hqm_chid_func_2 = 5'b100_10 ;
             19      : f_hqm_chid_func_2 = 5'b100_11 ;
             20      : f_hqm_chid_func_2 = 5'b101_00 ;
             21      : f_hqm_chid_func_2 = 5'b101_01 ;
             22      : f_hqm_chid_func_2 = 5'b101_10 ;
             23      : f_hqm_chid_func_2 = 5'b101_11 ;
             24      : f_hqm_chid_func_2 = 5'b110_00 ;
             25      : f_hqm_chid_func_2 = 5'b110_01 ;
             26      : f_hqm_chid_func_2 = 5'b110_10 ;
             27      : f_hqm_chid_func_2 = 5'b110_11 ;
             28      : f_hqm_chid_func_2 = 5'b111_00 ;  
             29      : f_hqm_chid_func_2 = 5'b111_01 ;
             30      : f_hqm_chid_func_2 = 5'b111_10 ;
             default : f_hqm_chid_func_2 = 5'b111_11 ;          
        endcase

endfunction //f_hqm_chid_func_2
//////////////////////////////////////////
function automatic logic[3:0] f_hqm_port_preswidth_func( 
  input  logic [HQMIOSF_PORTS-1:0] port_config,
  output logic [3:0][1:0] port_width);

  if (HQMIOSF_PORTS==4) begin
    casez (port_config) 
     
       4'b0001: begin

         f_hqm_port_preswidth_func = 4'b0001;
         port_width[0] = 2'b00;
         port_width[1] = 2'b11; 
         port_width[2] = 2'b11;
         port_width[3] = 2'b11;
       end
       4'b0101: begin
         f_hqm_port_preswidth_func = 4'b0101;
         port_width[0] = 2'b01;//8;
         port_width[2] = 2'b01;// 8;
         port_width[1] = 2'b11;
         port_width[3] = 2'b11;           
       end
       4'b0111: begin
         f_hqm_port_preswidth_func = 4'b0111;
         port_width[0] = 2'b10;//4;
         port_width[1] = 2'b10;//4;
         port_width[2] = 2'b01;//8;
         port_width[3] = 2'b11;//0;
       end
       4'b1101: begin
         f_hqm_port_preswidth_func = 4'b1101;
         port_width[0] = 2'b01;//8;
         port_width[1] = 2'b11;  
         port_width[2] = 2'b10;//4;
         port_width[3] = 2'b10;//4;
       end
       4'b1111: begin
         f_hqm_port_preswidth_func = 4'b1111;
         port_width[0] = 2'b10;//4;
         port_width[1] = 2'b10;//4;
         port_width[2] = 2'b10;//4;
         port_width[3] = 2'b10;//4;
       end
       default: begin
         f_hqm_port_preswidth_func = 4'b0000;
         port_width[0] = 2'b11;
         port_width[1] = 2'b11;      
         port_width[2] = 2'b11;
         port_width[3] = 2'b11;
       end 
    endcase

  end else if (HQMIOSF_PORTS==2) begin
    casez (port_config) 
       2'b01: begin
         f_hqm_port_preswidth_func = 4'b0001;
         port_width[0] = 2'b00;
         port_width[1] = 2'b11;                
         port_width[2] = 2'b11;
         port_width[3] = 2'b11;
       end
       2'b11: begin
         f_hqm_port_preswidth_func = 4'b0011;
         port_width[0] = 2'b01;
         port_width[1] = 2'b01;                
         port_width[2] = 2'b11;
         port_width[3] = 2'b11;
       end
       default: begin
         f_hqm_port_preswidth_func = 4'b0000;
         port_width[0] = 2'b0;
         port_width[1] = 2'b0;
         port_width[2] = 2'b0;
         port_width[3] = 2'b0;
       end
    endcase

  end else if (HQMIOSF_PORTS==1) begin
         f_hqm_port_preswidth_func = 4'b0001;
         port_width[0] = 2'b0;
         port_width[1] = 0;
         port_width[2] = 0;
         port_width[3] = 0;

  end else begin
         f_hqm_port_preswidth_func = 4'b0000;
         port_width[0] = 0;
         port_width[1] = 0;
         port_width[2] = 0;
         port_width[3] = 0;
    
  end //if HQMIOSF_PORTS

endfunction //f_hqm_port_preswidth_func
////////////////////////////////////////////////////
///////////////////////////////////////////////////
//Parity functions
////////////////////////////////////////////////////
//Data Parity
///////////////////////////////////////////////////
function automatic  logic [(`HQM_dw((HQMIOSF_TD_WIDTH==511 || HQMIOSF_TD_WIDTH==255) ? HQMIOSF_TD_WIDTH : 127))-1:0] f_hqm_data_parity( 
    input logic [(HQMIOSF_TD_WIDTH==31?127:HQMIOSF_TD_WIDTH==63?127:HQMIOSF_TD_WIDTH):0] data,
    input logic [HQMIOSF_TDP_WIDTH:0] dparity,
    input logic strap_is_rp,
    input logic up_dn_cfg,
    input logic dchk_dis,               // disable data parity check
    output logic tgt_dpar_err
);
    logic [15:0] tgt_dparity;

    if (dchk_dis)
        tgt_dpar_err   =  '0; // no parity checking vRP outbound

    // jbdiethe 10032015 This construct caused issues for visa. The tool didnt like
    // accessing of bit 1 if the parity was only 1 bit wide. Migrate it to a for loop.
    // Ran an RTL 2 RTL FEV to make sure its the same logically.
    else if (HQMIOSF_TD_WIDTH == 511)
    begin
        tgt_dpar_err = '0;
        for(int parbit = 0 ; parbit <= HQMIOSF_TDP_WIDTH ; parbit++)
        begin
            tgt_dpar_err |= (dparity[parbit] != ^data[parbit*256 +: 256]);
        end
    end
    else 
    begin
        tgt_dpar_err = (dparity != ^data);
    end

    tgt_dparity = '0;

    for (int dword=0; dword<`HQM_dw((HQMIOSF_TD_WIDTH==511 || HQMIOSF_TD_WIDTH==255) ? HQMIOSF_TD_WIDTH : 127); dword++) 
        tgt_dparity[dword] = ^data[(dword*32)+:32] ^ tgt_dpar_err;
 
    return (tgt_dparity[(`HQM_dw((HQMIOSF_TD_WIDTH==511 || HQMIOSF_TD_WIDTH==255) ? HQMIOSF_TD_WIDTH : 127))-1:0]);
endfunction //f_hqm_data_parity



////////////////////////////////////////////////////
// Header Parity
///////////////////////////////////////////////////
function automatic  logic [3:0] f_hqm_cmd_parity(
    input hqm_pcie_hdr_t hdr,
    input logic cparity_err,
    input logic pchk_dis                // Disable cmd parity check
);
    logic [3:0] tgt_cparity;

    if (pchk_dis) begin   
        tgt_cparity[0] = ^hdr[31:0];
        tgt_cparity[1] = ^hdr[63:32];
        tgt_cparity[2] = ^hdr[95:64];
        tgt_cparity[3] = ^hdr[127:96];
    end else begin
        if (cparity_err == 1'b1) begin  
            tgt_cparity[0] = ~^hdr[031:00];
            tgt_cparity[1] = ~^hdr[063:32];
            tgt_cparity[2] = ~^hdr[095:64];
            tgt_cparity[3] = ~^hdr[127:96];
        end else begin
            tgt_cparity[0] =  ^hdr[031:00];
            tgt_cparity[1] =  ^hdr[063:32];
            tgt_cparity[2] =  ^hdr[095:64];
            tgt_cparity[3] =  ^hdr[127:96];
        end
    end
      
    return (tgt_cparity);
endfunction //f_hqm_cmd_parity

///////////////////////////////////////////////////
function automatic logic f_hqm_cmd_parerr_iosf( 
input hqm_iosf_tgt_cmd_t iosf_tgt_cmd);
logic tgt_cpar_err_iosf;
    begin
          tgt_cpar_err_iosf = (iosf_tgt_cmd.tcparity != ^({iosf_tgt_cmd.tfmt,
                                            iosf_tgt_cmd.ttype,
                                            iosf_tgt_cmd.ttc,
                                            iosf_tgt_cmd.ttc3,
                                            iosf_tgt_cmd.tep,
                                            iosf_tgt_cmd.tro,
                                            iosf_tgt_cmd.tns,
                                            iosf_tgt_cmd.tat,
                                            iosf_tgt_cmd.tlength,
                                            iosf_tgt_cmd.trqid,
                                            iosf_tgt_cmd.ttag,
                                            iosf_tgt_cmd.tlbe,
                                            iosf_tgt_cmd.tfbe,
                                            iosf_tgt_cmd.taddress,
                                            iosf_tgt_cmd.ttd,
                                            iosf_tgt_cmd.tth,
                                            //iosf_tgt_cmd.tecrc,
                                            iosf_tgt_cmd.tecrc_generate,
                                            iosf_tgt_cmd.tecrc_error,
                                            iosf_tgt_cmd.trsvd1_1,
                                            iosf_tgt_cmd.trsvd1_3, 
                                            iosf_tgt_cmd.trsvd1_7,
                                            iosf_tgt_cmd.trsvd0_7, 
                                            iosf_tgt_cmd.tido,
                                            iosf_tgt_cmd.trs,
                                            iosf_tgt_cmd.tpasidtlp
                                            //iosf_tgt_cmd.tchain 
                                             }));

      return(tgt_cpar_err_iosf);
  end
endfunction //f_hqm_cmd_parerr_iosf

//////////////////////////////////////////////////////////
// DECODE FUNCTIONS 
//////////////////////////////////////////////////////////

function automatic logic[3:0] f_hqm_tgtdec_typedec (
input [6:0] ttype
);
      f_hqm_tgtdec_typedec = 4'b1111;
      case (ttype)
        `HQM_CPL,
        `HQM_CPLD,
        `HQM_CPLLK,
        `HQM_CPLDLK     : f_hqm_tgtdec_typedec = `HQM_CMP_TYPE;
      
        `HQM_MRD32,
        `HQM_MRD64,
        `HQM_MRDLK32,
        `HQM_MRDLK64, 
        `HQM_MWR32,
        `HQM_MWR64,   
        `HQM_NPMWR32,
        `HQM_NPMWR64,
        `HQM_FETCHADD32,
        `HQM_FETCHADD64,
        `HQM_SWAP32,
        `HQM_SWAP64,
        `HQM_CAS32,
        `HQM_CAS64      : f_hqm_tgtdec_typedec = `HQM_MEM_TYPE;

        `HQM_LTMRD32,
        `HQM_LTMRD64,
        `HQM_LTMWR32,
        `HQM_LTMWR64    : f_hqm_tgtdec_typedec = `HQM_LT_TYPE; 
  
        `HQM_IORD,
        `HQM_IOWR       : f_hqm_tgtdec_typedec = `HQM_IO_TYPE;

        `HQM_CFGRD0,
        `HQM_CFGWR0     : f_hqm_tgtdec_typedec = `HQM_CFG0_TYPE;

        `HQM_CFGRD1,
        `HQM_CFGWR1     : f_hqm_tgtdec_typedec = `HQM_CFG1_TYPE;

        `HQM_MSG_AD,
        `HQM_MSGD_AD    : f_hqm_tgtdec_typedec = `HQM_MSGBYAD_TYPE;

        `HQM_MSG_ID,
        `HQM_MSGD_ID    : f_hqm_tgtdec_typedec = `HQM_MSGBYID_TYPE; 

         default        : f_hqm_tgtdec_typedec = 4'b1111; // jbdiethe copied the default for litra otherwise it fatals
      endcase        
endfunction // 
//////////////////////////////////////////////////////////

function automatic logic[2:0] f_hqm_tgtdec_decbits (
input [6:0] ttype
);
      f_hqm_tgtdec_decbits = 3'b111;
      case (ttype)
        `HQM_CPLD,
        `HQM_MSGD_AD,
        `HQM_MSGD_ID    : f_hqm_tgtdec_decbits = `HQM_W_DATA;    

        `HQM_CPLLK,
        `HQM_CPLDLK,
        `HQM_MRDLK32,
        `HQM_MRDLK64    : f_hqm_tgtdec_decbits = `HQM_LOCK;
      
        `HQM_MRD32,
        `HQM_MRD64,
        `HQM_LTMRD32,
        `HQM_LTMRD64, 
        `HQM_IORD,
        `HQM_CFGRD0,
        `HQM_CFGRD1     : f_hqm_tgtdec_decbits = `HQM_READ;

        `HQM_MWR32,
        `HQM_MWR64,
        `HQM_LTMWR32,
        `HQM_LTMWR64,
        `HQM_NPMWR32,
        `HQM_NPMWR64,
        `HQM_CFGWR0,
        `HQM_CFGWR1,
        `HQM_IOWR       : f_hqm_tgtdec_decbits = `HQM_WRITE; 

        `HQM_FETCHADD32,
        `HQM_FETCHADD64,
        `HQM_SWAP32,
        `HQM_SWAP64,
        `HQM_CAS32,
        `HQM_CAS64      : f_hqm_tgtdec_decbits = `HQM_ATOMIC;

         default        : f_hqm_tgtdec_decbits = 3'b111; // jbdiethe copied the default for litra otherwise it fatals
      endcase        
endfunction // 
////////////////////////////////////////////////////
function automatic logic[15:0] f_hqm_tgtdec_bdfnum (
 input [3:0] type_dec,
 input [31:0] address,
 input [15:0] rqid);
 logic [15:0] bdfnum; 
   begin
    bdfnum = '0;
    bdfnum =  (type_dec==`HQM_CMP_TYPE) ? rqid : address[31:16];
    return (bdfnum); 
  end
 endfunction
    
 
//////////////////////////////////////////////////////////////////
function automatic logic f_hqm_lt_check (   
 input logic [3:0] dec_type);
  logic lt_ur;
     begin
         lt_ur = (dec_type == `HQM_LT_TYPE); 
         return (lt_ur);
    end
endfunction


//////////////////////////////////////////////////////////
// ERROR FUNCTIONS in addition to the checks done in decode 
//////////////////////////////////////////////////////////

//////////////////////////////////////////////////////
function automatic logic f_hqm_unlockmsg_hit (  
 input logic [1:0] fmt,
 input logic [4:0] ttype,
 input logic [2:0] tc,
 input logic [7:0] msgcode
 );
 
    logic unlockmsg_hit; 
    begin  
     unlockmsg_hit = 
                   ({fmt, ttype} == `HQM_MSG_BC) &
                   ( tc == 3'b000  ) &
                   ( msgcode == HQM_UNLOCK ) ;
                  
     return (unlockmsg_hit);
    end
endfunction



///////////////////////////////////////////////////////


///////////////////////////////////////////////////////

function automatic logic f_hqm_aeb_ur ( 
input logic aeb,
input logic up_dn_cfg,
input logic is_sprp,
input logic[2:0] dec_bits);
  logic aeb_ur;
  begin
      aeb_ur = is_sprp? (!up_dn_cfg && (dec_bits == `HQM_ATOMIC) && aeb): ((dec_bits == `HQM_ATOMIC) && aeb);
      return (aeb_ur);
  
 end
endfunction

///////////////////////////////////////////////////////


function automatic logic f_hqm_bme_ur ( 
 input logic [3:0] dec_type,
 input bme,
 input up_dn_cfg
  
);
   logic bme_ur;
   begin
        bme_ur = (up_dn_cfg && ((dec_type == `HQM_MEM_TYPE) | (dec_type == `HQM_IO_TYPE)) && !bme) ;
        return (bme_ur);
   end
endfunction


///////////////////////////////////////////////////////


function automatic logic f_hqm_mrdlk_ur (   
 input logic [1:0] fmt,
 input logic [4:0] ttype,
 input logic up_dn_cfg
);

   logic mrdlk_ur;
   begin
        mrdlk_ur = (({fmt, ttype} == `HQM_MRDLK32) || ({fmt, ttype} == `HQM_MRDLK64)) && 
                    (up_dn_cfg == 1'b1) ;
        return (mrdlk_ur);
   end
endfunction

///////////////////////////////////////////////////////

function automatic logic [1:0] f_hqm_vdm_dec (  
    input logic [1:0] fmt,
    input logic [4:0] ttype,
    input logic [7:0] msgcode,
    input logic up_dn_cfg,
    output logic vdm_drop
);
    logic [1:0] vdm;
    logic [6:0] ftype;
    ftype = {fmt, ttype};

    vdm[0] = ((ftype == `HQM_MSG_RC)   || (ftype == `HQM_MSGD_RC) ||
              (ftype == `HQM_MSG_BC)   || (ftype == `HQM_MSGD_BC) ||
              (ftype == `HQM_MSG_TERM) || (ftype == `HQM_MSGD_TERM))  &&
             (msgcode == HQM_VENDOR_TYPE0);

    vdm[1] = (((ftype == `HQM_MSG_RC)  || (ftype == `HQM_MSGD_RC) ||
               (ftype == `HQM_MSG_BC)  || (ftype == `HQM_MSGD_BC) ||
               (ftype == `HQM_MSG_TERM)|| (ftype == `HQM_MSGD_TERM))  &&
              (msgcode == HQM_VENDOR_TYPE1)) ;

    vdm_drop   = '0;
    if (up_dn_cfg) begin
         vdm_drop =  ((ftype == `HQM_MSG_BC)  || (ftype == `HQM_MSGD_BC)||
                      (ftype == `HQM_MSG_5)   || (ftype == `HQM_MSGD_5) ||
                      (ftype == `HQM_MSG_6)   || (ftype == `HQM_MSGD_6) ||
                      (ftype == `HQM_MSG_7)   || (ftype == `HQM_MSGD_7) ||
                      (ftype == `HQM_MSG_TERM)|| (ftype == `HQM_MSGD_TERM))  &&
                     (msgcode == HQM_VENDOR_TYPE1) ;
    end else begin
         vdm_drop =  ((ftype == `HQM_MSG_RC)  || (ftype == `HQM_MSGD_RC)||
                      (ftype == `HQM_MSG_5)   || (ftype == `HQM_MSGD_5) ||
                      (ftype == `HQM_MSG_6)   || (ftype == `HQM_MSGD_6) ||
                      (ftype == `HQM_MSG_7)   || (ftype == `HQM_MSGD_7) ||
                      (ftype == `HQM_MSG_TERM)|| (ftype == `HQM_MSGD_TERM))  &&
                      (msgcode == HQM_VENDOR_TYPE1) ;
    end
    return (vdm);
endfunction

///////////////////////////////////////////////////////
// Message Decode based on Routing fields URs
///////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////

function automatic logic f_hqm_ignmsg_dec ( 
 input logic [1:0] fmt,
 input logic [4:0] ttype,
 input logic [7:0] msgcode);


  logic ign_msg;
  begin

      ign_msg     = (({fmt, ttype} == `HQM_MSG_TERM)  || ({fmt, ttype} == `HQM_MSGD_TERM)) && 
                    ((msgcode == HQM_ATTENTION_INDICATOR_ON) ||
                     (msgcode == HQM_ATTENTION_INDICATOR_BLINK) ||
                     (msgcode == HQM_ATTENTION_INDICATOR_OFF) ||
                     (msgcode == HQM_POWER_INDICATOR_ON) ||
                     (msgcode == HQM_POWER_INDICATOR_BLINK) || 
                     (msgcode == HQM_POWER_INDICATOR_OFF) ||
                     (msgcode == HQM_ATTN_BUTTON)) ;

     return (ign_msg);
  end
endfunction

//////////////////////////////////////////////////////////
// Max Payload size encoding from DW to 3bit
/////////////////////////////////////////////////////////

function automatic logic [10:0] f_hqm_len_mps_dw (
 input logic [2:0] len_mps_strp,
 input logic [2:0] len_mps_reg,
 output logic [10:0] len_dw_reg
);
  
  f_hqm_len_mps_dw = '0;
  len_dw_reg       = '0;

  case (len_mps_strp)
    3'b000 :   f_hqm_len_mps_dw  = 11'b000_0010_0000; //32*4 bytes
    3'b001 :   f_hqm_len_mps_dw  = 11'b000_0100_0000; //64*4 bytes
    3'b010 :   f_hqm_len_mps_dw  = 11'b000_1000_0000; //128*4 bytes 
    3'b011 :   f_hqm_len_mps_dw  = 11'b001_0000_0000; //256*4 bytes
    3'b100 :   f_hqm_len_mps_dw  = 11'b010_0000_0000; //512*4 bytes
    3'b101 :   f_hqm_len_mps_dw  = 11'b100_0000_0000; //1024*4 bytes
    3'b111 :   f_hqm_len_mps_dw  = 11'b000_0001_0000; //16*4 bytes
    default:   f_hqm_len_mps_dw  = 11'b000_0010_0000; //32*4 bytes
  endcase
  case (len_mps_reg)
    3'b000 :   len_dw_reg   = 11'b000_0010_0000; //32*4 bytes
    3'b001 :   len_dw_reg   = 11'b000_0100_0000; //64*4 bytes
    3'b010 :   len_dw_reg   = 11'b000_1000_0000; //128*4 bytes
    3'b011 :   len_dw_reg   = 11'b001_0000_0000; //256*4 bytes
    3'b100 :   len_dw_reg   = 11'b010_0000_0000; //512*4 bytes
    3'b101 :   len_dw_reg   = 11'b100_0000_0000; //1024*4 bytes
    default:   len_dw_reg   = 11'b000_0010_0000; //32*4 bytes
  endcase

endfunction // f_hqm_len_mps_dw 
 
///////////////////////////////////////////////////////////////
// PME_TO functions
///////////////////////////////////////////////////////////////
// pme UR 
///////////////////////////////////////////////////////////////

function automatic logic f_hqm_vrp_pmeto (  
 input logic pme_turnoff,
 input logic [1:0] fmt,
 input logic [4:0] ttype

);
  logic pme_ur;
 begin
     pme_ur  = '0;
     pme_ur  =  ((({fmt,ttype} == `HQM_MRD32)   || ({fmt,ttype} == `HQM_MRD64)   || 
                  ({fmt,ttype} == `HQM_MRDLK32) || ({fmt,ttype} == `HQM_MRDLK64) ||
                  ({fmt,ttype} == `HQM_IORD)    || ({fmt,ttype} == `HQM_IOWR)    ||
                  ({fmt,ttype} == `HQM_CFGRD1)  || ({fmt,ttype} == `HQM_CFGWR1)) &&
                 pme_turnoff);


    return (pme_ur);
 end
endfunction //f_hqm_vrp_pmeto  

///////////////////////////////////////////////////////////////
//Pme_to CPL Flag function
///////////////////////////////////////////////////////////////

function automatic logic f_hqm_vrp_cplflag (    
 input logic [1:0] fc
);
  logic cpl_flag;
 begin
    cpl_flag  = '0;
    cpl_flag  =  (fc == `HQM_FC_NP)? 1'b1: 1'b0;
 return (cpl_flag);
 end
endfunction  // f_hqm_vrp_cplflag
 
//////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////
// Max Payload calculation (for credits remaining)
//////////////////////////////////////////////////////////////
function automatic logic [2:0] f_hqm_iosf_min_mps (
 input logic [2:0] mps_strap,
 input logic [2:0] mps_reg
);

 logic [2:0] iosf_min_mps;

  begin
   if  (mps_strap ==  3'b111) iosf_min_mps = mps_strap;
   else 
   if  (mps_strap < mps_reg) iosf_min_mps = mps_strap;
   else
   iosf_min_mps = mps_reg;
  return (iosf_min_mps);
  end
 endfunction // f_hqm_iosf_min_mps

//////////////////////////////////////////////////////////////

// Divide by MPS/MRRS and round-up function

function automatic [2:0] divide_ru (
     input  logic [9:0]     dividend
    ,input  logic [2:0]     divisor
);
    // Reducing logic path by adding only supported combinations of MPS and MRRS

    case (divisor)
        3'h0:    divide_ru =        dividend[9:7]  + {2'd0, |(dividend[6:0])};     // 128  3b inc
        3'h1:    divide_ru = {1'd0, dividend[9:8]} + {2'd0, |(dividend[7:0])};     // 256  2b inc
        default: divide_ru = {2'd0, dividend[9  ]} + {2'd0, |(dividend[8:0])};     // 512  1b inc
    endcase

endfunction

// Split transaction based on 4KBB MPS and MRS,
// and return the length of the next tlp
// The function accepts byte aligned start and end addresses
// and re-aligns the addresses to the nearest DWORD boundaries
// length is returned in DWORDS

function automatic [7:0] calc_tlp_lngth (   
     input  logic [12:0]    start_add
    ,input  logic [12:0]    end_add_p1
    ,input  logic [9:0]     length
    ,input  logic [2:0]     mps_mrrs
);

    logic [9:0]     mps_mrrs_bytes; 
    logic [12:0]    mxs_add_p1;

    // Transactions are limited to at most 512B within at most 8 consecutive 64B cache lines
    // So the maximum number of DWs is limited to at most 128 at MPS/MRRS=512B

    // If the mps_mrs value is set to 1K, 2K, 4K etc. (anything over 512) alias the mps_mrs value to 512.

    case (mps_mrrs)
        3'h0:    mps_mrrs_bytes = 10'd128;
        3'h1:    mps_mrrs_bytes = 10'd256;
        default: mps_mrrs_bytes = 10'd512;
    endcase

    mxs_add_p1   = start_add + {3'd0, mps_mrrs_bytes};      // 13b + 10b add (7 of 10b are constant)

    // Total remaining request length rounded to dword boundaries. First check if the total length is
    // greater than whichever of MPS or MRS is relevant.

    if (length > mps_mrrs_bytes) begin

        // Check if the request crosses a 4KB Page Boundary and if so limit TLP length to that boundary.

        if ((mxs_add_p1[12] != start_add[12]) & (|mxs_add_p1[8:0])) begin

            calc_tlp_lngth = {1'd0, ~start_add[8:2]} + 8'd1;

        end else begin // If the request doesn't cross page boundary then limit TLP length to MPS or MRS.

            calc_tlp_lngth = mps_mrrs_bytes[9:2];
      end

    end else begin

      // Request is less than relevant one of MPS or MRS
        // Check if the request crosses a 4KB Page Boundary and if so limit the TLP length to that boundary.

        if ((end_add_p1[12] != start_add[12]) & (|end_add_p1[8:0])) begin

            calc_tlp_lngth = {1'd0, ~start_add[8:2]} + 8'd1;

        end else begin // If the request doesn't cross page boundary then TLP length is the rounded request length.

            calc_tlp_lngth = length[9:2] + ((|length[1:0]) ? 8'd1 : 8'd0);
      end

    end

    return (calc_tlp_lngth);

endfunction

function automatic [6:0] calc_num_tlps (
     input  logic [12:0]    start_add
    ,input  logic [12:0]    end_add_p1
    ,input  logic [9:0]     length
    ,input  logic [2:0]     mps_mrs
);

    // Transactions are limited to at most 512B within at most 8 consecutive 64B cache lines
    // So the maximum number of TLPs is limited to at most 5 at MPS/MRRS=128B if we span a 4K boundary.

    // If the mps_mrs value is set to 1K, 2K, 4K etc. (anything over 512) alias the mps_mrs value to 512.

    logic [2:0]     aliased_mps_mrs; 
    logic [2:0]     num_tlps;

    aliased_mps_mrs = (|mps_mrs[2:1]) ? 3'h2 : {1'b0, mps_mrs[1:0]};

    // First divide on the 4KB Boundary

    if ((end_add_p1[12] != start_add[12]) & (|end_add_p1[8:0])) begin

        num_tlps = divide_ru(({1'd0, ~start_add[8:0]} + 10'd1), aliased_mps_mrs) +     // 10b inc -> 3b +
                   divide_ru( {1'd0, end_add_p1[8:0]}         , aliased_mps_mrs);      //            3b
    end else begin

        num_tlps = divide_ru(length, aliased_mps_mrs);
    end

    return {4'd0, num_tlps};

endfunction

//-------------------------------------------------------------------------
// X16 Decimal to Binary Conversion
//-------------------------------------------------------------------------
function automatic [15:0] dcbx16(
    input[3:0] select
);
    dcbx16 = 16'h1 << select;
endfunction // dcbx16

//-------------------------------------------------------------------------
// X7 Decimal to Binary Conversion
//-------------------------------------------------------------------------
function automatic [7:0] dcbx8(
    input[2:0] select
);
    dcbx8 = 8'h1 << select;
endfunction // dcbx7

//-------------------------------------------------------------------------
// Multiple Message Error Mask
//-------------------------------------------------------------------------
function automatic logic mult_msg_mask_func(
    input logic             global_err,
    input logic             err_sig,
    input logic             curr_msg_stat,
    input logic             clr_vec
);

    // If an error is asserted which applies to all functions, only the
    // last active function will send the message. This is to prevent 
    // multiple message for a single error. The following case will take
    // an error that applies to all the functions and mask out all but the
    // the most active function.
    if(global_err && err_sig) begin
      mult_msg_mask_func = '0; 
    end 
    // If the multiple message mask was set for a previously detected 
    // error, the mask must be cleared in the event that an individual 
    // function received the clear status.
    else if (clr_vec)
        mult_msg_mask_func = '0;
    else
        mult_msg_mask_func = curr_msg_stat;

endfunction // mult_msg_mask_func

//-------------------------------------------------------------------------
// Multiple Message Error Mask for Physical Functions
//-------------------------------------------------------------------------
function automatic logic    mult_msg_mask_pf(
    input logic             global_err,
    input logic             err_sig,
    input logic             curr_msg_stat,
    input logic             clr_vec
);

    // If an error is asserted which applies to the physical functions, only the
    // last active function will send the message. This is to prevent 
    // multiple message for a single error. The following case will take
    // an error that applies to the physical functions and mask out all but the
    // the most active fucntion.
    if(global_err && err_sig)
    begin
      mult_msg_mask_pf = '0; 
    end // else if global_err
    // If the multiple message mask was set for a previously detected 
    // error, the mask must be cleared in the event that an individual 
    // function received the clear status.
//tjj litra 1-bit fix   else if(|clr_vec)
    else if(clr_vec)
        mult_msg_mask_pf = curr_msg_stat & ~clr_vec;
    else
        mult_msg_mask_pf = curr_msg_stat;

endfunction // mult_msg_mask_pf

endpackage: hqm_system_func_pkg

