# React Native Camera Library

[React Native](https://facebook.github.io/react-native/) library which provides access to camera roll.

## Features
* thumbnails for both photos and videos
* URI for assets

## Installation
First, install the package:
```
npm install --save react-native-camera-library
```

Then, follow those instructions:

You have to import `node_modules/react-native-camera-library/CameraLibrary.xcodeproj`
by following the [libraries linking instructions](https://facebook.github.io/react-native/docs/linking-libraries-ios.html#here-the-few-steps-to-link-your-libraries-that-contain-native-code).


## Usage

### API

#### getPhotos

```js
CameraLibrary.getPhotos(fetchParams, callback)
```

`fetchParams`

An object containing parameters for fetching, currently supports `page`. Ex: `{ page: 1 }`

`callback`

A function which includes a parameter containing the following response:

```js
{ 
	next_page: 0, // boolean representing if next_page is available
	current_page: 1, // current page index
	last_page: 288, // the last available page
	objects: [
		type: "photo", // photo or video
		thumbnail: "xKdfk382SD...", // base64 encoded image
		url: "asset-library://...", // full path to asset
	]
} 



### Simple example
```
import CameraLibrary from 'react-native-camera-library';

CameraLibrary.getPhotos({page: 1}, (response) => {
    console.log(response);
});
```

## License

The MIT License.

See [LICENSE](LICENSE)
