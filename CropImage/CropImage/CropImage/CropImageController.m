//
//  CropImageController.m
//  CropImage
//
//  Created by limuyun on 2017/1/10.
//  Copyright © 2017年 biiway. All rights reserved.
//

#import "CropImageController.h"
#import "UIImage+Crop.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface CropImageController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIImage * originalImage;
@end

@implementation CropImageController
- (instancetype)initWithImage:(UIImage *)originalImage delegate:(id)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _originalImage = originalImage;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat height = (ScreenHeight - ScreenWidth)/2.0;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height ,ScreenWidth,ScreenWidth)];
    _scrollView.bouncesZoom = YES;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 3;
    _scrollView.zoomScale = 1;
    _scrollView.delegate = self;
    _scrollView.layer.masksToBounds = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.layer.borderWidth = 1.5;
    _scrollView.layer.borderColor = [UIColor whiteColor].CGColor;
    if (_ovalClip) {
        _scrollView.layer.cornerRadius = ScreenWidth/2.0;
    }
    self.view.layer.masksToBounds = YES;
    if (_originalImage) {
        _imageView = [[UIImageView alloc] initWithImage:_originalImage];
        CGFloat img_width = ScreenWidth;
        CGFloat img_height = _originalImage.size.height * (img_width/_originalImage.size.width);
        CGFloat img_y= (img_height - self.view.bounds.size.width)/2.0;
        _imageView.frame = CGRectMake(0,0, img_width, img_height);
        _imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:_imageView];
        
        
        _scrollView.contentSize = CGSizeMake(img_width, img_height);
        _scrollView.contentOffset = CGPointMake(0, img_y);
        [self.view addSubview:_scrollView];
    }
    [self userInterface];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)userInterface {
    
    CGRect cropframe = _scrollView.frame;
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds cornerRadius:0];
    UIBezierPath * cropPath = [UIBezierPath bezierPathWithRoundedRect:cropframe cornerRadius:0];
    if (_ovalClip) {
        cropPath = [UIBezierPath bezierPathWithOvalInRect:cropframe];
    }
    [path appendPath:cropPath];
    
    CAShapeLayer * layer = [[CAShapeLayer alloc] init];
    layer.fillColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.5].CGColor;
    layer.fillRule=kCAFillRuleEvenOdd;
    layer.path = path.CGPath;
    [self.view.layer addSublayer:layer];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 46, self.view.bounds.size.width, 46)];
    view.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.7];
    [self.view addSubview:view];
    
    UIButton * canncelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    canncelBtn.frame = CGRectMake(0, 0, 60, 44);
    canncelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [canncelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [canncelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [canncelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:canncelBtn];
    
    UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 0, 60, 44);
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [doneBtn setTitle:@"完 成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:doneBtn];
}
#pragma mark -- UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //调整位置
    [self centerContent];
}
- (void)centerContent {
    CGRect imageViewFrame = _imageView.frame;
    
    CGRect scrollBounds = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
    if (imageViewFrame.size.height > scrollBounds.size.height) {
        imageViewFrame.origin.y = 0.0f;
    }else {
        imageViewFrame.origin.y = (scrollBounds.size.height - imageViewFrame.size.height) / 2.0;
    }
    if (imageViewFrame.size.width < scrollBounds.size.width) {
        imageViewFrame.origin.x = (scrollBounds.size.width - imageViewFrame.size.width) /2.0;
    }else {
        imageViewFrame.origin.x = 0.0f;
    }
    _imageView.frame = imageViewFrame;
}
- (void)cancelBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIImage *)cropImage {
    CGPoint offset = _scrollView.contentOffset;
    //图片缩放比例
    CGFloat zoom = _imageView.frame.size.width/_originalImage.size.width;
    //视网膜屏幕倍数相关
    zoom = zoom / [UIScreen mainScreen].scale;
    
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height;
    if (_imageView.frame.size.height < _scrollView.frame.size.height) {//太胖了,取中间部分
        offset = CGPointMake(offset.x + (width - _imageView.frame.size.height)/2.0, 0);
        width = height = _imageView.frame.size.height;
    }
    
    CGRect rec = CGRectMake(offset.x/zoom, offset.y/zoom,width/zoom,height/zoom);
    CGImageRef imageRef =CGImageCreateWithImageInRect([_originalImage CGImage],rec);
    UIImage * image = [[UIImage alloc]initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    if (_ovalClip) {
        image = [image ovalClip];
    }
    return image;
}
- (void)doneBtnClick{
       if (_delegate && [_delegate respondsToSelector:@selector(cropImageDidFinishedWithImage:)]) {
        [_delegate cropImageDidFinishedWithImage:[self cropImage]];
    }
    [self.navigationController popViewControllerAnimated:YES];  
}
#pragma mark - UIStatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
@end

