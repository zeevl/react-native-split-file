import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  splitFileIntoChunks(path: String, chunkSize: number): Promise<string[]>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('SplitFile');
