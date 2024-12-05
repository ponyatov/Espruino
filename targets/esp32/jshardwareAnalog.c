/*
 * This file is designed to support Analog functions in Espruino,
 * a JavaScript interpreter for Microcontrollers designed by Gordon Williams
 *
 * Copyright (C) 2016 by Juergen Marsch
 *
 * This Source Code Form is subject to the terms of the Mozilla Publici
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * ----------------------------------------------------------------------------
 * This file is designed to be parsed during the build process
 *
 * Contains ESP32 board specific functions.
 * ----------------------------------------------------------------------------
 */
#include "jshardwareAnalog.h"
#include "driver/adc.h"
#if CONFIG_IDF_TARGET_ESP32
	#include "driver/dac.h"
#elif CONFIG_IDF_TARGET_ESP32C3
	typedef enum { DAC_CHAN_0=0 , DAC_CHAN_1=1 } dac_channel_t;
#elif CONFIG_IDF_TARGET_ESP32S3
	typedef enum { DAC_CHAN_0=0 , DAC_CHAN_1=1 } dac_channel_t;
#else
	#error Not an ESP32 or ESP32-S3
#endif

#include <stdio.h>

#define adc_channel_max 8

adc_atten_t adc_channel[8];

adc1_channel_t pinToAdcChannel(Pin pin){
  adc1_channel_t channel;
  if (pinInfo[pin].analog == JSH_ANALOG_NONE)
    return -1;
  switch(pinInfo[pin].analog & JSH_MASK_ANALOG_CH){
    case 0: channel = ADC1_CHANNEL_0; break;
    case 1: channel = ADC1_CHANNEL_1; break;
    case 2: channel = ADC1_CHANNEL_2; break;
    case 3: channel = ADC1_CHANNEL_3; break;
    case 4: channel = ADC1_CHANNEL_4; break;
#ifndef CONFIG_IDF_TARGET_ESP32C3
    case 5: channel = ADC1_CHANNEL_5; break;
    case 6: channel = ADC1_CHANNEL_6; break;
    case 7: channel = ADC1_CHANNEL_7; break;
#endif
    default: channel = -1; break;
  }
  return channel;
}
adc_atten_t rangeToAdcAtten(int range){
  adc_atten_t atten;
  switch (range){
#if ESP_IDF_VERSION_MAJOR>=4
	case 1000: atten = ADC_ATTEN_DB_0; break;
	case 1340: atten = ADC_ATTEN_DB_2_5; break;
	case 2000: atten = ADC_ATTEN_DB_6; break;
	case 3600: atten = ADC_ATTEN_DB_11; break;
	default: atten = ADC_ATTEN_DB_11; break;
#else
	case 1000: atten = ADC_ATTEN_0db; break;
	case 1340: atten = ADC_ATTEN_2_5db; break;
	case 2000: atten = ADC_ATTEN_6db; break;
	case 3600: atten = ADC_ATTEN_11db; break;
	default: atten = ADC_ATTEN_11db; break;
#endif
  }
  return atten;
}
int pinToAdcChannelIdx(Pin pin){
  if (pinInfo[pin].analog == JSH_ANALOG_NONE)
    return -1;
  return pinInfo[pin].analog & JSH_MASK_ANALOG_CH;
}

dac_channel_t pinToDacChannel(Pin pin){
#if CONFIG_IDF_TARGET_ESP32
  dac_channel_t channel;
  switch(pin){
    case 25: channel = DAC_CHANNEL_1; break;
    case 26: channel = DAC_CHANNEL_2; break;
    default: channel = -1; break;
  }
  return channel;
#elif CONFIG_IDF_TARGET_ESP32C3
  jsExceptionHere(JSET_ERROR, "not implemented\n");
  return 0;
#elif CONFIG_IDF_TARGET_ESP32S3
  jsExceptionHere(JSET_ERROR, "not implemented\n");
  return 0;
#else
	#error Not an ESP32 or ESP32-S3
#endif
}

void ADCReset(){
  initADC(1);
}
void initADC(int ADCgroup){
  switch(ADCgroup){
  case 1:
#if ESP_IDF_VERSION_MAJOR>=4
    adc1_config_width(ADC_WIDTH_BIT_12);
#else
    adc1_config_width(ADC_WIDTH_12Bit);
#endif
    for(int i = 0; i < adc_channel_max; i++) {
#if ESP_IDF_VERSION_MAJOR>=4
      adc_channel[i] = ADC_ATTEN_DB_11;
#else
      adc_channel[i] = ADC_ATTEN_11db;
#endif
     }
    break;
  case 2:
    jsExceptionHere(JSET_ERROR, "Not implemented");
    break;
  case 3:
    jsExceptionHere(JSET_ERROR, "Not implemented");
    break;
  default:
    jsExceptionHere(JSET_ERROR, "Out of range");
  break;
  }
}

void rangeADC(Pin pin,int range){
  int idx,atten;
  idx = pinToAdcChannelIdx(pin);
  printf("idx:%d\n",idx);
  if(idx >= 0){
    adc_channel[idx] = rangeToAdcAtten(range);
    printf("Atten:%d \n",adc_channel[idx]);
  }
}

int readADC(Pin pin){
  adc1_channel_t channel; int value;
  channel = pinToAdcChannel(pin);
  if(channel >= 0) {
    adc1_config_channel_atten(channel,adc_channel[pinToAdcChannelIdx(pin)]);
#if ESP_IDF_VERSION_MAJOR>=4
	  // ESP_IDF 4.x - int adc1_get_voltage(adc1_channel_t channel)    //Deprecated. Use adc1_get_raw() instead
	  int value=adc1_get_raw(channel);
#else
	  value = adc1_get_voltage(channel);
#endif
    return value;
  } else return -1;
}

void writeDAC(Pin pin,uint8_t value){
  dac_channel_t channel;
  if(value > 255){
    jsExceptionHere(JSET_ERROR, "Not implemented, only 8 bit supported");
    return;
  }
#if CONFIG_IDF_TARGET_ESP32
  channel = pinToDacChannel(pin);
#if ESP_IDF_VERSION_MAJOR>=4
  if(channel >= 0) dac_output_voltage(channel, value);
#else
  if(channel >= 0) dac_out_voltage(channel, value);
#endif
#elif CONFIG_IDF_TARGET_ESP32C3
  jsExceptionHere(JSET_ERROR, "not implemented\n");
#elif CONFIG_IDF_TARGET_ESP32S3
  jsExceptionHere(JSET_ERROR, "not implemented\n");
#else
	#error Not an ESP32 or ESP32-S3
#endif
}



