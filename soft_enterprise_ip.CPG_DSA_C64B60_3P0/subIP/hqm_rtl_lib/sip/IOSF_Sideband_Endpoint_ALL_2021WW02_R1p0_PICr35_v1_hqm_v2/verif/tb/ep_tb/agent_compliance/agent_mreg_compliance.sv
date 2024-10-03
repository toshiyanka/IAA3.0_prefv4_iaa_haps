//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author          : ddaftary
// Co-Author       : sshah3
// Date Created : 10-31-2011 
//-----------------------------------------------------------------
// Description:
// This file contains assumptions/assertions related to master 
// register access bus of the sbendpoint 
//------------------------------------------------------------------

`include "agent_types.svh"
module

 agent_mreg_compliance #(parameter int MAXPCMSTR=0,
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
   input  logic clk,
   input  logic reset,
   input  logic mreg_irdy,
   input  logic mreg_trdy, 
   input  logic[7:0] mreg_dest,
   input  logic[7:0] mreg_source,
   input  logic[7:0] mreg_opcode,
   input  logic mreg_addrlen,
   input  logic[2:0] mreg_bar,
   input  logic[2:0] mreg_tag,
   input logic[7:0] mreg_fid,
   input logic[3:0] mreg_sbe,
   input logic[3:0] mreg_fbe,
   input logic[MAXMSTRADDR:0] mreg_addr,
   input logic[MAXMSTRDATA:0] mreg_wdata,
   input logic mreg_npwrite,
   input logic mreg_pmsgip,
   input logic mreg_nmsgip
);

`ifdef EP_FPV
 parameter EP_FPV = 1;
`else
 parameter EP_FPV = 0;
`endif
   
   agt_message_buf_t m_agt_pcreg_msg_buf;
   agt_message_buf_t m_agt_npreg_msg_buf;
   
 //addrlen needs to be constraint to 0 since maxmsteraddr is 32
`define PACK_REG_FLITS(flit_buf, buf_size, start) \
   flit_buf[start] <= \
                       mreg_dest;\
   flit_buf[start+1] <= \
                       mreg_source;\
   flit_buf[start+2] <= \
                       mreg_opcode;\
   flit_buf[start+3] <= \
                       {1'b0, mreg_addrlen, mreg_bar, mreg_tag};\
   flit_buf[start+4] <= \
                       {mreg_sbe, mreg_fbe};\
   flit_buf[start+5] <= \
                       mreg_fid;\
   if (MAXMSTRADDR != 47) begin \
   flit_buf[start+6] <= \
                       mreg_addr[7:0];\
   flit_buf[start+7] <= \
                       mreg_addr[15:8];\
                         end \
   else begin \
   flit_buf[start+6] <= \
                       mreg_addr[7:0];\
   flit_buf[start+7] <= \
                       mreg_addr[15:8];\
   flit_buf[start+8] <= \
                       mreg_addr[23:16];\
   flit_buf[start+9] <= \
                       mreg_addr[31:24];\
   flit_buf[start+10] <= \
                       mreg_addr[39:32];\
   flit_buf[start+11] <= \
                       mreg_addr[47:40];\
                         end \
   if (mreg_opcode[0]) begin \
      for (int i =0; i <(MAXMSTRDATA+1)/8; i++) \
        flit_buf[start+8+i] <= \
                                 mreg_wdata[(8*i)+7 -: 8];\
                                 end
   


      always @(posedge clk)
         if (mreg_irdy && mreg_trdy && mreg_pmsgip) begin
	    // valid flit/byte    
            `PACK_REG_FLITS(m_agt_pcreg_msg_buf.flits,  72, 0);               
         end 
            
      always @(posedge clk)
         if (mreg_irdy && mreg_trdy && mreg_nmsgip) begin
	    // valid flit/byte
            `PACK_REG_FLITS(m_agt_npreg_msg_buf.flits, 72, 0);            
         end    

      /**
       * Make the assembled message valid when eom is seen.
       */
      always @(posedge clk or negedge reset)
         if (!reset)
            begin
               m_agt_pcreg_msg_buf.vld <= 0;
               m_agt_npreg_msg_buf.vld <= 0;
            end
         else
            begin
               m_agt_pcreg_msg_buf.vld <= mreg_irdy && mreg_trdy && mreg_pmsgip;
               m_agt_npreg_msg_buf.vld <= mreg_irdy && mreg_trdy && mreg_nmsgip;
            end // else: !if(!reset)
      always @(posedge clk or negedge reset)
         if (!reset)
            begin
               m_agt_pcreg_msg_buf.num_flits <= 0;
               m_agt_npreg_msg_buf.num_flits <= 0;
            end
         else
            begin
               if (mreg_irdy && mreg_trdy && mreg_pmsgip)                        
                 m_agt_pcreg_msg_buf.num_flits <= 6 + ((mreg_addrlen == 0) ? 2 : 6) + (!mreg_opcode[0] ? 0 : (mreg_sbe == 0 ? 4 : 8));
               if (mreg_irdy && mreg_trdy && mreg_nmsgip) 
                 m_agt_npreg_msg_buf.num_flits <= 6 + ((mreg_addrlen == 0) ? 2 : 6) + (!mreg_opcode[0] ? 0 : (mreg_sbe == 0 ? 4 : 8)); 
               if (m_agt_pcreg_msg_buf.vld)
                 m_agt_pcreg_msg_buf.num_flits <= 0;
               if (m_agt_npreg_msg_buf.vld)
                 m_agt_npreg_msg_buf.num_flits <= 0;
            end // else: !if(!reset)
      

   //end endgenerate

   //*************************************************************************
   // Message Validity assumptions
   //*************************************************************************
     property mreg_pc_write_vld;
        @(posedge clk) disable iff (reset !== 1) 
        ((m_agt_pcreg_msg_buf.vld) && (agt_msg_is_reg_write(m_agt_pcreg_msg_buf.flits[2]))) |-> (!mreg_npwrite);
      endproperty 
      if (EP_FPV)       
      mreg_pc_write_vld_prop: assume property (mreg_pc_write_vld);
      else
      mreg_pc_write_vld_prop: assert property (mreg_pc_write_vld) else $display("ERROR: mreg pc write is invalid");

     property mreg_np_write_vld;
        @(posedge clk) disable iff (reset !== 1) 
        ((m_agt_npreg_msg_buf.vld) && (agt_msg_is_reg_write(m_agt_npreg_msg_buf.flits[2]))) |-> (mreg_npwrite);
      endproperty 
      if (EP_FPV)       
      mreg_np_write_vld_prop: assume property (mreg_np_write_vld);
      else
      mreg_np_write_vld_prop: assert property (mreg_np_write_vld) else $display("ERROR: mreg np write is invalid");
  
      //valid message size, multiple of dw   
     property mreg_pc_size_vld;
        @(posedge clk) disable iff (reset !== 1) 
        (m_agt_pcreg_msg_buf.vld) |-> (agt_msg_is_DW_aligned( m_agt_pcreg_msg_buf.num_flits ));
      endproperty 
      if (EP_FPV)       
      mreg_pc_size_vld_prop: assume property (mreg_pc_size_vld);
      else
      mreg_pc_size_vld_prop: assert property (mreg_pc_size_vld) else $display("ERROR: mreg pc msg size is invalid");

      //valid opcode only regio messages
      property mreg_pc_opcode_vld;
        @(posedge clk) disable iff (reset !== 1) m_agt_pcreg_msg_buf.vld 
        |-> (agt_msg_is_reg_access ( m_agt_pcreg_msg_buf.flits[2]));
      
      endproperty        
      if (EP_FPV)       
      mreg_pc_opcode_vld_prop: assume property (mreg_pc_opcode_vld);  
      else
      mreg_pc_opcode_vld_prop: assert property (mreg_pc_opcode_vld) else $display("ERROR: mreg pc opcode is invalid");  

      //addrlen should be 0 or 1 for regio messages
      property mreg_pc_regio_addrlen_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pcreg_msg_buf.vld) && 
                                         (agt_msg_is_reg_access ( m_agt_pcreg_msg_buf.flits[2])))
      |-> (m_agt_pcreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0) || (m_agt_pcreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 1);
      endproperty
      if (EP_FPV)       
      mreg_pc_regio_addrlen_fld_vld_prop: assume property (mreg_pc_regio_addrlen_fld_vld);
      else
      mreg_pc_regio_addrlen_fld_vld_prop: assert property (mreg_pc_regio_addrlen_fld_vld) else $display("ERROR: mreg pc regio addrlen is invalid");
   
      //cfgwr, cfgrd, iowr, iord need 16 bit addrlen
      property mreg_pc_regio_cfgio_addrlen_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pcreg_msg_buf.vld) && 
                                         (m_agt_pcreg_msg_buf.flits[2] inside 
                                          { AGT_CFGWR}))
      |-> (m_agt_pcreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0);
      endproperty
      if (EP_FPV)       
      mreg_pc_regio_cfgio_addrlen_fld_vld_prop: assume property (mreg_pc_regio_cfgio_addrlen_fld_vld);
       else
     mreg_pc_regio_cfgio_addrlen_fld_vld_prop: assert property (mreg_pc_regio_cfgio_addrlen_fld_vld) else $display("ERROR: mreg pc regio cfg, io addrlen is not 0");
 
      //mwr, mrd, iowr, iord need dw alligned address
      property mreg_pc_regio_mio_dw_addr_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pcreg_msg_buf.vld) && 
                                         (m_agt_pcreg_msg_buf.flits[2] inside 
                                          { AGT_MWR}))
      |-> (m_agt_pcreg_msg_buf.flits[AGT_FST_ADDR_FLIT][1:0] == 2'b00);
      endproperty
      if (EP_FPV)       
      mreg_pc_regio_mio_dw_addr_fld_vld_prop: assume property (mreg_pc_regio_mio_dw_addr_fld_vld);
      else
      mreg_pc_regio_mio_dw_addr_fld_vld_prop: assert property (mreg_pc_regio_mio_dw_addr_fld_vld) else $display("ERROR: mreg pc regio memory, io addr is not dw alligned");

      //regio addr QW alligned
      property mreg_pc_regio_qw_addr_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pcreg_msg_buf.vld) && 
                                         (agt_msg_is_reg_access(m_agt_pcreg_msg_buf.flits[2])) &&
                                         m_agt_pcreg_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] > 0)
      |-> (m_agt_pcreg_msg_buf.flits[AGT_FST_ADDR_FLIT][2] == 0);
      endproperty
      if (EP_FPV)       
      mreg_pc_regio_qw_addr_fld_vld_prop: assume property (mreg_pc_regio_qw_addr_fld_vld);
      else
      mreg_pc_regio_qw_addr_fld_vld_prop: assert property (mreg_pc_regio_qw_addr_fld_vld) else $display("ERROR: mreg pc regio addr is not qw alligned");

      //valid regio read
      property mreg_pc_regio_read_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pcreg_msg_buf.vld) && 
                                                (agt_msg_is_gl_reg_read(m_agt_pcreg_msg_buf.flits[2])))
      |-> (m_agt_pcreg_msg_buf.num_flits == ((2+m_agt_pcreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD]) * AGT_DW_SIZE));
      endproperty
      if (EP_FPV)       
      mreg_pc_regio_read_vld_prop: assume property (mreg_pc_regio_read_vld);
      else
      mreg_pc_regio_read_vld_prop: assert property (mreg_pc_regio_read_vld) else $display("ERROR: mreg pc regio read is not valid");

      //valid regio write with sbe=0
      property mreg_pc_regio_write_sbe_zero_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pcreg_msg_buf.vld) && 
                                                (agt_msg_is_gl_reg_write(m_agt_pcreg_msg_buf.flits[2] )) &&
                                                (m_agt_pcreg_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] == 0))
      |-> (m_agt_pcreg_msg_buf.num_flits == (3+m_agt_pcreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD])*4);
      endproperty
      if (EP_FPV)       
      mreg_pc_regio_write_sbe_zero_vld_prop: assume property (mreg_pc_regio_write_sbe_zero_vld);
      else
      mreg_pc_regio_write_sbe_zero_vld_prop: assert property (mreg_pc_regio_write_sbe_zero_vld) else $display("ERROR: mreg pc regio write with sbe=0 is not valid");
                                         
      //valid regio write with sbe nonzero
      property mreg_pc_regio_write_sbe_nonzero_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pcreg_msg_buf.vld) && 
                                         (agt_msg_is_gl_reg_write(m_agt_pcreg_msg_buf.flits[2] )) &&
                                         (m_agt_pcreg_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] != 0))
      |-> (m_agt_pcreg_msg_buf.num_flits == 
           (AGT_DW_SIZE+m_agt_pcreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD])*AGT_DW_SIZE);
      endproperty
      if (EP_FPV)       
      mreg_pc_regio_write_sbe_nonzero_vld_prop: assume property (mreg_pc_regio_write_sbe_nonzero_vld);      
      else
      mreg_pc_regio_write_sbe_nonzero_vld_prop: assert property (mreg_pc_regio_write_sbe_nonzero_vld) else $display("ERROR: mreg pc regio write with sbe nonzero is invalid");      

      //non_posted read
      property mreg_read_cannot_posted_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_pcreg_msg_buf.vld)
      |-> (!agt_msg_is_reg_read( m_agt_pcreg_msg_buf.flits[2]));
      endproperty
      if (EP_FPV)       
      mreg_read_cannot_posted_vld_prop: assume property (mreg_read_cannot_posted_vld);  
      else
      mreg_read_cannot_posted_vld_prop: assert property (mreg_read_cannot_posted_vld) else $display("ERROR: mreg read cannot be posted");  

      //non_posted CFGWR/IOWR
      property mreg_cfgwr_iowr_cannot_posted_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_pcreg_msg_buf.vld)
      |-> (!(m_agt_pcreg_msg_buf.flits[2] inside {AGT_CFGWR, AGT_IOWR}));
      endproperty
      if (EP_FPV)       
      mreg_cfgwr_iowr_cannot_posted_vld_prop: assume property (mreg_cfgwr_iowr_cannot_posted_vld);  
      else
      mreg_cfgwr_iowr_cannot_posted_vld_prop: assert property (mreg_cfgwr_iowr_cannot_posted_vld) else $display("ERROR: mreg cfg, io write cannot be posted");  

      //eh == 0 for all message
      property mreg_pc_eh_zero_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pcreg_msg_buf.vld) && 
                                         ((agt_msg_is_reg_access( m_agt_pcreg_msg_buf.flits[2]))))
      |-> (m_agt_pcreg_msg_buf.flits[3][`AGT_EH_FIELD] == 0);
      endproperty
      if (EP_FPV)       
      mreg_pc_eh_zero_fld_vld_prop: assume property (mreg_pc_eh_zero_fld_vld);
      else
      mreg_pc_eh_zero_fld_vld_prop: assert property (mreg_pc_eh_zero_fld_vld) else $display("ERROR: mreg pc wh field is not 0");

     //addrlen == 0 for all message (is sbendpoint param is MAXMSTRADDR=31)
     //setting addrlen=0 for fpv only
      property mreg_pc_addrlen_zero_fld_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_pcreg_msg_buf.vld && (MAXMSTRADDR == 31 || MAXMSTRADDR == 15)) 
      |-> (m_agt_pcreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0);
      endproperty
      if (EP_FPV)       
      mreg_pc_addrlen_zero_fld_vld_prop: assume property (mreg_pc_addrlen_zero_fld_vld);
     
      //valid message size, multiple of dw   
     property mreg_np_size_vld;
        @(posedge clk) disable iff (reset !== 1) 
        (m_agt_npreg_msg_buf.vld) |-> (agt_msg_is_DW_aligned( m_agt_npreg_msg_buf.num_flits ));
      endproperty        
      if (EP_FPV)       
      mreg_np_size_vld_prop: assume property (mreg_np_size_vld);
      else
      mreg_np_size_vld_prop: assert property (mreg_np_size_vld) else $display("ERROR: mreg np msg is of incorrect size");

      //valid opcode 
      property mreg_np_opcode_vld;
        @(posedge clk) disable iff (reset !== 1) m_agt_npreg_msg_buf.vld 
        |-> (agt_msg_is_reg_access ( m_agt_npreg_msg_buf.flits[2]));
      
      endproperty        
      if (EP_FPV)       
      mreg_np_opcode_vld_prop: assume property (mreg_np_opcode_vld);  
      else
      mreg_np_opcode_vld_prop: assert property (mreg_np_opcode_vld) else $display("ERROR: mreg opcode is invalid");  

      //addrlen should be 0 or 1 for regio messages
      property mreg_np_regio_addrlen_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_npreg_msg_buf.vld) && 
                                         (agt_msg_is_reg_access ( m_agt_npreg_msg_buf.flits[2])))
      |-> (m_agt_npreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0) || (m_agt_npreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 1);
      endproperty
      if (EP_FPV)       
      mreg_np_regio_addrlen_fld_vld_prop: assume property (mreg_np_regio_addrlen_fld_vld);
      else
      mreg_np_regio_addrlen_fld_vld_prop: assert property (mreg_np_regio_addrlen_fld_vld) else $display("ERROR: mreg np addrlen is invalid");

      //cfgwr, cfgrd, iowr, iord need 16 bit addrlen
      property mreg_np_regio_cfgio_addrlen_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_npreg_msg_buf.vld) && 
                                         (m_agt_npreg_msg_buf.flits[2] inside 
                                          { AGT_IORD, AGT_IOWR,
                                            AGT_CFGRD, AGT_CFGWR}))
      |-> (m_agt_npreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0);
      endproperty
      if (EP_FPV)       
      mreg_np_regio_cfgio_addrlen_fld_vld_prop: assume property (mreg_np_regio_cfgio_addrlen_fld_vld);
      else
      mreg_np_regio_cfgio_addrlen_fld_vld_prop: assert property (mreg_np_regio_cfgio_addrlen_fld_vld) else $display("ERROR: mreg np regio cfg, io addrlen is not 16");
 
      //mwr, mrd, iowr, iord need dw alligned address
      property mreg_np_regio_mio_dw_addr_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_npreg_msg_buf.vld) && 
                                         (m_agt_npreg_msg_buf.flits[2] inside 
                                          { AGT_IORD, AGT_IOWR,
                                            AGT_MRD, AGT_MWR}))
      |-> (m_agt_npreg_msg_buf.flits[AGT_FST_ADDR_FLIT][1:0] == 2'b00);
      endproperty
      if (EP_FPV)       
      mreg_np_regio_mio_dw_addr_fld_vld_prop: assume property (mreg_np_regio_mio_dw_addr_fld_vld);
      else
      mreg_np_regio_mio_dw_addr_fld_vld_prop: assert property (mreg_np_regio_mio_dw_addr_fld_vld) else $display("ERROR: mreg np regio memory,io addr is not dw alligned");

      //cfgrd, cfgwr need dw alligned address
      property mreg_np_regio_cfg_dw_addr_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_npreg_msg_buf.vld) && 
                                                (m_agt_npreg_msg_buf.flits[2] inside {AGT_CFGRD, AGT_CFGWR})) 
      |-> (m_agt_npreg_msg_buf.flits[AGT_FST_ADDR_FLIT][1:1] == 1'b0);
      endproperty
      if (EP_FPV)       
      mreg_np_regio_cfg_dw_addr_fld_vld_prop: assume property (mreg_np_regio_cfg_dw_addr_fld_vld);
      else
      mreg_np_regio_cfg_dw_addr_fld_vld_prop: assert property (mreg_np_regio_cfg_dw_addr_fld_vld) else $display("ERROR: mreg np regio cfg addr is not dw alligned");

      //regio addr QW alligned
      property mreg_np_regio_qw_addr_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_npreg_msg_buf.vld) && 
                                         (agt_msg_is_reg_access(m_agt_npreg_msg_buf.flits[2])) &&
                                         m_agt_npreg_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] > 0)
      |-> (m_agt_npreg_msg_buf.flits[AGT_FST_ADDR_FLIT][2] == 0);
      endproperty
      if (EP_FPV)       
      mreg_np_regio_qw_addr_fld_vld_prop: assume property (mreg_np_regio_qw_addr_fld_vld);
      else
      mreg_np_regio_qw_addr_fld_vld_prop: assert property (mreg_np_regio_qw_addr_fld_vld) else $display("ERROR: mreg np regio addr is not qw alligned");

      //valid regio read
      property mreg_np_regio_read_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_npreg_msg_buf.vld) && 
                                                (agt_msg_is_gl_reg_read(m_agt_npreg_msg_buf.flits[2])))
      |-> (m_agt_npreg_msg_buf.num_flits == ((2+m_agt_npreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD]) * AGT_DW_SIZE));
      endproperty
      if (EP_FPV)       
      mreg_np_regio_read_vld_prop: assume property (mreg_np_regio_read_vld);
      else
      mreg_np_regio_read_vld_prop: assert property (mreg_np_regio_read_vld) else $display("ERROR: mreg np regio read is invalid");

      //valid regio write with sbe=0
      property mreg_np_regio_write_sbe_zero_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_npreg_msg_buf.vld) && 
                                         (agt_msg_is_gl_reg_write(m_agt_npreg_msg_buf.flits[2] )) &&
                                         (m_agt_npreg_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] == 0))
      |-> (m_agt_npreg_msg_buf.num_flits == (3+m_agt_npreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD])*4);
      endproperty
      if (EP_FPV)       
      mreg_np_regio_write_sbe_zero_vld_prop: assume property (mreg_np_regio_write_sbe_zero_vld);
      else
      mreg_np_regio_write_sbe_zero_vld_prop: assert property (mreg_np_regio_write_sbe_zero_vld) else $display("ERROR: mreg np regio write with sbe zero is invalid");
                                         
      //valid regio write with sbe nonzero
      property mreg_np_regio_write_sbe_nonzero_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_npreg_msg_buf.vld) && 
                                         (agt_msg_is_gl_reg_write(m_agt_npreg_msg_buf.flits[2] )) &&
                                         (m_agt_npreg_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] != 0))
      |-> (m_agt_npreg_msg_buf.num_flits == 
           (AGT_DW_SIZE+m_agt_npreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD])*AGT_DW_SIZE);
      endproperty
      if (EP_FPV)       
      mreg_np_regio_write_sbe_nonzero_vld_prop: assume property (mreg_np_regio_write_sbe_nonzero_vld);      
      else
      mreg_np_regio_write_sbe_nonzero_vld_prop: assert property (mreg_np_regio_write_sbe_nonzero_vld) else $display("ERROR: mreg np with zbe nonzero is invalid");      

      //eh == 0 for all message
      property mreg_np_eh_zero_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_npreg_msg_buf.vld) && 
                                         ((agt_msg_is_reg_access( m_agt_npreg_msg_buf.flits[2]))))
      |-> (m_agt_npreg_msg_buf.flits[3][`AGT_EH_FIELD] == 0);
      endproperty
      if (EP_FPV)       
      mreg_np_eh_zero_fld_vld_prop: assume property (mreg_np_eh_zero_fld_vld);
      else
      mreg_np_eh_zero_fld_vld_prop: assert property (mreg_np_eh_zero_fld_vld) else $display("ERROR: mreg np eh is not 0");

     //addrlen == 0 for all message (since sbendpoint param is 31)
     //setting addrlen=0 for fpv only
      property mreg_np_addrlen_zero_fld_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_npreg_msg_buf.vld && (MAXMSTRADDR == 31 || MAXMSTRADDR == 15)) 
      |-> (m_agt_npreg_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0);
      endproperty
      if (EP_FPV)       
      mreg_np_addrlen_zero_fld_vld_prop: assume property (mreg_np_addrlen_zero_fld_vld);
      
      
  
endmodule










