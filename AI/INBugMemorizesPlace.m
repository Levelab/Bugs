//
//  INBugRemembersPlaces.m
//  AI
//
//  Created by nikans on 9/14/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import "INBugMemorizesPlace.h"
#import "INBugMemory.h"
#import "INBugMemorizesMovement.h"

@implementation INBugMemorizesPlace

@synthesize x, y, feelsLike;

- (id)initWithX:(int)_x andY:(int)_y feelsLike:(INBugCondition)_feeling {
	if (self = [super init])
    {
		self.x = _x;
		self.y = _y;
		self.feelsLike = _feeling;
	}
	return self;
}

- (void)updateCoordinates:(INBugMemorizesMovement *)coordinates {
	//NSLog(@"before %@", self);
	self.x += coordinates.x*-1;
	self.y += coordinates.y*-1;
	//NSLog(@"after %@", self);
	//NSLog(@"-----", self);
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Place x:%i y:%i i felt:%i", self.x, self.y, self.feelsLike];
}

@end
