//
//  GCTextToolBar.m
//  GCDrawBoard
//
//  Created by APPLE on 2017/2/3.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "GCTextToolBar.h"
#import "GCColorSelectView.h"
#import "YBPopupMenu.h"

#define GCDefaultText   @"abc"
#define GCFontCellIdentifier        @"GCFontCellIdentifier"

@interface GCTextToolBar () <YBPopupMenuDelegate>
//subviews
@property (strong, nonatomic) UILabel *currentFontTextLabel;

@property (strong, nonatomic) UIButton *btnFontSize;

@property (strong, nonatomic) UIButton *btnFontSelect;

@property (strong, nonatomic) UIButton *btnFontColorSelect;

@property (strong, nonatomic) UIButton *btnEndEditing;

@property (strong, nonatomic) GCColorSelectView *colorSelectView;

//Data
@property (strong, nonatomic) NSMutableArray *textArray;

@property (strong, nonatomic) NSMutableArray *fontSizeArray;

@property (strong, nonatomic) NSMutableArray *fontArray;

@property (assign, atomic) NSInteger currentTableStyle;

@end

@implementation GCTextToolBar

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self initData];
    }
    
    return self;
}

-(void)initSubViews {
    [self addSubview: self.currentFontTextLabel];
    [self addSubview: self.btnFontSize];
    [self addSubview: self.btnFontSelect];
    [self addSubview: self.btnFontColorSelect];
    [self addSubview: self.btnEndEditing];
}

-(void)initData {
    self.fontSizeArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 10; i <= 60; i++) {
        NSString *text = [NSString stringWithFormat: @"%zd", i];
        [self.fontSizeArray addObject: text];
    }
    
    self.fontArray = [[NSMutableArray alloc] init];
    //中文
    [self.fontArray addObject: [UIFont boldSystemFontOfSize: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"DFWaWaSC-W5" size: 18]]; //娃娃体
    //外语
    [self.fontArray addObject: [UIFont fontWithName: @"Zapfino" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"Papyrus" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"Papyrus-Condensed" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"BodoniOrnamentsITCTT" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"SavoyeLetPlain" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"SnellRoundhand-Bold" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"SnellRoundhand" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"SnellRoundhand-Black" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"Cochin-BoldItalic" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"Trebuchet-BoldItalic" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"BradleyHandITCTT-Bold" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"HoeflerText-BlackItalic" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"Chalkduster" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"PartyLetPlain" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"Noteworthy-Bold" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"ChalkboardSE-Bold" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"MarkerFelt-Thin" size: 18]];
    [self.fontArray addObject: [UIFont fontWithName: @"MarkerFelt-Wide" size: 18]];
    
//    UIFont *font = [UIFont boldSystemFontOfSize: 15];
//    NSLog(@"boldSystemFont : %@", font.fontName);
//    NSArray *familys = [UIFont familyNames];
//    for (NSString *family in familys) {
//        NSArray *names = [UIFont fontNamesForFamilyName: family];
//        for (NSString *name in names) {
//            NSLog(@"+++++: %@", name);
//            [self.fontArray addObject: [UIFont fontWithName: name size: 15]];
//        }
//    }
}

-(void)selectFonSize:(UIButton *)sender {
    [self.textArray removeAllObjects];
    self.currentTableStyle = 0;
    
    self.textArray = [self.fontSizeArray mutableCopy];
    
    [YBPopupMenu showRelyOnView: sender titles: self.textArray
                          icons: nil
                      menuWidth: 60
                       delegate: self];
}

-(void)selectFont:(UIButton *)sender {
    [self.textArray removeAllObjects];
    self.currentTableStyle = 1;
    
    for (NSInteger i = 0; i < self.fontArray.count; i++) {
        UIFont *font = self.fontArray[i];//[self.fontArray[i] fontWithSize: self.btnFontSize.titleLabel.text.floatValue];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%@", font.fontName]
                                                                  attributes: @{NSFontAttributeName             : font,
                                                                                NSForegroundColorAttributeName  : [UIColor blackColor]}];
        [self.textArray addObject: text];
    }
    
    [YBPopupMenu showRelyOnView: sender attributedTitles: self.textArray
                          icons: nil
                      menuWidth: 300
                       delegate: self];
}

-(void)selectFontColor:(UIButton *)sender {
    if (_colorSelectView) {
        [self removeColorSelectView];
    }
    else {
        [self addSubview: self.colorSelectView];
    }
}

-(void)removeColorSelectView {
    if (_colorSelectView) {
        [_colorSelectView removeFromSuperview];
        _colorSelectView = nil;
    }
}

-(void)completeEditing:(UIButton *)sender {
    if (self.didEndEditingTextBlock) {
        self.didEndEditingTextBlock();
    }
    
    sender.enabled = NO;
    sender.hidden = YES;
}

#pragma getter & setter

-(void)setNewEditStart:(BOOL)newEditStart {
    _newEditStart = newEditStart;
    self.btnEndEditing.enabled = YES;
    self.btnEndEditing.hidden = NO;
}

-(UILabel *)currentFontTextLabel {
    if (!_currentFontTextLabel) {
        _currentFontTextLabel = [[UILabel alloc] initWithFrame: CGRectMake(15, 0, 60, CGRectGetHeight(self.frame))];
        _currentFontTextLabel.attributedText = [self sampleText];
        _currentFontTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return _currentFontTextLabel;
}

-(NSAttributedString *)sampleText {
    return [[NSAttributedString alloc] initWithString: GCDefaultText attributes: @{NSFontAttributeName : self.currentFont, NSForegroundColorAttributeName : self.currentTextColor}];
}

-(UIButton *)btnFontSize {
    if (!_btnFontSize) {
        _btnFontSize = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMaxX(self.currentFontTextLabel.frame) + 10, 0, 30, CGRectGetHeight(self.frame))];
        [_btnFontSize setTitle: [NSString stringWithFormat: @"%g", self.currentFont.pointSize] forState: UIControlStateNormal];
        [_btnFontSize setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [_btnFontSize addTarget: self action: @selector(selectFonSize:) forControlEvents: UIControlEventTouchUpInside];
    }
    
    return _btnFontSize;
}

-(UIButton *)btnFontSelect {
    if (!_btnFontSelect) {
        _btnFontSelect = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMaxX(self.btnFontSize.frame) + 10, 0, 30, CGRectGetHeight(self.frame))];
        [_btnFontSelect setTitle: @"A" forState: UIControlStateNormal];
        _btnFontSelect.titleLabel.font = [UIFont boldSystemFontOfSize: 20];
        [_btnFontSelect addTarget: self action: @selector(selectFont:) forControlEvents: UIControlEventTouchUpInside];
    }
    
    return _btnFontSelect;
}

-(UIButton *)btnFontColorSelect {
    if (!_btnFontColorSelect) {
        _btnFontColorSelect = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMaxX(self.btnFontSelect.frame) + 10, CGRectGetHeight(self.frame) / 2.0 - 15, 30, 30)];
        _btnFontColorSelect.backgroundColor = [UIColor yellowColor];
        _btnFontColorSelect.layer.cornerRadius = 15;
        _btnFontColorSelect.clipsToBounds = YES;
        [_btnFontColorSelect addTarget: self action: @selector(selectFontColor:) forControlEvents: UIControlEventTouchUpInside];
    }
    
    return _btnFontColorSelect;
}

-(UIButton *)btnEndEditing {
    if (!_btnEndEditing) {
        _btnEndEditing = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetWidth(self.frame) - 60, 0, 40, CGRectGetHeight(self.frame))];
        [_btnEndEditing setBackgroundImage: [UIImage imageNamed: @"icon_selected"] forState: UIControlStateNormal];
        [_btnEndEditing addTarget: self action: @selector(completeEditing:) forControlEvents: UIControlEventTouchUpInside];
    }
    
    return _btnEndEditing;
}

-(GCColorSelectView *)colorSelectView {
    if (!_colorSelectView) {
        _colorSelectView = [[GCColorSelectView alloc] initWithFrame: CGRectMake(self.bounds.size.width/2.0 + 15, 0, self.bounds.size.width / 2.0 - 15*2, 30)];
        _colorSelectView.backgroundColor = [UIColor whiteColor];
        
        __weak typeof(self) weakSelf = self;
        _colorSelectView.didSelectedBlock = ^(UIColor *color) {
            weakSelf.btnFontColorSelect.backgroundColor = color;
            weakSelf.currentTextColor = color;
            [weakSelf removeColorSelectView];
            weakSelf.currentFontTextLabel.attributedText = [weakSelf sampleText];
            if (weakSelf.didChangTextBlock) {
                weakSelf.didChangTextBlock();
            }
        };
        
    }
    
    return _colorSelectView;
}

-(UIFont *)currentFont {
    if (!_currentFont) {
        _currentFont = [UIFont systemFontOfSize: 17];
    }
    
    return _currentFont;
}

-(UIColor *)currentTextColor {
    if (!_currentTextColor) {
        _currentTextColor = [UIColor yellowColor];
    }
    
    return _currentTextColor;
}

-(NSMutableArray *)textArray {
    if (!_textArray) {
        _textArray = [[NSMutableArray alloc] init];
    }
    
    return _textArray;
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (self.currentTableStyle == 0) {
        self.currentFont = [self.currentFont fontWithSize: [self.fontSizeArray[index] floatValue]];
        [self.btnFontSize setTitle: self.fontSizeArray[index] forState: UIControlStateNormal];
    }
    else {
        self.currentFont = [self.fontArray[index] fontWithSize: self.btnFontSize.titleLabel.text.floatValue];
    }
    
    self.currentFontTextLabel.attributedText = [self sampleText];
    
    if (self.didChangTextBlock) {
        self.didChangTextBlock();
    }
}

@end
