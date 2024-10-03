
module PowerGatingResetTI(PowerGatingResetIF intf);
	import PowerGatingCommonPkg::*;
	parameter string 	IP_ENV_TO_AGENT_PATH = "";
	PowerGatingResetIFContainer param;
	
	initial begin
		param = new();
		param.scope = IP_ENV_TO_AGENT_PATH;
		param.intf = intf;
		PowerGatingBaseAgent::set_reset_if(param);
	end
endmodule: PowerGatingResetTI

module PowerGatingSIPTI(PowerGatingSIPIF intf);
	import PowerGatingCommonPkg::*;
	parameter string 	NAME 		= "";
	//parameter int		INDEX 		= 0; 	//for backward compatibility
	parameter int		NUM_SIDE	= 1;
	//TODO: add a NO_PRIM parameter
	parameter int		NUM_PRIM	= 1;
	parameter int		NUM_D3		= 1;
	parameter int		NUM_D0I3	= 1;
	parameter string 	FET_NAME 	= "";
	parameter string 	FABRIC_NAME	= "";
	//parameter bit 		BFM_DRIVES_POK = 1; //deprecated
	parameter string 	IP_ENV_TO_AGENT_PATH = "";
	PowerGatingSIPIFContainer param;
	initial begin
		param = new();
		param.scope = IP_ENV_TO_AGENT_PATH;
		param.name = NAME;
		param.num_side = NUM_SIDE;
		param.num_prim = NUM_PRIM;
		param.num_d3 = NUM_D3;
		param.num_d0i3 = NUM_D0I3;
		param.intf = intf;
		param.fet_name = FET_NAME;
		param.fabric_name = FABRIC_NAME;

		PowerGatingBaseAgent::set_sip_if(param);
	end
endmodule: PowerGatingSIPTI

module PowerGatingFabricTI(PowerGatingFabricIF intf);
	import PowerGatingCommonPkg::*;
	parameter string 	NAME 		= "";
	parameter string 	IP_ENV_TO_AGENT_PATH = "";
	PowerGatingFabricIFContainer param;
	initial begin
		param = new();
		param.scope = IP_ENV_TO_AGENT_PATH;
		param.name = NAME;
		param.intf = intf;
		PowerGatingBaseAgent::set_fab_if(param);
	end
endmodule: PowerGatingFabricTI
