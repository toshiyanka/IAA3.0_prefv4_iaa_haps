import hqm_tb_cfg_pkg::*;

class hcw_test0_hcw_seq extends hqm_base_cfg_seq;

    `ovm_sequence_utils(hcw_test0_hcw_seq, sla_sequencer)

    // -----------------------------------------------------
    // Data members
    // -----------------------------------------------------
    int trf_loop;
    int num_hcw;
    int idle_loop;

    // -----------------------------------------------------
    // Constructor
    // -----------------------------------------------------
    function new(string name = "hcw_test0_hcw_seq");
       super.new(name);
       trf_loop=1; 
       $value$plusargs("HQM_HCW_TEST0_TRF_NUM=%d", trf_loop);

       num_hcw=$urandom_range(1,16);
       $value$plusargs("HQM_HCW_TEST0_NUM_HCW=%d", num_hcw);

       idle_loop=1;
       $value$plusargs("HQM_HCW_TEST0_IDLE_NUM=%d", idle_loop);
    endfunction

    virtual task body();
      string hcw_dq_string;
     `ovm_info(get_name(), $psprintf("hcw_test0_hcw_seq: Start num_hcw=%0d trf_loop=%0d idle_loop=%0d",num_hcw, trf_loop, idle_loop), OVM_NONE);

      for(int kk=0; kk<trf_loop; kk++) begin  
           //--------------
           `ovm_info(get_name(), $psprintf("hcw_test0_hcw_seq:%0d_%0d Enqueue num_hcw=%0d", kk,trf_loop,num_hcw), OVM_NONE);
           for (int i=0; i<num_hcw; i++) begin
              cfg_cmds.push_back("HCW DIR:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302");
           end
    
           //--------------
           `ovm_info(get_name(), $psprintf("hcw_test0_hcw_seq:%0d_%0d Wait idle_loop=%0d", kk,trf_loop,idle_loop), OVM_NONE);
           for(int i=0; i<idle_loop; i++) begin
              cfg_cmds.push_back("IDLE 500");
           end
    
           //--------------
           `ovm_info(get_name(), $psprintf("hcw_test0_hcw_seq:%0d_%0d Return tokens=%0d", kk,trf_loop,num_hcw), OVM_NONE);
           hcw_dq_string = $psprintf("HCW DIR:0 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x00%h msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302",num_hcw-1);
          `ovm_info(get_name(), $psprintf("hcw_test0_hcw_seq:  HCW DQ string:%s",hcw_dq_string), OVM_NONE);
           cfg_cmds.push_back(hcw_dq_string);
           cfg_cmds.push_back("IDLE 500");

           `ovm_info(get_name(), $psprintf("hcw_test0_hcw_seq:%0d_%0d Done", kk,trf_loop), OVM_NONE);
      end //for(int kk=0;
  
       super.body();
      `ovm_info(get_name(), $psprintf("hcw_test0_hcw_seq: Finished"), OVM_LOW);
    endtask

endclass
