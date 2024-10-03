`ifndef HQM_HCW_PP_ADDR_ALIASING_SEQ__SV
`define HQM_HCW_PP_ADDR_ALIASING_SEQ__SV

class hqm_hcw_pp_addr_aliasing_seq extends hqm_hcw_enq_sz_less_than_16B_seq;

  hqm_cfg                                      i_hqm_cfg;

  bit            hqm_bar_offset_rand = $test$plusargs("HQM_BAR_OFFSET_RAND");
  bit            is_nm_pf_val = $test$plusargs("HQM_IS_NM_PF_VAL_1");

  `ovm_sequence_utils(hqm_hcw_pp_addr_aliasing_seq, sla_sequencer)

    extern function                  new                           (string name = "hqm_hcw_pp_addr_aliasing_seq");
    extern task                      send_new_cmd                  (bit [7:0] pp, bit is_ldb, hcw_qtype qtype, bit [7:0] qid, bit [9:0] i_length = 'd4, bit is_nm_pf = 1'b0, bit [3:0] i_first_byte_en = 4'hf, bit [3:0] i_last_byte_en = 4'hf, bit [63:0] bar_offset = 'h0);
    extern task                      body                          ();


endclass : hqm_hcw_pp_addr_aliasing_seq


function hqm_hcw_pp_addr_aliasing_seq::new(string name = "hqm_hcw_pp_addr_aliasing_seq");
  super.new(name);
endfunction

task hqm_hcw_pp_addr_aliasing_seq::body();

      ovm_object     o_tmp;
      sla_ral_addr_t addr;
      sla_ral_reg    reg_h;
      sla_ral_data_t rd_data;
      hcw_qtype      qtype_in;
      bit            is_ldb;
      bit [7:0]      pp_num;
      bit [7:0]      pp_num_l;
      bit [7:0]      pp_num_h;
      bit [7:0]      lqid;
      bit [7:0]      qid;
      bit [31:0]     exp_synd_val;
    ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);
      //-----------------------------
      //-- get i_hqm_cfg
      //-----------------------------
      if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
        ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
      end

      if (!$cast(i_hqm_cfg, o_tmp)) begin
        ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
      end  

      // -- Start traffic with the default bus number for VF and PF
     ovm_report_info(get_full_name(), $psprintf("Starting traffic on HQM "), OVM_LOW);

     if (! ((i_hqm_cfg.get_name_val("PP0", pp_num) ) ||(i_hqm_cfg.get_name_val("LPP0", pp_num)))  ) begin
        ovm_report_fatal(get_full_name(), $psprintf("Couldn't find PP label in configuration file"));
     end 
     if (i_hqm_cfg.get_name_val("LPP0", pp_num)) begin
         i_hqm_cfg.get_name_val("LQID0",lqid); 
         is_ldb =1;
         qtype_in=QUNO;
         qid=lqid;
         ovm_report_info(get_full_name(), $psprintf("LDB pp_num=0x%0x, is_ldb=%0d, qid=0x%0x, qtype=%s is_nm_pf=0x%0x", pp_num, is_ldb, qid, qtype_in, is_nm_pf_val), OVM_LOW);
     end
     else if (i_hqm_cfg.get_name_val("PP0", pp_num)) begin
         is_ldb =0;
         qtype_in=QDIR;
         qid=pp_num;
         ovm_report_info(get_full_name(), $psprintf("DIR pp_num=0x%0x, is_ldb=%0d, qid=0x%0x, qtype=%s is_nm_pf=0x%0x", pp_num, is_ldb, qid, qtype_in, is_nm_pf_val), OVM_LOW);
     end 
     else begin
        ovm_report_fatal(get_full_name(), $psprintf("Couldn't find any DIR/LDB PP label in configuration file 1"));
     end

    if(pp_num==0)begin
      pp_num_l = is_ldb ? 'b00111111: 'b01011111;
    end
    else //pp_num!=0
      pp_num_l = pp_num-1; 
    
    if(is_ldb) begin
      pp_num_h = (pp_num== (hqm_pkg::NUM_LDB_CQ-1)) ? 0: pp_num+1;
    end else begin //dir     
      pp_num_h = (pp_num== (hqm_pkg::NUM_DIR_CQ-1)) ? 0: pp_num+1;
    end
 
      send_new_cmd(.pp(pp_num_l), .is_ldb(is_ldb), .qtype(qtype_in), .qid(qid), .is_nm_pf(is_nm_pf_val) );
      wait_ns_clk(500);
      send_new_cmd(.pp(pp_num_h), .is_ldb(is_ldb), .qtype(qtype_in), .qid(qid), .is_nm_pf(is_nm_pf_val) );
      wait_ns_clk(500);
      send_iosf_prim(.pp(pp_num), .is_ldb(is_ldb), .cmd('b1000), .qtype(qtype_in), .qid(qid) , .lockid($urandom), .is_nm_pf(is_nm_pf_val) );
      wait_ns_clk(500);
      // -- Return token 
      if(is_nm_pf_val)begin
        // wait for scheduling 3-hcw scheduled
        poll_reg("hqm_system_cnt_8",  'h3, "hqm_system_csr");
        send_batt_iosf_prim(.pp(pp_num_l), .is_ldb(is_ldb), .num_tkn(1), .is_nm_pf(is_nm_pf_val));  
        send_batt_iosf_prim(.pp(pp_num_h), .is_ldb(is_ldb), .num_tkn(1), .is_nm_pf(is_nm_pf_val));     
      end else begin
        poll_reg("hqm_system_cnt_8",  'h1, "hqm_system_csr");
        ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier"), OVM_LOW);
        send_batt_iosf_prim(.pp(pp_num), .is_ldb(is_ldb), .num_tkn(1), .is_nm_pf(is_nm_pf_val));     
      end

      if(is_ldb==1) begin
        send_iosf_prim(.pp(pp_num), .is_ldb(is_ldb), .cmd('b0010), .qtype(qtype_in), .qid(qid) , .lockid($urandom), .is_nm_pf(is_nm_pf_val) );
        if (is_nm_pf_val) begin
          send_iosf_prim(.pp(pp_num_l), .is_ldb(is_ldb), .cmd('b0010), .qtype(qtype_in), .qid(qid) , .lockid($urandom), .is_nm_pf(is_nm_pf_val) );
          send_iosf_prim(.pp(pp_num_h), .is_ldb(is_ldb), .cmd('b0010), .qtype(qtype_in), .qid(qid) , .lockid($urandom), .is_nm_pf(is_nm_pf_val) );
        end     
      end

      wait_ns_clk(200);
      if(hqm_bar_offset_rand || is_nm_pf_val) begin 
      ovm_report_info(get_full_name(), $psprintf("No Syndrome observed"), OVM_LOW);
      end
      else begin
      exp_synd_val = {16'hC001,2'b0,is_ldb,5'b00001,pp_num_l};
      compare_reg("alarm_pf_synd0", exp_synd_val, rd_val,"hqm_system_csr");
      compare_reg("hqm_system_cnt_4", 'h2, rd_val,"hqm_system_csr");
      wait_ns_clk(100);
      end
        
  endtask


task hqm_hcw_pp_addr_aliasing_seq::send_new_cmd(bit [7:0] pp, bit is_ldb, hcw_qtype qtype, bit [7:0] qid, bit [9:0] i_length = 'd4, bit is_nm_pf = 1'b0, bit [3:0] i_first_byte_en = 4'hf, bit [3:0] i_last_byte_en = 4'hf, bit [63:0] bar_offset = 'h0);


    IosfPkg::IosfTxn tlp;
    Iosf::data_t     hcw_data[$];
    bar_offset[63:0]  = hqm_bar_offset_rand ? $urandom_range(1024,4032): '0 ;
    bar_offset[5:0]   = 6'b0; // HCW is always cache aligned 
    $display("bar_offset=0x%0x",bar_offset[63:0]);
    ovm_report_info(get_full_name(), $psprintf("send_new_cmd(pp=0x%0x, is_ldb=%0b, qtype=%0s,    qid=0x%0x, i_length=0x%0x, is_nm_pf=%0b, i_first_byte_en=%b, i_last_byte_en=%b, bar_offset=0x%0x) -- Start",
                                                             pp,       is_ldb,     qtype.name(), qid,       i_length,       is_nm_pf,     i_first_byte_en,    i_last_byte_en, bar_offset), OVM_DEBUG);
    get_new_cmd(qtype, qid, hcw_data);
    tlp = get_hcw_tlp(pp, is_ldb, i_length, hcw_data, is_nm_pf, i_first_byte_en, i_last_byte_en, bar_offset);
    send_tlp(tlp);
    //ovm_report_info(get_full_name(), $psprintf("send_new_cmd(pp=0x%0x, is_ldb=%0b, qtype=%0s,    qid=0x%0x, i_length=0x%0x, is_nm_pf=%0b, i_first_byte_en=%b, i_last_byte_en=%b, bar_offset=0x%0x) -- End",
    //                                                         pp,       is_ldb,     qtype.name(), qid,       i_length,       is_nm_pf,     i_first_byte_en,    i_last_byte_en, bar_offset), OVM_DEBUG);


    ovm_report_info(get_full_name(), $psprintf("send_new_cmd(pp=0x%0x, is_ldb=%0b, qtype=%0s,    qid=0x%0x, i_length=0x%0x, is_nm_pf=%0b, i_first_byte_en=%b, i_last_byte_en=%b, bar_offset=0x%0x) -- End",
                                                             pp,       is_ldb,     qtype.name(), qid,       i_length,       is_nm_pf,     i_first_byte_en,    i_last_byte_en, bar_offset), OVM_LOW);
endtask : send_new_cmd

`endif //HQM_HCW_PP_ADDR_ALIASING_SEQ__SV



