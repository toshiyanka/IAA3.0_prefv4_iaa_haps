echo "Generating Filelists\n"
make -C gen_filelist clean

make -C gen_filelist

echo "Build all Sim Models"
#make -C verif/vcsssim

echo "Running RTL Tools"

setenv STATIC_LIST "sglint vclp sgdft sgcdc effm_zebu effm_veloce effm_fpga"

foreach item ($STATIC_LIST)
    echo "Running Static Tool: $item"
    make -C static/$item $item\_compile
    make -C static/$item $item\_run
end

##Look for PASS Logs
##ld output/devtlb/*/*/*/*PASS

echo "Running BE Handoff Flows"

make -C verif/vcs   vcs_compile
make -C verif/vcs   vcs_elab
make -C handoff/h2b h2b
make -C handoff/h2b v2k_config
make -C handoff/h2b package

echo "Running Light Weight Synth"

rm output/devtlb/genfile*/.pass/syn_genfile.PASS
make -C syn/fc synth_elab
make -C syn/fc synth_run



