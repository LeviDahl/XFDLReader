//
//  AppDelegate.h
//  XFDLReader
//
//  Created by LeviMac on 9/8/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableArray *linedata;
    NSString *pagename;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSMutableArray *linedata;
@property (nonatomic, retain) NSString *pagename;
@end
