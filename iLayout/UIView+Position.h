//
//  UIView+Position.h
//
//  Created by Kevin Zhang on 10/27/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewData : NSObject
@property(assign, nonatomic) BOOL useCssLayout;
@property(strong, nonatomic) NSLayoutConstraint* widthConstraint;
@property(strong, nonatomic) NSLayoutConstraint* heightConstraint;
@property(strong, nonatomic) id delegate;
@property(strong, nonatomic) NSString* ID;
@property(strong, nonatomic) NSString* eventName;
@property(strong, nonatomic) NSMutableArray* cssClasses;
@end


@interface UIView (Position)
@property (assign, nonatomic)CGFloat height;
@property (assign, nonatomic)CGFloat width;
@property (assign, nonatomic)CGFloat x;
@property (assign, nonatomic)CGFloat y;

+(CGFloat)scale;
+(CGFloat)screenWidth;
+(CGFloat)screenHeight;

-(ViewData *)getViewData;

- (void)belowView:(UIView *)v withMargin:(CGFloat) margin;
- (void)aboveView:(UIView *)v withMargin:(CGFloat) margin;
- (void)leftOfView:(UIView *)v withMargin:(CGFloat) margin;
- (void)rightOfView:(UIView *)v withMargin:(CGFloat) margin;
- (void)alignParentLeftWithMarghin:(CGFloat) margin;
- (void)alignParentRightWithMarghin:(CGFloat) margin;
- (void)alignParentTopWithMarghin:(CGFloat) margin;
- (void)alignParentBottomWithMarghin:(CGFloat) margin;
+ (void)top2bottom:(NSArray *)views withMargin:(CGFloat) margin;
+ (CGRect)rectForViews:(NSArray *)views;
+ (UIView *)groupOfViews:(NSArray *)views;
- (void)fitParentWidthWithMargin:(CGFloat) margin;
- (void)fitParentHeightWithMargin:(CGFloat) margin;
- (void)fitParentWithMargin:(CGFloat) margin;
- (void)centerInParent;
- (void)hcenterInParent;
- (void)vcenterInParent;
- (void)extendToParentRightWithMargin:(CGFloat) margin;
- (void)extendToParentLeftWithMargin:(CGFloat) margin;
- (void)hcenterSubviews;
- (void)vcenterSubviews;
- (void)valignWith:(UIView *)view;
- (void)halignWith:(UIView *)view;
- (id) clone;
- (void) movetoNextSubview;
- (CGRect)rectForSubviews;

@end
