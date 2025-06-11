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

## 7. 注意事项与未来工作

*   **ZYNQ PS 配置**: 在 Block Design 中，ZYNQ Processing System IP 的配置至关重要。确保正确配置了 DDR 控制器、MIO/EMIO 分配以及所需的 PL Fabric Clocks。
*   **I/O 标准和引脚分配**: 务必在 XDC 文件中为所有外部端口指定正确的 I/O 标准 (如 LVCMOS33, LVDS 等) 和 FPGA 引脚位置。不正确的配置可能导致硬件损坏或功能异常。
*   **时钟域同步 (CDC)**: 对于跨越不同时钟域的信号，必须使用正确的同步技术 (如两级触发器同步器) 来防止亚稳态问题。`dds_signal_generator` 中已包含部分此类逻辑。
*   **Block Design 外部端口**: 确保 Block Design Wrapper 将所有必要的信号引出为外部端口，例如 LED 指示灯、ADC/DAC 时钟输出等。
*   **ROM 初始化**: `Block Memory Generator` IP 需要使用 `.coe` 文件来初始化 ROM 的内容 (波形数据)。确保这些文件已正确生成并关联到相应的 BMG IP。
*   **彻底的测试与验证**: 在将设计部署到实际硬件之前，强烈建议进行全面的仿真测试。之后，在硬件上逐步验证每个模块和整个系统的功能。

---

*本文档由 AI 编程助手 GitHub Copilot 协助生成并根据项目具体需求和开发过程进行了详细调整。*
