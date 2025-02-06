view wave -title wave_1

clear
vlib  work
vdel -all
vlog -f files.f -dbg
vsim +access+r testbench_top -dbg

wave sim:/testbench_top/uut/*

run -all


## TODO 
## 1. test na clock reset - puy.ścić na kloku, zaresetować w trakcie, z czasem po opoznieniu puścić test, w  trakcie testuy jebnac reset. 
## 2. sprawdzic acc, zrobic load, wulaczyc ce i czekac
## 3/4. utrzymac ce a potem zgasic na reszte ctesty
## 5. puscic test z sekwencja wielu dla kazdej instrukcji. 





wave sim:/testbench_top/clk

wave sim:/testbench_top/intf/*



