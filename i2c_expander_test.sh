#!/bin/bash
# Test i2c expander PI4IOE5V6408
# Loops through ports 0-7 turning on LED

ports=("0x01" "0x02" "0x04" "0x08" "0x10" "0x20" "0x40" "0x80")
inverseports=("0xfe" "0xfd" "0xfb" "0xf7" "0xef" "0xdf" "0xbf" "0x7f")

# Set ports as output
# Disable high impedance (ports are already inputs, this will sink current)
#sudo i2cset -y 1 0x43 0x07 0xff

# loop through array
for i in "${ports[@]}"
do
   echo "Toggling LED on port $i"

   # Set Port as output
   sudo i2cset -y 1 0x43 0x03 $i

   for j in "${inverseports[@]}"
   do
       # Disable high impedance.  Led on.
       sudo i2cset -y 1 0x43 0x07 $j
       sleep 1

       # Re-enable high impedance Led off.
       sudo i2cset -y 1 0x43 0x07 $j
   done

done

# Reset i2c expander to defaults
sudo i2cset -y 1 0x43 0x01 0x01
