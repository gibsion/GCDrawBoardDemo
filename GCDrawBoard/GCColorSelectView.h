//
//  GCColorSelectView.h
//  GCDrawBoard
//
//  Created by APPLE on 2017/1/20.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

typedef void(^DidSelectedColorBlock)(UIColor *color);

@interface GCColorSelectView : UIView

@property (strong, nonatomic) UIColor *currentColor;

@property (strong, nonatomic) DidSelectedColorBlock didSelectedBlock;

@end
