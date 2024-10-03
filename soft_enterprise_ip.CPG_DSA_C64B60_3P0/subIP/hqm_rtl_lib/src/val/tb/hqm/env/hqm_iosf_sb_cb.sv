class hqm_iosf_sb_cb extends iosfsbm_cm::opcode_cb;
  `ovm_component_utils(hqm_iosf_sb_cb)

  bit           ip_ready_received;
  bit [31:0]    hqm_fuse_values;
  int           randomize_fuses;
  int           fuse_ld_dn_once = 0;
  longint       lfuse_val, diff_lfuse_val;
  int           fuse_data_var;
  int           fuse_data_size;
  ovm_event_pool  global_pool;
  ovm_event       hqm_fuse_download_req;

  function new(string name, ovm_component parent);
    string      fuse_string, diff_fuse_string;

    super.new(name, parent);

    ip_ready_received = 1'b0;
/*
40 bit Fuse data: Refer HQM_v2_integrationGuide_0p3.docx and $<database root>/target/hqm_fusegen_lib/nebulon/output/fuse/hqm_top_classes.svh: desired_val for each fuse for expect value

rcv addr  8 bit fuse data
16'h0000  00000000 -- 00
16'h0001  00000000 -- 00 -- revision ID
*/
    fuse_string =  "0x00000000";
    diff_fuse_string =  fuse_string;

    global_pool  = ovm_event_pool::get_global_pool();
    hqm_fuse_download_req = global_pool.get("hqm_fuse_download_req");

    if (!$value$plusargs("HQM_TB_FUSE_DATA_VAR=%d",fuse_data_var)) fuse_data_var=0;
    if (!$value$plusargs("HQM_TB_FUSE_DATA_SIZE=%d", fuse_data_size)) fuse_data_size=1; // in DWs

    $value$plusargs("HQM_TB_FUSE_VALUES=%s",fuse_string);
    if(!$value$plusargs("HQM_TB_FUSE_VALUES_DIFF=%s",diff_fuse_string)) begin 
        diff_fuse_string =  fuse_string;
    end     
    $value$plusargs("RANDOMIZE_FUSE_VALUES=%s",randomize_fuses);

    if (lvm_common_pkg::token_to_longint(fuse_string,lfuse_val) == 0) begin
      `ovm_error("HQM_IOSF_SB_CB",$psprintf("+HQM_TB_FUSE_VALUES=%s not a valid integer value",fuse_string))
      return;
    end

    if (lvm_common_pkg::token_to_longint(diff_fuse_string,diff_lfuse_val) == 0) begin
      `ovm_error("HQM_IOSF_SB_CB",$psprintf("+HQM_TB_FUSE_VALUES_DIFF=%s not a valid integer value",diff_fuse_string))
      return;
    end

  endfunction :new
  
  function iosfsbm_cm::comp_xaction execute_cb(string name, iosfsbm_cm::ep_cfg m_ep_cfg, iosfsbm_cm::common_cfg m_common_cfg, bit[1:0] rsp_field, iosfsbm_cm::xaction rx_xaction);
    // Locals
    string msg;
    bit strap_hqm_16b_portids; 
    iosfsbm_cm::comp_xaction    tx_xaction;
    iosfsbm_cm::flit_t          my_ext_headers[];
    iosfsbm_cm::flit_t          compl_data[8];
    iosfsbm_cm::flit_t          err_compl_data[];
    iosfsbm_cm::flit_t          err_compl_data2[];

    err_compl_data = new[4*fuse_data_size];
    // Handle completions
    if ( rx_xaction.xaction_class == iosfsbm_cm::NON_POSTED) begin
      if(!( $cast(tx_xaction, ovm_factory::create_object("iosfsbm_cm::comp_xaction", "comp_xaction"))))
        ovm_report_fatal("CASTING","Type mismatch");
    
      my_ext_headers      = new[4];
      // Refer Chassis Fuse Architecture HAS 1.025.docx
      my_ext_headers[0]   = 8'h00; // Header Byte 4: 7 -EH=0; 6:0 - ExpandedHeaderID[6:0]
      my_ext_headers[1]   = 8'h24; // Header Byte 5: 7:0 - SAI[7:0] Legal SAI value for fusepull completion: Refer Refer HQM_v2_integrationGuide_0p3.docx
      my_ext_headers[2]   = 8'h00; // Header Byte 6: 7:0 - Reserved
      my_ext_headers[3]   = 8'h00; // Header Byte 7: 7:4 - Reserved; 3:0 - Rootspace[3:0]

      tx_xaction.set_cfg(m_ep_cfg, m_common_cfg);
    
      case (rx_xaction.opcode)
        'h45: begin

          if (!fuse_ld_dn_once) begin  
             hqm_fuse_values = lfuse_val[31:0];
             fuse_ld_dn_once = ~fuse_ld_dn_once;
          end
          else begin 
             hqm_fuse_values = diff_lfuse_val[31:0];
             fuse_ld_dn_once = ~fuse_ld_dn_once;
          end

          if (randomize_fuses==1) begin
             hqm_fuse_values = $urandom();
             //set proc_disable=0 to keep HQM active
             hqm_fuse_values[0] = 1'b0;
          end

          compl_data[0]         = 8'h00; // Packet 0: Byte 0: RcvrAddrByte Address[7:0]
          compl_data[1]         = 8'h00; // Packet 0: Byte 1: 7:6 - Reserved; 5:0 - RcvrAddrByte Address[15:10]
          compl_data[2]         = 8'h3f; // Packet 0: Byte 2: 7:4 - Last DW BE; 3:0 - First DW BE
          compl_data[3]         = 8'h01; // Packet 0: Byte 3: 7:5 - Reserved; 4:0 - Stream size[4:0] in DW

          compl_data[4]         = hqm_fuse_values[7:0];   // Packet 0: Byte 4: Data[7:0]
          compl_data[5]         = hqm_fuse_values[15:8];  // Packet 0: Byte 5: Data[15:8]
          compl_data[6]         = hqm_fuse_values[23:16]; // Packet 0: Byte 6: Data[23:16]
          compl_data[7]         = hqm_fuse_values[31:24]; // Packet 0: Byte 7: Data[31:24]

          //for (int i = 5 ; i < 8 ; i++) begin
          //  compl_data[i+4] = 0;
         // end

          `ovm_info(get_full_name(), $psprintf("FUSE_DEBUG:fuse_data_var=%d ", fuse_data_var), OVM_LOW);
          strap_hqm_16b_portids = $value$plusargs("HQM_STRAP_16B_PORTIDS=%d", strap_hqm_16b_portids) ? strap_hqm_16b_portids : `HQM_STRAP_16B_PORTIDS;
          `ovm_info(get_full_name(), $psprintf("strap_hqm_16b_portids=%0d ", strap_hqm_16b_portids), OVM_LOW);
          if (strap_hqm_16b_portids) begin 
             if (!tx_xaction.randomize() with { opcode == ((fuse_data_var==1)?iosfsbm_cm::OP_CMP:iosfsbm_cm::OP_CMPD);
                                             dest_pid == rx_xaction.src_pid;
                                             src_pid == rx_xaction.dest_pid;
                                             local_dest_pid == rx_xaction.local_src_pid;
                                             local_src_pid  == rx_xaction.local_dest_pid;
                                             tag == rx_xaction.tag;
                                             rsp == iosfsbm_cm::RSP_SUCCESSFUL; EH == 1;
                                             data_size_dw == ((fuse_data_var==1)?0:3);
                                             ext_headers_per_txn.size  == 4;
                                             foreach (ext_headers_per_txn[j]) ext_headers_per_txn[j] == my_ext_headers[j];
                                           } ) ovm_report_fatal("RND", "Randomization error");
          end else begin                                  
              if (!tx_xaction.randomize() with { opcode == ((fuse_data_var==1)?iosfsbm_cm::OP_CMP:iosfsbm_cm::OP_CMPD);
                                             dest_pid == rx_xaction.src_pid;
                                             src_pid == rx_xaction.dest_pid;
                                             tag == rx_xaction.tag;
                                             rsp == iosfsbm_cm::RSP_SUCCESSFUL; EH == 1;
                                             data_size_dw == ((fuse_data_var==1)?0:3);
                                             ext_headers_per_txn.size  == 4;
                                             foreach (ext_headers_per_txn[j]) ext_headers_per_txn[j] == my_ext_headers[j];
                                           } ) ovm_report_fatal("RND", "Randomization error");
          end 
          case (fuse_data_var)
              //Usual Data
              'h0: begin
                  tx_xaction.data = compl_data;
              end
              //No Data
              'h1: begin
                 tx_xaction.data = err_compl_data2; 
              end 
              //Excess Data
              'h2: begin 
                       for (int i = 0; i<=7; i++) begin
                           err_compl_data[i] = compl_data[i];
                       end 
                       err_compl_data[ 8] = 8'haa; 
                       err_compl_data[10] = 8'h55; 
                       tx_xaction.data = err_compl_data; 
                   end
              //Not enough Data
              'h3: begin 
                       for (int i = 0; i<=3; i++) begin
                           err_compl_data[i] = compl_data[i];
                       end 
                       tx_xaction.data = err_compl_data; 
                   end
              default: begin
                  tx_xaction.data = compl_data;
              end
          endcase
          `ovm_info(get_full_name(), $psprintf("Header fields for fuse pull completion message %s", tx_xaction.sprint_header()), OVM_LOW);
          `ovm_info(get_full_name(), $psprintf("Header fields for fuse pull req message %s", rx_xaction.sprint_header()), OVM_LOW);
            
          hqm_fuse_download_req.trigger();
          `ovm_info(get_full_name(),"Triggered Fuse download Request event (hqm_ifuse_download)!!",OVM_LOW)
          return tx_xaction;
        end
        'hd0: begin
          ip_ready_received = 1'b1;

          return null;
        end
      endcase
    end
  endfunction :execute_cb
endclass

