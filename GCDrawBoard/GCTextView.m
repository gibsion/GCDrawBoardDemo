//
//  GCTextView.m
//  GCDrawBoard
//
//  Created by APPLE on 2017/2/4.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "GCTextView.h"

@interface GCTextView () <UITextViewDelegate>

@property (strong, nonatomic) UITextView *textView;

@end

@implementation GCTextView


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor yellowColor].CGColor;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview: self.textView];
    }
    
    return self;
}

-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame: self.bounds];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.scrollsToTop = YES;
        _textView.scrollEnabled = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.backgroundColor = [UIColor clearColor];
    }
    
    return _textView;
}

#pragma mark -- setter & getter

-(void)setEnableEditing:(BOOL)enableEditing {
    _enableEditing = enableEditing;
    self.textView.editable = _enableEditing;
    if (!enableEditing) {
        self.layer.borderWidth = 0;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        if (self.textView.text.length <= 0) {
            [self removeFromSuperview];
        }
    }
    else {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor yellowColor].CGColor;
    }
}

-(void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    self.textView.font = _textFont;
    [self resizeTextViewWithText: self.textView.text];
}

-(void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textView.textColor = _textColor;
}

-(void)resizeTextViewWithText:(NSString *) newText {
    CGSize textSize = [self sizeOfText: newText font: self.textView.font width: CGRectGetWidth(self.textView.frame)];
    if (textSize.height > 50) {
        CGRect frame = self.frame;
        frame.size.height = textSize.height;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.frame = frame;
            self.textView.frame = self.bounds;
        });
    }
}

#pragma mark --UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor yellowColor].CGColor;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.layer.borderWidth = 0;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    if (self.didEndEditingBlock) {
        self.didEndEditingBlock();
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString: @"\n"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [textView resignFirstResponder];
        });
        
        return NO;
    }

    NSString *newText = [NSString stringWithFormat: @"%@%@",textView.text, text];
    [self resizeTextViewWithText: newText];
    return YES;
}

/**
 *  计算字符串长度，字符串自适应高度
 *
 *  @param text  需要计算的字符串
 *  @param size  字号大小
 *  @param width 最大宽度
 *
 *  @return 返回大小
 */
-(CGSize)sizeOfText:(NSString *)text font:(UIFont *)font width:(CGFloat)width
{
    NSDictionary *send = @{NSFontAttributeName: font};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(width, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:send context:nil].size;
    
    return textSize;
}

@end
