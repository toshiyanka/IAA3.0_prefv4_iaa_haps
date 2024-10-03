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

print "\/\/\n";
print "\/\/ Replace HIER_PFX with hierachy prefix, e\.g\. hqm_core_tb_top\.u_hqm_core\.par_hqm_list_sel_pipe\.i_hqm_list_sel_pipe\.i_hqm_list_sel_pipe_core\.\n";
print "\/\/\n";

open INPUT, "<$IN_FILE";
while (<INPUT>) {
  chomp;

  if ( ($_ =~ /No/) && ! ($_ =~ /^Other /) && ! ($_ =~ /\./) && ! ($_ =~ /]\[/ ) ) {

  s/ .*.//;
  $_ORIG=$_;

  if ($_ =~ /\[/) {
    if ($_ =~ /:/) {
      $_ = $_ORIG; s/\[.*//; $name=$_;
      $_ = $_ORIG; s/.*\[//; s/:.*//; $max=$_;
      $_ = $_ORIG; s/.*://; s/\].*//; $min=$_;

      $FULL_RANGE = "\[$MAX{$name}:$MIN{$name}\]"; if ($FULL_RANGE eq "\[0:0\]") {$FULL_RANGE = "";}
      $TOGGLE_RANGE = "\[$max:$min\]";
#     print "Toggle $name $TOGGLE_RANGE \"logic $name$FULL_RANGE\"\n";
      print "-node HIER_PFX\.$name$TOGGLE_RANGE\n";

    } else {
      $_ = $_ORIG; s/\[.*//; $name=$_;
      $_ = $_ORIG; s/.*\[//; s/\].*//; $max=$_; $min=$_;

      $FULL_RANGE = "\[$MAX{$name}:$MIN{$name}\]";  if ($FULL_RANGE eq "\[0:0\]") {$FULL_RANGE = "";}
      $TOGGLE_RANGE = "\[$max:$min\]";
#     print "Toggle $name $TOGGLE_RANGE \"logic $name$FULL_RANGE\"\n";
      print "-node HIER_PFX\.$name$TOGGLE_RANGE\n";

    } 
  } else {
      $_ = $_ORIG; s/\[.*//; $name=$_;

      $FULL_RANGE = "\[$MAX{$name}:$MIN{$name}\]";  if ($FULL_RANGE eq "\[0:0\]") {$FULL_RANGE = "";}
      $TOGGLE_RANGE = "";
#     print "Toggle $name $TOGGLE_RANGE \"logic $name$FULL_RANGE\"\n";
      print "-node HIER_PFX\.$name$TOGGLE_RANGE\n";
  }

}
}

close INPUT;

print "\n";
print "\/\/ Not included struct element:\n";
open INPUT, "<$IN_FILE";
while (<INPUT>) {

  if ( ($_ =~ /No/) && ($_ =~ /\./) ) {
    print ;
  }
}

close INPUT;

print "\n";
print "\/\/ Not included MDA:\n";
open INPUT, "<$IN_FILE";
while (<INPUT>) {

  if ( ($_ =~ /No/) && ($_ =~ /]\[/ ) && ! ($_ =~ /^Other /) ) {
    print ;
  }
}

close INPUT;

print "\n";
print "\/\/ Not included Other:\n";
open INPUT, "<$IN_FILE";
while (<INPUT>) {

  if ( ($_ =~ /No/) && ($_ =~ /^Other /) ) {
    print ;
  }
}

close INPUT;
