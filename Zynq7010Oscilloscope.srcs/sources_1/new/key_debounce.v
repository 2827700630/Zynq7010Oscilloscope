`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: key_debounce
// 功能描述: 四路按键下降沿检测模块 (无消抖)
// 创建日期: 2025/06/09
// 
// 输入接口:
//   - 系统时钟 (clk_25mhz)
//   - 四个按键输入 (key_freq_sel, key_wave_sel, key_extract_sel, key_reset)
// 
// 输出接口:
//   - 四个按键的脉冲信号 (freq_change_pulse, wave_change_pulse, extract_change_pulse, reset_pulse)
//////////////////////////////////////////////////////////////////////////////////

module key_debounce (
    // 时钟和复位信号
    input wire clk_25mhz,           // 25MHz系统时钟
    
    // 按键输入信号（低电平有效）
    input wire key_freq_sel,        // 频率选择按键 (原key4)
    input wire key_wave_sel,        // 波形选择按键 (原key3)  
    input wire key_extract_sel,     // 抽取比例选择按键 (原key2)
    input wire key_reset,           // 系统复位按键 (原key1)
    
    // 按键输出脉冲信号（一个时钟周期的脉冲）
    output reg freq_change_pulse,   // 频率切换脉冲
    output reg wave_change_pulse,   // 波形切换脉冲  
    output reg extract_change_pulse,// 抽取比例切换脉冲
    output reg reset_pulse          // 复位脉冲
);

    // 移除消抖参数定义
    // localparam DEBOUNCE_COUNT = 20'd499_999;
    
    // 移除消抖计数器
    // reg [19:0] debounce_counter;
    
    // 移除按键采样寄存器 (直接使用输入)
    // reg key_freq_sampled;
    // reg key_wave_sampled;
    // reg key_extract_sampled;
    // reg key_reset_sampled;
    
    // 按键输入延迟寄存器（用于检测下降沿）
    reg key_freq_sel_delay;     // 频率选择按键输入延迟
    reg key_wave_sel_delay;     // 波形选择按键输入延迟
    reg key_extract_sel_delay;  // 抽取选择按键输入延迟
    reg key_reset_delay;        // 复位按键输入延迟

    // 移除按键采样逻辑
    //===========================================================================
    // 按键采样逻辑 - 20ms扫描一次，滤除高频毛刺
    //===========================================================================
    // always @(posedge clk_25mhz) begin
    //     if (debounce_counter == DEBOUNCE_COUNT) begin
    //         // 计数器达到20ms，重新采样按键状态
    //         debounce_counter <= 20'b0;
    //         key_freq_sampled <= key_freq_sel;
    //         key_wave_sampled <= key_wave_sel; 
    //         key_extract_sampled <= key_extract_sel;
    //         key_reset_sampled <= key_reset;
    //     end else begin
    //         // 计数器递增
    //         debounce_counter <= debounce_counter + 20'b1;
    //     end
    // end

    //===========================================================================
    // 按键边沿检测逻辑 - 检测下降沿产生单脉冲 (直接使用输入信号)
    //===========================================================================
    always @(posedge clk_25mhz) begin
        // 保存上一时刻的输入值
        key_freq_sel_delay <= key_freq_sel;
        key_wave_sel_delay <= key_wave_sel;
        key_extract_sel_delay <= key_extract_sel;
        key_reset_delay <= key_reset;
        
        // 检测下降沿（按键按下）产生单脉冲
        freq_change_pulse <= key_freq_sel_delay & (~key_freq_sel);
        wave_change_pulse <= key_wave_sel_delay & (~key_wave_sel);
        extract_change_pulse <= key_extract_sel_delay & (~key_extract_sel);
        reset_pulse <= key_reset_delay & (~key_reset);
    end

endmodule
