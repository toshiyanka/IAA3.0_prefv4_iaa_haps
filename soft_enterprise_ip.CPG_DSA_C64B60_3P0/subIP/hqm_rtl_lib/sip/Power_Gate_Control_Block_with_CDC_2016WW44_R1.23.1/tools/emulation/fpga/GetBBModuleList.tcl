set default_impl "${prj_basename}_default" 
set BlackBoxDetect_impl "${prj_basename}_${top_module}_BlackBoxDetect"
set BlackBoxDetect_file "${prj_basename}_${top_module}_BlackBoxDetect.lst"
impl -add $BlackBoxDetect_impl $default_impl


if [catch {open $BlackBoxDetect_file w } file_out ] { 
  puts "ERR: File $BlackBoxDetect_file cant be created" 
  return 
}  

project -result_file "${BlackBoxDetect_impl}/${BlackBoxDetect_impl}.edf"

set_option -top_module ${lib_name}.${top_module}
#project -run compile_dm 
project -run compile
open_design "${BlackBoxDetect_impl}/${BlackBoxDetect_impl}.srs"
puts "BlackBoxDetect dm_compile completed\n"
set bb_list [find -rtl -hier -inst {*}  -filter (@is_black_box)]
#set inst_name [get_prop -prop orig_inst_of ${bb_list} ]
set tmp_lst [c_list $bb_list -prop orig_inst_of]
puts $file_out "$tmp_lst\n"
close $file_out