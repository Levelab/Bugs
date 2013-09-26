//
//  INMainViewController.m
//  AI
//
//  Created by nikans on 9/13/12.
//  Copyright (c) 2012 nikans. All rights reserved.
//

#import "INMainViewController.h"
#import "INEnvironment.h"
#import "INTile.h"
#import "INAppDelegate.h"
#import "INTileBugProxy.h"
#import "INBugView.h"
#import "ImageHelper.h"
#import "INBugAI.h"

@interface INMainViewController ()

@end

@implementation INMainViewController
@synthesize scrollView;
@synthesize mapView, bugs, appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.appDelegate = (INAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.bugs = [[NSMutableArray alloc] initWithCapacity:20];
	
	self.scrollView.contentSize = CGSizeMake(1280, 1280);
	self.scrollView.minimumZoomScale = 0.25;
	self.scrollView.maximumZoomScale = 2.0;
	[self.scrollView setZoomScale:self.scrollView.minimumZoomScale];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMap:) name:@"updateMap" object:nil ];
	[self cacheMap];
}


- (void)updateMap:(NSNotification *)notification {
	[self cacheMap];
}

- (void)cacheMap {
	
	//Create a raw buffer to hold pixel data which we will fill algorithmically
	NSInteger width = 1280;
	NSInteger height = 1280;
	NSInteger dataLength = width * height * 4;
	UInt8 *data = (UInt8*)malloc(dataLength * sizeof(UInt8));
	//unsigned char data[dataLength] = {0};
	
	//Fill pixel buffer with color data
	for (INTile *tmp_tile in self.appDelegate.environment.tiles) {
		for (int y = 0; y < 4; y++) {
			for (int x = 0; x < 4; x++) {
				
				// Drawing pixel map
				int index = 4*(tmp_tile.x * 4 + x + tmp_tile.y * 4 * width + y * width);
				data[index]  = tmp_tile.status;
				data[++index]= tmp_tile.status;
				data[++index]= tmp_tile.status;
				data[++index]= 255;
				
			}
		}
	}
	
	self.mapView.image = [ImageHelper convertBitmapRGBA8ToUIImage:data withWidth:width withHeight:height];

	if(data) {
		free(data);
		data = NULL;
	}
	

	/*
	// Create a CGImage with the pixel data
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	CGImageRef image = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast, provider, NULL, true, kCGRenderingIntentDefault);
	
	//Clean up
	CGColorSpaceRelease(colorspace);
	CGDataProviderRelease(provider);
	//CGImageRelease(image);
	if(data) {
		free(data);
		data = NULL;
	}
	self.mapView.image = [UIImage imageWithCGImage:image scale:1 orientation:UIImageOrientationDown];
	*/
	[self redrawMap];
}

- (void)redrawMap {
	NSLog(@"---------- REDRAW -----------");
	
	for (INBugView *tmp_bug in self.bugs) {
		[tmp_bug removeFromSuperview];
	}
	
	for (NSString *bugName in self.appDelegate.environment.bugProxies) {
		INTileBugProxy *tmp_proxy = [self.appDelegate.environment.bugProxies objectForKey:bugName];
		CGRect viewRect = CGRectMake(tmp_proxy.tile.x * 4 + 1,
									  tmp_proxy.tile.y * 4 + 1,
									  2, 2);
		INBugView *tmp_bug = [[INBugView alloc] initWithFrame:viewRect andCondition:tmp_proxy.bug.AI.iAmFeeling];
		
		[self.bugs addObject:tmp_bug];
		[self.mapView addSubview:tmp_bug];
	}
		
}


- (void)viewDidUnload
{
	[self setMapView:nil];
	[self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(INFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
