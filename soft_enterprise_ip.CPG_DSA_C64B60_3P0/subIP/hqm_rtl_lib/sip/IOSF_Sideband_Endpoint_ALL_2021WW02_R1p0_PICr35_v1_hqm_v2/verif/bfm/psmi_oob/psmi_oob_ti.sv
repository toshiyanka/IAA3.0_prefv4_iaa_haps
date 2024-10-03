//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 12-08-2011 
//-----------------------------------------------------------------
// Description:
// test island
//------------------------------------------------------------------

import psmi_oob_pkg::*;

module psmi_oob_ti #(
   parameter string INTF_NAME = "psmi_oob_intf",
   parameter MAX_PSMI_OOB_NUM = psmi_oob::MAX_PSMI_OOB_NUM,
   parameter MAX_PSMI_OOB_SIZE = psmi_oob::MAX_PSMI_OOB_SIZE)

   (
   interface  psmi_oob_intf              

);
   // Jacob added to compile with newer VCS
   import sla_pkg::*;

   function void connect_psmi_oob();      
   // Pass interface
      sla_resource_db #(virtual psmi_oob_intf)::add (
         INTF_NAME, psmi_oob_intf, `__FILE__, `__LINE__
      );
   endfunction: connect_psmi_oob

   initial begin : TI_CONNECT
      connect_psmi_oob();
   end : TI_CONNECT
endmodule : psmi_oob_ti
