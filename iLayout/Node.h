//
//  Tree.h
//  NextShopperSwift
//
//  Created by Kevin Zhang on 11/9/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject
@property(strong, nonatomic)id nodeid;
@property(strong, nonatomic)NSMutableArray* subnodes;

-(Node*)search:(Node*)node;
-(void)addSubnode:(Node*)subnode;
@end
