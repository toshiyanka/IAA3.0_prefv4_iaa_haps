$ZirconScore = `grep "Score for run rules: " $ENV{MODEL_ROOT}/tools/zirconqa/outputs/zirconqa.log`;
chomp($ZirconScore);
$ZirconScore =~ s/\D//g;
print "\nZirconQA score: $ZirconScore";

if($ZirconScore ne "")
{
   if($ZirconScore>=95)
   { 
      print "\nThe Zircon score $ZirconScore met the requirements";
      exit(0);
   }
   else{
      print "\nThe Zircon score $ZirconScore do not met the requirements";
      print "\nAborting...";
      exit(1);      
   }
}
else
{
   print "\nUnable to grep Score in provided log file";
   print "\nAborting";
   exit(1);
}
