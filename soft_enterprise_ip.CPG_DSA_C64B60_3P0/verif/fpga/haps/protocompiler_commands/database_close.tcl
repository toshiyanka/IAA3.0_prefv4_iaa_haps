foreach s [database list] {
    puts "$s:"
    database set $s
    export report -path $env(TARGET_DIR)/rtl_diag/ -all
    report list -verbose
}
database close
exit
