//
//  Headstone_HarryAppDelegate.h
//  Bumble Tales
//
//  Created by Robert Shoemate on 5/21/09.
//  Copyright Conjured Realms LLC 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;

@interface Headstone_HarryAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EAGLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;

@end

