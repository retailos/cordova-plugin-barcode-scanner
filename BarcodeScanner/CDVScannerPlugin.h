//
//  CDVBarcodeScanner.h
//  BarcodeScanner
//
//  Created by Elton Livera on 09/03/2015.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDVPlugin.h"

@interface CDVScannerPlugin : CDVPlugin

- (void)getDeviceInfo:(CDVInvokedUrlCommand *)command;

@end
