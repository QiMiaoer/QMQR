//
//  ScanView.m
//  QR-Demo
//
//  Created by zyx on 17/5/15.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import "ScanView.h"

@implementation ScanView {
    CALayer *_lineLayer;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        _lineLayer = [CALayer layer];
        _lineLayer.contents = (id)[UIImage imageNamed:@"line"].CGImage;
        [self.layer addSublayer:_lineLayer];
        [self resumeAnimation];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopAnimation) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat pickingFieldWidth = 200;
    CGFloat pickingFieldHeight = 200;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.35);
    CGContextSetLineWidth(contextRef, 3);
    
    CGRect pickingFieldRect = CGRectMake((width - pickingFieldWidth) / 2, (height - pickingFieldHeight) / 2, pickingFieldWidth, pickingFieldHeight);
    
    UIBezierPath *pickingFieldPath = [UIBezierPath bezierPathWithRect:pickingFieldRect];
    UIBezierPath *bezierPathRect = [UIBezierPath bezierPathWithRect:rect];
    [bezierPathRect appendPath:pickingFieldPath];
    
    bezierPathRect.usesEvenOddFillRule = YES;
    [bezierPathRect fill];
    CGContextSetLineWidth(contextRef, 2);
    CGContextSetRGBStrokeColor(contextRef, 27/255.0, 181/255.0, 254/255.0, 1);
    [pickingFieldPath stroke];
    
    CGContextRestoreGState(contextRef);
    self.layer.contentsGravity = kCAGravityCenter;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
    
    _lineLayer.frame = CGRectMake((self.frame.size.width - 200) / 2, (self.frame.size.height - 200) / 2, 200, 2);
}

- (void)stopAnimation
{
    [_lineLayer removeAnimationForKey:@"translationY"];
}

- (void)resumeAnimation
{
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    basic.fromValue = @(0);
    basic.toValue = @(200);
    basic.duration = 1.5;
    basic.repeatCount = NSIntegerMax;
    [_lineLayer addAnimation:basic forKey:@"translationY"];
}

@end
