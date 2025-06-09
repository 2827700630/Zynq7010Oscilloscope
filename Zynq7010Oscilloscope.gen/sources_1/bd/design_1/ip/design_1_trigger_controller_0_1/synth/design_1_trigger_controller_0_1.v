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


// IP VLNV: xilinx.com:module_ref:trigger_controller:1.0
// IP Revision: 1

(* X_CORE_INFO = "trigger_controller,Vivado 2025.1" *)
(* CHECK_LICENSE_TYPE = "design_1_trigger_controller_0_1,trigger_controller,{}" *)
(* CORE_GENERATION_INFO = "design_1_trigger_controller_0_1,trigger_controller,{x_ipProduct=Vivado 2025.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=trigger_controller,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_trigger_controller_0_1 (
  adc_clk_25mhz,
  fifo_empty,
  fifo_full,
  digital_trigger_signal,
  data_extract_pulse,
  pre_trigger_count,
  trigger_ready,
  trigger_state,
  fifo_write_ready,
  fifo_read_enable,
  fifo_write_enable
);

input wire adc_clk_25mhz;
input wire fifo_empty;
input wire fifo_full;
input wire digital_trigger_signal;
input wire data_extract_pulse;
output wire [10 : 0] pre_trigger_count;
output wire trigger_ready;
output wire trigger_state;
output wire fifo_write_ready;
output wire fifo_read_enable;
output wire fifo_write_enable;

  trigger_controller inst (
    .adc_clk_25mhz(adc_clk_25mhz),
    .fifo_empty(fifo_empty),
    .fifo_full(fifo_full),
    .digital_trigger_signal(digital_trigger_signal),
    .data_extract_pulse(data_extract_pulse),
    .pre_trigger_count(pre_trigger_count),
    .trigger_ready(trigger_ready),
    .trigger_state(trigger_state),
    .fifo_write_ready(fifo_write_ready),
    .fifo_read_enable(fifo_read_enable),
    .fifo_write_enable(fifo_write_enable)
  );
endmodule
