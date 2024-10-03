import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;
//include "hqm_iosf_sb_seq.svh" //uncomment;add "`" prefix for setidvalue opcode testing

class hqm_iosf_sb_file_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_iosf_sb_file_seq,sla_sequencer)

  string                        file_name = "";
  integer                       fd;
  integer                       timeoutval;
  static logic [2:0]            iosf_tag = 0;
  bit [15:0]                    src_pid;
  bit [15:0]                    dest_pid;

  flit_t                        my_ext_headers[];
  pid_t                         my_dest_pid;
  pid_t                         my_src_pid;

  iosfsbm_seq::iosf_sb_seq      sb_seq; //comment out for setidvalue opcode testing
//hqm_iosf_sb_seq      		sb_seq; //uncomment for setidvalue opcode testing

  function new(string name = "hqm_iosf_sb_file_seq");
    super.new(name); 
    timeoutval = 4000;

    $value$plusargs("IOSF_SB_FILE=%s",file_name);
    $value$plusargs("timeout=%d",timeoutval);
    
    if (file_name == "") begin
      `ovm_info("IOSF_SB_FILE_SEQ","+IOSF_SB_FILE=<file name> not set",OVM_LOW)
    end else begin
      `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("+IOSF_SB_FILE=%s",file_name),OVM_LOW)
    end
   
    `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("timeout is set to %0d",timeoutval),OVM_LOW)
   
    my_ext_headers      = new[4];
    my_ext_headers[0]   = 8'h00;
    my_ext_headers[1]   = 8'h03;                // Set SAI
    my_ext_headers[2]   = 8'h12;
    my_ext_headers[3]   = 8'h00;

  endfunction : new

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
  endfunction : get_int_tokens

  virtual task body();
    integer             fd;
    integer             code;
    string              opcode;
    bit [63:0]          addr;
    iosfsbm_cm::flit_t  iosf_addr[];
    iosfsbm_cm::flit_t  iosf_data[];
    bit [31:0]          wdata;
    bit [31:0]          wdata2;
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
    string              msg;

    poll_cnt = 0;
    
    if (file_name == "") begin
      `ovm_error("IOSF_SB_FILE_SEQ","file_name not set")
      return;
    end

    fd = $fopen(file_name,"r");

    if (fd == 0) begin
      `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("Unable to open file %s",file_name))
      return;
    end

    `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("Processing file %s",file_name),OVM_LOW)

    code = $fgets(input_line,fd);

    while (code > 0) begin : get_code_lp
      line = input_line;

      opcode = lvm_common_pkg::parse_token(line);
      opcode = opcode.tolower();
      maskdata = '1;
      poll_cnt = 0;
      polldelay = 0;

      if (opcode == "idle") begin : if_opc_eq_idle //////////////////////////
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("Idle %d ns",1),OVM_LOW)
          #1ns;
        end else begin
          `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("Idle %d ns",int_tokens_q[0]),OVM_LOW)
          repeat (int_tokens_q[0][31:0]) #1ns;
        end
      end : if_opc_eq_idle
      else if ((opcode == "cfgrd0") || (opcode == "cfgrd0e")) begin : if_opc_eq_cfgrd0 //////////////////////////
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_SB_FILE_SEQ",
            $psprintf("CfgRd0 command without an address argument"))
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

        m_sequencer.get_config_int("strap_hqm_gpsb_srcid", src_pid);
        m_sequencer.get_config_int("hqm_gpsb_dstid", dest_pid);
        `ovm_info(get_full_name(),$sformatf("src_pid %0h, dest_pid %0h", src_pid, dest_pid),OVM_LOW)
        iosf_addr       = new[2];
        iosf_addr[0]    = addr[7:0];
        iosf_addr[1]    = addr[15:8];

        `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address=0x%0x ",opcode,addr),OVM_LOW)
        `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
          { addr_i.size         == iosf_addr.size;
            foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
            eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            xaction_class_i     == NON_POSTED;
            src_pid_i           == dest_pid[7:0];
            dest_pid_i          == src_pid[7:0];
            local_src_pid_i       == dest_pid[15:8];
            local_dest_pid_i      == src_pid[15:8];
            opcode_i            == OP_CFGRD;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == addr[23:16];
            bar_i               == 3'b000;
            exp_rsp_i           == 1;
            compare_completion_i == 0;
          })

        iosf_tag++;

        if (sb_seq.rx_compl_xaction.rsp == 2'b00) begin
          rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
          rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
          rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
          rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];

          if (opcode == "cfgrd0e") begin
            ovm_report_error(get_full_name(), $psprintf("CfgRd0 Address=0x%x Data=0x%08x, expected error",addr,rdata), OVM_LOW);
          end

          if (do_compare) begin
            if ((rdata & maskdata) != cmpdata) begin
              `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask 0x%0x read data (0x%08x) does not match expected data (0x%08x)",opcode,addr,maskdata,rdata,cmpdata))
            end else begin
              `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask 0x%0x read data (0x%08x) matches expected value (0x%08x)",opcode,addr,maskdata,rdata,cmpdata),OVM_LOW)
            end
          end else begin
            `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: addr=0x%08x rdata=0x%08x",opcode,addr,rdata),OVM_LOW)
          end
        end else begin
            if (opcode == "cfgrd0e") begin
              `ovm_info(get_full_name(), $psprintf("CfgRd0 Address=0x%x received expected error",addr), OVM_LOW)
            end else begin
              `ovm_error(get_full_name(), $psprintf("CfgRd0 Address=0x%x received unexpected error",addr))
            end
        end
	
      end : if_opc_eq_cfgrd0
      else if ((opcode == "cfgwr0") || (opcode == "cfgwr0e")) begin : if_opc_eq_cfgwr0 //////////////////////////
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("CfgWr0 command without an address argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin
          addr = int_tokens_q[0];

          if (int_tokens_q.size() < 2) begin
            `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("CfgWr0 command without a write data argument"))
            code = $fgets(input_line,fd);
            continue;
          end

          wdata = int_tokens_q[1];
        end

        iosf_addr       = new[2];
        iosf_addr[0]    = addr[7:0];
        iosf_addr[1]    = addr[15:8];

        iosf_data = new[4];

        iosf_data[0] = wdata[7:0];
        iosf_data[1] = wdata[15:8];
        iosf_data[2] = wdata[23:16];
        iosf_data[3] = wdata[31:24];

        `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address=0x%0x wdata=0x%0x",opcode,addr,wdata),OVM_LOW)
        `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
          { addr_i.size         == iosf_addr.size;
            foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
            eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            data_i.size         == iosf_data.size;
            foreach (data_i[j]) data_i[j] == iosf_data[j];
            xaction_class_i     == NON_POSTED;
            src_pid_i           == dest_pid[7:0];
            dest_pid_i          == src_pid[7:0];
            local_src_pid_i       == dest_pid[15:8];
            local_dest_pid_i      == src_pid[15:8];
            opcode_i            == OP_CFGWR;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == addr[23:16];
            bar_i               == 3'b000;
            exp_rsp_i           == 1;
            compare_completion_i == 0;
          })

        if (sb_seq.rx_compl_xaction.rsp == 2'b00) begin
          if (opcode == "cfgwr0e") begin
            `ovm_error(get_full_name(), $psprintf("CfgWr0 Address=0x%x Data=0x%08x, expected error",addr,wdata))
          end else begin
            `ovm_info(get_full_name(),$psprintf("%s: addr=0x%08x write data=0x%08x",opcode,addr,wdata),OVM_LOW)	
          end
        end else begin
          if (opcode !== "cfgwr0e") begin
            `ovm_error(get_full_name(), $psprintf("CfgWr0 Address=0x%x Data=0x%08x, received unexpected error",addr,wdata))
          end else begin
            `ovm_info(get_full_name(),$psprintf("%s: addr=0x%08x write data=0x%08x, received expected error",opcode,addr,wdata),OVM_LOW)	
          end
        end

        iosf_tag++;
	
      end : if_opc_eq_cfgwr0
      else if (opcode == "cfgpoll") begin : if_opc_eq_cfgpoll //////////////////////////
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("CfgPoll command without an address argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin
          addr = int_tokens_q[0];

          if (int_tokens_q.size() < 2) begin
            `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("CfgPoll command without a compare data argument"))
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

        iosf_addr       = new[2];
        iosf_addr[0]    = addr[7:0];
        iosf_addr[1]    = addr[15:8];

        `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address=0x%0x",opcode,addr),OVM_LOW)
        `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
          { addr_i.size         == iosf_addr.size;
            foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
            eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            xaction_class_i     == NON_POSTED;
            src_pid_i           == dest_pid[7:0];
            dest_pid_i          == src_pid[7:0];
            local_src_pid_i       == dest_pid[15:8];
            local_dest_pid_i      == src_pid[15:8];
            opcode_i            == OP_CFGRD;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == addr[23:16];
            bar_i               == 3'b000;
            exp_rsp_i           == 1;
            compare_completion_i == 0;
          })

          iosf_tag++;

        rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
        rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
        rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
        rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];

        while((rdata & maskdata) != cmpdata) begin	
          poll_cnt++;           
          if(poll_cnt < timeoutval) begin	    
            `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) does not match write data (0x%08x), poll_cnt=%0d within timeoutval=%0d continue to poll",opcode,addr,maskdata,rdata,cmpdata,poll_cnt,timeoutval),OVM_LOW)
            repeat (polldelay) #1ns;
            `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
              { addr_i.size         == iosf_addr.size;
                foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
                eh_i                == 1'b1;
                ext_headers_i.size  == 4;
                foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
                xaction_class_i     == NON_POSTED;
                src_pid_i           == dest_pid[7:0];
                dest_pid_i          == src_pid[7:0];
                local_src_pid_i       == dest_pid[15:8];
                local_dest_pid_i      == src_pid[15:8];
                opcode_i            == OP_CFGRD;
                tag_i               == iosf_tag;
                fbe_i               == 4'hf;
                sbe_i               == 4'h0;
                fid_i               == addr[23:16];
                bar_i               == 3'b000;
                exp_rsp_i           == 1;
                compare_completion_i == 0;
              })

            iosf_tag++;

            rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
            rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
            rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
            rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
          end else begin
            break;	    
          end	    	    
        end  

        if ((rdata & maskdata) != cmpdata) begin	
          `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) does not match write data (0x%08x), poll_cnt=%0d reaches timeoutval=%0d stop polling",opcode,addr,maskdata,rdata,cmpdata,poll_cnt,timeoutval))	    
        end else begin
          `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) matches expected value (0x%08x)",opcode,maskdata,addr,rdata,cmpdata),OVM_LOW)
        end
      end : if_opc_eq_cfgpoll
      else if (opcode == "mrd64") begin : if_opc_eq_mrd64 //////////////////////////
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("MRd64 command without an address argument"))
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

        if (addr >= 64'h10000) begin
          iosf_addr          = new[6];
          iosf_addr[0]       = addr[7:0];
          iosf_addr[1]       = addr[15:8];
          iosf_addr[2]       = addr[23:16];
          iosf_addr[3]       = addr[31:24];
          iosf_addr[4]       = addr[39:32];
          iosf_addr[5]       = addr[47:40];
        end else begin
          iosf_addr       = new[2];
          iosf_addr[0]    = addr[7:0];
          iosf_addr[1]    = addr[15:8];
        end

        `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address=0x%0x",opcode,addr),OVM_LOW)
        `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
          { addr_i.size         == iosf_addr.size;
            foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
            eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            xaction_class_i     == NON_POSTED;
            src_pid_i           == dest_pid[7:0];
            dest_pid_i          == src_pid[7:0];
            local_src_pid_i       == dest_pid[15:8];
            local_dest_pid_i      == src_pid[15:8];
            opcode_i            == OP_MRD;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == addr[23:16];
            bar_i               == 3'b000;
            exp_rsp_i           == 1;
            compare_completion_i == 0;
          })

        iosf_tag++;

        rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
        rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
        rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
        rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];

        if (do_compare) begin
          if ((rdata & maskdata) != cmpdata) begin
            `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) does not match write data (0x%08x)",opcode,maskdata,addr,rdata,cmpdata))
          end else begin
            `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) matches expected value (0x%08x)",opcode,maskdata,addr,rdata,cmpdata),OVM_LOW)
          end
        end else begin
          `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: addr=0x%08x rdata=0x%08x",opcode,addr,rdata),OVM_LOW)
        end
	
      end : if_opc_eq_mrd64
      else if (opcode == "mwr64") begin : if_opc_eq_mwr64 //////////////////////////
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("CfgRd0 command without an address argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin
          addr = int_tokens_q.pop_front();
        end

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("MWr64 command no legal write data argument (%s)",input_line))
          code = $fgets(input_line,fd);
          continue;
        end

        if (addr >= 64'h10000) begin
          iosf_addr          = new[6];
          iosf_addr[0]       = addr[7:0];
          iosf_addr[1]       = addr[15:8];
          iosf_addr[2]       = addr[23:16];
          iosf_addr[3]       = addr[31:24];
          iosf_addr[4]       = addr[39:32];
          iosf_addr[5]       = addr[47:40];
        end else begin
          iosf_addr       = new[2];
          iosf_addr[0]    = addr[7:0];
          iosf_addr[1]    = addr[15:8];
        end

        iosf_data = new[4];
        iosf_data[0] = int_tokens_q[0][7:0];
        iosf_data[1] = int_tokens_q[0][15:8];
        iosf_data[2] = int_tokens_q[0][23:16];
        iosf_data[3] = int_tokens_q[0][31:24];

        `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address=0x%0x",opcode,addr),OVM_LOW)
        `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
          { addr_i.size         == iosf_addr.size;
            foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
            eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            data_i.size         == iosf_data.size;
            foreach (data_i[j]) data_i[j] == iosf_data[j];
            xaction_class_i     == POSTED;
            src_pid_i           == dest_pid[7:0];
            dest_pid_i          == src_pid[7:0];
            local_src_pid_i       == dest_pid[15:8];
            local_dest_pid_i      == src_pid[15:8];
            opcode_i            == OP_MWR;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == 8'h00;
            bar_i               == 3'b000;
            exp_rsp_i           == 0;
            compare_completion_i == 0;
          })

          iosf_tag++;

        msg = $psprintf("%s: addr=0x%08x write data=",opcode,addr);
        foreach (int_tokens_q[i]) begin
          if (i == 0) begin
            msg = {msg,$psprintf("0x%08x",int_tokens_q[i])};
          end else begin
            msg = {msg,$psprintf("_%08x",int_tokens_q[i])};
          end
        end

        `ovm_info("IOSF_SB_FILE_SEQ",msg,OVM_LOW)	
	
      end : if_opc_eq_mwr64
      else if (opcode == "mpoll64") begin : if_opc_eq_mpoll64 //////////////////////////
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("MPoll64 command without an address argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin
          addr = int_tokens_q[0];

          if (int_tokens_q.size() < 2) begin
            `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("MPoll64 command without a compare data argument"))
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

        if (addr >= 64'h10000) begin
          iosf_addr          = new[6];
          iosf_addr[0]       = addr[7:0];
          iosf_addr[1]       = addr[15:8];
          iosf_addr[2]       = addr[23:16];
          iosf_addr[3]       = addr[31:24];
          iosf_addr[4]       = addr[39:32];
          iosf_addr[5]       = addr[47:40];
        end else begin
          iosf_addr       = new[2];
          iosf_addr[0]    = addr[7:0];
          iosf_addr[1]    = addr[15:8];
        end

        `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address=0x%0x",opcode,addr),OVM_LOW)
        `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
          { addr_i.size         == iosf_addr.size;
            foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
            eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            xaction_class_i     == NON_POSTED;
            src_pid_i           == dest_pid[7:0];
            dest_pid_i          == src_pid[7:0];
            local_src_pid_i       == dest_pid[15:8];
            local_dest_pid_i      == src_pid[15:8];
            opcode_i            == OP_MRD;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == 8'h00;
            bar_i               == 3'b000;
            exp_rsp_i           == 1;
            compare_completion_i == 0;
          })

        iosf_tag++;

        rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
        rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
        rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
        rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];

        while((rdata & maskdata) != cmpdata) begin	
          poll_cnt++;           
          if(poll_cnt < timeoutval) begin	    
            `ovm_info("IOSF_SB_FILE_SEQ",
             $psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) does not match write data (0x%08x), poll_cnt=%0d within timeoutval=%0d continue to poll",
             opcode,addr,maskdata,rdata,cmpdata,poll_cnt,timeoutval),OVM_LOW)

            repeat (polldelay) #1ns;

            if (addr >= 64'h10000) begin
              iosf_addr          = new[6];
              iosf_addr[0]       = addr[7:0];
              iosf_addr[1]       = addr[15:8];
              iosf_addr[2]       = addr[23:16];
              iosf_addr[3]       = addr[31:24];
              iosf_addr[4]       = addr[39:32];
              iosf_addr[5]       = addr[47:40];
            end else begin
              iosf_addr       = new[2];
              iosf_addr[0]    = addr[7:0];
              iosf_addr[1]    = addr[15:8];
            end

            `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address=0x%0x",opcode,addr),OVM_LOW)
            `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
              { addr_i.size         == iosf_addr.size;
                foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
                eh_i                == 1'b1;
                ext_headers_i.size  == 4;
                foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
                xaction_class_i     == NON_POSTED;
                src_pid_i           == dest_pid[7:0];
                dest_pid_i          == src_pid[7:0];
                local_src_pid_i       == dest_pid[15:8];
                local_dest_pid_i      == src_pid[15:8];
                opcode_i            == OP_MRD;
                tag_i               == iosf_tag;
                fbe_i               == 4'hf;
                sbe_i               == 4'h0;
                fid_i               == 8'h00;
                bar_i               == 3'b000;
                exp_rsp_i           == 1;
                compare_completion_i == 0;
              })

            iosf_tag++;

            rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
            rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
            rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
            rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
          end else begin
            break;	    
          end	    	    
        end  

        if ((rdata & maskdata) != cmpdata) begin	
          `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) does not match write data (0x%08x), poll_cnt=%0d reaches timeoutval=%0d stop polling",opcode,addr,maskdata,rdata,cmpdata,poll_cnt,timeoutval))	    
        end else begin
          `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) matches expected value (0x%08x)",opcode,maskdata,addr,rdata,cmpdata),OVM_LOW)
        end
      end : if_opc_eq_mpoll64

      else if (opcode == "setidvalue") begin : if_opc_eq_setidvalue //////////////////////////
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("SetIDValue command without data argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin

          if (int_tokens_q.size() < 2) begin
            `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("SetIDValue command without both data arguments"))
            code = $fgets(input_line,fd);
            continue;
          end

          wdata  = int_tokens_q[0];
          wdata2 = int_tokens_q[1];
        end

        iosf_data = new[8];

        iosf_data[0] = wdata[7:0];
        iosf_data[1] = wdata[15:8];
        iosf_data[2] = wdata[23:16];
        iosf_data[3] = wdata[31:24];

        iosf_data[4] = wdata2[7:0];
        iosf_data[5] = wdata2[15:8];
        iosf_data[6] = wdata2[23:16];
        iosf_data[7] = wdata2[31:24];

        my_src_pid  = dest_pid[7:0];
        my_dest_pid = src_pid[7:0];
        `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address=0x%0x",opcode,addr),OVM_LOW)
        `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
          { eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            data_i.size         == iosf_data.size;
            foreach (data_i[j]) data_i[j] == iosf_data[j];
            xaction_class_i     == NON_POSTED;
            local_src_pid_i       == dest_pid[15:8];
            local_dest_pid_i      == src_pid[15:8];
            src_pid_i           == my_src_pid;
            dest_pid_i          == my_dest_pid;
          //opcode_i            == OP_SETIDVALUE; //uncomment for setidvalue opcode testing
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == 8'h00;
            bar_i               == 3'b000;
            exp_rsp_i           == 1;
            compare_completion_i == 0;
          })

        `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: data1=0x%08x data2=0x%08x",opcode,wdata,wdata2),OVM_LOW)	

        iosf_tag++;
	
      end : if_opc_eq_setidvalue
      else if (opcode == "sai") begin : if_opc_eq_sai //////////////////////////
        get_int_tokens(line,int_tokens_q);

        if (int_tokens_q.size() == 0) begin
          `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("SAI command without data argument"))
          code = $fgets(input_line,fd);
          continue;
        end else begin
          `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: Setting SAI to 0x%02x",opcode,int_tokens_q[0][7:0]),OVM_LOW);
          my_ext_headers[1]   = int_tokens_q[0][7:0];
        end
      end : if_opc_eq_sai
      else begin : opc_unknown
        if (opcode != "") begin : if_opc_undefined //////////////////////////
          `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("undefined opcode=%s",opcode))
        end : if_opc_undefined
      end : opc_unknown

      code = $fgets(input_line,fd);
    end : get_code_lp

  endtask : body
endclass : hqm_iosf_sb_file_seq
