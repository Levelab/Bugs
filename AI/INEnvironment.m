//
//  INEnvironment.m
//  AI
//
//  Created by nikans on 9/13/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import "INEnvironment.h"
#import "INTile.h"
#import "INBugAI.h"
#import "INTileBugProxy.h"

@implementation INEnvironment

@synthesize tiles, bugProxies;


#pragma mark - Generating

- (id)init {
	if (self = [super init])
    {
		self.viewport = 320;
		[self generateMap];
		[self spawnBugs];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBugs:) name:@"updateLife" object:nil ];
	}
	return self;
}

- (void)generateMap {
	
	struct Coordinates extremeCenter;
	extremeCenter.x = arc4random() % self.viewport;
	extremeCenter.y = arc4random() % self.viewport;
	
	self.tiles = [[NSMutableArray alloc] init];
	self.tilesWithKeys = [[NSMutableArray alloc] init];
	
	int gradationGap = (int)(pow(self.viewport, 2)*2) / 4/*grad scale*/ / 10/*grad num*/;
	//NSLog(@"grad %i", gradationGap);

	
	for (int y = 0; y < self.viewport; y++) {
		[self.tilesWithKeys insertObject:[NSMutableArray arrayWithCapacity:self.viewport] atIndex:y];
		
		for (int x = 0; x < self.viewport; x++) {
			
			float status = 0.0f;
			int sqHypotenuse = pow(x-extremeCenter.x, 2) + pow(y-extremeCenter.y, 2);
			
			if (sqHypotenuse < gradationGap*10/*grad num*/ && sqHypotenuse != 0) {
				//if(y % 50 == 0) { NSLog(@"%i-%i: %i = %f", x, y, sqHypotenuse, ceil(sqHypotenuse / gradationGap)); }
				status = (float)( 100 - 100/ 10 * ceil(sqHypotenuse / gradationGap) );
			}
			else if (sqHypotenuse == 0)
				status = 100.0f;
			
			INTile *tmp_tile = [[INTile alloc] initWithX:x y:y andStatus:status];
			[self.tiles addObject:tmp_tile];
						
			[[self.tilesWithKeys objectAtIndex:y] insertObject:tmp_tile atIndex:x];
		}
	}
	
	//NSLog(@"%@", self.tilesWithKeys);
	
	for (INTile *tmp_tile in self.tiles) {
		[tmp_tile findAdjacentAmongTiles:self.tilesWithKeys];
	}
	
	//NSLog(@"MAP");
}

- (void)spawnBugs {
	//NSLog(@"BUGZ");
	int bugsCount = 100;
	self.bugProxies = [[NSMutableDictionary alloc] init];
	
	NSArray *habitableTiles = [self.tiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(status >= 20) AND (status <= 90)"]];
	//NSLog(@"Habitable %i", [habitableTiles count]);
	for (int i = 0; i < bugsCount; i++) {
		
		bool isOccupied = NO;
		while (isOccupied == NO) {
			NSUInteger randomTileIndex = arc4random() % [habitableTiles count];
			INTile *randomTile = [habitableTiles objectAtIndex:randomTileIndex];
			if (randomTile.occupant == nil) {
				isOccupied = YES;
				INBug *tmp_bug = [[INBug alloc] init];
				randomTile.occupant = tmp_bug;
				INTileBugProxy *proxy = [[INTileBugProxy alloc] initWithBug:tmp_bug onTile:randomTile];
				[self.bugProxies setObject:proxy forKey:tmp_bug.name];
			}
		}
	}
	//NSLog(@"%@", habitableTiles);
}


#pragma mark - Time is ticking

- (void)updateBugs:(NSNotification *)notification {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		//NSLog(@"UPDATING bugs in Environment : bugs count %i", [self.bugs count]);
	
        for (INTileBugProxy *proxy in [self.bugProxies allValues]) {
            [self affectBug:proxy.bug];
        }
        [[self.bugProxies allValues] makeObjectsPerformSelector:@selector(actAlive)];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMap" object:self];
        });
        
    });
		
}

- (void)affectBug:(INBug *)bug {
    INTileBugProxy *proxy = [self.bugProxies objectForKey:bug.name];
	float stimulusLevel = proxy.tile.status;
	float batteryChange = 0.0f;
    
    // TODO: gradually
    // discomfort zone
	if (stimulusLevel < 50 || stimulusLevel > 70) {
		batteryChange = -0.3f;
		
		// hell
		if (stimulusLevel > 85) {
			batteryChange = -0.5f;
		}
		
		// frozen hell
		else if (stimulusLevel < 25) {
			batteryChange = -1;
		}
	}
    
	// moving
	if (proxy.activity == YES) {
		//batteryChange *= 1.5;
	}
    
    bug.batteryStatus += batteryChange;
	
	//NSLog(@"%@ battery change %f conditions %f", bug.name, batteryChange, stimulusLevel);
	
	// aligning
	if (bug.batteryStatus > 100) {
		bug.batteryStatus = 100;
	}
	else if (bug.batteryStatus < 0) {
		bug.batteryStatus = 0;
	}
}




- (float)getFoodForBug:(INBug *)bug {
	INTileBugProxy *proxy = [self.bugProxies objectForKey:bug.name];
    
    // charging zone
    if (proxy.tile.status >= 55 && proxy.tile.status <= 65) {
        proxy.tile.status -= 10;
        return 3.0f;
    }
    
//	if(proxy.tile.status > 10) {
//        proxy.tile.status -= 10;
//        return 1;
//    }
    
    // TODO extract
    if(proxy.tile.status < 0)
        proxy.tile.status = 0;
    return 0.0f;
}

- (int)getEnvironmentStatusForBug:(INBug *)bug {
	INTileBugProxy *tmp_proxy = [self.bugProxies objectForKey:bug.name];
	return tmp_proxy.tile.status;
}

- (BOOL)performMovementForBug:(INBug *)bug toCoordinates:(Coordinates)coordinates {
	INTileBugProxy *proxy = [self.bugProxies objectForKey:bug.name];
	int destination_x = proxy.tile.x+coordinates.x;
	int destination_y = proxy.tile.y+coordinates.y;
	
	if (destination_x < self.viewport && destination_x >= 0 && destination_y < self.viewport && destination_y >= 0) {
		INTile *new_tile = [[self.tilesWithKeys objectAtIndex:destination_y] objectAtIndex:destination_x];
		if (new_tile.occupant == nil) { // moving...
		//NSLog(@"MOVING %@ to x:%i->%i; y:%i->%i", bug.name, proxy.tile.x, destination_x, proxy.tile.y, destination_y);

			new_tile.occupant = bug;
			proxy.tile.occupant = nil;
			proxy.tile = nil;
			proxy.tile = new_tile;
			proxy.activity = YES;
			return YES;
		}
	}
	return NO;
}


//- (int)getBatteryChangeForBug:(INBugAI *)bug {
//	INBugTileProxy *proxy = [self.bugProxies objectForKey:bug.name];
//	int stimulusLevel = proxy.tile.status;
//	int batteryChange = 0;
//
//// TODO: gradually
//	// comfort zone
//	if (stimulusLevel >= 50 && stimulusLevel <= 70) {
//		
//		// charging zone
//		if (stimulusLevel >= 55 && stimulusLevel <= 65) {
//			batteryChange = 3;
//		}
//	}
//	// discomfort zone
//	else {
//		batteryChange = -0.3f;
//		
//		// hell
//		if (stimulusLevel > 85) {
//			batteryChange = -0.5f;
//		}
//		
//		// frozen hell
//		else if (stimulusLevel < 25) {
//			batteryChange = -1;
//		}
//	}
//	
//	// moving
//	if (proxy.activity == YES) {
//		batteryChange *= 1.5;
//	}
//	bug.batteryStatus += batteryChange;
//	
//	//NSLog(@"%@ battery change %i conditions %i", bug.name, batteryChange, stimulusLevel);
//	
//	// aligning
//	if (bug.batteryStatus > 100) {
//		bug.batteryStatus = 100;
//	}
//	else if (bug.batteryStatus < 0) {
//		bug.batteryStatus = 0;
//	}
//	
//	return batteryChange;
//}

@end
