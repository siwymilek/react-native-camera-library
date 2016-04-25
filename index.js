/**
 * @providesModule CameraLibrary
 * @flow
 */
'use strict';

var NativeCameraLibrary = require('NativeModules').CameraLibrary;

/**
 * High-level docs for the CameraLibrary iOS API can be written here.
 */

var CameraLibrary = {
  getPhotos: function(params, callback) {
    NativeCameraLibrary.getPhotos(params, callback);
  }
};

module.exports = CameraLibrary;
