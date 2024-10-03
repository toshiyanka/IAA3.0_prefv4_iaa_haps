import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_forcewake_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_iosf_sb_forcewake_seq,sla_sequencer)

  static logic [2:0]            iosf_tag = 0;
  bit [15:0]               src_pid;
  bit [15:0]               dest_pid;

  flit_t                        my_ext_headers[];

  rand  bit inject_illegal_sai;

  logic [7:0]  strap_hqm_force_pwrgate_pok_sai_0;     // -- Legal SAI values for Sideband ResetPrep message
  logic [7:0]  strap_hqm_force_pwrgate_pok_sai_1;     // -- Legal SAI values for Sideband ResetPrep message
  logic [7:0]  hqm_force_pwrgate_pok_sai;             // -- Selected SAI value for Sideband ResetPrep message

  constraint inject_illegal_sai_c     { soft inject_illegal_sai == 1'b_0; }

  iosfsbm_seq::iosf_sb_seq      sb_seq;

  function new(string name = "hqm_iosf_sb_forcewake_seq");
    super.new(name); 
    //timeoutval = 4000;
  endfunction

  
  virtual task body();
    integer             fd;
    integer             code;
    string              opcode;
    bit [63:0]          addr;
    iosfsbm_cm::flit_t  iosf_addr[];
    iosfsbm_cm::flit_t  iosf_data[];
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
    string              msg;

     wdata = 32'hFFFF_FFFF;
     addr = 64'h0000000000004120;

     strap_hqm_force_pwrgate_pok_sai_0 = get_strap_val("HQM_STRAP_FORCE_POK_SAI_0", `HQM_STRAP_FORCE_POK_SAI_0);
 
     strap_hqm_force_pwrgate_pok_sai_1 = get_strap_val("HQM_STRAP_FORCE_POK_SAI_1", `HQM_STRAP_FORCE_POK_SAI_1);
    m_sequencer.get_config_int("strap_hqm_gpsb_srcid", src_pid);
    m_sequencer.get_config_int("hqm_gpsb_dstid", dest_pid);
    `ovm_info(get_full_name(),$sformatf("src_pid %0h, dest_pid %0h", src_pid, dest_pid),OVM_LOW)
 
     if(inject_illegal_sai) begin
         std::randomize(hqm_force_pwrgate_pok_sai) with { 
              hqm_force_pwrgate_pok_sai inside {['h_00:'h_ff]};  
              hqm_force_pwrgate_pok_sai != strap_hqm_force_pwrgate_pok_sai_0;  
              hqm_force_pwrgate_pok_sai != strap_hqm_force_pwrgate_pok_sai_1;  
         };
     end else begin
         std::randomize(hqm_force_pwrgate_pok_sai) with { hqm_force_pwrgate_pok_sai inside {strap_hqm_force_pwrgate_pok_sai_0,strap_hqm_force_pwrgate_pok_sai_1};  };
     end
 
     `ovm_info(get_full_name(), $psprintf("Setting force_pwrgate_pok SAI in msg as (0x%0x), with inject_illegal_sai(0x%0x), strap_hqm_force_pwrgate_pok_sai_0(0x%0x), strap_hqm_force_pwrgate_pok_sai_1(0x%0x)", hqm_force_pwrgate_pok_sai, inject_illegal_sai, strap_hqm_force_pwrgate_pok_sai_0, strap_hqm_force_pwrgate_pok_sai_1), OVM_LOW)
     
     my_ext_headers      = new[4];
     my_ext_headers[0]   = 8'h00;
     my_ext_headers[1]   = hqm_force_pwrgate_pok_sai;                // Set SAI
     my_ext_headers[2]   = 8'h00;
     my_ext_headers[3]   = 8'h00;

                 
        iosf_addr          = new[6];
        iosf_addr[0]       = addr[7:0];
        iosf_addr[1]       = addr[15:8];
        iosf_addr[2]       = addr[23:16];
        iosf_addr[3]       = addr[31:24];
        iosf_addr[4]       = addr[39:32];
        iosf_addr[5]       = addr[47:40];

        iosf_data = new[4];
        //iosf_data[0] = int_tokens_q[0][7:0];
        //iosf_data[1] = int_tokens_q[0][15:8];
        //iosf_data[2] = int_tokens_q[0][23:16];
        //iosf_data[3] = int_tokens_q[0][31:24];


         iosf_data[0] = wdata[7:0];
        iosf_data[1] = wdata[15:8];
        iosf_data[2] = wdata[23:16];
        iosf_data[3] = wdata[31:24];



        `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
          { 
            eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            data_i.size         == iosf_data.size;
            // -- foreach (data_i[j]) data_i[j] == iosf_data[j];
            xaction_class_i     == POSTED;
            src_pid_i           == dest_pid[7:0];
            dest_pid_i          == src_pid[7:0];
            local_src_pid_i       == dest_pid[15:8];
            local_dest_pid_i      == src_pid[15:8];
            opcode_i            == 8'h2E;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == 8'h07;
            bar_i               == 3'b010;
            exp_rsp_i           == 0;
            compare_completion_i == 0;
          })

          iosf_tag++;
 



  endtask : body

  function longint get_strap_val(string plusarg_name, longint default_val);
    string val_string = "";
    if(!$value$plusargs({$sformatf("%s",plusarg_name),"=%s"}, val_string)) begin
       get_strap_val = default_val; // -- Assign default value of strap, if no plusarg provided -- //
    end
    else if (lvm_common_pkg::token_to_longint(val_string,get_strap_val) == 0) begin
      `ovm_error(get_full_name(),$psprintf("+%s=%s not a valid integer value",plusarg_name,val_string))
      get_strap_val = default_val; // -- Assign default value of strap, if no plusarg provided -- //
    end

    // -- Finally print the resolved strap value -- //
    `ovm_info(get_full_name(), $psprintf("Resolved strap (%s) with value (0x%0x) ", plusarg_name, get_strap_val), OVM_LOW);

  endfunction

endclass : hqm_iosf_sb_forcewake_seq
