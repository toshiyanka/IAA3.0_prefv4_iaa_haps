//--------------DO NOT EDIT COMMENT LINES--------------//


//begin PRE.read_lib

//begin POST.read_lib
set naming rule -mdportflatten

//begin PRE.read_golden
set directive on synopsys translate_off translate_on
//begin POST.read_golden

//begin PRE.read_revised

//begin POST.read_revised

//begin PRE.map
//add pin eq <> <> -revised

//begin mapping
//add map point <> <>

//begin POST.map

//begin PRE.verify
//remodel -seq_merge

//begin POST.verify
//report messages -modeling <>
