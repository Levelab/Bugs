//
//  INBugView.m
//  AI
//
//  Created by nikans on 9/14/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import "INBugView.h"

@implementation INBugView

- (id)initWithFrame:(CGRect)_frame andCondition:(INBugCondition)_condition
{
    self = [super initWithFrame:_frame];
    if (self) {
        switch (_condition) {
            case INBugFeedConditionDead:
                self.backgroundColor = [UIColor redColor];
                break;
            case INBugFeedConditionLifeless:
                self.backgroundColor = [UIColor orangeColor];
                break;
            case INBugFeedConditionEmaciated:
                self.backgroundColor = [UIColor yellowColor];
                break;
            case INBugFeedConditionDissatisfied:
                self.backgroundColor = [UIColor blueColor];
                break;
            case INBugFeedConditionSatisfied:
                self.backgroundColor = [UIColor greenColor];
                break;
            case INBugFeedConditionHappy: case INBugFeedConditionPerfect:
                self.backgroundColor = [UIColor whiteColor];
                break;
            default:
                break;
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
