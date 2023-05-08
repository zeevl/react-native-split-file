import * as React from 'react';

import { ScrollView, Text } from 'react-native';
import RNFS from 'react-native-fs';
import { splitFileIntoChunks } from 'react-native-split-file';

export default function App() {
  const [result, setResult] = React.useState<string[] | undefined>();

  React.useEffect(() => {
    doWork().then(setResult);
  }, []);

  return (
    <ScrollView style={{ flex: 1 }}>
      <Text>Result:</Text>
      {result?.map((s) => (
        <Text key={s}>{s}</Text>
      ))}
    </ScrollView>
  );
}

const doWork = async () => {
  console.log(`creating temp file to split...`);
  const tempFile = await createTempFile();

  console.log(`splitting ${tempFile} into chunks...`);
  const chunkFilenames = await splitFileIntoChunks(tempFile, 10000);

  console.log('done!', chunkFilenames);
  return chunkFilenames;
};

const createTempFile = async () => {
  const dest = `${RNFS.TemporaryDirectoryPath}${Date.now()}.tmp`;

  // write a long file of sequential numbers
  let str = '';
  for (let i = 0; i < 100000; i++) {
    str += `${i}\n`;
  }

  await RNFS.writeFile(dest, str);

  return dest;
};
