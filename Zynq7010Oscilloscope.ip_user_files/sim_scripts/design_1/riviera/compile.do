transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/xpm
vlib riviera/axi_infrastructure_v1_1_0
vlib riviera/axi_vip_v1_1_21
vlib riviera/processing_system7_vip_v1_0_23
vlib riviera/xil_defaultlib
vlib riviera/blk_mem_gen_v8_4_11
vlib riviera/fifo_generator_v13_2_13
vlib riviera/xlconstant_v1_1_10

vmap xilinx_vip riviera/xilinx_vip
vmap xpm riviera/xpm
vmap axi_infrastructure_v1_1_0 riviera/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_21 riviera/axi_vip_v1_1_21
vmap processing_system7_vip_v1_0_23 riviera/processing_system7_vip_v1_0_23
vmap xil_defaultlib riviera/xil_defaultlib
vmap blk_mem_gen_v8_4_11 riviera/blk_mem_gen_v8_4_11
vmap fifo_generator_v13_2_13 riviera/fifo_generator_v13_2_13
vmap xlconstant_v1_1_10 riviera/xlconstant_v1_1_10

vlog -work xilinx_vip  -incr "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_21 -l processing_system7_vip_v1_0_23 -l xil_defaultlib -l blk_mem_gen_v8_4_11 -l fifo_generator_v13_2_13 -l xlconstant_v1_1_10 \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_if.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/clk_vip_if.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_21 -l processing_system7_vip_v1_0_23 -l xil_defaultlib -l blk_mem_gen_v8_4_11 -l fifo_generator_v13_2_13 -l xlconstant_v1_1_10 \
"E:/FPGA/2025.1/Vivado/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/FPGA/2025.1/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"E:/FPGA/2025.1/Vivado/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  -incr -v2k5 "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_21 -l processing_system7_vip_v1_0_23 -l xil_defaultlib -l blk_mem_gen_v8_4_11 -l fifo_generator_v13_2_13 -l xlconstant_v1_1_10 \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_21  -incr "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_21 -l processing_system7_vip_v1_0_23 -l xil_defaultlib -l blk_mem_gen_v8_4_11 -l fifo_generator_v13_2_13 -l xlconstant_v1_1_10 \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/f16f/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_23  -incr "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_21 -l processing_system7_vip_v1_0_23 -l xil_defaultlib -l blk_mem_gen_v8_4_11 -l fifo_generator_v13_2_13 -l xlconstant_v1_1_10 \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_21 -l processing_system7_vip_v1_0_23 -l xil_defaultlib -l blk_mem_gen_v8_4_11 -l fifo_generator_v13_2_13 -l xlconstant_v1_1_10 \
"../../../bd/design_1/ip/design_1_processing_system7_0_0/sim/design_1_processing_system7_0_0.v" \
"../../../bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0_clk_wiz.v" \
"../../../bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0.v" \
"../../../bd/design_1/ip/design_1_data_extract_0_0/sim/design_1_data_extract_0_0.v" \
"../../../bd/design_1/ip/design_1_dds_signal_generator_0_0/sim/design_1_dds_signal_generator_0_0.v" \
"../../../bd/design_1/ip/design_1_digital_trigger_dete_0_0/sim/design_1_digital_trigger_dete_0_0.v" \
"../../../bd/design_1/ip/design_1_key_debounce_0_0/sim/design_1_key_debounce_0_0.v" \
"../../../bd/design_1/ip/design_1_trigger_controller_0_1/sim/design_1_trigger_controller_0_1.v" \
"../../../bd/design_1/ip/design_1_adc_data_acquisition_0_0/sim/design_1_adc_data_acquisition_0_0.v" \

vlog -work blk_mem_gen_v8_4_11  -incr -v2k5 "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_21 -l processing_system7_vip_v1_0_23 -l xil_defaultlib -l blk_mem_gen_v8_4_11 -l fifo_generator_v13_2_13 -l xlconstant_v1_1_10 \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a32c/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_21 -l processing_system7_vip_v1_0_23 -l xil_defaultlib -l blk_mem_gen_v8_4_11 -l fifo_generator_v13_2_13 -l xlconstant_v1_1_10 \
"../../../bd/design_1/ip/design_1_blk_mem_gen_2_0/sim/design_1_blk_mem_gen_2_0.v" \
"../../../bd/design_1/ip/design_1_sin_0/sim/design_1_sin_0.v" \
"../../../bd/design_1/ip/design_1_square_0/sim/design_1_square_0.v" \

vlog -work fifo_generator_v13_2_13  -incr -v2k5 "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_21 -l processing_system7_vip_v1_0_23 -l xil_defaultlib -l blk_mem_gen_v8_4_11 -l fifo_generator_v13_2_13 -l xlconstant_v1_1_10 \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/dc46/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_13 -93  -incr \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/dc46/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_13  -incr -v2k5 "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_21 -l processing_system7_vip_v1_0_23 -l xil_defaultlib -l blk_mem_gen_v8_4_11 -l fifo_generator_v13_2_13 -l xlconstant_v1_1_10 \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/dc46/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_21 -l processing_system7_vip_v1_0_23 -l xil_defaultlib -l blk_mem_gen_v8_4_11 -l fifo_generator_v13_2_13 -l xlconstant_v1_1_10 \
"../../../bd/design_1/ip/design_1_fifo_generator_0_0/sim/design_1_fifo_generator_0_0.v" \
"../../../bd/design_1/ip/design_1_ila_0_0/sim/design_1_ila_0_0.v" \

vlog -work xlconstant_v1_1_10  -incr -v2k5 "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_21 -l processing_system7_vip_v1_0_23 -l xil_defaultlib -l blk_mem_gen_v8_4_11 -l fifo_generator_v13_2_13 -l xlconstant_v1_1_10 \
"../../../../Zynq7010Oscilloscope.srcs/sources_1/bd/design_1/ipshared/a165/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_21 -l processing_system7_vip_v1_0_23 -l xil_defaultlib -l blk_mem_gen_v8_4_11 -l fifo_generator_v13_2_13 -l xlconstant_v1_1_10 \
"../../../bd/design_1/ip/design_1_xlconstant_3_0/sim/design_1_xlconstant_3_0.v" \
"../../../bd/design_1/ip/design_1_xlconstant_1_1/sim/design_1_xlconstant_1_1.v" \
"../../../bd/design_1/ip/design_1_xlconstant_0_1/sim/design_1_xlconstant_0_1.v" \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

