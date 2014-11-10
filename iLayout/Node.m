//
//  Tree.m
//  NextShopperSwift
//
//  Created by Kevin Zhang on 11/9/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import "Tree.h"

@implementation Node

-(Node*)search:(Node *)node {
    if ([node.nodeid isEqual:self.nodeid]) {
        return self;
    }
    for (Node* child in self.subnodes) {
        Node* found = [child search:node];
        if (found) {
            return found;
        }
    }
    return nil;
}

-(void)addSubnode:(Node *)subnode {
    if (!self.subnodes) {
        self.subnodes = [[NSMutableArray alloc] init];
        [self.subnodes addObject:subnode];
    }
    else {
        for (Node* sub in self.subnodes) {
            if ([sub.nodeid isEqual:subnode.nodeid]) {
                return;
            }
        }
        [self.subnodes addObject:subnode];
    }
}
@end
