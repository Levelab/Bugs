//
//  INBugMemorizesCondition.m
//  AI
//
//  Created by Eliah Nikans on 9/26/13.
//  Copyright (c) 2013 nikans. All rights reserved.
//

#import "INBugMemorizesCondition.h"

@implementation INBugMemorizesCondition

@synthesize batteryStatus, feelsLike;

- (id)initWithBatteryStatus:(float)_batteryStatus feelsLike:(INBugCondition)_feeling {
    if (self = [super init])
    {
		self.batteryStatus = _batteryStatus;
		self.feelsLike = _feeling;
	}
	return self;
}

@end
