#!/bin/bash

PIDS=`ps ax | grep sirq-hrtimer | grep -v grep | sed -e «s/^ *//» -e «s/ .*$//»`
for p in $PIDS; do
chrt -f -p 99 $p
done
PIDS=`ps ax | grep sirq-timer | grep -v grep | sed -e «s/^ *//» -e «s/ .*$//»`
for p in $PIDS; do
chrt -f -p 51 $p
done

PIDS=`pidof ./hlds_linux`
for p in $PIDS; do
chrt -f -p 98 $p
done
