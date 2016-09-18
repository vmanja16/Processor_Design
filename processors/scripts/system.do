onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/halt
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/cpu_halt
add wave -noupdate /system_tb/DUT/CPU/DP/PROGRAM_COUNTER/current_pc
add wave -noupdate -divider INSTRUCTION
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/imemload
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/dWEN
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -divider MEMORY
add wave -noupdate /system_tb/DUT/prif/memstore
add wave -noupdate /system_tb/DUT/prif/ramload
add wave -noupdate /system_tb/DUT/prif/ramREN
add wave -noupdate /system_tb/DUT/prif/ramWEN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate -divider ALU
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/al/alu_op
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/al/port_a
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/al/port_b
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/al/port_o
add wave -noupdate -divider Registers
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/rdat1
add wave -noupdate -radix decimal /system_tb/DUT/CPU/DP/RF/rfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP/CF/cuif/WEN
add wave -noupdate -radix decimal /system_tb/DUT/CPU/DP/CF/cuif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP/RF/register
add wave -noupdate -divider Controls
add wave -noupdate /system_tb/DUT/CPU/DP/CF/cuif/alusrc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22391266642 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1194320274 ns}
