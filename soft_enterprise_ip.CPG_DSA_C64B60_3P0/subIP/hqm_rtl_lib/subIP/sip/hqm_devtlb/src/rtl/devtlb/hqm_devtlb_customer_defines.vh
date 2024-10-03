//======================================================================================================================
//
// iommu_customer_defines.vh
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// Intel Proprietary and Top Secret Information
// Copyright (c) 2012-2014 Intel Corporation
//
//======================================================================================================================

`ifndef HQM_DEVTLB_CUSTOMER_DEFINES_VH
`define HQM_DEVTLB_CUSTOMER_DEFINES_VH


// Placeholders for custom RF DFX/BIST connections.
// PORTDEC is a list of declarations for the DFX/BIST signals that need to be connected between the IOMMU interface and the Custom RF block
`ifndef HQM_DEVTLB_CUSTOM_RF_PORTDEC
`define HQM_DEVTLB_CUSTOM_RF_PORTDEC
`endif
`ifndef HQM_DEVTLB_CUSTOM_MISCRF_PORTDEC
`define HQM_DEVTLB_CUSTOM_MISCRF_PORTDEC
`endif
// PORTLIST is a comma separated list of the DFX/BIST signals that need to be connected between the IOMMU interface and the Custom RF block
`ifndef HQM_DEVTLB_CUSTOM_RF_PORTLIST
`define HQM_DEVTLB_CUSTOM_RF_PORTLIST
`endif
`ifndef HQM_DEVTLB_CUSTOM_MISCRF_PORTLIST
`define HQM_DEVTLB_CUSTOM_MISCRF_PORTLIST
`endif
// PORTCON is a the interface connectivity of signals for the DFX/BIST controls that need to be connected between the IOMMU top level and the Custom RF block
`ifndef HQM_DEVTLB_CUSTOM_RF_PORTCON
`define HQM_DEVTLB_CUSTOM_RF_PORTCON
`endif

`ifndef HQM_DEVTLB_CUSTOM_RF_PARAMDEC
`define HQM_DEVTLB_CUSTOM_RF_PARAMDEC
`endif

`endif // DEVTLB_CUSTOMER_DEFINES_VH
