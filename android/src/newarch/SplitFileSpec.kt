package com.splitfile

import com.facebook.react.bridge.ReactApplicationContext

abstract class SplitFileSpec internal constructor(context: ReactApplicationContext) :
  NativeSplitFileSpec(context) {
}
