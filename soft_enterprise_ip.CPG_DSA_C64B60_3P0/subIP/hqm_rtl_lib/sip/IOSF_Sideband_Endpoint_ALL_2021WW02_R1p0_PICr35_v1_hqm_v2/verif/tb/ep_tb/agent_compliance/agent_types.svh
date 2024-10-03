//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author          : ddaftary
// Co-Author       : sshah3
// Date Created : 10-31-2011 
//-----------------------------------------------------------------
// Description:
// This file contains definitions of some macros that are used in the
// agent assumption files
//------------------------------------------------------------------

`ifndef AGT_TYPES
`define AGT_TYPES

typedef bit[7:0] agt_flit_t;

typedef struct packed {
   agt_flit_t[71:0] flits;
   int num_flits;
   bit vld;
} agt_message_buf_t;

`define SBEREGB(b) b == 31 ?  3 :  7

/**
 * Opcode Ranges
 */
`define AGT_REG_EP_OP_RANGE           ['b00010000:'b00011111]
`define AGT_DATA_EP_OP_RANGE          ['b01100000:'b01111111]
`define AGT_SIMPLE_EP_OP_RANGE        ['b10100000:'b11111111]

/**
 * Global Simple Message Opcodes
 */
typedef enum bit[7:0] {
   AGT_ASSERT_INTA   = 'b10000000, 
   AGT_ASSERT_INTB   = 'b10000001,
   AGT_ASSERT_INTC   = 'b10000010,
   AGT_ASSERT_INTD   = 'b10000011,
   AGT_DEASSERT_INTA = 'b10000100,
   AGT_DEASSERT_INTB = 'b10000101,
   AGT_DEASSERT_INTC = 'b10000110,
   AGT_DEASSERT_INTD = 'b10000111,
   AGT_DO_SERR       = 'b10001000,
   AGT_ASSERT_SCI      = 8'b1000_1001,
   AGT_DEASSERT_SCI    = 8'b1000_1010,
   AGT_ASSERT_SSMI     = 8'b1000_1011,
   AGT_ASSERT_SMI      = 8'b1000_1100,
   AGT_DEASSERT_SSMI   = 8'b1000_1101,
   AGT_DEASSERT_SMI    = 8'b1000_1110,
   AGT_SMI_ACK         = 8'b1000_1111,
   AGT_ASSERT_PME      = 8'b1001_0000,
   AGT_DEASSERT_PME    = 8'b1001_0001,
   AGT_SYNCCOMP        = 8'b1001_0010,
   AGT_ASSERT_NMI      = 8'b1001_0011,
   AGT_DEASSERT_NMI    = 8'b1001_0100, 
   AGT_SIMPLE_EP_RANGE_MIN = 'b10100000, 
   AGT_SIMPLE_EP_RANGE_MAX = 'b11111111
} agt_simple_gl_opcode_t;

function bit agt_msg_is_simple (
   input bit[7:0] opcode
);
   if((( AGT_ASSERT_INTA <=opcode ) && (opcode <=AGT_DEASSERT_NMI)) 
      || ((AGT_SIMPLE_EP_RANGE_MIN <= opcode) && (opcode <= AGT_SIMPLE_EP_RANGE_MAX)))begin
       agt_msg_is_simple = 1;
   end
   else
     agt_msg_is_simple = 0;
   
   /*agt_msg_is_simple = opcode inside
      {
         [AGT_ASSERT_INTA:AGT_DEASSERT_NMI],
         `AGT_SIMPLE_EP_OP_RANGE 
      };*/ 
endfunction

/**
 * Global Message with Data Opcodes
 */
typedef enum bit[7:0] {
   AGT_PM_REQ       = 'b01000000, 
      // PMU requests agent to initiate a state transition
   AGT_PM_DMD       = 'b01000001, 
      // Agent indicates a request for a specified power state or provide its
      // latency parameters to PMU
   AGT_PM_RSP      = 'b01000010, 
      // Agent response to AGT_PM_REQ
   AGT_PCI_PM      = 'b01001000, 
      // PCI-PM message
   AGT_PCI_E_ERROR = 'b01001001,
   AGT_SYNCSTARTCMD    = 8'b0101_0000,
   AGT_LOCALSYNC       = 8'b0101_0001, 
   AGT_ASSERT_PME_WITHDATA = 8'b0101_0010,
   AGT_DEASSERT_PME_WITHDATA = 8'b0101_0011,
   AGT_ASSERT_IRQN    = 8'b0101_0100,
   AGT_DEASSERT_IRQN  = 8'b0101_0101,


    AGT_BOOTPREP          =  8'b0010_1000,
    AGT_BOOTPREP_ACK      =  8'b0010_1001,
    AGT_RESETPREP         =  8'b0010_1010,
    AGT_RESETPREP_ACK     =  8'b0010_1011,
    AGT_RST_REQ           =  8'b0010_1100,
    AGT_VIRTUAL_WIRE      =  8'b0010_1101,
    AGT_FORCE_PWRGATE_POK =  8'b0010_1110,


      // PCI-e error. Data field includes message type (CORR, NON-FATAL, or 
      // FATAL and the requester ID).
   AGT_LTR = 'b01000011, //LTR
   AGT_DOPME = 'b01000100, //DoPME for HSD:1113837
   AGT_DATA_EP_RANGE_MIN = 'b01100000,
   AGT_DATA_EP_RANGE_MAX = 'b01111111                    
} agt_data_gl_opcode;

function bit agt_msg_is_data (
   input bit[7:0] opcode
);
   if((( AGT_PM_REQ <=opcode ) && (opcode <= AGT_DEASSERT_IRQN)) || (( AGT_BOOTPREP <=opcode ) && (opcode <= AGT_FORCE_PWRGATE_POK)) ||
       ((AGT_DATA_EP_RANGE_MIN <= opcode) && (opcode <= AGT_DATA_EP_RANGE_MAX)))begin
       agt_msg_is_data = 1;
   end
   else
     agt_msg_is_data = 0;


   
   
endfunction

/**
 * Global Register Access Messages
 */
typedef enum bit[7:0] {
   AGT_MRD   = 'b00000000,  // Read memory mapped register
   AGT_MWR   = 'b00000001,  // Write memory mapped register
   AGT_IORD  = 'b00000010,  // Read I/O mapped register
   AGT_IOWR  = 'b00000011,  // Write I/O mapped register
   AGT_CFGRD = 'b00000100,  // Read PCI configuration register
   AGT_CFGWR = 'b00000101,  // Write PCI configuration register
   AGT_CRRD  = 'b00000110,  // Read private control register
   AGT_CRWR  = 'b00000111,   // Write private control register
   AGT_REG_EP_RANGE_MIN = 'b00010000,
   AGT_REG_EP_RANGE_MAX = 'b00011111
} agt_reg_access_gl_opcode;

parameter AGT_BE_FLIT             = 4;
parameter AGT_FST_ADDR_FLIT       = 6;
parameter AGT_DW_SIZE             = 4;
   
`define AGT_ADDRMODE_FIELD        6:6
`define AGT_SBE_FIELD             7:4
`define AGT_RESERVED_FIELD        6:3
`define AGT_EH_FIELD               7:7


function bit agt_msg_is_DW_aligned (input int num_flits);
   agt_msg_is_DW_aligned = (num_flits > 0) & ((num_flits & 2'b11) == 0);
      
endfunction

function bit agt_msg_is_reg_access (
   input bit[7:0] opcode);

   if(((AGT_MRD <=opcode) && (opcode <= AGT_CRWR)) || 
      ((AGT_REG_EP_RANGE_MIN <= opcode) && (opcode <= AGT_REG_EP_RANGE_MAX)))begin
      agt_msg_is_reg_access = 1;
   end
   else
      agt_msg_is_reg_access = 0;
   
/*   agt_msg_is_reg_access = opcode inside 
      { 
         [AGT_MRD:AGT_CRWR], 
         `AGT_REG_EP_OP_RANGE
      };*/
  endfunction

function bit agt_msg_is_gl_reg_read (
   input bit[7:0] opcode
);
   if((opcode==AGT_MRD)||(opcode==AGT_IORD)||(opcode==AGT_CFGRD)||(opcode==AGT_CRRD))
     agt_msg_is_gl_reg_read = 1;
   else
     agt_msg_is_gl_reg_read = 0;
   
   /*agt_msg_is_gl_reg_read = opcode inside 
      {
         AGT_MRD, AGT_IORD, AGT_CFGRD, 
	 AGT_CRRD
      };*/
endfunction

function bit agt_msg_is_reg_read (
   input bit[7:0] opcode
);
   agt_msg_is_reg_read = 
      agt_msg_is_reg_access( opcode ) && (opcode[0] == 0);
endfunction

function bit agt_msg_is_gl_reg_write (
   input bit[7:0] opcode
);
   if((opcode==AGT_MWR)||(opcode==AGT_IOWR)||(opcode==AGT_CFGWR)||(opcode==AGT_CRWR))
     agt_msg_is_gl_reg_write = 1;
   else
     agt_msg_is_gl_reg_write = 0;
   
  /* agt_msg_is_gl_reg_write = opcode inside 
   {
      AGT_MWR, AGT_IOWR, AGT_CFGWR, 
      AGT_CRWR
   };*/
endfunction
  
function bit agt_msg_is_reg_write (
   input bit[7:0] opcode
);
   agt_msg_is_reg_write = 
      agt_msg_is_reg_access( opcode ) && (opcode[0] == 1);
endfunction

/**
 * Global Completion Data Opcodes
 */
typedef enum bit[7:0] {
   AGT_CMP  = 'b00100000, // Completion without data
   AGT_CMPD = 'b00100001  // Completion with data
} agt_completion_gl_opcode;

`define AGT_RSP_FIELD               4:3
`define AGT_RSP_RESERVED_FIELD      6:5

function bit agt_msg_is_completion (
   input bit[7:0] opcode
);
   if((AGT_CMP <=opcode ) && (opcode <= AGT_CMPD))begin
      agt_msg_is_completion = 1;
   end
   else agt_msg_is_completion = 0;
   
   /*agt_msg_is_completion = 
      opcode inside{ [AGT_CMP:AGT_CMPD]};*/
endfunction

/**
 * RSP values
 */
parameter AGT_RSP_SUCCESS = 2'b00;
parameter AGT_RSP_UNSUCCESS = 2'b01;
parameter AGT_RSP_POWER_DOWN = 2'b10;
parameter AGT_RSP_MULTI_MIXED = 2'b11;

//parameter type AGT_MULTICAST_ID_TYPE = enum bit[7:0] { AGT_BROADCAST = 8'hFF };

/**
 * Multicast group definition
 */
//parameter AGT_TOTAL_MCAST_PIDS = 256;



`endif
