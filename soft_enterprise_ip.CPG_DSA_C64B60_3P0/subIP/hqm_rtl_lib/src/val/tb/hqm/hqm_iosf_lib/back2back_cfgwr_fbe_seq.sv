import lvm_common_pkg::*;


class back2back_cfgwr_fbe_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_cfgwr_fbe_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_iosf_fbe_cfgwr_seq        cfg_write_seq;
  hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "back2back_cfgwr_fbe_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available for HQM (np buffer size ) and given to no_cnt
         int  np_cnt ; 
      
        cfg_packet pkt ;
        pkt = cfg_packet::type_id::create("pkt");
          
               //max np_credit is set to 16 while no credit update 
        np_cnt = 16 ;
  
           
        //------------------------send more NP cfgwr than available credit -------------------------------//
                /* if($test$plusargs("CFGWR"))begin

          // repeat(np_cnt+1)
                   for(int i = 0, i=0; i<15; i++)  
                       begin
                pkt.constraint_mode(0);
                //pkt.default_cfgwr.constraint_mode(1);
                pkt.default_data.constraint_mode(1); 
                    assert(pkt.randomize());

       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == i;})
         
         `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
           //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'AABBCCFF)begin
             `ovm_error("Parity_error_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})


                          end 

                        end */
    //----------------------------------------------------------------------------------------------------------------------------------------//

     if($test$plusargs("CFGWR_ALL"))begin

          //------------------------------------ 0-----------------------------------------------//
                  
       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 0;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00000000)begin
             `ovm_error("Read Data_mismatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

         //--------------------------1-------------------------------------//
                         
       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 1;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h000000FF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})




         //--------------------------2---------------------------------------------------------------------------------------//
                 `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 2;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h0000CC00)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})


       

         //--------------------------------------------------------3----------------------------------------------------------//
             `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 3;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h0000CCFF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})


       

                       
      
      
      
      //-------------------------------------------------------------------4---------------------------------------------------//
     
        `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 4;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00BB0000)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

//-----------------------------------------------------------------------------5-------------------------------------------------------------//
        `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 5;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00BB00FF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

  
  
  //------------------------------------------------------------------6---------------------------------------------------------------------------------//
    
`ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 6;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00BBCC00)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

  
//---------------------------------------------------------------7-------------------------------------------------------------------------------------//
`ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 7;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00BBCCFF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

//------------------------------------------------------------------8-----------------------------------------------------------------------------------//

`ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 8;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAA000000)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})


//------------------------------------------------------9-------------------------------------------------------------------------------------------------------//

`ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 9;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAA0000FF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

//--------------------------------------------------------------10--------------------------------------------------------------------------------------------//
`ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 10;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAA00CC00)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

//------------------------------------------------------------------------11----------------------------------------------------------------------------------//
`ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 11;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAA00CCFF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

//-----------------------------------------------------------------------12------------------------------------------------------------------------------------//

`ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 12;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAABB0000)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})


//------------------------------------------------------------------------13-----------------------------------------------------------------------------//

`ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 13;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAABB00FF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})


//----------------------------------------------------------------14-----------------------------------------------------------------------------------//

`ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCFF; iosf_fbe == 14;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAABBCC00)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})




//------------------------------------------------------------------------------------------------------------------------------------------------------//
end


  //---------------------------------------------------------------------------------------------//                      
     
   if($test$plusargs("ZERO_CFGWR"))begin

           repeat(5)
                    
                       begin
                pkt.constraint_mode(0);
                pkt.default_cfgwr.constraint_mode(1);
                pkt.default_data.constraint_mode(1); 
                    assert(pkt.randomize());

       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr; iosf_data == pkt.cfg_data; iosf_fbe == 0;})
         
         `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
 
                          end 

                        end 
//------------------------------------------------------------------------------------------------------------------//
                                                
                   

    
  endtask : body
endclass : back2back_cfgwr_fbe_seq
