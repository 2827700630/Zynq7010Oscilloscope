//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
//Date        : Tue Jun 10 00:20:45 2025
//Host        : myhym running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=16,numReposBlks=16,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=6,numPkgbdBlks=0,bdsource=USER,da_board_cnt=1,da_ps7_cnt=2,synth_mode=None}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    LED1,
    LED2,
    adc_clk_0,
    adc_data_input_0,
    crystal_clk_50mhz,
    dac_clk_0,
    dac_data_out_0,
    key_extract_sel_0,
    key_freq_sel_0,
    key_reset_0,
    key_wave_sel_0);
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR ADDR" *) (* X_INTERFACE_MODE = "Master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DDR, AXI_ARBITRATION_SCHEME TDM, BURST_LENGTH 8, CAN_DEBUG false, CAS_LATENCY 11, CAS_WRITE_LATENCY 11, CS_ENABLED true, DATA_MASK_ENABLED true, DATA_WIDTH 8, MEMORY_TYPE COMPONENTS, MEM_ADDR_MAP ROW_COLUMN_BANK, SLOT Single, TIMEPERIOD_PS 1250" *) inout [14:0]DDR_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR BA" *) inout [2:0]DDR_ba;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CAS_N" *) inout DDR_cas_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CK_N" *) inout DDR_ck_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CK_P" *) inout DDR_ck_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CKE" *) inout DDR_cke;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CS_N" *) inout DDR_cs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR DM" *) inout [3:0]DDR_dm;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR DQ" *) inout [31:0]DDR_dq;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR DQS_N" *) inout [3:0]DDR_dqs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR DQS_P" *) inout [3:0]DDR_dqs_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR ODT" *) inout DDR_odt;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR RAS_N" *) inout DDR_ras_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR RESET_N" *) inout DDR_reset_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR WE_N" *) inout DDR_we_n;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO DDR_VRN" *) (* X_INTERFACE_MODE = "Master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME FIXED_IO, CAN_DEBUG false" *) inout FIXED_IO_ddr_vrn;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO DDR_VRP" *) inout FIXED_IO_ddr_vrp;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO MIO" *) inout [53:0]FIXED_IO_mio;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO PS_CLK" *) inout FIXED_IO_ps_clk;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO PS_PORB" *) inout FIXED_IO_ps_porb;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO PS_SRSTB" *) inout FIXED_IO_ps_srstb;
  output LED1;
  output LED2;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.ADC_CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.ADC_CLK_0, CLK_DOMAIN /clk_wiz_0_clk_out1, FREQ_HZ 25000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) output adc_clk_0;
  input [7:0]adc_data_input_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CRYSTAL_CLK_50MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CRYSTAL_CLK_50MHZ, CLK_DOMAIN design_1_clk_in1_0, FREQ_HZ 50000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input crystal_clk_50mhz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.DAC_CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.DAC_CLK_0, CLK_DOMAIN /clk_wiz_0_clk_out1, FREQ_HZ 50000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) output dac_clk_0;
  output [7:0]dac_data_out_0;
  input key_extract_sel_0;
  input key_freq_sel_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.KEY_RESET_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.KEY_RESET_0, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input key_reset_0;
  input key_wave_sel_0;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire LED1;
  wire LED2;
  wire adc_clk_0;
  wire [7:0]adc_data_acquisition_0_adc_data_buffered;
  wire adc_data_acquisition_0_fifo_reset_signal;
  wire [7:0]adc_data_input_0;
  wire clk_wiz_0_key;
  wire crystal_clk_50mhz;
  wire dac_clk_0;
  wire [7:0]dac_data_out_0;
  wire data_extract_0_data_extract_pulse;
  wire [8:0]dds_signal_generator_0_sine_rom_addr;
  wire [8:0]dds_signal_generator_0_square_rom_addr;
  wire [8:0]dds_signal_generator_0_triangle_rom_addr;
  wire digital_trigger_dete_0_digital_trigger_out;
  wire [7:0]fifo_generator_0_dout;
  wire fifo_generator_0_empty;
  wire fifo_generator_0_full;
  wire key_debounce_0_extract_change_pulse;
  wire key_debounce_0_reset_pulse;
  wire key_debounce_0_wave_change_pulse;
  wire key_extract_sel_0;
  wire key_reset_0;
  wire key_wave_sel_0;
  wire processing_system7_0_FCLK_CLK0;
  wire [7:0]sin_douta;
  wire [7:0]square_douta;
  wire [7:0]triangle_douta;
  wire trigger_controller_0_fifo_read_enable;
  wire trigger_controller_0_fifo_write_enable;
  wire trigger_controller_0_fifo_write_ready;
  wire [0:0]xlconstant_0_dout;
  wire [2:0]xlconstant_1_dout;
  wire [7:0]xlconstant_3_dout;

  assign LED2 = key_freq_sel_0;
  design_1_adc_data_acquisition_0_0 adc_data_acquisition_0
       (.adc_clk_25mhz(adc_clk_0),
        .adc_data_buffered(adc_data_acquisition_0_adc_data_buffered),
        .adc_data_input(adc_data_input_0),
        .fifo_reset_signal(adc_data_acquisition_0_fifo_reset_signal),
        .reset_pulse(key_debounce_0_reset_pulse));
  design_1_clk_wiz_0_0 clk_wiz_0
       (.adc_clk25(adc_clk_0),
        .clk_in1(crystal_clk_50mhz),
        .dac_clk50(dac_clk_0),
        .key(clk_wiz_0_key));
  design_1_data_extract_0_0 data_extract_0
       (.adc_clk_25mhz(adc_clk_0),
        .data_extract_pulse(data_extract_0_data_extract_pulse),
        .extract_ratio_change_pulse(key_debounce_0_extract_change_pulse),
        .fifo_write_ready(trigger_controller_0_fifo_write_ready));
  design_1_dds_signal_generator_0_0 dds_signal_generator_0
       (.dac_clk_50mhz(dac_clk_0),
        .dac_data_out(dac_data_out_0),
        .freq_change_pulse(LED1),
        .sine_rom_addr(dds_signal_generator_0_sine_rom_addr),
        .sine_rom_data(sin_douta),
        .square_rom_addr(dds_signal_generator_0_square_rom_addr),
        .square_rom_data(square_douta),
        .triangle_rom_addr(dds_signal_generator_0_triangle_rom_addr),
        .triangle_rom_data(triangle_douta),
        .wave_change_pulse(key_debounce_0_wave_change_pulse));
  design_1_digital_trigger_dete_0_0 digital_trigger_dete_0
       (.adc_clk_25mhz(adc_clk_0),
        .adc_data_in(adc_data_acquisition_0_adc_data_buffered),
        .digital_trigger_out(digital_trigger_dete_0_digital_trigger_out),
        .trigger_enable(xlconstant_0_dout),
        .trigger_hysteresis(xlconstant_1_dout),
        .trigger_level(xlconstant_3_dout));
  design_1_fifo_generator_0_0 fifo_generator_0
       (.clk(adc_clk_0),
        .din(adc_data_acquisition_0_adc_data_buffered),
        .dout(fifo_generator_0_dout),
        .empty(fifo_generator_0_empty),
        .full(fifo_generator_0_full),
        .rd_en(trigger_controller_0_fifo_read_enable),
        .srst(adc_data_acquisition_0_fifo_reset_signal),
        .wr_en(trigger_controller_0_fifo_write_enable));
  design_1_ila_0_0 ila_0
       (.clk(dac_clk_0),
        .probe0(fifo_generator_0_dout),
        .probe1(dac_data_out_0),
        .probe2(adc_data_acquisition_0_adc_data_buffered),
        .probe3(LED2),
        .probe4(key_wave_sel_0),
        .probe5(key_extract_sel_0),
        .probe6(key_reset_0),
        .probe7(LED1),
        .probe8(key_debounce_0_wave_change_pulse),
        .probe9(trigger_controller_0_fifo_read_enable));
  design_1_key_debounce_0_0 key_debounce_0
       (.clk_25mhz(clk_wiz_0_key),
        .extract_change_pulse(key_debounce_0_extract_change_pulse),
        .freq_change_pulse(LED1),
        .key_extract_sel(key_extract_sel_0),
        .key_freq_sel(LED2),
        .key_reset(key_reset_0),
        .key_wave_sel(key_wave_sel_0),
        .reset_pulse(key_debounce_0_reset_pulse),
        .wave_change_pulse(key_debounce_0_wave_change_pulse));
  design_1_processing_system7_0_0 processing_system7_0
       (.DDR_Addr(DDR_addr),
        .DDR_BankAddr(DDR_ba),
        .DDR_CAS_n(DDR_cas_n),
        .DDR_CKE(DDR_cke),
        .DDR_CS_n(DDR_cs_n),
        .DDR_Clk(DDR_ck_p),
        .DDR_Clk_n(DDR_ck_n),
        .DDR_DM(DDR_dm),
        .DDR_DQ(DDR_dq),
        .DDR_DQS(DDR_dqs_p),
        .DDR_DQS_n(DDR_dqs_n),
        .DDR_DRSTB(DDR_reset_n),
        .DDR_ODT(DDR_odt),
        .DDR_RAS_n(DDR_ras_n),
        .DDR_VRN(FIXED_IO_ddr_vrn),
        .DDR_VRP(FIXED_IO_ddr_vrp),
        .DDR_WEB(DDR_we_n),
        .FCLK_CLK0(processing_system7_0_FCLK_CLK0),
        .MIO(FIXED_IO_mio),
        .M_AXI_GP0_ACLK(processing_system7_0_FCLK_CLK0),
        .M_AXI_GP0_ARREADY(1'b0),
        .M_AXI_GP0_AWREADY(1'b0),
        .M_AXI_GP0_BID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .M_AXI_GP0_BRESP({1'b0,1'b0}),
        .M_AXI_GP0_BVALID(1'b0),
        .M_AXI_GP0_RDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .M_AXI_GP0_RID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .M_AXI_GP0_RLAST(1'b0),
        .M_AXI_GP0_RRESP({1'b0,1'b0}),
        .M_AXI_GP0_RVALID(1'b0),
        .M_AXI_GP0_WREADY(1'b0),
        .PS_CLK(FIXED_IO_ps_clk),
        .PS_PORB(FIXED_IO_ps_porb),
        .PS_SRSTB(FIXED_IO_ps_srstb),
        .UART0_RX(1'b1),
        .UART1_CTSN(1'b0),
        .UART1_DCDN(1'b0),
        .UART1_DSRN(1'b0),
        .UART1_RIN(1'b0),
        .USB0_VBUS_PWRFAULT(1'b0));
  design_1_blk_mem_gen_2_0 sine
       (.addra(dds_signal_generator_0_sine_rom_addr),
        .clka(dac_clk_0),
        .douta(sin_douta));
  design_1_sin_0 square
       (.addra(dds_signal_generator_0_square_rom_addr),
        .clka(dac_clk_0),
        .douta(square_douta));
  design_1_square_0 triangle
       (.addra(dds_signal_generator_0_triangle_rom_addr),
        .clka(dac_clk_0),
        .douta(triangle_douta));
  design_1_trigger_controller_0_1 trigger_controller_0
       (.adc_clk_25mhz(adc_clk_0),
        .data_extract_pulse(data_extract_0_data_extract_pulse),
        .digital_trigger_signal(digital_trigger_dete_0_digital_trigger_out),
        .fifo_empty(fifo_generator_0_empty),
        .fifo_full(fifo_generator_0_full),
        .fifo_read_enable(trigger_controller_0_fifo_read_enable),
        .fifo_write_enable(trigger_controller_0_fifo_write_enable),
        .fifo_write_ready(trigger_controller_0_fifo_write_ready));
  design_1_xlconstant_0_1 xlconstant_0
       (.dout(xlconstant_0_dout));
  design_1_xlconstant_1_1 xlconstant_1
       (.dout(xlconstant_1_dout));
  design_1_xlconstant_3_0 xlconstant_3
       (.dout(xlconstant_3_dout));
endmodule
