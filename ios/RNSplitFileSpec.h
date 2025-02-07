#import <React/RCTBridgeModule.h>
#import <React/RCTConvert.h>

@protocol NativeSplitFileSpec <NSObject>

- (void)splitFileIntoChunks:(NSString *)path
                 chunkSize:(double)chunkSize
                 resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject;

@end
