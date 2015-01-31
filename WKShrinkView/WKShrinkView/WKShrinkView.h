//
//  WKShrinkView.h
//  WKShrinkView
//
//  Created by Maxron on 2015/1/31.
//  Copyright (c) 2015年 Maxron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKShrinkView : UIView
- (instancetype)initWithFrame:(CGRect)frame withView:(UIView *)view  NS_DESIGNATED_INITIALIZER;

@property (strong, nonatomic) UIView *view;
@end
