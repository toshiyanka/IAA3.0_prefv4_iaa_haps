
sub configs {
  my ($CASE) = @_ ;

use POSIX;
for ( $int = 1 ; $int < 100 ; $int++ ) {
for ( $mult = 1 ; $mult < 40 ; $mult++ ) {
$num = $int*($mult**2); 
$log = ceil ( log($num)/log(2) );  if ($log == 0) {$log = 1; }
$B2{$num}=$log ;
}
}
  $B2{"2"} = 1; $B2{"4"} = 2; $B2{"8"} = 3; $B2{"16"} = 4; $B2{"32"} = 5; $B2{"64"} = 6; $B2{"128"} = 7; $B2{"192"} = 8; $B2{"256"} = 8; $B2{"384"} = 9; $B2{"512"} = 9; $B2{"1024"} = 10; $B2{"2048"} = 11; $B2{"4096"} = 12; $B2{"5120"} = 13; $B2{"8192"} = 13; $B2{"16384"} = 14; $B2{"32768"} = 15; $B2{"65536"} = 16;

  if ( ($CASE eq "ARCH") ) {
  $VF               = 16;
  $VAS              = 32;

  $DIR_ENABLE       = 1 ;
  $LB_ENABLE        = 1 ;
  $ATM_ENABLE       = 1 ;
  $ORD_ENABLE       = 1 ;
  
  $LBCRD            = 32768;  $LBCRDpad=($B2{32768}-$B2{$LBCRD});
  $DIRCRD           = 8192;   $DIRCRDpad=($B2{8192}-$B2{$DIRCRD});
  $ATMCRD           = 2048;   $ATMCRDpad=($B2{2048}-$B2{$ATMCRD});
  
  $DIRCQ            = 128 ;   $DIRCQpad=($B2{128}-$B2{$DIRCQ});
  $DIRQID           = 128 ;   $DIRQIDpad=($B2{128}-$B2{$DIRQID});
  $LBCQ             = 64 ;    $LBCQpad=($B2{64}-$B2{$LBCQ});
  $LBQID            = 128 ;   $LBQIDpad=($B2{128}-$B2{$LBQID});
  $QIDIX            = 8 ;
  
  $HIST             = 5120 ;  $HISTpad=$B2{5120}-$B2{$HIST};
  $HCW_ECC          = 128+16; $HCW_ECCpad=(0);
  $FID              = 2048;   $FIDpad=($B2{4096}-$B2{$FID});
  $PRI              = 8;
  $BIN              = 4;      $BIN0=1;$BIN1=1;$BIN2=1;$BIN3=1;
  }
  
  if ( ($CASE eq "HQM") ) {
  $VF               = 16;
  $VAS              = 32;

  $DIR_ENABLE       = 1 ;
  $LB_ENABLE        = 1 ;
  $ATM_ENABLE       = 1 ;
  $ORD_ENABLE       = 1 ;
  
  $LBCRD            = 16384;  $LBCRDpad=($B2{32768}-$B2{$LBCRD});
  $DIRCRD           = 4096;   $DIRCRDpad=($B2{8192}-$B2{$DIRCRD});
  $ATMCRD           = 2048;   $ATMCRDpad=($B2{2048}-$B2{$ATMCRD});
  
  $DIRCQ            = 128 ;   $DIRCQpad=($B2{128}-$B2{$DIRCQ});
  $DIRQID           = 128 ;   $DIRQIDpad=($B2{128}-$B2{$DIRQID});
  $LBCQ             = 64 ;    $LBCQpad=($B2{64}-$B2{$LBCQ});
  $LBQID            = 128 ;   $LBQIDpad=($B2{128}-$B2{$LBQID});
  $QIDIX            = 8 ;
  
  $HIST             = 5120 ;  $HISTpad=$B2{5120}-$B2{$HIST};
  $HCW_ECC          = 128+16; $HCW_ECCpad=(0);
  $FID              = 2048;   $FIDpad=($B2{4096}-$B2{$FID});
  $PRI              = 8;
  $BIN              = 4;      $BIN0=1;$BIN1=1;$BIN2=1;$BIN3=1;
  }
  

  if ( ($CASE eq "HQMv2") ) {
  $VF               = 16;
  $VAS              = 32;
  $DVAS             = 32;

  $DIR_ENABLE       = 1 ;
  $LB_ENABLE        = 1 ;
  $ATM_ENABLE       = 1 ;
  $ORD_ENABLE       = 1 ;

  $LBCRD            = 8192;   $LBCRDpad=($B2{32768}-$B2{$LBCRD});
  $DIRCRD           = 4096;   $DIRCRDpad=($B2{8192}-$B2{$DIRCRD});
  $ATMCRD           = 2048;   $ATMCRDpad=($B2{2048}-$B2{$ATMCRD});

  $DIRCQ            = 64 ;    $DIRCQpad=($B2{128}-$B2{$DIRCQ});
  $DIRQID           = 64 ;    $DIRQIDpad=($B2{128}-$B2{$DIRQID});
  $LBCQ             = 64 ;    $LBCQpad=($B2{64}-$B2{$LBCQ});
  $LBQID            = 32 ;    $LBQIDpad=($B2{128}-$B2{$LBQID});
  $QIDIX            = 8 ;

  $HIST             = 2048 ;  $HISTpad=$B2{5120}-$B2{$HIST};
  $HCW_ECC          = 128+16; $HCW_ECCpad=(0);
  $FID              = 2048;   $FIDpad=($B2{4096}-$B2{$FID});
  $PRI              = 8;
  $BIN              = 4;      $BIN0=1;$BIN1=1;$BIN2=1;$BIN3=1;
  }


  if ( ($CASE eq "HQMv25") ) {
  $VF               = 16;
  $VAS              = 32;
  $DVAS             = 32;

  $DIR_ENABLE       = 1 ;
  $LB_ENABLE        = 1 ;
  $ATM_ENABLE       = 1 ;
  $ORD_ENABLE       = 1 ;

  $TOTCRD           = 16384 ; $TOTCRDpad=0;
  $ATMCRD           = 2048;   $ATMCRDpad=($B2{2048}-$B2{$ATMCRD});

  $DIRCQ            = 96 ;    $DIRCQpad=($B2{128}-$B2{$DIRCQ});
  $DIRQID           = 96 ;    $DIRQIDpad=($B2{128}-$B2{$DIRQID});
  $LBCQ             = 64 ;    $LBCQpad=($B2{64}-$B2{$LBCQ});
  $LBQID            = 32 ;    $LBQIDpad=($B2{128}-$B2{$LBQID});
  $QIDIX            = 8 ;

  $HIST             = 2048 ;  $HISTpad=$B2{5120}-$B2{$HIST};
  $HCW_ECC          = 128+16; $HCW_ECCpad=(0);
  $FID              = 2048;   $FIDpad=($B2{4096}-$B2{$FID});
  $PRI              = 8;
  $BIN              = 4;      $BIN0=1;$BIN1=1;$BIN2=1;$BIN3=1;
  }


  if ( ($CASE eq "HQMv26") ) {
  $VF               = 16;
  $VAS              = 32;
  $DVAS             = 32;

  $DIR_ENABLE       = 1 ;
  $LB_ENABLE        = 1 ;
  $ATM_ENABLE       = 1 ;
  $ORD_ENABLE       = 1 ;

  $TOTCRD           = 8192 ;  $TOTCRDpad=0;
  $ATMCRD           = 2048;   $ATMCRDpad=($B2{2048}-$B2{$ATMCRD});

  $DIRCQ            = 64 ;    $DIRCQpad=($B2{128}-$B2{$DIRCQ});
  $DIRQID           = 64 ;    $DIRQIDpad=($B2{128}-$B2{$DIRQID});
  $LBCQ             = 64 ;    $LBCQpad=($B2{64}-$B2{$LBCQ});
  $LBQID            = 32 ;    $LBQIDpad=($B2{128}-$B2{$LBQID});
  $QIDIX            = 8 ;

  $HIST             = 2048 ;  $HISTpad=$B2{5120}-$B2{$HIST};
  $HCW_ECC          = 128+16; $HCW_ECCpad=(0);
  $FID              = 2048;   $FIDpad=($B2{4096}-$B2{$FID});
  $PRI              = 8;
  $BIN              = 4;      $BIN0=1;$BIN1=1;$BIN2=1;$BIN3=1;
  }


  if ( ($CASE eq "HQMv3") ) {
  $VF               = 16;
  $VAS              = 32;
  $DVAS             = 32;

  $DIR_ENABLE       = 1 ;
  $LB_ENABLE        = 1 ;
  $ATM_ENABLE       = 1 ;
  $ORD_ENABLE       = 1 ;

  $TOTCRD           = 16384 ; $TOTCRDpad=0;
  $ATMCRD           = 2048;   $ATMCRDpad=($B2{2048}-$B2{$ATMCRD});

  $DIRCQ            = 64 ;    $DIRCQpad=($B2{128}-$B2{$DIRCQ});
  $DIRQID           = 64 ;    $DIRQIDpad=($B2{128}-$B2{$DIRQID});
  $LBCQ             = 64 ;    $LBCQpad=($B2{64}-$B2{$LBCQ});
  $LBQID            = 32 ;    $LBQIDpad=($B2{128}-$B2{$LBQID});
  $QIDIX            = 8 ;

  $HIST             = 2048 ;  $HISTpad=$B2{5120}-$B2{$HIST};
  $HCW_ECC          = 128+16; $HCW_ECCpad=(0);
  $FID              = 2048;   $FIDpad=($B2{4096}-$B2{$FID});
  $PRI              = 8;
  $BIN              = 4;      $BIN0=1;$BIN1=1;$BIN2=1;$BIN3=1;

  $ROB              = 2048 ;
  }


}
1; 

