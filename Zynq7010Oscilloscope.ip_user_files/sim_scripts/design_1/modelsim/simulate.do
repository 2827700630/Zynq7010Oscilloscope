onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc"  -L xil_defaultlib -L xilinx_vip -L xpm -L axi_infrastructure_v1_1_0 -L axi_vip_v1_1_21 -L processing_system7_vip_v1_0_23 -L blk_mem_gen_v8_4_11 -L xlconstant_v1_1_10 -L util_vector_logic_v2_0_5 -L proc_sys_reset_v5_0_17 -L axi_datamover_v5_1_37 -L axi_sg_v4_1_21 -L axi_dma_v7_1_36 -L fifo_generator_v13_2_13 -L smartconnect_v1_0 -L axi_register_slice_v2_1_35 -L generic_baseblocks_v2_1_2 -L axi_data_fifo_v2_1_35 -L axi_protocol_converter_v2_1_36 -L axi_clock_converter_v2_1_34 -L axi_dwidth_converter_v2_1_36 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.design_1 xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {design_1.udo}

run 1000ns

quit -force
