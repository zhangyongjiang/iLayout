//
//  UITextField+Active.m
//
//  Created by Kevin Zhang on 10/31/14.
//

#import <objc/runtime.h>
#import "UITextField+Active.h"
#import "UIView+Position.h"
#import "UIView+CSS.h"

@interface UITextField() <UITextFieldDelegate>

@end

static UITextField* gCurrentActiveTextField;

@implementation UITextField (Active)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod([UITextField class], @selector(setDelegateNew:)), class_getInstanceMethod([self class], @selector(setDelegate:)));
        method_exchangeImplementations(class_getInstanceMethod([UITextField class], @selector(initWithFrameNew:)), class_getInstanceMethod([self class], @selector(initWithFrame:)));
    });
}

-(void)setDelegateNew:(id<UITextFieldDelegate>)delegate {
    ViewData* vd = [self getViewData];
    if (self != delegate) {
        vd.delegate = delegate;
    }
    else
        [self setDelegateNew:delegate];
}

-(id)initWithFrameNew:(CGRect)frame {
    self = [self initWithFrameNew:frame];
    self.delegate = self;
    return self;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    gCurrentActiveTextField = self;
    ViewData* vd = [self getViewData];
    if (vd.delegate) {
        SEL sel = @selector(textFieldDidBeginEditing:);
        if ([vd.delegate respondsToSelector:sel]) {
            [vd.delegate performSelector:sel withObject:self];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    gCurrentActiveTextField = nil;
    ViewData* vd = [self getViewData];
    if (vd.delegate) {
        SEL sel = @selector(textFieldDidEndEditing:);
        if ([vd.delegate respondsToSelector:sel]) {
            [vd.delegate performSelector:sel withObject:self];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    ViewData* vd = [self getViewData];
    if (vd.delegate) {
        SEL selector = @selector(textField:shouldChangeCharactersInRange:replacementString:);
        if ([vd.delegate respondsToSelector:selector]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [[vd.delegate class] instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:vd.delegate];
            
            [invocation setArgument:&textField atIndex:2];
            [invocation setArgument:&range atIndex:3];
            [invocation setArgument:&string atIndex:4];
            
            [invocation invoke];
            BOOL returnValue;
            [invocation getReturnValue:&returnValue];
            return returnValue;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.superview movetoNextSubview];
    ViewData* vd = [self getViewData];
    if (vd.delegate) {
        SEL selector = @selector(textFieldShouldReturn:);
        if ([vd.delegate respondsToSelector:selector]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [[vd.delegate class] instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:vd.delegate];
            
            [invocation setArgument:&textField atIndex:2];
            
            [invocation invoke];
            BOOL returnValue;
            [invocation getReturnValue:&returnValue];
            return returnValue;
        }
    }
    return YES;
}

+(UITextField*)activeTextField {
    return gCurrentActiveTextField;
}

@end
