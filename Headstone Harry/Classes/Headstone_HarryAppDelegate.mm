//
//  Headstone_HarryAppDelegate.m
//  Bumble Tales
//
//  Created by Robert Shoemate on 5/21/09.
//  Copyright Conjured Realms LLC 2009. All rights reserved.
//

#import "Headstone_HarryAppDelegate.h"
#import "EAGLView.h"
#include "DeviceManager.h"

@implementation Headstone_HarryAppDelegate

@synthesize window;
@synthesize glView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	glView.animationInterval = 1.0 / 60.0;
	[glView startAnimation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	DeviceManager::Instance().DeviceAwake(false);
	glView.animationInterval = 1.0 / 5.0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	DeviceManager::Instance().DeviceAwake(true);
	glView.animationInterval = 1.0 / 60.0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[glView applicationTerminated];
}

- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

@end
