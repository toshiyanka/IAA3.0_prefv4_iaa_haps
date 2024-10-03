 
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


function new (string name = "cfg_packet");
  super.new(name);
endfunction:new  

 constraint default_cfgrd {
            soft cfg_addr inside {[64'h00:64'h3C]};
            
  }

   constraint default_cfgwr {
             cfg_addr inside {[64'h10:64'h24]};
                (cfg_addr==64'h10)->(cfg_data==32'h0);
                (cfg_addr==64'h18)->(cfg_data==32'h0);
                (cfg_addr==64'h20)->(cfg_data==32'h0);
                (cfg_addr==64'h14)->(cfg_data==32'h2);
                (cfg_addr==64'h1c)->(cfg_data==32'h2);
                (cfg_addr==64'h24)->(cfg_data==32'h2); 
              solve cfg_addr before cfg_data; 
               }

          /* constraint dataImplication {    
             
             //if (cfg_addr inside {64'h10 , 64'h18 , 64'h20 })(cfg_data == 32'h0);
             //if (cfg_addr inside {64'h14 , 64'h1c , 64'h24 })(cfg_data == 32'h2);

                (cfg_addr==64'h10)->(cfg_data==0);
                (cfg_addr==64'h18)->(cfg_data==0);
                (cfg_addr==64'h20)->(cfg_data==0);
                (cfg_addr==64'h14)->(cfg_data==2);
                (cfg_addr==64'h1c)->(cfg_data==2);
                (cfg_addr==64'h24)->(cfg_data==2); 

         (cfg_addr == 10) -> {
            cfg_data inside {[0:200]};
                    }
        (cfg_addr == 18) -> {
            cfg_data inside {[201:400]};
                   }
     
                 //solve cfg_addr before cfg_data;                
  } */


  
  
  /* constraint data_c {
               solve cfg_addr before cfg_data;
            if (cfg_addr inside {64'h10 , 64'h18 , 64'h20 })(cfg_data == 0);
             else  if (cfg_addr inside {64'h14 , 64'h1c , 64'h24 })(cfg_data inside {2,3,1});


   }*/


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
          driveBadDataParityCycle inside {[0:8]};
          driveBadDataParityPct inside {[1:5]};
          } // endconstraint: driveBadDataParity







endclass
