`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: data_extract
// 功能描述: 数据抽取模块 - 实现N抽1的数据抽取功能
// 创建日期: 2025/06/09
//
// 功能说明:
//   根据抽取比例设置，对输入数据进行抽取处理
//   支持10种抽取模式：不抽取、2抽1、5抽1、10抽1...50000抽1
//
// 输入接口:
//   - 系统时钟 (adc_clk_25mhz)
//   - 抽取比例选择信号 (extract_ratio_change_pulse)
//   - FIFO写准备信号 (fifo_write_ready)
//
// 输出接口:
//   - 当前抽取比例 (current_extract_ratio)
//   - 抽取计数器 (extract_counter)
//   - 数据抽取脉冲 (data_extract_pulse)
//////////////////////////////////////////////////////////////////////////////////

module data_extract (
    // 时钟信号
    input wire adc_clk_25mhz,               // ADC工作时钟25MHz

    // 控制信号
    input wire extract_ratio_change_pulse,  // 抽取比例切换脉冲
    input wire fifo_write_ready,            // FIFO写准备信号

    // 输出信号  
    output reg [15:0] current_extract_ratio,    // 当前抽取比例 (N抽1时，该值为N-1)
    output reg [15:0] extract_counter,          // 抽取计数器
    output reg data_extract_pulse               // 数据抽取脉冲输出

);

    // 抽取比例定义
    localparam [15:0] EXTRACT_RATIO_NO_EXTRACT = 16'd0;      // 不抽取 (每个样本都保留)
    localparam [15:0] EXTRACT_RATIO_2_TO_1     = 16'd1;      // 2抽1
    localparam [15:0] EXTRACT_RATIO_5_TO_1     = 16'd4;      // 5抽1  
    localparam [15:0] EXTRACT_RATIO_10_TO_1    = 16'd9;      // 10抽1
    localparam [15:0] EXTRACT_RATIO_20_TO_1    = 16'd19;     // 20抽1
    localparam [15:0] EXTRACT_RATIO_50_TO_1    = 16'd49;     // 50抽1
    localparam [15:0] EXTRACT_RATIO_100_TO_1   = 16'd99;     // 100抽1
    localparam [15:0] EXTRACT_RATIO_1000_TO_1  = 16'd999;    // 1000抽1
    localparam [15:0] EXTRACT_RATIO_10000_TO_1 = 16'd9999;   // 10000抽1
    localparam [15:0] EXTRACT_RATIO_50000_TO_1 = 16'd49999;  // 50000抽1

    // 内部寄存器定义
    reg [3:0] extract_mode_counter;     // 抽取模式计数器 (0-9)

    //===========================================================================
    // 抽取比例选择逻辑 - 10种抽取模式循环切换
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        if (extract_ratio_change_pulse) begin
            extract_mode_counter <= extract_mode_counter + 4'b1;
        end
    end

    // 根据抽取模式设置抽取比例
    always @(posedge adc_clk_25mhz) begin
        case (extract_mode_counter)
            4'd0: current_extract_ratio <= EXTRACT_RATIO_NO_EXTRACT;  // 不抽取
            4'd1: current_extract_ratio <= EXTRACT_RATIO_2_TO_1;      // 2抽1
            4'd2: current_extract_ratio <= EXTRACT_RATIO_5_TO_1;      // 5抽1
            4'd3: current_extract_ratio <= EXTRACT_RATIO_10_TO_1;     // 10抽1
            4'd4: current_extract_ratio <= EXTRACT_RATIO_20_TO_1;     // 20抽1
            4'd5: current_extract_ratio <= EXTRACT_RATIO_50_TO_1;     // 50抽1
            4'd6: current_extract_ratio <= EXTRACT_RATIO_100_TO_1;    // 100抽1
            4'd7: current_extract_ratio <= EXTRACT_RATIO_1000_TO_1;   // 1000抽1
            4'd8: current_extract_ratio <= EXTRACT_RATIO_10000_TO_1;  // 10000抽1
            4'd9: current_extract_ratio <= EXTRACT_RATIO_50000_TO_1;  // 50000抽1
            default: current_extract_ratio <= EXTRACT_RATIO_NO_EXTRACT; // 默认不抽取
        endcase
    end

    //===========================================================================
    // 抽取计数器逻辑
    // 当FIFO写准备信号有效时，计数器递增；达到抽取比例时清零并产生脉冲
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        if (fifo_write_ready == 1'b1) begin
            if (extract_counter == current_extract_ratio) begin
                extract_counter <= 16'd0;  // 计数器清零
            end else begin
                extract_counter <= extract_counter + 16'd1;  // 计数器递增
            end
        end else begin
            extract_counter <= 16'd0;  // FIFO写未准备好时清零计数器
        end
    end

    //===========================================================================
    // 数据抽取脉冲生成逻辑
    // 当FIFO写准备好且计数器达到抽取比例时产生脉冲
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        if (fifo_write_ready == 1'b1 && extract_counter == current_extract_ratio) begin
            data_extract_pulse <= 1'b1;  // 产生抽取脉冲
        end else begin
            data_extract_pulse <= 1'b0;  // 其他情况下脉冲为低
        end
    end

endmodule
