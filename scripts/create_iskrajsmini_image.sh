#!/bin/bash

# This file is part of Espruino, a JavaScript interpreter for Microcontrollers
#
# Copyright (C) 2013 Gordon Williams <gw@pur3.co.uk>
# Copyright (C) 2014 Victor Nakoryakov <victor@amperka.ru>
# Copyright (C) 2022 Roman Samusevich (kekcheburec) for Amperka Robots LLC
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# ----------------------------------------------------------------------------------------
# Create UF2 file with Espruino
# ----------------------------------------------------------------------------------------

cd `dirname $0` # scripts
cd ..            # main dir
BASEDIR=`pwd`

BOARDNAME=ISKRAJSMINI
ESPRUINOFILE=`python scripts/get_board_info.py $BOARDNAME "common.get_board_binary_name(board)"`
IMGFILE=espruino_iskrajs_mini.uf2
rm -f $ESPRUINOFILE $BOOTLOADERFILE $IMGFILE

export BOARD=ISKRAJSMINI
# export DEBUG=1
export RELEASE=1

make clean
make || { echo 'Build failed (espruino)' ; exit 1; }

echo Create UF2 file
echo ---------------------
./scripts/uf2conv.py --convert --base 0x08008000 --family STM32F4 bin/$ESPRUINOFILE --output bin/$IMGFILE  || { echo 'Build failed (uf2)' ; exit 1; }

echo ---------------------
echo Finished!
echo ---------------------

