//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_bcam_2048x26 (

     input  logic                        CLK_DFX_WRAPPER
                                        
    ,input  logic                        FUNC_WR_CLK_RF_IN_P0
    ,input  logic [8-1:0]                FUNC_WEN_RF_IN_P0
    ,input  logic [64-1:0]               FUNC_WR_ADDR_RF_IN_P0
    ,input  logic [208-1:0]              FUNC_WR_DATA_RF_IN_P0
                                        
    ,input  logic                        FUNC_CM_CLK_RF_IN_P0
    ,input  logic [8-1:0]                FUNC_CEN_RF_IN_P0
    ,input  logic [208-1:0]              FUNC_CM_DATA_RF_IN_P0
                                        
    ,output logic [2048-1:0]             CM_MATCH_RF_OUT_P0
                                        
    ,input  logic                        FUNC_RD_CLK_RF_IN_P0
    ,input  logic                        FUNC_REN_RF_IN_P0
    ,input  logic [8-1:0]                FUNC_RD_ADDR_RF_IN_P0
                                        
    ,output logic [208-1:0]              DATA_RF_OUT_P0
                                        
    ,input  logic                        pgcb_isol_en_b
                                        
    // LCP Interface                    
                                        
    ,input  logic                        fd
    ,input  logic                        rd
                                        
    ,input  logic                        ip_reset_b

    ,input  logic                        fscan_byprst_b
    ,input  logic                        fscan_rstbypen
);

logic ip_reset_b_sync;

hqm_mem_reset_sync_scan i_ip_reset_b_sync (

     .clk                           (FUNC_RD_CLK_RF_IN_P0)
    ,.rst_n                         (ip_reset_b)

    ,.fscan_rstbypen                (fscan_rstbypen)
    ,.fscan_byprst_b                (fscan_byprst_b)

    ,.rst_n_sync                    (ip_reset_b_sync)
);

srf026b256e1r1w1cbbeheaa0aaw_dfx_wrapper #(.MBIST_CAM_WRAPPER(1), .CAM_MATCH_ATPG_EN(1)) i_bcam_b7 (

     .FUNC_RD_CLK_RF_IN_P0          (FUNC_RD_CLK_RF_IN_P0)
    ,.FUNC_REN_RF_IN_P0             (FUNC_REN_RF_IN_P0)
    ,.FUNC_RD_ADDR_RF_IN_P0         (FUNC_RD_ADDR_RF_IN_P0)
    ,.DATA_RF_OUT_P0                (DATA_RF_OUT_P0[207:182])

    ,.FUNC_WR_CLK_RF_IN_P0          (FUNC_WR_CLK_RF_IN_P0)
    ,.FUNC_WEN_RF_IN_P0             (FUNC_WEN_RF_IN_P0[7])
    ,.FUNC_WR_ADDR_RF_IN_P0         (FUNC_WR_ADDR_RF_IN_P0[63:56])
    ,.FUNC_WR_DATA_RF_IN_P0         (FUNC_WR_DATA_RF_IN_P0[207:182])

    ,.FUNC_CM_CLK_RF_IN_P0          (FUNC_CM_CLK_RF_IN_P0)
    ,.FUNC_CEN_RF_IN_P0             (FUNC_CEN_RF_IN_P0[7])
    ,.FUNC_CM_DATA_RF_IN_P0         (FUNC_CM_DATA_RF_IN_P0[207:182])
    ,.CM_MATCH_RF_OUT_P0            (CM_MATCH_RF_OUT_P0[2047:1792])

    ,.BIST_RF_ENABLE                ('0)
    ,.BIST_WR_CLK_RF_IN_P0          ('0)
    ,.BIST_WEN_RF_IN_P0             ('0)
    ,.BIST_WR_ADDR_RF_IN_P0         ('0)
    ,.BIST_WR_DATA_RF_IN_P0         ('0)
    ,.BIST_RD_CLK_RF_IN_P0          ('0)
    ,.BIST_REN_RF_IN_P0             ('0)
    ,.BIST_RD_ADDR_RF_IN_P0         ('0)

    ,.BIST_CM_CLK_RF_IN_P0          ('0)
    ,.BIST_CEN_RF_IN_P0             ('0)
    ,.BIST_CM_DATA_RF_IN_P0         ('0)
    ,.BIST_CM_MODE_RF_IN            ('0)
    ,.BIST_ROTATE_MASK_RF_IN        ('0)
    ,.BIST_CD_MASK_ENABLE_RF_IN     ('0)
    ,.BIST_DATA_INV_RF_IN           ('0)
    ,.BIST_CM_MATCH_SEL0_RF_IN      ('0)
    ,.BIST_CM_MATCH_SEL1_RF_IN      ('0)

    ,.CLK_DFX_WRAPPER               (CLK_DFX_WRAPPER)
    ,.DFX_MISC_RF_IN                ({19'b0, ip_reset_b_sync})
    ,.DFX_MISC_RF_OUT               ()

    ,.FSCAN_RAM_WRDIS_B             ('1)
    ,.FSCAN_RAM_RDDIS_B             ('1)
    ,.FSCAN_RAM_ODIS_B              ('1)

    ,.FUSE_MISC_RF_IN               ('0)

    ,.UNGATE_BIST_WRTEN             ('1)

    ,.FSCAN_BYPRST_B                (fscan_byprst_b)
    ,.FSCAN_RSTBYPEN                (fscan_rstbypen)
    ,.FSCAN_RAM_BYPSEL              ('0)
    ,.FSCAN_RAM_AWT_MODE            ('0)
    ,.FSCAN_RAM_AWT_WEN             ('0)
    ,.FSCAN_RAM_AWT_REN             ('0)
    ,.FSCAN_MODE                    ('0)

    ,.FSCAN_RAM_INIT_EN             ('0)
    ,.FSCAN_RAM_INIT_VAL            ('0)

    ,.LBIST_TEST_MODE               ('0)

    ,.flcp_fd                       ({4{fd}})
    ,.flcp_rd                       ({4{rd}})

    ,.PWR_MGMT_MISC_RF_IN           ('0)
    ,.PWR_MGMT_MISC_RF_OUT          ()
);

srf026b256e1r1w1cbbeheaa0aaw_dfx_wrapper #(.MBIST_CAM_WRAPPER(1), .CAM_MATCH_ATPG_EN(1)) i_bcam_b6 (

     .FUNC_RD_CLK_RF_IN_P0          (FUNC_RD_CLK_RF_IN_P0)
    ,.FUNC_REN_RF_IN_P0             (FUNC_REN_RF_IN_P0)
    ,.FUNC_RD_ADDR_RF_IN_P0         (FUNC_RD_ADDR_RF_IN_P0)
    ,.DATA_RF_OUT_P0                (DATA_RF_OUT_P0[181:156])

    ,.FUNC_WR_CLK_RF_IN_P0          (FUNC_WR_CLK_RF_IN_P0)
    ,.FUNC_WEN_RF_IN_P0             (FUNC_WEN_RF_IN_P0[6])
    ,.FUNC_WR_ADDR_RF_IN_P0         (FUNC_WR_ADDR_RF_IN_P0[55:48])
    ,.FUNC_WR_DATA_RF_IN_P0         (FUNC_WR_DATA_RF_IN_P0[181:156])

    ,.FUNC_CM_CLK_RF_IN_P0          (FUNC_CM_CLK_RF_IN_P0)
    ,.FUNC_CEN_RF_IN_P0             (FUNC_CEN_RF_IN_P0[6])
    ,.FUNC_CM_DATA_RF_IN_P0         (FUNC_CM_DATA_RF_IN_P0[181:156])
    ,.CM_MATCH_RF_OUT_P0            (CM_MATCH_RF_OUT_P0[1791:1536])

    ,.BIST_RF_ENABLE                ('0)
    ,.BIST_WR_CLK_RF_IN_P0          ('0)
    ,.BIST_WEN_RF_IN_P0             ('0)
    ,.BIST_WR_ADDR_RF_IN_P0         ('0)
    ,.BIST_WR_DATA_RF_IN_P0         ('0)
    ,.BIST_RD_CLK_RF_IN_P0          ('0)
    ,.BIST_REN_RF_IN_P0             ('0)
    ,.BIST_RD_ADDR_RF_IN_P0         ('0)

    ,.BIST_CM_CLK_RF_IN_P0          ('0)
    ,.BIST_CEN_RF_IN_P0             ('0)
    ,.BIST_CM_DATA_RF_IN_P0         ('0)
    ,.BIST_CM_MODE_RF_IN            ('0)
    ,.BIST_ROTATE_MASK_RF_IN        ('0)
    ,.BIST_CD_MASK_ENABLE_RF_IN     ('0)
    ,.BIST_DATA_INV_RF_IN           ('0)
    ,.BIST_CM_MATCH_SEL0_RF_IN      ('0)
    ,.BIST_CM_MATCH_SEL1_RF_IN      ('0)

    ,.CLK_DFX_WRAPPER               (CLK_DFX_WRAPPER)
    ,.DFX_MISC_RF_IN                ({19'b0, ip_reset_b_sync})
    ,.DFX_MISC_RF_OUT               ()

    ,.FSCAN_RAM_WRDIS_B             ('1)
    ,.FSCAN_RAM_RDDIS_B             ('1)
    ,.FSCAN_RAM_ODIS_B              ('1)

    ,.FUSE_MISC_RF_IN               ('0)

    ,.UNGATE_BIST_WRTEN             ('1)

    ,.FSCAN_BYPRST_B                (fscan_byprst_b)
    ,.FSCAN_RSTBYPEN                (fscan_rstbypen)
    ,.FSCAN_RAM_BYPSEL              ('0)
    ,.FSCAN_RAM_AWT_MODE            ('0)
    ,.FSCAN_RAM_AWT_WEN             ('0)
    ,.FSCAN_RAM_AWT_REN             ('0)
    ,.FSCAN_MODE                    ('0)

    ,.FSCAN_RAM_INIT_EN             ('0)
    ,.FSCAN_RAM_INIT_VAL            ('0)

    ,.LBIST_TEST_MODE               ('0)

    ,.flcp_fd                       ({4{fd}})
    ,.flcp_rd                       ({4{rd}})

    ,.PWR_MGMT_MISC_RF_IN           ('0)
    ,.PWR_MGMT_MISC_RF_OUT          ()
);

srf026b256e1r1w1cbbeheaa0aaw_dfx_wrapper #(.MBIST_CAM_WRAPPER(1), .CAM_MATCH_ATPG_EN(1)) i_bcam_b5 (

     .FUNC_RD_CLK_RF_IN_P0          (FUNC_RD_CLK_RF_IN_P0)
    ,.FUNC_REN_RF_IN_P0             (FUNC_REN_RF_IN_P0)
    ,.FUNC_RD_ADDR_RF_IN_P0         (FUNC_RD_ADDR_RF_IN_P0)
    ,.DATA_RF_OUT_P0                (DATA_RF_OUT_P0[155:130])

    ,.FUNC_WR_CLK_RF_IN_P0          (FUNC_WR_CLK_RF_IN_P0)
    ,.FUNC_WEN_RF_IN_P0             (FUNC_WEN_RF_IN_P0[5])
    ,.FUNC_WR_ADDR_RF_IN_P0         (FUNC_WR_ADDR_RF_IN_P0[47:40])
    ,.FUNC_WR_DATA_RF_IN_P0         (FUNC_WR_DATA_RF_IN_P0[155:130])

    ,.FUNC_CM_CLK_RF_IN_P0          (FUNC_CM_CLK_RF_IN_P0)
    ,.FUNC_CEN_RF_IN_P0             (FUNC_CEN_RF_IN_P0[5])
    ,.FUNC_CM_DATA_RF_IN_P0         (FUNC_CM_DATA_RF_IN_P0[155:130])
    ,.CM_MATCH_RF_OUT_P0            (CM_MATCH_RF_OUT_P0[1535:1280])
    ,.BIST_RF_ENABLE                ('0)
    ,.BIST_WR_CLK_RF_IN_P0          ('0)
    ,.BIST_WEN_RF_IN_P0             ('0)
    ,.BIST_WR_ADDR_RF_IN_P0         ('0)
    ,.BIST_WR_DATA_RF_IN_P0         ('0)
    ,.BIST_RD_CLK_RF_IN_P0          ('0)
    ,.BIST_REN_RF_IN_P0             ('0)
    ,.BIST_RD_ADDR_RF_IN_P0         ('0)

    ,.BIST_CM_CLK_RF_IN_P0          ('0)
    ,.BIST_CEN_RF_IN_P0             ('0)
    ,.BIST_CM_DATA_RF_IN_P0         ('0)
    ,.BIST_CM_MODE_RF_IN            ('0)
    ,.BIST_ROTATE_MASK_RF_IN        ('0)
    ,.BIST_CD_MASK_ENABLE_RF_IN     ('0)
    ,.BIST_DATA_INV_RF_IN           ('0)
    ,.BIST_CM_MATCH_SEL0_RF_IN      ('0)
    ,.BIST_CM_MATCH_SEL1_RF_IN      ('0)

    ,.CLK_DFX_WRAPPER               (CLK_DFX_WRAPPER)
    ,.DFX_MISC_RF_IN                ({19'b0, ip_reset_b_sync})
    ,.DFX_MISC_RF_OUT               ()

    ,.FSCAN_RAM_WRDIS_B             ('1)
    ,.FSCAN_RAM_RDDIS_B             ('1)
    ,.FSCAN_RAM_ODIS_B              ('1)

    ,.FUSE_MISC_RF_IN               ('0)

    ,.UNGATE_BIST_WRTEN             ('1)

    ,.FSCAN_BYPRST_B                (fscan_byprst_b)
    ,.FSCAN_RSTBYPEN                (fscan_rstbypen)
    ,.FSCAN_RAM_BYPSEL              ('0)
    ,.FSCAN_RAM_AWT_MODE            ('0)
    ,.FSCAN_RAM_AWT_WEN             ('0)
    ,.FSCAN_RAM_AWT_REN             ('0)
    ,.FSCAN_MODE                    ('0)

    ,.FSCAN_RAM_INIT_EN             ('0)
    ,.FSCAN_RAM_INIT_VAL            ('0)

    ,.LBIST_TEST_MODE               ('0)

    ,.flcp_fd                       ({4{fd}})
    ,.flcp_rd                       ({4{rd}})

    ,.PWR_MGMT_MISC_RF_IN           ('0)
    ,.PWR_MGMT_MISC_RF_OUT          ()
);

srf026b256e1r1w1cbbeheaa0aaw_dfx_wrapper #(.MBIST_CAM_WRAPPER(1), .CAM_MATCH_ATPG_EN(1)) i_bcam_b4 (

     .FUNC_RD_CLK_RF_IN_P0          (FUNC_RD_CLK_RF_IN_P0)
    ,.FUNC_REN_RF_IN_P0             (FUNC_REN_RF_IN_P0)
    ,.FUNC_RD_ADDR_RF_IN_P0         (FUNC_RD_ADDR_RF_IN_P0)
    ,.DATA_RF_OUT_P0                (DATA_RF_OUT_P0[129:104])

    ,.FUNC_WR_CLK_RF_IN_P0          (FUNC_WR_CLK_RF_IN_P0)
    ,.FUNC_WEN_RF_IN_P0             (FUNC_WEN_RF_IN_P0[4])
    ,.FUNC_WR_ADDR_RF_IN_P0         (FUNC_WR_ADDR_RF_IN_P0[39:32])
    ,.FUNC_WR_DATA_RF_IN_P0         (FUNC_WR_DATA_RF_IN_P0[129:104])

    ,.FUNC_CM_CLK_RF_IN_P0          (FUNC_CM_CLK_RF_IN_P0)
    ,.FUNC_CEN_RF_IN_P0             (FUNC_CEN_RF_IN_P0[4])
    ,.FUNC_CM_DATA_RF_IN_P0         (FUNC_CM_DATA_RF_IN_P0[129:104])
    ,.CM_MATCH_RF_OUT_P0            (CM_MATCH_RF_OUT_P0[1279:1024])
    ,.BIST_RF_ENABLE                ('0)
    ,.BIST_WR_CLK_RF_IN_P0          ('0)
    ,.BIST_WEN_RF_IN_P0             ('0)
    ,.BIST_WR_ADDR_RF_IN_P0         ('0)
    ,.BIST_WR_DATA_RF_IN_P0         ('0)
    ,.BIST_RD_CLK_RF_IN_P0          ('0)
    ,.BIST_REN_RF_IN_P0             ('0)
    ,.BIST_RD_ADDR_RF_IN_P0         ('0)

    ,.BIST_CM_CLK_RF_IN_P0          ('0)
    ,.BIST_CEN_RF_IN_P0             ('0)
    ,.BIST_CM_DATA_RF_IN_P0         ('0)
    ,.BIST_CM_MODE_RF_IN            ('0)
    ,.BIST_ROTATE_MASK_RF_IN        ('0)
    ,.BIST_CD_MASK_ENABLE_RF_IN     ('0)
    ,.BIST_DATA_INV_RF_IN           ('0)
    ,.BIST_CM_MATCH_SEL0_RF_IN      ('0)
    ,.BIST_CM_MATCH_SEL1_RF_IN      ('0)

    ,.CLK_DFX_WRAPPER               (CLK_DFX_WRAPPER)
    ,.DFX_MISC_RF_IN                ({19'b0, ip_reset_b_sync})
    ,.DFX_MISC_RF_OUT               ()

    ,.FSCAN_RAM_WRDIS_B             ('1)
    ,.FSCAN_RAM_RDDIS_B             ('1)
    ,.FSCAN_RAM_ODIS_B              ('1)

    ,.FUSE_MISC_RF_IN               ('0)

    ,.UNGATE_BIST_WRTEN             ('1)

    ,.FSCAN_BYPRST_B                (fscan_byprst_b)
    ,.FSCAN_RSTBYPEN                (fscan_rstbypen)
    ,.FSCAN_RAM_BYPSEL              ('0)
    ,.FSCAN_RAM_AWT_MODE            ('0)
    ,.FSCAN_RAM_AWT_WEN             ('0)
    ,.FSCAN_RAM_AWT_REN             ('0)
    ,.FSCAN_MODE                    ('0)

    ,.FSCAN_RAM_INIT_EN             ('0)
    ,.FSCAN_RAM_INIT_VAL            ('0)

    ,.LBIST_TEST_MODE               ('0)

    ,.flcp_fd                       ({4{fd}})
    ,.flcp_rd                       ({4{rd}})

    ,.PWR_MGMT_MISC_RF_IN           ('0)
    ,.PWR_MGMT_MISC_RF_OUT          ()
);

srf026b256e1r1w1cbbeheaa0aaw_dfx_wrapper #(.MBIST_CAM_WRAPPER(1), .CAM_MATCH_ATPG_EN(1)) i_bcam_b3 (

     .FUNC_RD_CLK_RF_IN_P0          (FUNC_RD_CLK_RF_IN_P0)
    ,.FUNC_REN_RF_IN_P0             (FUNC_REN_RF_IN_P0)
    ,.FUNC_RD_ADDR_RF_IN_P0         (FUNC_RD_ADDR_RF_IN_P0)
    ,.DATA_RF_OUT_P0                (DATA_RF_OUT_P0[103:78])

    ,.FUNC_WR_CLK_RF_IN_P0          (FUNC_WR_CLK_RF_IN_P0)
    ,.FUNC_WEN_RF_IN_P0             (FUNC_WEN_RF_IN_P0[3])
    ,.FUNC_WR_ADDR_RF_IN_P0         (FUNC_WR_ADDR_RF_IN_P0[31:24])
    ,.FUNC_WR_DATA_RF_IN_P0         (FUNC_WR_DATA_RF_IN_P0[103:78])

    ,.FUNC_CM_CLK_RF_IN_P0          (FUNC_CM_CLK_RF_IN_P0)
    ,.FUNC_CEN_RF_IN_P0             (FUNC_CEN_RF_IN_P0[3])
    ,.FUNC_CM_DATA_RF_IN_P0         (FUNC_CM_DATA_RF_IN_P0[103:78])
    ,.CM_MATCH_RF_OUT_P0            (CM_MATCH_RF_OUT_P0[1023:768])
    ,.BIST_RF_ENABLE                ('0)
    ,.BIST_WR_CLK_RF_IN_P0          ('0)
    ,.BIST_WEN_RF_IN_P0             ('0)
    ,.BIST_WR_ADDR_RF_IN_P0         ('0)
    ,.BIST_WR_DATA_RF_IN_P0         ('0)
    ,.BIST_RD_CLK_RF_IN_P0          ('0)
    ,.BIST_REN_RF_IN_P0             ('0)
    ,.BIST_RD_ADDR_RF_IN_P0         ('0)

    ,.BIST_CM_CLK_RF_IN_P0          ('0)
    ,.BIST_CEN_RF_IN_P0             ('0)
    ,.BIST_CM_DATA_RF_IN_P0         ('0)
    ,.BIST_CM_MODE_RF_IN            ('0)
    ,.BIST_ROTATE_MASK_RF_IN        ('0)
    ,.BIST_CD_MASK_ENABLE_RF_IN     ('0)
    ,.BIST_DATA_INV_RF_IN           ('0)
    ,.BIST_CM_MATCH_SEL0_RF_IN      ('0)
    ,.BIST_CM_MATCH_SEL1_RF_IN      ('0)

    ,.CLK_DFX_WRAPPER               (CLK_DFX_WRAPPER)
    ,.DFX_MISC_RF_IN                ({19'b0, ip_reset_b_sync})
    ,.DFX_MISC_RF_OUT               ()

    ,.FSCAN_RAM_WRDIS_B             ('1)
    ,.FSCAN_RAM_RDDIS_B             ('1)
    ,.FSCAN_RAM_ODIS_B              ('1)

    ,.FUSE_MISC_RF_IN               ('0)

    ,.UNGATE_BIST_WRTEN             ('1)

    ,.FSCAN_BYPRST_B                (fscan_byprst_b)
    ,.FSCAN_RSTBYPEN                (fscan_rstbypen)
    ,.FSCAN_RAM_BYPSEL              ('0)
    ,.FSCAN_RAM_AWT_MODE            ('0)
    ,.FSCAN_RAM_AWT_WEN             ('0)
    ,.FSCAN_RAM_AWT_REN             ('0)
    ,.FSCAN_MODE                    ('0)

    ,.FSCAN_RAM_INIT_EN             ('0)
    ,.FSCAN_RAM_INIT_VAL            ('0)

    ,.LBIST_TEST_MODE               ('0)

    ,.flcp_fd                       ({4{fd}})
    ,.flcp_rd                       ({4{rd}})

    ,.PWR_MGMT_MISC_RF_IN           ('0)
    ,.PWR_MGMT_MISC_RF_OUT          ()
);

srf026b256e1r1w1cbbeheaa0aaw_dfx_wrapper #(.MBIST_CAM_WRAPPER(1), .CAM_MATCH_ATPG_EN(1)) i_bcam_b2 (

     .FUNC_RD_CLK_RF_IN_P0          (FUNC_RD_CLK_RF_IN_P0)
    ,.FUNC_REN_RF_IN_P0             (FUNC_REN_RF_IN_P0)
    ,.FUNC_RD_ADDR_RF_IN_P0         (FUNC_RD_ADDR_RF_IN_P0)
    ,.DATA_RF_OUT_P0                (DATA_RF_OUT_P0[77:52])

    ,.FUNC_WR_CLK_RF_IN_P0          (FUNC_WR_CLK_RF_IN_P0)
    ,.FUNC_WEN_RF_IN_P0             (FUNC_WEN_RF_IN_P0[2])
    ,.FUNC_WR_ADDR_RF_IN_P0         (FUNC_WR_ADDR_RF_IN_P0[23:16])
    ,.FUNC_WR_DATA_RF_IN_P0         (FUNC_WR_DATA_RF_IN_P0[77:52])

    ,.FUNC_CM_CLK_RF_IN_P0          (FUNC_CM_CLK_RF_IN_P0)
    ,.FUNC_CEN_RF_IN_P0             (FUNC_CEN_RF_IN_P0[2])
    ,.FUNC_CM_DATA_RF_IN_P0         (FUNC_CM_DATA_RF_IN_P0[77:52])
    ,.CM_MATCH_RF_OUT_P0            (CM_MATCH_RF_OUT_P0[767:512])
    ,.BIST_RF_ENABLE                ('0)
    ,.BIST_WR_CLK_RF_IN_P0          ('0)
    ,.BIST_WEN_RF_IN_P0             ('0)
    ,.BIST_WR_ADDR_RF_IN_P0         ('0)
    ,.BIST_WR_DATA_RF_IN_P0         ('0)
    ,.BIST_RD_CLK_RF_IN_P0          ('0)
    ,.BIST_REN_RF_IN_P0             ('0)
    ,.BIST_RD_ADDR_RF_IN_P0         ('0)

    ,.BIST_CM_CLK_RF_IN_P0          ('0)
    ,.BIST_CEN_RF_IN_P0             ('0)
    ,.BIST_CM_DATA_RF_IN_P0         ('0)
    ,.BIST_CM_MODE_RF_IN            ('0)
    ,.BIST_ROTATE_MASK_RF_IN        ('0)
    ,.BIST_CD_MASK_ENABLE_RF_IN     ('0)
    ,.BIST_DATA_INV_RF_IN           ('0)
    ,.BIST_CM_MATCH_SEL0_RF_IN      ('0)
    ,.BIST_CM_MATCH_SEL1_RF_IN      ('0)

    ,.CLK_DFX_WRAPPER               (CLK_DFX_WRAPPER)
    ,.DFX_MISC_RF_IN                ({19'b0, ip_reset_b_sync})
    ,.DFX_MISC_RF_OUT               ()

    ,.FSCAN_RAM_WRDIS_B             ('1)
    ,.FSCAN_RAM_RDDIS_B             ('1)
    ,.FSCAN_RAM_ODIS_B              ('1)

    ,.FUSE_MISC_RF_IN               ('0)

    ,.UNGATE_BIST_WRTEN             ('1)

    ,.FSCAN_BYPRST_B                (fscan_byprst_b)
    ,.FSCAN_RSTBYPEN                (fscan_rstbypen)
    ,.FSCAN_RAM_BYPSEL              ('0)
    ,.FSCAN_RAM_AWT_MODE            ('0)
    ,.FSCAN_RAM_AWT_WEN             ('0)
    ,.FSCAN_RAM_AWT_REN             ('0)
    ,.FSCAN_MODE                    ('0)

    ,.FSCAN_RAM_INIT_EN             ('0)
    ,.FSCAN_RAM_INIT_VAL            ('0)

    ,.LBIST_TEST_MODE               ('0)

    ,.flcp_fd                       ({4{fd}})
    ,.flcp_rd                       ({4{rd}})

    ,.PWR_MGMT_MISC_RF_IN           ('0)
    ,.PWR_MGMT_MISC_RF_OUT          ()
);

srf026b256e1r1w1cbbeheaa0aaw_dfx_wrapper #(.MBIST_CAM_WRAPPER(1), .CAM_MATCH_ATPG_EN(1)) i_bcam_b1 (

     .FUNC_RD_CLK_RF_IN_P0          (FUNC_RD_CLK_RF_IN_P0)
    ,.FUNC_REN_RF_IN_P0             (FUNC_REN_RF_IN_P0)
    ,.FUNC_RD_ADDR_RF_IN_P0         (FUNC_RD_ADDR_RF_IN_P0)
    ,.DATA_RF_OUT_P0                (DATA_RF_OUT_P0[51:26])

    ,.FUNC_WR_CLK_RF_IN_P0          (FUNC_WR_CLK_RF_IN_P0)
    ,.FUNC_WEN_RF_IN_P0             (FUNC_WEN_RF_IN_P0[1])
    ,.FUNC_WR_ADDR_RF_IN_P0         (FUNC_WR_ADDR_RF_IN_P0[15:8])
    ,.FUNC_WR_DATA_RF_IN_P0         (FUNC_WR_DATA_RF_IN_P0[51:26])

    ,.FUNC_CM_CLK_RF_IN_P0          (FUNC_CM_CLK_RF_IN_P0)
    ,.FUNC_CEN_RF_IN_P0             (FUNC_CEN_RF_IN_P0[1])
    ,.FUNC_CM_DATA_RF_IN_P0         (FUNC_CM_DATA_RF_IN_P0[51:26])
    ,.CM_MATCH_RF_OUT_P0            (CM_MATCH_RF_OUT_P0[511:256])
    ,.BIST_RF_ENABLE                ('0)
    ,.BIST_WR_CLK_RF_IN_P0          ('0)
    ,.BIST_WEN_RF_IN_P0             ('0)
    ,.BIST_WR_ADDR_RF_IN_P0         ('0)
    ,.BIST_WR_DATA_RF_IN_P0         ('0)
    ,.BIST_RD_CLK_RF_IN_P0          ('0)
    ,.BIST_REN_RF_IN_P0             ('0)
    ,.BIST_RD_ADDR_RF_IN_P0         ('0)

    ,.BIST_CM_CLK_RF_IN_P0          ('0)
    ,.BIST_CEN_RF_IN_P0             ('0)
    ,.BIST_CM_DATA_RF_IN_P0         ('0)
    ,.BIST_CM_MODE_RF_IN            ('0)
    ,.BIST_ROTATE_MASK_RF_IN        ('0)
    ,.BIST_CD_MASK_ENABLE_RF_IN     ('0)
    ,.BIST_DATA_INV_RF_IN           ('0)
    ,.BIST_CM_MATCH_SEL0_RF_IN      ('0)
    ,.BIST_CM_MATCH_SEL1_RF_IN      ('0)

    ,.CLK_DFX_WRAPPER               (CLK_DFX_WRAPPER)
    ,.DFX_MISC_RF_IN                ({19'b0, ip_reset_b_sync})
    ,.DFX_MISC_RF_OUT               ()

    ,.FSCAN_RAM_WRDIS_B             ('1)
    ,.FSCAN_RAM_RDDIS_B             ('1)
    ,.FSCAN_RAM_ODIS_B              ('1)

    ,.FUSE_MISC_RF_IN               ('0)

    ,.UNGATE_BIST_WRTEN             ('1)

    ,.FSCAN_BYPRST_B                (fscan_byprst_b)
    ,.FSCAN_RSTBYPEN                (fscan_rstbypen)
    ,.FSCAN_RAM_BYPSEL              ('0)
    ,.FSCAN_RAM_AWT_MODE            ('0)
    ,.FSCAN_RAM_AWT_WEN             ('0)
    ,.FSCAN_RAM_AWT_REN             ('0)
    ,.FSCAN_MODE                    ('0)

    ,.FSCAN_RAM_INIT_EN             ('0)
    ,.FSCAN_RAM_INIT_VAL            ('0)

    ,.LBIST_TEST_MODE               ('0)

    ,.flcp_fd                       ({4{fd}})
    ,.flcp_rd                       ({4{rd}})

    ,.PWR_MGMT_MISC_RF_IN           ('0)
    ,.PWR_MGMT_MISC_RF_OUT          ()
);

srf026b256e1r1w1cbbeheaa0aaw_dfx_wrapper #(.MBIST_CAM_WRAPPER(1), .CAM_MATCH_ATPG_EN(1)) i_bcam_b0 (

     .FUNC_RD_CLK_RF_IN_P0          (FUNC_RD_CLK_RF_IN_P0)
    ,.FUNC_REN_RF_IN_P0             (FUNC_REN_RF_IN_P0)
    ,.FUNC_RD_ADDR_RF_IN_P0         (FUNC_RD_ADDR_RF_IN_P0)
    ,.DATA_RF_OUT_P0                (DATA_RF_OUT_P0[25:0])

    ,.FUNC_WR_CLK_RF_IN_P0          (FUNC_WR_CLK_RF_IN_P0)
    ,.FUNC_WEN_RF_IN_P0             (FUNC_WEN_RF_IN_P0[0])
    ,.FUNC_WR_ADDR_RF_IN_P0         (FUNC_WR_ADDR_RF_IN_P0[7:0])
    ,.FUNC_WR_DATA_RF_IN_P0         (FUNC_WR_DATA_RF_IN_P0[25:0])

    ,.FUNC_CM_CLK_RF_IN_P0          (FUNC_CM_CLK_RF_IN_P0)
    ,.FUNC_CEN_RF_IN_P0             (FUNC_CEN_RF_IN_P0[0])
    ,.FUNC_CM_DATA_RF_IN_P0         (FUNC_CM_DATA_RF_IN_P0[25:0])
    ,.CM_MATCH_RF_OUT_P0            (CM_MATCH_RF_OUT_P0[255:0])
    ,.BIST_RF_ENABLE                ('0)
    ,.BIST_WR_CLK_RF_IN_P0          ('0)
    ,.BIST_WEN_RF_IN_P0             ('0)
    ,.BIST_WR_ADDR_RF_IN_P0         ('0)
    ,.BIST_WR_DATA_RF_IN_P0         ('0)
    ,.BIST_RD_CLK_RF_IN_P0          ('0)
    ,.BIST_REN_RF_IN_P0             ('0)
    ,.BIST_RD_ADDR_RF_IN_P0         ('0)

    ,.BIST_CM_CLK_RF_IN_P0          ('0)
    ,.BIST_CEN_RF_IN_P0             ('0)
    ,.BIST_CM_DATA_RF_IN_P0         ('0)
    ,.BIST_CM_MODE_RF_IN            ('0)
    ,.BIST_ROTATE_MASK_RF_IN        ('0)
    ,.BIST_CD_MASK_ENABLE_RF_IN     ('0)
    ,.BIST_DATA_INV_RF_IN           ('0)
    ,.BIST_CM_MATCH_SEL0_RF_IN      ('0)
    ,.BIST_CM_MATCH_SEL1_RF_IN      ('0)

    ,.CLK_DFX_WRAPPER               (CLK_DFX_WRAPPER)
    ,.DFX_MISC_RF_IN                ({19'b0, ip_reset_b_sync})
    ,.DFX_MISC_RF_OUT               ()

    ,.FSCAN_RAM_WRDIS_B             ('1)
    ,.FSCAN_RAM_RDDIS_B             ('1)
    ,.FSCAN_RAM_ODIS_B              ('1)

    ,.FUSE_MISC_RF_IN               ('0)

    ,.UNGATE_BIST_WRTEN             ('1)

    ,.FSCAN_BYPRST_B                (fscan_byprst_b)
    ,.FSCAN_RSTBYPEN                (fscan_rstbypen)
    ,.FSCAN_RAM_BYPSEL              ('0)
    ,.FSCAN_RAM_AWT_MODE            ('0)
    ,.FSCAN_RAM_AWT_WEN             ('0)
    ,.FSCAN_RAM_AWT_REN             ('0)
    ,.FSCAN_MODE                    ('0)

    ,.FSCAN_RAM_INIT_EN             ('0)
    ,.FSCAN_RAM_INIT_VAL            ('0)

    ,.LBIST_TEST_MODE               ('0)

    ,.flcp_fd                       ({4{fd}})
    ,.flcp_rd                       ({4{rd}})

    ,.PWR_MGMT_MISC_RF_IN           ('0)
    ,.PWR_MGMT_MISC_RF_OUT          ()
);

endmodule // hqm_AW_bcam_2048x26

