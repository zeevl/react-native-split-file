#import "SplitFile.h"

@implementation SplitFile
RCT_EXPORT_MODULE()

- (void)splitFileIntoChunks:(NSString *)path
                 chunkSize:(double)chunkSize
                 resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject
{
    // Check if the file exists
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if (!fileExists) {
        NSString *errorMessage = [NSString stringWithFormat:@"File not found: %@", path];
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:404 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
        reject(@"file_not_found", errorMessage, error);
        return;
    }
    
    // Open the input file
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (!fileHandle) {
        NSString *errorMessage = [NSString stringWithFormat:@"Failed to open file: %@", path];
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
        reject(@"file_open_error", errorMessage, error);
        return;
    }
    
    // Get the file size and calculate the number of chunks
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
    NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
    NSUInteger numberOfChunks = ceil([fileSize doubleValue] / [chunkSize doubleValue]);
    
    // Initialize the output filenames array
    NSMutableArray *outputFilenames = [NSMutableArray arrayWithCapacity:numberOfChunks];
    
    // Read and write chunks of data to output files
    for (NSUInteger i = 0; i < numberOfChunks; i++) {
        @autoreleasepool {
            @try {
                // Read a chunk of data from the input file
                NSData *chunkData = [fileHandle readDataOfLength:[chunkSize unsignedIntegerValue]];
                NSString *outputFilename = [NSString stringWithFormat:@"%@.%lu", path, i];
                [outputFilenames addObject:outputFilename];
                
                // Write the chunk data to the output file
                [chunkData writeToFile:outputFilename atomically:YES];
            } @catch (NSException *exception) {
                NSString *errorMessage = [NSString stringWithFormat:@"Failed to read/write chunk %lu of file: %@", i, path];
                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
                reject(@"chunk_error", errorMessage, error);
                return;
            }
        }
    }
    
    // Close the input file
    [fileHandle closeFile];
    
    // Return the array of output filenames
    resolve(outputFilenames);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeSplitFileSpecJSI>(params);
}
@end
