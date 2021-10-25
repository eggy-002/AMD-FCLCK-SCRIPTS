#!/bin/bash

SCRIPTDEST=/opt/upp_script
HIVESCRIPT=/hive/bin/hive
UPPSCRIPT=amd_fclock_update.sh

HIVELINE="Applying AMD OC"
HIVEUPDATE="\\\t\techo2 \"> Applying F state clk\"\n\t\tbash ${SCRIPTDEST}/${UPPSCRIPT}"

echo "Installing Python3"
apt-get install libgtk-3-dev build-essential python3 python3-pip -y -q

echo "Install UPP"
yes | pip3 install upp

echo "Installing script at $SCRIPTDEST"

if [ ! -d $SCRIPTDEST ]; then
    echo "Creating directory $SCRIPTDEST"
    mkdir $SCRIPTDEST
fi

echo "Adding upp script file"
cp $UPPSCRIPT $SCRIPTDEST

if [ "$?" -ne "0" ]; then
    echo "Failed to apply AMD fclock update!"
    exit 1
fi

echo "Test next step"

if grep -qwF "$UPPSCRIPT" "$HIVESCRIPT"; then
    echo "Hive file already updated!"
else
    echo "Updating Hive file to include upp script"
    sed -i "/$HIVELINE/i $HIVEUPDATE" $HIVESCRIPT
fi

if [ "$?" -eq "0" ]; then
    echo "AMD fclock update completed successfully!"
    echo "Please reboot to complete update!"
else
    echo "Failed to apply AMD fclock update!"
    exit 1
fi
