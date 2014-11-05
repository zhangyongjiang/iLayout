//
//  NSObject+Event.h
//
//  Created by Kevin Zhang on 11/4/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (Event)

@property(strong, nonatomic)NSString* eventName;

-(void)fireEvent;

@end
