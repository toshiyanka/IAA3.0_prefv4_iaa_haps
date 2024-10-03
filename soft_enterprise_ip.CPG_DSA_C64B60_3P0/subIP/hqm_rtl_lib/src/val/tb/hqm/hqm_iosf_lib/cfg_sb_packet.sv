 
import IosfPkg::*;


class cfg_sb_packet extends ovm_sequence_item;
  `ovm_object_utils(cfg_sb_packet) 

  
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



function new (string name = "cfg_sb_packet");
  super.new(name);
endfunction:new  

 constraint default_cfgrd {
           // soft cfg_addr inside {[64'h00:64'h3C]};
             //cfg_addr inside {64'h00010,64'h00014,64'h0003C,64'h00008,64'h00074};
             cfg_addr inside {64'h00010,64'h00014,64'h0003C,64'h00008};

            
  }

   constraint default_cfgwr {
             cfg_addr inside {64'h00010,64'h00014,64'h0003C};
                               }

      constraint default_data {
                      cfg_data inside {32'h00,32'h10,32'h20,32'h30};
                           }        






endclass
