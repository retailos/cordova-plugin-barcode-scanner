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
     _scanner = nil;
    
    //this gets rid of the thread warning for Scanner
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
           _scanner = [[RABarcodeScanner alloc] initWithDelegate:self];
        });
        _callbackId = command.callbackId;
    }];
}

- (void)sendResult:(CDVPluginResult *)pluginResult {
    if (_callbackId) {
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
        
        _scanner = nil;
    }
}

- (void)scannerFinishedWithResult:(NSDictionary *)result {
    NSDictionary *response = responseDictionary(EventScanned, result[RAResultKey]);
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response];
    [self sendResult:pluginResult];
}

- (void)scannerFinishedWithError:(NSError *)error {
    NSDictionary *response = responseDictionary(EventError, error.localizedDescription);
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:response];
    [self sendResult:pluginResult];
}

- (void)deviceDisconnectedWithInfo:(NSDictionary *)deviceInfo {
    NSDictionary *response = responseDictionary(EventDisconnected, deviceInfo[RADeviceNameKey]);
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:response];
    [self sendResult:pluginResult];
}

- (void)deviceConnectedWithInfo:(NSDictionary *)deviceInfo {
    NSDictionary *response = responseDictionary(EventConnected, deviceInfo[RADeviceNameKey]);
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response];
    [self sendResult:pluginResult];
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
