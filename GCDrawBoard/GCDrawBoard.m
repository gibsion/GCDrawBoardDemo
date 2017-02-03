//
//  GCDrawBoard.m
//  GCDrawBoard
//
//  Created by APPLE on 2017/1/20.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "GCDrawBoard.h"

@interface GCDrawBoard ()
{
    UIColor *_lastColor;
    CGFloat _lastLineWidth;
}

@property (strong, nonatomic) NSMutableArray<GCPath *> *paths;

@property (strong, nonatomic) NSMutableArray<GCPath *> *tmpPaths;

@property (strong, nonatomic) NSMutableArray<GCDrawPoint *> *tmpPoints;

@end

@implementation GCDrawBoard

- (void)drawRect:(CGRect)rect {
//    [super drawRect: rect];
    for (GCPath *path in self.paths) {
        [path drawPath];
    }
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.enableDraw = YES;
    [self initData];
    return self;
}

-(void)initData {
    self.paths = [NSMutableArray new];
    self.tmpPaths = [NSMutableArray new];
    self.tmpPoints = [NSMutableArray new];
}

-(void)setIsErase:(BOOL)isErase {
    _isErase = isErase;
    if (_isErase) {
        //保存上次绘制状态
        _lastColor = self.lineColor;
        _lastLineWidth = self.lineWidth;
        //设置橡皮擦属性
        self.lineColor = [UIColor clearColor];
    }else{
        self.shapeType = GCDrawShapeCurve;
        self.lineColor = _lastColor;
        self.lineWidth = _lastLineWidth;
    }
}

#pragma mark --actions

-(void)clearAll {
    [self.paths removeAllObjects];
    [self setNeedsDisplay];
}

-(void)revoke {
    GCPath *tmpPath = [self.paths lastObject];
    if (tmpPath) {
        [self.tmpPaths addObject: tmpPath];
    }
    
    [self.paths removeLastObject];
    [self setNeedsDisplay];
}

-(void)reSume {
    GCPath *tmpPath = [self.tmpPaths lastObject];
    if (tmpPath) {
        [self.paths addObject: tmpPath];
    }
    
    [self.tmpPaths removeLastObject];
    [self setNeedsDisplay];
}

#pragma mark --Touch
-(CGPoint)touchPoint:(NSSet<UITouch *> *)touch {
    return [[touch anyObject] locationInView: self];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.enableDraw) {
        return;
    }
    CGPoint touchPoint = [self touchPoint: touches];
    GCPath *path = [GCPath pathToPoint: touchPoint pathWidth: self.lineWidth isErase: self.isErase];
    path.shapeLayer.strokeColor = self.lineColor.CGColor;
    path.pathColor = self.lineColor;
    [self.paths addObject: path];
    [self.tmpPoints addObject: [GCDrawPoint pointWithCGPoint: touchPoint]];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.enableDraw) {
        return;
    }
    
    CGPoint point = [self touchPoint: touches];
    GCPath *path = [self.paths lastObject];
    
    [path pathLineToPoint: point WithType: self.shapeType];
    
    switch (self.shapeType) {
        case GCDrawShapeCurve:
        {
            [self.tmpPoints addObject: [GCDrawPoint pointWithCGPoint: point]];
        }
            break;
            
        case GCDrawShapeLine:
        case GCDrawShapeEllipse:
        case GCDrawShapeRect:
        {
            if (self.tmpPoints.count > 1) {
                [self.tmpPoints removeLastObject];
            }
        }
            
        default:
            break;
    }
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.enableDraw) {
        return;
    }
    
    CGPoint point = [self touchPoint: touches];
    GCPath *path = [self.paths lastObject];
    
    [path pathLineToPoint: point WithType: self.shapeType];
    [self.tmpPoints removeAllObjects];
}

@end


#pragma mark --GCPath
@interface GCPath()

@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGFloat pathWidth;

@end

@implementation GCPath

+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth isErase:(BOOL)isErase {
    GCPath *path = [GCPath new];
    path.beginPoint = beginPoint;
    path.pathWidth = pathWidth;
    path.isErase = isErase;
    
    UIBezierPath *besierPath = [UIBezierPath bezierPath];
    besierPath.lineWidth = pathWidth;
    besierPath.lineCapStyle = kCGLineCapRound;
    besierPath.lineJoinStyle = kCGLineJoinRound;
    [besierPath moveToPoint: beginPoint];
    path.bezierPath = besierPath;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineWidth = pathWidth;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = besierPath.CGPath;
    path.shapeLayer = shapeLayer;
    
    return path;
}

- (void)pathLineToPoint:(CGPoint)movePoint WithType:(GCDrawShapeType)shapeType {
    //判断绘图类型
    _shapeType = shapeType;
    switch (shapeType) {
        case GCDrawShapeCurve:
        {
            [self.bezierPath addLineToPoint:movePoint];
            if (self.isErase) [self.bezierPath strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
        }
            break;
        case GCDrawShapeLine:
        {
            self.bezierPath = [UIBezierPath bezierPath];
            self.bezierPath.lineCapStyle = kCGLineCapRound;
            self.bezierPath.lineJoinStyle = kCGLineJoinRound;
            self.bezierPath.lineWidth = self.pathWidth;
            [self.bezierPath moveToPoint:self.beginPoint];
            [self.bezierPath addLineToPoint:movePoint];
        }
            break;
        case GCDrawShapeEllipse:
        {
            self.bezierPath = [UIBezierPath bezierPathWithRect:[self getRectWithStartPoint:self.beginPoint endPoint:movePoint]];
            self.bezierPath.lineCapStyle = kCGLineCapRound;
            self.bezierPath.lineJoinStyle = kCGLineJoinRound;
            self.bezierPath.lineWidth = self.pathWidth;
        }
            break;
        case GCDrawShapeRect:
        {
            self.bezierPath = [UIBezierPath bezierPathWithOvalInRect:[self getRectWithStartPoint:self.beginPoint endPoint:movePoint]];
            self.bezierPath.lineCapStyle = kCGLineCapRound;
            self.bezierPath.lineJoinStyle = kCGLineJoinRound;
            self.bezierPath.lineWidth = self.pathWidth;
        }
            break;
        default:
            break;
    }
    self.shapeLayer.path = self.bezierPath.CGPath;
}

- (void)drawPath {
    [self.pathColor set];
    if (self.isErase) [self.bezierPath strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
    [self.bezierPath stroke];
}

- (CGRect)getRectWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    CGPoint orignal = startPoint;
    if (startPoint.x > endPoint.x) {
        orignal = endPoint;
    }
    CGFloat width = fabs(startPoint.x - endPoint.x);
    CGFloat height = fabs(startPoint.y - endPoint.y);
    return CGRectMake(orignal.x , orignal.y , width, height);
}

@end
