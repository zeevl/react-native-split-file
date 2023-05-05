
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNSplitFileSpec.h"

@interface SplitFile : NSObject <NativeSplitFileSpec>
#else
#import <React/RCTBridgeModule.h>

@interface SplitFile : NSObject <RCTBridgeModule>
#endif

@end
