import lvm_common_pkg::*;


class back2back_cfgrd_fbe_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_cfgrd_fbe_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_iosf_fbe_cfgrd_seq        cfg_read_seq;
  hqm_iosf_fbe_cfgwr_seq        cfg_write_seq;
  hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_iosf_prim_mem_wr_seq        mem_write_seq;
  hqm_iosf_config_rd_seq        cfg_read_seq1;


  function new(string name = "back2back_cfgrd_fbe_seq");
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
                 if($test$plusargs("CFGRD"))begin

          // repeat(np_cnt+1)
                   for(int i = 0; i<15; i++)  
                       begin
                pkt.constraint_mode(0);
                //pkt.default_cfgwr.constraint_mode(1);
                pkt.default_data.constraint_mode(1); 
                    assert(pkt.randomize());
         `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'hAABBCCDD; iosf_fbe == 15;})

       `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == i;})
                         rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAABBCCDD)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                               end
                             end       

         /*     
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hFFFFFFFF)begin
             `ovm_error("Parity_error_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

                         if (i == 0) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                                                      end



                           if (i == 1) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h000000DD)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end


                         if (i == 2) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h0000CC00)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end


                        if (i == 3) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h0000CCDD)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end
   
                         
                      if (i == 4) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00BB0000)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end
                           
                   if (i == 5) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00BB00DD)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end
                
                    if (i == 6) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00BBCC00)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end

             
                       if (i == 7) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00BBCCDD)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end

                          if (i == 8) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAA000000)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end
          

                        if (i == 9) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAA0000DD)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end




                   if (i == 10) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAA00CC00)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end


                  if (i == 11) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAA00CCDD)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end




                 if (i == 12) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAABB0000)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end

                       
                   if (i == 13) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAABB00DD)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end


                      if (i == 14) begin
                               `ovm_do_on_with(cfg_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hAABBCC00)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                                   end




















                          end 

                        end */
    //----------------------------------------------------------------------------------------------------------------------------------------//

   /*  if($test$plusargs("CFGWR_ALL"))begin

          //------------------------------------ 0-----------------------------------------------//
                  
       `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == 0;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00000000)begin
             `ovm_error("Read Data_mismatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

         //--------------------------1-------------------------------------//
                         
       `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == 1;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h000000FF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})




         //--------------------------2---------------------------------------------------------------------------------------//
                 `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == 2;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h0000FF00)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})


       

         //--------------------------------------------------------3----------------------------------------------------------//
             `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == 3;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h0000FFFF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})


       

                       
      
      
      
      //-------------------------------------------------------------------4---------------------------------------------------//
     
        `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == 4;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00FF0000)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

//-----------------------------------------------------------------------------5-------------------------------------------------------------//
        `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == 5;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00FF00FF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

  
  
  //------------------------------------------------------------------6---------------------------------------------------------------------------------//
    
`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == 6;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00FFFF00)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

  
//---------------------------------------------------------------7-------------------------------------------------------------------------------------//
`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == 7;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00FFFFFF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

//------------------------------------------------------------------8-----------------------------------------------------------------------------------//

`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == 8;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hFF000000)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})


//------------------------------------------------------9-------------------------------------------------------------------------------------------------------//

`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == 9;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hFF0000FF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

//--------------------------------------------------------------10--------------------------------------------------------------------------------------------//
`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == 10;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hFF00FF00)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

//------------------------------------------------------------------------11----------------------------------------------------------------------------------//
`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == 11;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hFF00FFFF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})

//-----------------------------------------------------------------------12------------------------------------------------------------------------------------//

`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_fbe == 12;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hFFFF0000)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})


//------------------------------------------------------------------------13-----------------------------------------------------------------------------//

`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;  iosf_fbe == 13;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hFFFF00FF)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})


//----------------------------------------------------------------14-----------------------------------------------------------------------------------//

`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;  iosf_fbe == 14;})
         
                    //check whether FBE make update       
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130;})
                 rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'hFFFFFF00)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
          end

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70130; iosf_data == 32'h00000000; iosf_fbe == 15;})




//------------------------------------------------------------------------------------------------------------------------------------------------------//
end
*/

                     
                   

    
  endtask : body
endclass : back2back_cfgrd_fbe_seq
