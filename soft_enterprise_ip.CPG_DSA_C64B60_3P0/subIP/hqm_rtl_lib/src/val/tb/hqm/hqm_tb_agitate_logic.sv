hqm_tb_agitate #(
  .NAME("hcw_wr_rdy"),
  .PATH("hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_system.i_hqm_system_core.i_hqm_ri.i_ri_cds.i_hcw_wr_aw_db.in_ready_f"),
  .VALUE(0)
) i_hcw_wr_rdy_agitate (
  .clk(prim_clk_root)
);

initial begin
  string        explode_q[$];

  int           agitate_phdr_afull_state        = 0;

  string        agitate_phdr_afull_arg          = "";
  int           agitate_phdr_afull_min_off      = 1;
  int           agitate_phdr_afull_max_off      = 1;
  int           agitate_phdr_afull_min_on       = 0;
  int           agitate_phdr_afull_max_on       = 0;

  int           agitate_pdata_afull_state       = 0;

  string        agitate_pdata_afull_arg         = "";
  int           agitate_pdata_afull_min_on      = 1;
  int           agitate_pdata_afull_max_on      = 1;
  int           agitate_pdata_afull_min_off     = 0;
  int           agitate_pdata_afull_max_off     = 0;

  $value$plusargs("agitate_phdr_afull=%s",agitate_phdr_afull_arg);
  $value$plusargs("agitate_pdata_afull=%s",agitate_pdata_afull_arg);

  explode_q.delete();
  lvm_common_pkg::explode(":",agitate_phdr_afull_arg,explode_q);

  case (explode_q.size())
    0: begin
       end
    1: begin
         if (lvm_common_pkg::token_to_int(explode_q[0],agitate_phdr_afull_min_off) == 0) begin
           `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_phdr_afull_arg))
         end else begin
           agitate_phdr_afull_max_off   = agitate_phdr_afull_min_off;
           agitate_phdr_afull_min_on    = agitate_phdr_afull_min_off;
           agitate_phdr_afull_max_on    = agitate_phdr_afull_min_off;
         end
       end
    2: begin
         if (lvm_common_pkg::token_to_int(explode_q[0],agitate_phdr_afull_min_off) == 0) begin
           `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_phdr_afull_arg))
         end else begin
           agitate_phdr_afull_min_on    = agitate_phdr_afull_min_off;

           if (lvm_common_pkg::token_to_int(explode_q[1],agitate_phdr_afull_max_off) == 0) begin
             `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_phdr_afull_arg))
           end else begin
             agitate_phdr_afull_max_on    = agitate_phdr_afull_max_off;
           end
         end
       end
    3: begin
         if (lvm_common_pkg::token_to_int(explode_q[0],agitate_phdr_afull_min_off) == 0) begin
           `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_phdr_afull_arg))
         end else begin
           if (lvm_common_pkg::token_to_int(explode_q[1],agitate_phdr_afull_max_off) == 0) begin
             `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_phdr_afull_arg))
           end else begin
             if (lvm_common_pkg::token_to_int(explode_q[2],agitate_phdr_afull_min_on) == 0) begin
               `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_phdr_afull_arg))
             end else begin
               agitate_phdr_afull_max_on    = agitate_phdr_afull_min_on;
             end
           end
         end
       end
    default: begin
         if (lvm_common_pkg::token_to_int(explode_q[0],agitate_phdr_afull_min_off) == 0) begin
           `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_phdr_afull_arg))
         end else begin
           if (lvm_common_pkg::token_to_int(explode_q[1],agitate_phdr_afull_max_off) == 0) begin
             `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_phdr_afull_arg))
           end else begin
             if (lvm_common_pkg::token_to_int(explode_q[2],agitate_phdr_afull_min_on) == 0) begin
               `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_phdr_afull_arg))
             end else begin
               if (lvm_common_pkg::token_to_int(explode_q[3],agitate_phdr_afull_max_on) == 0) begin
                 `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_phdr_afull_arg))
               end
             end
           end
         end
       end
  endcase

  explode_q.delete();
  lvm_common_pkg::explode(":",agitate_pdata_afull_arg,explode_q);

  case (explode_q.size())
    0: begin
       end
    1: begin
         if (lvm_common_pkg::token_to_int(explode_q[0],agitate_pdata_afull_min_off) == 0) begin
           `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_pdata_afull_arg))
         end else begin
           agitate_pdata_afull_max_off   = agitate_pdata_afull_min_off;
           agitate_pdata_afull_min_on    = agitate_pdata_afull_min_off;
           agitate_pdata_afull_max_on    = agitate_pdata_afull_min_off;
         end
       end
    2: begin
         if (lvm_common_pkg::token_to_int(explode_q[0],agitate_pdata_afull_min_off) == 0) begin
           `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_pdata_afull_arg))
         end else begin
           agitate_pdata_afull_min_on    = agitate_pdata_afull_min_off;

           if (lvm_common_pkg::token_to_int(explode_q[1],agitate_pdata_afull_max_off) == 0) begin
             `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_pdata_afull_arg))
           end else begin
             agitate_pdata_afull_max_on    = agitate_pdata_afull_max_off;
           end
         end
       end
    3: begin
         if (lvm_common_pkg::token_to_int(explode_q[0],agitate_pdata_afull_min_off) == 0) begin
           `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_pdata_afull_arg))
         end else begin
           if (lvm_common_pkg::token_to_int(explode_q[1],agitate_pdata_afull_max_off) == 0) begin
             `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_pdata_afull_arg))
           end else begin
             if (lvm_common_pkg::token_to_int(explode_q[2],agitate_pdata_afull_min_on) == 0) begin
               `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_pdata_afull_arg))
             end else begin
               agitate_pdata_afull_max_on    = agitate_pdata_afull_min_on;
             end
           end
         end
       end
    default: begin
         if (lvm_common_pkg::token_to_int(explode_q[0],agitate_pdata_afull_min_off) == 0) begin
           `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_pdata_afull_arg))
         end else begin
           if (lvm_common_pkg::token_to_int(explode_q[1],agitate_pdata_afull_max_off) == 0) begin
             `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_pdata_afull_arg))
           end else begin
             if (lvm_common_pkg::token_to_int(explode_q[2],agitate_pdata_afull_min_on) == 0) begin
               `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_pdata_afull_arg))
             end else begin
               if (lvm_common_pkg::token_to_int(explode_q[3],agitate_pdata_afull_max_on) == 0) begin
                 `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_phdr_afull_arg))
               end
             end
           end
         end
       end
  endcase

  agitate_phdr_afull_state = $urandom_range(agitate_phdr_afull_max_off,agitate_phdr_afull_min_off);
  agitate_pdata_afull_state = $urandom_range(agitate_pdata_afull_max_off,agitate_pdata_afull_min_off);

  forever begin
    @(posedge prim_clk_root); 
    #0.1;
    if (agitate_phdr_afull_state > 0) begin
      agitate_phdr_afull_state--;

      if (agitate_phdr_afull_state == 0) begin
        agitate_phdr_afull_state = -$urandom_range(agitate_phdr_afull_max_on,agitate_phdr_afull_min_on);

        if (agitate_phdr_afull_state < 0) begin
        force hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_system.i_hqm_system_core.i_hqm_ti.i_ti_trn.i_ph_fifo.fifo_afull = 1'b1;
      end
    end
    end else if (agitate_phdr_afull_state < 0) begin
      agitate_phdr_afull_state++;

      if (agitate_phdr_afull_state == 0) begin
        agitate_phdr_afull_state = $urandom_range(agitate_phdr_afull_max_off,agitate_phdr_afull_min_off);

        if (agitate_phdr_afull_state > 0) begin
          release hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_system.i_hqm_system_core.i_hqm_ti.i_ti_trn.i_ph_fifo.fifo_afull;
      end
      end
    end

    if (agitate_pdata_afull_state > 0) begin
      agitate_pdata_afull_state--;

      if (agitate_pdata_afull_state == 0) begin
        agitate_pdata_afull_state = -$urandom_range(agitate_pdata_afull_max_on,agitate_pdata_afull_min_on);

        if (agitate_pdata_afull_state < 0) begin
        force hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_system.i_hqm_system_core.i_hqm_ti.i_ti_trn.i_pd_fifo.fifo_afull = 1'b1;
      end
    end
    end else if (agitate_pdata_afull_state < 0) begin
      agitate_pdata_afull_state++;

      if (agitate_pdata_afull_state == 0) begin
        agitate_pdata_afull_state = $urandom_range(agitate_pdata_afull_max_off,agitate_pdata_afull_min_off);

        if (agitate_pdata_afull_state > 0) begin
          release hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_system.i_hqm_system_core.i_hqm_ti.i_ti_trn.i_pd_fifo.fifo_afull;
        end
      end
    end
  end
end


