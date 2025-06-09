# 2025-06-09T21:22:13.562284100
import vitis

client = vitis.create_client()
client.set_workspace(path="Zynq7010Oscilloscope")

platform = client.get_component(name="platform")
status = platform.build()

comp = client.get_component(name="zynq_fsbl")
comp.build()

status = platform.build()

status = platform.build()

comp = client.get_component(name="xgpiops_polled_example")
comp.build()

client.delete_component(name="zynq_fsbl")

client.delete_component(name="componentName")

status = platform.build()

comp.build()

comp = client.create_app_component(name="zynq_fsbl",platform = "$COMPONENT_LOCATION/../platform/export/platform/platform.xpfm",domain = "standalone_ps7_cortexa9_0",template = "zynq_fsbl")

status = platform.build()

comp = client.get_component(name="zynq_fsbl")
comp.build()

client.delete_component(name="zynq_fsbl")

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../design_1_wrapper.xsa")

status = platform.build()

comp = client.get_component(name="xgpiops_polled_example")
comp.build()

