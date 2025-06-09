# 1 "E:/FPGAproject/Zynq7010Oscilloscope/platform/ps7_cortexa9_0/standalone_ps7_cortexa9_0/bsp/lop-config.dts"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "E:/FPGAproject/Zynq7010Oscilloscope/platform/ps7_cortexa9_0/standalone_ps7_cortexa9_0/bsp/lop-config.dts"

/dts-v1/;
/ {
        compatible = "system-device-tree-v1,lop";
        lops {
                lop_0 {
                        compatible = "system-device-tree-v1,lop,load";
                        load = "assists/baremetal_validate_comp_xlnx.py";
                };

                lop_1 {
                    compatible = "system-device-tree-v1,lop,assist-v1";
                    node = "/";
                    outdir = "E:/FPGAproject/Zynq7010Oscilloscope/platform/ps7_cortexa9_0/standalone_ps7_cortexa9_0/bsp";
                    id = "module,baremetal_validate_comp_xlnx";
                    options = "ps7_cortexa9_0 E:/FPGA/2025.1/Vitis/data/embeddedsw/lib/sw_services/xilrsa_v1_8/src E:/FPGAproject/Zynq7010Oscilloscope/_ide/.wsdata/.repo.yaml";
                };

        };
    };
