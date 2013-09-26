//
//  NSMutableArray+Stack.m
//  AI
//
//  Created by nikans on 9/14/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

@interface NSMutableArray (StackModification)

- (id)pop;
- (void)push:(id)obj;

@end

@implementation NSMutableArray (StackModification)

- (id)pop
{
    // nil if [self count] == 0
    id lastObject = [self lastObject];
    if (lastObject)
        [self removeLastObject];
    return lastObject;
}

- (void)push:(id)obj
{
	[self addObject: obj];
}

@end
