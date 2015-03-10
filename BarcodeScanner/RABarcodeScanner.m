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
@property (nonatomic) NSTimer *scannerAPITimer;

@end

@implementation RABarcodeScanner

- (void)dealloc {
    [self.scannerAPITimer invalidate];
    self.scannerAPITimer = nil;
}

- (instancetype)init {
    
    if (self = [super init]) {
        _socketMobilescanner = [[ScanApiHelper alloc] init];
        [_socketMobilescanner setDelegate:self];
        [_socketMobilescanner open];
        
        _scannerAPITimer = [NSTimer scheduledTimerWithTimeInterval:ScannerTimerInterval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
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
        [self.delegate deviceConnectedWithInfo:deviceResponse(deviceAdded)];
    }
}

- (void)onDeviceRemoval:(DeviceInfo *)deviceRemoved {
    if ([self.delegate respondsToSelector:@selector(deviceDisconnectedWithInfo:)]) {
        [self.delegate deviceDisconnectedWithInfo:deviceResponse(deviceRemoved)];
    }
}

- (void)onDecodedDataResult:(long)result device:(DeviceInfo *)device decodedData:(id<ISktScanDecodedData>)decodedData {
    NSString *resultString = [NSString stringWithUTF8String:(const char *)[decodedData getData]];
    if ([self.delegate respondsToSelector:@selector(scannerFinishedWithResult:)]) {
        [self.delegate scannerFinishedWithResult:resultString ? scanResponse(resultString) : @{}];
    }
    
    [self.socketMobilescanner postSetDataConfirmation:device Target:nil Response:nil];
}

- (void)onError:(SKTRESULT)result {
    NSString *errorString = @"An error occured during the retrieval of a ScanObject from ScanAPI";
    [self sendError:errorString];
}

- (void)onScanApiInitializeComplete:(SKTRESULT)result {
    if (SKTSUCCESS(result)) {
        [self.socketMobilescanner postSetConfirmationMode:kSktScanDataConfirmationModeScanAPI Target:self Response:@selector(onSetDataConfirmationMode:)];
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

NSDictionary *deviceResponse(DeviceInfo *deviceInfo) {
    return @{
             @"deviceName" : deviceInfo.getName ?: @""
             };
}

NSDictionary *scanResponse(NSString *result) {
    return @{
             @"result" : result ?: @"",
             };
}

@end
