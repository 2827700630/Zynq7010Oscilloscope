# AD9434 简化方案集成指南

本文档说明如何在 Vivado Block Design 中集成 AD9434 模块。
新增：本指南现在描述一个方案，其中 FPGA 为 AD9434 提供 100MHz 的采样时钟。

## 方案概述: FPGA 提供 100MHz 采样时钟

**架构：**
```
                                     ┌───────────────────────────┐
                                     │   AD9434 (ADC Chip)       │
                                     │      CLK+/-  <─────────── FPGA 100MHz Diff Clock Output
(System Clock e.g. 50MHz)            │      DCO+/-  ───────────┐
    │                                │      Data+/- ───────────┼──┐
    ▼                                └───────────────────────────┘  │
┌───────────────────────┐                                          │  │
│ clk_wiz_0 (or new)    │                                          ▼  ▼
│ (Input: System Clock) │<──┐                               ┌───────────────┐
│ - Output: 100MHz Diff ├─►┴───────────────────────────────►│ clk_wiz_1     │(Input: 100MHz DCO from ADC)
│   (to AD9434 CLK+/-)  │   │ System Reset                   │(Process DCO)  │
│ - Other clocks...     │   │                                │ - Output:     │
└───────────────────────┘   │                                │   100MHz SerClk P/N (to SelectIO)
                            │                                │   locked      │
                            └───────────────
