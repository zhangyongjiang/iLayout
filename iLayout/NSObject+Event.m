//
//  NSObject+Event.m
//
//  Created by Kevin Zhang on 11/4/14.
//

#import <objc/runtime.h>
#import "NSObject+Event.h"

static char eventKey;
@implementation NSObject (Event)

-(NSString*)eventName {
    NSString* name = objc_getAssociatedObject(self, &eventKey);
    return name;
}

-(void)setEventName:(NSString *)eventName {
    objc_setAssociatedObject(self, &eventKey,
                        eventName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)fireEvent {
    NSString* ename = self.eventName;
    if (!ename) {
        NSLog(@"No event name");
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ename object:self];
}
@end
