`ifndef HQM_IOSF_FUNC_COV__SV
`define HQM_IOSF_FUNC_COV__SV


class hqm_iosf_func_cov extends ovm_component;

    bit ldb_pp_v[`HQM_NUM_LDB_PORTS];
    bit dir_pp_v[`HQM_NUM_DIR_PORTS];

    string      inst_suffix = "";

    hqm_cfg     i_hqm_cfg;

    ovm_analysis_imp #(iosf_trans_type_st, hqm_iosf_func_cov) analysis_imp;

    `ovm_component_utils(hqm_iosf_func_cov)

    covergroup enq_pp_address_cg (string cg_inst_name) with function sample (bit [6:0] pp_num, bit is_ldb, bit is_nm_pf);

       option.name         = cg_inst_name;
       option.per_instance = 1; 
       option.comment      = "To verify whether all the ports are being accessed using addresses (LDB/DIR, is_nm_pf)";

       cp_pp_num : coverpoint pp_num {
           option.comment = "Producer Port value";
           bins ldbpp_val[] = { ['h0 : 'h3f] } iff (is_ldb);
           bins dirpp_val[] = { ['h0 : 'h5f] } iff (!is_ldb);
       }

       cp_is_ldb : coverpoint is_ldb {
           option.comment = "Load Balanced or Directed";
           bins dir = { 0 };
           bins ldb = { 1 };
       }

       cp_is_nm_pf : coverpoint is_nm_pf {
           option.comment = "is_nm_pf set";
           bins is_nm_pf_0 = { 0 };
           bins is_nm_pf_1 = { 1 };
       }
       cp_pp_access : cross cp_pp_num, cp_is_ldb {
           option.comment = "Directed/Load Balanced ports";
           ignore_bins illegal_dir_pp     =  binsof(cp_pp_num.dirpp_val) && binsof(cp_is_ldb.ldb);
           ignore_bins illegal_ldb_pp     =  binsof(cp_pp_num.ldbpp_val) && binsof(cp_is_ldb.dir);
       }
       cp_pp_nm_pf_access : cross cp_pp_access, cp_is_nm_pf {
           option.comment = "Directed/Load Balanced ports access with is_nm_pf set/unset";
       }
    endgroup : enq_pp_address_cg

    covergroup iosf_prim_cmd_cg (string cg_inst_name) with function sample ( Iosf::iosf_cmd_t txn_cmd, bit [`HQM_SAI_WIDTH:0] sai_val, bit [9:0] txn_length, hqm_trans_type_e txn_type );
  
       option.name         = cg_inst_name;
       option.per_instance = 1; 
       cp_txn_type : coverpoint txn_type {
          option.comment = "Transaction Type";
          bins HCW_SCH            = {HCW_SCH};
          bins CQ_INT             = {CQ_INT}; 
          bins CSR_WRITE          = {CSR_WRITE};
          bins HCW_ENQ            = {HCW_ENQ};
          bins CSR_READ           = {CSR_READ}; 
          bins PCIE_CFG_RD0       = {PCIE_CFG_RD0};
          bins PCIE_CFG_WR0       = {PCIE_CFG_WR0};  
          bins COMP_CQ_INT        = {COMP_CQ_INT};
          bins MSI_INT            = {MSI_INT};
          bins MSIX_INT           = {MSIX_INT};
          bins HCW_ENQ_ADDR       = {HCW_ENQ_ADDR};
          bins CSR_WRITE_DATA     = {CSR_WRITE_DATA};
          bins PCIE_CFG_WR0_DATA  = {PCIE_CFG_WR0_DATA};
          bins HQM_GEN_CPL        = {HQM_GEN_CPL};
          bins HQM_GEN_CPLD       = {HQM_GEN_CPLD};
          bins UNKWN_TRANS_TO_HQM = {UNKWN_TRANS_TO_HQM};
          bins illegal_bin = default;
       }

       cp_sai_val : coverpoint sai_val {
          option.comment = "SAI Value";
          bins sai_bit0 = { 8'b0000_0001 };
          bins sai_bit1 = { 8'b0000_0010 };
          bins sai_bit2 = { 8'b0000_0100 };
          bins sai_bit3 = { 8'b0000_1000 };
          bins sai_bit4 = { 8'b0001_0000 };
          bins sai_bit5 = { 8'b0010_0000 };
          bins sai_bit6 = { 8'b0100_0000 };
          bins sai_bit7 = { 8'b1000_0000 };
       }

       cp_txn_cmd : coverpoint txn_cmd {
          option.comment = "Transcation Command";
          bins MRd32       = {Iosf::MRd32};
          bins MRd64       = {Iosf::MRd64};        
          bins MWr32       = {Iosf::MWr32};        
          bins MWr64       = {Iosf::MWr64};        
          bins CfgRd0      = {Iosf::CfgRd0};       
          bins CfgWr0      = {Iosf::CfgWr0};       
          bins Cpl         = {Iosf::Cpl};          
          bins CplD        = {Iosf::CplD};         
          bins LTMRd32     = {Iosf::LTMRd32 }; 
          bins LTMRd64     = {Iosf::LTMRd64 }; 
          bins MRdLk32     = {Iosf::MRdLk32 }; 
          bins MRdLk64     = {Iosf::MRdLk64 }; 
          bins LTMWr32     = {Iosf::LTMWr32 }; 
          bins LTMWr64     = {Iosf::LTMWr64 }; 
          bins NPMWr32     = {Iosf::NPMWr32 }; 
          bins NPMWr64     = {Iosf::NPMWr64 }; 
          bins IORd        = {Iosf::IORd    }; 
          bins IOWr        = {Iosf::IOWr    }; 
          bins FAdd32      = {Iosf::FAdd32  }; 
          bins FAdd64      = {Iosf::FAdd64  }; 
          bins Swap32      = {Iosf::Swap32  }; 
          bins Swap64      = {Iosf::Swap64  }; 
          bins CAS32       = {Iosf::CAS32   }; 
          bins CAS64       = {Iosf::CAS64   }; 
          bins Msg0        = {Iosf::Msg0    }; 
          bins Msg1        = {Iosf::Msg1    }; 
          bins Msg2        = {Iosf::Msg2    }; 
          bins Msg3        = {Iosf::Msg3    }; 
          bins Msg4        = {Iosf::Msg4    }; 
          bins Msg5        = {Iosf::Msg5    }; 
          bins Msg6        = {Iosf::Msg6    }; 
          bins Msg7        = {Iosf::Msg7    }; 
          bins MsgD0       = {Iosf::MsgD0   }; 
          bins MsgD1       = {Iosf::MsgD1   }; 
          bins MsgD2       = {Iosf::MsgD2   }; 
          bins MsgD3       = {Iosf::MsgD3   }; 
          bins MsgD4       = {Iosf::MsgD4   }; 
          bins MsgD5       = {Iosf::MsgD5   }; 
          bins MsgD6       = {Iosf::MsgD6   }; 
          bins MsgD7       = {Iosf::MsgD7   }; 
          bins CplLk       = {Iosf::CplLk   }; 
          bins CplDLk      = {Iosf::CplDLk  }; 

            
          bins liiegal_bin = default;
       }

       cp_txn_length : coverpoint txn_length {
          option.comment = "Transcation length ";
          bins len4B       = {`IOSF_LEN4B}; 
          bins len16B      = {`IOSF_LEN16B};
          bins len32B      = {`IOSF_LEN32B};
          bins len48B      = {`IOSF_LEN48B};
          bins len64B      = {`IOSF_LEN64B};
          bins illegal_bin = default;
       }
    
       cp_hqm_cq_qe_write : cross cp_txn_type,cp_txn_cmd,cp_txn_length {
          option.comment = "Hqm:CQ-QE Write";
          ignore_bins len_illegal     = !binsof(cp_txn_length) intersect {`IOSF_LEN16B,`IOSF_LEN32B,`IOSF_LEN48B,`IOSF_LEN64B} ; 
          ignore_bins txn_illegal     = !binsof(cp_txn_type) intersect {HCW_SCH};
          //ignore_bins cmd_illegal     = !binsof(cp_txn_cmd) intersect {Iosf::MWr32, Iosf::MWr64}; 
          ignore_bins cmd_illegal     = !binsof(cp_txn_cmd) intersect {Iosf::MWr64}; 
       }

       cp_hqm_intr_wr : cross cp_txn_type,cp_txn_cmd,cp_txn_length { 
          option.comment = "Hqm:Interrupt Write";
          ignore_bins len_illegal     = !binsof(cp_txn_length) intersect {`IOSF_LEN4B}; 
          ignore_bins txn_illegal     = !binsof(cp_txn_type) intersect {CQ_INT};
          ignore_bins cmd_illegal     = !binsof(cp_txn_cmd) intersect {Iosf::MWr32, Iosf::MWr64}; 
       }

       cp_ia_pp_write_sai  : cross cp_txn_type,cp_txn_cmd,cp_txn_length,cp_sai_val {
          option.comment = "IA:PP write with sai";
          ignore_bins cmd_illegal     = !binsof(cp_txn_cmd) intersect {Iosf::MWr32,Iosf::MWr64};
          ignore_bins txn_illegal     = !binsof(cp_txn_type) intersect {HCW_ENQ}; 
          ignore_bins len_illegal     = binsof(cp_txn_length) intersect {`IOSF_LEN4B}; 
       }
     
       cp_ia_pp_write  : cross cp_txn_type,cp_txn_cmd,cp_txn_length {
          option.comment = "IA:PP write";
          ignore_bins cmd_illegal     = !binsof(cp_txn_cmd) intersect {Iosf::MWr32,Iosf::MWr64};
          ignore_bins txn_illegal     = !binsof(cp_txn_type) intersect {HCW_ENQ}; 
          ignore_bins len_illegal     = binsof(cp_txn_length) intersect {`IOSF_LEN4B};
       }

       cp_ia_csr_write  : cross cp_txn_type,cp_txn_cmd, cp_txn_length {
          option.comment = "IA:CSR write";
          ignore_bins cmd_illegal     = !binsof(cp_txn_cmd)    intersect {Iosf::MWr32,Iosf::MWr64};
          ignore_bins txn_illegal     = !binsof(cp_txn_type)   intersect {CSR_WRITE}; 
          ignore_bins len_illegal     = !binsof(cp_txn_length) intersect {`IOSF_LEN4B};
       }
     
       cp_ia_csr_read_access  : cross cp_txn_type,cp_txn_cmd,cp_txn_length {
          option.comment = "IA:CSR read access";
          ignore_bins cmd_illegal     = !binsof(cp_txn_cmd)    intersect {Iosf::MRd32,Iosf::MRd64};
          ignore_bins txn_illegal     = !binsof(cp_txn_type)   intersect {CSR_READ}; 
          ignore_bins len_illegal     = !binsof(cp_txn_length) intersect {`IOSF_LEN4B};
       }
     
       cp_ia_pcie_cfg_read : cross cp_txn_type,cp_txn_cmd,cp_txn_length {
          option.comment = "IA:PCIe config register read";
          ignore_bins cmd_illegal     = !binsof(cp_txn_cmd)     intersect {Iosf::CfgRd0};
          ignore_bins txn_illegal     = !binsof(cp_txn_type)    intersect {PCIE_CFG_RD0}; 
          ignore_bins len_illegal     = !binsof(cp_txn_length)  intersect {`IOSF_LEN4B};
       }
     
      cp_ia_pcie_cfg_write : cross cp_txn_type,cp_txn_cmd,cp_txn_length {
          option.comment = "IA:PCIe config register write";
          ignore_bins cmd_illegal     = !binsof(cp_txn_cmd)    intersect {Iosf::CfgWr0} ;
          ignore_bins txn_illegal     = !binsof(cp_txn_type)   intersect {PCIE_CFG_WR0}; 
          ignore_bins len_illegal     = !binsof(cp_txn_length) intersect {`IOSF_LEN4B};
       }

       cp_hcw_sch_sai  : cross cp_txn_type, cp_sai_val {
          option.comment = "IA:HCW scheules with sai";
          ignore_bins txn_illegal     = !binsof(cp_txn_type) intersect { HCW_SCH }; 
       }
      
       cp_cq_int_sai  : cross cp_txn_type, cp_sai_val {
          option.comment = "IA:CQ Interrupt with sai";
          ignore_bins txn_illegal     = !binsof(cp_txn_type) intersect { CQ_INT, COMP_CQ_INT }; 
       }
     
       cp_msi_int_sai  : cross cp_txn_type, cp_sai_val {
          option.comment = "IA:MSI interrupt with sai";
          ignore_bins txn_illegal     = !binsof(cp_txn_type) intersect { MSI_INT }; 
       }
     
       cp_msix_int_sai  : cross cp_txn_type, cp_sai_val {
          option.comment = "IA:MSIX interrupt write with sai";
          ignore_bins txn_illegal     = !binsof(cp_txn_type) intersect { MSIX_INT }; 
       }
     
       cp_cpl_sai  : cross cp_txn_type, cp_sai_val {
          option.comment = "IA: completion write with sai";
          ignore_bins txn_illegal     = !binsof(cp_txn_type) intersect { HQM_GEN_CPL, HQM_GEN_CPLD }; 
       }
     
    endgroup : iosf_prim_cmd_cg 

    covergroup pp_addr_window_cg (string cg_inst_name) with function sample ( Iosf::iosf_cmd_t txn_cmd, bit [9:0] txn_length, bit [3:0] first_be, bit [3:0] last_be );
  
       option.name         = cg_inst_name;
       option.per_instance = 1; 

       cp_txn_cmd : coverpoint txn_cmd {
           option.comment = "Transaction command (MWr32/MWr64)";
           bins MWr32 = { Iosf::MWr32 };
           bins MWr64 = { Iosf::MWr64 };
       }

       cp_txn_length : coverpoint txn_length {
           option.comment = "Transaction length";
           bins len[] = { [ 'd1 : 'd64 ] };
           ignore_bins len_gt_512 = { 'd0, [ 'd65 : 'd1023 ] };
       }

       cp_first_be : coverpoint first_be {
           option.comment = "First byte enable";
           bins fbe[] = { [ 'h0 : 'hf ] };
       }

       cp_last_be : coverpoint last_be {
           option.comment = "Last byte enable";
           bins lbe[] = { ['h0 : 'hf ] };
       }

       cp_be : coverpoint { last_be[3:0], first_be } {
           option.comment = "Concatenated byte enable";
           bins be_ff     = { 'hff };
           bins not_all_fs = { [ 8'h0 : 8'hfe ] };
       }

       cp_txn_cmd_len : cross cp_txn_cmd, cp_txn_length {
           option.comment = "Cross between transaction command and transaction length";
       }

       cp_txn_cmd_be : cross cp_txn_cmd, cp_be {
           option.comment = "Cross between transaction command non-zero byte enables";
           bins        MWr32_not_all_fs = binsof(cp_be.not_all_fs) && binsof(cp_txn_cmd.MWr32);
           bins        MWr64_not_all_fs = binsof(cp_be.not_all_fs) && binsof(cp_txn_cmd.MWr64);
           ignore_bins all_ffs          = binsof(cp_be.be_ff);
       }

    endgroup: pp_addr_window_cg

    extern function      new                (string name = "hqm_iosf_func_cov", ovm_component parent = null);
    extern function void build              ();
    extern function void end_of_elaboration ();
    extern function void get_ral_cfg        ();
    extern function void write              (iosf_trans_type_st t);
    extern function bit  decode_pp_addr     (IosfMonTxn txn);

endclass : hqm_iosf_func_cov

function hqm_iosf_func_cov::new(string name = "hqm_iosf_func_cov", ovm_component parent = null);
    super.new(name, parent);
    enq_pp_address_cg = new($psprintf("%0s_enq_pp_address_cg", name));
    iosf_prim_cmd_cg  = new($psprintf("%0s_iosf_prim_cmd_cg", name));
    pp_addr_window_cg = new($psprintf("%0s_pp_addr_window_cg", name));
endfunction : new

function void hqm_iosf_func_cov::build();

    `START_TEMPL($psprintf("build"))
    analysis_imp = new("analysis_imp", this);
    `END_TEMPL($psprintf("build"))

endfunction : build

function void hqm_iosf_func_cov::end_of_elaboration();

    ovm_object o_tmp;

    `START_TEMPL($psprintf("end_of_elaboration"))
    if (!get_config_object({"i_hqm_cfg",inst_suffix}, o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("get_config_object(i_hqm_cfg,..) type not hqm_cfg"));
    end
    `END_TEMPL($psprintf("end_of_elaboration"))

endfunction : end_of_elaboration

function void hqm_iosf_func_cov::get_ral_cfg();

    sla_ral_env ral;
    sla_ral_reg reg_h;
    string      reg_name;

    `START_TEMPL($psprintf("get_ral_cfg"))
    `sla_assert($cast(ral, sla_ral_env::get_ptr()), ("Unable to get handle to RAL"))
    for (int i = 0; i < `HQM_NUM_DIR_PORTS; i++) begin
        reg_name = $psprintf("dir_pp_v[%0d]", i);
        reg_h = ral.find_reg_by_file_name(reg_name, "hqm_system_csr");
        if (reg_h == null) begin
            ovm_report_fatal(get_full_name(), $psprintf("cannot find handle for reg %0s", reg_name));
        end
        dir_pp_v[i] = reg_h.get();
    end
    for (int i = 0; i < `HQM_NUM_LDB_PORTS; i++) begin
        reg_name = $psprintf("ldb_pp_v[%0d]", i);
        reg_h = ral.find_reg_by_file_name(reg_name, "hqm_system_csr");
        if (reg_h == null) begin
            ovm_report_fatal(get_full_name(), $psprintf("cannot find handle for reg %0s", reg_name));
        end
        ldb_pp_v[i] = reg_h.get();
    end
    `END_TEMPL($psprintf("get_ral_cfg"))

endfunction : get_ral_cfg

function void hqm_iosf_func_cov::write(iosf_trans_type_st t);
   bit [`HQM_SAI_WIDTH:0] sai_val;
   bit [9:0] txn_length;
   Iosf::iosf_cmd_t txn_cmd;
   hqm_trans_type_e txn_type;     
 
`START_TEMPL($psprintf("write"))

    if (t.trans_type == HCW_ENQ) begin

        bit [6:0] pp_num;
        bit       is_ldb;
        bit       is_nm_pf;

        ovm_report_info(get_full_name(), $psprintf("Received an Enqueue IOSF transaction (Address=0x%0x)", t.monTxn.address), OVM_DEBUG);
        pp_num   = t.monTxn.address[18:12]; //19:12
        is_ldb   = t.monTxn.address[20];
        is_nm_pf = t.monTxn.address[21];

        if (is_ldb) begin
            if (ldb_pp_v[pp_num]) begin
                enq_pp_address_cg.sample(pp_num, is_ldb, is_nm_pf);
            end 
        end else begin
            if (dir_pp_v[pp_num]) begin
                enq_pp_address_cg.sample(pp_num, is_ldb, is_nm_pf);
            end
        end
    end //HCW_ENQ
        ovm_report_info(get_full_name(), $psprintf("Received an IOSF transaction (txn_cmd=%s txn_length=0x%0x txn_sai=0x%0x)", t.monTxn.cmd,t.monTxn.length,t.monTxn.sai), OVM_DEBUG);
        
        txn_cmd    = t.monTxn.cmd;
        sai_val    = t.monTxn.sai;
        txn_length = t.monTxn.length;
        txn_type   = t.trans_type;
        iosf_prim_cmd_cg.sample(txn_cmd,sai_val,txn_length,txn_type);

    if (decode_pp_addr(t.monTxn) ) begin
        ovm_report_info(get_full_name(), $psprintf("Received an IOSF transaction which falls in PP address window(address=0x%0x)", t.monTxn.address), OVM_DEBUG);
        pp_addr_window_cg.sample(t.monTxn.cmd, t.monTxn.length, t.monTxn.first_be, t.monTxn.last_be);
    end
    `END_TEMPL($psprintf("write"))

endfunction : write

function bit hqm_iosf_func_cov::decode_pp_addr(IosfMonTxn txn);

    int pp_num;
    int pp_type;
    int vf_num;
    int vpp_num;
    bit is_pf;
    bit is_nm_pf;

    ovm_report_info(get_full_name(), $psprintf("decode_pp_addr -- Start"), OVM_DEBUG);
    decode_pp_addr = 1'b0;
    if ( ( ({ txn.format, txn.type_i } == Iosf::MWr64) || ({ txn.format, txn.type_i } == Iosf::MWr32) ) && 
         ( (txn.eventType == Iosf::TCMD) && (txn.end_of_transaction == 1'b0) )
    ) begin
        decode_pp_addr = i_hqm_cfg.decode_pp_addr(txn.address, pp_num, pp_type, is_pf, vf_num, vpp_num, is_nm_pf);
    end
    ovm_report_info(get_full_name(), $psprintf("decode_pp_addr(decode_pp_addr=%0b) -- End", decode_pp_addr), OVM_DEBUG);

endfunction : decode_pp_addr

`endif //HQM_IOSF_FUNC_COV__SV
