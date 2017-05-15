//
//  ViewController.m
//  QR-Demo
//
//  Created by zyx on 17/5/15.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"
#import "QRCodeViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (IBAction)scan:(id)sender {
    ScanViewController *SVC = [ScanViewController new];
    __weak typeof(self) weak = self;
    SVC.result = ^(NSString *result) {
        weak.label.text = result;
    };
    [self.navigationController pushViewController:SVC animated:YES];
}

- (IBAction)QRCode:(id)sender {
    [self.navigationController pushViewController:[QRCodeViewController new] animated:YES];
}

@end
