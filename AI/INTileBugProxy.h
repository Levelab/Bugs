//
//  INBugTileProxy.h
//  AI
//
//  Created by nikans on 9/14/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import <Foundation/Foundation.h>
@class INBug;
@class INTile;

@interface INTileBugProxy : NSObject

@property (strong, nonatomic) INBug *bug;
@property (strong, nonatomic) INTile *tile;
@property (nonatomic) BOOL *activity; // TODO: types

- (id)initWithBug:(INBug *)_bug onTile:(INTile *)_tile;
- (void)actAlive;

@end
