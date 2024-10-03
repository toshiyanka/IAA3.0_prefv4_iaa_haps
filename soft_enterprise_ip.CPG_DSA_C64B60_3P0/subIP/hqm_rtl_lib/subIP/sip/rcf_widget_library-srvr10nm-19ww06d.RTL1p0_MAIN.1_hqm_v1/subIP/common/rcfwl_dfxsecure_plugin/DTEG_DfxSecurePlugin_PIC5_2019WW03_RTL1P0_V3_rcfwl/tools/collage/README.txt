General command simbuild -dut ${DUT} -s all +s collage -1c -CUST ${CUST} -1c-

For CNL: 
simbuild -dut dfxsecure_plugin -s all +s collage -1c -CUST CNL -1c-
cp -f outputs/collage/ip_kits/dfxsecure_plugin.coreKit coreKit/dfxsecure_plugin.coreKit
cp -f outputs/collage/reports/dfxsecure_plugin.build.* reports

For CDF:
simbuild -dut dfxsecure_plugin -s all +s collage -1c -CUST CDF -1c-
cp -f outputs/collage/ip_kits/dfxsecure_plugin.coreKit coreKit/dfxsecure_plugin.coreKit
cp -f outputs/collage/reports/dfxsecure_plugin.build.* reports

    

