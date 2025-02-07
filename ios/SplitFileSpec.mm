#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTBridgeModule.h>
#import <React/RCTConvert.h>
#import "RNSplitFileSpec.h"

namespace facebook {
namespace react {

static facebook::jsi::Value __hostFunction_NativeSplitFileSpec_splitFileIntoChunks(
    facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<NativeSplitFileSpecJSI *>(&turboModule)
      ->splitFileIntoChunks(rt, args, count);
}

NativeSplitFileSpecJSI::NativeSplitFileSpecJSI(const ObjCTurboModule::InitParams &params)
    : ObjCTurboModule(params)
{
  methodMap_["splitFileIntoChunks"] = MethodMetadata{
      2, __hostFunction_NativeSplitFileSpec_splitFileIntoChunks};
}

} // namespace react
} // namespace facebook
#endif
