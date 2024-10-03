//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 12-08-2011 
//-----------------------------------------------------------------
// Description:
// Class for Out of Band defines, enumerations
//------------------------------------------------------------------
//Edit here, change to your IP name, eg. `ifdef USB_OB_CLASS
`ifndef CCU_OB_CLASS
`define CCU_OB_CLASS

//Edit here, change to your IP name, eg. usb_ob
class ccu_ob;

   //Edit the MAX_OB_NUM to specify how many OOB signals you have in your system
   //Edit the MAX_OB_SIZE to specify the maximum width among all of your OOB signals
   // Parameters
   parameter  MAX_OB_SIZE = MAX_NUM_SLICES-1; // base 0
   parameter  MAX_OB_NUM  = 3; // log 2

   // Data types
   typedef logic [MAX_OB_SIZE:0] data_t;
   typedef logic [MAX_OB_NUM:0] idx_t;

   // Commands
   typedef enum {
      SET, // Set OB signal
      GET // Get value of OB signal
   } cmd_e;

   // Signal Type
   typedef enum {
      IN,    // Input to DUT
      OUT   // Output from DUT
   } sig_type_e;

   // Signal Properties Struct
   typedef struct {
      sig_type_e  sig_type;   // Signal type 
      int         width;      // Width of the signal
      data_t      def_val; // Default value (driven at time 0 in case of active)
                                 // def_val ignored for OUT/SPY signal types
   } sig_prop_s;

   // Signal names
   // Edit and update with the actual OOB signal names in your design here
   typedef enum idx_t {
      clkreq,
      clkack,
      usync,
      g_usync 
   } sig_e;

   // Signal Properties Array
   //Edit this array to specify the direction, size and default values of each of your signals
   static const sig_prop_s sig_prop[sig_e] = '{
      // Name  : '{Type,   Width,   Default}
      clkreq     : '{OUT,     MAX_OB_SIZE+1,       '0},
      clkack     : '{IN,      MAX_OB_SIZE+1,       '0},
      usync      : '{IN,      MAX_OB_SIZE+1,       '1},
      g_usync    : '{IN,      1,                 1}
   };

   // Event type
   typedef enum {
      R_EDGE,
      F_EDGE,
      CHANGE
   } event_e;

   // Calc event names helpers
   static function string get_event_name(sig_e sig, event_e e);
      string str;
      $sformat(str, "%s_%s", sig.name(), e.name());
      return str;
   endfunction
endclass : ccu_ob

`endif // CCU_OB_CLASS
