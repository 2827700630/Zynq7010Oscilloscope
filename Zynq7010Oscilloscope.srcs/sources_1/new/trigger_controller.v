`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: trigger_controller_axi_stream
// 项目名称: Zynq7010 示波器
// 目标设备: Zynq 7010
// 功能描述:
//   此模块实现数字触发逻辑，并在触发事件后将ADC数据作为AXI4-Stream输出。
//   设计用于连接AXI4-Stream FIFO。
//   不包含预触发缓冲或BRAM接口。
//
//////////////////////////////////////////////////////////////////////////////////

module trigger_controller_axi_stream #(
    parameter TDATA_WIDTH = 32,                     // AXI TDATA 宽度 (32位以匹配总线宽度)
    parameter ADC_DATA_WIDTH = 8,                   // ADC数据宽度 (8位)
    parameter TRIGGER_PACKET_WORD_COUNT = 512       // 每个触发事件流式传输的32位字数 (之前2048个8位字现在变成512个32位字)
)(
    // 时钟和复位
    input wire adc_clk_25mhz,
    input wire sys_rst_n,    // 触发控制输入
    input wire digital_trigger_signal,      // 数字触发输入
    input wire data_extract_pulse,          // ADC数据有效脉冲 (采样脉冲)
    input wire [ADC_DATA_WIDTH-1:0] adc_data_input, // ADC数据输入 (8位)

    // AXI4-Stream 主接口输出
    output wire [TDATA_WIDTH-1:0] m_axis_tdata,
    output reg                    m_axis_tvalid,
    input wire                    m_axis_tready, // 来自下游AXI Stream FIFO的准备好信号
    output reg                    m_axis_tlast,

    // 状态输出 (用于监控)
    output reg trigger_ready_status,        // 状态: 系统空闲，准备好接收触发
    output reg trigger_active_status        // 状态: 触发激活，通过AXI流式传输数据
);    // 内部寄存器
    reg digital_trigger_signal_delay_reg; // 用于数字触发信号的上升沿检测

    // 数据打包相关寄存器 (将4个8位ADC数据打包成1个32位字)
    reg [TDATA_WIDTH-1:0] data_pack_reg;    // 32位数据打包寄存器
    reg [1:0] pack_count_reg;               // 打包计数器 (0-3，表示当前是第几个8位数据)
    reg pack_ready_reg;                     // 指示32位数据包已准备好发送

    // AXI Stream 数据包计数器
    // 需要计数到 TRIGGER_PACKET_WORD_COUNT - 1
    // 宽度应为 $clog2(TRIGGER_PACKET_WORD_COUNT)
    reg [$clog2(TRIGGER_PACKET_WORD_COUNT)-1:0] axis_words_sent_count_reg;
    
    // 将32位打包数据赋值给 m_axis_tdata
    // 当控制逻辑断言 TVALID 时，TDATA 有效。
    assign m_axis_tdata = data_pack_reg;    //----------
    // 边沿检测
    // 捕获数字触发信号的前一个状态以检测上升沿。
    //----------
    always @(posedge adc_clk_25mhz or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            digital_trigger_signal_delay_reg <= 1'b0;
        end else begin
            digital_trigger_signal_delay_reg <= digital_trigger_signal;
        end
    end

    //----------
    // 数据打包逻辑 (将4个8位ADC数据打包成1个32位字)
    // 当触发激活且有ADC数据可用时，将8位数据依次打包到32位寄存器中
    // 当收集到4个8位数据后，设置pack_ready信号
    //----------
    always @(posedge adc_clk_25mhz or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            data_pack_reg <= 32'b0;
            pack_count_reg <= 2'b0;
            pack_ready_reg <= 1'b0;
        end else begin
            // 默认情况下pack_ready为低
            pack_ready_reg <= 1'b0;
            
            if (trigger_active_status && data_extract_pulse) begin
                // 根据当前打包位置存储ADC数据
                case (pack_count_reg)
                    2'b00: data_pack_reg[7:0]   <= adc_data_input;   // 第1个字节 (LSB)
                    2'b01: data_pack_reg[15:8]  <= adc_data_input;   // 第2个字节
                    2'b10: data_pack_reg[23:16] <= adc_data_input;   // 第3个字节
                    2'b11: data_pack_reg[31:24] <= adc_data_input;   // 第4个字节 (MSB)
                endcase
                
                // 递增打包计数器
                if (pack_count_reg == 2'b11) begin
                    pack_count_reg <= 2'b00;      // 重置计数器
                    pack_ready_reg <= 1'b1;       // 32位数据包准备好
                end else begin
                    pack_count_reg <= pack_count_reg + 1;
                end
            end else if (!trigger_active_status) begin
                // 触发未激活时重置打包状态
                pack_count_reg <= 2'b00;
                pack_ready_reg <= 1'b0;
            end
        end
    end

    //----------
    // 触发准备好状态逻辑 (trigger_ready_status)
    // 指示系统空闲并等待触发事件。
    // 当未主动流式传输数据 (trigger_active_status 为低) 时，此信号为高。
    //----------
    always @(posedge adc_clk_25mhz or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            trigger_ready_status <= 1'b1; // 系统复位后准备就绪
        end else begin
            // 如果系统当前未因触发而激活，则系统准备就绪。
            trigger_ready_status <= ~trigger_active_status;
        end
    end

    //----------
    // 触发激活状态逻辑 (trigger_active_status)
    // 控制数据采集和AXI流式传输的启动与停止。
    //----------
    always @(posedge adc_clk_25mhz or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            trigger_active_status <= 1'b0;
        end else begin
            if (!trigger_active_status) begin // 如果当前未激活
                // 进入激活状态的条件: (系统准备好) AND (数字触发信号出现上升沿)
                if (trigger_ready_status && (digital_trigger_signal && !digital_trigger_signal_delay_reg)) begin
                    trigger_active_status <= 1'b1; // 进入激活状态，开始流式传输
                end
            end else begin // 当前处于激活状态 (trigger_active_status 为高)
                // 退出激活状态的条件: AXI流数据包的最后一个字 (TLAST) 
                // 已成功发送 (TVALID 为高且下游 TREADY 为高)。
                if (m_axis_tlast && m_axis_tvalid && m_axis_tready) begin
                    trigger_active_status <= 1'b0; // 数据包已发送，返回非激活状态
                end
            end
        end
    end    //----------
    // AXI4-Stream 输出逻辑 (控制 TVALID, TLAST)
    // 此逻辑块管理AXI4-Stream握手和数据打包。
    // 现在基于32位数据包的准备状态发送数据
    //----------
    always @(posedge adc_clk_25mhz or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            m_axis_tvalid <= 1'b0;
            m_axis_tlast <= 1'b0;
            // axis_words_sent_count_reg 在其自身的 always 块中复位
        end else begin
            // AXI 握手: 如果 TVALID 已断言但 TREADY 为低 (从设备未准备好)，
            // 则保持 TVALID 和 TLAST 的值，直到 TREADY 变高。
            if (m_axis_tvalid && !m_axis_tready) begin
                m_axis_tvalid <= m_axis_tvalid; // 保持 TVALID
                m_axis_tlast  <= m_axis_tlast;  // 如果 TLAST 已断言，则保持
            end else begin
                // 在周期的开始（当未被TREADY暂停或移动到新的数据字时）
                // TVALID 和 TLAST 的默认赋值
                m_axis_tvalid <= 1'b0;
                m_axis_tlast  <= 1'b0;

                // 断言 TVALID 的条件:
                // 1. 触发器处于激活状态 (trigger_active_status 为高)。
                // 2. 32位数据包已准备好发送 (pack_ready_reg 为高)。
                if (trigger_active_status && pack_ready_reg) begin
                    m_axis_tvalid <= 1'b1; // 有效的32位数据准备发送

                    // 判断这是否是数据包的最后一个字
                    // 此检查基于已成功发送并被确认的32位字数。
                    // axis_words_sent_count_reg 仅在成功 (TVALID && TREADY) 传输时递增。
                    if (axis_words_sent_count_reg == TRIGGER_PACKET_WORD_COUNT - 1) begin
                        m_axis_tlast <= 1'b1; // 这是当前数据包的最后一个32位字
                    end else begin
                        m_axis_tlast <= 1'b0;
                    end
                end
            end
        end
    end
      //----------
    // AXI Stream 已发送字计数器 (axis_words_sent_count_reg)
    // 计数当前AXI流数据包中已成功传输的32位数据字数。
    // 当 TVALID, TREADY, 和 pack_ready_reg 都为高时递增。
    // 当数据包完成或未处于 trigger_active_status 状态时复位。
    //----------
    always @(posedge adc_clk_25mhz or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            axis_words_sent_count_reg <= 0;
        end else begin
            if (trigger_active_status) begin // 仅在触发激活状态下计数
                // 递增计数器的条件: (我们断言了 TVALID) AND 
                // (从设备断言了 TREADY) AND (32位数据包准备好)
                // 这表示一个32位数据字成功传输。
                if (m_axis_tvalid && m_axis_tready && pack_ready_reg) begin 
                    if (axis_words_sent_count_reg < TRIGGER_PACKET_WORD_COUNT - 1) begin
                        axis_words_sent_count_reg <= axis_words_sent_count_reg + 1;
                    end else begin // 数据包的最后一个32位字已成功发送
                        axis_words_sent_count_reg <= 0; // 为下一个可能的数据包复位计数器
                    end                end
                // 如果暂停 (TVALID && !TREADY)，计数器不改变。
            end // Closes if (trigger_active_status)
            else begin // 未处于激活触发状态 (触发前或数据包完成后)
                 axis_words_sent_count_reg <= 0; // 复位计数器
            end
        end
    end

endmodule
