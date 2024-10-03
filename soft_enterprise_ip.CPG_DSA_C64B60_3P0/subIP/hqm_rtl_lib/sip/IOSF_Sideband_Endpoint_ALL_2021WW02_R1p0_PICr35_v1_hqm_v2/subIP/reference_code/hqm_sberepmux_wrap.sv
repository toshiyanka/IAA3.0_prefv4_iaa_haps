//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2021 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  2021WW02_PICr35
//
//  Module sberepmux_wrap : Wrapper for repeater and the combo logics
//------------------------------------------------------------------------------

// lintra push -60020, -60088, -80018, -80028, -80099, -68001, -68000, -50514

module hqm_sberepmux_wrap
#(
  parameter INTERNALPLDBIT = 31,
  parameter SPLIT_COMBO    = 0
 )(
  input     agent_clk,
  input     agent_rst_b,
  
  // interface to IP

  input  logic           sbi_sbe_tmsg_pcfree_ip, 
  input  logic           sbi_sbe_tmsg_npfree_ip,
  input  logic           sbi_sbe_tmsg_npclaim_ip,
  output logic                        sbe_sbi_tmsg_pcput_ip,
  output logic                        sbe_sbi_tmsg_npput_ip,
  output logic                        sbe_sbi_tmsg_pcparity_ip,
  output logic                        sbe_sbi_tmsg_npparity_ip,
  output logic                        sbe_sbi_tmsg_pcmsgip_ip,
  output logic                        sbe_sbi_tmsg_npmsgip_ip,
  output logic                        sbe_sbi_tmsg_pceom_ip,
  output logic                        sbe_sbi_tmsg_npeom_ip,
  output logic                 [INTERNALPLDBIT:0] sbe_sbi_tmsg_pcpayload_ip,
  output logic                 [INTERNALPLDBIT:0] sbe_sbi_tmsg_nppayload_ip,
  output logic                        sbe_sbi_tmsg_pccmpl_ip,
  output logic                        sbe_sbi_tmsg_pcvalid_ip,
  output logic                        sbe_sbi_tmsg_npvalid_ip,
  input  logic           sbi_sbe_mmsg_pcirdy_ip,
  input  logic           sbi_sbe_mmsg_npirdy_ip,
  input  logic           sbi_sbe_mmsg_pcparity_ip,
  input  logic           sbi_sbe_mmsg_npparity_ip,
  input  logic           sbi_sbe_mmsg_pceom_ip,  
  input  logic           sbi_sbe_mmsg_npeom_ip,
  input  logic    [INTERNALPLDBIT:0] sbi_sbe_mmsg_pcpayload_ip,
  input  logic    [INTERNALPLDBIT:0] sbi_sbe_mmsg_nppayload_ip,
  output logic                        sbe_sbi_mmsg_pctrdy_ip,  
  output logic                        sbe_sbi_mmsg_nptrdy_ip,
  output logic                        sbe_sbi_mmsg_pcmsgip_ip,
  output logic                        sbe_sbi_mmsg_npmsgip_ip,
  output logic           sbe_sbi_mmsg_pcsel_ip,
  output logic           sbe_sbi_mmsg_npsel_ip,


  // interface to EP

  output  logic           sbi_sbe_tmsg_pcfree_ep,
  output  logic           sbi_sbe_tmsg_npfree_ep,
  output  logic           sbi_sbe_tmsg_npclaim_ep,
  input logic                        sbe_sbi_tmsg_pcput_ep,
  input logic                        sbe_sbi_tmsg_npput_ep,
  input logic                        sbe_sbi_tmsg_pcparity_ep,
  input logic                        sbe_sbi_tmsg_npparity_ep,
  input logic                        sbe_sbi_tmsg_pcmsgip_ep,
  input logic                        sbe_sbi_tmsg_npmsgip_ep,
  input logic                        sbe_sbi_tmsg_pceom_ep,
  input logic                        sbe_sbi_tmsg_npeom_ep,
  input logic                 [INTERNALPLDBIT:0] sbe_sbi_tmsg_pcpayload_ep,
  input logic                 [INTERNALPLDBIT:0] sbe_sbi_tmsg_nppayload_ep,
  input logic                        sbe_sbi_tmsg_pccmpl_ep,
  input logic                        sbe_sbi_tmsg_pcvalid_ep,
  input logic                        sbe_sbi_tmsg_npvalid_ep,

  output  logic           sbi_sbe_mmsg_pcirdy_ep,
  output  logic           sbi_sbe_mmsg_npirdy_ep,
  output  logic           sbi_sbe_mmsg_pcparity_ep,
  output  logic           sbi_sbe_mmsg_npparity_ep,
  output  logic           sbi_sbe_mmsg_pceom_ep,  
  output  logic           sbi_sbe_mmsg_npeom_ep,
  output  logic    [INTERNALPLDBIT:0] sbi_sbe_mmsg_pcpayload_ep,
  output  logic    [INTERNALPLDBIT:0] sbi_sbe_mmsg_nppayload_ep,
  
  input logic                        sbe_sbi_mmsg_pctrdy_ep,
  input logic                        sbe_sbi_mmsg_nptrdy_ep,
  input logic                        sbe_sbi_mmsg_pcmsgip_ep,
  input logic                        sbe_sbi_mmsg_npmsgip_ep,
  input logic           sbe_sbi_mmsg_pcsel_ep,
  input logic           sbe_sbi_mmsg_npsel_ep,

  output logic fifo_empty,
  
  input logic fscan_mode,
  input logic fscan_shiften,
  input logic fscan_clkungate_syn,
  input logic fscan_rstbypen,         // Bypass all resets
  input logic fscan_byprst_b         // Bypass all resets

);

logic sbe_sbi_tmsg_pcput_ip_int, sbe_sbi_tmsg_npput_ip_int;
logic sbe_sbi_mmsg_pcsel_ip_int, sbe_sbi_mmsg_npsel_ip_int;
logic sbe_sbi_mmsg_pctrdy_ip_int, sbe_sbi_mmsg_nptrdy_ip_int;
logic sbe_sbi_mmsg_pcmsgip_ip_int, sbe_sbi_mmsg_npmsgip_ip_int;
logic sbe_sbi_tmsg_pcput_ip_frmextcmb, sbe_sbi_tmsg_npput_ip_frmextcmb;
logic [1:0] puttotgt_int,empty_tgt_int;
logic fence_off_np_int;
logic [1:0] full_mst_int;


hqm_sberepeater_new #(
    .INTERNALPLDBIT ( INTERNALPLDBIT),
    .SPLIT_COMBO    ( SPLIT_COMBO   )
 )
    i_sberepeater_new (
        .agent_clk                  ( agent_clk                         ),
        .agent_rst_b                ( agent_rst_b                       ),
		.sbi_sbe_tmsg_pcfree_ip     ( sbi_sbe_tmsg_pcfree_ip            ),
		.sbi_sbe_tmsg_npfree_ip     ( sbi_sbe_tmsg_npfree_ip            ),
		.sbi_sbe_tmsg_npclaim_ip    ( sbi_sbe_tmsg_npclaim_ip           ),
		.sbe_sbi_tmsg_pcput_ip      ( sbe_sbi_tmsg_pcput_ip_int         ),
		.sbe_sbi_tmsg_npput_ip      ( sbe_sbi_tmsg_npput_ip_int         ),
		.sbe_sbi_tmsg_pcparity_ip   ( sbe_sbi_tmsg_pcparity_ip          ),
		.sbe_sbi_tmsg_npparity_ip   ( sbe_sbi_tmsg_npparity_ip          ),
		.sbe_sbi_tmsg_pcmsgip_ip    ( sbe_sbi_tmsg_pcmsgip_ip           ),
		.sbe_sbi_tmsg_npmsgip_ip    ( sbe_sbi_tmsg_npmsgip_ip           ),
		.sbe_sbi_tmsg_pceom_ip      ( sbe_sbi_tmsg_pceom_ip             ),
		.sbe_sbi_tmsg_npeom_ip      ( sbe_sbi_tmsg_npeom_ip             ),
		.sbe_sbi_tmsg_pcpayload_ip  ( sbe_sbi_tmsg_pcpayload_ip         ),
		.sbe_sbi_tmsg_nppayload_ip  ( sbe_sbi_tmsg_nppayload_ip         ),
		.sbe_sbi_tmsg_pccmpl_ip     ( sbe_sbi_tmsg_pccmpl_ip            ),
		
		.sbi_sbe_mmsg_pcirdy_ip     ( sbi_sbe_mmsg_pcirdy_ip            ),
		.sbi_sbe_mmsg_npirdy_ip     ( sbi_sbe_mmsg_npirdy_ip            ),
		.sbi_sbe_mmsg_pcparity_ip   ( sbi_sbe_mmsg_pcparity_ip          ),
		.sbi_sbe_mmsg_npparity_ip   ( sbi_sbe_mmsg_npparity_ip          ),
		.sbi_sbe_mmsg_pceom_ip      ( sbi_sbe_mmsg_pceom_ip             ),
		.sbi_sbe_mmsg_npeom_ip      ( sbi_sbe_mmsg_npeom_ip             ),
		.sbi_sbe_mmsg_pcpayload_ip  ( sbi_sbe_mmsg_pcpayload_ip         ),
		.sbi_sbe_mmsg_nppayload_ip  ( sbi_sbe_mmsg_nppayload_ip         ),
		.sbe_sbi_mmsg_pctrdy_ip     ( sbe_sbi_mmsg_pctrdy_ip_int        ),
		.sbe_sbi_mmsg_nptrdy_ip     ( sbe_sbi_mmsg_nptrdy_ip_int        ),
		.sbe_sbi_mmsg_pcmsgip_ip    ( sbe_sbi_mmsg_pcmsgip_ip_int       ),
		.sbe_sbi_mmsg_npmsgip_ip    ( sbe_sbi_mmsg_npmsgip_ip_int       ),
		.sbe_sbi_mmsg_pcsel_ip      ( sbe_sbi_mmsg_pcsel_ip_int         ),
		.sbe_sbi_mmsg_npsel_ip      ( sbe_sbi_mmsg_npsel_ip_int         ),
		.sbe_sbi_tmsg_pcvalid_ip    ( sbe_sbi_tmsg_pcvalid_ip           ),
		.sbe_sbi_tmsg_npvalid_ip    ( sbe_sbi_tmsg_npvalid_ip           ),
		
		.sbi_sbe_tmsg_pcfree_ep     ( sbi_sbe_tmsg_pcfree_ep            ),
		.sbi_sbe_tmsg_npfree_ep     ( sbi_sbe_tmsg_npfree_ep            ),
		.sbi_sbe_tmsg_npclaim_ep    ( sbi_sbe_tmsg_npclaim_ep           ),
		.sbe_sbi_tmsg_pcput_ep      ( sbe_sbi_tmsg_pcput_ep             ),
		.sbe_sbi_tmsg_npput_ep      ( sbe_sbi_tmsg_npput_ep             ),
		.sbe_sbi_tmsg_pcparity_ep   ( sbe_sbi_tmsg_pcparity_ep          ),
		.sbe_sbi_tmsg_npparity_ep   ( sbe_sbi_tmsg_npparity_ep          ),
		.sbe_sbi_tmsg_pcmsgip_ep    ( sbe_sbi_tmsg_pcmsgip_ep           ),
		.sbe_sbi_tmsg_npmsgip_ep    ( sbe_sbi_tmsg_npmsgip_ep           ),
		.sbe_sbi_tmsg_pceom_ep      ( sbe_sbi_tmsg_pceom_ep             ),
		.sbe_sbi_tmsg_npeom_ep      ( sbe_sbi_tmsg_npeom_ep             ),
		.sbe_sbi_tmsg_pcpayload_ep  ( sbe_sbi_tmsg_pcpayload_ep         ),
		.sbe_sbi_tmsg_nppayload_ep  ( sbe_sbi_tmsg_nppayload_ep         ),
		.sbe_sbi_tmsg_pccmpl_ep     ( sbe_sbi_tmsg_pccmpl_ep            ),
		.fscan_rstbypen             ( fscan_rstbypen                    ),
		.fscan_byprst_b             ( fscan_byprst_b                    ),
		.fscan_mode                 ( fscan_mode                        ),
		.fscan_shiften              ( fscan_shiften                     ),
		.fscan_clkungate_syn        ( fscan_clkungate_syn               ),
					   
		.sbi_sbe_mmsg_pcirdy_ep     ( sbi_sbe_mmsg_pcirdy_ep            ),
		.sbi_sbe_mmsg_npirdy_ep     ( sbi_sbe_mmsg_npirdy_ep            ),
		.sbi_sbe_mmsg_pcparity_ep   ( sbi_sbe_mmsg_pcparity_ep          ),
		.sbi_sbe_mmsg_npparity_ep   ( sbi_sbe_mmsg_npparity_ep          ),
		.sbi_sbe_mmsg_pceom_ep      ( sbi_sbe_mmsg_pceom_ep             ),
		.sbi_sbe_mmsg_npeom_ep      ( sbi_sbe_mmsg_npeom_ep             ),
		.sbi_sbe_mmsg_pcpayload_ep  ( sbi_sbe_mmsg_pcpayload_ep         ),
		.sbi_sbe_mmsg_nppayload_ep  ( sbi_sbe_mmsg_nppayload_ep         ),
		.sbe_sbi_mmsg_pctrdy_ep     ( sbe_sbi_mmsg_pctrdy_ep            ),
		.sbe_sbi_mmsg_nptrdy_ep     ( sbe_sbi_mmsg_nptrdy_ep            ),
		.sbe_sbi_mmsg_pcmsgip_ep    ( sbe_sbi_mmsg_pcmsgip_ep           ),
		.sbe_sbi_mmsg_npmsgip_ep    ( sbe_sbi_mmsg_npmsgip_ep           ),
		.sbe_sbi_mmsg_pcsel_ep      ( sbe_sbi_mmsg_pcsel_ep             ),
		.sbe_sbi_mmsg_npsel_ep      ( sbe_sbi_mmsg_npsel_ep             ),
		.sbe_sbi_tmsg_pcvalid_ep    ( sbe_sbi_tmsg_pcvalid_ep           ),
		.sbe_sbi_tmsg_npvalid_ep    ( sbe_sbi_tmsg_npvalid_ep           ),
        .puttotgt                   ( puttotgt_int                      ),
        .fence_off_np               ( fence_off_np_int                  ),
        .full_mst                   ( full_mst_int                      ),
        .empty_tgt                  ( empty_tgt_int                     ),
        .sbe_sbi_tmsg_pcput_ip_frmextcmb(sbe_sbi_tmsg_pcput_ip_frmextcmb),
        .sbe_sbi_tmsg_npput_ip_frmextcmb(sbe_sbi_tmsg_npput_ip_frmextcmb),
        .fifo_empty                 ( fifo_empty                        )
    );



        hqm_sberepmux_top #(
            .INTERNALPLDBIT (INTERNALPLDBIT ),
            .SPLIT_COMBO    (SPLIT_COMBO    ))
            i_sberepmux_top (
            // used when split_comb = 0
                .sbe_sbi_tmsg_pcput_ip_int      ( sbe_sbi_tmsg_pcput_ip_int ),
                .sbe_sbi_tmsg_npput_ip_int      ( sbe_sbi_tmsg_npput_ip_int ),
                .sbe_sbi_mmsg_pcsel_ip_int      ( sbe_sbi_mmsg_pcsel_ip_int ),
                .sbe_sbi_mmsg_npsel_ip_int      ( sbe_sbi_mmsg_npsel_ip_int ),
                .sbe_sbi_mmsg_pctrdy_ip_int     ( sbe_sbi_mmsg_pctrdy_ip_int),
                .sbe_sbi_mmsg_nptrdy_ip_int     ( sbe_sbi_mmsg_nptrdy_ip_int),
                .sbe_sbi_mmsg_pcmsgip_ip_int    ( sbe_sbi_mmsg_pcmsgip_ip_int),
                .sbe_sbi_mmsg_npmsgip_ip_int    ( sbe_sbi_mmsg_npmsgip_ip_int),
            //used when split_comb = 1
            //input to tgtmux
                .puttotgt_int                   ( puttotgt_int              ),
                .empty_tgt_int                  ( empty_tgt_int             ),
                .fence_off_np_int               ( fence_off_np_int          ),
                .sbi_sbe_tmsg_pcfree_ip         ( sbi_sbe_tmsg_pcfree_ip    ),
                .sbi_sbe_tmsg_npfree_ip         ( sbi_sbe_tmsg_npfree_ip    ),
            //outputs to ip
                .sbe_sbi_tmsg_pcput_ip          ( sbe_sbi_tmsg_pcput_ip     ),
                .sbe_sbi_tmsg_npput_ip          ( sbe_sbi_tmsg_npput_ip     ),
            //outputs to tgtrep
                .sbe_sbi_tmsg_pcput_ip_frmextcmb( sbe_sbi_tmsg_pcput_ip_frmextcmb),
                .sbe_sbi_tmsg_npput_ip_frmextcmb( sbe_sbi_tmsg_npput_ip_frmextcmb),
                .agent_clk                      ( agent_clk                 ),
                .agent_rst_b                    ( agent_rst_b               ),
                .full_mst_int                   ( full_mst_int              ),
	            .sbi_sbe_mmsg_pcirdy_ip         ( sbi_sbe_mmsg_pcirdy_ip    ),
	            .sbi_sbe_mmsg_npirdy_ip         ( sbi_sbe_mmsg_npirdy_ip    ),
	            .sbi_sbe_mmsg_pceom_ip          ( sbi_sbe_mmsg_pceom_ip     ),
	            .sbi_sbe_mmsg_npeom_ip          ( sbi_sbe_mmsg_npeom_ip     ),
            //outputs to ip
	            .sbe_sbi_mmsg_pcsel_ip          ( sbe_sbi_mmsg_pcsel_ip     ),
	            .sbe_sbi_mmsg_npsel_ip          ( sbe_sbi_mmsg_npsel_ip     ),
	            .sbe_sbi_mmsg_pctrdy_ip         ( sbe_sbi_mmsg_pctrdy_ip    ),
	            .sbe_sbi_mmsg_nptrdy_ip         ( sbe_sbi_mmsg_nptrdy_ip    ),
	            .sbe_sbi_mmsg_pcmsgip_ip        ( sbe_sbi_mmsg_pcmsgip_ip   ),
	            .sbe_sbi_mmsg_npmsgip_ip        ( sbe_sbi_mmsg_npmsgip_ip   )
	     );

endmodule
