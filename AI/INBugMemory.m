//
//  INBugMemory.m
//  AI
//
//  Created by nikans on 9/14/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import "INBugMemory.h"
#import "NSMutableArray+Stack.m"
#import "INBugMemorizesMap.h"

@implementation INBugMemory

@synthesize bugAI, conditions, places, spacial, lastMovement;

- (id)init {
    NSLog(@"You can't init Bug Memory without the brain");
    return nil;
}

- (id)initWithBugAI:(INBugAI *)_bugAI {
	if (self = [super init])
    {
        self.bugAI = _bugAI;
        self.conditions = [NSMutableArray arrayWithCapacity:30];
		self.places = [NSMutableArray arrayWithCapacity:30];
		self.spacial = [[INBugMemorizesMap alloc] init];
		self.lastMovement = [[INBugMemorizesMovement alloc] init];
	}
	return self;
}


#pragma mark - Recall Conditions

- (void)memorizeConditionWhenBatteryStatusWas:(float)_batteryStatus andItFeltLike:(INBugCondition)_feltLike {
    [self.conditions addObject:
     [[INBugMemorizesCondition alloc] initWithBatteryStatus:_batteryStatus feelsLike:_feltLike]
    ];
}

- (INBugMemorizesCondition *)recallLastCondition {
    return [self.conditions lastObject];
}



#pragma mark — Recall Places

- (void)updateSpacialMemory {
	//NSLog(@"-----");
    if (self.lastMovement.x != 0 && self.lastMovement.y != 0 && self.lastMovement != nil) { // WUT
        [self.places makeObjectsPerformSelector:@selector(updateCoordinates:) withObject:self.lastMovement];
        [self.spacial redrawMapWithData:self.places];
    }
	//NSLog(@"MAP %@", self.spacial.map);
}

- (INBugMemorizesPlace *)memorizePlaceThatFeelsLike:(INBugCondition)_feeling {
	INBugMemorizesPlace *place = [[INBugMemorizesPlace alloc] initWithX:0 andY:0 feelsLike:_feeling];
	
	/*if (self.lastMovement.x == 0 && self.lastMovement.y == 0) {
		if ([self.places count] > 0)
			[self.places removeObjectAtIndex:0];
	}*/
	
	[self.places push:place];
	
	/*if([self.places count] > 30) {
		[self.places pop];
	}*/
	
	//NSLog(@"%@", self.places);
	
	return place;
}

- (INBugMemorizesPlace *)recallPreviousPlace {
	if( [self.places count] > 1 && (self.lastMovement.x != 0 && self.lastMovement.y != 0) )
		return [self.places objectAtIndex:[self.places count]-2];
	return nil;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Spatial %@", self.spacial];
}


@end
