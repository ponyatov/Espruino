/*
 * This file is part of Espruino, a JavaScript interpreter for Microcontrollers
 *
 * Copyright (C) 2022 Gordon Williams <gw@pur3.co.uk>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * ----------------------------------------------------------------------------
 * Platform Specific entry point
 * ----------------------------------------------------------------------------
 */

#include "platform_config.h"
#include "jsinteractive.h"
#include "jshardware.h"
#include "jswrapper.h"
#include "jsflags.h"

/// This is the currently active EJS instance (if one is active at all)
struct ejs *activeEJS = NULL;

// Fixing up undefined functions
void jshInterruptOn() {}
void jshInterruptOff() {}
bool jshIsInInterrupt() { return false; }

void jsiConsolePrintf(const char *fmt, ...) {
  va_list argp;
  va_start(argp, fmt);
#ifdef USE_FLASH_MEMORY
  // TODO
  assert(0);
#else
  vcbprintf(vcbprintf_callback_jsiConsolePrintString,0, fmt, argp);
#endif
  va_end(argp);
}
void jsiConsolePrintStringVar(JsVar *v) {
  // the jsinteractive one converts \n -> \r\n but we don't care here
  jsiConsolePrintf("%v", v);
}
bool jsiFreeMoreMemory() { return false; } // no extra memory is allocated
void jshKickWatchDog() { }
void jsiConsoleRemoveInputLine() {}
JsSysTime jshGetTimeFromMilliseconds(JsVarFloat ms) {
  return (JsSysTime)(ms*1000);
}
JsVarFloat jshGetMillisecondsFromTime(JsSysTime time) {
  return ((JsVarFloat)time)/1000;
}
JsVar *jsvFindOrCreateRoot() {
  return jsvLockAgain(activeEJS->root);
}
// ===============================
JsSysTime jshGetSystemTime() {
  return ejs_get_microseconds();
}
void jsiConsolePrintString(const char *str) {
  ejs_print(str);
}
void vcbprintf_callback_jsiConsolePrintString(const char *str, void* user_data) {
  NOT_USED(user_data);
  jsiConsolePrintString(str);
}
// ===============================

void ejs_set_instance(struct ejs *ejs) {
  if (activeEJS) ejs_unset_instance();
  execInfo.hiddenRoot = ejs->hiddenRoot;
  execInfo.root = ejs->root;
  execInfo.baseScope = ejs->root;
  jsFlags = (JsFlags)ejs->jsFlags;
  jsErrorFlags = (JsErrorFlags)ejs->jsErrorFlags;
  activeEJS = ejs;
}

void ejs_unset_instance() {
  if (!activeEJS) return;
  activeEJS->jsFlags = (unsigned char)jsFlags;
  activeEJS->jsErrorFlags = (unsigned char)jsErrorFlags;
  execInfo.hiddenRoot = NULL;
  execInfo.root = NULL;
  execInfo.baseScope = NULL;
  jsFlags = 0;
  jsErrorFlags = 0;
  activeEJS = NULL;
}

struct ejs *ejs_get_active_instance() {
  return activeEJS;
}

void ejs_clear_exception() {
  if (activeEJS && activeEJS->exception) {
    jsvUnLock(activeEJS->exception);
    activeEJS->exception = NULL;
  }
}

/* Create an instance */
bool ejs_create(unsigned int varCount) {
  jsVars = NULL; // or else jsvInit will reuse the old jsVars
  jswHWInit();
  jsvInit(varCount);
  return jsVars!=NULL;
}

/* Create an instance */
struct ejs *ejs_create_instance(unsigned int varCount) {
  struct ejs *ejs = (struct ejs*)malloc(sizeof(struct ejs));
  if (!ejs) return 0;
  ejs->exception = NULL;
  ejs->root = jsvRef(jsvNewWithFlags(JSV_ROOT));
  activeEJS = ejs;
  jspInit();
  ejs->hiddenRoot = execInfo.hiddenRoot;
  return ejs;
}

/* Destroy the instance */
void ejs_destroy_instance(struct ejs *ejs) {
  ejs_set_instance(ejs);
  ejs_clear_exception();
  jspKill();
  jsvUnLock(ejs->root);
  free(ejs);
}

/* Destroy the instance */
void ejs_destroy() {
  jsvKill();
}

/* Handle an exception, and return it if there was one. The exception
returned is NOT locked and will be freed on the next call to ejs_catch_exception
or ejs_clear_exception */
JsVar *ejs_catch_exception() {
  JsVar *exception = jspGetException();
  if (exception) {
    ejs_clear_exception();
    activeEJS->exception = exception;
    jsiConsolePrintf("Uncaught %v\n", exception);
    if (jsvIsObject(exception)) {
      JsVar *stackTrace = jsvObjectGetChildIfExists(exception, "stack");
      if (stackTrace) {
        jsiConsolePrintf("%v\n", stackTrace);
        jsvUnLock(stackTrace);
      }
    }
  }
  return exception;
}

JsVar *ejs_exec(struct ejs *ejs, const char *src, bool stringIsStatic) {
  ejs_set_instance(ejs);
  ejs_clear_exception();
  JsVar *v = jspEvaluate(src, stringIsStatic);
  // ^ if the string is static, we can let functions reference it directly
  ejs_catch_exception();
  ejs_unset_instance();
  return v;
}

JsVar *ejs_execf(struct ejs *ejs, JsVar *func, JsVar *thisArg, int argCount, JsVar **argPtr) {
  ejs_set_instance(ejs);
  ejs_clear_exception();
  JsVar *v = jspExecuteFunction(func, thisArg, argCount, argPtr);
  ejs_catch_exception();
  ejs_unset_instance();
  return v;
}
