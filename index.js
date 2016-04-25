/**
 * @providesModule CameraLibrary
 * @flow
 */
'use strict';

const React = require('react-native')
const {NativeModules} = React;
const NativeCameraLibrary = NativeModules.CameraLibrary;

/**
 * High-level docs for the CameraLibrary iOS API can be written here.
 */

var CameraLibrary = {
  getPhotos: function(params, callback) {
    NativeCameraLibrary.getPhotos(params, callback);
  }
};

module.exports = CameraLibrary;
