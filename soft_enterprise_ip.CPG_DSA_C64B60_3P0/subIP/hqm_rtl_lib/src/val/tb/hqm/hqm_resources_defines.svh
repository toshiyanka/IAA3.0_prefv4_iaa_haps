//`ifndef HQM_NUM_PORTS
//   `define HQM_NUM_PORTS 64
//`endif // HQM_NUM_PORTS

`ifndef HQM_NUM_DIR_PORTS
   `define HQM_NUM_DIR_PORTS  hqm_pkg::NUM_DIR_CQ
`endif // HQM_NUM_DIR_PORTS

`ifndef HQM_NUM_LDB_PORTS
   `define HQM_NUM_LDB_PORTS hqm_pkg::NUM_LDB_CQ
`endif // HQM_NUM_LDB_PORTS

`ifndef HQM_SAI_WIDTH
  `define HQM_SAI_WIDTH 7 
`endif // HQM_SAI_WIDTH

`ifndef HQM_IOSF_LEN
   `define IOSF_LEN4B   1<<0 //4B
   `define IOSF_LEN16B  1<<2 //1HCW
   `define IOSF_LEN32B  1<<3 //2HCW
   `define IOSF_LEN48B  2<<3 //3HCW
   `define IOSF_LEN64B  1<<4 //4HCW
`endif  
