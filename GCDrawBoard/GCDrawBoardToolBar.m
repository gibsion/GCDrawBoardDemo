//
//  GCDrawBoardToolBar.m
//  GCDrawBoard
//
//  Created by APPLE on 2017/1/21.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "GCDrawBoardToolBar.h"
#import "GCPanColorToolBar.h"
#import "GCTextToolBar.h"

#define GCToolViewCellIdentifer         @"GCToolViewCellIdentifer"

@interface GCDrawBoardToolBar () <UICollectionViewDelegate, UICollectionViewDataSource>

//sub views
@property (strong, nonatomic) GCDrawBoard *drawBoard;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) GCPanColorToolBar *panColorBarView;

@property (strong, nonatomic) GCTextToolBar *textToolBarView;

//data
@property (strong, nonatomic) NSMutableArray *imgStringArray;

@end

@implementation GCDrawBoardToolBar

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
    [self addSubview: self.panColorBarView];
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

-(GCPanColorToolBar *)panColorBarView {
    if (!_panColorBarView) {
        _panColorBarView = [[GCPanColorToolBar alloc] initWithFrame: CGRectMake(0, 0, self.bounds.size.width, CGRectGetHeight(self.frame) - CGRectGetHeight(self.collectionView.frame))];
        
        self.drawBoard.enableDraw = YES;
        self.drawBoard.isErase = NO;
        self.drawBoard.lineColor = _panColorBarView.panColor;
        self.drawBoard.lineWidth = _panColorBarView.panWidth;
        
         __weak typeof(self) weakSelf = self;
        _panColorBarView.didChangePanBlock = ^{
            weakSelf.drawBoard.isErase = NO;
            weakSelf.drawBoard.lineColor = weakSelf.panColorBarView.panColor;
            weakSelf.drawBoard.lineWidth = weakSelf.panColorBarView.panWidth;
        };
    }
    
    return _panColorBarView;
}

-(GCTextToolBar *)textToolBarView {
    if (!_textToolBarView) {
        _textToolBarView = [[GCTextToolBar alloc] initWithFrame: CGRectMake(0, 0, self.bounds.size.width, CGRectGetHeight(self.frame) - CGRectGetHeight(self.collectionView.frame))];
    }
    
    return _textToolBarView;
}

-(void)initData {
    self.imgStringArray = [NSMutableArray new];
    [self.imgStringArray addObject: @"bi"];
    [self.imgStringArray addObject: @"icon_text"];
    [self.imgStringArray addObject: @"chexiao"];
    [self.imgStringArray addObject: @"qianjin"];
    [self.imgStringArray addObject: @"shanchu"];
    [self.imgStringArray addObject: @"xiangpica"];
    [self.imgStringArray addObject: @"icon_cut"];
}

-(void)showColorSelectView {
    [self removeTextToolBar];
    __weak typeof(self) weakSelf = self;
    
    if (!_panColorBarView) {
        [self addSubview: self.panColorBarView];
        
        self.drawBoard.enableDraw = YES;
        self.drawBoard.lineColor = self.panColorBarView.panColor;
        self.drawBoard.lineWidth = self.panColorBarView.panWidth;
        [UIView animateWithDuration: 0.3 animations:^{
            weakSelf.panColorBarView.frame = CGRectMake(0, 0, self.bounds.size.width, CGRectGetHeight(self.frame) - CGRectGetHeight(self.collectionView.frame));
        }];
    }
//    else {
//        self.drawBoard.enableDraw = NO;
//        [UIView animateWithDuration: 0.3 animations:^{
//            weakSelf.panColorBarView.frame = CGRectMake(0, self.bounds.size.height/4.0, self.bounds.size.width, 0);
//        } completion:^(BOOL finished) {
//            [weakSelf.panColorBarView removeFromSuperview];
//            weakSelf.panColorBarView = nil;
//        }];
//    }
}

-(void)removePanColorBarView {
    if (_panColorBarView) {
        [_panColorBarView removeFromSuperview];
        _panColorBarView = nil;
    }
}

-(void)showTextToolBar {
    self.drawBoard.enableDraw = NO;
    [self removePanColorBarView];
    
    if (!_textToolBarView) {
        [self addSubview: self.textToolBarView];
        
        __weak typeof(self) weakSelf = self;
        self.textToolBarView.didChangTextBlock = ^ {
            [weakSelf.drawBoard changTextFont: weakSelf.textToolBarView.currentFont textColor: weakSelf.textToolBarView.currentTextColor];
        };
        
        self.textToolBarView.didEndEditingTextBlock = ^{
            [weakSelf.drawBoard setEndTextEditing: YES];
        };
    }
    
    self.textToolBarView.newEditStart = YES;
    
    [self.drawBoard addNewTextViewWithFont: self.textToolBarView.currentFont andTextColot: self.textToolBarView.currentTextColor];
}

-(void)removeTextToolBar {
    if (_textToolBarView) {
        [_textToolBarView removeFromSuperview];
        _textToolBarView = nil;
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
            [self showTextToolBar];
        }
            break;
            
        case 2:
        {
            [self revoke];
        }
            break;
            
        case 3:
        {
            [self resume];
        }
            break;
            
        case 4:
        {
            [self clear];
        }
            break;
            
        case 5:
        {
            [self erase];
        }
            break;
            
        case 6:
        {
            //TO DO 裁剪
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
        bgView.backgroundColor = [UIColor colorWithRed: 1 green: 0xBB/255.0 blue: 1 alpha: 0.5];
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
