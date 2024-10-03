`ifdef INTEL_INST_ON

module hqm_master_inst import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

`ifdef INTEL_INST_ON
 
   logic clk;
   logic rst_n;
   
   logic [( 20 )-1:0] puser;
   logic              psel;
   logic              pwrite;
   logic              penable;
   logic [( 32 )-1:0] paddr;
   logic [( 32 )-1:0] pwdata;

   logic              pready;
   logic              plverr;
   logic [( 32 )-1:0] prdata;  
 
   logic cfg_req_down_write;
   logic cfg_req_down_read;
   cfg_req_t cfg_req_down;

   logic cfg_req_internal_write;
   logic cfg_req_internal_read;
   cfg_req_t cfg_req_internal;

   logic cfg_req_up_write;
   logic cfg_req_up_read;
   cfg_req_t cfg_req_up;

   logic cfg_rsp_up_ack;
   cfg_rsp_t cfg_rsp_up;

   logic cfg_rsp_internal_ack;
   cfg_rsp_t cfg_rsp_internal;

   logic err_timeout;
   logic err_cfg_rspreq_unsol;
   logic err_cfg_protocol;
   logic err_cfg_req_up_miss;
   logic err_slv_access;
   logic err_slv_par;
   logic err_cfg_req_drop;
   logic err_cfg_decode;

   logic cfg_req_down_v_f;
   logic cfg_req_internal_v_f; 


   logic                       ring_pready_drop, internal_pready_drop;
   logic                       cfg_req_internal_write_f;
   logic                       cfg_req_internal_read_f;
   logic                       cfg_req_down_write_f;
   logic                       cfg_req_down_read_f;
   cfg_req_t                   cfg_req_down_f;
   cfg_req_t                   cfg_req_internal_f;
   logic                       hqm_flr_prep;
   logic                       pm_fsm_in_run;
   logic                       core_reset_done;
         
   assign ring_pready_drop = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.ring_pready_drop;
   assign internal_pready_drop = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.internal_pready_drop;
   assign cfg_req_down_f = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_down_f;
   assign cfg_req_internal_f = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_internal_f;
   assign cfg_req_internal_write_f = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_internal_write_f;
   assign cfg_req_internal_read_f = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_internal_read_f;
   assign cfg_req_down_write_f = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_down_write_f;
   assign cfg_req_down_read_f = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_down_read_f;
   assign hqm_flr_prep = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.hqm_flr_prep;
   assign pm_fsm_in_run = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.pm_fsm_in_run;
   assign core_reset_done = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.core_reset_done;

   assign puser = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.puser;
   assign psel = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.psel;
   assign pwrite = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.pwrite;
   assign penable = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.penable;
   assign paddr = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.paddr;
   assign pwdata = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.pwdata;

   assign pready = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.pready;
   assign pslverr = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.pslverr;
   assign prdata = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.prdata;
 
   assign clk = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.prim_gated_clk;
   assign rst_n = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.prim_gated_rst_b_sync;
   assign cfg_req_down_write = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_down_write;
   assign cfg_req_down_read = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_down_read;
   assign cfg_req_down = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_down;

   assign cfg_req_internal_write = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_internal_write;
   assign cfg_req_internal_read = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_internal_read;
   assign cfg_req_internal = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_internal;

   assign cfg_req_up_write = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_up_write;
   assign cfg_req_up_read = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_up_read;
   assign cfg_req_up = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_up;
 
   assign cfg_rsp_up_ack = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_rsp_up_ack;
   assign cfg_rsp_up = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_rsp_up;
   
   assign cfg_rsp_internal_ack = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_rsp_internal_ack;
   assign cfg_rsp_internal = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_rsp_internal;

   assign err_timeout = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.err_timeout;
   assign err_cfg_reqrsp_unsol = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.err_cfg_reqrsp_unsol;
   assign err_cfg_protocol = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.err_cfg_protocol;
   assign err_cfg_req_up_miss = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.err_cfg_req_up_miss;
   assign err_slv_access = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.err_slv_access;
   assign err_slv_par = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.err_slv_par;

assign err_cfg_req_drop = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.err_cfg_req_drop ;
assign err_cfg_decode = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.err_cfg_decode ;

   assign cfg_req_down_v_f = i_hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_down_v_f;
   assign cfg_req_internal_v_f = i_hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_internal_v_f;

   logic [31:0] cfg_err_cnt_f, cfg_err_cnt_nxt ;   

   always_comb begin

     // Default is hold until slv err pulse
     cfg_err_cnt_nxt = cfg_err_cnt_f;

     if ( err_slv_access ) begin
       cfg_err_cnt_nxt = cfg_err_cnt_f + 32'd1 ;
     end

   end

   always_ff @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
        cfg_err_cnt_f <= '0;      
      end
      else begin
        cfg_err_cnt_f <= cfg_err_cnt_nxt;
      end
   end // always_ff

   always_ff @(posedge clk) begin

// PRINTS
if ($test$plusargs("HQM_DEBUG_HIGH")) begin

      if (rst_n & pready) begin
          $display("@%0tps [MASTER_INFO] APB RSP, pready:%h, pslveror:%h, prdata:%h,"
                   ,$time
                   ,pready
                   ,pslverr
                   ,prdata
                  );
      end

      if (rst_n & psel & ~penable & pwrite ) begin
          $display("@%0tps [MASTER_INFO] APB REQ WRITE, psel:%h, penable:%h, pwrite:%h, paddr:%h, pwdata:%h,"
                   ,$time
                   ,psel
                   ,penable
                   ,pwrite
                   ,paddr
                   ,pwdata
                  );
      end

      if (rst_n & psel & ~penable & ~pwrite ) begin
          $display("@%0tps [MASTER_INFO] APB REQ READ, psel:%h, penable:%h, pwrite:%h, paddr:%h,"
                   ,$time
                   ,psel
                   ,penable
                   ,pwrite
                   ,paddr
                  );
      end


      if (rst_n & cfg_req_down_read) begin
         $display("@%0tps [MASTER_INFO] CFG RING REQ READ, node:%h, target:%h, offset:%h, user:%h,"
                  ,$time
                  ,cfg_req_down.addr.node
                  ,cfg_req_down.addr.target
                  ,cfg_req_down.addr.offset
                  ,cfg_req_down.user
                 );
      end

      if (rst_n & cfg_req_down_write) begin
         $display("@%0tps [MASTER_INFO] CFG RING REQ WRITE, node:%h, target:%h, offset:%h, wdata:%h, user:%h,"
                  ,$time
                  ,cfg_req_down.addr.node
                  ,cfg_req_down.addr.target
                  ,cfg_req_down.addr.offset
                  ,cfg_req_down.wdata
                  ,cfg_req_down.user
                 );
      end

      if (rst_n & cfg_req_internal_write) begin
         $display("@%0tps [MASTER_INFO] MSTR CFG REQ WRITE, node:%h, target:%h, offset:%h, wdata:%h, user:%h,"
                  ,$time
                  ,cfg_req_internal.addr.node
                  ,cfg_req_internal.addr.target
                  ,cfg_req_internal.addr.offset
                  ,cfg_req_internal.wdata  
                  ,cfg_req_internal.user
                 );
      end
      

     if (rst_n & cfg_req_internal_read) begin
         $display("@%0tps [MASTER_INFO] MSTR CFG REQ READ, node:%h, target:%h, offset:%h, user:%h,"
                  ,$time
                  ,cfg_req_internal.addr.node
                  ,cfg_req_internal.addr.target
                  ,cfg_req_internal.addr.offset
                  ,cfg_req_internal.user
                 );
     end
     
     if (rst_n & (cfg_rsp_up_ack)) begin
         $display("@%0tps [MASTER_INFO] CFG RING RSP, ack:%h, rdata:%h, eror:%h, eror_slv_par:%h, uid:%h,"
                  ,$time
                  ,cfg_rsp_up_ack
                  ,cfg_rsp_up.rdata
                  ,cfg_rsp_up.err
                  ,cfg_rsp_up.err_slv_par
                  ,cfg_rsp_up.uid
                 );
     end

      if (rst_n & (cfg_rsp_internal_ack)) begin
         $display("@%0tps [MASTER_INFO] MSTR CFG RSP, ack:%h, rdata:%h, eror:%h, eror_slv_par:%h, uid:%h,"
                  ,$time
                  ,cfg_rsp_internal_ack
                  ,cfg_rsp_internal.rdata
                  ,cfg_rsp_internal.err
                  ,cfg_rsp_internal.err_slv_par
                  ,cfg_rsp_internal.uid
                 );
      end

      if (rst_n & (cfg_req_up_write|cfg_req_up_read)) begin
         $display("@%0tps [MASTER_INFO] CFG RING REQ RETURN, write:%h, read:%h, node:%h, target:%h, offset:%h, wdata:%h, user:%h,"
                  ,$time
                  ,cfg_req_up_write
                  ,cfg_req_up_read
                  ,cfg_req_up.addr.node
                  ,cfg_req_up.addr.target
                  ,cfg_req_up.addr.offset
                  ,cfg_req_up.wdata
                  ,cfg_req_up.user
                 );
      end

     // CFG REQUEST DROPPED AT RING
     if (rst_n & ring_pready_drop ) begin
         $display("@%0tps [MASTER_INFO] CFG RING REQ DROP (SILENT ACK), ring_pready_drop:%h, ~pm_fsm_in_run:%h, addr_decode_err:%h, cfg_req_down_write_f:%h, cfg_req_down_read_f:%h"
                  ,$time
                  ,ring_pready_drop
                  ,(~pm_fsm_in_run) 
                  ,cfg_req_down_f.user.addr_decode_err
                  ,cfg_req_down_write_f
                  ,cfg_req_down_read_f
                 );
     end

     // CFG REQUEST DROPPED - INTERNAL
     if (rst_n & internal_pready_drop ) begin
         $display("@%0tps [MASTER_INFO] CFG INTERNAL REQ DROP (SILENT ACK), internal_pready_drop:%h, addr_decode_err:%h, cfg_req_internal_write_f:%h, cfg_req_internal_read_f:%h"
                  ,$time
                  ,internal_pready_drop
                  ,cfg_req_internal_f.user.addr_decode_err
                  ,cfg_req_internal_write_f
                  ,cfg_req_internal_read_f
                 );
     end


      if (rst_n & (err_timeout | err_cfg_reqrsp_unsol | err_cfg_protocol | err_cfg_req_up_miss |  err_slv_access | err_slv_par | err_cfg_decode | err_cfg_req_drop)) begin
          $display("@%0tps [MASTER_ERORR] timeout:%h, reqrsp_unsol:%h, protocol:%h, req_miss:%h, slv_access:%h, slv_par:%h, synd_uid:%h, synd_enc:%h, synd_node:%h, synd_targ:%h, synd_ofst4:%h"
                   ,$time
                   ,err_timeout
                   ,err_cfg_reqrsp_unsol
                   ,err_cfg_protocol
                   ,err_cfg_req_up_miss
                   ,err_slv_access
                   ,err_slv_par
                   ,err_cfg_decode
                   ,err_cfg_req_drop
                   ,hqm_master_core.i_hqm_cfg_master.syndrome_capture_data[30:27]  //uid
                   ,hqm_master_core.i_hqm_cfg_master.syndrome_capture_data[26:24]  //enc
                   ,hqm_master_core.i_hqm_cfg_master.syndrome_capture_data[23:20]  //node 
                   ,hqm_master_core.i_hqm_cfg_master.syndrome_capture_data[19:04]  //targ 
                   ,hqm_master_core.i_hqm_cfg_master.syndrome_capture_data[03:00]  //offset[3:0]  
                  );
       end


end 

   end // always_ff

   initial begin
      $display("@%0tps [MASTER_DEBUG] hqm_master VER=%d initial block ...",$time,hqm_master_core.i_hqm_cfg_master.hqm_mstr_target_cfg_unit_version_status);
   end // begin

   final begin
      $display("@%0tps [MASTER_DEBUG] hqm_master VER=%d final block ...",$time,hqm_master_core.i_hqm_cfg_master.hqm_mstr_target_cfg_unit_version_status);
      $display("@%0tps [MASTER_DEBUG] Slv Drops  cfg_err_cnt (non-synth)                  :#%020d"
               ,$time
               ,cfg_err_cnt_f
              );
   end // final
`endif

task cfg_err_cnt (output logic [31:0] err_cnt);
  
  err_cnt = cfg_err_cnt_f;
  
endtask : cfg_err_cnt


// End of Task (EOT) Check
task eot_check (output bit pf);

  pf = 1'b0 ; //pass

//Unit state checks
  if ( (cfg_req_down_v_f|cfg_req_internal_v_f) == 1'b1 ) begin
    pf = 1'b1; //fail
    $display("@%0tps [MSTR_ERROR] EOT REQUEST STILL PENDING, cfg_req_down_v_f:%h, cfg_req_internal_v_f:%h"
             ,$time
             ,cfg_req_down_v_f
             ,cfg_req_internal_v_f
            );
  end

  if ( ( hqm_master_core.i_hqm_cfg_master.hqm_mstr_target_cfg_diagnostic_reset_status_status != 32'h80000bff ) 
     | ( hqm_master_core.i_hqm_cfg_master.hqm_mstr_target_cfg_diagnostic_idle_status_status != 32'h9f0fffff )
     | ( hqm_master_core.i_hqm_cfg_master.hqm_mstr_target_cfg_diagnostic_proc_lcb_status_status != 32'h00000000 )
     ) begin
    pf = 1'b1; //fail
    $display("@%0tps [MSTR_ERROR] EOT UNIT diagnostic status not IDLE, cfg_diagnostic_reset_status:0x%08x cfg_diagnostic_idle_status:0x%08x cfg_diagnostic_proc_lcb_status:0x%08x"
             ,$time
             ,hqm_master_core.i_hqm_cfg_master.hqm_mstr_target_cfg_diagnostic_reset_status_status
             ,hqm_master_core.i_hqm_cfg_master.hqm_mstr_target_cfg_diagnostic_idle_status_status
             ,hqm_master_core.i_hqm_cfg_master.hqm_mstr_target_cfg_diagnostic_proc_lcb_status_status
            );
  end

  if ( ((hqm_master_core.hqm_proc_clkreq_b) != 1'b1) & hqm_master_core.i_hqm_cfg_master.cfg_enable_hqm_proc_idle ) begin
    pf = 1'b1; //fail
    $display("@%0tps [MSTR_ERROR] EOT HQM not IDLE (due to traffic,cfg access,or pf_reset), &hqm_proc_clkreq_b:%h, cfg_enable_hqm_proc_idle:%h"
             ,$time
             ,(&hqm_master_core.hqm_proc_clkreq_b)
             ,(hqm_master_core.i_hqm_cfg_master.cfg_enable_hqm_proc_idle)
            );
  end










  pf = 1'b0 ; //pass 
endtask : eot_check

endmodule

bind hqm_master_core hqm_master_inst i_hqm_master_inst();

`endif
