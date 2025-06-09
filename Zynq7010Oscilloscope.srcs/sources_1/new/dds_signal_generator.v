`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: dds_signal_generator
// 功能描述: DDS数字信号发生器，支持三种波形（正弦波、方波、三角波）和8种频率
// 创建日期: 2025/06/09
//
// 输入接口:
//   - DAC时钟 (dac_clk_50mhz)
//   - 频率切换信号 (freq_change_pulse)
//   - 波形切换信号 (wave_change_pulse)
//
// 输出接口:
//   - DAC数据输出 (dac_data_out)
//   - 当前频率指示 (current_freq_index)
//   - 当前波形指示 (current_wave_type)
//////////////////////////////////////////////////////////////////////////////////

module dds_signal_generator (
    // 时钟信号
    input wire dac_clk_50mhz,       // DAC工作时钟50MHz
    
    // 控制信号
    input wire freq_change_pulse,   // 频率切换脉冲
    input wire wave_change_pulse,   // 波形切换脉冲
    
    // ROM接口 - 正弦波
    output wire [8:0] sine_rom_addr,    // 正弦波ROM地址输出
    input wire [7:0] sine_rom_data,     // 正弦波ROM数据输入
    
    // ROM接口 - 方波
    output wire [8:0] square_rom_addr,  // 方波ROM地址输出
    input wire [7:0] square_rom_data,   // 方波ROM数据输入
    
    // ROM接口 - 三角波
    output wire [8:0] triangle_rom_addr, // 三角波ROM地址输出
    input wire [7:0] triangle_rom_data,  // 三角波ROM数据输入
    
    // 输出信号
    output reg [7:0] dac_data_out,  // DAC数据输出
    output wire [2:0] current_freq_index,  // 当前频率索引 (0-7)
    output wire [1:0] current_wave_type    // 当前波形类型 (0:正弦 1:方波 2:三角)
);

    // 频率步进参数定义
    // 输出频率计算公式: Fo = (50*10^6 / 2^24) * step Hz
    localparam [23:0] FREQ_STEP_100HZ   = 24'd34;      // 100 Hz
    localparam [23:0] FREQ_STEP_1KHZ    = 24'd336;     // 1 kHz  
    localparam [23:0] FREQ_STEP_2K5HZ   = 24'd839;     // 2.5 kHz
    localparam [23:0] FREQ_STEP_10KHZ   = 24'd3355;    // 10 kHz
    localparam [23:0] FREQ_STEP_20KHZ   = 24'd8387;    // 20 kHz
    localparam [23:0] FREQ_STEP_100KHZ  = 24'd33554;   // 100 kHz
    localparam [23:0] FREQ_STEP_1MHZ    = 24'd335544;  // 1 MHz
    localparam [23:0] FREQ_STEP_2M5HZ   = 24'd883861;  // 2.5 MHz
    
    // 波形类型定义
    localparam [1:0] WAVE_SINE     = 2'b00;  // 正弦波
    localparam [1:0] WAVE_SQUARE   = 2'b01;  // 方波
    localparam [1:0] WAVE_TRIANGLE = 2'b10;  // 三角波    // 内部寄存器定义
    reg [2:0] freq_index_counter;    // 频率索引计数器 (0-7)
    reg [1:0] wave_type_counter;     // 波形类型计数器 (0-2)
    reg [23:0] frequency_step;       // 当前频率步进值
    reg [23:0] phase_accumulator;    // 相位累加器
    reg [8:0] rom_address;           // ROM地址
    
    // 控制信号分频和边沿检测
    reg [15:0] control_divider;      // 控制信号分频计数器 (50MHz->1.5KHz)
    reg control_clk_enable;          // 控制时钟使能信号
    reg freq_change_pulse_sync1, freq_change_pulse_sync2; // 频率切换脉冲同步
    reg wave_change_pulse_sync1, wave_change_pulse_sync2; // 波形切换脉冲同步
    reg freq_change_pulse_prev, wave_change_pulse_prev;   // 前一时刻的脉冲状态
    
    // 波形选择输出
    reg [7:0] selected_wave_data;    // 选择的波形数据    //===========================================================================
    // 控制信号同步和分频逻辑
    // 将外部控制信号同步到DAC时钟域，并产生控制时钟使能
    //===========================================================================
    always @(posedge dac_clk_50mhz) begin
        // 控制信号分频：50MHz / 32768 ≈ 1.5KHz，降低控制逻辑的工作频率
        control_divider <= control_divider + 16'd1;
        if (control_divider == 16'd32767) begin
            control_clk_enable <= 1'b1;
            control_divider <= 16'd0;
        end else begin
            control_clk_enable <= 1'b0;
        end
        
        // 将控制脉冲同步到DAC时钟域（两级同步防止亚稳态）
        freq_change_pulse_sync1 <= freq_change_pulse;
        freq_change_pulse_sync2 <= freq_change_pulse_sync1;
        wave_change_pulse_sync1 <= wave_change_pulse;
        wave_change_pulse_sync2 <= wave_change_pulse_sync1;
    end

    //===========================================================================
    // 频率控制逻辑 - 8种频率循环切换
    //===========================================================================
    always @(posedge dac_clk_50mhz) begin
        freq_change_pulse_prev <= freq_change_pulse_sync2;
        
        // 检测频率切换脉冲的上升沿
        if (control_clk_enable && freq_change_pulse_sync2 && !freq_change_pulse_prev) begin
            freq_index_counter <= freq_index_counter + 3'b1;
        end
    end

    // 频率步进值选择
    always @(posedge dac_clk_50mhz) begin
        if (control_clk_enable) begin
            case (freq_index_counter)
                3'd0: frequency_step <= FREQ_STEP_100HZ;   // 100 Hz
                3'd1: frequency_step <= FREQ_STEP_1KHZ;    // 1 kHz
                3'd2: frequency_step <= FREQ_STEP_2K5HZ;   // 2.5 kHz
                3'd3: frequency_step <= FREQ_STEP_10KHZ;   // 10 kHz
                3'd4: frequency_step <= FREQ_STEP_20KHZ;   // 20 kHz
                3'd5: frequency_step <= FREQ_STEP_100KHZ;  // 100 kHz
                3'd6: frequency_step <= FREQ_STEP_1MHZ;    // 1 MHz
                3'd7: frequency_step <= FREQ_STEP_2M5HZ;   // 2.5 MHz
                default: frequency_step <= FREQ_STEP_1KHZ; // 默认1kHz
            endcase
        end
    end

    //===========================================================================
    // 波形类型控制逻辑 - 3种波形循环切换
    //===========================================================================
    always @(posedge dac_clk_50mhz) begin
        wave_change_pulse_prev <= wave_change_pulse_sync2;
        
        // 检测波形切换脉冲的上升沿
        if (control_clk_enable && wave_change_pulse_sync2 && !wave_change_pulse_prev) begin
            wave_type_counter <= wave_type_counter + 2'b1;
        end
    end

    //===========================================================================
    // DDS相位累加器 - 在DAC时钟域运行
    //===========================================================================
    always @(posedge dac_clk_50mhz) begin
        phase_accumulator <= phase_accumulator + frequency_step;
    end

    // 从相位累加器生成ROM地址
    always @(posedge dac_clk_50mhz) begin
        rom_address <= phase_accumulator[23:15];  // 使用高9位作为地址
    end   
    //===========================================================================
    // ROM地址输出连接
    //===========================================================================
    assign sine_rom_addr = rom_address;
    assign square_rom_addr = rom_address;
    assign triangle_rom_addr = rom_address;

    //===========================================================================
    // 波形选择多路复用器
    //===========================================================================
    always @(posedge dac_clk_50mhz) begin
        case (wave_type_counter)
            WAVE_SINE:     selected_wave_data <= sine_rom_data;     // 正弦波
            WAVE_SQUARE:   selected_wave_data <= square_rom_data;   // 方波
            WAVE_TRIANGLE: selected_wave_data <= triangle_rom_data; // 三角波
            default:       selected_wave_data <= sine_rom_data;     // 默认正弦波
        endcase
    end

    // 输出寄存器
    always @(posedge dac_clk_50mhz) begin
        dac_data_out <= selected_wave_data;
    end

    //===========================================================================
    // 状态输出
    //===========================================================================
    assign current_freq_index = freq_index_counter;
    assign current_wave_type = wave_type_counter;

endmodule
