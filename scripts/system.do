onerror {resume}
quietly virtual function -install /system_tb/DUT/CPU/DP1/dpif -env /system_tb/DUT/CPU/DP1/dpif { &{/system_tb/DUT/CPU/DP1/dpif/dmemREN, /system_tb/DUT/CPU/DP1/dpif/dmemWEN, /system_tb/DUT/CPU/DP1/dpif/dmemload, /system_tb/DUT/CPU/DP1/dpif/dmemstore, /system_tb/DUT/CPU/DP1/dpif/dmemaddr }} DP1
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {CORE 0} /system_tb/CLK
add wave -noupdate -expand -group {CORE 0} /system_tb/DUT/CPU/DP0/dpif/halt
add wave -noupdate -expand -group {CORE 0} /system_tb/DUT/CPU/CM0/DCACHE/halt_count
add wave -noupdate -expand -group {CORE 0} /system_tb/DUT/CPU/DP0/PROGRAM_COUNTER/current_pc
add wave -noupdate -expand -group {CORE 0} -format Event -childformat {{{/system_tb/DUT/CPU/CM0/DCACHE/sets[0]} -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1]} -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].valid} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].dirty} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].tag} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].blkoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].bytoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].data} -radix hexadecimal -childformat {{{[1]} -radix hexadecimal} {{[0]} -radix hexadecimal}}}}} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0]} -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].valid} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].dirty} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].tag} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].blkoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].bytoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].data} -radix hexadecimal}}}}}} -expand -subitemconfig {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0]} {-height 17 -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1]} -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].valid} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].dirty} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].tag} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].blkoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].bytoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].data} -radix hexadecimal -childformat {{{[1]} -radix hexadecimal} {{[0]} -radix hexadecimal}}}}} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0]} -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].valid} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].dirty} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].tag} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].blkoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].bytoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].data} -radix hexadecimal}}}} -expand} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1]} {-height 17 -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].valid} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].dirty} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].tag} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].blkoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].bytoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].data} -radix hexadecimal -childformat {{{[1]} -radix hexadecimal} {{[0]} -radix hexadecimal}}}} -expand} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].valid} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].dirty} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].tag} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].blkoff} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].bytoff} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].data} {-height 17 -radix hexadecimal -childformat {{{[1]} -radix hexadecimal} {{[0]} -radix hexadecimal}} -expand} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].data[1]} {-radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][1].data[0]} {-radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0]} {-height 17 -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].valid} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].dirty} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].tag} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].blkoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].bytoff} -radix hexadecimal} {{/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].data} -radix hexadecimal}} -expand} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].valid} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].dirty} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].tag} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].blkoff} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].bytoff} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/CM0/DCACHE/sets[0][0].data} {-height 17 -radix hexadecimal}} /system_tb/DUT/CPU/CM0/DCACHE/sets
add wave -noupdate -expand -group {Core0 CCsigs} /system_tb/DUT/CPU/CM0/cif/ccwait
add wave -noupdate -expand -group {Core0 CCsigs} /system_tb/DUT/CPU/CM0/cif/ccinv
add wave -noupdate -expand -group {Core0 CCsigs} /system_tb/DUT/CPU/CM0/cif/ccwrite
add wave -noupdate -expand -group {Core0 CCsigs} /system_tb/DUT/CPU/CM0/cif/cctrans
add wave -noupdate -expand -group {Core0 CCsigs} /system_tb/DUT/CPU/CM0/DCACHE/snoop_match1
add wave -noupdate -expand -group {Core0 CCsigs} /system_tb/DUT/CPU/CM0/DCACHE/snoop_in
add wave -noupdate -expand -group {Core0 CCsigs} /system_tb/DUT/CPU/CM0/DCACHE/snoop_match
add wave -noupdate -expand -group {Core0 CCsigs} /system_tb/DUT/CPU/CM0/cif/ccsnoopaddr
add wave -noupdate -expand -group {Core0 CCsigs} /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -expand -group {RFIF 1} /system_tb/DUT/CPU/DP0/rfif/WEN
add wave -noupdate -expand -group {RFIF 1} /system_tb/DUT/CPU/DP0/rfif/wsel
add wave -noupdate -expand -group {RFIF 1} /system_tb/DUT/CPU/DP0/rfif/rsel1
add wave -noupdate -expand -group {RFIF 1} /system_tb/DUT/CPU/DP0/rfif/rsel2
add wave -noupdate -expand -group {RFIF 1} /system_tb/DUT/CPU/DP0/rfif/wdat
add wave -noupdate -expand -group {RFIF 1} /system_tb/DUT/CPU/DP0/rfif/rdat1
add wave -noupdate -expand -group {RFIF 1} /system_tb/DUT/CPU/DP0/rfif/rdat2
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/dpif/dmemREN
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/dpif/dmemWEN
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/memwbif/dmemload_in
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/memwbif/dmemload_out
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/dpif/dmemload
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/dpif/dmemstore
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/dpif/dmemaddr
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/CM0/dc/datomic
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/CM0/DCACHE/link_address
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/CM0/DCACHE/link_valid
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/CM0/DCACHE/atomic_hit
add wave -noupdate /system_tb/DUT/CPU/DP0/dpif/dhit
add wave -noupdate -expand -group STATES /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate -expand -group STATES /system_tb/DUT/CPU/CC/COHERENCE/state
add wave -noupdate -expand -group STATES /system_tb/DUT/CPU/CM1/DCACHE/state
add wave -noupdate -expand -group {CORE 1} /system_tb/DUT/CPU/DP1/dpif/dhit
add wave -noupdate -expand -group {CORE 1} /system_tb/DUT/CPU/DP1/dpif/DP1
add wave -noupdate -expand -group {CORE 1} /system_tb/DUT/CPU/DP1/dpif/dmemREN
add wave -noupdate -expand -group {CORE 1} /system_tb/DUT/CPU/DP1/dpif/dmemWEN
add wave -noupdate -expand -group {CORE 1} /system_tb/DUT/CPU/DP1/dpif/dmemload
add wave -noupdate -expand -group {CORE 1} /system_tb/DUT/CPU/DP1/dpif/dmemstore
add wave -noupdate -expand -group {CORE 1} /system_tb/DUT/CPU/DP1/dpif/dmemaddr
add wave -noupdate -expand -group {CORE 1} /system_tb/DUT/CPU/DP1/PROGRAM_COUNTER/current_pc
add wave -noupdate /system_tb/DUT/CPU/DP1/dpif/halt
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/halt_count
add wave -noupdate -expand -group {Core1 CCsigs} /system_tb/DUT/CPU/dcif1/dmemstore
add wave -noupdate -expand -group {Core1 CCsigs} /system_tb/DUT/CPU/CM1/cif/daddr
add wave -noupdate -expand -group {Core1 CCsigs} /system_tb/DUT/CPU/cif1/dstore
add wave -noupdate -expand -group {Core1 CCsigs} /system_tb/DUT/CPU/CM1/cif/ccwait
add wave -noupdate -expand -group {Core1 CCsigs} /system_tb/DUT/CPU/CM1/cif/ccinv
add wave -noupdate -expand -group {Core1 CCsigs} /system_tb/DUT/CPU/CM1/cif/ccwrite
add wave -noupdate -expand -group {Core1 CCsigs} /system_tb/DUT/CPU/CM1/cif/cctrans
add wave -noupdate -expand -group {Core1 CCsigs} /system_tb/DUT/CPU/CM1/cif/ccsnoopaddr
add wave -noupdate -format Event /system_tb/DUT/CPU/CM1/DCACHE/sets
add wave -noupdate -divider INSTRUCTION
add wave -noupdate /system_tb/DUT/CPU/CC/requestor
add wave -noupdate -divider MEMORY
add wave -noupdate -expand -group Coherence /system_tb/DUT/CPU/CC/cocif/ramaddr
add wave -noupdate -expand -group Coherence /system_tb/DUT/CPU/CC/cocif/ramstore
add wave -noupdate -expand -group Coherence /system_tb/DUT/CPU/CC/cocif/wait_in
add wave -noupdate -expand -group Coherence /system_tb/DUT/CPU/CC/cocif/ramWEN
add wave -noupdate -expand -group Coherence /system_tb/DUT/CPU/CC/cocif/ramREN
add wave -noupdate -expand -group Memory /system_tb/DUT/CPU/CC/COHERENCE/requestor
add wave -noupdate -expand -group Memory /system_tb/DUT/CPU/CC/COHERENCE/snoop_hit
add wave -noupdate -expand -group Memory /system_tb/DUT/prif/memstore
add wave -noupdate -expand -group Memory /system_tb/DUT/prif/ramstore
add wave -noupdate -expand -group Memory /system_tb/DUT/prif/ramaddr
add wave -noupdate -expand -group Memory /system_tb/DUT/prif/ramload
add wave -noupdate -expand -group Memory /system_tb/DUT/prif/ramREN
add wave -noupdate -expand -group Memory /system_tb/DUT/prif/ramWEN
add wave -noupdate -divider ALU
add wave -noupdate -divider Registers
add wave -noupdate -divider Controls
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
WaveRestoreCursors {{Cursor 1} {2080000 ps} 0} {{Cursor 2} {4596778 ps} 0}
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
WaveRestoreZoom {2051532 ps} {2230532 ps}
