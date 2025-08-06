vlib work
vlog SPI.v ram.v wrapper.v TB.v
vsim -voptargs=+acc work.TB
add wave sim:/TB/dut/*
add wave *
run -all
#quit -sim
