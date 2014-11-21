//
//  ButtonView.h
//  ButtonFun
//
//  Created by Chris Hayes on 11/20/14.
//  Copyright (c) 2014 com.DiscoSample. All rights reserved.
//

// A ButtonView is the square 'button' that changes color when tapped.
// Here it keeps track of its row and column so that when you tap it,
// it knows how to check for its neighbors and get their average color
// Without that extension, this is unnecessary

#import <UIKit/UIKit.h>

@interface ButtonView : UIView
@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger column;

+ (id)initWithRow:(NSInteger)row column:(NSInteger)column;
+ (id)initWithRow:(NSInteger)row column:(NSInteger)column color:(UIColor *)color;
@end
