 
import IosfPkg::*;


class cfg_packet extends ovm_sequence_item;
  `ovm_object_utils(cfg_packet) 

  
   rand bit [63:0] cfg_addr; 
   rand Iosf::data_t     cfg_data;
  //parity signals
   rand bit driveBadCmdParity; ; // toggles cmd parity signal
   rand bit driveBadDataParity; //  toggles data[0] when set
   rand int unsigned driveBadDataParityCycle;// bad parity data cycle
   rand int unsigned driveBadDataParityPct; // more than one cycle

// constant 
int np_cnt = 2 ; //max np credit
int p_cnt = 16 ; //max p credit 



function new (string name = "cfg_packet");
  super.new(name);
endfunction:new  

 constraint default_cfgrd {
            soft cfg_addr inside {[64'h0000C:64'h0003C]};
            
  }

   constraint default_cfgwr {
             cfg_addr dist {64'h01000010:/33,64'h01000014:/33,64'h0100003C:/33};
                               }

      constraint default_data {
                      cfg_data inside {32'h00,32'h10,32'h20,32'h30};
                           }        
/************************************************************
* driveBadParity_c - drive only bad parity
*************************************************************/
    constraint driveBadCmdParity_c
        { 
            (driveBadCmdParity == 1);
            (driveBadDataParity == 0);

          } // endconstraint: driveBadCmdParity

      constraint driveBadDataParity_c
        { 
              (driveBadDataParity == 1);
              (driveBadCmdParity == 0);
          (driveBadDataParityCycle == 0);
          (driveBadDataParityPct == 100);
          } // endconstraint: driveBadDataParity







endclass
