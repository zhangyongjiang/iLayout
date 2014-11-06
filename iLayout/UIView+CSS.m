//
//  UIView+Theme.m
//
//  Created by Kevin Zhang on 11/2/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+CSS.h"
#import "ESCssParser.h"
#import "UIView+Position.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+String.h"
#import "NSObject+Attach.h"

static NSDictionary* themes;

@implementation UILabel (CSS)

-(void)applyCss {
    [super applyCss];
    
    if(!self.useCssLayout) {
        return;
    }
    UIFont* font = [self cssFont];
    if (font) {
        self.font = font;
    }
    UIColor* color = [self cssColor:@"color"];
    if (color) {
        self.textColor = color;
    }
    NSString* textDecoration = [self css:@"text-decoration"];
    if (textDecoration) {
        NSString* text = self.text;
        if (text && [@"underline" isEqualToString:textDecoration]) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
            [attrStr setAttributes:@{NSForegroundColorAttributeName:self.textColor,NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[attrStr length])];
            [self setAttributedText:attrStr];
        }
    }
}

@end


@implementation UITextField(CSS)

-(void)applyCss {
    [super applyCss];
    if(!self.useCssLayout) {
        return;
    }
    NSString* placeholder = [self css:@"placeholder-text"];
    UIColor* placeholderColor = [self cssColor:@"placeholder-text-color"];
    if (placeholderColor && placeholder) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    }
    else if (placeholder) {
        self.placeholder = placeholder;
    }
    
    NSString* secureTextEntry = [self css:@"secureTextEntry"];
    if (secureTextEntry && [secureTextEntry isEqualToString:@"true"]) {
        self.secureTextEntry = YES;
    }
}

@end

@interface UILabel (CSS)
@end

@interface UIButton (CSS)
@end

@interface UITextField (CSS)
@end


@implementation UITextFieldWithPadding

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    NSNumber* num = [self cssPadding];
    return CGRectInset(bounds, (num ? num.floatValue : 0), 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    NSNumber* num = [self cssPadding];
    return CGRectInset(bounds, (num ? num.floatValue : 0), 0);
}
@end

@interface ViewPosition : NSObject
@property(strong, nonatomic)NSString* relatedTo;
@property(strong, nonatomic)NSString* direction;
@property(assign, nonatomic)NSString* value;

+(ViewPosition*)parse:(NSString*)posStr;
@end
@implementation ViewPosition

-(id)init {
    self = [super init];
    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"%@ %@ %@", self.direction, self.relatedTo, self.value];
}

+(ViewPosition*)parse:(NSString *)posStr {
    if (!posStr) {
        return nil;
    }
    NSArray* items = [posStr componentsSeparatedByString:@" "];
    ViewPosition* vp = [[ViewPosition alloc] init];
    if(items.count>0)vp.direction = items[0];
    if(items.count>1)vp.relatedTo = items[1];
    if(items.count>2)vp.value = items[2];
    return vp;
}

@end


@implementation UIButton (CSS)

-(void)applyCss {
    [super applyCss];

    if(!self.useCssLayout) {
        return;
    }
    NSString* value;
    {
        value = [self css:@"image-normal"];
        if (value) {
            [self setImage:[UIImage imageNamed:value ] forState:UIControlStateNormal];
        }
        value = [self css:@"image-disabled"];
        if (value) {
            [self setImage:[UIImage imageNamed:value ] forState:UIControlStateDisabled];
        }
        value = [self css:@"image-highlighted"];
        if (value) {
            [self setImage:[UIImage imageNamed:value ] forState:UIControlStateHighlighted];
        }
        value = [self css:@"image-selected"];
        if (value) {
            [self setImage:[UIImage imageNamed:value ] forState:UIControlStateSelected];
        }
    }
    
    NSNumber* paddingTop = [self cssNumber:@"padding-top"];
    NSNumber* paddingLeft = [self cssNumber:@"padding-left"];
    NSNumber* paddingBottom = [self cssNumber:@"padding-bottom"];
    NSNumber* paddingRight = [self cssNumber:@"padding-right"];
    if(paddingBottom && paddingLeft && paddingRight && paddingTop) {
        self.contentEdgeInsets = UIEdgeInsetsMake(paddingTop.floatValue, paddingLeft.floatValue, paddingBottom.floatValue, paddingRight.floatValue);
    }
    else {
        NSNumber* padding = [self cssNumber:@"padding"];
        if (padding) {
            self.contentEdgeInsets = UIEdgeInsetsMake(padding.floatValue, padding.floatValue, padding.floatValue, padding.floatValue);
        }
    }
    
    {
        value = [self css:@"title-normal"];
        if(value) {
            [self setTitle:value forState:UIControlStateNormal];
        }
        value = [self css:@"title-disabled"];
        if(value) {
            [self setTitle:value forState:UIControlStateDisabled];
        }
        value = [self css:@"title-highlighted"];
        if(value) {
            [self setTitle:value forState:UIControlStateHighlighted];
        }
        value = [self css:@"title-selected"];
        if(value) {
            [self setTitle:value forState:UIControlStateSelected];
        }
    }
    
    UIFont* font = [self cssFont];
    self.titleLabel.font = font;
    
    {
        value = [self css:@"title-color-normal"];
        if(value) {
            UIColor* color = [UIColor colorFromString:value];
            [self setTitleColor:color forState:UIControlStateNormal];
        }
        value = [self css:@"title-color-disabled"];
        if(value) {
            UIColor* color = [UIColor colorFromString:value];
            [self setTitleColor:color forState:UIControlStateDisabled];
        }
        value = [self css:@"title-color-highlighted"];
        if(value) {
            UIColor* color = [UIColor colorFromString:value];
            [self setTitleColor:color forState:UIControlStateHighlighted];
        }
        value = [self css:@"title-color-selected"];
        if(value) {
            UIColor* color = [UIColor colorFromString:value];
            [self setTitleColor:color forState:UIControlStateSelected];
        }
    }
}

@end


@implementation UIView (CSS)

+ (void)load
{
    static dispatch_once_t onceToken;
    
    ESCssParser *parser = [[ESCssParser alloc] init];
    themes = [parser parseFile:@"default" type:@"css"];
    
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod([UIView class], @selector(initWithFrame_swizzle:)), class_getInstanceMethod([self class], @selector(initWithFrame:)));
        method_exchangeImplementations(class_getInstanceMethod([UIView class], @selector(swizzle_addSubview:)), class_getInstanceMethod([self class], @selector(addSubview:)));
    });
}

-(id)initWithFrame_swizzle:(CGRect)frame {
    self = [self initWithFrame_swizzle:frame];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

-(void)swizzle_addSubview:(UIView *)view {
    [self swizzle_addSubview:view];
    if (view.useCssLayout) {
        [self applyCss];
    }
}

-(id)initWithCssEnabled:(BOOL)enabled {
    self = [self initWithFrame:CGRectZero];
    self.useCssLayout = enabled;
    return self;
}

-(id)initWithCssClasses:(NSString *)cssCls {
    self = [self initWithFrame:CGRectZero];
    self.useCssLayout = YES;
    [self addCssClasses:cssCls];
    return self;
}

-(id)initWithID:(NSString *)ID {
    self = [self initWithFrame:CGRectZero];
    self.useCssLayout = YES;
    self.ID = ID;
    return self;
}

-(id)initWithID:(NSString *)ID cssClasses:(NSString*)cssClasses {
    self = [self initWithFrame:CGRectZero];
    self.useCssLayout = YES;
    self.ID = ID;
    [self addCssClasses:cssClasses];
    return self;
}

-(id)initWithFrame:(CGRect)frame cssClasses:(NSString *)cssClasses {
    self = [self initWithFrame_swizzle:frame];
    [self addCssClasses:cssClasses];
    return self;
}

-(id)initWithFrame:(CGRect)frame andID:(NSString *)ID {
    self = [self initWithFrame_swizzle:frame];
    self.ID = ID;
    return self;
}

-(id)initWithFrame:(CGRect)frame andID:(NSString *)ID cssClasses:(NSString *)cssClasses {
    self = [self initWithFrame_swizzle:frame];
    self.ID = ID;
    [self addCssClasses:cssClasses];
    return self;
}

-(NSString*)ID {
    ViewData* vd = [self getViewData];
    return vd.ID;
}

-(void)setID:(NSString *)ID {
    ViewData* vd = [self getViewData];
    vd.ID = ID;
}

-(BOOL)useCssLayout {
    return [self getViewData].useCssLayout;
}

-(void)setUseCssLayout:(BOOL)useCssLayout {
    [self getViewData].useCssLayout = useCssLayout;
    if (useCssLayout) {
        NSString* cssClasses = [self css:@"cssClasses"];
        if (cssClasses) {
            [self addCssClasses:cssClasses];
        }
    }
}

-(void)applyCss {
    if(self.useCssLayout) {
        UIColor* bgColor = [self cssBgColor];
        if (bgColor) {
            self.backgroundColor = bgColor;
        }
        
        NSNumber* num = [self cssNumber:@"width"];
        if(num) self.width = num.floatValue;
        num = [self cssNumber:@"height"];
        if(num) self.height = num.floatValue;
        
        NSNumber* cornerRadius = [self cssNumber:@"corner-radius"];
        if (cornerRadius) {
            self.layer.cornerRadius = cornerRadius.floatValue;
        }
        
        NSString* masksToBounds = [self css:@"masks-to-bounds"];
        if (masksToBounds && [masksToBounds isEqualToString:@"true"]) {
            self.layer.masksToBounds = YES;
        }
        
        NSString* hcenter = [self css:@"hcenter"];
        if(hcenter && [hcenter isEqualToString:@"true"]) {
            [self hcenterInParent];
        }
        
        NSString* vcenter = [self css:@"vcenter"];
        if(vcenter && [vcenter isEqualToString:@"true"]) {
            [self vcenterInParent];
        }
        [self applyCssPositions];
    }
    for (UIView* child in self.subviews) {
        [child applyCss];
    }
}

-(CGFloat)scale
{
    return  [UIScreen mainScreen].bounds.size.width / 320.0;
}

-(CGFloat) cssAbsNumber:(NSString*)name withDefault:(CGFloat)defvalue {
    NSNumber* num = [self cssAbsNumber:name];
    return num ? num.floatValue : defvalue;
}

-(NSNumber*) cssAbsNumber:(NSString*)name {
    NSString* str = [self css:name];
    if (!str) {
        return nil;
    }
    if ([str hasSuffix:@"px"]) {
        str = [str substringToIndex:(str.length-2)];
    }
    return [NSNumber numberWithFloat:[str floatValue]];
}

-(CGFloat) cssNumber:(NSString*)name withDefault:(CGFloat)defvalue {
    NSNumber* num = [self cssNumber:name];
    return num ? num.floatValue : defvalue;
}

-(NSNumber*)numberFromString:(NSString*)strNum {
    if(!strNum || strNum.length==0) return nil;
    strNum = [strNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    strNum = [strNum stringByReplacingOccurrencesOfString:@"*" withString:@""];
    
    if ([strNum hasSuffix:@"screen-width"]) {
        strNum = [strNum substringToIndex:strNum.length-12];
        if(strNum.length == 0)
            return [NSNumber numberWithFloat:[UIView screenWidth]];
        else
            return [NSNumber numberWithFloat:(strNum.floatValue * [UIView screenWidth])];
    }
    
    if ([strNum hasSuffix:@"screen-height"]) {
        strNum = [strNum substringToIndex:strNum.length-13];
        if(strNum.length == 0)
            return [NSNumber numberWithFloat:[UIView screenHeight]];
        else
            return [NSNumber numberWithFloat:(strNum.floatValue * [UIView screenHeight]) ];
    }
    
    if ([strNum hasSuffix:@"parent-width"]) {
        if (!self.superview) {
            return nil;
        }
        strNum = [strNum substringToIndex:strNum.length-12];
        if(strNum.length == 0) {
            CGFloat w = self.superview.width;
            return [NSNumber numberWithFloat:w];
        }
        else {
            return [NSNumber numberWithFloat:strNum.floatValue * self.superview.width];
        }
    }
    
    if ([strNum hasSuffix:@"parent-height"]) {
        if (!self.superview) {
            return nil;
        }
        strNum = [strNum substringToIndex:strNum.length-13];
        if(strNum.length == 0)
            return [NSNumber numberWithFloat:self.superview.height];
        else
            return [NSNumber numberWithFloat:(strNum.floatValue * self.superview.height)];
    }
    
    if ([strNum hasSuffix:@"px"]) {
        strNum = [strNum substringToIndex:(strNum.length-2)];
    }
    return [NSNumber numberWithFloat:[strNum floatValue]];
}

-(NSNumber*) cssNumber:(NSString*)name {
    NSString* strNum = [self css:name];
    return [self numberFromString:strNum];
}

-(NSString*)cssId {
    NSString* ID = self.ID;
    if(ID == nil) return nil;
    return [NSString stringWithFormat:@"#%@", ID];
}

+(NSString*) css:(NSString*)name forClass:(Class)cls {
    for(; cls != nil; cls = [cls superclass]) {
        NSString* clsName = [UIView simpleClsName:cls];
        clsName = [NSString stringWithFormat:@".%@", clsName];
        NSDictionary* dict = [themes objectForKey:clsName];
        if(dict != nil) {
            NSString* value = [dict objectForKey:name];
            if( value != nil) {
                value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                return value;
            }
        }
        if ([clsName isEqualToString:@".UIView"]) {
            break;
        }
    }
    
    NSDictionary* dict = [themes objectForKey:@"*"];
    if(dict != nil) {
        NSString* value = [dict objectForKey:name];
        if( value != nil) {
            value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            return value;
        }
    }
    
    return nil;
}

-(NSString*) css:(NSString*)name fromDict:(NSDictionary*)cssDict {
    NSString* ID = [self cssId];
    if (ID != nil) {
        NSDictionary* dict = [cssDict objectForKey:ID];
        if(dict != nil) {
            NSString* value = [dict objectForKey:name];
            if( value != nil) {
                value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                return value;
            }
        }
    }
    
    ViewData* vd = [self getViewData];
    NSMutableArray* cssClasses = [[NSMutableArray alloc] init];
    if (vd.cssClasses) {
        for (NSString* cls in vd.cssClasses) {
            [cssClasses addObject:cls];
        }
    }

    Class clz = [self class];
    while (clz != nil) {
        NSString* clsName = [UIView simpleClsName:clz];
        [cssClasses addObject:clsName];
        if (clz == [UIView class]) {
            break;
        }
        clz = [clz superclass];
    }
    
    for (NSString* cls in cssClasses) {
        NSString* key = [NSString stringWithFormat:@".%@", cls];
        NSDictionary* dict = [cssDict objectForKey:key];
        if(dict != nil) {
            NSString* value = [dict objectForKey:name];
            if( value != nil) {
                value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                return value;
            }
        }
    }

    return nil;
}

-(NSString*) css:(NSString*)name {
    UIView* viewOfCss = self;
    while (viewOfCss) {
        NSDictionary* myCssDict = [viewOfCss myCssDict];
        if (myCssDict) {
            NSString* value = [self css:name fromDict:myCssDict];
            if (value) {
                return value;
            }
        }
        viewOfCss = viewOfCss.superview;
    }
    NSString* value = [self css:name fromDict:themes];
    if (value) {
        return value;
    }
    
    return [UIView css:name forClass:[self class]];
}

+(UIColor*)colorFromRGB:(int) rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIColor*) cssColor:(NSString *)name{
    NSString* colorStr = [self css:name];
    if(colorStr == nil)
        return nil;
    
    UIColor* color = [UIColor colorFromString:colorStr];
    if(color)
        return color;
    
    if ([colorStr hasPrefix:@"img("]) {
        colorStr = [colorStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        colorStr = [colorStr substringWithRange:NSMakeRange(4, colorStr.length-5)];
        UIImage* img = [UIImage imageNamed:colorStr];
        if (img.size.width > self.width || img.size.height > self.height) {
            img = [UIView imageWithImage:img scaledToSize:CGSizeMake(self.width, self.height)];
        }
        NSString* key = [NSString stringWithFormat:@"%@-effect", name];
        NSString* effect = [self css:key];
        if (effect && [effect isEqualToString:@"dark"]) {
            UIColor *tintColor = [UIColor colorWithWhite:0 alpha:0.6];
            img = [img applyBlurWithRadius:0 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
        }
        else if (effect && [effect isEqualToString:@"light"]) {
            UIColor *tintColor = [UIColor colorWithWhite:0.5 alpha:0.6];
            img = [img applyBlurWithRadius:0 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
        }
        else if (effect && [effect isEqualToString:@"gray"]) {
            UIColor *tintColor = [UIColor colorWithWhite:0.25 alpha:0.6];
            img = [img applyBlurWithRadius:0 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
        }
        return [UIColor colorWithPatternImage:img];
    }
    
    NSLog(@"invalid color str %@", colorStr);
    return [UIColor clearColor];
}

-(UIColor*) cssBgColor {
    return [self cssColor:@"background-color"];
}

-(NSNumber*)  cssWidth {
    return [self cssNumber:@"width"];
}

-(NSNumber*)  cssHeight {
    return [self cssNumber:@"height"];
}

-(NSNumber*)  cssPadding {
    return [self cssNumber:@"padding"];
}

-(CGFloat)  cssPaddingWithDefault:(CGFloat)defvalue {
    NSNumber* num = [self cssNumber:@"padding"];
    return num ? num.floatValue : defvalue;
}

+(NSString*) simpleClsName:(Class)cls {
    NSString* name = NSStringFromClass(cls);
    NSRange r = [name rangeOfString:@"."];
    if(r.location == NSNotFound) {
        return name;
    }
    return [name substringFromIndex:r.location+1];
}

-(UIFont*)cssFont {
    NSString* name = [self css:@"font-family"];
    NSNumber* size = [self cssNumber:@"font-size"];
    if (name && size) {
        return [UIFont fontWithName:name size:size.floatValue];
    }
    return nil;
}

-(void)addCssClasses:(NSString *)clsNames {
    if (clsNames == nil || clsNames.length == 0) {
        return;
    }
    NSArray* names = [clsNames componentsSeparatedByString:@" "];
    for (NSString* cls in names) {
        ViewData* vd = [self getViewData];
        if (vd.cssClasses == nil) {
            vd.cssClasses = [[NSMutableArray alloc] init];
        }
        if ([vd.cssClasses indexOfObject:cls] == NSNotFound) {
            [vd.cssClasses addObject:cls];
        }
    }
}


-(void)setSubviewsID {
    Class clazz = [self class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        Class cls = [self classForProperty:prop];
        if([self isUIView:cls]) {
            const char* propertyName = property_getName(prop);
            NSString* key = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            UIView* propValue = [self valueForKey:key];
            if (propValue) {
                if (propValue.ID) {
                    continue;
                }
                propValue.ID = key;
            }
        }
    }
    free(properties);
}

- (void) dumpProperties{
    Class clazz = [self class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        NSString* str = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
        Class cls = [self classForProperty:prop];
        NSLog(@"isUIView:%d", [self isUIView:cls]);
    }
    free(properties);
}

- (Class)classForProperty:(objc_property_t)property {
    if(property != NULL) {
        return [self classFromTypeEncoding:[NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding]];
    } else
        return Nil;
}

- (Class)classFromTypeEncoding:(NSString*)typeEncoding {
    NSRange range = [typeEncoding rangeOfString:@"\""];
    if (range.location != NSNotFound) {
        NSMutableString *clazzName = [NSMutableString stringWithString:[typeEncoding substringFromIndex:range.location + 1]];
        // Find the ending "
        range = [clazzName rangeOfString:@"\""];
        if (range.location != NSNotFound) {
            [clazzName deleteCharactersInRange:NSMakeRange(range.location, [clazzName length] - range.location)];
            id cls = NSClassFromString(clazzName);
            return cls;
        }
    } 
    return nil;
}

-(BOOL)isUIView:(Class)cls {
    while (cls != nil) {
        if (cls == [UIView class]) {
            return YES;
        }
        cls = [cls superclass];
    }
    return NO;
}

-(void)applyCssPositions {
    NSString* positions = [self css:@"positions"];
    if (!positions) {
        return;
    }
    positions = [positions stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSArray* items = [positions componentsSeparatedByString:@";"];
    for (NSString* pos in items) {
        ViewPosition* vp = [ViewPosition parse:pos];
        [self setPoistion:vp];
    }
}

-(void)setPoistion:(ViewPosition*)vp {
    UIView* related = [self viewByName:vp.relatedTo];
    if (!related) {
        NSLog(@"invalid position %@", vp);
        return;
    }
    NSNumber* num = [self numberFromString:vp.value];
    if(related == self.superview) {
        if ([ vp.direction isEqualToString:@"hcenter"]) {
            [self hcenterInParent];
        }
        else if ([ vp.direction isEqualToString:@"vcenter"]) {
            [self vcenterInParent];
        }
        else if ([ vp.direction isEqualToString:@"below"]) {
            [self alignParentTopWithMarghin:num.floatValue];
        }
        else if ([ vp.direction isEqualToString:@"above"]) {
            [self alignParentBottomWithMarghin:num.floatValue];
        }
        else if ([ vp.direction isEqualToString:@"left"]) {
            [self alignParentLeftWithMarghin:num.floatValue];
        }
        else if ([ vp.direction isEqualToString:@"right"]) {
            [self alignParentRightWithMarghin:num.floatValue];
        }
    }
    else {
        if ([ vp.direction isEqualToString:@"below"]) {
            [self belowView:related withMargin:num.floatValue];
        }
        else if ([ vp.direction isEqualToString:@"above"]) {
            [self aboveView:related withMargin:num.floatValue];
        }
        else if ([ vp.direction isEqualToString:@"left"]) {
            [self leftOfView:related withMargin:num.floatValue];
        }
        else if ([ vp.direction isEqualToString:@"right"]) {
            [self rightOfView:related withMargin:num.floatValue];
        }
    }
}

-(UIView*)viewByName:(NSString*)name {
    if (!name) {
        return nil;
    }
    if ([name isEqualToString:@"parent"]) {
        return self.superview;
    }
    for (UIView* sibling in self.superview.subviews) {
        NSString* sibid = sibling.ID;
        if (sibid == nil) {
            continue;
        }
        if ([name isEqualToString:sibid]) {
            return sibling;
        }
    }
    for (UIView* child in self.subviews) {
        NSString* childid = child.ID;
        if (childid == nil) {
            continue;
        }
        if ([name isEqualToString:childid]) {
            return child;
        }
    }
    return nil;
}

static NSString* csskey = @"mycss";
-(void)loadCssFiles:(NSString *)fileNames {
    NSArray* names = [fileNames componentsSeparatedByString:@" "];
    for (NSString* fileName in names) {
        NSRange r = [fileName rangeOfString:@"."];
        NSString* name = [fileName substringToIndex:r.location];
        NSString* ext = [fileName substringFromIndex:r.location+1];
        ESCssParser *parser = [[ESCssParser alloc] init];
        NSDictionary* dict = [parser parseFile:name type:ext];
        NSMutableDictionary* myCss = [self attachedObjectForKey:csskey defaultValue:[[NSMutableDictionary alloc] init]];
        [myCss addEntriesFromDictionary:dict];
        [self attachObject:myCss forKey:csskey];
    }
}
-(NSDictionary*)myCssDict {
    NSDictionary* myCss = [self attachedObjectForKey:csskey];
    return myCss;
}

+(void)enableCssLayouts:(NSArray *)views :(BOOL)enable {
    for (UIView* view in views) {
        [view setUseCssLayout:enable];
    }
}
@end

