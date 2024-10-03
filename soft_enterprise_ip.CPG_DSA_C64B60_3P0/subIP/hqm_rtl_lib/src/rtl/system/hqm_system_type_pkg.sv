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

package hqm_system_type_pkg;

`include "hqm_system_def.vh"

import hqm_pkg::*, hqm_sif_pkg::*, hqm_system_pkg::*;

// Transaction type (fmt:type) enum encoding
typedef enum logic [6:0]
             {
              HQM_MRD3      = 7'b00_0_0000,
              HQM_MRD4      = 7'b01_0_0000,
              HQM_LTMRD3    = 7'b00_0_0111,
              HQM_LTMRD4    = 7'b01_0_0111,
              HQM_MRDLK3    = 7'b00_0_0001,
              HQM_MRDLK4    = 7'b01_0_0001,
              HQM_MWR3      = 7'b10_0_0000,
              HQM_MWR4      = 7'b11_0_0000,
              HQM_LTMWR3    = 7'b10_0_0111,
              HQM_LTMWR4    = 7'b11_0_0111,
              HQM_NPMWR3    = 7'b10_1_1011,
              HQM_NPMWR4    = 7'b11_1_1011,

              HQM_IORD      = 7'b00_0_0010,
              HQM_IOWR      = 7'b10_0_0010,
              HQM_CFGRD0    = 7'b00_0_0100,
              HQM_CFGWR0    = 7'b10_0_0100,
              HQM_CFGRD1    = 7'b00_0_0101,
              HQM_CFGWR1    = 7'b10_0_0101,
              HQM_MSG       = 7'b01_1_0000,   // Need to use msg routing, too
              HQM_MSG1      = 7'b01_1_0001,
              HQM_MSG2      = 7'b01_1_0010,
              HQM_MSG3      = 7'b01_1_0011,
              HQM_MSG4      = 7'b01_1_0100,
              HQM_MSG5      = 7'b01_1_0101,
              HQM_MSG6      = 7'b01_1_0110,
              HQM_MSG7      = 7'b01_1_0111,
              HQM_MSGD      = 7'b11_1_0000,   // Need to use msg routing, too
              HQM_MSGD1     = 7'b11_1_0001,
              HQM_MSGD2     = 7'b11_1_0010,
              HQM_MSGD3     = 7'b11_1_0011,
              HQM_MSGD4     = 7'b11_1_0100,
              HQM_MSGD5     = 7'b11_1_0101,
              HQM_MSGD6     = 7'b11_1_0110,
              HQM_MSGD7     = 7'b11_1_0111,
              HQM_CPL       = 7'b00_0_1010,
              HQM_CPLD      = 7'b10_0_1010,
              HQM_CPLLK     = 7'b00_0_1011,
              HQM_CPLDLK    = 7'b10_0_1011,
              //             HQM_TCFGRD    = 7'b00_1_1011, // Deprecated TLP Type
              //             HQM_TCFGWR    = 7'b10_1_1011, // Deprecated TLP Type
              HQM_FETCHADD3 = 7'b10_0_1100,
              HQM_FETCHADD4 = 7'b11_0_1100,
              HQM_SWAP3     = 7'b10_0_1101,
              HQM_SWAP4     = 7'b11_0_1101,
              HQM_CAS3      = 7'b10_0_1110,
              HQM_CAS4      = 7'b11_0_1110
              } hqm_pcie_type_e_t;

// Message routing bit enum encoding
typedef enum logic [2:0]
             {
              HQM_ROUTE_TO_RC  = 3'b000,
              HQM_ROUTE_BY_ADR = 3'b001,
              HQM_ROUTE_BY_ID  = 3'b010,
              HQM_BROADCAST    = 3'b011,
              HQM_LOCAL        = 3'b100,
              HQM_GATHER       = 3'b101,
              HQM_RESERVED6    = 3'b110,
              HQM_RESERVED7    = 3'b111
              } hqm_pcie_msg_route_e_t;

// Message code enum encoding
typedef enum logic [7:0]
             {
              HQM_ASRT_INTA                 = 8'b0010_0000,
              HQM_ASRT_INTB                 = 8'b0010_0001,
              HQM_ASRT_INTC                 = 8'b0010_0010,
              HQM_ASRT_INTD                 = 8'b0010_0011,
              HQM_DSRT_INTA                 = 8'b0010_0100,
              HQM_DSRT_INTB                 = 8'b0010_0101,
              HQM_DSRT_INTC                 = 8'b0010_0110,
              HQM_DSRT_INTD                 = 8'b0010_0111,
              HQM_PM_ACTIVE_STATE_NAK       = 8'b0001_0100,
              HQM_PM_PME                    = 8'b0001_1000,
              HQM_PM_TURN_OFF               = 8'b0001_1001,
              HQM_PM_TO_ACK                 = 8'b0001_1011,
              HQM_ERR_COR                   = 8'b0011_0000,
              HQM_ERR_NONFATAL              = 8'b0011_0001,
              HQM_ERR_FATAL                 = 8'b0011_0011,
              HQM_UNLOCK                    = 8'b0000_0000,
              HQM_INVLDT_REQ                = 8'b0000_0001,
              HQM_INVLDT_CPL                = 8'b0000_0010,
              HQM_PAGE_REQUEST              = 8'b0000_0100,
              HQM_PAGE_RESPONSE             = 8'b0000_0101,
              HQM_SET_SLOT_POWER_LIMIT      = 8'b0101_0000,
              HQM_VENDOR_TYPE0              = 8'b0111_1110,
              HQM_VENDOR_TYPE1              = 8'b0111_1111,
              HQM_ATTENTION_INDICATOR_ON    = 8'b0100_0001,
              HQM_ATTENTION_INDICATOR_BLINK = 8'b0100_0011,
              HQM_ATTENTION_INDICATOR_OFF   = 8'b0100_0000,
              HQM_POWER_INDICATOR_ON        = 8'b0100_0101,
              HQM_POWER_INDICATOR_BLINK     = 8'b0100_0111,
              HQM_POWER_INDICATOR_OFF       = 8'b0100_0100,
              HQM_ATTN_BUTTON               = 8'b0100_1000,
              HQM_LTR                       = 8'b0001_0000,
              HQM_OBFF                      = 8'b0001_0010
              } hqm_pcie_msg_code_e_t;

// IOSF request struct
// iosf_cmd_s
typedef struct packed {
    logic [1:0]                          cfmt;
    logic [4:0]                          ctype;
    logic [3:0]                          ctc;
    logic                                cth;
    logic                                cep;
    logic                                cro;
    logic                                cns;
    logic                                cido;
    logic [1:0]                          cat;
    logic [9:0]                          clength;
    logic [15:0]                         crqid;
    logic [7:0]                          ctag;
    logic [3:0]                          clbe;
    logic [3:0]                          cfbe;
    logic [63:0]                         caddress; // jbdiethe Mstr Code assumes struct is 64 bits
    logic                                ctd;
    logic                                crsvd1_7;
    logic                                crsvd1_3;
    logic                                crsvd1_1;
    logic                                crsvd0_7;
    logic [HQMIOSF_RS_WIDTH:0]           crs;
    logic [HQMIOSF_SAI_WIDTH:0]          csai;
    logic [HQMIOSF_PASIDTLP_WIDTH-1:0]   cpasidtlp;
    logic                                cparity;
} hqm_iosf_cmd_t;


// IOSF request struct
typedef struct packed {
    logic                                put;
    logic [HQMIOSF_NUMCHANL2:0]          chid;
    logic [1:0]                          rtype;
    logic                                cdata;
    logic [HQMIOSF_MAX_DATA_LEN:0]       dlen; 
    logic [3:0]                          tc;
    logic                                ns;
    logic                                ro;
    logic [HQMIOSF_RS_WIDTH:0]           rs;
    logic                                ido;
    logic [15:0]                         id;
    logic                                locked;
    logic                                chain;
    logic                                opp;
    logic [HQMIOSF_AGENT_WIDTH:0]        agent;
    logic [HQMIOSF_PORTS*HQMIOSF_VC-1:0] priorty;    // Name is miss spelled on purpose, SV rsvd word.
} hqm_iosf_req_t;

// IOSF grant struct
typedef struct packed {
    logic                                gnt;
    logic   [HQMIOSF_NUMCHANL2:0]        chid;
    logic   [1:0]                        rtype;
    logic   [1:0]                        gtype;
} hqm_iosf_gnt_t;

// Rx/Tx Data Queue struct
typedef struct packed {
    logic   [15:0]          poison;
    logic   [15:0]          parity;
    logic   [15:0] [31:0]   dw;
} hqm_data_t;

typedef struct packed {

    logic                                spare;

    logic                                cparity;
    logic [HQMIOSF_PASIDTLP_WIDTH-1:0]   cpasidtlp;

    // Byte 0

    logic                                ctc3;          // tc[3]=rsvd4
    logic [1:0]                          cfmt;
    logic [4:0]                          ctype;

    // Byte 1

    logic                                crsvd1_7;      // rsvd3
    logic [2:0]                          ctc;
    logic                                crsvd1_3;      // rsvd2
    logic                                cido;          // attr2
    logic                                crsvd1_1;      // rsvd0
    logic                                cth;

    // Bytes 2-3

    logic                                ctd;
    logic                                cep;
    logic                                cro;           // attr[1]
    logic                                cns;           // attr[0]
    logic [1:0]                          cat;
    logic [9:0]                          clength;

    // Bytes 4-5

    logic [15:0]                         crqid;

    // Byte 6

    logic [7:0]                          ctag;

    // Byte 7

    logic [3:0]                          clbe;
    logic [3:0]                          cfbe;

    // Bytes 8-15

    logic [63:0]                         caddress;

} hqm_hdrbufi_t;

typedef struct packed {

    logic [HQMIOSF_SAI_WIDTH:0]          csai;

    hqm_hdrbufi_t                        hdrbufi;

} hqm_hdrbufo_t;

////////////////////////////////////////
// MEM64
////////////////////////////////////////
typedef struct packed {
    // Byte 0
    logic        rsvd4;
    logic        [1:0] fmt ;
    logic        [4:0] ttype;
    // Byte 1
    logic        rsvd3;
    logic        [2:0] tc;
    logic        rsvd2;
    logic        attr2;
    logic        rsvd0;
    logic        oh;
    // Byte 2-3
    logic        td;
    logic        ep;
    logic        [1:0] attr;
    logic        [1:0] at;
    logic        [9:0] len;
    // Byte 4-5
    logic        [15:0] rqid;
    // Byte 6
    logic        [7:0] tag;
    // Byte 7
    logic        [3:0] lbe;
    logic        [3:0] fbe;
    // Byte 8 thru 15
    logic        [63:2] addr;
    logic        rsvd5, rsvd6;
} hqm_pciemem64_hdr_t;


////////////////////////////////////////
// MEM32
////////////////////////////////////////
typedef struct packed {
    // Byte 0
    logic        rsvd4;
    logic        [1:0] fmt ;
    logic        [4:0] ttype;
    // Byte 1
    logic        rsvd3;
    logic        [2:0] tc;
    logic        rsvd2;
    logic        attr2;
    logic        rsvd0;
    logic        oh;
    // Byte 2-3
    logic        td;
    logic        ep;
    logic        [1:0] attr;
    logic        [1:0] at;
    logic        [9:0] len;
    // Byte 4-5
    logic        [15:0] rqid;
    // Byte 6
    logic        [7:0] tag;
    // Byte 7
    logic        [3:0] lbe;
    logic        [3:0] fbe;
    // Byte 8 thru 11
    logic        [31:2] addr;
    logic        rsvd5, rsvd6;
    // Byte 12-15
    logic   [63:32]     rsvd7;
} hqm_pciemem32_hdr_t;

////////////////////////////////////////
// ATOMIC64 FetchAdd, Swap, CAS
////////////////////////////////////////
typedef struct packed {
    // Byte 0
    logic        rsvd4;
    logic        [1:0] fmt ;
    logic        [4:0] ttype;
    // Byte 1
    logic        rsvd3;
    logic        [2:0] tc;
    logic        rsvd2;
    logic        attr2;
    logic        rsvd0;
    logic        oh;
    // Byte 2-3
    logic        td;
    logic        ep;
    logic        [1:0] attr;
    logic        [1:0] at;
    logic        [9:0] len;
    // Byte 4-5
    logic        [15:0] rqid;
    // Byte 6
    logic        [7:0] tag;
    // Byte 7
    logic        [3:0] lbe;
    logic        [3:0] fbe;
    // Byte 8 thru 15
    logic        [63:2] addr;
    logic        rsvd5, rsvd6;
} hqm_pcieatomic64_hdr_t;


////////////////////////////////////////
// ATOMIC32 FetchAdd, Swap, CAS   
////////////////////////////////////////
typedef struct packed {
    // Byte 0
    logic        rsvd4;
    logic        [1:0] fmt ;
    logic        [4:0] ttype;
    // Byte 1
    logic        rsvd3;
    logic        [2:0] tc;
    logic        rsvd2;
    logic        attr2;
    logic        rsvd0;
    logic        oh;
    // Byte 2-3
    logic        td;
    logic        ep;
    logic        [1:0] attr;
    logic        [1:0] at;
    logic        [9:0] len;
    // Byte 4-5
    logic        [15:0] rqid;
    // Byte 6
    logic        [7:0] tag;
    // Byte 7
    logic        [3:0] lbe;
    logic        [3:0] fbe;
    // Byte 8 thru 11
    logic        [31:2] addr;
    logic        rsvd5, rsvd6;
    // Byte 12-15
    logic   [63:32]     rsvd7;
} hqm_pcieatomic32_hdr_t;

////////////////////////////////////////
// CPL
////////////////////////////////////////
typedef struct packed {
    // Byte 0
    logic        rsvd4;
    logic        [1:0] fmt ;
    logic        [4:0] ttype;
    // Byte 1
    logic        rsvd3;
    logic        [2:0] tc;
    logic        rsvd2;
    logic        attr2;
    logic        rsvd0;
    logic        oh;
    // Byte 2-3
    logic        td;
    logic        ep;
    logic        [1:0] attr;
    logic        [1:0] at;
    logic        [9:0] len;
    // Byte 4-5
    logic        [15:0] cplid;
    // Byte 6-7
    logic        [2:0] cplstat;
    logic        bcm;
    logic        [11:0] bytecnt;
    // Byte 8-9
    logic        [15:0] rqid;
    // Byte 10
    logic        [7:0] tag;
    // Byte 11
    logic        rsvd5;
    logic        [6:0] lowaddr;
    // Byte 12-15
    logic       [31:0] rsvd6;
} hqm_pciecpl_hdr_t;

////////////////////////////////////////
// CFG
////////////////////////////////////////
typedef struct packed {
    // Byte 0
    logic        rsvd4;
    logic        [1:0] fmt ;
    logic        [4:0] ttype;
    // Byte 1
    logic        rsvd3;
    logic        [2:0] tc;
    logic        rsvd2;
    logic        attr2;
    logic        rsvd0;
    logic        oh;
    // Byte 2-3
    logic        td;
    logic        ep;
    logic        [1:0] attr;
    logic        [1:0] at;
    logic        [9:0] len;
    // Byte 4-5
    logic        [15:0] rqid;
    // Byte 6
    logic        [7:0] tag;
    // Byte 7
    logic        [3:0] lbe;
    logic        [3:0] fbe;
    // Byte 8
    logic        [7:0] bus;
    // Byte 9
    logic        [4:0] dev;
    logic        [2:0] funcn;
    // Byte 10
    logic        rsvd5;
    logic        rsvd6;
    logic        rsvd7;
    logic        rsvd8;
    logic        [3:0] extregnum;
    // Byte 11
    logic        [5:0] regnum;
    logic        rsvd9;
    logic        rsvd10;
    // Byte 12-15
    logic   [31:0]      rsvd11;
} hqm_pciecfg_hdr_t;
////////////////////////////////////////
// IO
////////////////////////////////////////
typedef struct packed {
    // Byte 0
    logic        rsvd4;
    logic        [1:0] fmt ;
    logic        [4:0] ttype;
    // Byte 1
    logic        rsvd3;
    logic        [2:0] tc;
    logic        rsvd2;
    logic        attr2;
    logic        rsvd0;
    logic        oh;
    // Byte 2-3
    logic        td;
    logic        ep;
    logic        [1:0] attr;
    logic        [1:0] at;
    logic        [9:0] len;
    // Byte 4-5
    logic        [15:0] rqid;
    // Byte 6
    logic        [7:0] tag;
    // Byte 7
    logic        [3:0] lbe;
    logic        [3:0] fbe;
    // Byte 8 thru 11
    logic        [31:2] addr;
    logic        rsvd5, rsvd6;
    // Byte 12-15
    logic   [31:0]      rsvd7;
} hqm_pcieio_hdr_t;

////////////////////////////////////////
// MSG
////////////////////////////////////////
typedef struct packed {
    // Byte 0 thru 3
    logic        rsvd4;
    logic        [1:0] fmt ;
    logic        [4:0] ttype;
    // Byte 1
    logic        rsvd3;
    logic        [2:0] tc;
    logic        rsvd2;
    logic        attr2;
    logic        rsvd0;
    logic        oh;
    // Byte 2-3
    logic        td;
    logic        ep;
    logic        [1:0] attr;
    logic        [1:0] at;
    logic        [9:0] len;
    // Byte 4-5
    logic        [15:0] rqid;
    // Byte 6
    logic        [7:0] tag;
    // Byte 7
    logic        [7:0] msgcode;
    // Byte 8 thru 15
    logic        [63:0] rsvd5;
} hqm_pciemsg_hdr_t;


typedef struct packed {
    logic [31:0] dw0;
    logic [31:0] dw1;
    logic [31:0] dw2;
    logic [31:0] dw3;
} hqm_pcieraw_hdr_t;
  
////////////////////////////////////////
// PCIe Union
////////////////////////////////////////

typedef union packed {
    logic [127:0]           lec_map; // Put fake name in union to help with rename rule in LEC mapping
    hqm_pcieraw_hdr_t       dw;
    hqm_pciemem64_hdr_t     pcie64;
    hqm_pcieatomic64_hdr_t  pcieatm64;
    hqm_pciemem32_hdr_t     pcie32;
    hqm_pcieatomic32_hdr_t  pcieatm32;
    hqm_pciecpl_hdr_t       pciecpl;
    hqm_pcieio_hdr_t        pcieio;
    hqm_pciemsg_hdr_t       pciemsg;
    hqm_pciecfg_hdr_t       pciecfg;
} hqm_pcie_hdr_t;

// Header Parity struct

 typedef struct packed {
   logic            par;
   hqm_pasidtlp_t   pasidtlp;
   hqm_pcie_hdr_t   pcie_hdr;
 } hqm_pcie_hdr_par_t;

//============================================================
// IOSF Target Credit interface
//============================================================

 typedef struct packed {
  logic                            credit_put;       
  logic [HQMIOSF_NUMCHANL2:0]      credit_chid;      
  logic [1:0]                      credit_rtype;   
  logic                            credit_cmd;    
  logic [2:0]                      credit_data;  
} hqm_iosf_tgt_credit_t;


 typedef struct packed {
  logic                            cmd_put;     
  logic [HQMIOSF_NUMCHANL2:0]      cmd_chid;
  logic [1:0]                      cmd_rtype;
  logic                            cmd_nfs_err;
} hqm_iosf_tgt_cput_t;


//=========================================================
// IOSF Target Command Interface
//=========================================================

 typedef struct packed {
  logic [1:0]                           tfmt;     
  logic [4:0]                           ttype;   
  logic                                 ttc3; 
  logic [2:0]                           ttc;     
  logic                                 tep;     
  logic                                 tro;    
  logic                                 tns;   
  logic [1:0]                           tat;  
  logic [9:0]                           tlength;
  logic [15:0]                          trqid; 
  logic [7:0]                           ttag; 
  logic [3:0]                           tlbe;
  logic [3:0]                           tfbe;  
  logic [63:0]                          taddress; // jbdiethe Mstr Code assumes struct is 64 bits
  logic                                 ttd;     
  logic [31:0]                          tecrc;  
  logic                                 tecrc_error;
  logic                                 tecrc_generate;
  logic                                 trsvd1_1;
  logic                                 trsvd1_3; 
  logic                                 trsvd1_7;
  logic                                 trsvd0_7; 
  logic                                 tth;
  logic                                 tido;
  logic                                 tchain;
  logic [HQMIOSF_RS_WIDTH:0]            trs;
  logic                                 tcparity; 
  logic [HQMIOSF_SAI_WIDTH:0]           tsai;
  logic [HQMIOSF_PASIDTLP_WIDTH-1:0]    tpasidtlp;
  logic                                 tcparerr;
 } hqm_iosf_tgt_cmd_t;

//=========================================================
// IOSF Target Data Interface
//=========================================================

 typedef struct packed {
  logic [HQMIOSF_TD_WIDTH:0]        data;
  logic [HQMIOSF_TDP_WIDTH:0]       dparity;
 } hqm_iosf_tgt_data_t;

//============================================================
// IOSF Target Credit Interface
//============================================================

 typedef struct packed {
  
   logic                                  dcreditup;
   logic [`HQM_L2CEIL(HQMIOSF_PORTS)-1:0] dcredit_port;
   logic [`HQM_L2CEIL(HQMIOSF_VC)-1:0]    dcredit_vc;
   logic [1:0]                            dcredit_fc;
   logic [7:0]                            dcredit;
    
   logic                                  ccreditup;
   logic [`HQM_L2CEIL(HQMIOSF_PORTS)-1:0] ccredit_port;
   logic [`HQM_L2CEIL(HQMIOSF_VC)-1:0]    ccredit_vc;
   logic [1:0]                            ccredit_fc; 
   logic                                  ccredit;

 } hqm_iosf_tgt_crd_t;

//============================================================== 

//============================================================
// IOSF Target data and  hdr interface to the queues
//============================================================

  typedef struct packed {
   logic                                  push_data;       // Valid data
   logic [`HQM_L2CEIL(HQMIOSF_PORTS)-1:0] data_port;       // destination port of data
   logic [`HQM_L2CEIL(HQMIOSF_VC)-1:0]    data_vc;         // destination VC of data
   logic [1:0]                            data_fc;         // flow class of data
   logic [8:0]                            data_ptr_offset; // Pointer offset in the Qs in x16B
   logic                                  push_cmd;        // Valid header
   logic [`HQM_L2CEIL(HQMIOSF_PORTS)-1:0] cmd_port;        // destination port of cmd

   logic [`HQM_L2CEIL(HQMIOSF_VC)-1:0]    cmd_vc;          // destination VC of cmd
   logic [1:0]                            cmd_fc;          // flow class of cmd
   logic [6:0]                            cmd_ptr_offset;  // Pointer offset in the Qs in x16B
   
   hqm_pcie_hdr_t                         cmd_pcie_hdr;
   logic [3:0]                            hdr_par;
   logic [HQMIOSF_TD_WIDTH:0]             data;
   logic [`HQM_dw(HQMIOSF_TD_WIDTH)-1:0]  data_par;
   logic [31:0]                           ecrc;
   logic [1:0]                            alldw_data; 
   logic                                  cpar_err;
   logic                                  dpar_err;
   logic                                  tecrc_error;      // HSD 4727748 - add support for TECRC error
   logic [HQMIOSF_SAI_WIDTH:0]            sai;
   hqm_pasidtlp_t                         pasidtlp;
 } hqm_iosf_tgtq_cmddata_t; 

  
//=============================================================================
// New Struct for all the Error Checks and the extension of header struct above
//=============================================================================
 typedef struct packed {


 // Set this bit for all internal txns
  logic      int_txn;
 
 // Set this Drop bit for txns that needs to be dropped, no logging 
  logic      drop;

 // Set this bit if the txn needs to be URed
  logic      ur;  

 // Set this bit if the txn needs to be CAed
  logic      ca;

 // Set this bit for UC
  logic      uc;

 // bits for Atomic Egress Block
  logic      atomic_eb; //  Set UR bit for this? 

 // config txns
  logic      cfg;    // Cfg0 txn
        
  logic      invpage; // Invalid page

 // Config conversion
  logic     cfg1to0;  // Indicates type conversion, will also have the checks for ari.   

 // ACS violation
  logic     acsvioln;
  
 // header parity error detected
  logic     hdrpar_err;

 // parity for the bits above
  logic      par;


 } hqm_iosf_tgtq_hdrbits_t; 
//=============================================================================

//------------------------------------------------------------
// Error signaling structures
//------------------------------------------------------------

// pcie FMT Header Field Definition
typedef enum logic [1:0] {
    NDATA_3DW                                = 2'b00                                                          , 
    NDATA_4DW                                = 2'b01                                                          , 
    DATA_3DW                                 = 2'b10                                                          , 
    DATA_4DW                                 = 2'b11                                                            
} PcieHdrFmt_t;

// pcie Type Header Field Definition
typedef enum logic [4:0] {
    MRDWR                                    = 5'h00                                                          , 
    MRDLK                                    = 5'h01                                                          , 
    IORDWR                                   = 5'h02                                                          , 
    CFGRDWR0                                 = 5'h04                                                          , 
    CMPL                                     = 5'h0A                                                          , 
    CMPLLK                                   = 5'h0B                                                          , 
    MSG2RC                                   = 5'h10                                                          , 
    MSG2ADD                                  = 5'h11                                                          , 
    MSG2ID                                   = 5'h12                                                          , 
    MSGLOCAL                                 = 5'h14                                                          , 
    MSGTOACK                                 = 5'h15                                                            
} PcieHdrType_t;

// Internal Definition for Transfer Type
typedef enum logic [1:0] {
    NONE                                     = 2'b00                                                          , 
    POSTED                                   = 2'b01                                                          , 
    NPOSTED                                  = 2'b10                                                          , 
    CPL                                      = 2'b11                                                            
} XferType_t;

// Scoreboard Memory Struct
typedef struct packed {
    logic [7:0]                              cmph_cc                                                          ; // completion header credits consumed
    logic [11:0]                             cmpd_cc                                                          ; // completion data credits consumed
    logic                                    inval                                                            ; // BME has been cleared, invalidate
    logic [7:0]                              axi_id                                                           ; // AXI request ID
    logic [10:0]                             len                                                              ; // length field
    logic [4:0]                              byte_add                                                         ; // byte address bits
} SbData_t;

// pfleming - assertion - max number of hdr credits returned 
// in a single cycle. 1KB Read Request returns as 4 256Byte cmpls
// rather than 16 x 64 byte completions. On the final request
// we may need to return 8 header credits.
// Data credits are accumalated into a max of 8 credits

// Command Interface from command dispatch FUB to Transmit FUB and eSRAM FUB. - 129 bit
typedef struct packed {
    logic                                    par                                                              ; // parity on other fields
    logic                                    int_v                                                            ;
    logic                                    cq_v                                                             ;
    logic                                    cq_ldb                                                           ;
    logic [HQM_SYSTEM_CQ_WIDTH-1:0]          cq                                                               ;
    logic                                    len_par                                                          ; // parity on length field
    logic [1:0]                              add_par                                                          ; // parity on add field
    logic                                    invalid                                                          ; // indicates the transaction should not be put on the link
    logic                                    ro                                                               ; // indicates the transaction is a message
    logic [3:0]                              tc                                                               ; // Traffic class
    hqm_pasidtlp_t                           pasidtlp                                                         ; // PASID fields
    logic [7:0]                              byte_mask                                                        ; // Data Byte Mask
    logic [`HQM_TI_TRN_LEN_MSB:0]            length                                                           ; // Length, in bytes for DT commands
    logic [`HQM_TI_ADDR:0]                   add                                                              ; // CPP address
} CdCmd_t;

// Common Block Lane Definition
typedef struct packed {
    logic                                    int_v                                                            ;
    logic                                    cq_v                                                             ;
    logic                                    cq_ldb                                                           ;
    logic [HQM_SYSTEM_CQ_WIDTH-1:0]          cq                                                               ;
    logic                                    endp                                                             ; // end packet
    logic                                    stp                                                              ; // start of packet
    hqm_pasidtlp_t                           pasidtlp                                                         ; 
    logic [`HQM_dw(HQMTI_DATA_MSB+1)-1:0]    data_par                                                         ;
    logic [HQMTI_DATA_MSB:0]                 data                                                             ; 
    logic                                    hdr_par                                                          ;
    logic [127:0]                            header                                                           ; 
} ti_iosfp_ifc_t;

//  The outbound completion header
typedef struct packed {
    logic                                    par                                                              ; // 80    -> Parity
    logic                                    lok                                                              ; // 79    -> CplLk/CplDLk instead of Cpl/CplD
    logic [3:0]                              endbe                                                            ; // 78:75 -> End byte enable
    logic [3:0]                              startbe                                                          ; // 74:71 -> Start byte enable
    logic                                    ep                                                               ; // 70    -> EP - poisoned transaction, for parity errors
    logic [2:0]                              tc                                                               ; // 69:67 -> Traffic Class  
    logic [1:0]                              pm                                                               ; // 66:65 -> D3 state of function & all functions 
                                                                                                                //  (01= Function disalbed, 11 = all functions disabled)
    logic [9:0]                              length                                                           ; // 64:55 -> Data payload size
    logic [1:0]                              attr                                                             ; // 54:53 -> Attribute
    logic                                    fmt                                                              ; // 52    -> Format (data associated w/ completion)
    logic [2:0]                              cs                                                               ; // 51:49 -> Completion Status
    logic [15:0]                             cid                                                              ; // 48:33 -> Completion ID
    logic [6:0]                              addr                                                             ; // 32:26 -> Lower address bits of the request.
    logic [9:0]                              tag                                                              ; // 25:16 -> Tag field of the request
    logic [15:0]                             rid                                                              ; // 15:0  -> Request ID
} RiObCplHdr_t; 

// Internally used credit type struct
// credit accumulation counters
typedef struct packed {
    logic [11:0]                             pdata                                                            ; 
    logic [7:0]                              phdr                                                             ; 
    logic [11:0]                             cmpld                                                            ; 
    logic [7:0]                              cmplh                                                            ; 
} CdtCnt_t;

// Credit allocated counter struct
// used for aloocating infinite completion
// credits
typedef struct packed {
    logic [11:0]                             cmpld                                                            ; 
    logic [7:0]                              cmplh                                                            ; 
} CmplCdt_t;

// PCI Memory Header Struct as per PCIE spec
typedef struct packed {
    logic                                    rsvd1                                                            ; 
    PcieHdrFmt_t                             fmt                                                              ; 
    PcieHdrType_t                            typ                                                              ; 
    logic                                    rsvd2                                                            ; 
    logic [2:0]                              tc                                                               ; 
    logic                                    rsvd3                                                            ; 
    logic                                    attr2                                                            ; 
    logic                                    lnx                                                              ; 
    logic                                    th                                                               ; 
    logic                                    td                                                               ; 
    logic                                    ep                                                               ; 
    logic [1:0]                              attr                                                             ; 
    logic [1:0]                              at                                                               ; 
    logic [9:0]                              length                                                           ; 
    logic [15:0]                             rid                                                              ; 
    logic [7:0]                              tag                                                              ; 
    logic [3:0]                              dwbe2                                                            ; 
    logic [3:0]                              dwbe1                                                            ; 
    logic [63:0]                             add                                                              ; 
} PcieMHdr_t;

// PCI Completion Header Struct as per PCIE spec
typedef struct packed {
    logic                                    rsvd1                                                            ; 
    PcieHdrFmt_t                             fmt                                                              ; 
    PcieHdrType_t                            typ                                                              ; 
    logic                                    rsvd2                                                            ; 
    logic [2:0]                              tc                                                               ; 
    logic [3:0]                              rsvd3                                                            ; 
    logic                                    td                                                               ; 
    logic                                    ep                                                               ; 
    logic [1:0]                              attr                                                             ; 
    logic [1:0]                              at                                                               ; 
    logic [9:0]                              length                                                           ; 
    logic [15:0]                             cid                                                              ; 
    logic [2:0]                              stat                                                             ; 
    logic                                    bcm                                                              ; 
    logic [11:0]                             bc                                                               ; 
    logic [15:0]                             rid                                                              ; 
    logic [7:0]                              tag                                                              ; 
    logic                                    rsvd4                                                            ; 
    logic [6:0]                              add                                                              ; 
} PcieCHdr_t;

// struct to hold bus and device number for a function
typedef struct packed {
    logic [7:0]                              bus                                                              ; 
    logic [4:0]                              device                                                           ; 
} BdNum_t;

// Transmit FUB FSM States
typedef enum logic [4:0] {
                                             IDLE_TRN       = 5'b00001                                        ,
                                             PH_TRN         = 5'b00010                                        , // Posted Header
                                             IPR_TRN        = 5'b00100                                        , // Invalid Posted Request
                                             PD_TRN         = 5'b01000                                        , // Posted Data
                                             CMPLH_TRN      = 5'b10000                                          // Completion Header
} TrnState_t; 

typedef struct packed {
    logic                                    hdr_cycle_wl                                                     ; 
    logic                                    nxt_cycle_wl                                                     ; 
    XferType_t                               tlp_cmpl_wxl                                                     ; 
    logic                                    update_consumed_cnt_wl                                           ; 
    logic                                    iosf_push_wl                                                     ; 
    ti_iosfp_ifc_t                           iosf_ifc_wxl                                                     ; 
    logic                                    trn_sb_wren_wl                                                   ; 
    SbData_t                                 trn_sb_data_rxl                                                  ; 
    logic [15:0]                             ti_cmpltim_tag_wxl                                               ; 
    logic                                    ti_cmpltim_valid_wl                                              ; 
    logic                                    pull_final_deq_wl                                                ; // dequeue the end signal
} TrnOutputs_t;

typedef struct packed {
    TrnOutputs_t                             out                                                              ; 
} TrnFsm_t;

/////////////////////
// RI to/from SB
/////////////////////

typedef struct packed {
  logic                                           irdy                                    ; // IReady
  logic [ 7:0]                                    op                                      ; // Opcode
  logic [15:0]                                    dest                                    ; // Dest Port ID
  logic [ 2:0]                                    tag                                     ; // tag
  logic [47:0]                                    addr                                    ; 
  logic                                           alen                                    ; // 1 indicates 48 bit addr, 0 indicates 16 bit addr
  logic                                           eh                                      ; // Include 1 DWORD of extended header
  logic [HQMIOSF_SAI_WIDTH:0]                     sai                                     ; // capture the tsai for later use.
  logic [ 7:0]                                    fid                                     ; // Device n Function number
  logic [ 2:0]                                    bar                                     ; 
  logic [ 4:0]                                    len                                     ; // Number of Dwords to send 1 = 1DW
  logic [ 4:0]                                    dcnt                                    ; // DW cnt currently on.
  logic [ 3:0]                                    be                                      ; // Used on CfgRd/CfgWr {fbe}
  logic [ 3:0]                                    sbe                                     ; // Used on CfgRd/CfgWr {sbe}
  logic [31:0]                                    data                                    ;
  logic                                           np                                      ; // 1 Non Posted  0 Posted
} hqm_ep_sb_msg_t;

typedef struct packed {
  logic                                           vld                                     ; // Valid - store the value as it streams in
  logic                                           dvld                                    ; // Data Valid - store the value as it streams in
  logic                                           eom                                     ; // End of Completion
  logic [ 7:0]                                    op                                      ; // Opcode - 0x21 (has data) or 0x20 (no data) 
  logic [ 2:0]                                    tag                                     ; // Tag
  logic [ 1:0]                                    rsp                                     ; // SB CMP Response Status: 
                                                                                            // 00:    Successful 
                                                                                            // 01:    Unsuccessful / Not Supported 
                                                                                            // 10:    Powered Down 
                                                                                            // 11:    Multicast Mixed Status
  logic [31:0]                                    data                                    ; // Dword of Data
} hqm_sb_ep_cmp_t;

typedef struct packed {
  logic                                           irdy                                    ; // IReady
  logic [ 7:0]                                    op                                      ; // Opcode
  logic [15:0]                                    src                                     ; // Source Port ID
  logic [47:0]                                    addr                                    ; 
  logic [31:0]                                    data                                    ; // First DW of data 
  logic [31:0]                                    sdata                                   ; // Second DW of data when sbe != 0;
  logic [ 3:0]                                    fbe                                     ; // First DW byte enables Used on Register Txns
  logic [ 3:0]                                    sbe                                     ; // Second DW byte enables Used on Register Txns
  logic [ 2:0]                                    bar                                     ; // BAR 0=ARAMBAR 2=PMISCBAR 4=ETRBAR
  logic [ 7:0]                                    fid                                     ; // Device n Function number
  logic                                           np                                      ; // Non posted
  logic [HQMIOSF_SAI_WIDTH:0]                     sai                                     ; // capture the tsai for later use.
} hqm_sb_ep_msg_t;

// Struct for ri_iosf_sb -> ri_cds
typedef struct packed {
  logic                                           irdy                                    ; // IReady
  logic [47:0]                                    addr                                    ; 
  logic [31:0]                                    data                                    ; // First DW of data 
  logic [31:0]                                    sdata                                   ; // Second DW of data when sbe != 0;
  logic [ 3:0]                                    fbe                                     ; // First DW byte enables Used on Register Txns
  logic [ 3:0]                                    sbe                                     ; // Second DW byte enables Used on Register Txns
  logic [ 2:0]                                    bar                                     ; // BAR 0=ARAMBAR 2=PMISCBAR 4=ETRBAR
  logic                                           cfgrd                                   ;
  logic                                           cfgwr                                   ;
  logic                                           mmiord                                  ;
  logic                                           mmiowr                                  ;
  logic [ 7:0]                                    fid                                     ; // Device n Function number
  logic                                           np                                      ; // Non posted
  logic [HQMIOSF_SAI_WIDTH:0]                     sai                                     ; // capture the tsai for later use.
} hqm_sb_ri_cds_msg_t;

// struct for ri_cds -> sb_tgt
typedef struct packed {
  logic                                           vld                                     ; // Valid Message
  logic                                           dvld                                    ; // Valid Data in Message
  logic                                           eom                                     ; // End of Message
  logic                                           ursp                                    ; // Completion error
  logic [1:0][31:0]                               rdata                                   ; // Read data
} hqm_cds_sb_tgt_cmsg_t;


////////////////////////////
// SB xlate to/from SB tgt
////////////////////////////

typedef struct packed {
  logic                                           irdy                                    ; // SB Target is ready
  logic [15:0]                                    dest                                    ; // Destination Port ID
  logic [15:0]                                    source                                  ; // Source Port ID
  logic [7:0]                                     opcode                                  ; // Reg access opcode
  logic [2:0]                                     tag                                     ; // Transaction tag
  logic [HQMEPSB_MAX_TGT_BE:0]                    be                                      ; // Byte enables
  logic [7:0]                                     fid                                     ; // Function ID
  logic [2:0]                                     bar                                     ; // Function ID
  logic [HQMEPSB_MAX_TGT_ADR:0]                   addr                                    ; // Address
  logic [HQMEPSB_MAX_TGT_DAT:0]                   wdata                                   ; // Write data
  logic                                           np                                      ; // 1=non-posted/0=posted
  logic [HQMIOSF_NUM_RX_EXT_HEADERS:0][31:0]      ext_header                              ; // received extended headers 
  logic                                           eh                                      ; // state of 'eh' bit in standard header 
  logic                                           eh_discard                              ; // indicates unsupported header discarded
} hqm_sb_tgt_msg_t;

typedef struct packed {
  logic                                           ursp                                    ; // Completion error
  logic [1:0][31:0]                               data                                    ; // Read data
  logic                                           dvld                                    ; // 
  logic                                           vld                                     ; // 
  logic                                           eom                                     ; // 
} hqm_sb_tgt_cmsg_t;

typedef logic[`HQM_FUNC_RST_CNTR_SZ-1:0]                    rst_cnt_t;
typedef logic[LLC_PACKET_DWIDTH-1:0]                        ri_bus_width_t;
typedef logic[(LLC_PACKET_DWIDTH/32)-1:0]                   ri_bus_par_t; // parity per DWord
typedef logic[`HQM_DSL_MAX_HDR_SIZE-1:0]                    hdr_t;
typedef logic[`HQM_CSR_BAR_SIZE-1:0]                        hdr_addr_t;
typedef logic[`HQM_CSR_BAR_SIZE-1:2]                        nphdr_addr_t;
typedef logic[7:0]                                          hdr_tag_t;
typedef logic[9:0]                                          nphdr_tag_t;
typedef logic[2:0]                                          hdr_tc_t;
typedef logic[15:0]                                         hdr_reqid_t;
typedef logic[3:0]                                          hdr_byten_t;
typedef logic[`HQM_PHDR_LEN_SZ-1:0]                         hdr_len_t;
typedef logic[2:0]                                          hdr_cmd_t;
typedef logic[2:0]                                          phdr_cmd_t;
typedef logic[2:0]                                          nphdr_cmd_t;
typedef logic[5:0]                                          cplhdr_addr_t;
typedef logic[15:0]                                         cplhdr_cid_t;
typedef logic[15:0]                                         cplhdr_rid_t;
typedef logic[2:0]                                          cplhdr_stat_t;
typedef logic[`HQM_CPLHDR_LEN_SZ-1:0]                       cplhdr_len_t;
typedef logic[11:0]                                         cplhdr_bc_t;

typedef logic[1:0]                                          tlq_ioqdata_t;

typedef logic[`HQM_CSR_SIZE-1:0]                            csr_data_t;
typedef logic[7:0]                                          csr_func_t;


typedef logic[`HQM_CDS_CMD_SIGNUM_WID-1:0]                  cds_signum_t;
typedef logic[`HQM_CDS_CMD_SIGNUM_SZ-1:0]                   cds_signum1h_t;

typedef struct packed {
    logic [(RI_PDATA_WID/32)-1:0]                           parity;
    logic [RI_PDATA_WID-1:0]                                data;
} tlq_pdata_t;

typedef struct packed {
    logic [(RI_NPDATA_WID/32)-1:0]                          parity;
    logic [RI_NPDATA_WID-1:0]                               data;
} tlq_npdata_t;

typedef logic[`HQM_OBC_HDR_RF_SZ-1:0] obc_rf_ptr_t;

typedef struct packed {
    cds_signum_t                       signum;              // Unique signal number for header
    RiObCplHdr_t                       hdr;                 // The OBC header entry#
} obcpl_hdr_rf_t;

// the bit defines for a completion header decode
typedef struct packed {
    logic [2:0]                        tc;                   // 81:79 traffic class
    logic                              ido;                  // 78 ID ordering
    logic                              ro;                   // 77 relaxed ordering
    logic                              ns;                   // 76 no snoop
    logic                              poison;               // 75 poison bit
    cplhdr_rid_t                       rid;                  // 74:59 Requestor ID
    cplhdr_cid_t                       cid;                  // 58:43 Completor ID
    cplhdr_addr_t                      addr;                 // 42:36 completion address
    cplhdr_bc_t                        bc;                   // 35:24 Number of bytes outstanding
    cplhdr_stat_t                      status;               // 23:21 completion status
    cplhdr_len_t                       length;               // 20:11 completion length
    logic                              wdata;                // 10 completion with data
    nphdr_tag_t                        tag;                  // 9:0 Tag 
} tdl_cplhdr_t;

// The bit defines for the posted header decode signals

typedef struct packed {
    logic                              cmdlen_par;          // 152     Parity on cmd, fmt, type, & length fields
    logic [1:0]                        addr_par;            // 151:150 Parity on addr field
    logic [1:0]                        par;                 // 149:148 Parity on other fields
    logic [1:0]                        fmt;                 // 147:146 Original fmt  field
    logic [4:0]                        ttype;               // 145:141 Original type field
    hqm_pasidtlp_t                     pasidtlp;            // 140:118 PASIDTLP
    logic [7:0]                        sai;                 // 117:110 SAI
    logic                              poison;              // 109 Packet is poisoned
    hdr_addr_t                         addr;                // 108:45 Address 
    hdr_tag_t                          tag;                 // 44:37 Tag 
    hdr_reqid_t                        reqid;               // 36:21 Request ID 
    hdr_byten_t                        endbe;               // 20:17 final byte enable 
    hdr_byten_t                        startbe;             // 16:13 start byte enable 
    hdr_len_t                          length;              // 12:3 Size of request 
    phdr_cmd_t                         cmd;                 // 2:0 The posted header command
} tdl_phdr_t;

typedef struct packed {
    logic                              addr_par;            // 160     Parity on addr field
    logic                              par;                 // 159     Parity on other fields
    logic [1:0]                        fmt;                 // 158:157 Original fmt  field
    logic [4:0]                        ttype;               // 156:152 Original type field
    hqm_pasidtlp_t                     pasidtlp;            // 151:129 PASIDTLP
    logic [7:0]                        sai;                 // 128:121 SAI of request
    logic [2:0]                        iosfsb;              // 120:118 sideband indication (majority for hdr parity error case)
    logic [1:0]                        attr;                // 117:116 HSD 4240171 NS/RO (for IOSF Compliance)
    hdr_tc_t                           tc;                  // 115:113 Traffic class
    logic                              posted;              // 112 flag if the header is posted
    logic                              poison;              // 111 Packet is poisoned
    hdr_addr_t                         addr;                // 110:47 Address 
    nphdr_tag_t                        tag;                 // 46:37 Tag 
    hdr_reqid_t                        reqid;               // 36:21 Request ID 
    hdr_byten_t                        endbe;               // 20:17 final byte enable 
    hdr_byten_t                        startbe;             // 16:13 start byte enable 
    hdr_len_t                          length;              // 12:3 Size of request 
    hdr_cmd_t                          cmd;                 // 2:0 The posted header command
} cbd_hdr_t;

typedef struct packed {
  logic                                     is_ldb;
  logic [7:0]                               prod_port;
  logic [2:0]                               num_hcw;
  logic                                     is_nm;
  logic [3:0]                               cl;
} hcw_wr_hdr_t;

// The bit defines for the non posted header decode signals
typedef struct packed {
    logic                              cmdlen_par;          // 157     Parity on cmd, fmt, type, & length fields
    logic [1:0]                        addr_par;            // 156:155 Parity on addr field
    logic [1:0]                        par;                 // 154:153 Parity on other fields
    logic [1:0]                        fmt;                 // 152:151 Original fmt  field
    logic [4:0]                        ttype;               // 150:146 Original type field
    hqm_pasidtlp_t                     pasidtlp;            // 145:123 PASIDTLP
    logic [7:0]                        sai;                 // 122:115 SAI
    logic [1:0]                        attr;                // 114:113 NS/RO (for IOSF Compliance)
    hdr_tc_t                           tc;                  // 112:110 Traffic class
    logic                              poison;              // 109 Packet is poisoned
    nphdr_addr_t                       addr;                // 108:47 Address (doesn't include bits 1:0)
    nphdr_tag_t                        tag;                 // 46:37 Tag 
    hdr_reqid_t                        reqid;               // 36:21 Request ID 
    hdr_byten_t                        endbe;               // 20:17 final byte enable 
    hdr_byten_t                        startbe;             // 16:13 start byte enable 
    hdr_len_t                          length;              // 12:3 Size of request 
    nphdr_cmd_t                        cmd;                 // 2:0 The posted header command
} tdl_nphdr_t;

// The source of the outbound completion data
typedef enum logic[1:0] {
    INTERNAL = 2'b01,
    CPP_PUSH = 2'b10,
    IOSFSB   = 2'b11
} signal_src_t;

// Data format for the OBC pending data fifo.
typedef struct packed {
    signal_src_t    signal_src;             // 7:6 The source of the data
    cds_signum_t    signal_number;          // 5:2 The Signal number for the header 
} pend_sig_data_t;

// AER Uncorrectable Error Mask CSR
typedef struct packed {
    logic              ieunc;
    logic              ur;
    logic              ecrcc;
    logic              mtlp;
    logic              ro;
    logic              ec;
    logic              ca;
    logic              ct;
    logic              fcpes;
    logic              ptlpr;
    logic              dlpe;
} ppaerucm_t;

// Correctable Error Mask Register
typedef struct packed {
    logic              iecor;
    logic              anfes;
    logic              rtts;
    logic              rnrs;
    logic              bdllps;
    logic              dlpe;
    logic              res;
} ppaercm_t;

// AER Capabilities Register 
typedef struct packed {
    logic              rnrs;
    logic              bdllps;
    logic              dlpe;
    logic              ecrcgc;
    logic              ecrccc;
    logic              ecrcce;
} ppaerctlcap_t;

typedef struct packed {
    logic              dpe;
    logic              sse;
    logic              rma;
    logic              rta;
    logic              sta;
    logic              mdpe;
} pcists_t;

// Device command register
typedef struct packed {
    logic              ser;
    logic              per;
} pcicmd_t;

// Device control register 
typedef struct packed {
    logic              ero;
    logic              urro;
    logic              fere;
    logic              nere;
    logic              cere;
    logic              ens;
} ppdcntl_t;

typedef logic[`HQM_CSR_PPMCSR_DLY-1:0]  ppmcsr_dly_t;

typedef enum logic[3:0] {
    IEUNC,
    UR,
    ECRCC,
    MTLP,
    RO,
    EC,
    CA,
    CT,
    FCPES,
    PTLPR,
    DLPE 
} uerr_t;

typedef enum logic[3:0] {
    IECOR,
    ANFES,
    RTTS,
    RNRS,
    BDLLPS,
    BDLPE,
    RES
} cerr_t;

typedef enum logic[4:0] {
    RES_EL,
    BDLPE_EL,
    BDLLPS_EL,
    RNRS_EL,
    RTTS_EL,
    ANFES_EL,
    IECOR_EL,
    DLPE_EL,  
    PTLPR_EL,
    FCPES_EL,
    CT_EL,
    CA_EL,
    EC_EL,
    RO_EL,
    MTLP_EL,
    ECRCC_EL,
    UR_EL,
    IEUNC_EL
} hdrlog_err_t;

typedef struct packed {
    hqm_pasidtlp_t                      pasidtlp;
    hdr_t                               header;
} errhdr_t;

// Error Source 3

typedef struct packed {
    logic                               pend_err;
    csr_func_t                          func;
    logic                               severity;
} pend_err_t;

typedef pend_err_t  [`HQM_NUM_UERR_SRC-1:0]                     all_pend_uerr_t; 
typedef pend_err_t  [`HQM_NUM_CERR_SRC-1:0]                     all_pend_cerr_t; 
typedef logic       [`HQM_NUM_UERR_SRC-1:0]                     pend_uerr_vec_t;
typedef logic       [`HQM_NUM_CERR_SRC-1:0]                     pend_cerr_vec_t;
typedef logic       [`HQM_NUM_UERR_SRC+`HQM_NUM_CERR_SRC-1:0]   pend_err_vec_t;
typedef csr_func_t  [`HQM_NUM_UERR_SRC-1:0]                     pend_uerr_func_t;
typedef csr_func_t  [`HQM_NUM_CERR_SRC-1:0]                     pend_cerr_func_t;
typedef errhdr_t    [`HQM_NUM_ERR_SRC-1:0]                      hdr_log_t; 

typedef logic [4:0]                         csr_ppaerctlcap_ferrp_t;

typedef enum logic [1:0] {
    XXXX  = 2'b00,
    BME   = 2'b01,
    MSIE  = 2'b10,
    MSIXE = 2'b11
} upd_enable_t;

typedef struct packed {
    upd_enable_t                        enable; // Encoded enable bit name
    logic                               value;  // Value to which the enable bit should be updated
} upd_enables_t;

// collage-pragma translate_off

`ifndef INTEL_SVA_OFF

 `ifndef HQM_SYS_CLK
 `define HQM_SYS_CLK null
 `endif

 // System Verilog Assertion properties
 property hqm_p_cover(seq, clk=`HQM_SYS_CLK, rst=1'b0);
    @(clk) disable iff(rst) seq;
 endproperty : hqm_p_cover

 property hqm_p_never(prop, clk=`HQM_SYS_CLK, rst=1'b0);
    @(clk) disable iff(rst) not(prop);
 endproperty : hqm_p_never

 property hqm_p_verify(prop, clk=`HQM_SYS_CLK, rst=1'b0);
    @(clk) disable iff(rst) prop;
 endproperty : hqm_p_verify

`endif // INTEL_SVA_OFF

// collage-pragma translate_on

endpackage: hqm_system_type_pkg

