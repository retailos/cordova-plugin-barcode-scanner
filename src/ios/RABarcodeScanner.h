//
//  RABarcodeScanner.h
//  BarcodeScanner
//
//  Created by Elton Livera on 09/03/2015.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const RAScannerErrorDomain;
extern NSInteger const RAScannerErrorCode;
extern NSString * const RAResultKey;
extern NSString * const RADeviceNameKey;

@protocol RABarcodeScannerDelegate <NSObject>

@required
- (void)scannerFinishedWithResult:(NSDictionary *)result;
- (void)scannerFinishedWithError:(NSError *)error;

@optional
- (void)deviceConnectedWithInfo:(NSDictionary *)deviceInfo;
- (void)deviceDisconnectedWithInfo:(NSDictionary *)deviceInfo;

@end

@interface RABarcodeScanner : NSObject

- (instancetype)initWithDelegate:(id<RABarcodeScannerDelegate>)delegate;

@end
