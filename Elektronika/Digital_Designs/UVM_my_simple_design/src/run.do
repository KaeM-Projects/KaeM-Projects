
clear
vdel -all
vlog -f files.f -uvm
vsim tb_top
run