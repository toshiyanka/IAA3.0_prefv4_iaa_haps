// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
// File   : hqm_reg_cfg_base_seq.sv
// Author : vijayaga 
//
// Description :
//  register config write/read  base sequence
//   
//
// -----------------------------------------------------------------------------

class hqm_reg_cfg_base_seq extends ovm_sequence;
  `ovm_object_utils(hqm_reg_cfg_base_seq)

  sla_ral_env                   ral;
  sla_ral_access_path_t         ral_access_path;
  hqm_tb_env                    hqm_env;
  virtual hqm_misc_if           pins;
  string                        base_tb_env_hier     = "*";


  function new(string name = "hqm_reg_cfg_base_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 
    `sla_assert( $cast(hqm_env,   sla_utils::get_comp_by_name("i_hqm_tb_env")), (("Could not find i_hqm_tb_env\n")));
    if(hqm_env   == null) `ovm_error(get_full_name(),$psprintf("i_hqm_tb_env ptr is null")) else 
                          `ovm_info(get_full_name(),$psprintf("i_hqm_tb_env ptr is not null"),OVM_LOW) 
    `sla_assert( $cast(pins, hqm_env.pins),  (("Could not find hqm_misc_if pointer \n")));
    if(pins      == null) `ovm_error(get_full_name(),$psprintf("hqm_misc_if ptr is null"))    else
                          `ovm_info(get_full_name(),$psprintf("hqm_misc_if ptr is not null"),OVM_LOW)   
    `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
    ral_access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
  endfunction

  extern virtual task body();

  extern virtual task WriteReg( string          file_name,
                                string          reg_name,
                                sla_ral_data_t  wr_data
                              );


  extern virtual task WriteField( string                file_name,
                                  string                reg_name,
                                  string                field_name,
                                  sla_ral_data_t        wr_data
                                );

  extern virtual task ReadReg( string                   file_name,
                               string                   reg_name,
                               boolean_t                exp_error,
                               output  sla_ral_data_t   rd_data
                              );
  extern virtual task ReadField( string                 file_name,
                                 string                 reg_name,
                                 string                 field_name,
                                 boolean_t              exp_error,
                                 output  sla_ral_data_t rd_data
                                );
  extern virtual task poll(string                 file_name,
                                 string                 reg_name,
                                 string                 field_name,
                                 boolean_t              exp_error,
                                 input  sla_ral_data_t  exp_data);

  extern virtual task compare(string                 file_name,
                                 string                 reg_name,
                                 string                 field_name,
                                 boolean_t              exp_error,
                                 input  sla_ral_data_t  exp_data);
  extern virtual task read_and_check_reg( string                   file_name,
                               string                   reg_name,
                               boolean_t                exp_error,
                               output  sla_ral_data_t   rd_data
                              );

  extern virtual task compare_rtl_against_mirror(input string        powerwell,
                                                 boolean_t                exp_error,
                                                 ref sla_ral_field fields[$]
                                 );



  extern virtual task read_compare_reg(string file_name, string reg_name, output bit [31:0] reg_val, input bit chk=0, input boolean_t poll_=SLA_FALSE, input sla_ral_data_t chk_val=0);


  virtual task wait_for_clk(int number=10);
   repeat(number) begin @(sla_tb_env::sys_clk_r); end
  endtask


endclass : hqm_reg_cfg_base_seq

task hqm_reg_cfg_base_seq::body();
endtask : body

task hqm_reg_cfg_base_seq::read_and_check_reg( string                     file_name,
                                     string                     reg_name,
                                     boolean_t                  exp_error,
                                     output     sla_ral_data_t  rd_data
                                   );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);

  ral_reg.read_and_check(status,rd_data,ral_access_path,this,.sai(legal_sai),.ignore_access_error(exp_error));
endtask : read_and_check_reg




task hqm_reg_cfg_base_seq::compare_rtl_against_mirror ( string        powerwell,
                                                    boolean_t                exp_error,
                                                    ref sla_ral_field fields[$]
                                     );
  string fname[$];
  string fname_upper;
  sla_status_t          status;
  sla_ral_data_t        rd_val[$];
  sla_ral_sai_t         legal_sai;
  sla_ral_file my_files[$];
  sla_ral_reg  my_regs[$];
  sla_ral_field my_fields[$];
  ral.get_reg_files(my_files, ral);
  if (my_files.size() == 0)
    `ovm_error(get_full_name(),$sformatf(" my_files size is zero %d", my_files.size()))
  foreach (my_files[i]) begin  
     `ovm_info(get_full_name(),$sformatf("files[%0d]=%s",i,my_files[i].get_name()),OVM_MEDIUM)
     my_files[i].get_regs(my_regs);
    if (my_regs.size() == 0)
       `ovm_error(get_full_name(),$sformatf(" my_regs size is zero %d", my_regs.size()))
     foreach (my_regs[i]) begin
         `ovm_info(get_full_name(),$sformatf("regs[%0d]=%s",i,my_regs[i].get_name()),OVM_MEDIUM)
         my_regs[i].get_fields(my_fields);
         legal_sai     = my_regs[i].pick_legal_sai_value(RAL_READ);
         if (my_fields.size() == 0)
            `ovm_error(get_full_name(),$sformatf(" my_fields size is zero %d", my_fields.size()))
         foreach (my_fields[i]) begin 
            `ovm_info(get_full_name(),$sformatf("fields[%0d]=%s, powerwell %s",i,my_fields[i].get_name(),my_fields[i].get_powerwell()),OVM_MEDIUM)
            if (my_fields[i].get_powerwell() == powerwell) begin
                fields.push_back(my_fields[i]);
                fname_upper = my_fields[i].get_name();
                fname.push_back(fname_upper.toupper());
            end
         end
         my_regs[i].read_and_check_fields(status,fname,rd_val,ral_access_path,this,.sai(legal_sai),.ignore_access_error(exp_error));
         if (status == SLA_OK)
            `ovm_info(get_full_name(),$sformatf("status= %s",status),OVM_MEDIUM)
         else    
            `ovm_error(get_full_name(),$sformatf("read_and_check_fields: status= %s",status))
     end 
  end
endtask : compare_rtl_against_mirror

task hqm_reg_cfg_base_seq::poll  ( string                   file_name,
                                       string                   reg_name,
                                       string                   field_name,
                                       boolean_t                exp_error,
                                       input   sla_ral_data_t   exp_data
                                     );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_ral_field         ral_field;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;
  sla_ral_data_t        rd_val[$];
  sla_ral_data_t        reg_val;
  sla_ral_data_t        rd_data;
  string                field_names[$];
  sla_ral_data_t        exp_vals[$];

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  field_name = field_name.toupper();
  ral_field = ral_reg.find_field(field_name);
  if (ral_field == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL field ",field_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);
  foreach (field_names[i])`ovm_info(get_full_name(),$sformatf("\nfield_names[%0d] = %s\n", i, field_names[i]),OVM_LOW)
  foreach (exp_vals[i]) `ovm_info(get_full_name(),$sformatf("\n exp_vals[%0d] = %h", i, exp_vals[i]),OVM_LOW) 
  field_names.delete();
  exp_vals.delete();
   
  field_names.push_back(field_name);
  exp_vals.push_back(exp_data);
  foreach (field_names[i])`ovm_info(get_full_name(),$sformatf("\nfield_names[%0d] = %s\n", i, field_names[i]),OVM_LOW)
  foreach (exp_vals[i]) `ovm_info(get_full_name(),$sformatf("\n exp_vals[%d] = %h", i, exp_vals[i]),OVM_LOW) 
  foreach (rd_val[i]) `ovm_info(get_full_name(),$sformatf("\n  rd_val[%0d] = %h", i, rd_val[i]),OVM_LOW)

  `ovm_info(get_full_name(),$sformatf("\n status = %s, ral_access_path = %s, legal_sai = %h, exp_error = %b", status, ral_access_path, legal_sai, exp_error),OVM_LOW)
  ral_reg.readx_fields(status,field_names,exp_vals,rd_val,ral_access_path,SLA_TRUE,this,.sai(legal_sai),.ignore_access_error(exp_error));
  reg_val = rd_val.pop_front(); 
  rd_data = ral_field.get_val(reg_val);

endtask : poll

task hqm_reg_cfg_base_seq::WriteReg( string               file_name,
                                      string               reg_name,
                                      sla_ral_data_t       wr_data
                                    );
  sla_ral_file      ral_file;
  sla_ral_reg       ral_reg;
  sla_status_t      status;
  sla_ral_sai_t     legal_sai;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_WRITE);

  ral_reg.write(status,wr_data,ral_access_path,this,.sai(legal_sai));
endtask : WriteReg

task hqm_reg_cfg_base_seq::WriteField( string          file_name,
                                        string          reg_name,
                                        string          field_name,
                                        sla_ral_data_t  wr_data
                                      );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;
  string                field_names[$];
  sla_ral_data_t        field_vals[$];

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_WRITE);

  field_name = field_name.toupper();
  field_names.delete();
  field_vals.delete();

  field_names.push_back(field_name);
  field_vals.push_back(wr_data);

  ral_reg.write_fields(status,field_names,field_vals,ral_access_path,this,.sai(legal_sai));
endtask : WriteField

task hqm_reg_cfg_base_seq::ReadReg( string                     file_name,
                                     string                     reg_name,
                                     boolean_t                  exp_error,
                                     output     sla_ral_data_t  rd_data
                                   );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);

  ral_reg.read(status,rd_data,ral_access_path,this,.sai(legal_sai),.ignore_access_error(exp_error));
endtask : ReadReg

task hqm_reg_cfg_base_seq::ReadField( string                   file_name,
                                       string                   reg_name,
                                       string                   field_name,
                                       boolean_t                exp_error,
                                       output   sla_ral_data_t  rd_data
                                     );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_ral_field         ral_field;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;
  sla_ral_data_t        reg_val;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  field_name = field_name.toupper();
  ral_field = ral_reg.find_field(field_name);
  if (ral_field == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL field ",field_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);

  ral_reg.read(status,reg_val,ral_access_path,this,.sai(legal_sai),.ignore_access_error(exp_error));

  rd_data = ral_field.get_val(reg_val);
endtask : ReadField
task hqm_reg_cfg_base_seq::compare  ( string                   file_name,
                                       string                   reg_name,
                                       string                   field_name,
                                       boolean_t                exp_error,
                                       input   sla_ral_data_t   exp_data
                                     );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_ral_field         ral_field;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;
  sla_ral_data_t        rd_val[$];
  sla_ral_data_t        reg_val;
  sla_ral_data_t        rd_data;
  string                field_names[$];
  sla_ral_data_t        exp_vals[$];

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  field_name = field_name.toupper();
  ral_field = ral_reg.find_field(field_name);
  if (ral_field == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL field ",field_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);
  foreach (field_names[i])`ovm_info(get_full_name(),$sformatf("\nfield_names[%0d] = %s\n", i, field_names[i]),OVM_LOW)
  foreach (exp_vals[i]) `ovm_info(get_full_name(),$sformatf("\n exp_vals[%0d] = %h", i, exp_vals[i]),OVM_LOW) 
  field_names.delete();
  exp_vals.delete();
   
  field_names.push_back(field_name);
  exp_vals.push_back(exp_data);
  foreach (field_names[i])`ovm_info(get_full_name(),$sformatf("\nfield_names[%0d] = %s\n", i, field_names[i]),OVM_LOW)
  foreach (exp_vals[i]) `ovm_info(get_full_name(),$sformatf("\n exp_vals[%0d] = %h", i, exp_vals[i]),OVM_LOW) 
  foreach (rd_val[i]) `ovm_info(get_full_name(),$sformatf("\n  rd_val[%0d] = %h", i, rd_val[i]),OVM_LOW)

  `ovm_info(get_full_name(),$sformatf("\n status = %s, ral_access_path = %s, legal_sai = %h, exp_error = %b", status, ral_access_path, legal_sai, exp_error),OVM_LOW)
  ral_reg.readx_fields(status,field_names,exp_vals,rd_val,ral_access_path,SLA_FALSE,this,.sai(legal_sai),.ignore_access_error(exp_error));
  reg_val = rd_val.pop_front(); 
  rd_data = ral_field.get_val(reg_val);

endtask : compare



task hqm_reg_cfg_base_seq::read_compare_reg(string file_name, string reg_name, output bit [31:0] reg_val, input bit chk=0, input boolean_t poll_=SLA_FALSE, input sla_ral_data_t chk_val=0);

    sla_ral_file   ral_file;
    sla_ral_reg    ral_reg;
    sla_ral_data_t rd_val;
    sla_ral_sai_t  legal_sai;
    sla_status_t   cfg_status; 

    ral_file = ral.find_file({base_tb_env_hier, file_name});
    if (ral_file == null) begin
      `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
       return;
    end

    ovm_report_info(get_full_name(), $psprintf("Reading reg %0s", reg_name), OVM_MEDIUM);
    ral_reg = ral_file.find_reg(reg_name);
    if (!ral_reg) begin 
       ovm_report_fatal(get_full_name(), $psprintf("No reg handle found in ral for reg_name :%0s", reg_name)); 
    end

    legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);
   if (chk) begin
       ral_reg.readx(.status(cfg_status), .expected(chk_val), .mask(32'h_ffff_ffff), .val(rd_val),.access_path(ral_access_path), .poll(poll_), .sai(legal_sai));
    end else begin
    	ral_reg.read(.status(cfg_status), .val(rd_val), .access_path(ral_access_path), .sai(legal_sai));
    end

    reg_val = rd_val;
    ovm_report_info(get_full_name(), $psprintf("Read reg %0s with val = %0x", reg_name, reg_val), OVM_DEBUG);
            
endtask : read_compare_reg
