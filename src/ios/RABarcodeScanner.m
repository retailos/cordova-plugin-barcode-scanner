//
//  RABarcodeScanner.m
//  BarcodeScanner
//
//  Created by Elton Livera on 09/03/2015.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import "RABarcodeScanner.h"
#import "ScanApiHelper.h"
#import "DTDevices.h"

NSString * const RAResultKey = @"result";
NSString * const RADeviceNameKey = @"deviceName";

NSString * const RAScannerErrorDomain = @"com.redant.scanner-error";
NSInteger const RAScannerErrorCode = 101;
static float ScannerTimerInterval = 0.5;

@interface RABarcodeScanner() <ScanApiHelperDelegate, DTDeviceDelegate>

@property (nonatomic, weak) id<RABarcodeScannerDelegate> delegate;
@property (nonatomic) ScanApiHelper *socketMobileScanner;
@property (nonatomic) DTDevices *lineaproScanner;
@property (nonatomic) NSTimer *scannerAPITimer;

@end

@implementation RABarcodeScanner

- (void)dealloc {
    [self.scannerAPITimer invalidate];
    self.scannerAPITimer = nil;
}

- (instancetype)init {
    return nil;
}

- (instancetype)initWithDelegate:(id<RABarcodeScannerDelegate>)delegate {
    
    if (self = [super init]) {
        _delegate = delegate;
        
        _socketMobileScanner = [[ScanApiHelper alloc] init];
        [_socketMobileScanner setDelegate:self];
        [_socketMobileScanner open];
        _scannerAPITimer = [NSTimer scheduledTimerWithTimeInterval:ScannerTimerInterval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        
        _lineaproScanner = [DTDevices sharedDevice];
        _lineaproScanner.delegate = self;
        [_lineaproScanner barcodeSetTypeMode:BARCODE_TYPE_DEFAULT error:nil];
        [_lineaproScanner connect];
    }
    return self;
}

#pragma mark - SocketMobile SDK
#pragma mark Helper methods

- (void)onTimer:(NSTimer *)timer {
    [self.socketMobileScanner doScanApiReceive];
}

- (void)sendError:(NSString *)errorDescription {
    NSError *error = [NSError errorWithDomain:RAScannerErrorDomain code:RAScannerErrorCode userInfo:@{ NSLocalizedDescriptionKey : errorDescription }];
    if ([self.delegate respondsToSelector:@selector(scannerFinishedWithError:)]) {
        [self.delegate scannerFinishedWithError:error];
    }
}

#pragma mark Scanner delegate methods

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

- (void)onDecodedDataResult:(long)result device:(DeviceInfo *)device decodedData:(ISktScanDecodedData*)decodedData {
    NSString *resultString = [NSString stringWithUTF8String:(const char *)[decodedData getData]];
    if ([self.delegate respondsToSelector:@selector(scannerFinishedWithResult:)]) {
        [self.delegate scannerFinishedWithResult:resultString ? scanResponse(resultString) : @{}];
    }
    [self.socketMobileScanner postSetDataConfirmation:device goodData:resultString ? TRUE : FALSE Target:nil Response:nil]; 
}

- (void)onError:(SKTRESULT)result {
    NSString *errorString = @"An error occured during the retrieval of a ScanObject from ScanAPI";
    [self sendError:errorString];
}

- (void)onScanApiInitializeComplete:(SKTRESULT)result {
    if (SKTSUCCESS(result)) {
        [self.socketMobileScanner postSetConfirmationMode:kSktScanDataConfirmationModeApp Target:self Response:@selector(onSetDataConfirmationMode:)];
    } else {
        NSString *errorString = [NSString stringWithFormat:@"Error initializing ScanAPI: %ld",result];
        [self sendError:errorString];
    }
}

- (void)onSetDataConfirmationMode:(ISktScanObject*)scanObj {
    SKTRESULT result=[[scanObj Msg] Result];
    if(!SKTSUCCESS(result)){
        NSString *errorString = [NSString stringWithFormat:@"DataConfirmation Mode Error: %ld",result];
        [self sendError:errorString];
    }
}

#pragma mark - Linea-pro SDK
#pragma mark Scanner delegate methods

- (void)barcodeNSData:(NSData *)barcode type:(int)type {
    NSString *resultString = [[NSString alloc] initWithData:barcode encoding:NSUTF8StringEncoding];
    if ([self.delegate respondsToSelector:@selector(scannerFinishedWithResult:)]) {
        [self.delegate scannerFinishedWithResult:scanResponse(resultString)];
    }
}

- (void)connectionState:(int)state {
    switch (state) {
            
        case CONN_CONNECTED: {
            NSArray *connectedDevices = [_lineaproScanner getConnectedDevicesInfo:nil];
            if ([self.delegate respondsToSelector:@selector(deviceConnectedWithInfo:)]) {
                [self.delegate deviceConnectedWithInfo:deviceResponse(connectedDevices.firstObject)];
            }
        }
            break;
            
        case CONN_DISCONNECTED:
        case CONN_CONNECTING:
            if ([self.delegate respondsToSelector:@selector(deviceDisconnectedWithInfo:)]) {
                [self.delegate deviceDisconnectedWithInfo:deviceResponse(nil)];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Functions

NSDictionary *deviceResponse(id device) {
    NSString *deviceName;
    
    if ([device isKindOfClass:[DTDeviceInfo class]]) {
        deviceName = ((DTDeviceInfo *)device).name;
    } else if ([device isKindOfClass:[DeviceInfo class]]) {
        deviceName = ((DeviceInfo *)device).getName;
    }
    
    return @{
             RADeviceNameKey : deviceName ?: @""
             };
}

NSDictionary *scanResponse(NSString *result) {
    return @{
             RAResultKey : result ?: @"",
             };
}

@end
