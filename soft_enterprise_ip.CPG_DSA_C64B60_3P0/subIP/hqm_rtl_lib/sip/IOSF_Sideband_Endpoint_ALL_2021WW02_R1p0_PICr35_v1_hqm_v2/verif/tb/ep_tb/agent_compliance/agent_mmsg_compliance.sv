//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author          : ddaftary
// Co-Author       : sshah3
// Date Created : 10-31-2011 
//-----------------------------------------------------------------
// Description:
// This file contains assumptions/assertions related to master 
// message bus of the sbendpoint 
//------------------------------------------------------------------


`include "agent_types.svh"
module

 agent_mmsg_compliance #(parameter int MAXPCMSTR=0,
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
   input  logic[32*MAXPCMSTR+31:0] mmsg_pcpayload,
   input  logic[32*MAXNPMSTR+31:0] mmsg_nppayload,
   input  logic[MAXPCMSTR:0] mmsg_pcirdy,
   input  logic      mmsg_pctrdy,
   input  logic[MAXPCMSTR:0]      mmsg_pceom,
   input  logic[MAXNPMSTR:0]      mmsg_npirdy,
   input  logic      mmsg_nptrdy,
   input  logic[MAXNPMSTR:0]      mmsg_npeom,
   input logic mmsg_npmsgip,
   input logic mmsg_pcmsgip,
   input logic[MAXPCMSTR:0] mmsg_pcsel,
   input logic[MAXNPMSTR:0] mmsg_npsel
);

   agt_message_buf_t m_agt_pc_msg_buf;
   agt_message_buf_t m_agt_np_msg_buf;
   logic [31:0] pc_payload, np_payload;
   
  
   `define PACK_FLITS(payload, flit_buf, buf_size, start) \
      for (int i = 0; i < AGT_DW_SIZE; i++) begin \
         if (start+i < buf_size) \
            flit_buf[start+i] <= \
               payload[i*8 +: 8];\
      end 

`ifdef EP_FPV
 parameter EP_FPV = 1;
`else
 parameter EP_FPV = 0;
`endif

    
      always @(posedge clk)
         if (|mmsg_pcirdy && mmsg_pctrdy && |mmsg_pcsel) begin
	    // valid flit/byte
            for (int i=0; i<=MAXPCMSTR; i++)          
            if (mmsg_pcirdy[i]) pc_payload = mmsg_pcpayload[((32*i)+31) -: 32];
            
            if (m_agt_pc_msg_buf.vld) begin
               // back-to-back case
               `PACK_FLITS(pc_payload, m_agt_pc_msg_buf.flits, 72, 0);

            end else begin
	       // normal flits
               `PACK_FLITS (pc_payload, m_agt_pc_msg_buf.flits, 72, m_agt_pc_msg_buf.num_flits);               
            end
         end          
   
      always @(posedge clk)
         if (|mmsg_npirdy&& mmsg_npirdy && |mmsg_npsel) begin
	    // valid flit/byte
            for (int i=0; i<=MAXNPMSTR; i++)             
            if (mmsg_npirdy[i]) np_payload = mmsg_nppayload[((32*i)+31) -: 32];
            
            if (m_agt_np_msg_buf.vld) begin
               // back-to-back case
               `PACK_FLITS(np_payload, m_agt_np_msg_buf.flits, 72, 0);

            end else begin
	       // normal flits
               `PACK_FLITS (np_payload, m_agt_np_msg_buf.flits, 72, m_agt_np_msg_buf.num_flits);               
            end            
	 end 

 
      /**
       * Make the assembled message valid when eom is seen.
       */
      always @(posedge clk or negedge reset)
         if (!reset)
           m_agt_pc_msg_buf.vld <= 0;
         else 
           m_agt_pc_msg_buf.vld <= (|mmsg_pcirdy && mmsg_pctrdy && |mmsg_pceom && |mmsg_pcsel); 

      always @(posedge clk or negedge reset)
         if (!reset)
           m_agt_pc_msg_buf.num_flits <= 0;
         else if (m_agt_pc_msg_buf.vld)
           begin
              if (|mmsg_pcirdy && mmsg_pctrdy && |mmsg_pcsel )
                m_agt_pc_msg_buf.num_flits <= AGT_DW_SIZE;
              else
                m_agt_pc_msg_buf.num_flits <= 0;
           end
         else if (|mmsg_pcirdy && mmsg_pctrdy && |mmsg_pcsel )
           m_agt_pc_msg_buf.num_flits <= m_agt_pc_msg_buf.num_flits + AGT_DW_SIZE;
              
   //    
     always @(posedge clk or negedge reset)
         if (!reset)
           m_agt_np_msg_buf.vld <= 0;
         else 
           m_agt_np_msg_buf.vld <= (|mmsg_npirdy && mmsg_nptrdy && |mmsg_npeom && |mmsg_npsel);
   
      always @(posedge clk or negedge reset)
         if (!reset)
           m_agt_np_msg_buf.num_flits <= 0;
         else if (m_agt_np_msg_buf.vld)
            begin
               if (|mmsg_npirdy && mmsg_nptrdy  && |mmsg_npsel )
                 m_agt_np_msg_buf.num_flits <= AGT_DW_SIZE;
               else
                 m_agt_np_msg_buf.num_flits <= 0;
            end
         else if (|mmsg_npirdy && mmsg_nptrdy  && |mmsg_npsel )
           m_agt_np_msg_buf.num_flits <= (m_agt_np_msg_buf.num_flits + AGT_DW_SIZE);
     

   //*************************************************************************
   // Message Validity assumptions
   //*************************************************************************
  
      //valid message size, multiple of dw   
     property mmsg_pc_size_vld;
        @(posedge clk) disable iff (reset !== 1) 
        (m_agt_pc_msg_buf.vld) |-> (agt_msg_is_DW_aligned( m_agt_pc_msg_buf.num_flits ));
      endproperty 
      if (EP_FPV)
      mmsg_pc_size_vld_prop: assume property (mmsg_pc_size_vld);
      else
      mmsg_pc_size_vld_prop: assert property (mmsg_pc_size_vld) else $display("ERROR: mmsg is of incorrect size") ;
       
     

      //valid opcode 
      property mmsg_pc_opcode_vld;
        @(posedge clk) disable iff (reset !== 1) 
              (m_agt_pc_msg_buf.vld) |->
               (agt_msg_is_simple ( m_agt_pc_msg_buf.flits[2] )|| 
                agt_msg_is_data (m_agt_pc_msg_buf.flits[2] ) ||       
                agt_msg_is_completion ( m_agt_pc_msg_buf.flits[2]) || 
                agt_msg_is_reg_access ( m_agt_pc_msg_buf.flits[2]));         
              /*
              ((agt_msg_is_simple ( mmsg_pcpayload [((32*(MAXPCMSTR+1))-9):((32*(MAXPCMSTR+1))-16)]))||
              (agt_msg_is_data ( mmsg_pcpayload [((32*(MAXPCMSTR+1))-9):((32*(MAXPCMSTR+1))-16)])) ||       
              (agt_msg_is_completion (mmsg_pcpayload [((32*(MAXPCMSTR+1))-9):((32*(MAXPCMSTR+1))-16)])) || 
              (agt_msg_is_reg_access ( mmsg_pcpayload [((32*(MAXPCMSTR+1))-9):((32*(MAXPCMSTR+1))-16)])));
      */
      endproperty
      if (EP_FPV)
      mmsg_pc_opcode_vld_prop: assume property (mmsg_pc_opcode_vld);
      else
      mmsg_pc_opcode_vld_prop: assert property (mmsg_pc_opcode_vld) else $display("ERROR: mmsg_pc opcode not valid") ;
      

      //valid simple message size
      property mmsg_pc_simple_msg_vld;
      @(posedge clk) disable iff (reset !== 1)           
      ((m_agt_pc_msg_buf.vld) &&
                                        (agt_msg_is_simple (m_agt_pc_msg_buf.flits[2]))) 
      |-> (m_agt_pc_msg_buf.num_flits == AGT_DW_SIZE);
      endproperty
      if (EP_FPV)
      mmsg_pc_simple_msg_vld_prop: assume property (mmsg_pc_simple_msg_vld);
      else
      mmsg_pc_simple_msg_vld_prop: assert property (mmsg_pc_simple_msg_vld) else $display("ERROR: mmsg pc simple msg is of incorrect size") ;
      

      //reserved field ==0 for simple message
      property mmsg_pc_simple_reserved_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_simple ( m_agt_pc_msg_buf.flits[2])))
      |-> (m_agt_pc_msg_buf.flits[3][`AGT_RESERVED_FIELD] == 0);
      endproperty
      if (EP_FPV)
      mmsg_pc_simple_reserved_fld_vld_prop: assume property (mmsg_pc_simple_reserved_fld_vld);
      else
      mmsg_pc_simple_reserved_fld_vld_prop: assert property (mmsg_pc_simple_reserved_fld_vld) else $display("ERROR: mmsg pc simple msg reserved field not zero") ;
      
      
      //valid msgd message size
      property mmsg_pc_msgd_msg_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_data ( m_agt_pc_msg_buf.flits[2])))
      |-> (m_agt_pc_msg_buf.num_flits >= 2 * AGT_DW_SIZE);
      endproperty
      if (EP_FPV)
      mmsg_pc_msgd_msg_vld_prop: assume property (mmsg_pc_msgd_msg_vld);
      else
      mmsg_pc_msgd_msg_vld_prop: assert property (mmsg_pc_msgd_msg_vld) else $display("ERROR: mmsg pc msgd msg is of incorrect size") ;
      

      //reserved field == 0 for msgd messages
      property mmsg_pc_msgd_reserved_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_data ( m_agt_pc_msg_buf.flits[2])))
      |-> (m_agt_pc_msg_buf.flits[3][`AGT_RESERVED_FIELD] == 0);
      endproperty
      if (EP_FPV)
      mmsg_pc_msgd_reserved_fld_vld_prop: assume property (mmsg_pc_msgd_reserved_fld_vld);
      else
   mmsg_pc_msgd_reserved_fld_vld_prop: assert property (mmsg_pc_msgd_reserved_fld_vld) else $display("ERROR: mmsg pc msgd msg, reserved field not zero") ;
      

      //addrlen should be 0 or 1 for regio messages
      property mmsg_pc_regio_addrlen_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_reg_access ( m_agt_pc_msg_buf.flits[2])))
      |-> (m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0) || (m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 1);
      endproperty
      if (EP_FPV)
      mmsg_pc_regio_addrlen_fld_vld_prop: assume property (mmsg_pc_regio_addrlen_fld_vld);
      else
      mmsg_pc_regio_addrlen_fld_vld_prop: assert property (mmsg_pc_regio_addrlen_fld_vld) else $display("ERROR: mmsg pc regio addrlen field is invalid");
      

      //cfgwr, cfgrd, iowr, iord need 16 bit addrlen
      property mmsg_pc_regio_cfgio_addrlen_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pc_msg_buf.vld) && 
                                         (m_agt_pc_msg_buf.flits[2] inside 
                                          { AGT_IORD, AGT_IOWR,
                                            AGT_CFGRD, AGT_CFGWR}))
      |-> (m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0);
      endproperty
      if (EP_FPV)
      mmsg_pc_regio_cfgio_addrlen_fld_vld_prop: assume property (mmsg_pc_regio_cfgio_addrlen_fld_vld);
      else
       mmsg_pc_regio_cfgio_addrlen_fld_vld_prop: assert property (mmsg_pc_regio_cfgio_addrlen_fld_vld) else $display("ERROR: mmsg pc regio cfg, io addrlen is not 16");
      

      //mwr, mrd, iowr, iord need dw alligned address
      property mmsg_pc_regio_mio_dw_addr_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pc_msg_buf.vld) && 
                                         (m_agt_pc_msg_buf.flits[2] inside 
                                          { AGT_IORD, AGT_IOWR,
                                            AGT_MRD, AGT_MWR}))
      |-> (m_agt_pc_msg_buf.flits[AGT_FST_ADDR_FLIT][1:0] == 2'b00);
      endproperty
      if (EP_FPV)
      mmsg_pc_regio_mio_dw_addr_fld_vld_prop: assume property (mmsg_pc_regio_mio_dw_addr_fld_vld);
      else
      mmsg_pc_regio_mio_dw_addr_fld_vld_prop: assert property (mmsg_pc_regio_mio_dw_addr_fld_vld) else $display("ERROR: mmsg pc regio memory, io address is not dw alligned");
      

      //cfgrd, cfgwr need dw alligned address
      property mmsg_pc_regio_cfg_dw_addr_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pc_msg_buf.vld) && 
                                                (m_agt_pc_msg_buf.flits[2] inside {AGT_CFGRD, AGT_CFGWR}))
      |-> (m_agt_pc_msg_buf.flits[AGT_FST_ADDR_FLIT][1:1] == 1'b0);
      endproperty
      if (EP_FPV)
      mmsg_pc_regio_cfg_dw_addr_fld_vld_prop: assume property (mmsg_pc_regio_cfg_dw_addr_fld_vld);
      else
      mmsg_pc_regio_cfg_dw_addr_fld_vld_prop: assert property (mmsg_pc_regio_cfg_dw_addr_fld_vld) else $display("ERROR: mmsg pc regio cfg address is not dw alligned");
      

      //regio addr QW alligned
      property mmsg_pc_regio_qw_addr_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_reg_access(m_agt_pc_msg_buf.flits[2])) &&
                                         m_agt_pc_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] > 0)
      |-> (m_agt_pc_msg_buf.flits[AGT_FST_ADDR_FLIT][2] == 0);
      endproperty
      if (EP_FPV)
      mmsg_pc_regio_qw_addr_fld_vld_prop: assume property (mmsg_pc_regio_qw_addr_fld_vld);
      else
      mmsg_pc_regio_qw_addr_fld_vld_prop: assert property (mmsg_pc_regio_qw_addr_fld_vld) else $display("ERROR: mmsg pc regio addr is now QW alligned");
      

      //valid regio read
      property mmsg_pc_regio_read_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_gl_reg_read(m_agt_pc_msg_buf.flits[2])))
      |-> (m_agt_pc_msg_buf.num_flits == ((2+m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD]) * AGT_DW_SIZE));
      endproperty
      if (EP_FPV)
      mmsg_pc_regio_read_vld_prop: assume property (mmsg_pc_regio_read_vld);
      else
      mmsg_pc_regio_read_vld_prop: assert property (mmsg_pc_regio_read_vld) else $display("ERROR: mmsg pc regio read is invalid");
      

      property mmsg_pc_regio_write_sbe_zero_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_gl_reg_write(m_agt_pc_msg_buf.flits[2] )) &&
                                         (m_agt_pc_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] == 0))
      |-> (m_agt_pc_msg_buf.num_flits == (3+m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD])*4);
      endproperty
      if (EP_FPV)
      mmsg_pc_regio_write_sbe_zero_vld_prop: assume property (mmsg_pc_regio_write_sbe_zero_vld);                                   
      else
      mmsg_pc_regio_write_sbe_zero_vld_prop: assert property (mmsg_pc_regio_write_sbe_zero_vld) else $display("ERROR: mmsg pc regio write with sbe=0 is of incorrect size");                                   
      
    

      property mmsg_pc_regio_write_sbe_nonzero_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pc_msg_buf.vld) &&  
                                         (agt_msg_is_gl_reg_write(m_agt_pc_msg_buf.flits[2] )) &&
                                         (m_agt_pc_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] != 0))
      |-> (m_agt_pc_msg_buf.num_flits == 
           (AGT_DW_SIZE+m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD])*AGT_DW_SIZE);
      endproperty
      if (EP_FPV)
      mmsg_pc_regio_write_sbe_nonzero_vld_prop: assume property (mmsg_pc_regio_write_sbe_nonzero_vld);      
      else
      mmsg_pc_regio_write_sbe_nonzero_vld_prop: assert property (mmsg_pc_regio_write_sbe_nonzero_vld) else $display("ERROR: mmsg pc regio write with sbe nonzero is of incorrect size");      
      

      //valid completion without data message
      property mmsg_pc_cmp_vld;
      @(posedge clk) disable iff (reset !== 1)
      ((m_agt_pc_msg_buf.vld) && 
                                         (m_agt_pc_msg_buf.flits[2] == AGT_CMP)) 
      |-> (m_agt_pc_msg_buf.num_flits == AGT_DW_SIZE); 
      endproperty
      if (EP_FPV)
      mmsg_pc_cmp_vld_prop: assume property (mmsg_pc_cmp_vld);    
      else
      mmsg_pc_cmp_vld_prop: assert property (mmsg_pc_cmp_vld) else $display("ERROR: mmsg comp msg without data is of invalid size");    
      

      //valid completion with data message
      property mmsg_pc_cmpd_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pc_msg_buf.vld) && 
                                         (m_agt_pc_msg_buf.flits[2] == AGT_CMPD)) 
      |-> (m_agt_pc_msg_buf.num_flits > AGT_DW_SIZE) &&
         agt_msg_is_DW_aligned( m_agt_pc_msg_buf.num_flits);
      endproperty
      if (EP_FPV)
      mmsg_pc_cmpd_vld_prop: assume property (mmsg_pc_cmpd_vld);  
      else
      mmsg_pc_cmpd_vld_prop: assert property (mmsg_pc_cmpd_vld) else $display("ERROR: mmsg comp msg with data is of invalid size");  
      

      //completion cannot be non_posted
      property mmsg_comp_cannot_nonposted_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_np_msg_buf.vld)
      |-> (!(m_agt_np_msg_buf.flits[2] inside {AGT_CMP, AGT_CMPD}));
      endproperty
      if (EP_FPV)
      mmsg_comp_cannot_nonposted_vld_prop: assume property (mmsg_comp_cannot_nonposted_vld);  
      else
      mmsg_comp_cannot_nonposted_vld_prop: assert property (mmsg_comp_cannot_nonposted_vld) else $display("ERROR: mmsg comp cannot be non_posted");  
      

      //non_posted CFGWR/IOWR
      property mmsg_cfgwr_iowr_cannot_posted_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_pc_msg_buf.vld)
      |-> (!(m_agt_pc_msg_buf.flits[2] inside {AGT_CFGWR, AGT_IOWR}));
      endproperty
      if (EP_FPV)       
      mmsg_cfgwr_iowr_cannot_posted_vld_prop: assume property (mmsg_cfgwr_iowr_cannot_posted_vld);  
      else
      mmsg_cfgwr_iowr_cannot_posted_vld_prop: assert property (mmsg_cfgwr_iowr_cannot_posted_vld) else $display("ERROR: mmsg cfg, io write cannot be posted");  
   
      //non_posted read
      property mmsg_read_cannot_posted_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_pc_msg_buf.vld)
      |-> (!agt_msg_is_reg_read( m_agt_pc_msg_buf.flits[2]));
      endproperty
      if (EP_FPV)
      mmsg_read_cannot_posted_vld_prop: assume property (mmsg_read_cannot_posted_vld);  
      else
      mmsg_read_cannot_posted_vld_prop: assert property (mmsg_read_cannot_posted_vld) else $display("ERROR: mmsg read cannot be posted");  
      

      //pm message is 3dw
      property mmsg_pc_pm_msg_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_pc_msg_buf.vld) &&
                                         (m_agt_pc_msg_buf.flits[2] == AGT_PM_REQ || 
                                          m_agt_pc_msg_buf.flits[2] == AGT_PM_DMD ||
                                          m_agt_pc_msg_buf.flits[2] == AGT_PM_RSP)
      |-> (m_agt_pc_msg_buf.num_flits == 3 * AGT_DW_SIZE);
      endproperty
      if (EP_FPV)
      mmsg_pc_pm_msg_vld_prop: assume property (mmsg_pc_pm_msg_vld); 
      else
      mmsg_pc_pm_msg_vld_prop: assert property (mmsg_pc_pm_msg_vld) else $display("ERROR: mmsg pc pm message is invalid"); 
      

      //pm message is 2dw
      property mmsg_pc_pm_ltr_msg_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_pc_msg_buf.vld) &&
                                         (m_agt_pc_msg_buf.flits[2] == AGT_LTR)
      |-> (m_agt_pc_msg_buf.num_flits == 2 * AGT_DW_SIZE);
      endproperty
      if (EP_FPV)
      mmsg_pc_pm_ltr_msg_vld_prop: assume property (mmsg_pc_pm_ltr_msg_vld);
      else
      mmsg_pc_pm_ltr_msg_vld_prop: assert property (mmsg_pc_pm_ltr_msg_vld) else $display("ERROR: mmsg pm_ltr message is invalid");
      


      //eh == 0 for all message
      property mmsg_pc_eh_zero_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_pc_msg_buf.vld) && 
                                         ((agt_msg_is_simple ( m_agt_pc_msg_buf.flits[2])) ||
                                          (agt_msg_is_data ( m_agt_pc_msg_buf.flits[2])) ||
                                          (agt_msg_is_reg_access( m_agt_pc_msg_buf.flits[2])) ||
                                          (agt_msg_is_completion( m_agt_pc_msg_buf.flits[2]))))
      |-> (m_agt_pc_msg_buf.flits[3][`AGT_EH_FIELD] == 0);
      endproperty
      if (EP_FPV)
      mmsg_pc_eh_zero_fld_vld_prop: assume property (mmsg_pc_eh_zero_fld_vld);
      else
      mmsg_pc_eh_zero_fld_vld_prop: assert property (mmsg_pc_eh_zero_fld_vld) else $display("ERROR: mmsg pc eh is not zero");
      

     //addrlen == 0 for messages when sbendpoint param is 31
     //setting addrlen=0 for fpv only
      property mmsg_pc_addrlen_zero_fld_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_pc_msg_buf.vld && (MAXMSTRADDR == 31 || MAXMSTRADDR == 15)) 
      |-> (m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0);
      endproperty
      if (EP_FPV)
      mmsg_pc_addrlen_zero_fld_vld_prop: assume property (mmsg_pc_addrlen_zero_fld_vld);
      

      //valid message size, multiple of dw   
     property mmsg_np_size_vld;
        @(posedge clk) disable iff (reset !== 1) 
        (m_agt_np_msg_buf.vld) |-> (agt_msg_is_DW_aligned( m_agt_np_msg_buf.num_flits ));
      endproperty        
      if (EP_FPV)
      mmsg_np_size_vld_prop: assume property (mmsg_np_size_vld);
      else
      mmsg_np_size_vld_prop: assert property (mmsg_np_size_vld) else $display("ERROR: mmsg np message is of invalid size");
      

      //valid opcode 
      property mmsg_np_opcode_vld;
        @(posedge clk) disable iff (reset !== 1) 
              (m_agt_np_msg_buf.vld) |-> 
               (agt_msg_is_simple ( m_agt_np_msg_buf.flits[2])|| 
                agt_msg_is_data (m_agt_np_msg_buf.flits[2] ) ||       
                agt_msg_is_completion ( m_agt_np_msg_buf.flits[2] ) || 
                agt_msg_is_reg_access ( m_agt_np_msg_buf.flits[2]));
     /*        
             ((agt_msg_is_simple ( mmsg_nppayload [((32*(MAXNPMSTR+1))-9):((32*(MAXNPMSTR+1))-16)]))|| 
              (agt_msg_is_data ( mmsg_nppayload [((32*(MAXNPMSTR+1))-9):((32*(MAXNPMSTR+1))-16)])) ||       
              (agt_msg_is_completion ( mmsg_nppayload [((32*(MAXNPMSTR+1))-9):((32*(MAXNPMSTR+1))-16)])) || 
              (agt_msg_is_reg_access ( mmsg_nppayload [((32*(MAXNPMSTR+1))-9):((32*(MAXNPMSTR+1))-16)])));
      */
      endproperty        
      if (EP_FPV)
      mmsg_np_opcode_vld_prop: assume property (mmsg_np_opcode_vld);  
      else
      mmsg_np_opcode_vld_prop: assert property (mmsg_np_opcode_vld) else $display("ERROR: mmsg np opcode is invalid");  
      

      //valid simple message size
      property mmsg_np_simple_msg_vld;
      @(posedge clk) disable iff (reset !== 1)          
      ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_simple ( m_agt_np_msg_buf.flits[2])))
      |-> (m_agt_np_msg_buf.num_flits == AGT_DW_SIZE);
      endproperty
      if (EP_FPV)
      mmsg_np_simple_msg_vld_prop: assume property (mmsg_np_simple_msg_vld);
      else
      mmsg_np_simple_msg_vld_prop: assert property (mmsg_np_simple_msg_vld) else $display("ERROR: mmsg np simple msg is invalid");
      

      //reserved field ==0 for simple message
      property mmsg_np_simple_reserved_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_simple ( m_agt_np_msg_buf.flits[2])))
      |-> (m_agt_np_msg_buf.flits[3][`AGT_RESERVED_FIELD] == 0);
      endproperty
      if (EP_FPV)
      mmsg_np_simple_reserved_fld_vld_prop: assume property (mmsg_np_simple_reserved_fld_vld);
      else
      mmsg_np_simple_reserved_fld_vld_prop: assert property (mmsg_np_simple_reserved_fld_vld) else $display("ERROR: mmsg np simple msg reserved field is not 0");
      

      //valid msgd message size
      property mmsg_np_msgd_msg_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_data ( m_agt_np_msg_buf.flits[2])))
      |-> (m_agt_np_msg_buf.num_flits >= 2 * AGT_DW_SIZE);
      endproperty
      if (EP_FPV)
      mmsg_np_msgd_msg_vld_prop: assume property (mmsg_np_msgd_msg_vld);
      else
      mmsg_np_msgd_msg_vld_prop: assert property (mmsg_np_msgd_msg_vld) else $display("ERROR: mmsg np msgd msg if not valid");
      

      //reserved field == 0 for msgd messages
      property mmsg_np_msgd_reserved_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_data ( m_agt_np_msg_buf.flits[2])))
      |-> (m_agt_np_msg_buf.flits[3][`AGT_RESERVED_FIELD] == 0);
      endproperty
      if (EP_FPV)
      mmsg_np_msgd_reserved_fld_vld_prop: assume property (mmsg_np_msgd_reserved_fld_vld);
      else
      mmsg_np_msgd_reserved_fld_vld_prop: assert property (mmsg_np_msgd_reserved_fld_vld) else $display("ERROR: mmsg np msgd reserved field is not zero");
      

      //addrlen should be 0 or 1 for regio messages
      property mmsg_np_regio_addrlen_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_reg_access ( m_agt_np_msg_buf.flits[2])))
      |-> (m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0) || (m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 1);
      endproperty
      if (EP_FPV)
      mmsg_np_regio_addrlen_fld_vld_prop: assume property (mmsg_np_regio_addrlen_fld_vld);
      else
      mmsg_np_regio_addrlen_fld_vld_prop: assert property (mmsg_np_regio_addrlen_fld_vld) else $display("ERROR: mmsg np regio addren is invalid");
      

      //cfgwr, cfgrd, iowr, iord need 16 bit addrlen
      property mmsg_np_regio_cfgio_addrlen_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_np_msg_buf.vld) && 
                                         (m_agt_np_msg_buf.flits[2] inside 
                                          { AGT_IORD, AGT_IOWR,
                                            AGT_CFGRD, AGT_CFGWR}))
      |-> (m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0);
      endproperty
      if (EP_FPV)
      mmsg_np_regio_cfgio_addrlen_fld_vld_prop: assume property (mmsg_np_regio_cfgio_addrlen_fld_vld);
      else
       mmsg_np_regio_cfgio_addrlen_fld_vld_prop: assert property (mmsg_np_regio_cfgio_addrlen_fld_vld) else $display("ERROR: mmsg np regio cfg, io addrlen is not 16");
      

      //mwr, mrd, iowr, iord need dw alligned address
      property mmsg_np_regio_mio_dw_addr_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_np_msg_buf.vld) && 
                                         (m_agt_np_msg_buf.flits[2] inside 
                                          { AGT_IORD, AGT_IOWR,
                                            AGT_MRD, AGT_MWR}))
      |-> (m_agt_np_msg_buf.flits[AGT_FST_ADDR_FLIT][1:0] == 2'b00);
      endproperty
      if (EP_FPV)
      mmsg_np_regio_mio_dw_addr_fld_vld_prop: assume property (mmsg_np_regio_mio_dw_addr_fld_vld);
      else
      mmsg_np_regio_mio_dw_addr_fld_vld_prop: assert property (mmsg_np_regio_mio_dw_addr_fld_vld) else $display("ERROR: mmsg np regio memory, io addr is not dw alligned");
      

      //cfgrd, cfgwr need dw alligned address
      property mmsg_np_regio_cfg_dw_addr_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_np_msg_buf.vld) && 
                                                (m_agt_np_msg_buf.flits[2] inside {AGT_CFGRD, AGT_CFGWR})) 
      |-> (m_agt_np_msg_buf.flits[AGT_FST_ADDR_FLIT][1:1] == 1'b0);
      endproperty
      if (EP_FPV)
      mmsg_np_regio_cfg_dw_addr_fld_vld_prop: assume property (mmsg_np_regio_cfg_dw_addr_fld_vld);
      else
      mmsg_np_regio_cfg_dw_addr_fld_vld_prop: assert property (mmsg_np_regio_cfg_dw_addr_fld_vld) else $display("ERROR: mmsg np regio cfg addr is not dw alligned");
      

      //regio addr QW alligned
      property mmsg_np_regio_qw_addr_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_np_msg_buf.vld) && 
                                                (agt_msg_is_reg_access(m_agt_np_msg_buf.flits[2])) &&
                                         m_agt_np_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] > 0)
      |-> (m_agt_np_msg_buf.flits[AGT_FST_ADDR_FLIT][2] == 0);
      endproperty
      if (EP_FPV)
      mmsg_np_regio_qw_addr_fld_vld_prop: assume property (mmsg_np_regio_qw_addr_fld_vld);
      else
      mmsg_np_regio_qw_addr_fld_vld_prop: assert property (mmsg_np_regio_qw_addr_fld_vld) else $display("ERROR: mmsg np regio addr is not QW alligned");
      

      //valid regio read
      property mmsg_np_regio_read_vld;
      @(posedge clk) disable iff (reset !== 1)((m_agt_np_msg_buf.vld) && 
                                               (agt_msg_is_gl_reg_read(m_agt_np_msg_buf.flits[2])))
      |-> (m_agt_np_msg_buf.num_flits == ((2+m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD]) * AGT_DW_SIZE)) ;
      endproperty
      if (EP_FPV)
      mmsg_np_regio_read_vld_prop: assume property (mmsg_np_regio_read_vld);
      else
      mmsg_np_regio_read_vld_prop: assert property (mmsg_np_regio_read_vld) else $display("ERROR: mmsg np regio read is invalid");
      

      property mmsg_np_regio_write_sbe_zero_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_np_msg_buf.vld) &&  
                                         (agt_msg_is_gl_reg_write(m_agt_np_msg_buf.flits[2] )) &&
                                         (m_agt_np_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] == 0))
      |-> (m_agt_np_msg_buf.num_flits == (3+m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD])*4);
      endproperty
      if (EP_FPV)
      mmsg_np_regio_write_sbe_zero_vld_prop: assume property (mmsg_np_regio_write_sbe_zero_vld);  
      else
      mmsg_np_regio_write_sbe_zero_vld_prop: assert property (mmsg_np_regio_write_sbe_zero_vld) else $display("ERROR: mmsg np regio write with sbe=0 is of incorrect size");  
      
                                   
      

      property mmsg_np_regio_write_sbe_nonzero_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_gl_reg_write(m_agt_np_msg_buf.flits[2] )) &&
                                         (m_agt_np_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] != 0))
      |-> (m_agt_np_msg_buf.num_flits == 
           (AGT_DW_SIZE+m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD])*AGT_DW_SIZE);
      endproperty
      if (EP_FPV)
      mmsg_np_regio_write_sbe_nonzero_vld_prop: assume property (mmsg_np_regio_write_sbe_nonzero_vld);
      else
      mmsg_np_regio_write_sbe_nonzero_vld_prop: assert property (mmsg_np_regio_write_sbe_nonzero_vld) else $display("ERROR: mmsg np regio write with sbe nonzeor is of incorrect size");
      
 
      //pm message is 3dw
      property mmsg_np_pm_msg_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_np_msg_buf.vld) &&
                                         (m_agt_np_msg_buf.flits[2] == AGT_PM_REQ || 
                                          m_agt_np_msg_buf.flits[2] == AGT_PM_DMD ||
                                          m_agt_np_msg_buf.flits[2] == AGT_PM_RSP)
      |-> (m_agt_np_msg_buf.num_flits == 3 * AGT_DW_SIZE);
      endproperty
      if (EP_FPV)
      mmsg_np_pm_msg_vld_prop: assume property (mmsg_np_pm_msg_vld); 
      else
      mmsg_np_pm_msg_vld_prop: assert property (mmsg_np_pm_msg_vld) else $display("ERROR: mmsg np pm msg is invalid"); 
      

      //pm message is 2dw
      property mmsg_np_pm_ltr_msg_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_np_msg_buf.vld) &&
                                         (m_agt_np_msg_buf.flits[2] == AGT_LTR)
      |-> (m_agt_np_msg_buf.num_flits == 2 * AGT_DW_SIZE);
      endproperty
      if (EP_FPV)
      mmsg_np_pm_ltr_msg_vld_prop: assume property (mmsg_np_pm_ltr_msg_vld);
      else
      mmsg_np_pm_ltr_msg_vld_prop: assert property (mmsg_np_pm_ltr_msg_vld) else $display("ERROR: mmsg np pm_ltr msg is invalid");
      

      //simple message is posted
      property mmsg_np_simple_posted_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_np_msg_buf.vld)                   
      |-> ((m_agt_np_msg_buf.flits[2] != AGT_ASSERT_INTA) &&
           (m_agt_np_msg_buf.flits[2] != AGT_ASSERT_INTB) &&
           (m_agt_np_msg_buf.flits[2] != AGT_ASSERT_INTC) &&
           (m_agt_np_msg_buf.flits[2] != AGT_ASSERT_INTD) &&
           (m_agt_np_msg_buf.flits[2] != AGT_DEASSERT_INTA) &&
           (m_agt_np_msg_buf.flits[2] != AGT_DEASSERT_INTB) &&
           (m_agt_np_msg_buf.flits[2] != AGT_DEASSERT_INTC) &&
           (m_agt_np_msg_buf.flits[2] != AGT_DEASSERT_INTD) &&
           (m_agt_np_msg_buf.flits[2] != AGT_ASSERT_SCI) &&
           (m_agt_np_msg_buf.flits[2] != AGT_DEASSERT_SCI) &&
           (m_agt_np_msg_buf.flits[2] != AGT_ASSERT_SSMI) &&
           (m_agt_np_msg_buf.flits[2] != AGT_ASSERT_SMI) &&
           (m_agt_np_msg_buf.flits[2] != AGT_DEASSERT_SSMI) &&
           (m_agt_np_msg_buf.flits[2] != AGT_DEASSERT_SMI) &&
           (m_agt_np_msg_buf.flits[2] != AGT_SMI_ACK ) &&
           (m_agt_np_msg_buf.flits[2] != AGT_ASSERT_PME) &&
           (m_agt_np_msg_buf.flits[2] != AGT_DEASSERT_PME) &&
           (m_agt_np_msg_buf.flits[2] != AGT_SYNCCOMP ) &&
           (m_agt_np_msg_buf.flits[2] != AGT_ASSERT_NMI) &&
           (m_agt_np_msg_buf.flits[2] != AGT_DEASSERT_NMI)) ;
       endproperty
      if (EP_FPV)
      mmsg_np_simple_posted_vld_prop: assume property (mmsg_np_simple_posted_vld);
      else
      mmsg_np_simple_posted_vld_prop: assert property (mmsg_np_simple_posted_vld) else $display("ERROR: mmsg np simple msg cannot be non_posted");
      

      //simple do_serr message is posted
      property mmsg_np_simple_do_serr_posted_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_np_msg_buf.vld)                   
      |-> ((m_agt_np_msg_buf.flits[2] != AGT_DO_SERR));
      endproperty
      if (EP_FPV)
      mmsg_np_simple_do_serr_posted_vld_prop: assume property (mmsg_np_simple_do_serr_posted_vld);
      else
      mmsg_np_simple_do_serr_posted_vld_prop: assert property (mmsg_np_simple_do_serr_posted_vld) else $display("ERROR: mmsg np simple do_serr msg cannot be non_posted");
      

      //pm message needs to be posted
      property mmsg_np_pm_msg_posted_vld;
      @(posedge clk) disable iff (reset !== 1)(m_agt_np_msg_buf.vld)                   
      |-> ((m_agt_np_msg_buf.flits[2] != AGT_PM_REQ) &&
           (m_agt_np_msg_buf.flits[2] != AGT_PM_DMD) &&
           (m_agt_np_msg_buf.flits[2] != AGT_PM_RSP) &&
           (m_agt_np_msg_buf.flits[2] != AGT_SYNCSTARTCMD)); 
      endproperty
      if (EP_FPV)
      mmsg_np_pm_msg_posted_vld_prop: assume property (mmsg_np_pm_msg_posted_vld);
      else
      mmsg_np_pm_msg_posted_vld_prop: assert property (mmsg_np_pm_msg_posted_vld) else $display("ERROR: mmsg np pm_msg cannot be non_posted");
      

      //pci pm message needs to be posted
      property mmsg_np_pci_pm_msg_posted_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_np_msg_buf.vld)                   
      |-> ((m_agt_np_msg_buf.flits[2] != AGT_PCI_PM));
      endproperty
      if (EP_FPV)
      mmsg_np_pci_pm_msg_posted_vld_prop: assume property (mmsg_np_pci_pm_msg_posted_vld);
      else
      mmsg_np_pci_pm_msg_posted_vld_prop: assert property (mmsg_np_pci_pm_msg_posted_vld) else $display("ERROR: mmsg np pci pm msg cannot be non_posted");
      

      //pci error message needs to be posted
      property mmsg_np_pci_error_msg_posted_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_np_msg_buf.vld)                   
      |-> ((m_agt_np_msg_buf.flits[2] != AGT_PCI_E_ERROR));
      endproperty
      if (EP_FPV)
      mmsg_np_pci_error_msg_posted_vld_prop: assume property (mmsg_np_pci_error_msg_posted_vld);
      else
      mmsg_np_pci_error_msg_posted_vld_prop: assert property (mmsg_np_pci_error_msg_posted_vld) else $display("ERROR: mmsg np pci error pm msg cannot be non_posted");
      
      //localsync message needs to be non posted
      property mmsg_pc_localsync_msg_nonposted_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_pc_msg_buf.vld)                   
      |-> ((m_agt_pc_msg_buf.flits[2] != AGT_LOCALSYNC));
      endproperty
      if (EP_FPV)
      mmsg_pc_localsync_msg_nonposted_vld_prop: assume property (mmsg_pc_localsync_msg_nonposted_vld);
      else
      mmsg_pc_localsync_msg_nonposted_vld_prop: assert property (mmsg_pc_localsync_msg_nonposted_vld) else $display("ERROR: mmsg localsync cannot be posted");
      

      //simple ltr posted
      property mmsg_np_ltr_posted_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_np_msg_buf.vld)                   
      |-> ((m_agt_np_msg_buf.flits[2] != AGT_LTR));
      endproperty
      if (EP_FPV)
      mmsg_np_ltr_posted_vld_prop: assume property (mmsg_np_ltr_posted_vld);
      else
      mmsg_np_ltr_posted_vld_prop: assert property (mmsg_np_ltr_posted_vld) else $display("ERROR: mmsg np pm_ltr msg cannot be non_posted");
      

      //eh == 0 for all message
      property mmsg_np_eh_zero_fld_vld;
      @(posedge clk) disable iff (reset !== 1) ((m_agt_np_msg_buf.vld) && 
                                         ((agt_msg_is_simple ( m_agt_np_msg_buf.flits[2])) ||
                                          (agt_msg_is_data ( m_agt_np_msg_buf.flits[2])) ||
                                          (agt_msg_is_reg_access( m_agt_np_msg_buf.flits[2])) ||
                                          (agt_msg_is_completion( m_agt_np_msg_buf.flits[2]))))
      |-> (m_agt_np_msg_buf.flits[3][`AGT_EH_FIELD] == 0);
      endproperty
      if (EP_FPV)
      mmsg_np_eh_zero_fld_vld_prop: assume property (mmsg_np_eh_zero_fld_vld);
      else
      mmsg_np_eh_zero_fld_vld_prop: assert property (mmsg_np_eh_zero_fld_vld) else $display("ERROR: mmsg np msg is not with eh=0");
      

     //addrlen == 0 for message when sbendpoint param is 31
     //setting addrlen=0 for fpv only
      property mmsg_np_addrlen_zero_fld_vld;
      @(posedge clk) disable iff (reset !== 1) (m_agt_np_msg_buf.vld && (MAXMSTRADDR == 31 || MAXMSTRADDR == 15)) 
      |-> (m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0);
      endproperty
      if (EP_FPV)
      mmsg_np_addrlen_zero_fld_vld_prop: assume property (mmsg_np_addrlen_zero_fld_vld);
      
      
  
endmodule










