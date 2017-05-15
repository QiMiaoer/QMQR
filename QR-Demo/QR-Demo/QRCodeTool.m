//
//  QRCodeTool.m
//  QR-Demo
//
//  Created by zyx on 17/5/15.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import "QRCodeTool.h"

@implementation QRCodeTool

+ (UIImage *)createQRImageWithString:(NSString *)string size:(CGSize)size {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CIImage *image = filter.outputImage;
    CGImageRef imageRef = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef ctxRef = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctxRef, kCGInterpolationNone);
    CGContextScaleCTM(ctxRef, 1.0, -1.0);
    CGContextDrawImage(ctxRef, CGContextGetClipBoundingBox(ctxRef), imageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    
    return result;
}

+ (UIImage *)changeColorWithQRImage:(UIImage *)image backColor:(UIColor *)backColor frontColor:(UIColor *)frontColor {
    CIFilter *filter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:
                        @"inputImage",[CIImage imageWithCGImage:image.CGImage],
                        @"inputColor0",[CIColor colorWithCGColor:frontColor.CGColor],
                        @"inputColor1",[CIColor colorWithCGColor:backColor.CGColor], nil];
    return [UIImage imageWithCIImage:filter.outputImage];
}

+ (UIImage *)addSmallIconToQRImage:(UIImage *)image smallIcon:(UIImage *)smallIcon {
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    CGFloat iconWH = 30;
    CGFloat iconX = (image.size.width - iconWH) / 2;
    CGFloat iconY = (image.size.height - iconWH) / 2;
    [smallIcon drawInRect:CGRectMake(iconX, iconY, iconWH, iconWH)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
