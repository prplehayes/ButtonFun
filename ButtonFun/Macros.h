//
//  Macros.h
//  ButtonFun
//
//  Created by Chris Hayes on 11/20/14.
//  Copyright (c) 2014 com.DiscoSample. All rights reserved.
//

#ifndef ButtonFun_Macros_h
#define ButtonFun_Macros_h

#define MACRO_SQUARE_SIZE 40 // Pixel size of squares
#define MACRO_EQUAL_COLOR_TOLERANCE 5.0f/255.0f // Tolerance allowed to consider colors equal


// MIN / MAX color ranges
// These are DEC values that will be used to form the UIColors
// The values can range from 0 to 255
// They will be used as limits for the random color generation
// 0   -> 0.0
// 255 -> 1.0

// R values
#define MACRO_RED_MIN 0
#define MACRO_RED_MAX 50
// G values
#define MACRO_GREEN_MIN 100
#define MACRO_GREEN_MAX 150
// B values
#define MACRO_BLUE_MIN 150
#define MACRO_BLUE_MAX 255

#endif
