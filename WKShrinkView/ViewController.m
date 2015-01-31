//
//  ViewController.m
//  WKShrinkView
//
//  Created by Maxron on 2015/1/31.
//  Copyright (c) 2015年 Maxron. All rights reserved.
//

#import "ViewController.h"
#import "WKShrinkView.h"

@interface ViewController ()
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) WKShrinkView *floatingView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showFloatingView:(id)sender {
    CGRect theFrame = [[[UIApplication sharedApplication] keyWindow] frame];
    CGRect infoViewFrame = CGRectMake(0, 0, theFrame.size.width, theFrame.size.height);
    
    _infoView = [[UIView alloc] initWithFrame:infoViewFrame];
    _infoView.backgroundColor = [UIColor lightGrayColor];
    
    if (_floatingView != nil)
        [_floatingView removeFromSuperview];
    
    _floatingView = [[WKShrinkView alloc] initWithFrame:theFrame withView:_infoView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_floatingView];
}
@end
