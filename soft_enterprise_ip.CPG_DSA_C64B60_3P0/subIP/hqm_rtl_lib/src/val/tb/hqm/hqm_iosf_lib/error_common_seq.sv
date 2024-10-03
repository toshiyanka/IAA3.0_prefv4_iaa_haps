import lvm_common_pkg::*;


class error_common_seq extends ovm_sequence;
  `ovm_sequence_utils(error_common_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  
  function new(string name = "error_common_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       
              //check device status 
            `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h04;})
                rdata = cfg_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)

        if($test$plusargs("DATA_PARITY_CHECK"))begin

          if (rdata[31] == 1'b0)begin
             `ovm_error("Parity_error_received",$psprintf("status 0x04  read data expected PArity error to be set (bit 31) (0x%08x) ",rdata))
          end
             end

           if($test$plusargs("POISON_CHECK"))begin

          if (rdata[31] == 1'b0)begin
             `ovm_error("Poison_txn_received",$psprintf("status 0x04  read data expected poison error to be set (bit 31) (0x%08x) ",rdata))
          end
             end
   

          /* if (rdata[31] == 1'b1)begin
             `ovm_error("Parity_error_received",$psprintf("status 0x04  Detected PArity error (bit 31) (0x%08x) ",rdata))
          end */
  
  //------------------------------------------------------------------------------------------------------------------------------------//
         
 //pcie_cap_device_status  check       
          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h76;})
                rdata = cfg_read_seq.iosf_data;

           


         //check error status aer uncorr_status
        
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h14C;})
                rdata = cfg_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)

            if($test$plusargs("POISON_CHECK"))begin

          if (rdata[12] == 1'b0)begin
             `ovm_error("POISON_TLP_received",$psprintf("status 0x14c posion TLP not set fo Poison transaction  read data (0x%08x) ",rdata))

          end
          
           end

           if($test$plusargs("DATA_PARITY_CHECK"))begin

          if (rdata[12] == 1'b0)begin
             `ovm_error("DATA_PARITY_ERROR_received",$psprintf("status 0x14c DATA_PARITY_ERROR  not set fo data_parity_injection error transaction  read data (0x%08x) ",rdata))

          end
           end

         
          if (rdata[14] == 1'b1)begin
             `ovm_error("COMPLETION_TIMEOUT_received",$psprintf(" status 0x14c  read data (0x%08x) ",rdata))

          end

          if (rdata[15] == 1'b1)begin
             `ovm_error("COMPLETION_ABORT_received",$psprintf(" status 0x14c read data (0x%08x) ",rdata))

          end

         if (rdata[16] == 1'b1)begin
             `ovm_error("UNEXPECTED_received",$psprintf("status 0x14c  read data (0x%08x) ",rdata))

          end

          if (rdata[18] == 1'b1)begin
             `ovm_error("MALFUNCTION_TLP_received",$psprintf(" ERROR status 0x14c read data (0x%08x) ",rdata))

          end

              if (rdata[19] == 1'b1)begin
             `ovm_error("ECRC_FAIL_received",$psprintf("ERROR status 0x14c read data (0x%08x) ",rdata))

          end
          //if($test$plusargs("MEM_ERROR_CHECK"))begin
          //else begin 
          if (rdata[20] == 1'b1)begin
             `ovm_error("UNSUPPORTED_REQUEST_received",$psprintf("ERROR status 0x14c read data (0x%08x) ",rdata))

          end
                                  
         
    
  endtask : body
endclass : error_common_seq
