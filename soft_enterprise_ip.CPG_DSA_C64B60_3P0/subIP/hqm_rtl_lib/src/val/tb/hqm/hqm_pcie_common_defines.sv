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

`ifndef HQM_PCIE_COMMON_DEF_
`define HQM_PCIE_COMMON_DEF_

  // PCIe Register numbers //
  `define DEV_COMMAND_REG					32'h_0000_0001
  `define FUNC_BAR_U_REG					32'h_0000_0005
  `define CSR_BAR_U_REG						32'h_0000_0007

  `define SRIOV_NUM_VF_CFG_REG				32'h_0000_0046
  `define SRIOV_CAP_VF_OFFSET_N_STRIDE_REG	32'h_0000_0047

  `define CFG_DIAGNOSTIC_RESET_STATUS		32'h_2e00_0002


  `define CREDIT_HIST_PIPE_BASE				32'h_a000_0000

  `define CSR_BAR							64'h_0000_0001_0000_0000

  `define HQM_PF_FLR_WAIT_WITH_HCW  500
  //HQM constants//
  `define MAX_NO_OF_VFS			16
  `define HQM_SRIOV_VF_STRIDE	 1
  `define HQM_SRIOV_VF_OFFSET	 8
  `define HQM_LDB_QUEUES		256

  `define DIR_PORT_CNT    128
  `define LDB_PORT_CNT    64
  `define DOMAIN_CNT      1
  `define PF_CNT          1
  `define VF_CNT          16
  `define VAS_CNT         32
  `define QID_CNT         128
  
  `define LDB_CREDITS     16384
  `define DIR_CREDITS     4096
  `define LDB_POOL_CNT    64
  `define DIR_POOL_CNT    64
  
  `define MAX_INFLIGHT_HCW    4096
  
  `define PORT_DISABLE    00
  `define PP_ONLY_PORT    01
  `define CP_ONLY_PORT    02
  `define PP_CP_PORT      03
  
  `define DIR_PORT        01
  `define LDB_PORT        02
  
  `define PF0_ID          32'hfffe

  //Following two are temporary//
  `define HQM_LDB_POOLS			64
  `define HQM_NUM_VAS			32

  //MSIX_VECTOR values
  `define HQM_NUM_MSIX_VECTOR   65
  `define HQM_ALARM_MSIX_VECTOR 0

  // -- HQM BAR SIZES -- // 
  `define HQM_PF_FUNC_BAR_SIZE 64'h_0000_0000_03ff_ffff
  `define HQM_PF_CSR_BAR_SIZE  64'h_0000_0000_ffff_ffff
  `define HQM_VF_BAR_SIZE      64'h_0000_0000_03ff_ffff

  `define HQM_SYS_PAGE_SIZE    64'h_0000_0000_0000_1000
  `define HQM_CLASS_CODE       24'h_0b40_00
  `define HQM_POLL_REG_ITER    100
  // -- IMS_VECTOR values -- //
  `define HQM_NUM_IMS_VECTOR   64
  `define HQM_NUM_IMS_VECTOR_DIR   64
  `define IMS_INT_ADDR_31_20   12'h_fee
  `define IMS_INT_DATA_31_16   16'h_0000

  // -- Max PCIe spec values -- //
  `define PCIE_MAX_TLP_LENGTH  1024

  // -- PF and VF unimp addr -- // 
  `define HQM_PF_UNIMP_START_ADDR 'h_1b8
  `define HQM_VF_UNIMP_START_ADDR 'h_198
`endif
