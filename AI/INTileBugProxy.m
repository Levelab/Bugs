//
//  INBugTileProxy.m
//  AI
//
//  Created by nikans on 9/14/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import "INTileBugProxy.h"
#import "INBug.h"
#import "INTile.h"

@implementation INTileBugProxy

@synthesize bug, tile;

- (id)initWithBug:(INBug *)_bug onTile:(INTile *)_tile {
	if (self = [super init])
    {
		self.bug = _bug;
		self.tile = _tile;
	}
	return self;
}

- (void)actAlive {
	[self.bug actAlive];
}

@end
