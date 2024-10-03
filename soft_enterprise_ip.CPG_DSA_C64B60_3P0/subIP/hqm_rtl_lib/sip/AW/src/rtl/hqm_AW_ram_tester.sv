module hqm_AW_ram_tester (
  input logic clk
, input logic rst_n
, input logic re 
, input logic we 
, input logic [4:0] ft_data_in
, input logic [11:0] data_in
, output logic [4:0] ft_data_out
, output logic [11:0] sram_data_out
, output logic [11:0] rf_data_out
);

logic [11:0] ram_to_ram;

hqm_AW_rf_4096x12 i_rf_rop_qed_dqed_enq (
    .wclk                               ( clk )
  , .we                                 ( we )
  , .waddr                              ( data_in )
  , .wdata                              ( sram_data_out )
  , .rclk                               ( clk )
  , .raddr                              ( data_in )
  , .re                                 ( re )
  , .rdata                              ( ram_to_ram )
  , .fuse_misc_rf_in                    ( '0 )
  , .fscan_ram_wrdis_b                  ( '1 )
  , .fscan_ram_rddis_b                  ( '1 )
  , .fscan_ram_odis_b                   ( '1 )
  , .pwr_mgmt_in                        ( '0 )
  , .pwr_mgmt_out                       (  )
);

hqm_AW_sram_4096x12 i_sr_dqed_e (
    .clk                                ( clk )
  , .re                                 ( re )
  , .we                                 ( we )
  , .addr                               ( ram_to_ram )
  , .wdata                              ( data_in )
  , .rdata                              ( sram_data_out )
  , .fuse_misc_ssa_in                   ( '0  )
  , .fscan_ram_rddis_b                  (  '1 )
  , .fscan_ram_wrdis_b                  (  '1 )
  , .fscan_ram_odis_b                   (  '1 )
  , .pwr_mgmt_in                        (  '0 )
  , .pwr_mgmt_out                       (  )
) ;

assign ft_data_out = ft_data_in;

assign rf_data_out = ram_to_ram;











// uncomment to test CAAL  
// uncomment to test CAAL  localparam NUM_RREQS = 1;
// uncomment to test CAAL  localparam NUM_WREQS = 1;
// uncomment to test CAAL  localparam NUM_REIDS = 64;
// uncomment to test CAAL  localparam NUM_WEIDS = 16;
// uncomment to test CAAL  localparam NUM_RJOBS = 64;
// uncomment to test CAAL  localparam NUM_WJOBS = 16;
// uncomment to test CAAL  localparam NUM_RIDS = 256;
// uncomment to test CAAL  localparam NUM_WIDS = 256;
// uncomment to test CAAL  localparam NUM_POOLS = 8;
// uncomment to test CAAL  localparam CMSI_ADDR_WIDTH = 36;
// uncomment to test CAAL  localparam ACEL_ADDR_WIDTH = 48;
// uncomment to test CAAL  localparam BYTES_WIDTH = 16;
// uncomment to test CAAL  localparam SN_WIDTH = 16;
// uncomment to test CAAL  localparam MIN_BLK_SIZE = 256;
// uncomment to test CAAL  localparam CL_SIZE = 64;
// uncomment to test CAAL  localparam WT_WIDTH = 1;
// uncomment to test CAAL  localparam CLA_TABLE_PRESENT = 1;
// uncomment to test CAAL  localparam MAX_CLA_TABLE_COUNT = 8;
// uncomment to test CAAL  localparam DEFAULT_POOL_PRESENT = 0;
// uncomment to test CAAL  localparam DEFAULT_QOS_CONTROL = 32'h0a0c0a0c;
// uncomment to test CAAL  localparam VAT_BASE_INIT_0 = 0;
// uncomment to test CAAL  localparam CL_WIDTH = (AW_logb2(CL_SIZE-1) + 1);
// uncomment to test CAAL  localparam RRID_WIDTH = (AW_logb2(NUM_RREQS-1) + 1);
// uncomment to test CAAL  localparam WRID_WIDTH = (AW_logb2(NUM_WREQS-1) + 1);
// uncomment to test CAAL  localparam REID_WIDTH = (AW_logb2(NUM_REIDS-1) + 1);
// uncomment to test CAAL  localparam WEID_WIDTH = (AW_logb2(NUM_WEIDS-1) + 1);
// uncomment to test CAAL  localparam RJID_WIDTH = (AW_logb2(NUM_RJOBS-1) + 1);
// uncomment to test CAAL  localparam WJID_WIDTH = (AW_logb2(NUM_WJOBS-1) + 1);
// uncomment to test CAAL  localparam RID_WIDTH = (AW_logb2(NUM_RIDS-1) + 1);
// uncomment to test CAAL  localparam WID_WIDTH = (AW_logb2(NUM_WIDS-1) + 1);
// uncomment to test CAAL  localparam POOL_WIDTH = (AW_logb2(NUM_POOLS-1) + 1);
// uncomment to test CAAL  localparam MIN_BLK_WIDTH = (AW_logb2(MIN_BLK_SIZE-1) + 1);
// uncomment to test CAAL  
// uncomment to test CAAL  logic caal_interrupt;
// uncomment to test CAAL  logic tz_enable_axprot_set_secure;
// uncomment to test CAAL  logic cfg_caal_psel;
// uncomment to test CAAL  logic cfg_caal_pwrite;
// uncomment to test CAAL  logic cfg_caal_penable;
// uncomment to test CAAL  logic [31:0] cfg_caal_paddr;
// uncomment to test CAAL  logic [31:0] cfg_caal_pwdata;
// uncomment to test CAAL  logic caal_cfg_pready;
// uncomment to test CAAL  logic caal_cfg_pslverr;
// uncomment to test CAAL  logic [31:0] caal_cfg_prdata;
// uncomment to test CAAL  logic [NUM_RREQS-1:0] crr_valid;
// uncomment to test CAAL  logic [(NUM_RREQS*REID_WIDTH)-1:0] crr_eid;
// uncomment to test CAAL  logic [(NUM_RREQS*RJID_WIDTH)-1:0] crr_jid;
// uncomment to test CAAL  logic [(NUM_RREQS*CMSI_ADDR_WIDTH)-1:0] crr_addr;
// uncomment to test CAAL  logic [(NUM_RREQS*BYTES_WIDTH)-1:0] crr_bytes;
// uncomment to test CAAL  logic [NUM_RREQS-1:0] crr_priority;
// uncomment to test CAAL  logic [NUM_RREQS-1:0] crr_wrap;
// uncomment to test CAAL  logic [(NUM_RREQS*6)-1:0] crr_ttype;
// uncomment to test CAAL  logic [(NUM_RREQS*5)-1:0] crr_pool;
// uncomment to test CAAL  logic [NUM_RREQS-1:0] crr_ready;
// uncomment to test CAAL  logic [NUM_WREQS-1:0] cwr_valid;
// uncomment to test CAAL  logic [(NUM_WREQS*WEID_WIDTH)-1:0] cwr_eid;
// uncomment to test CAAL  logic [(NUM_WREQS*WJID_WIDTH)-1:0] cwr_jid;
// uncomment to test CAAL  logic [(NUM_WREQS*CMSI_ADDR_WIDTH)-1:0] cwr_addr;
// uncomment to test CAAL  logic [(NUM_WREQS*BYTES_WIDTH)-1:0] cwr_bytes;
// uncomment to test CAAL  logic [NUM_WREQS-1:0] cwr_priority;
// uncomment to test CAAL  logic [(NUM_WREQS*5)-1:0] cwr_ttype;
// uncomment to test CAAL  logic [(NUM_WREQS*5)-1:0] cwr_pool;
// uncomment to test CAAL  logic [NUM_WREQS-1:0] cwr_ready;
// uncomment to test CAAL  logic [NUM_WREQS-1:0] cwd_valid;
// uncomment to test CAAL  logic [(NUM_WREQS*WEID_WIDTH)-1:0] cwd_eid;
// uncomment to test CAAL  logic [(NUM_WREQS*WJID_WIDTH)-1:0] cwd_jid;
// uncomment to test CAAL  logic [NUM_WREQS-1:0] cwd_soj;
// uncomment to test CAAL  logic [NUM_WREQS-1:0] cwd_eoj;
// uncomment to test CAAL  logic [(NUM_WREQS*128)-1:0] cwd_data;
// uncomment to test CAAL  logic [NUM_WREQS-1:0] cwd_ready;
// uncomment to test CAAL  logic [NUM_RREQS-1:0] crd_valid;
// uncomment to test CAAL  logic [REID_WIDTH-1:0] crd_eid;
// uncomment to test CAAL  logic [RJID_WIDTH-1:0] crd_jid;
// uncomment to test CAAL  logic [SN_WIDTH-1:0] crd_tseq;
// uncomment to test CAAL  logic [SN_WIDTH-1:0] crd_jseq;
// uncomment to test CAAL  logic [15:0] crd_ecc;
// uncomment to test CAAL  logic [127:0] crd_data;
// uncomment to test CAAL  logic crd_soj;
// uncomment to test CAAL  logic crd_eoj;
// uncomment to test CAAL  logic [3:0] crd_soff;
// uncomment to test CAAL  logic [3:0] crd_eoff;
// uncomment to test CAAL  logic [1:0] crd_resp;
// uncomment to test CAAL  logic [NUM_RREQS-1:0] crd_cc_ack;
// uncomment to test CAAL  logic [NUM_WREQS-1:0] cwa_valid;
// uncomment to test CAAL  logic [WEID_WIDTH-1:0] cwa_eid;
// uncomment to test CAAL  logic [WJID_WIDTH-1:0] cwa_jid;
// uncomment to test CAAL  logic [1:0] cwa_resp;
// uncomment to test CAAL  logic arvalid;
// uncomment to test CAAL  logic [RID_WIDTH-1:0] arid;
// uncomment to test CAAL  logic [ACEL_ADDR_WIDTH-1:0] araddr;
// uncomment to test CAAL  logic [1:0] arburst;
// uncomment to test CAAL  logic [3:0] arlen;
// uncomment to test CAAL  logic [3:0] arcache;
// uncomment to test CAAL  logic [3:0] arqos;
// uncomment to test CAAL  logic [3:0] arregion;
// uncomment to test CAAL  logic [1:0] ardomain;
// uncomment to test CAAL  logic [3:0] arsnoop;
// uncomment to test CAAL  logic [1:0] arbar;
// uncomment to test CAAL  logic [1:0] aruser;
// uncomment to test CAAL  logic [2:0] arprot;
// uncomment to test CAAL  logic arready;
// uncomment to test CAAL  logic awvalid;
// uncomment to test CAAL  logic [WID_WIDTH-1:0] awid;
// uncomment to test CAAL  logic [ACEL_ADDR_WIDTH-1:0] awaddr;
// uncomment to test CAAL  logic [1:0] awburst;
// uncomment to test CAAL  logic [3:0] awlen;
// uncomment to test CAAL  logic [3:0] awcache;
// uncomment to test CAAL  logic [3:0] awqos;
// uncomment to test CAAL  logic [3:0] awregion;
// uncomment to test CAAL  logic [1:0] awdomain;
// uncomment to test CAAL  logic [2:0] awsnoop;
// uncomment to test CAAL  logic [1:0] awbar;
// uncomment to test CAAL  logic [1:0] awuser;
// uncomment to test CAAL  logic [2:0] awprot;
// uncomment to test CAAL  logic awready;
// uncomment to test CAAL  logic wvalid;
// uncomment to test CAAL  logic [WID_WIDTH-1:0] wid;
// uncomment to test CAAL  logic [15:0] wstrb;
// uncomment to test CAAL  logic wlast;
// uncomment to test CAAL  logic [127:0] wdata;
// uncomment to test CAAL  logic [1:0] wuser;
// uncomment to test CAAL  logic wready;
// uncomment to test CAAL  logic rvalid;
// uncomment to test CAAL  logic [RID_WIDTH-1:0] rid;
// uncomment to test CAAL  logic [1:0] rresp;
// uncomment to test CAAL  logic rlast;
// uncomment to test CAAL  logic [127:0] rdata;
// uncomment to test CAAL  logic rready;
// uncomment to test CAAL  logic bvalid;
// uncomment to test CAAL  logic [WID_WIDTH-1:0] bid;
// uncomment to test CAAL  logic [1:0] bresp;
// uncomment to test CAAL  logic bready;
// uncomment to test CAAL  
// uncomment to test CAAL  hqm_AW_caal #(
// uncomment to test CAAL   .NUM_RREQS(NUM_RREQS)
// uncomment to test CAAL  ,.NUM_WREQS(NUM_WREQS)
// uncomment to test CAAL  ,.NUM_REIDS(NUM_REIDS)
// uncomment to test CAAL  ,.NUM_WEIDS(NUM_WEIDS)
// uncomment to test CAAL  ,.NUM_RJOBS(NUM_RJOBS)
// uncomment to test CAAL  ,.NUM_WJOBS(NUM_WJOBS)
// uncomment to test CAAL  ,.NUM_RIDS(NUM_RIDS)
// uncomment to test CAAL  ,.NUM_WIDS(NUM_WIDS)
// uncomment to test CAAL  ,.NUM_POOLS(NUM_POOLS)
// uncomment to test CAAL  ,.CMSI_ADDR_WIDTH(CMSI_ADDR_WIDTH)
// uncomment to test CAAL  ,.ACEL_ADDR_WIDTH(ACEL_ADDR_WIDTH)
// uncomment to test CAAL  ,.BYTES_WIDTH(BYTES_WIDTH)
// uncomment to test CAAL  ,.SN_WIDTH(SN_WIDTH)
// uncomment to test CAAL  ,.MIN_BLK_SIZE(MIN_BLK_SIZE)
// uncomment to test CAAL  ,.CL_SIZE(CL_SIZE)
// uncomment to test CAAL  ,.WT_WIDTH(WT_WIDTH)
// uncomment to test CAAL  ,.CLA_TABLE_PRESENT(CLA_TABLE_PRESENT)
// uncomment to test CAAL  ,.MAX_CLA_TABLE_COUNT(MAX_CLA_TABLE_COUNT)
// uncomment to test CAAL  ,.DEFAULT_POOL_PRESENT(DEFAULT_POOL_PRESENT)
// uncomment to test CAAL  ,.DEFAULT_QOS_CONTROL(DEFAULT_QOS_CONTROL)
// uncomment to test CAAL  ,.VAT_BASE_INIT_0(VAT_BASE_INIT_0)
// uncomment to test CAAL  ,.CL_WIDTH(CL_WIDTH)
// uncomment to test CAAL  ,.RRID_WIDTH(RRID_WIDTH)
// uncomment to test CAAL  ,.WRID_WIDTH(WRID_WIDTH)
// uncomment to test CAAL  ,.REID_WIDTH(REID_WIDTH)
// uncomment to test CAAL  ,.WEID_WIDTH(WEID_WIDTH)
// uncomment to test CAAL  ,.RJID_WIDTH(RJID_WIDTH)
// uncomment to test CAAL  ,.WJID_WIDTH(WJID_WIDTH)
// uncomment to test CAAL  ,.RID_WIDTH(RID_WIDTH)
// uncomment to test CAAL  ,.WID_WIDTH(WID_WIDTH)
// uncomment to test CAAL  ,.POOL_WIDTH(POOL_WIDTH)
// uncomment to test CAAL  ,.MIN_BLK_WIDTH(MIN_BLK_WIDTH)
// uncomment to test CAAL  ) i_hqm_AW_caal (
// uncomment to test CAAL   .clk(clk)
// uncomment to test CAAL  ,.reset_n(reset_unit_n)
// uncomment to test CAAL  ,.scan_mode(1'b0)
// uncomment to test CAAL  ,.caal_interrupt(caal_interrupt)
// uncomment to test CAAL  ,.tz_enable_axprot_set_secure(tz_enable_axprot_set_secure)
// uncomment to test CAAL  ,.clk_apb(clk)
// uncomment to test CAAL  ,.cfg_caal_psel(cfg_caal_psel)
// uncomment to test CAAL  ,.cfg_caal_pwrite(cfg_caal_pwrite)
// uncomment to test CAAL  ,.cfg_caal_penable(cfg_caal_penable)
// uncomment to test CAAL  ,.cfg_caal_paddr(cfg_caal_paddr)
// uncomment to test CAAL  ,.cfg_caal_pwdata(cfg_caal_pwdata)
// uncomment to test CAAL  ,.caal_cfg_pready(caal_cfg_pready)
// uncomment to test CAAL  ,.caal_cfg_pslverr(caal_cfg_pslverr)
// uncomment to test CAAL  ,.caal_cfg_prdata(caal_cfg_prdata)
// uncomment to test CAAL  ,.crr_valid(crr_valid)
// uncomment to test CAAL  ,.crr_eid(crr_eid)
// uncomment to test CAAL  ,.crr_jid(crr_jid)
// uncomment to test CAAL  ,.crr_addr(crr_addr)
// uncomment to test CAAL  ,.crr_bytes(crr_bytes)
// uncomment to test CAAL  ,.crr_priority(crr_priority)
// uncomment to test CAAL  ,.crr_wrap(crr_wrap)
// uncomment to test CAAL  ,.crr_ttype(crr_ttype)
// uncomment to test CAAL  ,.crr_pool(crr_pool)
// uncomment to test CAAL  ,.crr_ready(crr_ready)
// uncomment to test CAAL  ,.cwr_valid(cwr_valid)
// uncomment to test CAAL  ,.cwr_eid(cwr_eid)
// uncomment to test CAAL  ,.cwr_jid(cwr_jid)
// uncomment to test CAAL  ,.cwr_addr(cwr_addr)
// uncomment to test CAAL  ,.cwr_bytes(cwr_bytes)
// uncomment to test CAAL  ,.cwr_priority(cwr_priority)
// uncomment to test CAAL  ,.cwr_ttype(cwr_ttype)
// uncomment to test CAAL  ,.cwr_pool(cwr_pool)
// uncomment to test CAAL  ,.cwr_ready(cwr_ready)
// uncomment to test CAAL  ,.cwd_valid(cwd_valid)
// uncomment to test CAAL  ,.cwd_eid(cwd_eid)
// uncomment to test CAAL  ,.cwd_jid(cwd_jid)
// uncomment to test CAAL  ,.cwd_soj(cwd_soj)
// uncomment to test CAAL  ,.cwd_eoj(cwd_eoj)
// uncomment to test CAAL  ,.cwd_data(cwd_data)
// uncomment to test CAAL  ,.cwd_ready(cwd_ready)
// uncomment to test CAAL  ,.crd_valid(crd_valid)
// uncomment to test CAAL  ,.crd_eid(crd_eid)
// uncomment to test CAAL  ,.crd_jid(crd_jid)
// uncomment to test CAAL  ,.crd_tseq(crd_tseq)
// uncomment to test CAAL  ,.crd_jseq(crd_jseq)
// uncomment to test CAAL  ,.crd_ecc(crd_ecc)
// uncomment to test CAAL  ,.crd_data(crd_data)
// uncomment to test CAAL  ,.crd_soj(crd_soj)
// uncomment to test CAAL  ,.crd_eoj(crd_eoj)
// uncomment to test CAAL  ,.crd_soff(crd_soff)
// uncomment to test CAAL  ,.crd_eoff(crd_eoff)
// uncomment to test CAAL  ,.crd_resp(crd_resp)
// uncomment to test CAAL  ,.crd_cc_ack(crd_cc_ack)
// uncomment to test CAAL  ,.cwa_valid(cwa_valid)
// uncomment to test CAAL  ,.cwa_eid(cwa_eid)
// uncomment to test CAAL  ,.cwa_jid(cwa_jid)
// uncomment to test CAAL  ,.cwa_resp(cwa_resp)
// uncomment to test CAAL  ,.arvalid(arvalid)
// uncomment to test CAAL  ,.arid(arid)
// uncomment to test CAAL  ,.araddr(araddr)
// uncomment to test CAAL  ,.arburst(arburst)
// uncomment to test CAAL  ,.arlen(arlen)
// uncomment to test CAAL  ,.arcache(arcache)
// uncomment to test CAAL  ,.arqos(arqos)
// uncomment to test CAAL  ,.arregion(arregion)
// uncomment to test CAAL  ,.ardomain(ardomain)
// uncomment to test CAAL  ,.arsnoop(arsnoop)
// uncomment to test CAAL  ,.arbar(arbar)
// uncomment to test CAAL  ,.aruser(aruser)
// uncomment to test CAAL  ,.arprot(arprot)
// uncomment to test CAAL  ,.arready(arready)
// uncomment to test CAAL  ,.awvalid(awvalid)
// uncomment to test CAAL  ,.awid(awid)
// uncomment to test CAAL  ,.awaddr(awaddr)
// uncomment to test CAAL  ,.awburst(awburst)
// uncomment to test CAAL  ,.awlen(awlen)
// uncomment to test CAAL  ,.awcache(awcache)
// uncomment to test CAAL  ,.awqos(awqos)
// uncomment to test CAAL  ,.awregion(awregion)
// uncomment to test CAAL  ,.awdomain(awdomain)
// uncomment to test CAAL  ,.awsnoop(awsnoop)
// uncomment to test CAAL  ,.awbar(awbar)
// uncomment to test CAAL  ,.awuser(awuser)
// uncomment to test CAAL  ,.awprot(awprot)
// uncomment to test CAAL  ,.awready(awready)
// uncomment to test CAAL  ,.wvalid(wvalid)
// uncomment to test CAAL  ,.wid(wid)
// uncomment to test CAAL  ,.wstrb(wstrb)
// uncomment to test CAAL  ,.wlast(wlast)
// uncomment to test CAAL  ,.wdata(wdata)
// uncomment to test CAAL  ,.wuser(wuser)
// uncomment to test CAAL  ,.wready(wready)
// uncomment to test CAAL  ,.rvalid(rvalid)
// uncomment to test CAAL  ,.rid(rid)
// uncomment to test CAAL  ,.rresp(rresp)
// uncomment to test CAAL  ,.rlast(rlast)
// uncomment to test CAAL  ,.rdata(rdata)
// uncomment to test CAAL  ,.rready(rready)
// uncomment to test CAAL  ,.bvalid(bvalid)
// uncomment to test CAAL  ,.bid(bid)
// uncomment to test CAAL  ,.bresp(bresp)
// uncomment to test CAAL  ,.bready(bready)
// uncomment to test CAAL  );
// uncomment to test CAAL  
// uncomment to test CAAL  assign tz_enable_axprot_set_secure = '0;
// uncomment to test CAAL  
// uncomment to test CAAL  assign cfg_caal_psel = re ;
// uncomment to test CAAL  assign cfg_caal_pwrite = re ;
// uncomment to test CAAL  assign cfg_caal_penable = re ;
// uncomment to test CAAL  assign cfg_caal_paddr = {32{re}};
// uncomment to test CAAL  assign cfg_caal_pwdata = {32{re}};
// uncomment to test CAAL  
// uncomment to test CAAL  assign crr_valid = {NUM_RREQS{re}};
// uncomment to test CAAL  assign crr_eid = {(NUM_RREQS*REID_WIDTH){re}};
// uncomment to test CAAL  assign crr_jid = {(NUM_RREQS*RJID_WIDTH){re}};
// uncomment to test CAAL  assign crr_addr = {(NUM_RREQS*CMSI_ADDR_WIDTH){re}};
// uncomment to test CAAL  assign crr_bytes = {(NUM_RREQS*BYTES_WIDTH){re}};
// uncomment to test CAAL  assign crr_priority = {NUM_RREQS{re}};
// uncomment to test CAAL  assign crr_wrap = {NUM_RREQS{re}};
// uncomment to test CAAL  assign crr_ttype = {(NUM_RREQS*6){re}};
// uncomment to test CAAL  assign crr_pool = {(NUM_RREQS*5){re}};
// uncomment to test CAAL  
// uncomment to test CAAL  assign arready = re ;
// uncomment to test CAAL  
// uncomment to test CAAL  assign cwr_valid = {NUM_WREQS{re}};
// uncomment to test CAAL  assign cwr_eid = {(NUM_WREQS*WEID_WIDTH){re}};
// uncomment to test CAAL  assign cwr_jid = {(NUM_WREQS*WJID_WIDTH){re}};
// uncomment to test CAAL  assign cwr_addr = {(NUM_WREQS*CMSI_ADDR_WIDTH){re}};
// uncomment to test CAAL  assign cwr_bytes = {(NUM_WREQS*BYTES_WIDTH){re}};
// uncomment to test CAAL  assign cwr_priority = {NUM_WREQS{re}};
// uncomment to test CAAL  assign cwr_ttype = {(NUM_WREQS*5){re}};
// uncomment to test CAAL  assign cwr_pool = {(NUM_WREQS*5){re}};
// uncomment to test CAAL  assign cwd_valid = {NUM_WREQS{re}};
// uncomment to test CAAL  assign cwd_eid = {(NUM_WREQS*WEID_WIDTH){re}};
// uncomment to test CAAL  assign cwd_jid = {(NUM_WREQS*WJID_WIDTH){re}};
// uncomment to test CAAL  assign cwd_soj = {NUM_WREQS{re}};
// uncomment to test CAAL  assign cwd_eoj = {NUM_WREQS{re}};
// uncomment to test CAAL  assign cwd_data = {(NUM_WREQS*128){re}};
// uncomment to test CAAL  
// uncomment to test CAAL  assign awready = re ;
// uncomment to test CAAL  assign wready = re ;
// uncomment to test CAAL  
// uncomment to test CAAL  assign rvalid = re ;
// uncomment to test CAAL  assign rid = {RID_WIDTH{re}};
// uncomment to test CAAL  assign rresp = {2{re}};
// uncomment to test CAAL  assign rlast = re;
// uncomment to test CAAL  assign rdata = {128{re}};
// uncomment to test CAAL  
// uncomment to test CAAL  assign bvalid = re ;
// uncomment to test CAAL  assign bid = {WID_WIDTH{re}};
// uncomment to test CAAL  assign bresp = {2{re}};
// uncomment to test CAAL  
// uncomment to test CAAL 
// uncomment to test CAAL assign ft_data_out = (crr_ready)
// uncomment to test CAAL | (cwr_ready)
// uncomment to test CAAL | (cwd_ready)
// uncomment to test CAAL | (|crd_valid)
// uncomment to test CAAL | (|crd_eid)
// uncomment to test CAAL | (|crd_jid)
// uncomment to test CAAL | (|crd_tseq)
// uncomment to test CAAL | (|crd_jseq)
// uncomment to test CAAL | (|crd_ecc)
// uncomment to test CAAL | (|crd_data)
// uncomment to test CAAL | (crd_soj)
// uncomment to test CAAL | (crd_eoj)
// uncomment to test CAAL | (|crd_soff)
// uncomment to test CAAL | (|crd_eoff)
// uncomment to test CAAL | (|crd_resp)
// uncomment to test CAAL | (|crd_cc_ack)
// uncomment to test CAAL | (|cwa_valid)
// uncomment to test CAAL | (|cwa_eid)
// uncomment to test CAAL | (|cwa_jid)
// uncomment to test CAAL | (|cwa_resp)
// uncomment to test CAAL | (arvalid)
// uncomment to test CAAL | (|arid)
// uncomment to test CAAL | (|araddr)
// uncomment to test CAAL | (|arburst)
// uncomment to test CAAL | (|arlen)
// uncomment to test CAAL | (|arcache)
// uncomment to test CAAL | (|arqos)
// uncomment to test CAAL | (|arregion)
// uncomment to test CAAL | (|ardomain)
// uncomment to test CAAL | (|arsnoop)
// uncomment to test CAAL | (|arbar)
// uncomment to test CAAL | (|aruser)
// uncomment to test CAAL | (|arprot)
// uncomment to test CAAL | (awvalid)
// uncomment to test CAAL | (|awid)
// uncomment to test CAAL | (|awaddr)
// uncomment to test CAAL | (|awburst)
// uncomment to test CAAL | (|awlen)
// uncomment to test CAAL | (|awcache)
// uncomment to test CAAL | (|awqos)
// uncomment to test CAAL | (|awregion)
// uncomment to test CAAL | (|awdomain)
// uncomment to test CAAL | (|awsnoop)
// uncomment to test CAAL | (|awbar)
// uncomment to test CAAL | (|awuser)
// uncomment to test CAAL | (|awprot)
// uncomment to test CAAL | (wvalid)
// uncomment to test CAAL | (|wid)
// uncomment to test CAAL | (|wstrb)
// uncomment to test CAAL | (wlast)
// uncomment to test CAAL | (|wdata)
// uncomment to test CAAL | (|wuser)
// uncomment to test CAAL | (rready)
// uncomment to test CAAL | (bready) ;



endmodule
