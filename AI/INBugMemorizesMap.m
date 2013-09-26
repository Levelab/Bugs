//
//  INBugMemorizesMap.m
//  AI
//
//  Created by nikans on 9/15/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import "INBugMemorizesMap.h"

@implementation INBugMemorizesMap

@synthesize map;

- (id)init {
	if (self = [super init])
    {
		self.map = [NSMutableDictionary dictionaryWithCapacity:30];
	}
	return self;
}

- (void)redrawMapWithData:(NSMutableArray *)data {
	[self.map removeAllObjects];
	for (INBugMemorizesPlace *tile in data) { 
		if([self.map objectForKey:[NSNumber numberWithInt:tile.y] ] == nil) {
			[self.map setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:[NSNumber numberWithInt:tile.y] ];
		}
		[[self.map objectForKey:[NSNumber numberWithInt:tile.y]] setObject:tile forKey:[NSNumber numberWithInt:tile.x]];
	}
	
	//NSLog(@"MAP %@", self.map);
}

@end
