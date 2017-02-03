//
//  GCTextToolBar.m
//  GCDrawBoard
//
//  Created by APPLE on 2017/2/3.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "GCTextToolBar.h"
#import "YBPopupMenu.h"

#define GCDefaultText   @"abc"
#define GCFontCellIdentifier        @"GCFontCellIdentifier"

@interface GCTextToolBar () <UITableViewDelegate, UITableViewDataSource, YBPopupMenuDelegate>

@property (strong, nonatomic) UILabel *currentFontTextLabel;

@property (strong, nonatomic) UIButton *btnFontSize;

@property (strong, nonatomic) UIButton *btnFontSelect;

@property (strong, nonatomic) UIButton *btnFontColorSelect;

@property (strong, nonatomic) UITableView *tableView;

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
    
    NSArray *familys = [UIFont familyNames];
    for (NSString *family in familys) {
        NSArray *names = [UIFont fontNamesForFamilyName: family];
        for (NSString *name in names) {
            NSLog(@"+++++: %@", name);
        }
    }
}

-(void)initData {
    self.fontSizeArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 10; i <= 40; i++) {
        NSString *text = [NSString stringWithFormat: @"%zd", i];
        [self.fontSizeArray addObject: text];
    }
    
    self.fontArray = [[NSMutableArray alloc] init];
    [self.fontArray addObject: [UIFont fontWithName: @"Copperplate-Light" size: 15]];
    [self.fontArray addObject: [UIFont fontWithName: @"Copperplate-Bold" size: 15]];
    [self.fontArray addObject: [UIFont fontWithName: @"Thonburi-Light" size: 15]];
    [self.fontArray addObject: [UIFont fontWithName: @"Thonburi-Bold" size: 15]];
    [self.fontArray addObject: [UIFont fontWithName: @"AppleColorEmoji" size: 15]];
    [self.fontArray addObject: [UIFont fontWithName: @"MarkerFelt-Thin" size: 15]];
    [self.fontArray addObject: [UIFont fontWithName: @"MarkerFelt-Wide" size: 15]];
    [self.fontArray addObject: [UIFont fontWithName: @"Zapfino" size: 15]];
}

-(void)selectFonSize:(UIButton *)sender {
    [self.textArray removeAllObjects];
//    [self.tableView removeFromSuperview];
    self.currentTableStyle = 0;
    
    self.textArray = [self.fontSizeArray mutableCopy];
    
    [YBPopupMenu showRelyOnView: sender titles: self.textArray
                          icons: nil
                      menuWidth: 60
                       delegate: self];
    
//    self.tableView.center = CGPointMake(sender.center.x, -(CGRectGetHeight(self.tableView.frame)) / 2.0);
//    [self addSubview: self.tableView];
}

-(void)selectFont:(UIButton *)sender {
    [self.textArray removeAllObjects];
//    [self.tableView removeFromSuperview];
    self.currentTableStyle = 1;
    
    for (NSInteger i = 0; i < self.fontArray.count; i++) {
        UIFont *font = [self.fontArray[i] fontWithSize: self.btnFontSize.titleLabel.text.floatValue];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString: GCDefaultText
                                                                  attributes: @{NSFontAttributeName             : font,
                                                                                NSForegroundColorAttributeName  : [UIColor blackColor]}];
        [self.textArray addObject: text];
    }
    
    [YBPopupMenu showRelyOnView: sender attributedTitles: self.textArray
                          icons: nil
                      menuWidth: 100
                       delegate: self];
    
//    self.tableView.center = CGPointMake(sender.center.x, -(CGRectGetHeight(self.tableView.frame)) / 2.0);
//    [self addSubview: self.tableView];
}

#pragma getter & setter

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
        _btnFontSize = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMaxX(self.currentFontTextLabel.frame), 0, 30, CGRectGetHeight(self.frame))];
        [_btnFontSize setTitle: [NSString stringWithFormat: @"%g", self.currentFont.pointSize] forState: UIControlStateNormal];
        [_btnFontSize setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [_btnFontSize addTarget: self action: @selector(selectFonSize:) forControlEvents: UIControlEventTouchUpInside];
    }
    
    return _btnFontSize;
}

-(UIButton *)btnFontSelect {
    if (!_btnFontSelect) {
        _btnFontSelect = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMaxX(self.btnFontSize.frame) + 10, 0, 40, CGRectGetHeight(self.frame))];
        [_btnFontSelect setTitle: @"A" forState: UIControlStateNormal];
        _btnFontSelect.titleLabel.font = [UIFont boldSystemFontOfSize: 20];
        [_btnFontSelect addTarget: self action: @selector(selectFont:) forControlEvents: UIControlEventTouchUpInside];
    }
    
    return _btnFontSelect;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, 60, 160)];
        _tableView.backgroundColor = [UIColor yellowColor];
        _tableView.userInteractionEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor lightGrayColor];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
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

#pragma mark --UITableViewDelegate, UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: GCFontCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: GCFontCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = self.textArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    if (self.currentTableStyle == 0) {
        self.currentFont = [self.currentFont fontWithSize: cell.textLabel.text.floatValue];
        [self.btnFontSize setTitle: cell.textLabel.text forState: UIControlStateNormal];
    }
    else {
        self.currentFont = [cell.textLabel.font fontWithSize: self.btnFontSize.titleLabel.text.floatValue];
    }
    
    self.currentFontTextLabel.attributedText = [self sampleText];
    
//    [self.tableView removeFromSuperview];
//    self.tableView = nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
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
}

@end
