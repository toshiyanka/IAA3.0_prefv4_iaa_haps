`ifndef HQM_SLA_PCIE_CPL_ERROR_SEQ
`define HQM_SLA_PCIE_CPL_ERROR_SEQ

import lvm_common_pkg::*;

typedef enum int {  nf_unmask       = 0, 
                    nf_mask         = 1,
                    f_unmask        = 2,
                    f_mask          = 3,
                    nf_anfes_unmask = 4
                 } sev_mask_type_t ;

`include "stim_config_macros.svh"

class hqm_sla_pcie_cpl_error_stim_config extends ovm_object;

  static string stim_cfg_name = "hqm_sla_pcie_cpl_error_stim_config";
 
  rand sev_mask_type_t ec_sev_mask_type; 

  `ovm_object_utils_begin(hqm_sla_pcie_cpl_error_stim_config)
    `ovm_field_enum(sev_mask_type_t    , ec_sev_mask_type,  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_sla_pcie_cpl_error_stim_config)
    `stimulus_config_field_rand_enum(sev_mask_type_t, ec_sev_mask_type)
  `stimulus_config_object_utils_end
 
  function new(string name = "hqm_sla_pcie_cpl_error_stim_config");
    super.new(name); 
  endfunction

endclass : hqm_sla_pcie_cpl_error_stim_config


class hqm_sla_pcie_cpl_error_seq extends hqm_sla_pcie_base_seq;
  
  `ovm_sequence_utils(hqm_sla_pcie_cpl_error_seq,sla_sequencer)


  rand bit skip_checks ;
  rand bit warm_reset_before_checks ;
  rand bit vf_flr_before_checks ;

  hqm_ue_cpl_seq                         ue_cpl_seq;
  hqm_sla_pcie_flr_sequence flr_seq;
  hqm_sla_pcie_eot_checks_sequence       error_status_chk_seq;
  hqm_tb_cfg_file_mode_seq               warm_rst_seq;
  hqm_sla_pcie_init_seq                  init_hqm;

  rand bit       ep;
  rand bit [9:0] loc_tag;
  rand bit       reporting_en;
  static bit     ten_bit_tag_en = ~($test$plusargs("HQM_TEN_BIT_TAG_DISABLE"));

  ovm_event_pool glbl_pool;
  ovm_event      exp_ep_fatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      exp_ep_corr_msg[`MAX_NO_OF_VFS+1];

  constraint deflt_ep         { soft ep           == 1'b0; }
  constraint deflt_report_en  { soft reporting_en == 1'b1; }
  constraint deflt_loc_tag    { if   (ten_bit_tag_en) loc_tag inside { [10'b_01_0000_0000 : 10'b_11_1111_1111] };
                                else                  loc_tag inside { [10'b_00_0000_0000 : 10'b_00_1111_1111] }; }

  constraint skip_checks_c { soft skip_checks == 1'b0; }
  constraint warm_reset_before_checks_c { soft warm_reset_before_checks == 1'b0; }
  constraint vf_flr_before_checks_c     { soft vf_flr_before_checks     == 1'b0; }

  rand hqm_sla_pcie_cpl_error_stim_config cfg;
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_sla_pcie_cpl_error_stim_config);

  function new(string name = "hqm_sla_pcie_cpl_error_seq");
    super.new(name); 

    glbl_pool        = ovm_event_pool::get_global_pool();

    // -- Create/get handles to msi/msix_vector detected triggering -- // 
    for(int i=0; i<(`MAX_NO_OF_VFS+1); i++) begin
      exp_ep_fatal_msg[i]    = glbl_pool.get($psprintf("exp_ep_fatal_msg_%0d",i));
      exp_ep_corr_msg[i]     = glbl_pool.get($psprintf("exp_ep_corr_msg_%0d",i));
    end
    cfg = hqm_sla_pcie_cpl_error_stim_config::type_id::create("hqm_sla_pcie_cpl_error_stim_config"); 
    apply_stim_config_overrides(0);  // 0 means apply overrides for non-rand variables before seq.randomize() is called
 
  endfunction

  virtual task body();
    sla_ral_addr_t   ue_req_id;
    logic [4:0]      func_num;
    logic [4:0]  flr_func_num=0;

    bit [127:0] header = 128'h00000000_00006900_00000004_0a000000;

    apply_stim_config_overrides(1); // (1) below means apply overrides for random variables after seq.randomize() is called

    if($test$plusargs("HQM_PCIE_CPL_ERR_FUNC_NO")) begin $value$plusargs("HQM_PCIE_CPL_ERR_FUNC_NO=%0d",func_num); end 
    ue_req_id = func_num ;

    if(func_num<(`HQM_PF_FUNC_NUM) || func_num>(`HQM_PF_FUNC_NUM)) func_num = `HQM_PF_FUNC_NUM;
 
    `ovm_info(get_full_name(),$psprintf("Starting hqm_sla_pcie_cpl_error_seq with: ue_req_id (0x%0x); func_num (0x%0x), ep (0x%0x) and skip_checks(0x%0x)",ue_req_id,func_num, ep, skip_checks),OVM_LOW)
    if(skip_checks) begin 
       `ovm_do_on_with(ue_cpl_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_req_id == ue_req_id; iosf_cpl_status == 'h_0;errorpresent==ep; iosf_tag == 9'h_1ff;})
    end else begin
       `ovm_do_on_with(ue_cpl_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_req_id == ue_req_id; iosf_cpl_status == 'h_0;errorpresent==ep; iosf_tag == loc_tag[9:0];})

    end
    
    `ovm_info(get_full_name(),$psprintf("tag field: ue_cpl_seq.iosf_tag = %h, cfg.ec_sev_mask_type = %0s", ue_cpl_seq.iosf_tag, cfg.ec_sev_mask_type),OVM_LOW)

    header[79:72] = ue_cpl_seq.iosf_tag[7:0];
    header[19]    = ue_cpl_seq.iosf_tag[8];
    header[23]    = ue_cpl_seq.iosf_tag[9];
    header[95:80] = ue_req_id[15:0];
    header[14]    = ep;

    // -- Wait for AER SB msg, then trigger warm_reset -- //
    if(warm_reset_before_checks) begin wait_ns_clk(5000); induce_warm_reset(); end
   
    if(skip_checks) begin
          `ovm_info(get_full_name(), $psprintf("Skipping error logging checks in hqm_sla_pcie_cpl_error_seq as skip_checks(0x%0x)!!!", skip_checks), OVM_LOW)
          case (cfg.ec_sev_mask_type)
             f_unmask        : begin if(reporting_en) exp_ep_fatal_msg[func_num].trigger(); end 
             nf_anfes_unmask : begin if(reporting_en) exp_ep_corr_msg[func_num].trigger() ; end 
          endcase      

    end else begin

    case (cfg.ec_sev_mask_type)
        nf_unmask: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==~(vf_flr_before_checks && |func_num);test_induced_anfes==1'b_1; test_induced_ec==1'b_0; en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;/* exp_header_log == header;*/}); 
           end 
        f_unmask: begin 
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_fed==~(vf_flr_before_checks && |func_num); test_induced_ec==1'b_1;en_H_FP_check==1'b_1; exp_header_log == header;}); 
              if(reporting_en) exp_ep_fatal_msg[func_num].trigger();
           end 
        nf_mask: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==~(vf_flr_before_checks && |func_num);test_induced_anfes==1'b_1; test_induced_ec==1'b_0; en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;});  
           end 
        f_mask: begin 
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_fed==~(vf_flr_before_checks && |func_num);test_induced_ec==1'b_1;en_H_FP_check==1'b_0; test_induced_fep==5'b_11110;}); 
           end
        nf_anfes_unmask: begin
              `ovm_do_with(error_status_chk_seq, {func_no==func_num;test_induced_ced==~(vf_flr_before_checks && |func_num);test_induced_anfes==1'b_1; test_induced_ec==1'b_1; en_H_FP_check==1'b_1; exp_header_log == header;});  
              if(reporting_en) exp_ep_corr_msg[func_num].trigger();
           end 
    endcase      
    end      

  endtask : body

  task induce_warm_reset();
        //-----------------------------
        //-- issue warm_rst
        //-----------------------------
        `ovm_info(get_full_name(),$psprintf("Starting warm_rst_seq"),OVM_LOW);
        wait_ns_clk(20);
        warm_rst_seq = hqm_tb_cfg_file_mode_seq::type_id::create("warm_rst_seq");
        warm_rst_seq.set_cfg("HQM_PCIE_BASE_WARM_RESET_SEQ", 1'b0);
        warm_rst_seq.start(get_sequencer());
        wait_ns_clk(20);
        `ovm_info(get_full_name(),$psprintf("Done warm_rst_seq"),OVM_LOW);
        `ovm_do(init_hqm);
  endtask

endclass : hqm_sla_pcie_cpl_error_seq

`endif
