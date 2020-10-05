#!/bin/bash
# Test i2c expander PI4IOE5V6408
# Loops through ports 0-7 turning on LED
# https://www.diodes.com/assets/Datasheets/PI4IOE5V6408.pdf

# Registers
# 0x03 
# 0x05
# 0x07

# hex addresses from lsb to msb
ports=("0x01" "0x02" "0x04" "0x08" "0x10" "0x20" "0x40" "0x80")
inverseports=("0xfe" "0xfd" "0xfb" "0xf7" "0xef" "0xdf" "0xbf" "0x7f")

# Set ports as output
# Disable high impedance (ports are already inputs, this will sink current)
# sudo i2cset -y 1 0x43 0x07 0xff

# Trap Ctrl+C and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
   echo -e '\n'
   sudo i2cset -y 1 0x43 0x01 0x01
   echo "Resetting board. Register 0x01 set to 0x01"
   exit 1
}

# Message
echo "Blinking LED's"

# Set Port as output
sudo i2cset -y 1 0x43 0x03 0xff 

while true; do

   for j in "${inverseports[@]}"
   do
       # Disable high impedance.  Led on.
       echo "Blinking port $j"
       sudo i2cset -y 1 0x43 0x07 $j
       sleep 0.1

       # Re-enable high impedance Led off.
       sudo i2cset -y 1 0x43 0x07 $j
   done
done

# Reset i2c expander to defaults
sudo i2cset -y 1 0x43 0x01 0x01
