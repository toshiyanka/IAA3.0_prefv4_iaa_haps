
module ip (

    input           fdfx_earlyboot_exit,
    input           fdfx_policy_update,
    input   [3:0]   fdfx_secure_policy,

    input           TdiT731L,
    input           TmsT731L,
    input           TrstbT731L,
    input           Tclk,
    output          TdoT731H,

    input           Tdi_2,
    input           Tms_2,
    output          Tdo_2,
    input           Trstb_2,

    input           ijtag_si,
    output          ijtag_so,
    input           ijtag_sel,
    input           ijtag_reset_b,

    input           sen,
    input           cen,
    input           uen,

    input           si_AB,
    output          so_AB,

    input    [1:0]  si,
    output   [1:0]  so,
    input    [1:0]  sel,

    input           si_A,
    output          so_A,
    input           sel_A,

    input           si_B,
    output          so_B,
    input           sel_B,
    input    [1:0]  sel_ABC,

    input  [31:0]   ftap_slvidcode,
    input  [31:0]   ftap_slvidcode_1,
    input  [31:0]   ftap_slvidcode_2,
    input  [7:0]    status,

    output  [3:0]   enable_1,
    output  [3:0]   enable_A,

    input           fdfx_powergood
);


endmodule
