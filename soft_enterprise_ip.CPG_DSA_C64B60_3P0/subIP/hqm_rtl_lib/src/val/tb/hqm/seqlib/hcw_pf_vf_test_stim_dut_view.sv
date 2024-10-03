class hcw_pf_vf_test_stim_dut_view extends ovm_object;

  `ovm_object_utils(hcw_pf_vf_test_stim_dut_view)

  static function hcw_pf_vf_test_stim_dut_view instance(ovm_component comp=null,string inst_suffix="");
    automatic hcw_pf_vf_test_stim_dut_view inst;

    if(inst_list.exists(inst_suffix)) begin
      inst = inst_list[inst_suffix];
    end else begin
      if(comp == null) begin comp = ovm_root::get(); end
      if(accessor == null) accessor = comp;

      if(accessor != null) begin
        inst = hcw_pf_vf_test_stim_dut_view::type_id::create("hcw_pf_vf_test_stim_dut_view");
        inst_list[inst_suffix] = inst;
      end else begin
       `ovm_fatal("hcw_pf_vf_test_stim_dut_view", "No accessor component to retrieve configs through")
      end
    end

    return inst;
  endfunction

  string        inst_suffix = "";

  // this must be assigned in constructor new
  int unsigned  num_ldb_pp;
  int unsigned  num_dir_pp;
  int unsigned  num_vf;
  int unsigned  num_vf_ldb_pp;
  int unsigned  num_vf_dir_pp;
  bit           enable_msi;
  bit           enable_msix;
  bit           enable_ims_poll;

  static protected      hcw_pf_vf_test_stim_dut_view    inst_list[string];
  static protected      ovm_component                   accessor;

  function new(name="hcw_pf_vf_test_stim_dut_view");
    int                 int_val;
    int unsigned        num_ldb_pp_val          = 0;
    int unsigned        num_dir_pp_val          = 1;
    int unsigned        num_vf_val              = 0;
    int unsigned        num_vf_ldb_pp_val       = 0;
    int unsigned        num_vf_dir_pp_val       = 0;
    bit                 enable_msi_val          = 0;
    bit                 enable_msix_val         = 0;
    bit                 enable_ims_poll_val     = 0;

    super.new(name);      
      
    if (accessor.get_config_int("HCW_PF_VF_TEST_NUM_DIR_PP", int_val)) begin
      num_dir_pp_val = int_val;
    end

    if (accessor.get_config_int("HCW_PF_VF_TEST_NUM_LDB_PP", int_val)) begin
      num_ldb_pp_val = int_val;
    end

    if (accessor.get_config_int("HCW_PF_VF_TEST_NUM_VF", int_val)) begin
      num_vf_val = int_val;
    end

    if (accessor.get_config_int("HCW_PF_VF_TEST_NUM_VF_DIR_PP", int_val)) begin
      num_vf_dir_pp_val = int_val;
    end

    if (accessor.get_config_int("HCW_PF_VF_TEST_NUM_VF_LDB_PP", int_val)) begin
      num_vf_ldb_pp_val = int_val;
    end

    if (accessor.get_config_int("HCW_PF_VF_TEST_ENABLE_MSIX", int_val)) begin
      enable_msi_val = int_val;
    end

    if (accessor.get_config_int("HCW_PF_VF_TEST_ENABLE_MSIX", int_val)) begin
      enable_msi_val = int_val;
    end

    num_ldb_pp          = num_ldb_pp_val;
    num_dir_pp          = num_dir_pp_val;
    num_vf              = num_vf_val;
    num_vf_ldb_pp       = num_vf_ldb_pp_val;
    num_vf_dir_pp       = num_vf_dir_pp_val;
    enable_msi          = enable_msi_val;
    enable_msix         = enable_msix_val;
    enable_ims_poll     = enable_ims_poll_val;

  endfunction

endclass
