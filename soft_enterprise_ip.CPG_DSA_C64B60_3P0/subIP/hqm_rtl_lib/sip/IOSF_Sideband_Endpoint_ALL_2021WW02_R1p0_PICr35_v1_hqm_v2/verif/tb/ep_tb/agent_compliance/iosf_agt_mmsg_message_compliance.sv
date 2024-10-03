`include "agt_types.svh"

module

iosf_agt_mmsg_message_compliance #(parameter int MAXPCMSTR=0,
                                   parameter int MAXNPMSTR=0,
                                   parameter int MAXPCTRGT=0,
                                   parameter int MAXNPTRGT=0,
                                   parameter int MAXTRGTADDR=31,
                                   parameter int MAXTRGTDATA=63,
                                   parameter int MAXMSTRADDR=31,
                                   parameter int MAXMSTRDATA=63,
                                   parameter int NUM_TX_EXT_HEADERS=0,
                                   parameter int NUM_RX_EXT_HEADERS=0) 
(
   input bit   clk,
   input bit   reset,
   input agt_message_buf_t m_agt_pc_msg_buf,
   input agt_message_buf_t m_agt_np_msg_buf
);

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
   AGT_ASSERT_PME    = 'b10010000,
   AGT_DEASSERT_PME  = 'b10010001 
} agt_simple_gl_opcode_t;

function bit agt_message_is_simple (
   input bit[7:0] opcode
);
   agt_message_is_simple = opcode inside
      {
         [AGT_ASSERT_INTA:AGT_DO_SERR],
          AGT_ASSERT_PME, AGT_DEASSERT_PME,
	 `AGT_SIMPLE_EP_OP_RANGE 
      };
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
      // PCI-e error. Data field includes message type (CORR, NON-FATAL, or 
      // FATAL and the requester ID).
   AGT_LTR = 'b01000011, //LTR
   AGT_DOPME = 'b01000100 //DoPME for HSD:1113837
} agt_data_gl_opcode;

function bit agt_message_is_data (
   input bit[7:0] opcode
);
   agt_message_is_data = opcode inside
      { 
         AGT_PM_REQ, AGT_PM_DMD, 
	 AGT_PM_RSP, AGT_PCI_PM,
	 AGT_PCI_E_ERROR,AGT_LTR,
         AGT_DOPME,
	 `AGT_DATA_EP_OP_RANGE
      };
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
   AGT_CRWR  = 'b00000111   // Write private control register
} agt_reg_access_gl_opcode;

parameter AGT_BE_FLIT             = 4;
parameter AGT_FST_ADDR_FLIT       = 6;

`define AGT_ADDRMODE_FIELD        6:6
`define AGT_SBE_FIELD             7:4


function bit agt_message_is_DW_aligned (input int num_flits);
   agt_message_is_DW_aligned = (num_flits > 0) & ((num_flits & 2'b11) == 0);
      
endfunction



function bit agt_message_is_reg_access (
   input bit[7:0] opcode);
   agt_message_is_reg_access = opcode inside 
      { 
         [AGT_MRD:AGT_CRWR], 
         `AGT_REG_EP_OP_RANGE
      };
  endfunction

function bit agt_message_is_gl_reg_read (
   input bit[7:0] opcode
);
   agt_message_is_gl_reg_read = opcode inside 
      {
         AGT_MRD, AGT_IORD, AGT_CFGRD, 
	 AGT_CRRD
      };
endfunction

function bit agt_message_is_reg_read (
   input bit[7:0] opcode
);
   agt_message_is_reg_read = 
      agt_message_is_reg_access( opcode ) && (opcode[0] == 0);
endfunction

function bit agt_message_is_gl_reg_write (
   input bit[7:0] opcode
);
   agt_message_is_gl_reg_write = opcode inside 
   {
      AGT_MWR, AGT_IOWR, AGT_CFGWR, 
      AGT_CRWR
   };
endfunction
  
function bit agt_message_is_reg_write (
   input bit[7:0] opcode
);
   agt_message_is_reg_write = 
      agt_message_is_reg_access( opcode ) && (opcode[0] == 1);
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

function bit agt_message_is_completion (
   input bit[7:0] opcode
);
   agt_message_is_completion = 
      opcode inside{ [AGT_CMP:AGT_CMPD]};
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

   
   `define m_agt_pc_msg_tag_etc_reserved_field (m_agt_pc_msg_tag_etc[6:3])

   `define m_agt_pc_msg_tag_etc_addrmode (m_agt_pc_msg_tag_etc[6:6])
   
   `define m_agt_pc_msg_tag_etc_rsp (m_agt_pc_msg_tag_etc[4:3])

   `define m_agt_np_msg_tag_etc_reserved_field (m_agt_np_msg_tag_etc[6:3])

   `define m_agt_np_msg_tag_etc_addrmode (m_agt_np_msg_tag_etc[6:6])
   
   `define m_agt_np_msg_tag_etc_rsp (m_agt_np_msg_tag_etc[4:3])
   
   /**
    * Internal signals for message opcodes and tags
    */
   
   bit [7:0] m_agt_pc_msg_opcode;
   bit [7:0] m_agt_pc_msg_tag_etc;
   bit [7:0] m_agt_np_msg_opcode;
   bit [7:0] m_agt_np_msg_tag_etc;
   
   //genvar iter;

   //*************************************************************************
   // Message Validity Check
   //*************************************************************************

   //generate for (iter = 0; iter<2; iter++) begin: vld_msg_chk

   /**
    * Extract opcodes and tags from messages
    */
   assign m_agt_pc_msg_opcode = m_agt_pc_msg_buf.flits[2];
   assign m_agt_pc_msg_tag_etc = m_agt_pc_msg_buf.flits[3];
   assign m_agt_np_msg_opcode = m_agt_np_msg_buf.flits[2];
   assign m_agt_np_msg_tag_etc = m_agt_np_msg_buf.flits[3];
   
   

   
      //if (iter == 0) begin

   //valid message size, multiple of dw   
  /* property mmsg_pc_size_vld;
     @(posedge clk) disable iff(reset) 
     (m_agt_pc_msg_buf.vld) |-> (agt_message_is_DW_aligned( m_agt_pc_msg_buf.num_flits ));
   endproperty        
   mmsg_pc_size_vld_assume: assume property (mmsg_pc_size_vld);
*/

/*
      //valid opcode 
      property mmsg_pc_opcode_vld;
        @(posedge clk) disable iff(reset) m_agt_msg_buf[iter].vld 
        |-> ((agt_message_is_simple ( m_agt_msg_opcode[iter] ) || 
              agt_message_is_data ( m_agt_msg_opcode[iter] ) ||       
              agt_message_is_completion ( m_agt_msg_opcode[iter] ) || 
              agt_message_is_reg_access ( m_agt_msg_opcode[iter] )));
      
      endproperty        
      mmsg_pc_opcode_vld_assume: assume property (mmsg_pc_opcode_vld);  

      //valid simple message size
      property mmsg_pc_simple_msg_vld;
      @(posedge clk) disable iff(reset) ((m_agt_msg_buf[iter].vld) && 
                                         (agt_message_is_simple ( m_agt_msg_opcode[iter])))
      |-> (m_agt_msg_buf[iter].num_flits == 4);
      endproperty
      mmsg_pc_simple_msg_vld_assume: assume property (mmsg_pc_simple_msg_vld);

      //reserved field ==0 for simple message
      property mmsg_pc_simple_reserved_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_msg_buf[iter].vld) && 
                                         (agt_message_is_simple ( m_agt_msg_opcode[iter])))
      |-> (`m_agt_msg_tag_etc_reserved_field == 0);
      endproperty
      mmsg_pc_simple_reserved_fld_vld_assume: assume property (mmsg_pc_simple_reserved_fld_vld);

      //valid msgd message size
      property mmsg_pc_msgd_msg_vld;
      @(posedge clk) disable iff(reset) ((m_agt_msg_buf[iter].vld) && 
                                         (agt_message_is_data ( m_agt_msg_opcode[iter])))
      |-> (m_agt_msg_buf[iter].num_flits >= 2 * 4);
      endproperty
      mmsg_pc_msgd_msg_vld_assume: assume property (mmsg_pc_msgd_msg_vld);

      //reserved field == 0 for msgd messages
      property mmsg_pc_msgd_reserved_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_msg_buf[iter].vld) && 
                                         (agt_message_is_msgd ( m_agt_msg_opcode[iter])))
      |-> (`m_agt_msg_tag_etc_reserved_field == 0);
      endproperty
      mmsg_pc_msgd_reserved_fld_vld_assume: assume property (mmsg_pc_msgd_reserved_fld_vld);

      //addrlen should be 0 or 1 for regio messages
      property mmsg_pc_regio_addrlen_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_msg_buf[iter].vld) && 
                                         (agt_message_is_reg_access ( m_agt_msg_opcode[iter])))
      |-> (`m_agt_msg_tag_etc_addrmode == 0) || (`m_agt_msg_tag_etc_addrmode == 1);
      endproperty
      mmsg_pc_regio_addrlen_fld_vld_assume: assume property (mmsg_pc_regio_addrlen_fld_vld);

      //cfgwr, cfgrd, iowr, iord need 16 bit addrlen
      property mmsg_pc_regio_cfgio_addrlen_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_msg_buf[iter].vld) && 
                                         (m_agt_msg_opcode[iter] inside 
                                          { AGT_IORD, AGT_IOWR,
                                            AGT_CFGRD, AGT_CFGWR}))
      |-> (`m_agt_msg_tag_etc_addrmode == 0);
      endproperty
      mmsg_pc_regio_cfgio_addrlen_fld_vld_assume: assume property (mmsg_pc_regio_cfgio_addrlen_fld_vld);
 
      //mwr, mrd, iowr, iord need dw alligned address
      property mmsg_pc_regio_mio_dw_addr_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_msg_buf[iter].vld) && 
                                         (m_agt_msg_opcode[iter] inside 
                                          { AGT_IORD, AGT_IOWR,
                                            AGT_MRD, AGT_MWR}))
      |-> (m_agt_msg_buf[iter].flits[AGT_FST_ADDR_FLIT][1:0] == 2'b00);
      endproperty
      mmsg_pc_regio_mio_dw_addr_fld_vld_assume: assume property (mmsg_pc_regio_mio_dw_addr_fld_vld);

      //cfgrd, cfgwr need dw alligned address
      property mmsg_pc_regio_cfg_dw_addr_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_msg_buf[iter].vld) && 
                                         (agt_message_is_reg_access(m_agt_msg_opcode[iter]))) 
      |-> (m_agt_msg_buf[iter].flits[AGT_FST_ADDR_FLIT][1] == 1'b0);
      endproperty
      mmsg_pc_regio_cfg_dw_addr_fld_vld_assume: assume property (mmsg_pc_regio_cfg_dw_addr_fld_vld);

      //regio addr QW alligned
      property mmsg_pc_regio_qw_addr_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_msg_buf[iter].vld) && 
                                         (agt_message_is_reg_access(m_agt_msg_opcode[iter])) &&
                                         m_agt_msg_buf[iter].flits[AGT_BE_FLIT][`AGT_SBE_FIELD] > 0)
      |-> (m_agt_msg_buf[iter].flits[AGT_FST_ADDR_FLIT][2] == 0);
      endproperty
      mmsg_pc_regio_qw_addr_fld_vld_assume: assume property (mmsg_pc_regio_qw_addr_fld_vld);
*/
      
      //end
      
     /* if (iter == 1) begin
      property mmsg_np_size_vld;
        @(posedge clk) disable iff(reset) 
        (m_agt_msg_buf[iter].vld) |-> (agt_message_is_DW_aligned( m_agt_msg_buf[iter].num_flits ));
      endproperty        
      mmsg_np_size_vld_assume: assume property (mmsg_np_size_vld);

      property mmsg_np_opcode_vld;
        @(posedge clk) disable iff(reset) m_agt_msg_buf[iter].vld 
        |-> ((agt_message_is_simple ( m_agt_msg_opcode[iter] ) || 
              agt_message_is_data ( m_agt_msg_opcode[iter] ) ||       
              agt_message_is_completion ( m_agt_msg_opcode[iter] ) || 
              agt_message_is_reg_access ( m_agt_msg_opcode[iter] )));
      
      endproperty        
      mmsg_np_opcode_vld_assume: assume property (mmsg_np_opcode_vld); 

      property mmsg_np_simple_msg_vld;
      @(posedge clk) disable iff(reset) ((m_agt_msg_buf[iter].vld) && 
                                         (agt_message_is_simple ( m_agt_msg_opcode[iter])))
      |-> (m_agt_msg_buf[iter].num_flits == 4);
      endproperty
      mmsg_np_simple_msg_vld_assume: assume property (mmsg_np_simple_msg_vld);

      property mmsg_np_simple_reserved_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_msg_buf[iter].vld) && 
                                         (agt_message_is_simple ( m_agt_msg_opcode[iter])))
      |-> (`m_agt_msg_tag_etc_reserved_field == 0);
      endproperty
      mmsg_np_simple_reserved_fld_vld_assume: assume property (mmsg_np_simple_reserved_fld_vld);

      property mmsg_np_msgd_msg_vld;
      @(posedge clk) disable iff(reset) ((m_agt_msg_buf[iter].vld) && 
                                         (agt_message_is_data ( m_agt_msg_opcode[iter])))
      |-> (m_agt_msg_buf[iter].num_flits >= 2 * 4);
      endproperty
      mmsg_np_msgd_msg_vld_assume: assume property (mmsg_np_msgd_msg_vld);
         
      end
 
      */
      
  // end
//endgenerate

   
endmodule




