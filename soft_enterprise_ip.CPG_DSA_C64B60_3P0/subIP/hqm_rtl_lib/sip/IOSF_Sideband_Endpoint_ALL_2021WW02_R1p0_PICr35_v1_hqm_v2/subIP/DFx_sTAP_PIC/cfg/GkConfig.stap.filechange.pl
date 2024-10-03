################################################################################################
# Store file change action
# specify the actions that needs to be invoked based on every file changed. (smart turnin config file)
################################################################################################

our %filechange_action = (
        "ace" =>            [ "build", "DOA",],
        "doc" =>            [  ],
        "scripts" =>        [ "build", "DOA",],
        "cfg"     =>        [ "build", "DOA",],
        "config"  =>        [ "build", "DOA",],
        "source/rtl" =>     [ "build", "DOA", "lintra_build", "lintra_run","febe_ip_turnin",  ],
        "verif" =>          [ "build", "DOA","lintra_svtb", ],
        "tools/cdc" =>      [ "build","DOA","simbuild_CDC", ],
        "tools/collage" =>  [ "build","DOA","simbuild_collage", ],
        "tools/fpv" =>      [  ],
        "tools/fev" =>      ["build","DOA","febe_ip_turnin","febe_ip_fev", ],
        "tools/lint" =>     [ "build", "lintra_build","lintra_run",],
        "tools/svtb_lintra" =>     [ "build", "lintra_svtb",                    ],

        #"tools/noble" =>    [ "build", "DOA", "lintra_build", "lintra_run", "febe_ip_turnin","febe_ip_FEV",  ],
        "tools/noble" =>    [ "build", "DOA", "lintra_build", "lintra_run", "febe_ip_turnin", ],
        "tools/rdl" =>      [  ],
        "tools/srdl" =>     [  ],
        "tools/syn" =>      ["build", "febe_ip_turnin", ],
        "tools/zirconqa" => [   ],
);
;

