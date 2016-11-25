onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /coherence_control_tb/CLK
add wave -noupdate /coherence_control_tb/nRST
add wave -noupdate /coherence_control_tb/M/state
add wave -noupdate /coherence_control_tb/M/writer
add wave -noupdate /coherence_control_tb/M/int_wait
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {81 ns} 0}
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
WaveRestoreZoom {60 ns} {276 ns}
