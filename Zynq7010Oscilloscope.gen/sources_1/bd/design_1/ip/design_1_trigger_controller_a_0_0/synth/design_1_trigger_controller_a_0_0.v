// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:trigger_controller_axi_stream:1.0
// IP Revision: 1

(* X_CORE_INFO = "trigger_controller_axi_stream,Vivado 2025.1" *)
(* CHECK_LICENSE_TYPE = "design_1_trigger_controller_a_0_0,trigger_controller_axi_stream,{}" *)
(* CORE_GENERATION_INFO = "design_1_trigger_controller_a_0_0,trigger_controller_axi_stream,{x_ipProduct=Vivado 2025.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=trigger_controller_axi_stream,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,TDATA_WIDTH=32,ADC_DATA_WIDTH=8,TRIGGER_PACKET_WORD_COUNT=512}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_trigger_controller_a_0_0 (
  adc_clk_25mhz,
  sys_rst_n,
  digital_trigger_signal,
  data_extract_pulse,
  adc_data_input,
  m_axis_tdata,
  m_axis_tvalid,
  m_axis_tready,
  m_axis_tlast,
  trigger_ready_status,
  trigger_active_status
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 adc_clk_25mhz CLK" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME adc_clk_25mhz, FREQ_HZ 25000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, ASSOCIATED_BUSIF m_axis, ASSOCIATED_RESET sys_rst_n, INSERT_VIP 0" *)
input wire adc_clk_25mhz;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 sys_rst_n RST" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME sys_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
input wire sys_rst_n;
input wire digital_trigger_signal;
input wire data_extract_pulse;
input wire [7 : 0] adc_data_input;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TDATA" *)
(* X_INTERFACE_MODE = "master" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 25000000, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0, ASSOCIATED_CLOCK adc_clk_25mhz" *)
output wire [31 : 0] m_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TVALID" *)
output wire m_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TREADY" *)
input wire m_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TLAST" *)
output wire m_axis_tlast;
output wire trigger_ready_status;
output wire trigger_active_status;

  trigger_controller_axi_stream #(
    .TDATA_WIDTH(32),
    .ADC_DATA_WIDTH(8),
    .TRIGGER_PACKET_WORD_COUNT(512)
  ) inst (
    .adc_clk_25mhz(adc_clk_25mhz),
    .sys_rst_n(sys_rst_n),
    .digital_trigger_signal(digital_trigger_signal),
    .data_extract_pulse(data_extract_pulse),
    .adc_data_input(adc_data_input),
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tready(m_axis_tready),
    .m_axis_tlast(m_axis_tlast),
    .trigger_ready_status(trigger_ready_status),
    .trigger_active_status(trigger_active_status)
  );
endmodule
