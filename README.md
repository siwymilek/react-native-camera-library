# React Native Camera Library

[React Native](https://facebook.github.io/react-native/) library which provides access to camera roll.

## Features
* thumbnails for both photos and videos
* URI for assets

## Setup
First, install the package:
```
npm install --save react-native-camera-library
```

Then, follow those instructions:

You have to import `node_modules/react-native-camera-library/CameraLibrary.xcodeproj`
by following the [libraries linking instructions](https://facebook.github.io/react-native/docs/linking-libraries-ios.html#here-the-few-steps-to-link-your-libraries-that-contain-native-code).

## Simple example
```
import CameraLibrary from 'react-native-camera-library';

CameraLibrary.getPhotos({page: 1}, (response) => {
    console.log(response);
});
```

## License

The MIT License.

See [LICENSE](LICENSE)
