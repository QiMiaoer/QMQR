//
//  ScanViewController.h
//  QR-Demo
//
//  Created by zyx on 17/5/15.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController

@property (nonatomic, copy) void(^result)(NSString *);

@end
