//
//  UIImage+Crop.h
//  CropImage
//
//  Created by limuyun on 2017/1/11.
//  Copyright © 2017年 biiway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Crop)

/**
 缩放指定大小

 @param newSize 缩放后的尺寸
 @return UIImage
 */
- (UIImage *)resizeImageWithSize:(CGSize)newSize;

/**
 图片圆形裁剪

 @return UIImage
 */
- (UIImage *)ovalClip;
@end
