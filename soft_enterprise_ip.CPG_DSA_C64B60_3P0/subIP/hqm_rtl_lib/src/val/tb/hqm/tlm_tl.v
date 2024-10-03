`timescale 10fs/10fs

module tlm_tl(
);
    parameter interface_soma = "";
    parameter init_file   = "";
    parameter sim_control = "";

initial
    $pcie_access();
endmodule

