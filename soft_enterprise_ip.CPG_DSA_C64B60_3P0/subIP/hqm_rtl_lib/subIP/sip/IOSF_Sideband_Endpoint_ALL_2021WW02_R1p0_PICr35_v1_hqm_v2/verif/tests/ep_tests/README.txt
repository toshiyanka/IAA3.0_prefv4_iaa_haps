ip-iosf-sideband-fabric
|-- README.txt
`-- tests 
    `-- ep_tests -- Endpoint Tests files
                    |-- REAME.txt                       - This file!
                    |-- base_test.svh                	- Base Test 
                    |-- test01.svh               
                    |-- test02.svh               	        
                    |-- test03.sv               	
                    |-- test04.svh     	
                    |-- test05.svh     	   	
                    |-- test06.svh     	   	
                    |-- test07.svh     	   	
                    |-- test08.svh     	   	
                    |-- test09.svh     	   	
                    |-- test10.svh     	   	
                    |-- test11.svh     	   	
                    |-- test12.svh     	   	
                    |-- test13.svh     	   	
                    |-- test14.svh     	   	
                    |-- test15.svh     	   	
                    |-- test16.svh     	   	
                    |-- test17.svh     	   	
                    |-- test18.svh     	   	
                    |-- test19.svh     	   	
                    `-- test20.svh               

Test Detail:

test01: Directed test for basic flow

test02: Random test for basic flow with sparse xactions

test03: Sends directed xactions only from agent side

test04: Sends directed xactions only from agent side, Disables clock gating, 
        completion delay set to 60 for fabric

test05: Sends directed xactions, randomly claims all messages, 
        randomly disables clock gating, async_reset with reset_test, 
        separate reset for agent and fabric, asserts/de-asserts agent and fabric resets

test06: Disables clock gating, sends directed xactions only from fabric

test07: Disables clock gating, sends directed xactions from agent and fabric 
        to cover all xaction level cg related to xaction_type

test08: test to cover agent's ACTIVE_REQ to CREDIT_REQ ism transition, 
        fabric's creditack ism delay set to 10, async_test, reset_test

test09: sets clkack deassert delay to 100, agent claims all xactions, 
        and agent's completion message for np is delayed by 300 cycles.

test10: agent randonly claims all xactions, pc and np crd init delay set to 5  and 4, 
        sends random xactions from agent and fabric

test11: sends random xactions, sets crd init delay and crd updated delay for fabric

test12: agent claims all xactions, sets np completion delay to be 0, and 
        sets flag in the agent to send completion message after 12 posted messages are received.

test13: sets crd update delay for fabric, disables clock gating, 
        sends directed xactions from agent and fabric for covegare

test14: sends random unicast invalid messages from agent and afabric

test15: sets actireq delay for fabric , asserts fabric's reset to 
        hit agent's actireq_req to credit_req ism 

test16: sets activereq delay to be 10 for fabric

test17: sends directed xactions from fabrics

test18: randomly claims all messages, asserts fabric/agent's reset and sends directed xactions, 

test19: set not to claim any xactions, sends invalid messages from fabric and agent

test20: sends directed xactions from agent/fabric



