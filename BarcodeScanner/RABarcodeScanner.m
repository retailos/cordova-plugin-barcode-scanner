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

static float CDTimerInterval = 0.2;

@interface RABarcodeScanner() <ScanApiHelperDelegate>

@property (nonatomic) ScanApiHelper *scanner;
@property (nonatomic) NSTimer *scannerAPIConsumer;

@end

@implementation RABarcodeScanner

- (instancetype)init {
    if (self = [super init]) {
        _scanner = [[ScanApiHelper alloc] init];
        [_scanner setDelegate:self];
        [_scanner open];
        
        _scannerAPIConsumer = [NSTimer scheduledTimerWithTimeInterval:CDTimerInterval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)onTimer:(NSTimer *)timer {
    [self.scanner doScanApiReceive];
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
        [self.delegate scannerFinishedWithResult:result?:@""];
    }
}

- (void)onError:(SKTRESULT)result{
    if ([self.delegate respondsToSelector:@selector(scannerFinishedWithError:)]) {
        NSError *error = [NSError errorWithDomain:RAScannerErrorDomain code:RAScannerErrorCode userInfo:@{ NSLocalizedDescriptionKey : @(result) }];
        [self.delegate scannerFinishedWithError:error];
    }
}

- (void)onScanApiInitializeComplete:(SKTRESULT)result {
    if (SKTSUCCESS(result)) {
        [self.scanner postSetConfirmationMode:kSktScanDataConfirmationModeApp Target:self Response:@selector(onSetDataConfirmationMode:)];
    }
}

- (void)onSetDataConfirmationMode:(id<ISktScanObject>)scanObj{
    SKTRESULT result=[[scanObj Msg]Result];
    if(SKTSUCCESS(result)){
        NSLog(@"DataConfirmation Mode OK");
    }
    else{
        NSLog(@"DataConfirmation Mode Error %ld",result);
    }
}

NSDictionary *deviceDetails(DeviceInfo *deviceInfo) {
    return @{
             @"name" : deviceInfo.getName
             };
}

@end
