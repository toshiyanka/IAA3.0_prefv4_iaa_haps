

#ifndef _P1273D5_V10_RS_
#define _P1273D5_V10_RS_


#include <p12723_metal_via_common.rs>


//Set via id and dl (for error output)
#define vid 10
#define vndl 53

#define vian     via10
#define VIAN     VIA10
#define METALN   METAL10


//Include TM1 via common file
#include <p12723_TM1_via.rs>


//Undefine just to be safe
#undef vid 
#undef vndl

#undef vian   
#undef VIAN   
#undef METALN


// Push pass through layers for debug 
drPassthru( VIA10,   53, 0)
drPassthru( METAL10, 54, 0)
drPassthru( TM1,    42, 0)


#endif //_P1273DX_V9_RS_
