 
import IosfPkg::*;


class mem_sb_packet extends ovm_sequence_item;
  `ovm_object_utils(mem_sb_packet) 
rand bit [63:0] mem_addr; 
//rand bit [255:0] mem_data; //hqm_data_width is 32 bytes
rand Iosf::data_t     mem_data[];
randc bit [3:0]        cpl_status;


//parity signals
   rand bit driveBadCmdParity; ; // toggles cmd parity signal
   rand bit driveBadDataParity; //  toggles data[0] when set
   rand int unsigned driveBadDataParityCycle;// bad parity data cycle
   rand int unsigned driveBadDataParityPct; // more than one cycle

function new (string name = "mem_sb_packet");
  super.new(name);
endfunction:new 

   constraint default_memrd64 {
             //mem_addr inside {[64'h200000000:$]};
             //mem_addr inside {64'h000004120,64'h000004214,64'h00004218,64'h00000600,64'h00000408,64'h0000040C,64'h0000_0410};
             mem_addr inside {64'h008001084,64'h008001088};

                              } 


 //from base address programming select base adress register 
   constraint default_memwr64 {
             // mem_addr inside {64'h202000100,64'h2A0000120,64'h202000D00,64'h202000040,64'h202000044,64'h202002D04,64'h20200ED04};
               mem_addr inside {64'h008001084,64'h008001088};

                             }

   constraint zero_sbe_c{
               (mem_addr == 64'h018001048);};

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
              mem_addr inside {64'h000000000,64'h0000000C,64'h000000008,64'h000000004};

                             }

// 32 bit memory access address region defined
      constraint default_memrd32 {
             mem_addr inside {64'h000000000,64'h0000000C,64'h000000008,64'h000000004};
                             }
  
  constraint legal_cplstatus
        { 
           cpl_status inside {4'h0,4'h1,4'h2,64'h4};

          } 
 
    constraint illegal_cplstatus
        {      cpl_status inside {4'h3,4'h5,4'h6,64'h7};
          } 
 

     


   
 



endclass
