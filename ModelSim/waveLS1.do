onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /MIPS_Processor_TB/DUV/clk
add wave -noupdate -radix decimal /MIPS_Processor_TB/DUV/PC_wire
add wave -noupdate /MIPS_Processor_TB/DUV/ALUSrc_wire
add wave -noupdate -radix decimal /MIPS_Processor_TB/DUV/MUX_RFWrite_wire
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/InmmediateExtend_wire
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/ALUResult_wire
add wave -noupdate /MIPS_Processor_TB/DUV/MemWrite_wire
add wave -noupdate /MIPS_Processor_TB/DUV/MemRead_wire
add wave -noupdate /MIPS_Processor_TB/DUV/RegWrite_wire
add wave -noupdate /MIPS_Processor_TB/DUV/MemtoReg_wire
add wave -noupdate /MIPS_Processor_TB/DUV/RAMReadData_wire
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/ReadData1_wire
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/InmmediateExtend_wire
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/ReadData2OrInmmediate_wire
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {5 ps} {21 ps}
