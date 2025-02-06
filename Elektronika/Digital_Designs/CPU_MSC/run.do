view wave -title wave_1

clear
vlib  work
vdel -all
vlog -f file.f -dbg
vsim +access+r top -dbg

framework.window.activate -window wave_1

wave sim:/top/cpu_inst/*
wave sim:/top/cpu_inst/alu_inst/*

run -all
