//------------------------------------------------------------------------------
// Class: hqm_address_map_builder
// Address Map DUT view builder
//------------------------------------------------------------------------------
import address_map_dut_view_pkg::address_map_dut_view_builder;
import address_map_dut_view_pkg::address_map_dut_view_config;

class hqm_address_map_builder extends address_map_dut_view_pkg::address_map_dut_view_builder;
  `ovm_object_utils(hqm_address_map_builder)

  // Required constructor
  function new(string name = "");
    super.new(name);
  endfunction

  // Override of DUT view builder virtual function
  // Populate with minimum set of top level regions that must exist
  virtual function void build_address_map(address_map_dut_view_pkg::address_map_dut_view_config cfg);
     $display("[%0t] hqm_address_map_builder:: build_address_map start", $time);


    // Address, length, space, parent-region, region
    // IO region
    cfg.add_region('h0000_0000, 'h0001_0004, address_map_dut_view_pkg::address_map_dut_view_config::IO, "", "LEGACY_IO");
    // CFG region
    cfg.add_region('h0000_0000, 'h1000_0000, address_map_dut_view_pkg::address_map_dut_view_config::CFG, "", "MMIO");
    // MEM regions
    cfg.add_region('h8000_0000,        'h1000_0000,     address_map_dut_view_pkg::address_map_dut_view_config::MEM, "", "MMCFG");
    cfg.add_region('h9000_0000,        'h6e00_0000,     address_map_dut_view_pkg::address_map_dut_view_config::MEM, "", "MMIO_LOW");
    cfg.add_region('h10_8000_0000,   'h8_0000_0000,     address_map_dut_view_pkg::address_map_dut_view_config::MEM, "", "MMIO_HIGH");
    cfg.add_region('hFE00_0000,        'h0200_0000,     address_map_dut_view_pkg::address_map_dut_view_config::MEM, "", "NO_EGO");
    cfg.add_region('hFEC0_0000,        'h0010_0000,     address_map_dut_view_pkg::address_map_dut_view_config::MEM, "NO_EGO", "IOAPIC"); // sub-region of NO-EGO
    cfg.add_region('h0000_0000,        'h8000_0000,     address_map_dut_view_pkg::address_map_dut_view_config::MEM, "", "DRAM_LOW");
    cfg.add_region('h1_0000_0000,    'hf_8000_0000,     address_map_dut_view_pkg::address_map_dut_view_config::MEM, "", "DRAM_HIGH");
  endfunction
endclass


