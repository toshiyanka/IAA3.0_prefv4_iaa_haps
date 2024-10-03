README.txt
=============================================================================
- This is a README file which describes common operations in this repository
- Please keep this README file clean with crisp information

SOURCE RC FILE FOR 10nm LV 
=============================================================================
> source /p/srvr10nm/lv/cfg/rtl.rc

HOW TO BUILD ALL STAGES OF A IP 
=============================================================================
> simbuild -dut <ip-name> -sched local -collage -keep

HOW TO BUILD VCS STAGE of A IP 
=============================================================================
> simbuild -dut <ip-name> -sched local -s all +s vcs

HOW TO BUILD COLLAGE STAGE of A IP 
=============================================================================
> simbuild -dut <ip-name> -sched local -s all +s collage -collage -keep

