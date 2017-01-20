//
//  GCDrawBoard.h
//  GCDrawBoard
//
//  Created by APPLE on 2017/1/20.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDrawPoint.h"

typedef NS_ENUM(NSUInteger, GCDrawShapeType) {
    GCDrawShapeCurve,          //曲线
    GCDrawShapeLine,                //直线
    GCDrawShapeEllipse,             //椭圆
    GCDrawShapeRect                 //矩形
};

@interface GCDrawBoard : UIView

@property (assign, nonatomic) BOOL isErase; //是否是橡皮擦状态, 默认NO

@property (assign, nonatomic) GCDrawShapeType shapeType;    //画笔类型

@property (assign, nonatomic) CGFloat lineWidth;    //画笔宽度

@property (strong, nonatomic) UIColor *lineColor;  //画笔颜色

//清屏
-(void) clearAll;

//撤销上一次的画笔
-(void) revoke;

//恢复上一次撤销的画笔
-(void) reSume;


@end

#pragma mark --GCPath
@interface GCPath : NSObject

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIColor *pathColor;//画笔颜色
@property (nonatomic, assign) BOOL isErase;//橡皮擦
@property (nonatomic, assign) GCDrawShapeType shapeType;

+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth isErase:(BOOL)isErase;//初始化对象

- (void)pathLineToPoint:(CGPoint)movePoint WithType:(GCDrawShapeType)shapeType;//画

- (void)drawPath;//绘制

@end
