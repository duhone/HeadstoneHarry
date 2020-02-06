//
//  EAGLView.m
//  Bumble Tales
//
//  Created by Robert Shoemate on 5/21/09.
//  Copyright Conjured Realms LLC 2009. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "EAGLView.h"
#include <pthread.h>
#include "GraphicsEngineInternal.h"
#include "Game.h"
#include "Globals.h"
#include "InputEngine.h"
#include "KeyboardManager.h"
#include "DeviceManager.h"

using namespace CR::Input;

Game* game_class;
char path[256];
extern CR::Input::InputEngine* input_engine;
extern CR::Graphics::GraphicsEngineInternal *gengine;

#define USE_DEPTH_BUFFER 0

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end


@implementation EAGLView

@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;


// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
		
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
		//[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
		[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];

		// Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
        
        animationInterval = 1.0 / 120.0;
		
		[self setMultipleTouchEnabled:YES];
		textView = [[[UITextField alloc] initWithFrame:CGRectMake(-100,-100,0,0)] autorelease];
		textView.delegate = self;
		[self addSubview:textView];
		KeyboardManager::Instance().SetMainView(self);
		KeyboardManager::Instance().SetTextView(textView);
		//UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
		//accelerometer.delegate = self;
		//accelerometer.updateInterval = 1.0f/60.0f;
    }
	
	// Engine Initialization
	path[0] = 0;
	input_engine = &InputEngine::Instance();
	InputEngine::Instance().AddTouchable(&UIEngine::Instance());
	game_class = new Game();
	game_class->Initialize();

    return self;
}


- (void)drawView {
	gengine->context = context;
	gengine->backingWidth = backingWidth;
	gengine->backingHeight = backingHeight;
	gengine->viewFramebuffer = viewFramebuffer;
	gengine->viewRenderbuffer = viewRenderbuffer;
	game_class->Execute();
}


- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}


- (void)startAnimation {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}


- (void)stopAnimation {
    self.animationTimer = nil;
}


- (void)setAnimationTimer:(NSTimer *)newTimer {
    [animationTimer invalidate];
    animationTimer = newTimer;
}


- (void)setAnimationInterval:(NSTimeInterval)interval {
    
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}

- (void)touchesBegan: (NSSet *)touches withEvent:(UIEvent *)event
{
	//KeyboardManager::Instance().HideKeyboard();
	
	InputEngine::Instance().TouchesBegan(self, touches);
}

- (void)touchesMoved: (NSSet *)touches withEvent:(UIEvent *)event
{
	InputEngine::Instance().TouchesMoved(self, touches);
}

- (void)touchesEnded: (NSSet *)touches withEvent:(UIEvent *)event
{
	InputEngine::Instance().TouchesEnded(self, touches);
}

- (void)touchesCancelled: (NSSet *)touches withEvent:(UIEvent *)event
{
	InputEngine::Instance().TouchesCancelled(self, touches);
}



/*
- (void)accelerometer:(UIAccelerometer *)accelerometer
		didAccelerate:(UIAcceleration *)acceleration {
	input_engine->DidAccelerate(accelerometer, acceleration);
}*/

- (void)applicationTerminated
{
	game_class->ApplicationTerminated();
}

- (void)dealloc {
    
    [self stopAnimation];
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
	//input_engine->Release();
	delete game_class;
	
    [context release];  
    [super dealloc];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	KeyboardManager::Instance().HideKeyboard();
	return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)str
{
	KeyboardManager::Instance().ReportCharactersTyped(range, str);
	
	return YES;
}

@end
