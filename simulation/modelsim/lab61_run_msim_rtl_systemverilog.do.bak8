transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/nyl20/Desktop/FlappyBird {C:/Users/nyl20/Desktop/FlappyBird/frameRAM.sv}
vlog -sv -work work +incdir+C:/Users/nyl20/Desktop/FlappyBird {C:/Users/nyl20/Desktop/FlappyBird/color_mapper.sv}
vlib lab62_soc
vmap lab62_soc lab62_soc

vlog -sv -work work +incdir+C:/Users/nyl20/Desktop/FlappyBird {C:/Users/nyl20/Desktop/FlappyBird/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -L lab62_soc -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 5000 ns
