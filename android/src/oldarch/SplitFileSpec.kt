package com.splitfile

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.Promise

abstract class SplitFileSpec internal constructor(context: ReactApplicationContext) :
  ReactContextBaseJavaModule(context) {

  abstract fun multiply(a: Double, b: Double, promise: Promise)
}
