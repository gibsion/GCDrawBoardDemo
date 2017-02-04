//
//  GCTextView.h
//  GCDrawBoard
//
//  Created by APPLE on 2017/2/4.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidEndEditingBlock)();

@interface GCTextView : UIView

@property (strong, nonatomic) UIFont *textFont;

@property (strong, nonatomic) UIColor *textColor;

@property (strong, nonatomic) DidEndEditingBlock didEndEditingBlock;

@property (assign, nonatomic) BOOL enableEditing;      //是否允许编辑

@end
