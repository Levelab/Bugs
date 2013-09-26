//
//  INEnvironment.h
//  AI
//
//  Created by nikans on 9/13/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INAppDelegate.h"
@class INBug;

@interface INEnvironment : NSObject {
	@private
	NSMutableArray *tiles;
	NSMutableDictionary *bugProxies;
}

@property (strong, nonatomic) NSMutableArray *tiles;
@property (strong, nonatomic) NSMutableArray *tilesWithKeys;
@property (strong, nonatomic) NSMutableDictionary *bugProxies;

@property (nonatomic) int viewport;

- (void)generateMap;
- (void)spawnBugs;
- (void)updateBugs:(NSNotification *)notification;

- (int)getEnvironmentStatusForBug:(INBug *)bug;
- (float)getFoodForBug:(INBug *)bug;
- (BOOL)performMovementForBug:(INBug *)bug toCoordinates:(Coordinates)coordinates;
- (void)affectBug:(INBug *)bug;

@end
