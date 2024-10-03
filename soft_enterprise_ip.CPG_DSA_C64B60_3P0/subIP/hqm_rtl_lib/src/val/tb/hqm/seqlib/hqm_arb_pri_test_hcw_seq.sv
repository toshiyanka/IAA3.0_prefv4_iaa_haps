import hqm_tb_cfg_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

class hqm_arb_pri_test_hcw_seq extends sla_sequence_base;

  `ovm_sequence_utils(hqm_arb_pri_test_hcw_seq, sla_sequencer)

  hqm_tb_cfg            i_hqm_cfg;

  hqm_pp_cq_base_seq    ldb_pp_cq_0_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_1_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_2_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_3_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_4_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_5_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_6_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_7_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_8_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_9_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_10_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_11_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_12_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_13_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_14_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_15_seq;

  int trfseq_sel;
  int trfseqfreq_sel;
  int trftype_sel;
  int trfldbpp_enable[16];
  int trfdirpp_enable[16];
  string    qtype_str_list[16];  
  int pp_val;
    
  function new(string name = "hqm_arb_pri_test_hcw_seq");
    
    super.new(name);

    for(int i=0; i<16; i++) begin
      trfldbpp_enable[i] = 0;
      trfdirpp_enable[i] = 0;
    end
    
    //$value$plusargs({$psprintf("TRF_PP%0d_ENABLE", pp_val),"=%d"}, trfldbpp_enable[pp_val]);  
    //`ovm_info("HCW_PP_CQ_ARBTRF_CFG",$psprintf("Get trfldbpp_enable[%0d]=%0d, pp_val=%0d", pp_val, trfldbpp_enable[pp_val], pp_val),OVM_LOW)          
    $value$plusargs("trfldbpp0_enable=%0d",  trfldbpp_enable[0]);
    $value$plusargs("trfldbpp1_enable=%0d",  trfldbpp_enable[1]);
    $value$plusargs("trfldbpp2_enable=%0d",  trfldbpp_enable[2]);
    $value$plusargs("trfldbpp3_enable=%0d",  trfldbpp_enable[3]);
    $value$plusargs("trfldbpp4_enable=%0d",  trfldbpp_enable[4]);
    $value$plusargs("trfldbpp5_enable=%0d",  trfldbpp_enable[5]);
    $value$plusargs("trfldbpp6_enable=%0d",  trfldbpp_enable[6]);
    $value$plusargs("trfldbpp7_enable=%0d",  trfldbpp_enable[7]);
    $value$plusargs("trfldbpp8_enable=%0d",  trfldbpp_enable[8]);
    $value$plusargs("trfldbpp9_enable=%0d",  trfldbpp_enable[9]);
    $value$plusargs("trfldbpp10_enable=%0d", trfldbpp_enable[10]);
    $value$plusargs("trfldbpp11_enable=%0d", trfldbpp_enable[11]);
    $value$plusargs("trfldbpp12_enable=%0d", trfldbpp_enable[12]);  
    $value$plusargs("trfldbpp13_enable=%0d", trfldbpp_enable[13]);
    $value$plusargs("trfldbpp14_enable=%0d", trfldbpp_enable[14]);
    $value$plusargs("trfldbpp15_enable=%0d", trfldbpp_enable[15]);                                                          

    for(int i=0; i<16; i++) `ovm_info("HCW_PP_CQ_ARBTRF_CFG",$psprintf("Get trfldbpp_enable[%0d]=%0d",i, trfldbpp_enable[i]),OVM_LOW)
    
        
    $value$plusargs("trfdirpp0_enable=%0d",  trfdirpp_enable[0]);
    $value$plusargs("trfdirpp1_enable=%0d",  trfdirpp_enable[1]);
    $value$plusargs("trfdirpp2_enable=%0d",  trfdirpp_enable[2]);
    $value$plusargs("trfdirpp3_enable=%0d",  trfdirpp_enable[3]);
    $value$plusargs("trfdirpp4_enable=%0d",  trfdirpp_enable[4]);
    $value$plusargs("trfdirpp5_enable=%0d",  trfdirpp_enable[5]);
    $value$plusargs("trfdirpp6_enable=%0d",  trfdirpp_enable[6]);
    $value$plusargs("trfdirpp7_enable=%0d",  trfdirpp_enable[7]);
    $value$plusargs("trfdirpp8_enable=%0d",  trfdirpp_enable[8]);
    $value$plusargs("trfdirpp9_enable=%0d",  trfdirpp_enable[9]);
    $value$plusargs("trfdirpp10_enable=%0d", trfdirpp_enable[10]);
    $value$plusargs("trfdirpp11_enable=%0d", trfdirpp_enable[11]);
    $value$plusargs("trfdirpp12_enable=%0d", trfdirpp_enable[12]);  
    $value$plusargs("trfdirpp13_enable=%0d", trfdirpp_enable[13]);
    $value$plusargs("trfdirpp14_enable=%0d", trfdirpp_enable[14]);
    $value$plusargs("trfdirpp15_enable=%0d", trfdirpp_enable[15]); 
    for(int i=0; i<16; i++) `ovm_info("HCW_PP_CQ_ARBTRF_CFG",$psprintf("Get trfdirpp_enable[%0d]=%0d",i, trfdirpp_enable[i]),OVM_LOW)
 
    trfseqfreq_sel=8;
    $value$plusargs("trfseqfreq_sel=%0d", trfseqfreq_sel);
    `ovm_info("HCW_PP_CQ_ARBTRF_CFG",$psprintf("Get trfseqfreq_sel value = %0d", trfseqfreq_sel),OVM_LOW)
    

    trfseq_sel=16;
    $value$plusargs("trfseq_sel=%0d", trfseq_sel);
    `ovm_info("HCW_PP_CQ_ARBTRF_CFG",$psprintf("Get trfseq_sel value = %0d", trfseq_sel),OVM_LOW)
    
    trftype_sel=0;
    $value$plusargs("trftype_sel=%0d", trftype_sel);
    `ovm_info("HCW_PP_CQ_ARBTRF_CFG",$psprintf("Get trftype_sel value = %0d", trftype_sel),OVM_LOW)    
  endfunction

  virtual task body();
    ovm_object  o_tmp;

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg %s not consistent with hqm_tb_cfg type", o_tmp.sprint()));
    end

    fork  
      begin
        start_pp_cq(1,0,0,QATM,   0, 256,  trfseq_sel, trfseqfreq_sel, ldb_pp_cq_0_seq);
      end
      begin
        if(trfldbpp_enable[1] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[1]"), OVM_LOW) 	
           start_pp_cq(1,1,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq);
        end else if(trfdirpp_enable[1] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[1]"), OVM_LOW) 	
           start_pp_cq(0,1,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); //--bit is_ldb, int pp_cq_num_in, int qi 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[1]"), OVM_LOW)    	
        end		   
      end
      begin
        if(trfldbpp_enable[2] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[2]"), OVM_LOW) 	
           start_pp_cq(1,2,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_2_seq);
        end else if(trfdirpp_enable[2] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[2]"), OVM_LOW) 	
           start_pp_cq(0,2,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[2]"), OVM_LOW)    	
        end
      end
      begin
        if(trfldbpp_enable[3] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[3]"), OVM_LOW) 	
           start_pp_cq(1,3,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_3_seq);
        end else if(trfdirpp_enable[3] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[3]"), OVM_LOW) 	
           start_pp_cq(0,3,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[3]"), OVM_LOW)    	
        end
      end
      begin
        if(trfldbpp_enable[4] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[4]"), OVM_LOW) 	
           start_pp_cq(1,4,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_4_seq);
        end else if(trfdirpp_enable[4] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[4]"), OVM_LOW) 	
           start_pp_cq(0,4,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[4]"), OVM_LOW)    	
        end
      end
      begin
        if(trfldbpp_enable[5] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[5]"), OVM_LOW) 	
           start_pp_cq(1,5,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_5_seq);
        end else if(trfdirpp_enable[5] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[5]"), OVM_LOW) 	
           start_pp_cq(0,5,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[5]"), OVM_LOW)    	
        end
      end
      begin
        if(trfldbpp_enable[6] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[6]"), OVM_LOW) 	
           start_pp_cq(1,6,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_6_seq);
        end else if(trfdirpp_enable[6] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[6]"), OVM_LOW) 	
           start_pp_cq(0,6,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[6]"), OVM_LOW)    	
        end
      end
      begin
        if(trfldbpp_enable[7] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[7]"), OVM_LOW) 	
           start_pp_cq(1,7,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_7_seq);
        end else if(trfdirpp_enable[7] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[7]"), OVM_LOW) 	
           start_pp_cq(0,7,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[7]"), OVM_LOW)    	
        end
      end
      begin
        if(trfldbpp_enable[8] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[8]"), OVM_LOW) 	
           start_pp_cq(1,8,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_8_seq);
        end else if(trfdirpp_enable[8] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[8]"), OVM_LOW) 	
           start_pp_cq(0,8,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[8]"), OVM_LOW)    	
        end
      end
      begin
        if(trfldbpp_enable[9] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[9]"), OVM_LOW) 	
           start_pp_cq(1,9,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_9_seq);
        end else if(trfdirpp_enable[9] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[9]"), OVM_LOW) 	
           start_pp_cq(0,9,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[9]"), OVM_LOW)    	
        end
      end
      begin
        if(trfldbpp_enable[10] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[10]"), OVM_LOW) 	
           start_pp_cq(1,10,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_10_seq);
        end else if(trfdirpp_enable[10] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[10]"), OVM_LOW) 	
           start_pp_cq(0,10,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[10]"), OVM_LOW)    	
        end
      end
      begin
        if(trfldbpp_enable[11] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[11]"), OVM_LOW) 	
           start_pp_cq(1,11,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_11_seq);
        end else if(trfdirpp_enable[11] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[11]"), OVM_LOW) 	
           start_pp_cq(0,11,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[11]"), OVM_LOW)    	
        end
      end
      begin
        if(trfldbpp_enable[12] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[12]"), OVM_LOW) 	
           start_pp_cq(1,12,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_12_seq);
        end else if(trfdirpp_enable[12] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[12]"), OVM_LOW) 	
           start_pp_cq(0,12,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[12]"), OVM_LOW)    	
        end
      end
      begin
        if(trfldbpp_enable[13] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[13]"), OVM_LOW) 	
           start_pp_cq(1,13,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_13_seq);
        end else if(trfdirpp_enable[13] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[13]"), OVM_LOW) 	
           start_pp_cq(0,13,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[13]"), OVM_LOW)    	
        end
      end
      begin
        if(trfldbpp_enable[14] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[14]"), OVM_LOW) 	
           start_pp_cq(1,14,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_14_seq);
        end else if(trfdirpp_enable[14] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[14]"), OVM_LOW) 	
           start_pp_cq(0,14,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[14]"), OVM_LOW)    	
        end
      end
      begin
        if(trfldbpp_enable[15] == 1) begin 
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  start_pp_cq[15]"), OVM_LOW) 	
           start_pp_cq(1,15,1,QUNO,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_15_seq);
        end else if(trfdirpp_enable[15] == 1)begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Start  dirpp start_pp_cq[15]"), OVM_LOW) 	
           start_pp_cq(0,15,1,QDIR,   0,   0,           1, trfseqfreq_sel, ldb_pp_cq_1_seq); 
        end else begin
          `ovm_info("HCW_PP_CQ_ARBTRF_SEQ",$psprintf("Bypass  start_pp_cq[15]"), OVM_LOW)    	
        end
      end
    join      
    super.body();

  endtask

  virtual task start_pp_cq(bit is_ldb, int pp_cq_num_in, int qid, hcw_qtype qtype, int dir_credit_count_in, int ldb_credit_count_in, int queue_list_size, int hcw_delay_in, output hqm_pp_cq_base_seq pp_cq_seq);
    sla_ral_env         ral;
    sla_ral_reg         my_reg;
    sla_ral_data_t      ral_data;
    logic [63:0]        cq_addr_val;
    int                 num_hcw_gen;
    string              pp_cq_prefix;
    string              qtype_str;
    int                 vf_num_val;
    bit                 inc_lock_id;
    bit [15:0]          lock_id;
    bit [15:0]          dsi;
    int                 cq_depth_in;
    int                 qpri_weight[8];
    int                 init_tok_return_delay;
    int                 init_comp_return_delay;

    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal("CFG", "Unable to get RAL handle");
    end    

    cq_addr_val = '0;

    if (is_ldb) begin
      pp_cq_prefix = "LDB";
    end else begin
      pp_cq_prefix = "DIR";
    end

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pp_cq_num_in), "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[63:32] = ral_data[31:0];

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pp_cq_num_in), "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[31:6] = ral_data[31:6];
    ovm_report_info(get_full_name(), $psprintf("hqm_arb_pri_test_hcw_seq: is_ldb=%0d pp_cq_num_in=%0d read cq_addr_u/l to get cq_addr_val=0x%0x", is_ldb, pp_cq_num_in, cq_addr_val), OVM_LOW);

    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- the above cq_addr_val read from CQ_ADDR ral is virtual address
    //-- to get physical address: cq_addr_val=i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in);  
    //----------------------------------
    if(i_hqm_cfg.ats_enabled==1) begin
        cq_addr_val = i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in); 
        ovm_report_info(get_full_name(), $psprintf("hqm_arb_pri_test_hcw_seq: is_ldb=%0d pp_cq_num_in=%0d get cq_addr_val=0x%0x (physical address when i_hqm_cfg.ats_enabled==1)", is_ldb, pp_cq_num_in, cq_addr_val), OVM_LOW);
    end  


    my_reg   = ral.find_reg_by_file_name($psprintf("cfg_%s_cq_token_depth_select[%0d]",pp_cq_prefix,pp_cq_num_in), "credit_hist_pipe");
    ral_data = my_reg.get_actual();

    cq_depth_in = 4 << ral_data;

    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_in);
    $value$plusargs({$psprintf("%s_PP%0d_DIR_CREDIT",pp_cq_prefix,pp_cq_num_in),"=%d"}, dir_credit_count_in);
    $value$plusargs({$psprintf("%s_PP%0d_LDB_CREDIT",pp_cq_prefix,pp_cq_num_in),"=%d"}, ldb_credit_count_in);

    `ovm_create(pp_cq_seq)
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_num_in));
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
                     pp_cq_num                  == pp_cq_num_in;      // Producer Port/Consumer Queue number
                     pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type

                     cq_depth                   == cq_depth_in;

                     queue_list.size()          == queue_list_size;

                     hcw_enqueue_batch_min      == 1;  // Minimum number of HCWs to send as a batch (1-4)
                     hcw_enqueue_batch_max      == 1;  // Maximum number of HCWs to send as a batch (1-4)

                     queue_list_delay_min       == hcw_delay_in;
                     queue_list_delay_max       == hcw_delay_in;

                     cq_addr                    == cq_addr_val;

                     cq_poll_interval           == 1;
                   } ) begin
      `ovm_warning("HCW_PP_CQ_ARBTRF_SEQ", "Randomization failed for pp_cq_seq");
    end

    vf_num_val = -1;

    $value$plusargs({$psprintf("%s_PP%0d_VF",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, vf_num_val);

    if (vf_num_val >= 0) begin
      pp_cq_seq.is_vf   = 1;
      pp_cq_seq.vf_num  = vf_num_val;
    end

    $value$plusargs({$psprintf("%s_PP%0d_QID",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, qid);

    qtype_str = qtype.name();
    $value$plusargs({$psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%s"}, qtype_str);
    qtype_str = qtype_str.tolower();

    //-- this option parse doesn't work (TBC)
    //for (int idx = 0 ; idx < 16 ; idx++) begin
        //$value$plusargs({$psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%s"}, qtype_str);
        //qtype_str_list[idx] = qtype_str.tolower();
        // ovm_report_info(get_type_name(),$psprintf("Seq_Setting_qtype_str_list[%0d]=%0s", idx, qtype_str_list[idx]),  OVM_LOW);
    //end
    
    //-- use this option instead to specify qtypes from testcases    
    if(trftype_sel==0) begin
         for(int idx=0; idx<16; idx++) qtype_str_list[idx] = "qatm";
    end else if(trftype_sel==1) begin
         for(int idx=0; idx<16; idx++) begin 
	    if(idx<8) qtype_str_list[idx] = "qatm";
	    else      qtype_str_list[idx] = "quno";    
         end  
    end else if(trftype_sel==2) begin
         for(int idx=0; idx<16; idx++) begin 
	    if(idx<4)                qtype_str_list[idx] = "quno";
	    else if(idx>=4 && idx<8) qtype_str_list[idx] = "qatm";    
            else                     qtype_str_list[idx] = "qdir";    	    
         end   	
    end else if(trftype_sel==3) begin
         for(int idx=0; idx<16; idx++) begin 
	    if(idx<2) qtype_str_list[idx] = "qatm";
	    else      qtype_str_list[idx] = "quno";    
         end 	     
    end else if(trftype_sel==4) begin
         for(int idx=0; idx<16; idx++) begin 
	    if(idx%2==0)             qtype_str_list[idx] = "quno";
            else                     qtype_str_list[idx] = "qdir";    	    
         end  
    end         

    for (int idx = 0 ; idx < 16 ; idx++) begin 
         ovm_report_info(get_type_name(),$psprintf("Seq_Setting_qtype_str_list[%0d]=%0s", idx, qtype_str_list[idx]),  OVM_LOW);
    end
    
    
    
    for (int pri = 0 ; pri < 8 ; pri++) begin
      if (pri == 0) begin
        qpri_weight[pri] = 1;
      end else begin
        qpri_weight[pri] = 0;
      end

      $value$plusargs({$psprintf("%s_PP%0d_QPRI%0d_WEIGHT",pp_cq_prefix,pp_cq_seq.pp_cq_num,pri),"=%d"}, qpri_weight[pri]);
    end

    init_tok_return_delay     = 0;
    $value$plusargs({$psprintf("%s_PP%0d_TOK_RETURN_DELAY",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, init_tok_return_delay);

    init_comp_return_delay     = 0;
    $value$plusargs({$psprintf("%s_PP%0d_COMP_RETURN_DELAY",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, init_comp_return_delay);

    lock_id = 16'h4001;
    $value$plusargs({$psprintf("%s_PP%0d_LOCKID",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, lock_id);

    if ($test$plusargs($psprintf("%s_PP%0d_INC_LOCKID",pp_cq_prefix,pp_cq_seq.pp_cq_num))) begin
      inc_lock_id = 1'b1;
    end else begin
      inc_lock_id = 1'b0;
    end

    dsi = 16'h0100;
    $value$plusargs({$psprintf("%s_PP%0d_DSI",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, dsi);

    case (qtype_str)
      "qdir": qtype = QDIR;
      "quno": qtype = QUNO;
      "qatm": qtype = QATM;
      "qord": qtype = QORD;
    endcase

    pp_cq_seq.tok_return_delay_q.push_back(init_tok_return_delay);
    pp_cq_seq.comp_return_delay_q.push_back(init_comp_return_delay);

    for (int i = 0 ; i < queue_list_size ; i++) begin
      num_hcw_gen = 0;
      $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%d"}, num_hcw_gen);
      $value$plusargs({$psprintf("%s_Q%0d_HCW_DELAY",pp_cq_prefix,i),"=%d"}, hcw_delay_in);

      case (qtype_str_list[i])
        "qdir": qtype = QDIR;
        "quno": qtype = QUNO;
        "qatm": qtype = QATM;
        "qord": qtype = QORD;
      endcase

      pp_cq_seq.queue_list[i].num_hcw                   = num_hcw_gen;
      pp_cq_seq.queue_list[i].qid                       = qid + i;
      pp_cq_seq.queue_list[i].qtype                     = qtype;
      for (int pri = 0 ; pri < 8 ; pri++) begin
        pp_cq_seq.queue_list[i].qpri_weight[pri]          = qpri_weight[pri];
      end
      pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_in;
      pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_in;
      pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1'b1;
      pp_cq_seq.queue_list[i].inc_lock_id               = inc_lock_id;
      pp_cq_seq.queue_list[i].lock_id                   = lock_id;
      pp_cq_seq.queue_list[i].dsi                       = dsi;
      pp_cq_seq.queue_list[i].comp_flow                 = 1;
      pp_cq_seq.queue_list[i].cq_token_return_flow      = 1;
      pp_cq_seq.queue_list[i].illegal_hcw_gen_mode      = hqm_pp_cq_base_seq::NO_ILLEGAL;
      
      ovm_report_info(get_type_name(),$psprintf("start_pp_cq_generate__[%0d]: pp_cq_num_in=%0d/qtype=%0s/qid=%0d/inc_lock_id=%0d/lockid=0x%0x/delay=%0d", i, pp_cq_num_in, qtype.name(), pp_cq_seq.queue_list[i].qid, inc_lock_id, lock_id, hcw_delay_in ),  OVM_LOW);
      
      
    end

    finish_item(pp_cq_seq);
  endtask

endclass
