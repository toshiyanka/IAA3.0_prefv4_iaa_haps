
class test_hqm_ral_attr_ids_seq extends sla_ral_attr_base_test_seq;
 `ovm_sequence_utils(test_hqm_ral_attr_ids_seq,sla_sequencer)

  function new(string name= "test_hqm_ral_attr_ids_seq");
    super.new(name);
  endfunction : new

  // user must override this function to customize for instance to ignore checking
  // "reserved" fields, skip testing some register, or test registers in specific files only.
  virtual function void apply_user_setting();
    //Get IP Register File
    //ip_unit_file ip_file = ral.find_file("ip_file_name");
    sla_ral_file my_file;
    my_file = ral.find_file("hqm_pf_cfg_i");

    //add the file you want to test as by default all files are tested
    //add_files_by_name({"ip_file_name"});
    add_files_by_name({"*hqm_pf_cfg*"});

    //Set Access method for read and write as primary. Keep reset read as backdoor
    set_read_access(sla_iosf_pri_reg_lib_pkg::get_src_type());
    set_write_access(sla_iosf_pri_reg_lib_pkg::get_src_type());

    //Don't test any register that metches the pattern "boring"
    //ip_file.dont_test_reg_by_name("boring");

    //add the regs you want to test as by default all regs are tested
    //add_regs_by_name({"reg_name"});
    //add_regs_by_name("hqm_pf_cfg_i",{"*_id"},1'b1);

    // ignore checking for all reserved fields
    my_file.dontcompare_field_by_name("reserved*");

  endfunction : apply_user_setting
endclass : test_hqm_ral_attr_ids_seq
