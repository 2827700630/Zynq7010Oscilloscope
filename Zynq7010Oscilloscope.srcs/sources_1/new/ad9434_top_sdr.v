// ad9434_top_sdr.v
// AD9434 SDR 模式顶层模块 - 简化版 (无输入延迟)
// **重要:** 此模块使用简化方案，不包含 IDELAYE2 和 IDELAYCTRL。
// 依赖 SelectIO Interface Wizard IP。
// ADC DCO 时钟 (P/N) 应直接连接到 Block Design 中的 SelectIO Interface Wizard IP 的高速串行时钟输入。
// LVDS 数据也应连接到 SelectIO Interface Wizard IP。

module ad9434_top_sdr (
    // -- SelectIO IP 的并行数据输入 --
    input wire [23:0] adc_parallel_data_from_selectio, // 来自 SelectIO IP 的 24 位并行数据

    // -- 时钟输入 (由 SelectIO Interface Wizard IP 提供) --
    // 注意: ADC 的 DCO P/N 信号直接连接到 SelectIO Interface Wizard IP。
    //       SelectIO IP 从 DCO 生成此并行数据时钟。
    input wire clk_parallel_data,              // 并行数据时钟 (例如 125MHz, 来自 SelectIO IP 的 clk_div_out)

    // -- 系统接口 --
    input wire sys_rst_n,                      // 系统异步复位 (低有效)

    // -- ADC 数据输出 --
    output wire [11:0] adc_output_data,        // 最终的12位ADC数据
    output wire adc_output_valid                // ADC数据有效信号
);

    // 从24位SelectIO输出中选择12位有效数据
    // 假设对于SDR和串行化因子为2，每个LVDS通道对应的2位输出中，
    // 较低索引的位 (Q1) 是我们需要的数据。
    // 例如：adc_parallel_data_from_selectio[0] 是通道0的Q1
    //        adc_parallel_data_from_selectio[1] 是通道0的Q2 (未使用)
    //        adc_parallel_data_from_selectio[2] 是通道1的Q1
    //        ...
    wire [11:0] selected_adc_data;
    genvar i;
    generate
        for (i = 0; i < 12; i = i + 1) begin : gen_select_q1_bits
            assign selected_adc_data[i] = adc_parallel_data_from_selectio[i*2];
        end
    endgenerate

    // 实例化简化的LVDS接收器逻辑 (现在处理已选择的12位数据)
    // 注意: mmcm_locked 信号已从此模块移除，
    //       ad9434_lvds_receiver_sdr 子模块也需要相应修改。
    ad9434_lvds_receiver_sdr i_ad9434_lvds_receiver (
        // 时钟输入 (来自 SelectIO IP)
        .clk_parallel_data      (clk_parallel_data),
        // .mmcm_locked         (mmcm_locked), // mmcm_locked 已移除

        // 并行数据输入 (来自 SelectIO IP)
        .adc_parallel_data_in   (selected_adc_data), // 传递选择后的12位数据

        // 系统接口
        .sys_rst_n              (sys_rst_n),

        // ADC 数据输出
        .adc_data_out           (adc_output_data),
        .adc_data_valid         (adc_output_valid)
    );

    // 注意: 在简化方案中，IDELAYCTRL 由 SelectIO Interface Wizard IP 内部管理 (如果启用)
    // 或者完全不需要 (如果禁用输入延迟功能)。
    // 因此这里不再手动例化 IDELAYCTRL。
    // 可以在此处添加进一步的处理逻辑，例如将 adc_output_data 写入 FIFO，
    // 然后通过 AXI 接口传输到 Zynq PS (处理系统) 的 DDR 内存中。
    // 
    // 方案 C 数据流：
    // AD9434 DCO (P/N) → SelectIO IP (IBUFDS + ISERDES + clk_div_logic) → clk_parallel_data
    // AD9434 LVDS Data (P/N) → SelectIO IP (IBUFDS + ISERDES) → adc_parallel_data_from_selectio
    // adc_parallel_data_from_selectio & clk_parallel_data → 此模块 → 后续处理
    // ...

endmodule