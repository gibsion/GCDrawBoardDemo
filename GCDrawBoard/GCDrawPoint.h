//
//  GCDrawPoint.h
//  GCDrawBoard
//
//  Created by APPLE on 2017/1/20.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GCDrawPoint : NSObject

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;

+(instancetype)pointWithCGPoint:(CGPoint) point;

-(CGPoint)CGpoint;

@end
