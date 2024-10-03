 
import IosfPkg::*;


class sai_packet extends ovm_sequence_item;
  `ovm_object_utils(sai_packet) 

  
   rand bit [63:0] cfg_addr; 
   rand Iosf::data_t     cfg_data;
   rand bit [63:0] mem_addr; 
   rand Iosf::data_t     mem_data[];
   rand logic [7:0]     iosf_sai;
   rand bit [63:0] cfg_rdaddr;

  

function new (string name = "sai_packet");
  super.new(name);
endfunction:new  

 constraint default_cfgrd {
            soft cfg_rdaddr inside {64'h00000,64'h0002E,64'h00060,64'h00170,64'h00164,64'h00150};
            
  }

   constraint default_cfgwr {
             cfg_addr inside {64'h00010,64'h00014,64'h0003C};
                               }

      constraint default_data {
                      cfg_data inside {32'h00,32'h10,32'h20,32'h30};
                           }   

     constraint valid_sai {
                      iosf_sai inside {8'd01,8'd03,8'd07,8'd17,8'd18,8'd19,8'd23,8'd35,8'd39,8'd49,8'd51,8'd55,8'd65,8'd67,8'd71,8'd48,8'd81,8'd83,8'd84,8'd87,8'd97,8'd99,8'd122};
                          }
       
     constraint invalid_sai {
                      iosf_sai inside
                      {8'd0,8'd2,8'd5,8'd11,8'd12,8'd15,8'd16,8'd20,8'd21,8'd22,[8'd24:8'd32],8'd34,8'd30,8'd36,8'd38,[8'd40:8'd47],[8'd248:8'd254],[8'd216:8'd224],[8'd232:8'd240]};
                          }
                          
    constraint invalid_sai1 {
                      iosf_sai inside
                      //{8'd50,8'd52,8'd53,8'd54,[8'd56:8'd64],8'd66,[8'd68:8'd70],[8'd72:8'd80],8'd82,8'd85,8'd86,[8'd88:8'd96],8'd100,8'd102,[8'd104:8'd112],[8'd123:8'd128],[8'd152:8'd160],[8'd184:8'd192],[8'd196:8'd198],[8'd200:8'd208]};
                      {8'hab, 8'had, 8'h4d, 8'haf, 8'hfb, 8'h18, 8'h1a, 8'h1c, 8'h1e, 8'h20, 8'h1d};
                          }

constraint default_memrd64 {
             //mem_addr inside {[64'h200000000:$]};
             mem_addr inside {64'h200000100,64'h200000004,64'h200000008,64'h200000040,64'h200000044,64'h200000050,64'h200000000};

                              } 


 //from base address programming select base adress register 
   constraint default_memwr64 {
             // mem_addr inside {64'h202000100,64'h2A0000120,64'h202000D00,64'h202000040,64'h202000044,64'h202002D04,64'h20200ED04};
               mem_addr inside {64'h20800106C,64'h208001070}; 
                             }    



endclass
