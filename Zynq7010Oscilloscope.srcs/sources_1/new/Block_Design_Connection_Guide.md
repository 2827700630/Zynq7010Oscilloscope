# Vivado Block Design 连接指南 (Zynq PL-PS 数据通路更新)

本文档旨在指导用户如何在Vivado Block Design (BD) 中连接模块，实现ADC数据通过触发控制、FIFO缓存，最终由AXI DMA传输到PS端的功能。

## 1. 添加模块和IP到Block Design

确保以下模块和IP已添加到您的Block Design中：

*   `key_debounce.v` (按键消抖)
*   `dds_signal_generator.v` (DDS信号发生器，用于DAC测试，如果当前主要关注ADC通路可暂时简化)
*   `adc_data_acquisition.v` (ADC数据采集)
*   `digital_trigger_detector.v` (数字触发检测)
*   `data_extract.v` (数据抽取，产生采样脉冲)
*   `trigger_controller_axi_stream.v` (带AXI4-Stream输出的触发控制器 - **这是更新后的模块**)
*   **ZYNQ7 Processing System IP** (PS端核心)
*   **AXI4-Stream Data FIFO IP** (用于PL端数据缓存)
*   **AXI Direct Memory Access (DMA) IP** (用于PL到PS的数据传输)
*   **Clocking Wizard IP** (PLL，用于生成PL端时钟)
*   **Processor System Reset IP** (用于生成AXI总线和外设的复位信号)
*   ROM IP核 (用于DDS，如果使用)
*   Constant IP, Utility Vector Logic IP (用于生成常数和简单逻辑门，如反相器)

## 2. 创建外部端口 (示例)

根据您的硬件设计创建必要的外部端口，例如：

### 输入端口:
*   `crystal_clk_50mhz`: `clk` 类型, 外部晶振。
*   `key_...`: 按键输入。
*   `sys_rst_n_external`: `rst` 类型, 单比特，外部复位按键输入 (低电平有效)。
*   `adc_data_input_external`: `data` 类型, 8比特 (`[7:0]`)，ADC芯片数据输入。

### 输出端口:
*   `led_...`: LED指示灯。
*   (其他DAC或调试相关端口)

## 3. ZYNQ7 Processing System (PS) 配置

双击ZYNQ7 IP进行配置：
*   **MIO Configuration**: 根据硬件配置管脚。
*   **Clock Configuration**: 配置 `FCLK_CLK0` (例如100MHz或150MHz)，这将作为AXI总线的主要时钟。
*   **PS-PL Configuration**: 使能至少一个AXI GP主接口 (如 `M_AXI_GP0`) 用于控制DMA，以及至少一个AXI HP从接口 (如 `S_AXI_HP0`) 用于DMA写入PS DDR。
*   **Interrupts**: 使能PL到PS的中断 (`IRQ_F2P[0:0]` 或更多)。

## 4. 时钟和复位系统

### 4.1. Clocking Wizard (PLL)
*   **输入**:
    *   `clk_in1`: 连接到外部端口 `crystal_clk_50mhz`。
*   **输出**:
    *   `clk_out1` (例如配置为25MHz): 命名为 `adc_clk_25mhz`，用于驱动ADC采样相关逻辑 (`adc_data_acquisition`, `digital_trigger_detector`, `data_extract`, `trigger_controller` 的核心逻辑部分, `AXI4-Stream Data FIFO` 的从端写时钟)。
    *   `clk_out2` (例如配置为100MHz或与 `FCLK_CLK0` 一致): 如果需要，可用于其他PL逻辑，或作为AXI组件的备用时钟源 (但通常AXI组件直接使用 `FCLK_CLK0`)。
    *   `locked`: 可连接到LED或用于复位逻辑。

### 4.2. Processor System Reset
*   添加一个 `Processor System Reset` IP。
*   **输入**:
    *   `slowest_sync_clk`: 连接到 `FCLK_CLK0` (来自PS)。
    *   `ext_reset_in`: 连接到外部复位信号 `sys_rst_n_external` (确保极性正确，此IP通常期望高有效复位，如果外部是低有效，则需要反相器)。
    *   `mb_debug_sys_rst`: 通常不使用，可悬空或接地。
    *   `dcm_locked`: 连接到 `Clocking Wizard` 的 `locked` 输出。
*   **输出**:
    *   `peripheral_aresetn`: **低有效复位**，连接到所有AXI外设 (AXI DMA, AXI4-Stream FIFO的AXI接口等) 的复位输入端。确保连接到与 `FCLK_CLK0` 同步的AXI接口的复位。
    *   `interconnect_aresetn`: 连接到AXI Interconnect (如果使用SmartConnect或AXI Interconnect IP) 的复位。
    *   `bus_struct_reset`, `peripheral_reset`: 高有效复位，按需使用。

## 5. 模块间连接

### 5.1. 时钟生成 (PLL/Clocking Wizard IP)

*   **输入**:
    *   `clk_in1`: 连接到外部端口 `crystal_clk_50mhz`。
    *   `reset`: 可以连接到 `key_reset` 经过处理后的复位信号 (如果PLL需要同步复位)，或者根据PLL IP的推荐连接到常低或常高。通常，上电复位已足够。
*   **输出**:
    *   `clk_out1` (配置为50MHz): 命名为 `dac_clk_50mhz`。
    *   `clk_out2` (配置为25MHz): 命名为 `adc_clk_25mhz`。
    *   `locked`: 连接到 `led_pll_locked` 外部端口 (注意：LED为低电平有效，可能需要在BD中添加一个反相器，或者在约束文件中处理)。

### 5.2. 按键消抖 (`key_debounce`)

*   **输入**:
    *   `clk_25mhz`: 连接到 `adc_clk_25mhz` (来自PLL)。
    *   `key_freq_sel`: 连接到外部端口 `key_freq_sel`。
    *   `key_wave_sel`: 连接到外部端口 `key_wave_sel`。
    *   `key_extract_sel`: 连接到外部端口 `key_extract_sel`。
    *   `key_reset`: 连接到外部端口 `key_reset`。
*   **输出**:
    *   `freq_change_pulse`: 连接到 `dds_signal_generator.freq_change_pulse`。
    *   `wave_change_pulse`: 连接到 `dds_signal_generator.wave_change_pulse`。
    *   `extract_change_pulse`: 连接到 `data_extract.extract_ratio_change_pulse`。
    *   `reset_pulse`: 连接到 `adc_data_acquisition.reset_pulse`。

### 5.3. DDS信号发生器 (`dds_signal_generator`)

*   **输入**:
    *   `dac_clk_50mhz`: 连接到 `dac_clk_50mhz` (来自PLL)。
    *   `freq_change_pulse`: 来自 `key_debounce.freq_change_pulse`。
    *   `wave_change_pulse`: 来自 `key_debounce.wave_change_pulse`。
    *   `sine_rom_data`: 来自 正弦波ROM IP的 `dout`。
    *   `square_rom_data`: 来自 方波ROM IP的 `dout`。
    *   `triangle_rom_data`: 来自 三角波ROM IP的 `dout`。
*   **输出**:
    *   `dac_data_out`: 连接到外部端口 `dac_data_output`。
    *   `sine_rom_addr`: 连接到 正弦波ROM IP的 `addra`。
    *   `square_rom_addr`: 连接到 方波ROM IP的 `addra`。
    *   `triangle_rom_addr`: 连接到 三角波ROM IP的 `addra`。
    *   `current_freq_index`, `current_wave_type`: 这些是状态输出，可以悬空，或者如果需要在BD中其他地方监控，可以连接到ILA等调试核。

### 5.4. ROM IP核 (三个独立的Block Memory Generator)

*   **正弦波ROM**:
    *   `clka`: 连接到 `dac_clk_50mhz` (或根据ROM配置选择合适的时钟)。
    *   `addra`: 连接到 `dds_signal_generator.sine_rom_addr`。
    *   `douta`: 连接到 `dds_signal_generator.sine_rom_data`。
    *   其他端口如 `wea`, `dina` 等根据ROM配置（只读模式）接地或置高。
*   **方波ROM**:
    *   `clka`: 连接到 `dac_clk_50mhz`。
    *   `addra`: 连接到 `dds_signal_generator.square_rom_addr`。
    *   `douta`: 连接到 `dds_signal_generator.square_rom_data`。
*   **三角波ROM**:
    *   `clka`: 连接到 `dac_clk_50mhz`。
    *   `addra`: 连接到 `dds_signal_generator.triangle_rom_addr`。
    *   `douta`: 连接到 `dds_signal_generator.triangle_rom_data`。

    *注意: ROM的深度应为512 (因为地址是9位)，宽度为8位。确保在生成ROM IP时加载正确的波形数据文件 (.coe)。*

### 5.5. ADC数据采集 (`adc_data_acquisition`)

*   **输入**:
    *   `adc_clk_25mhz`: 来自 `Clocking Wizard`。
    *   `adc_data_input`: 连接到外部端口 `adc_data_input_external`。
    *   `reset_pulse`: 来自 `key_debounce.reset_pulse` (或连接到 `Processor System Reset` 的某个高有效复位输出，确保同步)。
*   **输出**:
    *   `adc_data_buffered [7:0]`: 连接到 `trigger_controller_axi_stream.adc_data_input` 和 `digital_trigger_detector.adc_data_in`。

### 5.6. 数字触发检测 (`digital_trigger_detector`)

*   **输入**:
    *   `adc_clk_25mhz`: 来自 `Clocking Wizard`。
    *   `adc_data_in`: 来自 `adc_data_acquisition.adc_data_buffered`。
    *   `trigger_enable`, `trigger_level`, `trigger_hysteresis`: 可由Constant IP提供，或连接到PS通过AXI GPIO控制的寄存器。
*   **输出**:
    *   `digital_trigger_out`: 连接到 `trigger_controller_axi_stream.digital_trigger_signal`。

### 5.7. 数据抽取 (`data_extract`)

*   **输入**:
    *   `adc_clk_25mhz`: 来自 `Clocking Wizard`。
    *   `extract_ratio_change_pulse`: 来自 `key_debounce`。
    *   `fifo_write_ready`: **重要修改** - 应连接到 `trigger_controller_axi_stream.trigger_ready_status`，而不是硬编码为 `1'b0`。这确保只有在触发系统准备好时才进行数据抽取。
*   **输出**:
    *   `data_extract_pulse`: 连接到 `trigger_controller_axi_stream.data_extract_pulse`。

### 5.8. 触发控制器 (`trigger_controller_axi_stream`) - **32位AXI架构**

*   **参数设置** (在BD中选中IP，查看Block Properties -> Config):
    *   `TDATA_WIDTH`: **修改为 32** (AXI总线宽度)。
    *   `ADC_DATA_WIDTH`: 保持为 8 (ADC数据宽度)。
    *   `TRIGGER_PACKET_WORD_COUNT`: **修改为 512** (之前2048个8位字现在变成512个32位字，保持相同的总字节数)。
*   **输入**:
    *   `adc_clk_25mhz`: 来自 `Clocking Wizard` (驱动模块核心逻辑和数据打包逻辑)。
    *   `sys_rst_n`: 连接到一个与 `adc_clk_25mhz` 同步的**低有效复位**。可以由 `Processor System Reset` IP针对PL逻辑生成，或者简单地将 `sys_rst_n_external` 通过反相器后，再经过同步逻辑处理得到。
    *   `digital_trigger_signal`: 来自 `digital_trigger_detector.digital_trigger_out`。    *   `data_extract_pulse`: 来自 `data_extract.data_extract_pulse`。
    *   `adc_data_input [7:0]`: 来自 `adc_data_acquisition.adc_data_buffered`。
    *   `m_axis_tready`: 来自 `AXI4-Stream Data FIFO` 的 `S_AXIS_TREADY`。
*   **输出**:
    *   `m_axis_tdata [31:0]`: **32位输出** - 连接到 `AXI4-Stream Data FIFO` 的 `S_AXIS_TDATA`。
    *   `m_axis_tvalid`: 连接到 `AXI4-Stream Data FIFO` 的 `S_AXIS_TVALID`。
    *   `m_axis_tlast`: 连接到 `AXI4-Stream Data FIFO` 的 `S_AXIS_TLAST`。
    *   `trigger_ready_status`: **应连接到 `data_extract.fifo_write_ready`** 以实现正确的数据抽取控制。
    *   `trigger_active_status`: 可连接到LED或ILA进行调试。

### 5.9. AXI4-Stream Data FIFO - **32位数据宽度**
*   **配置**:
    *   FIFO Interface Type: AXI4-Stream.
    *   FIFO Implementation: Block RAM.
    *   **Clocking Mode: Independent Clocks** (因为读写在不同时钟域)。
    *   **Slave AXI-Stream Interface (Write Port - PL side)**:
        *   **Data Width: 32 bits** (匹配trigger_controller的输出)。
        *   (根据需要配置深度，例如 `TRIGGER_PACKET_WORD_COUNT` 或更大)。
    *   **Master AXI-Stream Interface (Read Port - AXI/DMA side)**:
        *   **Data Width: 32 bits** (与DMA的S2MM接口数据宽度匹配)。
*   **连接**:
    *   **Slave Interface (Write - `trigger_controller` side)**:
        *   `s_axis_aclk`: 连接到 `adc_clk_25mhz`。
        *   `s_axis_aresetn`: 连接到与 `adc_clk_25mhz` 同步的**高有效复位** (注意：FIFO通常使用高有效复位)。
        *   `S_AXIS_TDATA [31:0]`: **直接连接到 `trigger_controller.m_axis_tdata`** (移除之前的位拼接)。
        *   `S_AXIS_TVALID`: 来自 `trigger_controller.m_axis_tvalid`。
        *   `S_AXIS_TLAST`: 来自 `trigger_controller.m_axis_tlast`。
        *   `S_AXIS_TREADY`: 连接到 `trigger_controller.m_axis_tready`。
    *   **Master Interface (Read - DMA side)**:
        *   `m_axis_aclk`: 连接到 `FCLK_CLK0` (来自PS)。
        *   `m_axis_aresetn`: 连接到 `Processor System Reset` 的 `peripheral_aresetn`。
        *   `M_AXIS_TDATA [31:0]`: 连接到 `AXI DMA` 的 `S_AXIS_S2MM_TDATA`。
        *   `M_AXIS_TVALID`: 连接到 `AXI DMA` 的 `S_AXIS_S2MM_TVALID`。
        *   `M_AXIS_TLAST`: 连接到 `AXI DMA` 的 `S_AXIS_S2MM_TLAST`。
        *   `M_AXIS_TREADY`: 来自 `AXI DMA` 的 `S_AXIS_S2MM_TREADY`。
    *   `s_axis_data_count`, `m_axis_data_count`: 可用于调试。

### 5.A. AXI Direct Memory Access (DMA) - **32位数据宽度**
*   **配置** (双击IP):
    *   取消选中 "Enable Write Channel" (MM2S)。
    *   **选中 "Enable Read Channel" (S2MM)**。
    *   Buffer Length Register Width: 例如 16位 (支持最大64KB传输) 或更大 (如23位支持8MB)。根据 `TRIGGER_PACKET_WORD_COUNT` 计算所需字节数：512个32位字 = 512 × 4 = 2048字节，确保此宽度足够。
    *   **S2MM Data Width**: **配置为32位** (与 `AXI4-Stream Data FIFO` 的 `M_AXIS_TDATA` 宽度一致)。
    *   Max Burst Size: 根据性能需求选择 (例如16, 32, 64, 128, 256)。
*   **连接**:
    *   **S_AXI_LITE (Control Interface)**:
        *   `s_axi_lite_aclk`: 连接到 `FCLK_CLK0`。
        *   `s_axi_lite_aresetn`: 连接到 `Processor System Reset` 的 `peripheral_aresetn`。
        *   将此接口通过AXI SmartConnect或AXI Interconnect连接到ZYNQ PS的 `M_AXI_GP0` (或 `M_AXI_GP1`) 接口，以便PS配置DMA。
    *   **S_AXIS_S2MM (Stream Data Input from PL)**:
        *   `s_axis_s2mm_aclk`: 连接到 `FCLK_CLK0`。
        *   `S_AXIS_S2MM_TDATA [31:0]`: **32位数据** - 来自 `AXI4-Stream Data FIFO` 的 `M_AXIS_TDATA`。
        *   `S_AXIS_S2MM_TVALID`: 来自 `AXI4-Stream Data FIFO` 的 `M_AXIS_TVALID`。
        *   `S_AXIS_S2MM_TLAST`: 来自 `AXI4-Stream Data FIFO` 的 `M_AXIS_TLAST`。
        *   `S_AXIS_S2MM_TREADY`: 连接到 `AXI4-Stream Data FIFO` 的 `M_AXIS_TREADY`。
    *   **M_AXI_S2MM (Memory Mapped Data Output to PS DDR)**:
        *   `m_axi_s2mm_aclk`: 连接到 `FCLK_CLK0`。
        *   将此接口通过AXI SmartConnect或AXI Interconnect连接到ZYNQ PS的 `S_AXI_HP0` (或 `S_AXI_HP1`, `S_AXI_HP2`, `S_AXI_HP3`) 接口。
    *   **Interrupts**:
        *   `s2mm_introut`: 连接到ZYNQ PS的 `IRQ_F2P[0:0]` (或选择一个可用的中断输入)。

## 6. 地址分配

*   在Block Design验证通过后，打开 "Address Editor" 选项卡。
*   Vivado通常会自动分配AXI外设的地址。确保 `AXI DMA` 的 `S_AXI_LITE` 控制接口在PS的 `M_AXI_GPx` 地址空间内有一个分配的地址范围。
*   `AXI DMA` 的 `M_AXI_S2MM` 接口不需要在PL的地址编辑器中分配地址，因为它直接访问PS的DDR内存空间。

## 7. **32位AXI架构关键修改总结**

### 7.1 Block Design修改要点
1. **trigger_controller IP重新配置**：
   - `TDATA_WIDTH` = 32
   - `TRIGGER_PACKET_WORD_COUNT` = 512
   - 更新IP封装以正确关联时钟和接口频率

2. **FIFO Generator重新配置**：
   - 数据宽度从8位修改为32位
   - 移除不必要的位拼接，直接连接32位数据

3. **关键连接修改**：
   - `data_extract.fifo_write_ready` 连接到 `trigger_controller.trigger_ready_status`
   - 所有AXI接口使用32位数据宽度
   - 确保时钟域和复位信号正确连接

### 7.2 软件侧修改
在Vitis中，需要相应修改：
- `MAX_PKT_LEN` = 512 × 4 = 2048字节
- DMA传输配置使用32位数据宽度
- 数据解析逻辑需要处理32位打包的数据

## 8. 注意事项

*   **时钟域交叉 (CDC)**: `AXI4-Stream Data FIFO` 在独立时钟模式下内部处理CDC。确保FIFO的深度足够应对时钟差异和数据突发。
*   **复位同步**: 确保所有复位信号对于其对应的时钟域是同步的。`Processor System Reset` IP有助于生成符合AXI规范的同步复位。
*   **AXI Interconnects**: 当连接多个AXI主设备到从设备，或多个从设备到一个主设备时，使用 `AXI SmartConnect` IP (推荐) 或 `AXI Interconnect` IP。
*   **Validate BD**: 完成连接后，务必运行 "Validate BD" 检查错误。
*   **ILA调试**: 在关键AXI4-Stream接口 (如 `trigger_controller` 到FIFO, FIFO到DMA) 和DMA控制信号上添加ILA，以便硬件调试。
*   **数据对齐**: 32位架构下，确保DMA目标地址是4字节对齐的。

此连接指南提供了一个详细的32位AXI架构框架。根据您的具体设计和FPGA开发板，可能需要进行微调。