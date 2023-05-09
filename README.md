# react-native-split-file

A simple react-native library that can split a file into parts of an equal size, with the last part consisting of the remainder. 

Designed to be used for multi-part uploads to S3. 

## Installation

```sh
npm install react-native-split-file
# or
yarn add react-native-split-file
```

## Usage

```js
import { splitFile } from 'react-native-split-file';

// ...

const result = await splitFile('/some/big/file.mov', 5000000);
// result is an array of paths to the split files
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
