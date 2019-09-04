#!/bin/bash
cpu=$(</sys/class/thermal/thermal_zone0/temp)
echo "$(date) @ $(hostname)"
echo "-------------------------------------------"
echo "GPU => $(sudo /opt/vc/bin/vcgencmd measure_temp)"
echo "CPU => $((cpu/1000))'C"
