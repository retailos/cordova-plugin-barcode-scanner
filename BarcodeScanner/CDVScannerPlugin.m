//
//  CDVBarcodeScanner.m
//  BarcodeScanner
//
//  Created by Elton Livera on 09/03/2015.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import "CDVScannerPlugin.h"
#import "CDV.h"
#import "RABarcodeScanner.h"

@interface CDVScannerPlugin() <RABarcodeScannerDelegate>

@property (nonatomic) RABarcodeScanner *scanner;
@property (nonatomic) NSString *callbackId;

@end

@implementation CDVScannerPlugin

- (void)initScanner:(CDVInvokedUrlCommand *)command {
    _scanner = [[RABarcodeScanner alloc] init];
    _scanner.delegate = self;
    
    self.callbackId = command.callbackId;
    //[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)scannerFinishedWithResult:(NSString *)result {
    NSDictionary *resultInfo = @{ @"result" : result };
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultInfo];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)deviceConnectedWithInfo:(NSDictionary *)deviceInfo {
    
}

- (void)deviceDisconnectedWithInfo:(NSDictionary *)deviceInfo {
    
}

- (void)scannerFinishedWithError:(NSError *)error {

}

@end
