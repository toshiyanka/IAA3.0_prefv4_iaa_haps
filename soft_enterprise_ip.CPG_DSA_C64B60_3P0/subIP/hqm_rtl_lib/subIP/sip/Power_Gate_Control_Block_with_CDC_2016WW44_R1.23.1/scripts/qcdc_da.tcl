 do /p/com/eda/intel/cdc/v20140603/prototype/cdc_global.tcl; do   /p/com/eda/intel/cdc/v20140603/custom_sync_cells/p1273/custom_sync_cells.tcl; do   /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/pgcbunit/pgcbunit_cdc.tcl; do   /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/pgcbunit/pgcbunit_waivers.tcl; cdc run -work cdc_pgcbunit_lib -L work  -L pgcb_collection_cdc_testlib -L cdc_tooltb_lib -L cdc_synccell_lib -L cdc_pgcbcg_lib -L cdc_ClockDomainController_lib -L cdc_pgcbunit_lib  -d pgcbunit  -hier  ; cdc generate crossings   /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_pgcbunit/Violation_Details.rpt  ; cdc generate tree -reset /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_pgcbunit/Reset_Details.rpt  ; cdc generate tree -clock /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_pgcbunit/Clock_Details.rpt 