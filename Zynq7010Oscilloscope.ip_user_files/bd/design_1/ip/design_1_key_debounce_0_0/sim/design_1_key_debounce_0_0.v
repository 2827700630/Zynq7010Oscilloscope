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


// IP VLNV: xilinx.com:module_ref:key_debounce:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_key_debounce_0_0 (
  clk_25mhz,
  key_freq_sel,
  key_wave_sel,
  key_extract_sel,
  key_reset,
  freq_change_pulse,
  wave_change_pulse,
  extract_change_pulse,
  reset_pulse
);

input wire clk_25mhz;
input wire key_freq_sel;
input wire key_wave_sel;
input wire key_extract_sel;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 key_reset RST" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME key_reset, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
input wire key_reset;
output wire freq_change_pulse;
output wire wave_change_pulse;
output wire extract_change_pulse;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_pulse RST" *)
(* X_INTERFACE_MODE = "master" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset_pulse, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
output wire reset_pulse;

  key_debounce inst (
    .clk_25mhz(clk_25mhz),
    .key_freq_sel(key_freq_sel),
    .key_wave_sel(key_wave_sel),
    .key_extract_sel(key_extract_sel),
    .key_reset(key_reset),
    .freq_change_pulse(freq_change_pulse),
    .wave_change_pulse(wave_change_pulse),
    .extract_change_pulse(extract_change_pulse),
    .reset_pulse(reset_pulse)
  );
endmodule
