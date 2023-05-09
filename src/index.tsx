import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-split-file' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const SplitFileModule = isTurboModuleEnabled
  ? require('./NativeSplitFile').default
  : NativeModules.SplitFile;

const SplitFile = SplitFileModule
  ? SplitFileModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export async function splitFile(path: string, chunkSize: number) {
  const chunkPaths = await SplitFile.splitFileIntoChunks(path, chunkSize);

  // On iOS, the native code returns the paths as NSURL objects, so we need to convert them to strings
  // if (Platform.OS === 'ios') {
  //   return chunkPaths.map((chunkPath) => chunkPath.absoluteString);
  // }

  return chunkPaths;
}

export default { splitFile };
