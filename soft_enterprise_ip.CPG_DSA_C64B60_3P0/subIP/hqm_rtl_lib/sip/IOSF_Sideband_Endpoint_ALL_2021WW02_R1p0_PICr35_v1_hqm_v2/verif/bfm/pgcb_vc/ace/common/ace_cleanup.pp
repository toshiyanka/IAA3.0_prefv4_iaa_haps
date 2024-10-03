# -*-perl-*- for Emacs
{
################################################################################
# Note: All regular expressions must be placed with single quotes '/example/i' 
#  instead of double quotes "/example/i"
################################################################################
    %CONFIG = (
        ## to keep track of cleanup activities for debug purpose
        -verbose => 1,

        ## Optional: specify a find command to locate all linked files for '-exclude_dirs_with_links'.
        -exclude_dirs_find_cmd => "find . -maxdepth 1 -type l",
    
        ## Optional: -exclude_dirs_with_links wil exclude <test run>/<tid>/$dir from cleanup
        -exclude_dirs_with_links => "1",
    
        ## to run cleanup in following order
        -task_order => ['DoNotTouch', 'Delete', 'GZip',  ],
    
        ## to use bzip2 instead of gzip thus to get 30% more compaction
        #-zip_cmd => "find \$file -type f | xargs bzip2 -f ",
    
        ## No files matching this list of regular expression are ever touched
        ##  regardless of mode or status
        NeverTouch => [
            '/postsim\.(log|pass|fail)/',
            '/.*include.*/',
            '/.*\.pcov.*/',
            '/.*postmortem.*/', # this is to prevent nbmon to fail because of this file being zipped or deleted
        ],
    
        Modes => {
            ## This mode is intended to be used for interactive and command line jobs
            "local" => {
                ## Following is true for passing tests (postsim.pass present)
                Pass => {
                    ## The lists have the following precedence: DoNotTouch, GZip, Delete
                    DoNotTouch => [
                        '/.*sv_(asn|cov).*/',
                        '/.*\.vdb/',
                    ],
                    GZip       => [
                        '/src\.list.*/',
                        '/.*reglog.*/',
                        '/.*\.rpt/',
                        '/.*\.log/',
                        '/.*\_log/',
                        '/.*\.txt/',
                        '/.*\.sv/',
                        '/.*\.out/',
                        '/.*\.OUT/',
                        '/.*\.sh/',
                        '/.*\.pl/',
                        '/.*\.(rtl|vlog|vhdl)list/',
                        '/\/images\/ppm.*/',
                        '/trkfiles/',
                        '/errfiles/',
                        '/memory_in/',
                        '/memory_out/',
                        '/fd2d/',
                        '/fdmi/',
                    ],          
                    Delete     => [
                        '/.*\.timestamp$/',
                        '/regress_flag/',
                        '/.*csrc/',
                        '/.*\.simv.*/',
                        '/.*vcs_testlib/',
                        '/.*PrintHier.txt.*/',
                        '/fd3d/',
                    ],
                    Move        => [
                    ],
                },      
    
                ## Following is true for failing tests (postsim.fail present)
                Fail => {
                    DoNotTouch => [
                    ],
                    GZip       => [
                        '/.*reglog.*/',
                        '/src\.list.*/',
                        '/.*\.rpt/',
                        '/.*\.log/',
                        '/.*\_log/',
                        '/.*\.txt/',
                        '/.*\.sv/',
                        '/.*\.out/',
                        '/.*\.OUT/',
                        '/.*\.sh/',
                        '/.*\.pl/',
                        '/.*\.(rtl|vlog|vhdl)list/',
                        '/\/images\/ppm.*/',
                        '/trkfiles/',
                        '/errfiles/',
                        '/memory_in/',
                        '/memory_out/',
                        '/fd2d/',
                        '/fdmi/',
                    ],
                    Delete     => [
                        '/.*\.timestamp$/',
                        '/regress_flag/',
                        '/.*csrc/',
                        '/.*\.simv.*/',
                        '/.*vcs_testlib/',
                        '/.*sv_(asn|cov).*/',
                        '/.*\.vdb/',
                        '/.*PrintHier.txt.*/',
                        '/fd3d/',
                    ],                   
                },
            },
             
            ## This mode is intended for netbatch jobs
            "batch" => {
                ## Following is true for passing tests (postsim.pass present)
                Pass => {
                    ## The lists have the following precedence: DoNotTouch, GZip, Delete
                    DoNotTouch => [
                        '/.*sv_(asn|cov).*/',
                        '/.*\.vdb/',
                        '/.*\.nb/', #to prevent .nb log being removed/zipped
                    ],
                    GZip       => [
                        '/src\.list.*/',
                        '/.*\.rpt/',
                        '/.*\.log/',
                        '/.*\_log/',
                        '/.*\.txt/',
                        '/.*reglog.*/',
                        '/.*\.sv/',
                        '/.*\.out/',
                        '/.*\.OUT/',
                        '/.*\.sh/',
                        '/.*\.pl/',
                        '/.*\.(rtl|vlog|vhdl)list/',
                        '/\/images\/ppm.*/',
                        '/trkfiles/',
                        '/errfiles/',
                        '/memory_in/',
                        '/memory_out/',
                        '/fd2d/',
                        '/fdmi/',
                    ],          
                    Delete     => [
                        '/.*\.timestamp$/',
                        '/regress_flag/',
                        '/.*csrc/',
                        '/.*\.simv.*/',
                        '/.*vcs_testlib/',
                        '/.*PrintHier.txt.*/',
                        '/fd3d/',
                    ],        
                },      
    
                ## Following is true for failing tests (postsim.fail present)
                Fail => {
                    DoNotTouch => [
                        '/.*\.nb/', #to prevent .nb log being removed/zipped
                    ],
                    GZip       => [
                        '/.*reglog.*/',
                        '/src\.list.*/',
                        '/.*\.rpt/',
                        '/.*\.log/',
                        '/.*\_log/',
                        '/.*\.txt/',
                        '/.*\.sv/',
                        '/.*\.out/',
                        '/.*\.OUT/',
                        '/.*\.sh/',
                        '/.*\.pl/',
                        '/.*\.(rtl|vlog|vhdl)list/',
                        '/\/images\/ppm.*/',
                        '/trkfiles/',
                        '/errfiles/',
                        '/memory_in/',
                        '/memory_out/',
                        '/fd2d/',
                        '/fdmi/',
                    ],
                    Delete     => [
                        '/.*\.timestamp$/',
                        '/regress_flag/',
                        '/.*csrc/',
                        '/.*\.simv.*/',
                        '/.*vcs_testlib/',
                        '/.*sv_(asn|cov).*/',
                        '/.*\.vdb/',
                        '/.*PrintHier.txt.*/',
                        '/fd3d/',
                    ],                   
                },
            },
        },      
    );
};
