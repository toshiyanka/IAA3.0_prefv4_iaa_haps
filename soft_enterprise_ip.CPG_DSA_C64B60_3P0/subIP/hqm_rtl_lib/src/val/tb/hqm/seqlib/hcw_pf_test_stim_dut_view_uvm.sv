class hcw_pf_test_stim_dut_view extends uvm_object;

  `uvm_object_utils(hcw_pf_test_stim_dut_view)

  static function hcw_pf_test_stim_dut_view instance(uvm_component comp=null,string inst_suffix="");
    automatic hcw_pf_test_stim_dut_view inst;

    if(inst_list.exists(inst_suffix)) begin
      inst = inst_list[inst_suffix];
    end else begin
      if(comp == null) begin comp = uvm_root::get(); end 
      if(accessor == null) accessor = comp;

      if(accessor != null) begin
        inst = hcw_pf_test_stim_dut_view::type_id::create("hcw_pf_test_stim_dut_view");
        inst_list[inst_suffix] = inst;
      end else begin
       uvm_top.uvm_report_fatal("hcw_pf_test_stim_dut_view", "No accessor component to retrieve configs through") ;
      end 
    end 

    return inst;
  endfunction

  string        inst_suffix = "";

  // this must be assigned in constructor new
  bit           enable_msix;
  bit           enable_ims_poll;
  bit           enable_wdog_cq;
  int unsigned  num_ldb_pp;
  int unsigned  num_dir_pp;

  static protected      hcw_pf_test_stim_dut_view       inst_list[string];
  static protected      uvm_component                   accessor;

  function new(name="hcw_pf_test_stim_dut_view");
    int                 int_val;
    bit                 enable_msix_val = 0;
    int unsigned        num_ldb_pp_val  = 0;
    int unsigned        num_dir_pp_val  = 1;

    super.new(name);      
      
    if (accessor.get_config_int("HCW_PF_TEST_NUM_DIR_PP", int_val)) begin
      num_dir_pp_val = int_val;
    end 

    if (accessor.get_config_int("HCW_PF_TEST_NUM_LDB_PP", int_val)) begin
      num_ldb_pp_val = int_val;
    end 

    if (accessor.get_config_int("HCW_PF_TEST_ENABLE_MSIX", int_val)) begin
      enable_msix_val = int_val;
    end 

    enable_msix = enable_msix_val;
    num_ldb_pp  = num_ldb_pp_val;
    num_dir_pp  = num_dir_pp_val;

  endfunction

endclass
