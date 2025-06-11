# 2025-06-10T11:28:16.043446100
import vitis

client = vitis.create_client()
client.set_workspace(path="Zynq7010Oscilloscope")

vitis.dispose()

