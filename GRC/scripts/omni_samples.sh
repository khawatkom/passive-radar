#!/bin/bash

usage="$(basename "$0") [-h] [-g gain] -n name

Program to take samples between 70 and 390 MHz in increments of 20 MHz using the omnidirectional antenna.
Updated 26 Jul 2016.

where: 
    -h|--help              show this help text
    -g|--gain     (=20)    set the gain of the receiver
    -r|--rate     (=16e6)  set the sampling rate of the receiver
    -d|--duration (=0.2)   set the duration (seconds) during which to take samples
    -n|--name              set the name of the folder and archive in which samples will be saved"

while [[ $# -gt 0 ]] 
do
key="$1"
case $key in
    -n|--name)
    NAME="$2"
    shift
    ;;
    -g|--gain)
    GAIN="$2"
    shift
    ;;
   -r|--rate)
    RATE="$2"
    shift
    ;;
    -d|--duration)
    DUR="$2"
    shift
    ;;
    -h|--help)
    echo "$usage"
    exit
    ;;
  esac
  shift
done

NAME=${NAME:-"NA"}
if [ "$NAME" == "NA" ]; then
    echo "Please input name (-n)"
    exit 0
fi

NAME+="_omni"

GAIN=${GAIN:-20}
RATE=${RATE:-16000000}
DUR=${DUR:-0.2}

mkdir ../samples/$NAME

# cage elements
FREQMHZ=70      # starting
FREQMHZMAX=390  # ending     400
FREQMHZSTEP=20  # step

~/grc/applications/take_samples/build/take_samples --file ~/grc/samples/$NAME/ --gain $GAIN --start $FREQMHZ --end $FREQMHZMAX --step $FREQMHZSTEP --rate $RATE --duration $DUR
#make archive and clean up
ARCHIVENAME=$NAME
ARCHIVENAME+=".tar.xz"

cd ~/grc/samples

echo "Compressing files..."
#tar -cf ~/$ARCHIVENAME $NAME/*
tar -cf /media/usb0/$ARCHIVENAME $NAME/*
rm -r ~/grc/samples/$NAME

cd ~/grc/scripts
echo "Done!"
