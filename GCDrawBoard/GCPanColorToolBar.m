//
//  GCPanColorToolBar.m
//  GCDrawBoard
//
//  Created by APPLE on 2017/2/3.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "GCPanColorToolBar.h"
#import "GCColorSelectView.h"

@interface GCPanColorToolBar ()

@property (strong, nonatomic) GCColorSelectView *colorSelectView;

@property (strong, nonatomic) UIView *currentPanColorView;

@property (strong, nonatomic) UISlider *slider;

@property (strong, nonatomic) UILabel *panSizeLabel;

@end

@implementation GCPanColorToolBar

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self initData];
    }
    
    return self;
}

-(void)initSubViews {
    [self addSubview: self.currentPanColorView];
    [self addSubview: self.slider];
    [self addSubview: self.panSizeLabel];
    [self addSubview: self.colorSelectView];
}

-(void)initData {
    self.panColor = self.colorSelectView.currentColor;
    self.panWidth = self.slider.value;
}

-(UIView *)currentPanColorView {
    if (!_currentPanColorView) {
        _currentPanColorView = [[UIView alloc] initWithFrame: CGRectMake(15, 1, 30, 30)];
        _currentPanColorView.backgroundColor = self.colorSelectView.currentColor;
    }
    
    return _currentPanColorView;
}

-(GCColorSelectView *)colorSelectView {
    if (!_colorSelectView) {
        _colorSelectView = [[GCColorSelectView alloc] initWithFrame: CGRectMake(self.bounds.size.width/2.0 + 15, 0, self.bounds.size.width / 2.0 - 15*2, 30)];
        _colorSelectView.backgroundColor = [UIColor whiteColor];
        
        __weak typeof(self) weakSelf = self;
        _colorSelectView.didSelectedBlock = ^(UIColor *color) {
            weakSelf.panColor = color;
            weakSelf.currentPanColorView.backgroundColor = color;
            if (weakSelf.didChangePanBlock) {
                weakSelf.didChangePanBlock();
            }
        };

    }
    
    return _colorSelectView;
}

-(UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame: CGRectMake(CGRectGetMaxX(self.currentPanColorView.frame) + 10, self.bounds.size.height/2.0 - 7, self.bounds.size.width/2.0 - 15 * 2 - 20 - CGRectGetWidth(self.currentPanColorView.frame), 12)];
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

-(void)changePan:(UISlider *)slider {
    self.panWidth = slider.value;
    _panSizeLabel.text = [NSString stringWithFormat: @"%zd", (NSInteger)(slider.value)];
    if (self.didChangePanBlock) {
        self.didChangePanBlock();
    }
}

@end
