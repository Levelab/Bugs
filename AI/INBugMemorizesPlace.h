//
//  INBugRemembersPlaces.h
//  AI
//
//  Created by nikans on 9/14/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INBugAI.h"
@class INBugMemorizesMovement;

@interface INBugMemorizesPlace : NSObject

@property (nonatomic) int x;
@property (nonatomic) int y;
@property (nonatomic) INBugCondition feelsLike;

- (id)initWithX:(int)_x andY:(int)_y feelsLike:(INBugCondition)_feeling;
- (void)updateCoordinates:(INBugMemorizesMovement *)coordinates;

@end
