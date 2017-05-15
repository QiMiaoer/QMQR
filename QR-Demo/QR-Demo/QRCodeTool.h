//
//  QRCodeTool.h
//  QR-Demo
//
//  Created by zyx on 17/5/15.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeTool : NSObject

/// 创建二维码
+ (UIImage *)createQRImageWithString:(NSString *)string size:(CGSize)size;

/// 改变二维码颜色
+ (UIImage *)changeColorWithQRImage:(UIImage *)image backColor:(UIColor *)backColor frontColor:(UIColor *)frontColor;

/// 添加中间小头像
+ (UIImage *)addSmallIconToQRImage:(UIImage *)image smallIcon:(UIImage *)smallIcon;

@end
