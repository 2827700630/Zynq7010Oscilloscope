vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/xpm
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_vip_v1_1_21
vlib questa_lib/msim/processing_system7_vip_v1_0_23
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/blk_mem_gen_v8_4_11
vlib questa_lib/msim/fifo_generator_v13_2_13
vlib questa_lib/msim/xlconstant_v1_1_10

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap xpm questa_lib/msim/xpm
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_21 questa_lib/msim/axi_vip_v1_1_21
vmap processing_system7_vip_v1_0_23 questa_lib/msim/processing_system7_vip_v1_0_23
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap blk_mem_gen_v8_4_11 questa_lib/msim/blk_mem_gen_v8_4_11
vmap fifo_generator_v13_2_13 questa_lib/msim/fifo_generator_v13_2_13
vmap xlconstant_v1_1_10 questa_lib/msim/xlconstant_v1_1_10

vlog -work xilinx_vip  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L processing_system7_vip_v1_0_23 -L xilinx_vip "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_if.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/clk_vip_if.sv" \
"E:/FPGA/2025.1/Vivado/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L processing_system7_vip_v1_0_23 -L xilinx_vip "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" \
"E:/FPGA/2025.1/Vivado/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/FPGA/2025.1/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"E:/FPGA/2025.1/Vivado/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  -incr -mfcu  "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_21  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L processing_system7_vip_v1_0_23 -L xilinx_vip "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/f16f/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_23  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L processing_system7_vip_v1_0_23 -L xilinx_vip "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_processing_system7_0_0/sim/design_1_processing_system7_0_0.v" \
"../../../bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0_clk_wiz.v" \
"../../../bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0.v" \
"../../../bd/design_1/ip/design_1_data_extract_0_0/sim/design_1_data_extract_0_0.v" \
"../../../bd/design_1/ip/design_1_dds_signal_generator_0_0/sim/design_1_dds_signal_generator_0_0.v" \
"../../../bd/design_1/ip/design_1_digital_trigger_dete_0_0/sim/design_1_digital_trigger_dete_0_0.v" \
"../../../bd/design_1/ip/design_1_key_debounce_0_0/sim/design_1_key_debounce_0_0.v" \
"../../../bd/design_1/ip/design_1_trigger_controller_0_1/sim/design_1_trigger_controller_0_1.v" \
"../../../bd/design_1/ip/design_1_adc_data_acquisition_0_0/sim/design_1_adc_data_acquisition_0_0.v" \

vlog -work blk_mem_gen_v8_4_11  -incr -mfcu  "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a32c/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_blk_mem_gen_2_0/sim/design_1_blk_mem_gen_2_0.v" \
"../../../bd/design_1/ip/design_1_sin_0/sim/design_1_sin_0.v" \
"../../../bd/design_1/ip/design_1_square_0/sim/design_1_square_0.v" \

vlog -work fifo_generator_v13_2_13  -incr -mfcu  "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/dc46/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_13  -93  \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/dc46/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_13  -incr -mfcu  "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/dc46/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_fifo_generator_0_0/sim/design_1_fifo_generator_0_0.v" \
"../../../bd/design_1/ip/design_1_ila_0_0/sim/design_1_ila_0_0.v" \

vlog -work xlconstant_v1_1_10  -incr -mfcu  "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Zynq7010Oscilloscope.srcs/sources_1/bd/design_1/ipshared/a165/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/6cfa/hdl" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../../../FPGA/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/5431/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/4e08/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/537f/hdl/verilog" "+incdir+../../../../Zynq7010Oscilloscope.gen/sources_1/bd/design_1/ipshared/d41f/hdl/verilog" "+incdir+E:/FPGA/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_xlconstant_3_0/sim/design_1_xlconstant_3_0.v" \
"../../../bd/design_1/ip/design_1_xlconstant_1_1/sim/design_1_xlconstant_1_1.v" \
"../../../bd/design_1/ip/design_1_xlconstant_0_1/sim/design_1_xlconstant_0_1.v" \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

