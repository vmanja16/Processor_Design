onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/RAMCLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate /dcache_tb/C/DCACHE/state
add wave -noupdate /dcache_tb/C/DCACHE/cif/dREN
add wave -noupdate /dcache_tb/C/DCACHE/cif/dwait
add wave -noupdate /dcache_tb/dcif/dmemload
add wave -noupdate /dcache_tb/PROG/dcif/dmemaddr
add wave -noupdate /dcache_tb/dcif/dhit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {150931 ps} 0}
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
WaveRestoreZoom {110325 ps} {246825 ps}
