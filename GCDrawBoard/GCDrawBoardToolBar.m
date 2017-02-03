//
//  GCDrawBoardToolBar.m
//  GCDrawBoard
//
//  Created by APPLE on 2017/1/21.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "GCDrawBoardToolBar.h"
#import "ColorSelectView.h"

#define GCToolViewCellIdentifer         @"GCToolViewCellIdentifer"

@interface GCDrawBoardToolBar () <UICollectionViewDelegate, UICollectionViewDataSource>

//sub views
@property (strong, nonatomic) GCDrawBoard *drawBoard;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) ColorSelectView *colorSelectView;

@property (strong, nonatomic) UIView *panColorView;

@property (strong, nonatomic) UIView *currentPanColorView;

@property (strong, nonatomic) UISlider *slider;

@property (strong, nonatomic) UILabel *panSizeLabel;

//data
@property (strong, nonatomic) NSMutableArray *imgStringArray;

@end

@implementation GCDrawBoardToolBar

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    [self.collectionView setBackgroundColor: [UIColor lightGrayColor]];
}

-(instancetype)initWithDrawBoardView:(GCDrawBoard *)drawBoard Frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.drawBoard = drawBoard;
        [self initData];
        [self initSubViews];
    }
    
    return self;
}

-(void)initSubViews {
    [self addSubview: self.panColorView];
    [self addSubview: self.collectionView];
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize: CGSizeMake(self.bounds.size.height/2.0 - 2, self.bounds.size.height/2.0 - 2)];
        [flowLayout setScrollDirection: UICollectionViewScrollDirectionHorizontal];
        [flowLayout setMinimumLineSpacing: 1];
        [flowLayout setMinimumInteritemSpacing: 1];
        
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(15, self.bounds.size.height/2.0, self.bounds.size.width - 15 * 2, self.bounds.size.height/2.0) collectionViewLayout: flowLayout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.scrollsToTop = YES;
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.userInteractionEnabled = YES;
        [_collectionView registerClass: [GCToolViewCell class] forCellWithReuseIdentifier: GCToolViewCellIdentifer];
    }
    
    return _collectionView;
}

-(UIView *)panColorView {
    if (!_panColorView) {
        _panColorView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.bounds.size.width, CGRectGetHeight(self.frame) - CGRectGetHeight(self.collectionView.frame))];
        
        [_panColorView addSubview: self.currentPanColorView];
        [_panColorView addSubview: self.slider];
        [_panColorView addSubview: self.panSizeLabel];
        [_panColorView addSubview: self.colorSelectView];
    }
    
    return _panColorView;
}

-(UIView *)currentPanColorView {
    if (!_currentPanColorView) {
        _currentPanColorView = [[UIView alloc] initWithFrame: CGRectMake(15, 1, 30, 30)];
        _currentPanColorView.backgroundColor = self.colorSelectView.currentColor;
    }
    
    return _currentPanColorView;
}

-(ColorSelectView *)colorSelectView {
    if (!_colorSelectView) {
        _colorSelectView = [[ColorSelectView alloc] initWithFrame: CGRectMake(self.panColorView.bounds.size.width/2.0 + 15, 0, self.panColorView.bounds.size.width / 2.0 - 15*2, 30)];
    }
    
    return _colorSelectView;
}

-(UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame: CGRectMake(CGRectGetMaxX(self.currentPanColorView.frame) + 10, self.panColorView.bounds.size.height/2.0 - 7, self.panColorView.bounds.size.width/2.0 - 15 * 2 - 20 - CGRectGetWidth(self.currentPanColorView.frame), 12)];
        _slider.thumbTintColor = [UIColor orangeColor];
        _slider.value = 5;
        _slider.minimumValue = 1;
        _slider.maximumValue = 60;
        [_slider addTarget: self action: @selector(changePan:) forControlEvents: UIControlEventValueChanged];
    }
    
    return _slider;
}

-(UILabel *)panSizeLabel {
    if (!_panSizeLabel) {
        _panSizeLabel = [[UILabel alloc] initWithFrame: CGRectMake(CGRectGetMaxX(self.slider.frame) + 10, CGRectGetMidY(self.slider.frame) - 7, 40, 14)];
        _panSizeLabel.textColor = [UIColor whiteColor];
        _panSizeLabel.textAlignment = NSTextAlignmentLeft;
        _panSizeLabel.font = [UIFont systemFontOfSize: 14];
        _panSizeLabel.text = [NSString stringWithFormat: @"%zd", (NSInteger)(self.slider.value)];
    }
    
    return _panSizeLabel;
}


-(void)initData {
    self.imgStringArray = [NSMutableArray new];
    [self.imgStringArray addObject: @"bi"];
    [self.imgStringArray addObject: @"chexiao"];
    [self.imgStringArray addObject: @"qianjin"];
    [self.imgStringArray addObject: @"shanchu"];
    [self.imgStringArray addObject: @"xiangpica"];
}

-(void)changePan:(UISlider *)slider {
//    NSLog(@"slider.value = %g", slider.value);
    self.drawBoard.lineWidth = slider.value;
    _panSizeLabel.text = [NSString stringWithFormat: @"%zd", (NSInteger)(slider.value)];
}

-(void)showColorSelectView {
    __weak typeof(self) weakSelf = self;
    
    if (!_panColorView) {
        [self addSubview: self.panColorView];
        
        self.drawBoard.enableDraw = YES;
        self.drawBoard.lineColor = self.colorSelectView.currentColor;
        self.drawBoard.lineWidth = self.slider.value;
        self.colorSelectView.backgroundColor = [UIColor whiteColor];
        self.colorSelectView.didSelectedBlock = ^(UIColor *color) {
            weakSelf.drawBoard.isErase = NO;
            weakSelf.currentPanColorView.backgroundColor = color;
            weakSelf.drawBoard.lineColor = color;
            weakSelf.drawBoard.lineWidth = weakSelf.slider.value;
        };
        
        [UIView animateWithDuration: 0.3 animations:^{
            weakSelf.panColorView.frame = CGRectMake(0, 0, self.bounds.size.width, CGRectGetHeight(self.frame) - CGRectGetHeight(self.collectionView.frame));
        }];
    }
    else {
        self.drawBoard.enableDraw = NO;
        [UIView animateWithDuration: 0.3 animations:^{
            weakSelf.panColorView.frame = CGRectMake(0, self.bounds.size.height/4.0, self.bounds.size.width, 0);
        } completion:^(BOOL finished) {
            [weakSelf.panColorView removeFromSuperview];
            weakSelf.panColorView = nil;
        }];
    }
}

-(void)revoke {
    if (self.drawBoard) {
        [self.drawBoard revoke];
    }
}

-(void)resume {
    if (self.drawBoard) {
        [self.drawBoard reSume];
    }
}

-(void)clear {
    if (self.drawBoard) {
        [self.drawBoard clearAll];
    }
}

-(void)erase {
    self.drawBoard.isErase = !self.drawBoard.isErase;
}

#pragma mark --UICollectionViewDelegate, UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgStringArray.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GCToolViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: GCToolViewCellIdentifer forIndexPath: indexPath];
    [cell.btnBackImageView setImage: [UIImage imageNamed: self.imgStringArray[indexPath.item]] forState: UIControlStateNormal];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __block UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath: indexPath];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cell.selected = NO;
    });
    
    switch (indexPath.item) {
        case 0:
        {
            [self showColorSelectView];
        }
            break;
            
        case 1:
        {
            [self revoke];
        }
            break;
            
        case 2:
        {
            [self resume];
        }
            break;
            
        case 3:
        {
            [self clear];
        }
            break;
            
        case 4:
        {
            [self erase];
        }
            break;
            
        default:
            break;
    }
}

@end

#pragma GCToolViewCell

@interface GCToolViewCell ()

@end

@implementation GCToolViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnBackImageView = [[UIButton alloc] initWithFrame: self.contentView.bounds];
        self.btnBackImageView.userInteractionEnabled = NO;
        [self.contentView addSubview: self.btnBackImageView];
        
        UIView *bgView = [[UIView alloc] initWithFrame: self.contentView.bounds];
        bgView.backgroundColor = [UIColor blueColor];
        bgView.alpha = 0.2;
        self.selectedBackgroundView = bgView;
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.btnBackImageView.frame = self.contentView.bounds;
}

-(void)prepareForReuse {
    self.btnBackImageView.imageView.image = nil;
    self.selectedBackgroundView = nil;
}

@end
