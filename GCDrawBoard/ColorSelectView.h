//
//  ColorSelectView.h
//  GCDrawBoard
//
//  Created by APPLE on 2017/1/20.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectedColorBlock)(UIColor *color);

@interface ColorSelectView : UIView

@property (assign, nonatomic) DidSelectedColorBlock didSelectedBlock;

@end
