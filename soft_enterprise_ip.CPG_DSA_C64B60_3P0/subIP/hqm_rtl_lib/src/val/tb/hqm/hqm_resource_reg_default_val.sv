//Regs yet to find
//HQM Version ?
//LDB COS Classes:4
//Sequence Numbers  (SN)  Total :2048

//hqm_system_csr Table 2 MAS & sec 2.5.2
`define DEF_VAL_TOTAL_VF              'd16
`define	DEF_VAL_TOTAL_VAS             'd32 
`define	DEF_VAL_TOTAL_LDB_PORTS       'd64
`define	DEF_VAL_TOTAL_DIR_PORTS       'd64
`define	DEF_VAL_TOTAL_LDB_QID         'd32
`define	DEF_VAL_TOTAL_DIR_QID         'd64
`define	DEF_VAL_TOTAL_CREDITS         'd16384 

//list_sel_pipe CFG_AQED_TOT_ENQUEUE_LIMIT aqed_pipe:2048 "permitted to occupy AQED storage. Must be less than 2049"
`define DEF_VAL_AQED_TOT_ENQUEUE_LIMIT  'd2048

//hqm_system_csr:TOTAL_SN_REGIONS:GROUP
`define	DEF_VAL_TOTAL_SN_REGIONS_SLOT  
`define	DEF_VAL_TOTAL_SN_REGIONS_GROUP 'd2
`define	DEF_VAL_TOTAL_SN_REGIONS_MODE

//aqed_pipe.CFG_AQED_QID_FID_LIMIT:QID_FID_LIMIT:LIMIT 
`define DEF_VAL_AQED_QID_FID_LIMIT    'd2047

//list_sel_pipe  CQ Inflights :2048
`define DEF_VAL_CQ_LDB_TOT_INFLIGHT_LIMIT 'd2048

//list_sel_pipe:FIDs 2048
`define DEF_VAL_FID_INFLIGHT_LIMIT  'd2048


//Security Policy Register 
`define HQM_CSR_CP_LO         32'h01000218	
`define HQM_CSR_CP_HI         32'h00000400 	
`define HQM_CSR_WAC_LO        32'h0300021F	
`define HQM_CSR_WAC_HI        32'h20000C00	
`define HQM_CSR_RAC_LO        32'hFFFFFFFF	
`define HQM_CSR_RAC_HI        32'hFFFFFFFF	
//Policy register value RO bit set to 1
`define HQM_CSR_CP_LO_RO         32'h00000000	
`define HQM_CSR_CP_HI_RO         32'h00000000 	
`define HQM_CSR_WAC_LO_RO        32'h00000000	
`define HQM_CSR_WAC_HI_RO        32'h00000000	
`define HQM_CSR_RAC_LO_RO        32'h00000000
`define HQM_CSR_RAC_HI_RO        32'h00000000	

`define HQM_WR_ALL_0S            32'h00000000	

`define ILL_SAI_RD_VAL      'd0
`define HQM_CSR_ALL_F        32'hFFFFFFFF
