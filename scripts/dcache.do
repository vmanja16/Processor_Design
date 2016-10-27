onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/RAMCLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate /dcache_tb/C/DCACHE/state
add wave -noupdate /dcache_tb/C/DCACHE/cif/dREN
add wave -noupdate /dcache_tb/C/DCACHE/cif/dwait
add wave -noupdate /dcache_tb/PROG/dcif/dmemload
add wave -noupdate /dcache_tb/PROG/dcif/dmemaddr
add wave -noupdate /dcache_tb/PROG/dcif/dhit
add wave -noupdate /dcache_tb/C/DCACHE/readhit
add wave -noupdate -radix hexadecimal /dcache_tb/cif0/dload
add wave -noupdate /dcache_tb/dcif/dmemREN
add wave -noupdate /dcache_tb/dcif/dmemWEN
add wave -noupdate /dcache_tb/PROG/cif/dstore
add wave -noupdate /dcache_tb/PROG/cif/dREN
add wave -noupdate /dcache_tb/PROG/cif/dWEN
add wave -noupdate /dcache_tb/C/cif/daddr
add wave -noupdate /dcache_tb/C/DCACHE/readhit
add wave -noupdate /dcache_tb/C/DCACHE/read_tag_miss_clean
add wave -noupdate /dcache_tb/C/DCACHE/read_tag_miss_dirty
add wave -noupdate /dcache_tb/C/DCACHE/writehit
add wave -noupdate /dcache_tb/C/DCACHE/write_tag_miss_clean
add wave -noupdate /dcache_tb/C/DCACHE/write_tag_miss_dirty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {528864 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 171
configure wave -valuecolwidth 61
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
WaveRestoreZoom {472253 ps} {611134 ps}
