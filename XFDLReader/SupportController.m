//
//  SupportController.m
//  XFDLReader
//
//  Created by LeviMac on 12/22/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import "SupportController.h"

@interface SupportController ()

@end

@implementation SupportController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Support Page";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}
-(IBAction)pushSupport:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.venturacountylife.com/xfdl/"]];
}
-(IBAction)pushAPD:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.apd.army.mil"]];
}
-(IBAction)pushAir:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.e-publishing.af.mil"]];
}
-(IBAction)emailMe:(id)sender {
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    [mailer setSubject:@"XFDL Reader"];
    NSArray *toArray = [[NSArray alloc] initWithObjects:@"webmaster@venturacountylife.com", nil];
    [mailer setToRecipients:toArray];
    [self presentModalViewController:mailer animated:YES];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}


-(IBAction)rateMe:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=580387117&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8"]];
}
@end
