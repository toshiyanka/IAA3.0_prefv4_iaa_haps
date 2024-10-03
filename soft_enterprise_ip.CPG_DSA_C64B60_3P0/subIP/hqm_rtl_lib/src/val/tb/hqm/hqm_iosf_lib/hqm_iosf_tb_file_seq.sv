import lvm_common_pkg::*;

class hqm_iosf_tb_file_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_iosf_tb_file_seq,sla_sequencer)

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_msg_wr_seq        msg_write_seq;

  function new(string name = "hqm_iosf_tb_file_seq");
    super.new(name); 
    timeoutval = 4000;

    $value$plusargs("IOSF_PRIM_FILE=%s",file_name);
    $value$plusargs("timeout=%d",timeoutval);
    
    if (file_name == "") begin
      `ovm_info("IOSF_PRIM_FILE_SEQ","+IOSF_PRIM_FILE=<file name> not set",OVM_LOW)
    end else begin
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("+IOSF_PRIM_FILE=%s",file_name),OVM_LOW)
    end
   
    `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("timeout is set to %0d",timeoutval),OVM_LOW)
   
  endfunction

  virtual function void get_int_tokens(ref string line,output bit [63:0] int_tokens_q[$],input int max_ints = -1);
    bit [63:0]  int_val;
    string      token;

    token = lvm_common_pkg::parse_token(line);

    int_tokens_q.delete();

    while (token != "") begin
      if (lvm_common_pkg::token_to_longint(token,int_val) == 0) begin
        line = {token," ",line};
        break;
      end

      int_tokens_q.push_back(int_val);

      if ((max_ints >= 0) && (int_tokens_q.size() == max_ints)) begin
        break;
      end

      token = lvm_common_pkg::parse_token(line);
    end
  endfunction

  virtual task body();
    integer             fd;
    integer             code;
    string              opcode;
    bit [63:0]          addr;
    bit [31:0]          wdata;
    bit [31:0]          rdata;
    bit [31:0]          cmpdata;
    bit [31:0]          maskdata;
    bit                 do_compare;
    int                 polldelay;
    integer             poll_cnt;
    string              input_line;
    string              line;
    string              token;
    bit [63:0]          int_tokens_q[$];
    logic               exp_error;
    string              msg;

    poll_cnt = 0;
    
    if (file_name == "") begin
      `ovm_error("IOSF_PRIM_FILE_SEQ","file_name not set")
      return;
    end

    fd = $fopen(file_name,"r");

    if (fd == 0) begin
      `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("Unable to open file %s",file_name))
      return;
    end

    `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("Processing file %s",file_name),OVM_LOW)

    code = $fgets(input_line,fd);

    while (code > 0) begin
      line = input_line;

      opcode = lvm_common_pkg::parse_token(line);
      opcode = opcode.tolower();
      maskdata = '1;
      poll_cnt = 0;
      polldelay = 0;

      if (opcode == "idle") begin
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("Idle %d ns",1),OVM_LOW)
          #1ns;
        end else begin
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("Idle %d ns",int_tokens_q[0]),OVM_LOW)
          repeat (int_tokens_q[0][31:0]) #1ns;
        end
      end else if ((opcode == "cfgrd0") || (opcode == "cfgrd0e")) begin
        if (opcode == "cfgrd0e") begin
          exp_error = 1'b1;
        end else begin
          exp_error = 1'b0;
        end

        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("CfgRd0 command without an address argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin
          addr = int_tokens_q[0];

          if (int_tokens_q.size() > 1) begin
            cmpdata = int_tokens_q[1];
            do_compare = 1;
          end else begin
            do_compare = 0;
          end

          if (int_tokens_q.size() > 2) begin
            maskdata = int_tokens_q[2];
          end
        end

        `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr;iosf_exp_error == exp_error;})
        rdata = cfg_read_seq.iosf_data;

        if (do_compare) begin
          if ((rdata & maskdata) != cmpdata) begin
            `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("%s: address 0x%0x mask 0x%0x read data (0x%08x) does not match expected data (0x%08x)",opcode,addr,maskdata,rdata,cmpdata))
          end else begin
            `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("%s: address 0x%0x mask 0x%0x read data (0x%08x) matches expected value (0x%08x)",opcode,addr,maskdata,rdata,cmpdata),OVM_LOW)
          end
        end else begin
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("%s: addr=0x%08x rdata=0x%08x",opcode,addr,rdata),OVM_LOW)
        end
	
      end else if ((opcode == "cfgwr0") || (opcode == "cfgwr0e")) begin
        if (opcode == "cfgwr0e") begin
          exp_error = 1'b1;
        end else begin
          exp_error = 1'b0;
        end

        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("CfgWr0 command without an address argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin
          addr = int_tokens_q[0];

          if (int_tokens_q.size() < 2) begin
            `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("CfgWr0 command without a write data argument"))
            code = $fgets(input_line,fd);
            continue;
          end

          wdata = int_tokens_q[1];
        end

        `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr; iosf_data == wdata;iosf_exp_error == exp_error;})
        `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("%s: addr=0x%08x write data=0x%08x",opcode,addr,wdata),OVM_LOW)	
	
      end else if (opcode == "cfgpoll") begin
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("CfgPoll command without an address argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin
          addr = int_tokens_q[0];

          if (int_tokens_q.size() < 2) begin
            `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("CfgPoll command without a compare data argument"))
            code = $fgets(input_line,fd);
            continue;
          end

          cmpdata = int_tokens_q[1];

          if (int_tokens_q.size() > 2) begin
            maskdata = int_tokens_q[2];
          end

          if (int_tokens_q.size() > 3) begin
            polldelay = int_tokens_q[3];
          end
        end

        `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr;})
        rdata = cfg_read_seq.iosf_data;

        while((rdata & maskdata) != cmpdata) begin	
          poll_cnt++;           
          if(poll_cnt < timeoutval) begin	    
            `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) does not match write data (0x%08x), poll_cnt=%0d within timeoutval=%0d continue to poll",opcode,addr,maskdata,rdata,cmpdata,poll_cnt,timeoutval),OVM_LOW)
            repeat (polldelay) #1ns;
            `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr;})
            rdata = cfg_read_seq.iosf_data;
          end else begin
            break;	    
          end	    	    
        end  

        if ((rdata & maskdata) != cmpdata) begin	
          `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) does not match write data (0x%08x), poll_cnt=%0d reaches timeoutval=%0d stop polling",opcode,addr,maskdata,rdata,cmpdata,poll_cnt,timeoutval))	    
        end else begin
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) matches expected value (0x%08x)",opcode,maskdata,addr,rdata,cmpdata),OVM_LOW)
        end
      end else if (opcode == "mrd64") begin
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("MRd64 command without an address argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin
          addr = int_tokens_q[0];

          if (int_tokens_q.size() > 1) begin
            cmpdata = int_tokens_q[1];
            do_compare = 1;
          end else begin
            do_compare = 0;
          end

          if (int_tokens_q.size() > 2) begin
            maskdata = int_tokens_q[2];
          end
        end

        token = lvm_common_pkg::parse_token(line);

        `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr;})
        rdata = mem_read_seq.iosf_data;

        if (do_compare) begin
          if ((rdata & maskdata) != cmpdata) begin
            `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) does not match write data (0x%08x)",opcode,maskdata,addr,rdata,cmpdata))
          end else begin
            `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) matches expected value (0x%08x)",opcode,maskdata,addr,rdata,cmpdata),OVM_LOW)
          end
        end else begin
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("%s: addr=0x%08x rdata=0x%08x",opcode,addr,rdata),OVM_LOW)
        end
	
      end else if (opcode == "mrd64e") begin
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("MRd64 command without an address argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin
          addr = int_tokens_q[0];
        end

        token = lvm_common_pkg::parse_token(line);

        `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr; iosf_exp_error == 1'b1;})
        rdata = mem_read_seq.iosf_data;

        `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("%s: addr=0x%08x rdata=0x%08x",opcode,addr,rdata),OVM_LOW)
	
      end else if (opcode == "mwr64") begin
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("CfgRd0 command without an address argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin
          addr = int_tokens_q.pop_front();
        end

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("MWr64 command no legal write data argument (%s)",input_line))
          code = $fgets(input_line,fd);
          continue;
        end

        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
        start_item(mem_write_seq);
        if (!mem_write_seq.randomize() with  {iosf_addr == addr; iosf_data.size() == int_tokens_q.size();}) begin
          `ovm_warning("hqm_iosf_tb_file_seq", "Randomization failed for mem_write_seq");
        end
        foreach (int_tokens_q[i]) begin
          mem_write_seq.iosf_data[i] = int_tokens_q[i];
        end
        finish_item(mem_write_seq);

        msg = $psprintf("%s: addr=0x%08x write data=",opcode,addr);
        foreach (int_tokens_q[i]) begin
          if (i == 0) begin
            msg = {msg,$psprintf("0x%08x",int_tokens_q[i])};
          end else begin
            msg = {msg,$psprintf("_%08x",int_tokens_q[i])};
          end
        end

        `ovm_info("IOSF_PRIM_FILE_SEQ",msg,OVM_LOW)	
	
      end else if (opcode == "msg4") begin
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("MSG4 command without an address argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin
          addr = int_tokens_q.pop_front();
        end

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("MSG4 command no legal write data argument (%s)",input_line))
          code = $fgets(input_line,fd);
          continue;
        end

        `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
        start_item(msg_write_seq);
        if (!msg_write_seq.randomize() with  {iosf_addr == addr; iosf_data.size() == int_tokens_q.size();}) begin
          `ovm_warning("hqm_iosf_tb_file_seq", "Randomization failed for msg_write_seq");
        end
        foreach (int_tokens_q[i]) begin
          msg_write_seq.iosf_data[i] = int_tokens_q[i];
        end
        finish_item(msg_write_seq);

        msg = $psprintf("%s: addr=0x%08x write data=",opcode,addr);
        foreach (int_tokens_q[i]) begin
          if (i == 0) begin
            msg = {msg,$psprintf("0x%08x",int_tokens_q[i])};
          end else begin
            msg = {msg,$psprintf("_%08x",int_tokens_q[i])};
          end
        end

        `ovm_info("IOSF_PRIM_FILE_SEQ",msg,OVM_LOW)	
	
      end else if (opcode == "mpoll64") begin
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("MPoll64 command without an address argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin
          addr = int_tokens_q[0];

          if (int_tokens_q.size() < 2) begin
            `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("MPoll64 command without a compare data argument"))
            code = $fgets(input_line,fd);
            continue;
          end

          cmpdata = int_tokens_q[1];

          if (int_tokens_q.size() > 2) begin
            maskdata = int_tokens_q[2];
          end

          if (int_tokens_q.size() > 3) begin
            polldelay = int_tokens_q[3];
          end
        end

        `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr;})
        rdata = mem_read_seq.iosf_data;

        while((rdata & maskdata) != cmpdata) begin	
          poll_cnt++;           
          if(poll_cnt < timeoutval) begin	    
            `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) does not match write data (0x%08x), poll_cnt=%0d within timeoutval=%0d continue to poll",opcode,addr,maskdata,rdata,cmpdata,poll_cnt,timeoutval),OVM_LOW)

            repeat (polldelay) #1ns;
            `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr;})
            rdata = mem_read_seq.iosf_data;
          end else begin
            break;	    
          end	    	    
        end  

        if ((rdata & maskdata) != cmpdata) begin	
          `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) does not match write data (0x%08x), poll_cnt=%0d reaches timeoutval=%0d stop polling",opcode,addr,maskdata,rdata,cmpdata,poll_cnt,timeoutval))	    
        end else begin
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) matches expected value (0x%08x)",opcode,maskdata,addr,rdata,cmpdata),OVM_LOW)
        end
      end else begin
        if (opcode != "") begin
          `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf("undefined opcode=%s",opcode))
        end
      end

      code = $fgets(input_line,fd);
    end

  endtask : body
endclass : hqm_iosf_tb_file_seq
