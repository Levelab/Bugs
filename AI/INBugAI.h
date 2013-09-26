//
//  INBugAI.h
//  AI
//
//  Created by nikans on 9/13/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INAppDelegate.h"
#import "INBug.h"
@class INBugMemory;
@class INBugMemorizesPlace;

@interface INBugAI : NSObject

typedef enum INBugFeedCondition {
    INBugFeedConditionPerfect,
	INBugFeedConditionHappy,
	INBugFeedConditionSatisfied,
	INBugFeedConditionDissatisfied,
	INBugFeedConditionEmaciated,
	INBugFeedConditionLifeless,
	INBugFeedConditionDead
} INBugCondition;

typedef enum INBugActions {
	INBugActionStay,
	INBugActionWonder,
	INBugActionGoBack
} INBugActions;

@property (strong, nonatomic) INAppDelegate *appDelegate;

@property (nonatomic, strong) INBug *body;
//@property (nonatomic) float batteryStatus;
@property (nonatomic) INBugCondition iAmFeeling;
@property (strong, nonatomic) INBugMemory *memory;
@property (strong, nonatomic) INBugMemorizesPlace *whereAmI;

- (id)initWithBody:(INBug *)_body;

- (BOOL)actAlive;

- (int)feel;
- (INBugCondition)evaluateFeelings:(int)_batteryChange;
- (void)expressFeelings;
- (void)memorizeFeeling;

- (BOOL)feed;


- (INBugMemorizesPlace *)recallPreviousPlace;
- (INBugActions)evaluateMoveAction;
- (INBugActions)decideWhatToDo:(INBugMemorizesPlace *)comparing;
- (BOOL)moveBack;
- (BOOL)moveRandomly;
- (BOOL)moveToX:(int)_x andY:(int)_y;

+ (Coordinates)generateDirections;

@end
