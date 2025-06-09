# Vivado Block Design 连接指南

本文档旨在指导用户如何在Vivado Block Design (BD) 中连接重构后的Verilog模块，以实现ADC/DAC测试系统的功能。

## 1. 添加模块到Block Design

首先，需要将以下Verilog模块作为源文件添加到Vivado工程中，或者将它们打包成IP核后添加到IP Catalog，然后从Catalog中拖拽到Block Design画布上：

*   `key_debounce.v`
*   `dds_signal_generator.v`
*   `adc_data_acquisition.v`
*   `digital_trigger_detector.v`
*   `data_extract.v`
*   `trigger_controller.v`
*   `adc_fifo` (您需要一个FIFO IP核，例如Vivado自带的 FIFO Generator IP)
*   `PLL` (您需要一个PLL/Clocking Wizard IP核，例如Vivado自带的 Clocking Wizard IP)
*   三个独立的ROM IP核 (例如Vivado自带的 Block Memory Generator IP)，分别用于存储正弦波、方波和三角波的采样数据。

## 2. 创建外部端口

在Block Design的画布上，右键选择 "Create Port" 来创建以下外部输入和输出端口，这些端口将对应FPGA的物理引脚或与其他系统模块的接口。

### 输入端口:

*   `crystal_clk_50mhz`: `clk` 类型, 单比特，外部50MHz晶振时钟输入。
*   `key_freq_sel`: `data` 类型, 单比特，频率选择按键输入 (低电平有效)。
*   `key_wave_sel`: `data` 类型, 单比特，波形选择按键输入 (低电平有效)。
*   `key_extract_sel`: `data` 类型, 单比特，抽取比例选择按键输入 (低电平有效)。
*   `key_reset`: `data` 类型, 单比特，系统复位按键输入 (低电平有效)。
*   `adc_data_input`: `data` 类型, 8比特 (`[7:0]`)，ADC原始数据输入。

### 输出端口:

*   `dac_data_output`: `data` 类型, 8比特 (`[7:0]`)，DAC数据输出。
*   `dac_clock_output`: `clk` 类型, 单比特，DAC工作时钟输出。
*   `adc_clock_output`: `clk` 类型, 单比特，ADC工作时钟输出。
*   `led_pll_locked`: `data` 类型, 单比特，PLL锁定指示LED (低电平有效)。
*   `led_fifo_full`: `data` 类型, 单比特，FIFO满状态指示LED (低电平有效)。
*   `led_trigger_signal`: `data` 类型, 单比特，触发信号指示LED (低电平有效)。
*   `led_trigger_enable`: `data` 类型, 单比特，触发使能指示LED (低电平有效)。

## 3. 模块间连接

以下是各模块主要端口的连接建议：

### 3.1. 时钟生成 (PLL/Clocking Wizard IP)

*   **输入**:
    *   `clk_in1`: 连接到外部端口 `crystal_clk_50mhz`。
    *   `reset`: 可以连接到 `key_reset` 经过处理后的复位信号 (如果PLL需要同步复位)，或者根据PLL IP的推荐连接到常低或常高。通常，上电复位已足够。
*   **输出**:
    *   `clk_out1` (配置为50MHz): 命名为 `dac_clk_50mhz`。
    *   `clk_out2` (配置为25MHz): 命名为 `adc_clk_25mhz`。
    *   `locked`: 连接到 `led_pll_locked` 外部端口 (注意：LED为低电平有效，可能需要在BD中添加一个反相器，或者在约束文件中处理)。

### 3.2. 按键消抖 (`key_debounce`)

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

### 3.3. DDS信号发生器 (`dds_signal_generator`)

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

### 3.4. ROM IP核 (三个独立的Block Memory Generator)

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

### 3.5. ADC数据采集 (`adc_data_acquisition`)

*   **输入**:
    *   `adc_clk_25mhz`: 连接到 `adc_clk_25mhz` (来自PLL)。
    *   `adc_data_input`: 连接到外部端口 `adc_data_input`。
    *   `reset_pulse`: 来自 `key_debounce.reset_pulse`。
*   **输出**:
    *   `adc_data_buffered`: 连接到 `digital_trigger_detector.adc_data_in` 和 `adc_fifo.din`。
    *   `fifo_reset_signal`: 连接到 `adc_fifo.srst` (或 `rst`，取决于FIFO IP的复位端口名称和类型)。

### 3.6. 数字触发检测 (`digital_trigger_detector`)

*   **输入**:
    *   `adc_clk_25mhz`: 连接到 `adc_clk_25mhz` (来自PLL)。
    *   `adc_data_in`: 来自 `adc_data_acquisition.adc_data_buffered`。
    *   `trigger_enable`: 在BD中创建一个Constant IP核，值为 `1'b1` (或者如果希望通过按键控制，则需要更复杂的逻辑从按键输入生成此信号)，连接到此端口。或者，直接在BD中将此端口连接到 `trigger_enable_setting` (如果已将其设为BD的输入端口或由其他逻辑生成)。简单起见，先用常数。
    *   `trigger_level`: 在BD中创建一个Constant IP核，值为 `8'd120`，连接到此端口。
    *   `trigger_hysteresis`: 在BD中创建一个Constant IP核，值为 `3'd3`，连接到此端口。
*   **输出**:
    *   `digital_trigger_out`: 连接到 `trigger_controller.digital_trigger_signal` 和外部端口 `led_trigger_signal` (注意LED低有效，可能需要反相器)。

### 3.7. 数据抽取 (`data_extract`)

*   **输入**:
    *   `adc_clk_25mhz`: 连接到 `adc_clk_25mhz` (来自PLL)。
    *   `extract_ratio_change_pulse`: 来自 `key_debounce.extract_change_pulse`。
    *   `fifo_write_ready`: 来自 `trigger_controller.fifo_write_ready`。
*   **输出**:
    *   `data_extract_pulse`: 连接到 `trigger_controller.data_extract_pulse`。
    *   `current_extract_ratio`, `extract_counter`: 状态输出，可悬空或连接到ILA。

### 3.8. 触发控制器 (`trigger_controller`)

*   **输入**:
    *   `adc_clk_25mhz`: 连接到 `adc_clk_25mhz` (来自PLL)。
    *   `fifo_empty`: 来自 `adc_fifo.empty`。
    *   `fifo_full`: 来自 `adc_fifo.full`。
    *   `digital_trigger_signal`: 来自 `digital_trigger_detector.digital_trigger_out`。
    *   `data_extract_pulse`: 来自 `data_extract.data_extract_pulse`。
*   **输出**:
    *   `fifo_write_ready`: 连接到 `data_extract.fifo_write_ready`。
    *   `fifo_write_enable`: 连接到 `adc_fifo.wr_en`。
    *   `fifo_read_enable`: 连接到 `adc_fifo.rd_en`。
    *   `pre_trigger_count`, `trigger_ready`, `trigger_state`: 状态输出，可悬空或连接到ILA。

### 3.9. ADC FIFO (FIFO Generator IP)

*   **配置**:
    *   接口类型: Native
    *   FIFO实现: 根据资源和性能需求选择 (e.g., Block RAM)
    *   读写时钟: `adc_clk_25mhz` (同步FIFO)
    *   数据宽度: 8位
    *   数据深度: 例如1024或2048 (根据需求调整，例如 `PRE_TRIGGER_DEPTH` 是500，总深度应大于此)
    *   复位类型: 同步复位 (Synchronous Reset)
*   **输入**:
    *   `clk`: 连接到 `adc_clk_25mhz` (来自PLL)。
    *   `srst` (或 `rst`): 连接到 `adc_data_acquisition.fifo_reset_signal`。
    *   `din`: 连接到 `adc_data_acquisition.adc_data_buffered`。
    *   `wr_en`: 连接到 `trigger_controller.fifo_write_enable`。
    *   `rd_en`: 连接到 `trigger_controller.fifo_read_enable`。
*   **输出**:
    *   `dout`: 此端口的数据通常用于后续处理或通过JTAG/UART等接口传输出去。在当前设计中，如果只是为了板级测试DAC和ADC的配合，`dout` 可能不直接连接到外部DAC，因为DAC输出的是DDS生成的波形。如果需要观察采集到的ADC数据，可以将 `dout` 连接到ILA，或者引出到外部接口。目前可以暂时悬空或连接到ILA。
    *   `full`: 连接到 `trigger_controller.fifo_full` 和外部端口 `led_fifo_full` (注意LED低有效，可能需要反相器)。
    *   `empty`: 连接到 `trigger_controller.fifo_empty`。

### 3.10. 连接到外部输出端口

*   `dac_clock_output`: 连接到 `dac_clk_50mhz` (来自PLL)。
*   `adc_clock_output`: 连接到 `adc_clk_25mhz` (来自PLL)。
*   `led_trigger_enable`:
    *   如果 `digital_trigger_detector.trigger_enable` 是由BD内的常数 `1'b1` 提供，则此LED将常亮（表示使能）。将此端口连接到该常数（可能需要反相器）。
    *   或者，更灵活地，将 `digital_trigger_detector` 的 `trigger_enable` 输入端口也作为BD的一个外部输入端口（例如 `ext_trigger_enable_input`），然后 `led_trigger_enable` 连接到这个 `ext_trigger_enable_input` (经过反相器)。

## 4. 注意事项

*   **LED驱动**: 所有LED输出端口 (`led_pll_locked`, `led_fifo_full`, `led_trigger_signal`, `led_trigger_enable`) 都是低电平有效。如果直接将高电平有效的信号连接到这些端口，LED的行为会相反。您可以在BD中使用 "Utility Vector Logic" IP核添加反相器，或者在顶层Wrapper生成后，在约束文件中处理（不推荐，最好在逻辑层面处理）。
*   **Constant IP**: 对于固定的触发参数 (`trigger_level`, `trigger_hysteresis`, `trigger_enable`)，可以使用Vivado提供的 "Constant" IP核来生成这些值。
*   **ILA调试**: 强烈建议在关键信号路径上添加ILA (Integrated Logic Analyzer) IP核，以便在硬件上进行调试。例如，可以监控ADC数据、触发信号、FIFO状态、DDS输出等。
*   **Validate BD**: 在完成所有连接后，务必运行 "Validate BD" 功能，检查是否有连接错误或警告。
*   **Generate Output Products**: 为BD生成输出产物，包括HDL Wrapper。
*   **约束文件**: 不要忘记为所有外部端口（特别是时钟和物理IO）在XDC约束文件中添加正确的管脚分配和时序约束。

此连接指南提供了一个基础框架。根据您的具体FPGA开发板和进一步的设计需求，可能需要进行调整。