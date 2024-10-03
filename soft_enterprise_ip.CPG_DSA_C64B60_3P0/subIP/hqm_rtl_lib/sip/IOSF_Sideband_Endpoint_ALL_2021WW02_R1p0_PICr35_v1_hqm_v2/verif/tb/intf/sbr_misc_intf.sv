interface sbr_misc_intf();

localparam int MAX_PORT_NUM = 16;

logic [4:0]   cfg_cgovrd;
logic [15:0]  cfg_cgctrl;
logic [15:0]  mi_select;

logic [MAX_PORT_NUM-1:0] side_pok;
logic [MAX_PORT_NUM-1:0] port_disable;
logic [MAX_PORT_NUM-1:0] egress_req_pending;
logic [MAX_PORT_NUM-1:0][2:0] ism_out;

endinterface
