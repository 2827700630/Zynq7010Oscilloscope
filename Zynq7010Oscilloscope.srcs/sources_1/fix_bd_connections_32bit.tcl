# TCL脚本：修复Block Design中的32位数据连接问题
# 用于解决FIFO连接、复位信号和数据宽度不匹配问题

puts "开始修复Block Design连接..."

# 打开Block Design
open_bd_design [get_files design_1.bd]

# 1. 修复FIFO复位连接
# FIFO的s_aresetn是低电平复位(ACTIVE_LOW)，当前硬编码为1'b0使FIFO永久复位
# 需要连接到处理器系统的复位释放信号(高电平有效)
puts "修复FIFO复位连接..."
disconnect_bd_net /fifo_generator_1/s_aresetn
connect_bd_net [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins fifo_generator_1/s_aresetn]

# 2. 修复data_extract的fifo_write_ready连接
puts "连接fifo_write_ready到trigger_ready_status..."
disconnect_bd_net /data_extract_0/fifo_write_ready
connect_bd_net [get_bd_pins trigger_controller_a_0/trigger_ready_status] [get_bd_pins data_extract_0/fifo_write_ready]

# 3. 重新配置FIFO Generator以支持32位数据
puts "重新配置FIFO Generator为32位数据宽度..."
set_property -dict [list \
  CONFIG.Input_Data_Width {32} \
  CONFIG.Output_Data_Width {32} \
] [get_bd_cells fifo_generator_1]

# 4. 断开旧的FIFO输入连接并重新连接（移除零填充）
puts "修复FIFO数据连接，移除零填充..."
disconnect_bd_net /fifo_generator_1/s_axis_tdata
# 直接连接32位数据，无需填充
connect_bd_net [get_bd_pins trigger_controller_a_0/m_axis_tdata] [get_bd_pins fifo_generator_1/s_axis_tdata]

# 5. 添加处理器系统复位IP以提供更好的复位管理
puts "添加处理器系统复位IP..."
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins proc_sys_reset_0/ext_reset_in]

# 为ADC时钟域添加另一个复位IP
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1
connect_bd_net [get_bd_pins clk_wiz_0/AD9434] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins proc_sys_reset_1/ext_reset_in]

# 使用专用复位信号替换硬编码复位
disconnect_bd_net /trigger_controller_a_0/sys_rst_n
connect_bd_net [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins trigger_controller_a_0/sys_rst_n]

# 6. 验证并更新地址分配
puts "更新地址分配..."
assign_bd_address

# 7. 验证设计
puts "验证Block Design..."
validate_bd_design

# 保存设计
puts "保存Block Design..."
save_bd_design

puts "Block Design修复完成！"
puts ""
puts "修复内容总结："
puts "1. FIFO复位信号从硬编码1'b0改为连接processing_system7_0/FCLK_RESET0_N"
puts "2. data_extract_0/fifo_write_ready连接到trigger_controller_a_0/trigger_ready_status"
puts "3. FIFO Generator重新配置为32位数据宽度"
puts "4. 移除FIFO输入的零填充，直接连接32位数据"
puts "5. 添加处理器系统复位IP以改善复位管理"
puts "6. trigger_controller复位信号连接到专用复位输出"
puts ""
puts "下一步："
puts "1. 重新生成比特流"
puts "2. 验证时序约束"
puts "3. 更新Vitis软件端32位数据处理逻辑"
