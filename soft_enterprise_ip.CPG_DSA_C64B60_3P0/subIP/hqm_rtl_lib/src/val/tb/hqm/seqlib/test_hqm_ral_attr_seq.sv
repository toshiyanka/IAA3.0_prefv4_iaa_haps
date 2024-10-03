import hqm_integ_pkg::*;
class test_hqm_ral_attr_seq extends sla_ral_attr_base_test_seq;
 `ovm_sequence_utils(test_hqm_ral_attr_seq,sla_sequencer)
  //plusargs usage: ie +hraisrfn=hqm_core

  hqm_iosf_prim_checker i_hqm_iosf_prim_checker_obj;
  sla_tb_env  loc_tb_env;
  sla_phase_name_t curr_phase;
  string rfn = "hqm_pf_cfg_i"; //reg_file name
  string dtrbn = "boring"; //don't test register by name
  string dtrbna = "silly"; //don't test register by name atr, sai
  string dtrbnrs3 = "lilly"; //don't test register by name atr & rs3
  string dtrbnrs4 = "flry"; //don't test register by name atr & rs4
  string rgn = "harry"; //first included register name
  string my_HqmIsFeatureReg = ""; //register user attribute
  int rcnt = 0; //count of regisers to be included
  int rdcnt = 0; //down count of registers to be included
  int offs = 0; //segment start offset
  int seg = 0; //segment number if nonzero
  int fin = 0; //expect this to be the final register segment if nonzero
  int fna = 0; //expect this to be the final unimpl. addr. seg if nonzero
  int ffg = 0; //found first register flag
  int fdif = 0; //when found first register flag, while relaod rdcnt=rcnt; and found rdcnt > (mregs_q[].size - n ), this is a bug in Rich's sequence. set fdif=1 to bypass the rdcnt>0 check at the end 
  int ftmp = 0; //found trigger match pattern flag
  int atr = 0; //enable attribute testing (1=frontdoor,2=backdoor,3=valid backdoor)
  int dpatr = 0; //data phase attribute testing (1=frontdoor,2=backdoor,3=valid backdoor)
  int dpuat = 0; //data phase unimplemented address test
  int barf = 0; // for background access, use All Register Files
  int rilb = 0; // Insert Registers that are Intentionally Left Blank
  int uat = 0; // Unimplemented address Attribute Teat
  int sai = 0; //enable sai testing
  int svc = 1; //set variant check
  int pgc = 0; //set policy group check
  int rxc = 0; //set register existance check
  int pth = 0; //check hdl paths
  string saigm = "RAND"; //sai_gen_mode:NONE,RANDC,RAND,LIST,LEGAL,ILLEGAL
  int def = 1; //default value testing (1=frontdoor, 2=backdoor,3=valid backdoor)
  int prdp_def = 0; //post reset data phase def (1=frontdoor, 2=backdoor,3=valid backdoor)
  int recfg_p = 0; //reconfig phase
  int no_recfg_p = 0; //disable reconfig phase if nonzero
  int tsm = 1; //test sequence mode :
  // 0: write followed by read_and_check one register at a time
  // 1: write all registers first, then folowwed by read_and_check for all registers
  // 2: write followed by read_and_check one register at a time.then read_and_check all registers again
  // 4: - randomly pick from available modes
  // 7: - terminate
  int wom = 2; //write_op_mode: inverse, current config, random, constrained random
  // wom:0 =  inverse
  // wom:1 =  current config value
  // wom:2 =  any random value
  // wom:3 =  generate new constrained (legal)  config value
  // wom:4 =  don't care (picks between modes 0-3)
  int wrcnt = 2; //write_count - number of writes for atr and sai
  int restm = 0; //restore_mode: when set, last register write restores original value
  int resetm = 0; //reset_mode: when nonzero, exercise reset test
  int dtpr = 0; //don't test policy registers: when set, policy registers are not tested
  int sbd = 0; //is sideband test
  sla_ral_space_t r_space;
  sla_ral_addr_t  r_addr;
  sla_ral_addr_t  prev_r_addr; //previous value of r_addr
  sla_ral_addr_t  r_spc_addr;
  sla_ral_addr_t  r_spc_base_addr_val;
  sla_ral_addr_t  r_4k_addr;
  sla_ral_addr_t  r_4k_addr_mask = 64'hFFFF_FFFF_FFFF_F000;
  sla_ral_access_path_t primary_id;
  sla_ral_access_path_t backdoor_id;
  sla_ral_reg iregs_q[$]; //include regs queue
  sla_ral_file my_reg_file;
  int no_vpi_msg = 0; //When set to one, suppress check hdl path's no vpi message
  bit my_invalid_path_error = 1'b1;
  bit r_fld_ipth = 1'b0; //register has field without a valid rtl path
  bit my_replace = 1'b1;
  int flr_func_no = 0;
  string my_irgn_q[$]; //include register name queue
  string tg_mtc_rgn_q[$]; //trigger match register name queue
  string tg_mtc_pat = ""; //trigger match pattern
  int    tg_mtc_asz = 0; //trigger match array size
  string str_q[$];
  int    pfvf_space_access; //--anyan: added to support pfvf space tests
  int    pfvf_space_access_seg_adj;

  function new(string name= "test_hqm_ral_attr_seq");
    super.new(name);
    loc_tb_env = sla_tb_env::get_top_tb_env();
    curr_phase = loc_tb_env.get_current_test_phase();
    primary_id = sla_iosf_pri_reg_lib_pkg::get_src_type();
    backdoor_id = "backdoor";
    $value$plusargs({"hraisrfn","=%s"}, this.rfn); //reg_file name
    $value$plusargs({"hraisdtrbn","=%s"}, this.dtrbn); //don't test reg by name
    $value$plusargs({"hraisdtrbna","=%s"}, this.dtrbna); //don't test reg by name atr, sai
    $value$plusargs({"hraisdtrbnrs3","=%s"}, this.dtrbnrs3); //don't test reg by name atr & rs3
    $value$plusargs({"hraisdtrbnrs4","=%s"}, this.dtrbnrs4); //don't test reg by name atr & rs4
    $value$plusargs({"hraiswom","=%d"}, this.wom); // set write op mode
    $value$plusargs({"hraisrgn","=%s"}, this.rgn); //first included register name
    $value$plusargs({"hraisrcnt","=%d"}, this.rcnt); //count of regisers to be included
    $value$plusargs({"hraisseg","=%d"}, this.seg); //segment number
    $value$plusargs({"hraisfin","=%d"}, this.fin); //final register segment
    $value$plusargs({"hraisfna","=%d"}, this.fna); //final uat segment
    $value$plusargs({"hraisatr","=%d"}, this.atr); //attribute testing enable/disable
    $value$plusargs({"hraisbarf","=%d"}, this.barf); //for background use all register files
    $value$plusargs({"hraisrilb","=%d"}, this.rilb); //enable Registers Intentionally Left Blank insertion
    $value$plusargs({"hraisuat","=%d"}, this.uat); //enable Unimplemented Address Register insertion
    dpuat = uat; //remember data phase uat setting
    if(atr != 0) def = 0; //disable default value testing for atr
    dpatr = atr; //save data phase atr value
    $value$plusargs({"hraissai","=%d"}, this.sai); //sai testing enable/disable
    if(sai != 0) def = 0; //disable default value testing for sai
    $value$plusargs({"hraissaigm","=%s"}, this.saigm); //sai generation mode
    $value$plusargs({"hraisdef","=%d"}, this.def); //default value testing enable/disable override
    $value$plusargs({"hraisprdp_def","=%d"}, this.prdp_def); //post reset data phase default value testing
    $value$plusargs({"hraisrecfg_p","=%d"}, this.recfg_p); //reconfig phase
    $value$plusargs({"hraisno_recfg_p","=%d"}, this.no_recfg_p); //disable reconfig phase
    $value$plusargs({"hraissvc","=%d"}, this.svc); //set variant check
    $value$plusargs({"hraispgc","=%d"}, this.pgc); //set policy group check
    $value$plusargs({"hraisrxc","=%d"}, this.rxc); //set register existance check
    $value$plusargs({"hraispth","=%d"}, this.pth); //check hdl paths
    $value$plusargs({"hraistsm","=%d"}, this.tsm); //test sequence mode
    $value$plusargs({"hraisdtpr","=%d"}, this.dtpr); //don't test policy registers
    $value$plusargs({"hraisflrfn","=%d"}, this.flr_func_no); //set flr func_no
    $value$plusargs("HQM_RAL_ACCESS_PATH=%s",primary_id);
    if (ovm_is_match(primary_id,"sideband"))
     begin : is_sbd
      primary_id = iosf_sb_sla_pkg::get_src_type();
      sbd = 1;
     end   : is_sbd
    if(sai != 0 && (ovm_is_match(primary_id,iosf_sb_sla_pkg::get_src_type())))
      begin : sai_is_sb
        wrcnt = 1; //reduce write count for sideband sai to prevent timeout
        restm = 0; //only get one write
      end   : sai_is_sb
    $value$plusargs({"hraisresetm","=%d"}, this.resetm); //reset_mode(do second reset when nonzero)
    $value$plusargs({"hraisrestm","=%d"}, this.restm); //restore mode
    $value$plusargs({"hraiswrcnt","=%d"}, this.wrcnt); //write count for atr & sai testing

    if(resetm != 0 && curr_phase == "DATA_PHASE")
      begin : resetm_nz_dp
        def = 0; //no default value check this phase
        restm = 0; //no restore mode, time for only one write 
        tsm = 0; //write followed by read_and_check one register at a time
        wom = 0; //inverse write operation mode
        wrcnt = 1; //reduce write count to prevent timeout
      end   : resetm_nz_dp

    if(prdp_def != 0 && curr_phase == "POST_RESET_DATA_PHASE")
      begin : nz_prdp
            atr = 0; //don't modify registers
            uat = 0; 
            def = prdp_def; //just do default value check this phase
      end   : nz_prdp

    if(sai == 0) 
      begin : new_sai_is_zero
        set_sai_gen_mode("LIST",{8'h03}); //allow runtime constraint resolution
      end   : new_sai_is_zero
    else
      begin : new_sai_is_zero_not
        set_sai_gen_mode(saigm); 
      end   : new_sai_is_zero_not

    offs = (seg > 0) ? rcnt * (seg -1) : 0; //calculate test segment start offset
    $value$plusargs({"HQM_PFVF_SPACE_ACCESS","=%d"}, this.pfvf_space_access); //anyan: added to support pfvf space tests
    $value$plusargs({"HQM_PFVF_SEG_ADJ","=%d"}, this.pfvf_space_access_seg_adj); //anyan: added to support pfvf space tests seg16 of hqm_system_csr last register
    `ovm_info(get_type_name(),$psprintf("new rfn=%s fin=%0d fna=%0d seg=%0d rcnt=%0d rgn=%s dtrbn=%s dtrbna=%s offs=%0d wrcnt=%0d restm=%0d tsm=%0d wom=%0d ph=%s rilb=%0d pfvf_space_access=%0d",
     rfn,fin,fna,seg,rcnt,rgn,dtrbn,dtrbna,offs,wrcnt,restm,tsm,wom,curr_phase, rilb, pfvf_space_access), OVM_LOW);
  endfunction : new

  //**********************************************************
  // Get colon separated values 
  //**********************************************************
  function get_csv(ref string str_q[$], string s);
      automatic string s1;
      for(int idx = 0; idx < s.len(); idx++) begin
          byte s2;
          s2 = s.getc(idx);
          if(s2 != " ") begin
          if(s2 == ":") begin
              str_q.push_back(s1);
              s1 = "";
          end
          else begin
              s1 = {s1, s2};
              if (idx == (s.len() - 1)) begin
                  str_q.push_back(s1);
              end
          end
          end
      end

  endfunction

  // user must override this function to customize for instance to ignore checking
  // "reserved" fields, skip testing some register, or test registers in specific files only.
  virtual function void apply_user_setting();
    hqm_ral_env hqm_ral;
    sla_ral_addr_t uat_addr_q[$];
    sla_ral_file mfiles_q[$]; //all regfiles queue
    sla_ral_reg mregs_q[$]; //all regs queue
    sla_ral_reg tregs_q[$]; //temporary regs queue
    sla_ral_reg eregs_q[$]; //excluse regs queue
    sla_ral_reg xregs_q[$]; //existance regs queue
    sla_ral_field my_field;
    sla_ral_field my_fields_q[$];
    sla_ral_field gap_field;
    string fpg_a[sla_ral_addr_t]; //feature policy group array
    string my_pg; //policy group
    string rilb_pg; //register intentionally left blank policy group
    string my_rgn; //register name candidate
    string rx_rgn; //register exists register name
    string my_rilbn; //register intentionally left blank name
    string my_rfn; //register file name
    string rx_rfn; //register exists register file name
    string my_rfn_q[$]; //regfile name queus
    string fldn = "zeus"; //field name
    string my_fld_names[$]; //field names
    string my_full_pths[$]; //full paths
    string my_full_pth; //full paths converted to string
    int    uat_size_q[$];
    int    uat_num_rand_addr = 0;
    int    uat_q_isize = 0; //initial uat_q size with uat_num_rand_addr == 0
    int    uat_q_size = 0; //adjusted uat_q size0t_num_rand_addr
    int    pstep = 0; //Positive Address Step (RILB)
    int    nstep = 0; //Negative Address Step (RILB)
    int    my_num_fields; //register number of field
    int    gap_msb; //potential gap msb
    int    gap_lsb; //potential gap lsb
    int    gap_size; //potential gap size
    string gap_name; //potential gap name
    string my_fldn_q[$]; //register field names queus
    int    my_reg_size; //register size
    int    my_fld_size; //register field size
    int    my_fld_lsb; //register field least significant bit
    int    my_fld_msb; //register field most significant bit
    bit    my_fld_vpth; //register field valid rtl path
    bit    uat_gen_istat = 1'b0;
    bit    uat_gen_stat = 1'b0;
    string my_fld_attr; //register field attribute
    string my_fld_reset_signame; //register field reset signal name
    string my_fld_sync_reset_signame; //register field sync reset signal name
    string my_policy_group; //register policy group
    string gap_attr = "RSV"; //register gap attribute
    bit    dtrbn_set;

    //initialize queues
    mfiles_q = {};
    my_rfn_q = {};
    my_rgn = "";

    my_reg_file = ral.find_file(this.rfn); //Find Register File
    $cast(hqm_ral,my_reg_file.get_ral_env());

    //Set Access method
    if(def == 2 || atr == 2 || def == 3 || atr == 3) 
      begin : set_backdoor_id_access
        set_read_access(backdoor_id);
        set_write_access(backdoor_id);
        set_reset_access(backdoor_id);
        //For the bat tests, add the "RW/1C/V" attribute to the exclude_attr array
        //to block backdoor writes to fields with that attribute.
        if(atr == 2 || atr == 3)
          begin : bat_exclude_attr
            hqm_ral.add_exclude_attr("RW/1C/V");
            hqm_ral.add_exclude_attr("RW/1C/V/L");
            hqm_ral.add_exclude_attr("RW/1C/V/P");
            hqm_ral.add_exclude_attr("RW/1S/V");
          end   : bat_exclude_attr
      end   : set_backdoor_id_access
    else
      begin : set_primary_id_access
        set_read_access(primary_id);
        set_write_access(primary_id);
        set_reset_access(primary_id);
      end   : set_primary_id_access
    set_attribute_check((atr != 0) ? 1'b1 : 1'b0);
    set_default_check(  (def != 0) ? 1'b1 : 1'b0);
    set_test_seq_mode(tsm);
    set_restore_mode(restm);
    set_write_count(wrcnt);
    set_write_op_mode(wom);
    sla_ral_env::set_variant_check(svc);
    sla_ral_env::set_sai_check(sai);
    if(atr == 0) set_sai_only_check(sai);

    if(pfvf_space_access==1) 
      sla_tb_env::set_max_run_clocks(0);
    else 
      sla_tb_env::set_max_run_clocks(7700000);

    if(sai !=0 && (ovm_is_match(primary_id,iosf_sb_sla_pkg::get_src_type())))
     begin : set_sb_sai
       sla_tb_env::set_max_run_clocks(0);
     end   : set_sb_sai
    if(dtpr == 1 && (sai != 0 || atr != 0))
     begin : dtpr_is_set
       dont_test_control_policy_regs("HQM_OS_W");
     end   : dtpr_is_set


    if(rcnt == 0)
      begin : entirety
        `ovm_error(get_type_name(),
         $psprintf("zero rcnt not supported  rfn=%s rcnt=%0d",
                                             rfn,   rcnt));
         //add_files_by_name(my_rfn_q); //Add Entire Register File
      end   : entirety

    if(curr_phase == "PRE_RECONFIG_PHASE")
      begin : resetm_model_reset
        my_reg_file = ral.find_file(this.rfn); //Find Register File
        `ovm_info(get_type_name(),
         $psprintf("model_reset rfn=%s resetm=%0d flr=%0d",
                            this.rfn,   resetm,flr_func_no),OVM_LOW);
        if(resetm == 1)
          begin : rs1_model_reset
            reset_agent_prim_checker_obj();
            my_reg_file.reset_regs();
          end   : rs1_model_reset
        if(resetm == 2)
          begin : rs2_model_reset
            reset_agent_prim_checker_obj();
            my_reg_file.reset_regs("WARM");
            for ( int vf = 0; vf < 16; vf++ )
              begin : rs2_vf_lp
                my_reg_file.reset_by_signame($psprintf("hqm_csr_vf_pwr_rst_n[%0d]",vf));
              end   : rs2_vf_lp
          end   : rs2_model_reset
        if(resetm == 3)
          begin : rs3_model_reset
            my_reg_file.reset_regs(,"vcccfn_gated");
          end   : rs3_model_reset
        if(resetm == 4) //FLR
          begin : rs4_model_reset
            if(flr_func_no == 0)
              begin : flr0_model_reset
                //This part for flr0 (function level reset fn(0) )
                mregs_q  = {};
                my_reg_file.get_regs(mregs_q);
                if(ovm_is_match("*pf_cfg*",this.rfn)) 
                  begin : flr0_warm
                    foreach(mregs_q[s])
                      begin : flr0_warm_lp
                        my_rgn = mregs_q[s].get_name();
                        if(ovm_is_match("NONAME",my_rgn))
                          begin : flr0_warm_rewritten
                            `ovm_info(get_type_name(),
                              $psprintf("flr0_rewritten mregs_q[%0d] = %s",
                                s,my_rgn), OVM_LOW);
                          end   : flr0_warm_rewritten
                         else
                          begin : flr0_warm_model_reset
                            mregs_q[s].reset("WARM");
                          end   : flr0_warm_model_reset
                      end   : flr0_warm_lp
                  end   : flr0_warm
                else
                  begin : flr0_warm_not
                    //hqm_iosf CSR fields (all of them) reset by a cold reset,
                    // warm reset, or a PF FLR
                    my_reg_file.reset_by_signame("hqm_csr_mmio_rst_n");
                    my_reg_file.reset_by_signame("hqm_csr_mmio_rst_n powergood_rst_b");
                    //hqm_iosf non-sticky, non-FLR-resistant PF CFG fields
                    // (bulk of PF CFG) reset by a cold reset, warm reset, or PF FLR
                    my_reg_file.reset_by_signame("hqm_csr_pf0_rst_n");
                    my_reg_file.reset_by_signame("hqm_csr_pf0_rst_n hqm_csr_pf0_pwr_rst_n");
                    //hqm_proc fields in the gated power domain
                    // (all except hqm_master) reset by cold reset, warm reset,
                    //a PF FLR, or a D3->D0 
                    my_reg_file.reset_by_signame("hqm_inp_gated_rst_n");
                    my_reg_file.reset_by_signame("hqm_inp_gated_rst_n powergood_rst_b");
                    //hqm_iosf sticky VF CFG fields (like the AER regs) 
                    //reset by a cold reset, warm reset, a PF FLR,
                    //or a VFE 1->0 transition, but not FLR
                    for ( int vf = 0; vf < 16; vf++ )
                      begin : flr0_vf_lp
                        my_reg_file.reset_by_signame($psprintf("hqm_csr_vf_pwr_rst_n[%0d]",vf));
                        my_reg_file.reset_by_signame($psprintf("hqm_csr_vf_rst_n[%0d]",vf));
                      end   : flr0_vf_lp
                  end   : flr0_warm_not
              end   : flr0_model_reset
            else //FLR flr_func_no != 0
              begin : flrnz_model_reset
                //hqm_iosf non-sticky VF CFG fields (bulk of VF CFG)
                //reset by a cold reset, warm reset, a PF FLR, a VF FLR,
                //or a VFE 1->0 transition
                my_reg_file.reset_by_signame($psprintf("hqm_csr_vf_rst_n[%0d]",
                                                             flr_func_no -1));
              end   : flrnz_model_reset
          end   : rs4_model_reset
          tsm = 7; 
          set_test_seq_mode(tsm); //7 - terminate
      end   : resetm_model_reset


     if(pgc != 0 && curr_phase != "PRE_RECONFIG_PHASE")
       begin: policy_group_check
         mfiles_q  = {};
         ral.get_reg_files(mfiles_q);
         foreach(mfiles_q[j])
           begin : pgc_files_lp
             mregs_q  = {};
             mfiles_q[j].get_regs(mregs_q);
             foreach(mregs_q[i])
               begin : pgc_regs_lp
                 my_HqmIsFeatureReg = mregs_q[i].get_user_attribute("HqmIsFeatureReg");
                 my_rgn   = mregs_q[i].get_name();
                 my_rfn   = mregs_q[i].get_file_name();
                 my_pg    = mregs_q[i].get_policy_group();
                 get_r_addr(mregs_q[i]);
                 if(fpg_a.exists(r_4k_addr))
                   begin : r_4k_addr_exists
                     if(fpg_a[r_4k_addr] == my_HqmIsFeatureReg)
                       begin : pgc_ok
                         `ovm_info(get_type_name(),
                           $psprintf("pgc addr=0x%x pg=%s regn=%s.%s space=%s HIFR=%s",
                               r_addr,  my_pg,my_rfn, my_rgn,r_space,my_HqmIsFeatureReg), OVM_LOW);
                       end   : pgc_ok
                     else
                       begin : pgc_nok
                         `ovm_error(get_type_name(),
                            $psprintf("pgc addr=0x%x pg=%s regn=%s.%s space=%s HIFR=%s",
                             r_addr,my_pg,my_rfn,my_rgn,r_space,my_HqmIsFeatureReg));
                       end   : pgc_nok
                   end   : r_4k_addr_exists
                else
                   begin : r_4k_addr_is_new
                     fpg_a[r_4k_addr] = my_HqmIsFeatureReg; 
                     `ovm_info(get_type_name(),
                     $psprintf("pgc addr=0x%x pg=%s regn=%s.%s space=%s HIFR=%s NEW",
                     r_addr,  my_pg,my_rfn, my_rgn,r_space,my_HqmIsFeatureReg), OVM_LOW);
                   end   : r_4k_addr_is_new
               end   : pgc_regs_lp
           end   : pgc_files_lp
       end  : policy_group_check


     if(rxc != 0 && curr_phase != "PRE_RECONFIG_PHASE")
       begin: register_existance_check
         mfiles_q  = {};
         ral.get_reg_files(mfiles_q);
         foreach(mfiles_q[j])
           begin : rxc_files_lp
             mregs_q  = {};
             mfiles_q[j].get_regs(mregs_q);
             foreach(mregs_q[i])
               begin : rxc_regs_lp
                 my_rgn   = mregs_q[i].get_name();
                 my_rfn   = mregs_q[i].get_file_name();
               //my_pg    = mregs_q[i].get_policy_group();
                 //compare to wildcard list & push mregs_q[i]  match to xregs_q 
                //if( ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX*[*]",my_rgn) ||
                  if( ovm_is_match("CFG_QID_LDB_QID2CQIDIX*[*]",my_rgn) ||
                      ovm_is_match("CFG_AQED_QID*[*]",my_rgn)     ||
                      ovm_is_match("CFG_ATM_QID_DPTH_THRSH*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CQ2*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CMP_SN_CHK_ENBL*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CMP_SN_CHK_ENBL*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CQ_DIR_DIS*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CQ_DIR_TOKEN*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CQ_DIR_TOT*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CQ_LDB*[*]",my_rgn)     ||
                      ovm_is_match("CFG_DIR_CQ*[*]",my_rgn)     ||
                      ovm_is_match("CFG_DIR_QID_DPTH_THRS*[*]",my_rgn)     ||
                      ovm_is_match("CFG_VAS_CREDIT_COUN*[*]",my_rgn)     ||
                      ovm_is_match("CFG_HIST_LIST_B*[*]",my_rgn)  ||
                      ovm_is_match("CFG_HIST_LIST_L*[*]",my_rgn)  ||
                      ovm_is_match("CFG_HIST_LIST_P*[*]",my_rgn)  ||
                      ovm_is_match("CFG_LDB_CQ*[*]",my_rgn)     ||
                      ovm_is_match("CFG_LDB_QID_RDYLST_CLAMP*[*]",my_rgn)     ||
                      ovm_is_match("CFG_LDB_VAS*[*]",my_rgn) ||
                      ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX*[*]",my_rgn)     ||
                      ovm_is_match("CFG_NALB_QID_DPTH_THRSH*[*]",my_rgn)     ||
                      ovm_is_match("CFG_ORD_QID_S*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_A*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_DIR*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_LDB_ENQUEUE_COUN*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_LDB_INFLIGHT_*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_LDB_QID2CQIDIX2*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_LDB_REPLAY*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_NALDB*[*]",my_rgn) ||
                      ovm_is_match("DIR_CQ_ADDR_L[*]",my_rgn) ||
                      ovm_is_match("DIR_CQ_ADDR_U[*]",my_rgn) ||
                      ovm_is_match("DIR_PP2VAS[*]",my_rgn) ||
                      ovm_is_match("HQM_DIR_PP2VDEV[*]",my_rgn) ||
                      ovm_is_match("DIR_PP_V[*]",my_rgn) ||
                      ovm_is_match("DIR_CQ2VF_PF_RO[*]",my_rgn) ||
                      ovm_is_match("DIR_CQ_ISR[*]",my_rgn) ||
                      ovm_is_match("DIR_CQ_PASID[*]",my_rgn) ||
                      ovm_is_match("AI_ADDR_L[*]",my_rgn) ||
                      ovm_is_match("AI_ADDR_U[*]",my_rgn) ||
                      ovm_is_match("AI_DATA[*]",my_rgn) ||
                      ovm_is_match("AI_CTRL[*]",my_rgn) ||
                      ovm_is_match("DIR_CQ_FMT[*]",my_rgn) ||
                      ovm_is_match("DIR_QID_V[*]",my_rgn) ||
                      ovm_is_match("DIR_QID_ITS[*]",my_rgn) ||
                      ovm_is_match("DIR_VASQID_V[*]",my_rgn) ||
                      ovm_is_match("LDB_CQ_ADDR_L[*]",my_rgn) ||
                      ovm_is_match("LDB_CQ_ADDR_U[*]",my_rgn) ||
                      ovm_is_match("LDB_PP2VAS[*]",my_rgn) ||
                      ovm_is_match("HQM_LDB_PP2VDEV[*]",my_rgn) ||
                      ovm_is_match("LDB_PP_V[*]",my_rgn) ||
                      ovm_is_match("LDB_CQ2VF_PF_RO[*]",my_rgn) ||
                      ovm_is_match("LDB_CQ_ISR[*]",my_rgn) ||
                      ovm_is_match("LDB_CQ_PASID[*]",my_rgn) ||
                      ovm_is_match("LDB_QID_V[*]",my_rgn) ||
                      ovm_is_match("LDB_QID_ITS[*]",my_rgn) ||
                      ovm_is_match("LDB_QID_CFG_V[*]",my_rgn) ||
                      ovm_is_match("LDB_QID2VQID[*]",my_rgn) ||
                      ovm_is_match("LDB_VASQID_V[*]",my_rgn) ||
                      ovm_is_match("ALARM_VF_SYND0*[*]",my_rgn) ||
                      ovm_is_match("ALARM_VF_SYND1*[*]",my_rgn) ||
                      ovm_is_match("ALARM_VF_SYND2*[*]",my_rgn) ||
                      ovm_is_match("VF_DIR_VPP_V[*]",my_rgn) ||
                      ovm_is_match("VF_DIR_VPP2PP[*]",my_rgn) ||
                      ovm_is_match("VF_DIR_VQID2QID[*]",my_rgn) ||
                      ovm_is_match("VF_DIR_VQID_V[*]",my_rgn) ||
                      ovm_is_match("VF_LDB_VPP_V[*]",my_rgn) ||
                      ovm_is_match("VF_LDB_VPP2PP[*]",my_rgn) ||
                      ovm_is_match("VF_LDB_VQID2QID[*]",my_rgn) ||
                      ovm_is_match("VF_LDB_VQID_V[*]",my_rgn)) 
                   begin : rxc_push_mtc //Verify Register exists and is size 32
                     if(mregs_q[i].get_size() != 32)
                      begin : check_rxc_size
                        `ovm_error(get_type_name(),
                         $psprintf("check_rilb_tmpl_size reg size NE 32 %s.%s %0d",
                                    my_rfn,my_rgn,mregs_q[i].get_size()));
                      end   : check_rxc_size
                     else //my_reg_size == 32
                      begin : rxc_size_is_32
                        //check register testability as was set by rdl
                        if(mregs_q[i].get_test_reg() == 0)
                          begin : rxc_not_testable
                            if(ovm_is_match("CFG_*_CQ_WD_ENB[*]",my_rgn) ||
                               ovm_is_match("CFG_*_CQ_IRQ_PENDING[*]",my_rgn) || 
                               ovm_is_match("CFG_*_CQ_INT_MASK[*]",my_rgn))  
                              begin : rxc_not_testable_warn
                                `ovm_warning(get_type_name(),
                                 $psprintf("rxc_not_testable trigger reg %s.%s is marked as donttest",
                                       my_rfn,my_rgn));
                              end   : rxc_not_testable_warn
                            else
                              begin : rxc_not_testable_err
                                `ovm_error(get_type_name(),
                                 $psprintf("rxc_not_testable trigger reg %s.%s is marked as donttest",
                                       my_rfn,my_rgn));
                              end   : rxc_not_testable_err
                          end   : rxc_not_testable
                        if(eval_reg_ipth(mregs_q[i]) !=0)
                          begin : rxc_ipth
                            `ovm_error(get_type_name(),
                            $psprintf("rxc_ipth reg %s.%s has a field with an invalid RTL path",
                                                 my_rfn,my_rgn));
                          end   : rxc_ipth
                        get_r_addr(mregs_q[i]);
                        `ovm_info(get_type_name(),
                         $psprintf("rxc_trigger_exists %s.%s addr=0x%0x",
                                    my_rfn,my_rgn,r_addr), OVM_NONE);
                      end   : rxc_size_is_32
                      xregs_q.push_back(mregs_q[i]);
                   end   : rxc_push_mtc
                end   : rxc_regs_lp
           end   : rxc_files_lp

           ass_tg_mtc_rgn_q();
           foreach(tg_mtc_rgn_q[w])
              begin : new_tg_mtc_n //w index loop
                tg_mtc_asz = get_array_size_from_trigger_rgn_string(tg_mtc_rgn_q[w]); 
                `ovm_info(get_type_name(),
                  $psprintf("new_tg_mtc_n tg_mtc_rgn_q[%0d]=%s asz=%0d",
                              w,tg_mtc_rgn_q[w],tg_mtc_asz),OVM_LOW);

                //verify that each array member is present
                for (int y = 0; y < tg_mtc_asz; y++)
                  begin : vfy_rxc_reg //y index loop
                    tg_mtc_pat = $psprintf("%s[%0d]",get_mtc_pat_from_rgn_string(tg_mtc_rgn_q[w]),y);
                    ftmp = 0;
                    `ovm_info(get_type_name(),
                     $psprintf("vfy_rxc_reg tg_mtc_rgn_q[%0d]=%s asz=%0d tg_mtc_pat=%s",
                              w,tg_mtc_rgn_q[w],tg_mtc_asz,tg_mtc_pat),OVM_LOW);
                    foreach(xregs_q[x])
                      begin : find_tg_mtc_pat //x index loop
                        rx_rgn   = xregs_q[x].get_name();
                        rx_rfn   = xregs_q[x].get_file_name();
                        if((ovm_is_match(tg_mtc_pat,rx_rgn) && !ovm_is_match("CFG_QID_LDB_QID2CQIDIX_*",tg_mtc_pat)) ||
                           (ovm_is_match(tg_mtc_pat,rx_rgn) &&
                             ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX*",tg_mtc_rgn_q[w]) && ovm_is_match("atm_pipe",rx_rfn)) ||
                           (ovm_is_match(tg_mtc_pat,rx_rgn) &&
                             ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX*",tg_mtc_rgn_q[w]) && ovm_is_match("list_sel_pipe",rx_rfn)))
                          begin : tg_mtc_pat_found
                            ftmp = 1;
                            get_r_addr(xregs_q[x]);
                            `ovm_info(get_type_name(),
                             $psprintf("rxc array_member_found pat %s index=%0d asz=%0d reg=%s.%s addr=0x%0x",
                                                 tg_mtc_pat,y,tg_mtc_asz,rx_rfn,rx_rgn,r_addr),OVM_LOW);
                            if(y != 0)   //skip for first member of array
                              begin : ck_addr_increment
                                if((r_addr - prev_r_addr) != 16'h1000)
                                  begin : rxc_addr_increment_violation
                                    `ovm_error(get_type_name(),
                                    $psprintf("rxc_addr_incr_viol reg=%s.%s addr=0x%0x prev_addr=0x%0x",
                                                 rx_rfn,rx_rgn,r_addr,prev_r_addr));
                                  end   : rxc_addr_increment_violation
                              end   : ck_addr_increment
                            prev_r_addr = r_addr;
                            break; //x found for this y
                          end   : tg_mtc_pat_found
                      end   : find_tg_mtc_pat //x index loop

                      if(ftmp == 0) //no x found for this y
                        begin : array_member_not_found
                          `ovm_error(get_type_name(),
                            $psprintf("rxc array_member_not_found pat %s index=%0d asz=%0d",
                                                 tg_mtc_pat,y,tg_mtc_asz));
                        end   : array_member_not_found
                end   : vfy_rxc_reg //y loop
              end   : new_tg_mtc_n //w index loop
       end  : register_existance_check

     if(rcnt != 0 && curr_phase != "PRE_RECONFIG_PHASE")
       begin: pick_regs
         mfiles_q = {};
         mregs_q  = {};
         iregs_q  = {};
         eregs_q  = {};
         my_irgn_q = {};
         add_regs_by_name(this.rfn,my_irgn_q,my_replace); //clear register selections.
         `ovm_info(get_type_name(),
          $psprintf("pick_regs def=%0d dpatr=%0d barf=%0d rcnt=0x%x rgn=%s.%s",
                               def,    dpatr,    barf,    rcnt, rfn,rgn), OVM_LOW);
         if((atr==3 || def == 3) && barf != 0)
          begin: pick_all_reg_files
            no_vpi_msg = 1; //suppress vpi msg of check_hdl_paths
            ral.get_reg_files(mfiles_q);
          //ral.get_reg_files(mfiles_q,hqm_ral); //get all reg files
          end  : pick_all_reg_files
         else
          begin: pick_one_reg_file
            no_vpi_msg = 0; //don't suppress vpi msg of check_hdl_paths
            my_reg_file = ral.find_file(this.rfn); //Find Register File
            mfiles_q.push_back(my_reg_file);
          end  : pick_one_reg_file

         foreach(mfiles_q[k])
          begin : pick_files_lp
           tregs_q  = {};
           mfiles_q[k].get_regs(tregs_q); //tentatively, get all regs
           foreach(tregs_q[t])
            begin : exclude_non_sb_MSGs
              if(sbd != 0 || !ovm_is_match("MSG",tregs_q[t].get_space()))
                begin : include_non_sb_MSG
                  mregs_q.push_back(tregs_q[t]);
                end   : include_non_sb_MSG
            end   : exclude_non_sb_MSGs
          end   : pick_files_lp

         `ovm_info(get_type_name(),$psprintf("Total registers = %d ", mregs_q.size()),OVM_LOW);
                   
         if(uat > 0)
          begin : gen_uat
            my_rfn      = mregs_q[0].get_file_name();
            my_reg_file = ral.find_file(my_rfn); //Find Register File
            if(this.dtrbn != "boring") begin
              get_csv(str_q, this.dtrbn);
              foreach(str_q[i]) begin
                my_reg_file.dont_test_reg_by_name(str_q[i]); 
              end

              my_reg_file.get_regs(mregs_q);
            end    

            my_rgn      = mregs_q[0].get_name();
            uat_addr_q = {};
            uat_size_q = {};
            uat_gen_istat = hqm_ral.gen_unimp_addresses(my_rfn,uat_num_rand_addr,uat_addr_q,uat_size_q);
            uat_q_isize = uat_addr_q.size();
            if(uat_q_isize < offs + rcnt)
             begin : adjust_uat_q_size
               uat_addr_q = {};
               uat_size_q = {};
               uat_num_rand_addr = offs + rcnt - uat_q_isize;
               uat_gen_stat = hqm_ral.gen_unimp_addresses(my_rfn,uat_num_rand_addr,uat_addr_q,uat_size_q);
               uat_q_size = uat_addr_q.size();
             end   : adjust_uat_q_size
            else
             begin : ok_uat_q_size
               uat_q_size = uat_q_isize;
               uat_gen_stat = uat_gen_istat;
               if(fna != 0) //Last expected segment unadjusted for this regfile
                begin : gen_uat_not_fna
                  `ovm_error(get_type_name(),
                    $psprintf("unimp_addr incomplete rfn=%s seg=%0d fna=%0d ista=%0d isz=0x%0x offs=0x%0x rcnt=0x%0x rand=0x%0x", 
                     my_rfn,seg,fna,uat_gen_istat,uat_q_isize,offs,rcnt,uat_num_rand_addr));
                end   : gen_uat_not_fna
             end   : ok_uat_q_size
            `ovm_info(get_type_name(),
             $psprintf("gen_uat rfn=%s seg=%0d fna=%0d ista=%0d sta=%0d rand=0x%0x isz=0x%0x sz=0x%0x offs=0x%0x rcnt=0x%0x",
              my_rfn,seg,fna,uat_gen_istat,uat_gen_stat,uat_num_rand_addr,
              uat_q_isize,uat_q_size,offs,rcnt), OVM_LOW);

              foreach(uat_addr_q[u])
                begin : pick_uats_lp
                  if(seg >0 && offs-- == 0 && ffg == 0) //skip through prior segments
                    begin : found_first_uat
                      rdcnt = rcnt;
                      ffg = 1; //set found first flag
                    end   : found_first_uat
                   if(rdcnt != 0)
                    begin : include_uat
                      rdcnt--;
                     `ovm_info(get_type_name(),$psprintf("DEBUG_include_uat:: rdcnt=%0d def=%0d atr=%0d rcnt=0x%0x rilb=%0d", rdcnt, def, atr, rcnt, rilb),OVM_LOW);
                      my_rilbn = $psprintf("UAT_0x%0x",uat_addr_q[u]); 
                      add_new_rilb(my_rfn,my_rgn,my_rilbn,uat_addr_q[u],uat_size_q[u]);
                    end   : include_uat
                end   : pick_uats_lp
              if (fna == 0 && rdcnt > 0 && uat != 0)
               begin : unfinished_uats
                 `ovm_error(get_type_name(), $psprintf("pick_uats unfinished rdcnt = %d", rdcnt));
               end   : unfinished_uats

              if (my_irgn_q.size() == 0 && uat != 0)
               begin : no_uats_included
                 `ovm_error(get_type_name(), $psprintf("gen_uat  no_uats_included rfn = %s", my_rfn));
                 tsm = 7; 
                 set_test_seq_mode(tsm); //7 - terminate
               end   : no_uats_included
          end   : gen_uat
        else //uat <= 0
         begin : do_pick_regs_lp
          `ovm_info(get_type_name(),$psprintf("DEBUG_do_pick_regs_lp_start:: seg=%0d fna=%0d uat=%0d; offs=%0d barf=%0d atr=%0d def=%0d; rdcnt=0x%0x rcnt=0x%0x mregs_q.size=%0d", seg, fna, uat, offs, barf, atr, def, rdcnt, rcnt, mregs_q.size()),OVM_LOW);
          foreach(mregs_q[i])
           begin : pick_regs_lp
              my_rfn = mregs_q[i].get_file_name();
              my_reg_file = ral.find_file(my_rfn); //Find Register File
              my_rgn      = mregs_q[i].get_name();
              r_space    = mregs_q[i].get_space();
              r_spc_addr = mregs_q[i].get_space_addr(r_space);
              my_pg     = mregs_q[i].get_policy_group();
              r_spc_base_addr_val = mregs_q[i].get_base_addr_val(r_space);
              my_reg_size = mregs_q[i].get_size();

              //print out a list of all register names in regfile
              if(barf != 0 && (atr == 3 || def == 3))
                begin : pickregs_print_all_regs
                  `ovm_info(get_type_name(),
                   $psprintf("pick_regs mregs_q[%0d]=%s.%s rdcnt=%0d barf=%0d atr=%0d def=%0d",
                                                 i,my_rfn,my_rgn, rdcnt, barf, atr, def), OVM_HIGH);
                end   : pickregs_print_all_regs
               else
                begin : pickregs_print_all_regs_in_regfile
                  `ovm_info(get_type_name(),
                   $psprintf("pick_regs mregs_q[%0d]=%s.%s rdcnt=%0d barf=%0d atr=%0d def=%0d",
                                                 i,my_rfn,my_rgn, rdcnt, barf, atr, def), OVM_LOW);
                end   : pickregs_print_all_regs_in_regfile
              
              //when seg==0 start with register name rather than offset countdown
              if( (seg == 0 && ovm_is_match(this.rgn,my_rgn)) ||
                  (seg >0 && offs-- == 0 && ffg == 0) ) //skip through prior segments
                begin : found_first_reg
                  rdcnt = rcnt;
                  ffg = 1; //set found first register flag

                  //--setting fdif=1 to fix Rich's seq bug
                  //--there is a case that when meeting ffg=1 condition and rdcnt reloaded, the number of rest regs to process (mregs_q.size() - i) is less than rdcnt
                  //--this causes the failure in unfinished_regs checking
                  //--set fdif=1 to bypass the checking in unfinished_regs
                  if(rdcnt > (mregs_q.size() - i))  
                    begin: bug_fix_rdcnt
                      fdif = 1;  //set to bypass rdcnt>0 check at end                         
                    end   : bug_fix_rdcnt
                   `ovm_info(get_type_name(),$psprintf("DEBUG_found_first_reg:: seg=%0d fna=%0d uat=%0d; fdif=%0d offs=%0d rdcnt=0x%0x rcnt=0x%0x ffg=1", seg, fna, uat, fdif, offs, rdcnt, rcnt),OVM_LOW);
                end   : found_first_reg

              if(rdcnt != 0 || (barf != 0 && (atr == 3 || def == 3))) 
                 r_fld_ipth = eval_reg_ipth(mregs_q[i]);

              //Process all regs in all regfiles for background barf
              if(rdcnt != 0 || (barf != 0 && (def == 3 || atr == 3)))
                begin : include_reg
                  rdcnt--;

                  //Some patterns in this list are preceeded with X,P or M
                  //for exclude, positive only & negative only instead of 4pm
                  //(The prefixes prevent matches in this trigger list)
                  //The prefixes were added to the original trigger match list
                  //because the offset addresses are otherwise intentionally occupied.
                //if((ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX*[*]",my_rgn) ||
                  if((ovm_is_match("CFG_QID_LDB_QID2CQIDIX*[*]",my_rgn) ||
                      ovm_is_match("CFG_AQED_QID*[*]",my_rgn)     ||
                      ovm_is_match("CFG_ATM_QID_DPTH_THRSH*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CQ2*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CMP_SN_CHK_ENBL*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CMP_SN_CHK_ENBL*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CQ_DIR_DIS*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CQ_DIR_TOKEN*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CQ_DIR_TOT*[*]",my_rgn)     ||
                      ovm_is_match("CFG_CQ_LDB*[*]",my_rgn)     ||
                      ovm_is_match("CFG_DIR_CQ*[*]",my_rgn)     ||
                      ovm_is_match("CFG_DIR_QID_DPTH_THRS*[*]",my_rgn)     ||
                      ovm_is_match("CFG_VAS_CREDIT_COUN*[*]",my_rgn)     ||
                      ovm_is_match("CFG_HIST_LIST_B*[*]",my_rgn)  ||
                      ovm_is_match("CFG_HIST_LIST_L*[*]",my_rgn)  ||
                      ovm_is_match("CFG_HIST_LIST_P*[*]",my_rgn)  ||
                      ovm_is_match("CFG_LDB_CQ*[*]",my_rgn)     ||
                      ovm_is_match("CFG_LDB_QID_RDYLST_CLAMP*[*]",my_rgn)     ||
                      ovm_is_match("CFG_LDB_VAS*[*]",my_rgn) ||
                      ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX*[*]",my_rgn)     ||
                      ovm_is_match("CFG_NALB_QID_DPTH_THRSH*[*]",my_rgn)     ||
                      ovm_is_match("CFG_ORD_QID_S*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_A*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_DIR*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_LDB_ENQUEUE_COUN*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_LDB_INFLIGHT_*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_LDB_QID2CQIDIX2*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_LDB_REPLAY*[*]",my_rgn)     ||
                      ovm_is_match("CFG_QID_NALDB*[*]",my_rgn) ||
                      ovm_is_match("MDIR_CQ_ADDR_L[*]",my_rgn) ||
                      ovm_is_match("XDIR_CQ_ADDR_U[*]",my_rgn) ||
                      ovm_is_match("XDIR_PP2VAS[*]",my_rgn) ||
                      ovm_is_match("XHQM_DIR_PP2VDEV[*]",my_rgn) ||
                      ovm_is_match("XDIR_PP_V[*]",my_rgn) ||
                      ovm_is_match("XDIR_CQ2VF_PF_RO[*]",my_rgn) ||
                      ovm_is_match("XDIR_CQ_ISR[*]",my_rgn) ||
                      ovm_is_match("XDIR_CQ_PASID[*]",my_rgn) ||
                      ovm_is_match("XAI_ADDR_L[*]",my_rgn) ||
                      ovm_is_match("XAI_ADDR_U[*]",my_rgn) ||
                      ovm_is_match("XAI_DATA[*]",my_rgn) ||
                      ovm_is_match("XAI_CTRL[*]",my_rgn) ||
                      ovm_is_match("PDIR_CQ_FMT[*]",my_rgn) ||
                      ovm_is_match("MDIR_QID_V[*]",my_rgn) ||
                      ovm_is_match("PDIR_QID_ITS[*]",my_rgn) ||
                      ovm_is_match("PDIR_VASQID_V[*]",my_rgn) ||
                      ovm_is_match("MLDB_CQ_ADDR_L[*]",my_rgn) ||
                      ovm_is_match("XLDB_CQ_ADDR_U[*]",my_rgn) ||
                      ovm_is_match("XLDB_PP2VAS[*]",my_rgn) ||
                      ovm_is_match("XHQM_LDB_PP2VDEV[*]",my_rgn) ||
                      ovm_is_match("XLDB_PP_V[*]",my_rgn) ||
                      ovm_is_match("XLDB_CQ2VF_PF_RO[*]",my_rgn) ||
                      ovm_is_match("XLDB_CQ_ISR[*]",my_rgn) ||
                      ovm_is_match("XLDB_CQ_PASID[*]",my_rgn) ||
                      ovm_is_match("MLDB_QID_V[*]",my_rgn) ||
                      ovm_is_match("XLDB_QID_ITS[*]",my_rgn) ||
                      ovm_is_match("PLDB_QID_CFG_V[*]",my_rgn) ||
                      ovm_is_match("XLDB_QID2VQID[*]",my_rgn) ||
                      ovm_is_match("XLDB_VASQID_V[*]",my_rgn) ||
                      ovm_is_match("MALARM_VF_SYND0*[*]",my_rgn) ||
                      ovm_is_match("XALARM_VF_SYND1*[*]",my_rgn) ||
                      ovm_is_match("PALARM_VF_SYND2*[*]",my_rgn) ||
                      ovm_is_match("XVF_DIR_VPP_V[*]",my_rgn) ||
                      ovm_is_match("XVF_DIR_VPP2PP[*]",my_rgn) ||
                      ovm_is_match("XVF_DIR_VQID2QID[*]",my_rgn) ||
                      ovm_is_match("XVF_DIR_VQID_V[*]",my_rgn) ||
                      ovm_is_match("MVF_LDB_VPP_V[*]",my_rgn) ||
                      ovm_is_match("XVF_LDB_VPP2PP[*]",my_rgn) ||
                      ovm_is_match("XVF_LDB_VQID2QID[*]",my_rgn) ||
                      ovm_is_match("XVF_LDB_VQID_V[*]",my_rgn))
                                          && rilb > 1 && def <2 && atr <2)
                   begin : add_rilb_4pm //Insert Register Intentionally Left Blank
                     `ovm_info(get_type_name(),$psprintf("DEBUG_add_rilb_4pm:: rdcnt=%0d  def=%0d atr=%0d rcnt=0x%0x rilb=%0d", rdcnt,  def, atr, rcnt, rilb),OVM_LOW);
                     my_rilbn = {"RILB4P_",my_rgn}; 
                     add_new_rilb(my_rfn,my_rgn,my_rilbn,0,0,4);
                     my_rilbn = {"RILB4M_",my_rgn}; 
                     add_new_rilb(my_rfn,my_rgn,my_rilbn,0,0,0,4);
                     get_r_addr(mregs_q[i]);
                     if(r_addr != r_4k_addr)
                       begin : add_rilb_4pm_4kerr
                         `ovm_error(get_type_name(),
                            $psprintf("add_rilb_4pm_4kerr addr=0x%x regn=%s.%s space=%s",
                             r_addr,my_rfn,my_rgn,r_space));
                       end   : add_rilb_4pm_4kerr
                   end   : add_rilb_4pm

                  if((ovm_is_match("DIR_CQ_ADDR_L[*]",my_rgn) ||
                      ovm_is_match("LDB_CQ_ADDR_L[*]",my_rgn) ||
                      ovm_is_match("LDB_QID_V[*]",my_rgn) ||
                      ovm_is_match("ALARM_VF_SYND0*[*]",my_rgn) ||
                      ovm_is_match("VF_LDB_VPP_V[*]",my_rgn))
                                          && rilb > 1 && def <2 && atr <2)
                   begin : add_rilb_4m //Insert Register Intentionally Left Blank
                     `ovm_info(get_type_name(),$psprintf("DEBUG_add_rilb_4m:: rdcnt=%0d  def=%0d atr=%0d rcnt=0x%0x rilb=%0d", rdcnt, def, atr, rcnt, rilb),OVM_LOW);
                     my_rilbn = {"RILB4M_",my_rgn}; 
                     add_new_rilb(my_rfn,my_rgn,my_rilbn,0,0,0,4);
                //   get_r_addr(mregs_q[i]);
                //These didn't pass, and then were deemed as not necessary
                //   if(r_addr != r_4k_addr)
                //     begin : add_rilb_4m_4kerr
                //       `ovm_error(get_type_name(),
                //         $psprintf("add_rilb_4m_4kerr addr=0x%x regn=%s.%s space=%s",
                //           r_addr,my_rfn,my_rgn,r_space));
                //     end   : add_rilb_4m_4kerr
                   end   : add_rilb_4m

                  if((ovm_is_match("DIR_CQ_FMT[*]",my_rgn) ||
                      ovm_is_match("DIR_QID_ITS[*]",my_rgn) ||
                      ovm_is_match("DIR_VASQID_V[*]",my_rgn) ||
                      ovm_is_match("LDB_QID_CFG_V[*]",my_rgn) ||
                      ovm_is_match("AI_DATA[*]",my_rgn) ||
                      ovm_is_match("ALARM_VF_SYND2[*]",my_rgn))
                                          && rilb > 1 && def <2 && atr <2)
                   begin : add_rilb_4p //Insert Register Intentionally Left Blank
                     `ovm_info(get_type_name(),$psprintf("DEBUG_add_rilb_4p:: rdcnt=%0d def=%0d atr=%0d rcnt=0x%0x rilb=%0d", rdcnt, def, atr, rcnt, rilb),OVM_LOW);
                     my_rilbn = {"RILB4P_",my_rgn}; 
                     add_new_rilb(my_rfn,my_rgn,my_rilbn,0,0,4);
                   end   : add_rilb_4p

                  if((ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX*[31]",my_rgn) ||
                      ovm_is_match("CFG_AQED_QID*[31]",my_rgn)     ||
                      ovm_is_match("CFG_ATM_QID_DPTH_THRSH*[31]",my_rgn)     ||
                      ovm_is_match("CFG_CQ2*[63]",my_rgn)     ||
                      ovm_is_match("CFG_CMP_SN_CHK_ENBL*[63]",my_rgn)     ||
                      ovm_is_match("CFG_CMP_SN_CHK_ENBL*[63]",my_rgn)     ||
                      ovm_is_match("CFG_CQ_DIR_DIS*[95]",my_rgn)     ||
                      ovm_is_match("CFG_CQ_DIR_TOKEN*[95]",my_rgn)     ||
                      ovm_is_match("CFG_CQ_DIR_TOT*[95]",my_rgn)     ||
                      ovm_is_match("CFG_CQ_LDB*[63]",my_rgn)     ||
                      ovm_is_match("CFG_DIR_CQ*[95]",my_rgn)     ||
                      ovm_is_match("CFG_DIR_QID_DPTH_THRS*[95]",my_rgn)     ||
                      ovm_is_match("CFG_VAS_CREDIT_COUN*[31]",my_rgn)     ||
                      ovm_is_match("CFG_HIST_LIST_B*[63]",my_rgn)  ||
                      ovm_is_match("CFG_HIST_LIST_L*[63]",my_rgn)  ||
                      ovm_is_match("CFG_HIST_LIST_P*[63]",my_rgn)  ||
                      ovm_is_match("CFG_LDB_CQ*[63]",my_rgn)     ||
                      ovm_is_match("CFG_LDB_QID_RDYLST_CLAMP*[31]",my_rgn)     ||
                      ovm_is_match("CFG_LDB_VAS*[31]",my_rgn) ||
                      ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX*[31]",my_rgn)     ||
                      ovm_is_match("CFG_NALB_QID_DPTH_THRSH*[31]",my_rgn)     ||
                      ovm_is_match("CFG_ORD_QID_S*[31]",my_rgn)     ||
                      ovm_is_match("CFG_QID_A*[31]",my_rgn)     ||
                      ovm_is_match("CFG_QID_DIR_ENQUEUE_COUNT[95]",my_rgn)     ||
                      ovm_is_match("CFG_QID_DIR_MAX_DEPTH[95]",my_rgn)     ||
                      ovm_is_match("CFG_QID_DIR_TOT_ENQ_CNTH[95]",my_rgn)     ||
                      ovm_is_match("CFG_QID_DIR_TOT_ENQ_CNTL[95]",my_rgn)     ||
                      ovm_is_match("CFG_QID_DIR_REPLAY_COUNT[31]",my_rgn)     ||
                      ovm_is_match("CFG_QID_LDB_ENQUEUE_COUN*[31]",my_rgn)     ||
                      ovm_is_match("CFG_QID_LDB_INFLIGHT_*[31]",my_rgn)     ||
                      ovm_is_match("CFG_QID_LDB_QID2CQIDIX2*[31]",my_rgn)     ||
                      ovm_is_match("CFG_QID_LDB_REPLAY*[31]",my_rgn)     ||
                      ovm_is_match("CFG_QID_NALDB*[31]",my_rgn) ||
                      ovm_is_match("DIR_CQ_ADDR_L[95]",my_rgn) ||
                      ovm_is_match("DIR_CQ_ADDR_U[95]",my_rgn) ||
                      ovm_is_match("DIR_PP2VAS[95]",my_rgn) ||
                      ovm_is_match("HQM_DIR_PP2VDEV[95]",my_rgn) ||
                      ovm_is_match("DIR_PP_V[95]",my_rgn) ||
                      ovm_is_match("DIR_CQ2VF_PF_RO[95]",my_rgn) ||
                      ovm_is_match("DIR_CQ_ISR[95]",my_rgn) ||
                      ovm_is_match("DIR_CQ_PASID[95]",my_rgn) ||
                      ovm_is_match("AI_ADDR_L[159]",my_rgn) ||
                      ovm_is_match("AI_ADDR_U[159]",my_rgn) ||
                      ovm_is_match("AI_DATA[159]",my_rgn) ||
                      ovm_is_match("AI_CTRL[159]",my_rgn) ||
                      ovm_is_match("DIR_CQ_FMT[95]",my_rgn) ||
                      ovm_is_match("DIR_QID_V[95]",my_rgn) ||
                      ovm_is_match("DIR_QID_ITS[95]",my_rgn) ||
                      ovm_is_match("DIR_VASQID_V[3071]",my_rgn) ||
                      ovm_is_match("LDB_CQ_ADDR_L[63]",my_rgn) ||
                      ovm_is_match("LDB_CQ_ADDR_U[63]",my_rgn) ||
                      ovm_is_match("LDB_PP2VAS[63]",my_rgn) ||
                      ovm_is_match("HQM_LDB_PP2VDEV[63]",my_rgn) ||
                      ovm_is_match("LDB_PP_V[63]",my_rgn) ||
                      ovm_is_match("LDB_CQ2VF_PF_RO[63]",my_rgn) ||
                      ovm_is_match("LDB_CQ_ISR[63]",my_rgn) ||
                      ovm_is_match("LDB_CQ_PASID[63]",my_rgn) ||
                      ovm_is_match("LDB_QID_V[31]",my_rgn) ||
                      ovm_is_match("LDB_QID_ITS[31]",my_rgn) ||
                      ovm_is_match("LDB_QID_CFG_V[31]",my_rgn) ||
                      ovm_is_match("LDB_QID2VQID[31]",my_rgn) ||
                      ovm_is_match("LDB_VASQID_V[1023]",my_rgn) ||
                      ovm_is_match("ALARM_VF_SYND*[15]",my_rgn) ||
                      ovm_is_match("VF_DIR_VPP_V[1535]",my_rgn) ||
                      ovm_is_match("VF_DIR_VPP2PP[1535]",my_rgn) ||
                      ovm_is_match("VF_DIR_VQID2QID[1535]",my_rgn) ||
                      ovm_is_match("VF_DIR_VQID_V[1535]",my_rgn) ||
                      ovm_is_match("VF_LDB_VPP_V[1023]",my_rgn) ||
                      ovm_is_match("VF_LDB_VPP2PP[1023]",my_rgn) ||
                      ovm_is_match("VF_LDB_VQID2QID[511]",my_rgn) ||
                      ovm_is_match("VF_LDB_VQID_V[511]",my_rgn))
                                          && rilb !=0 && def <2 && atr <2)
                   begin : add_rilb_1kp //Insert Register Intentionally Left Blank
                     `ovm_info(get_type_name(),$psprintf("DEBUG_add_rilb_1kp:: rdcnt=%0d def=%0d atr=%0d rcnt=0x%0x rilb=%0d", rdcnt, def, atr, rcnt, rilb),OVM_LOW);
                     my_rilbn = {"RILB1kP_",my_rgn}; 
                     add_new_rilb(my_rfn,my_rgn,my_rilbn,0,0,16'h1000);
                   end   : add_rilb_1kp

                  //should register be excluded?
                  if((r_fld_ipth == 1'b1 && (def > 1 || atr > 1)) ||
                     (ovm_is_match("CFG_DIAGNOSTIC_STATUS_1",my_rgn) && dpatr != 0 && def != 0) || 
                     (ovm_is_match("CFG_INTERFACE_STATUS",my_rgn) && dpatr > 1 && def == 1) || 
                     (ovm_is_match("CFG_INTERFACE_STATUS",my_rgn) && def == 3) || 
                     (ovm_is_match("*CFG_DIAGNOSTIC_STATUS*",my_rgn) && barf != 0 && dpuat != 0) ||
                     (ovm_is_match("ALARM_ERR",my_rgn) && barf != 0 && dpuat != 0) ||
                     (ovm_is_match("ALARM_HW_SYND",my_rgn) && barf != 0 && dpuat != 0) ||
                    ((ovm_is_match(dtrbna,my_rgn) ||
                     (ovm_is_match(dtrbnrs3,my_rgn) && resetm == 3) ||
                     (ovm_is_match(dtrbnrs4,my_rgn) && resetm == 4) ||
                     (ovm_is_match("*CFG_*WMSTAT*",my_rgn) && get_write_op_mode() != 0) ||
                     (ovm_is_match("*MMIO_TIMEOUT*",my_rgn) && get_write_op_mode() != 0) ||
                     (ovm_is_match("*CFG_MASTER_TIMEOUT*",my_rgn) && get_write_op_mode() != 0) ||
                     (ovm_is_match("*CFG_MSTR_DIAGNOSTIC_STATUS*",my_rgn) && svc == 1)  ||
                     (ovm_is_match("*CFG_LDB_SCHED_CONTROL*",my_rgn) && svc == 1)  ||
                     (ovm_is_match("*WBUF_LDB_RESET*",my_rgn) && svc == 1)  ||
                      ovm_is_match("*CDC_CTL",my_rgn) ||
                      ovm_is_match("*CFG_DIAGNOSTIC_STATUS_1*",my_rgn) ||
                      ovm_is_match("*IOSF*CGCTL*",my_rgn) ||
                      ovm_is_match("*CONTROL_GENERAL*",my_rgn) ||
                      ovm_is_match("*PCIE_CAP_DEVICE_CONTROL",my_rgn) ||
                      ovm_is_match("*PM_CAP_CONTROL_STATUS*",my_rgn) ||
                      ovm_is_match("*PARITY_CTL*",my_rgn) ||
                      ovm_is_match("*R_INJEC*",my_rgn) ||
                      ovm_is_match("*RESET*START*",my_rgn) ||
                      ovm_is_match("*RESET_UNIT_STAT*",my_rgn) ||
                      ovm_is_match("*HPTR_UPDATE*",my_rgn) ||
                      ovm_is_match("*TPTR_UPDATE*",my_rgn) ||
                      ovm_is_match("*TAILPTR_UPDATE*",my_rgn) ||
                      ovm_is_match("*CFG_HBM_RING_TPTR*",my_rgn) ||
                      ovm_is_match("*CFG_DIAGNOSTIC_AW_STATUS*",my_rgn) ||
                      ovm_is_match("*SMON*CONFIGURATION0*",my_rgn)) && (atr != 0 || sai != 0)))
                    begin : dtrbna_mtc
                      eregs_q.push_back(mregs_q[i]);
                      `ovm_info(get_type_name(),
                      $psprintf("pick_regs excludes=%s.%s ipth=%0d",
                                  my_rfn,my_rgn,r_fld_ipth), OVM_NONE);
                    end   : dtrbna_mtc
                    else if(this.dtrbn != "boring" && dtrbn_set == 0) 
                    begin : dtrbn_mtc
                      //Logic to exclude multiple registers
                      get_csv(str_q, this.dtrbn);
                      foreach(str_q[i]) begin
                        my_reg_file.dont_test_reg_by_name(str_q[i]); 
                        `ovm_info(get_type_name(),$psprintf("pick_regs excludes=%s",str_q[i]), OVM_DEBUG);
                      end
                      my_reg_file.get_regs(mregs_q);
                      dtrbn_set = 1;
                   end : dtrbn_mtc 
                   else if(rilb == 0)
                    begin : do_include
                      my_num_fields = mregs_q[i].get_num_fields;
                      my_reg_size = mregs_q[i].get_size();
                      my_policy_group = mregs_q[i].get_policy_group();
                      my_fields_q = {};
                      mregs_q[i].get_fields(my_fields_q);
                      if(atr !=0 && uat == 0) //facilitate empty field atttribute checks
                        begin : do_mpt_fld_lp
                          gap_lsb = 0;
                          foreach(my_fields_q[j])
                           begin : mpt_fld_lp
                             my_fld_vpth = my_fields_q[j].check_hdl_paths(no_vpi_msg);
                             my_fld_attr = my_fields_q[j].get_attr();
                             my_fld_lsb  = my_fields_q[j].get_lsb();
                             my_fld_reset_signame = my_fields_q[j].get_reset_signame();
                             my_fld_sync_reset_signame = my_fields_q[j].get_sync_reset_signame();
                             my_fld_size = my_fields_q[j].get_size();
                             if(my_fld_lsb > gap_lsb)
                            begin : leading_gap
                              gap_size = my_fld_lsb - gap_lsb;
                              gap_name =  $psprintf("gap%0d",gap_lsb);
                             `ovm_info(get_type_name(),
                               $psprintf("leading_gap %s.%s.%s size=%0d lsb=%0d attr=RSV",
                                my_rfn,my_rgn,gap_name,gap_size,gap_lsb), OVM_NONE);
                              gap_field = new(gap_name,"RSV",gap_size,gap_lsb);
                              mregs_q[i].add_field(gap_field);
                            end   : leading_gap
         
                             `ovm_info(get_type_name(),
                               $psprintf("mpt_fld_lp %s.[%0d] size=%0d lsb=%0d attr=%s vp=%0d, rs=%s srs=%s",
                                my_rgn,j,my_fld_size,my_fld_lsb,my_fld_attr,my_fld_vpth,my_fld_reset_signame,my_fld_sync_reset_signame), OVM_NONE);
                              gap_lsb = my_fld_lsb + my_fld_size;
                           end   : mpt_fld_lp
                           if(gap_lsb < my_reg_size -1)
                            begin : trailing_gap
                              gap_size = my_reg_size - gap_lsb;
                              gap_name =  $psprintf("gap%0d",gap_lsb);
                             `ovm_info(get_type_name(),
                               $psprintf("trailing_gap %s.%s.%s size=%0d lsb=%0d attr=RSV",
                               my_rfn,my_rgn,gap_name,gap_size,gap_lsb), OVM_NONE);
                              gap_field = new(gap_name,"RSV",gap_size,gap_lsb);
                              mregs_q[i].add_field(gap_field);
                            end   : trailing_gap
                        end   : do_mpt_fld_lp

                      if(rilb == 0)
                       begin : push_reg_to_iregs_q
                         iregs_q.push_back(mregs_q[i]);
                         my_irgn_q.push_back(my_rgn);
                       end   : push_reg_to_iregs_q
                      if(barf != 0 && (atr == 3 || def == 3) && rilb == 0)
                       begin: pick_regs_print_included
                         `ovm_info(get_type_name(),
                          $psprintf("pick_regs includes %s.%s size=%0d num_fields=%0d pg=%s spc=%s sbav=0x%0x spc_addr=0x%0x",
                             my_rfn,my_rgn,my_reg_size,my_num_fields,my_policy_group,r_space,r_spc_base_addr_val,r_spc_addr), OVM_HIGH);
                       end  : pick_regs_print_included
                      else if(rilb == 0)
                       begin: pick_regs_print_included_in_file
                         `ovm_info(get_type_name(),
                          $psprintf("pick_regs includes %s.%s size=%0d num_fields=%0d pg=%s spc=%s  sbav=0x%0x spc_addr=0x%0x",
                             my_rfn,my_rgn,my_reg_size,my_num_fields,my_policy_group,r_space,r_spc_base_addr_val,r_spc_addr), OVM_LOW);
                       end  : pick_regs_print_included_in_file
                    end   : do_include
                end   : include_reg
              else if(rilb == 0)
                begin : exclude_reg
                  eregs_q.push_back(mregs_q[i]);
                  if (ffg == 1 && fin != 0 && rdcnt <= 0)
                    begin : not_fin
                      `ovm_error(get_type_name(), $psprintf("pick_regs not fin ergn = %s", my_rgn));
                    end   : not_fin
                end   : exclude_reg
           end   : pick_regs_lp

           if (my_irgn_q.size() == 0)
             begin : no_regs_included
               if(atr == 3 || def == 3 || rilb != 0 || pfvf_space_access_seg_adj==1)
                 begin : no_regs_included_w
                   `ovm_warning(get_type_name(), $psprintf("pick_regs  no_regs_included ergn = %s", my_rgn));
                 end   : no_regs_included_w
                else
                 begin : no_regs_included_e
                   `ovm_warning(get_type_name(), $psprintf("pick_regs  no_regs_included ergn = %s", my_rgn)); //--change to warning - my_irgn_q empty : function add_new_rilb() is not called => my_irgn_q is empty
                 end   : no_regs_included_e
               tsm = 7; 
               set_test_seq_mode(tsm); //7 - terminate
             end   : no_regs_included

          if (fin == 0 && rdcnt > 0 )
            begin : unfinished_regs
              if(fdif == 0)  
              `ovm_error(get_type_name(), $psprintf("pick_regs unfinished rdcnt = %d", rdcnt));
            end   : unfinished_regs

          `ovm_info(get_type_name(),$psprintf("DEBUG_do_pick_regs_lp_done:: seg=%0d fna=%0d uat=%0d; offs=%0d barf=%0d atr=%0d def=%0d; rdcnt=0x%0x rcnt=0x%0x, fin=%0d, ffg=%0d fdif=%0d", seg, fna, uat, offs, barf, atr, def, rdcnt, rcnt, fin, ffg, fdif),OVM_LOW);
         end   : do_pick_regs_lp 

          add_regs(iregs_q);

          if(sai != 0)
            begin : sai_nonzero
              foreach(iregs_q[i])
                begin : sai_set_lp
                  iregs_q[i].set_sai_check(1);
                end   : sai_set_lp
            end   : sai_nonzero

          if(pth != 0)
            begin : pth_nonzero
              foreach(mregs_q[m])
                begin : pth_chk_lp
                  my_rgn = mregs_q[m].get_name();
                  my_rfn = mregs_q[m].get_file_name();
                  //check register testability as was set by rdl
                  if(mregs_q[m].get_test_reg() == 0)
                    begin : rg_not_testable
                      `ovm_warning(get_type_name(),
                          $psprintf("rg_not_testable rfn=%s regn=%s",my_rfn,my_rgn));
                    end   : rg_not_testable
                  else
                    begin : rg_is_testable
                      `ovm_info(get_type_name(),
                          $psprintf("rg_is_testable rfn=%s regn=%s",my_rfn,my_rgn), OVM_LOW);
                    end   : rg_is_testable
                  //check register rtl pth
                  my_fld_names = {};
                  mregs_q[m].get_field_names(my_fld_names);
                  if(my_fld_names.size() == 0)
                   begin : pth_chk_no_field_names 
                     `ovm_error(get_type_name(), $psprintf("pth_chk_no_field_names rgn = %s", my_rgn));
                   end   : pth_chk_no_field_names 
                  else
                   begin : pth_chk_has_field_names 
                    foreach(my_fld_names[j])
                     begin : pth_fld_lp
                       fldn = my_fld_names[j];
                       my_field = mregs_q[m].find_field(fldn);
                       my_fld_vpth =  my_field.check_hdl_paths();
                       `ovm_info(get_type_name(),
                         $psprintf("vpth=%0d mfn=%s.%s.%s",my_fld_vpth,my_rfn,my_rgn,fldn), OVM_NONE);
                       my_full_pths = {};
                       my_full_pth = "";
                       my_field.get_full_paths(my_full_pths);
                       if(my_full_pths.size() == 0)
                        begin : full_pths_is_0
                          `ovm_info(get_type_name(),
                           $psprintf("full_pths_is_0 rgn = %s fldn = %s",my_rgn,fldn), OVM_NONE);
                        end   : full_pths_is_0
                       else
                        begin : full_pths_not_0
                          foreach(my_full_pths[k])
                            begin : my_full_pths_lp
                              my_full_pth = {my_full_pth,my_full_pths[k]};
                            end   : my_full_pths_lp
                          `ovm_info(get_type_name(),
                           $psprintf("rgn= %s fldn= %s pth= %s",my_rgn,fldn,my_full_pth), OVM_NONE);
                          if(my_full_pth.len() != 0) //guard against a null string path
                            begin : exec_check_hdl_paths
                              //-- neuter it any RO fields that are set to NoSignal:
                              if(ovm_is_match("*NoSignal",my_full_pth)) begin
                                `ovm_info(get_type_name(), $psprintf("pick_regs -- exec_check_hdl_paths.bypass check_hdl_paths due to NoSignal -- rgn= %s fldn= %s pth= %s, my_full_pth.len=%0d", my_rgn,fldn,my_full_pth, my_full_pth.len()), OVM_NONE);
                                 my_field.check_hdl_paths(no_vpi_msg,0);
                              end else begin
                                `ovm_info(get_type_name(), $psprintf("pick_regs -- exec_check_hdl_paths -- rgn= %s fldn= %s pth= %s, my_full_pth.len=%0d", my_rgn,fldn,my_full_pth, my_full_pth.len()), OVM_HIGH);
                                 my_field.check_hdl_paths(no_vpi_msg,my_invalid_path_error);
                              end
                            end   : exec_check_hdl_paths
                        end   : full_pths_not_0
                     end   : pth_fld_lp
                   end   : pth_chk_has_field_names 
                end   : pth_chk_lp
            end   : pth_nonzero
       end:   pick_regs

  //my_reg_file.dontcompare_field_by_name("reserved*"); //ignore checking for reserved fields

  endfunction : apply_user_setting

  function void reset_agent_prim_checker_obj();
      ovm_object tmp_obj;

      if (p_sequencer.get_config_object("i_hqm_iosf_prim_checker", tmp_obj,0))  begin

          $cast(i_hqm_iosf_prim_checker_obj, tmp_obj);
      end else begin
          `ovm_fatal(get_full_name(), "Unable to get config object i_hqm_iosf_prim_checker_obj");
      end
      // -- Reset transaction Qs -- //
      i_hqm_iosf_prim_checker_obj.reset_txnid_q(); 
      i_hqm_iosf_prim_checker_obj.reset_ep_bus_num_q(); 
      i_hqm_iosf_prim_checker_obj.reset_func_flr_status(); 

  endfunction : reset_agent_prim_checker_obj

  function void get_r_addr  (sla_ral_reg my_reg);
                 r_space = my_reg.get_space();
                 r_spc_addr = my_reg.get_space_addr(r_space);
                 r_addr = r_spc_addr;
                 if(r_space == "MEM")
                  begin : add_MEM_base
                    r_addr = r_spc_addr + my_reg.get_base_addr_val(r_space);
                  end   : add_MEM_base
                 if(r_space == "CFG")
                  begin : add_CFG_addr_adj
                    r_addr = r_spc_addr           |
                    (my_reg.get_func_num() << 16) | 
                    (my_reg.get_dev_num()  << 19) | 
                    (my_reg.get_bus_num()  << 24);
                  end   : add_CFG_addr_adj
                 r_4k_addr = r_addr & r_4k_addr_mask;
  endfunction : get_r_addr

  //add new Register Intentionally Left Blank
  function void add_new_rilb(string tmpl_rfn, //template register file name
                             string tmpl_rgn, //template register name
                             string rilbn,    //intentionally left nlank register name
                             sla_ral_addr_t  spc_addr = 0, //space address
                             int    my_size = 0,
                             int    pstep = 0,  //positive step (add to offset)
                             int    nstep = 0); //negative step (add to offset)
    int            rilb_lsb = 0; //rilb_field least significant bit
    int            tmpl_fid; //fid of register
    int            tmpl_bar; //BAR of register
    int            tmpl_bus; //register bus number
    int            tmpl_dev; //register dev number
    int            tmpl_func; //register func number
    int            tmpl_size; //register size
    string         tmpl_msg_opcode;
    string         tmpl_pg; //policy group
  //string         tmpl_rgn; //template register name
    sla_ral_addr_t tmpl_rf_base;
    sla_ral_addr_t rilb_spc_base_addr_val;
    sla_ral_addr_t rilb_addr; //Register Intentionally Left Blank addr
    sla_ral_addr_t tmpl_spc_addr;
    sla_ral_addr_t rilb_spc_addr;
    sla_ral_addr_t tmpl_msg_bus_port_spc_addr;
    sla_ral_addr_t tmpl_MEM_spc_addr;
    sla_ral_addr_t tmpl_MEMSB_spc_addr;
    sla_ral_addr_t tmpl_MSG_spc_addr;
    sla_ral_addr_t tmpl_spc_base_addr_val;
    sla_ral_addr_t rilb_MEM_spc_addr;
    sla_ral_addr_t rilb_MEMSB_spc_addr;
    sla_ral_addr_t rilb_MSG_spc_addr;
    sla_ral_addr_t rilb_msg_bus_port_spc_addr;
    sla_ral_data_t tmpl_offset; //Register offset;
    sla_ral_data_t rilb_offset; //Register offset + pstep - nstep
    sla_ral_file   tmpl_reg_file;
    sla_ral_file   tmpl_hqm_pf_cfg_i_rf;
    sla_ral_reg    tmpl_reg; //Template Register 
    sla_ral_reg    my_rilb; //Register Intentionally Left Blank
    sla_ral_reg    my_CSR_BAR_L; //hqm_pf_cfg_i.CSR_BAR_L register for set RILB bar
    sla_ral_reg    my_CSR_BAR_U; //hqm_pf_cfg_i.CSR_BAR_U register for set RILB bar
    sla_ral_reg    my_FUNC_BAR_L; //hqm_pf_cfg_i.FUNC_BAR_L register for set RILB bar
    sla_ral_reg    my_FUNC_BAR_U; //hqm_pf_cfg_i.FUNC_BAR_U register for set RILB bar
    sla_ral_field  rilb_field;
    sla_ral_space_t tmpl_spc;
    sla_status_t   rilb_sla_status;

    tmpl_hqm_pf_cfg_i_rf = ral.find_file("hqm_pf_cfg_i"); //Find Register File
    my_CSR_BAR_L = tmpl_hqm_pf_cfg_i_rf.find_reg("CSR_BAR_L");
    my_CSR_BAR_U = tmpl_hqm_pf_cfg_i_rf.find_reg("CSR_BAR_U");
    my_FUNC_BAR_L = tmpl_hqm_pf_cfg_i_rf.find_reg("FUNC_BAR_L");
    my_FUNC_BAR_U = tmpl_hqm_pf_cfg_i_rf.find_reg("FUNC_BAR_U");

    tmpl_reg_file = ral.find_file(tmpl_rfn); //Find Register File
    tmpl_reg      = tmpl_reg_file.find_reg(tmpl_rgn);
    tmpl_spc      = tmpl_reg.get_space();
    tmpl_bus      = tmpl_reg.get_bus_num();
    tmpl_dev      = tmpl_reg.get_dev_num();
    tmpl_func     = tmpl_reg.get_func_num();
    tmpl_size     = (my_size == 0) ? tmpl_reg.get_size() : my_size;
    tmpl_pg       = tmpl_reg.get_policy_group();
    tmpl_spc_base_addr_val = tmpl_reg.get_base_addr_val(tmpl_spc);
    tmpl_rf_base  = tmpl_reg_file.get_base();
    tmpl_spc_addr = (spc_addr == 0) ? tmpl_reg.get_space_addr(tmpl_spc) : spc_addr;
    tmpl_offset   = (spc_addr == 0) ? tmpl_reg.get_offset() : spc_addr - tmpl_rf_base;
    rilb_spc_addr = tmpl_spc_addr + pstep - nstep;
    rilb_offset   = tmpl_offset + pstep - nstep;

    `ovm_info(get_type_name(),
     $psprintf("DEBUG_add_rilb:add_new_rilb - tmp_rilb %s.%s offs=0x%x spc_addr=0x%x sbav=0x%x sz=%0d bus=%0d dev=%0d func=%0d spc=%s pg=%s rfbs=0x%x",
         tmpl_rfn,tmpl_rgn,tmpl_offset,tmpl_spc_addr,tmpl_spc_base_addr_val,tmpl_size,tmpl_bus,tmpl_dev,tmpl_func,tmpl_spc,tmpl_pg,tmpl_rf_base), OVM_LOW);

     my_rilb = new(rilbn,tmpl_bus,tmpl_dev,tmpl_func,rilb_offset,tmpl_size);
     rilb_field = new("FILB","RO",tmpl_size,rilb_lsb); //Field Intent. Left Blank
     my_rilb.add_field(rilb_field);

     if (ovm_is_match("hqm_msix_mem*",tmpl_rfn))
              my_rilb.set_base_addr_reg(my_FUNC_BAR_L,my_FUNC_BAR_U,
                                        64'hFFFFFFFFC000000, .space("MEM"));
     else
      my_rilb.set_base_addr_reg(my_CSR_BAR_L,my_CSR_BAR_U,
                                64'hFFFFFFFF00000000, .space("MEM"));




     tmpl_msg_bus_port_spc_addr = tmpl_reg.get_space_addr("msg_bus_port");
     my_rilb.set_space_addr("msg_bus_port",tmpl_msg_bus_port_spc_addr);

     my_rilb.set_space(tmpl_spc);
     my_rilb.set_security_policy("Security_PolicyGroup",tmpl_pg);

     tmpl_MEM_spc_addr   = (spc_addr == 0) ? tmpl_reg.get_space_addr("MEM") : spc_addr;
     tmpl_MSG_spc_addr   = (spc_addr == 0) ? tmpl_reg.get_space_addr("MSG") : spc_addr;
     tmpl_MEMSB_spc_addr = (spc_addr == 0) ? tmpl_reg.get_space_addr("MEM-SB") : spc_addr;

     rilb_MEM_spc_addr = tmpl_MEM_spc_addr + pstep - nstep - tmpl_rf_base; 
     my_rilb.set_space_addr("MEM",rilb_MEM_spc_addr);

     rilb_MSG_spc_addr =  tmpl_MSG_spc_addr + pstep - nstep - tmpl_rf_base;
     my_rilb.set_space_addr("MSG",rilb_MSG_spc_addr);

     tmpl_msg_opcode = tmpl_reg.get_msg_opcode();
     my_rilb.set_msg_opcode(tmpl_msg_opcode);

     rilb_MEMSB_spc_addr = tmpl_MEMSB_spc_addr + pstep - nstep - tmpl_rf_base;
     my_rilb.set_space_addr("MEM-SB",rilb_MEMSB_spc_addr);

     tmpl_fid = tmpl_reg.get_fid("MEM-SB");
     my_rilb.set_fid(tmpl_fid,"MEM-SB");

     tmpl_bar = tmpl_reg.get_bar("MEM-SB");
     my_rilb.set_bar(tmpl_bar,"MEM-SB");

     my_rilb.set_cfg(tmpl_bus,tmpl_dev,tmpl_func,rilb_offset,tmpl_size,0);

     rilb_sla_status = tmpl_reg_file.add_reg(my_rilb);
     iregs_q.push_back(my_rilb);
     my_irgn_q.push_back(rilbn);

     `ovm_info(get_type_name(),
      $psprintf("DEBUG_add_rilb:add_new_rilb - new_rilb %s.%s offs=0x%x spc_addr=0x%x sbav=0x%x sz=%0d bus=%0d dev=%0d func=%0d spc=%s pg=%s stat=%s",
         tmpl_rfn,rilbn,rilb_offset,rilb_spc_addr,tmpl_spc_base_addr_val,tmpl_size,tmpl_bus,tmpl_dev,tmpl_func,tmpl_spc,tmpl_pg, rilb_sla_status), OVM_LOW);
  endfunction : add_new_rilb

  function string get_mtc_pat_from_rgn_string(string my_string);
    //assumes my_string contains name of a register array's last element
    string my_pat = "";
    string adj_string = ""; //adjusted string
    int    my_string_pos = 0;
    
    adj_string = my_string;

    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_00[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_00[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_01[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_01[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_02[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_02[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_03[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_03[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_04[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_04[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_05[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_05[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_06[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_06[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_07[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_07[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_08[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_08[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_09[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_09[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_10[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_10[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_11[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_11[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_12[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_12[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_13[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_13[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_14[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_14[31]";
    if(ovm_is_match("CFG_AP_QID_LDB_QID2CQIDIX_15[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_15[31]";

    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_00[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_00[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_01[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_01[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_02[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_02[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_03[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_03[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_04[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_04[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_05[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_05[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_06[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_06[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_07[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_07[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_08[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_08[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_09[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_09[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_10[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_10[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_11[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_11[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_12[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_12[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_13[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_13[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_14[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_14[31]";
    if(ovm_is_match("CFG_LSP_QID_LDB_QID2CQIDIX_15[31]",my_string)) adj_string = "CFG_QID_LDB_QID2CQIDIX_15[31]";

    my_string_pos = get_left_bracket_string_pos_minus_1(adj_string);
    get_mtc_pat_from_rgn_string = adj_string.substr(0,my_string_pos);
  endfunction : get_mtc_pat_from_rgn_string

  function string get_wildcard_mtc_pat_from_rgn_string(string my_string);
    //assumes my_string contains name of a register array's last element
    string my_pat = "";
    int    my_string_pos = 0;
    
    my_string_pos = get_left_bracket_string_pos_minus_1(my_string);
    my_pat = my_string.substr(0,my_string_pos);
    get_wildcard_mtc_pat_from_rgn_string = $psprintf("%s[*]",my_pat);
  endfunction : get_wildcard_mtc_pat_from_rgn_string

  function int get_array_size_from_trigger_rgn_string(string my_string);
    //assumes my_string contains name of a register array's last element
    get_array_size_from_trigger_rgn_string = 0; //return zero if not matched
    if(ovm_is_match("*[15]",  my_string)) get_array_size_from_trigger_rgn_string =   16;
    if(ovm_is_match("*[31]",  my_string)) get_array_size_from_trigger_rgn_string =   32;
    if(ovm_is_match("*[63]",  my_string)) get_array_size_from_trigger_rgn_string =   64;
    if(ovm_is_match("*[95]",  my_string)) get_array_size_from_trigger_rgn_string =   96;
    if(ovm_is_match("*[127]", my_string)) get_array_size_from_trigger_rgn_string =  128;
    if(ovm_is_match("*[255]", my_string)) get_array_size_from_trigger_rgn_string =  256;
    if(ovm_is_match("*[511]", my_string)) get_array_size_from_trigger_rgn_string =  512;
    if(ovm_is_match("*[1023]",my_string)) get_array_size_from_trigger_rgn_string = 1024;
    if(ovm_is_match("*[1535]",my_string)) get_array_size_from_trigger_rgn_string = 1536;
    if(ovm_is_match("*[2047]",my_string)) get_array_size_from_trigger_rgn_string = 2048;
    if(ovm_is_match("*[3071]",my_string)) get_array_size_from_trigger_rgn_string = 3072;
    if(ovm_is_match("*[4095]",my_string)) get_array_size_from_trigger_rgn_string = 4096;
  endfunction : get_array_size_from_trigger_rgn_string

  function int get_left_bracket_string_pos_minus_1(string my_string);
    //return postition in string before left bracket
    int my_string_len = 0;

    my_string_len =  my_string.len();
    //return last postition in string if no left bracket is found
    get_left_bracket_string_pos_minus_1 = my_string_len -1;

    for (int m = 0; m <= my_string_len; m++)
      begin : find_index_pos
        if (my_string[m] == "[")
          begin : found_index_pos_lp
            get_left_bracket_string_pos_minus_1 = m-1;
            break;
          end   : found_index_pos_lp
       end   : find_index_pos
  endfunction : get_left_bracket_string_pos_minus_1

  function bit eval_reg_ipth(sla_ral_reg my_reg);
  //check if register has field without a valid rtl path
    sla_ral_field my_fields_q[$] = {};

    eval_reg_ipth = 1'b0; //assume no invalid rtl pth
    my_reg.get_fields(my_fields_q);
    foreach(my_fields_q[j])
      begin : eval_reg_ipth_lp
        if(my_fields_q[j].check_hdl_paths(no_vpi_msg) != 1'b1)
          begin : set_reg_ipth
            eval_reg_ipth = 1'b1; //invalid rtl pth
            break;
         end   : set_reg_ipth
     end   : eval_reg_ipth_lp

  endfunction : eval_reg_ipth

  function void ass_tg_mtc_rgn_q();
     tg_mtc_rgn_q = {};
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_00[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_01[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_02[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_03[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_04[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_05[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_06[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_07[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_08[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_09[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_10[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_11[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_12[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_13[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_14[31]");
     tg_mtc_rgn_q.push_back("CFG_AP_QID_LDB_QID2CQIDIX_15[31]");
     tg_mtc_rgn_q.push_back("CFG_AQED_QID_FID_LIMIT[31]");    
     tg_mtc_rgn_q.push_back("CFG_AQED_QID_HID_WIDTH[31]");    
     tg_mtc_rgn_q.push_back("CFG_ATM_QID_DPTH_THRSH[31]");    
     tg_mtc_rgn_q.push_back("CFG_CQ2PRIOV[63]");    
     tg_mtc_rgn_q.push_back("CFG_CQ2QID0[63]");    
     tg_mtc_rgn_q.push_back("CFG_CQ2QID1[63]");    
     tg_mtc_rgn_q.push_back("CFG_CMP_SN_CHK_ENBL[63]");    
     tg_mtc_rgn_q.push_back("CFG_CQ_DIR_DISABLE[95]");    
     tg_mtc_rgn_q.push_back("CFG_CQ_DIR_TOKEN_COUNT[95]");    
     tg_mtc_rgn_q.push_back("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[95]");
     tg_mtc_rgn_q.push_back("CFG_CQ_DIR_TOT_SCH_CNTH[95]");    
     tg_mtc_rgn_q.push_back("CFG_CQ_DIR_TOT_SCH_CNTL[95]");    
     tg_mtc_rgn_q.push_back("CFG_CQ_LDB_DISABLE[63]");    
     tg_mtc_rgn_q.push_back("CFG_CQ_LDB_INFLIGHT_COUNT[63]");    
     tg_mtc_rgn_q.push_back("CFG_CQ_LDB_INFLIGHT_LIMIT[63]");    
     tg_mtc_rgn_q.push_back("CFG_CQ_LDB_TOKEN_COUNT[63]");    
     tg_mtc_rgn_q.push_back("CFG_CQ_LDB_TOKEN_DEPTH_SELECT[63]");    
     tg_mtc_rgn_q.push_back("CFG_CQ_LDB_TOT_SCH_CNTH[63]");    
     tg_mtc_rgn_q.push_back("CFG_CQ_LDB_TOT_SCH_CNTL[63]");    
     tg_mtc_rgn_q.push_back("CFG_DIR_CQ_DEPTH[95]");    
     tg_mtc_rgn_q.push_back("CFG_DIR_CQ_INT_DEPTH_THRSH[95]");    
     tg_mtc_rgn_q.push_back("CFG_DIR_CQ_INT_ENB[95]");    
     tg_mtc_rgn_q.push_back("CFG_DIR_CQ_TIMER_COUNT[95]");    
     tg_mtc_rgn_q.push_back("CFG_DIR_CQ_TIMER_THRESHOLD[95]");    
     tg_mtc_rgn_q.push_back("CFG_DIR_CQ_TOKEN_DEPTH_SELECT[95]");    
     tg_mtc_rgn_q.push_back("CFG_DIR_CQ_WD_ENB[95]");    
     tg_mtc_rgn_q.push_back("CFG_DIR_CQ_WPTR[95]");    
     tg_mtc_rgn_q.push_back("CFG_DIR_CQ2VAS[95]");    
     tg_mtc_rgn_q.push_back("CFG_DIR_QID_DPTH_THRSH[95]");    
     tg_mtc_rgn_q.push_back("CFG_VAS_CREDIT_COUNT[31]");    
     tg_mtc_rgn_q.push_back("CFG_VAS_CREDIT_COUNT[31]");    
     tg_mtc_rgn_q.push_back("CFG_HIST_LIST_BASE[63]"); 
     tg_mtc_rgn_q.push_back("CFG_HIST_LIST_LIMIT[63]"); 
     tg_mtc_rgn_q.push_back("CFG_HIST_LIST_POP_PTR[63]"); 
     tg_mtc_rgn_q.push_back("CFG_HIST_LIST_PUSH_PTR[63]"); 
     tg_mtc_rgn_q.push_back("CFG_LDB_CQ_DEPTH[63]");    
     tg_mtc_rgn_q.push_back("CFG_LDB_CQ_INT_DEPTH_THRSH[63]");    
     tg_mtc_rgn_q.push_back("CFG_LDB_CQ_INT_ENB[63]");    
     tg_mtc_rgn_q.push_back("CFG_LDB_CQ_TIMER_COUNT[63]");    
     tg_mtc_rgn_q.push_back("CFG_LDB_CQ_TIMER_THRESHOLD[63]");    
     tg_mtc_rgn_q.push_back("CFG_LDB_CQ_TOKEN_DEPTH_SELECT[63]");    
     tg_mtc_rgn_q.push_back("CFG_LDB_CQ_WD_ENB[63]");    
     tg_mtc_rgn_q.push_back("CFG_LDB_CQ_WPTR[63]");    
     tg_mtc_rgn_q.push_back("CFG_LDB_CQ2VAS[63]");    
     tg_mtc_rgn_q.push_back("CFG_LDB_QID_RDYLST_CLAMP[31]");    
     tg_mtc_rgn_q.push_back("CFG_VAS_CREDIT_COUNT[31]");
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_00[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_01[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_02[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_03[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_04[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_05[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_06[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_07[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_08[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_09[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_10[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_11[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_12[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_13[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_14[31]");    
     tg_mtc_rgn_q.push_back("CFG_LSP_QID_LDB_QID2CQIDIX_15[31]");    
     tg_mtc_rgn_q.push_back("CFG_NALB_QID_DPTH_THRSH[31]");    
     tg_mtc_rgn_q.push_back("CFG_ORD_QID_SN_MAP[31]");    
     tg_mtc_rgn_q.push_back("CFG_ORD_QID_SN[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_AQED_ACTIVE_COUNT[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_AQED_ACTIVE_LIMIT[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_ATM_ACTIVE[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_ATM_TOT_ENQ_CNTH[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_ATM_TOT_ENQ_CNTL[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_ATQ_ENQUEUE_COUNT[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_DIR_ENQUEUE_COUNT[95]");    
     tg_mtc_rgn_q.push_back("CFG_QID_DIR_MAX_DEPTH[95]");    
     tg_mtc_rgn_q.push_back("CFG_QID_DIR_TOT_ENQ_CNTH[95]");    
     tg_mtc_rgn_q.push_back("CFG_QID_DIR_TOT_ENQ_CNTL[95]");    
     tg_mtc_rgn_q.push_back("CFG_QID_DIR_REPLAY_COUNT[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_INFLIGHT_COUNT[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_INFLIGHT_LIMIT[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_00[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_01[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_02[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_03[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_04[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_05[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_06[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_07[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_08[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_09[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_10[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_11[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_12[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_13[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_14[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_QID2CQIDIX2_15[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_LDB_REPLAY_COUNT[31]");    
     tg_mtc_rgn_q.push_back("CFG_QID_NALDB_MAX_DEPTH[31]");
     tg_mtc_rgn_q.push_back("CFG_QID_NALDB_TOT_ENQ_CNTH[31]");
     tg_mtc_rgn_q.push_back("CFG_QID_NALDB_TOT_ENQ_CNTL[31]");
     tg_mtc_rgn_q.push_back("DIR_CQ_ADDR_L[95]");
     tg_mtc_rgn_q.push_back("DIR_CQ_ADDR_U[95]");
     tg_mtc_rgn_q.push_back("DIR_PP2VAS[95]");
     tg_mtc_rgn_q.push_back("HQM_DIR_PP2VDEV[95]");
     tg_mtc_rgn_q.push_back("DIR_PP_V[95]");
     tg_mtc_rgn_q.push_back("DIR_CQ2VF_PF_RO[95]");
     tg_mtc_rgn_q.push_back("DIR_CQ_ISR[95]");
     tg_mtc_rgn_q.push_back("DIR_CQ_PASID[95]");
     tg_mtc_rgn_q.push_back("AI_ADDR_L[159]");
     tg_mtc_rgn_q.push_back("AI_ADDR_U[159]");
     tg_mtc_rgn_q.push_back("AI_DATA[159]");
     tg_mtc_rgn_q.push_back("AI_CTRL[159]");
     tg_mtc_rgn_q.push_back("DIR_CQ_FMT[95]");
     tg_mtc_rgn_q.push_back("DIR_QID_V[95]");
     tg_mtc_rgn_q.push_back("DIR_QID_ITS[95]");
     tg_mtc_rgn_q.push_back("DIR_VASQID_V[3071]");
     tg_mtc_rgn_q.push_back("LDB_CQ_ADDR_L[63]");
     tg_mtc_rgn_q.push_back("LDB_CQ_ADDR_U[63]");
     tg_mtc_rgn_q.push_back("LDB_PP2VAS[63]");
     tg_mtc_rgn_q.push_back("HQM_LDB_PP2VDEV[63]");
     tg_mtc_rgn_q.push_back("LDB_PP_V[63]");
     tg_mtc_rgn_q.push_back("LDB_CQ2VF_PF_RO[63]");
     tg_mtc_rgn_q.push_back("LDB_CQ_ISR[63]");
     tg_mtc_rgn_q.push_back("LDB_CQ_PASID[63]");
     tg_mtc_rgn_q.push_back("LDB_QID_V[31]");
     tg_mtc_rgn_q.push_back("LDB_QID_ITS[31]");
     tg_mtc_rgn_q.push_back("LDB_QID_CFG_V[31]");
     tg_mtc_rgn_q.push_back("LDB_QID2VQID[31]");
     tg_mtc_rgn_q.push_back("LDB_VASQID_V[1023]");
     tg_mtc_rgn_q.push_back("ALARM_VF_SYND0[15]");
     tg_mtc_rgn_q.push_back("ALARM_VF_SYND1[15]");
     tg_mtc_rgn_q.push_back("ALARM_VF_SYND2[15]");
     tg_mtc_rgn_q.push_back("VF_DIR_VPP_V[1535]");
     tg_mtc_rgn_q.push_back("VF_DIR_VPP2PP[1535]");
     tg_mtc_rgn_q.push_back("VF_DIR_VQID2QID[1535]");
     tg_mtc_rgn_q.push_back("VF_DIR_VQID_V[1535]");
     tg_mtc_rgn_q.push_back("VF_LDB_VPP_V[1023]");
     tg_mtc_rgn_q.push_back("VF_LDB_VPP2PP[1023]");
     tg_mtc_rgn_q.push_back("VF_LDB_VQID2QID[511]");
     tg_mtc_rgn_q.push_back("VF_LDB_VQID_V[511]");
  endfunction : ass_tg_mtc_rgn_q

endclass : test_hqm_ral_attr_seq

