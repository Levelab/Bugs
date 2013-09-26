//
//  INBugBody.m
//  AI
//
//  Created by Eliah Nikans on 9/26/13.
//  Copyright (c) 2013 nikans. All rights reserved.
//

#import "INBug.h"
#import "INBugAI.h"
#import "INEnvironment.h"

@implementation INBug

@synthesize batteryStatus = _batteryStatus, name, AI;

static int names_pool = 0;

- (id)init {
	if (self = [super init])
    {
        self.name = [NSString stringWithFormat:@"Bug #%i", names_pool++];
		self.batteryStatus = 80;
		self.AI = [[INBugAI alloc] initWithBody:self];
    }
	return self;
}

- (BOOL)actAlive {
    float priceForBeingAlive = 0.1f;
    
    if(self.batteryStatus >= priceForBeingAlive) {
        self.batteryStatus -= priceForBeingAlive;
        return [self.AI actAlive];
    }
    NSLog(@"Bug %@ died", self.name);
    return NO;
}

- (BOOL)isAlive {
    if (self.batteryStatus == 0)
        return NO;
    return YES;
}

- (float)feed {
    INAppDelegate *appDelegate = (INAppDelegate *)[[UIApplication sharedApplication] delegate];
    float gotSomeFood = [appDelegate.environment getFoodForBug:self];
	if (gotSomeFood > 0.0f) {
        self.batteryStatus += gotSomeFood;
    }
    return gotSomeFood;
}

- (void)setBatteryStatus:(float)aBatteryStatus {
    if (aBatteryStatus > 100)
        _batteryStatus = 100;
    else if(aBatteryStatus < 0)
        _batteryStatus = 0;
    else
        _batteryStatus = aBatteryStatus;
}

- (float)batteryStatus {
    return _batteryStatus;
}


@end
