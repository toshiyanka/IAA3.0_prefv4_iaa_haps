class cfg_file_seq extends ovm_sequence;
  `ovm_sequence_utils(cfg_file_seq,apb_master_sequencer)

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  apb_seq_lib_pkg::apb_read_seq  read_seq;
  apb_seq_lib_pkg::apb_write_seq write_seq;

  function new(string name = "cfg_file_seq");
    super.new(name); 
    timeoutval = 8000;

    $value$plusargs("CFG_FILE=%s",file_name);
    $value$plusargs("timeout=%d",timeoutval);
    
    if (file_name == "") begin
      `ovm_info("CFG_FILE_SEQ","+CFG_FILE=<file name> not set",OVM_LOW)
    end else begin
      `ovm_info("CFG_FILE_SEQ",$psprintf("+CFG_FILE=%s",file_name),OVM_LOW)
    end
   
    `ovm_info("CFG_FILE_SEQ",$psprintf("timeout is set to %0d",timeoutval),OVM_LOW)
   
  endfunction

  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  task pre_body();
    ovm_test_done.raise_objection(this);
  endtask
  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  task post_body();
    ovm_test_done.drop_objection(this);
  endtask

  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  virtual task body();
    integer     fd;
    integer     code;
    string      opcode;
    bit [31:0]  addr;
    bit [31:0]  wdata;
    bit [31:0]  rdata;
    integer     poll_cnt;

    poll_cnt = 0;
    
    if (file_name == "") begin
      `ovm_error("CFG_FILE_SEQ","file_name not set")
      return;
    end

    fd = $fopen(file_name,"r");

    if (fd == 0) begin
      `ovm_error("CFG_FILE_SEQ",$psprintf("Unable to open file %s",file_name))
      return;
    end

    `ovm_info("CFG_FILE_SEQ",$psprintf("Processing file %s",file_name),OVM_LOW)

    code = $fscanf(fd,"%s %x %x",opcode,addr,wdata);

    while (code >= 2) begin
      if (opcode == "rd") begin
        `ovm_do_with(read_seq, {apb_addr == addr;})
        rdata = read_seq.rsp.data;

        if (code == 2) begin
          `ovm_info("CFG_FILE_SEQ",$psprintf("Read: addr=0x%08x rdata=0x%08x",opcode,addr,rdata),OVM_LOW)
        end else begin
          if (rdata != wdata) begin
            `ovm_error("CFG_FILE_SEQ",$psprintf("Read: address 0x%0x read data (0x%08x) does not match write data (0x%08x)",addr,rdata,wdata))
          end else begin
            `ovm_info("CFG_FILE_SEQ",$psprintf("Read: address 0x%0x read data (0x%08x) matches expected value (0x%08x)",addr,rdata,wdata),OVM_LOW)
          end
        end
	
      end else if (opcode == "wr") begin
        `ovm_do_with(write_seq, {apb_addr == addr; apb_data == wdata;})
        `ovm_info("CFG_FILE_SEQ",$psprintf("Write: addr=0x%08x write data=0x%08x",addr,wdata),OVM_LOW)	
	
      end else if (opcode == "poll") begin
        `ovm_do_with(read_seq, {apb_addr == addr;})
        rdata = read_seq.rsp.data;

        if (code == 2) begin
          `ovm_info("CFG_FILE_SEQ",$psprintf("Read_poll: addr=0x%08x rdata=0x%08x",opcode,addr,rdata),OVM_LOW)
        end else begin
          while(rdata != wdata) begin	
            poll_cnt++;           
            if(poll_cnt < timeoutval) begin	    
              `ovm_info("CFG_FILE_SEQ",$psprintf("Read_poll: address 0x%0x read data (0x%08x) does not match write data (0x%08x), poll_cnt=%0d within timeoutval=%0d continue to poll",addr,rdata,wdata,poll_cnt,timeoutval),OVM_LOW)
	      `ovm_do_with(read_seq, {apb_addr == addr;})
              rdata = read_seq.rsp.data;
            end else begin
              `ovm_error("CFG_FILE_SEQ",$psprintf("Read_poll: address 0x%0x read data (0x%08x) does not match write data (0x%08x), poll_cnt=%0d reaches timeoutval=%0d stop polling",addr,rdata,wdata,poll_cnt,timeoutval))	    
              break;	    
            end	    	    
          end  
           `ovm_info("CFG_FILE_SEQ",$psprintf("Read_poll:: address 0x%0x read data (0x%08x) matches expected value (0x%08x)",addr,rdata,wdata),OVM_LOW)
           
        end	
	
      end else begin
        `ovm_error("CFG_FILE_SEQ",$psprintf("undefined opcode=%s addr=0x%08x wdata=0x%08x",opcode,addr,wdata))
      end

      code = $fscanf(fd,"%s %x %x",opcode,addr,wdata);
    end

  endtask : body
endclass : cfg_file_seq
