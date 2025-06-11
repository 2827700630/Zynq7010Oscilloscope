# 2025-06-10T10:55:36.911738100
import vitis

client = vitis.create_client()
client.set_workspace(path="Zynq7010Oscilloscope")

platform = client.get_component(name="platform")
status = platform.update_desc(desc="")

vitis.dispose()

