/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  (C) Copyright Intel Corporation, 2018.  All Rights Reserved.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * File       : hqm_ral_backdoor.svh
 *
 * Description:
 *    HQM RAL backdoor
 *
 * History:
 *    Original: Mike Betker
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 */
`ifndef HQM_IP_TB_OVM
//--TMP_NOT_SUPPORTED class hqm_ral_backdoor extends uvm_reg_backdoor;

//--TMP_NOT_SUPPORTED    `uvm_object_utils_begin(hqm_ral_backdoor)
//--TMP_NOT_SUPPORTED    `uvm_object_utils_end

   //function: new
//--TMP_NOT_SUPPORTED    function new(string name = "hqm_ral_backdoor", sla_ral_env ral_env=null);
//--TMP_NOT_SUPPORTED       super.new(name, ral_env);
//--TMP_NOT_SUPPORTED    endfunction
//--TMP_NOT_SUPPORTED endclass : hqm_ral_backdoor

`else 
//class: hqm_ral_backdoor
//Register backdoor access class.
class hqm_ral_backdoor extends sla_ral_backdoor;

   `ovm_object_utils_begin(hqm_ral_backdoor)
   `ovm_object_utils_end

   //function: new
   function new(string name = "hqm_ral_backdoor", sla_ral_env ral_env=null);
      super.new(name, ral_env);
   endfunction

   /** Function to backdoor REG directly from RTL path.
    */
   extern protected function sla_status_t _backdoor( sla_ral_reg r,
                                                     ref sla_ral_data_t val,
                                                     input sla_ral_backdoor_t bkdr,
                                                     input boolean_t exclude_attr_override = SLA_FALSE, 
                                                     input string fields[$] = {}
                                                     );

   /** Write CSR directly from RTL path.
    * Forces value for force_time period.
    */
   extern virtual task write_backdoor( output sla_status_t status,
                                       input sla_ral_reg    r,
                                       input sla_ral_data_t val,
                                       input time           force_time = 0,
                                       input boolean_t      wait_for_complete=SLA_TRUE,
                                       input boolean_t      exclude_attr_override = SLA_FALSE
				       );
 
 
  /** Write named CSR fields directly from RTL path.
    * Forces value for force_time period.
    */
   extern virtual task write_backdoor_fields( output sla_status_t status,
                                       input sla_ral_reg    r,
                                       input  string        fnames[$],
                                       input sla_ral_data_t vals[$],
                                       input time           force_time = 0,
                                       input boolean_t      wait_for_complete=SLA_TRUE,
                                       input boolean_t      exclude_attr_override = SLA_FALSE
                       ); 

   /** Read a register directly from RTL path.
    */
   extern virtual function void read_backdoor( output sla_status_t status,
                                               input sla_ral_reg r,
                                               ref sla_ral_data_t val
                                               );


   extern virtual function void put_backdoor( output sla_status_t   status,
                                              input  sla_ral_reg    r,
                                              input  sla_ral_data_t val,
                                              input  boolean_t      exclude_attr_override = SLA_FALSE
                                              );

   extern virtual function bit hqm_read_backdoor_override( input  sla_ral_field  my_field,
                                                           input  sla_ral_reg    my_reg,
                                                           input  sla_ral_file   my_file,
                                                           input  string         field_name,
                                                           input  string         reg_name,
                                                           input  string         file_name,
                                                           input  string         path,
                                                           output bit            invert_data,
                                                           output sla_ral_data_t rdata);

   extern virtual function sla_status_t hqm_write_backdoor_override( input  sla_ral_field  my_field,
                                                                     input  sla_ral_reg    my_reg,
                                                                     input  sla_ral_file   my_file,
                                                                     input  string         field_name,
                                                                     input  string         reg_name,
                                                                     input  string         file_name,
                                                                     input  string         path,
                                                                     input  sla_ral_data_t wdata,
                                                                     input  int            slice_offset);

   extern virtual function sla_status_t hqm_write_qid2cqidix_backdoor( input  string  field_name,
                                                                       input  string  reg_prefix,
                                                                       input  string  path_mem_prefix,
                                                                       input  int     path_msb,
                                                                       input  int     path_lsb,
                                                                       input  sla_ral_data_t wdata,
                                                                       input  int     slice_offset);

   extern virtual function bit [1:0] gen_residue( input bit [127:0] data,
                                                  input int width);

   extern virtual function bit       gen_parity( input bit [127:0] data,
                                                  input int width);

endclass : hqm_ral_backdoor

//function: _backdoor
//Backdoor operation from RTL path. Utilizes MHPI/VPI/VHPI defined functions to access a register field by a string name defined by <sla_ral_field._paths>. 
// This method contains the bulk of functionality for the major user backdoor access methods. 
//* <read_backdoor>
//* <write_backdoor>
//* <put_backdoor>
//
//The functionality of _backdoor is controlled by the "bkdr" enumerated variable. 
//
//-BKDR_PUT - "Write" value. Used by both <write_backdoor> (when "force_time" is 0) and <put_backdoor> 
//-BKDR_GET - "Read" value. Used by <read_backdoor>. Results in a call to sla_mhpi_get_value_by_name. 
//-BKDR_FORCE - "Force and hold" value. Used by <write_backdoor> when "force_time" is non-zero. Results in a call to sla_mhpi_force_value_by_name, which calls the VHPI/VPI function.
//-BKDR_RELEASE - "Release - undo the force action" value. Used by <write_backdoor> to release the hold from using BKDR_FORCE.  Results in a call to sla_mhpi_release_value_by_name, which calls the VHPI/VPI function.
function sla_status_t hqm_ral_backdoor::_backdoor( sla_ral_reg r,
                                                   ref sla_ral_data_t val,
                                                   input sla_ral_backdoor_t bkdr,
                                                   input boolean_t exclude_attr_override = SLA_FALSE,
                                                   input string fields[$] = {}
                                                   );

   sla_status_t status                          = SLA_OK;
   string       file_name;
   string       reg_name;
   string	field_names[$];
   string       file_hdl_path;
   boolean_t    exclude_write                   = SLA_FALSE;
   sla_ral_file reg_file                        = r.get_file();
   bit 	        bit_blasting_enabled            = _ral_env.get_bit_blasting();
   bit          is_any_field_path_exist         = 0;
   int          rsv_field_empty_path_cnt        = 0; 

   file_name    = reg_file.get_name();
   reg_name     = r.get_name();

   if (fields.size() == 0)
      r.get_field_names( field_names );
   else
      field_names = fields;
   
   file_hdl_path = reg_file.get_hdl_path();

   if( bkdr == BKDR_GET ) begin
      val  = '0;
   end

   for (int i = 0; i < field_names.size(); ++i) begin
      string paths[$];
      string log2phy_path;
      string field_name    = field_names[i];
      sla_ral_field field  = r.find_field( field_name );
      sla_ral_data_t mask;
      sla_ral_data_t  wr_slice_tmp, rd_tmp_slice = '0;
      int unsigned slice_size = 0;
      int unsigned slice_offset = 0;
      log2phy_path = "";

      mask  = _get_mask(field.get_size);
      wr_slice_tmp   = (val >> field.get_lsb) & mask;
     
      field.get_paths( paths );
      if(field.get_logical_path() != "") begin
         sla_ral_env top_ral_env = sla_ral_env::get_ptr();
         log2phy_path = top_ral_env.get_log2phy_path(field.get_logical_path(), reg_file.get_name(), reg_file.get_unique_name); 
      end
    
    //  if (paths.size() == 0 || (paths.size() == 1 && ((paths[0] == "") || (paths[0].tolower() == "nosignal")) )) continue;
      if (paths.size() == 0 || (paths.size() == 1 && paths[0] == "") ) begin
          if (field.get_attr() == "RSV")  
              rsv_field_empty_path_cnt++;
          continue;
      end 
      else is_any_field_path_exist = 1;

      for (int j = 0; j < paths.size(); j++) begin
	    sla_ral_data_t  tmp  = '0 ;
	    string path;
	    if (file_hdl_path == "")
	      path         = _ral_env.get_full_hdl_path(paths[j]);
	    else
              path  = {file_hdl_path,".",paths[j]};

            if(log2phy_path != "") begin
               path = {log2phy_path, ".", path};
            end

	    if( bkdr == BKDR_GET ) begin
               if( path == "" || paths[j] == "" ) begin
		          tmp           = '0;
               end
               else begin
                  if(path.tolower() == "nosignal" || paths[j].tolower() == "nosignal") begin
                     if(j > 0) begin
                        status = SLA_FAIL;
                        `sla_error("backdoor", ("RAL> Register [%s] in File [%s] has field %s which has sliced path and one of the paths is NoSignal.NoSignal not supported with sliced_path.", 
                                       r.get_name(), reg_file.get_name(), field.get_name()));
                         break;
                     end
                     tmp = (field.get_reset_val() << field.get_lsb()); 
                     val = val | tmp;
                     `sla_msg( OVM_HIGH, "_backdoor", ( "RAL> Returning reset value %0x for field  %s", field.get_reset_val(), field.get_name()));                     
                     break;
                  end
                  if(!field.is_sliced_path() || paths.size() <= 1) begin		              
                    bit                 invert_data;

                    if (hqm_read_backdoor_override(field, r, reg_file, field_name, reg_name, file_name, path, invert_data, tmp) == 0) begin
                      tmp = sla_mhpi_get_value_by_name( path );
                      `ovm_info(get_full_name(),$psprintf("BACKDOOR READ of field %s.%s.%s, path=%s, val=0x%0x, invert_data=%0d",file_name,reg_name,field_name,path,tmp,invert_data),OVM_HIGH)

                      if (invert_data) tmp = (~tmp) & field.get_read_mask();
                    end
                    tmp  = (tmp << field.get_lsb());
                    val  = val | tmp;
                    `ovm_info(get_full_name(),$psprintf("BACKDOOR READ of field %s.%s.%s, path=%s, val=0x%0x, tmp=0x%0x",file_name,reg_name,field_name,path,val,tmp),OVM_HIGH)
                  end // !field.is_sliced_path()
                  else begin
                     chandle            handle;
                     string             SigType; 
                     int                tmp_slice_size;
                     sla_ral_data_t     tmp_slice = '0;
                     bit                invert_data;

                     handle = SLA_MHPI_handle_by_name( path, SigType );
                     tmp_slice_size = SLA_MHPI_get_signal_size(handle, SigType);
                     if (hqm_read_backdoor_override(field, r, reg_file, field_name, reg_name, file_name, path, invert_data, rd_tmp_slice) == 0) begin
                       tmp_slice = sla_mhpi_get_value( handle, path , SigType);
                       `ovm_info(get_full_name(),$psprintf("BACKDOOR READ of field %s.%s.%s, path=%s, val=0x%0x, invert_data=%0d, slice_size=%0d",file_name,reg_name,field_name,path,tmp_slice,invert_data,tmp_slice_size),OVM_HIGH)
                       if (invert_data) tmp_slice = (~tmp_slice) & ((1 << tmp_slice_size) - 1);
                       rd_tmp_slice = tmp_slice << slice_size;
                       slice_size += SLA_MHPI_get_signal_size(handle, SigType);
                     end

                     tmp  = (rd_tmp_slice << field.get_lsb());
                     val  = val | tmp;                     
                  end 
               end

	    end // BKDR_GET
	    else begin
               if( path == "" || paths[j] == "" ) begin
		  continue;
               end
               else begin
		  exclude_write = SLA_FALSE;
		  if (exclude_attr_override == SLA_FALSE) begin
		     foreach (_exclude_attr[i]) begin
			if (field.get_attr() == _exclude_attr[i]) begin
			   `sla_msg( OVM_HIGH, "_backdoor", ( "RAL> Excluding write to field %s", field.get_name()));
			   exclude_write = SLA_TRUE;
			   break;
			end
		     end
		  end

		  if (!exclude_write) begin
		     tmp   = (val >> field.get_lsb) & mask;
                     
                     if(!field.is_sliced_path() || paths.size() <= 1) begin 
		        case (bkdr)		          
                          BKDR_PUT: begin
                            status = hqm_write_backdoor_override(field, r, reg_file, field_name, reg_name, file_name, path, tmp, 0);
                            if (status != SLA_OK) begin
                              status = sla_mhpi_put_value_by_name    (path, tmp); 
                            end
                          end
                          BKDR_FORCE   :  status = sla_mhpi_force_value_by_name  (path, tmp);
                          BKDR_RELEASE :  status = sla_mhpi_release_value_by_name(path, tmp);
		        endcase /// case bkdr
                     end // !field.is_sliced_path

                     else begin
		        chandle handle;
                        string SigType;

                        handle = SLA_MHPI_handle_by_name( path, SigType );   
                        slice_size = SLA_MHPI_get_signal_size(handle, SigType);
                        case (bkdr)
                          BKDR_PUT: begin
                            status = hqm_write_backdoor_override(field, r, reg_file, field_name, reg_name, file_name, path, wr_slice_tmp, slice_offset);
                            if (status != SLA_OK) begin
                              status = sla_mhpi_put_value(handle, wr_slice_tmp, path, SigType);
                            end
                          end
                          BKDR_PUT     :  status = sla_mhpi_put_value   (handle, wr_slice_tmp, path, SigType);
                          BKDR_FORCE   :  status = sla_mhpi_force_value  (handle, wr_slice_tmp, path, SigType);
                          BKDR_RELEASE :  status = sla_mhpi_release_value(handle, wr_slice_tmp, path, SigType);
                        endcase /// case bkdr
                        slice_offset += slice_size;
                        wr_slice_tmp = wr_slice_tmp >> slice_size; 
                     end

		  end // !exclude_write
               end // else begin
	    end // else begin
	 end //for paths.size
   end // for fields.size

   if((!is_any_field_path_exist) && (rsv_field_empty_path_cnt != field_names.size())) begin
      if(sla_ral_env::is_hdl_path_chk()) begin
         status = SLA_FAIL;
         `sla_error("backdoor", ("RAL> All Fields in Register [%s] in File [%s] have an empty HDL path", 
                                       r.get_name(), reg_file.get_name()));
      end
   end
   return (status);

endfunction : _backdoor

//function: read_backdoor
//Read via backdoor.  Executes <_backdoor> with BKDR_GET option. 
function void hqm_ral_backdoor::read_backdoor( output sla_status_t status,
                                               input  sla_ral_reg r,
                                               ref    sla_ral_data_t val
                                               );
   val  = '0;
   status = _backdoor(r, val, BKDR_GET );
  `ovm_info("READ_BACKDOOR",$psprintf("status=%0s, val=0x%0x", status.name(), val),OVM_HIGH)

endfunction : read_backdoor

//task: write_backdoor
// Write CSR directly from RTL path.
// Forces value for force_time period.  Executes <_backdoor> under the hood.
task hqm_ral_backdoor::write_backdoor( output sla_status_t   status,
                                       input  sla_ral_reg    r,
                                       input  sla_ral_data_t val,
                                       input  time           force_time = 0,
                                       input  boolean_t      wait_for_complete=SLA_TRUE,
                                       input  boolean_t      exclude_attr_override = SLA_FALSE
                                       );
   status  = SLA_OK;

   if( force_time == 0 ) begin
      status   = _backdoor(r, val, BKDR_PUT, exclude_attr_override);
   end 

   else if(force_time == -1) begin
      status   = sla_status_t'(status & _backdoor(r, val, BKDR_FORCE, exclude_attr_override));
   end

   else begin

      fork
	 begin
            status   = sla_status_t'(status & _backdoor(r, val, BKDR_FORCE, exclude_attr_override));
            #( force_time );
            status   = sla_status_t'(status & _backdoor(r, val, BKDR_RELEASE, exclude_attr_override));
            #0;
	 end
      join_none;


      if (! wait_for_complete ) begin
	 return;
      end
      wait fork;
      end

endtask : write_backdoor

//task: write_backdoor_fields
// Write only to specified field names of CSR directly from RTL path.
// Order of 'vals' list corresponds to fields in the 'fnames' list 
// Forces value for force_time period.  Executes <_backdoor> under the hood.
task hqm_ral_backdoor::write_backdoor_fields( output sla_status_t   status,
                                       input  sla_ral_reg    r,
                                       input  string         fnames[$],
                                       input  sla_ral_data_t vals[$],
                                       input  time           force_time = 0,
                                       input  boolean_t      wait_for_complete=SLA_TRUE,
                                       input  boolean_t      exclude_attr_override = SLA_FALSE
                                       );
   sla_ral_data_t val = 'h0;
    
   status  = SLA_OK;    
   if (fnames.size != vals.size) begin
        status = SLA_FAIL;
       `sla_error(("hqm_ral_backdoor::write_backdoor_fields"), ("Size of list passed for fnames does not match number of vals!"))
       return;
   end
        
   
   foreach (fnames[fn]) begin
       sla_ral_field  f = r.find_field( fnames[fn] );
       val = val | (vals[fn] << (f.get_lsb() ));
   end

   if( force_time == 0 ) begin
      status   = _backdoor(r, val, BKDR_PUT, exclude_attr_override, fnames);
   end 

   else if(force_time == -1) begin
      status   = sla_status_t'(status & _backdoor(r, val, BKDR_FORCE, exclude_attr_override, fnames));
   end

   else begin

     fork
     begin
            status   = sla_status_t'(status & _backdoor(r, val, BKDR_FORCE, exclude_attr_override, fnames));
            #( force_time );
            status   = sla_status_t'(status & _backdoor(r, val, BKDR_RELEASE, exclude_attr_override, fnames));
            #0;
     end
     join_none;


      if (! wait_for_complete ) begin
         return;
      end
      wait fork;
      end

endtask : write_backdoor_fields


//function: put_backdoor
//Forces a value on a register via the backdoor. Works using <_backdoor> using BKDR_PUT attribute.
function void hqm_ral_backdoor::put_backdoor( output sla_status_t   status,
                                              input  sla_ral_reg    r,
                                              input  sla_ral_data_t val,
                                              input  boolean_t      exclude_attr_override = SLA_FALSE
                                              );

   status   = _backdoor(r, val, BKDR_PUT, exclude_attr_override);
endfunction : put_backdoor

function bit hqm_ral_backdoor::hqm_read_backdoor_override( input  sla_ral_field  my_field,
                                                           input  sla_ral_reg    my_reg,
                                                           input  sla_ral_file   my_file,
                                                           input  string         field_name,
                                                           input  string         reg_name,
                                                           input  string         file_name,
                                                           input  string         path,
                                                           output bit            invert_data,
                                                           output sla_ral_data_t rdata);
  string file_prefix;
  string reg_prefix;
  string reg_name_in;
  string indices[$];

  hqm_read_backdoor_override    = 0;
  reg_name_in                   = reg_name;
  invert_data                   = 0;
  rdata                         = 0;
  file_prefix           = lvm_common_pkg::parse_token(file_name,"[");
  reg_prefix            = lvm_common_pkg::parse_array_indices(reg_name, indices) ;

  case (file_prefix.tolower())
    "hqm_system_csr": begin
      case (reg_prefix.tolower())
        "dir_pp_v",
        "dir_vasqid_v", "ldb_vasqid_v",
        "dir_pp2vas", "ldb_pp2vas",
        "dir_cq2vf_pf_ro", "ldb_cq2vf_pf_ro",
        "dir_cq_addr_l", "dir_cq_addr_u", "ldb_cq_addr_l", "ldb_cq_addr_u",
        "vf_dir_vpp_v", "vf_ldb_vpp_v",
        "vf_dir_vqid_v", "vf_ldb_vqid_v",
        "vf_dir_vpp2pp", "vf_ldb_vpp2pp",
        "vf_dir_vqid2qid", "vf_ldb_vqid2qid",
        "ldb_qid2vqid",
        "dir_cq_at", "ldb_cq_at",
        "dir_cq_isr", "ldb_cq_isr",
        "ai_addr_l",
        "ai_addr_u",
        "ai_data":
          begin
            invert_data     = 1;
          end
        "dir_cq_pasid","ldb_cq_pasid": begin
          case (field_name.tolower())
            "priv_req": begin
              rdata = 0;
              return(1);
            end
            "exe_req": begin
              rdata = 0;
              return(1);
            end
          endcase

          invert_data     = 1;
        end
        "alarm_vf_synd0": begin
          case (field_name.tolower())
            "more","valid": begin
              invert_data     = 0;
            end
            default: begin
              invert_data     = 1;
            end
          endcase
        end
        "alarm_vf_synd1", "alarm_vf_synd2": begin
          invert_data     = 1;
        end
      endcase
    end
    "hqm_msix_mem": begin
      int reg_index;

      case (reg_prefix.tolower())
        "msg_addr_l",
        "msg_addr_u",
        "msg_data": begin
          if (indices.size() > 0) begin
            if (lvm_common_pkg::token_to_longint(indices[0],reg_index) == 0) begin
              `ovm_error("HQM_CFG",$psprintf("illegal reg index specification - %s[%s]",reg_prefix,indices[0]))
            end else begin
              if (reg_index <= 63) begin
                invert_data     = 1;
              end
            end
          end
        end
      endcase
    end
    "list_sel_pipe": begin
      case (reg_prefix.tolower())
        "cfg_qid_dir_replay_count", "cfg_qid_ldb_replay_count",
        "cfg_qid_atq_enqueue_count",
        "cfg_qid_dir_enqueue_count",
        "cfg_qid_ldb_enqueue_count",
        "cfg_qid_dir_max_depth",
        "cfg_qid_naldb_max_depth",
        "cfg_qid_atm_active",
        "cfg_cq_ldb_wu_count",
        "cfg_cq_ldb_wu_limit",
        "cfg_qid_aqed_active_count",
        "cfg_nalb_qid_dpth_thrsh",
        "cfg_qid_ldb_inflight_count",
        "cfg_cq_ldb_inflight_count",
        "cfg_dir_qid_dpth_thrsh",
        "cfg_qid_dir_tot_enq_cnth", "cfg_qid_dir_tot_enq_cntl",
        "cfg_qid_naldb_tot_enq_cnth", "cfg_qid_naldb_tot_enq_cntl",
        "cfg_qid_atm_tot_enq_cnth", "cfg_qid_atm_tot_enq_cntl",
        "cfg_cq_dir_tot_sch_cnth", "cfg_cq_dir_tot_sch_cntl",
        "cfg_cq_ldb_tot_sch_cnth", "cfg_cq_ldb_tot_sch_cntl",
        "cfg_cq_dir_token_count", "cfg_cq_ldb_token_count",
        "cfg_atm_qid_dpth_thrsh",
        "cfg_cq_dir_token_depth_select_dsi",
        "cfg_cq_ldb_token_depth_select",
        "cfg_cq_ldb_inflight_limit",
        "cfg_cq_ldb_inflight_threshold",
        "cfg_cq2priov",
        "cfg_cq2qid0", "cfg_cq2qid1",
        "cfg_qid_aqed_active_limit",
        "cfg_qid_ldb_qid2cqidix_00", "cfg_qid_ldb_qid2cqidix_01", "cfg_qid_ldb_qid2cqidix_02", "cfg_qid_ldb_qid2cqidix_03",
        "cfg_qid_ldb_qid2cqidix_04", "cfg_qid_ldb_qid2cqidix_05", "cfg_qid_ldb_qid2cqidix_06", "cfg_qid_ldb_qid2cqidix_07",
        "cfg_qid_ldb_qid2cqidix_08", "cfg_qid_ldb_qid2cqidix_09", "cfg_qid_ldb_qid2cqidix_10", "cfg_qid_ldb_qid2cqidix_11",
        "cfg_qid_ldb_qid2cqidix_12", "cfg_qid_ldb_qid2cqidix_13", "cfg_qid_ldb_qid2cqidix_14", "cfg_qid_ldb_qid2cqidix_15",
        "cfg_qid_ldb_qid2cqidix2_00", "cfg_qid_ldb_qid2cqidix2_01", "cfg_qid_ldb_qid2cqidix2_02", "cfg_qid_ldb_qid2cqidix2_03",
        "cfg_qid_ldb_qid2cqidix2_04", "cfg_qid_ldb_qid2cqidix2_05", "cfg_qid_ldb_qid2cqidix2_06", "cfg_qid_ldb_qid2cqidix2_07",
        "cfg_qid_ldb_qid2cqidix2_08", "cfg_qid_ldb_qid2cqidix2_09", "cfg_qid_ldb_qid2cqidix2_10", "cfg_qid_ldb_qid2cqidix2_11",
        "cfg_qid_ldb_qid2cqidix2_12", "cfg_qid_ldb_qid2cqidix2_13", "cfg_qid_ldb_qid2cqidix2_14", "cfg_qid_ldb_qid2cqidix2_15",
        "cfg_qid_ldb_inflight_limit":
        begin
          invert_data     = 1;
        end
      endcase
    end
    "aqed_pipe": begin
      case (reg_prefix.tolower())
        "cfg_aqed_qid_fid_limit": begin
          invert_data     = 1;
        end
      endcase
    end
    "reorder_pipe": begin
      case (reg_prefix.tolower())
        "cfg_reorder_state_nalb_hp",
        "cfg_reorder_state_qid_qidix_cq",
        "cfg_grp_0_slot_shift", "cfg_grp_1_slot_shift": begin
          invert_data     = 1;
        end
      endcase
    end
    "atm_pipe": begin
      case (reg_prefix.tolower())
        "cfg_ldb_qid_rdylst_clamp",
        "cfg_qid_ldb_qid2cqidix_00", "cfg_qid_ldb_qid2cqidix_01", "cfg_qid_ldb_qid2cqidix_02", "cfg_qid_ldb_qid2cqidix_03",
        "cfg_qid_ldb_qid2cqidix_04", "cfg_qid_ldb_qid2cqidix_05", "cfg_qid_ldb_qid2cqidix_06", "cfg_qid_ldb_qid2cqidix_07",
        "cfg_qid_ldb_qid2cqidix_08", "cfg_qid_ldb_qid2cqidix_09", "cfg_qid_ldb_qid2cqidix_10", "cfg_qid_ldb_qid2cqidix_11",
        "cfg_qid_ldb_qid2cqidix_12", "cfg_qid_ldb_qid2cqidix_13", "cfg_qid_ldb_qid2cqidix_14", "cfg_qid_ldb_qid2cqidix_15":
        begin
          invert_data     = 1;
        end
      endcase
    end
    "credit_hist_pipe": begin
      case (reg_prefix.tolower())
        "cfg_ord_qid_sn",
        "cfg_ord_qid_sn_map",
        "cfg_dir_cq_wptr", "cfg_ldb_cq_wptr",
        "cfg_dir_cq_timer_threshold", "cfg_ldb_cq_timer_threshold",
        "cfg_dir_cq_timer_count", "cfg_ldb_cq_timer_count",
        "cfg_cmp_sn_chk_enbl",
        "cfg_dir_cq_depth", "cfg_ldb_cq_depth",
        "cfg_dir_cq_token_depth_select", "cfg_ldb_cq_token_depth_select",
        "cfg_dir_cq_int_depth_thrsh", "cfg_ldb_cq_int_depth_thrsh",
        "cfg_hist_list_base", "cfg_hist_list_limit",
        "cfg_hist_list_push_ptr", "cfg_hist_list_pop_ptr":
        begin
          invert_data     = 1;
        end
        default: begin
        end
      endcase
    end
    default: begin
    end
  endcase
endfunction : hqm_read_backdoor_override

function sla_status_t hqm_ral_backdoor::hqm_write_backdoor_override( input  sla_ral_field  my_field,
                                                                     input  sla_ral_reg    my_reg,
                                                                     input  sla_ral_file   my_file,
                                                                     input  string         field_name,
                                                                     input  string         reg_name,
                                                                     input  string         file_name,
                                                                     input  string         path,
                                                                     input  sla_ral_data_t wdata,
                                                                     input  int            slice_offset);
  bit                   invert_data;
  sla_ral_data_t        tmp;
  bit [127:0]           long_wdata;
  string                path_prefix;            // path without any indices
  string                path_mem_prefix;        // path with all but last index (path to memory location)
  string                file_prefix;
  int                   file_index;
  string                reg_prefix;
  int                   reg_index;
  int                   path_msb;
  int                   path_lsb;
  string                explode_q[$];
  string                file_indices[$];
  string                indices[$];

  hqm_write_backdoor_override   = SLA_FAIL;

  file_prefix           = lvm_common_pkg::parse_array_indices(file_name, file_indices) ;
  if (file_indices.size() == 1) begin
    if (lvm_common_pkg::token_to_longint(file_indices[0],file_index) == 0) begin
      `ovm_error("HQM_CFG",$psprintf("illegal file index specification - %s[%s]",file_prefix,file_indices[0]))
      return(hqm_write_backdoor_override);
    end
  end

  `ovm_info(get_full_name(),$psprintf("BACKDOOR WRITE of field %s.%s.%s, path=%s, wdata=0x%0x",file_name,reg_name,field_name,path,wdata),OVM_HIGH)

  reg_prefix            = lvm_common_pkg::parse_array_indices(reg_name, indices) ;
  if (indices.size() == 1) begin
    if (lvm_common_pkg::token_to_longint(indices[0],reg_index) == 0) begin
      `ovm_error("HQM_CFG",$psprintf("illegal reg index specification - %s[%s]",reg_prefix,indices[0]))
      return(hqm_write_backdoor_override);
    end
  end

  path_prefix           = lvm_common_pkg::parse_array_indices(path, indices) ;
  path_mem_prefix       = path_prefix;

  if (indices.size() > 0) begin
    while (indices.size() > 1) begin
      path_mem_prefix = {path_mem_prefix,"[",indices.pop_front(),"]"};
    end

    explode_q.delete();

    lvm_common_pkg::explode(":",indices[0],explode_q);

    if (explode_q.size() == 1) begin
      if (lvm_common_pkg::token_to_longint(explode_q[0],path_msb) == 0) begin
        `ovm_error("HQM_CFG",$psprintf("illegal bit specification - %s",path))
        return(hqm_write_backdoor_override);
      end
      path_lsb = path_msb;
    end else if (explode_q.size() == 2) begin
      if (lvm_common_pkg::token_to_longint(explode_q[0],path_msb) == 0) begin
        `ovm_error("HQM_CFG",$psprintf("illegal bit specification - %s",path))
        return(hqm_write_backdoor_override);
      end
      if (lvm_common_pkg::token_to_longint(explode_q[1],path_lsb) == 0) begin
        `ovm_error("HQM_CFG",$psprintf("illegal bit specification - %s",path))
        return(hqm_write_backdoor_override);
      end
    end else begin
      `ovm_error("HQM_CFG",$psprintf("illegal bit specification - %s",path))
      return(hqm_write_backdoor_override);
    end
  end

  case (file_prefix.tolower())
    "hqm_system_csr": begin
      case (reg_prefix.tolower())
        "dir_cq_isr", "ldb_cq_isr": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[12:0]",path_mem_prefix) );
          for (int b = 0 ; b <= (path_msb - path_lsb) ; b++) begin
            tmp[path_lsb + b] = wdata[b];
          end
          wdata = tmp;
          wdata[12] = ^(wdata[11:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[12:0]",path_mem_prefix), wdata); 
        end
        "dir_cq_fmt": begin
          tmp = sla_mhpi_get_value_by_name( $psprintf("%s[32:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[32] = ^(wdata[31:0]);
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[32:0]",path_mem_prefix), wdata); 
        end
        "dir_cq_at","ldb_cq_at": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[8:0]",path_mem_prefix) );
          tmp[path_lsb +: 2] = wdata[1:0];
          wdata = tmp;
          wdata[8] = ^(wdata[7:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[8:0]",path_mem_prefix), wdata); 
        end
        "ai_addr_l": begin
          wdata[30] = ^(wdata[29:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[30:0]",path_mem_prefix), wdata); 
        end
        "ai_addr_u": begin
          wdata[32] = ^(wdata[31:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[32:0]",path_mem_prefix), wdata); 
        end
        "ai_data": begin
          wdata[32] = ^(wdata[31:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[32:0]",path_mem_prefix), wdata); 
        end
        "dir_qid_v": begin
          tmp = sla_mhpi_get_value_by_name( $psprintf("%s[32:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[32] = ^(wdata[31:0]);
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[32:0]",path_mem_prefix), wdata); 
        end
        "ldb_qid_v": begin
          tmp = sla_mhpi_get_value_by_name( $psprintf("%s[16:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[16] = ^(wdata[15:0]);
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[16:0]",path_mem_prefix), wdata); 
        end
        "dir_qid_its": begin
          tmp = sla_mhpi_get_value_by_name( $psprintf("%s[32:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[32] = ^(wdata[31:0]);
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[32:0]",path_mem_prefix), wdata); 
        end
        "ldb_qid_its": begin
          tmp = sla_mhpi_get_value_by_name( $psprintf("%s[16:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[16] = ^(wdata[15:0]);
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[16:0]",path_mem_prefix), wdata); 
        end
        "dir_pp_v": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[16:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[16] = ^(wdata[15:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[16:0]",path_mem_prefix), wdata); 
        end
        "ldb_pp_v": begin
          tmp = sla_mhpi_get_value_by_name( $psprintf("%s[32:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[32] = ^(wdata[31:0]);
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[32:0]",path_mem_prefix), wdata); 
        end
        "ldb_qid_cfg_v": begin
          tmp = sla_mhpi_get_value_by_name( $psprintf("%s[32:0]",path_mem_prefix) );
          case (field_name.tolower())
            "sn_cfg_v": begin
              tmp[path_msb] = wdata[0];
            end
            "fid_cfg_v": begin
              tmp[path_msb] = wdata[0];
            end
          endcase
          tmp[32] = ^(tmp[31:0]);
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[32:0]",path_mem_prefix), tmp); 
        end
        "dir_vasqid_v": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[32:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[32] = ^(wdata[31:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[32:0]",path_mem_prefix), wdata); 
        end
        "ldb_vasqid_v": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[16:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[16] = ^(wdata[15:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[16:0]",path_mem_prefix), wdata); 
        end
        "dir_pp2vas": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[10:0]",path_mem_prefix) );
          tmp[path_lsb +: 5] = wdata[4:0];
          wdata = tmp;
          wdata[10] = ^(wdata[9:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[10:0]",path_mem_prefix), wdata); 
        end
        "ldb_pp2vas": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[10:0]",path_mem_prefix) );
          tmp[path_lsb +: 5] = wdata[4:0];
          wdata = tmp;
          wdata[10] = ^(wdata[9:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[10:0]",path_mem_prefix), wdata); 
        end
        "dir_cq2vf_pf_ro": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[12:0]",path_mem_prefix) );
          case (field_name.tolower())
            "vf": begin
              tmp[path_lsb +: 4] = wdata[3:0];
            end
            "is_pf": begin
              tmp[path_msb] = wdata[0];
            end
            "ro": begin
              tmp[path_msb] = wdata[0];
            end
            "": begin
              tmp[path_lsb +: 6] = wdata[5:0];
            end
          endcase
          wdata = tmp;
          wdata[12] = ^(wdata[11:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[12:0]",path_mem_prefix), wdata); 
        end
        "ldb_cq2vf_pf_ro": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[12:0]",path_mem_prefix) );
          case (field_name.tolower())
            "vf": begin
              tmp[path_lsb +: 4] = wdata[3:0];
            end
            "is_pf": begin
              tmp[path_msb] = wdata[0];
            end
            "ro": begin
              tmp[path_msb] = wdata[0];
            end
            "": begin
              tmp[path_lsb +: 6] = wdata[5:0];
            end
          endcase
          wdata = tmp;
          wdata[12] = ^(wdata[11:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[12:0]",path_mem_prefix), wdata); 
        end
        "dir_cq_addr_l": begin       // stores inverted data
          if (field_name.tolower() == "") wdata[25:0] = wdata[31:6];
          wdata[26] = ^(wdata[25:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[26:0]",path_mem_prefix), wdata); 
        end
        "dir_cq_addr_u": begin       // stores inverted data
          wdata[32] = ^(wdata[31:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[32:0]",path_mem_prefix), wdata); 
        end
        "ldb_cq_addr_l": begin       // stores inverted data
          if (field_name.tolower() == "") wdata[25:0] = wdata[31:6];
          wdata[26] = ^(wdata[25:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[26:0]",path_mem_prefix), wdata); 
        end
        "ldb_cq_addr_u": begin       // stores inverted data
          wdata[32] = ^(wdata[31:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[32:0]",path_mem_prefix), wdata); 
        end
        "dir_cq_pasid", "ldb_cq_pasid": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[23:0]",path_mem_prefix) );
          case (field_name.tolower())
            "pasid": begin
              tmp[19:0] = wdata[19:0];
            end
            "exe_req": begin
              tmp[20] = wdata[0];
            end
            "priv_req": begin
              tmp[21] = wdata[0];
            end
            "fmt2": begin
              tmp[22] = wdata[0];
            end
            "": begin
              tmp[22:0] = wdata[22:0];
            end
          endcase
          wdata = tmp;
          wdata[23] = ^(wdata[22:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[23:0]",path_mem_prefix), wdata); 
        end
        "vf_dir_vpp_v": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[16:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[16] = ^(wdata[15:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[16:0]",path_mem_prefix), wdata); 
        end
        "vf_ldb_vpp_v": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[16:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[16] = ^(wdata[15:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[16:0]",path_mem_prefix), wdata); 
        end
        "vf_dir_vqid_v": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[16:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[16] = ^(wdata[15:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[16:0]",path_mem_prefix), wdata); 
        end
        "vf_ldb_vqid_v": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[16:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[16] = ^(wdata[15:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[16:0]",path_mem_prefix), wdata); 
        end
        "vf_dir_vpp2pp": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[27:0]",path_mem_prefix) );
          tmp[path_lsb +: 7] = wdata[6:0];
          wdata = tmp;
          wdata[34:28] = nu_ecc_pkg::nu_ecc_d28_e7_gen(wdata[27:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[34:0]",path_mem_prefix), wdata); 
        end
        "vf_ldb_vpp2pp": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[24:0]",path_mem_prefix) );
          tmp[path_lsb +: 6] = wdata[5:0];
          wdata = tmp;
          wdata[24] = ^(wdata[23:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[24:0]",path_mem_prefix), wdata); 
        end
        "vf_dir_vqid2qid": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[27:0]",path_mem_prefix) );
          tmp[path_lsb +: 7] = wdata[6:0];
          wdata = tmp;
          wdata[34:28] = nu_ecc_pkg::nu_ecc_d28_e7_gen(wdata[27:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[34:0]",path_mem_prefix), wdata); 
        end
        "vf_ldb_vqid2qid": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[26:0]",path_mem_prefix) );
          tmp[path_lsb +: 5] = wdata[4:0];
          wdata = tmp;
          wdata[26:20] = nu_ecc_pkg::nu_ecc_d20_e7_gen(wdata[19:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[26:0]",path_mem_prefix), wdata); 
        end
        "ldb_qid2vqid": begin       // stores inverted data
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[20:0]",path_mem_prefix) );
          tmp[path_lsb +: 5] = wdata[4:0];
          wdata = tmp;
          wdata[20] = ^(wdata[19:0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[20:0]",path_mem_prefix), wdata); 
        end
        "alarm_vf_synd0": begin
          case (field_name.tolower())
            "more", "valid": begin
              return(SLA_FAIL);
            end
            default: begin
              tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[29:0]",path_mem_prefix) );

              for (int b = 0 ; b <= (path_msb - path_lsb) ; b++) begin
                tmp[path_lsb + b] = wdata[b];
              end

              wdata = tmp;
              wdata[10] = ^({wdata[29:13],wdata[9:0]});
              wdata = ~wdata;
              hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[29:0]",path_mem_prefix), wdata); 
            end
          endcase
        end
        "alarm_vf_synd1", "alarm_vf_synd2": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[31:0]",path_mem_prefix) );

          for (int b = 0 ; b <= (path_msb - path_lsb) ; b++) begin
            tmp[path_lsb + b] = wdata[b];
          end

          wdata = tmp;
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[31:0]",path_mem_prefix), wdata); 
        end
      endcase
    end
    "list_sel_pipe": begin
      case (reg_prefix.tolower())
        "cfg_qid_dir_max_depth",
        "cfg_qid_naldb_max_depth": begin
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:0]",path_mem_prefix,path_msb), wdata); 
        end
        "cfg_qid_dir_replay_count", "cfg_qid_ldb_replay_count",
        "cfg_qid_atq_enqueue_count",
        "cfg_qid_dir_enqueue_count",
        "cfg_qid_ldb_enqueue_count",
        "cfg_qid_atm_active",
        "cfg_cq_ldb_wu_count",
        "cfg_qid_aqed_active_count": begin
          wdata[((path_msb-path_lsb)+1) +: 2] = gen_residue(wdata,(path_msb - path_lsb) + 1);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:0]",path_mem_prefix,path_msb+2), wdata); 
        end
        "cfg_nalb_qid_dpth_thrsh": begin
          wdata[path_msb + 1] = gen_parity(wdata,path_msb + 1);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[15:0]",path_mem_prefix), wdata); 
        end
        "cfg_dir_qid_dpth_thrsh": begin
          wdata[path_msb + 1] = gen_parity(wdata,path_msb + 1);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[15:0]",path_mem_prefix), wdata); 
        end
        "cfg_qid_dir_tot_enq_cnth", "cfg_qid_dir_tot_enq_cntl",
        "cfg_qid_naldb_tot_enq_cnth", "cfg_qid_naldb_tot_enq_cntl",
        "cfg_qid_atm_tot_enq_cnth", "cfg_qid_atm_tot_enq_cntl",
        "cfg_cq_dir_tot_sch_cnth", "cfg_cq_dir_tot_sch_cntl",
        "cfg_cq_ldb_tot_sch_cnth", "cfg_cq_ldb_tot_sch_cntl": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[63:0]",path_mem_prefix) );
          tmp[path_lsb +: 32] = wdata[31:0];
          long_wdata[63:0] = tmp;
          long_wdata[65:64] = gen_residue(long_wdata,64);
          long_wdata = ~long_wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[63:0]",path_mem_prefix), long_wdata[63:0]); 
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[65:64]",path_mem_prefix), long_wdata[65:64]); 
        end
        "cfg_cq_ldb_inflight_count",
        "cfg_qid_ldb_inflight_count": begin
          wdata[((path_msb-path_lsb)+1) +: 2] = gen_residue(wdata,(path_msb - path_lsb) + 1);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:0]",path_mem_prefix,path_msb+2), wdata); 
        end
        "cfg_cq_dir_token_count": begin
          wdata[((path_msb-path_lsb)+1) +: 2] = gen_residue(wdata,(path_msb - path_lsb) + 1);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:0]",path_mem_prefix,path_msb+2), wdata); 
        end
        "cfg_cq_ldb_token_count": begin
          wdata[((path_msb-path_lsb)+1) +: 2] = gen_residue(wdata,(path_msb - path_lsb) + 1);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:0]",path_mem_prefix,path_msb+2), wdata); 
        end
        "cfg_atm_qid_dpth_thrsh": begin
          wdata[path_msb + 1] = gen_parity(wdata,path_msb + 1);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[15:0]",path_mem_prefix), wdata); 
        end
        "cfg_qid_aqed_active_limit": begin
          wdata[12] = ~(^(wdata[11:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[12:0]",path_mem_prefix), wdata); 
        end
        "cfg_qid_ldb_inflight_limit": begin
          wdata[12] = ~(^(wdata[11:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[12:0]",path_mem_prefix), wdata); 
        end
        "cfg_cq_ldb_wu_limit": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[16:0]",path_mem_prefix) );
          case (field_name.tolower())
            "limit": begin
              tmp[path_lsb +: 15] = wdata[14:0];
            end
            "v": begin
              tmp[path_lsb] = wdata[0];
            end
          endcase
          wdata = tmp;
          wdata[16] = ~(^(wdata[15:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[16:0]",path_mem_prefix), wdata); 
        end
        "cfg_cq_dir_token_depth_select_dsi": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[7:0]",path_mem_prefix) );
          case (field_name.tolower())
            "token_depth_select": begin
              tmp[3:0] = wdata[3:0];
            end
            "disable_wb_opt": begin
              tmp[4] = wdata[0];
            end
          endcase
          wdata = tmp;
          wdata[7] = ~(^(wdata[5:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[7:0]",path_mem_prefix), wdata); 
        end
        "cfg_cq_ldb_token_depth_select": begin
          if (field_name.tolower() == "token_depth_select") begin
            tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[4:0]",path_mem_prefix) );
            tmp[3:0] = wdata[3:0];
            wdata = tmp;
            wdata[4] = ~(^(wdata[3:0]));
            wdata = ~wdata;
            hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[4:0]",path_mem_prefix), wdata); 
          end
        end
        "cfg_cq2priov": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[32:0]",path_mem_prefix) );
          case (field_name.tolower())
            "prio": begin
              tmp[23:0] = wdata[23:0];
            end
            "v": begin
              tmp[31:24] = wdata[7:0];
            end
          endcase
          wdata = tmp;
          wdata[32] = ~(^(wdata[31:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[32:0]",path_mem_prefix), wdata); 
        end
        "cfg_cq2qid0": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[28:0]",path_mem_prefix) );
          case (field_name.tolower())
            "qid_p0": begin
              tmp[6:0] = wdata[6:0];
            end
            "qid_p1": begin
              tmp[13:7] = wdata[6:0];
            end
            "qid_p2": begin
              tmp[20:14] = wdata[6:0];
            end
            "qid_p3": begin
              tmp[27:21] = wdata[6:0];
            end
          endcase
          wdata = tmp;
          wdata[28] = ~(^(wdata[27:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[28:0]",path_mem_prefix), wdata); 
        end
        "cfg_cq2qid1": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[28:0]",path_mem_prefix) );
          case (field_name.tolower())
            "qid_p4": begin
              tmp[6:0] = wdata[6:0];
            end
            "qid_p5": begin
              tmp[13:7] = wdata[6:0];
            end
            "qid_p6": begin
              tmp[20:14] = wdata[6:0];
            end
            "qid_p7": begin
              tmp[27:21] = wdata[6:0];
            end
          endcase
          wdata = tmp;
          wdata[28] = ~(^(wdata[27:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[28:0]",path_mem_prefix), wdata); 
        end
        "cfg_cq_ldb_inflight_limit": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[12:0]",path_mem_prefix) );
          tmp[11:0] = wdata[11:0];
          wdata = tmp;
          wdata[12] = ~(^(wdata[11:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[12:0]",path_mem_prefix), wdata); 
        end
        "cfg_cq_ldb_inflight_threshold": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[12:0]",path_mem_prefix) );
          tmp[11:0] = wdata[11:0];
          wdata = tmp;
          wdata[12] = ~(^(wdata[11:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[12:0]",path_mem_prefix), wdata); 
        end
        "cfg_qid_ldb_qid2cqidix_00",  "cfg_qid_ldb_qid2cqidix_01",  "cfg_qid_ldb_qid2cqidix_02",  "cfg_qid_ldb_qid2cqidix_03",
        "cfg_qid_ldb_qid2cqidix_04",  "cfg_qid_ldb_qid2cqidix_05",  "cfg_qid_ldb_qid2cqidix_06",  "cfg_qid_ldb_qid2cqidix_07",
        "cfg_qid_ldb_qid2cqidix_08",  "cfg_qid_ldb_qid2cqidix_09",  "cfg_qid_ldb_qid2cqidix_10",  "cfg_qid_ldb_qid2cqidix_11",
        "cfg_qid_ldb_qid2cqidix_12",  "cfg_qid_ldb_qid2cqidix_13",  "cfg_qid_ldb_qid2cqidix_14",  "cfg_qid_ldb_qid2cqidix_15",
        "cfg_qid_ldb_qid2cqidix2_00", "cfg_qid_ldb_qid2cqidix2_01", "cfg_qid_ldb_qid2cqidix2_02", "cfg_qid_ldb_qid2cqidix2_03",
        "cfg_qid_ldb_qid2cqidix2_04", "cfg_qid_ldb_qid2cqidix2_05", "cfg_qid_ldb_qid2cqidix2_06", "cfg_qid_ldb_qid2cqidix2_07",
        "cfg_qid_ldb_qid2cqidix2_08", "cfg_qid_ldb_qid2cqidix2_09", "cfg_qid_ldb_qid2cqidix2_10", "cfg_qid_ldb_qid2cqidix2_11",
        "cfg_qid_ldb_qid2cqidix2_12", "cfg_qid_ldb_qid2cqidix2_13", "cfg_qid_ldb_qid2cqidix2_14", "cfg_qid_ldb_qid2cqidix2_15": begin
          hqm_write_backdoor_override = hqm_write_qid2cqidix_backdoor(field_name,reg_prefix,path_mem_prefix,path_msb,path_lsb,wdata,slice_offset);
        end
        default: begin
        end
      endcase
    end
    "aqed_pipe": begin
      case (reg_prefix.tolower())
        "cfg_aqed_qid_fid_limit": begin
          wdata[13] = ~(^(wdata[12:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[13:0]",path_mem_prefix), wdata); 
        end
        default: begin
        end
      endcase
    end
    "reorder_pipe": begin
      case (reg_prefix.tolower())
        "cfg_reorder_state_nalb_hp": begin
          wdata[15] = ~(^(wdata[14:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:%0d]",path_mem_prefix,path_msb+1,path_lsb), wdata); 
        end
        "cfg_grp_0_slot_shift", "cfg_grp_1_slot_shift": begin
          wdata[((path_msb-path_lsb)+1) +: 2] = gen_residue(wdata,(path_msb - path_lsb) + 1);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:%0d]",path_mem_prefix,path_msb+2,path_lsb), wdata); 
        end
        default: begin
        end
      endcase
    end
    "atm_pipe": begin
      case (reg_prefix.tolower())
        "cfg_ldb_qid_rdylst_clamp": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[5:0]",path_mem_prefix) );
          case (field_name.tolower())
            "min_bin": begin
              tmp[1:0] = wdata[1:0];
            end
            "max_bin": begin
              tmp[3:2] = wdata[1:0];
            end
            "rsvz0": begin
              tmp[4] = wdata[0];
            end
          endcase
          wdata = tmp;
          wdata[5] = ~(^(wdata[4:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[5:0]",path_mem_prefix), wdata); 
        end
        "cfg_qid_ldb_qid2cqidix_00",  "cfg_qid_ldb_qid2cqidix_01",  "cfg_qid_ldb_qid2cqidix_02",  "cfg_qid_ldb_qid2cqidix_03",
        "cfg_qid_ldb_qid2cqidix_04",  "cfg_qid_ldb_qid2cqidix_05",  "cfg_qid_ldb_qid2cqidix_06",  "cfg_qid_ldb_qid2cqidix_07",
        "cfg_qid_ldb_qid2cqidix_08",  "cfg_qid_ldb_qid2cqidix_09",  "cfg_qid_ldb_qid2cqidix_10",  "cfg_qid_ldb_qid2cqidix_11",
        "cfg_qid_ldb_qid2cqidix_12",  "cfg_qid_ldb_qid2cqidix_13",  "cfg_qid_ldb_qid2cqidix_14",  "cfg_qid_ldb_qid2cqidix_15": begin
          hqm_write_backdoor_override = hqm_write_qid2cqidix_backdoor(field_name,reg_prefix,path_mem_prefix,path_msb,path_lsb,wdata,slice_offset);
        end
        default: begin
        end
      endcase
    end
    "credit_hist_pipe": begin
      case (reg_prefix.tolower())
        "cfg_ord_qid_sn_map": begin
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:%0d]",path_mem_prefix,path_msb,path_lsb), wdata); 
        end
        "cfg_ord_qid_sn": begin
          wdata[((path_msb-path_lsb)+1) +: 2] = gen_residue(wdata,(path_msb - path_lsb) + 1);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:%0d]",path_mem_prefix,path_msb+2,path_lsb), wdata); 
        end
        "cfg_dir_cq_wptr", "cfg_ldb_cq_wptr": begin
          wdata[((path_msb-path_lsb)+1) +: 2] = gen_residue(wdata,(path_msb - path_lsb) + 1);
          wdata = (~wdata) & ((1 << ((path_msb - path_lsb) + 3)) - 1);
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:%0d]",path_mem_prefix,path_msb+2,path_lsb), wdata); 
        end
        "cfg_dir_cq_timer_count", "cfg_ldb_cq_timer_count": begin
          wdata[13:1] = wdata[12:0];
          wdata[0] = ~(^(wdata[13:1]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[13:0]",path_mem_prefix), wdata); 
        end
        "cfg_dir_cq_timer_count", "cfg_ldb_cq_timer_count": begin
          wdata[14] = ~(^(wdata[13:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[14:0]",path_mem_prefix), wdata); 
        end
        "cfg_cmp_sn_chk_enbl": begin
          wdata[1] = ~(wdata[0]);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[1:0]",path_mem_prefix), wdata); 
        end
        "cfg_vas_credit_count": begin
          wdata[((path_msb-path_lsb)+1) +: 2] = gen_residue(wdata,(path_msb - path_lsb) + 1);
          wdata = wdata & ((1 << ((path_msb - path_lsb) + 3)) - 1);
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:%0d]",path_mem_prefix,path_msb+2,path_lsb), wdata); 
        end
        "cfg_dir_cq_depth": begin
          wdata[((path_msb-path_lsb)+1) +: 2] = gen_residue(wdata,(path_msb - path_lsb) + 1);
          wdata = (~wdata) & ((1 << ((path_msb - path_lsb) + 3)) - 1);
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:%0d]",path_mem_prefix,path_msb+2,path_lsb), wdata); 
        end
        "cfg_ldb_cq_depth": begin
          wdata[((path_msb-path_lsb)+1) +: 2] = gen_residue(wdata,(path_msb - path_lsb) + 1);
          wdata = (~wdata) & ((1 << ((path_msb - path_lsb) + 3)) - 1);
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:%0d]",path_mem_prefix,path_msb+2,path_lsb), wdata); 
        end
        "cfg_hist_list_pop_ptr": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[%0d:%0d]",path_mem_prefix,31,16) );
          case (field_name.tolower())
            "generation": begin
              tmp[13] = wdata[0];
            end
            "pop_ptr": begin
              tmp[12:0] = wdata[12:0];
            end
          endcase
          tmp[15:14] = gen_residue(tmp,14);
          tmp = ~tmp;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:%0d]",path_mem_prefix,31,16), tmp); 
        end
        "cfg_hist_list_push_ptr": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[%0d:%0d]",path_mem_prefix,15,0) );
          case (field_name.tolower())
            "generation": begin
              tmp[13] = wdata[0];
            end
            "push_ptr": begin
              tmp[12:0] = wdata[12:0];
            end
          endcase
          tmp[15:14] = gen_residue(tmp,14);
          tmp = ~tmp;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:%0d]",path_mem_prefix,15,0), tmp); 
        end
        "cfg_hist_list_base", "cfg_hist_list_limit": begin
          wdata[((path_msb - path_lsb) + 1) +: 2] = gen_residue(wdata,(path_msb - path_lsb) + 1);
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:%0d]",path_mem_prefix,path_msb+2,path_lsb), wdata); 
        end
        "cfg_dir_cq2vas": begin
          wdata[5] = ~(^(wdata[4:0]));
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:%0d]",path_mem_prefix,path_msb + 1,path_lsb), wdata); 
        end
        "cfg_ldb_cq2vas": begin // 2 copies in register array
          wdata[5] = ~(^(wdata[4:0]));
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[%0d:%0d]",path_mem_prefix,path_msb + 1,path_lsb), wdata); 
        end
        "cfg_dir_cq_token_depth_select", "cfg_ldb_cq_token_depth_select": begin
          wdata[4] = ~(^(wdata[3:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[4:0]",path_mem_prefix), wdata); 
        end
        "cfg_dir_cq_int_depth_thrsh": begin
          wdata[13] = 1'b0;
          wdata[14] = ~(^(wdata[12:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[14:0]",path_mem_prefix), wdata); 
        end
        "cfg_ldb_cq_int_depth_thrsh": begin
          wdata[11] = 1'b0;
          wdata[12] = ~(^(wdata[10:0]));
          wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[12:0]",path_mem_prefix), wdata); 
        end
        "cfg_dir_cq_timer_threshold", "cfg_ldb_cq_timer_threshold": begin
          tmp = ~sla_mhpi_get_value_by_name( $psprintf("%s[13:0]",path_mem_prefix) );
          case (field_name.tolower())
            "thrsh_13_1": begin
              tmp[13:1] = wdata[12:0];
            end
            default: begin
            end
          endcase
          tmp[0] = ~(^(tmp[13:1]));
          wdata = ~tmp;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[13:0]",path_mem_prefix), wdata); 
        end
        default: begin
        end
      endcase
    end
    "hqm_msix_mem": begin
      case (reg_prefix.tolower())
        "msg_addr_l": begin
          tmp = sla_mhpi_get_value_by_name( $psprintf("%s[31:0]",path_mem_prefix) );
          if (reg_index <= 63) tmp = ~tmp;
          case (field_name.tolower())
            "msg_addr_l": begin
              tmp[31:2] = wdata[29:0];
            end
            "rsvd": begin
              tmp[1:0] = wdata[1:0];
            end
          endcase
          tmp[32] = ^(tmp[31:0]);
          wdata = tmp;
          if (reg_index <= 63) wdata = ~tmp;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[32:0]",path_mem_prefix), wdata); 
        end
        "msg_addr_u","msg_data": begin
          wdata[32] = ^(wdata[31:0]);
          if (reg_index <= 63) wdata = ~wdata;
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[32:0]",path_mem_prefix), wdata); 
        end
        "vector_ctrl": begin
          tmp = sla_mhpi_get_value_by_name( $psprintf("%s[8:0]",path_mem_prefix) );
          tmp[path_msb] = wdata[0];
          wdata = tmp;
          wdata[8] = ^(wdata[7:0]);
          hqm_write_backdoor_override = sla_mhpi_put_value_by_name($psprintf("%s[8:0]",path_mem_prefix), wdata); 
        end
        default: begin
        end
      endcase
    end
    default: begin
    end
  endcase
endfunction : hqm_write_backdoor_override

function sla_status_t hqm_ral_backdoor::hqm_write_qid2cqidix_backdoor( input  string  field_name,
                                                                       input  string  reg_prefix,
                                                                       input  string  path_mem_prefix,
                                                                       input  int     path_msb,
                                                                       input  int     path_lsb,
                                                                       input  sla_ral_data_t wdata,
                                                                       input  int     slice_offset);
  int reg_num;
  string explode_q[$];
  logic [527:0] qid2cqidix_val;
  string mem_path[4];
  int   mem_bank_str_index = -1;

  hqm_write_qid2cqidix_backdoor   = SLA_FAIL;

  explode_q.delete();

  lvm_common_pkg::explode("_",reg_prefix,explode_q);

  if (explode_q.size() >= 2) begin
    if (lvm_common_pkg::token_to_longint(explode_q[explode_q.size()-1],reg_num) == 0) begin
      `ovm_error(get_full_name(),$psprintf("illegal register prefix - %s",reg_prefix))
      return(hqm_write_qid2cqidix_backdoor);
    end
  end else begin
    `ovm_error(get_full_name(),$psprintf("illegal register prefix - %s",reg_prefix))
    return(hqm_write_qid2cqidix_backdoor);
  end

  mem_path[0] = path_mem_prefix;
  mem_path[1] = path_mem_prefix;
  mem_path[2] = path_mem_prefix;
  mem_path[3] = path_mem_prefix;

  for (int i = 0 ; i < (path_mem_prefix.len() - 7) ; i++) begin
    if (path_mem_prefix.substr(i,i+6) == ".i_rf_b") begin
      mem_bank_str_index = i+7;
      break;
    end
  end

  if (mem_bank_str_index < 0) begin
    `ovm_error(get_full_name(),$psprintf("illegal path_mem_prefix - %s",path_mem_prefix))
    return(hqm_write_qid2cqidix_backdoor);
  end

  mem_path[0][mem_bank_str_index] = "0";
  mem_path[1][mem_bank_str_index] = "1";
  mem_path[2][mem_bank_str_index] = "2";
  mem_path[3][mem_bank_str_index] = "3";

  qid2cqidix_val[63:0]    = ~sla_mhpi_get_value_by_name( $psprintf("%s[63:0]",mem_path[0]) );
  qid2cqidix_val[127:64]  = ~sla_mhpi_get_value_by_name( $psprintf("%s[127:64]",mem_path[0]) );
  qid2cqidix_val[131:128] = ~sla_mhpi_get_value_by_name( $psprintf("%s[131:128]",mem_path[0]) );
  qid2cqidix_val[195:132] = ~sla_mhpi_get_value_by_name( $psprintf("%s[63:0]",mem_path[1]) );
  qid2cqidix_val[259:196] = ~sla_mhpi_get_value_by_name( $psprintf("%s[127:64]",mem_path[1]) );
  qid2cqidix_val[263:260] = ~sla_mhpi_get_value_by_name( $psprintf("%s[131:128]",mem_path[1]) );
  qid2cqidix_val[327:264] = ~sla_mhpi_get_value_by_name( $psprintf("%s[63:0]",mem_path[2]) );
  qid2cqidix_val[391:328] = ~sla_mhpi_get_value_by_name( $psprintf("%s[127:64]",mem_path[2]) );
  qid2cqidix_val[395:392] = ~sla_mhpi_get_value_by_name( $psprintf("%s[131:128]",mem_path[2]) );
  qid2cqidix_val[459:396] = ~sla_mhpi_get_value_by_name( $psprintf("%s[63:0]",mem_path[3]) );
  qid2cqidix_val[523:460] = ~sla_mhpi_get_value_by_name( $psprintf("%s[127:64]",mem_path[3]) );
  qid2cqidix_val[527:524] = ~sla_mhpi_get_value_by_name( $psprintf("%s[131:128]",mem_path[3]) );

  for (int s = 0 ; s <= (path_msb - path_lsb) ; s++) begin 
    case (field_name.tolower())
      "cq_p0": qid2cqidix_val[(reg_num * 32)      + slice_offset + s] = wdata[s];
      "cq_p1": qid2cqidix_val[(reg_num * 32) +  8 + slice_offset + s] = wdata[s];
      "cq_p2": qid2cqidix_val[(reg_num * 32) + 16 + slice_offset + s] = wdata[s];
      "cq_p3": qid2cqidix_val[(reg_num * 32) + 24 + slice_offset + s] = wdata[s];
    endcase
  end

  for (int w = 0 ; w < 16 ; w++) begin
    qid2cqidix_val[512 + w] = ~(^qid2cqidix_val[(w*32) +: 32]);
  end

  qid2cqidix_val = ~qid2cqidix_val;

  hqm_write_qid2cqidix_backdoor = SLA_OK;
  hqm_write_qid2cqidix_backdoor = (sla_mhpi_put_value_by_name($psprintf("%s[63:0]",mem_path[0]),         qid2cqidix_val[63:0])    == SLA_OK) ? hqm_write_qid2cqidix_backdoor : SLA_FAIL; 
  hqm_write_qid2cqidix_backdoor = (sla_mhpi_put_value_by_name($psprintf("%s[127:64]",mem_path[0]),       qid2cqidix_val[127:64])  == SLA_OK) ? hqm_write_qid2cqidix_backdoor : SLA_FAIL; 
  hqm_write_qid2cqidix_backdoor = (sla_mhpi_put_value_by_name($psprintf("%s[131:128]",mem_path[0]),      qid2cqidix_val[131:128]) == SLA_OK) ? hqm_write_qid2cqidix_backdoor : SLA_FAIL; 
  hqm_write_qid2cqidix_backdoor = (sla_mhpi_put_value_by_name($psprintf("%s[63:0]",mem_path[1]),         qid2cqidix_val[195:132]) == SLA_OK) ? hqm_write_qid2cqidix_backdoor : SLA_FAIL; 
  hqm_write_qid2cqidix_backdoor = (sla_mhpi_put_value_by_name($psprintf("%s[127:64]",mem_path[1]),       qid2cqidix_val[259:196]) == SLA_OK) ? hqm_write_qid2cqidix_backdoor : SLA_FAIL; 
  hqm_write_qid2cqidix_backdoor = (sla_mhpi_put_value_by_name($psprintf("%s[131:128]",mem_path[1]),      qid2cqidix_val[263:260]) == SLA_OK) ? hqm_write_qid2cqidix_backdoor : SLA_FAIL; 
  hqm_write_qid2cqidix_backdoor = (sla_mhpi_put_value_by_name($psprintf("%s[63:0]",mem_path[2]),         qid2cqidix_val[327:264]) == SLA_OK) ? hqm_write_qid2cqidix_backdoor : SLA_FAIL; 
  hqm_write_qid2cqidix_backdoor = (sla_mhpi_put_value_by_name($psprintf("%s[127:64]",mem_path[2]),       qid2cqidix_val[391:328]) == SLA_OK) ? hqm_write_qid2cqidix_backdoor : SLA_FAIL; 
  hqm_write_qid2cqidix_backdoor = (sla_mhpi_put_value_by_name($psprintf("%s[131:128]",mem_path[2]),      qid2cqidix_val[395:392]) == SLA_OK) ? hqm_write_qid2cqidix_backdoor : SLA_FAIL; 
  hqm_write_qid2cqidix_backdoor = (sla_mhpi_put_value_by_name($psprintf("%s[63:0]",mem_path[3]),         qid2cqidix_val[459:396]) == SLA_OK) ? hqm_write_qid2cqidix_backdoor : SLA_FAIL; 
  hqm_write_qid2cqidix_backdoor = (sla_mhpi_put_value_by_name($psprintf("%s[127:64]",mem_path[3]),       qid2cqidix_val[523:460]) == SLA_OK) ? hqm_write_qid2cqidix_backdoor : SLA_FAIL; 
  hqm_write_qid2cqidix_backdoor = (sla_mhpi_put_value_by_name($psprintf("%s[131:128]",mem_path[3]),      qid2cqidix_val[527:524]) == SLA_OK) ? hqm_write_qid2cqidix_backdoor : SLA_FAIL; 
endfunction

function bit [1:0] hqm_ral_backdoor::gen_residue(input bit [127:0] data, input int width);
  bit [2:0] residue;

  residue = 3'b000;

  for (int i = 0 ; i < ((width +1) / 2) ; i++) begin
    residue = (residue + {1'b0,data[(2*i) +: 2]}) % 3'b011;
  end

  gen_residue = residue;
endfunction

function bit hqm_ral_backdoor::gen_parity(input bit [127:0] data, input int width);
  bit parity;

  parity = 1'b1;

  for (int i = 0 ; i < width ; i++) begin
    parity = parity ^ data[i];
  end

  gen_parity = parity;
endfunction
`endif //`ifndef HQM_IP_TB_OVM
