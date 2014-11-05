//
//  NSObject+Attach.m
//
//  Created by Kevin Zhang on 11/5/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Attach.h"

@implementation NSObject (Attach)

-(void)attachObject:(id)anObject forKey:(id)aKey {
    NSMutableDictionary* dict = [self getAttachedDictionary:YES];
    [dict setObject:anObject forKey:aKey];
}

-(id)attachedObjectForKey:(id)aKey {
    NSMutableDictionary* dict = [self getAttachedDictionary:NO];
    if (!dict) {
        return nil;
    }
    return [dict objectForKey:aKey];
}

-(id)attachedObjectForKey:(id)aKey defaultValue:(id)defValue{
    NSMutableDictionary* dict = [self getAttachedDictionary:NO];
    id value = [dict objectForKey:aKey];
    return value ? value : defValue;
}

-(NSMutableDictionary *)getAttachedDictionary:(BOOL)createIfNotExist {
    static char key;
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &key);
    if(dict || !createIfNotExist)
        return dict;
    dict = [[NSMutableDictionary alloc] init];
    objc_setAssociatedObject(self, &key, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dict;
}

@end
