//
//  INBugMemorizesMovements.m
//  AI
//
//  Created by nikans on 9/14/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import "INBugMemorizesMovement.h"

@implementation INBugMemorizesMovement

@synthesize x, y;

-(id)initWithX:(int)_x andY:(int)_y {
	if (self = [super init])
    {
		self.x = _x;
		self.y = _y;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Place x:%i y:%i", self.x, self.y];
}

@end
