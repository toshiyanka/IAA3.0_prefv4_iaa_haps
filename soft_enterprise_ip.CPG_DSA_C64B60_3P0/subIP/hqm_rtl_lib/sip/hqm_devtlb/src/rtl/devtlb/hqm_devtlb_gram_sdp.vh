//-------------------------------------------------------------------------
//  TOOL and VENDOR Specific configurations
// ------------------------------------------------------------------------
// The TOOL and VENDOR definition necessary to correctly configure PAR project
// package currently supports
// Vendors : Xilinx & Altera
// Tools   : Synplify & Quartus II & Vivado

`ifndef HQM_DEVTLB_GRAM_SDP_VH
`define HQM_DEVTLB_GRAM_SDP_VH
// Added this for DEVTLB team
`define HQM_VENDOR_ALTERA
`define HQM_TOOL_QUARTUS

    // Generate error if Vendor not defined
    `ifdef VENDOR_XILINX
            `ifdef HQM_VENDOR_ALTERA
                    ***Select only one VENDOR option***
            `endif
    `else
            `ifndef HQM_VENDOR_ALTERA
                    ***Select atleast one VENDOR option***
            `endif        
    `endif
    
    `ifdef HQM_VENDOR_ALTERA
        `define HQM_GRAM_AUTO "no_rw_check"                         // defaults to auto
        `define HQM_GRAM_BLCK "no_rw_check, M20K"
        `define HQM_GRAM_DIST "no_rw_check, MLAB"
    `endif
    
    //-------------------------------------------
    // Generate error if TOOL not defined
    `ifdef HQM_TOOL_QUARTUS
            `ifdef TOOL_SYNPLIFY
                    ***Select only one TOOL option***
            `endif
            `ifdef TOOL_VIVADO
                    ***Select only one TOOL option***
            `endif
    
    `elsif TOOL_SYNPLIFY
            `ifdef HQM_TOOL_QUARTUS
                    ***Select atleast one TOOL option***
            `endif        
            `ifdef TOOL_VIVADO
                    ***Select atleast one TOOL option***
            `endif        
    `else
            `ifndef TOOL_VIVADO
                    ***Select atleast one TOOL option***
            `endif                
    `endif
    
    `ifdef HQM_TOOL_QUARTUS
        `define HQM_GRAM_STYLE ramstyle
        `define HQM_NO_RETIMING  dont_retime
        `define HQM_NO_MERGE dont_merge
        `define HQM_KEEP_WIRE syn_keep = 1
    `endif
    
    `ifdef TOOL_SYNPLIFY
        `define HQM_GRAM_STYLE syn_ramstyle
        `define HQM_NO_RETIMING syn_allow_retiming=0
        `define HQM_NO_MERGE syn_preserve=1
        `define HQM_KEEP_WIRE syn_keep=1
    
        `ifdef VENDOR_XILINX
            `define HQM_GRAM_AUTO "no_rw_check"
            `define HQM_GRAM_BLCK "block_ram"
            `define HQM_GRAM_DIST "select_ram"
        `endif
    
    `endif 
    
    `ifdef TOOL_VIVADO  
        `define HQM_GRAM_STYLE ram_style
        `define HQM_NO_RETIMING dont_touch="true"
        `define HQM_NO_MERGE dont_touch="true"
        `define HQM_KEEP_WIRE keep="true"
    
        `ifdef VENDOR_XILINX
            `define HQM_GRAM_AUTO "auto_gram"
            `define HQM_GRAM_BLCK "block"
            `define HQM_GRAM_DIST "distributed"
        `endif
    `endif 


`endif
