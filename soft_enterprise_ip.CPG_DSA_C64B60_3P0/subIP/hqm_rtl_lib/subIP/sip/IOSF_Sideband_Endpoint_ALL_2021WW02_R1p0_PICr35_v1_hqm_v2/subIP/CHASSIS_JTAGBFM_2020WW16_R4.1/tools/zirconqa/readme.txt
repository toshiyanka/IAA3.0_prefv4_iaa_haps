Commands to run Zircon:
-----------------------

Get list of projects using the IP:
==================================
/p/sip/utils/bin/preZirconQA -list-varis

Copy and rename the following files according to the version of Zircon:
=======================================================================
cp -rf sptlp_override_1.x.dat sptlp_override_1.y.dat
cp -rf sptlp_ignore_1.x.dat sptlp_ignore_1.y.dat

Open GUI to add exclusions: In current example SunrisePoint is chosen.
===========================
/p/sip/utils/bin/preZirconQA -ip 'DFx JTAG BFM' -proj 'SunrisePoint-LP' -vari 'SPTLP'

Command line script to run Zircon:
==================================
/p/sip/utils/bin/zirconQA -ip 'DFx JTAG BFM' -proj 'SunrisePoint-LP' -vari 'SPTLP'

Command line script to run with more details of Zircon rules:
=============================================================
/p/sip/utils/bin/zirconQA -ip 'DFx JTAG BFM' -proj 'SunrisePoint-LP' -vari 'SPTLP' -verbose3 > temp
