// ad9434_lvds_receiver_sdr.v
// AD9434 SDR 数据接收核心逻辑 - 简化版
// 假设 AD9434 输出 12 位 SDR 数据。
// **重要:** 此模块现在依赖外部 SelectIO Interface Wizard IP (或类似 IP)
// 进行 LVDS 接收、IDELAY 和 ISERDES 功能。
// 它接收已经串并转换后的并行数据。

module ad9434_lvds_receiver_sdr (
    // -- 时钟输入 (由外部 Clocking Wizard 提供) --
    // clk_iserdes, clk_iserdes_b, clk_idelay_ctrl_ref 不再由此模块直接使用
    input wire clk_parallel_data, // 并行数据输出时钟 (例如 50MHz for 100MHz DCO / SF=2), 用于锁存输入数据
    input wire mmcm_locked,         // 外部 MMCM/PLL 的锁定信号

    // -- 并行数据输入 (来自 SelectIO IP) --
    input wire [11:0] adc_parallel_data_in, // 12 位并行 ADC 数据

    // -- 系统接口 --
    input wire sys_rst_n,        // 系统复位，低电平有效

    // -- ADC 数据输出 --
    output reg [11:0] adc_data_out, // 12 位 ADC 并行数据输出
    output reg adc_data_valid     // 数据有效信号
);

    // 输出 12 位并行数据
    // 数据在 clk_parallel_data 的上升沿有效
    always @(posedge clk_parallel_data or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            adc_data_out <= 12'b0;
            adc_data_valid <= 1'b0;
        end else if (mmcm_locked) begin // 仅当 MMCM 锁定时数据才有效
            adc_data_out <= adc_parallel_data_in; // 直接使用输入的并行数据
            adc_data_valid <= 1'b1; // 数据有效信号在mmcm_locked后立即有效
        end else begin
            adc_data_out <= 12'b0;
            adc_data_valid <= 1'b0;
        end
    end

endmodule
