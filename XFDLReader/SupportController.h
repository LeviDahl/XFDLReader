//
//  SupportController.h
//  XFDLReader
//
//  Created by LeviMac on 12/22/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface SupportController : UIViewController <MFMailComposeViewControllerDelegate>
-(IBAction)pushSupport:(id)sender;
-(IBAction)pushAPD:(id)sender;
-(IBAction)pushAir:(id)sender;
-(IBAction)emailMe:(id)sender;
-(IBAction)rateMe:(id)sender;
@end
