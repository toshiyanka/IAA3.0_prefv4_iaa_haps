`define TEST_TIME 1000000000
`define ASSERT_EQ(cond, str, name=`__LINE__)\
 chk_``name``: assert ( cond ) else $error($psprintf("ERROR:%s",str));

`define DUT_TOP tb.ClockDomainController_1
 


//`include "CdcPgClock.sva"
//`include "CdcMainClock.sva"

