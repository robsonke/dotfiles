#!/usr/bin/env bash
# Reset routing table on OSX

# display current routing table
echo "********** BEFORE ****************************************"
netstat -r
echo "**********************************************************"

for i in {0..4}; do
  sudo route -n flush # several times
done

echo "********** AFTER *****************************************"
netstat -r
echo "**********************************************************"

echo "Bringing interface down..."
sudo ifconfig en1 down
sleep 1
echo "Bringing interface back up..."
sudo ifconfig en1 up
sleep 1

echo "********** FINALLY ***************************************"
netstat -r
echo "**********************************************************"