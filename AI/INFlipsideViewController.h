//
//  INFlipsideViewController.h
//  AI
//
//  Created by nikans on 9/13/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import <UIKit/UIKit.h>

@class INFlipsideViewController;

@protocol INFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(INFlipsideViewController *)controller;
@end

@interface INFlipsideViewController : UIViewController

@property (weak, nonatomic) id <INFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
