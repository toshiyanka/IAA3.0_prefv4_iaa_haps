//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 12-08-2011 
//-----------------------------------------------------------------
// Description:
// Class for Out of Band defines, enumerations
//------------------------------------------------------------------
//Edit here, change to your IP name, eg. `ifdef USB_OOB_CLASS
`ifndef PSMI_OOB_CLASS
`define PSMI_OOB_CLASS

//Edit here, change to your IP name, eg. usb_oob
class psmi_oob;

   //Edit the MAX_PSMI_OOB_NUM to specify how many OOB signals you have in your system
   //Edit the MAX_PSMI_OOB_SIZE to specify the maximum width among all of your OOB signals
   // Parameters
   parameter  MAX_PSMI_OOB_SIZE = 16; // maximum width of all interface signals
   parameter  MAX_PSMI_OOB_NUM  = 2; // 3 signals in the interface

   // Data types
   typedef logic [MAX_PSMI_OOB_SIZE-1:0] data_t;
   typedef logic [MAX_PSMI_OOB_NUM-1:0] idx_t;

   // Commands
   typedef enum {
      SET, // Set OOB signal
      GET // Get value of OOB signal
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
      req,
      gnt
   } sig_e;

   // Signal Properties Array
   //Edit this array to specify the direction, size and default values of each of your signals
   static const sig_prop_s sig_prop[sig_e] = '{
      // Name  : '{Type,   Width,   Default}
      req     : '{IN,     16,       16'h0000},
      gnt     : '{OUT,    16,       0}
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
endclass : psmi_oob

`endif // IP_OOB_CLASS
