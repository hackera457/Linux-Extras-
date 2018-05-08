#!/bin/shPIDS=`ps ax | grep sirq-hrtimer | grep -v grep | sed -e «s/^ *//» -e «s/ .*$//»`
for p in $PIDS; do
chrt -f -p 99 $p
done
PIDS=`ps ax | grep sirq-timer | grep -v grep | sed -e «s/^ *//» -e «s/ .*$//»`
for p in $PIDS; do
chrt -f -p 51 $p
done

PIDS=`pidof srcds_linux`
for p in $PIDS; do
chrt -f -p 98 $p
done

PIDS=`pidof srcds_i686`
for p in $PIDS; do
chrt -f -p 98 $p
done

PIDS=`pidof srcds_i486`
for p in $PIDS; do
chrt -f -p 98 $p
done

PIDS=`pidof srcds_amd`
for p in $PIDS; do
chrt -f -p 98 $p
done

PIDS=`pidof hlds_i686`
for p in $PIDS; do
chrt -f -p 98 $p
done

PIDS=`pidof hlds_i486`
for p in $PIDS; do
chrt -f -p 98 $p
done

PIDS=`pidof hlds_amd`
for p in $PIDS; do
chrt -f -p 98 $p
done
