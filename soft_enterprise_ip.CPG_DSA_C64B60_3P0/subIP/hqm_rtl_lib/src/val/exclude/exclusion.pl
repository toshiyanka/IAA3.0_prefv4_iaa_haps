#!/usr/bin/perl



$IN_FILE= shift;
open INPUT, "<$IN_FILE";
while (<INPUT>) {
  chomp;

  s/ .*.//;
  $_ORIG=$_;

  if ($_ =~ /\[/) {
    if ($_ =~ /:/) {
      $_ = $_ORIG; s/\[.*//; $name=$_;
      $_ = $_ORIG; s/.*\[//; s/:.*//; $max=$_;
      $_ = $_ORIG; s/.*://; s/\].*//; $min=$_;

      if ($MIN{$name} eq "") { $MIN{$name}=0;}
      if ($MAX{$name} eq "") { $MAX{$name}=0;}
      if ($max < $MIN{$name}) {$MIN{$name}=$max;}
      if ($max > $MAX{$name}) {$MAX{$name}=$max;}
      if ($min < $MIN{$name}) {$MIN{$name}=$min;}
      if ($min > $MAX{$name}) {$MAX{$name}=$min;}
    } else {
      $_ = $_ORIG; s/\[.*//; $name=$_;
      $_ = $_ORIG; s/.*\[//; s/\].*//; $bit=$_;
      if ($MIN{$name} eq "") { $MIN{$name}=0;}
      if ($MAX{$name} eq "") { $MAX{$name}=0;}

      if ($bit < $MIN{$name}) {$MIN{$name}=$bit;}
      if ($bit > $MAX{$name}) {$MAX{$name}=$bit;}
    }
  } else {
      $_ = $_ORIG; s/\[.*//; $name=$_;
      $_ = $_ORIG; s/.*\[//; s/\].*//; $bit=$_;
      if ($MIN{$name} eq "") { $MIN{$name}=0;}
      if ($MAX{$name} eq "") { $MAX{$name}=0;}

      if ($bit < $MIN{$name}) {$MIN{$name}=$bit;}
      if ($bit > $MAX{$name}) {$MAX{$name}=$bit;}
  }

}
close INPUT;


open INPUT, "<$IN_FILE";
while (<INPUT>) {
  chomp;

  if ($_ =~ /No/) {
  s/ .*.//;
  $_ORIG=$_;

  if ($_ =~ /\[/) {
    if ($_ =~ /:/) {
      $_ = $_ORIG; s/\[.*//; $name=$_;
      $_ = $_ORIG; s/.*\[//; s/:.*//; $max=$_;
      $_ = $_ORIG; s/.*://; s/\].*//; $min=$_;

      $FULL_RANGE = "\[$MAX{$name}:$MIN{$name}\]"; if ($FULL_RANGE eq "\[0:0\]") {$FULL_RANGE = "";}
      $TOGGLE_RANGE = "\[$max:$min\]";
      print "Toggle $name $TOGGLE_RANGE \"logic $name$FULL_RANGE\"\n";

    } else {
      $_ = $_ORIG; s/\[.*//; $name=$_;
      $_ = $_ORIG; s/.*\[//; s/\].*//; $max=$_; $min=$_;

      $FULL_RANGE = "\[$MAX{$name}:$MIN{$name}\]";  if ($FULL_RANGE eq "\[0:0\]") {$FULL_RANGE = "";}
      $TOGGLE_RANGE = "\[$max:$min\]";
      print "Toggle $name $TOGGLE_RANGE \"logic $name$FULL_RANGE\"\n";

    } 
  } else {
      $_ = $_ORIG; s/\[.*//; $name=$_;

      $FULL_RANGE = "\[$MAX{$name}:$MIN{$name}\]";  if ($FULL_RANGE eq "\[0:0\]") {$FULL_RANGE = "";}
      $TOGGLE_RANGE = "";
      print "Toggle $name $TOGGLE_RANGE \"logic $name$FULL_RANGE\"\n";
  }

  }
}
close INPUT;



