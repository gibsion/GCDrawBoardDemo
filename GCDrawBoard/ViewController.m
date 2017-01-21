//
//  ViewController.m
//  GCDrawBoard
//
//  Created by APPLE on 2017/1/20.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "ViewController.h"
#import "GCDrawBoard.h"
#import "GCDrawBoardToolBar.h"

@interface ViewController ()

@property (strong, nonatomic) GCDrawBoard *drawBoard;
@property (strong, nonatomic) GCDrawBoardToolBar *drawBoardToolBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    self.drawBoard = [[GCDrawBoard alloc] initWithFrame: CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 44 * 2 - 64)];
    [self.view addSubview: self.drawBoard];
    
    self.drawBoardToolBar = [[GCDrawBoardToolBar alloc] initWithDrawBoardView: self.drawBoard Frame: CGRectMake(0, self.view.bounds.size.height - 44 * 2, self.view.bounds.size.width, 44 * 2)];
    [self.view addSubview: self.drawBoardToolBar];
    
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"tuya"]];
    self.navigationItem.titleView = titleImageView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
