//
//  QRCodeViewController.m
//  QR-Demo
//
//  Created by zyx on 17/5/15.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import "QRCodeViewController.h"
#import "QRCodeTool.h"

@interface QRCodeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation QRCodeViewController {
    UIImageView *_imageView;
    UITextField *_textField;
    UILabel *_label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"从相册选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectImage)];
    
    [self setupUI];
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    imageView.center = self.view.center;
    imageView.layer.borderColor = [[UIColor blackColor] CGColor];
    imageView.layer.borderWidth = 1.0;
    [self.view addSubview:imageView];
    _imageView = imageView;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(checkQRCode)];
    longPress.minimumPressDuration = 0.8;
    longPress.numberOfTouchesRequired = 1;
    [imageView addGestureRecognizer:longPress];
    imageView.userInteractionEnabled = YES;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 200, 30)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    _textField = textField;
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(CGRectGetMaxX(textField.frame), CGRectGetMinY(textField.frame), 150, 30);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"create QRImage" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(createQRImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton new];
    btn1.frame = CGRectMake(30, CGRectGetMaxY(textField.frame) + 30, 150, 30);
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"change color" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton new];
    btn2.frame = CGRectMake(CGRectGetMaxX(btn1.frame) + 30, CGRectGetMaxY(textField.frame) + 30, 150, 30);
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"add small icon" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(addSmallIcon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame) + 30, self.view.bounds.size.width, 30)];
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];
    _label = lab;
}

- (void)createQRImage {
    [self hideKeyboard];
    UIImage *image = [QRCodeTool createQRImageWithString:_textField.text size:_imageView.bounds.size];
    _imageView.image = image;
}

- (void)changeColor {
    [self hideKeyboard];
    UIImage *image = [QRCodeTool changeColorWithQRImage:_imageView.image backColor:[UIColor cyanColor] frontColor:[UIColor purpleColor]];
    _imageView.image = image;
}

- (void)addSmallIcon {
    [self hideKeyboard];
    UIImage *image = [QRCodeTool addSmallIconToQRImage:_imageView.image smallIcon:[UIImage imageNamed:@"头像.jpg"]];
    _imageView.image = image;
}

- (void)hideKeyboard {
    [_textField resignFirstResponder];
}

- (void)selectImage {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"设备不支持访问相册");
    }
}

#pragma mark --- picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        _imageView.image = image;
    }];
}

#pragma mark --- 识别二维码
- (void)checkQRCode {
    [self hideKeyboard];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:_imageView.image.CGImage]];
    if (features.count) {
        CIQRCodeFeature *feature = [features firstObject];
        _label.text = feature.messageString;
    } else {
        _label.text = @"not find QRCode";
    }
}

@end
