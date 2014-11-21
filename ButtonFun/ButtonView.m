//
//  ButtonView.m
//  ButtonFun
//
//  Created by Chris Hayes on 11/20/14.
//  Copyright (c) 2014 com.DiscoSample. All rights reserved.
//

#import "ButtonView.h"
#import "ColorManager.h"

@implementation ButtonView

+ (id)initWithRow:(NSInteger)row column:(NSInteger)column {
    // No color specified, so initialize with a random color
    return [ButtonView initWithRow:row column:column color:[ColorManager randomColor]];
}

+ (id)initWithRow:(NSInteger)row column:(NSInteger)column color:(UIColor *)color {
    // Initial the button view with a given row, column, and color
    // We should probably take the rect's x and y as inputs, but since we're only using this class within the main View Controller, we know the x and y can be calculated by the row and column
    ButtonView *buttonView = [[ButtonView alloc] initWithFrame:CGRectMake(column*MACRO_SQUARE_SIZE, row*MACRO_SQUARE_SIZE, MACRO_SQUARE_SIZE, MACRO_SQUARE_SIZE)];
    if (buttonView) {
        buttonView.row = row;
        buttonView.column = column;
        [buttonView setBackgroundColor:color];
    }
    return buttonView;
}
@end
