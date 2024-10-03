class test_hqm_ral_attr_ids_seq extends sla_ral_attr_base_test_seq;
 `ovm_sequence_utils(test_hqm_ral_attr_ids_seq,sla_sequencer)
  //plusargs usage: ie +hraisrfn=hqm_core

  string rfn = "hqm_pf_cfg_i"; //reg_file name
  string dtrbn = "boring"; //don't test register by name

  function new(string name= "test_hqm_ral_attr_ids_seq");
    super.new(name);
    $value$plusargs({"hraisrfn","=%s"}, this.rfn); //reg_file name
    $value$plusargs({"hraisdtrbn","=%s"}, this.dtrbn); //don't test reg by name
    set_sai_gen_mode("LIST",{8'h03}); //allow runtime constraint resolution
  endfunction : new

  // user must override this function to customize for instance to ignore checking
  // "reserved" fields, skip testing some register, or test registers in specific files only.
  virtual function void apply_user_setting();
    sla_ral_file my_reg_file;
    string my_regs_que[$];
    string my_rfn_que[$];


    //add the file you want to test as by default all files are tested
    //add_files_by_name({"ip_file_name"});
  //add_files_by_name({"*hqm_pf_cfg*"}); //Add Register File
    my_rfn_que = {};
    my_rfn_que.push_back(this.rfn);
    add_files_by_name(my_rfn_que); //Add Register File

    //Set Access method for read and write as primary. Keep reset read as backdoor
     set_read_access(sla_iosf_pri_reg_lib_pkg::get_src_type());
     set_write_access(sla_iosf_pri_reg_lib_pkg::get_src_type());
     set_reset_access(sla_iosf_pri_reg_lib_pkg::get_src_type()); //until rtl path is corrected (temporary)
     set_attribute_check(1'b0); //this prevents IOSF errors (temporary)
     sla_ral_env::set_variant_check(1);
     sla_tb_env::set_max_run_clocks(1300000);

   //add the regs you want to test as by default all regs are tested
   //my_regs_que = {};
   //my_regs_que.push_back( "vendor_id" );             //0x000      8086h
   //my_regs_que.push_back( "device_id" );             //0x002      0000h
   //my_regs_que.push_back( "revision_id_class_code" );//0x008 0B40_0000h
   //my_regs_que.push_back( "subsystem_vendor_id" );   //0x02c      8086h
   //my_regs_que.push_back( "subsystem_id" );          //0x02e      0000h
   //my_regs_que.push_back( "msix_cap_id" );           //0x060        11h
   //my_regs_que.push_back( "pcie_cap_id" );           //0x06c        10h
   //my_regs_que.push_back( "pm_cap_id" );             //0x0B0        01h
   //my_regs_que.push_back( "acs_cap_id" );            //0x100      000Dh
   //my_regs_que.push_back( "aer_cap_id" );            //0x148      0001h
   //add_regs_by_name("hqm_pf_cfg_i",my_regs_que,1);

   //my_reg_file = ral.find_file("hqm_pf_cfg_i"); //Find Register File
     my_reg_file = ral.find_file(this.rfn); //Find Register File
     my_reg_file.dontcompare_field_by_name("reserved*"); //ignore checking for reserved fields

    //Don't test any register that metches the pattern "boring"
    my_reg_file.dont_test_reg_by_name(this.dtrbn);


  endfunction : apply_user_setting
endclass : test_hqm_ral_attr_ids_seq
