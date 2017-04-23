//
//  UIImage+TalusResize.h
//  Talus
//
//  Created by zengjing on 16/6/3.
//  Copyright © 2016年 devzeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TalusResize)

- (UIImage *)ts_resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

@end
