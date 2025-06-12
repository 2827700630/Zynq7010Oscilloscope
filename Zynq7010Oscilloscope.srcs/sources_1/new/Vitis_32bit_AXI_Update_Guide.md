# Vitis 软件更新指南 - 32位AXI架构适配

## 概述

本文档描述了在将触发控制器从8位修改为32位AXI架构后，Vitis软件端需要进行的相应修改。

## 主要修改内容

### 1. 数据长度定义修改

```c
// 修改前 (8位架构)
#define MAX_PKT_LEN  (2048 * 1)  // 2048个8位字 = 2048字节

// 修改后 (32位架构)
#define MAX_PKT_LEN  (512 * 4)   // 512个32位字 = 2048字节
```

### 2. 数据类型声明

```c
// 修改前 (8位架构)
u8 RxBuffer[MAX_PKT_LEN];  // 2048个字节

// 修改后 (32位架构) - 可以选择以下方式之一：
// 方式1: 保持字节数组
u8 RxBuffer[MAX_PKT_LEN];  // 2048个字节

// 方式2: 使用32位数组 (推荐，便于数据解析)
u32 RxBuffer32[512];       // 512个32位字
u8 *RxBuffer = (u8*)RxBuffer32;  // 字节访问指针
```

### 3. 数据解析修改

由于现在4个8位ADC样本被打包成1个32位字，需要修改数据解析逻辑：

```c
// 解析32位打包数据的函数
void parse_adc_data(u32 *packed_data, int word_count, u8 *adc_samples) {
    for (int i = 0; i < word_count; i++) {
        u32 packed_word = packed_data[i];
        
        // 解包4个8位ADC样本
        adc_samples[i*4 + 0] = (u8)(packed_word & 0xFF);         // 第1个样本 (LSB)
        adc_samples[i*4 + 1] = (u8)((packed_word >> 8) & 0xFF);  // 第2个样本
        adc_samples[i*4 + 2] = (u8)((packed_word >> 16) & 0xFF); // 第3个样本
        adc_samples[i*4 + 3] = (u8)((packed_word >> 24) & 0xFF); // 第4个样本 (MSB)
    }
}

// 使用示例
void process_received_data() {
    // 接收到的数据在 RxBuffer32 中 (512个32位字)
    u8 adc_samples[2048];  // 解包后的2048个8位ADC样本
    
    parse_adc_data(RxBuffer32, 512, adc_samples);
    
    // 现在可以正常处理 adc_samples 数组中的数据
    for (int i = 0; i < 2048; i++) {
        printf("%02X ", adc_samples[i]);
        if ((i + 1) % 16 == 0) {
            printf("\r\n");
        }
    }
}
```

### 4. DMA传输配置修改

```c
// DMA传输长度计算
// 修改前 (8位架构)
int transfer_length = 2048;  // 2048个字节

// 修改后 (32位架构)
int transfer_length = 2048;  // 依然是2048个字节，但现在是512个32位字

// DMA配置保持不变，因为总字节数相同
Status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)RX_BUFFER_BASE, 
                                transfer_length, XAXIDMA_DEVICE_TO_DMA);
```

### 5. 完整的数据接收和处理示例

```c
#include "xaxidma.h"
#include "xparameters.h"
#include "xil_cache.h"

#define DMA_DEV_ID        XPAR_AXIDMA_0_DEVICE_ID
#define RX_BUFFER_BASE    0x01000000
#define WORDS_32BIT       512      // 32位字数量
#define MAX_PKT_LEN       (WORDS_32BIT * 4)  // 2048字节

XAxiDma AxiDma;
u32 RxBuffer32[WORDS_32BIT] __attribute__((aligned(64)));  // 缓存行对齐

int receive_and_process_data() {
    int Status;
    
    // 使缓存无效
    Xil_DCacheInvalidateRange((UINTPTR)RxBuffer32, MAX_PKT_LEN);
    
    // 启动DMA传输
    Status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)RxBuffer32, 
                                    MAX_PKT_LEN, XAXIDMA_DEVICE_TO_DMA);
    if (Status != XST_SUCCESS) {
        xil_printf("DMA transfer failed\r\n");
        return XST_FAILURE;
    }
    
    // 等待传输完成
    while (XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA)) {
        /* 等待 */
    }
    
    // 再次使缓存无效以读取DMA写入的数据
    Xil_DCacheInvalidateRange((UINTPTR)RxBuffer32, MAX_PKT_LEN);
    
    // 处理接收到的数据
    xil_printf("Received %d 32-bit words (2048 ADC samples):\r\n", WORDS_32BIT);
    
    // 方法1: 直接以32位字形式显示
    for (int i = 0; i < WORDS_32BIT; i++) {
        xil_printf("Word[%d]: 0x%08X\r\n", i, RxBuffer32[i]);
        if (i >= 10) break;  // 只显示前10个字作为示例
    }
    
    // 方法2: 解包为单独的ADC样本
    u8 *adc_samples = (u8*)RxBuffer32;
    xil_printf("\nFirst 16 ADC samples:\r\n");
    for (int i = 0; i < 16; i++) {
        xil_printf("%02X ", adc_samples[i]);
    }
    xil_printf("\r\n");
    
    return XST_SUCCESS;
}
```

### 6. 性能优化建议

1. **内存对齐**: 确保DMA缓冲区按照缓存行大小对齐（通常是64字节）。

2. **缓存管理**: 
   ```c
   // 传输前使缓存无效
   Xil_DCacheInvalidateRange((UINTPTR)buffer, size);
   
   // 传输后再次使缓存无效（如果使用轮询方式）
   Xil_DCacheInvalidateRange((UINTPTR)buffer, size);
   ```

3. **批量处理**: 32位架构提高了传输效率，可以考虑增加缓冲区大小以支持更大的数据包。

## 调试建议

1. **验证数据打包**: 首先验证trigger_controller正确地将4个8位样本打包到32位字中。

2. **DMA状态检查**: 
   ```c
   // 检查DMA错误状态
   u32 status = XAxiDma_ReadReg(AxiDma.RegBase, XAXIDMA_SR_OFFSET);
   if (status & XAXIDMA_ERR_ALL_MASK) {
       xil_printf("DMA Error: 0x%08X\r\n", status);
   }
   ```

3. **ILA调试**: 在硬件中使用ILA监控AXI4-Stream信号，确保数据正确传输。

## 总结

32位AXI架构的主要优势：
- 提高了总线利用率（每次传输32位而不是8位）
- 减少了AXI事务数量
- 更好地匹配标准AXI总线宽度

软件端的修改相对简单，主要涉及数据解析逻辑的调整。总的数据量和传输时间保持不变，但系统的整体效率得到了提升。
