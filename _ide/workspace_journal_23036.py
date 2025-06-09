# 2025-06-09T20:57:45.648774700
import vitis

client = vitis.create_client()
client.set_workspace(path="Zynq7010Oscilloscope")

advanced_options = client.create_advanced_options_dict(dt_overlay="0")

platform = client.create_platform_component(name = "platform",hw_design = "$COMPONENT_LOCATION/../design_1_wrapper.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",generate_dtb = False,advanced_options = advanced_options,compiler = "gcc")

platform = client.get_component(name="platform")
status = platform.build()

comp = client.get_component(name="xgpiops_polled_example")
comp.build()

status = platform.build()

comp.build()

client.delete_component(name="platform")

client.delete_component(name="platform")

client.delete_component(name="xgpiops_polled_example")

advanced_options = client.create_advanced_options_dict(dt_overlay="0")

platform = client.create_platform_component(name = "platform",hw_design = "$COMPONENT_LOCATION/../design_1_wrapper.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",generate_dtb = False,advanced_options = advanced_options,compiler = "gcc")

status = platform.build()

domain = platform.get_domain(name="zynq_fsbl")

status = domain.remove_lib(lib_name="xilrsa")

status = domain.set_lib(lib_name="xilrsa", path="E:\FPGA\2025.1\Vitis\data\embeddedsw\lib\sw_services\xilrsa_v1_8")

status = domain.set_config(option = "lib", param = "XILFFS_read_only", value = "true", lib_name="xilffs")

status = domain.set_config(option = "lib", param = "XILFFS_enable_exfat", value = "true", lib_name="xilffs")

status = platform.build()

domain = platform.get_domain(name="standalone_ps7_cortexa9_0")

status = domain.set_lib(lib_name="xilffs", path="E:\FPGA\2025.1\Vitis\data\embeddedsw\lib\sw_services\xilffs_v5_4")

status = domain.set_lib(lib_name="xilrsa", path="E:\FPGA\2025.1\Vitis\data\embeddedsw\lib\sw_services\xilrsa_v1_8")

status = platform.build()

comp = client.create_app_component(name="zynq_fsbl",platform = "$COMPONENT_LOCATION/../platform/export/platform/platform.xpfm",domain = "standalone_ps7_cortexa9_0",template = "zynq_fsbl")

vitis.dispose()

