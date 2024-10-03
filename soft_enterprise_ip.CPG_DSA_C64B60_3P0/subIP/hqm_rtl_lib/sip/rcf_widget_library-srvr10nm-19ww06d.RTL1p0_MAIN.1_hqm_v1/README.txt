README.txt
=============================================================================
- This is a README file which describes common operations in this repository
- Please keep this README file clean with crisp information

HOW TO BUILD ALL STAGES OF A IP 
============================================================================= 
bman
bman -mc <ip> //where ip is either cdc_wrapper, dft_reset_sync, or fpg_pok

TO RUN FULL FEBE from the command line (after building all models)
======================================
bman -dut rcfwl -flow ip_release -s .sd_noa -s global -gkturnin

TO RUN THE INTERFACE CHECKER from the command line
==================================================
source tools/interface_control/run_interface_control.csh



