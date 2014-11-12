//
//  Parser.m
//  NextShopperSwift
//
//  Created by Kevin Zhang on 11/12/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

#import "Parser.h"

@interface Block : NSObject
@property(strong, nonatomic)NSString* idOrClass;
@property(strong, nonatomic)NSMutableDictionary* definitions;
@end

@implementation Block

-(id)init {
    self = [super init];
    self.definitions = [[NSMutableDictionary alloc] init];
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"%@:%@", self.idOrClass, self.definitions];
}
@end

@implementation Parser
-(NSDictionary*)parseFile:(NSString*)name type:(NSString*)ext {
    NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:ext]
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    NSArray* lines = [self linesOfString:content];
    NSArray* blocks = [self blocksFromLines:lines];
    NSMutableDictionary *styleSheet = [[NSMutableDictionary alloc] init];
    for (Block* block in blocks) {
        [styleSheet setObject:block.definitions forKey:block.idOrClass];
    }
    NSLog(@"%@", styleSheet);
    return styleSheet;
}

-(NSArray*)linesOfString:(NSString*)content {
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSArray *lines = [content componentsSeparatedByString:@"\n"];
    return lines;
}

-(NSArray*)blocksFromLines:(NSArray*)lines {
    NSMutableArray* blocks = [[NSMutableArray alloc] init];
    Block* current = [[Block alloc] init];
    NSMutableString* continued = [[NSMutableString alloc] init];
    for (NSString* line in lines) {
        NSString* trimed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimed.length == 0 || [trimed isEqualToString:@"}"]) {
            if (current.idOrClass && current.definitions.count>0) {
                [blocks addObject:current];
            }
            current = [[Block alloc] init];
            continued = [[NSMutableString alloc] init];
            continue;
        }
        if (![line hasPrefix:@" "] && ![line hasPrefix:@"\t"]) {
            trimed = [trimed stringByReplacingOccurrencesOfString:@"{" withString:@""];
            trimed = [trimed stringByReplacingOccurrencesOfString:@" " withString:@""];
            current.idOrClass = trimed;
        }
        else {
            if (continued.length!=0) {
                [continued appendString:@" "];
            }
            [continued appendString:trimed];
            if ([line hasPrefix:@"        "] || [line hasPrefix:@"\t\t"] || [line hasPrefix:@"    \t"] || [line hasPrefix:@"\t    "]) {
            }
            else {
                NSRange range = [continued rangeOfString:@":"];
                if (range.location == NSNotFound || range.location == (continued.length-1)) {
                    continue;
                }
                else {
                    NSString* key = [continued substringToIndex:range.location];
                    key = [key stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSString* value = [continued substringFromIndex:(range.location+1)];
                    if ([value hasSuffix:@";"]) {
                        value = [value substringToIndex:value.length-1];
                    }
                    [current.definitions setObject:value forKey:key];
                    continued = [[NSMutableString alloc] init];
                }
            }
        }
    }
    if (current.idOrClass && current.definitions.count>0) {
        [blocks addObject:current];
    }
    return blocks;
}
@end
