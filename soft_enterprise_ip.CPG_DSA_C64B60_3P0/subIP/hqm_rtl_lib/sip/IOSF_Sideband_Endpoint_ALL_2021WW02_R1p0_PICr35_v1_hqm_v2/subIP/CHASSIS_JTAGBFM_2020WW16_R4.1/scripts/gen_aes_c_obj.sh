#!/bin/csh -f

gcc -I.   -I/usr/intel/pkgs/openssl/0.9.8-32.orig/include \
    -c    $IP_ROOT/scripts/aes_c_enc_dec_wrapper.c \
    -o    $IP_ROOT/scripts/aes_c_enc_dec_wrapper.o 
