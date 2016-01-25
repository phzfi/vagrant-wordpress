#!/bin/bash
echo "Please provide your sudo -password if asked for...."
TEST=`cat /etc/hosts | grep "192.168.66.66 wordpress.local" | wc -l`
if [ $TEST -eq 0 ]; then
    sudo -- sh -c 'echo "192.168.66.66 wordpress.local" >> /etc/hosts'
fi
