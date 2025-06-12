# 2025-06-12T16:00:31.268654400
import vitis

client = vitis.create_client()
client.set_workspace(path="Zynq7010Oscilloscope")

platform = client.get_component(name="platform")
status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../design_1_wrapper.xsa")

status = platform.build()

comp = client.get_component(name="xgpiops_polled_example")
comp.build()

vitis.dispose()

