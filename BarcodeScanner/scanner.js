var argscheck = require('cordova/argscheck'),
channel = require('cordova/channel'),
utils = require('cordova/utils'),
exec = require('cordova/exec'),
cordova = require('cordova');

channel.createSticky('onCordovaInfoReady');
channel.waitForInitialization('onCordovaInfoReady');

function Scanner() {}

/**
 *
 * @param {Function} successCallback The function to call when the heading data is available
 * @param {Function} errorCallback The function to call when there is an error getting the heading data.
 */
Scanner.prototype.scan = function(successCallback, errorCallback) {
    exec(successCallback, errorCallback, "Scanner", "scan", []);
};

module.exports = new Scanner();
