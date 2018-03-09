onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_point_addition/rst
add wave -noupdate /tb_point_addition/clk
add wave -noupdate /tb_point_addition/load
add wave -noupdate /tb_point_addition/en
add wave -noupdate -radix unsigned /tb_point_addition/X1
add wave -noupdate -radix unsigned /tb_point_addition/Y1
add wave -noupdate -radix unsigned /tb_point_addition/Z1
add wave -noupdate -radix unsigned /tb_point_addition/X2
add wave -noupdate -radix unsigned /tb_point_addition/Y2
add wave -noupdate -radix unsigned /tb_point_addition/Z2
add wave -noupdate /tb_point_addition/done
add wave -noupdate -radix unsigned /tb_point_addition/X3
add wave -noupdate -radix unsigned /tb_point_addition/Y3
add wave -noupdate -radix unsigned /tb_point_addition/Z3
add wave -noupdate /tb_point_addition/dut/inst_FSM/ce
add wave -noupdate /tb_point_addition/dut/inst_FSM/done
add wave -noupdate /tb_point_addition/dut/inst_FSM/opcode
add wave -noupdate /tb_point_addition/dut/inst_FSM/Asel
add wave -noupdate /tb_point_addition/dut/inst_FSM/Bsel
add wave -noupdate /tb_point_addition/dut/inst_FSM/Csel
add wave -noupdate /tb_point_addition/dut/inst_FSM/load_MMALU
add wave -noupdate /tb_point_addition/dut/inst_FSM/FSM_done
add wave -noupdate /tb_point_addition/dut/inst_FSM/curState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 229
configure wave -valuecolwidth 86
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ps} {23227 ps}
