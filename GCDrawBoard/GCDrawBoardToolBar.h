//
//  GCDrawBoardToolBar.h
//  GCDrawBoard
//
//  Created by APPLE on 2017/1/21.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDrawBoard.h"

@interface GCDrawBoardToolBar : UIView

-(instancetype)initWithDrawBoardView:(GCDrawBoard *)drawBoard Frame:(CGRect)frame;

@end

@interface GCToolViewCell : UICollectionViewCell

@property (strong, nonatomic) UIButton *btnBackImageView;

@end
