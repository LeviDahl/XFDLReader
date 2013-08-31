//
//  AppDelegate.m
//  XFDLReader
//
//  Created by LeviMac on 9/8/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTableView.h"
@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[GDiOS sharedInstance] getWindow];
    self.good = [GDiOS sharedInstance];
    _good.delegate = self;
    started = NO;
 /*   NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"XFDL"];
	NSError *error;
	if (![fileManager fileExistsAtPath:path])	//Does directory already exist?
	{
		if (![[NSFileManager defaultManager] createDirectoryAtPath:path
									   withIntermediateDirectories:NO
														attributes:nil
															 error:&error])
		{
			NSLog(@"Main Directory Already Exists, No Action = %@", error);
		}
	}
    
    
    path = [path stringByAppendingPathComponent:@"a4.xfdl"];
    if(![fileManager fileExistsAtPath:path])
    {
        NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/a4.xfdl"]];
        [data writeToFile:path atomically:YES];
    }
    NSString *PDFPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"PDFs"];
    
    if (![fileManager fileExistsAtPath:PDFPath])	//Does directory already exist?
	{
		if (![[NSFileManager defaultManager] createDirectoryAtPath:PDFPath
									   withIntermediateDirectories:NO
														attributes:nil
															 error:&error])
		{
			NSLog(@"Main Directory Already Exists, No Action = %@", error);
		}
	}*/
    //Show the Good Authentication UI.
    [_good authorize];

    return YES;

}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    MainTableView *table = [[MainTableView alloc] init];
    if (url != nil && [url isFileURL]) {
        [table handleOpenURL:url];
    }
    NSString *filepath = [url lastPathComponent];
    NSLog(@"filename = %@", filepath);
    return YES;
}

-(void)handleEvent:(GDAppEvent*)anEvent
{
    /* Called from _good when events occur, such as system startup. */
    
    switch (anEvent.type)
    {
		case GDAppEventAuthorized:
        {
            [self onauthorized:anEvent];
			break;
        }
		case GDAppEventNotAuthorized:
        {
            [self onNotauthorized:anEvent];
			break;
        }
		case GDAppEventRemoteSettingsUpdate:
        {
            //A change to application-related configuration or policy settings.
			break;
        }
        case GDAppEventServicesUpdate:
        {
            //A change to services-related configuration.
            break;
        }
        case GDAppEventPolicyUpdate:
        {
            //A change to one or more application-specific policy settings has been received.
            break;
        }
    }
}

-(void) onNotauthorized:(GDAppEvent*)anEvent
{
    /* Handle the Good Libraries not authorized event. */
    
    switch (anEvent.code) {
        case GDErrorActivationFailed:
        case GDErrorProvisioningFailed:
        case GDErrorPushConnectionTimeout: {
            // application can either handle this and show it's own UI or just call back into
            // the GD library and the welcome screen will be shown
            [_good authorize];
            break;
        }
        case GDErrorSecurityError:
        case GDErrorAppDenied:
        case GDErrorBlocked:
        case GDErrorWiped:
        case GDErrorRemoteLockout:
        case GDErrorPasswordChangeRequired: {
            // an condition has occured denying authorization, an application may wish to log these events
            NSLog(@"onNotauthorized %@", anEvent.message);
            break;
        }
        case GDErrorIdleLockout: {
            // idle lockout is benign & informational
            break;
        }
        default:
            NSAssert(false, @"Unhandled not authorized event");
            break;
    }
}

-(void) onauthorized:(GDAppEvent*)anEvent
{
    /* Handle the Good Libraries authorized event. */
    
    switch (anEvent.code) {
        case GDErrorNone: {
            if (!started) {
                // launch application UI here
                started = YES;
            }
            break;
        }
        default:
            NSAssert(false, @"authorized startup with an error");
            break;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
