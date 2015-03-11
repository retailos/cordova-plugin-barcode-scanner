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

@required
- (void)scannerFinishedWithResult:(NSDictionary *)result;
- (void)scannerFinishedWithError:(NSError *)error;

@optional
- (void)deviceConnectedWithInfo:(NSDictionary *)deviceInfo;
- (void)deviceDisconnectedWithInfo:(NSDictionary *)deviceInfo;

@end

@interface RABarcodeScanner : NSObject

@property (nonatomic, weak) id<RABarcodeScannerDelegate> delegate;

@end
