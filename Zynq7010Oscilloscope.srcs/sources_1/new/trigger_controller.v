`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: trigger_controller
// 功能描述: 触发控制模块 - 管理数据采集的触发时序和FIFO读写控制
// 创建日期: 2025/06/09
//
// 功能说明:
//   1. 管理预触发数据采集
//   2. 检测触发条件并进入触发状态
//   3. 支持自动触发功能
//   4. 控制FIFO的读写时序
//
// 输入接口:
//   - 系统时钟 (adc_clk_25mhz)
//   - FIFO状态 (fifo_empty, fifo_full)
//   - 触发信号 (digital_trigger_signal)
//   - 数据抽取脉冲 (data_extract_pulse)
//
// 输出接口:
//   - 触发状态 (trigger_ready, trigger_state)
//   - FIFO控制 (fifo_write_ready, fifo_write_enable, fifo_read_enable)
//   - 预触发计数 (pre_trigger_count)
//////////////////////////////////////////////////////////////////////////////////

module trigger_controller (
    // 时钟信号
    input wire adc_clk_25mhz,           // ADC工作时钟25MHz
    
    // FIFO状态信号
    input wire fifo_empty,              // FIFO空标志
    input wire fifo_full,               // FIFO满标志
    
    // 触发控制信号
    input wire digital_trigger_signal,  // 数字触发信号
    input wire data_extract_pulse,      // 数据抽取脉冲
    
    // 输出状态信号
    output reg [10:0] pre_trigger_count,    // 预触发计数器
    output reg trigger_ready,               // 触发准备状态
    output reg trigger_state,               // 当前触发状态
    
    // FIFO控制信号
    output reg fifo_write_ready,        // FIFO写准备信号
    output reg fifo_read_enable,        // FIFO读使能信号
    output reg fifo_write_enable        // FIFO写使能信号
);

    // 预触发参数定义
    localparam [10:0] PRE_TRIGGER_DEPTH = 11'd500;     // 预触发深度
    localparam [16:0] AUTO_TRIGGER_TIMEOUT = 17'd100000; // 自动触发超时计数 (4ms @ 25MHz)

    // 内部寄存器定义
    reg [10:0] pre_trigger_depth_config;   // 预触发深度配置
    reg [16:0] auto_trigger_counter;       // 自动触发计数器
    
    // 触发状态寄存器
    reg trigger_condition_met;             // 触发条件满足标志
    reg trigger_condition_met_delay;       // 触发条件延迟
    reg auto_trigger_flag;                 // 自动触发标志
    
    // FIFO状态延迟寄存器
    reg fifo_empty_delay;                  // FIFO空状态延迟
    reg fifo_full_delay;                   // FIFO满状态延迟
    reg trigger_ready_delay;               // 触发准备状态延迟
    reg trigger_state_delay;               // 触发状态延迟
    reg digital_trigger_signal_delay;     // 数字触发信号延迟
    
    // FIFO读控制寄存器
    reg fifo_read_ready;                   // FIFO读准备
    reg fifo_read_extract;                 // FIFO读抽取模式

    //===========================================================================
    // 信号时序处理 - 产生延迟信号用于边沿检测
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        fifo_empty_delay <= fifo_empty;
        fifo_full_delay <= fifo_full;
        trigger_ready_delay <= trigger_ready;
        trigger_state_delay <= trigger_state;
        digital_trigger_signal_delay <= digital_trigger_signal;
        trigger_condition_met_delay <= trigger_condition_met;
    end

    //===========================================================================
    // 预触发深度配置
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        pre_trigger_depth_config <= PRE_TRIGGER_DEPTH;
    end

    //===========================================================================
    // 触发准备状态控制逻辑
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        if (fifo_empty_delay || fifo_full_delay) begin
            // FIFO空或满时，退出准备状态
            trigger_ready <= 1'b0;
        end else if (trigger_condition_met && !trigger_condition_met_delay) begin
            // 预触发条件满足时，进入准备状态
            trigger_ready <= 1'b1;
        end else if (trigger_state && !trigger_state_delay) begin
            // 触发状态开始时，退出准备状态
            trigger_ready <= 1'b0;
        end
    end

    //===========================================================================
    // 预触发计数逻辑
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        if (fifo_empty && ~fifo_empty_delay) begin
            // FIFO从非空变为空时，清零预触发计数器
            pre_trigger_count <= 11'h00;
            trigger_condition_met <= 1'b0;
        end else if (fifo_write_enable && !trigger_state && !trigger_ready) begin
            // 在非触发和非准备状态下，FIFO写入时递增预触发计数
            pre_trigger_count <= pre_trigger_count + 11'b1;
            
            if (pre_trigger_count == pre_trigger_depth_config) begin
                trigger_condition_met <= 1'b1;  // 达到预触发深度
            end else begin
                trigger_condition_met <= 1'b0;
            end
        end
    end

    //===========================================================================
    // 自动触发计数逻辑
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        if (fifo_empty && ~fifo_empty_delay) begin
            // FIFO从非空变为空时，清零自动触发计数器
            auto_trigger_counter <= 17'h00;
            auto_trigger_flag <= 1'b0;
        end else if (trigger_ready) begin
            // 在准备状态下递增自动触发计数器
            auto_trigger_counter <= auto_trigger_counter + 17'b1;
            
            if (auto_trigger_counter == AUTO_TRIGGER_TIMEOUT) begin
                auto_trigger_flag <= 1'b1;  // 超时，产生自动触发
            end else begin
                auto_trigger_flag <= 1'b0;
            end
        end else begin
            auto_trigger_counter <= 17'h00;
            auto_trigger_flag <= 1'b0;
        end
    end

    //===========================================================================
    // 触发状态控制逻辑
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        if (((digital_trigger_signal && ~digital_trigger_signal_delay) || auto_trigger_flag) && trigger_ready) begin
            // 检测到触发信号上升沿或自动触发，且处于准备状态时，进入触发状态
            trigger_state <= 1'b1;
        end else if (fifo_full && !fifo_full_delay) begin
            // FIFO从非满变为满时，退出触发状态
            trigger_state <= 1'b0;
        end
    end

    //===========================================================================
    // FIFO写控制逻辑
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        if (fifo_empty && !fifo_empty_delay) begin
            // FIFO从非空变为空时，启动写准备
            fifo_write_ready <= 1'b1;
        end else if (fifo_full && !fifo_full_delay) begin
            // FIFO从非满变为满时，停止写准备
            fifo_write_ready <= 1'b0;
        end
    end

    // FIFO写使能信号 = 写准备信号 & 数据抽取脉冲
    always @(posedge adc_clk_25mhz) begin
        fifo_write_enable <= fifo_write_ready & data_extract_pulse;
    end

    //===========================================================================
    // FIFO读控制逻辑
    //===========================================================================
    always @(posedge adc_clk_25mhz) begin
        if ((fifo_empty && !fifo_empty_delay) || (trigger_state && !trigger_state_delay)) begin
            // FIFO空或触发信号到来时，关闭读使能
            fifo_read_ready <= 1'b0;
            fifo_read_extract <= 1'b0;
        end else if (trigger_ready && trigger_ready_delay) begin
            // 进入准备状态时，读使能依据抽取速率开启
            fifo_read_ready <= 1'b0;
            fifo_read_extract <= 1'b1;
        end else if (fifo_full && ~fifo_full_delay) begin
            // FIFO从非满变为满时，开启读使能
            fifo_read_ready <= 1'b1;
            fifo_read_extract <= 1'b0;
        end
    end

    // FIFO读使能输出选择
    always @(posedge adc_clk_25mhz) begin
        fifo_read_enable <= (fifo_read_extract == 1'b1) ? fifo_write_enable : fifo_read_ready;
    end

endmodule
