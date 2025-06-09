`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: adc_data_acquisition
// 功能描述: ADC数据采集模块 - 负责ADC数据接收、缓冲和FIFO复位
// 创建日期: 2025/06/09
//
// 功能说明:
//   1. ADC数据同步采集和缓冲
//   2. 系统复位控制 (生成FIFO复位信号)
//
// 输入接口:
//   - 系统时钟 (adc_clk_25mhz)
//   - ADC原始数据 (adc_data_input)
//   - 复位控制信号 (reset_pulse)
//
// 输出接口:
//   - 缓冲后的ADC数据 (adc_data_buffered)
//   - FIFO复位信号 (fifo_reset_signal)
//////////////////////////////////////////////////////////////////////////////////

module adc_data_acquisition (
    // 时钟信号
    input wire adc_clk_25mhz,           // ADC工作时钟25MHz
    
    // ADC数据输入
    input wire [7:0] adc_data_input,    // ADC原始数据输入
    
    // 控制信号
    input wire reset_pulse,             // 系统复位脉冲
    
    // ADC数据输出
    output reg [7:0] adc_data_buffered, // 缓冲后的ADC数据
    
    // 控制输出
    output reg fifo_reset_signal       // FIFO复位信号
);

    // 内部寄存器定义
    reg [7:0] adc_data_sync_reg1;       // ADC数据同步寄存器第一级
    reg [7:0] adc_data_sync_reg2;       // ADC数据同步寄存器第二级
    reg reset_pulse_delayed;            // 复位脉冲延迟

    //===========================================================================
    // ADC数据多级同步采集
    // 使用多级寄存器减少亚稳态，提高数据可靠性
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        adc_data_sync_reg1 <= adc_data_input;      // 第一级同步
        adc_data_sync_reg2 <= adc_data_sync_reg1;  // 第二级同步
        adc_data_buffered <= adc_data_sync_reg2;   // 最终输出缓冲
    end

    //===========================================================================
    // FIFO复位控制逻辑
    // 在复位脉冲到来时产生FIFO复位信号
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        reset_pulse_delayed <= reset_pulse;
        
        if (reset_pulse && !reset_pulse_delayed) begin
            // 检测到复位脉冲上升沿
            fifo_reset_signal <= 1'b1;
        end else begin
            fifo_reset_signal <= 1'b0;
        end
    end

endmodule
