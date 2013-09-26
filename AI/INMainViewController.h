//
//  INMainViewController.h
//  AI
//
//  Created by nikans on 9/13/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import "INFlipsideViewController.h"
@class INEnvironment;
@class INAppDelegate;

@interface INMainViewController : UIViewController <INFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@property (strong, nonatomic) INAppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UIImageView *mapView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *bugs;

- (void)cacheMap;
- (void)redrawMap;
- (void)updateMap:(NSNotification *)notification;

@end
