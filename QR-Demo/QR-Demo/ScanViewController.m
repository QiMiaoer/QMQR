//
//  ScanViewController.m
//  QR-Demo
//
//  Created by zyx on 17/5/15.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanView.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation ScanViewController {
    AVCaptureVideoPreviewLayer *_prevLayer;
    BOOL _lightOpen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ScanView *scan = [[ScanView alloc] init];
    [self.view addSubview:scan];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"闪光灯" style:UIBarButtonItemStylePlain target:self action:@selector(lightOnOrOff)];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    _prevLayer = layer;
    [self.view.layer insertSublayer:layer atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.session stopRunning];
}

#pragma mark --- light
- (void)lightOnOrOff {
    _lightOpen = !_lightOpen;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch] && [device hasFlash]) {
        [device lockForConfiguration:nil];
        
        if (_lightOpen) {
            device.torchMode = AVCaptureTorchModeOn;
            device.flashMode = AVCaptureFlashModeOn;
        } else {
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeOff;
        }
        
        [device unlockForConfiguration];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *result;
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        if (metadataObject.stringValue.length > 0) {
            result = metadataObject.stringValue;
        }
        
        [self performSelectorOnMainThread:@selector(stopReading:) withObject:result waitUntilDone:NO];
    }
}

-(void)stopReading:(NSString *)result {
    [_session stopRunning];
    _session = nil;
    [_prevLayer removeFromSuperlayer];
    
    [self.navigationController popViewControllerAnimated:YES];
    if (self.result) {
        self.result(result);
    }
}

#pragma mark --- getter
- (AVCaptureSession *)session {
    if (!_session) {
        _session = ({
            //获取摄像设备
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            //创建输入流
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            if (!input) {
                return nil;
            }
            //创建输出流
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
            //设置代理 刷新
            dispatch_queue_t queue = dispatch_queue_create("myqueue", NULL);
            [output setMetadataObjectsDelegate:self queue:queue];
            //设置扫描区域的比例
            CGFloat width = 200 / CGRectGetHeight(self.view.frame);
            CGFloat height = 200 / CGRectGetWidth(self.view.frame);
            output.rectOfInterest = CGRectMake((1 - width) / 2, (1- height) / 2, width, height);
            
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
            //高质量采集率
            [session setSessionPreset:AVCaptureSessionPresetHigh];
            [session addInput:input];
            [session addOutput:output];
            
            //设置扫码支持的编码格式(这里设置条形码和二维码兼容)
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                           AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeCode128Code];
            
            session;
        });
    }
    
    return _session;
}

@end
