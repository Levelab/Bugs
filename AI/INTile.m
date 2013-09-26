//
//  INTile.m
//  AI
//
//  Created by nikans on 9/13/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import "INTile.h"

@implementation INTile

@synthesize x, y, status, occupant;

- (INTile *)initWithX:(int)_x y:(int)_y andStatus:(float)_status {
	if (self = [super init])
    {
		self.x = _x;
		self.y = _y;
		self.status = _status;
		self.occupant = nil;
	}
	return self;
}

- (BOOL)isOccupied {
	if(self.occupant != nil)
		return YES;
	return NO;
}

- (BOOL)findAdjacentAmongTiles:(NSMutableArray *)_tiles {
	//for (int y = -1; y <= 1; y++) {
	//for (int x = -1; x <= 1; x++) {
	//NSMutableArray *adj_tiles = [_tiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"x <= %i AND x >= %i AND y < %i AND y > %i", self.x+1, self.x-1, self.y+y, self.y-y]];
	for (int y = -1; y <= 1; y++) {
		for (int x = -1; x <= 1; x++) {
			int diff_x = self.x+x;
			int diff_y = self.y+y;
			if( diff_x > 0 && diff_y > 0 && diff_x < 320 && diff_y < 320 ) {
				[self.adjacentTiles addObject:[[_tiles objectAtIndex:diff_x] objectAtIndex:diff_y] ];
			}
		}
	}
			//self.adjacentTiles = adj_tiles;
	//}
	//}
	//NSLog(@"ADJ %@", self.adjacentTiles);
}

- (NSString*)description {
	return [NSString stringWithFormat:@"%d %d is %f and holds %@", self.x, self.y, self.status, self.occupant];
}

@end
