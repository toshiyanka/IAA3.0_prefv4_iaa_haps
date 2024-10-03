`ifndef HQM_SLA_PCIE_UNSUPPORTED_REQ_SEQUENCE_
`define HQM_SLA_PCIE_UNSUPPORTED_REQ_SEQUENCE_

typedef enum int { IOWr    = 1, 
                   IORd    = 2,
                   MRdLk32 = 3,
                   LTMRd32 = 4,
                   NPMWr32 = 5,
                   LTMWr32 = 6,
                   FAdd32  = 7,
                   Swap32  = 8,
                   CAS32   = 9,
                   MRdLk64 = 10,
                   LTMRd64 = 11,
                   NPMWr64 = 12,
                   LTMWr64 = 13,
                   FAdd64  = 14,
                   Swap64  = 15,
                   CAS64   = 16,
                   CfgRd1  = 17,
                   CfgWr1  = 18,
                   Msg0    = 19,
                   Msg1    = 20,
                   Msg2    = 21,
                   Msg3    = 22,
                   Msg4    = 23,
                   Msg5    = 24,
                   Msg6    = 25,
                   Msg7    = 26,
                   MsgD0   = 27,
                   MsgD1   = 28,
                   MsgD2   = 29,
                   MsgD3   = 30,
                   MsgD4   = 31,
                   MsgD5   = 32,
                   MsgD6   = 33,
                   MsgD7   = 34,
                   np_p_mem= 35,
                   p_np_mem= 36,
                   Cpl     = 37,
                   CplD    = 38,
                   CplLk   = 39,
                   CplDLk  = 40,
                   UR_Poision = 41,
                   EC_Poision = 42,
                   Rsvd_fmt_type = 43

                 } trans_type_t ;

typedef enum int {  
                    pci_sig_vid = 0
                   ,intel_vid   = 1
                   ,random_vid  = 2

                 } vendor_id_t ;



`include "stim_config_macros.svh"

class hqm_sla_pcie_unsupported_req_stim_config extends ovm_object;

  static string stim_cfg_name = "hqm_sla_pcie_unsupported_req_stim_config";
 
  rand trans_type_t cmd_type ;  
  rand int       len;
  rand bit [7:0] msg_code;
  rand bit [2:0] cpl_status;
  rand vendor_id_t vendor_id;

  `ovm_object_utils_begin(hqm_sla_pcie_unsupported_req_stim_config)
    `ovm_field_enum(trans_type_t        , cmd_type, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(len                            , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(msg_code                       , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cpl_status                     , OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_enum(vendor_id_t        , vendor_id, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_sla_pcie_unsupported_req_stim_config)
    `stimulus_config_field_rand_enum(trans_type_t, cmd_type)
    `stimulus_config_field_rand_int (len                   )
    `stimulus_config_field_rand_int (msg_code              )
    `stimulus_config_field_rand_int (cpl_status            )
    `stimulus_config_field_rand_enum(vendor_id_t, vendor_id)
  `stimulus_config_object_utils_end
 
  //constraint  trans_type_t    { soft cmd_type == IOWr; }
  constraint  deflt_cpl_status    { soft cpl_status == 3'b0; }
  constraint  msg_code_c          { soft msg_code   == 8'h_7e; } // -- VDM Type 0 msg -- //
  constraint  len_c               { soft len        == 1999;   } // -- Invalid len val -- //

  function new(string name = "hqm_sla_pcie_unsupported_req_stim_config");
    super.new(name); 
  endfunction

endclass : hqm_sla_pcie_unsupported_req_stim_config


class hqm_sla_pcie_unsupported_req_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_unsupported_req_seq,sla_sequencer)
  
  hqm_tb_sequences_pkg::hqm_iosf_unsupport_transaction_seq     unsupport_transaction_seq;

  ovm_event_pool        glbl_pool;
  ovm_event exp_ep_nfatal_msg_pf;
  Iosf::iosf_cmd_t  iosf_cmd_i;


  rand bit [9:0]                loc_tag;
  static bit                    ten_bit_tag_en = ~($test$plusargs("HQM_TEN_BIT_TAG_DISABLE"));

  constraint _loc_tag_  { if   (ten_bit_tag_en) loc_tag inside { [10'b_01_0000_0000 : 10'b_11_1111_1111] };  
                          else                  loc_tag inside { [10'b_00_0000_0000 : 10'b_00_1111_1111] };
                      }
  rand hqm_sla_pcie_unsupported_req_stim_config cfg;
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_sla_pcie_unsupported_req_stim_config);

  function new(string name = "hqm_sla_pcie_unsupported_req_seq");
    super.new(name);
    glbl_pool  = ovm_event_pool::get_global_pool();
    exp_ep_nfatal_msg_pf = glbl_pool.get("exp_ep_nfatal_msg_0");

    cfg = hqm_sla_pcie_unsupported_req_stim_config::type_id::create("hqm_sla_pcie_unsupported_req_stim_config"); 
    apply_stim_config_overrides(0);  // 0 means apply overrides for non-rand variables before seq.randomize() is called
  endfunction

  virtual task body();
      sla_ral_addr_t _addr_, _addr1_;
      bit [31:0]     _data_, _data1_;
      bit [31:0]     exp_reg_val, exp_reg_val1;
      int length_r;

    apply_stim_config_overrides(1); // (1) below means apply overrides for random variables after seq.randomize() is called

    if ($test$plusargs("PF_FUNC_BAR_LESS_4G")) begin
        pf_cfg_regs.FUNC_BAR_U.write(status,32'h_0000_0000,primary_id);
        pf_cfg_regs.FUNC_BAR_L.write(status,32'h_0000_0000,primary_id);
        pf_cfg_regs.CSR_BAR_U.write(status,32'h_0000_0002,primary_id);
        pf_cfg_regs.CSR_BAR_L.write(status,32'h_0000_0000,primary_id);
    end

    length_r = 0;
    _addr_[63:0] = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), hqm_msix_mem_regs.MSG_DATA[0]);
    _data_ = $urandom();
    hqm_msix_mem_regs.MSG_DATA[0].write(status, _data_, primary_id);
    hqm_msix_mem_regs.MSG_DATA[0].read(status, rd_val, primary_id);
    exp_reg_val = rd_val[31:0];
    _data_ = $urandom();

    _data1_ = $urandom_range(15);
    pf_cfg_regs.INT_LINE.write(status,_data1_,primary_id);
    pf_cfg_regs.INT_LINE.read(status,rd_val,primary_id);
    exp_reg_val1 = rd_val[31:0];
    _data1_ = $urandom_range(15);


    _addr1_ = _addr_;

    ovm_report_info(get_full_name(), $psprintf("Unsupport:  Address=0x%x, Data=0x%08x, cfg.cmd_type = %0s, exp_reg_val=%0x, Address1=0x%x, Data1=0x%08x, exp_reg_val1=%0x  ", _addr_, _data_, cfg.cmd_type.name(), exp_reg_val, _addr1_, _data1_, exp_reg_val1), OVM_LOW);

    case (cfg.cmd_type)
        IOWr:       `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_data==_data_; iosf_cmd32==Iosf::IOWr; })
        IORd:       `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_cmd32==Iosf::IORd; })
        MRdLk32:    `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_cmd32==Iosf::MRdLk32; })
        LTMRd32:    `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_cmd32==Iosf::LTMRd32; })
        NPMWr32:    `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_data==_data_; iosf_cmd32==Iosf::NPMWr32; })
        LTMWr32:    begin exp_ep_nfatal_msg_pf.trigger(); `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_data==_data_; iosf_cmd32==Iosf::LTMWr32;}) end
        FAdd32:     `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; length_i==1; fbe_i==0; iosf_data==_data_; iosf_cmd32==Iosf::FAdd32; })
        Swap32:     `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; length_i==1; fbe_i==0; iosf_data==_data_; iosf_cmd32==Iosf::Swap32; })
        CAS32:      `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; length_i==2; fbe_i==0; iosf_data==_data_; iosf_cmd32==Iosf::CAS32; })

        MRdLk64:    `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_cmd64==Iosf::MRdLk64; })
        LTMRd64:    `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_cmd64==Iosf::LTMRd64; })
        NPMWr64:    `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_data==_data_; iosf_cmd64==Iosf::NPMWr64; })
        LTMWr64:    begin exp_ep_nfatal_msg_pf.trigger(); `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_data==_data_; iosf_cmd64==Iosf::LTMWr64;}) end
        FAdd64:     `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; length_i==2; fbe_i==0; iosf_data==_data_; iosf_cmd64==Iosf::FAdd64; })
        Swap64:     `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; length_i==2; fbe_i==0; iosf_data==_data_; iosf_cmd64==Iosf::Swap64; })
        CAS64:      `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; length_i==4; fbe_i==0; iosf_data==_data_; iosf_cmd64==Iosf::CAS64; })
 
        CfgRd1:     `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr1_; iosf_cmd32==Iosf::CfgRd1; })
        CfgWr1:     `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr1_; iosf_data==_data1_; iosf_cmd32==Iosf::CfgWr1; })

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

            case(cfg.msg_code)
                65 /*8'h_41*/ 
               ,67 /*8'h_43*/ 
               ,64 /*8'h_40*/ 
               ,69 /*8'h_45*/ 
               ,71 /*8'h_47*/ 
               ,68 /*8'h_44*/ 
               ,72 /*8'h_48*/ : if(iosf_cmd_i != Iosf::Msg4) begin exp_ep_nfatal_msg_pf.trigger(); end

               127 /*8'h_7f*/ : if(iosf_cmd_i inside {Iosf::Msg0,Iosf::Msg2,Iosf::Msg3,Iosf::Msg4}) begin end else begin exp_ep_nfatal_msg_pf.trigger(); end

               default        : exp_ep_nfatal_msg_pf.trigger();

            endcase

                _addr_ = 'h_0; _addr_[15:0] = ( (cfg.vendor_id == intel_vid) ? 16'h_8086 : ( (cfg.vendor_id == pci_sig_vid) ? 'h_1 : $urandom_range('h_1,'h_7fff) ) ) ;
                _addr_[63] = 1'b_1;
                `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; length_i==0; lbe_i==cfg.msg_code[7:4]; fbe_i==cfg.msg_code[3:0]; iosf_cmd64==iosf_cmd_i;}) 

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

            case(cfg.msg_code)
                65 /*8'h_41*/ 
               ,67 /*8'h_43*/ 
               ,64 /*8'h_40*/ 
               ,69 /*8'h_45*/ 
               ,71 /*8'h_47*/ 
               ,68 /*8'h_44*/ 
               ,72 /*8'h_48*/ : if(iosf_cmd_i != Iosf::MsgD4) begin exp_ep_nfatal_msg_pf.trigger(); end

               127 /*8'h_7f*/ : if(iosf_cmd_i inside {Iosf::MsgD0,Iosf::MsgD2,Iosf::MsgD3,Iosf::MsgD4}) begin end else begin exp_ep_nfatal_msg_pf.trigger(); end

               default        : exp_ep_nfatal_msg_pf.trigger();

            endcase

                if(cfg.len == 1999) begin length_r = 1; end else begin length_r = cfg.len; end
                _addr_ = 'h_0; _addr_[15:0] = ( (cfg.vendor_id == intel_vid) ? 16'h_8086 : ( (cfg.vendor_id == pci_sig_vid) ? 'h_1 : $urandom_range('h_1,'h_7fff) ) ) ;
                _addr_[63] = 1'b_1;
                `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; length_i==length_r; lbe_i==cfg.msg_code[7:4]; fbe_i==cfg.msg_code[3:0]; iosf_cmd64==iosf_cmd_i;}) 

        end
        np_p_mem:
        begin
            `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_data==_data_; iosf_cmd32==Iosf::IOWr; })
            //wait_ns_clk(100);
            exp_ep_nfatal_msg_pf.trigger(); 
            `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_data==_data_; iosf_cmd32==Iosf::LTMWr32;})
        end
        p_np_mem:
        begin
            exp_ep_nfatal_msg_pf.trigger(); 
            `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_data==_data_; iosf_cmd32==Iosf::LTMWr32;})
           // wait_ns_clk(100);
            `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_data==_data_; iosf_cmd32==Iosf::IOWr; })
        end

        Cpl, CplD, CplLk, CplDLk: begin
            _addr_[63:7] = 57'h0;
            case(cfg.cmd_type)
               Cpl:          iosf_cmd_i = Iosf::Cpl;
               CplD:   begin iosf_cmd_i = Iosf::CplD; length_r=1;   end
               CplLk:        iosf_cmd_i = Iosf::CplLk;
               CplDLk: begin iosf_cmd_i = Iosf::CplDLk; length_r=1; end
            endcase
            `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), { iosf_cmd==iosf_cmd_i; is_cpl==1; iosf_addr==_addr_; length_i==length_r; iosf_data==_data_; fbe_i==cfg.cpl_status; lbe_i==4; })
        end
        UR_Poision:       `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_data==_data_; iosf_cmd32==Iosf::IOWr; ep==1;})
        EC_Poision:       `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_cmd==Iosf::Cpl; is_cpl==1; iosf_addr=={57'h0,_addr_[6:0]}; length_i==0; iosf_data==_data_; fbe_i==cfg.cpl_status; lbe_i==4; ep==1;})
        Rsvd_fmt_type:       `ovm_do_on_with(unsupport_transaction_seq, p_sequencer.pick_sequencer(primary_id), {iosf_addr==_addr_; iosf_data==_data_; is_rsvd_fmt_type==1;})

        default:    `ovm_error(get_name(),"Invalid transaction type!!")
    endcase
    hqm_msix_mem_regs.MSG_DATA[0].readx(status, exp_reg_val, 'hffff_ffff, rd_val, primary_id);

  endtask

endclass

`endif
