`ifndef HQM_DEVTLB_CUSTOM_MISCRF_EXT_MACROS_VH
`define HQM_DEVTLB_CUSTOM_MISCRF_EXT_MACROS_VH

`define HQM_DEVTLB_CUSTOM_MISCRF_PORTLIST	\
                             	\
EXT_RF_InvQRdEn             ,	\
EXT_RF_InvQRdAddr           ,	\
EXT_RF_InvQRdData           ,	\
                             	\
EXT_RF_InvQWrEn             ,	\
EXT_RF_InvQWrAddr           ,	\
EXT_RF_InvQWrData           ,	\
                             	\
EXT_RF_PendQRdEn             ,	\
EXT_RF_PendQRdAddr           ,	\
EXT_RF_PendQRdData           ,	\
                             	\
EXT_RF_PendQWrEn             ,	\
EXT_RF_PendQWrAddr           ,	\
EXT_RF_PendQWrData           ,	\
                             	\
EXT_RF_MsTrkReqCAMEn        ,	\
EXT_RF_MsTrkReqCAMData      ,	\
EXT_RF_MsTrkReqCAMHit       ,	\
                             	\
EXT_RF_MsTrkReqRdEn         ,	\
EXT_RF_MsTrkReqRdAddr       ,	\
EXT_RF_MsTrkReqRdData       ,	\
                            	\
EXT_RF_MsTrkReqWrEn         ,	\
EXT_RF_MsTrkReqWrAddr       ,	\
EXT_RF_MsTrkReqWrData       ,	\
                            	\
EXT_RF_MsTrkRspRdEn         ,	\
EXT_RF_MsTrkRspRdAddr       ,	\
EXT_RF_MsTrkRspRdData       ,	\
                            	\
EXT_RF_MsTrkRspWrEn         ,	\
EXT_RF_MsTrkRspWrAddr       ,	\
EXT_RF_MsTrkRspWrData       ,

`define HQM_DEVTLB_CUSTOM_MISCRF_PORTDEC     \
                            \
output    logic                                                                                       EXT_RF_InvQRdEn;                \
output    logic   [DEVTLB_INVQ_IDW-1:0]                                                            EXT_RF_InvQRdAddr;              \
input     logic   [$bits(t_devtlb_invreq)-1:0]                                                        EXT_RF_InvQRdData;              \
                            \
output    logic                                                                                       EXT_RF_InvQWrEn;                \
output    logic   [DEVTLB_INVQ_IDW-1:0]                                                            EXT_RF_InvQWrAddr;              \
output    logic   [$bits(t_devtlb_invreq)-1:0]                                                        EXT_RF_InvQWrData;              \
                            \
output    logic                                                                                       EXT_RF_PendQRdEn;                \
output    logic   [DEVTLB_PENDQ_IDW-1:0]                                                            EXT_RF_PendQRdAddr;              \
input     logic   [$bits(t_devtlb_request)-1:0]                                                        EXT_RF_PendQRdData;              \
                            \
output    logic                                                                                       EXT_RF_PendQWrEn;                \
output    logic   [DEVTLB_PENDQ_IDW-1:0]                                                            EXT_RF_PendQWrAddr;              \
output    logic   [$bits(t_devtlb_request)-1:0]                                                        EXT_RF_PendQWrData;              \
                            \
output    logic                                                                                       EXT_RF_MsTrkReqCAMEn;               \
output    logic   [$bits(t_devtlb_camreq)-1:0]                                                        EXT_RF_MsTrkReqCAMData;             \
input     logic   [DEVTLB_MISSTRK_DEPTH-1:0]                                                          EXT_RF_MsTrkReqCAMHit;              \
                            \
output    logic                                                                                       EXT_RF_MsTrkReqRdEn;                \
output    logic   [$clog2(DEVTLB_MISSTRK_DEPTH)-1:0]                                                  EXT_RF_MsTrkReqRdAddr;              \
input     logic   [$bits(t_devtlb_request)-1:0]                                                        EXT_RF_MsTrkReqRdData;              \
                            \
output    logic                                                                                       EXT_RF_MsTrkReqWrEn;                \
output    logic   [$clog2(DEVTLB_MISSTRK_DEPTH)-1:0]                                                  EXT_RF_MsTrkReqWrAddr;              \
output    logic   [$bits(t_devtlb_request)-1:0]                                                        EXT_RF_MsTrkReqWrData;               \
                            \
output    logic                                                                                       EXT_RF_MsTrkRspRdEn;                \
output    logic   [$clog2(DEVTLB_MISSTRK_DEPTH)-1:0]                                                  EXT_RF_MsTrkRspRdAddr;              \
input     logic   [$bits(t_mstrk_atsrsp)-1:0]                                                        EXT_RF_MsTrkRspRdData;              \
                            \
output    logic                                                                                       EXT_RF_MsTrkRspWrEn;                \
output    logic   [$clog2(DEVTLB_MISSTRK_DEPTH)-1:0]                                                  EXT_RF_MsTrkRspWrAddr;              \
output    logic   [$bits(t_mstrk_atsrsp)-1:0]                                                        EXT_RF_MsTrkRspWrData;

`endif // IOMMU_MACROS_VH 

