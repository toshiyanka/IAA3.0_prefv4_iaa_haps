
module sbr_mux #(parameter int ENDPOINT = 0, parameter int AGT = 1) (
    input logic  [2:0] agt_ism_agt,
    output logic        agt_mpccup,
    output logic        agt_mnpcup,
    input logic        agt_mpcput,
    input logic        agt_mnpput,
    input logic [31:0] agt_mpayload,
    input logic        agt_meom,
    input logic        agt_mparity,

    output logic  [2:0] agt_ism_fab,
    input logic        agt_tpccup,
    input logic        agt_tnpcup,
    output logic        agt_tpcput,
    output logic        agt_tnpput,
    output logic [31:0] agt_tpayload,
    output logic        agt_teom,
    output logic        agt_tparity,    

    output logic  [2:0] fab_ism_agt,
    input logic        fab_mpccup,
    input logic        fab_mnpcup,
    output logic        fab_mpcput,
    output logic        fab_mnpput,
    output logic [31:0] fab_mpayload,
    output logic        fab_meom,
    output logic        fab_mparity,

    input logic  [2:0] fab_ism_fab,
    output logic        fab_tpccup,
    output logic        fab_tnpcup,
    input logic        fab_tpcput,
    input logic        fab_tnpput,
    input logic [31:0] fab_tpayload,
    input logic        fab_teom,
    input logic        fab_tparity,
         
    interface sb_if
);
    
    if(ENDPOINT == 0) begin 
        if(AGT == 1) begin
            assign agt_ism_fab = sb_if.side_ism_fabric; 
            assign sb_if.side_ism_agent = agt_ism_agt;
            assign agt_mpccup = sb_if.mpccup;
            assign agt_mnpcup = sb_if.mnpcup;
            assign sb_if.mpcput = agt_mpcput;
            assign sb_if.mnpput = agt_mnpput;
            assign sb_if.meom = agt_meom;
            assign sb_if.mpayload = agt_mpayload;
            assign sb_if.mparity = agt_mparity;
            assign sb_if.tpccup = agt_tpccup;
            assign sb_if.tnpcup = agt_tnpcup;
            assign agt_tpcput = sb_if.tpcput;
            assign agt_tnpput = sb_if.tnpput;
            assign agt_teom = sb_if.teom;
            assign agt_tpayload = sb_if.tpayload;
            assign agt_tparity = sb_if.tparity;
            assign fab_tpccup = 0;
            assign fab_tnpcup = 0;
            assign fab_mpcput = 0;
            assign fab_mnpput = 0;
            assign fab_meom = 0;
            assign fab_mpayload = '0;
            assign fab_mparity = 0;
            assign fab_ism_agt = '0;
        end
        else begin
            assign sb_if.side_ism_fabric = fab_ism_fab;
            assign fab_ism_agt = sb_if.side_ism_agent;
            assign sb_if.tpccup = fab_mpccup;
            assign fab_tpccup = sb_if.mpccup;
            assign sb_if.tnpcup = fab_mnpcup;
            assign fab_tnpcup = sb_if.mnpcup;
            assign sb_if.mpcput = fab_tpcput;
            assign fab_mpcput = sb_if.tpcput;
            assign sb_if.mnpput = fab_tnpput;
            assign fab_mnpput = sb_if.tnpput;
            assign sb_if.meom = fab_teom;
            assign fab_meom = sb_if.teom;
            assign sb_if.mpayload = fab_tpayload;
            assign fab_mpayload = sb_if.tpayload;
            assign sb_if.mparity = fab_tparity;
            assign fab_mparity = sb_if.tparity;
            assign agt_ism_fab = '0;
            assign agt_mpccup = '0;
            assign agt_mnpcup = '0;
            assign agt_tpcput = 0;
            assign agt_tnpput = 0;
            assign agt_teom = 0;
            assign agt_tparity = 0;
            assign agt_tpayload = '0;        
        end        
    end
    else begin
        if(AGT == 1) begin
            assign agt_mnpcup = sb_if.tnpcup;
            assign agt_mpccup = sb_if.tpccup;
            assign agt_tnpput = sb_if.mnpput;
            assign agt_tpcput = sb_if.mpcput;
            assign agt_teom = sb_if.meom;
            assign agt_tpayload = sb_if.mpayload;
            assign agt_tparity = sb_if.mparity;
            assign agt_ism_fab = sb_if.side_ism_fabric;
            assign sb_if.tnpput = agt_mnpput; 
            assign sb_if.tpcput = agt_mpcput;
            assign sb_if.teom = agt_meom;
            assign sb_if.tpayload = agt_mpayload;
            assign sb_if.tparity = agt_mparity;
            assign sb_if.mnpcup = agt_tnpcup;
            assign sb_if.mpccup = agt_tpccup;
            assign sb_if.side_ism_agent = agt_ism_agt;
            assign fab_mnpput = 0;
            assign fab_mpcput = 0;
            assign fab_meom = 0;
            assign fab_mparity = 0;
            assign fab_mpayload = '0;
            assign fab_tnpcup = 0;
            assign fab_tpccup = 0;
            assign fab_ism_agt = '0;
        end
        else begin
            assign fab_ism_agt = sb_if.side_ism_agent;
            assign sb_if.side_ism_fabric = fab_ism_fab;
            assign fab_mpcput = sb_if.mpcput;
            assign fab_mnpput = sb_if.mnpput;
            assign fab_mpayload = sb_if.mpayload;
            assign fab_meom = sb_if.meom;
            assign fab_mparity = sb_if.mparity;
            assign fab_tpccup = sb_if.tpccup;
            assign fab_tnpcup = sb_if.tnpcup;
            assign sb_if.mpccup = fab_mpccup;
            assign sb_if.mnpcup = fab_mnpcup;
            assign sb_if.tpcput = fab_tpcput;
            assign sb_if.tnpput = fab_tnpput;
            assign sb_if.tpayload = fab_tpayload;
            assign sb_if.teom = fab_teom;
            assign sb_if.tparity = fab_tparity; 
            assign agt_mnpcup = 0;
            assign agt_mpccup = 0;
            assign agt_tnpput = 0;
            assign agt_tpcput = 0;
            assign agt_teom = 0;
            assign agt_tparity = 0;
            assign agt_tpayload = '0;
            assign agt_ism_fab = '0;
        end        
    end    
endmodule

