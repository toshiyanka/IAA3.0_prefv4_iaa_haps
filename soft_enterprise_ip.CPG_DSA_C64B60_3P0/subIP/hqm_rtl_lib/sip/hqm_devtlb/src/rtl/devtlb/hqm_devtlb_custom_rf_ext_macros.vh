`ifndef HQM_DEVTLB_CUSTOM_RF_EXT_MACROS_VH
`define HQM_DEVTLB_CUSTOM_RF_EXT_MACROS_VH

`define HQM_DEVTLB_CUSTOM_RF_PORTLIST \
EXT_RF_IOTLB_4k_Tag_RdData, \
EXT_RF_IOTLB_4k_Tag_RdEn,   \
EXT_RF_IOTLB_4k_Tag_RdAddr, \
EXT_RF_IOTLB_4k_Tag_WrEn,   \
EXT_RF_IOTLB_4k_Tag_WrAddr, \
EXT_RF_IOTLB_4k_Tag_WrData, \
                                \
EXT_RF_IOTLB_4k_Data_RdData  ,  \
EXT_RF_IOTLB_4k_Data_RdEn    ,  \
EXT_RF_IOTLB_4k_Data_RdAddr  ,  \
EXT_RF_IOTLB_4k_Data_WrEn    ,  \
EXT_RF_IOTLB_4k_Data_WrAddr  ,  \
EXT_RF_IOTLB_4k_Data_WrData  ,  \
                                \
EXT_RF_IOTLB_2m_Tag_RdData   ,  \
EXT_RF_IOTLB_2m_Tag_RdEn     ,  \
EXT_RF_IOTLB_2m_Tag_RdAddr   ,  \
EXT_RF_IOTLB_2m_Tag_WrEn     ,  \
EXT_RF_IOTLB_2m_Tag_WrAddr   ,  \
EXT_RF_IOTLB_2m_Tag_WrData   ,  \
                                \
EXT_RF_IOTLB_2m_Data_RdData  ,  \
EXT_RF_IOTLB_2m_Data_RdEn    ,  \
EXT_RF_IOTLB_2m_Data_RdAddr  ,  \
EXT_RF_IOTLB_2m_Data_WrEn    ,  \
EXT_RF_IOTLB_2m_Data_WrAddr  ,  \
EXT_RF_IOTLB_2m_Data_WrData  ,  \
                                \
EXT_RF_IOTLB_1g_Tag_RdData   ,  \
EXT_RF_IOTLB_1g_Tag_RdEn     ,  \
EXT_RF_IOTLB_1g_Tag_RdAddr   ,  \
EXT_RF_IOTLB_1g_Tag_WrEn     ,  \
EXT_RF_IOTLB_1g_Tag_WrAddr   ,  \
EXT_RF_IOTLB_1g_Tag_WrData   ,  \
                                \
EXT_RF_IOTLB_1g_Data_RdData  ,  \
EXT_RF_IOTLB_1g_Data_RdEn    ,  \
EXT_RF_IOTLB_1g_Data_RdAddr  ,  \
EXT_RF_IOTLB_1g_Data_WrEn    ,  \
EXT_RF_IOTLB_1g_Data_WrAddr  ,  \
EXT_RF_IOTLB_1g_Data_WrData  ,

`define HQM_DEVTLB_CUSTOM_RF_PORTDEC                                                                                                                   \
output logic [DEVTLB_XREQ_PORTNUM-1:0]                                              EXT_RF_IOTLB_4k_Tag_RdEn;      \
output logic [DEVTLB_XREQ_PORTNUM-1:0][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[0])-1:0] EXT_RF_IOTLB_4k_Tag_RdAddr;    \
input  logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_TAG_ENTRY_4K_RF_WIDTH-1:0] EXT_RF_IOTLB_4k_Tag_RdData;     \
output logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]                     EXT_RF_IOTLB_4k_Tag_WrEn;        \
output logic [DEVTLB_XREQ_PORTNUM-1:0][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[0])-1:0] EXT_RF_IOTLB_4k_Tag_WrAddr;     \
output logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TAG_ENTRY_4K_RF_WIDTH-1:0]            EXT_RF_IOTLB_4k_Tag_WrData;      \
                                                                                                                    \
output logic [DEVTLB_XREQ_PORTNUM-1:0]                                             EXT_RF_IOTLB_4k_Data_RdEn;       \
output logic [DEVTLB_XREQ_PORTNUM-1:0][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[0])-1:0] EXT_RF_IOTLB_4k_Data_RdAddr;    \
input  logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_DATA_ENTRY_4K_RF_WIDTH-1:0] EXT_RF_IOTLB_4k_Data_RdData;  \
output logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]                     EXT_RF_IOTLB_4k_Data_WrEn;       \
output logic [DEVTLB_XREQ_PORTNUM-1:0][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[0])-1:0] EXT_RF_IOTLB_4k_Data_WrAddr;     \
output logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_DATA_ENTRY_4K_RF_WIDTH-1:0]           EXT_RF_IOTLB_4k_Data_WrData;     \
                                                                                                                     \
output logic [DEVTLB_XREQ_PORTNUM-1:0]                                              EXT_RF_IOTLB_2m_Tag_RdEn;        \
output logic [DEVTLB_XREQ_PORTNUM-1:0][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[1])-1:0] EXT_RF_IOTLB_2m_Tag_RdAddr;      \
input  logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_TAG_ENTRY_2M_RF_WIDTH-1:0] EXT_RF_IOTLB_2m_Tag_RdData;      \
output logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]                     EXT_RF_IOTLB_2m_Tag_WrEn;        \
output logic [DEVTLB_XREQ_PORTNUM-1:0][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[1])-1:0] EXT_RF_IOTLB_2m_Tag_WrAddr;      \
output logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TAG_ENTRY_2M_RF_WIDTH-1:0]            EXT_RF_IOTLB_2m_Tag_WrData;      \
                                                                                                                     \
output logic [DEVTLB_XREQ_PORTNUM-1:0]                                              EXT_RF_IOTLB_2m_Data_RdEn;       \
output logic [DEVTLB_XREQ_PORTNUM-1:0][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[1])-1:0] EXT_RF_IOTLB_2m_Data_RdAddr;     \
input  logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_DATA_ENTRY_2M_RF_WIDTH-1:0] EXT_RF_IOTLB_2m_Data_RdData;     \
output logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                    EXT_RF_IOTLB_2m_Data_WrEn;        \
output logic [DEVTLB_XREQ_PORTNUM-1:0][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[1])-1:0] EXT_RF_IOTLB_2m_Data_WrAddr;     \
output logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_DATA_ENTRY_2M_RF_WIDTH-1:0]           EXT_RF_IOTLB_2m_Data_WrData;     \
                                                                                                                        \
output logic [DEVTLB_XREQ_PORTNUM-1:0]                                              EXT_RF_IOTLB_1g_Tag_RdEn;        \
output logic [DEVTLB_XREQ_PORTNUM-1:0][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[2])-1:0] EXT_RF_IOTLB_1g_Tag_RdAddr;      \
input  logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_TAG_ENTRY_1G_RF_WIDTH-1:0] EXT_RF_IOTLB_1g_Tag_RdData;      \
output logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                    EXT_RF_IOTLB_1g_Tag_WrEn;        \
output logic [DEVTLB_XREQ_PORTNUM-1:0][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[2])-1:0] EXT_RF_IOTLB_1g_Tag_WrAddr;      \
output logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TAG_ENTRY_1G_RF_WIDTH-1:0]            EXT_RF_IOTLB_1g_Tag_WrData;      \
                                                                                                                        \
output logic [DEVTLB_XREQ_PORTNUM-1:0]                                              EXT_RF_IOTLB_1g_Data_RdEn;       \
output logic [DEVTLB_XREQ_PORTNUM-1:0][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[2])-1:0] EXT_RF_IOTLB_1g_Data_RdAddr;     \
input  logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_DATA_ENTRY_1G_RF_WIDTH-1:0] EXT_RF_IOTLB_1g_Data_RdData;     \
output logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                    EXT_RF_IOTLB_1g_Data_WrEn;        \
output logic [DEVTLB_XREQ_PORTNUM-1:0][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[2])-1:0] EXT_RF_IOTLB_1g_Data_WrAddr;     \
output logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_DATA_ENTRY_1G_RF_WIDTH-1:0]           EXT_RF_IOTLB_1g_Data_WrData;

`define HQM_DEVTLB_CUSTOM_RF_PORTCON                                \
.EXT_RF_IOTLB_4k_Tag_RdData   (EXT_RF_IOTLB_4k_Tag_RdData ),    \
.EXT_RF_IOTLB_4k_Tag_RdEn     (EXT_RF_IOTLB_4k_Tag_RdEn   ),    \
.EXT_RF_IOTLB_4k_Tag_RdAddr   (EXT_RF_IOTLB_4k_Tag_RdAddr ),    \
.EXT_RF_IOTLB_4k_Tag_WrEn     (EXT_RF_IOTLB_4k_Tag_WrEn   ),    \
.EXT_RF_IOTLB_4k_Tag_WrAddr   (EXT_RF_IOTLB_4k_Tag_WrAddr ),    \
.EXT_RF_IOTLB_4k_Tag_WrData   (EXT_RF_IOTLB_4k_Tag_WrData ),    \
                                                                \
.EXT_RF_IOTLB_4k_Data_RdData  (EXT_RF_IOTLB_4k_Data_RdData),    \
.EXT_RF_IOTLB_4k_Data_RdEn    (EXT_RF_IOTLB_4k_Data_RdEn  ),    \
.EXT_RF_IOTLB_4k_Data_RdAddr  (EXT_RF_IOTLB_4k_Data_RdAddr),    \
.EXT_RF_IOTLB_4k_Data_WrEn    (EXT_RF_IOTLB_4k_Data_WrEn  ),    \
.EXT_RF_IOTLB_4k_Data_WrAddr  (EXT_RF_IOTLB_4k_Data_WrAddr),    \
.EXT_RF_IOTLB_4k_Data_WrData  (EXT_RF_IOTLB_4k_Data_WrData),    \
                                                                \
.EXT_RF_IOTLB_2m_Tag_RdData   (EXT_RF_IOTLB_2m_Tag_RdData ),    \
.EXT_RF_IOTLB_2m_Tag_RdEn     (EXT_RF_IOTLB_2m_Tag_RdEn   ),    \
.EXT_RF_IOTLB_2m_Tag_RdAddr   (EXT_RF_IOTLB_2m_Tag_RdAddr ),    \
.EXT_RF_IOTLB_2m_Tag_WrEn     (EXT_RF_IOTLB_2m_Tag_WrEn   ),    \
.EXT_RF_IOTLB_2m_Tag_WrAddr   (EXT_RF_IOTLB_2m_Tag_WrAddr ),    \
.EXT_RF_IOTLB_2m_Tag_WrData   (EXT_RF_IOTLB_2m_Tag_WrData ),    \
                                                                \
.EXT_RF_IOTLB_2m_Data_RdData  (EXT_RF_IOTLB_2m_Data_RdData),    \
.EXT_RF_IOTLB_2m_Data_RdEn    (EXT_RF_IOTLB_2m_Data_RdEn  ),    \
.EXT_RF_IOTLB_2m_Data_RdAddr  (EXT_RF_IOTLB_2m_Data_RdAddr),    \
.EXT_RF_IOTLB_2m_Data_WrEn    (EXT_RF_IOTLB_2m_Data_WrEn  ),    \
.EXT_RF_IOTLB_2m_Data_WrAddr  (EXT_RF_IOTLB_2m_Data_WrAddr),    \
.EXT_RF_IOTLB_2m_Data_WrData  (EXT_RF_IOTLB_2m_Data_WrData),    \
                                                                \
.EXT_RF_IOTLB_1g_Tag_RdData   (EXT_RF_IOTLB_1g_Tag_RdData ),    \
.EXT_RF_IOTLB_1g_Tag_RdEn     (EXT_RF_IOTLB_1g_Tag_RdEn   ),    \
.EXT_RF_IOTLB_1g_Tag_RdAddr   (EXT_RF_IOTLB_1g_Tag_RdAddr ),    \
.EXT_RF_IOTLB_1g_Tag_WrEn     (EXT_RF_IOTLB_1g_Tag_WrEn   ),    \
.EXT_RF_IOTLB_1g_Tag_WrAddr   (EXT_RF_IOTLB_1g_Tag_WrAddr ),    \
.EXT_RF_IOTLB_1g_Tag_WrData   (EXT_RF_IOTLB_1g_Tag_WrData ),    \
                                                                \
.EXT_RF_IOTLB_1g_Data_RdData  (EXT_RF_IOTLB_1g_Data_RdData),    \
.EXT_RF_IOTLB_1g_Data_RdEn    (EXT_RF_IOTLB_1g_Data_RdEn  ),    \
.EXT_RF_IOTLB_1g_Data_RdAddr  (EXT_RF_IOTLB_1g_Data_RdAddr),    \
.EXT_RF_IOTLB_1g_Data_WrEn    (EXT_RF_IOTLB_1g_Data_WrEn  ),    \
.EXT_RF_IOTLB_1g_Data_WrAddr  (EXT_RF_IOTLB_1g_Data_WrAddr),    \
.EXT_RF_IOTLB_1g_Data_WrData  (EXT_RF_IOTLB_1g_Data_WrData),

`define HQM_DEVTLB_CUSTOM_RF_PARAMDEC                               \
localparam type T_IO_TAG_ENTRY_4K = t_devtlb_io_4k_tag_entry;   \
localparam type T_IO_TAG_ENTRY_2M = t_devtlb_io_2m_tag_entry;   \
localparam type T_IO_TAG_ENTRY_1G = t_devtlb_io_1g_tag_entry;   \
localparam type T_IO_TAG_ENTRY_5T = t_devtlb_io_5t_tag_entry;   \
localparam type T_IO_TAG_ENTRY_QP = t_devtlb_io_Qp_tag_entry;   \
localparam type T_IO_DATA_ENTRY_4K = t_devtlb_io_4k_data_entry;   \
localparam type T_IO_DATA_ENTRY_2M = t_devtlb_io_2m_data_entry;   \
localparam type T_IO_DATA_ENTRY_1G = t_devtlb_io_1g_data_entry;   \
localparam type T_IO_DATA_ENTRY_5T = t_devtlb_io_5t_data_entry;   \
localparam type T_IO_DATA_ENTRY_QP = t_devtlb_io_Qp_data_entry;   \
localparam type T_TAG_ENTRY_4K = t_devtlb_iotlb_4k_tag_entry;   \
localparam type T_DATA_ENTRY_4K = t_devtlb_iotlb_4k_data_entry;   \
localparam type T_TAG_ENTRY_2M = t_devtlb_iotlb_2m_tag_entry;   \
localparam type T_DATA_ENTRY_2M = t_devtlb_iotlb_2m_data_entry;   \
localparam type T_TAG_ENTRY_1G = t_devtlb_iotlb_1g_tag_entry;   \
localparam type T_DATA_ENTRY_1G = t_devtlb_iotlb_1g_data_entry;   \
localparam type T_TAG_ENTRY_5T = t_devtlb_iotlb_5t_tag_entry;   \
localparam type T_DATA_ENTRY_5T = t_devtlb_iotlb_5t_data_entry;   \
localparam type T_TAG_ENTRY_QP = t_devtlb_iotlb_Qp_tag_entry;   \
localparam type T_DATA_ENTRY_QP = t_devtlb_iotlb_Qp_data_entry;

`endif // IOMMU_MACROS_VH 

