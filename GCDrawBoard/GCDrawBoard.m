//
//  GCDrawBoard.m
//  GCDrawBoard
//
//  Created by APPLE on 2017/1/20.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "GCDrawBoard.h"
#import "GCTextView.h"

@interface GCDrawBoard () <UIGestureRecognizerDelegate>
{
    UIColor *_lastColor;
    CGFloat _lastLineWidth;
}

@property (strong, nonatomic) NSMutableArray<GCPath *> *paths;

@property (strong, nonatomic) NSMutableArray<GCPath *> *tmpPaths;

@property (strong, nonatomic) NSMutableArray<GCDrawPoint *> *tmpPoints;

@property (strong, nonatomic) NSMutableArray<UIView *> *sViews;

@property (strong, nonatomic) NSMutableArray<UIView *> *tmpsViews;

@property (strong, nonatomic) GCTextView *currentTextView;

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
    
    self.sViews = [NSMutableArray new];
    self.tmpsViews = [NSMutableArray new];
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

-(void)setEndTextEditing:(BOOL)endTextEditing {
    _endTextEditing = endTextEditing;
    if (self.currentTextView) {
        self.currentTextView.enableEditing = !_endTextEditing;
    }
}

#pragma mark --actions

-(void)clearAll {
    [self.paths removeAllObjects];
    if (!self.enableDraw) {
        for (GCTextView *textView in self.sViews) {
            [textView removeFromSuperview];
        }
        [self.sViews removeAllObjects];
    }
    
    [self setNeedsDisplay];
}

-(void)revoke {
    GCPath *tmpPath = [self.paths lastObject];
    if (tmpPath) {
        [self.tmpPaths addObject: tmpPath];
    }
    
    if (!self.enableDraw) {
        GCTextView *textView = (GCTextView *)[self.sViews lastObject];
        if (textView) {
            [self.tmpsViews addObject: textView];
        }
        
        [textView removeFromSuperview];
        [self.sViews removeLastObject];
    }
    
    [self.paths removeLastObject];
    [self setNeedsDisplay];
}

-(void)reSume {
    GCPath *tmpPath = [self.tmpPaths lastObject];
    if (tmpPath) {
        [self.paths addObject: tmpPath];
    }
    
    if (!self.enableDraw) {
        GCTextView *textView = (GCTextView *)[self.tmpsViews lastObject];
        if (textView) {
            [self addSubview: textView];
            [self.sViews addObject: textView];
        }
        
        [self.tmpsViews removeLastObject];
    }
    
    [self.tmpPaths removeLastObject];
    [self setNeedsDisplay];
}

#pragma mark --Touch
-(CGPoint)touchPoint:(NSSet<UITouch *> *)touch {
    return [[touch anyObject] locationInView: self];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [self touchPoint: touches];
    if (!self.enableDraw) {
        if (self.currentTextView && !CGRectContainsPoint(self.frame, [[touches anyObject] locationInView: self.currentTextView])) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.currentTextView resignFirstResponder];
            });
        }
        return;
    }
    
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

#pragma mark --GCTextView options

-(void)addNewTextViewWithFont:(UIFont *)textFont andTextColot:(UIColor *)textColor {
    if (self.currentTextView) {
        self.currentTextView.enableEditing = NO;
    }
    
    GCTextView *textView = [[GCTextView alloc] initWithFrame: CGRectMake(0, 0, CGRectGetWidth(self.frame) - 80, 50)];
    textView.textFont = textFont;
    textView.textColor = textColor;
    textView.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0);
    [self addSubview: textView];
    
    [self.sViews addObject: textView];
    self.currentTextView = textView;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    [panGestureRecognizer setDelegate: self];
    [self.currentTextView addGestureRecognizer:panGestureRecognizer];
    
    __weak typeof(self) weakSelf = self;
    textView.didEndEditingBlock = ^{
        [weakSelf.currentTextView resignFirstResponder];
//        weakSelf.currentTextView = nil;
    };
}

//如果是插入文本状态，可以修改当前文字的字体和颜色
-(void)changTextFont:(UIFont *)newFont textColor:(UIColor *) newColor {
    if (self.currentTextView) {
        if (newFont) {
            self.currentTextView.textFont = newFont;
        }
        
        if (newColor) {
            self.currentTextView.textColor = newColor;
        }
    }
}

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGRect frame = recognizer.view.frame;
        
        if (CGRectGetWidth(frame) < CGRectGetWidth(self.frame)) {
            if (CGRectGetMaxX(frame) + translation.x > CGRectGetWidth(self.frame)
                || CGRectGetMinX(frame) + translation.x < 0) {
                translation.x = 0;
            }
        }
        else {
            if (CGRectGetMaxX(frame) + translation.x < CGRectGetWidth(self.frame)
                || CGRectGetMinX(frame) + translation.x > 0) {
                translation.x = 0;
            }
        }
        
        if (CGRectGetHeight(frame) < CGRectGetHeight(self.frame)) {
            if ((CGRectGetMaxY(frame)+translation.y > CGRectGetHeight(self.frame))
                || (CGRectGetMinY(frame) + translation.y) < 0) {
                translation.y = 0;
            }
        }
        else {
            if ((CGRectGetMaxY(frame)+translation.y < CGRectGetHeight(self.frame))
                || (CGRectGetMinY(frame) + translation.y) > 0) {
                translation.y = 0;
            }
        }
        
        CGAffineTransform transform = CGAffineTransformTranslate(recognizer.view.transform, translation.x, translation.y);
        [recognizer.view setTransform: transform];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }
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
