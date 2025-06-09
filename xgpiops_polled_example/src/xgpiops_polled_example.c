/***************************** Include Files ********************************/

#include "xparameters.h"
#include "xgpiops.h"
#include "xstatus.h"
#include "xplatform_info.h"
#include <xil_printf.h>

/************************** Constant Definitions ****************************/

#ifndef SDT
#ifndef GPIO_DEVICE_ID
#define GPIO_DEVICE_ID		XPAR_XGPIOPS_0_DEVICE_ID
#endif
#else
#define	XGPIOPS_BASEADDR	XPAR_XGPIOPS_0_BASEADDR
#endif

/* 你开发板上LED连接的MIO引脚 */
#define LED_MIO0_PIN  0      // MIO0 上的 LED
#define LED_MIO13_PIN 13     // MIO13 上的 LED

/*
 * 用于产生大约0.5秒软件延时的计数值。
 * 这个值高度依赖于Zynq PS的时钟速度和编译器优化。
 * 你很可能需要通过实验来调整这个值以获得实际的0.5秒延时。
 * 例如，对于667MHz的时钟，一个粗略的起点可能是 (667,000,000 / 2 / ~10)，
 * 其中10是每次循环迭代大约消耗的时钟周期数（非常粗略的估计）。
 */
#define HALF_SECOND_DELAY_COUNT  33000000  // 占位符 - 需要仔细调试校准!

#define printf			xil_printf	/* 更小体积的 printf */

/**************************** Type Definitions ******************************/

/***************** Macros (Inline Functions) Definitions *******************/

/************************** Function Prototypes ****************************/

static void DelayHalfSecond(void); // 新增延时函数声明
static int GpioOutputExample(void);
static int GpioInputExample(u32 *DataRead);
#ifndef SDT
int GpioPolledExample(u16 DeviceId, u32 *DataRead);
#else
int GpioPolledExample(UINTPTR BaseAddress, u32 *DataRead);
#endif

/************************** Variable Definitions **************************/
static u32 Input_Pin; /* 用于原始示例逻辑的开关按钮引脚 */
static u32 Output_Pin; /* 用于原始示例逻辑的LED引脚, 在MIO0/MIO13的控制中不会直接使用 */

XGpioPs Gpio;	/* GPIO设备的驱动实例 */

/*****************************************************************************/
/**
*
* 主函数，调用示例。
*
* @return
*		- XST_SUCCESS 如果示例成功完成。
*		- XST_FAILURE 如果示例失败。
*
* @note		None
*
******************************************************************************/
int main(void)
{
	int Status;
	u32 InputData; // 用于示例中的输入部分

	printf("GPIO轮询模式示例 (已修改为MIO0和MIO13 LED交替闪烁)\r\n");
#ifndef SDT
	Status = GpioPolledExample(GPIO_DEVICE_ID, &InputData);
#else
	Status = GpioPolledExample(XGPIOPS_BASEADDR, &InputData);
#endif
	if (Status != XST_SUCCESS) {
		printf("GPIO轮询模式示例测试失败\r\n");
		return XST_FAILURE;
	}

    /* 由于 GpioOutputExample 中包含无限循环, 以下代码通常不会执行到 */
	printf("成功运行GPIO轮询模式示例测试 (已修改)\r\n");
	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* 此函数用于演示如何使用GPIO驱动程序来点亮/熄灭LED以及使用引脚API读取输入。
* 此版本已修改为使MIO0和MIO13上的LED交替闪烁。
*
* @param	DeviceId 是来自 xparameters.h 的 XPAR_<GPIO_instance>_DEVICE_ID 值
*           (对于SDT流程, 使用BaseAddress)。
* @param	DataRead 是一个指针，用于返回从GPIO输入读取的数据 (由GpioInputExample使用)。
*
* @return
*		- XST_SUCCESS 如果成功。
*		- XST_FAILURE 如果失败。
*
******************************************************************************/
#ifndef SDT
int GpioPolledExample(u16 DeviceId, u32 *DataRead)
#else
int GpioPolledExample(UINTPTR BaseAddress, u32 *DataRead)
#endif
{
	int Status;
	XGpioPs_Config *ConfigPtr;
	int Type_of_board;

	/* 初始化GPIO驱动 */
#ifndef SDT
	ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
#else
	ConfigPtr = XGpioPs_LookupConfig(BaseAddress);
#endif
    if (ConfigPtr == NULL) {
        printf("GPIO LookupConfig 失败\r\n");
        return XST_FAILURE;
    }

	Type_of_board = XGetPlatform_Info();
	switch (Type_of_board) {
		case XPLAT_ZYNQ_ULTRA_MP:
			Input_Pin = 22;
			Output_Pin = 23;
			break;
		case XPLAT_ZYNQ: // 你的情况很可能属于这里
			Input_Pin = 14;  // zc702的默认输入引脚, 如果使用输入功能请调整
			Output_Pin = 10; // zc702的默认输出引脚, 在我们的LED逻辑中会被忽略
			break;
#ifdef versal
		case XPLAT_VERSAL:
			Gpio.PmcGpio =  1;
			Input_Pin    = 56;
			Output_Pin   = 52;
			break;
#endif
        default:
            printf("未针对默认引脚特别处理此板卡类型，LED将直接使用MIO0/MIO13。\r\n");
            // 对于其他开发板或XGetPlatform_Info()不匹配的情况，
            // 我们直接使用MIO0和MIO13。
            break;
	}

	Status = XGpioPs_CfgInitialize(&Gpio, ConfigPtr,
				       ConfigPtr->BaseAddr);
	if (Status != XST_SUCCESS) {
        printf("GPIO CfgInitialize 失败\r\n");
		return XST_FAILURE;
	}

	/* 运行输出示例 (已修改为控制MIO0和MIO13并使其交替闪烁) */
	Status = GpioOutputExample();
	if (Status != XST_SUCCESS) { // 实际上，如果GpioOutputExample失败，它内部可能已返回
        printf("GpioOutputExample 失败\r\n");
		return XST_FAILURE;
	}

    /* 由于GpioOutputExample中包含无限循环，以下代码通常不会执行 */
	Status = GpioInputExample(DataRead);
	if (Status != XST_SUCCESS) {
        printf("GpioInputExample 失败\r\n");
		return XST_FAILURE;
	}

	return XST_SUCCESS; // 通常不会执行到这里
}

/****************************************************************MIO0****************************/
/**
*
* 软件延时函数，大约延时0.5秒。
* **重要提示：** `HALF_SECOND_DELAY_COUNT` 的值需要根据你的具体硬件和
* 编译器进行精确校准才能获得准确的0.5秒延时。
*
* @param	None.
*
* @return	None.
*
* @note		这是一个阻塞式延时。
*
*********************************************************************************************/
static void DelayHalfSecond(void)
{
    volatile u32 DelayCount; // 使用 volatile 防止编译器优化掉循环
    for (DelayCount = 0; DelayCount < HALF_SECOND_DELAY_COUNT; DelayCount++);
}

/*****************************************************************************/
/**
*
* 此函数修改为使MIO0和MIO13上的LED以约1秒周期交替闪烁。
*
* @param	None.
*
* @return	此函数包含无限循环，正常情况下不会返回。
*           如果发生错误则可能提前返回 XST_FAILURE。
*
* @note		None.
*
****************************************************************************/
static int GpioOutputExample(void)
{
	u32 Led0_State = 1; // 初始状态：MIO0亮, MIO13灭

	/*
	 * 将LED_MIO0_PIN设置为输出方向，并使能输出。
	 */
	XGpioPs_SetDirectionPin(&Gpio, LED_MIO0_PIN, 1);    // 1 代表输出
	XGpioPs_SetOutputEnablePin(&Gpio, LED_MIO0_PIN, 1); // 使能输出

	/*
	 * 将LED_MIO13_PIN设置为输出方向，并使能输出。
	 */
	XGpioPs_SetDirectionPin(&Gpio, LED_MIO13_PIN, 1);   // 1 代表输出
	XGpioPs_SetOutputEnablePin(&Gpio, LED_MIO13_PIN, 1); // 使能输出

	printf("开始 LED 交替闪烁 (周期约1秒)...\r\n");
	printf("控制引脚: MIO0 (Pin %d), MIO13 (Pin %d)\r\n", LED_MIO0_PIN, LED_MIO13_PIN);

	while (1) // 无限循环以实现持续闪烁
	{
		// 设置 MIO0 为当前 Led0_State 状态, MIO13 为其相反状态
		XGpioPs_WritePin(&Gpio, LED_MIO0_PIN, Led0_State);
		XGpioPs_WritePin(&Gpio, LED_MIO13_PIN, !Led0_State);

		if (Led0_State) {
			// 为了减少串口输出对定时的影响，可以考虑在调试完成后注释掉循环内的printf
			// printf("MIO0: ON, MIO13: OFF\r\n");
		} else {
			// printf("MIO0: OFF, MIO13: ON\r\n");
		}

		DelayHalfSecond(); // 延时约0.5秒

		Led0_State = !Led0_State; // 切换状态，为下一次迭代做准备
	}

	// 由于上面的while(1)是无限循环，此处的return语句实际上不会被执行到。
	// return XST_SUCCESS;
}

/******************************************************************************/
/**
*
* 此函数用于测试GPIO驱动/设备，将GPIO配置为输入。
* (原始示例函数 - 包含对引脚编号的修正检查)
*
* @param	DataRead 是一个指针，用于返回从GPIO输入读取的数据。
*
* @return	- XST_SUCCESS 如果成功。
*		- XST_FAILURE 如果失败。
*
* @note		None.
*
******************************************************************************/
static int GpioInputExample(u32 *DataRead)
{
    /*
     * 如果使用此函数，请确保Input_Pin已为你的开发板正确设置。
     * GpioPolledExample函数会尝试根据开发板类型设置Input_Pin。
     * 如果Input_Pin未连接或未被驱动，DataRead的值可能不可预知。
     * 对于Zynq-7000, MIO引脚通常编号为0-53。
     */
	if (Input_Pin > 53) { // Zynq-7000的MIO引脚范围是0-53
		printf("警告: Input_Pin (%lu) 超出 Zynq-7000 MIO 有效范围 (0-53)。跳过输入读取。\r\n", Input_Pin);
		*DataRead = 0xFFFFFFFF; // 表示无效读取或默认值
		return XST_SUCCESS;
	}

	/* 将指定引脚的方向设置为输入 */
	XGpioPs_SetDirectionPin(&Gpio, Input_Pin, 0x0); // 0 代表输入

	/* 读取数据状态以便验证 */
	*DataRead = XGpioPs_ReadPin(&Gpio, Input_Pin);
    printf("从 Input_Pin %lu 读取到数据 0x%X\r\n", Input_Pin, (unsigned int)*DataRead);

	return XST_SUCCESS;
}