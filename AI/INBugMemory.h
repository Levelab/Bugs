//
//  INBugMemory.h
//  AI
//
//  Created by nikans on 9/14/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INBugMemorizesCondition.h"
#import "INBugMemorizesPlace.h"
#import "INBugMemorizesMovement.h"
#import "INBugAI.h"
@class INBugMemorizesMap;

@interface INBugMemory : NSObject

@property (strong, nonatomic) INBugAI *bugAI;
@property (strong, nonatomic) NSMutableArray *conditions;
@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) INBugMemorizesMap *spacial;
@property (strong, nonatomic) INBugMemorizesMovement *lastMovement;

- (id)initWithBugAI:(INBugAI *)_bugAI;

- (void)memorizeConditionWhenBatteryStatusWas:(float)_batteryStatus andItFeltLike:(INBugCondition)_feltLike;
- (INBugMemorizesCondition *)recallLastCondition;
    
- (void)updateSpacialMemory;
- (INBugMemorizesPlace *)memorizePlaceThatFeelsLike:(INBugCondition)_feeling;

- (INBugMemorizesPlace *)recallPreviousPlace;

@end
