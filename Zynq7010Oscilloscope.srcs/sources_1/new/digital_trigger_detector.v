`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: digital_trigger_detector
// 功能描述: 数字触发检测模块 - 对ADC数据进行电平触发检测
// 创建日期: 2025/06/09
//
// 功能说明:
//   检测输入的ADC数据是否超过设定的触发电平
//   支持触发迟滞功能，避免噪声引起的误触发
//   提供触发使能控制
//
// 输入接口:
//   - 系统时钟 (adc_clk_25mhz)
//   - ADC数据输入 (adc_data_in)
//   - 触发使能 (trigger_enable)
//   - 触发电平设置 (trigger_level)
//   - 触发迟滞设置 (trigger_hysteresis)
//
// 输出接口:
//   - 数字触发信号 (digital_trigger_out)
//////////////////////////////////////////////////////////////////////////////////

module digital_trigger_detector (
    // 时钟信号
    input wire adc_clk_25mhz,           // ADC工作时钟25MHz
    
    // 数据输入
    input wire [7:0] adc_data_in,       // ADC数据输入
    
    // 控制信号
    input wire trigger_enable,          // 触发使能信号
    input wire [7:0] trigger_level,     // 触发电平设置
    input wire [2:0] trigger_hysteresis,// 触发迟滞设置
    
    // 输出信号
    output reg digital_trigger_out      // 数字触发输出信号
);

    // 内部寄存器定义
    reg [7:0] adc_data_delayed;         // ADC数据延迟寄存器

    //===========================================================================
    // ADC数据时序处理
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        adc_data_delayed <= adc_data_in;
    end

    //===========================================================================
    // 数字触发检测逻辑 - 带迟滞的电平比较器
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        if (trigger_enable) begin
            // 上升沿触发：当ADC数据超过触发电平时，触发信号置1
            if (adc_data_delayed >= trigger_level) begin
                digital_trigger_out <= 1'b1;
            end
            // 下降沿触发：当ADC数据低于(触发电平-迟滞值)时，触发信号置0
            // 迟滞功能防止在触发电平附近的噪声造成误触发
            else if (adc_data_delayed < (trigger_level - trigger_hysteresis)) begin
                digital_trigger_out <= 1'b0;
            end
            // 在迟滞区间内保持原状态
        end else begin
            // 触发功能禁用时，强制触发信号为0
            digital_trigger_out <= 1'b0;
        end
    end

endmodule
