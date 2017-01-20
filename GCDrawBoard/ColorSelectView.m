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
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier: ColorCellIdentifier];
    }
    
    return _collectionView;
}

-(void)initData {
    self.colors = [NSMutableArray new];
    NSInteger colorValues[] = {0xed4040,
                               0xf5973c,
                               0xefe82e,
                               0x7ce331,
                               0x48dcde,
                               0x2877e3,
                               0x9b33e4};
    for (NSInteger i = 0; i < sizeof(colorValues)/sizeof(NSInteger); i++) {
        [self.colors addObject: HexRGBAlpha(colorValues[i], 1.0)];
    }
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
    cell.backgroundColor = self.colors[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.didSelectedBlock){
        _didSelectedBlock(self.colors[indexPath.item]);
//    }
}

@end
