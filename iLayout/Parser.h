//
//  Parser.h
//  NextShopperSwift
//
//  Created by Kevin Zhang on 11/12/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject
-(NSDictionary*)parseFile:(NSString*)name type:(NSString*)ext;
@end
