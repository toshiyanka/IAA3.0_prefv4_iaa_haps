set default_impl "${base_name}_default" 
set TopLevelDetect_impl "${base_name}_TopLevelDetect"
set toplist_filename "${TopLevelDetect_impl}/\.toplist"
set modlist_file "${TopLevelDetect_impl}\.lst"
set EMUL_CFG_DIR      $::env(EMUL_CFG_DIR)
set EMUL_RESULTS_DIR  $::env(EMUL_RESULTS_DIR)
set EMUL_TOOLS_DIR    $::env(EMUL_TOOLS_DIR)

puts "LOG: EMUL_CFG_DIR $EMUL_CFG_DIR\n" 
puts "LOG: EMUL_RESULTS_DIR $EMUL_RESULTS_DIR\n" 
puts "LOG: EMUL_TOOLS_DIR $EMUL_TOOLS_DIR\n" 

impl -add $TopLevelDetect_impl $default_impl
add_file -vhdl     -lib bogus_vhdl_lib    "$EMUL_TOOLS_DIR/fpga/bogus_vhdl_module.vhdl"
add_file -verilog  -lib bogus_verilog_lib "$EMUL_TOOLS_DIR/fpga/bogus_verilog_module.v"
impl -active "$TopLevelDetect_impl"

project -result_file "${TopLevelDetect_impl}_syntax_check.edf"
project -run compile

puts "syntax_check completed\n"
if {[catch {exec cp  $toplist_filename toplist_file } results]} {
   if {[lindex $::errorCode 0] eq "CHILDSTATUS"} {
      set status [lindex $::errorCode 2]
   } else {
      puts "ERR: cp $toplist_filename toplist_file  " 
   }
}

if [catch {open $modlist_file w } file_out ] { 
  puts "ERR: File $modlist_file cant be created" 
  return 
}

if [catch {open toplist_file r } file_log_id ] { 
    puts "ERR : File toplist_file cant be opened.\n" 
    return 
}
puts "LOG : File toplist_file opened.\n" 
set file_data [read $file_log_id]
close $file_log_id

puts "LOG : single_module_only : $single_module_only.\n" 

puts "LOG : Start reading file.\n" 
#while { [gets $file_log_id file_line] >=0} { 
set data [split $file_data "\n"]


foreach file_line $data {
     puts "LOG : Line : $file_line.\n" 

     if {[regexp "bogus.+" $file_line]==0} { 
         puts  "LOG : top :  $file_line" 
         set_option -top_module $file_line
         project -run compile_dm 
         set blocks_list [dm_blocks -hier] 
         foreach block $blocks_list { 
            set dm_module_block [split [dm_module $block] { } ] 
            set origname [lindex $dm_module_block 1] 
            set lang [lindex $dm_module_block 2] 
            set blackbox [lindex $dm_module_block 3] 
            set params [ dm_param $block ]
            puts "FOUND $origname , $lang , $blackbox, $dm_module_block : $block params : $params" 
            puts $file_out "$origname $params" 
         }
         if { $single_module_only == 1 } {
            break
         }
     }  
 } 
close $file_out