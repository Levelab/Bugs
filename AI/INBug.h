//
//  INBugBody.h
//  AI
//
//  Created by Eliah Nikans on 9/26/13.
//  Copyright (c) 2013 nikans. All rights reserved.
//

#import <Foundation/Foundation.h>
@class INBugAI;

@interface INBug : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) float batteryStatus;
@property (strong, nonatomic) INBugAI *AI;

- (BOOL)actAlive;
- (BOOL)isAlive;

- (float)feed;

@end
