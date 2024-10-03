//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 12-08-2011 
//-----------------------------------------------------------------
// Description:
// test island
//------------------------------------------------------------------
import ovm_pkg::*;
import ccu_ob_pkg::*;

module ccu_ob_ti #(
	
   parameter string IP_ENV_TO_AGT_PATH = "*",
   parameter MAX_OB_NUM = ccu_ob::MAX_OB_NUM,
   parameter MAX_OB_SIZE = ccu_ob::MAX_OB_SIZE)

   (
   interface  ccu_ob_intf              

);

   function void connect_ob();      
   // Pass interface
   sla_pkg::sla_vif_container #(virtual ccu_ob_intf) ccu_ob_IFcontainer;
   ccu_ob_IFcontainer = new("ccu_ob_if_container");
   ccu_ob_IFcontainer.set_v_if(ccu_ob_intf);
   set_config_object({IP_ENV_TO_AGT_PATH,"*"}, "ccu_ob_if_container", ccu_ob_IFcontainer,0);
   endfunction: connect_ob

   initial begin : TI_CONNECT
      connect_ob();
   end : TI_CONNECT
endmodule : ccu_ob_ti
