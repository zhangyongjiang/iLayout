//
//  UIView+Position.m
//
//  Created by Kevin Zhang on 10/24/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+Autolayout.h"
#import "UIView+Position.h"

@implementation UIView (Autolayout)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod([UIView class], @selector(swizzled_setTranslatesAutoresizingMaskIntoConstraints:)), class_getInstanceMethod([self class], @selector(setTranslatesAutoresizingMaskIntoConstraints:)));
    });
}

-(void)swizzled_setTranslatesAutoresizingMaskIntoConstraints:(BOOL)flag {
    CGFloat width = self.width;
    CGFloat height = self.height;
    [self swizzled_setTranslatesAutoresizingMaskIntoConstraints:flag];
    if(!flag) {
        ViewData* vd = [self getViewData];
        if (!vd.widthConstraint && width>0.01) {
            NSLayoutConstraint* con = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1  constant:width];
            [self.superview addConstraints:@[con]];
            vd.widthConstraint = con;
        }
        if (!vd.heightConstraint && height>0.01) {
            NSLayoutConstraint* con = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1  constant:height];
            [self.superview addConstraints:@[con]];
            vd.heightConstraint = con;
        }
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

-(void)autoLayoutSubviews:(NSArray*)subviews marginBottom:(CGFloat)margin {
    for (UIView* v in subviews) {
        [self autoLayout:v marginBottom:margin];
    }
}

-(void)autoLayoutSubviews:(NSArray*)subviews marginRight:(CGFloat)margin {
    for (UIView* v in subviews) {
        [self autoLayout:v marginRight:margin];
    }
}

-(void)autoLayoutSubviews:(NSArray*)subviews marginLeft:(CGFloat)margin {
    for (UIView* v in subviews) {
        [self autoLayout:v marginLeft:margin];
    }
}

-(void)autoLayoutSubviews:(NSArray*)subviews marginTop:(CGFloat)margin {
    for (UIView* v in subviews) {
        [self autoLayout:v marginTop:margin];
    }
}

-(void)autoLayout:(UIView*)subview marginBottom:(CGFloat)margin
{
    if(!subview.superview) [self addSubview:subview];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSString* name = [subview nameOfView];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:subview, name,nil];
    NSString* format = [NSString stringWithFormat:@"V:[%@]-offsetBottom-|", name];
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:format
                            options:0
                            metrics:@{@"offsetBottom": [NSNumber numberWithFloat: margin]}
                            views:dict];
    [self addConstraints:constraints];
}

-(void)autoLayout:(UIView*)subview percentTop:(CGFloat)percent
{
    if(!subview.superview) [self addSubview:subview];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* con = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:percent  constant:0];

    [self addConstraint:con];
}

-(void)autoLayout:(UIView*)subview marginTop:(CGFloat)margin
{
    if(!subview.superview) [self addSubview:subview];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSString* name = [subview nameOfView];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:subview, name,nil];
    NSString* format = [NSString stringWithFormat:@"V:|-offset-[%@]", name];
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:format
                            options:0
                            metrics:@{@"offset": [NSNumber numberWithFloat: margin]}
                            views:dict];
    [self addConstraints:constraints];
}

-(void)autoLayout:(UIView*)subview marginRight:(CGFloat)margin
{
    if(!subview.superview) [self addSubview:subview];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSString* name = [subview nameOfView];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:subview, name,nil];
    NSString* format = [NSString stringWithFormat:@"H:[%@]-offsetRight-|", name];
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:format
                            options:0
                            metrics:@{@"offsetRight": [NSNumber numberWithFloat: margin]}
                            views:dict];
    [self addConstraints:constraints];
}

-(void)autoLayout:(UIView*)subview marginLeft:(CGFloat)margin
{
    if(!subview.superview) [self addSubview:subview];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSString* name = [subview nameOfView];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:subview, name,nil];
    NSString* format = [NSString stringWithFormat:@"H:|-offset-[%@]", name];
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:format
                            options:0
                            metrics:@{@"offset": [NSNumber numberWithFloat: margin]}
                            views:dict];
    [self addConstraints:constraints];
}

-(void)autoLayout:(UIView*)subview width:(CGFloat)width height:(CGFloat)height {
    [self autoLayout:subview width:width];
    [self autoLayout:subview height:height];
}

-(void)autoLayout:(UIView*)subview width:(CGFloat)width
{
    if(!subview.superview) [self addSubview:subview];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    ViewData* vd = [self getViewData];
    if (vd.widthConstraint) {
        [self removeConstraint:vd.widthConstraint];
    }
    
    NSLayoutConstraint* con = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1  constant:width];
    [self addConstraints:@[con]];
    vd.widthConstraint = con;
}

-(void)autoLayout:(UIView*)subview widthPercent:(CGFloat)percent
{
    if(!subview.superview) [self addSubview:subview];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    ViewData* vd = [self getViewData];
    if (vd.widthConstraint) {
        [self removeConstraint:vd.widthConstraint];
    }
    
    NSLayoutConstraint* con = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:percent  constant:0];
    
    [self addConstraints:@[con]];
    vd.widthConstraint = con;
}

-(void)autoLayout:(UIView*)subview height:(CGFloat)height
{
    if(!subview.superview) [self addSubview:subview];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    ViewData* vd = [self getViewData];
    if (vd.heightConstraint) {
        [self removeConstraint:vd.heightConstraint];
    }
    
    NSLayoutConstraint* con = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1  constant:height];
    [self addConstraints:@[con]];
    vd.heightConstraint = con;
}


-(void)autoLayoutXCenter:(NSArray*)subviews {
    for (UIView* subview in subviews) {
        if(!subview.superview) [self addSubview:subview];
        subview.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:subview
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:0
                                         toItem:self
                                      attribute:NSLayoutAttributeCenterX
                                     multiplier:1
                                       constant:0]];
    }
}

-(void)autoLayoutYCenter:(NSArray*)subviews {
    for (UIView* subview in subviews) {
        if(!subview.superview) [self addSubview:subview];
        subview.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:subview
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:0
                                         toItem:self
                                      attribute:NSLayoutAttributeCenterY
                                     multiplier:1
                                       constant:0]];
    }
}

-(NSString*)nameOfView {
    return [NSString stringWithFormat:@"v%p", self];
}

-(void)autoLayoutXCenterFlow:(NSArray *)views  margin:(CGFloat)margin {
    UIView *spacer1 = [[UIView alloc] init];
    [self addSubview:spacer1];
    spacer1.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *spacer2 = [[UIView alloc] init];
    [self addSubview:spacer2];
    spacer2.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:spacer1 forKey:@"spacer1"];
    [dict setObject:spacer2 forKey:@"spacer2"];
    for (UIView* v in views) {
        v.translatesAutoresizingMaskIntoConstraints = NO;
        [dict setObject:v forKey:[v nameOfView]];
        if(!v.superview) [self addSubview:v];
    }
    
    NSMutableString* str = [[NSMutableString alloc] init];
    [str appendString:@"H:|[spacer1(>=0)]"];
    BOOL first = YES;
    for (UIView* v in views) {
        if(first) {
            first = NO;
        }
        else {
            [str appendString:[NSString stringWithFormat:@"-%f-", margin]];
        }
        [str appendString:@"["];
        [str appendString:[v nameOfView]];
        [str appendString:@"]"];
    }
    [str appendString:@"[spacer2(==spacer1)]|"];
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:[str description] options:0 metrics:nil views:dict];
    [self addConstraints:constraints];
}

-(void)autoLayoutXFlow:(NSArray *)views  margin:(CGFloat)margin left:(CGFloat)marginLeft {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (UIView* v in views) {
        if(!v.superview) [self addSubview:v];
        v.translatesAutoresizingMaskIntoConstraints = NO;
        [dict setObject:v forKey:[v nameOfView]];
    }
    
    NSMutableString* str = [[NSMutableString alloc] init];
    [str appendString:@"H:|-marginLeft"];
    BOOL first = YES;
    for (UIView* v in views) {
        if (first) {
            first = NO;
            [str appendString:@"-["];
            [str appendString:[v nameOfView]];
            [str appendString:@"]"];
        }
        else {
            [str appendString:@"-offset-["];
            [str appendString:[v nameOfView]];
            [str appendString:@"]"];
        }
    }
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:[str description]
                            options:0
                            metrics:@{@"offset": [NSNumber numberWithFloat: margin], @"marginLeft": [NSNumber numberWithFloat: marginLeft]}
                            views:dict];
    
    [self addConstraints:constraints];
}

-(void)autoLayout:(UIView *)subview xFlow:(NSArray *)subviews margin:(CGFloat)margin firstMargin:(CGFloat)firstMargin {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:subview forKey:[subview nameOfView]];
    for (UIView* v in subviews) {
        if(!v.superview) [self addSubview:v];
        v.translatesAutoresizingMaskIntoConstraints = NO;
        [dict setObject:v forKey:[v nameOfView]];
    }
    
    NSMutableString* str = [[NSMutableString alloc] init];
    [str appendString:@"H:["];
    [str appendString:[subview nameOfView]];
    BOOL first = YES;
    for (UIView* v in subviews) {
        if (first) {
            first = NO;
            [str appendString:@"]-firstMargin-[" ];
            [str appendString:[v nameOfView]];
            [str appendString:@"]"];
        }
        else {
            [str appendString:@"-offset-["];
            [str appendString:[v nameOfView]];
            [str appendString:@"]"];
        }
    }
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:[str description]
                            options:0
                            metrics:@{@"offset": [NSNumber numberWithFloat: margin], @"firstMargin": [NSNumber numberWithFloat: firstMargin]}
                            views:dict];
    
    [self addConstraints:constraints];
}

-(void)autoLayout:(UIView *)subview yFlow:(NSArray *)subviews margin:(CGFloat)margin firstMargin:(CGFloat)firstMargin {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:subview forKey:[subview nameOfView]];
    for (UIView* v in subviews) {
        if(!v.superview) [self addSubview:v];
        v.translatesAutoresizingMaskIntoConstraints = NO;
        [dict setObject:v forKey:[v nameOfView]];
    }
    
    NSMutableString* str = [[NSMutableString alloc] init];
    [str appendString:@"V:["];
    [str appendString:[subview nameOfView]];
    BOOL first = YES;
    for (UIView* v in subviews) {
        if (first) {
            first = NO;
            [str appendString:@"]-firstMargin-[" ];
            [str appendString:[v nameOfView]];
            [str appendString:@"]"];
        }
        else {
            [str appendString:@"-offset-["];
            [str appendString:[v nameOfView]];
            [str appendString:@"]"];
        }
    }
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:[str description]
                            options:0
                            metrics:@{@"offset": [NSNumber numberWithFloat: margin], @"firstMargin": [NSNumber numberWithFloat: firstMargin]}
                            views:dict];
    
    [self addConstraints:constraints];
}

-(void)autoLayout:(UIView *)subview xFlow:(NSArray *)subviews margin:(CGFloat)margin {
    [self autoLayout:subview xFlow:subviews margin:margin firstMargin:margin];
}

-(void)autoLayout:(UIView *)subview yFlow:(NSArray *)subviews margin:(CGFloat)margin {
    [self autoLayout:subview yFlow:subviews margin:margin firstMargin:margin];
}

-(void)autoLayoutYCenterFlow:(NSArray *)views  margin:(CGFloat)margin {
    UIView *spacer1 = [[UIView alloc] init];
    [self addSubview:spacer1];
    spacer1.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *spacer2 = [[UIView alloc] init];
    [self addSubview:spacer2];
    spacer2.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:spacer1 forKey:@"spacer1"];
    [dict setObject:spacer2 forKey:@"spacer2"];
    for (UIView* v in views) {
        if(!v.superview) [self addSubview:v];
        v.translatesAutoresizingMaskIntoConstraints = NO;
        [dict setObject:v forKey:[v nameOfView]];
    }
    
    NSMutableString* str = [[NSMutableString alloc] init];
    [str appendString:@"V:|[spacer1(>=0)]"];
    BOOL first = YES;
    for (UIView* v in views) {
        if(first) {
            first = NO;
        }
        else {
            [str appendString:[NSString stringWithFormat:@"-%f-", margin]];
        }
        [str appendString:@"["];
        [str appendString:[v nameOfView]];
        [str appendString:@"]"];
    }
    [str appendString:@"[spacer2(==spacer1)]|"];
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:[str description] options:0 metrics:nil views:dict];
    [self addConstraints:constraints];
}

-(void)autoLayoutYFlow:(NSArray *)views  margin:(CGFloat)margin top:(CGFloat)marginTop {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (UIView* v in views) {
        if(!v.superview) [self addSubview:v];
        v.translatesAutoresizingMaskIntoConstraints = NO;
        [dict setObject:v forKey:[v nameOfView]];
    }
    
    NSMutableString* str = [[NSMutableString alloc] init];
    [str appendString:@"V:|-marginTop"];
    BOOL first = YES;
    for (UIView* v in views) {
        if (first) {
            first = NO;
            [str appendString:@"-["];
            [str appendString:[v nameOfView]];
            [str appendString:@"]"];
        }
        else {
            [str appendString:@"-offset-["];
            [str appendString:[v nameOfView]];
            [str appendString:@"]"];
        }
    }
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:[str description]
                            options:0
                            metrics:@{@"offset": [NSNumber numberWithFloat: margin], @"marginTop": [NSNumber numberWithFloat: marginTop]}
                            views:dict];
    
    [self addConstraints:constraints];
}

-(void)autoLayout:(UIView*)subview belowView:(UIView*)sibling margin:(CGFloat)margin {
    if(!subview.superview) [self addSubview:subview];
    if(!sibling.superview) [self addSubview:sibling];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSString* name = [subview nameOfView];
    NSString* siblingName = [sibling nameOfView];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:subview, name, sibling, siblingName, nil];
    NSString* format = [NSString stringWithFormat:@"V:[%@]-offset-[%@]", siblingName, name];
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:format
                            options:0
                            metrics:@{@"offset": [NSNumber numberWithFloat: margin]}
                            views:dict];
    [self addConstraints:constraints];
}

-(void)autoLayoutSubviews:(NSArray*)subviews belowView:(UIView*)sibling margin:(CGFloat)margin {
    for (UIView* subview in subviews) {
        [self autoLayout:subview belowView:sibling margin:margin];
    }
}

-(void)autoLayout:(UIView*)subview aboveView:(UIView*)sibling margin:(CGFloat)margin {
    if(!subview.superview) [self addSubview:subview];
    if(!sibling.superview) [self addSubview:sibling];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSString* name = [subview nameOfView];
    NSString* siblingName = [sibling nameOfView];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:subview, name, sibling, siblingName, nil];
    NSString* format = [NSString stringWithFormat:@"V:[%@]-offset-[%@]", name, siblingName];
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:format
                            options:0
                            metrics:@{@"offset": [NSNumber numberWithFloat: margin]}
                            views:dict];
    [self addConstraints:constraints];
}

-(void)autoLayoutSubviews:(NSArray*)subviews aboveView:(UIView*)sibling margin:(CGFloat)margin {
    for (UIView* subview in subviews) {
        [self autoLayout:subview aboveView:sibling margin:margin];
    }
}

-(void)autoLayout:(UIView *)subview onTheRightOfView:(UIView *)sibling margin:(CGFloat)margin {
    if(!subview.superview) [self addSubview:subview];
    if(!sibling.superview) [self addSubview:sibling];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSString* name = [subview nameOfView];
    NSString* siblingName = [sibling nameOfView];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:subview, name, sibling, siblingName, nil];
    NSString* format = [NSString stringWithFormat:@"H:[%@]-offset-[%@]", siblingName, name];
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:format
                            options:0
                            metrics:@{@"offset": [NSNumber numberWithFloat: margin]}
                            views:dict];
    [self addConstraints:constraints];
}

-(void)autoLayoutSubviews:(NSArray*)subviews onTheRightOfView:(UIView*)sibling margin:(CGFloat)margin {
    for (UIView* subview in subviews) {
        [self autoLayout:subview onTheRightOfView:sibling margin:margin];
    }
}

-(void)autoLayout:(UIView*)subview onTheLeftOfView:(UIView *)sibling margin:(CGFloat)margin {
    if(!subview.superview) [self addSubview:subview];
    if(!sibling.superview) [self addSubview:sibling];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSString* name = [subview nameOfView];
    NSString* siblingName = [sibling nameOfView];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:subview, name, sibling, siblingName, nil];
    NSString* format = [NSString stringWithFormat:@"H:[%@]-offset-[%@]", name, siblingName];
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:format
                            options:0
                            metrics:@{@"offset": [NSNumber numberWithFloat: margin]}
                            views:dict];
    [self addConstraints:constraints];
}

-(void)autoLayoutSubviews:(NSArray*)subviews onTheLeftOfView:(UIView*)sibling margin:(CGFloat)margin {
    for (UIView* subview in subviews) {
        [self autoLayout:subview onTheLeftOfView:sibling margin:margin];
    }
}

- (CGRect)rectOfSubviews
{
    CGFloat x0, y0, x1, y1;
    x0 = y0 = -1000000;
    x1 = y1 = 1000000;
    
    for (UIView * view in self.subviews) {
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

-(CGRect)topSpaceRect
{
    CGRect rect = [self rectOfSubviews];
    return CGRectMake(0, 0, self.width, rect.origin.y);
}

-(CGRect)leftSpaceRect
{
    CGRect rect = [self rectOfSubviews];
    return CGRectMake(0, 0, rect.origin.x, self.height);
}

-(CGRect)bottomSpaceRect
{
    CGRect rect = [self rectOfSubviews];
    return CGRectMake(0, rect.origin.y + rect.size.height, self.width, self.height - rect.origin.y - rect.size.height);
}

-(CGRect)rightSpaceRect
{
    CGRect rect = [self rectOfSubviews];
    return CGRectMake(rect.origin.x + rect.size.width, 0, self.width - rect.origin.x - rect.size.width, self.height);
}

-(UIView*)fillTop {
    CGRect rect = [self topSpaceRect];
    UIView* subview = [[UIView alloc] initWithFrame:rect];
    [self addSubview:subview];
    return subview;
}

-(UIView*)fillLeft {
    CGRect rect = [self leftSpaceRect];
    UIView* subview = [[UIView alloc] initWithFrame:rect];
    [self addSubview:subview];
    return subview;
}

-(UIView*)fillRight {
    CGRect rect = [self rightSpaceRect];
    UIView* subview = [[UIView alloc] initWithFrame:rect];
    [self addSubview:subview];
    return subview;
}

-(UIView*)fillBottom {
    CGRect rect = [self bottomSpaceRect];
    UIView* subview = [[UIView alloc] initWithFrame:rect];
    [self addSubview:subview];
    return subview;
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
    [current resignFirstResponder];
    
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
@end
