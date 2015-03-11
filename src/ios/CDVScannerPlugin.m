//
//  CDVBarcodeScanner.m
//  BarcodeScanner
//
//  Created by Elton Livera on 09/03/2015.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import "CDVScannerPlugin.h"
#import "RABarcodeScanner.h"

static NSString * const EventKey = @"event";
static NSString * const EventTypeKey = @"type";
static NSString * const EventMessageKey = @"message";

static NSString * const EventScanned = @"SCANNED";
static NSString * const EventError = @"ERROR";
static NSString * const EventConnected = @"CONNECTED";
static NSString * const EventDisconnected = @"DISCONNECTED";

@interface CDVScannerPlugin() <RABarcodeScannerDelegate>

@property (nonatomic) RABarcodeScanner *scanner;
@property (nonatomic) NSString *callbackId;

@end

@implementation CDVScannerPlugin

- (void)scan:(CDVInvokedUrlCommand *)command {
    if (_scanner) {
        _scanner = nil;
    }
    
    _scanner = [[RABarcodeScanner alloc] init];
    _scanner.delegate = self;
    
    self.callbackId = command.callbackId;
}

- (void)scannerFinishedWithResult:(NSDictionary *)result {
    NSDictionary *response = responseDictionary(EventScanned, result[@"result"]);
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)scannerFinishedWithError:(NSError *)error {
    NSDictionary *response = responseDictionary(EventError, error.localizedDescription);
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:response];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)deviceDisconnectedWithInfo:(NSDictionary *)deviceInfo {
    NSDictionary *response = responseDictionary(EventDisconnected, deviceInfo[@"deviceName"]);
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:response];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)deviceConnectedWithInfo:(NSDictionary *)deviceInfo {
    NSDictionary *response = responseDictionary(EventConnected, deviceInfo[@"deviceName"]);
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

NSDictionary * responseDictionary(NSString *eventType, NSString *message) {
    return @{
             EventKey : @{
                     EventTypeKey:eventType,
                     EventMessageKey:message
                     }
             };
}

@end
