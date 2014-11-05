//
//  NSObject+Attach.h
//
//  Created by Kevin Zhang on 11/5/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Attach)

- (id)attachedObjectForKey:(id)aKey;
- (void)attachObject:(id)anObject forKey:(id)aKey;
-(id)attachedObjectForKey:(id)aKey defaultValue:(id)defValue;

@end
