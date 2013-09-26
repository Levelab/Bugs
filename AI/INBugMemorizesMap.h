//
//  INBugMemorizesMap.h
//  AI
//
//  Created by nikans on 9/15/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INBugMemorizesPlace.h"
#import "INBugAI.h"
#import "INBugMemory.h"

@interface INBugMemorizesMap : NSObject

@property (strong, nonatomic) NSMutableDictionary *map;

- (void)redrawMapWithData:(NSMutableArray *)data;

@end
