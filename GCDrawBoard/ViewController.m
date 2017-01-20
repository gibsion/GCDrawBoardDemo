//
//  ViewController.m
//  GCDrawBoard
//
//  Created by APPLE on 2017/1/20.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "ViewController.h"
#import "GCDrawBoard.h"
#import "ColorSelectView.h"

@interface ViewController ()

@property (strong, nonatomic) GCDrawBoard *drawBoard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.drawBoard = [[GCDrawBoard alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
    [self.view addSubview: self.drawBoard];
    
    ColorSelectView *colorView = [[ColorSelectView alloc] initWithFrame: CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    [self.view addSubview: colorView];
    
    colorView.didSelectedBlock = ^(UIColor *color) {
        _drawBoard.lineColor = color;
    };
    
    self.drawBoard.lineColor = [UIColor redColor];
    self.drawBoard.lineWidth = 5;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
