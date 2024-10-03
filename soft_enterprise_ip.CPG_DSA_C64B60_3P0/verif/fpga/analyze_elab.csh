source test.bash
make -f $TARGET_DIR/analyzed_libs/Makefile all_analysis -j $NUM_ANALYZE_PARALLEL_JOBS
source elab.src
