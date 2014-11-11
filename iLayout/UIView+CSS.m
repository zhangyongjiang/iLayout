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
#import "UIView+Autolayout.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+String.h"
#import "NSObject+Attach.h"
#import "Node.h"

static CssFileList* defaultThemes;
static NSMutableDictionary* classCssCache;

@implementation CssFile
{
    NSMutableDictionary* entries;
}

-(id)init {
    self = [super init];
    entries = [[NSMutableDictionary alloc] init];
    return self;
}

-(NSString*)cssProperty:(NSString *)propertyName forSelector:(NSString *)selector {
    NSMutableDictionary* dict = [entries objectForKey:selector];
    if (!dict) {
        return nil;
    }
    return [dict objectForKey:propertyName];
}

-(void)addEntry:(NSMutableDictionary *)entry forSelector:(NSString *)selector {
    [entries setObject:entry forKey:selector];
}
@end

@implementation CssFileList

-(id)init {
    self = [super init];
    self.files = [[NSMutableArray alloc] init];
    return self;
}

-(void)addCssFile:(CssFile *)file {
    [self.files addObject:file];
}

-(NSString*)cssProperty:(NSString *)propertyName forSelector:(NSString *)selector {
    for (CssFile* cf in self.files) {
        NSString* value = [cf cssProperty:propertyName forSelector:selector];
        if (value) {
            return value;
        }
    }
    return nil;
}

@end


@implementation UICollectionView (CSS)
-(void)applyCss {
    [super applyCss];
    if(self.useCssLayout) {
    }
}
@end

@implementation UILabel (CSS)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod([UIView class], @selector(swizzle_setText:)), class_getInstanceMethod([self class], @selector(setText:)));
    });
}

-(void)swizzle_setText:(NSString *)text {
    [self swizzle_setText:text];
    [self applyCssTextDecoration];
}

-(void)applyCssProperties {
    if(self.useCssLayout) {
        UIFont* font = [self cssFont];
        if (font && ![font isEqual:self.font]) {
            self.font = font;
        }
        
        NSNumber* lines = [self cssNumber:@"numberOfLines"];
        if (lines && lines.integerValue != self.numberOfLines) {
            self.numberOfLines = lines.integerValue;
        }
        
        NSString* textAlignment = [self css:@"textAlignment"];
        if (textAlignment) {
            NSTextAlignment newAlignment=0;
            if ([textAlignment isEqualToString:@"center"]) {
                newAlignment = NSTextAlignmentCenter;
            }
            if ([textAlignment isEqualToString:@"left"]) {
                newAlignment = NSTextAlignmentLeft;
            }
            if ([textAlignment isEqualToString:@"right"]) {
                newAlignment = NSTextAlignmentRight;
            }
            if (self.textAlignment != newAlignment) {
                self.textAlignment = newAlignment;
            }
        }
        
        NSNumber* preferredMaxLayoutWidth = [self cssNumber:@"preferredMaxLayoutWidth"];
        if(preferredMaxLayoutWidth) {
            self.preferredMaxLayoutWidth = preferredMaxLayoutWidth.floatValue;
        }
        
        UIColor* color = [self cssColor:@"color"];
        if (color) {
            self.textColor = color;
        }
        
        NSString* currentText = self.text;
        NSString* text = [self css:@"text"];
        if (text && ![text isEqualToString:currentText]) {
            self.text = text;
        }
        
        [self applyCssTextDecoration];
    }
    
    [super applyCssProperties];
}

-(void)applyCssTextDecoration {
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

-(void)applyCssProperties {
    [super applyCssProperties];
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
    posStr = [posStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (posStr.length==0) {
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

-(void)applyCssProperties {
    [super applyCssProperties];

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

@implementation UIImageView(CSS)

-(void)applyCssProperties {
    [super applyCssProperties];
    
    if (self.useCssLayout) {
        NSString* value = [self css:@"img-name"];
        if (value) {
            self.image = [UIImage imageNamed:value];
        }
        
        value = [self css:@"content-mode"];
        if(value) {
            if([value isEqualToString:@"ScaleToFill"]) {
                self.contentMode = UIViewContentModeScaleToFill;
            }
            if([value isEqualToString:@"ScaleAspectFit"]) {
                self.contentMode = UIViewContentModeScaleAspectFit;
            }
            if([value isEqualToString:@"ScaleAspectFill"]) {
                self.contentMode = UIViewContentModeScaleAspectFill;
            }
            if([value isEqualToString:@"Redraw"]) {
                self.contentMode = UIViewContentModeRedraw;
            }
            if([value isEqualToString:@"Center"]) {
                self.contentMode = UIViewContentModeCenter;
            }
            if([value isEqualToString:@"Top"]) {
                self.contentMode = UIViewContentModeTop;
            }
            if([value isEqualToString:@"Bottom"]) {
                self.contentMode = UIViewContentModeBottom;
            }
            if([value isEqualToString:@"Left"]) {
                self.contentMode = UIViewContentModeLeft;
            }
            if([value isEqualToString:@"Right"]) {
                self.contentMode = UIViewContentModeRight;
            }
            if([value isEqualToString:@"TopLeft"]) {
                self.contentMode = UIViewContentModeTopLeft;
            }
            if([value isEqualToString:@"TopRight"]) {
                self.contentMode = UIViewContentModeTopRight;
            }
            if([value isEqualToString:@"BottomLeft"]) {
                self.contentMode = UIViewContentModeBottomLeft;
            }
            if([value isEqualToString:@"BottomRight"]) {
                self.contentMode = UIViewContentModeBottomRight;
            }
        }
                             
    }
}

@end


@implementation UIView (CSS)

+ (void)load
{
    static dispatch_once_t onceToken;
    
    defaultThemes = [[CssFileList alloc] init];
    classCssCache = [[NSMutableDictionary alloc] init];
    
    CssFile* cf = [UIView loadCssFromFile:@"default.css"];
    if (cf) {
        [defaultThemes addCssFile:cf];
    }
    
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod([UIView class], @selector(initWithFrame_swizzle:)), class_getInstanceMethod([self class], @selector(initWithFrame:)));
        method_exchangeImplementations(class_getInstanceMethod([UIView class], @selector(setFrame_swizzle:)), class_getInstanceMethod([self class], @selector(setFrame:)));
        method_exchangeImplementations(class_getInstanceMethod([UIView class], @selector(swizzle_addSubview:)), class_getInstanceMethod([self class], @selector(addSubview:)));
    });
}

-(void)setFrame_swizzle:(CGRect)frame {
    [self setFrame_swizzle:frame];
}

-(void)breadthFirst:(NSMutableArray*)nodes :(NSMutableArray*)queue {
    if (!nodes || nodes.count==0) {
        return;
    }
    NSMutableArray* nextLevel = [[NSMutableArray alloc] init];
    for(Node* n in nodes) {
        [queue addObject:n];
        [nextLevel addObjectsFromArray:n.subnodes];
    }
    [self breadthFirst:nextLevel :queue];
}

-(id)initWithFrame_swizzle:(CGRect)frame {
    self = [self initWithFrame_swizzle:frame];
    [self loadSameNameCss];
    return self;
}

-(void)swizzle_addSubview:(UIView *)view {
    [self swizzle_addSubview:view];
    //    [self bindPropertyToSubview:view];
    NSString* cssClasses = [view css:@"cssClasses"];
    [view addCssClasses:cssClasses];
    if(view.useCssLayout) {
        [view applyCss];
    }
    if (view.ID) {
        NSLog(@"addSubview %@", view.ID);
    }
    [self adjustChildrenPosition];
}

-(void)adjustChildrenSize {
    for (UIView* child in self.subviews) {
        if (child.useCssLayout) {
            NSString* str = [child css:@"width"];
            if (str && [str rangeOfString:@"parent"].location != NSNotFound) {
                NSNumber* num = [child numberFromString:str];
                child.width = num.floatValue;
            }
            str = [child css:@"height"];
            if (str && [str rangeOfString:@"parent"].location != NSNotFound) {
                NSNumber* num = [child numberFromString:str];
                child.height = num.floatValue;
            }
        }
    }
}

-(void)adjustChildrenPosition {
    NSMutableArray* queue = [[NSMutableArray alloc] init];
    Node* node = [self subviewsDependentTree];
    if (!node || !node.subnodes || node.subnodes.count == 0) {
        return;
    }
    [self breadthFirst:node.subnodes :queue];
    for (Node* n in queue) {
        [n.nodeid applyCssPosition];
    }
}

-(void)bindPropertyViewsID {
    Class clazz = [self class];
    NSString* clsName = [UIView simpleClsName:clazz];
    if ([clsName hasPrefix:@"UI"]) {
        return;
    }
    
    u_int count;
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        NSString* key = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        UIView* subview = [self valueForKey:key];
        if (subview) {
            Class cls = [subview class];
            if([UIView isUIView:cls]) {
                if (!subview.ID) {
                    subview.ID = key;
                }
            }
        }
    }
    free(properties);
}

-(void)bindPropertyToView:(UIView*)view {
    [UIView bindPropertyOfObject:self toView:view];
}

+(void)bindPropertyOfObject:(UIView*)obj toView:(UIView*)subview {
    Class clazz = [obj class];
    NSString* clsName = [UIView simpleClsName:clazz];
    if ([clsName hasPrefix:@"UI"] || [clsName hasPrefix:@"_UI"]) {
        return;
    }
    
    u_int count;
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        NSString* key = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        UIView* propValue = [obj valueForKey:key];
        if (propValue && propValue == subview && [UIView isUIView:[propValue class]]) {
            if (!propValue.ID) {
                propValue.ID = key;
            }
            
            NSString* cssClasses = [subview css:@"cssClasses"];
            [subview addCssClasses:cssClasses];
            break;
        }
    }
    free(properties);
}

-(void)loadSameNameCss {
    [self loadSameNameCssForClass:[self class]];
}

-(void)loadSameNameCssForClass:(Class)cls {
    NSString* clsName = [UIView simpleClsName:cls];
    id cached = [classCssCache objectForKey:clsName];
    NSString* file = [NSString stringWithFormat:@"%@.css",clsName];
    if (cached) {
        if ([cached isKindOfClass:[CssFile class]]) {
            NSString* source = [cached cssProperty:@"file-name" forSelector:@"__SOURCE__"];
            if ([file isEqualToString:source]) {
                self.useCssLayout = true;
            }
            [self addCssFile:cached];
        }
    }
    else {
        CssFile* cf = [UIView loadCssFromFile:file];
        if (cf) {
            self.useCssLayout = YES;
            [self addCssFile:cf];
            [classCssCache setObject:cf forKey:clsName];
        }
        else {
            [classCssCache setObject:[NSNumber numberWithBool:false] forKey:clsName];
        }
    }
    if(cls == [UIView class])
        return;
    [self loadSameNameCssForClass:[cls superclass]];
}

-(Node*) subviewsDependentTree {
    Node* root = [[Node alloc] init];
    root.nodeid = self;
    for (UIView* child in self.subviews) {
        NSMutableArray* uniqueDependents = [child uniqueDependents];
        if (uniqueDependents == nil || uniqueDependents.count == 0) {
            continue;
        }
        for (NSString* dep in uniqueDependents) {
            UIView* view = [child viewByName:dep];
            if (!view) {
                NSLog(@"cannot find related view %@", dep);
                return nil;
            }
            Node* node = [root search:view];
            if (!node) {
                node = [[Node alloc] init];
                node.nodeid = view;
                [root addSubnode:node];
                
                Node* childNode = [[Node alloc] init];
                childNode.nodeid = child;
                [node addSubnode:childNode];
            }
            else {
                Node* childNode = [[Node alloc] init];
                childNode.nodeid = child;
                [node addSubnode:childNode];
            }
        }
    }
    return root;
}


-(id)initWithCssEnabled:(BOOL)enabled {
    self = [self initWithFrame:CGRectZero];
    self.useCssLayout = enabled;
    [self applyCssSize];
    return self;
}

-(id)initWithCssClasses:(NSString *)cssCls {
    self = [self initWithFrame:CGRectZero];
    self.useCssLayout = YES;
    [self addCssClasses:cssCls];
    [self applyCssSize];
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
    [self applyCssSize];
    return self;
}

-(id)initWithFrame:(CGRect)frame cssClasses:(NSString *)cssClasses {
    self = [self initWithFrame_swizzle:frame];
    self.useCssLayout = YES;
    [self addCssClasses:cssClasses];
    [self applyCssSize];
    return self;
}

-(id)initWithFrame:(CGRect)frame andID:(NSString *)ID {
    self = [self initWithFrame_swizzle:frame];
    self.useCssLayout = YES;
    self.ID = ID;
    return self;
}

-(id)initWithFrame:(CGRect)frame andID:(NSString *)ID cssClasses:(NSString *)cssClasses {
    self = [self initWithFrame_swizzle:frame];
    self.useCssLayout = YES;
    self.ID = ID;
    [self addCssClasses:cssClasses];
    [self applyCssSize];
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
}

-(void)applyCssRecursive {
    [self applyCss];
    NSArray* subviews = self.subviews;
    if (subviews == nil || subviews.count==0) {
        return;
    }
    NSMutableArray* remain = [[NSMutableArray alloc] init];
    for (UIView* subview in subviews) {
        [remain addObject:subview];
    }
    
    while (remain.count > 0) {
        [self applyCssForSubview:[remain objectAtIndex:0] tracker:[[NSMutableSet alloc] init] remain:remain];
    }
}

-(void)applyCssForSubview:(UIView*)subview tracker:(NSMutableSet*)tracker remain:(NSMutableArray*)remain {
    if ([tracker containsObject:subview]) {
        NSLog(@"dead loop %@", subview.ID);
        return;
    }
    [tracker addObject:subview];
    
    NSMutableArray* uniqueDependents = [subview uniqueDependents];
    if (!uniqueDependents || uniqueDependents.count == 0) {
        [subview applyCss];
        [remain removeObject:subview];
        return;
    }
    if (uniqueDependents.count == 1 && [[uniqueDependents objectAtIndex:0] isEqualToString:@"parent"]) {
        [subview applyCss];
        [remain removeObject:subview];
        return;
    }
    [uniqueDependents removeObject:@"parent"];
    for (NSString* dependent in uniqueDependents) {
        UIView* sibling = [self viewByName:dependent];
        if (!sibling) {
            NSLog(@"sibling %@ doesn't exist", dependent);
            continue;
        }
        if (![remain containsObject:sibling]) {
            continue;
        }
        [self applyCssForSubview:sibling tracker:tracker remain:remain];
    }
    [subview applyCss];
    [remain removeObject:subview];
}

-(void)applyCss:(NSString*)cssClasses {
    self.useCssLayout = YES;
    [self addCssClasses:cssClasses];
    [self applyCss];
}

-(void)applyCssPosition {
    if(self.useCssLayout) {
        [self applyCssPositions];
    }
}

-(void)applyCssSize {
    if(self.useCssLayout) {
        NSNumber* num = [self cssNumber:@"width"];
        if(num) self.width = num.floatValue;
        
        num = [self cssNumber:@"height"];
        if(num) self.height = num.floatValue;
    }
}

-(void)applyCssProperties {
    if(self.useCssLayout) {
        UIColor* bgColor = [self cssBgColor];
        if (bgColor) {
            self.backgroundColor = bgColor;
        }
        
        NSNumber* cornerRadius = [self cssNumber:@"corner-radius"];
        if (cornerRadius) {
            self.layer.cornerRadius = cornerRadius.floatValue;
        }
        
        NSString* masksToBounds = [self css:@"masks-to-bounds"];
        if (masksToBounds && [masksToBounds isEqualToString:@"true"]) {
            self.layer.masksToBounds = YES;
        }
    }
}

-(void)applyCss {
    if(self.useCssLayout) {
        NSLog(@"applycss for %@ (%@ %f %f %f %f)", [self class], self.ID, self.x, self.y, self.width, self.height);
        [self applyCssProperties];
        [self applyCssSize];
        [self applyCssPosition];
    }
}

-(CGFloat)scale
{
    return  [UIScreen mainScreen].bounds.size.width / 320.0;
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

    if ([strNum hasSuffix:@"!"]) {
        strNum = [strNum substringToIndex:(strNum.length-1)];
        return [NSNumber numberWithFloat:[strNum floatValue]];
    }
    else {
        return [NSNumber numberWithFloat:([strNum floatValue] * [self scale])];
    }
}

-(NSNumber*) cssNumber:(NSString*)name {
    NSString* strNum = [self css:name];
    return [self numberFromString:strNum];
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
        img = [UIView imageWithImage:img scaledToSize:CGSizeMake(self.width, self.height)];
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
        NSLog(@"isUIView:%d", [UIView isUIView:cls]);
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
            if (cls) {
                return cls;
            }
//            [clazzName insertString:@"NextShopperSwift." atIndex:0];
//            cls = NSClassFromString(clazzName);
//            if (cls) {
//                return cls;
//            }
        }
    } 
    return nil;
}

+(BOOL)isUIView:(Class)cls {
    while (cls != nil) {
        if (cls == [UIView class]) {
            return YES;
        }
        cls = [cls superclass];
    }
    return NO;
}

-(void)applyCssPositions {
    NSArray* positions = [self positions];
    if (!positions) {
        return;
    }
    BOOL hasAll = YES;
    NSMutableArray* uniqueDependents = [self uniqueDependents];
    for (NSString* dep in uniqueDependents) {
        if (![self viewByName:dep]) {
            NSLog(@"related view %@ are not ready for view %@ ", dep, self.ID);
            hasAll = NO;
            break;
        }
    }
    if (!hasAll) {
        return;
    }
    NSLog(@"applyCssPositions for view %@ ", self.ID);
    for (ViewPosition* vp in positions) {
        [self setPoistion:vp];
    }
}

-(NSMutableArray*)positions {
    NSString* positions = [self css:@"positions"];
    if (!positions) {
        return nil;
    }
    positions = [positions stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSArray* items = [positions componentsSeparatedByString:@";"];
    NSMutableArray* depends = [[NSMutableArray alloc] init];
    for (NSString* pos in items) {
        ViewPosition* vp = [ViewPosition parse:pos];
        if (vp) {
            [depends addObject:vp];
        }
    }
    return depends;
}

-(NSMutableArray*)uniqueDependents {
    NSMutableArray* positions = [self positions];
    if (positions == nil || positions.count == 0) {
        return nil;
    }
    NSMutableArray* depends = [[NSMutableArray alloc] init];
    for (ViewPosition* vp in positions) {
        NSString* relatedto = vp.relatedTo;
        if (![depends containsObject:relatedto]) {
            [depends addObject:relatedto];
        }
    }
    return depends;
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
        CssFile* cf = [UIView loadCssFromFile:fileName];
        if (cf) {
            CssFileList* cfl = [self attachedObjectForKey:csskey];
            if (!cfl) {
                cfl = [[CssFileList alloc] init];
            }
            [cfl addCssFile:cf];
            [self attachObject:cfl forKey:csskey];
        }
    }
}
-(CssFileList*)myCssFiles {
    CssFileList* myCss = [self attachedObjectForKey:csskey];
    return myCss;
}
-(void)addCssFile:(CssFile*)cssFile {
    CssFileList* cfl = [self attachedObjectForKey:csskey];
    if (!cfl) {
        cfl = [[CssFileList alloc] init];
    }
    [cfl addCssFile:cssFile];
    [self attachObject:cfl forKey:csskey];
}

-(void)addSubviews:(NSArray *)views
{
    for (UIView *view in views) {
        [self addSubview:view];
    }
}

-(void)enableCssLayouts:(NSArray *)views :(BOOL)enable {
    for (UIView* view in views) {
        [self bindPropertyToView:view];
        [view setUseCssLayout:enable];
    }
}

-(void)addCssClasses:(NSString *)clsNames {
    if (clsNames == nil || clsNames.length == 0) {
        return;
    }
    self.useCssLayout = YES;
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

-(NSMutableArray*)cssClasses {
    ViewData* vd = [self getViewData];
    return vd.cssClasses;
}

-(NSString*)css:(NSString *)name forCssClass:(NSString*)cssCls {
    NSString* selector = [NSString stringWithFormat:@".%@", cssCls];
    NSString* value = [self css:name forSelector:selector];
    if (value) {
        return value;
    }
    NSString* parents = [self css:@"extends" forSelector:selector];
    parents = [self unescape:parents];
    for (NSString* parent in [parents componentsSeparatedByString:@" "]) {
        value = [self css:name forCssClass:parent];
        if (value) {
            return value;
        }
    }
    return nil;
}

-(NSString*)css:(NSString *)name {
    NSString* ID = self.ID;
    if (ID) {
        NSString* selector = [NSString stringWithFormat:@"#%@", ID];
        NSString* value = [self css:name forSelector:selector];
        if (value) {
            value = [self unescape:value];
            return value;
        }
    }
    
    NSMutableArray* cssClasses = [self cssClasses];
    for (NSString* cssCls in cssClasses) {
        NSString* value = [self css:name forCssClass:cssCls];
        if (value) {
            value = [self unescape:value];
            return value;
        }
    }
    
    Class objCls = [self class];
    do {
        NSString* cssCls = [UIView simpleClsName:objCls];
        NSString* selector = [NSString stringWithFormat:@".%@", cssCls];
        NSString* value = [self css:name forSelector:selector];
        if (value) {
            value = [self unescape:value];
            return value;
        }
        objCls = [objCls superclass];
    } while (objCls != [UIResponder class]);
    
    NSString* value = [self css:name forSelector:@"*"];
    if (value) {
        value = [self unescape:value];
        return value;
    }
    
    return nil;
}

-(NSString*)unescape:(NSString*)value {
    return [value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
}

-(NSString*)css:(NSString *)name forSelector:(NSString*)selector {
    UIView* view = self;
    while (view != nil) {
        CssFileList* cfl = [view myCssFiles];
        NSString* value = [cfl cssProperty:name forSelector:selector];
        if (value) {
            return value;
        }
        view = view.superview;
    }
    NSString* value = [defaultThemes cssProperty:name forSelector:selector];
    if (value) {
        return value;
    }
    
    return nil;
}

+(CssFile*)loadCssFromFile:(NSString*)fileName {
    NSRange r = [fileName rangeOfString:@"."];
    NSString* name = [fileName substringToIndex:r.location];
    NSString* ext = [fileName substringFromIndex:r.location+1];
    CssFile* cf = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        ESCssParser *parser = [[ESCssParser alloc] init];
        NSDictionary* dict = [parser parseFile:name type:ext];
        [dict setValue:[[NSDictionary alloc] initWithObjectsAndKeys:fileName, @"file-name", nil] forKey:@"__SOURCE__"];
    
        cf = [[CssFile alloc] init];
        for (NSString* key in dict) {
                [cf addEntry:[dict objectForKey:key] forSelector:key];
            }
    }
    return cf;
}

@end

