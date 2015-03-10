//
//  ViewController.m
//  BarcodeScanner
//
//  Created by Elton Livera on 09/03/2015.
//  Copyright (c) 2015 Red Ant. All rights reserved.
//

#import "ViewController.h"
#import "RABarcodeScanner.h"

@interface ViewController () <RABarcodeScannerDelegate>

@property (nonatomic) RABarcodeScanner *scanner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scanner = [[RABarcodeScanner alloc] init];
    self.scanner.delegate = self;
}

- (void)scannerFinishedWithResult:(NSDictionary *)result {
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
