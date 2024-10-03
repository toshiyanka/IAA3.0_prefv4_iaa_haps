
`ifdef INTEL_INST_ON

module hqm_sif_inst

  import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_system_type_pkg::*, hqm_sif_pkg::*;

();

  logic               hqmi_debug;
  logic [127:0][71:0] pci_cmd;
  logic [7:0][63:0]   tlq_pcmd;
  logic [7:0][63:0]   tlq_npcmd;
  logic               drop_cnt_check;
  logic               credit_cnt_check;

  //--------------------------------------------------------------------------------------------------------

  initial begin
   $display("@%0tps [HQMI_DEBUG] hqm_sif initial block ...",$time);
   hqmi_debug='0; if ($test$plusargs("HQMI_DEBUG")) hqmi_debug='1;
   $display("@%0tps [HQMI_DEBUG] hqmi_debug=%x",$time, hqmi_debug);
   drop_cnt_check=1;   if ($test$plusargs("HQM_IOSF_NO_DROP_CNT_CHECK")) drop_cnt_check=0;
   credit_cnt_check=1; if ($test$plusargs("HQM_IOSF_NO_CREDIT_CNT_CHECK")) credit_cnt_check=0;
   for (int i=0; i<128; i++) pci_cmd[i] = "(XXXXXXX)";
   pci_cmd[7'b00_00000] = "(MRD32  )";
   pci_cmd[7'b01_00000] = "(MRD64  )";
   pci_cmd[7'b00_00111] = "(LTMRD32)";
   pci_cmd[7'b01_00111] = "(LTMRD64)";
   pci_cmd[7'b00_00001] = "(MRDLK32)";
   pci_cmd[7'b01_00001] = "(MRDLK64)";
   pci_cmd[7'b10_00000] = "(MWR32  )";
   pci_cmd[7'b11_00000] = "(MWR64  )";
   pci_cmd[7'b10_00111] = "(LTMWR32)";
   pci_cmd[7'b11_00111] = "(LTMWR64)";
   pci_cmd[7'b10_11011] = "(NPMWR32)";
   pci_cmd[7'b11_11011] = "(NPMWR64)";
   pci_cmd[7'b00_00010] = "(IORD   )";
   pci_cmd[7'b10_00010] = "(IOWR   )";
   pci_cmd[7'b00_00100] = "(CFGRD0 )";
   pci_cmd[7'b10_00100] = "(CFGWR0 )";
   pci_cmd[7'b00_00101] = "(CFGRD1 )";
   pci_cmd[7'b10_00101] = "(CFGWR1 )";
   pci_cmd[7'b00_01010] = "(CPL    )";
   pci_cmd[7'b10_01010] = "(CPLD   )";
   pci_cmd[7'b00_01011] = "(CPLLK  )";
   pci_cmd[7'b10_01011] = "(CPLDLK )";
   pci_cmd[7'b10_01100] = "(FADD32 )";
   pci_cmd[7'b11_01100] = "(FADD64 )";
   pci_cmd[7'b10_01101] = "(SWAP32 )";
   pci_cmd[7'b11_01101] = "(SWAP64 )";
   pci_cmd[7'b10_01110] = "(CAS32  )";
   pci_cmd[7'b11_01110] = "(CAS64  )";
   pci_cmd[7'b01_10000] = "(MSG0   )";
   pci_cmd[7'b01_10001] = "(MSG1   )";
   pci_cmd[7'b01_10010] = "(MSG2   )";
   pci_cmd[7'b01_10011] = "(MSG3   )";
   pci_cmd[7'b01_10100] = "(MSG4   )";
   pci_cmd[7'b01_10101] = "(MSG5   )";
   pci_cmd[7'b01_10110] = "(MSG6   )";
   pci_cmd[7'b01_10111] = "(MSG7   )";
   pci_cmd[7'b11_10000] = "(MSGD0  )";
   pci_cmd[7'b11_10001] = "(MSGD1  )";
   pci_cmd[7'b11_10010] = "(MSGD2  )";
   pci_cmd[7'b11_10011] = "(MSGD3  )";
   pci_cmd[7'b11_10100] = "(MSGD4  )";
   pci_cmd[7'b11_10101] = "(MSGD5  )";
   pci_cmd[7'b11_10110] = "(MSGD6  )";
   pci_cmd[7'b11_10111] = "(MSGD7  )";
   for (int i=0; i<8; i++) begin
    tlq_pcmd[i]  = "(XXXXXX)";
    tlq_npcmd[i] = "(XXXXXX)";
   end
   tlq_pcmd[0]  = "(MEM_WR)";
   tlq_pcmd[3]  = "(USR_D )";
   tlq_pcmd[4]  = "(USR_ND)";
   tlq_npcmd[0] = "(MEM_RD)";
   tlq_npcmd[1] = "(CFG_RD)";
   tlq_npcmd[2] = "(CFG_WR)";
   tlq_npcmd[5] = "(USR_D )";
   tlq_npcmd[6] = "(USR_ND)";
   tlq_npcmd[7] = "(MEM_WR)";
  end // begin

  //--------------------------------------------------------------------------------------------------------

  final begin

   $display("@%0tps [HQMI_INFO] hqm_sif final block ...",$time);

   $display("@%0tps [HQMI_INFO] --------------------------------------------------------------------------------------",$time);
   $display("@%0tps [HQMI_INFO] HW COUNTER[ 1, 0] RI TLQ posted header count         : 0x%08x_%08x",
        $time, hqm_sif_core.i_hqm_ri.hqm_sif_cnt[ 1], hqm_sif_core.i_hqm_ri.hqm_sif_cnt[ 0]);
   $display("@%0tps [HQMI_INFO] HW COUNTER[ 3, 2] RI TLQ posted data word count      : 0x%08x_%08x\n",
        $time, hqm_sif_core.i_hqm_ri.hqm_sif_cnt[ 3], hqm_sif_core.i_hqm_ri.hqm_sif_cnt[ 2]);
   $display("@%0tps [HQMI_INFO] HW COUNTER[ 5, 4] RI TLQ non-posted header count     : 0x%08x_%08x",
        $time, hqm_sif_core.i_hqm_ri.hqm_sif_cnt[ 5], hqm_sif_core.i_hqm_ri.hqm_sif_cnt[ 4]);
   $display("@%0tps [HQMI_INFO] HW COUNTER[ 7, 6] RI TLQ non-posted data word count  : 0x%08x_%08x\n",
        $time, hqm_sif_core.i_hqm_ri.hqm_sif_cnt[ 7], hqm_sif_core.i_hqm_ri.hqm_sif_cnt[ 6]);
   $display("@%0tps [HQMI_INFO] HW COUNTER[ 9, 8] RI TLQ unexpected completion count : 0x%08x_%08x",
        $time, hqm_sif_core.i_hqm_ri.hqm_sif_cnt[ 9], hqm_sif_core.i_hqm_ri.hqm_sif_cnt[ 8]);
   $display("@%0tps [HQMI_INFO] HW COUNTER[11,10] MSTR MSI-X drops (MSIXE=0)         : 0x%08x_%08x",
        $time, hqm_sif_core.i_hqm_ri.hqm_sif_cnt[11], hqm_sif_core.i_hqm_ri.hqm_sif_cnt[10]);

  end // final

  //--------------------------------------------------------------------------------------------------------

  always_ff @(posedge hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.prim_gated_clk) begin
   if (hqmi_debug & (hqm_sif_core.prim_rst_b === 1'b1)) begin

    if (hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_req.valid &
     ~|{hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.psel_q,
        hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.cfg_rvalid_q,
        hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.cfg_wvalid_q})
     $display("%0tps: [HQMI_DEBUG] CFGM CFG Req:   op=%x a=%x d=%x be=%x sai=%x fid=%x bar=%x"
        ,$time
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_req.opcode
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_req.addr
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_req.data
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_req.be
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_req.sai
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_req.fid
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_req.bar
     );
    if (hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.psel &
       ~hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.penable &
        hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.pwrite)
     $display("%0tps: [HQMI_DEBUG] CFGM APB Write Req:  a=%x d=%x"
        ,$time
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.paddr
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.pwdata
     );
    if (hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.psel &
       ~hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.penable &
        ~hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.pwrite)
     $display("%0tps: [HQMI_DEBUG] CFGM APB Read  Req:  a=%x"
        ,$time
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.paddr
     );
    if (hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.psel &
        hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.penable &
        hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.pwrite &
        hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.pready)
     $display("%0tps: [HQMI_DEBUG] CFGM APB Write Resp: a=%x e=%x"
        ,$time
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.paddr
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.pslverr
     );
    if (hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.psel &
        hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.penable &
       ~hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.pwrite &
        hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.pready)
     $display("%0tps: [HQMI_DEBUG] CFGM APB Read  Resp: a=%x d=%x e=%x"
        ,$time
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.paddr
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.prdata
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.pslverr
     );
    if (hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_ack.read_valid)
     $display("%0tps: [HQMI_DEBUG] CFGM CFG Read  Ack:  a=%x d=%x miss=%x sai_succ=%x"
        ,$time
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_req.addr
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_ack.data
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_ack.read_miss
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_ack.sai_successfull
     );
    if (hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_ack.write_valid)
     $display("%0tps: [HQMI_DEBUG] CFGM CFG Write Ack:  a=%x            miss=%x sai_succ=%x"
        ,$time
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_req.addr
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_ack.write_miss
        ,hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.hqm_csr_ext_mmio_ack.sai_successfull
     );

   end // debug

  end // cfg_master.clk

 //--------------------------------------------------------------------------------------------------------
 // AER stuff

 logic                      cpl_unexpected_q;
 logic                      updated_err_hdr_q;

 always_ff @(posedge hqm_sif_core.prim_freerun_clk) begin
  if (hqmi_debug) begin

   cpl_unexpected_q <= hqm_sif_core.i_hqm_ri.i_ri_err.cpl_unexpected;

   updated_err_hdr_q <= hqm_sif_core.i_hqm_ri.i_ri_err.update_hdr_log_hdr &
                                ~(|hqm_sif_core.i_hqm_ri.i_ri_err.hdr_log_vec);

  end

  if (hqmi_debug & (hqm_sif_core.prim_rst_b === 1'b1)) begin
   
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_pcie_cap_device_status_nc.URD)) $display("%t: [HQMI_DEBUG]: AER PF  Device Status URD set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_pcie_cap_device_status_nc.URD)) $display("%t: [HQMI_DEBUG]: AER PF  Device Status URD cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_pcie_cap_device_status_nc.FED)) $display("%t: [HQMI_DEBUG]: AER PF  Device Status FED set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_pcie_cap_device_status_nc.FED)) $display("%t: [HQMI_DEBUG]: AER PF  Device Status FED cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_pcie_cap_device_status_nc.NED)) $display("%t: [HQMI_DEBUG]: AER PF  Device Status NED set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_pcie_cap_device_status_nc.NED)) $display("%t: [HQMI_DEBUG]: AER PF  Device Status NED cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_pcie_cap_device_status_nc.CED)) $display("%t: [HQMI_DEBUG]: AER PF  Device Status CED set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_pcie_cap_device_status_nc.CED)) $display("%t: [HQMI_DEBUG]: AER PF  Device Status CED cleared.", $time);
   
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.device_command.SER)) $display("%t: [HQMI_DEBUG]: AER Device Command SER   enabled.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.device_command.SER)) $display("%t: [HQMI_DEBUG]: AER Device Command SER  disabled.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.device_command.PER)) $display("%t: [HQMI_DEBUG]: AER Device Command PER   enabled.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.device_command.PER)) $display("%t: [HQMI_DEBUG]: AER Device Command PER  disabled.", $time);
   
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.ERO )) $display("%t: [HQMI_DEBUG]: AER Device Control ERO  set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.ERO )) $display("%t: [HQMI_DEBUG]: AER Device Control ERO  cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.URRO)) $display("%t: [HQMI_DEBUG]: AER Device Control URRO set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.URRO)) $display("%t: [HQMI_DEBUG]: AER Device Control URRO cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.FERE)) $display("%t: [HQMI_DEBUG]: AER Device Control FERE set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.FERE)) $display("%t: [HQMI_DEBUG]: AER Device Control FERE cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.NERE)) $display("%t: [HQMI_DEBUG]: AER Device Control NERE set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.NERE)) $display("%t: [HQMI_DEBUG]: AER Device Control NERE cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.CERE)) $display("%t: [HQMI_DEBUG]: AER Device Control CERE set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.CERE)) $display("%t: [HQMI_DEBUG]: AER Device Control CERE cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.ENS )) $display("%t: [HQMI_DEBUG]: AER Device Control ENS  set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.ENS )) $display("%t: [HQMI_DEBUG]: AER Device Control ENS  cleared.", $time);
   
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.IEUNC)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     IEUNC    asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.IEUNC)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     IEUNC  deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.UR   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     UR       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.UR   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     UR     deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.ECRCC)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     ECRCC    asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.ECRCC)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     ECRCC  deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.MTLP )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     MTLP     asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.MTLP )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     MTLP   deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.RO   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     RO       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.RO   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     RO     deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.EC   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     EC       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.EC   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     EC     deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.CA   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     CA       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.CA   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     CA     deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.CT   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     CT       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.CT   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     CT     deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.FCPES)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     FCPES    asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.FCPES)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     FCPES  deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.PTLPR)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     PTLPR    asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.PTLPR)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     PTLPR  deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.DLPE )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     DLPE     asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.DLPE )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Mask     DLPE   deasserted.", $time);
   
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.IEUNC)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity IEUNC    asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.IEUNC)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity IEUNC  deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.UR   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity UR       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.UR   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity UR     deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.ECRCC)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity ECRCC    asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.ECRCC)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity ECRCC  deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.MTLP )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity MTLP     asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.MTLP )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity MTLP   deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.RO   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity RO       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.RO   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity RO     deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.EC   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity EC       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.EC   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity EC     deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.CA   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity CA       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.CA   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity CA     deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.CT   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity CT       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.CT   )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity CT     deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.FCPES)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity FCPES    asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.FCPES)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity FCPES  deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.PTLPR)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity PTLPR    asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.PTLPR)) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity PTLPR  deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.DLPE )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity DLPE     asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.DLPE )) $display("%t: [HQMI_DEBUG]: AER     Uncorrectable Err Severity DLPE   deasserted.", $time);
   
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.ANFES))  $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     ANFES    asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.ANFES))  $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     ANFES  deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.RTTS ))  $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     RTTS     asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.RTTS ))  $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     RTTS   deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.RNRS ))  $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     RNRS     asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.RNRS ))  $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     RNRS   deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.BDLLPS)) $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     BDLLPS   asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.BDLLPS)) $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     BDLLPS deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.DLPE  )) $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     DLPE     asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.DLPE  )) $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     DLPE   deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.RES   )) $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     RES      asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.RES   )) $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     RES    deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.IECOR )) $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     IECOR    asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.IECOR )) $display("%t: [HQMI_DEBUG]: AER       Correctable Err Mask     IECOR  deasserted.", $time);
   
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.IEUNC)) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   IEUNC  set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.IEUNC)) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   IEUNC  cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.UR   )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   UR     set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.UR   )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   UR     cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.ECRCC)) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   ECRCC  set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.ECRCC)) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   ECRCC  cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.MTLP )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   MTLP   set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.MTLP )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   MTLP   cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.RO   )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   RO     set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.RO   )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   RO     cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.EC   )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   EC     set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.EC   )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   EC     cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.CA   )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   CA     set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.CA   )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   CA     cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.CT   )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   CT     set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.CT   )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   CT     cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.FCPES)) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   FCPES  set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.FCPES)) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   FCPES  cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.PTLPR)) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   PTLPR  set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.PTLPR)) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   PTLPR  cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.DLPE )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   DLPE   set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_status.DLPE )) $display("%t: [HQMI_DEBUG]: AER PF  Uncorrectable Err Status   DLPE   cleared.", $time);
   
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.ANFES )) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   ANFES  set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.ANFES )) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   ANFES  cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.RTTS  )) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   RTTS   set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.RTTS  )) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   RTTS   cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.RNRS  )) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   RNRS   set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.RNRS  )) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   RNRS   cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.BDLLPS)) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   BDLLPS set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.BDLLPS)) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   BDLLPS cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.DLPE  )) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   DLPE   set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.DLPE  )) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   DLPE   cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.RES   )) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   RES    set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.RES   )) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   RES    cleared.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.IECOR )) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   IECOR  set.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pf_aer_cap_corr_err_status_nc.IECOR )) $display("%t: [HQMI_DEBUG]: AER PF    Correctable Err Status   IECOR  cleared.", $time);
   
   if ( hqm_sif_core.i_hqm_ri.i_ri_err.cpl_unexpected & ~cpl_unexpected_q) $display("%t: [HQMI_DEBUG]: AER PF  unexpected completion err asserted.", $time);
   if (~hqm_sif_core.i_hqm_ri.i_ri_err.cpl_unexpected &  cpl_unexpected_q) $display("%t: [HQMI_DEBUG]: AER PF  unexpected completion err deasserted.", $time);
   
   if (updated_err_hdr_q) begin
    $display("%t: [HQMI_DEBUG]: AER PF  err hdr log0 updated to 0x%08x.", $time, hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0);
    $display("%t: [HQMI_DEBUG]: AER PF  err hdr log1 updated to 0x%08x.", $time, hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log1);
    $display("%t: [HQMI_DEBUG]: AER PF  err hdr log2 updated to 0x%08x.", $time, hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log2);
    $display("%t: [HQMI_DEBUG]: AER PF  err hdr log3 updated to 0x%08x.", $time, hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log3);
    if (hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[5]) begin // 4DW
        $display("%t: [HQMI_DEBUG]: AER PF  err hdr: fmt=%x type=0x%x %s tag=0x%x len=0x%x reqid=0x%x ebe=0x%x sbe=0x%x tc=%x poison=%x a=0x%x_%x"
        ,$time
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[6-:2]
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[4-:5]
        ,string'(pci_cmd[hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[6-:7]])
        ,{hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[15-:1]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[11-:1]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log1[23-:8]}
        ,{hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[17-:2]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[31-:8]}
        ,{hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log1[7-:8]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log1[15-:8]}
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log1[31-:4]
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log1[27-:4]
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[14-:1]
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[22-:1]
        ,{hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log2[7-:8]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log2[15-:8]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log2[23-:8]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log2[31-:8]}
        ,{hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log3[7-:8]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log3[15-:8]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log3[23-:8]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log3[31-:8]}
        );
    end else begin // 3DW
        $display("%t: [HQMI_DEBUG]: AER PF  err hdr: fmt=%x type=0x%x %s tag=0x%x len=0x%x reqid=0x%x ebe=0x%x sbe=0x%x tc=%x poison=%x a=0x%x"
        ,$time
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[6-:2]
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[4-:5]
        ,string'(pci_cmd[hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[6-:7]])
        ,{hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[15-:1]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[11-:1]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log1[23-:8]}
        ,{hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[17-:2]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[31-:8]}
        ,{hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log1[7-:8]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log1[15-:8]}
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log1[31-:4]
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log1[27-:4]
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[14-:1]
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log0[22-:1]
        ,{hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log2[7-:8]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log2[15-:8]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log2[23-:8]
         ,hqm_sif_core.i_hqm_ri.i_ri_err.err_hdr_log2[31-:8]}
        );
    end
   end

   if (hqm_sif_core.i_hqm_ri.i_ri_cds.cds_take_decode) begin
    $display("%t: [HQMI_DEBUG]: CBD transaction: sb=%1x ep=%1x p=%1x cmd=%1x%s len=0x%03x sbe=0x%1x ebe=0x%1x tag=0x%03x reqid=0x%04x addr=0x%x sai=0x%02x fmt=%1x type=0x%02x%s pasidtlp=0x%06x", $time
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.iosfsb
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.poison
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.posted
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.cmd
        ,((hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.posted) ?
            tlq_pcmd[ hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.cmd] :
            tlq_npcmd[hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.cmd])
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.length
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.startbe
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.endbe
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.tag
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.reqid
        ,{hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.addr[63:1], 1'b0}
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.sai
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.fmt
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.ttype
        ,string'(pci_cmd[{hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.fmt
                         ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.ttype}])
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.pasidtlp
    );
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_hdr.fmt[1]) 
     $display("%t: [HQMI_DEBUG]: CBD transaction: data=0x%08x_%08x_%08x_%08x_%08x_%08x_%08x_%08x_%08x_%08x_%08x_%08x_%08x_%08x_%08x_%08x", $time
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data2[255:224]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data2[223:192]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data2[191:160]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data2[159:128]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data2[127: 96]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data2[ 95: 64]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data2[ 63: 32]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data2[ 31:  0]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data[255:224]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data[223:192]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data[191:160]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data[159:128]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data[127: 96]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data[ 95: 64]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data[ 63: 32]
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_wr_data[ 31:  0]
     );
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_bar_miss_err_wp |
        hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_multi_bar_hit_err_wp |
        hqm_sif_core.i_hqm_ri.i_ri_cds.mem_bad_region |
        hqm_sif_core.i_hqm_ri.i_ri_cds.mem_bad_addr)
     $display("%t: [HQMI_DEBUG]: AER state: CSR_PF_BAR=0x%08x_xxxxxxxx FUNC_PF_BAR=0x%08x_%02xxxxxxx", $time
        ,hqm_sif_core.i_hqm_ri.csr_pf_bar[ 63:32]
        ,hqm_sif_core.i_hqm_ri.func_pf_bar[63:32], {hqm_sif_core.i_hqm_ri.func_pf_bar[31:26], 2'd0}
     );
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.cds_err_next) begin
     $display("%t: [HQMI_DEBUG]: AER state: D3=%1x BM=%1x MSE=%1x MPS=%1x FIR=%1x QUIESCE=%1x SCIOV_ENB=%1x", $time
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.ri_pf_disabled_wxp
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.device_command.BM
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.csr_pcicmd_mem
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.ri_mps_rxp
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.func_in_rst
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sif_mstr_quiesce_req
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.csr_pasid_enable
     );
     $display("%t: [HQMI_DEBUG]: AER state: PF:  UC_SEV(UR=%1x EC=%1x PTLP=%1x MTLP=%1x)", $time
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.UR
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.EC
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.PTLPR
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_sev.MTLP
     );
     $display("%t: [HQMI_DEBUG]: AER state: PF:  UC_MSK(UR=%1x EC=%1x PTLP=%1x MTLP=%1x)    C_MSK(ANFES=%1x)", $time
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.UR
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.EC
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.PTLPR
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_uncorr_err_mask.MTLP
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.aer_cap_corr_err_mask.ANFES
     );
     $display("%t: [HQMI_DEBUG]: AER state: PF:  URRE=%1x FERE=%1x NERE=%1x CERE=%1x SERR=%1x", $time
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.URRO
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.FERE
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.NERE
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.pcie_cap_device_control.CERE
        ,hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.device_command.SER
     );
    end

    if (hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_drop_flr_p)           $display("%t: [HQMI_DEBUG]: AER CDS P DROP FLR is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_drop_flr_np)          $display("%t: [HQMI_DEBUG]: AER CDS NP DROP FLR is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_uns_pcmd)             $display("%t: [HQMI_DEBUG]: AER CDS P  UNS command err is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_uns_npcmd)            $display("%t: [HQMI_DEBUG]: AER CDS NP UNS command err is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.mem_mps_err)              $display("%t: [HQMI_DEBUG]: AER CDS MEM MPS err is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_bar_miss_err_wp)      $display("%t: [HQMI_DEBUG]: AER CDS MEM bar miss err is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_multi_bar_hit_err_wp) $display("%t: [HQMI_DEBUG]: AER CDS MEM multi-bar hit err is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.mem_bad_addr)             $display("%t: [HQMI_DEBUG]: AER CDS MEM bad address err is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.mem_bad_len_be)           $display("%t: [HQMI_DEBUG]: AER CDS MEM bad length/be err is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.mem_bad_region)           $display("%t: [HQMI_DEBUG]: AER CDS MEM region decode err is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.mem_in_d3)                $display("%t: [HQMI_DEBUG]: AER CDS MEM in D3 err is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.mem_prim_quiesce)         $display("%t: [HQMI_DEBUG]: AER CDS MEM prim_quiesce is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_poisoned_p)           $display("%t: [HQMI_DEBUG]: AER CDS P  poisoned packet is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_poisoned_np)          $display("%t: [HQMI_DEBUG]: AER CDS NP poisoned packet is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_cfg_usr_func)         $display("%t: [HQMI_DEBUG]: AER CDS CFG USR function is set.", $time);
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_cfg_prim_quiesce)     $display("%t: [HQMI_DEBUG]: AER CDS CFG prim_quiesce is set.", $time);

   end // take_decode

   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_err.cds_npusr_err_wp))      $display("%t: [HQMI_DEBUG]: AER ERR NP USR err asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_err.cds_npusr_err_wp))      $display("%t: [HQMI_DEBUG]: AER ERR NP USR err deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_err.cds_pusr_err_wp))       $display("%t: [HQMI_DEBUG]: AER ERR P  USR err asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_err.cds_pusr_err_wp))       $display("%t: [HQMI_DEBUG]: AER ERR P  USR err deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_err.cds_usr_in_cpl))        $display("%t: [HQMI_DEBUG]: AER ERR USR in completion asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_err.cds_usr_in_cpl))        $display("%t: [HQMI_DEBUG]: AER ERR USR in completion deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_err.cds_cfg_usr_func))      $display("%t: [HQMI_DEBUG]: AER ERR USR cfg function err asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_err.cds_cfg_usr_func))      $display("%t: [HQMI_DEBUG]: AER ERR USR cfg function err deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_err.cds_bar_decode_err_wp)) $display("%t: [HQMI_DEBUG]: AER ERR bar decode err asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_err.cds_bar_decode_err_wp)) $display("%t: [HQMI_DEBUG]: AER ERR bar decode err deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_err.cds_poison_err_wp))     $display("%t: [HQMI_DEBUG]: AER ERR cfg poisoned err asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_err.cds_poison_err_wp))     $display("%t: [HQMI_DEBUG]: AER ERR cfg poisoned err deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_err.cds_malform_pkt))       $display("%t: [HQMI_DEBUG]: AER ERR malformed packet err asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_err.cds_malform_pkt))       $display("%t: [HQMI_DEBUG]: AER ERR malformed packet err deasserted.", $time);

   if (hqm_sif_core.i_hqm_ri.i_ri_cds.obcpl_fifo_push & (hqm_sif_core.i_hqm_ri.i_ri_cds.obcpl_fifo_push_hdr.cs != 0))
    $display("%t: [HQMI_DEBUG]: AER UR cmpl generated: cs=%1x fmt=%1x cid=0x%04x len=0x%03x sbe=0x%1x ebe=0x%1x tag=0x%03x reqid=0x%04x addr=0x%x ep=%1x lok=%1x", $time
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_err_cplhdr.cs
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_err_cplhdr.fmt
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_err_cplhdr.cid
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_err_cplhdr.length
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_err_cplhdr.startbe
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_err_cplhdr.endbe
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_err_cplhdr.tag
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_err_cplhdr.rid
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_err_cplhdr.addr
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_err_cplhdr.ep
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_err_cplhdr.lok
     );

   if (hqm_sif_core.i_hqm_ri.i_ri_err.cds_err_msg_gnt)
    $display("%t: [HQMI_DEBUG]: AER SB message generated by ri_err: cid=0x%04x data=0x%x (%-s", $time
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_gen_msg_func
        ,hqm_sif_core.i_hqm_ri.i_ri_err.err_gen_msg_data
        ,((hqm_sif_core.i_hqm_ri.i_ri_err.err_gen_msg_data==8'h30)?"ERR_COR)":
         ((hqm_sif_core.i_hqm_ri.i_ri_err.err_gen_msg_data==8'h31)?"ERR_NONFATAL)":
         ((hqm_sif_core.i_hqm_ri.i_ri_err.err_gen_msg_data==8'h33)?"ERR_FATAL)":"UNKNOWN)")))
    );

   if (hqm_sif_core.i_hqm_ri.i_ri_cds.obcpl_fifo_push & (hqm_sif_core.i_hqm_ri.i_ri_cds.obcpl_fifo_push_hdr.cs == 0))
    $display("%t: [HQMI_DEBUG]: CDS SC cmpl generated: cs=%1x fmt=%1x cid=0x%04x len=0x%03x sbe=0x%1x ebe=0x%1x tag=0x%03x reqid=0x%04x addr=0x%x ep=%1x lok=%1x", $time
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_cplhdr.cs
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_cplhdr.fmt
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_cplhdr.cid
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_cplhdr.length
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_cplhdr.startbe
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_cplhdr.endbe
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_cplhdr.tag
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_cplhdr.rid
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_cplhdr.addr
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_cplhdr.ep
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds2ob_cplhdr.lok
     );

   if (hqm_sif_core.i_hqm_ri.i_ri_cds.cds_sb_wrack | hqm_sif_core.i_hqm_ri.i_ri_cds.cds_sb_rdack)
    $display("%t: [HQMI_DEBUG]: CDS SB acknowledge: wrack=%1x rdack=%1x v=%1x dv=%1x ursp=%1x d=0x%08x", $time
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_sb_wrack
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_sb_rdack
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_sb_cmsg.vld
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_sb_cmsg.dvld
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_sb_cmsg.ursp
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_sb_cmsg.rdata[0]
    );

   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.irdy))
    $display("%t: [HQMI_DEBUG]: CDS SB transaction: mmio(wr=%1x rd=%1x) cfg(wr=%1x rd=%1x) np=%1x sbe=%1x fbe=%1x a=0x%x sai=0x%02x bar=%1x fid=%1x d=0x%08x_%08x", $time
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.mmiowr
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.mmiord
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.cfgwr
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.cfgrd
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.np
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.sbe
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.fbe
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.addr
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.sai
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.bar
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.fid
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.sdata
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.data
    );

   if (hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr_v_wdata)
    $display("%t: [HQMI_DEBUG]: CDS transaction: sb=%1x (mmio=%1x bar=%x fid=%x) ep=%1x p=%1x cmd=%1x%s len=0x%03x sbe=0x%1x ebe=0x%1x tag=0x%03x reqid=0x%04x addr=0x%x sai=0x%02x fmt=%1x type=0x%02x %s pasidtlp=0x%06x", $time
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.iosfsb
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.iosfsb_mmio_txn
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.iosfsb_mmio_bar
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.iosfsb_mmio_fid
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.poison
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.posted
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.cmd
        ,((hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.posted) ?
            tlq_pcmd[ hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.cmd] :
            tlq_npcmd[hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.cmd])
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.length
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.startbe
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.endbe
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.tag
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.reqid
        ,{hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.addr[63:1], 1'b0}
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.sai
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.fmt
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.ttype
        ,string'(pci_cmd[{hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.fmt
                         ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.ttype}])
        ,hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.pasidtlp
     );

  end
 end

 //---------------------------------------------------------------------------------------------------------

 initial begin
  if (hqmi_debug) begin
   wait (hqm_sif_core.prim_rst_b === 1'b0);
   wait (hqm_sif_core.prim_rst_b === 1'b1);
   $display("%t: [HQMI_DEBUG]: RESET: strap_hqm_is_reg_ep=%d %s", $time, hqm_sif_core.strap_hqm_is_reg_ep,
    ((hqm_sif_core.strap_hqm_is_reg_ep)?"(EP)":"(RCIEP)"));
  end
 end

 logic [63:26]  func_pf_bar_q;
 logic [63:32]  csr_pf_bar_q;
 logic [1:0]    prim_clkreq_async_q;
 logic [3:0]    side_clkreq_async_q;
 logic [1:0]    ps_q;
 logic [2:0]    ps_fsm_q;
 logic [7:0]    current_bus_q;

 always_ff @(posedge hqm_sif_core.prim_freerun_clk) begin: error_p
  if (hqmi_debug) begin

   func_pf_bar_q <= hqm_sif_core.i_hqm_ri.func_pf_bar[63:26];
   csr_pf_bar_q  <= hqm_sif_core.i_hqm_ri.csr_pf_bar[63:32];
   ps_q          <= hqm_sif_core.i_hqm_ri.csr_pf0_ppmcsr_ps_c;
   ps_fsm_q      <= hqm_sif_core.i_hqm_ri.i_ri_pm.pf0_pm_state;
   current_bus_q <= hqm_sif_core.i_hqm_ri.i_ri_cds.current_bus;
`ifndef HQM_SFI
   prim_clkreq_async_q <= hqm_sif_core.i_hqm_iosfp_core.prim_clkreq_async;
   side_clkreq_async_q <= hqm_sif_core.i_hqm_iosfsb_core.side_clkreq_async;
`endif

   if ($rose(hqm_sif_core.fuse_proc_disable))                         $display("%t: [HQMI_DEBUG]: RESET: fuse_proc_disable          asserted.", $time);
   if ($fell(hqm_sif_core.fuse_proc_disable))                         $display("%t: [HQMI_DEBUG]: RESET: fuse_proc_disable        deasserted.", $time);
   if ($rose(hqm_sif_core.fuse_force_on))                             $display("%t: [HQMI_DEBUG]: RESET: fuse_force_on              asserted.", $time);
   if ($fell(hqm_sif_core.fuse_force_on))                             $display("%t: [HQMI_DEBUG]: RESET: fuse_force_on            deasserted.", $time);
   if ($rose(hqm_sif_core.pm_allow_ing_drop))                         $display("%t: [HQMI_DEBUG]: RESET: pm_allow_ing_drop          asserted.", $time);
   if ($fell(hqm_sif_core.pm_allow_ing_drop))                         $display("%t: [HQMI_DEBUG]: RESET: pm_allow_ing_drop        deasserted.", $time);
   if ($rose(hqm_sif_core.pm_fsm_in_run))                             $display("%t: [HQMI_DEBUG]: RESET: pm_fsm_in_run              asserted.", $time);
   if ($fell(hqm_sif_core.pm_fsm_in_run))                             $display("%t: [HQMI_DEBUG]: RESET: pm_fsm_in_run            deasserted.", $time);
   if ($rose(hqm_sif_core.pm_fsm_d3tod0_ok))                          $display("%t: [HQMI_DEBUG]: RESET: pm_fsm_d3tod0_ok           asserted.", $time);
   if ($fell(hqm_sif_core.pm_fsm_d3tod0_ok))                          $display("%t: [HQMI_DEBUG]: RESET: pm_fsm_d3tod0_ok         deasserted.", $time);
   if ($rose(hqm_sif_core.pm_fsm_d0tod3_ok))                          $display("%t: [HQMI_DEBUG]: RESET: pm_fsm_d0tod3_ok           asserted.", $time);
   if ($fell(hqm_sif_core.pm_fsm_d0tod3_ok))                          $display("%t: [HQMI_DEBUG]: RESET: pm_fsm_d0tod3_ok         deasserted.", $time);
   if ($rose(hqm_sif_core.hqm_flr_prep))                              $display("%t: [HQMI_DEBUG]: RESET: hqm_flr_prep               asserted.", $time);
   if ($fell(hqm_sif_core.hqm_flr_prep))                              $display("%t: [HQMI_DEBUG]: RESET: hqm_flr_prep             deasserted.", $time);
   if ($rose(hqm_sif_core.hqm_proc_reset_done))                       $display("%t: [HQMI_DEBUG]: RESET: hqm_proc_reset_done        asserted.", $time);
   if ($fell(hqm_sif_core.hqm_proc_reset_done))                       $display("%t: [HQMI_DEBUG]: RESET: hqm_proc_reset_done      deasserted.", $time);
   if ($rose(hqm_sif_core.hqm_proc_idle))                             $display("%t: [HQMI_DEBUG]: RESET: hqm_proc_idle              asserted.", $time);
   if ($fell(hqm_sif_core.hqm_proc_idle))                             $display("%t: [HQMI_DEBUG]: RESET: hqm_proc_idle            deasserted.", $time);
   if ($rose(hqm_sif_core.hqm_sif_idle))                              $display("%t: [HQMI_DEBUG]: RESET: hqm_sif_idle               asserted.", $time);
   if ($fell(hqm_sif_core.hqm_sif_idle))                              $display("%t: [HQMI_DEBUG]: RESET: hqm_sif_idle             deasserted.", $time);
   if ($rose(hqm_sif_core.hqm_idle))                                  $display("%t: [HQMI_DEBUG]: RESET: hqm_idle                   asserted.", $time);
   if ($fell(hqm_sif_core.hqm_idle))                                  $display("%t: [HQMI_DEBUG]: RESET: hqm_idle                 deasserted.", $time);
   if ($rose(hqm_sif_core.side_pok))                                  $display("%t: [HQMI_DEBUG]: RESET: side_pok                   asserted.", $time);
   if ($fell(hqm_sif_core.side_pok))                                  $display("%t: [HQMI_DEBUG]: RESET: side_pok                 deasserted.", $time);
   if ($rose(hqm_sif_core.pma_safemode))                              $display("%t: [HQMI_DEBUG]: RESET: pma_safemode               asserted.", $time);
   if ($fell(hqm_sif_core.pma_safemode))                              $display("%t: [HQMI_DEBUG]: RESET: pma_safemode             deasserted.", $time);
   if ($rose(hqm_sif_core.side_pwrgate_pmc_wake))                     $display("%t: [HQMI_DEBUG]: RESET: side_pwrgate_pmc_wake      asserted.", $time);
   if ($fell(hqm_sif_core.side_pwrgate_pmc_wake))                     $display("%t: [HQMI_DEBUG]: RESET: side_pwrgate_pmc_wake    deasserted.", $time);
`ifndef HQM_SFI
   if ($rose(hqm_sif_core.prim_pok))                                  $display("%t: [HQMI_DEBUG]: RESET: prim_pok                   asserted.", $time);
   if ($fell(hqm_sif_core.prim_pok))                                  $display("%t: [HQMI_DEBUG]: RESET: prim_pok                 deasserted.", $time);
   if ($rose(hqm_sif_core.prim_pwrgate_pmc_wake))                     $display("%t: [HQMI_DEBUG]: RESET: prim_pwrgate_pmc_wake      asserted.", $time);
   if ($fell(hqm_sif_core.prim_pwrgate_pmc_wake))                     $display("%t: [HQMI_DEBUG]: RESET: prim_pwrgate_pmc_wake    deasserted.", $time);
   if ( hqm_sif_core.i_hqm_iosfp_core.prim_clkreq_async[0]&~prim_clkreq_async_q[0])       $display("%t: [HQMI_DEBUG]: RESET: prim_clkreq_async[0]       asserted.", $time);
   if (~hqm_sif_core.i_hqm_iosfp_core.prim_clkreq_async[0]& prim_clkreq_async_q[0])       $display("%t: [HQMI_DEBUG]: RESET: prim_clkreq_async[0]     deasserted.", $time);
   if ( hqm_sif_core.i_hqm_iosfp_core.prim_clkreq_async[1]&~prim_clkreq_async_q[1])       $display("%t: [HQMI_DEBUG]: RESET: prim_clkreq_async[1]       asserted.", $time);
   if (~hqm_sif_core.i_hqm_iosfp_core.prim_clkreq_async[1]& prim_clkreq_async_q[1])       $display("%t: [HQMI_DEBUG]: RESET: prim_clkreq_async[1]     deasserted.", $time);
   if ( hqm_sif_core.i_hqm_iosfsb_core.side_clkreq_async[0]&~side_clkreq_async_q[0])       $display("%t: [HQMI_DEBUG]: RESET: side_clkreq_async[0]       asserted.", $time);
   if (~hqm_sif_core.i_hqm_iosfsb_core.side_clkreq_async[0]& side_clkreq_async_q[0])       $display("%t: [HQMI_DEBUG]: RESET: side_clkreq_async[0]     deasserted.", $time);
   if ( hqm_sif_core.i_hqm_iosfsb_core.side_clkreq_async[1]&~side_clkreq_async_q[1])       $display("%t: [HQMI_DEBUG]: RESET: side_clkreq_async[1]       asserted.", $time);
   if (~hqm_sif_core.i_hqm_iosfsb_core.side_clkreq_async[1]& side_clkreq_async_q[1])       $display("%t: [HQMI_DEBUG]: RESET: side_clkreq_async[1]     deasserted.", $time);
   if ( hqm_sif_core.i_hqm_iosfsb_core.side_clkreq_async[2]&~side_clkreq_async_q[2])       $display("%t: [HQMI_DEBUG]: RESET: side_clkreq_async[2]       asserted.", $time);
   if (~hqm_sif_core.i_hqm_iosfsb_core.side_clkreq_async[2]& side_clkreq_async_q[2])       $display("%t: [HQMI_DEBUG]: RESET: side_clkreq_async[2]     deasserted.", $time);
   if ( hqm_sif_core.i_hqm_iosfsb_core.side_clkreq_async[3]&~side_clkreq_async_q[3])       $display("%t: [HQMI_DEBUG]: RESET: side_clkreq_async[3]       asserted.", $time);
   if (~hqm_sif_core.i_hqm_iosfsb_core.side_clkreq_async[3]& side_clkreq_async_q[3])       $display("%t: [HQMI_DEBUG]: RESET: side_clkreq_async[3]     deasserted.", $time);
   if ($rose(hqm_sif_core.prim_clkreq))                               $display("%t: [HQMI_DEBUG]: RESET: prim_clkreq                asserted.", $time);
   if ($fell(hqm_sif_core.prim_clkreq))                               $display("%t: [HQMI_DEBUG]: RESET: prim_clkreq              deasserted.", $time);
   if ($rose(hqm_sif_core.prim_clkack))                               $display("%t: [HQMI_DEBUG]: RESET: prim_clkack                asserted.", $time);
   if ($fell(hqm_sif_core.prim_clkack))                               $display("%t: [HQMI_DEBUG]: RESET: prim_clkack              deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.flr_clk_enable))           $display("%t: [HQMI_DEBUG]: RESET: flr_clk_enable             asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.flr_clk_enable))           $display("%t: [HQMI_DEBUG]: RESET: flr_clk_enable           deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.flr_clk_enable_system))    $display("%t: [HQMI_DEBUG]: RESET: flr_clk_enable_sys         asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.flr_clk_enable_system))    $display("%t: [HQMI_DEBUG]: RESET: flr_clk_enable_sys       deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.flr_cpl_sent))                      $display("%t: [HQMI_DEBUG]: RESET: mstr.flr_cpl_sent          asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.flr_cpl_sent))                      $display("%t: [HQMI_DEBUG]: RESET: mstr.flr_cpl_sent        deasserted.", $time);
`endif
   if ($rose(hqm_sif_core.side_clkreq))                               $display("%t: [HQMI_DEBUG]: RESET: side_clkreq                asserted.", $time);
   if ($fell(hqm_sif_core.side_clkreq))                               $display("%t: [HQMI_DEBUG]: RESET: side_clkreq              deasserted.", $time);
   if ($rose(hqm_sif_core.side_clkack))                               $display("%t: [HQMI_DEBUG]: RESET: side_clkack                asserted.", $time);
   if ($fell(hqm_sif_core.side_clkack))                               $display("%t: [HQMI_DEBUG]: RESET: side_clkack              deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfsb_core.sif_gpsb_quiesce_req))    $display("%t: [HQMI_DEBUG]: RESET: sif_gpsb_quiesce_req       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfsb_core.sif_gpsb_quiesce_req))    $display("%t: [HQMI_DEBUG]: RESET: sif_gpsb_quiesce_req     deasserted.", $time);
   if ($rose(hqm_sif_core.sif_mstr_quiesce_req))                      $display("%t: [HQMI_DEBUG]: RESET: sif_mstr_quiesce_req       asserted.", $time);
   if ($fell(hqm_sif_core.sif_mstr_quiesce_req))                      $display("%t: [HQMI_DEBUG]: RESET: sif_mstr_quiesce_req     deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfsb_core.sif_gpsb_quiesce_ack))    $display("%t: [HQMI_DEBUG]: RESET: sif_gpsb_quiesce_ack       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfsb_core.sif_gpsb_quiesce_ack))    $display("%t: [HQMI_DEBUG]: RESET: sif_gpsb_quiesce_ack     deasserted.", $time);
   if ($rose(hqm_sif_core.sif_mstr_quiesce_ack))                      $display("%t: [HQMI_DEBUG]: RESET: sif_mstr_quiesce_ack       asserted.", $time);
   if ($fell(hqm_sif_core.sif_mstr_quiesce_ack))                      $display("%t: [HQMI_DEBUG]: RESET: sif_mstr_quiesce_ack     deasserted.", $time);
   if ($rose(hqm_sif_core.force_ip_inaccessible))                     $display("%t: [HQMI_DEBUG]: RESET: force_ip_inaccessible      asserted.", $time);
   if ($fell(hqm_sif_core.force_ip_inaccessible))                     $display("%t: [HQMI_DEBUG]: RESET: force_ip_inaccessible    deasserted.", $time);
   if ($rose(hqm_sif_core.force_warm_reset))                          $display("%t: [HQMI_DEBUG]: RESET: force_warm_reset           asserted.", $time);
   if ($fell(hqm_sif_core.force_warm_reset))                          $display("%t: [HQMI_DEBUG]: RESET: force_warm_reset         deasserted.", $time);
   if ($rose(hqm_sif_core.pm_hqm_adr_assert))                         $display("%t: [HQMI_DEBUG]: RESET: pm_hqm_adr_assert          asserted.", $time);
   if ($fell(hqm_sif_core.pm_hqm_adr_assert))                         $display("%t: [HQMI_DEBUG]: RESET: pm_hqm_adr_assert        deasserted.", $time);
   if ($rose(hqm_sif_core.hqm_pm_adr_ack))                            $display("%t: [HQMI_DEBUG]: RESET: hqm_pm_adr_ack             asserted.", $time);
   if ($fell(hqm_sif_core.hqm_pm_adr_ack))                            $display("%t: [HQMI_DEBUG]: RESET: hqm_pm_adr_ack           deasserted.", $time);
   if ($fell(hqm_sif_core.powergood_rst_b))                           $display("%t: [HQMI_DEBUG]: RESET: powergood_rst_b            asserted.", $time);
   if ($rose(hqm_sif_core.powergood_rst_b))                           $display("%t: [HQMI_DEBUG]: RESET: powergood_rst_b          deasserted.", $time);
   if ($fell(hqm_sif_core.prim_rst_b))                                $display("%t: [HQMI_DEBUG]: RESET: prim_rst_b                 asserted.", $time);
   if ($rose(hqm_sif_core.prim_rst_b))                                $display("%t: [HQMI_DEBUG]: RESET: prim_rst_b               deasserted.", $time);
   if ($fell(hqm_sif_core.side_rst_b))                                $display("%t: [HQMI_DEBUG]: RESET: side_rst_b                 asserted.", $time);
   if ($rose(hqm_sif_core.side_rst_b))                                $display("%t: [HQMI_DEBUG]: RESET: side_rst_b               deasserted.", $time);
   if ($fell(hqm_sif_core.hqm_gated_rst_b))                           $display("%t: [HQMI_DEBUG]: RESET: hqm_gated_rst_b            asserted.", $time);
   if ($rose(hqm_sif_core.hqm_gated_rst_b))                           $display("%t: [HQMI_DEBUG]: RESET: hqm_gated_rst_b          deasserted.", $time);
   if ($rose(hqm_sif_core.flr_triggered))                             $display("%t: [HQMI_DEBUG]: RESET: flr_triggered              asserted.", $time);
   if ($fell(hqm_sif_core.flr_triggered))                             $display("%t: [HQMI_DEBUG]: RESET: flr_triggered            deasserted.", $time);
   if ($rose(hqm_sif_core.prim_clk_enable_cdc))                       $display("%t: [HQMI_DEBUG]: RESET: prim_clk_enable_cdc        asserted.", $time);
   if ($fell(hqm_sif_core.prim_clk_enable_cdc))                       $display("%t: [HQMI_DEBUG]: RESET: prim_clk_enable_cdc      deasserted.", $time);
   if ($rose(hqm_sif_core.prim_clk_enable_sys))                       $display("%t: [HQMI_DEBUG]: RESET: prim_clk_enable_sys        asserted.", $time);
   if ($fell(hqm_sif_core.prim_clk_enable_sys))                       $display("%t: [HQMI_DEBUG]: RESET: prim_clk_enable_sys      deasserted.", $time);
   if ($rose(hqm_sif_core.prim_clk_enable))                           $display("%t: [HQMI_DEBUG]: RESET: prim_clk_enable            asserted.", $time);
   if ($fell(hqm_sif_core.prim_clk_enable))                           $display("%t: [HQMI_DEBUG]: RESET: prim_clk_enable          deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.ps_d0_to_d3))                       $display("%t: [HQMI_DEBUG]: RESET: ps_d0_to_d3                asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.ps_d0_to_d3))                       $display("%t: [HQMI_DEBUG]: RESET: ps_d0_to_d3              deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.flr_function0))                     $display("%t: [HQMI_DEBUG]: RESET: flr_function0              asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.flr_function0))                     $display("%t: [HQMI_DEBUG]: RESET: flr_function0            deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pm.ps_txn_sent_q))             $display("%t: [HQMI_DEBUG]: RESET: pm.ps_txn_sent_q           asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pm.ps_txn_sent_q))             $display("%t: [HQMI_DEBUG]: RESET: pm.ps_txn_sent_q         deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pm.ps_cpl_sent_q))             $display("%t: [HQMI_DEBUG]: RESET: pm.ps_cpl_sent_q           asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pm.ps_cpl_sent_q))             $display("%t: [HQMI_DEBUG]: RESET: pm.ps_cpl_sent_q         deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pm.ps_cpl_sent_ack))           $display("%t: [HQMI_DEBUG]: RESET: pm.ps_cpl_sent_ack         asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pm.ps_cpl_sent_ack))           $display("%t: [HQMI_DEBUG]: RESET: pm.ps_cpl_sent_ack       deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pm.flr_txn_sent_q))            $display("%t: [HQMI_DEBUG]: RESET: pm.flr_txn_sent_q          asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pm.flr_txn_sent_q))            $display("%t: [HQMI_DEBUG]: RESET: pm.flr_txn_sent_q        deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pm.flr_cpl_sent_q))            $display("%t: [HQMI_DEBUG]: RESET: pm.flr_cpl_sent_q          asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pm.flr_cpl_sent_q))            $display("%t: [HQMI_DEBUG]: RESET: pm.flr_cpl_sent_q        deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_cds.flr_treatment_q))          $display("%t: [HQMI_DEBUG]: RESET: flr_treatment_q            asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_cds.flr_treatment_q))          $display("%t: [HQMI_DEBUG]: RESET: flr_treatment_q          deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.hard_rst_np))          $display("%t: [HQMI_DEBUG]: RESET: hard_rst_np              deasserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.hard_rst_np))          $display("%t: [HQMI_DEBUG]: RESET: hard_rst_np                asserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.soft_rst_np))          $display("%t: [HQMI_DEBUG]: RESET: soft_rst_np              deasserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.soft_rst_np))          $display("%t: [HQMI_DEBUG]: RESET: soft_rst_np                asserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.flr_treatment_q))      $display("%t: [HQMI_DEBUG]: RESET: csr_flr_treatment          asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.flr_treatment_q))      $display("%t: [HQMI_DEBUG]: RESET: csr_flr_treatment        deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.device_command.MEM))         $display("%t: [HQMI_DEBUG]: RESET: device_command.MEM[pf]     asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.device_command.MEM))         $display("%t: [HQMI_DEBUG]: RESET: device_command.MEM[pf]   deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.device_command.BM))          $display("%t: [HQMI_DEBUG]: RESET: device_command.BM[pf]      asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.device_command.BM))          $display("%t: [HQMI_DEBUG]: RESET: device_command.BM[pf]    deasserted.", $time);
   if (hqm_sif_core.lli_phdr_val)   $display("%t: [HQMI_DEBUG]: RESET: LLI P  request valid (cmd=%-s", $time,
        tlq_pcmd[hqm_sif_core.lli_phdr.cmd]);
   if (hqm_sif_core.lli_nphdr_val)  $display("%t: [HQMI_DEBUG]: RESET: LLI NP request valid (cmd=%-s", $time,
        tlq_npcmd[hqm_sif_core.lli_nphdr.cmd]);
`ifndef HQM_SFI
   if (hqm_sif_core.i_hqm_iosfp_core.lli_cplhdr_val) $display("%t: [HQMI_DEBUG]: RESET: LLI completion valid (status=%-s", $time,
        (hqm_sif_core.i_hqm_iosfp_core.lli_cplhdr.status==3'd0)?"SC )":
        (hqm_sif_core.i_hqm_iosfp_core.lli_cplhdr.status==3'd1)?"UR )":
        (hqm_sif_core.i_hqm_iosfp_core.lli_cplhdr.status==3'd2)?"CRS)":
        (hqm_sif_core.i_hqm_iosfp_core.lli_cplhdr.status==3'd4)?"CA )":
        (hqm_sif_core.i_hqm_iosfp_core.lli_cplhdr.status==3'd7)?"CPLLK|CPLDLK)":"XXX)");
`endif

   if ($rose(hqm_sif_core.master_ctl_load)) $display("%t: [HQMI_DEBUG]: master_ctl updated to 0x%08x.", $time, hqm_sif_core.master_ctl);
   
   if (hqm_sif_core.prim_rst_b) begin

    if ($rose(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.csr_pasid_enable))  $display("%t: [HQMI_DEBUG]: RESET: SCIOV  enabled.", $time);
    if ($fell(hqm_sif_core.i_hqm_ri.i_ri_pf_vf_cfg.csr_pasid_enable))  $display("%t: [HQMI_DEBUG]: RESET: SCIOV disabled.", $time);
    
    if (func_pf_bar_q != hqm_sif_core.i_hqm_ri.func_pf_bar[63:26])
     $display("%t: [HQMI_DEBUG]: RESET: func_pf_bar changed to 0x%08x_%02xxxxxxx",
     $time, hqm_sif_core.i_hqm_ri.func_pf_bar[63:32], {hqm_sif_core.i_hqm_ri.func_pf_bar[31:26], 2'd0});
    if (csr_pf_bar_q  != hqm_sif_core.i_hqm_ri.csr_pf_bar[63:32])
     $display("%t: [HQMI_DEBUG]: RESET: csr_pf_bar  changed to 0x%08x_xxxxxxxx", 
     $time, hqm_sif_core.i_hqm_ri.csr_pf_bar[63:32]);
    if (ps_q != hqm_sif_core.i_hqm_ri.csr_pf0_ppmcsr_ps_c)
     $display("%t: [HQMI_DEBUG]: RESET: ps     changed to D%01d", $time, hqm_sif_core.i_hqm_ri.csr_pf0_ppmcsr_ps_c);
    if (ps_fsm_q != hqm_sif_core.i_hqm_ri.i_ri_pm.pf0_pm_state)
     $display("%t: [HQMI_DEBUG]: RESET: ps FSM changed to %01d (%s", $time, hqm_sif_core.i_hqm_ri.i_ri_pm.pf0_pm_state,
     ((hqm_sif_core.i_hqm_ri.i_ri_pm.pf0_pm_state==3'd0) ? "D3COLD)" :
     ((hqm_sif_core.i_hqm_ri.i_ri_pm.pf0_pm_state==3'd1) ? "D3HOT)" :
     ((hqm_sif_core.i_hqm_ri.i_ri_pm.pf0_pm_state==3'd2) ? "D0UNINIT)" : "D0ACT)"))));
    
    if (hqm_sif_core.i_hqm_ri.i_ri_cds.current_bus !=  current_bus_q)
     $display("%t: [HQMI_DEBUG]: RESET: PF  saved bus number changed (bus=0x%08x).",
     $time, hqm_sif_core.i_hqm_ri.i_ri_cds.current_bus);
    
   end

  end
 end

`ifndef HQM_SFI

 //---------------------------------------------------------------------------------------------------------
 // Master tracing

 logic [HQM_MSTR_NUM_CQS-1:0] hpa_err_last;
 logic [HQM_MSTR_NUM_CQS-1:0] hpa_pnd_last;

 always_ff @(posedge hqm_sif_core.prim_freerun_clk or negedge hqm_sif_core.prim_gated_rst_b) begin
  if (~hqm_sif_core.prim_gated_rst_b) begin
   hpa_err_last <= '0;
   hpa_pnd_last <= '0;
  end else begin
   hpa_err_last <= hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.hpa_err_q;
   hpa_pnd_last <= hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.hpa_pnd_q;
  end
 end

 always_ff @(posedge hqm_sif_core.prim_freerun_clk) begin
  if (hqmi_debug & (hqm_sif_core.prim_rst_b === 1'b1)) begin

   if ( hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.iosf_gnt_q.gnt &
       (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.iosf_gnt_q.gtype==2'd0)) begin
    if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.iosf_gnt_q.rtype==2'd0) 
     $display("%t: [HQMI_DEBUG]: MSTR SEND P   CMD: f/t=%x/%02x %s tc=%x ep=%x at=%x l=0x%03x rid=0x%04x tag=0x%x%02x lfbe=%x/%x a=0x%08x_%08x pasid=0x%06x sai=0x%02x"
        ,$time
        ,hqm_sif_core.mfmt
        ,hqm_sif_core.mtype
        ,string'(pci_cmd[{hqm_sif_core.mfmt, hqm_sif_core.mtype}])
        ,hqm_sif_core.mtc
        ,hqm_sif_core.mep
        ,hqm_sif_core.mat
        ,hqm_sif_core.mlength
        ,hqm_sif_core.mrqid
        ,{hqm_sif_core.mrsvd1_7, hqm_sif_core.mrsvd1_3}
        ,hqm_sif_core.mtag
        ,hqm_sif_core.mlbe
        ,hqm_sif_core.mfbe
        ,hqm_sif_core.maddress[63:32]
        ,hqm_sif_core.maddress[31: 0]
        ,hqm_sif_core.mpasidtlp
        ,hqm_sif_core.msai
     );
    else if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.iosf_gnt_q.rtype==2'd1) 
     $display("%t: [HQMI_DEBUG]: MSTR SEND NP  CMD: f/t=%x/%02x %s tc=%x ep=%x at=%x l=0x%03x rid=0x%04x tag=0x%x%02x lfbe=%x/%x a=0x%08x_%08x pasid=0x%06x sai=0x%02x"
        ,$time
        ,hqm_sif_core.mfmt
        ,hqm_sif_core.mtype
        ,string'(pci_cmd[{hqm_sif_core.mfmt, hqm_sif_core.mtype}])
        ,hqm_sif_core.mtc
        ,hqm_sif_core.mep
        ,hqm_sif_core.mat
        ,hqm_sif_core.mlength
        ,hqm_sif_core.mrqid
        ,{hqm_sif_core.mrsvd1_7, hqm_sif_core.mrsvd1_3}
        ,hqm_sif_core.mtag
        ,hqm_sif_core.mlbe
        ,hqm_sif_core.mfbe
        ,hqm_sif_core.maddress[63:32]
        ,hqm_sif_core.maddress[31: 0]
        ,hqm_sif_core.mpasidtlp
        ,hqm_sif_core.msai
     );
    else if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.iosf_gnt_q.rtype==2'd2) 
     $display("%t: [HQMI_DEBUG]: MSTR SEND CPL CMD: f/t=%x/%02x %s tc=%x ep=%x l=0x%03x cid=0x%04x cs=%x tag=0x%x%02x bc=0x%04x rid=0x%04x la=0x%02x pasid=0x%06x sai=0x%02x"
        ,$time
        ,hqm_sif_core.mfmt
        ,hqm_sif_core.mtype
        ,string'(pci_cmd[{hqm_sif_core.mfmt, hqm_sif_core.mtype}])
        ,hqm_sif_core.mtc
        ,hqm_sif_core.mep
        ,hqm_sif_core.mlength
        ,hqm_sif_core.mrqid
        ,{hqm_sif_core.mrsvd1_7, hqm_sif_core.mrsvd1_3}
        ,hqm_sif_core.maddress[15:8]
        ,{hqm_sif_core.mlbe, hqm_sif_core.mfbe}
        ,hqm_sif_core.maddress[31:16]
        ,hqm_sif_core.maddress[6:0]
        ,hqm_sif_core.maddress[31: 0]
        ,hqm_sif_core.mpasidtlp
        ,hqm_sif_core.msai
     );
   end

   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.fl2ll_v)
    $display("%t: [HQMI_DEBUG]: MSTR LL:     FL      HP (PTR=0x%02x)  pop to %3s LL 0x%02x"
        ,$time
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.fl_hptr
        ,((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.fl2ll_ll==8'd128)?"P":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.fl2ll_ll==8'd129)?"NP":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.fl2ll_ll==8'd130)?"CPL":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.fl2ll_ll==8'd131)?"ALM":"CQ"))))
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.fl2ll_ll
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2rl_v)
    $display("%t: [HQMI_DEBUG]: MSTR LL: %3s LL 0x%02x HP (PTR=0x%02x) move to %3s RL"
        ,$time
        ,((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2rl_ll==8'd128)?"P":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2rl_ll==8'd129)?"NP":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2rl_ll==8'd130)?"CPL":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2rl_ll==8'd131)?"ALM":"CQ"))))
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2rl_ll
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_hptr_mda[hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2rl_ll]
        ,((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2rl_rl==2'd2)?"CPL":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2rl_rl==2'd1)?"NP":"P"))
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_v) begin
    if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_v_nd) begin
     $display("%t: [HQMI_DEBUG]: MSTR LL: %3s LL 0x%02x HP (PTR=0x%02x) move to %3s DB"
        ,$time
        ,((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll==8'd128)?"P":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll==8'd129)?"NP":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll==8'd130)?"CPL":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll==8'd131)?"ALM":"CQ"))))
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_hptr_mda[hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll]
        ,((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_arb_winner_rl==2'd2)?"CPL":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_arb_winner_rl==2'd1)?"NP":"P"))
     );
    end else if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.hpa_err_scaled[hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_arb_winner_q]) begin
     $display("%t: [HQMI_DEBUG]: MSTR LL: %3s LL 0x%02x HP (PTR=0x%02x) drain due to hpa_err being set for CQ"
        ,$time
        ,((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll==8'd128)?"P":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll==8'd129)?"NP":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll==8'd130)?"CPL":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll==8'd131)?"ALM":"CQ"))))
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_hptr_mda[hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll]
        ,((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_arb_winner_rl==2'd2)?"CPL":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_arb_winner_rl==2'd1)?"NP":"P"))
     );
    end else begin
     $display("%t: [HQMI_DEBUG]: MSTR LL: %3s LL 0x%02x HP (PTR=0x%02x) drain due to FLR or PS=D3"
        ,$time
        ,((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll==8'd128)?"P":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll==8'd129)?"NP":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll==8'd130)?"CPL":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll==8'd131)?"ALM":"CQ"))))
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_hptr_mda[hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll]
        ,((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_arb_winner_rl==2'd2)?"CPL":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_arb_winner_rl==2'd1)?"NP":"P"))
     );
    end
   end
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rl2db_v)
    $display("%t: [HQMI_DEBUG]: MSTR LL: %3s RL      HP (PTR=0x%02x) move to %3s DB"
        ,$time
        ,((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rl2db_rl==2'd2)?"CPL":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rl2db_rl==2'd1)?"NP":"P"))
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rl_hptr_mda[hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rl2db_rl]
        ,((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rl2db_rl==2'd2)?"CPL":
         ((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rl2db_rl==2'd1)?"NP":"P"))
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.fl_push)
    $display("%t: [HQMI_DEBUG]: MSTR LL:                (PTR=0x%02x) push to     FL"
        ,$time
        ,((hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rl2db_v)?
           hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rl_hptr_mda[hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rl2db_rl]:
           hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_hptr_mda[hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_ll])
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.scrbd_alloc)
    $display("%t: [HQMI_DEBUG]: MSTR LL: SCRBD allocate tag=0x%02x src=%0d id=0x%02x"
        ,$time
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.scrbd_tag
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.scrbd_alloc_data.src
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.scrbd_alloc_data.id
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.scrbd_free)
    $display("%t: [HQMI_DEBUG]: MSTR: SCRBD free     tag=0x%02x"
        ,$time
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.scrbd_free_tag
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_req_v)
    $display("%t: [HQMI_DEBUG]: MSTR: DEVTLB Request:  id=0x%02x tlb=%0d pasid(v=%0d priv=%0d 0x%05x) pri=%0d op=%d tc=%0d bdf=0x%04x addr=0x0%07x_%05x000"
        ,$time
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_req.id
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_req.tlbid
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_req.pasid_valid
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_req.pasid_priv
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_req.pasid
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_req.ppriority
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_req.opcode
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_req.tc
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_req.bdf
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_req.address[56:32]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_req.address[31:12]
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_rsp_v)
    $display("%t: [HQMI_DEBUG]: MSTR: DEVTLB Response: id=0x%02x res=%0d ns=%0d h/derr=%0d/%0d addr=0x0000%04x_%05x000"
        ,$time
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_rsp.id
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_rsp.result
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_rsp.nonsnooped
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_rsp.hdrerror
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_rsp.dperror
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_rsp.address[45:32]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_rsp.address[31:12]
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req_v[1] &
       hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req_ack[1])
    $display("%t: [HQMI_DEBUG]: MSTR: DEVTLB HP ATS Request: id=0x%02x nw=%0d pasid(v=%0d priv=%0d 0x%05x) tc=%0d bdf=0x%04x addr=0x0%07x_%05x000"
        ,$time
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.id[1]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.nw[1]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.pasid_valid[1]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.pasid_priv[1]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.pasid[1]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.tc[1]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.bdf[1]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.address[1][56:32]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.address[1][31:12]
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req_v[0] &
       hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req_ack[0])
    $display("%t: [HQMI_DEBUG]: MSTR: DEVTLB LP ATS Request: id=0x%02x nw=%0d pasid(v=%0d priv=%0d 0x%05x) tc=%0d bdf=0x%04x addr=0x0%07x_%05x000"
        ,$time
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.id[0]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.nw[0]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.pasid_valid[0]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.pasid_priv[0]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.pasid[0]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.tc[0]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.bdf[0]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.address[0][56:32]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req.address[0][31:12]
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp_v)
    $display("%t: [HQMI_DEBUG]: MSTR: DEVTLB ATS Response: id=0x%02x h/derr=%0d/%0d s=%0d n=%0d g=%0d p=%0d e=%0d u=%0d w=%0d r=%0d pa=0x%08x_%05x000"
        ,$time
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.id
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.hdrerror
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.dperror
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[51]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[50]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[61]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[60]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[59]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[58]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[57]
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[56]
        ,{hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[7:0]
         ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[15:8]
         ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[23:16]
         ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[31:24]}
        ,{hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[39:32]
         ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[47:40]
         ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_rsp.data[55:52]}
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.drain_req_v &
       hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.drain_req_ack)
    $display("%t: [HQMI_DEBUG]: MSTR: DEVTLB Drain Request: pasid(v=%0d priv=%0d 0x%05x g=%0d) bdf=0x%04x"
        ,$time
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.drain_req.pasid_valid
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.drain_req.pasid_priv
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.drain_req.pasid
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.drain_req.pasid_global
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.drain_req.bdf
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.drain_rsp_v)
    $display("%t: [HQMI_DEBUG]: MSTR: DEVTLB Drain Response",$time);
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rx_msg_v)
    $display("%t: [HQMI_DEBUG]: MSTR: DEVTLB Invalidate Request:  pasid(v=%0d priv=%0d 0x%0x) op=%d derr=%0d itag=0x%0x rid=0x%0x dw2=0x%0x data=0x%0x"
        ,$time
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rx_msg.pasid_valid
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rx_msg.pasid_priv
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rx_msg.pasid
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rx_msg.opcode
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rx_msg.dperror
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rx_msg.invreq_itag
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rx_msg.invreq_reqid
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rx_msg.dw2
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rx_msg.data
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.tx_msg_v &
       hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.tx_msg_ack)
    $display("%t: [HQMI_DEBUG]: MSTR: DEVTLB Invalidate Response: pasid(v=%0d priv=%0d 0x%05x) op=%d tc=%0d bdf=0x%04x dw2=0x%0x dw3=0x%0x"
        ,$time
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.tx_msg.pasid_valid
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.tx_msg.pasid_priv
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.tx_msg.pasid
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.tx_msg.opcode
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.tx_msg.tc
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.tx_msg.bdf
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.tx_msg.dw2
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.tx_msg.dw3
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ibcpl_hdr_push)
    $display("%t: [HQMI_DEBUG]: MSTR: IBCPL HDR: tag=0x%03x st=%x tc=0x%01x len=0x%03x bc=0x%03x rid=0x%04x cid=0x%04x addr=0x%02x ep=%x ro=%x wdata=%x"
        ,$time
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ibcpl_hdr.tag
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ibcpl_hdr.status
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ibcpl_hdr.tc
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ibcpl_hdr.length
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ibcpl_hdr.bc
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ibcpl_hdr.rid
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ibcpl_hdr.cid
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ibcpl_hdr.addr
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ibcpl_hdr.poison
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ibcpl_hdr.ro
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ibcpl_hdr.wdata
    );
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.clr_hpa_err)
     $display("%t: [HQMI_DEBUG]: MSTR: Clearing hpa_err_q[0x%02x]"
        ,$time
        ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.clr_hpa_err_cq
     );
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cfg_ats_enabled))    $display("%t: [HQMI_DEBUG]: MSTR: cfg_ats_enabled      asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cfg_ats_enabled))    $display("%t: [HQMI_DEBUG]: MSTR: cfg_ats_enabled    deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.np_trans_pending))   $display("%t: [HQMI_DEBUG]: MSTR: np_trans_pending     asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.np_trans_pending))   $display("%t: [HQMI_DEBUG]: MSTR: np_trans_pending   deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.xreqs_active))       $display("%t: [HQMI_DEBUG]: MSTR: xreqs_active         asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.xreqs_active))       $display("%t: [HQMI_DEBUG]: MSTR: xreqs_active       deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.invreqs_active))     $display("%t: [HQMI_DEBUG]: MSTR: invreqs_active       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.invreqs_active))     $display("%t: [HQMI_DEBUG]: MSTR: invreqs_active     deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.imp_invalidation_v)) $display("%t: [HQMI_DEBUG]: MSTR: imp_invalidation_v   asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.imp_invalidation_v)) $display("%t: [HQMI_DEBUG]: MSTR: imp_invalidation_v deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.fl_empty))           $display("%t: [HQMI_DEBUG]: MSTR: fl_empty             asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.fl_empty))           $display("%t: [HQMI_DEBUG]: MSTR: fl_empty           deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.drain_cq_p_np_lls))  $display("%t: [HQMI_DEBUG]: MSTR: drain_cq_p_np_lls    asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.drain_cq_p_np_lls))  $display("%t: [HQMI_DEBUG]: MSTR: drain_cq_p_np_lls  deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.block_cq_p_np_lls))  $display("%t: [HQMI_DEBUG]: MSTR: block_cq_p_np_lls    asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.block_cq_p_np_lls))  $display("%t: [HQMI_DEBUG]: MSTR: block_cq_p_np_lls  deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.clr_hpa_v))          $display("%t: [HQMI_DEBUG]: MSTR: clr_hpa_v            asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.clr_hpa_v))          $display("%t: [HQMI_DEBUG]: MSTR: clr_hpa_v          deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cpl_usr))            $display("%t: [HQMI_DEBUG]: MSTR: cpl_usr              asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cpl_usr))            $display("%t: [HQMI_DEBUG]: MSTR: cpl_usr            deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cpl_abort))          $display("%t: [HQMI_DEBUG]: MSTR: cpl_abort            asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cpl_abort))          $display("%t: [HQMI_DEBUG]: MSTR: cpl_abort          deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cpl_timeout))        $display("%t: [HQMI_DEBUG]: MSTR: cpl_timeout          asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cpl_timeout))        $display("%t: [HQMI_DEBUG]: MSTR: cpl_timeout        deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cpl_poisoned))       $display("%t: [HQMI_DEBUG]: MSTR: cpl_poisoned         asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cpl_poisoned))       $display("%t: [HQMI_DEBUG]: MSTR: cpl_poisoned       deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cpl_unexpected))     $display("%t: [HQMI_DEBUG]: MSTR: cpl_unexpected       asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cpl_unexpected))     $display("%t: [HQMI_DEBUG]: MSTR: cpl_unexpected     deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_ats_alarm))   $display("%t: [HQMI_DEBUG]: MSTR: devtlb_ats_alarm     asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_ats_alarm))   $display("%t: [HQMI_DEBUG]: MSTR: devtlb_ats_alarm   deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.set_devtlb_ats_err.BAD_RESULT)) $display("%t: [HQMI_DEBUG]: MSTR: ats_rsp bad_result   asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.set_devtlb_ats_err.BAD_RESULT)) $display("%t: [HQMI_DEBUG]: MSTR: ats_rsp bad_result deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.set_devtlb_ats_err.HDRERROR))   $display("%t: [HQMI_DEBUG]: MSTR: ats_rsp hdrerror     asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.set_devtlb_ats_err.HDRERROR))   $display("%t: [HQMI_DEBUG]: MSTR: ats_rsp hdrerror   deasserted.", $time);
   if ($rose(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.set_devtlb_ats_err.DPERROR))    $display("%t: [HQMI_DEBUG]: MSTR: ats_rsp dperror      asserted.", $time);
   if ($fell(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.set_devtlb_ats_err.DPERROR))    $display("%t: [HQMI_DEBUG]: MSTR: ats_rsp dperror    deasserted.", $time);
   for (int i=0; i<HQM_MSTR_NUM_CQS; i=i+1) begin
   if ( hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.hpa_pnd_q[i] & ~hpa_pnd_last[i])   $display("%t: [HQMI_DEBUG]: MSTR: hpa_pnd_q[0x%02x]      asserted.", $time, i);
   if (~hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.hpa_pnd_q[i] &  hpa_pnd_last[i])   $display("%t: [HQMI_DEBUG]: MSTR: hpa_pnd_q[0x%02x]    deasserted.", $time, i);
   if ( hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.hpa_err_q[i] & ~hpa_err_last[i])   $display("%t: [HQMI_DEBUG]: MSTR: hpa_err_q[0x%02x]      asserted.", $time, i);
   if (~hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.hpa_err_q[i] &  hpa_err_last[i])   $display("%t: [HQMI_DEBUG]: MSTR: hpa_err_q[0x%02x]    deasserted.", $time, i);
   end
  end
 end

 //---------------------------------------------------------------------------------------------------------
 // LL Checks

 task ll_check ();

  logic                                 err_flag;
  logic  [HQM_MSTR_FL_DEPTH_WIDTH-1:0]  ptr;
  logic  [HQM_MSTR_FL_DEPTH-1:0]        blk_err;
  logic  [HQM_MSTR_FL_DEPTH-1:0]        fl_blk;
  logic  [HQM_MSTR_FL_DEPTH-1:0]        ll_blk[HQM_MSTR_NUM_LLS-1:0];
  logic  [HQM_MSTR_FL_DEPTH-1:0]        rl_blk[2:0];
  logic  [HQM_MSTR_FL_CNT_WIDTH-1:0]    fl_cnt;
  logic  [HQM_MSTR_FL_CNT_WIDTH-1:0]    ll_cnt[HQM_MSTR_NUM_LLS-1:0];
  logic  [HQM_MSTR_FL_CNT_WIDTH-1:0]    rl_cnt[2:0];
  int                                   cnt;
  int                                   tot_cnt;
  string                                s;

  fl_blk = '0; fl_cnt = '0; blk_err = '0; cnt = 0; tot_cnt = 0;
  if (|hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.fl_cnt_q) begin
   ptr = hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.fl_hptr_q;
   fl_blk[ptr] = '1; fl_cnt = 1; tot_cnt = 1;
   while (ptr != hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.fl_tptr_q) begin
    ptr = hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.blk_ptr_q[ptr];
    fl_blk[ptr] = '1; fl_cnt = fl_cnt+1; tot_cnt = tot_cnt+1; cnt = cnt+1;
    if (cnt > HQM_MSTR_FL_DEPTH) break;
   end
  end

  for (int i=0; i<HQM_MSTR_NUM_LLS; i=i+1) begin
   ll_blk[i] = '0; ll_cnt[i] = '0; cnt = 0;
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.ll_v_q[i]) begin
    ptr = hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.ll_hptr_q[i];
    ll_blk[i][ptr] = '1; ll_cnt[i] = 1; tot_cnt = tot_cnt+1;
    while (ptr != hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.ll_tptr_q[i]) begin
     ptr = hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.blk_ptr_q[ptr];
     ll_blk[i][ptr] = '1; ll_cnt[i] = ll_cnt[i]+1; tot_cnt = tot_cnt+1; cnt = cnt+1;
     if (cnt > HQM_MSTR_FL_DEPTH) break;
    end
   end
  end

  for (int i=0; i<3; i=i+1) begin
   rl_blk[i] = '0; rl_cnt[i] = '0; cnt = 0;
   if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.rl_v_q[i]) begin
    ptr = hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.rl_hptr_q[i];
    rl_blk[i][ptr] = '1; rl_cnt[i] = 1; tot_cnt = tot_cnt+1;
    while (ptr != hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.rl_tptr_q[i]) begin
     ptr = hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.blk_ptr_q[ptr];
     rl_blk[i][ptr] = '1; rl_cnt[i] = rl_cnt[i]+1; tot_cnt = tot_cnt+1; cnt = cnt+1;
     if (cnt > HQM_MSTR_FL_DEPTH) break;
    end
   end
  end

  if (tot_cnt != HQM_MSTR_FL_DEPTH) begin
   $display("%t: MSTR LL ERROR: Total block count on all LLs, RLs, and the FL (%d) was not %d !!!", $time
        ,tot_cnt ,HQM_MSTR_FL_DEPTH
   );
   err_flag = '1;
  end

  for (int i=0; i<HQM_MSTR_FL_DEPTH; i=i+1) begin // Each block

   for (int j=0; j<HQM_MSTR_NUM_LLS; j=j+1) begin
    if (fl_blk[i] & ll_blk[j][i]) begin
     $display("%t: MSTR LL ERROR: Block 0x%02x exists on FL and LL 0x%02x !!!", $time, i, j);
     blk_err[i] = '1; err_flag = '1;
    end
    for (int k=0; k<HQM_MSTR_NUM_LLS; k=k+1) begin
     if (j != k) begin
      if (ll_blk[j][i] & ll_blk[k][i]) begin
       $display("%t: MSTR LL ERROR: Block 0x%02x exists on LL 0x%02x and LL 0x%02x !!!", $time, i, j, k);
       blk_err[i] = '1; err_flag = '1;
      end
     end
    end
    for (int k=0; k<3; k=k+1) begin
     if (ll_blk[j][i] & rl_blk[k][i]) begin
      $display("%t: MSTR LL ERROR: Block 0x%02x exists on LL 0x%02x and RL 0x%02x !!!", $time, i, j, k);
      blk_err[i] = '1; err_flag = '1;
     end
    end
   end
   for (int j=0; j<3; j=j+1) begin
    if (fl_blk[i] & rl_blk[j][i]) begin
     $display("%t: MSTR LL ERROR: Block 0x%02x exists on FL and RL 0x%02x !!!", $time, i, j);
     blk_err[i] = '1; err_flag = '1;
    end
    for (int k=0; k<3; k=k+1) begin
     if (j != k) begin
      if (rl_blk[j][i] & rl_blk[k][i]) begin
       $display("%t: MSTR LL ERROR: Block 0x%02x exists on RL 0x%02x and RL 0x%02x !!!", $time, i, j, k);
       blk_err[i] = '1; err_flag = '1;
      end
     end
    end
   end

  end // Each block

  if (err_flag) begin // Display LLs

   if (|hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.fl_cnt_q) begin
    cnt = 1;
    s = $psprintf("FL:     cnt=%4d hp=0x%02x tp=0x%02x %02x", fl_cnt
      ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.fl_hptr_q
      ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.fl_tptr_q
      ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.fl_hptr_q
    );
    ptr = hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.fl_hptr_q;
    while (ptr != hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.fl_tptr_q) begin
     ptr = hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.blk_ptr_q[ptr];
     s = {s, $psprintf("->%02x", ptr)};
     cnt = cnt+1;
     if (cnt > HQM_MSTR_FL_DEPTH) begin
      s = {s, $psprintf(" (FL too big)")};
      break;
     end
    end
   end else begin
    s = $psprintf("FL: Empty");
   end
   $display("%s", s);

   for (int i=0; i<HQM_MSTR_NUM_LLS; i=i+1) begin
    if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.ll_v_q[i]) begin
     cnt = 1;
     s = $psprintf("LL[%02x]: cnt=%4d hp=0x%02x tp=0x%02x %02x", i, ll_cnt[i]
      ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.ll_hptr_q[i]
      ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.ll_tptr_q[i]
      ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.ll_hptr_q[i]
     );
     ptr = hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.ll_hptr_q[i];
     while (ptr != hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.ll_tptr_q[i]) begin
      ptr = hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.blk_ptr_q[ptr];
      s = {s, $psprintf("->%02x", ptr)};
      cnt = cnt+1;
      if (cnt > HQM_MSTR_FL_DEPTH) begin
       s = {s, $psprintf(" (LL too big)")};
       break;
      end
     end
    end else begin
     s = $psprintf("LL[%02x]: Empty", i);
    end
    $display("%s", s);
   end

   for (int i=0; i<3; i=i+1) begin
    if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.rl_v_q[i]) begin
     cnt = 1;
     s = $psprintf("%-3s RL: cnt=%4d hp=0x%02x tp=0x%02x %02x", ((i==0)?"P  ":((i==1)?"NP ":"CPL")), rl_cnt[i]
      ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.rl_hptr_q[i]
      ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.rl_tptr_q[i]
      ,hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.rl_hptr_q[i]
     );
     ptr = hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.rl_hptr_q[i];
     while (ptr != hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.rl_tptr_q[i]) begin
      ptr = hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_ll.blk_ptr_q[ptr];
      s = {s, $psprintf("->%02x", ptr)};
      cnt = cnt+1;
      if (cnt > HQM_MSTR_FL_DEPTH) begin
       s = {s, $psprintf(" (RL too big)")};
       break;
      end
     end
    end else begin
     s = $psprintf("%-3s RL: Empty", ((i==0)?"P  ":((i==1)?"NP ":"CPL")));
    end
    $display("%s", s);
   end

  end // Diplay LLs

 endtask : ll_check

 logic check_lls_q;

 always_ff @(posedge hqm_sif_core.prim_freerun_clk or hqm_sif_core.prim_gated_rst_b) begin
  if (~hqm_sif_core.prim_gated_rst_b) begin
   check_lls_q <= '0;
  end else begin
   check_lls_q <= hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.fl2ll_v |
                  hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2rl_v |
                  hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll2db_v |
                  hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rl2db_v |
                  hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.fl_push;
   if (check_lls_q) ll_check();
  end
 end

`endif

 //---------------------------------------------------------------------------------------------------------

 task eot_check (output bit pf);

  pf = 1'b0 ; //pass

  if (hqm_sif_core.i_hqm_sif_infra_core.i_hqm_sif_cfg_master.psel_q) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: Config master still has an outstanding APB transaction!!!", $time);
   pf = 1'b1;
  end

`ifndef HQM_SFI

  if (|hqm_sif_core.i_hqm_iosfp_core.mstr_cnts) begin
   if (drop_cnt_check) begin
    $display ("%0tps: [HQMI_EOT]: ERROR: MSTR MSI-X drop counter is non-zero (value=0x%08x_%08x)!!!", $time,
        $sampled(hqm_sif_core.i_hqm_iosfp_core.mstr_cnts[1]), $sampled(hqm_sif_core.i_hqm_iosfp_core.mstr_cnts[0]));
    pf = 1'b1;
   end else begin
    $display ("%0tps: [HQMI_EOT]: WARNING: MSTR MSI-X drop counter is non-zero (value=0x%08x_%08x)!!!", $time,
        $sampled(hqm_sif_core.i_hqm_iosfp_core.mstr_cnts[1]), $sampled(hqm_sif_core.i_hqm_iosfp_core.mstr_cnts[0]));
   end
  end

  // MSTR checks

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.req_put_cnt_q[0] !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR P request put count != 0 at EOT (count=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.req_put_cnt_q[0]));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.req_put_cnt_q[1] !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR NP request put count != 0 at EOT (count=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.req_put_cnt_q[1]));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.req_put_cnt_q[2] !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR CPL request put count != 0 at EOT (count=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.req_put_cnt_q[2]));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req_cnt_q !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR ATS request count != 0 at EOT (count=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ats_req_cnt_q));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.xreq_cnt_q !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR xreq count != 0 at EOT (count=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.xreq_cnt_q));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_hcrd_q !== 3'h4) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR has outstanding HP devtlb requests at EOT (hcrd=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_hcrd_q));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_lcrd_q !== 3'h4) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR has outstanding LP devtlb requests at EOT (lcrd=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.devtlb_lcrd_q));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_v !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR LLs are not empty at EOT (value=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.ll_v));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rl_v !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR RLs are not empty at EOT (value=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.rl_v));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cpl_req_db_status[1:0] !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR CPL request DB is not empty at EOT (depth=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.cpl_req_db_status[1:0]));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.np_req_db_status[1:0] !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR NP request DB is not empty at EOT (depth=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.np_req_db_status[1:0]));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.p_req_db_status[1:0] !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR P request DB is not empty at EOT (depth=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.p_req_db_status[1:0]));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.scrbd_cnt_q !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR scorboard count != 0 at EOT (count=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.scrbd_cnt_q));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.scrbd_tag_inuse_q !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR scorboard tags are in use at EOT (value=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.scrbd_tag_inuse_q));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.cpl_timer_v_q !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR scorboard completion timers are in use at EOT (value=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.cpl_timer_v_q));
   pf = 1'b1;
  end

  if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.cpl_timeout_pend_q !== '0) begin
   $display ("%0tps: [HQMI_EOT]: ERROR: MSTR scorboard completion timeouts are pending at EOT (value=0x%0x)!!!", $time,
      $sampled(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.cpl_timeout_pend_q));
   pf = 1'b1;
  end

  // Credit checks

  if (credit_cnt_check) begin

   if (hqm_sif_core.i_hqm_iosfp_core.tgt_rem_hcredits.REM_HCREDITS_NP !== NP_HDR_CREDITS[7:0]) begin
    $display ("%0tps: [HQMI_EOT]: ERROR: SIF TGT remaining non-posted header credits != initial credit value at EOT (value=0x%02x expected=0x%02x)!!!", $time,
       $sampled(hqm_sif_core.i_hqm_iosfp_core.tgt_rem_hcredits.REM_HCREDITS_NP), NP_HDR_CREDITS[7:0]);
    pf = 1'b1;
   end

   if (hqm_sif_core.i_hqm_iosfp_core.tgt_rem_hcredits.REM_HCREDITS_P !== P_HDR_CREDITS[7:0]) begin
    $display ("%0tps: [HQMI_EOT]: ERROR: SIF TGT remaining posted header credits != initial credit value at EOT (value=0x%02x expected=0x%02x)!!!", $time,
       $sampled(hqm_sif_core.i_hqm_iosfp_core.tgt_rem_hcredits.REM_HCREDITS_P), P_HDR_CREDITS[7:0]);
    pf = 1'b1;
   end

   if (hqm_sif_core.i_hqm_iosfp_core.tgt_rem_hcredits.REM_HCREDITS_CPL !== CPL_HDR_CREDITS[7:0]) begin
    $display ("%0tps: [HQMI_EOT]: ERROR: SIF TGT remaining completion header credits != initial credit value at EOT (value=0x%02x expected=0x%02x)!!!", $time,
       $sampled(hqm_sif_core.i_hqm_iosfp_core.tgt_rem_hcredits.REM_HCREDITS_CPL), CPL_HDR_CREDITS[7:0]);
    pf = 1'b1;
   end

   if (hqm_sif_core.i_hqm_iosfp_core.tgt_rem_dcredits.REM_DCREDITS_NP !== NP_DATA_CREDITS[7:0]) begin
    $display ("%0tps: [HQMI_EOT]: ERROR: SIF TGT remaining non-posted data credits != initial credit value at EOT (value=0x%02x expected=0x%02x)!!!", $time,
       $sampled(hqm_sif_core.i_hqm_iosfp_core.tgt_rem_dcredits.REM_DCREDITS_NP), NP_DATA_CREDITS[7:0]);
    pf = 1'b1;
   end

   if (hqm_sif_core.i_hqm_iosfp_core.tgt_rem_dcredits.REM_DCREDITS_P !== P_DATA_CREDITS[7:0]) begin
    $display ("%0tps: [HQMI_EOT]: ERROR: SIF TGT remaining posted data credits != initial credit value at EOT (value=0x%02x expected=0x%02x)!!!", $time,
       $sampled(hqm_sif_core.i_hqm_iosfp_core.tgt_rem_dcredits.REM_DCREDITS_P), P_DATA_CREDITS[7:0]);
    pf = 1'b1;
   end

   if (hqm_sif_core.i_hqm_iosfp_core.tgt_rem_dcredits.REM_DCREDITS_CPL !== CPL_DATA_CREDITS[7:0]) begin
    $display ("%0tps: [HQMI_EOT]: ERROR: SIF TGT remaining completion data credits != initial credit value at EOT (value=0x%02x expected=0x%02x)!!!", $time,
       $sampled(hqm_sif_core.i_hqm_iosfp_core.tgt_rem_dcredits.REM_DCREDITS_CPL), CPL_DATA_CREDITS[7:0]);
    pf = 1'b1;
   end

   if (hqm_sif_core.i_hqm_iosfp_core.tgt_ret_hcredits.RET_HCREDITS_NP !== '0) begin
    $display ("%0tps: [HQMI_EOT]: ERROR: SIF TGT return non-posted header credits != 0 at EOT (value=0x%02x)!!!", $time,
       $sampled(hqm_sif_core.i_hqm_iosfp_core.tgt_ret_hcredits.RET_HCREDITS_NP));
    pf = 1'b1;
   end

   if (hqm_sif_core.i_hqm_iosfp_core.tgt_ret_hcredits.RET_HCREDITS_P !== '0) begin
    $display ("%0tps: [HQMI_EOT]: ERROR: SIF TGT return posted header credits != 0 at EOT (value=0x%02x)!!!", $time,
       $sampled(hqm_sif_core.i_hqm_iosfp_core.tgt_ret_hcredits.RET_HCREDITS_P));
    pf = 1'b1;
   end

   if (hqm_sif_core.i_hqm_iosfp_core.tgt_ret_hcredits.RET_HCREDITS_CPL !== '0) begin
    $display ("%0tps: [HQMI_EOT]: ERROR: SIF TGT return completion header credits != 0 at EOT (value=0x%02x)!!!", $time,
       $sampled(hqm_sif_core.i_hqm_iosfp_core.tgt_ret_hcredits.RET_HCREDITS_CPL));
    pf = 1'b1;
   end

   if (hqm_sif_core.i_hqm_iosfp_core.tgt_ret_dcredits.RET_DCREDITS_NP !== '0) begin
    $display ("%0tps: [HQMI_EOT]: ERROR: SIF TGT return non-posted data credits != 0 at EOT (value=0x%02x)!!!", $time,
       $sampled(hqm_sif_core.i_hqm_iosfp_core.tgt_ret_dcredits.RET_DCREDITS_NP));
    pf = 1'b1;
   end

   if (hqm_sif_core.i_hqm_iosfp_core.tgt_ret_dcredits.RET_DCREDITS_P !== '0) begin
    $display ("%0tps: [HQMI_EOT]: ERROR: SIF TGT return posted data credits != 0 at EOT (value=0x%02x)!!!", $time,
       $sampled(hqm_sif_core.i_hqm_iosfp_core.tgt_ret_dcredits.RET_DCREDITS_P));
    pf = 1'b1;
   end

   if (hqm_sif_core.i_hqm_iosfp_core.tgt_ret_dcredits.RET_DCREDITS_CPL !== '0) begin
    $display ("%0tps: [HQMI_EOT]: ERROR: SIF TGT return completion data credits != 0 at EOT (value=0x%02x)!!!", $time,
       $sampled(hqm_sif_core.i_hqm_iosfp_core.tgt_ret_dcredits.RET_DCREDITS_CPL));
    pf = 1'b1;
   end

  end

`endif

 endtask : eot_check

 //---------------------------------------------------------------------------------------------------------

endmodule

bind hqm_sif_core hqm_sif_inst i_hqm_sif_inst();

`endif

