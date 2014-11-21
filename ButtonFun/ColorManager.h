//
//  ColorManager.h
//  ButtonFun
//
//  Created by Chris Hayes on 11/20/14.
//  Copyright (c) 2014 com.DiscoSample. All rights reserved.
//

// The color manager abstracts some of the color functionality

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorManager : NSObject
+ (UIColor *)randomColor;
+ (UIColor *)averageColorFromColors:(NSArray *)colorArray;
+ (BOOL)isColor:(UIColor *)firstColor equalToColor:(UIColor *)secondColor;
@end
