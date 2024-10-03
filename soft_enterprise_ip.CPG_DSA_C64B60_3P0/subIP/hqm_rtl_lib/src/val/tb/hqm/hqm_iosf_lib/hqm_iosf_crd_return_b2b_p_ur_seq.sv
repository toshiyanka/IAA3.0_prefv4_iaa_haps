`ifndef HQM_IOSF_CRD_RETURN_B2B_P_UR_SEQ_SEQUENCE_
`define HQM_IOSF_CRD_RETURN_B2B_P_UR_SEQ_SEQUENCE_

typedef enum int { MRdLk32 = 1,
                   LTMRd32 = 2,
                   NPMWr32 = 3,
                   LTMWr32 = 4,
                   MRdLk64 = 5,
                   LTMRd64 = 6,
                   NPMWr64 = 7,
                   LTMWr64 = 8,
                   Msg0    = 9,
                   Msg1    = 10,
                   Msg2    = 11,
                   Msg3    = 12,
                   Msg4    = 13,
                   Msg5    = 14,
                   Msg6    = 15,
                   Msg7    = 16,
                   MsgD0   = 17,
                   MsgD1   = 18,
                   MsgD2   = 19,
                   MsgD3   = 20,
                   MsgD4   = 21,
                   MsgD5   = 22,
                   MsgD6   = 23,
                   MsgD7   = 24
                 } ur_trans_type_t ;

`include "stim_config_macros.svh"

class hqm_iosf_crd_return_b2b_p_ur_seq_stim_config extends ovm_object;

  static string stim_cfg_name = "hqm_iosf_crd_return_b2b_p_ur_seq_stim_config";
 
  rand ur_trans_type_t cmd_type ;  

  `ovm_object_utils_begin(hqm_iosf_crd_return_b2b_p_ur_seq_stim_config)
    `ovm_field_enum(ur_trans_type_t        , cmd_type, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_iosf_crd_return_b2b_p_ur_seq_stim_config)
    `stimulus_config_field_rand_enum(ur_trans_type_t, cmd_type)
  `stimulus_config_object_utils_end

  function new(string name = "hqm_iosf_crd_return_b2b_p_ur_seq_stim_config");
    super.new(name); 
  endfunction

endclass : hqm_iosf_crd_return_b2b_p_ur_seq_stim_config


class hqm_iosf_crd_return_b2b_p_ur_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_crd_return_b2b_p_ur_seq,sla_sequencer)
  
  hqm_tb_sequences_pkg::hqm_iosf_unsupport_transaction_seq     unsupport_transaction_seq;

  ovm_event_pool        glbl_pool;
  ovm_event exp_ep_nfatal_msg_pf;
  Iosf::iosf_cmd_t  iosf_cmd_i;

  rand hqm_iosf_crd_return_b2b_p_ur_seq_stim_config cfg;
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_iosf_crd_return_b2b_p_ur_seq_stim_config);

  function new(string name = "hqm_iosf_crd_return_b2b_p_ur_seq");
    super.new(name);
    glbl_pool  = ovm_event_pool::get_global_pool();
    exp_ep_nfatal_msg_pf = glbl_pool.get("exp_ep_nfatal_msg_0");

    cfg = hqm_iosf_crd_return_b2b_p_ur_seq_stim_config::type_id::create("hqm_iosf_crd_return_b2b_p_ur_seq_stim_config"); 
    apply_stim_config_overrides(0);  // 0 means apply overrides for non-rand variables before seq.randomize() is called
  endfunction

  virtual task body();
      sla_ral_addr_t addr;
      sla_ral_data_t rd_data;
      string file_name, reg_name;
      bit [31:0]     data;
      bit [31:0]     exp_reg_val;
      int rand_addr_sel;

    `ovm_info(get_full_name(), $sformatf("hqm_iosf_crd_return_b2b_p_ur_seq started"),OVM_LOW)

    apply_stim_config_overrides(1); // (1) below means apply overrides for random variables after seq.randomize() is called

    if ($test$plusargs("PF_FUNC_BAR_LESS_4G")) begin
        WriteReg("hqm_pf_cfg_i","func_bar_u",32'h_0000_0000);
        WriteReg("hqm_pf_cfg_i","func_bar_l",32'h_0000_0000);
        WriteReg("hqm_pf_cfg_i","csr_bar_u",32'h_0000_0002);
        WriteReg("hqm_pf_cfg_i","csr_bar_l",32'h_0000_0000);
    end
    if ( !(std::randomize(rand_addr_sel) with { rand_addr_sel dist { 0 := 1, 1 := 1 }; } ) )  begin
              `ovm_fatal(get_full_name(), $psprintf("Randomization failed"))
    end
    rand_addr_sel = ((cfg.cmd_type == MRdLk32) || (cfg.cmd_type == LTMRd32) || (cfg.cmd_type == NPMWr32) || (cfg.cmd_type ==  LTMWr32)) ? 0 : rand_addr_sel; 
    file_name = (rand_addr_sel == 0) ? "hqm_msix_mem" : "config_master";
    reg_name =  (rand_addr_sel == 0) ? "msg_data[0]"  : "cfg_ts_control";

    addr[63:0] = get_reg_addr(file_name,reg_name,"primary");
    ReadReg(file_name,reg_name,SLA_FALSE,rd_data);
    exp_reg_val = rd_data[31:0];
    data = ~rd_data;

    ovm_report_info(get_full_name(), $psprintf("Unsupport:  Address=0x%x, Data=0x%08x, cfg.cmd_type = %0s, exp_reg_val=%0x, rand_addr_sel=%0d, file_name=%0s, reg_name=%0s", addr, data, cfg.cmd_type.name(), exp_reg_val, rand_addr_sel, file_name, reg_name), OVM_LOW);

    case (cfg.cmd_type)
        MRdLk32:    `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==addr; iosf_cmd32==Iosf::MRdLk32; })
        LTMRd32:    `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==addr; iosf_cmd32==Iosf::LTMRd32; })
        NPMWr32:    `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==addr; iosf_data==data; iosf_cmd32==Iosf::NPMWr32; })
        MRdLk64:    `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==addr; iosf_cmd64==Iosf::MRdLk64; })
        LTMRd64:    `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==addr; iosf_cmd64==Iosf::LTMRd64; })
        NPMWr64:    `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==addr; iosf_data==data; iosf_cmd64==Iosf::NPMWr64; })
        LTMWr32: begin 
                   exp_ep_nfatal_msg_pf.trigger();
                   for (int i=0; i < 9; i++) begin 
                     `ovm_do_on_with(unsupport_transaction_seq,  p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==addr; iosf_data==data; iosf_cmd32==Iosf::LTMWr32;})
                   end  
                 end
        LTMWr64: begin 
                   exp_ep_nfatal_msg_pf.trigger(); 
                   for (int i=0; i < 9; i++) begin 
                     `ovm_do_on_with(unsupport_transaction_seq,  p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==addr; iosf_data==data; iosf_cmd64==Iosf::LTMWr64;}) end
                   end  
        // Vendor defined message, type1: Message Code [7:0] = {lbe, fbe} 
        Msg0,Msg1,Msg2,Msg3,Msg4,Msg5,Msg6,Msg7:
        begin 
            case (cfg.cmd_type)
                Msg0: iosf_cmd_i = Iosf::Msg0;
                Msg1: iosf_cmd_i = Iosf::Msg1;
                Msg2: iosf_cmd_i = Iosf::Msg2;
                Msg3: iosf_cmd_i = Iosf::Msg3;
                Msg4: iosf_cmd_i = Iosf::Msg4;
                Msg5: iosf_cmd_i = Iosf::Msg5;
                Msg6: iosf_cmd_i = Iosf::Msg6;
                Msg7: iosf_cmd_i = Iosf::Msg7;
            endcase
            exp_ep_nfatal_msg_pf.trigger(); 
            for (int i=0; i < 9; i++) begin 
               `ovm_do_on_with(unsupport_transaction_seq,  p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==addr; length_i==0; lbe_i==4'h7; fbe_i==4'hE; iosf_cmd64==iosf_cmd_i;}) 
            end
        end
        MsgD0,MsgD1,MsgD2,MsgD3,MsgD4,MsgD5,MsgD6,MsgD7:
        begin 
            case (cfg.cmd_type)
                MsgD0: iosf_cmd_i = Iosf::MsgD0;
                MsgD1: iosf_cmd_i = Iosf::MsgD1;
                MsgD2: iosf_cmd_i = Iosf::MsgD2;
                MsgD3: iosf_cmd_i = Iosf::MsgD3;
                MsgD4: iosf_cmd_i = Iosf::MsgD4;
                MsgD5: iosf_cmd_i = Iosf::MsgD5;
                MsgD6: iosf_cmd_i = Iosf::MsgD6;
                MsgD7: iosf_cmd_i = Iosf::MsgD7;
            endcase
            exp_ep_nfatal_msg_pf.trigger(); 
            for (int i=0; i < 9; i++) begin 
               `ovm_do_on_with(unsupport_transaction_seq,  p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr==addr; length_i==1; lbe_i==4'h7; fbe_i==4'hE; iosf_cmd64==iosf_cmd_i;}) 
            end
        end
        default:    `ovm_error(get_name(),"Invalid transaction type!!")
    endcase
    ReadReg(file_name,reg_name,SLA_FALSE,rd_data);
    if (rd_data[31:0] != exp_reg_val) begin 
        `ovm_error(get_full_name(), $sformatf("register value %0s.%0s got updated by the ur transaction %0s rd_data %0xh exp_reg_val %0xh", file_name, reg_name, cfg.cmd_type.name(), rd_data, exp_reg_val))
    end 
    `ovm_info(get_full_name(), $sformatf("hqm_iosf_crd_return_b2b_p_ur_seq ended"),OVM_LOW)

  endtask

endclass

`endif
