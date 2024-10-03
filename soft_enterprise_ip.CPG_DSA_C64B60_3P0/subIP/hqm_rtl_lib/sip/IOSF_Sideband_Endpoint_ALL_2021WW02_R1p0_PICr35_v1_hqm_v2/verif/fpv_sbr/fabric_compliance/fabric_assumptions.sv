
// Assumptions to generate valid traffic between 2 ports
// port1's pid is 'h01 and port2's pid is 'h04
// follwoing assertion sets source and dest pids for 2 ports

module fabric_assumptions ();

   parameter DESTID01 = 4;
   parameter DESTID02 = 1;
   parameter SOURCEID01 = 1;
   parameter SOURCEID02 = 4;
   
   default clocking @(posedge sbr.clk); endclocking
   default disable iff (!sbr.rstb);
 
   b1:  assume property (sbr.sbc_compliance0.sbc_ifc_compliance.agent_message_compliance.m_msg_buf[0].flits[0][7:0] == 'h04);   
   b2:  assume property (sbr.sbc_compliance0.sbc_ifc_compliance.agent_message_compliance.m_msg_buf[1].flits[0][7:0] == 'h04);  
   b3:  assume property (sbr.sbc_compliance0.sbc_ifc_compliance.agent_message_compliance.m_msg_buf[0].flits[1][7:0] == 'h01);   
   b4:  assume property (sbr.sbc_compliance0.sbc_ifc_compliance.agent_message_compliance.m_msg_buf[1].flits[1][7:0] == 'h01);
   
   b5:  assume property (sbr.sbc_compliance1.sbc_ifc_compliance.agent_message_compliance.m_msg_buf[0].flits[0][7:0] == 'h01);   
   b6:  assume property (sbr.sbc_compliance1.sbc_ifc_compliance.agent_message_compliance.m_msg_buf[1].flits[0][7:0] == 'h01);  
   b7:  assume property (sbr.sbc_compliance1.sbc_ifc_compliance.agent_message_compliance.m_msg_buf[0].flits[1][7:0] == 'h04);   
   b8:  assume property (sbr.sbc_compliance1.sbc_ifc_compliance.agent_message_compliance.m_msg_buf[1].flits[1][7:0] == 'h04); 
   
endmodule // fabric_assumptions

