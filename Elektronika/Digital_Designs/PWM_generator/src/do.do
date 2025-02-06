										  
										  
clear										  
vdel -all
vlog dut.v dut_tb.v
vsim PWM_gen_tb +access +r
run -all