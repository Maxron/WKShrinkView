//
//  WKShrinkView.m
//  WKShrinkView
//
//  Created by Maxron on 2015/1/31.
//  Copyright (c) 2015年 Maxron. All rights reserved.
//

#import "WKShrinkView.h"

#define SIDE_MARGIN 10
#define ThumbnailViewWidth  160
#define ThumbnailViewHeight 90

@implementation WKShrinkView
{
    CGRect originalFrame;
    BOOL isFullScreen;
}

-(instancetype) initWithFrame:(CGRect)frame withView:(UIView *)view {
    self = [super initWithFrame:frame];
    if (self) {
        _view = view;
        originalFrame = frame;
        isFullScreen = YES;
        [self setAutoresizesSubviews:YES];
        
        [self addSubview:_view];
        [self addGestureOfView];
    }
    return self;
}

#pragma mark
#pragma mark - Add Gesture
-(void)addGestureOfView {
    [self addSwipeDownGestureForView];
    [self addSwipeUpGestureForView];
}

-(void)addSwipeDownGestureForView {
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(minimizeView)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self addGestureRecognizer:swipeDown];
}

-(void)addSwipeUpGestureForView {
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(maximizeView:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:swipeUp];
}

#pragma mark
#pragma mark - Maximized View
- (void)maximizeView:(UIPanGestureRecognizer *)recognizer {
    if (isFullScreen) {
        return;
    }
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.view.frame = originalFrame;
        [self removeRemoveGestureFromView];
    } completion:^(BOOL finished) {
        isFullScreen = YES;
    }];
}

-(void)removeRemoveGestureFromView {
    [self removeGestureFromViewWithDirection:UISwipeGestureRecognizerDirectionLeft];
    [self removeGestureFromViewWithDirection:UISwipeGestureRecognizerDirectionRight];
}

-(void)removeGestureFromViewWithDirection:(UISwipeGestureRecognizerDirection)direction {
    for (UIGestureRecognizer * gesture in self.gestureRecognizers) {
        if ([self isGesture:gesture matchSwipeDirection:direction]) {
            [self removeGestureRecognizer:gesture];
        }
    }
}

-(BOOL)isGesture:(UIGestureRecognizer *)gesture matchSwipeDirection:(UISwipeGestureRecognizerDirection)direction {
    BOOL result = NO;
    if ([gesture isKindOfClass:[UISwipeGestureRecognizer class]]) {
        if ( [(UISwipeGestureRecognizer *)gesture direction] == direction) {
            result = YES;
        }
    }
    return result;
}

#pragma mark
#pragma mark - Minimized View
- (void)minimizeView {
    if (!isFullScreen) {
        return;
    }
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGFloat x = self.view.frame.size.width - ThumbnailViewWidth - SIDE_MARGIN;
        CGFloat y = self.view.frame.size.height - ThumbnailViewHeight - SIDE_MARGIN;
        CGRect containerFrame = CGRectMake(x, y, ThumbnailViewWidth, ThumbnailViewHeight);
        self.view.frame = containerFrame;
        
        [self addRemoveGestureOfView];
    } completion:^(BOOL finished) {
        isFullScreen = NO;
    }];
}

-(void)addRemoveGestureOfView {
    [self addGestureRecognizer:[self createSwipeLeftGesture]];
    [self addGestureRecognizer:[self createSwipeRightGesture]];
}

-(UISwipeGestureRecognizer *)createSwipeLeftGesture {
    return [self createSwipeGestureOfRemoveViewWithGestureDirection:UISwipeGestureRecognizerDirectionLeft];
}

-(UISwipeGestureRecognizer *)createSwipeRightGesture {
    return [self createSwipeGestureOfRemoveViewWithGestureDirection:UISwipeGestureRecognizerDirectionRight];
}

-(UISwipeGestureRecognizer *)createSwipeGestureOfRemoveViewWithGestureDirection:(UISwipeGestureRecognizerDirection)direction {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removeThumbnailView)];
    [swipeGesture setDirection:direction];
    
    return swipeGesture;
}

- (void)removeThumbnailView
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark
#pragma mark - overridden
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil) {
                return result;
            }
        }
    }
    return nil;
}

@end
