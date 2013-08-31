//
//  AppDelegate.h
//  XFDLReader
//
//  Created by LeviMac on 9/8/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GD/GDiOS.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, GDiOSDelegate>
{
    NSMutableArray *linedata;
    BOOL started;
}

-(void) onauthorized:(GDAppEvent*)anEvent;
-(void) onNotauthorized:(GDAppEvent*)anEvent;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GDiOS *good;
@end
