//
//  UIView+Position.m
//
//  Created by Kevin Zhang on 10/27/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+Position.h"

@implementation ViewData

-(id)init {
    self = [super init];
    self.useCssLayout = NO;
    return self;
}

@end

static char viewData;
@implementation UIView (Position)

-(ViewData *)getViewData{
    ViewData * vd = objc_getAssociatedObject(self, &viewData);
    if (!vd) {
        vd = [[ViewData alloc] init];
        objc_setAssociatedObject(self, &viewData,
                                 vd, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return vd;
}

- (void)belowView:(UIView *)v withMargin:(CGFloat) margin
{
    CGRect thisFrame = self.frame;
    CGRect frame = v.frame;
    thisFrame.origin.y = frame.origin.y + frame.size.height + margin;
    self.frame = thisFrame;
}

- (void)aboveView:(UIView *)v withMargin:(CGFloat) margin
{
    CGRect thisFrame = self.frame;
    CGRect frame = v.frame;
    thisFrame.origin.y = frame.origin.y - thisFrame.size.height - margin;
    self.frame = thisFrame;
}

+ (void)top2bottom:(NSArray *)views withMargin:(CGFloat)margin
{
    UIView *prev = nil;
    for (UIView * view in views) {
        if(!prev) {
            prev = view;
            continue;
        }
        [view belowView:prev withMargin:margin];
    }
}

+ (CGRect)rectForViews:(NSArray *)views
{
    CGFloat x0, y0, x1, y1;
    x0 = y0 = -1000000;
    x1 = y1 = 1000000;
    
    for (UIView * view in views) {
        if (view.hidden) {
            continue;
        }
        CGRect frame = view.frame;
        if (x0 < -99999) {
            x0 = frame.origin.x;
            y0 = frame.origin.y;
            x1 = frame.origin.x + frame.size.width;
            y1 = frame.origin.y + frame.size.height;
            continue;
        }
        if (frame.origin.x < x0) {
            x0 = frame.origin.x;
        }
        if (frame.origin.y < y0) {
            y0 = frame.origin.y;
        }
        if(frame.origin.x + frame.size.width > x1)
            x1 = frame.origin.x + frame.size.width;
        if(frame.origin.y + frame.size.height > y1)
            y1 = frame.origin.y + frame.size.height;
    }
    
    CGRect rect = CGRectMake(x0, y0, x1-x0, y1-y0);
    return rect;
}

+(UIView *)groupOfViews:(NSArray *)views
{
    CGRect rect = [UIView rectForViews:views];
    UIView *parent = [[UIView alloc] initWithFrame:rect];
    for (UIView * view in views) {
        [view removeFromSuperview];
        CGRect frame = view.frame;
        frame.origin.x = frame.origin.x - rect.origin.x;
        frame.origin.y = frame.origin.y - rect.origin.y;
        view.frame = frame;
        [parent addSubview:view];
    }
    return parent;
}

-(void)alignParentBottomWithMarghin:(CGFloat)margin
{
    CGRect pframe = self.superview.frame;
    CGRect frame = self.frame;
    frame.origin.y = pframe.size.height - frame.size.height - margin;
    self.frame = frame;
}

-(void)alignParentLeftWithMarghin:(CGFloat)margin
{
    CGRect frame = self.frame;
    frame.origin.x = margin;
    self.frame = frame;
}

-(void)rightOfView:(UIView *)v withMargin:(CGFloat)margin
{
    if(!v) return;
    self.x = v.x + v.width + margin;
}

-(void)alignParentRightWithMarghin:(CGFloat)margin
{
    if (self.superview) {
        CGRect pframe = self.superview.frame;
        CGRect frame = self.frame;
        frame.origin.x = pframe.size.width - frame.size.width - margin;
        self.frame = frame;
    }
}

-(void)alignParentTopWithMarghin:(CGFloat)margin
{
    if (self.superview) {
        CGRect frame = self.frame;
        frame.origin.y = margin;
        self.frame = frame;
    }
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(CGFloat)width
{
    return self.frame.size.width;
}

-(CGFloat)x {
    return self.frame.origin.x;
}

-(void)setX:(CGFloat)x
{
    CGRect f = self.frame;
    f.origin.x = x;
    self.frame = f;
}

-(void)setY:(CGFloat)y
{
    CGRect f = self.frame;
    f.origin.y = y;
    self.frame = f;
}

-(void)setWidth:(CGFloat)width
{
    CGRect f = self.frame;
    f.size.width = width;
    self.frame = f;
}

-(void)setHeight:(CGFloat)height
{
    CGRect f = self.frame;
    f.size.height = height;
    self.frame = f;
}

-(CGFloat)y {
    return self.frame.origin.y;
}

-(void)fitParentWidthWithMargin:(CGFloat)margin
{
    if (self.superview) {
        CGFloat pw = self.superview.width;
        self.frame = CGRectMake(margin, self.y, pw-margin*2, self.height);
    }
}

-(void)fitParentHeightWithMargin:(CGFloat)margin
{
    if (self.superview) {
        CGFloat ph = self.superview.height;
        self.frame = CGRectMake(self.x, margin, self.width, ph - margin * 2);
    }
}

- (void)centerInParent
{
    [self hcenterInParent];
    [self vcenterInParent];
}

- (void)hcenterInParent
{
    if (self.superview) {
        self.x = self.superview.width / 2.0 - self.width / 2.0;
    }
}

- (void)vcenterInParent
{
    if (self.superview) {
        self.y = self.superview.height / 2.0 - self.height / 2.0;
    }
}

- (void)extendToParentRightWithMargin:(CGFloat) margin
{
    if (self.superview) {
        CGFloat neww = self.superview.width - self.x - margin;
        self.width = neww;
    }
}

- (void)extendToParentLeftWithMargin:(CGFloat) margin
{
    if (self.superview) {
        CGFloat neww = self.x + self.width - margin;
        self.width = neww;
        self.x = margin;
    }
}

-(void)fitParentWithMargin:(CGFloat)margin
{
    [self fitParentHeightWithMargin:margin];
    [self fitParentWidthWithMargin:margin];
}

-(void)leftOfView:(UIView *)v withMargin:(CGFloat)margin
{
    if(!v) return;
    CGFloat delta = v.x - (self.x + self.width + margin);
    self.x = self.x + delta;
}

-(void)hcenterSubviews
{
    for (UIView *child in self.subviews) {
        child.x = (self.width - child.width)/2.0;
    }
}

-(void)vcenterSubviews
{
    for (UIView *child in self.subviews) {
        child.y = (self.height - child.height) / 2.0;
    }
}

-(void)valignWith:(UIView *)view
{
    self.y = view.y + view.height/2 - self.height/2;
}

-(void)halignWith:(UIView *)view
{
    self.x = view.x + view.width/2 - self.width/2;
}

-(id)clone
{
    NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject: self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];
}

-(void) movetoNextSubview
{
    UIView *current = nil;
    for (UIView *child in self.subviews) {
        if([child isFirstResponder]) {
            current = child;
            break;
        }
    }
    
    if(current == nil) {
        for (UIView *child in self.subviews) {
            if(![child isKindOfClass:[UITextField class]]) {
                continue;
            }
            if(child.hidden) {
                continue;
            }
            if(current == nil) {
                current = child;
                continue;
            }
            if (child.y < current.y) {
                current = child;
                continue;
            }
            if (child.x < current.x) {
                current = child;
                continue;
            }
        }
        [current becomeFirstResponder];
        return;
    }
    
    UIView *next = nil;
    for (UIView *child in self.subviews) {
        if(![child isKindOfClass:[UITextField class]]) {
            continue;
        }
        if(child == current)
            continue;
        CGFloat diff = child.y - current.y;
        if(diff < 0) diff = -diff;
        if (diff < 0.01) {
            if (child.x < current.x) {
                continue;
            }
        }
        if (child.y < current.y) {
            continue;
        }
        if(child.hidden) {
            continue;
        }
        if(next == nil) {
            next = child;
            continue;
        }
        
        diff = (child.y - current.y) - (next.y - current.y);
        if(diff < 0) diff = -diff;
        if(diff < 0.01) {
            if(child.x < current.x)
                continue;
            if(child.x - current.x < next.x - current.x) {
                next = child;
                continue;
            }
        }
        else {
            if(child.y - current.y < next.y - current.y) {
                next = child;
                continue;
            }
        }
    }
    [next becomeFirstResponder];
}

-(CGRect)rectForSubviews
{
    return [UIView rectForViews:self.subviews];
}

+(CGFloat)scale
{
    return  [UIScreen mainScreen].bounds.size.width / 320.0;
}

+(CGFloat)screenWidth
{
    return  [UIScreen mainScreen].bounds.size.width;
}

+(CGFloat)screenHeight
{
    return  [UIScreen mainScreen].bounds.size.height;
}

@end
