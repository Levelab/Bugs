//
//  INBugAI.m
//  AI
//
//  Created by nikans on 9/13/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import "INBugAI.h"
#import "INEnvironment.h"
#import "INBugMemory.h"
#import "INTileBugProxy.h"
#import "INBugMemorizesPlace.h"
#import "INTile.h"
#import "INBugMemorizesMap.h"

@implementation INBugAI

@synthesize /*name, batteryStatus,*/ iAmFeeling, memory, whereAmI, appDelegate;


#pragma mark - Creating mind

- (id)init {
    NSLog(@"You can't init a bug without a body");
	return nil;
}

- (id)initWithBody:(INBug *)body {
    if (self = [super init])
    {
        self.body = body;
		self.memory = [[INBugMemory alloc] initWithBugAI:self];
		
		// WTF
		self.appDelegate = (INAppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	return self;
}


#pragma mark Time is ticking

- (BOOL)actAlive {
	//dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
	//NSLog(@"------ ACTING --------");

    // FEED
    if (self.iAmFeeling != INBugFeedConditionPerfect) {
        BOOL fed = [self feed];
    }
    
    // FEEL
    int batteryChange = self.body.batteryStatus - [[self.memory recallLastCondition] batteryStatus];
	self.iAmFeeling = [self evaluateFeelings:batteryChange];
    //NSLog(@"%f", self.batteryStatus);

    int stimulusLevel = [self feel]; // TODO react || remember
    [self memorizeFeeling]; // TODO:extract somehow
    [self expressFeelings];

    
    // MOVE
    [self updateSpacialMemory];
	INBugActions tmptmp = [self decideWhatToDo];
	
	//NSLog(@"%@ action %i", self, tmptmp);
	
	//[self decideWhatToDo: [self recallPreviousPlace] ];
	
	//dispatch_async(dispatch_get_main_queue(), ^{
			
	//});
	//});
	
	return YES;
}


#pragma mark Feed

- (BOOL)feed {
    float fed = [self.body feed];
    if (fed > 0.0f)
        return YES;
    else
        return NO;
}



#pragma mark Feelings

- (int)feel {
	return [self.appDelegate.environment getEnvironmentStatusForBug:self.body];
	//NSLog(@"CUR STATUS %i", status);
}

- (INBugCondition)evaluateFeelings:(int)_batteryChange {
    
    INBugCondition condition;
    
    if (self.body.batteryStatus == 100) {
        condition = INBugFeedConditionPerfect;
    }
    else if ((self.body.batteryStatus > 70 && _batteryChange > 0) || self.body.batteryStatus > 90) {
        condition = INBugFeedConditionHappy;
    }
    else if ((self.body.batteryStatus > 40 && _batteryChange > 0) || self.body.batteryStatus > 70) {
        condition = INBugFeedConditionSatisfied;
    }
    else if ((self.body.batteryStatus > 30 && _batteryChange > 0) || self.body.batteryStatus > 50) {
        condition = INBugFeedConditionDissatisfied;
    }
    else if ((self.body.batteryStatus > 10 && _batteryChange > 0) || self.body.batteryStatus > 30) {
        condition = INBugFeedConditionEmaciated;
    }
    else if ((self.body.batteryStatus > 0 && _batteryChange > 0) || self.body.batteryStatus > 10) {
        condition = INBugFeedConditionLifeless;
    }
    else /*if (_bug.batteryStatus > 0)*/ {
        condition = INBugFeedConditionDead;
    }
    
    return condition;
}

- (void)expressFeelings {
    switch (self.iAmFeeling) {
        default:
            break;
    }
}

- (void)memorizeFeeling {
    [self.memory memorizeConditionWhenBatteryStatusWas:self.body.batteryStatus andItFeltLike:self.iAmFeeling];
	[self.memory memorizePlaceThatFeelsLike:self.iAmFeeling];
}


#pragma mark Move

- (void)updateSpacialMemory {
    [self.memory updateSpacialMemory];
}

- (INBugMemorizesPlace *)recallPreviousPlace {
	//NSLog(@"IT WAS BETTER BEFORE %@", [self.memory recallPreviousPlace]);
	return [self.memory recallPreviousPlace];
}

- (INBugActions)evaluateMoveAction {
	
	// staying
	if (self.iAmFeeling == INBugFeedConditionPerfect ||
        self.iAmFeeling == INBugFeedConditionHappy ||
        self.iAmFeeling == INBugFeedConditionSatisfied) {
		return INBugActionStay;
	}
	/*else if ((_bug.iAmFeeling == INBugConditionDissatisfied ||_bug.iAmFeeling == INBugConditionDepressed) &&  [_bug recallPreviousPlace] != nil && [_bug recallPreviousPlace].feelsLike < _bug.iAmFeeling && arc4random() % 3 == 2) {
     return INBugActionGoBack;
     }*/
	
	return INBugActionWonder;
}


- (INBugActions)decideWhatToDo {
	INBugActions action = [self evaluateMoveAction];
	BOOL result;
	if (action == INBugActionWonder) {
		result = [self moveRandomly];
	}
	else if (action == INBugActionGoBack) {
		result = [self moveBack];
	}
    
	if (result == NO) {
		self.memory.lastMovement.x = 0;
		self.memory.lastMovement.y = 0;
	}
	
	return action;
}

- (BOOL)moveBack {
	return [self moveToX:self.memory.lastMovement.x*-1 andY:self.memory.lastMovement.y*-1];
}

- (BOOL)moveRandomly {
	//NSLog(@"I REMEMBER %@", self.memory.spatial);
	
	NSMutableArray *preferableMovements = [NSMutableArray arrayWithCapacity:8];
    NSMutableArray *undesirableMovements = [NSMutableArray arrayWithCapacity:8];
	
	INTileBugProxy *tmp_proxy = [self.appDelegate.environment.bugProxies objectForKey:self.body.name];
	//NSLog(@"I'm on %i, %i", tmp_proxy.tile.x, tmp_proxy.tile.y);
	
	for (int y = -1; y <= 1; y++) {
		for (int x = -1; x <= 1; x++) {
			if(x != 0 && y != 0) { // FIX: OR
				INBugMemorizesPlace *tile = [[self.memory.spacial.map objectForKey:[NSNumber numberWithInt:y] ] objectForKey:[NSNumber numberWithInt:x] ];
				
				// been there
				if (tile != nil) {
                    // good
                    if (tile.feelsLike < self.iAmFeeling) {
                        [preferableMovements removeAllObjects];
                        [preferableMovements addObject:[[INBugMemorizesMovement alloc] initWithX:x andY:y]];
                        NSLog(@"BEEN THERE GOOD %i %i", x, y);
                        break;
                    }
                    // bad
                    else {
                        [undesirableMovements addObject:[[INBugMemorizesMovement alloc] initWithX:x andY:y]];
                        NSLog(@"BEEN THERE BAD %i %i", x, y);
                        break;
                    }
                    
				}
				// hasn't been there
				else {
                    
                }
				
				//NSLog(@"CHECKING TILE for %i:%i %@", x, y, tile);
				
				if(tile == nil) {
					[preferableMovements addObject:[[INBugMemorizesMovement alloc] initWithX:x andY:y]];
					//NSLog(@"-- ADDING %i %i", x, y);
				}
                else {
                    INBugMemorizesMovement *movement = [[INBugMemorizesMovement alloc] initWithX:x andY:y];
                    if (![undesirableMovements indexOfObject:movement]) {
                        [undesirableMovements addObject:movement];
                    }
                }
			}
		}
	}
	
	if ([preferableMovements count] > 0) {
		INBugMemorizesPlace *randomTile = [preferableMovements objectAtIndex:arc4random() % [preferableMovements count]];
		//NSLog(@"x: %i; y: %i, MAP %@", randomTile.x, randomTile.y, self.memory.spacial.map);
		return [self moveToX:randomTile.x andY:randomTile.y];
	}
	else {
        INBugMemorizesPlace *randomTile = [undesirableMovements objectAtIndex:arc4random() % [undesirableMovements count]];
        return [self moveToX:randomTile.x andY:randomTile.y];
	}
	
	return NO;
}

- (BOOL)moveToX:(int)_x andY:(int)_y {
	Coordinates move;
	move.x = _x;
	move.y = _y;
	BOOL mayI = [self.appDelegate.environment performMovementForBug:self.body toCoordinates:move];
	if (mayI == YES) {
		self.memory.lastMovement.x = move.x;
		self.memory.lastMovement.y = move.y;
	}
	return mayI;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ status %i battery %f", self.body.name, self.iAmFeeling, self.body.batteryStatus];
}


@end
