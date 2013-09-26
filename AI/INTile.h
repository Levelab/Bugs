//
//  INTile.h
//  AI
//
//  Created by nikans on 9/13/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INBug;

@interface INTile : NSObject

@property (nonatomic) int x;
@property (nonatomic) int y;
@property (nonatomic) float status;
@property (nonatomic) INBug *occupant;
@property (strong, nonatomic) NSMutableArray *adjacentTiles;

- (id)initWithX:(int)_x y:(int)_y andStatus:(float)_status;
- (BOOL)isOccupied;

- (BOOL)findAdjacentAmongTiles:(NSMutableArray *)_tiles;

@end
