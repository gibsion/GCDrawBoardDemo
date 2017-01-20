//
//  GCDrawPoint.m
//  GCDrawBoard
//
//  Created by APPLE on 2017/1/20.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "GCDrawPoint.h"

@implementation GCDrawPoint

+(instancetype)pointWithCGPoint:(CGPoint) point {
    GCDrawPoint *drawPoint = [GCDrawPoint new];
    drawPoint.x = point.x;
    drawPoint.y = point.y;
    
    return  drawPoint;
}

-(CGPoint)CGpoint {
    return CGPointMake(self.x, self.y);
}

@end
