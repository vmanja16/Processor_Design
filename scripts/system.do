onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {CORE 0} /system_tb/CLK
add wave -noupdate -expand -group {CORE 0} /system_tb/nRST
add wave -noupdate -expand -group {CORE 0} /system_tb/DUT/CPU/DP0/dpif/halt
add wave -noupdate -expand -group {CORE 0} /system_tb/DUT/CPU/CM0/DCACHE/halt_count
add wave -noupdate -expand -group {CORE 0} /system_tb/DUT/CPU/DP0/PROGRAM_COUNTER/current_pc
add wave -noupdate -expand -group {CORE 0} -expand -subitemconfig {{/system_tb/DUT/CPU/CM0/DCACHE/sets[1]} -expand {/system_tb/DUT/CPU/CM0/DCACHE/sets[1][1]} -expand {/system_tb/DUT/CPU/CM0/DCACHE/sets[0]} {-height 17 -childformat {{{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1]} -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].valid} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].dirty} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].tag} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].blkoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].bytoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].data} -radix hexadecimal -childformat {{{[1]} -radix hexadecimal} {{[0]} -radix hexadecimal}}}}}} -expand} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1]} {-height 17 -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].valid} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].dirty} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].tag} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].blkoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].bytoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].data} -radix hexadecimal -childformat {{{[1]} -radix hexadecimal} {{[0]} -radix hexadecimal}}}} -expand} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].valid} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].dirty} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].tag} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].blkoff} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].bytoff} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].data} {-height 17 -radix hexadecimal -childformat {{{[1]} -radix hexadecimal} {{[0]} -radix hexadecimal}} -expand} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].data[1]} {-radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].data[0]} {-radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0]} -expand} /system_tb/DUT/CPU/CM0/DCACHE/sets
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/state
add wave -noupdate /system_tb/DUT/CPU/CC/COHERENCE/state
add wave -noupdate /system_tb/DUT/CPU/CM0/cif/ccwait
add wave -noupdate /system_tb/DUT/CPU/CM0/cif/ccinv
add wave -noupdate /system_tb/DUT/CPU/CM0/cif/ccwrite
add wave -noupdate /system_tb/DUT/CPU/CM0/cif/cctrans
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/snoop_match1
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/next_snoop_valid
add wave -noupdate -expand /system_tb/DUT/CPU/CM0/DCACHE/snoop_in
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/snoop_match
add wave -noupdate /system_tb/DUT/CPU/CM0/cif/ccsnoopaddr
add wave -noupdate /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -expand -group {CORE 1} /system_tb/DUT/CPU/DP1/PROGRAM_COUNTER/current_pc
add wave -noupdate -expand -group {CORE 1} /system_tb/DUT/CPU/DP1/EXMEM/exmemif/halt_out
add wave -noupdate /system_tb/DUT/CPU/DP1/dpif/halt
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/halt_count
add wave -noupdate /system_tb/DUT/CPU/dcif1/dmemstore
add wave -noupdate /system_tb/DUT/CPU/CM1/cif/daddr
add wave -noupdate /system_tb/DUT/CPU/cif1/dstore
add wave -noupdate /system_tb/DUT/CPU/CM1/cif/ccwait
add wave -noupdate /system_tb/DUT/CPU/CM1/cif/ccinv
add wave -noupdate /system_tb/DUT/CPU/CM1/cif/ccwrite
add wave -noupdate /system_tb/DUT/CPU/CM1/cif/cctrans
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/next_snoop_dirty
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/next_snoop_valid
add wave -noupdate /system_tb/DUT/CPU/CM1/cif/ccsnoopaddr
add wave -noupdate -expand -subitemconfig {{/system_tb/DUT/CPU/CM1/DCACHE/sets[0]} -expand} /system_tb/DUT/CPU/CM1/DCACHE/sets
add wave -noupdate -divider INSTRUCTION
add wave -noupdate /system_tb/DUT/CPU/CC/requestor
add wave -noupdate -divider MEMORY
add wave -noupdate /system_tb/DUT/CPU/CC/COHERENCE/requestor
add wave -noupdate /system_tb/DUT/CPU/CC/COHERENCE/snoop_hit
add wave -noupdate /system_tb/DUT/prif/memstore
add wave -noupdate /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate /system_tb/DUT/prif/ramstore
add wave -noupdate /system_tb/DUT/prif/ramaddr
add wave -noupdate /system_tb/DUT/prif/ramload
add wave -noupdate /system_tb/DUT/prif/ramREN
add wave -noupdate /system_tb/DUT/prif/ramWEN
add wave -noupdate -divider ALU
add wave -noupdate -divider Registers
add wave -noupdate -divider Controls
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
WaveRestoreCursors {{Cursor 1} {3080154 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 40
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
WaveRestoreZoom {3061509 ps} {3171594 ps}
