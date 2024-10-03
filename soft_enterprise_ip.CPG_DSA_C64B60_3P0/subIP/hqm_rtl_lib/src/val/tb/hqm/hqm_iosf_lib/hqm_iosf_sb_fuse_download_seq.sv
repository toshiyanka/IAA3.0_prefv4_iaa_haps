import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_fuse_download_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_iosf_sb_fuse_download_seq,sla_sequencer)

  bit [31:0]                    hqm_fuse_values;
  longint                       lfuse_val;
  static logic [2:0]            iosf_tag = 0;
  flit_t                        my_ext_headers[];
  iosfsbm_cm::flit_t            compl_data[8];
  string                        fuse_string;
  bit [15:0]                    src_pid;
  bit [15:0]                    dest_pid;

  iosfsbm_seq::iosf_sb_seq      sb_seq;
  ovm_event_pool                global_pool;
  ovm_event                     hqm_fuse_download_req;

  function new(string name = "hqm_iosf_sb_fuse_download_seq");
    super.new(name); 
    fuse_string =  "0x00000000";
    global_pool  = ovm_event_pool::get_global_pool();
    hqm_fuse_download_req = global_pool.get("hqm_fuse_download_req");

    $value$plusargs("HQM_TB_FUSE_VALUES1=%s",fuse_string);
    
    if (lvm_common_pkg::token_to_longint(fuse_string,lfuse_val) == 0) begin
      `ovm_error("HQM_IOSF_SB_CB",$psprintf("+HQM_TB_FUSE_VALUES1=%s not a valid integer value",fuse_string))
      return;
    end
  endfunction
  
  virtual task body();
      bit strap_hqm_16b_portids; 
      longint   strap_gpsb_srcid;
      longint   strap_fp_cfg_dstid;

      my_ext_headers      = new[4];
      // Refer Chassis Fuse Architecture HAS 1.025.docx
      my_ext_headers[0]   = 8'h00; // Header Byte 4: 7 -EH=0; 6:0 - ExpandedHeaderID[6:0]
      my_ext_headers[1]   = get_strap_val("HQM_STRAP_FP_CFG_SAI_CMPL", `HQM_STRAP_FP_CFG_SAI_CMPL);//8'h24; // Header Byte 5: 7:0 - SAI[7:0] Legal SAI value for fusepull completion: Refer Refer HQM_v2_integrationGuide_0p3.docx
      my_ext_headers[2]   = 8'h00; // Header Byte 6: 7:0 - Reserved
      my_ext_headers[3]   = 8'h00; // Header Byte 7: 7:4 - Reserved; 3:0 - Rootspace[3:0]

      hqm_fuse_values = lfuse_val[31:0];

      compl_data[0]         = 8'h00; // Packet 0: Byte 0: RcvrAddrByte Address[7:0]
      compl_data[1]         = 8'h00; // Packet 0: Byte 1: 7:6 - Reserved; 5:0 - RcvrAddrByte Address[15:10]
      compl_data[2]         = 8'h3f; // Packet 0: Byte 2: 7:4 - Last DW BE; 3:0 - First DW BE
      compl_data[3]         = 8'h01; // Packet 0: Byte 3: 7:5 - Reserved; 4:0 - Stream size[4:0] in DW
      compl_data[4]         = hqm_fuse_values[7:0];   // Packet 0: Byte 4: Data[7:0]
      compl_data[5]         = hqm_fuse_values[15:8];  // Packet 0: Byte 5: Data[15:8]
      compl_data[6]         = hqm_fuse_values[23:16]; // Packet 0: Byte 6: Data[23:16]
      compl_data[7]         = hqm_fuse_values[31:24]; // Packet 0: Byte 7: Data[31:24]

      m_sequencer.get_config_int("strap_hqm_gpsb_srcid", src_pid);
      m_sequencer.get_config_int("strap_hqm_fp_cfg_dstid", dest_pid);
      strap_hqm_16b_portids = $value$plusargs("HQM_STRAP_16B_PORTIDS=%d", strap_hqm_16b_portids) ? strap_hqm_16b_portids : `HQM_STRAP_16B_PORTIDS;
      if (strap_hqm_16b_portids) begin 
          `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
            { 
              eh_i                == 1'b1;
              ext_headers_i.size  == 4;
              foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
              data_i.size         == compl_data.size();
              foreach (data_i[j]) data_i[j] == compl_data[j];
              xaction_class_i     == POSTED;
              dest_pid_i          == src_pid[7:0];
              src_pid_i           == dest_pid[7:0];
              local_dest_pid_i    == src_pid[15:8];
              local_src_pid_i     == dest_pid[15:8];
              opcode_i            == iosfsbm_cm::OP_CMPD;
              tag_i               == iosf_tag;
              rsp_i               == iosfsbm_cm::RSP_SUCCESSFUL;
              //fbe_i               == 4'hf;
              //sbe_i               == 4'hf;
              //fid_i               == 8'h07;
              //bar_i               == 3'b010;
              //exp_rsp_i           == 0;
              //compare_completion_i == 0;
            })
        end else begin 
          `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
            { 
              eh_i                == 1'b1;
              ext_headers_i.size  == 4;
              foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
              data_i.size         == compl_data.size();
              foreach (data_i[j]) data_i[j] == compl_data[j];
              xaction_class_i     == POSTED;
              dest_pid_i          == src_pid[7:0];
              src_pid_i           == dest_pid[7:0];
              opcode_i            == iosfsbm_cm::OP_CMPD;
              tag_i               == iosf_tag;
              rsp_i               == iosfsbm_cm::RSP_SUCCESSFUL;
              //fbe_i               == 4'hf;
              //sbe_i               == 4'hf;
              //fid_i               == 8'h07;
              //bar_i               == 3'b010;
              //exp_rsp_i           == 0;
              //compare_completion_i == 0;
            })
        end 


        `ovm_info(get_full_name(), $psprintf("Header fields for fuse pull completion message %s", sb_seq.req.sprint_header()), OVM_LOW);

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

endclass : hqm_iosf_sb_fuse_download_seq

