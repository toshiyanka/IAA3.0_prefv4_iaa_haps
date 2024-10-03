scripts/port_parameter_checker.pl --interface_control_file tools/interface_control/cdc_wrapper_ifccntl.txt --input_port_parameter_file target/collage/ip_kits/cdc_wrapper.build.summary > target/interface_check.log  
scripts/interface_checker.pl --interface_control_file tools/interface_control/cdc_wrapper_ifccntl.txt --input_port_parameter_file target/collage/ip_kits/cdc_wrapper.build.summary >> target/interface_check.log 
scripts/port_parameter_checker.pl --interface_control_file tools/interface_control/dft_reset_sync_ifccntl.txt --input_port_parameter_file target/collage/ip_kits/dft_reset_sync.build.summary >> target/interface_check.log
scripts/interface_checker.pl --interface_control_file tools/interface_control/dft_reset_sync_ifccntl.txt --input_port_parameter_file target/collage/ip_kits/dft_reset_sync.build.summary >> target/interface_check.log 
scripts/port_parameter_checker.pl --interface_control_file tools/interface_control/ip_disable_ifccntl.txt --input_port_parameter_file target/collage/ip_kits/ip_disable.build.summary >> target/interface_check.log  
scripts/interface_checker.pl --interface_control_file tools/interface_control/ip_disable_ifccntl.txt --input_port_parameter_file target/collage/ip_kits/ip_disable.build.summary >> target/interface_check.log 
scripts/port_parameter_checker.pl --interface_control_file tools/interface_control/fuse_hip_glue_ifccntl.txt --input_port_parameter_file target/collage/ip_kits/fuse_hip_glue.build.summary >> target/interface_check.log
scripts/interface_checker.pl --interface_control_file tools/interface_control/fuse_hip_glue_ifccntl.txt --input_port_parameter_file target/collage/ip_kits/fuse_hip_glue.build.summary >> target/interface_check.log 

