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
   input  bit clk,
   input  bit reset,
   input  bit[1:0] mirdy,
   input  bit[1:0] mtrdy, 
   input  bit[1:0] meom,
   input  bit[31:0] mmsg_pcpayload,
   input  bit[31:0] mmsg_nppayload,
   input bit[1:0] mmsgip,
   input bit[1:0] msel
);

   agt_message_buf_t m_agt_pc_msg_buf;
   agt_message_buf_t m_agt_np_msg_buf;
   
  
   `define PACK_FLITS(payload, flit_buf, buf_size, start) \
      for (int i = 0; i < AGT_DW_SIZE; i++) begin \
         if (start+i < buf_size) \
            flit_buf[start+i] <= \
               payload[i*8 +: 8];\
      end 



 
   /**
    *
    * The npirdy and pcirdy signals may never be asserted in the 
    * same clock cycle.
    */

//   np_and_pc_irdy_cannot_happen_together_assume: assume property (mirdy[1] || $onehot0(mirdy[0]));

   //generate for (genvar iter = 0; iter < 2; iter++) begin 
   
      always @(posedge clk)
         if (mirdy[0] && mtrdy[0]) begin
	    // valid flit/byte

            if (m_agt_pc_msg_buf.vld) begin
               // back-to-back case
               `PACK_FLITS(mmsg_pcpayload, m_agt_pc_msg_buf.flits, 72, 0);

            end else begin
	       // normal flits
               `PACK_FLITS (mmsg_pcpayload, m_agt_pc_msg_buf.flits, 72, m_agt_pc_msg_buf.num_flits);               
            end
         end // if (mirdy[0] && mtrdy[0])
   
   always @(posedge clk)
            if (mirdy[1] && mtrdy[1] ) begin
	    // valid flit/byte

            if (m_agt_np_msg_buf.vld) begin
               // back-to-back case
               `PACK_FLITS(mmsg_nppayload, m_agt_np_msg_buf.flits, 72, 0);

            end else begin
	       // normal flits
               `PACK_FLITS (mmsg_nppayload, m_agt_np_msg_buf.flits, 72, m_agt_np_msg_buf.num_flits);               
            end            
	    end

 
      /**
       * Make the assembled message valid when eom is seen.
       */
      always @(posedge clk or negedge reset)
         if (!reset)
            begin
               m_agt_pc_msg_buf.vld <= 0;
               
            end
         else
            begin
               m_agt_pc_msg_buf.vld <= mirdy[0] && mtrdy[0] && meom[0];
               
            end // else: !if(!reset)
   
     always @(posedge clk or negedge reset)
         if (!reset)
            begin
               m_agt_np_msg_buf.vld <= 0;
               
            end
         else
            begin
               m_agt_np_msg_buf.vld <= mirdy[1] && mtrdy[1] && meom[1];
               
            end
      /**
       * Count number of flits in a message under assembly
       */
      always @(posedge clk or negedge reset)
         if (!reset) begin
            m_agt_pc_msg_buf.num_flits <= 0;
            
         end else if (m_agt_pc_msg_buf.vld) begin
            if (mirdy[0] && mtrdy[0])  // back-to-back message
              m_agt_pc_msg_buf.num_flits <= AGT_DW_SIZE;
            
            else // inactivity between mesages
              m_agt_pc_msg_buf.num_flits <= 0;
            
                      
         end else if (mirdy[0] && mtrdy[0]) begin
            m_agt_pc_msg_buf.num_flits <= 
	        m_agt_pc_msg_buf.num_flits + AGT_DW_SIZE;  
            
         end

      /**
       * Count number of flits in a message under assembly
       */
      always @(posedge clk or negedge reset)
         if (!reset) begin
            m_agt_np_msg_buf.num_flits <= 0;
            
         end else if (m_agt_np_msg_buf.vld) begin
            if (mirdy[1] && mtrdy[1])  // back-to-back message
              m_agt_np_msg_buf.num_flits <= AGT_DW_SIZE;
            
            else // inactivity between mesages
              m_agt_np_msg_buf.num_flits <= 0;
            
                      
         end else if (mirdy[1] && mtrdy[1]) begin
            m_agt_np_msg_buf.num_flits <= 
	        m_agt_np_msg_buf.num_flits + AGT_DW_SIZE;  
            
         end
   

   //*************************************************************************
   // Message Validity assumptions
   //*************************************************************************
  
      //valid message size, multiple of dw   
     property mmsg_pc_size_vld;
        @(posedge clk) disable iff(reset) 
        (m_agt_pc_msg_buf.vld) |-> (agt_msg_is_DW_aligned( m_agt_pc_msg_buf.num_flits ));
      endproperty        
      mmsg_pc_size_vld_assume: assume property (mmsg_pc_size_vld);

      //valid opcode 
      property mmsg_pc_opcode_vld;
        @(posedge clk) disable iff(reset) m_agt_pc_msg_buf.vld 
        |-> ((agt_msg_is_simple ( m_agt_pc_msg_buf.flits[2] ) || 
              agt_msg_is_data ( m_agt_pc_msg_buf.flits[2] ) ||       
              agt_msg_is_completion ( m_agt_pc_msg_buf.flits[2] ) || 
              agt_msg_is_reg_access ( m_agt_pc_msg_buf.flits[2] )));
      
      endproperty        
      mmsg_pc_opcode_vld_assume: assume property (mmsg_pc_opcode_vld);  

      //valid simple message size
      property mmsg_pc_simple_msg_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_simple ( m_agt_pc_msg_buf.flits[2])))
      |-> (m_agt_pc_msg_buf.num_flits == AGT_DW_SIZE);
      endproperty
      mmsg_pc_simple_msg_vld_assume: assume property (mmsg_pc_simple_msg_vld);

      //reserved field ==0 for simple message
      property mmsg_pc_simple_reserved_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_simple ( m_agt_pc_msg_buf.flits[2])))
      |-> (m_agt_pc_msg_buf.flits[3][`AGT_RESERVED_FIELD] == 0);
      endproperty
      mmsg_pc_simple_reserved_fld_vld_assume: assume property (mmsg_pc_simple_reserved_fld_vld);

      //valid msgd message size
      property mmsg_pc_msgd_msg_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_data ( m_agt_pc_msg_buf.flits[2])))
      |-> (m_agt_pc_msg_buf.num_flits >= 2 * AGT_DW_SIZE);
      endproperty
      mmsg_pc_msgd_msg_vld_assume: assume property (mmsg_pc_msgd_msg_vld);

      //reserved field == 0 for msgd messages
      property mmsg_pc_msgd_reserved_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_data ( m_agt_pc_msg_buf.flits[2])))
      |-> (m_agt_pc_msg_buf.flits[3][`AGT_RESERVED_FIELD] == 0);
      endproperty
      mmsg_pc_msgd_reserved_fld_vld_assume: assume property (mmsg_pc_msgd_reserved_fld_vld);

      //addrlen should be 0 or 1 for regio messages
      property mmsg_pc_regio_addrlen_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_reg_access ( m_agt_pc_msg_buf.flits[2])))
      |-> (m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0) || (m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 1);
      endproperty
      mmsg_pc_regio_addrlen_fld_vld_assume: assume property (mmsg_pc_regio_addrlen_fld_vld);

      //cfgwr, cfgrd, iowr, iord need 16 bit addrlen
      property mmsg_pc_regio_cfgio_addrlen_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (m_agt_pc_msg_buf.flits[2] inside 
                                          { AGT_IORD, AGT_IOWR,
                                            AGT_CFGRD, AGT_CFGWR}))
      |-> (m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0);
      endproperty
      mmsg_pc_regio_cfgio_addrlen_fld_vld_assume: assume property (mmsg_pc_regio_cfgio_addrlen_fld_vld);
 
      //mwr, mrd, iowr, iord need dw alligned address
      property mmsg_pc_regio_mio_dw_addr_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (m_agt_pc_msg_buf.flits[2] inside 
                                          { AGT_IORD, AGT_IOWR,
                                            AGT_MRD, AGT_MWR}))
      |-> (m_agt_pc_msg_buf.flits[AGT_FST_ADDR_FLIT][1:0] == 2'b00);
      endproperty
      mmsg_pc_regio_mio_dw_addr_fld_vld_assume: assume property (mmsg_pc_regio_mio_dw_addr_fld_vld);

      //cfgrd, cfgwr need dw alligned address
      property mmsg_pc_regio_cfg_dw_addr_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_reg_access(m_agt_pc_msg_buf.flits[2]))) 
      |-> (m_agt_pc_msg_buf.flits[AGT_FST_ADDR_FLIT][1] == 1'b0);
      endproperty
      mmsg_pc_regio_cfg_dw_addr_fld_vld_assume: assume property (mmsg_pc_regio_cfg_dw_addr_fld_vld);

      //regio addr QW alligned
      property mmsg_pc_regio_qw_addr_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_reg_access(m_agt_pc_msg_buf.flits[2])) &&
                                         m_agt_pc_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] > 0)
      |-> (m_agt_pc_msg_buf.flits[AGT_FST_ADDR_FLIT][2] == 0);
      endproperty
      mmsg_pc_regio_qw_addr_fld_vld_assume: assume property (mmsg_pc_regio_qw_addr_fld_vld);

      //valid regio read
      property mmsg_pc_regio_read_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_gl_reg_read(m_agt_pc_msg_buf.flits[2])))
      |-> (m_agt_pc_msg_buf.num_flits == ((2+m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD]) * AGT_DW_SIZE));
      endproperty
      mmsg_pc_regio_read_vld_assume: assume property (mmsg_pc_regio_read_vld);

      //valid regio write with sbe=0
      property mmsg_pc_regio_write_sbe_zero_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_gl_reg_write(m_agt_pc_msg_buf.flits[2] )) &&
                                         (m_agt_pc_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] == 0))
      |-> (m_agt_pc_msg_buf.num_flits == (3+m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD])*4);
      endproperty
      mmsg_pc_regio_write_sbe_zero_vld_assume: assume property (mmsg_pc_regio_write_sbe_zero_vld);
                                         
      //valid regio write with sbe nonzero
      property mmsg_pc_regio_write_sbe_nonzero_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (agt_msg_is_gl_reg_write(m_agt_pc_msg_buf.flits[2] )) &&
                                         (m_agt_pc_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] != 0))
      |-> (m_agt_pc_msg_buf.num_flits == 
           (AGT_DW_SIZE+m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD])*AGT_DW_SIZE);
      endproperty
      mmsg_pc_regio_write_sbe_nonzero_vld_assume: assume property (mmsg_pc_regio_write_sbe_nonzero_vld);      

      //valid completion without data message
      property mmsg_pc_cmp_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (m_agt_pc_msg_buf.flits[2] == AGT_CMP)) 
      |-> (m_agt_pc_msg_buf.num_flits == AGT_DW_SIZE);
      endproperty
      mmsg_pc_cmp_vld_assume: assume property (mmsg_pc_cmp_vld);    

      //valid completion with data message
      property mmsg_pc_cmpd_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         (m_agt_pc_msg_buf.flits[2] == AGT_CMPD)) 
      |-> (m_agt_pc_msg_buf.num_flits > AGT_DW_SIZE) &&
         agt_msg_is_DW_aligned( m_agt_pc_msg_buf.num_flits);
      endproperty
      mmsg_pc_cmpd_vld_assume: assume property (mmsg_pc_cmpd_vld);  

      //non_posted read
      property mmsg_pc_read_cannot_posted_vld;
      @(posedge clk) disable iff(reset) (m_agt_pc_msg_buf.vld)
      |-> (!agt_msg_is_reg_read( m_agt_pc_msg_buf.flits[2]));
      endproperty
      mmsg_pc_read_cannot_posted_vld_assume: assume property (mmsg_pc_read_cannot_posted_vld);  

      //pm message is 3dw
      property mmsg_pc_pm_msg_vld;
      @(posedge clk) disable iff(reset) (m_agt_pc_msg_buf.vld) &&
                                         (m_agt_pc_msg_buf.flits[2] == AGT_PM_REQ || 
                                          m_agt_pc_msg_buf.flits[2] == AGT_PM_DMD ||
                                          m_agt_pc_msg_buf.flits[2] == AGT_PM_RSP)
      |-> (m_agt_pc_msg_buf.num_flits == 3 * AGT_DW_SIZE);
      endproperty
      mmsg_pc_pm_msg_vld_assume: assume property (mmsg_pc_pm_msg_vld); 

      //pm message is 2dw
      property mmsg_pc_pm_ltr_msg_vld;
      @(posedge clk) disable iff(reset) (m_agt_pc_msg_buf.vld) &&
                                         (m_agt_pc_msg_buf.flits[2] == AGT_LTR)
      |-> (m_agt_pc_msg_buf.num_flits == 2 * AGT_DW_SIZE);
      endproperty
      mmsg_pc_pm_ltr_msg_vld_assume: assume property (mmsg_pc_pm_ltr_msg_vld);


      //eh == 0 for all message
      property mmsg_pc_eh_zero_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_pc_msg_buf.vld) && 
                                         ((agt_msg_is_simple ( m_agt_pc_msg_buf.flits[2])) ||
                                          (agt_msg_is_data ( m_agt_pc_msg_buf.flits[2])) ||
                                          (agt_msg_is_reg_access( m_agt_pc_msg_buf.flits[2])) ||
                                          (agt_msg_is_completion( m_agt_pc_msg_buf.flits[2]))))
      |-> (m_agt_pc_msg_buf.flits[3][`AGT_EH_FIELD] == 0);
      endproperty
      mmsg_pc_eh_zero_fld_vld_assume: assume property (mmsg_pc_eh_zero_fld_vld);

     //addrlen == 0 for all message (since sbendpoint param is 31)
      property mmsg_pc_addrlen_zero_fld_vld;
      @(posedge clk) disable iff(reset) (m_agt_pc_msg_buf.vld) 
      |-> (m_agt_pc_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0);
      endproperty
      mmsg_pc_addrlen_zero_fld_vld_assume: assume property (mmsg_pc_addrlen_zero_fld_vld);
      




      //valid message size, multiple of dw   
     property mmsg_np_size_vld;
        @(posedge clk) disable iff(reset) 
        (m_agt_np_msg_buf.vld) |-> (agt_msg_is_DW_aligned( m_agt_np_msg_buf.num_flits ));
      endproperty        
      mmsg_np_size_vld_assume: assume property (mmsg_np_size_vld);

      //valid opcode 
      property mmsg_np_opcode_vld;
        @(posedge clk) disable iff(reset) m_agt_np_msg_buf.vld 
        |-> ((agt_msg_is_simple ( m_agt_np_msg_buf.flits[2] ) || 
              agt_msg_is_data ( m_agt_np_msg_buf.flits[2] ) ||       
              agt_msg_is_completion ( m_agt_np_msg_buf.flits[2] ) || 
              agt_msg_is_reg_access ( m_agt_np_msg_buf.flits[2] )));
      
      endproperty        
      mmsg_np_opcode_vld_assume: assume property (mmsg_np_opcode_vld);  

      //valid simple message size
      property mmsg_np_simple_msg_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_simple ( m_agt_np_msg_buf.flits[2])))
      |-> (m_agt_np_msg_buf.num_flits == AGT_DW_SIZE);
      endproperty
      mmsg_np_simple_msg_vld_assume: assume property (mmsg_np_simple_msg_vld);

      //reserved field ==0 for simple message
      property mmsg_np_simple_reserved_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_simple ( m_agt_np_msg_buf.flits[2])))
      |-> (m_agt_np_msg_buf.flits[3][`AGT_RESERVED_FIELD] == 0);
      endproperty
      mmsg_np_simple_reserved_fld_vld_assume: assume property (mmsg_np_simple_reserved_fld_vld);

      //valid msgd message size
      property mmsg_np_msgd_msg_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_data ( m_agt_np_msg_buf.flits[2])))
      |-> (m_agt_np_msg_buf.num_flits >= 2 * AGT_DW_SIZE);
      endproperty
      mmsg_np_msgd_msg_vld_assume: assume property (mmsg_np_msgd_msg_vld);

      //reserved field == 0 for msgd messages
      property mmsg_np_msgd_reserved_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_data ( m_agt_np_msg_buf.flits[2])))
      |-> (m_agt_np_msg_buf.flits[3][`AGT_RESERVED_FIELD] == 0);
      endproperty
      mmsg_np_msgd_reserved_fld_vld_assume: assume property (mmsg_np_msgd_reserved_fld_vld);

      //addrlen should be 0 or 1 for regio messages
      property mmsg_np_regio_addrlen_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_reg_access ( m_agt_np_msg_buf.flits[2])))
      |-> (m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0) || (m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 1);
      endproperty
      mmsg_np_regio_addrlen_fld_vld_assume: assume property (mmsg_np_regio_addrlen_fld_vld);

      //cfgwr, cfgrd, iowr, iord need 16 bit addrlen
      property mmsg_np_regio_cfgio_addrlen_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (m_agt_np_msg_buf.flits[2] inside 
                                          { AGT_IORD, AGT_IOWR,
                                            AGT_CFGRD, AGT_CFGWR}))
      |-> (m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0);
      endproperty
      mmsg_np_regio_cfgio_addrlen_fld_vld_assume: assume property (mmsg_np_regio_cfgio_addrlen_fld_vld);
 
      //mwr, mrd, iowr, iord need dw alligned address
      property mmsg_np_regio_mio_dw_addr_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (m_agt_np_msg_buf.flits[2] inside 
                                          { AGT_IORD, AGT_IOWR,
                                            AGT_MRD, AGT_MWR}))
      |-> (m_agt_np_msg_buf.flits[AGT_FST_ADDR_FLIT][1:0] == 2'b00);
      endproperty
      mmsg_np_regio_mio_dw_addr_fld_vld_assume: assume property (mmsg_np_regio_mio_dw_addr_fld_vld);

      //cfgrd, cfgwr need dw alligned address
      property mmsg_np_regio_cfg_dw_addr_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_reg_access(m_agt_np_msg_buf.flits[2]))) 
      |-> (m_agt_np_msg_buf.flits[AGT_FST_ADDR_FLIT][1] == 1'b0);
      endproperty
      mmsg_np_regio_cfg_dw_addr_fld_vld_assume: assume property (mmsg_np_regio_cfg_dw_addr_fld_vld);

      //regio addr QW alligned
      property mmsg_np_regio_qw_addr_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_reg_access(m_agt_np_msg_buf.flits[2])) &&
                                         m_agt_np_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] > 0)
      |-> (m_agt_np_msg_buf.flits[AGT_FST_ADDR_FLIT][2] == 0);
      endproperty
      mmsg_np_regio_qw_addr_fld_vld_assume: assume property (mmsg_np_regio_qw_addr_fld_vld);

      //valid regio read
      property mmsg_np_regio_read_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_gl_reg_read(m_agt_np_msg_buf.flits[2])))
      |-> (m_agt_np_msg_buf.num_flits == ((2+m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD]) * AGT_DW_SIZE));
      endproperty
      mmsg_np_regio_read_vld_assume: assume property (mmsg_np_regio_read_vld);

      //valid regio write with sbe=0
      property mmsg_np_regio_write_sbe_zero_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_gl_reg_write(m_agt_np_msg_buf.flits[2] )) &&
                                         (m_agt_np_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] == 0))
      |-> (m_agt_np_msg_buf.num_flits == (3+m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD])*4);
      endproperty
      mmsg_np_regio_write_sbe_zero_vld_assume: assume property (mmsg_np_regio_write_sbe_zero_vld);
                                         
      //valid regio write with sbe nonzero
      property mmsg_np_regio_write_sbe_nonzero_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (agt_msg_is_gl_reg_write(m_agt_np_msg_buf.flits[2] )) &&
                                         (m_agt_np_msg_buf.flits[AGT_BE_FLIT][`AGT_SBE_FIELD] != 0))
      |-> (m_agt_np_msg_buf.num_flits == 
           (AGT_DW_SIZE+m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD])*AGT_DW_SIZE);
      endproperty
      mmsg_np_regio_write_sbe_nonzero_vld_assume: assume property (mmsg_np_regio_write_sbe_nonzero_vld);      

      //valid completion without data message
      property mmsg_np_cmp_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (m_agt_np_msg_buf.flits[2] == AGT_CMP)) 
      |-> (m_agt_np_msg_buf.num_flits == AGT_DW_SIZE);
      endproperty
      mmsg_np_cmp_vld_assume: assume property (mmsg_np_cmp_vld);    

      //valid completion with data message
      property mmsg_np_cmpd_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         (m_agt_np_msg_buf.flits[2] == AGT_CMPD)) 
      |-> (m_agt_np_msg_buf.num_flits > AGT_DW_SIZE) &&
         agt_msg_is_DW_aligned( m_agt_np_msg_buf.num_flits);
      endproperty
      mmsg_np_cmpd_vld_assume: assume property (mmsg_np_cmpd_vld);  

      //non_posted read
      property mmsg_np_read_cannot_posted_vld;
      @(posedge clk) disable iff(reset) (m_agt_np_msg_buf.vld)
      |-> (!agt_msg_is_reg_read( m_agt_np_msg_buf.flits[2]));
      endproperty
      mmsg_np_read_cannot_posted_vld_assume: assume property (mmsg_np_read_cannot_posted_vld);  

      //pm message is 3dw
      property mmsg_np_pm_msg_vld;
      @(posedge clk) disable iff(reset) (m_agt_np_msg_buf.vld) &&
                                         (m_agt_np_msg_buf.flits[2] == AGT_PM_REQ || 
                                          m_agt_np_msg_buf.flits[2] == AGT_PM_DMD ||
                                          m_agt_np_msg_buf.flits[2] == AGT_PM_RSP)
      |-> (m_agt_np_msg_buf.num_flits == 3 * AGT_DW_SIZE);
      endproperty
      mmsg_np_pm_msg_vld_assume: assume property (mmsg_np_pm_msg_vld); 

      //pm message is 2dw
      property mmsg_np_pm_ltr_msg_vld;
      @(posedge clk) disable iff(reset) (m_agt_np_msg_buf.vld) &&
                                         (m_agt_np_msg_buf.flits[2] == AGT_LTR)
      |-> (m_agt_np_msg_buf.num_flits == 2 * AGT_DW_SIZE);
      endproperty
      mmsg_np_pm_ltr_msg_vld_assume: assume property (mmsg_np_pm_ltr_msg_vld);

      //simple message is posted
      property mmsg_np_simple_posted_vld;
      @(posedge clk) disable iff(reset) (m_agt_np_msg_buf.vld)                   
      |-> ((m_agt_np_msg_buf.flits[2] != AGT_ASSERT_INTA) &&
           (m_agt_np_msg_buf.flits[2] != AGT_ASSERT_INTB) &&
           (m_agt_np_msg_buf.flits[2] != AGT_ASSERT_INTC) &&
           (m_agt_np_msg_buf.flits[2] != AGT_ASSERT_INTD) &&
           (m_agt_np_msg_buf.flits[2] != AGT_DEASSERT_INTA) &&
           (m_agt_np_msg_buf.flits[2] != AGT_DEASSERT_INTB) &&
           (m_agt_np_msg_buf.flits[2] != AGT_DEASSERT_INTC) &&
           (m_agt_np_msg_buf.flits[2] != AGT_DEASSERT_INTD));
      endproperty
      mmsg_np_simple_posted_vld_assume: assume property (mmsg_np_simple_posted_vld);
 
      //simple do_serr message is posted
      property mmsg_np_simple_do_serr_posted_vld;
      @(posedge clk) disable iff(reset) (m_agt_np_msg_buf.vld)                   
      |-> ((m_agt_np_msg_buf.flits[2] != AGT_DO_SERR));
      endproperty
      mmsg_np_simple_do_serr_posted_vld_assume: assume property (mmsg_np_simple_do_serr_posted_vld);

      //pm message needs to be posted
      property mmsg_np_pm_msg_posted_vld;
      @(posedge clk) disable iff(reset) (m_agt_np_msg_buf.vld)                   
      |-> ((m_agt_np_msg_buf.flits[2] != AGT_PM_REQ) &&
           (m_agt_np_msg_buf.flits[2] != AGT_PM_DMD) &&
           (m_agt_np_msg_buf.flits[2] != AGT_PM_RSP));
      endproperty
      mmsg_np_pm_msg_posted_vld_assume: assume property (mmsg_np_pm_msg_posted_vld);

      //pci pm message needs to be posted
      property mmsg_np_pci_pm_msg_posted_vld;
      @(posedge clk) disable iff(reset) (m_agt_np_msg_buf.vld)                   
      |-> ((m_agt_np_msg_buf.flits[2] != AGT_PCI_PM));
      endproperty
      mmsg_np_pci_pm_msg_posted_vld_assume: assume property (mmsg_np_pci_pm_msg_posted_vld);

      //pci error message needs to be posted
      property mmsg_np_pci_error_msg_posted_vld;
      @(posedge clk) disable iff(reset) (m_agt_np_msg_buf.vld)                   
      |-> ((m_agt_np_msg_buf.flits[2] != AGT_PCI_E_ERROR));
      endproperty
      mmsg_np_pci_error_msg_posted_vld_assume: assume property (mmsg_np_pci_error_msg_posted_vld);

      //simple ltr posted
      property mmsg_np_ltr_posted_vld;
      @(posedge clk) disable iff(reset) (m_agt_np_msg_buf.vld)                   
      |-> ((m_agt_np_msg_buf.flits[2] != AGT_LTR));
      endproperty
      mmsg_np_ltr_posted_vld_assume: assume property (mmsg_np_ltr_posted_vld);

      //eh == 0 for all message
      property mmsg_np_eh_zero_fld_vld;
      @(posedge clk) disable iff(reset) ((m_agt_np_msg_buf.vld) && 
                                         ((agt_msg_is_simple ( m_agt_np_msg_buf.flits[2])) ||
                                          (agt_msg_is_data ( m_agt_np_msg_buf.flits[2])) ||
                                          (agt_msg_is_reg_access( m_agt_np_msg_buf.flits[2])) ||
                                          (agt_msg_is_completion( m_agt_np_msg_buf.flits[2]))))
      |-> (m_agt_np_msg_buf.flits[3][`AGT_EH_FIELD] == 0);
      endproperty
      mmsg_np_eh_zero_fld_vld_assume: assume property (mmsg_np_eh_zero_fld_vld);

     //addrlen == 0 for all message (since sbendpoint param is 31)
      property mmsg_np_addrlen_zero_fld_vld;
      @(posedge clk) disable iff(reset) (m_agt_np_msg_buf.vld) 
      |-> (m_agt_np_msg_buf.flits[3][`AGT_ADDRMODE_FIELD] == 0);
      endproperty
      mmsg_np_addrlen_zero_fld_vld_assume: assume property (mmsg_np_addrlen_zero_fld_vld);
      
      
  
endmodule










