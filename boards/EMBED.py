#!/bin/false
# This file is part of Espruino, a JavaScript interpreter for Microcontrollers
#
# Copyright (C) 2013 Gordon Williams <gw@pur3.co.uk>
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# ----------------------------------------------------------------------------------------
# This file contains information for a specific board - the available pins, and where LEDs,
# Buttons, and other in-built peripherals are. It is used to build documentation as well
# as various source and header files for Espruino.
#
# The EMBED target allows us to build Espruino into a single, embeddable C file for use
# in other projects. It doesn't contain any of the hardware access code, just the basic
# JS interpreter.
# ----------------------------------------------------------------------------------------

import pinutils;
info = {
 'name' : "Embedded Espruino",
 'variables' :  16000, # this forces 14 byte variables
 'binary_name' : 'espruino_embedded.c',
 'build' : {
   'libraries' : [],
   'makefile' : [
     'ESPR_EMBED=1',
     'USE_DEBUGGER=0',
     'DEFINES+=-DUSE_CALLFUNCTION_HACK', # for now, just ensure we can be properly multiplatform
     'DEFINES+=-DJSVAR_MALLOC'
   ]
 }
};
chip = {
  'part' : "EMBED", 
  'family' : "EMBED",
  'package' : "",
  'ram' : 0,
  'flash' : 0, # size of file used to fake flash memory (kb)
  'speed' : -1,
  'usart' : 6,
  'spi' : 3,
  'i2c' : 3,
  'adc' : 0,
  'dac' : 0,
};

devices = {
};

def get_pins():
  pins = pinutils.generate_pins(0,32) # FIXME - no pins needed
  # just fake pins D0 .. D32
  return pins
