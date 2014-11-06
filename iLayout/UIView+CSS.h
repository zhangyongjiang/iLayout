//
//  UIView+Theme.h
//
//  Created by Kevin Zhang on 11/2/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CSS)

@property (strong, nonatomic)NSString* ID;
@property (assign, nonatomic)BOOL useCssLayout;

+(void)enableCssLayouts:(NSArray *)views :(BOOL)enable;

-(id)initWithCssClasses:(NSString*)cssCls;
-(id)initWithID:(NSString *)ID ;
-(id)initWithID:(NSString *)ID cssClasses:(NSString*)cssClasses ;
-(id)initWithCssEnabled:(BOOL)enabled;
-(id)initWithFrame:(CGRect)frame andID:(NSString *)ID ;
-(id)initWithFrame:(CGRect)frame andID:(NSString *)ID cssClasses:(NSString*)cssClasses ;
-(id)initWithFrame:(CGRect)frame cssClasses:(NSString*)cssClasses ;

-(void)loadCssFiles:(NSString*)fileNames;
-(void)applyCss;
-(void)addCssClasses:(NSString *)clsNames;

-(NSString*) css:(NSString*)name;
-(NSNumber*) cssAbsNumber:(NSString*)name;
-(NSNumber*) cssNumber:(NSString*)name;
-(CGFloat)   cssAbsNumber:(NSString*)name withDefault:(CGFloat)defvalue;
-(CGFloat)   cssNumber:(NSString*)name withDefault:(CGFloat)defvalue;
-(UIColor*)  cssColor:(NSString*)name;
-(UIColor*)  cssBgColor;
-(NSNumber*) cssWidth;
-(NSNumber*) cssHeight;
-(NSNumber*) cssPadding;
-(CGFloat)   cssPaddingWithDefault:(CGFloat)defvalue;
-(UIFont*)   cssFont;

@end

@interface UITextFieldWithPadding : UITextField
@end
