class hqm_pcie_msg_seq extends sla_sequence_base;
  `ovm_object_utils(hqm_pcie_msg_seq)

  hqm_pcie_corr_err_seq         i_hqm_pcie_corr_err_seq;
  hqm_pcie_fatal_err_seq        i_hqm_pcie_fatal_err_seq;
  hqm_pcie_nonfatal_err_seq     i_hqm_pcie_nonfatal_err_seq;
  hqm_gen_msix_seq              i_hqm_gen_msix_seq;

  function new(string name = "hqm_pcie_msg_seq");
    super.new(name);
  endfunction

  virtual task body();
    string      seq_choice;

    seq_choice = "";

    if ($value$plusargs("HQM_PCIE_MSG_SEQ_CHOICE=%s", seq_choice)) begin
      case (seq_choice)
        "CORR_ERR": begin
          `ovm_do(i_hqm_pcie_corr_err_seq)
        end
        "FATAL_ERR": begin
          `ovm_do(i_hqm_pcie_fatal_err_seq)
        end
        "NONFATAL_ERR": begin
          `ovm_do(i_hqm_pcie_nonfatal_err_seq)
        end
        "MSIX": begin
          `ovm_do(i_hqm_gen_msix_seq)
        end
        default: begin
          `ovm_error(get_full_name(),$psprintf("+HQM_PCIE_MSG_SEQ_CHOICE=%s is not a valid choice (CORR_ERR, FATAL_ERR, NONFATAL_ERR)",seq_choice))
        end
      endcase
    end else begin
      `ovm_error(get_full_name(),"+HQM_PCIE_MSG_SEQ_CHOICE=[CORR_ERR | FATAL_ERR | NONFATAL_ERR] not specified")
    end
  endtask

endclass : hqm_pcie_msg_seq
