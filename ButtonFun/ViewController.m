//
//  ViewController.m
//  ButtonFun
//
//  Created by Chris Hayes on 11/20/14.
//  Copyright (c) 2014 com.DiscoSample. All rights reserved.
//


#import "ViewController.h"
#import "ColorManager.h"
#import "ButtonView.h"

@interface ViewController ()

@property (nonatomic, retain) NSMutableArray *buttonViewArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ColorManager averageColorFromColors:@[@"hi"]];
    [self layoutSquares];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)buttonViewArray {
    // This array is a 2D representation of all the button views.
    // It's used to find a given view's neighbors to set their color if needed
    if (!_buttonViewArray) {
        _buttonViewArray = [NSMutableArray arrayWithCapacity:[self totalTiles]];
    }
    return _buttonViewArray;
}

- (void)layoutSquares {
    // This calculates how many rows and columns we need and generates those views.
    // As the views are being created, the _buttonViewArray gets populated
    // Prior to any view creation, we remove all previous views and
    
    // Reset buttonViewArray
    _buttonViewArray = nil;
    
    // Iterate over all ButtonViews and remove them and their recognizers
    for (UIView *view in self.view.subviews) {
        if (![view isKindOfClass:[ButtonView class]]) continue;
        for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
            [view removeGestureRecognizer:recognizer];
        }
        [view removeFromSuperview];
    }
    
    NSInteger numRows = [self numRows];
    NSInteger numColumns = [self numColumns];
    
    // Iterate over the columns and rows and create squares
    for (NSInteger col = 0; col < numColumns; col++) {
        for (NSInteger row = 0; row < numRows; row++) {
            if (col == 0) {
                // For debugging, this makes buttonViewArray 2D in the form of [row][column]
                // If it's the first column, for every row, make [row] a new mutable array
                [self.buttonViewArray addObject:[NSMutableArray arrayWithCapacity:numRows]];
            }
            // Create the ButtonView with default randomColor
            ButtonView *button = [ButtonView initWithRow:row column:col];
            
            // Create tap gesture recognizer (no UIButton!) to change tile color
            // and add it to view
            // action is tileTapped:
            UITapGestureRecognizer *tapButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTapped:)];
            [button addGestureRecognizer:tapButton];

            // Create long press gesture recognizer to seed new tile color
            // and add it to view. In case somehow all tiles end up same color, this gives new interaction
            // action is tileLongPressed:
            UILongPressGestureRecognizer *longPressButton = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tileLongPressed:)];
            [button addGestureRecognizer:longPressButton];
            [self.view addSubview:button];
            
            // Get the buttonViewArray's row, update it with the new column, and set it back
            // Again, this is to make [row][column] more logical
            NSMutableArray *rowArray = [self.buttonViewArray objectAtIndex:row];
            [rowArray addObject:button];
            [self.buttonViewArray replaceObjectAtIndex:row withObject:rowArray];
        }
    }
}

- (CGFloat)viewWidth {
    return self.view.frame.size.width;
}

- (CGFloat)viewHeight {
    return self.view.frame.size.height;
}

- (NSInteger)numRows {
    // The number of rows required to fill the device horizontally
    // We could do things like use floor and then find an offset to pad the squares, but for now we just fill the space
    return (NSInteger)ceil([self viewHeight] / MACRO_SQUARE_SIZE);
}

- (NSInteger)numColumns {
    // The number of columns required to fill the device vertically
    // We could do things like use floor and then find an offset to pad the squares, but for now we just fill the space
    return (NSInteger)ceil([self viewWidth] / MACRO_SQUARE_SIZE);
}

- (NSInteger)totalTiles {
    // The total number of squares required to fill the device
    return [self numRows] * [self numColumns];
}

- (void)tileTapped:(id)sender {
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    ButtonView *buttonView = (ButtonView *)gesture.view;

// Uncomment the following two lines and it will behave as requested in the readme
//    [buttonView setBackgroundColor:[ColorManager randomColor]];
//    return;
    
// If you've gotten this far, let's have some fun.
// Let's make the square change to the average of the squares around it
    [self makeButtonViewTheAverageColorOfNeighbors:buttonView];
}

- (void)tileLongPressed:(id)sender {
    // Reset the sqare to some new color
    UILongPressGestureRecognizer *gesture = (UILongPressGestureRecognizer *)sender;
    // Only want this to run the first time the gesture fires
    if (gesture.state == UIGestureRecognizerStateBegan){
        ButtonView * buttonView = (ButtonView *)gesture.view;
        [buttonView setBackgroundColor:[ColorManager randomColor]];
    }
}

- (void)makeButtonViewTheAverageColorOfNeighbors:(ButtonView *)buttonView {
    // Check to see how many neighbors the square has and then generate the average RGB color of the neighbors
    // If the color of the tile is already the average of its neighbors (already been tapped),
    // then set the neighbors to the center tile's color
    
    // surroundingSquaresArray is an Array of UIColors
    // it's used to pass to the ColorManager so it can calculate the average color
    NSMutableArray *surroundingSquaresArray = [NSMutableArray arrayWithCapacity:4];
    
    // Initialize the neighbors, we will check for nil later
    ButtonView *leftNeighbor;
    ButtonView *topNeighbor;
    ButtonView *rightNeighbor;
    ButtonView *bottomNeighbor;
    
    if (buttonView.row > 0) { // a left neighbor exists
        leftNeighbor = (ButtonView *)self.buttonViewArray[buttonView.row - 1][buttonView.column];
        // add left's UIColor to our surrounding array
        [surroundingSquaresArray addObject:leftNeighbor.backgroundColor];
    }
    if (buttonView.column > 0) { // a top neighbor exists
        topNeighbor = (ButtonView *)self.buttonViewArray[buttonView.row][buttonView.column - 1];
        // add top's UIColor to our surrounding array
        [surroundingSquaresArray addObject:topNeighbor.backgroundColor];
    }
    if (buttonView.row < [self numRows] - 1) { // a right neighbor exists
        rightNeighbor = (ButtonView *)self.buttonViewArray[buttonView.row + 1][buttonView.column];
        // add right's UIColor to our surrounding array
        [surroundingSquaresArray addObject:rightNeighbor.backgroundColor];
    }
    if (buttonView.column < [self numColumns] - 1) { // a bottom neighbor exists
        bottomNeighbor = (ButtonView *)self.buttonViewArray[buttonView.row][buttonView.column + 1];
        // add bottom's UIColor to our surrounding array
        [surroundingSquaresArray addObject:bottomNeighbor.backgroundColor];
    }
    
    // Generate our new 'average' color
    UIColor *newColor = [ColorManager averageColorFromColors:surroundingSquaresArray];
    
    // Test to see if the color is already set to the average of its neighbors
    if ([ColorManager isColor:buttonView.backgroundColor equalToColor:newColor]) {
        // The tapped tile is already 'average', set its neighbors if they exist
        if (leftNeighbor) [leftNeighbor setBackgroundColor:newColor];
        if (topNeighbor) [topNeighbor setBackgroundColor:newColor];
        if (rightNeighbor) [rightNeighbor setBackgroundColor:newColor];
        if (bottomNeighbor) [bottomNeighbor setBackgroundColor:newColor];
    } else {
        // Set the tapped tile's color to average
        [buttonView setBackgroundColor:newColor];
    }
}

- (void)didRotate:(NSNotification *)notification
{
    // Our rotation notification observer
    // We could just have layoutSquares observe, but in the readme, I wasn't sure what you wanted to 'handle' rotation
    // If we just unchecked the non-portrait device orientations in the Project Settings, the app would still basically function the same. By not supporting rotation, it kind of would...ya know?
    // So anyway, if I'm reading it wrong, here's where other 'handling' would go
    [self layoutSquares];
    //I'm just generating new squares here. If I had more time, I'd detect which way they went and transform my _buttonViewArray and lay the squares out so they were in the same place as you'd expect them to be after the rotation
}

@end
