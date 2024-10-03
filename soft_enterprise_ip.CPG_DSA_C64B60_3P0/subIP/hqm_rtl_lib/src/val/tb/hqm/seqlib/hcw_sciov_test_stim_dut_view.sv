class hcw_sciov_test_stim_dut_view extends ovm_object;

  `ovm_object_utils(hcw_sciov_test_stim_dut_view)

  static function hcw_sciov_test_stim_dut_view instance(ovm_component comp=null,string inst_suffix="");
    automatic hcw_sciov_test_stim_dut_view inst;

    if(inst_list.exists(inst_suffix)) begin
      inst = inst_list[inst_suffix];
    end else begin
      if(comp == null) begin comp = ovm_root::get(); end
      if(accessor == null) accessor = comp;

      if(accessor != null) begin
        inst = hcw_sciov_test_stim_dut_view::type_id::create("hcw_sciov_test_stim_dut_view");
        inst_list[inst_suffix] = inst;
      end else begin
       `ovm_fatal("hcw_sciov_test_stim_dut_view", "No accessor component to retrieve configs through")
      end
    end

    return inst;
  endfunction

  string        inst_suffix = "";

  // this must be assigned in constructor new
  bit           enable_msix;
  bit           enable_ims;
  bit           enable_ims_poll;
  int unsigned  num_vdev;
  int unsigned  num_ldb_pp;
  int unsigned  num_dir_pp;

  static protected      hcw_sciov_test_stim_dut_view    inst_list[string];
  static protected      ovm_component                   accessor;

  function new(name="hcw_sciov_test_stim_dut_view");
    int                 int_val;
    bit                 enable_msix_val  = 0;
    bit                 enable_ims_val  = 0;
    int unsigned        num_vdev_val    = 1;
    int unsigned        num_ldb_pp_val  = 0;
    int unsigned        num_dir_pp_val  = 1;

    super.new(name);      
      
    if (accessor.get_config_int("HCW_SCIOV_TEST_NUM_VDEV", int_val)) begin
      num_vdev_val = int_val;
    end

    if (accessor.get_config_int("HCW_SCIOV_TEST_NUM_DIR_PP", int_val)) begin
      num_dir_pp_val = int_val;
    end

    if (accessor.get_config_int("HCW_SCIOV_TEST_NUM_LDB_PP", int_val)) begin
      num_ldb_pp_val = int_val;
    end

    if (accessor.get_config_int("HCW_SCIOV_TEST_ENABLE_IMS", int_val)) begin
      enable_ims_val = int_val;
    end

    if (accessor.get_config_int("HCW_SCIOV_TEST_ENABLE_MSIX", int_val)) begin
      enable_msix_val = int_val;
    end

    enable_msix = enable_msix_val;
    enable_ims  = enable_ims_val;
    num_vdev    = num_vdev_val;
    num_ldb_pp  = num_ldb_pp_val;
    num_dir_pp  = num_dir_pp_val;

  endfunction

endclass
