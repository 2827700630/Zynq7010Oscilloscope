# ZYNQ7010 ADC/DAC 测试与信号处理平台

## 1. 项目概述

本项目旨在为 ZYNQ7010 FPGA 开发板提供一个模块化的 ADC/DAC 测试与数字信号处理平台。原始设计基于一个现有的 ZYNQ7010 Verilog 工程，经过了深入分析和重构，以适应 Vivado Block Design 的开发流程，显著提高了代码的可重用性、可维护性和模块化程度。

项目核心功能包括：
*   通过 ADC (Analog-to-Digital Converter) 模块采集外部模拟信号。
*   使用 DDS (Direct Digital Synthesizer) 信号发生器产生测试波形，驱动 DAC (Digital-to-Analog Converter)。
*   实现灵活的数字触发功能，用于捕获特定事件。
*   通过按键与系统进行交互。

整个重构过程涉及了代码分解、变量名优化、注释添加、冗余功能移除（如 UART）、DDS 模块的 ROM 外置和单时钟改造、以及 ADC 数据采集模块的专门化。

## 2. 硬件与软件环境

*   **硬件平台**: Xilinx ZYNQ7010 (或兼容的 Zynq-7000 系列器件)
*   **开发工具**: Xilinx Vivado Design Suite (建议 2017.4 或更高版本以获得更好的 Verilog-in-Block-Design 支持)

## 3. 主要功能模块

本项目包含以下主要 Verilog HDL 模块：

*   **`adda_test_top.v`**: 概念上的顶层模块。在 Vivado Block Design 环境中，其角色主要由 Vivado 自动生成的 Block Design Wrapper 取代。它负责例化和连接项目中的各个子模块。**注意**: 触发参数 (`trigger_level_setting`, `trigger_hysteresis_setting`, `trigger_enable_setting`) 在此模块中定义并连接到相应模块。
*   **`key_debounce.v`**: 按键消抖模块。接收最多4个低电平有效的按键输入，并为每个按键生成一个单时钟周期的脉冲信号 (`key_change_pulse`)，指示按键被按下。
*   **`dds_signal_generator.v`**: DDS 信号发生器。此模块经过重大修改：
    *   移除了内部 ROM，改为使用外部 ROM 接口 (`rom_address`, `rom_data_out`)，便于在 Block Design 中连接 `Block Memory Generator` IP。
    *   统一使用单一时钟 `dac_clk_50mhz` 进行操作。
    *   包含了用于同步来自不同时钟域的控制信号（如 `freq_set_pulse`, `phase_set_pulse`）的逻辑。
    *   输出相位累加值 (`phase_accumulator_out`) 和最终的 DDS 波形数据 (`dds_output_data`)。
*   **`adc_data_acquisition.v`**: ADC 数据采集模块。此模块经过简化，专注于：
    *   缓冲输入的 ADC 数据 (`adc_data_in`)。
    *   基于 `adc_clk` 生成 ADC FIFO 的复位信号 (`adc_fifo_reset_signal`)。
    *   移除了原有的触发参数输出、`data_valid` 逻辑以及数据质量检查，以消除与触发模块的功能冗余。
*   **`digital_trigger_detector.v`**: 数字触发检测器。根据输入的 ADC 数据 (`adc_data_in`) 和由 `trigger_controller` 提供的触发电平 (`trigger_level`)、迟滞 (`trigger_hysteresis`) 及使能 (`trigger_enable`) 信号，判断是否满足触发条件，并输出触发信号 (`trigger_signal`)。
*   **`trigger_controller.v`**: 触发控制器。管理触发逻辑：
    *   接收来自按键的控制信号（如模式选择、参数调整）。
    *   根据按键输入更新触发参数（电平、迟滞、使能）。
    *   将这些参数传递给 `digital_trigger_detector`。
    *   移除了原有的 `adc_data_in` 输入，不再直接处理 ADC 数据。

**已移除/替代的模块:**

*   `UART_TX.v` 和 `uartcontrol.v`: UART 相关功能已从当前设计中移除，以简化 FPGA 逻辑。若需串行通信，建议利用 ZYNQ PS (Processing System) 的 UART 功能。
*   `data_extract.v` (原始版本): 其功能已被新的 `adc_data_acquisition.v` 和 `trigger_controller.v` 等模块更清晰地划分和实现。
*   `trig.v` (原始版本): 其功能已被 `digital_trigger_detector.v` 和 `trigger_controller.v` 模块替代。

## 4. 关键特性与改进

*   **高度模块化**: 代码被精心分解为独立的、功能明确的模块，非常适合在 Vivado Block Design 中进行图形化连接和系统集成。
*   **DDS 外部 ROM 与单时钟**: `dds_signal_generator` 模块采用外部 ROM 接口，增强了波形存储的灵活性，并统一使用 `dac_clk_50mhz`，简化了时钟管理。
*   **专注且高效的 ADC 采集**: `adc_data_acquisition` 模块功能明确，专注于数据缓冲和 FIFO 控制，消除了与触发逻辑的耦合，避免了功能冗余。
*   **清晰分离的触发逻辑**: 触发检测 (`digital_trigger_detector`) 与触发控制 (`trigger_controller`) 分离，使得逻辑更清晰，易于理解和修改。
*   **移除 UART**: 简化了 PL (Programmable Logic) 部分的设计，降低了资源消耗。
*   **改进的变量命名和注释**: 提高了代码的可读性和可维护性。
*   **按键脉冲生成**: `key_debounce.v` 确保在按键按下时（输入从高到低跳变）产生可靠的单周期脉冲。

## 5. 如何使用 (Vivado Block Design)

1.  **创建新工程**: 在 Vivado 中创建一个针对 ZYNQ7010 (或所用开发板型号) 的新工程。
2.  **添加源文件**: 将本项目中的所有 `.v` Verilog 源文件添加为设计源文件 (Design Sources)。
3.  **创建 Block Design**:
    *   在 IP Integrator 中选择 "Create Block Design"。
    *   **添加自定义模块**:
        *   右键点击 Diagram 视图，选择 "Add Module..."，然后将 `key_debounce.v`, `dds_signal_generator.v`, `adc_data_acquisition.v`, `digital_trigger_detector.v`, `trigger_controller.v` 添加到 Block Design 中。Vivado 会自动将它们封装成 IP 块。
        *   或者，可以将每个 Verilog 文件手动打包成 IP (Tools -> Create and Package New IP)，然后添加到 IP Catalog，再从 Catalog 中拖拽到 Block Design。
    *   **添加 Xilinx IP 核**:
        *   `ZYNQ7 Processing System`: 必须添加并配置。至少需要配置好 DDR 和应用的 PL Fabric Clocks (如 FCLK_CLK0, FCLK_CLK1)。
        *   `Clocking Wizard` (可选，但推荐): 用于从 PS 输出的 FCLK 生成项目所需的特定频率时钟 (如 `adc_clk`, `dac_clk_50mhz`, `sys_clk_100mhz`)，并确保时钟质量。
        *   `Block Memory Generator` (x2): 为 `dds_signal_generator` 提供两个独立的 ROM。一个用于存储正弦波数据，另一个用于存储三角波/方波数据（根据 DDS 设计）。配置其接口以匹配 `dds_signal_generator` 的 `rom_address` 和 `rom_data_out` 端口。
        *   `Utility Vector Logic` / `Slice` / `Constant` IPs: 可能需要用于提供固定的控制信号、参数，或进行简单的逻辑操作。
4.  **连接模块**:
    *   参考 `Block_Design_Connection_Guide.md` 和各模块的端口定义，仔细连接各个模块。
    *   **时钟和复位**: 确保所有模块的 `clk` 和 `reset_n` (或 `reset`) 信号正确连接。通常，复位信号由 `Processor System Reset` IP 生成，并连接到所有需要同步复位的模块。
    *   **DDS ROMs**: 将 `Block Memory Generator` IP 的输出连接到 `dds_signal_generator` 的 `rom_data_out_sin` 和 `rom_data_out_other` (或类似名称，取决于 DDS 修改后的端口) 输入，并将 `dds_signal_generator` 的 `rom_address_sin` 和 `rom_address_other` 连接到 ROMs 的地址输入。
    *   **触发参数**: 将 `adda_test_top.v` (或在 BD 中创建的等效信号) 中的 `trigger_level_setting`, `trigger_hysteresis_setting`, `trigger_enable_setting` 连接到 `trigger_controller` 的相应输入。
    *   **外部端口**: 右键点击模块端口或信号线，选择 "Make External" 以创建顶层 I/O 端口 (如按键输入、LED 输出、ADC/DAC 接口信号)。
5.  **验证 Block Design**: 点击 "Validate Design" (F6) 检查连接错误。
6.  **创建 HDL Wrapper**: 右键点击 Block Design 源文件 (通常是 `.bd` 文件) 并选择 "Create HDL Wrapper..."，让 Vivado 管理 Wrapper 的更新。
7.  **添加约束**: 创建或编辑 XDC 约束文件 (例如 `pinlayout.xdc`)。
    *   使用 I/O Planning 视图分配 FPGA 引脚，并设置 I/O 标准 (如 LVCMOS33)。
    *   **重要**: 确保在 I/O Planning 中所做的更改已保存到 XDC 文件中，以避免在重新打开工程时丢失配置。
    *   为所有时钟信号创建时钟约束。
8.  **运行综合、实现、生成比特流**: 按照 Vivado 的标准流程执行。
9.  **硬件测试**: 将生成的比特流下载到 ZYNQ7010 开发板上，并进行功能验证。

## 6. 文件结构 (主要文件)

*   `key_debounce.v`: 按键消抖模块。
*   `dds_signal_generator.v`: DDS 信号发生器模块。
*   `adc_data_acquisition.v`: ADC 数据采集模块。
*   `digital_trigger_detector.v`: 数字触发检测模块。
*   `trigger_controller.v`: 触发控制器模块。
*   `adda_test_top.v`: (概念性)顶层模块，主要用于参数定义和模块例化展示。
*   `pinlayout.xdc`: 引脚和时序约束文件。
*   `Block_Design_Connection_Guide.md`: Block Design 中模块连接的详细指南。
*   `README.md`: 本文档。
*   `IMPROVEMENT_SUMMARY.md`: (早期) 改进摘要。
*   `block_deseign.v`: (用户提供的) Block Design 导出的 Verilog 文件，用于审查。

## 6.1. 用户可配置参数

为了适应不同的测试需求和硬件特性，本项目中的一些关键参数可以通过修改 Verilog 源代码中的 `localparam` 或在 Block Design 中通过连接外部信号/常量 IP 来进行配置。主要参数如下：

1.  **预触发深度 (Pre-trigger Depth)**:
    *   **描述**: 定义在触发事件发生前，FIFO 中需要存储的数据点数量。
    *   **位置**: `trigger_controller.v` 模块内部。
    *   **参数名**: `PRE_TRIGGER_DEPTH` (localparam)
    *   **默认值**: `11'd500`
    *   **设置方式**: 直接修改 `trigger_controller.v` 文件中 `localparam PRE_TRIGGER_DEPTH = 11'd500;` 这一行的值。
    *   **注意**: 该值不应超过 FIFO 的总深度。

2.  **触发电平 (Trigger Level)**:
    *   **描述**: ADC 数据超过此电平（对于上升沿触发）或低于此电平（对于下降沿触发，如果设计支持）时，会产生触发事件。
    *   **位置**: 此参数由 `trigger_controller.v` 模块输出，并连接到 `digital_trigger_detector.v` 模块的 `trigger_level` 输入端口。
    *   **设置方式**:
        *   **硬编码/顶层参数**: 在 `adda_test_top.v` (或 Block Design 的顶层 Wrapper) 中定义一个 `wire` 或 `parameter`，并将其连接到 `trigger_controller` 的相应输入（如果 `trigger_controller` 设计为接收外部设置）或直接连接到 `digital_trigger_detector` 的 `trigger_level` 输入。
        *   **动态设置 (通过按键)**: 当前 `trigger_controller.v` 的设计意图是通过按键输入来动态调整触发电平。具体的按键逻辑在 `trigger_controller.v` 内部实现，它会更新内部寄存器，该寄存器的值最终作为 `trigger_level` 输出给 `digital_trigger_detector`。
    *   **范围**: 通常是 ADC 的数据范围 (例如，对于8位 ADC，是 0 到 255)。

3.  **触发迟滞 (Trigger Hysteresis)**:
    *   **描述**: 用于防止在触发电平附近的噪声引起多次误触发。当信号在触发电平附近小幅波动时，迟滞定义了一个不敏感区域。
    *   **位置**: 与触发电平类似，此参数由 `trigger_controller.v` 模块输出，并连接到 `digital_trigger_detector.v` 模块的 `trigger_hysteresis` 输入端口。
    *   **设置方式**: 同触发电平的设置方式，通常与触发电平一起通过按键动态调整，或在顶层硬编码。
    *   **范围**: 一个较小的值，例如 `2'b11` (十进制 3) 或 `3'b001` (十进制 1) 到 `3'b111` (十进制 7)，具体取决于噪声水平和 ADC 分辨率。

4.  **触发使能 (Trigger Enable)**:
    *   **描述**: 控制是否启用触发检测功能。
    *   **位置**: 由 `trigger_controller.v` 模块输出，并连接到 `digital_trigger_detector.v` 模块的 `trigger_enable` 输入端口。
    *   **设置方式**: 通常通过按键在 `trigger_controller.v` 内部进行切换，或在顶层设计中连接一个控制信号。

5.  **DDS 信号频率与相位 (DDS Signal Frequency and Phase)**:
    *   **描述**: `dds_signal_generator.v` 模块产生的波形的频率和初始相位。
    *   **位置**: 这些参数通过 `dds_signal_generator.v` 的输入端口进行设置：
        *   `frequency_setting_word`: 频率控制字。
        *   `phase_offset_setting`: 相位偏移设置。
        *   `freq_set_pulse`: 应用新频率设置的脉冲信号。
        *   `phase_set_pulse`: 应用新相位设置的脉冲信号。
    *   **设置方式**: 这些控制信号和参数通常由 `key_debounce.v` 模块产生的按键脉冲，经过一定的逻辑处理（可能在 `adda_test_top.v` 或专门的控制模块中，或直接在 `trigger_controller.v` 中，如果按键功能集成在那里）后，连接到 `dds_signal_generator.v` 的相应输入端口。
    *   **注意**: 频率控制字和相位偏移值的具体计算方法取决于 DDS的设计（如相位累加器的位数、时钟频率等）。

6.  **DDS 波形选择 (DDS Waveform Selection - 如果支持多种波形)**:
    *   **描述**: 如果 `dds_signal_generator.v` 设计为可以输出多种波形 (如正弦波、方波、三角波)，则需要有选择信号。
    *   **位置**: 通常是 `dds_signal_generator.v` 的一个或多个输入端口。
    *   **设置方式**: 通过按键或其他控制逻辑在顶层设计中生成选择信号，并连接到 DDS 模块。
    *   **当前设计**: 当前 `dds_signal_generator.v` 的修改主要是针对外部 ROM，具体波形选择逻辑需要查看其内部实现或顶层连接。如果使用不同的 ROM 存储不同波形，则选择逻辑可能涉及到使能不同的 ROM 或选择不同的 ROM 数据输出。

**在 Block Design 中的配置方法总结**:

*   对于 `localparam` 定义的参数 (如 `PRE_TRIGGER_DEPTH`)，需要直接修改对应的 `.v` 文件。
*   对于通过模块端口输入的参数 (如触发电平、迟滞、DDS 控制字等)：
    *   **静态配置**: 可以在 Block Design 中添加 `Constant` IP 核 (Xilinx IP Catalog -> Utility -> Constant) 并将其输出连接到模块的参数输入端口。
    *   **动态配置**: 将来自 `key_debounce.v` 的按键信号，经过必要的控制逻辑模块 (可以是自定义的 Verilog 模块，或者是用 `Slice`, `Concat`, `Utility Vector Logic` 等 IP 组合实现) 处理后，连接到相应模块的参数输入端口。
    *   **ZYNQ PS 控制**: 更高级的配置可以通过 ZYNQ Processing System 实现，通过 AXI 接口将参数从软件写入到 PL 侧的寄存器，这些寄存器的输出再连接到各模块的参数输入端口。本项目当前未明确包含此 PS 控制部分。

建议用户在进行具体实现时，仔细检查 `adda_test_top.v` (作为概念连接的参考) 以及各子模块的端口列表和内部参数定义，以确定最佳的参数配置方式。

## 7. 注意事项与未来工作

*   **ZYNQ PS 配置**: 在 Block Design 中，ZYNQ Processing System IP 的配置至关重要。确保正确配置了 DDR 控制器、MIO/EMIO 分配以及所需的 PL Fabric Clocks。
*   **I/O 标准和引脚分配**: 务必在 XDC 文件中为所有外部端口指定正确的 I/O 标准 (如 LVCMOS33, LVDS 等) 和 FPGA 引脚位置。不正确的配置可能导致硬件损坏或功能异常。
*   **时钟域同步 (CDC)**: 对于跨越不同时钟域的信号，必须使用正确的同步技术 (如两级触发器同步器) 来防止亚稳态问题。`dds_signal_generator` 中已包含部分此类逻辑。
*   **Block Design 外部端口**: 确保 Block Design Wrapper 将所有必要的信号引出为外部端口，例如 LED 指示灯、ADC/DAC 时钟输出等。
*   **ROM 初始化**: `Block Memory Generator` IP 需要使用 `.coe` 文件来初始化 ROM 的内容 (波形数据)。确保这些文件已正确生成并关联到相应的 BMG IP。
*   **彻底的测试与验证**: 在将设计部署到实际硬件之前，强烈建议进行全面的仿真测试。之后，在硬件上逐步验证每个模块和整个系统的功能。

---

*本文档由 AI 编程助手 GitHub Copilot 协助生成并根据项目具体需求和开发过程进行了详细调整。*
