//--------------DO NOT EDIT COMMENT LINES--------------//


//begin PRE.read_lib

//begin POST.read_lib
//set naming rule -mdportflatten

//begin PRE.read_golden

//begin POST.read_golden

//begin PRE.read_revised

//begin POST.read_revised

//begin PRE.map
//add pin eq <> <> -revised
add renaming rule -PIN_MULTIDIM_TO_1DIM -both

//begin mapping
//add map point <> <>

//begin POST.map

//begin PRE.verify
//delete map points *ascan_sdo*
//remodel -seq_merge

//begin POST.verify
//report messages -modeling <>
