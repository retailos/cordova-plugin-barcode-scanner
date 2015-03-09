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

@protocol RABarcodeScannerDelegate <NSObject>

- (void)deviceConnectedWithInfo:(NSDictionary *)deviceInfo;
- (void)deviceDisconnectedWithInfo:(NSDictionary *)deviceInfo;
- (void)scannerFinishedWithResult:(NSString *)result;
- (void)scannerFinishedWithError:(NSError *)error;

@end

@interface RABarcodeScanner : NSObject

@property (nonatomic, weak) id<RABarcodeScannerDelegate> delegate;

@end
