//=====================================================================================================================
//
// iommu_custom_rf_external.sv
//
// Contacts            : Camron Rust
// Original Author(s)  : Camron Rust
// Original Date       : 10/2014
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

`ifndef HQM_DEVTLB_CUSTOM_RF_EXTERNAL_VS
`define HQM_DEVTLB_CUSTOM_RF_EXTERNAL_VS


// Each IOTLB Array is organized in multiple ways. As such, some inputs are shared.
// All ways of the same level IOTLB (4k, 2m, or 1g) share the same read enable, read address, write address, and write data.
// Each way of the same level IOTLB (4k, 2m, or 1g) will have its own write enable and read data.
// The write data for each level's tag  is largely the same except each succesive higher order array drops 9 bits from the lower end.
// The write data for each level's data is largely the same except each succesive higher order array drops 9 bits from the lower end.
//
// IOTLB 4k
T_IO_TAG_ENTRY_4K [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]          EXT_RF_IOTLB_4k_Tag_RdData_c; 
T_IO_TAG_ENTRY_4K [DEVTLB_XREQ_PORTNUM-1:0]                                   EXT_RF_IOTLB_4k_Tag_WrData_c;
always_comb begin
//assign RF_IOTLB_4k_Tag_RdData       = EXT_RF_IOTLB_4k_Tag_RdData;
    RF_IOTLB_4k_Tag_RdData = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        for (int j=0; j<DEVTLB_TLB_NUM_WAYS; j++) begin
            EXT_RF_IOTLB_4k_Tag_RdData_c[i][j]   = T_IO_TAG_ENTRY_4K'(EXT_RF_IOTLB_4k_Tag_RdData[i][j]);
            RF_IOTLB_4k_Tag_RdData[i][j].ValidSL = EXT_RF_IOTLB_4k_Tag_RdData_c[i][j].ValidSL;
            RF_IOTLB_4k_Tag_RdData[i][j].ValidFL = EXT_RF_IOTLB_4k_Tag_RdData_c[i][j].ValidFL;
            RF_IOTLB_4k_Tag_RdData[i][j].Parity  = EXT_RF_IOTLB_4k_Tag_RdData_c[i][j].Parity;
            RF_IOTLB_4k_Tag_RdData[i][j].Address = EXT_RF_IOTLB_4k_Tag_RdData_c[i][j].Address;
            RF_IOTLB_4k_Tag_RdData[i][j].BDF     = EXT_RF_IOTLB_4k_Tag_RdData_c[i][j].BDF;
            RF_IOTLB_4k_Tag_RdData[i][j].PASID   = EXT_RF_IOTLB_4k_Tag_RdData_c[i][j].PASID;
            //RF_IOTLB_4k_Tag_RdData[i][j].Global  = EXT_RF_IOTLB_4k_Tag_RdData_c[i][j].Global;
            RF_IOTLB_4k_Tag_RdData[i][j].PR      = EXT_RF_IOTLB_4k_Tag_RdData_c[i][j].PR;
        end
    end
    EXT_RF_IOTLB_4k_Tag_RdEn     = RF_IOTLB_4k_Tag_RdEn;
    EXT_RF_IOTLB_4k_Tag_RdAddr   = RF_IOTLB_4k_Tag_RdAddr;

    EXT_RF_IOTLB_4k_Tag_WrEn     = RF_IOTLB_4k_Tag_WrEn;
    EXT_RF_IOTLB_4k_Tag_WrAddr   = RF_IOTLB_4k_Tag_WrAddr;
    EXT_RF_IOTLB_4k_Tag_WrData_c = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        EXT_RF_IOTLB_4k_Tag_WrData_c[i].ValidSL  = RF_IOTLB_4k_Tag_WrData[i].ValidSL;
        EXT_RF_IOTLB_4k_Tag_WrData_c[i].ValidFL  = RF_IOTLB_4k_Tag_WrData[i].ValidFL;
        EXT_RF_IOTLB_4k_Tag_WrData_c[i].Parity   = RF_IOTLB_4k_Tag_WrData[i].Parity;
        EXT_RF_IOTLB_4k_Tag_WrData_c[i].Address  = RF_IOTLB_4k_Tag_WrData[i].Address;
        EXT_RF_IOTLB_4k_Tag_WrData_c[i].BDF      = RF_IOTLB_4k_Tag_WrData[i].BDF;
        EXT_RF_IOTLB_4k_Tag_WrData_c[i].PASID    = RF_IOTLB_4k_Tag_WrData[i].PASID;
        //EXT_RF_IOTLB_4k_Tag_WrData_c[i].Global   = RF_IOTLB_4k_Tag_WrData[i].Global;
        EXT_RF_IOTLB_4k_Tag_WrData_c[i].PR       = RF_IOTLB_4k_Tag_WrData[i].PR;
        EXT_RF_IOTLB_4k_Tag_WrData[i] = EXT_RF_IOTLB_4k_Tag_WrData_c[i];
    end
end

T_IO_DATA_ENTRY_4K [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]          EXT_RF_IOTLB_4k_Data_RdData_c; 
T_IO_DATA_ENTRY_4K [DEVTLB_XREQ_PORTNUM-1:0]                                   EXT_RF_IOTLB_4k_Data_WrData_c;
always_comb begin
    RF_IOTLB_4k_Data_RdData = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        for (int j=0; j<DEVTLB_TLB_NUM_WAYS; j++) begin
            EXT_RF_IOTLB_4k_Data_RdData_c[i][j]    = T_IO_DATA_ENTRY_4K'(EXT_RF_IOTLB_4k_Data_RdData[i][j]);
            RF_IOTLB_4k_Data_RdData[i][j].Parity   = EXT_RF_IOTLB_4k_Data_RdData_c[i][j].Parity;
            RF_IOTLB_4k_Data_RdData[i][j].U        = EXT_RF_IOTLB_4k_Data_RdData_c[i][j].RSVD;
            RF_IOTLB_4k_Data_RdData[i][j].N        = EXT_RF_IOTLB_4k_Data_RdData_c[i][j].N;
            RF_IOTLB_4k_Data_RdData[i][j].X        = '0;
            RF_IOTLB_4k_Data_RdData[i][j].R        = EXT_RF_IOTLB_4k_Data_RdData_c[i][j].R;
            RF_IOTLB_4k_Data_RdData[i][j].W        = EXT_RF_IOTLB_4k_Data_RdData_c[i][j].W;
            RF_IOTLB_4k_Data_RdData[i][j].Memtype  = '0;
            RF_IOTLB_4k_Data_RdData[i][j].Priv_Data = '0;
            RF_IOTLB_4k_Data_RdData[i][j].Address  = EXT_RF_IOTLB_4k_Data_RdData_c[i][j].Address;
        end
    end
    EXT_RF_IOTLB_4k_Data_RdEn    = RF_IOTLB_4k_Data_RdEn;
    EXT_RF_IOTLB_4k_Data_RdAddr  = RF_IOTLB_4k_Data_RdAddr;
    EXT_RF_IOTLB_4k_Data_WrEn    = RF_IOTLB_4k_Data_WrEn;
    EXT_RF_IOTLB_4k_Data_WrAddr  = RF_IOTLB_4k_Data_WrAddr;

    EXT_RF_IOTLB_4k_Data_WrData_c = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        EXT_RF_IOTLB_4k_Data_WrData_c[i].Parity   = RF_IOTLB_4k_Data_WrData[i].Parity;
        EXT_RF_IOTLB_4k_Data_WrData_c[i].RSVD     = RF_IOTLB_4k_Data_WrData[i].U;
        EXT_RF_IOTLB_4k_Data_WrData_c[i].N        = RF_IOTLB_4k_Data_WrData[i].N;
//        EXT_RF_IOTLB_4k_Data_WrData_c[i].X        = RF_IOTLB_4k_Data_WrData[i].X;
        EXT_RF_IOTLB_4k_Data_WrData_c[i].R        = RF_IOTLB_4k_Data_WrData[i].R;
        EXT_RF_IOTLB_4k_Data_WrData_c[i].W        = RF_IOTLB_4k_Data_WrData[i].W;
//        EXT_RF_IOTLB_4k_Data_WrData_c[i].Memtype  = RF_IOTLB_4k_Data_WrData[i].Memtype;
//        EXT_RF_IOTLB_4k_Data_WrData_c[i].Priv_Data= RF_IOTLB_4k_Data_WrData[i].Priv_Data;
        EXT_RF_IOTLB_4k_Data_WrData_c[i].Address  = RF_IOTLB_4k_Data_WrData[i].Address;
        EXT_RF_IOTLB_4k_Data_WrData[i]            = EXT_RF_IOTLB_4k_Data_WrData_c[i];
    end
end

// IOTLB 2m
T_IO_TAG_ENTRY_2M [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]          EXT_RF_IOTLB_2m_Tag_RdData_c; 
T_IO_TAG_ENTRY_2M [DEVTLB_XREQ_PORTNUM-1:0]                                   EXT_RF_IOTLB_2m_Tag_WrData_c;
always_comb begin
//assign RF_IOTLB_2m_Tag_RdData       = EXT_RF_IOTLB_2m_Tag_RdData;
    RF_IOTLB_2m_Tag_RdData = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        for (int j=0; j<DEVTLB_TLB_NUM_WAYS; j++) begin
            EXT_RF_IOTLB_2m_Tag_RdData_c[i][j] = T_IO_TAG_ENTRY_2M'(EXT_RF_IOTLB_2m_Tag_RdData[i][j]);
            RF_IOTLB_2m_Tag_RdData[i][j].ValidSL = EXT_RF_IOTLB_2m_Tag_RdData_c[i][j].ValidSL;
            RF_IOTLB_2m_Tag_RdData[i][j].ValidFL = EXT_RF_IOTLB_2m_Tag_RdData_c[i][j].ValidFL;
            RF_IOTLB_2m_Tag_RdData[i][j].Parity = EXT_RF_IOTLB_2m_Tag_RdData_c[i][j].Parity;
            RF_IOTLB_2m_Tag_RdData[i][j].Address = EXT_RF_IOTLB_2m_Tag_RdData_c[i][j].Address;
            RF_IOTLB_2m_Tag_RdData[i][j].BDF     = EXT_RF_IOTLB_2m_Tag_RdData_c[i][j].BDF;
            RF_IOTLB_2m_Tag_RdData[i][j].PASID   = EXT_RF_IOTLB_2m_Tag_RdData_c[i][j].PASID;
            //RF_IOTLB_2m_Tag_RdData[i][j].Global  = EXT_RF_IOTLB_2m_Tag_RdData_c[i][j].Global;
            RF_IOTLB_2m_Tag_RdData[i][j].PR      = EXT_RF_IOTLB_2m_Tag_RdData_c[i][j].PR;
        end
    end
    EXT_RF_IOTLB_2m_Tag_RdEn     = RF_IOTLB_2m_Tag_RdEn;
    EXT_RF_IOTLB_2m_Tag_RdAddr   = RF_IOTLB_2m_Tag_RdAddr;

    EXT_RF_IOTLB_2m_Tag_WrEn     = RF_IOTLB_2m_Tag_WrEn;
    EXT_RF_IOTLB_2m_Tag_WrAddr   = RF_IOTLB_2m_Tag_WrAddr;
    EXT_RF_IOTLB_2m_Tag_WrData_c = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        EXT_RF_IOTLB_2m_Tag_WrData_c[i].ValidSL  = RF_IOTLB_2m_Tag_WrData[i].ValidSL;
        EXT_RF_IOTLB_2m_Tag_WrData_c[i].ValidFL  = RF_IOTLB_2m_Tag_WrData[i].ValidFL;
        EXT_RF_IOTLB_2m_Tag_WrData_c[i].Parity   = RF_IOTLB_2m_Tag_WrData[i].Parity;
        EXT_RF_IOTLB_2m_Tag_WrData_c[i].Address  = RF_IOTLB_2m_Tag_WrData[i].Address;
        EXT_RF_IOTLB_2m_Tag_WrData_c[i].BDF      = RF_IOTLB_2m_Tag_WrData[i].BDF;
        EXT_RF_IOTLB_2m_Tag_WrData_c[i].PASID    = RF_IOTLB_2m_Tag_WrData[i].PASID;
        //EXT_RF_IOTLB_2m_Tag_WrData_c[i].Global   = RF_IOTLB_2m_Tag_WrData[i].Global;
        EXT_RF_IOTLB_2m_Tag_WrData_c[i].PR       = RF_IOTLB_2m_Tag_WrData[i].PR;
        EXT_RF_IOTLB_2m_Tag_WrData[i] = EXT_RF_IOTLB_2m_Tag_WrData_c[i];
    end
end

T_IO_DATA_ENTRY_2M [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]          EXT_RF_IOTLB_2m_Data_RdData_c; 
T_IO_DATA_ENTRY_2M [DEVTLB_XREQ_PORTNUM-1:0]                                   EXT_RF_IOTLB_2m_Data_WrData_c;
always_comb begin
    RF_IOTLB_2m_Data_RdData = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        for (int j=0; j<DEVTLB_TLB_NUM_WAYS; j++) begin
            EXT_RF_IOTLB_2m_Data_RdData_c[i][j]    = T_IO_DATA_ENTRY_2M'(EXT_RF_IOTLB_2m_Data_RdData[i][j]);
            RF_IOTLB_2m_Data_RdData[i][j].Parity   = EXT_RF_IOTLB_2m_Data_RdData_c[i][j].Parity;
            RF_IOTLB_2m_Data_RdData[i][j].U        = EXT_RF_IOTLB_2m_Data_RdData_c[i][j].RSVD;
            RF_IOTLB_2m_Data_RdData[i][j].N        = EXT_RF_IOTLB_2m_Data_RdData_c[i][j].N;
            RF_IOTLB_2m_Data_RdData[i][j].X        = '0;
            RF_IOTLB_2m_Data_RdData[i][j].R        = EXT_RF_IOTLB_2m_Data_RdData_c[i][j].R;
            RF_IOTLB_2m_Data_RdData[i][j].W        = EXT_RF_IOTLB_2m_Data_RdData_c[i][j].W;
            RF_IOTLB_2m_Data_RdData[i][j].Memtype  = '0;
            RF_IOTLB_2m_Data_RdData[i][j].Priv_Data = '0;
            RF_IOTLB_2m_Data_RdData[i][j].Address  = EXT_RF_IOTLB_2m_Data_RdData_c[i][j].Address;
        end
    end
    EXT_RF_IOTLB_2m_Data_RdEn    = RF_IOTLB_2m_Data_RdEn;
    EXT_RF_IOTLB_2m_Data_RdAddr  = RF_IOTLB_2m_Data_RdAddr;
    EXT_RF_IOTLB_2m_Data_WrEn    = RF_IOTLB_2m_Data_WrEn;
    EXT_RF_IOTLB_2m_Data_WrAddr  = RF_IOTLB_2m_Data_WrAddr;

    EXT_RF_IOTLB_2m_Data_WrData_c = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        EXT_RF_IOTLB_2m_Data_WrData_c[i].Parity   = RF_IOTLB_2m_Data_WrData[i].Parity;
        EXT_RF_IOTLB_2m_Data_WrData_c[i].RSVD     = RF_IOTLB_2m_Data_WrData[i].U;
        EXT_RF_IOTLB_2m_Data_WrData_c[i].N        = RF_IOTLB_2m_Data_WrData[i].N;
//        EXT_RF_IOTLB_2m_Data_WrData_c[i].X        = RF_IOTLB_2m_Data_WrData[i].X;
        EXT_RF_IOTLB_2m_Data_WrData_c[i].R        = RF_IOTLB_2m_Data_WrData[i].R;
        EXT_RF_IOTLB_2m_Data_WrData_c[i].W        = RF_IOTLB_2m_Data_WrData[i].W;
//        EXT_RF_IOTLB_2m_Data_WrData_c[i].Memtype  = RF_IOTLB_2m_Data_WrData[i].Memtype;
//        EXT_RF_IOTLB_2m_Data_WrData_c[i].Priv_Data= RF_IOTLB_2m_Data_WrData[i].Priv_Data;
        EXT_RF_IOTLB_2m_Data_WrData_c[i].Address  = RF_IOTLB_2m_Data_WrData[i].Address;
        EXT_RF_IOTLB_2m_Data_WrData[i]            = EXT_RF_IOTLB_2m_Data_WrData_c[i];
    end
end
// IOTLB 1g
T_IO_TAG_ENTRY_1G [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]          EXT_RF_IOTLB_1g_Tag_RdData_c; 
T_IO_TAG_ENTRY_1G [DEVTLB_XREQ_PORTNUM-1:0]                                   EXT_RF_IOTLB_1g_Tag_WrData_c;
always_comb begin
//assign RF_IOTLB_1g_Tag_RdData       = EXT_RF_IOTLB_1g_Tag_RdData;
    RF_IOTLB_1g_Tag_RdData = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        for (int j=0; j<DEVTLB_TLB_NUM_WAYS; j++) begin
            EXT_RF_IOTLB_1g_Tag_RdData_c[i][j] = T_IO_TAG_ENTRY_1G'(EXT_RF_IOTLB_1g_Tag_RdData[i][j]);
            RF_IOTLB_1g_Tag_RdData[i][j].ValidSL = EXT_RF_IOTLB_1g_Tag_RdData_c[i][j].ValidSL;
            RF_IOTLB_1g_Tag_RdData[i][j].ValidFL = EXT_RF_IOTLB_1g_Tag_RdData_c[i][j].ValidFL;
            RF_IOTLB_1g_Tag_RdData[i][j].Parity = EXT_RF_IOTLB_1g_Tag_RdData_c[i][j].Parity;
            RF_IOTLB_1g_Tag_RdData[i][j].Address = EXT_RF_IOTLB_1g_Tag_RdData_c[i][j].Address;
            RF_IOTLB_1g_Tag_RdData[i][j].BDF     = EXT_RF_IOTLB_1g_Tag_RdData_c[i][j].BDF;
            RF_IOTLB_1g_Tag_RdData[i][j].PASID   = EXT_RF_IOTLB_1g_Tag_RdData_c[i][j].PASID;
            //RF_IOTLB_1g_Tag_RdData[i][j].Global  = EXT_RF_IOTLB_1g_Tag_RdData_c[i][j].Global;
            RF_IOTLB_1g_Tag_RdData[i][j].PR      = EXT_RF_IOTLB_1g_Tag_RdData_c[i][j].PR;
        end
    end
    EXT_RF_IOTLB_1g_Tag_RdEn     = RF_IOTLB_1g_Tag_RdEn;
    EXT_RF_IOTLB_1g_Tag_RdAddr   = RF_IOTLB_1g_Tag_RdAddr;

    EXT_RF_IOTLB_1g_Tag_WrEn     = RF_IOTLB_1g_Tag_WrEn;
    EXT_RF_IOTLB_1g_Tag_WrAddr   = RF_IOTLB_1g_Tag_WrAddr;
    EXT_RF_IOTLB_1g_Tag_WrData_c = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        EXT_RF_IOTLB_1g_Tag_WrData_c[i].ValidSL  = RF_IOTLB_1g_Tag_WrData[i].ValidSL;
        EXT_RF_IOTLB_1g_Tag_WrData_c[i].ValidFL  = RF_IOTLB_1g_Tag_WrData[i].ValidFL;
        EXT_RF_IOTLB_1g_Tag_WrData_c[i].Parity   = RF_IOTLB_1g_Tag_WrData[i].Parity;
        EXT_RF_IOTLB_1g_Tag_WrData_c[i].Address  = RF_IOTLB_1g_Tag_WrData[i].Address;
        EXT_RF_IOTLB_1g_Tag_WrData_c[i].BDF      = RF_IOTLB_1g_Tag_WrData[i].BDF;
        EXT_RF_IOTLB_1g_Tag_WrData_c[i].PASID    = RF_IOTLB_1g_Tag_WrData[i].PASID;
        //EXT_RF_IOTLB_1g_Tag_WrData_c[i].Global   = RF_IOTLB_1g_Tag_WrData[i].Global;
        EXT_RF_IOTLB_1g_Tag_WrData_c[i].PR       = RF_IOTLB_1g_Tag_WrData[i].PR;
        EXT_RF_IOTLB_1g_Tag_WrData[i] = EXT_RF_IOTLB_1g_Tag_WrData_c[i];
    end
end

T_IO_DATA_ENTRY_1G [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]          EXT_RF_IOTLB_1g_Data_RdData_c; 
T_IO_DATA_ENTRY_1G [DEVTLB_XREQ_PORTNUM-1:0]                                   EXT_RF_IOTLB_1g_Data_WrData_c;
always_comb begin
    RF_IOTLB_1g_Data_RdData = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        for (int j=0; j<DEVTLB_TLB_NUM_WAYS; j++) begin
            EXT_RF_IOTLB_1g_Data_RdData_c[i][j]    = T_IO_DATA_ENTRY_1G'(EXT_RF_IOTLB_1g_Data_RdData[i][j]);
            RF_IOTLB_1g_Data_RdData[i][j].Parity   = EXT_RF_IOTLB_1g_Data_RdData_c[i][j].Parity;
            RF_IOTLB_1g_Data_RdData[i][j].U        = EXT_RF_IOTLB_1g_Data_RdData_c[i][j].RSVD;
            RF_IOTLB_1g_Data_RdData[i][j].N        = EXT_RF_IOTLB_1g_Data_RdData_c[i][j].N;
            RF_IOTLB_1g_Data_RdData[i][j].X        = '0;
            RF_IOTLB_1g_Data_RdData[i][j].R        = EXT_RF_IOTLB_1g_Data_RdData_c[i][j].R;
            RF_IOTLB_1g_Data_RdData[i][j].W        = EXT_RF_IOTLB_1g_Data_RdData_c[i][j].W;
            RF_IOTLB_1g_Data_RdData[i][j].Memtype  = '0;
            RF_IOTLB_1g_Data_RdData[i][j].Priv_Data = '0;
            RF_IOTLB_1g_Data_RdData[i][j].Address  = EXT_RF_IOTLB_1g_Data_RdData_c[i][j].Address;
        end
    end
    EXT_RF_IOTLB_1g_Data_RdEn    = RF_IOTLB_1g_Data_RdEn;
    EXT_RF_IOTLB_1g_Data_RdAddr  = RF_IOTLB_1g_Data_RdAddr;
    EXT_RF_IOTLB_1g_Data_WrEn    = RF_IOTLB_1g_Data_WrEn;
    EXT_RF_IOTLB_1g_Data_WrAddr  = RF_IOTLB_1g_Data_WrAddr;

    EXT_RF_IOTLB_1g_Data_WrData_c = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        EXT_RF_IOTLB_1g_Data_WrData_c[i].Parity   = RF_IOTLB_1g_Data_WrData[i].Parity;
        EXT_RF_IOTLB_1g_Data_WrData_c[i].RSVD     = RF_IOTLB_1g_Data_WrData[i].U;
        EXT_RF_IOTLB_1g_Data_WrData_c[i].N        = RF_IOTLB_1g_Data_WrData[i].N;
//        EXT_RF_IOTLB_1g_Data_WrData_c[i].X        = RF_IOTLB_1g_Data_WrData[i].X;
        EXT_RF_IOTLB_1g_Data_WrData_c[i].R        = RF_IOTLB_1g_Data_WrData[i].R;
        EXT_RF_IOTLB_1g_Data_WrData_c[i].W        = RF_IOTLB_1g_Data_WrData[i].W;
//        EXT_RF_IOTLB_1g_Data_WrData_c[i].Memtype  = RF_IOTLB_1g_Data_WrData[i].Memtype;
//        EXT_RF_IOTLB_1g_Data_WrData_c[i].Priv_Data= RF_IOTLB_1g_Data_WrData[i].Priv_Data;
        EXT_RF_IOTLB_1g_Data_WrData_c[i].Address  = RF_IOTLB_1g_Data_WrData[i].Address;
        EXT_RF_IOTLB_1g_Data_WrData[i]            = EXT_RF_IOTLB_1g_Data_WrData_c[i];
    end
end

// IOTLB 5t
always_comb begin
//assign RF_IOTLB_5t_Tag_RdData       = EXT_RF_IOTLB_5t_Tag_RdData;
    RF_IOTLB_5t_Tag_RdData = '0;
    /*for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        for (int j=0; j<DEVTLB_TLB_NUM_WAYS; j++) begin
            RF_IOTLB_5t_Tag_RdData[i][j].ValidSL = EXT_RF_IOTLB_5t_Tag_RdData[i][j].ValidSL;
            RF_IOTLB_5t_Tag_RdData[i][j].ValidFL = EXT_RF_IOTLB_5t_Tag_RdData[i][j].ValidFL;
            RF_IOTLB_5t_Tag_RdData[i][j].Parity = EXT_RF_IOTLB_5t_Tag_RdData[i][j].Parity;
            RF_IOTLB_5t_Tag_RdData[i][j].Address = EXT_RF_IOTLB_5t_Tag_RdData[i][j].Address;
        end
    end*/
end
/*assign EXT_RF_IOTLB_5t_Tag_RdEn     = RF_IOTLB_5t_Tag_RdEn;
assign EXT_RF_IOTLB_5t_Tag_RdAddr   = RF_IOTLB_5t_Tag_RdAddr;
assign EXT_RF_IOTLB_5t_Tag_WrEn     = RF_IOTLB_5t_Tag_WrEn;
assign EXT_RF_IOTLB_5t_Tag_WrAddr   = RF_IOTLB_5t_Tag_WrAddr;
always_comb begin 
    EXT_RF_IOTLB_5t_Tag_WrData = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        EXT_RF_IOTLB_5t_Tag_WrData[i].ValidSL  = RF_IOTLB_5t_Tag_WrData[i].ValidSL;
        EXT_RF_IOTLB_5t_Tag_WrData[i].ValidFL  = RF_IOTLB_5t_Tag_WrData[i].ValidFL;
        EXT_RF_IOTLB_5t_Tag_WrData[i].Parity   = RF_IOTLB_5t_Tag_WrData[i].Parity;
        EXT_RF_IOTLB_5t_Tag_WrData[i].Address  = RF_IOTLB_5t_Tag_WrData[i].Address;
    end
end*/

always_comb begin
    RF_IOTLB_5t_Data_RdData      = '0;
/*    RF_IOTLB_5t_Data_RdData      = EXT_RF_IOTLB_5t_Data_RdData;
    EXT_RF_IOTLB_5t_Data_RdEn    = RF_IOTLB_5t_Data_RdEn;
    EXT_RF_IOTLB_5t_Data_RdAddr  = RF_IOTLB_5t_Data_RdAddr;
    EXT_RF_IOTLB_5t_Data_WrEn    = RF_IOTLB_5t_Data_WrEn;
    EXT_RF_IOTLB_5t_Data_WrAddr  = RF_IOTLB_5t_Data_WrAddr;
    EXT_RF_IOTLB_5t_Data_WrData  = RF_IOTLB_5t_Data_WrData;*/
end

//=====================================================================================================================
// COVERS
//=====================================================================================================================

`ifdef HQM_DEVTLB_COVER_EN // Do not use covers in VCS...flood the log files with too many messages

`endif // DEVTLB_COVER_EN

//=====================================================================================================================
// ASSERTIONS
//=====================================================================================================================

`ifndef HQM_DEVTLB_SVA_OFF

`endif // DEVTLB_SVA_OFF


//endmodule

`endif // DEVTLB_CUSTOM_RF_EXTERNAL_VS
