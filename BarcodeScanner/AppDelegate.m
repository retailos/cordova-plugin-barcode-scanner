//
//  AppDelegate.m
//  BarcodeScanner
//
//  Created by Elton Livera on 09/03/2015.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import "AppDelegate.h"
#import "RABarcodeScanner.h"

@interface AppDelegate () <RABarcodeScannerDelegate>

@property (nonatomic) RABarcodeScanner *scanner;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.scanner = [[RABarcodeScanner alloc] init];
    self.scanner.delegate = self;
    return YES;
}

- (void)scannerFinishedWithResult:(NSString *)result {
    NSLog(@"scanningFinishedWithResult: %@", result);
}

- (void)deviceConnectedWithInfo:(NSDictionary *)deviceInfo {
    NSLog(@"deviceConnectedWithInfo: %@", deviceInfo);
}

- (void)deviceDisconnectedWithInfo:(NSDictionary *)deviceInfo {
    NSLog(@"deviceDisconnectedWithInfo: %@", deviceInfo);
}

- (void)scannerFinishedWithError:(NSError *)error {
    NSLog(@"scannerFinishedWithError: %@", error);
}

@end
