 
import IosfPkg::*;


class mem_badtxn_packet extends ovm_sequence_item;
  `ovm_object_utils(mem_badtxn_packet) 
rand bit [63:0] mem_addr; 
//rand bit [255:0] mem_data; //hqm_data_width is 32 bytes
rand Iosf::data_t     mem_data[];


//parity signals
   rand bit driveBadCmdParity; ; // toggles cmd parity signal
   rand bit driveBadDataParity; //  toggles data[0] when set
   rand int unsigned driveBadDataParityCycle;// bad parity data cycle
   rand int unsigned driveBadDataParityPct; // more than one cycle

function new (string name = "mem_badtxn_packet");
  super.new(name);
endfunction:new 

   constraint misaligned_memrd64 {
             //mem_addr inside {[64'h200000000:$]};
             mem_addr inside {64'h200000111,64'h2000000A3,64'h200000017,64'h2000000309,64'h200000043,64'h200000055,64'h200000077};

                              } 


 //from base address programming select base adress register 
   constraint misaligned_memwr64 {
             // mem_addr inside {64'h202000100,64'h2A0000120,64'h202000D00,64'h202000040,64'h202000044,64'h202002D04,64'h20200ED04};
             mem_addr inside {64'h200000111,64'h2000000A3,64'h200000017,64'h200000309,64'h200000043,64'h200000055,64'h200000077};

                                            }

     constraint unsupported_addr {
              //mem_addr inside {64'h202000100,64'h2A0000120,64'h202000D00,64'h202000040,64'h202000044,64'h202002D04,64'h20200ED04};
               mem_addr inside {64'h200004214,64'h200004218,64'h200004120};

                             } 
                        
       
           constraint unsupported_maddr {
              //mem_addr inside {64'h202000100,64'h2A0000120,64'h202000D00,64'h202000040,64'h202000044,64'h202002D04,64'h20200ED04};
              // mem_addr inside {64'h200004214,64'h200004218,64'h200004120};

               mem_addr inside {64'h300004214,64'h300004218,64'h300004120};

                             }       
   //no of DW  equal to 8
   constraint mem_data_size { 
  // mem_data.size() inside {[8:8]};
  (mem_data.size() == 1);
 }

  task randomize_foreach; 
      foreach ( mem_data[ i ] ) 
         mem_data[ i ] = i;// try with randomize( mem_data[i]) with ..... 
    endtask 


// 32 bit memory access address region defined
      constraint default_memwr32 {
             //mem_addr inside {[64'h00000000:64'hffffffff]};
              mem_addr inside {64'h000000100,64'h00000120,64'h000000D00,64'h000000040};

                             }

// 32 bit memory access address region defined
      constraint default_memrd32 {
             mem_addr inside {64'h000000100,64'h00000120,64'h000000D00,64'h000000040};
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
          driveBadDataParityPct inside {[90:100]};
          } // endconstraint: driveBadDataParity




endclass
