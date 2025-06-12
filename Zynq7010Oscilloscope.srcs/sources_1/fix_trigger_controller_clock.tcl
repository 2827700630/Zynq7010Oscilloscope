# Vivado TCL Script to Fix trigger_controller Clock Association
# Run this script in Vivado TCL Console

puts "Fixing trigger_controller_a_0 clock association..."

# Open the block design
open_bd_design [get_files design_1.bd]

# Refresh the trigger_controller IP to pick up the XCI changes
puts "Refreshing trigger_controller_a_0 IP..."
upgrade_bd_cells [get_bd_cells trigger_controller_a_0]

# Validate the block design
puts "Validating block design..."
validate_bd_design

# Check if there are any critical warnings about clock association
set validation_status [get_property STATUS [get_bd_designs]]
puts "Block design status: $validation_status"

# Save the block design
save_bd_design

puts "Clock association fix completed!"
puts "Please check if the error '[BD 41-967] AXI interface pin /trigger_controller_a_0/m_axis is not associated to any clock pin' is resolved."
