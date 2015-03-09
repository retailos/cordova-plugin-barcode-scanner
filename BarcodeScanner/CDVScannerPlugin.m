//
//  CDVBarcodeScanner.m
//  BarcodeScanner
//
//  Created by Elton Livera on 09/03/2015.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import "CDVScannerPlugin.h"
#import "CDV.h"

@implementation CDVScannerPlugin

- (void)getDeviceInfo:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{}];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
