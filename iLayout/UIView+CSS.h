//
//  UIView+Theme.h
//
//  Created by Kevin Zhang on 11/2/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CssFile : NSObject
-(NSString*)cssProperty:(NSString*)propertyName forSelector:(NSString *)selector;
-(void)addEntry:(NSMutableDictionary*)entry forSelector:(NSString *)selector;
@end

@interface CssFileList : NSObject
@property(strong,nonatomic) NSMutableArray* files;
-(NSString*)cssProperty:(NSString*)propertyName forSelector:(NSString *)selector;
-(void)addCssFile:(CssFile*) file;
@end


@interface UIView (CSS)

@property (strong, nonatomic)NSString* ID;
@property (assign, nonatomic)BOOL useCssLayout;

-(id)initWithCssClasses:(NSString*)cssCls;
-(id)initWithID:(NSString *)ID ;
-(id)initWithID:(NSString *)ID cssClasses:(NSString*)cssClasses ;
-(id)initWithCssEnabled:(BOOL)enabled;
-(id)initWithFrame:(CGRect)frame andID:(NSString *)ID ;
-(id)initWithFrame:(CGRect)frame andID:(NSString *)ID cssClasses:(NSString*)cssClasses ;
-(id)initWithFrame:(CGRect)frame cssClasses:(NSString*)cssClasses ;

-(void)applyCssProperties;
-(void)applyCssSize;
-(void)applyCssPosition;

-(void)loadCssFiles:(NSString*)fileNames;
-(void)applyCss;
-(void)applyCss:(NSString*)cssClasses;
-(void)applyCssRecursive;
-(void)addCssClasses:(NSString *)clsNames;
-(NSMutableArray*)cssClasses;
-(void)addSubviews:(NSArray *)views;
-(void)addSubviewsTopToBottom:(NSArray *)views;
-(void)bindPropertyViewsID;

-(NSString*) css:(NSString*)name;
-(NSNumber*) cssNumber:(NSString*)name;
-(CGFloat)   cssNumber:(NSString*)name withDefault:(CGFloat)defvalue;
-(UIColor*)  cssColor:(NSString*)name;
-(UIColor*)  cssBgColor;
-(NSNumber*) cssWidth;
-(NSNumber*) cssHeight;
-(NSNumber*) cssPadding;
-(CGFloat)   cssPaddingWithDefault:(CGFloat)defvalue;
-(UIFont*)   cssFont;
-(NSString*) cssIncludeParent:(NSString*)name;

-(void)enableCssLayouts:(NSArray *)views :(BOOL)enable;
-(void)autoCreateSubviews;
-(void)autoAddSubviews;

+(void)setTheme:(NSString*)name;
+(NSString*)theme;

@end

@interface UITextFieldWithPadding : UITextField
@end
