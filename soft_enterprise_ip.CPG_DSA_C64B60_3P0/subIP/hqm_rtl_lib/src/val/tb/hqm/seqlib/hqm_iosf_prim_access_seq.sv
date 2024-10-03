class hqm_iosf_prim_access_seq extends sla_ral_sequence_base;
  `ovm_sequence_utils(hqm_iosf_prim_access_seq,IosfAgtSeqr);

  typedef struct {
    bit [7:0]   sai_6bit_to_8bit[$];
  } sai_queue_t;

  sla_ral_data_t 	rd_legal_sais[$];
  sla_ral_data_t 	wr_legal_sais[$];
  sai_queue_t           sai_queues[64];

  Iosf::address_t       addr;

  int                   ral_size;
  int                   hraissai = 0; //if nonzero, hqm_ral_attr_seq sai testing
  int                   hqm_sai_mtc = 1;  //if nonzero, sai matched (access is OK)
  int                   hqm_sai_rpr = 0;  //if nonzero, read policy_role inside RAC,WAC,CP
  int                   hqm_iosf_exp_mem_read_error = 0; //if nonzero, expect an error
  string                hqm_policy_role = ""; //policy role

  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string n="hqm_iosf_prim_access_seq");
    super.new();
    $value$plusargs({"hraissai","=%d"}, this.hraissai); //hqm_ral_attr_seq sai testing enable/disable

    for (bit [8:0] sai8 = 0 ; sai8 < 9'h100 ; sai8++) begin
      if (sai8[0] == 1'b1) begin
        sai_queues[{3'b000,sai8[3:1]}].sai_6bit_to_8bit.push_back(sai8);
      end else if ((sai8[7:1] > 7'b0000111) && (sai8[7:1] < 7'b0111111)) begin
        sai_queues[sai8[6:1]].sai_6bit_to_8bit.push_back(sai8);
      end else begin
        sai_queues[6'b111111].sai_6bit_to_8bit.push_back(sai8);
      end
    end

    //print out queues
    for (int sai6q = 0 ; sai6q < 64 ; sai6q++)
     begin : saiq_list_lp
       if(sai_queues[sai6q].sai_6bit_to_8bit.size >0)
         begin : saiq_list_nz
           foreach(sai_queues[sai6q].sai_6bit_to_8bit[sai6to8])
            begin : saiq_list_inside_lp
              `ovm_info(get_type_name(),
                $psprintf("sai6q=0x%x,sai8=0x%x",
                           sai6q,    sai_queues[sai6q].sai_6bit_to_8bit[sai6to8]),
                           OVM_FULL);
            end : saiq_list_inside_lp
         end : saiq_list_nz
        else
          begin : saiq_list_z
              `ovm_info(get_type_name(),
                $psprintf("sai6q=0x%x zerosize",
                           sai6q),
                           OVM_FULL);
          end   : saiq_list_z
     end   : saiq_list_lp
  endfunction

  function bit [7:0] get_8bit_sai(sla_ral_sai_t sai6);
    sai6 = sai6 & 6'h3f;
    return (sai_queues[sai6].sai_6bit_to_8bit[$urandom_range(sai_queues[sai6].sai_6bit_to_8bit.size()-1,0)]);
  endfunction

  task body;
    bit [7:0] sai8;

    addr = target.get_addr_val(source);
    ral_size = target.get_size();
    sai8 = get_8bit_sai(sai);

    ral_status = SLA_OK;

    case (operation)
      "read": begin : op_is_read
        if(hraissai != 0)
          begin : hraissai_nz_rd
            hqm_policy_role = target.get_policy_role();

            if((hqm_policy_role.len() != 0) &&
               (ovm_is_match(hqm_policy_role,"RAC") ||
                ovm_is_match(hqm_policy_role,"WAC") ||
                ovm_is_match(hqm_policy_role,"CP")))
              begin : hqm_sai_is_rpr
                hqm_sai_rpr = 1;
                `ovm_info(get_type_name(),
                  $psprintf("hqm_sai_is_rpr rgn=%s role=%s hqm_sai_rpr=%0d",
                        target.get_name(),hqm_policy_role, hqm_sai_rpr),
                          OVM_LOW);
              end   : hqm_sai_is_rpr
             else
              begin : hqm_sai_not_rpr
                hqm_sai_rpr = 0;
              end   : hqm_sai_not_rpr
          
            target.get_legal_sai_values(RAL_READ,rd_legal_sais);
            hqm_sai_mtc = 0; // access legality not established yet
            for ( int idx_ls = 0; idx_ls < rd_legal_sais.size; idx_ls++ )
              begin : rd_legal_sais_lp
                `ovm_info(get_type_name(),
                  $psprintf("rgn=%s legal_sai=0x%x,sai8=0x%x,sai=0x%x",
                        target.get_name(),rd_legal_sais[idx_ls],sai8,sai),
                          OVM_FULL);
                 if(rd_legal_sais[idx_ls] == sai)
                   begin : rd_legal_sai_mtc
                     `ovm_info(get_type_name(),
                      $psprintf("rd_legal_sai_mtc rgn=%s legal_sai=0x%x,sai8=0x%x,sai=0x%x",
                             target.get_name(),rd_legal_sais[idx_ls],sai8,sai),
                             OVM_FULL);
                      hqm_sai_mtc = 1; //sai matches, legal acces!
                   end   : rd_legal_sai_mtc
               end : rd_legal_sais_lp
           end : hraissai_nz_rd
        case (target.get_space())
          "CFG": begin : rd_cfg_op
            `ovm_do_with(cfg_read_seq, {iosf_addr == addr; reg_size == ral_size; iosf_sai == sai8; iosf_exp_error == ignore_access_error;})
            ral_data = cfg_read_seq.iosf_data >> (addr[1:0] * 8);
            for (int i = target.get_size() ; i < $bits(ral_data) ; i++) ral_data[i] = 1'b0;
            ral_status = (cfg_read_seq.iosf_cpl_status == 3'b000) ? SLA_OK : SLA_FAIL;
          end : rd_cfg_op
          "MEM": begin : rd_mem_op
                  hqm_iosf_exp_mem_read_error = (ignore_access_error && hqm_sai_rpr != 1) ? 1 : 0;
            `ovm_info(get_type_name(),
                $psprintf("hiemre=%0d iae=%0d mtc=%0d rpr=%0d pr=%s",
                hqm_iosf_exp_mem_read_error,ignore_access_error,hqm_sai_mtc,hqm_sai_rpr,hqm_policy_role),
                OVM_HIGH);
            `ovm_do_with(mem_read_seq,
                         {iosf_addr == addr;
                          iosf_sai == sai8;
                          iosf_exp_error == hqm_iosf_exp_mem_read_error;})
            ral_data = mem_read_seq.iosf_data;
            ral_status = (mem_read_seq.iosf_cpl_status == 3'b000) ?
                          ((hqm_sai_mtc == 0 && hqm_sai_rpr != 1) ? SLA_SAI_FAIL : SLA_OK) : SLA_FAIL;
          end : rd_mem_op
          default: begin : rd_def_op
            ral_status = SLA_FAIL;
          end : rd_def_op
        endcase
      end : op_is_read ////////////////////////////////////////////
      "write": begin : op_is_write
        if(hraissai != 0)
          begin : hraissai_nz_wr
            target.get_legal_sai_values(RAL_WRITE,wr_legal_sais);
            hqm_sai_mtc = 0; // access legality not established yet
            for ( int idx_ls = 0; idx_ls < wr_legal_sais.size; idx_ls++ )
              begin : wr_legal_sais_lp
                `ovm_info(get_type_name(),
                  $psprintf("rgn=%s legal_sai=0x%x,sai8=0x%x,sai=0x%x",
                        target.get_name(),wr_legal_sais[idx_ls],sai8,sai),
                          OVM_FULL);
                 if(wr_legal_sais[idx_ls] == sai)
                   begin : wr_legal_sai_mtc
                     `ovm_info(get_type_name(),
                      $psprintf("wr_legal_sai_mtc rgn=%s legal_sai=0x%x,sai8=0x%x,sai=0x%x",
                             target.get_name(),wr_legal_sais[idx_ls],sai8,sai),
                             OVM_FULL);
                      hqm_sai_mtc = 1; //sai matches, legal acces!
                   end   : wr_legal_sai_mtc
               end : wr_legal_sais_lp
           end : hraissai_nz_wr

        case (target.get_space())
          "CFG": begin : wr_cfg_op
            logic hqm_is_reg_ep_arg=0;  $value$plusargs("hqm_is_reg_ep=%d",hqm_is_reg_ep_arg);
            `ovm_do_with(cfg_write_seq, {iosf_addr == addr; reg_size == ral_size; iosf_data == ral_data[31:0]; iosf_sai == sai8; iosf_exp_error == ignore_access_error;})
            ral_status = (cfg_write_seq.iosf_cpl_status == 3'b000) ?
                          ((hqm_sai_mtc == 0) ? SLA_SAI_FAIL : SLA_OK) : SLA_FAIL;
          end : wr_cfg_op
          "MEM": begin : wr_mem_op
            `ovm_do_with(mem_write_seq, {iosf_addr == addr; iosf_data.size() == 1; iosf_data[0] == ral_data[31:0]; iosf_sai == sai8;})
            //Posted mem writes return no iosf_cpl_status 
            //reasonable assumption,needs subsequent verification by a read operation.
            ral_status = (hqm_sai_mtc == 0) ?  SLA_SAI_FAIL : SLA_OK;
          end : wr_mem_op
          default: begin : wr_def_op
            ral_status = SLA_FAIL;
          end : wr_def_op
        endcase
      end : op_is_write //////////////////////////////
        default: begin : op_not_read_nor_write
          ral_status = SLA_FAIL;
        end : op_not_read_nor_write
    endcase //operation
  endtask : body

endclass : hqm_iosf_prim_access_seq
