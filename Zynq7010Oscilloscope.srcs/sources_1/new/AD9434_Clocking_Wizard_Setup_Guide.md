\
# AD9434 Clocking Wizard 和 SelectIO Interface Wizard 图形化配置指南 (Vivado Block Design)

本文档指导如何在 Vivado Block Design 中为 AD9434 高速 ADC 配置 Clocking Wizard 和 SelectIO Interface Wizard。
新增：本指南现在包含一个方案，其中 FPGA 为 AD9434 提供 100MHz 的采样时钟。

## 第一部分：Clocking Wizard IP 配置

### 目标时钟方案

**重要概念:** 本指南描述多种方案。请根据您的需求选择：

*   **方案1: ADC DCO (250MHz) 直接驱动 SelectIO (简化方案 - 之前推荐)**
    *   **SelectIO IP 高速串行时钟 (`clk_in_p`, `clk_in_n`):** 直接由 AD9434 ADC 的 DCO 输出 (250 MHz 差分 LVDS) 提供。此 DCO 信号从 FPGA 外部引脚接入，并直接连接到 SelectIO IP 的 `clk_in_p` 和 `clk_in_n` 端口。
    *   **Clocking Wizard (用于生成并行时钟):**
        *   **输入:** 板载系统时钟 (例如，来自 Zynq PS 的 FCLK0，或板载晶振，频率如 100MHz 或 200MHz)。
        *   **输出:**
            1.  `clk_parallel_125m`: 125 MHz (用于 SelectIO IP 的 `clk_div_in` 端口以及 `ad9434_top_sdr` 模块的 `clk_parallel_data` 输入)。
            2.  `locked`: MMCM/PLL 锁定状态信号 (用于 `ad9434_top_sdr` 的 `mmcm_locked` 输入)。

*   **方案2: ADC DCO (250MHz) 输入到 Clocking Wizard (完整方案 - 之前讨论)**
    *   **ADC DCO (作为 Clocking Wizard 的输入):** 250 MHz (差分 LVDS 信号，直接来自 FPGA 引脚)。
    *   **Clocking Wizard 输出:**
        1.  `clk_iserdes_250m`: 250 MHz (用于 SelectIO IP 的高速串行时钟 `clk_in` 或 `clk_in_p`)。
        2.  `clk_iserdes_b_250m`: 250 MHz, 相对于 `clk_iserdes_250m` 反相 (用于 SelectIO IP 的反相高速串行时钟 `clk_in_b` 或 `clk_in_n`)。
        3.  `clk_parallel_125m`: 125 MHz (用于 SelectIO IP 的 `clk_div_in` 和 `ad9434_top_sdr` 的 `clk_parallel_data`)。
        4.  `clk_ref_200m` (如果启用输入延迟): 200 MHz (用于 SelectIO IP 的 `ref_clk`，即 IDELAYCTRL 的参考时钟)。
        5.  `locked`: MMCM/PLL 锁定状态信号 (用于 `ad9434_top_sdr` 的 `mmcm_locked` 输入)。

*   **方案3: FPGA 提供 100MHz 采样时钟给 AD9434 (当前验证方案)**
    *   **FPGA 输出 ADC 采样时钟 (由 `clk_wiz_0` 或新 Clocking Wizard 生成):**
        *   输入: 板载系统时钟 (例如 `crystal_clk_50mhz`)。
        *   输出: `fpga_to_adc_clk_p`/`fpga_to_adc_clk_n` (100MHz 差分时钟)，用于驱动 AD9434 的 CLK+/- 输入。
    *   **AD9434 DCO (现在是 100MHz) 输入到 FPGA (连接到 `clk_wiz_1`):**
        *   `adc_dco_bd_clk_p`/`adc_dco_bd_clk_n` (100MHz 差分)，来自 AD9434 的 DCO 输出。
    *   **`clk_wiz_1` (DCO 输入处理):**
        *   输入: 上述 100MHz DCO。
        *   输出:
            1.  `clk_iserdes_100m`: 100MHz (用于 SelectIO IP 的 `clk_in_p`)。
            2.  `clk_iserdes_b_100m`: 100MHz, 相对于 `clk_iserdes_100m` 反相 (用于 SelectIO IP 的 `clk_in_n`)。
            3.  `locked`: MMCM/PLL 锁定状态信号。
    *   **SelectIO Interface Wizard (`selectio_wiz_0`):**
        *   高速串行时钟输入 (`clk_in_p`, `clk_in_n`): 由 `clk_wiz_1` 的 `clk_iserdes_100m`/`clk_iserdes_b_100m` (100MHz) 驱动。
        *   并行时钟输出 (`clk_div_out`): 50MHz (100MHz / 2)。
    *   **`ad9434_top_sdr` 模块:**
        *   并行数据时钟 (`clk_parallel_data`): 由 `selectio_wiz_0` 的 `clk_div_out` (50MHz) 驱动。

### Clocking Wizard 配置步骤

#### A. 配置 `clk_wiz_0` (或新增 Clocking Wizard) 以生成 100MHz ADC 采样时钟

1.  **准备工作:**
    *   确保你的 Vivado 工程中已添加修改后的 `ad9434_top_sdr.v` (该模块现在接收并行数据) 作为设计源文件。
    *   打开或创建一个 Block Design。

2.  **添加/打开 Clocking Wizard IP (例如 `clk_wiz_0`):**
    *   如果使用现有的 `clk_wiz_0` (当前输入为 `crystal_clk_50mhz`)，双击打开其配置。
    *   如果需要新增一个 Clocking Wizard，右键点击 Block Design 画布，选择 "Add IP..."，搜索 "Clocking Wizard" 并双击添加。Vivado 会打开其配置界面。

3.  **配置 "Clocking Options" 选项卡:**
    *   **Input Clock Information:** 保持 `crystal_clk_50mhz` (50MHz) 或您选择的系统时钟。
    *   **Output Clocks:** 保留 `clk_wiz_0` 现有的输出时钟 (如 25MHz, 50MHz)。新增一个差分输出时钟:
        *   **Port Name (示例):** `clk_out_adc_sample` (会自动生成 `_p` 和 `_n` 后缀)。
        *   **Output Freq (MHz) Requested:** `100.000`
        *   **Output Type:** `Differential` (选择支持差分输出的缓冲器类型，如 `BUFGDS`)。
        *   **Phase (degrees) Requested:** `0.000`
    *   确保 `locked` 和 `reset` (高有效) 信号已勾选。

4.  **完成配置并连接:**
    *   将此 Clocking Wizard 生成的 100MHz 差分输出连接到 Block Design 顶层的 `fpga_to_adc_clk_p` 和 `fpga_to_adc_clk_n` 输出端口。

#### B. 重新配置 `clk_wiz_1` 以处理 100MHz DCO 输入

1.  **打开 `clk_wiz_1` 配置界面。**
2.  **配置 "Clocking Options" 选项卡:**
    *   **Input Clock Information / Primary Input Clock (`clk_in1`):**
        *   **Input Frequency (MHz):** 手动输入 `100.000` (新的 DCO 频率)。
        *   **Source:** 保持 `Differential clock capable pin`。
3.  **配置 "Output Clocks" 选项卡:**
    *   **Output Clock 1 (例如，命名为 `clk_iserdes_100m`):**
        *   **Port Name:** `clk_iserdes_100m`
        *   **Output Freq (MHz) Requested:** `100.000`
        *   **Phase (degrees) Requested:** `0.000`
    *   **Output Clock 2 (例如，命名为 `clk_iserdes_b_100m`):**
        *   **Port Name:** `clk_iserdes_b_100m`
        *   **Output Freq (MHz) Requested:** `100.000`
        *   **Phase (degrees) Requested:** `180.000`
    *   (移除之前可能存在的 125MHz 或 250MHz 并行时钟输出，除非您有特定理由保留并用于其他目的)。
    *   确保 `locked` 和 `reset` (高有效) 信号已勾选。
4.  **完成配置。**

7.  **连接 Block Design 中的时钟输入和复位到 Clocking Wizard:**
    *   **时钟输入到 Clocking Wizard:**
        *   **对于简化方案:** 将你的板载系统时钟源连接到 Clocking Wizard IP 的时钟输入端口 (`clk_in1`)。
        *   **对于完整方案:** 在 Block Design 的顶层，创建两个输入端口 (例如 `adc_dco_bd_p` 和 `adc_dco_bd_n`)，连接到 FPGA 的物理 DCO 输入引脚。将这两个顶层差分输入端口连接到 Clocking Wizard IP 的差分时钟输入端口 (`clk_in1_p` 和 `clk_in1_n`)。
    *   **复位信号:**
        *   将你的全局高有效复位信号连接到 Clocking Wizard 的 `reset` 输入。

8.  **验证设计:**
    *   在 Block Design 工具栏中点击 \"Validate Design\" (F6) 检查连接和配置错误。

完成以上步骤后，你的 AD9434 接口的时钟部分将完全由图形化配置的 Clocking Wizard IP 控制。
这种方法使得时钟参数的调整更加方便，并且能更好地利用 Vivado 的集成特性。
Verilog 代码将不再包含任何时钟生成或缓冲逻辑，仅作为数据处理的核心。

## 第二部分：SelectIO Interface Wizard IP 配置

### SelectIO IP 功能概述

SelectIO Interface Wizard IP 将替代之前在 Verilog 中手动例化的：
*   `IBUFDS` (差分输入缓冲器)
*   `IDELAYE2` (输入延迟单元)
*   `ISERDESE2` (串并转换器)
*   `IDELAYCTRL` (延迟控制器)

### SelectIO IP 配置步骤

1.  **添加/打开 SelectIO Interface Wizard IP (例如 `selectio_wiz_0`):** (同前)
2.  **配置 "Data Bus Setup" 选项卡:**
    *   **Interface Template:** `Custom`
    *   **Data Bus Direction:** `Input`
    *   **Data Rate:** `SDR`
    *   **Serialization Factor:** `2` (输出24位并行数据)
    *   **External Data Width:** `12`
3.  **配置 "I/O Signaling" 部分:** (同前，例如 LVDS 25)
4.  **配置 "Clock Setup" 选项卡 (重要更新):**
    *   **High Speed Clock Source:** `External` (表示时钟来自另一个 IP，即 `clk_wiz_1`)。
    *   **High Speed Clock Port (e.g., `clk_in_p`):** 连接到来自 `clk_wiz_1` 的 `clk_iserdes_100m` (100 MHz)。
    *   **High Speed Clock (Inverted) Port (e.g., `clk_in_n`):** 连接到来自 `clk_wiz_1` 的 `clk_iserdes_b_100m` (100 MHz, 180度相移)。
    *   **Divided Clock Port (e.g., `clk_div_in`):** 通常保持不连接，让 SelectIO IP 内部从 100MHz 高速时钟分频得到 50MHz 并行时钟。如果 IP 配置要求连接，可以从 `clk_wiz_0` 或 `clk_wiz_1` (如果配置了相应输出) 提供一个 50MHz 时钟。
    *   **Enable Clock Input Buffer:** **务必保持 `未选中`** (因为时钟来自内部 `clk_wiz_1`)。
5.  **配置 "Data And Clock Delay" 选项卡:**
    *   **Enable Input Data Delay:** 保持 `不选中` (用于简化和初始测试)
6.  **配置其他选项:**
    *   **Enable Input Serialization:** `选中` (启用 ISERDESE2 功能)
    *   **Serialization Mode:** 通常选择 `Master` 
    *   **Reset Logic:** 
        *   **Enable Reset:** `选中`
        *   **Reset Active:** 选择 `High` (假设您将连接取反的 `sys_rst_n`)

7.  **"Summary" 选项卡验证:**
    *   检查所有配置参数是否正确
    *   确认生成的端口列表符合预期：
        *   12 个差分数据输入端口 (`data_in_from_pins_p[11:0]`, `data_in_from_pins_n[11:0]`)
        *   时钟输入端口 (`clk_in`, `clk_in_b`, `clk_div_in`, `ref_clk`)
        *   12 位并行数据输出 (`data_in_to_device[11:0]`)
        *   复位和控制信号端口
    *   点击 "OK" 完成 SelectIO IP 的配置和生成

## 第三部分：Block Design 中的连接 (100MHz FPGA 采样时钟方案)

### 1. FPGA 到 AD9434 的采样时钟连接:
*   `clk_wiz_0` (或新的 Clocking Wizard) 的 100MHz 差分输出 (`clk_out_adc_sample_p/n`) → Block Design 顶层输出端口 (`fpga_to_adc_clk_p/n`) → (外部连接) AD9434 CLK+/- 输入。

### 2. AD9434 DCO (100MHz) 输入连接:
*   AD9434 DCO+/- 输出 → (外部连接) Block Design 顶层输入端口 (`adc_dco_bd_clk_p/n`) → `clk_wiz_1` 的差分时钟输入 (`clk_in1_p/n`)。

### 3. AD9434 LVDS 数据输入连接:
*   AD9434 Data+/- 输出 → (外部连接) Block Design 顶层输入端口 (`data_in_from_pins_p_0`/`data_in_from_pins_n_0`) → `selectio_wiz_0` 的 `data_in_from_pins_p/n`。

### 4. `clk_wiz_1` 到 `selectio_wiz_0` 时钟连接:
*   `clk_iserdes_100m` (`clk_wiz_1`) → `clk_in_p` (`selectio_wiz_0`)。
*   `clk_iserdes_b_100m` (`clk_wiz_1`) → `clk_in_n` (`selectio_wiz_0`)。

### 5. `selectio_wiz_0` 到 `ad9434_top_sdr` 连接:
*   `data_in_to_device[23:0]` (`selectio_wiz_0`) → `adc_parallel_data_from_selectio[23:0]` (`ad9434_top_sdr_0`)。
*   `clk_div_out` (`selectio_wiz_0`, 输出 50MHz) → `clk_parallel_data` (`ad9434_top_sdr_0`)。

### 6. Clocking Wizards 到 `ad9434_top_sdr` 控制信号:
*   `locked` (`clk_wiz_1`) → `mmcm_locked` (`ad9434_top_sdr_0`)。
*   (如果 `clk_wiz_0` 的 `locked` 信号也需要被监控，可以类似连接)。

### 7. 复位信号连接:
*   系统高有效复位 (`~sys_rst_n`) → `clk_wiz_0.reset`, `clk_wiz_1.reset`, `selectio_wiz_0.clk_reset`, `selectio_wiz_0.io_reset`。
*   系统低有效复位 (`sys_rst_n`) → `ad9434_top_sdr_0.sys_rst_n`。

### 8. Bitslip 控制连接:
*   `selectio_wiz_0.bitslip[11:0]` → 连接到全 '0' (例如通过 Constant IP)。

## 第四部分：验证和测试

1.  **设计验证:**
    *   在 Block Design 中点击 "Validate Design" (F6) 检查所有连接
    *   确保没有未连接的必需端口

2.  **综合前检查:**
    *   确认 XDC 约束文件中定义了所有 AD9434 相关的物理引脚约束
    *   检查 I/O 标准设置与 SelectIO IP 配置一致

3.  **硬件调试:**
    *   在实际硬件测试中，您可能需要调整 SelectIO IP 中的 `Input Data Delay Value`
    *   可以通过重新配置 IP (如果选择了 `Variable` 延迟类型) 或在软件中动态调整来优化数据捕获窗口

通过这种方法，您的 Verilog 代码变得非常简洁，而复杂的 I/O 处理完全由经过验证的 Xilinx IP 核处理，提高了设计的可靠性和可维护性。
