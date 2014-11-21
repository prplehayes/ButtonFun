//
//  ColorManager.m
//  ButtonFun
//
//  Created by Chris Hayes on 11/20/14.
//  Copyright (c) 2014 com.DiscoSample. All rights reserved.
//

#import "ColorManager.h"

@implementation ColorManager

+ (UIColor *)randomColor {
    // Generates a random UIColor
    // Uses the Macros for min and max DEC values for the color and generates random R, G, and B values between those
    // (and then divides by 255 to get a float used for colorWithRed: green: blue: alpha:
    // We keep alpha at 1.0 throughout the app
    
    CGFloat redFloat = (MACRO_RED_MIN + arc4random() % (MACRO_RED_MAX - MACRO_RED_MIN)) / 255.0;
    CGFloat greenFloat = (MACRO_GREEN_MIN + arc4random() % (MACRO_GREEN_MAX - MACRO_GREEN_MIN)) / 255.0;
    CGFloat blueFloat = (MACRO_BLUE_MIN + arc4random() % (MACRO_BLUE_MAX - MACRO_BLUE_MIN)) / 255.0;
    return [UIColor colorWithRed:redFloat green:greenFloat blue:blueFloat alpha:1.0];
}

+ (UIColor *)averageColorFromColors:(NSArray *)colorArray {
    // Returns the 'average' color of the UIColors in a given array

    if ([colorArray isKindOfClass:[NSNull class]] || !colorArray || ![colorArray isKindOfClass:[NSArray class]]) {
        // If our array wasn't good, just return white
        NSLog(@"White. What'd you expect asking me to average %@?",colorArray);
        return [UIColor whiteColor];
    }
    
    // block variables for keeping running totals during enumeration
    __block NSInteger count = 0;
    __block CGFloat redTotal = 0.0;
    __block CGFloat greenTotal = 0.0;
    __block CGFloat blueTotal = 0.0;
    [colorArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[UIColor class]]) return; // make sure we got a UIColor
        count++;
        CGFloat red = 1.0, green = 1.0, blue = 1.0, alpha = 1.0;
        UIColor *color = (UIColor *)obj;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        redTotal += red;
        greenTotal += green;
        blueTotal += blue;
    }];
    
    // Being defensive here in case all input was non-UIColors.
    if (count == 0) {
        NSLog(@"White. What'd you expect asking me to average %@?",colorArray);
        return [UIColor whiteColor];
    }
    
    // We know we have a >0 count, so find the average by taking the RGB running totals and divide by count
    CGFloat redAverageFloat = redTotal / count;
    CGFloat greenAverageFloat = greenTotal / count;
    CGFloat blueAverageFloat = blueTotal / count;
    // Return 'average' UIColor
    return [UIColor colorWithRed:redAverageFloat green:greenAverageFloat blue:blueAverageFloat alpha:1.0];
}

+ (BOOL)isColor:(UIColor *)firstColor equalToColor:(UIColor *)secondColor {
    // Tests to see if the R, G, and B colors respectively are within the MACRO tolerance.
    // If so, the colors are determined equal, return TRUE
    
    CGFloat firstColorRed = 1.0, firstColorGreen = 1.0, firstColorBlue = 1.0, firstColorAlpha = 1.0;
    [firstColor getRed:&firstColorRed green:&firstColorGreen blue:&firstColorBlue alpha:&firstColorAlpha];
    
    CGFloat secondColorRed = 1.0, secondColorGreen = 1.0, secondColorBlue = 1.0, secondColorAlpha = 1.0;
    [secondColor getRed:&secondColorRed green:&secondColorGreen blue:&secondColorBlue alpha:&secondColorAlpha];

    BOOL isColorEqual = (fabsf(firstColorRed - secondColorRed) <= MACRO_EQUAL_COLOR_TOLERANCE && fabsf(firstColorGreen - secondColorGreen) <= MACRO_EQUAL_COLOR_TOLERANCE && fabsf(firstColorBlue - secondColorBlue) <= MACRO_EQUAL_COLOR_TOLERANCE);
    return isColorEqual;
}

@end
