# ZYNQ7010 模块化设计 - Block Design 使用指南

## 项目概述

本项目将原有的ZYNQ7010 Verilog代码重构为模块化设计，使其能够在Vivado Block Design中轻松使用。重构后的设计移除了UART模块，并将DDS信号发生器的ROM实例化移至外部，以便在Block Design中连接外部ROM IP核。

## 模块结构

### 1. 顶层模块 (`adda_test_top.v`)
- **功能**: 系统顶层集成模块
- **主要特点**:
  - 集成所有子模块
  - 提供ROM接口端口供Block Design连接
  - 移除了UART相关功能
  - 支持四路按键控制

### 2. 核心功能模块

#### 2.1 按键消抖模块 (`key_debounce.v`)
- **功能**: 四路按键消抖处理
- **端口**:
  - 输入: 4个按键信号 + 25MHz时钟
  - 输出: 4个消抖后的脉冲信号

#### 2.2 DDS信号发生器 (`dds_signal_generator.v`)
- **功能**: 数字信号发生器，支持3种波形、8种频率
- **重要改动**: 
  - **移除了内部ROM实例化**
  - **添加了外部ROM接口端口**
- **ROM接口端口**:
  ```verilog
  // 正弦波ROM接口
  output wire [8:0] sine_rom_addr,    // 地址输出
  input wire [7:0] sine_rom_data,     // 数据输入
  
  // 方波ROM接口  
  output wire [8:0] square_rom_addr,  // 地址输出
  input wire [7:0] square_rom_data,   // 数据输入
  
  // 三角波ROM接口
  output wire [8:0] triangle_rom_addr, // 地址输出
  input wire [7:0] triangle_rom_data,  // 数据输入
  ```

#### 2.3 ADC数据采集模块 (`adc_data_acquisition.v`)
- **功能**: ADC数据接收、缓冲和基本处理
- **特点**: 
  - 多级同步采集，减少亚稳态
  - 数据有效性检测
  - 触发参数配置管理
  - FIFO复位控制

#### 2.4 数据抽取模块 (`data_extract.v`)
- **功能**: ADC数据抽取处理
- **特点**: 支持16种抽取比例

#### 2.5 数字触发检测模块 (`digital_trigger_detector.v`)
- **功能**: 触发检测和电平比较
- **特点**: 支持迟滞功能

#### 2.6 触发控制模块 (`trigger_controller.v`)
- **功能**: 触发状态管理和FIFO控制
- **特点**: 预触发和数据采集控制

## 在Block Design中的使用方法

### 步骤1: 添加自定义IP
1. 在Vivado中创建新的Block Design
2. 添加所有Verilog模块文件到项目中
3. 将`adda_test_top.v`添加为顶层IP核

### 步骤2: 创建ROM IP核
由于DDS模块不再包含内部ROM，需要在Block Design中添加3个ROM IP核：

1. **正弦波ROM** (建议命名: `sine_wave_rom`)
   - 深度: 512 (9位地址)
   - 宽度: 8位
   - 初始化文件: 正弦波数据

2. **方波ROM** (建议命名: `square_wave_rom`)
   - 深度: 512 (9位地址)
   - 宽度: 8位
   - 初始化文件: 方波数据

3. **三角波ROM** (建议命名: `triangle_wave_rom`)
   - 深度: 512 (9位地址)
   - 宽度: 8位
   - 初始化文件: 三角波数据

### 步骤3: 连接ROM接口
将顶层模块的ROM接口端口与相应的ROM IP核连接：

```
adda_test_top.sine_rom_addr -> sine_wave_rom.addra
adda_test_top.sine_rom_data <- sine_wave_rom.douta

adda_test_top.square_rom_addr -> square_wave_rom.addra  
adda_test_top.square_rom_data <- square_wave_rom.douta

adda_test_top.triangle_rom_addr -> triangle_wave_rom.addra
adda_test_top.triangle_rom_data <- triangle_wave_rom.douta
```

### 步骤4: 时钟连接
- 为所有ROM IP核连接时钟信号（建议使用50MHz DAC时钟）
- 确保时钟域正确对应

### 步骤5: 添加其他IP核
根据需要添加其他IP核：
- PLL/MMCM用于时钟生成
- FIFO IP核用于数据缓存
- GPIO IP核用于按键和LED控制

## 主要改进

### 1. 模块化设计
- 每个功能独立成模块
- 便于在Block Design中复用
- 提高了代码可维护性

### 2. 中文注释和改进的变量命名
- 所有信号使用描述性命名
- 添加了详细的中文注释
- 提高了代码可读性

### 3. ROM外部化
- DDS模块不再包含内部ROM实例
- 支持在Block Design中灵活配置ROM
- 便于更换不同的波形数据

### 4. 移除UART功能
- 简化了系统设计
- 更适合Block Design环境
- 减少了资源占用

## 波形数据格式

ROM初始化文件应包含512个8位数据点：
- **正弦波**: 0-255范围的正弦波采样数据
- **方波**: 0和255的方波数据
- **三角波**: 0-255线性递增递减的三角波数据

## 测试建议

1. 首先测试按键消抖功能
2. 验证DDS信号发生器的频率和波形切换
3. 测试触发检测和数据抽取功能
4. 验证FIFO数据流

## 注意事项

1. 确保所有时钟域正确连接
2. ROM数据需要预先准备并加载到IP核中
3. 注意信号的时序关系，特别是ROM读取延迟
4. 建议在ILA中添加关键信号进行调试

## 文件清单

- `adda_test_top.v` - 顶层集成模块
- `key_debounce.v` - 按键消抖模块
- `dds_signal_generator.v` - DDS信号发生器（无ROM版本）
- `adc_data_acquisition.v` - ADC数据采集模块
- `data_extract.v` - 数据抽取模块
- `digital_trigger_detector.v` - 数字触发检测模块
- `trigger_controller.v` - 触发控制模块
