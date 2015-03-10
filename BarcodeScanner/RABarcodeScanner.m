//
//  RABarcodeScanner.m
//  BarcodeScanner
//
//  Created by Elton Livera on 09/03/2015.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import "RABarcodeScanner.h"
#import "ScanApiHelper.h"

NSString * const RAScannerErrorDomain = @"com.redant.scanner-error";
NSInteger const RAScannerErrorCode = 101;

static float ScannerTimerInterval = 0.2;

@interface RABarcodeScanner() <ScanApiHelperDelegate>

@property (nonatomic) ScanApiHelper *socketMobilescanner;
@property (nonatomic) NSTimer *scannerAPIConsumer;

@end

@implementation RABarcodeScanner

- (instancetype)init {
    
    if (self = [super init]) {
        _socketMobilescanner = [[ScanApiHelper alloc] init];
        [_socketMobilescanner setDelegate:self];
        [_socketMobilescanner open];
        
        _scannerAPIConsumer = [NSTimer scheduledTimerWithTimeInterval:ScannerTimerInterval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)onTimer:(NSTimer *)timer {
    [self.socketMobilescanner doScanApiReceive];
}

- (void)sendError:(NSString *)errorDescription {
    NSError *error = [NSError errorWithDomain:RAScannerErrorDomain code:RAScannerErrorCode userInfo:@{ NSLocalizedDescriptionKey : errorDescription }];
    if ([self.delegate respondsToSelector:@selector(scannerFinishedWithError:)]) {
        [self.delegate scannerFinishedWithError:error];
    }
}

#pragma mark - Scanner delegate methods

- (void)onDeviceArrival:(SKTRESULT)result device:(DeviceInfo *)deviceAdded {
    if ([self.delegate respondsToSelector:@selector(deviceConnectedWithInfo:)]) {
        [self.delegate deviceConnectedWithInfo:deviceDetails(deviceAdded)];
    }
}

- (void)onDeviceRemoval:(DeviceInfo *)deviceRemoved {
    if ([self.delegate respondsToSelector:@selector(deviceDisconnectedWithInfo:)]) {
        [self.delegate deviceDisconnectedWithInfo:deviceDetails(deviceRemoved)];
    }
}

- (void)onDecodedData:(DeviceInfo *)device decodedData:(id<ISktScanDecodedData>)decodedData {
    NSString *result = [NSString stringWithUTF8String:(const char *)[decodedData getData]];
    if ([self.delegate respondsToSelector:@selector(scannerFinishedWithResult:)]) {
        [self.delegate scannerFinishedWithResult:result ? resultDetails(device, result) : @{}];
    }
}

- (void)onError:(SKTRESULT)result {
    NSString *errorString = @"An error occured during the retrieval of a ScanObject from ScanAPI";
    [self sendError:errorString];
}

- (void)onScanApiInitializeComplete:(SKTRESULT)result {
    if (SKTSUCCESS(result)) {
        [self.socketMobilescanner postSetConfirmationMode:kSktScanDataConfirmationModeApp Target:self Response:@selector(onSetDataConfirmationMode:)];
    } else {
        NSString *errorString = [NSString stringWithFormat:@"Error initializing ScanAPI: %ld",result];
        [self sendError:errorString];
    }
}

- (void)onSetDataConfirmationMode:(id<ISktScanObject>)scanObj {
    SKTRESULT result=[[scanObj Msg] Result];
    if(!SKTSUCCESS(result)){
        NSString *errorString = [NSString stringWithFormat:@"DataConfirmation Mode Error: %ld",result];
        [self sendError:errorString];
    }
}

NSDictionary *deviceDetails(DeviceInfo *deviceInfo) {
    return @{
             @"deviceName" : deviceInfo.getName
             };
}

NSDictionary *resultDetails(DeviceInfo *deviceInfo, NSString *result) {
    NSMutableDictionary *info = deviceDetails(deviceInfo).mutableCopy;
    [info addEntriesFromDictionary: @{
                                     @"result"      : result,
                                     }];
    return info;
}

@end
