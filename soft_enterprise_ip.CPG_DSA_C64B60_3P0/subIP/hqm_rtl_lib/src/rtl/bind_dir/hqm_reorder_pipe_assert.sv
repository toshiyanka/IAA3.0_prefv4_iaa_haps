`ifdef INTEL_INST_ON

`ifndef INTEL_SVA_OFF

module hqm_reorder_pipe_assert import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

logic                               hqm_gated_clk;
logic                               hqm_gated_rst_n;

logic [3:0]                         illegal_slt_sn_combination_grp;

logic [3:0]                         cmp_v;
logic [9:0]                         cmp_sn;
logic                               cmp_sn_pop;
logic [4:0]                         cmp_slt;
logic [2:0]                         cmp_mode;
logic [3:0]                         cmp_ready;

logic [1023:0]                      sn_active_nxt[3:0];
logic [1023:0]                      sn_active_f[3:0];

logic [4:0]                         request_state;

logic [3:0]                         replay_v;
logic [3:0]                         replay_selected;

logic [3:0]                         replay_sequence_v;
logic [39:0]                        replay_sequence;

logic                               pulling_sequenc_with_no_completion_nxt;
logic                               pulling_sequenc_with_no_completion_f;
logic [1:0]                         pulling_sequenc_with_no_completion_group_nxt;
logic [1:0]                         pulling_sequenc_with_no_completion_group_f;

logic                               completion_on_active_sequence_nxt; // double completion
logic                               completion_on_active_sequence_f; // double completion
logic [1:0]                         completion_on_active_sequence_group_nxt; // double completion
logic [1:0]                         completion_on_active_sequence_group_f; // double completion

logic [31:0]                       cfg_grp_sn_mode_f;

logic                               sequence_mode_cfg_chp_rop_mismatch0;
logic                               sequence_mode_cfg_chp_rop_mismatch1;
logic                               sequence_mode_cfg_chp_rop_mismatch2;
logic                               sequence_mode_cfg_chp_rop_mismatch3;

logic                               cfg_pipe_idle_collision_f;






   assign hqm_gated_clk                                    = hqm_reorder_pipe_core.hqm_gated_clk;
   assign hqm_gated_rst_n                                  = hqm_reorder_pipe_core.hqm_gated_rst_n;

   assign cmp_v                                  = { 2'd0 , hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_aw_sn_order_select[1:0] } ;
   assign cmp_sn                                 = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0];
   assign cmp_sn_pop                             = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop;
   assign cmp_slt                                = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.grp_slt[4:0];
   assign cmp_mode                               = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.grp_mode[2:0];
   assign cmp_ready                              = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_aw_sn_ready;

   assign replay_sequence_v                      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.replay_sequence_v;
   assign replay_sequence                        = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.replay_sequence;

   assign replay_v                               = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.replay_v;
   assign replay_selected                        = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.replay_selected;
   assign cfg_grp_sn_mode_f                      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_grp_sn_mode_f;

   assign request_state                          = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state;


   assign sequence_mode_cfg_chp_rop_mismatch0 = cmp_v[0] & (cfg_grp_sn_mode_f[0*8 +: 3] != cmp_mode[2:0]); 
   assign sequence_mode_cfg_chp_rop_mismatch1 = cmp_v[1] & (cfg_grp_sn_mode_f[1*8 +: 3] != cmp_mode[2:0]); 
   assign sequence_mode_cfg_chp_rop_mismatch2 = cmp_v[2] & (cfg_grp_sn_mode_f[2*8 +: 3] != cmp_mode[2:0]); 
   assign sequence_mode_cfg_chp_rop_mismatch3 = cmp_v[3] & (cfg_grp_sn_mode_f[3*8 +: 3] != cmp_mode[2:0]); 

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin

      cfg_pipe_idle_collision_f <= 1'b0;

 end else begin

  if ( ~hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_nxt.pipe_idle & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_nxt.cfg_active ) begin 

        cfg_pipe_idle_collision_f <= 1'b1;

      end else begin

        cfg_pipe_idle_collision_f <= 1'b0;

      end
  end

end

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_cfg_pipe_idle_collision
                      , ( cfg_pipe_idle_collision_f==1'b1 )
                      , posedge hqm_gated_clk
                      , ~hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_cfg_pipe_idle_collision: " )
                      , SDG_SVA_SOC_SIM
                      )

logic rop_dp_enq_rop_qed_dqed_enq_same;
logic rop_nalb_enq_rop_qed_dqed_enq_same;



always_comb begin
   rop_dp_enq_rop_qed_dqed_enq_same = 1'b0;
   if (hqm_reorder_pipe_core.rop_dp_enq_v && ( (hqm_reorder_pipe_core.rop_dp_enq_data.cmd==ROP_DP_ENQ_DIR_ENQ_NEW_HCW) || (hqm_reorder_pipe_core.rop_dp_enq_data.cmd==ROP_DP_ENQ_DIR_ENQ_REORDER_HCW)) &&
       hqm_reorder_pipe_core.rop_qed_dqed_enq_v && 
       (hqm_reorder_pipe_core.rop_dp_enq_data.flid==hqm_reorder_pipe_core.rop_qed_dqed_enq_data.flid) && 
       (hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cmd==ROP_QED_DQED_ENQ_DIR)) begin
     rop_dp_enq_rop_qed_dqed_enq_same = 1'b1;
   end
end

always_comb begin
   rop_nalb_enq_rop_qed_dqed_enq_same = 1'b0;

   if (hqm_reorder_pipe_core.rop_nalb_enq_v && ( (hqm_reorder_pipe_core.rop_nalb_enq_data.cmd==ROP_NALB_ENQ_LB_ENQ_NEW_HCW) || (hqm_reorder_pipe_core.rop_nalb_enq_data.cmd==ROP_NALB_ENQ_LB_ENQ_REORDER_HCW)) &&
       hqm_reorder_pipe_core.rop_qed_dqed_enq_v &&
       (hqm_reorder_pipe_core.rop_nalb_enq_data.flid==hqm_reorder_pipe_core.rop_qed_dqed_enq_data.flid) &&
       (hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cmd==ROP_QED_DQED_ENQ_LB) ) begin
     rop_nalb_enq_rop_qed_dqed_enq_same = 1'b1;
   end
end

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_rop_dp_enq_rop_qed_dqed_enq_same
                      , ( rop_dp_enq_rop_qed_dqed_enq_same )
                      , posedge hqm_gated_clk
                      , ~hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_rop_dp_enq_rop_qed_dqed_enq_same!!" )
                      , SDG_SVA_SOC_SIM
                      )
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_rop_nalb_enq_rop_qed_dqed_enq_same 
                      , rop_nalb_enq_rop_qed_dqed_enq_same
                      , posedge hqm_gated_clk
                      , ~hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_rop_nalb_enq_rop_qed_dqed_enq_same!!" )
                      , SDG_SVA_SOC_SIM
                      )

always_comb begin
integer group_i;
     completion_on_active_sequence_nxt = 1'b0;
     completion_on_active_sequence_group_nxt = '0;

     pulling_sequenc_with_no_completion_nxt = 1'b0;
     pulling_sequenc_with_no_completion_group_nxt = '0;    

     for (group_i=0; group_i<2; group_i=group_i+1) begin
       sn_active_nxt[group_i] = sn_active_f[group_i];
     end

     for (group_i=0; group_i<2; group_i=group_i+1) begin
        if (cmp_v[group_i] & cmp_ready[group_i] & cmp_sn_pop) begin
           sn_active_nxt[group_i][cmp_sn] = 1'b1;

           if (sn_active_f[group_i][cmp_sn] == 1'b1) begin
              completion_on_active_sequence_nxt = 1'b1;
              completion_on_active_sequence_group_nxt = group_i; 
           end
        end
     end

     for (group_i=0; group_i<2; group_i=group_i+1) begin
       if (replay_sequence_v[group_i]) begin
          sn_active_nxt[group_i][replay_sequence[group_i*10 +: 10]] = 1'b0;

          // it is an error to pull 
          if (sn_active_f[group_i][replay_sequence[group_i*10 +: 10]]==1'b0) begin
            pulling_sequenc_with_no_completion_nxt = 1'b1; 
            pulling_sequenc_with_no_completion_group_nxt = group_i;
          end 
       end
     end 
end

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
  if (~hqm_gated_rst_n) begin
      pulling_sequenc_with_no_completion_f <= '0;
      pulling_sequenc_with_no_completion_group_f <= '0;

      completion_on_active_sequence_f <= '0;
      completion_on_active_sequence_group_f <= '0;

      for (int group_i=0; group_i<2; group_i=group_i+1) begin
       sn_active_f[group_i] <= '0;
      end


  end else begin
      pulling_sequenc_with_no_completion_f <= pulling_sequenc_with_no_completion_nxt;
      pulling_sequenc_with_no_completion_group_f <= pulling_sequenc_with_no_completion_group_nxt;
      completion_on_active_sequence_f <= completion_on_active_sequence_nxt; 
      completion_on_active_sequence_group_f <= completion_on_active_sequence_group_nxt; 

      for (int group_i=0; group_i<2; group_i=group_i+1) begin
       sn_active_f[group_i] <= sn_active_nxt[group_i];
      end

  end
end  
    
   always_comb begin

       illegal_slt_sn_combination_grp[1:0] = '0;

       for (int i=0; i<2; i=i+1) begin

         if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_aw_sn_order_select[i]) begin

                 case(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_grp_sn_mode_f[i*8 +: 3])
              3'b000: begin 
                         case(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.grp_slt)
                                   0: begin illegal_slt_sn_combination_grp[i] =                                                         (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >   63); end
                                   1: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] <  64) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  127); end
                                   2: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 128) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  191); end
                                   3: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 192) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  255); end
                                   4: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 256) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  319); end
                                   5: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 320) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  383); end
                                   6: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 384) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  447); end
                                   7: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 448) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  511); end
                                   8: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 512) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  575); end
                                   9: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 576) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  639); end
                                  10: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 640) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  703); end
                                  11: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 704) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  767); end
                                  12: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 768) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  831); end
                                  13: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 832) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  895); end
                                  14: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 896) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  959); end
                                  15: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 960) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] > 1023); end
                             default: begin illegal_slt_sn_combination_grp[i] = 1'b1; end
                         endcase                                           
                      end
              3'b001: begin 
                          case(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.grp_slt)
                                   0: begin illegal_slt_sn_combination_grp[i] =                                                         (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  127); end
                                   1: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 128) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  255); end
                                   2: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 256) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  383); end
                                   3: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 384) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  511); end
                                   4: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 512) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  639); end
                                   5: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 640) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  767); end
                                   6: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 768) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  895); end
                                   7: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 896) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] > 1023); end
                             default: begin illegal_slt_sn_combination_grp[i] = 1'b1; end
                          endcase
                      end
              3'b010: begin 
                          case(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.grp_slt)
                                   0: begin illegal_slt_sn_combination_grp[i] =                                                         (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  255); end
                                   1: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 256) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  511); end
                                   2: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 512) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  767); end
                                   3: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 768) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] > 1023); end
                             default: begin illegal_slt_sn_combination_grp[i] = 1'b1; end
                          endcase
                      end
              3'b011: begin 
                          case(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.grp_slt)
                                   0: begin illegal_slt_sn_combination_grp[i] =                                                         (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  511); end
                                   1: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] < 512) | (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] > 1023); end
                             default: begin illegal_slt_sn_combination_grp[i] = 1'b1; end
                          endcase
                      end
              3'b100: begin 
                          case(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.grp_slt)
                                   0: begin illegal_slt_sn_combination_grp[i] = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0] >  1023); end
                             default: begin illegal_slt_sn_combination_grp[i] = 1'b1; end
                          endcase
                      end
             default: begin                 illegal_slt_sn_combination_grp[i] = 1'b1; end 
             endcase

         end // if (hqm_aw_sn_order_select[i
       end // for
   end


`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b00000
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b0000) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b0000")
                   , SDG_SVA_SOC_SIM
                  );

`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b00010
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b00010) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b00010")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b00100
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b00100) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b00100")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b00101
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b00101) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b00101")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b00110
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b00110) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b00110")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b00111
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b00111) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b00111")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b01000
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b01000) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b01000")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b01010
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b01010) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b01010")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b01011
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b01011) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b01011")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b01110
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b01110) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b01110")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b10010
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b10010) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b10010")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b10100
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b10100) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b10100")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b10101
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b10101) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b10101")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b10110
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b10110) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b10110")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b10111
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b10111) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b10111")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b11000
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b11000) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b11000")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b11010
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b11010) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b11010")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b11011
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b11011) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b11011")
                   , SDG_SVA_SOC_SIM
                  );
`HQM_SDG_ASSERTS_FORBIDDEN(
                     invalid_request_state_b11110
                   , ((hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state == 5'b11110) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req  &(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) )
                   , posedge hqm_gated_clk
                   , ~hqm_gated_rst_n
                   , `HQM_SVA_ERR_MSG("Error:INVALID COMMAND CONDITION 5'b11110")
                   , SDG_SVA_SOC_SIM
                  );

`HQM_SDG_ASSERTS_FORBIDDEN(hqm_reorder_pipe_invalid_sn_slt_combination_grp0, illegal_slt_sn_combination_grp[0], posedge hqm_gated_clk, ~hqm_gated_rst_n, `HQM_SVA_ERR_MSG("Error:hqm_reorder_pipe: invalid sn/slt combination grp0"), SDG_SVA_SOC_SIM)
`HQM_SDG_ASSERTS_FORBIDDEN(hqm_reorder_pipe_invalid_sn_slt_combination_grp1, illegal_slt_sn_combination_grp[1], posedge hqm_gated_clk, ~hqm_gated_rst_n, `HQM_SVA_ERR_MSG("Error:hqm_reorder_pipe: invalid sn/slt combination grp1"), SDG_SVA_SOC_SIM)

// this asserts when we have sequence being pullsed but we never got completion for this sequence
`HQM_SDG_ASSERTS_FORBIDDEN(pulling_sequenc_with_no_completion, pulling_sequenc_with_no_completion_f, posedge hqm_gated_clk, ~hqm_gated_rst_n, `HQM_SVA_ERR_MSG("Error:hqm_reorder_pipe: pulling_sequenc_with_no_completion"), SDG_SVA_SOC_SIM)
// this asserts when we completion with sequence already in the list (couble completion)
`HQM_SDG_ASSERTS_FORBIDDEN(completion_on_active_sequence     , completion_on_active_sequence_f     , posedge hqm_gated_clk, ~hqm_gated_rst_n, `HQM_SVA_ERR_MSG("Error:hqm_reorder_pipe: completion_on_active_sequence"), SDG_SVA_SOC_SIM)
`HQM_SDG_ASSERTS_FORBIDDEN(sequence_mode_cfg_chp_rop_mismatch_group0, sequence_mode_cfg_chp_rop_mismatch0, posedge hqm_gated_clk, ~hqm_gated_rst_n, `HQM_SVA_ERR_MSG("Error:hqm_reorder_pipe: ROP configured mode for GRP[0] doesn't match CHP cfg"), SDG_SVA_SOC_SIM)
`HQM_SDG_ASSERTS_FORBIDDEN(sequence_mode_cfg_chp_rop_mismatch_group1, sequence_mode_cfg_chp_rop_mismatch1, posedge hqm_gated_clk, ~hqm_gated_rst_n, `HQM_SVA_ERR_MSG("Error:hqm_reorder_pipe: ROP configured mode for GRP[1] doesn't match CHP cfg"), SDG_SVA_SOC_SIM)

`HQM_SDG_ASSERTS_KNOWN_DRIVEN(
                      rop_alarm_up     
                     ,hqm_reorder_pipe_core.rop_alarm_up_data
                     , posedge hqm_gated_clk
                     , (~hqm_gated_rst_n | ~$sampled(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_alarm_up_v))
                     , `HQM_SVA_ERR_MSG("Error:rop_alarm_up_data is unknown"), SDG_SVA_SOC_SIM)

`HQM_SDG_ASSERTS_KNOWN_DRIVEN(
                      chp_rop_hcw_data_hcw_cmd 
                    ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_data.hcw_cmd
                    ,posedge hqm_gated_clk
                    ,(~hqm_gated_rst_n | ~$sampled(hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_v))
                    , `HQM_SVA_ERR_MSG("Error:chp_rop_hcw_data_hcw_cmd  is unknown"), SDG_SVA_SOC_SIM)

// assert on unknown flid but ignore when hcw_cmd==HQM_CMD_COMP
`HQM_SDG_ASSERTS_KNOWN_DRIVEN(
    chp_rop_hcw_data_flid    
   , hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_data.flid 
   , posedge hqm_gated_clk
   , (~hqm_gated_rst_n | ~($sampled(hqm_reorder_pipe_core.chp_rop_hcw_v) &
        ( ($sampled(hqm_reorder_pipe_core.chp_rop_hcw_data.hcw_cmd)==HQM_CMD_ENQ_NEW) |
          ($sampled(hqm_reorder_pipe_core.chp_rop_hcw_data.hcw_cmd)==HQM_CMD_ENQ_NEW_TOK_RET) |
          ($sampled(hqm_reorder_pipe_core.chp_rop_hcw_data.hcw_cmd)==HQM_CMD_ENQ_COMP) |
          ($sampled(hqm_reorder_pipe_core.chp_rop_hcw_data.hcw_cmd)==HQM_CMD_ENQ_COMP_TOK_RET) |
          ($sampled(hqm_reorder_pipe_core.chp_rop_hcw_data.hcw_cmd)==HQM_CMD_ENQ_FRAG) |
          ($sampled(hqm_reorder_pipe_core.chp_rop_hcw_data.hcw_cmd)==HQM_CMD_ENQ_FRAG_TOK_RET) ) ) )
   , `HQM_SVA_ERR_MSG("Error:chp_rop_hcw_data.flid is unknown"), SDG_SVA_SOC_SIM)

`HQM_SDG_ASSERTS_KNOWN_DRIVEN(
                      chp_rop_hcw_data_cq_hcw  
                     ,hqm_reorder_pipe_core.chp_rop_hcw_data.cq_hcw
                     ,posedge hqm_gated_clk
                     , (~hqm_gated_rst_n | ~$sampled(hqm_reorder_pipe_core.chp_rop_hcw_v))
                     , `HQM_SVA_ERR_MSG("Error:chp_rop_hcw_data_cq_hcw is unknown"), SDG_SVA_SOC_SIM)

`HQM_SDG_ASSERTS_AT_MOST_BITS_HIGH(
                           only_one_can_be_high                 
                          ,replay_sequence_v
                          , 1
                          , posedge hqm_gated_clk
                          , ~hqm_gated_rst_n
                          , `HQM_SVA_ERR_MSG("Error:concurrent response from hqm_AW_sn_order modules"), SDG_SVA_SOC_SIM)

`HQM_SDG_ASSERTS_AT_MOST_BITS_HIGH(
                           only_one_replay_selected_can_be_high 
                          ,replay_selected  
                          , 1
                          , posedge hqm_gated_clk
                          , ~hqm_gated_rst_n
                          , `HQM_SVA_ERR_MSG("Error:More than 1 selected from hqm_AW_sn_order modules"), SDG_SVA_SOC_SIM)

`HQM_SDG_ASSERTS_FORBIDDEN(chp_rop_hcw_fifo_of    ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_fifo_of,    posedge hqm_gated_clk, ~hqm_gated_rst_n, `HQM_SVA_ERR_MSG("Error:chp_rop_hcw_fifo    detected overflow"), SDG_SVA_SOC_SIM)
`HQM_SDG_ASSERTS_FORBIDDEN(dir_rply_req_fifo_of   ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.dir_rply_req_fifo_of,   posedge hqm_gated_clk, ~hqm_gated_rst_n, `HQM_SVA_ERR_MSG("Error:dir_rply_req_fifo       detected overflow"), SDG_SVA_SOC_SIM)
`HQM_SDG_ASSERTS_FORBIDDEN(ldb_rply_req_fifo_of   ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.ldb_rply_req_fifo_of,   posedge hqm_gated_clk, ~hqm_gated_rst_n, `HQM_SVA_ERR_MSG("Error:ldb_rply_req_fifo       detected overflow"), SDG_SVA_SOC_SIM)
`HQM_SDG_ASSERTS_FORBIDDEN(sn_ordered_fifo_of     ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_ordered_fifo_of,     posedge hqm_gated_clk, ~hqm_gated_rst_n, `HQM_SVA_ERR_MSG("Error:sn_ordered_fifo     detected overflow"), SDG_SVA_SOC_SIM)
`HQM_SDG_ASSERTS_FORBIDDEN(sn_complete_fifo_of    ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_of,    posedge hqm_gated_clk, ~hqm_gated_rst_n, `HQM_SVA_ERR_MSG("Error:sn_complete_fifo    detected overflow"), SDG_SVA_SOC_SIM)
`HQM_SDG_ASSERTS_FORBIDDEN(lsp_reordercmp_fifo_of ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.lsp_reordercmp_fifo_of, posedge hqm_gated_clk, ~hqm_gated_rst_n, `HQM_SVA_ERR_MSG("Error:lsp_reordercmp_fifo detected overflow"), SDG_SVA_SOC_SIM)

`HQM_SDG_ASSERTS_FORBIDDEN    (
                       frag_hist_list_qtype_not_ordered_qtype 
                      , hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.frag_hist_list_qtype_not_ordered
                      , posedge hqm_gated_clk
                      , ~hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error:got fragment with qtype not equail ORDERED " )
                      , SDG_SVA_SOC_SIM
                      )
//`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_int_cor0
//                      , ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.int_cor_v[0] == 1'b1 )
//                      , hqm_reorder_pipe_core.hqm_gated_clk
//                      , ~hqm_gated_rst_n
//                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_int_cor0: " )
//                      )

//HQM_SDG_ASSERTS_FORBIDDEN(name, cond, hqm_gated_clk, rst, MSG)

logic [HQM_ROP_ALARM_NUM_INF-1:0] assert_int_inf_v ;
logic int_inf_0_mask ;

always_comb begin
  assert_int_inf_v = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.int_inf_v ;
  if ($test$plusargs("HQM_INGRESS_ERROR_TEST")) begin
    assert_int_inf_v[0] = 1'b0 ;
  end
  int_inf_0_mask = 1'b0 ;
  if ($test$plusargs("HQM_CHP_FLID_PARITY_ERROR_INJECTION_TEST") ) begin
    int_inf_0_mask = int_inf_0_mask | ( hqm_reorder_pipe_core.hqm_rop_target_cfg_syndrome_01_capture_data [ 30 : 0 ] == 31'h1020_0000 ) ;
  end
end


`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_int_inf_0
                      , ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.int_inf_v[0]  & ~ int_inf_0_mask )
                      , posedge hqm_gated_clk
                      , ~hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_int_inf_0: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_chp_rop_hcw_fifo_pop_unit_idle
                      , ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_fifo_pop && hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_nxt.unit_idle )
                      , posedge hqm_gated_clk
                      , ~hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_chp_rop_hcw_fifo_pop_unit_idle" )
                      , SDG_SVA_SOC_SIM)

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_ldb_rply_req_fifo_pop
                      , ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.ldb_rply_req_fifo_pop && hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_nxt.unit_idle )
                      , posedge hqm_gated_clk
                      , ~hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_ldb_rply_req_fifo_pop_unit_idle" )
                      , SDG_SVA_SOC_SIM)

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_sn_ordered_fifo_pop
                      , ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_ordered_fifo_pop && hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_nxt.unit_idle )
                      , posedge hqm_gated_clk
                      , ~hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_sn_ordered_fifo_pop_unit_idle" )
                      , SDG_SVA_SOC_SIM)

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_sn_complete_fifo_pop
                      , ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop && hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_nxt.unit_idle )
                      , posedge hqm_gated_clk
                      , ~hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_sn_complete_fifo_pop_unit_idle" )
                      , SDG_SVA_SOC_SIM)

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_lsp_reordercmp_fifo_pop
                      , ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.lsp_reordercmp_fifo_pop && hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_nxt.unit_idle )
                      , posedge hqm_gated_clk
                      , ~hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_lsp_reordercmp_fifo_pop_unit_idle" )
                      , SDG_SVA_SOC_SIM)

// The sn_state* vector is no longer used in unit idle
//`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_pipe_health_sn_state_active0
//                      , ( (|hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.pipe_health_sn_state_f) && hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_nxt.unit_idle )
//                      , posedge hqm_gated_clk
//                      , ~hqm_gated_rst_n
//                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_sn_grp0_unit_idle" )
//                      , SDG_SVA_SOC_SIM)
//`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_pipe_health_sn_state_active1
//                      , ( (|hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[1].i_hqm_aw_sn_order.pipe_health_sn_state_f) && hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_nxt.unit_idle )
//                      , posedge hqm_gated_clk
//                      , ~hqm_gated_rst_n
//                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_sn_grp1_unit_idle" )
//                      , SDG_SVA_SOC_SIM)

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_chp_rop_hcw_db2_status 
                      , ( (|hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_status_pnc[1:0]) && hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_nxt.unit_idle )
                      , posedge hqm_gated_clk
                      , ~hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_chp_rop_hcw_db2_status_unit_idle" )
                      , SDG_SVA_SOC_SIM)
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_lsp_reordercmp_db_status
                      , ( (|hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.lsp_reordercmp_db_status_pnc[1:0]) && hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_nxt.unit_idle )
                      , posedge hqm_gated_clk
                      , ~hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_lsp_reordercmp_db_status_unit_idle" )
                      , SDG_SVA_SOC_SIM)

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_chp_rop_hcw_db_status
                      , ( (|hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_status_pnc[1:0]) && hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_nxt.unit_idle )
                      , posedge hqm_gated_clk
                      , ~hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG("Error:assert_forbidden_chp_rop_hcw_db2_status_unit_idle" )
                      , SDG_SVA_SOC_SIM)


endmodule

bind hqm_reorder_pipe_core hqm_reorder_pipe_assert i_hqm_reorder_pipe_assert();

`endif

`endif

