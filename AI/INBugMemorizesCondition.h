//
//  INBugMemorizesCondition.h
//  AI
//
//  Created by Eliah Nikans on 9/26/13.
//  Copyright (c) 2013 nikans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INBugAI.h"

@interface INBugMemorizesCondition : NSObject

@property (nonatomic) float batteryStatus;
@property (nonatomic) INBugCondition feelsLike;

- (id)initWithBatteryStatus:(float)_batteryStatus feelsLike:(INBugCondition)_feeling;

@end
