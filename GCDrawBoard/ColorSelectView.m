//
//  ColorSelectView.m
//  GCDrawBoard
//
//  Created by APPLE on 2017/1/20.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "ColorSelectView.h"

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define ColorCellIdentifier      @"ColorCellIdentifier"

@interface ColorSelectView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *colors;

@end

@implementation ColorSelectView

-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    [self initData];
    [self initSubViews];
    return  self;
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

-(void)initSubViews {
    [self addSubview: self.collectionView];
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.bounds.size.height, self.bounds.size.height);
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame: self.bounds collectionViewLayout: flowLayout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.userInteractionEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier: ColorCellIdentifier];
    }
    
    return _collectionView;
}

-(void)initData {
    self.colors = [NSMutableArray new];
    NSInteger colorValues[] = {0xFF0000,
                               0xFF34B3,
                               0xFF00FF,
                               0xFF83FA,
                               0xFFBBFF,
                               0xFFFF00,
                               0xFFF68F,
                               0x3A5FCD,
                               0x3A5FCD,
                               0x1E90FF,
                               0x00F5FF,
                               0x00CD00,
                               0x00EE00,
                               0x00FF00,
                               0x006400,
                               0x000000,
                               0x7A8B8B,
                               0x8A2BE2,
                               0x912CEE,
                               0x9B30FF,
                               0x9F79EE
                                };
    for (NSInteger i = 0; i < sizeof(colorValues)/sizeof(NSInteger); i++) {
        [self.colors addObject: HexRGBAlpha(colorValues[i], 1.0)];
    }
    
    self.currentColor = self.colors[0];
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"numberOfItemsInSection %zd", self.colors.count);
    
    return self.colors.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: ColorCellIdentifier forIndexPath: indexPath];
    cell.contentView.backgroundColor = self.colors[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select color !!!");
    if (self.didSelectedBlock){
        _currentColor = self.colors[indexPath.item];
        _didSelectedBlock(self.colors[indexPath.item]);
    }
}

@end
