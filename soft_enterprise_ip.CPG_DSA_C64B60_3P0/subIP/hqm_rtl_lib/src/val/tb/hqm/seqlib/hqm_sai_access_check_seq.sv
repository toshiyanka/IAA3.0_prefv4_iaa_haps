`ifndef HQM_SAI_ACCESS_CHECK_SEQ__SV
`define HQM_SAI_ACCESS_CHECK_SEQ__SV

// Read access to the policy registers is not controlled by the values in the policy registers. You can read them regardless of SAI.

`include "stim_config_macros.svh"

class hqm_sai_access_check_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_sai_access_check_seq_stim_config";

  `ovm_object_utils_begin(hqm_sai_access_check_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_sai_access_check_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hqm_sai_access_check_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_sai_access_check_seq_stim_config

class hqm_sai_access_check_seq extends hqm_base_seq ;

  `ovm_object_utils( hqm_sai_access_check_seq)

  rand hqm_sai_access_check_seq_stim_config        cfg;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_sai_access_check_seq_stim_config);

  function new(string name = "hqm_sai_access_check_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 
    cfg = hqm_sai_access_check_seq_stim_config::type_id::create("hqm_sai_access_check_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();
  extern virtual task sai_enable_cfg_check();
  extern virtual task sai_check_on_policy_ctrl_regs();
  extern virtual task sai_enable_read_check(input int i,input logic  [63:0]  wr_data);
  extern virtual task sai_enable_write_check(input int i);
  extern virtual task restore_policy_ctrl_regs(bit [5:0] sai);
  extern virtual function get_sai_6(input bit [7:0] sai_8, output bit [5:0] sai_6);


endclass : hqm_sai_access_check_seq



task hqm_sai_access_check_seq::body();

  apply_stim_config_overrides(1);
   if(!$test$plusargs("WAC_SAI_WR_CHK")) begin
     `ovm_info(get_full_name(),$sformatf("\n hqm_sai_access_check_seq->sai_enable_cfg_check started \n"),OVM_LOW)
      sai_enable_cfg_check();
   end else begin
     `ovm_info(get_full_name(),$sformatf("\n hqm_sai_access_check_seq->sai_check_on_policy_ctrl_regs started \n"),OVM_LOW)
      sai_check_on_policy_ctrl_regs();
  end  
 `ovm_info(get_full_name(),$sformatf("\n hqm_sai_access_check_seq  ended \n"),OVM_LOW)
endtask: body


task hqm_sai_access_check_seq::sai_enable_cfg_check();

  sla_ral_data_t rd_reg_val;
  sla_ral_data_t rd_field_val[$];

  sla_ral_data_t  wac_lo_rd_val = 32'h0; 
  logic  [63:0]  wr_data;
  logic  [31:0]  wr_data_a = 32'hA5A5A5A5;
  bit    [5:0]   sai_6;
  int            i=0;

  if(!$value$plusargs("SAI_INDEX=%0d", i))
  begin i = 0;   end

  `ovm_info(get_full_name(),$sformatf("\n hqm_sai_access_check_seq SAI_INDEX=%0d \n", i),OVM_LOW)
   wr_data = 64'h0000000000000001 << i ;
  `ovm_info(get_full_name(),$sformatf("\n hqm_sai_access_check_seq wr_data=0x%0x shift_i=0x%0x \n", wr_data, i),OVM_LOW)
   if (i < 32) begin
     write_reg ("HQM_CSR_CP_LO",  wr_data[31:0],  "hqm_sif_csr", .sai(3));
     write_reg ("HQM_CSR_CP_HI",  wr_data[63:32], "hqm_sif_csr", .sai(i));
   end else begin
     write_reg ("HQM_CSR_CP_HI",  wr_data[63:32], "hqm_sif_csr", .sai(3));
     write_reg ("HQM_CSR_CP_LO",  wr_data[31:0],  "hqm_sif_csr", .sai(i));
   end
   write_reg ("HQM_CSR_WAC_LO", wr_data[31:0],  "hqm_sif_csr", .sai(i));
   write_reg ("HQM_CSR_WAC_HI", wr_data[63:32], "hqm_sif_csr", .sai(i));
   write_reg ("HQM_CSR_RAC_LO", wr_data[31:0],  "hqm_sif_csr", .sai(i));
   write_reg ("HQM_CSR_RAC_HI", wr_data[63:32], "hqm_sif_csr", .sai(i));

   compare_reg ("HQM_CSR_CP_LO",   wr_data[31:0],  rd_reg_val, "hqm_sif_csr", .sai(i));
   compare_reg ("HQM_CSR_CP_HI",   wr_data[63:32], rd_reg_val, "hqm_sif_csr", .sai(i));
   compare_reg ("HQM_CSR_WAC_LO",  wr_data[31:0],  rd_reg_val, "hqm_sif_csr", .sai(i));
   compare_reg ("HQM_CSR_WAC_HI",  wr_data[63:32], rd_reg_val, "hqm_sif_csr", .sai(i));
   compare_reg ("HQM_CSR_RAC_LO",  wr_data[31:0],  rd_reg_val, "hqm_sif_csr", .sai(i));
   compare_reg ("HQM_CSR_RAC_HI",  wr_data[63:32], rd_reg_val, "hqm_sif_csr", .sai(i));

   if(!$test$plusargs("SAI_WR_CHK_ENB")) 
   // task to perform read only
   begin sai_enable_read_check(i, wr_data); end
   // task to perform wr check 
   else begin sai_enable_write_check(i); end

   restore_policy_ctrl_regs(.sai(i));

   `ovm_info(get_full_name(),$sformatf("\n hqm_sai_access_check_seq  end \n"),OVM_LOW)

endtask :sai_enable_cfg_check


task hqm_sai_access_check_seq::sai_check_on_policy_ctrl_regs();

  sla_ral_data_t rd_reg_val;
  sla_ral_data_t rd_field_val[$];

  logic  [63:0]  wr_data;
  int            i=0;
  int            j=0;

    write_reg ("HQM_CSR_RAC_LO",   `HQM_CSR_RAC_LO, "hqm_sif_csr", .sai(3));
    write_reg ("HQM_CSR_WAC_LO",   `HQM_CSR_WAC_LO, "hqm_sif_csr", .sai(3));
    write_reg ("HQM_CSR_RAC_HI",   `HQM_CSR_RAC_HI, "hqm_sif_csr", .sai(3));
    write_reg ("HQM_CSR_WAC_HI",   `HQM_CSR_WAC_HI, "hqm_sif_csr", .sai(3));

    compare_reg ("HQM_CSR_WAC_LO", `HQM_CSR_WAC_LO, rd_reg_val, "hqm_sif_csr", .sai(3));
    compare_reg ("HQM_CSR_RAC_LO", `HQM_CSR_RAC_LO, rd_reg_val, "hqm_sif_csr", .sai(3));
    compare_reg ("HQM_CSR_WAC_HI", `HQM_CSR_WAC_HI, rd_reg_val, "hqm_sif_csr", .sai(3));
    compare_reg ("HQM_CSR_RAC_HI", `HQM_CSR_RAC_HI, rd_reg_val, "hqm_sif_csr", .sai(3));

  if(!$value$plusargs("SAI_INDEX=%0d", i))
  begin i = 0;   end
  `ovm_info(get_full_name(),$sformatf("\n hqm_sai_access_check_seq SAI_INDEX=%0d \n", i),OVM_LOW)
   wr_data = 64'h0000000000000001 << i ;
  `ovm_info(get_full_name(),$sformatf("\n hqm_sai_access_check_seq wr_data=0x%0x shift_i=0x%0x \n", wr_data, i),OVM_LOW)
   if (i < 32) begin
     write_reg ("HQM_CSR_CP_LO",  wr_data[31:0],  "hqm_sif_csr", .sai(3));
     write_reg ("HQM_CSR_CP_HI",  wr_data[63:32], "hqm_sif_csr", .sai(i));
   end else begin
     write_reg ("HQM_CSR_CP_HI",  wr_data[63:32], "hqm_sif_csr", .sai(3));
     write_reg ("HQM_CSR_CP_LO",  wr_data[31:0],  "hqm_sif_csr", .sai(i));
   end
   compare_reg ("HQM_CSR_CP_LO",   wr_data[31:0],  rd_reg_val, "hqm_sif_csr", .sai(i));
   compare_reg ("HQM_CSR_CP_HI",   wr_data[63:32], rd_reg_val, "hqm_sif_csr", .sai(i));

  for (j=0; j<32;j++) begin
      write_reg ("HQM_CSR_WAC_LO", `HQM_CSR_ALL_F,  "hqm_sif_csr", .sai(j));
      write_reg ("HQM_CSR_RAC_LO", `HQM_CSR_ALL_F,  "hqm_sif_csr", .sai(j));
     if(!(j==i)) begin //write was with illegal sai 
     `ovm_info(get_full_name(),$sformatf("\n hqm_sai_access_check_seq:Check with illegal sai value=%0d \n", j),OVM_LOW)
      compare_reg ("HQM_CSR_WAC_LO",  `HQM_CSR_WAC_LO, rd_reg_val, "hqm_sif_csr", .sai(j)); //read with illegal sai also return values
      compare_reg ("HQM_CSR_RAC_LO",  `HQM_CSR_RAC_LO, rd_reg_val, "hqm_sif_csr", .sai(j)); //read with illegal sai also return values
     end else begin //write was with legal sai 
     `ovm_info(get_full_name(),$sformatf("\n hqm_sai_access_check_seq:Check with legal sai value=%0d \n", j),OVM_LOW)
      compare_reg ("HQM_CSR_WAC_LO",  `HQM_CSR_ALL_F, rd_reg_val, "hqm_sif_csr", .sai(j)); //read with legal sai also return values
      compare_reg ("HQM_CSR_RAC_LO",  `HQM_CSR_ALL_F, rd_reg_val, "hqm_sif_csr", .sai(j)); //read with legal sai also return values
      //restore
      write_reg ("HQM_CSR_RAC_LO",   `HQM_CSR_RAC_LO, "hqm_sif_csr", .sai(j));
      write_reg ("HQM_CSR_WAC_LO",   `HQM_CSR_WAC_LO, "hqm_sif_csr", .sai(j));
      compare_reg ("HQM_CSR_RAC_LO", `HQM_CSR_RAC_LO, rd_reg_val, "hqm_sif_csr", .sai(j));
      compare_reg ("HQM_CSR_WAC_LO", `HQM_CSR_WAC_LO, rd_reg_val, "hqm_sif_csr", .sai(j));
     end
  end

  for (j=32; j<64;j++) begin
      write_reg ("HQM_CSR_WAC_HI", `HQM_CSR_ALL_F,  "hqm_sif_csr", .sai(j));
      write_reg ("HQM_CSR_RAC_HI", `HQM_CSR_ALL_F,  "hqm_sif_csr", .sai(j));
     if(j!=i) begin //write was with illegal sai 
     `ovm_info(get_full_name(),$sformatf("\n hqm_sai_access_check_seq:Check with illegal sai value=%0d \n", j),OVM_LOW)
      compare_reg ("HQM_CSR_WAC_HI",  `HQM_CSR_WAC_HI, rd_reg_val, "hqm_sif_csr", .sai(j));
      compare_reg ("HQM_CSR_RAC_HI",  `HQM_CSR_RAC_HI, rd_reg_val, "hqm_sif_csr", .sai(j));
     end else begin //write was with legal sai 
     `ovm_info(get_full_name(),$sformatf("\n hqm_sai_access_check_seq:Check with legal sai value=%0d \n", j),OVM_LOW)
      compare_reg ("HQM_CSR_WAC_HI",  `HQM_CSR_ALL_F, rd_reg_val, "hqm_sif_csr", .sai(j));
      compare_reg ("HQM_CSR_RAC_HI",  `HQM_CSR_ALL_F, rd_reg_val, "hqm_sif_csr", .sai(j));
      //restore
      write_reg ("HQM_CSR_RAC_HI",   `HQM_CSR_RAC_HI, "hqm_sif_csr", .sai(j));
      write_reg ("HQM_CSR_WAC_HI",   `HQM_CSR_WAC_HI, "hqm_sif_csr", .sai(j));
      compare_reg ("HQM_CSR_RAC_HI", `HQM_CSR_RAC_HI, rd_reg_val, "hqm_sif_csr", .sai(j));
      compare_reg ("HQM_CSR_WAC_HI", `HQM_CSR_WAC_HI, rd_reg_val, "hqm_sif_csr", .sai(j));
     end
  end

  restore_policy_ctrl_regs(.sai(i));

endtask : sai_check_on_policy_ctrl_regs

task hqm_sai_access_check_seq::restore_policy_ctrl_regs(bit [5:0] sai);

  sla_ral_data_t rd_reg_val;

  write_reg ("HQM_CSR_WAC_HI",   `HQM_CSR_WAC_HI, "hqm_sif_csr", .sai(sai));
  write_reg ("HQM_CSR_WAC_LO",   `HQM_CSR_WAC_LO, "hqm_sif_csr", .sai(sai));
  write_reg ("HQM_CSR_WAC_HI",   `HQM_CSR_WAC_HI, "hqm_sif_csr", .sai(sai));
  write_reg ("HQM_CSR_RAC_LO",   `HQM_CSR_RAC_LO, "hqm_sif_csr", .sai(sai));
  write_reg ("HQM_CSR_RAC_HI",   `HQM_CSR_RAC_HI, "hqm_sif_csr", .sai(sai));
  compare_reg ("HQM_CSR_WAC_LO",  `HQM_CSR_WAC_LO, rd_reg_val, "hqm_sif_csr", .sai(sai));
  compare_reg ("HQM_CSR_WAC_HI",  `HQM_CSR_WAC_HI, rd_reg_val, "hqm_sif_csr", .sai(sai));
  compare_reg ("HQM_CSR_RAC_LO",  `HQM_CSR_RAC_LO, rd_reg_val, "hqm_sif_csr", .sai(sai));
  compare_reg ("HQM_CSR_RAC_HI",  `HQM_CSR_RAC_HI, rd_reg_val, "hqm_sif_csr", .sai(sai));

  // write CP registers last to allow use of sai argument for WAC and RAC writes/checks
  write_reg ("HQM_CSR_CP_LO",   `HQM_CSR_CP_LO, "hqm_sif_csr", .sai(sai));
  write_reg ("HQM_CSR_CP_HI",   `HQM_CSR_CP_HI, "hqm_sif_csr", .sai(3));       // previous write possibly changes legal SAI
  compare_reg ("HQM_CSR_CP_LO",  `HQM_CSR_CP_LO, rd_reg_val, "hqm_sif_csr", .sai(3));
  compare_reg ("HQM_CSR_CP_HI",  `HQM_CSR_CP_HI, rd_reg_val, "hqm_sif_csr", .sai(3));
endtask : restore_policy_ctrl_regs

function hqm_sai_access_check_seq::get_sai_6 ( input bit [7:0] sai_8, output bit [5:0] sai_6);
    bit [7:0] sai_8_in;
    sai_8_in[7:0] = sai_8; 
   if ( sai_8_in[0] == 1) begin
     sai_6 = {3'b0,sai_8_in[3:1]}; 
   end
   if ((sai_8_in[0] == 0)) 
   begin
     if (~((7'b0000111 < sai_8_in[7:1]) && (sai_8_in[7:1] < 7'b0111111))) begin
        sai_6 = 6'b111111; 
     end
     else if (((7'b0000111 < sai_8_in[7:1]) && (sai_8_in[7:1] < 7'b0111111))) begin
      sai_6 = sai_8_in[6:1] ; 
     end
   end
endfunction 


task hqm_sai_access_check_seq::sai_enable_read_check(input int i,logic  [63:0]  wr_data);
  sla_ral_data_t rd_reg_val;
  bit    [5:0]   sai_6;
  int index_val;
  index_val=i;
   //rd-check for all 256 8 bit sai values
   for(int k=0;k<256;k++)begin
      get_sai_6 (.sai_8(k),.sai_6(sai_6));
      if (sai_6 != index_val) begin //illegal sai
         `ovm_info(get_full_name(),$sformatf("\n illegal_sai_access  sai_6=0x%0x sai_k=0x%0x \n", sai_6, k),OVM_LOW)
         //read returns all 0's 
         compare_reg   ("TOTAL_VF",                   `ILL_SAI_RD_VAL,                 rd_reg_val, "hqm_system_csr", .sai(sai_6)); 
         compare_reg   ("TOTAL_VAS",                  `ILL_SAI_RD_VAL,                 rd_reg_val, "hqm_system_csr", .sai(sai_6));
         compare_reg   ("TOTAL_LDB_PORTS",            `ILL_SAI_RD_VAL,                 rd_reg_val, "hqm_system_csr", .sai(sai_6));
         compare_reg   ("TOTAL_DIR_PORTS",            `ILL_SAI_RD_VAL,                 rd_reg_val, "hqm_system_csr", .sai(sai_6));
         compare_reg   ("TOTAL_LDB_QID",              `ILL_SAI_RD_VAL,                 rd_reg_val, "hqm_system_csr", .sai(sai_6));
         compare_reg   ("TOTAL_DIR_QID",              `ILL_SAI_RD_VAL,                 rd_reg_val, "hqm_system_csr", .sai(sai_6));
         compare_reg   ("TOTAL_CREDITS",              `ILL_SAI_RD_VAL,                 rd_reg_val, "hqm_system_csr", .sai(sai_6));
         compare_reg   ("CFG_AQED_TOT_ENQUEUE_LIMIT", `ILL_SAI_RD_VAL,                 rd_reg_val, "list_sel_pipe",  .sai(sai_6));
         compare_reg   ("HQM_CSR_WAC_LO",             wr_data[31:0],                    rd_reg_val, "hqm_sif_csr",   .sai(sai_6));
         compare_reg   ("HQM_CSR_WAC_HI",             wr_data[63:32],                   rd_reg_val, "hqm_sif_csr",   .sai(sai_6));
         compare_reg   ("HQM_CSR_RAC_LO",             wr_data[31:0],                    rd_reg_val, "hqm_sif_csr",   .sai(sai_6));
         compare_reg   ("HQM_CSR_RAC_HI",             wr_data[63:32],                   rd_reg_val, "hqm_sif_csr",   .sai(sai_6));
      end else begin //legal sai    //read expected value 
         `ovm_info(get_full_name(),$sformatf("\n legal_sai_access  sai_6=0x%0x sai_k=0x%0x \n", sai_6, k),OVM_LOW)
          compare_reg   ("TOTAL_VF",                   `DEF_VAL_TOTAL_VF,               rd_reg_val, "hqm_system_csr", .sai(sai_6)); 
          compare_reg   ("TOTAL_VAS",                  `DEF_VAL_TOTAL_VAS,              rd_reg_val, "hqm_system_csr", .sai(sai_6));
          compare_reg   ("TOTAL_LDB_PORTS",            `DEF_VAL_TOTAL_LDB_PORTS,        rd_reg_val, "hqm_system_csr", .sai(sai_6));
          compare_reg   ("TOTAL_DIR_PORTS",            `DEF_VAL_TOTAL_DIR_PORTS,        rd_reg_val, "hqm_system_csr", .sai(sai_6));
          compare_reg   ("TOTAL_LDB_QID",              `DEF_VAL_TOTAL_LDB_QID,          rd_reg_val, "hqm_system_csr", .sai(sai_6));
          compare_reg   ("TOTAL_DIR_QID",              `DEF_VAL_TOTAL_DIR_QID,          rd_reg_val, "hqm_system_csr", .sai(sai_6));
          compare_reg   ("TOTAL_CREDITS",              `DEF_VAL_TOTAL_CREDITS,          rd_reg_val, "hqm_system_csr", .sai(sai_6));
          compare_reg   ("CFG_AQED_TOT_ENQUEUE_LIMIT", `DEF_VAL_AQED_TOT_ENQUEUE_LIMIT, rd_reg_val, "list_sel_pipe",  .sai(sai_6));
          compare_reg   ("HQM_CSR_WAC_LO",             wr_data[31:0],                   rd_reg_val, "hqm_sif_csr",   .sai(sai_6));
          compare_reg   ("HQM_CSR_WAC_HI",             wr_data[63:32],                  rd_reg_val, "hqm_sif_csr",   .sai(sai_6));
          compare_reg   ("HQM_CSR_RAC_LO",             wr_data[31:0],                   rd_reg_val, "hqm_sif_csr",   .sai(sai_6));
          compare_reg   ("HQM_CSR_RAC_HI",             wr_data[63:32],                  rd_reg_val, "hqm_sif_csr",   .sai(sai_6));
      end
    end //for k
endtask : sai_enable_read_check


task hqm_sai_access_check_seq::sai_enable_write_check(input int i );
  sla_ral_data_t rd_reg_val;
  sla_ral_data_t rd_field_val[$];
  logic  [31:0]  wr_data_a = 32'hA5A5A5A5;
  logic  [31:0]  wr_data_b = 32'h0;
  bit    [5:0]   sai_6;
  int            sai_8;
  int min_range, max_range;
  int index_val;
  index_val=i;

   min_range = $urandom_range(0,150);
   max_range = $urandom_range(151,256);
   if ((max_range-min_range)>128) begin if (min_range[0]==1) max_range=min_range+128 ; else min_range=max_range-128; end
  `ovm_info(get_full_name(),$sformatf("\n min_range=0x%0x max_range=0x%0x \n", min_range, max_range),OVM_LOW)
  
   //wr with legal sai and read with legal and illegal sai values
    write_fields ("CFG_VAS_CREDIT_COUNT[0]",  {"COUNT"},  {wr_data_a[13:0]},  "credit_hist_pipe", .sai(index_val));
    write_fields ("CFG_VAS_CREDIT_COUNT[31]", {"COUNT"},  {wr_data_a[13:0]},  "credit_hist_pipe", .sai(index_val));
    write_fields ("CFG_DIR_CQ_DEPTH[0]",          {"DEPTH"},  {wr_data_a[12:0]},  "credit_hist_pipe", .sai(index_val));
    write_fields ("CFG_DIR_CQ_DEPTH[31]",         {"DEPTH"},  {wr_data_a[12:0]},  "credit_hist_pipe", .sai(index_val));
    write_fields ("CFG_DIR_CQ_DEPTH[63]",         {"DEPTH"},  {wr_data_a[12:0]},  "credit_hist_pipe", .sai(index_val));
    write_reg    ("CFG_DIR_WD_THRESHOLD",                      wr_data_a[31:0],   "credit_hist_pipe", .sai(index_val));
    compare_fields ("CFG_VAS_CREDIT_COUNT[0]",  {"COUNT"},  {wr_data_a[13:0]},  rd_field_val, "credit_hist_pipe", .sai(index_val));
    compare_fields ("CFG_VAS_CREDIT_COUNT[31]", {"COUNT"},  {wr_data_a[13:0]},  rd_field_val, "credit_hist_pipe", .sai(index_val));
    compare_fields ("CFG_DIR_CQ_DEPTH[0]",          {"COUNT"},  {wr_data_a[12:0]},  rd_field_val, "credit_hist_pipe", .sai(index_val));
    compare_fields ("CFG_DIR_CQ_DEPTH[31]",         {"COUNT"},  {wr_data_a[12:0]},  rd_field_val, "credit_hist_pipe", .sai(index_val));
    compare_fields ("CFG_DIR_CQ_DEPTH[63]",         {"COUNT"},  {wr_data_a[12:0]},  rd_field_val, "credit_hist_pipe", .sai(index_val));
    compare_reg    ("CFG_DIR_WD_THRESHOLD",                      wr_data_a[31:0],   rd_reg_val,   "credit_hist_pipe", .sai(index_val));

   //wr/rd check with all 8-bit sai values
   //vijayaga  for(int k=0;k<256;k++)begin
   for(int k=0 ;k<5;k++)begin
      sai_8 = $urandom_range(0,255);
      get_sai_6 (.sai_8(sai_8),.sai_6(sai_6));
      wr_data_b= $urandom();
      //write with illegal sai and  read back
      write_fields ("CFG_VAS_CREDIT_COUNT[0]",  {"COUNT"},  {wr_data_b[13:0]},  "credit_hist_pipe", .sai(sai_6));
      write_fields ("CFG_VAS_CREDIT_COUNT[31]", {"COUNT"},  {wr_data_b[13:0]},  "credit_hist_pipe", .sai(sai_6));
      write_fields ("CFG_DIR_CQ_DEPTH[0]",          {"DEPTH"},  {wr_data_b[12:0]},  "credit_hist_pipe", .sai(sai_6));
      write_fields ("CFG_DIR_CQ_DEPTH[31]",         {"DEPTH"},  {wr_data_b[12:0]},  "credit_hist_pipe", .sai(sai_6));
      write_fields ("CFG_DIR_CQ_DEPTH[63]",         {"DEPTH"},  {wr_data_b[12:0]},  "credit_hist_pipe", .sai(sai_6)); 
      write_reg    ("CFG_DIR_WD_THRESHOLD",                      wr_data_b[31:0],   "credit_hist_pipe", .sai(sai_6));
      if (sai_6 != index_val) begin //legal sai
        for(int j=min_range ;j<max_range ;j++)begin //illegal sai rd_chk
           get_sai_6 (.sai_8(j),.sai_6(sai_6));
           if (sai_6 != index_val) begin //illegal sai
            `ovm_info(get_full_name(),$sformatf("\n illegal_sai_access  sai_6=0x%0x sai_j=0x%0x \n", sai_6, j),OVM_LOW)
             compare_fields ("CFG_VAS_CREDIT_COUNT[0]",    {"COUNT"},  {`ILL_SAI_RD_VAL},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
             compare_fields ("CFG_VAS_CREDIT_COUNT[31]",   {"COUNT"},  {`ILL_SAI_RD_VAL},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
             compare_fields ("CFG_DIR_CQ_DEPTH[0]",            {"COUNT"},  {`ILL_SAI_RD_VAL},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
             compare_fields ("CFG_DIR_CQ_DEPTH[31]",           {"COUNT"},  {`ILL_SAI_RD_VAL},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
             compare_fields ("CFG_DIR_CQ_DEPTH[63]",           {"COUNT"},  {`ILL_SAI_RD_VAL},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
             compare_reg    ("CFG_DIR_WD_THRESHOLD",                      `ILL_SAI_RD_VAL,  rd_reg_val, "credit_hist_pipe", .sai(sai_6));
           end else begin //legal sai    //read expected value old
           `ovm_info(get_full_name(),$sformatf("\n legal_sai_access  sai_6=0x%0x sai_j=0x%0x \n", sai_6, j),OVM_LOW)
            compare_fields ("CFG_VAS_CREDIT_COUNT[0]",  {"COUNT"},  {wr_data_a[13:0]},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
            compare_fields ("CFG_VAS_CREDIT_COUNT[31]", {"COUNT"},  {wr_data_a[13:0]},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
            compare_fields ("CFG_DIR_CQ_DEPTH[0]",          {"COUNT"},  {wr_data_a[12:0]},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
            compare_fields ("CFG_DIR_CQ_DEPTH[31]",         {"COUNT"},  {wr_data_a[12:0]},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
            compare_fields ("CFG_DIR_CQ_DEPTH[63]",         {"COUNT"},  {wr_data_a[12:0]},  rd_field_val, "credit_hist_pipe", .sai(sai_6)); 
            compare_reg    ("CFG_DIR_WD_THRESHOLD",                      wr_data_a[31:0],   rd_reg_val,   "credit_hist_pipe", .sai(sai_6));
           end 
        end //for j illega sai
      end //illegal sai
      else begin //legal sai
        for(int j=min_range;j<max_range;j++)begin //legal sai rd_chk
           get_sai_6 (.sai_8(j),.sai_6(sai_6));
           if (sai_6 != index_val) begin //illegal sai
            `ovm_info(get_full_name(),$sformatf("\n illegal_sai_access  sai_6=0x%0x sai_j=0x%0x \n", sai_6, j),OVM_LOW)
             compare_fields ("CFG_VAS_CREDIT_COUNT[0]",    {"COUNT"},  {`ILL_SAI_RD_VAL},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
             compare_fields ("CFG_VAS_CREDIT_COUNT[31]",   {"COUNT"},  {`ILL_SAI_RD_VAL},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
             compare_fields ("CFG_DIR_CQ_DEPTH[0]",            {"COUNT"},  {`ILL_SAI_RD_VAL},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
             compare_fields ("CFG_DIR_CQ_DEPTH[31]",           {"COUNT"},  {`ILL_SAI_RD_VAL},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
             compare_fields ("CFG_DIR_CQ_DEPTH[63]",           {"COUNT"},  {`ILL_SAI_RD_VAL},  rd_field_val, "credit_hist_pipe", .sai(sai_6)); 
             compare_reg    ("CFG_DIR_WD_THRESHOLD",                      `ILL_SAI_RD_VAL,  rd_reg_val, "credit_hist_pipe", .sai(sai_6));
           end else begin //legal sai    //read expected value old
           `ovm_info(get_full_name(),$sformatf("\n legal_sai_access  sai_6=0x%0x sai_j=0x%0x \n", sai_6, j),OVM_LOW)
            compare_fields ("CFG_VAS_CREDIT_COUNT[0]",  {"COUNT"},  {wr_data_b[13:0]},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
            compare_fields ("CFG_VAS_CREDIT_COUNT[31]", {"COUNT"},  {wr_data_b[13:0]},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
            compare_fields ("CFG_DIR_CQ_DEPTH[0]",          {"COUNT"},  {wr_data_b[12:0]},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
            compare_fields ("CFG_DIR_CQ_DEPTH[31]",         {"COUNT"},  {wr_data_b[12:0]},  rd_field_val, "credit_hist_pipe", .sai(sai_6));
            compare_fields ("CFG_DIR_CQ_DEPTH[63]",         {"COUNT"},  {wr_data_b[12:0]},  rd_field_val, "credit_hist_pipe", .sai(sai_6)); 
            compare_reg    ("CFG_DIR_WD_THRESHOLD",                      wr_data_b[31:0],   rd_reg_val,   "credit_hist_pipe", .sai(sai_6));
            wr_data_a[31:0] = wr_data_b[31:0];
           end 
        end //for k illega sai
      end //legal sai
   end //for k
    write_fields ("CFG_VAS_CREDIT_COUNT[0]",  {"COUNT"},  {`ILL_SAI_RD_VAL},  "credit_hist_pipe", .sai(index_val));
    write_fields ("CFG_VAS_CREDIT_COUNT[31]", {"COUNT"},  {`ILL_SAI_RD_VAL},  "credit_hist_pipe", .sai(index_val));
    write_fields ("CFG_DIR_CQ_DEPTH[0]",          {"DEPTH"},  {`ILL_SAI_RD_VAL},  "credit_hist_pipe", .sai(index_val));
    write_fields ("CFG_DIR_CQ_DEPTH[31]",         {"DEPTH"},  {`ILL_SAI_RD_VAL},  "credit_hist_pipe", .sai(index_val));
    write_fields ("CFG_DIR_CQ_DEPTH[63]",         {"DEPTH"},  {`ILL_SAI_RD_VAL},  "credit_hist_pipe", .sai(index_val));
    write_reg    ("CFG_DIR_WD_THRESHOLD",                      `ILL_SAI_RD_VAL,   "credit_hist_pipe", .sai(index_val));
endtask: sai_enable_write_check



`endif
