import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_access_seq extends sla_ral_sequence_base;
  `ovm_sequence_utils(hqm_iosf_sb_access_seq,iosfsbc_sequencer);

  typedef struct {
    bit [7:0]   sai_6bit_to_8bit[$];
  } sai_queue_t;

 
  sla_ral_data_t 	rd_legal_sais[$];
  sla_ral_data_t 	wr_legal_sais[$];
  sai_queue_t           sai_queues[64];

  int                   ral_size;
  int                   hraissai = 0; //if nonzero, hqm_ral_attr_seq sai testing
  int                   hqm_sai_mtc = 1;  //if nonzero, sai matched (access is OK)
  int                   hqm_sai_rpr = 0;  //if nonzero, read policy_role inside RAC,WAC,CP
  int                   hqm_exp_mem_read_error = 0; //if nonzero, expect an error
  string                hqm_policy_role = ""; //policy role
  bit [15:0]            src_pid;
  bit [15:0]            dest_pid;

  static logic [2:0]            iosf_tag = 0;

  flit_t                        my_ext_headers[];

  iosfsbm_seq::iosf_sb_seq      sb_seq;

  function new(string n="hqm_iosf_sb_access_seq");
    super.new();
    $value$plusargs({"hraissai","=%d"}, this.hraissai); //hqm_ral_attr_seq sai testing enable/disable

    for (bit [8:0] sai8 = 0 ; sai8 < 9'h100 ; sai8++) begin
      if (sai8[0] == 1'b1) begin
        sai_queues[{3'b000,sai8[3:1]}].sai_6bit_to_8bit.push_back(sai8);
      end else if ((sai8[7:1] > 7'b0000111) && (sai8[7:1] < 7'b0111111)) begin
        sai_queues[sai8[6:1]].sai_6bit_to_8bit.push_back(sai8);
      end else begin
        sai_queues[6'b111111].sai_6bit_to_8bit.push_back(sai8);
      end
    end

    //print out queues
    for (int sai6q = 0 ; sai6q < 64 ; sai6q++)
     begin : saiq_list_lp
       if(sai_queues[sai6q].sai_6bit_to_8bit.size >0)
         begin : saiq_list_nz
           foreach(sai_queues[sai6q].sai_6bit_to_8bit[sai6to8])
            begin : saiq_list_inside_lp
              `ovm_info(get_type_name(),
                $psprintf("sai6q=0x%x,sai8=0x%x",
                           sai6q,    sai_queues[sai6q].sai_6bit_to_8bit[sai6to8]),
                           OVM_FULL);
            end : saiq_list_inside_lp
         end : saiq_list_nz
        else
          begin : saiq_list_z
              `ovm_info(get_type_name(),
                $psprintf("sai6q=0x%x zerosize",
                           sai6q),
                           OVM_FULL);
          end   : saiq_list_z
     end   : saiq_list_lp
  endfunction

  function bit [7:0] get_8bit_sai(sla_ral_sai_t sai6);
    return (sai_queues[sai6].sai_6bit_to_8bit[$urandom_range(sai_queues[sai6].sai_6bit_to_8bit.size()-1,0)]);
  endfunction

  task body;
    bit [63:0]                  addr;
    iosfsbm_cm::flit_t          iosf_addr[];
    iosfsbm_cm::flit_t          iosf_data[];
    bit [3:0]                   byte_en;
    bit [7:0]                   sai8;

    addr = target.get_addr_val(source);
    ral_size = target.get_size();
    sai8 = get_8bit_sai(sai);

    ral_status = SLA_OK;
    m_sequencer.get_config_int("strap_hqm_gpsb_srcid", src_pid);
    m_sequencer.get_config_int("hqm_gpsb_dstid", dest_pid);
    `ovm_info(get_full_name(),$sformatf("src_pid %0h, dest_pid %0h", src_pid, dest_pid),OVM_LOW)

    case (operation)
      "read": begin : op_is_read
        if(hraissai != 0)
          begin : hraissai_nz_rd
            hqm_policy_role = target.get_policy_role();

            if((hqm_policy_role.len() != 0) &&
               (ovm_is_match(hqm_policy_role,"RAC") ||
                ovm_is_match(hqm_policy_role,"WAC") ||
                ovm_is_match(hqm_policy_role,"CP")))
              begin : hqm_sai_is_rpr
                hqm_sai_rpr = 1;
                `ovm_info(get_type_name(),
                  $psprintf("hqm_sai_is_rpr rgn=%s role=%s hqm_sai_rpr=%0d",
                        target.get_name(),hqm_policy_role, hqm_sai_rpr),
                          OVM_LOW);
              end   : hqm_sai_is_rpr
             else
              begin : hqm_sai_not_rpr
                hqm_sai_rpr = 0;
              end   : hqm_sai_not_rpr
          
            target.get_legal_sai_values(RAL_READ,rd_legal_sais);
            hqm_sai_mtc = 0; // access legality not established yet
            for ( int idx_ls = 0; idx_ls < rd_legal_sais.size; idx_ls++ )
              begin : rd_legal_sais_lp
                `ovm_info(get_type_name(),
                  $psprintf("rgn=%s legal_sai=0x%x,sai8=0x%x,sai=0x%x",
                        target.get_name(),rd_legal_sais[idx_ls],sai8,sai),
                          OVM_FULL);
                 if(rd_legal_sais[idx_ls] == sai)
                   begin : rd_legal_sai_mtc
                     `ovm_info(get_type_name(),
                      $psprintf("rd_legal_sai_mtc rgn=%s legal_sai=0x%x,sai8=0x%x,sai=0x%x",
                             target.get_name(),rd_legal_sais[idx_ls],sai8,sai),
                             OVM_FULL);
                      hqm_sai_mtc = 1; //sai matches, legal acces!
                   end   : rd_legal_sai_mtc
               end : rd_legal_sais_lp
           end : hraissai_nz_rd
        case (target.get_space())
          "CFG": begin : rd_cfg_op
            iosf_addr       = new[2];
            iosf_addr[0]    = {addr[7:2],2'b00};
            iosf_addr[1]    = addr[15:8];

            if ((addr[1:0] != 0) || (target.get_size() != 32)) begin
              byte_en = 4'h0;
              for (int i = addr[1:0] ; i < (addr[1:0] + (target.get_size()/8)) ; i++) begin
                byte_en[i] = 1'b1;
              end
            end else begin
              byte_en = 4'hf;
            end

            my_ext_headers      = new[4];
            my_ext_headers[0]   = 8'h00;
            my_ext_headers[1]   = sai8;               // Set SAI
            my_ext_headers[2]   = 8'h00;
            my_ext_headers[3]   = 8'h00;

            `ovm_do_on_with(sb_seq, sla_sequencer::pick_sequencer("sideband"),
              { addr_i.size         == iosf_addr.size;
                foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
                eh_i                == 1'b1;
                ext_headers_i.size  == 4;
                foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
                xaction_class_i     == NON_POSTED;
                src_pid_i           == dest_pid[7:0];
                local_src_pid_i       == dest_pid[15:8];
                local_dest_pid_i      == src_pid[15:8];
                dest_pid_i          == target.get_space_addr("msg_bus_port");
                opcode_i            == OP_CFGRD;
                tag_i               == iosf_tag;
                fbe_i               == byte_en;
                sbe_i               == 4'h0;
                fid_i               == target.get_fid("CFG-SB");
                bar_i               == 3'b000;
                exp_rsp_i           == 1;
                compare_completion_i == 0;
              })

            iosf_tag++;

            if (sb_seq.rx_compl_xaction.rsp == 2'b00) begin
              ral_data[7:0]      = sb_seq.rx_compl_xaction.data[0];
              ral_data[15:8]     = sb_seq.rx_compl_xaction.data[1];
              ral_data[23:16]    = sb_seq.rx_compl_xaction.data[2];
              ral_data[31:24]    = sb_seq.rx_compl_xaction.data[3];

              ral_data = ral_data >> (addr[1:0] * 8);
              for (int i = target.get_size() ; i < $bits(ral_data) ; i++) ral_data[i] = 1'b0;

              ral_status = SLA_OK;
              if (ignore_access_error) begin
                ovm_report_error(get_full_name(), $psprintf("CfgRd0 Address=0x%x BE=0x%01x Data=0x%08x, expected error",addr,byte_en,ral_data), OVM_LOW);
              end
            end else begin
              ral_status = SLA_FAIL;
              if (~ignore_access_error) begin
                ovm_report_error(get_full_name(), $psprintf("CfgRd0 Address=0x%x BE=0x%01x Data=0x%08x, unexpected error",addr,byte_en,ral_data), OVM_LOW);
              end
            end
          end  : rd_cfg_op
          "MEM": begin : rd_mem_op
            iosf_addr          = new[6];
            iosf_addr[0]       = addr[7:0];
            iosf_addr[1]       = addr[15:8];
            iosf_addr[2]       = addr[23:16];
            iosf_addr[3]       = addr[31:24];
            iosf_addr[4]       = 8'h0;
            iosf_addr[5]       = 8'h0;

            my_ext_headers      = new[4];
            my_ext_headers[0]   = 8'h00;
            my_ext_headers[1]   = sai8;               // Set SAI
            my_ext_headers[2]   = 8'h00;
            my_ext_headers[3]   = 8'h00;

            `ovm_do_on_with(sb_seq, sla_sequencer::pick_sequencer("sideband"),
              { addr_i.size         == iosf_addr.size;
                foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
                eh_i                == 1'b1;
                ext_headers_i.size  == 4;
                foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
                xaction_class_i     == NON_POSTED;
                src_pid_i           == dest_pid[7:0];
                local_src_pid_i       == dest_pid[15:8];
                local_dest_pid_i      == src_pid[15:8];
                dest_pid_i          == target.get_space_addr("msg_bus_port");
                opcode_i            == OP_MRD;
                tag_i               == iosf_tag;
                fbe_i               == 4'hf;
                sbe_i               == 4'h0;
                fid_i               == target.get_fid("MEM-SB");
                bar_i               == target.get_bar("MEM-SB");
                exp_rsp_i           == 1;
                compare_completion_i == 0;
              })

            iosf_tag++;

            if (sb_seq.rx_compl_xaction.rsp == 2'b00) begin
              ral_data[7:0]      = sb_seq.rx_compl_xaction.data[0];
              ral_data[15:8]     = sb_seq.rx_compl_xaction.data[1];
              ral_data[23:16]    = sb_seq.rx_compl_xaction.data[2];
              ral_data[31:24]    = sb_seq.rx_compl_xaction.data[3];

              ral_status = (hqm_sai_mtc == 0 && hqm_sai_rpr != 1) ? SLA_SAI_FAIL : SLA_OK;

              if (ignore_access_error) begin
                ovm_report_error(get_full_name(), $psprintf("MRd64 Address=0x%x BE=0x%01x Data=0x%08x, expected error",addr,byte_en,ral_data), OVM_LOW);
              end
            end else begin
              ral_status = SLA_FAIL;
              if (~ignore_access_error) begin
                ovm_report_error(get_full_name(), $psprintf("MRd64 Address=0x%x BE=0x%01x Data=0x%08x, unexpected error",addr,byte_en,ral_data), OVM_LOW);
              end
            end
          end : rd_mem_op
          default: begin : rd_def_op
          end : rd_def_op
        endcase
      end : op_is_read ////////////////////////////////////////////
      "write": begin : op_is_write
        if(hraissai != 0)
          begin : hraissai_nz_wr
            target.get_legal_sai_values(RAL_WRITE,wr_legal_sais);
            hqm_sai_mtc = 0; // access legality not established yet
            for ( int idx_ls = 0; idx_ls < wr_legal_sais.size; idx_ls++ )
              begin : wr_legal_sais_lp
                `ovm_info(get_type_name(),
                  $psprintf("rgn=%s legal_sai=0x%x,sai8=0x%x,sai=0x%x",
                        target.get_name(),wr_legal_sais[idx_ls],sai8,sai),
                          OVM_FULL);
                 if(wr_legal_sais[idx_ls] == sai)
                   begin : wr_legal_sai_mtc
                     `ovm_info(get_type_name(),
                      $psprintf("wr_legal_sai_mtc rgn=%s legal_sai=0x%x,sai8=0x%x,sai=0x%x",
                             target.get_name(),wr_legal_sais[idx_ls],sai8,sai),
                             OVM_FULL);
                      hqm_sai_mtc = 1; //sai matches, legal acces!
                   end   : wr_legal_sai_mtc
               end : wr_legal_sais_lp
           end : hraissai_nz_wr

        case (target.get_space())
          "CFG": begin : wr_cfg_op
            logic hqm_is_reg_ep_arg=0;  $value$plusargs("hqm_is_reg_ep=%d",hqm_is_reg_ep_arg);

            iosf_addr           = new[2];
            iosf_addr[0]        = {addr[7:2],2'b00};
            iosf_addr[1]        = addr[15:8];

            ral_data = ral_data << (addr[1:0] * 8);

            iosf_data = new[4];

            iosf_data[0] = ral_data[7:0];
            iosf_data[1] = ral_data[15:8];
            iosf_data[2] = ral_data[23:16];
            iosf_data[3] = ral_data[31:24];

            if ((addr[1:0] != 0) || (target.get_size() != 32)) begin
              byte_en = 4'h0;
              for (int i = addr[1:0] ; i < (addr[1:0] + (target.get_size()/8)) ; i++) begin
                byte_en[i] = 1'b1;
              end
            end else begin
              byte_en = 4'hf;
            end

            my_ext_headers      = new[4];
            my_ext_headers[0]   = 8'h00;
            my_ext_headers[1]   = sai8;               // Set SAI
            my_ext_headers[2]   = 8'h00;
            my_ext_headers[3]   = 8'h00;

            `ovm_do_on_with(sb_seq, sla_sequencer::pick_sequencer("sideband"),
              { addr_i.size         == iosf_addr.size;
                foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
                eh_i                == 1'b1;
                ext_headers_i.size  == 4;
                foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
                data_i.size         == iosf_data.size;
                foreach (data_i[j]) data_i[j] == iosf_data[j];
                xaction_class_i     == NON_POSTED;
                src_pid_i           == dest_pid[7:0];
                local_src_pid_i       == dest_pid[15:8];
                local_dest_pid_i      == src_pid[15:8];
                dest_pid_i          == target.get_space_addr("msg_bus_port");
                opcode_i            == OP_CFGWR;
                tag_i               == iosf_tag;
                fbe_i               == byte_en;
                sbe_i               == 4'h0;
                fid_i               == target.get_fid("CFG-SB");
                bar_i               == 3'b000;
                exp_rsp_i           == 1;
                compare_completion_i == 0;
              })

            iosf_tag++;

            if (sb_seq.rx_compl_xaction.rsp == 2'b00) begin
              ral_status = (hqm_sai_mtc == 0) ? SLA_SAI_FAIL : SLA_OK;
              if (ignore_access_error) begin
                ovm_report_error(get_full_name(), $psprintf("CfgWr0 Address=0x%x BE=0x%01x Data=0x%08x, expected error",addr,byte_en,ral_data), OVM_LOW);
              end
            end else begin
              ral_status = SLA_FAIL;
              if (~ignore_access_error) begin
                ovm_report_error(get_full_name(), $psprintf("CfgWr0 Address=0x%x BE=0x%01x Data=0x%08x, unexpected error",addr,byte_en,ral_data), OVM_LOW);
              end
            end
          end : wr_cfg_op
          "MEM": begin : wr_mem_op
            iosf_addr          = new[6];
            iosf_addr[0]       = addr[7:0];
            iosf_addr[1]       = addr[15:8];
            iosf_addr[2]       = addr[23:16];
            iosf_addr[3]       = addr[31:24];
            iosf_addr[4]       = 8'h0;
            iosf_addr[5]       = 8'h0;

            iosf_data = new[4];
            iosf_data[0] = ral_data[7:0];
            iosf_data[1] = ral_data[15:8];
            iosf_data[2] = ral_data[23:16];
            iosf_data[3] = ral_data[31:24];

            my_ext_headers      = new[4];
            my_ext_headers[0]   = 8'h00;
            my_ext_headers[1]   = sai8;               // Set SAI
            my_ext_headers[2]   = 8'h00;
            my_ext_headers[3]   = 8'h00;

            `ovm_do_on_with(sb_seq, sla_sequencer::pick_sequencer("sideband"),
              { addr_i.size         == iosf_addr.size;
                foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
                eh_i                == 1'b1;
                ext_headers_i.size  == 4;
                foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
                data_i.size         == iosf_data.size;
                foreach (data_i[j]) data_i[j] == iosf_data[j];
                xaction_class_i     == POSTED;
                src_pid_i           == dest_pid[7:0];
                local_src_pid_i       == dest_pid[15:8];
                local_dest_pid_i      == src_pid[15:8];
                dest_pid_i          == target.get_space_addr("msg_bus_port");
                opcode_i            == OP_MWR;
                tag_i               == iosf_tag;
                fbe_i               == 4'hf;
                sbe_i               == 4'h0;
                fid_i               == target.get_fid("MEM-SB");
                bar_i               == target.get_bar("MEM-SB");
                exp_rsp_i           == 0;
                compare_completion_i == 0;
              })

            iosf_tag++;
            ral_status = (hqm_sai_mtc == 0) ?  SLA_SAI_FAIL : SLA_OK;
          end : wr_mem_op
          default: begin : wr_def_op
            ral_status = SLA_FAIL;
          end : wr_def_op
        endcase
      end : op_is_write //////////////////////////////
        default: begin : op_not_read_nor_write
          ral_status = SLA_FAIL;
        end : op_not_read_nor_write
    endcase //operation
  endtask : body

endclass : hqm_iosf_sb_access_seq
