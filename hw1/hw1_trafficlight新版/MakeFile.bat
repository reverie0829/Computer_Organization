iverilog -o traffic_light.vvp traffic_light.v traffic_light_tb.v 
vvp traffic_light.vvp
gtkwave.exe .\traffic_light.VCD