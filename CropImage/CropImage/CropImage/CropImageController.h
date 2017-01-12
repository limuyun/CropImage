//
//  CropImageController.h
//  CropImage
//
//  Created by limuyun on 2017/1/10.
//  Copyright © 2017年 biiway. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CropImageDelegate <NSObject>

- (void)cropImageDidFinishedWithImage:(UIImage *)image;

@end

@interface CropImageController : UIViewController

@property (nonatomic, weak) id <CropImageDelegate> delegate;
//圆形裁剪，默认NO;
@property (nonatomic, assign) BOOL ovalClip;
- (instancetype)initWithImage:(UIImage *)originalImage delegate:(id)delegate;
@end
