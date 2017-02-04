//
//  GCTextToolBar.h
//  GCDrawBoard
//
//  Created by APPLE on 2017/2/3.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidChangTextBlock)();

typedef void(^DidEndEditingTextBlock)();

@interface GCTextToolBar : UIView

@property (strong, nonatomic) UIFont *currentFont;

@property (strong, nonatomic) UIColor *currentTextColor;

@property (strong, nonatomic) DidChangTextBlock didChangTextBlock;

@property (strong, nonatomic) DidEndEditingTextBlock didEndEditingTextBlock;

@property (assign, nonatomic) BOOL newEditStart;

@end
