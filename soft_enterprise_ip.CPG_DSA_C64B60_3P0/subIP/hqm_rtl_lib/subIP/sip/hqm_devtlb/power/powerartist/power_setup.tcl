
# Specify clock tree inferencing 
#SetClockBuffer -type root -name SEQCLKBUFX4MTH -library hvt -fanout 2
#SetClockBuffer -type branch -name SEQCLKBUFX8MTH -library hvt -fanout 4
#SetClockBuffer -type leaf -name SEQCLKBUFX8MTH -library hvt -fanout 60
#
## Set up clock gate inferencing
SetClockGatingStyle -clock_cell_attribute latch_posedge_precontrol -min_bit_width 3 -min_bit_width_ecg 6
#
## Specify non-clock high fanout net buffer tree inferencing
#SetHighFanoutNet -fanout 16
#SetBuffer -type root -name SEQBUFX2MTH -library hvt -fanout 4
#SetBuffer -type branch -name SEQBUFX2MTH -library hvt -fanout 8
#SetBuffer -type leaf -name SEQBUFX2MTH -library hvt -fanout 16
SetClockBuffer -type leaf   -name ec0bfm201an1n02x5 -library ec0_nn_p1274d3_tttt_v085_t100_max -net devtlb.clk
#
## Specify wire load model
#SetWireLoadModel -name cmos65_wl30 -library hvt -instance * -net *
#
## Specify unique string pattern per threshold voltage library
#SetVoltageThreshold -group LOW_VT -pattern {*L}
#SetVoltageThreshold -group HIGH_VT -pattern {*H}
#
## Specify %VT utilization
#SetVT -mode percentage -instance {top.core1.u1 top.core1.a1} -vt_group {LOW_VT:30 HIGH_VT:70}
