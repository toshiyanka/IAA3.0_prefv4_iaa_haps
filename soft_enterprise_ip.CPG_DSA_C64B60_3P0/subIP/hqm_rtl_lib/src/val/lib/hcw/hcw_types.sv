`ifndef HCW_TYPES__SV
`define HCW_TYPES__SV

typedef enum {
    HCW_AXI,
    HCW_LIST_SELECT,
    HCW_IOSF
} hcw_downstream_interface_t;

typedef enum {
    MON_END,
    MON_SCH,
    MON_PPT 
} hcw_monsel_t;



typedef enum bit [1:0] {
 QATM	 	= 2'b00,
 QUNO    	= 2'b01,
 QORD  	        = 2'b10,
 QDIR  	        = 2'b11
} hcw_qtype;

typedef enum bit [3:0] {
 NOOP	        = 4'b0000,
 BAT_T          = 4'b0001,
 COMP  	        = 4'b0010,
 COMP_T         = 4'b0011,
 A_COMP         = 4'b0110,
 A_COMP_T       = 4'b0111,
 RELS           = 4'b0100,
 ARM            = 4'b0101,
 //ILLEGAL6       = 4'b0110,
 //ILLEGAL7       = 4'b0111,
 NEW 	        = 4'b1000,
 NEW_T          = 4'b1001,
 RENQ  	        = 4'b1010,
 RENQ_T         = 4'b1011,
 FRAG           = 4'b1100,
 FRAG_T         = 4'b1101,
 ILLEGAL14      = 4'b1110,
 ILLEGAL15      = 4'b1111
} hcw_cmd_t;



`endif
