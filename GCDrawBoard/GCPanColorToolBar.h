//
//  GCPanColorToolBar.h
//  GCDrawBoard
//
//  Created by APPLE on 2017/2/3.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidChangPanBlock)();

@interface GCPanColorToolBar : UIView

@property (assign, nonatomic) CGFloat panWidth;

@property (strong, nonatomic) UIColor *panColor;

@property (strong, nonatomic) DidChangPanBlock didChangePanBlock;

@end
