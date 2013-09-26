//
//  INAppDelegate.h
//  AI
//
//  Created by nikans on 9/13/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class INEnvironment;

@interface INAppDelegate : UIResponder <UIApplicationDelegate>

typedef struct Coordinates {
	int x;
	int y;
} Coordinates;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) INEnvironment *environment;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)updateLife:(NSTimer *)timer;

@end
