//
//  TutorialViewController.m
//  XFDLReader
//
//  Created by Levi on 3/8/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(IBAction)didPressTutorialButton:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"watchedTutorial" forKey:@"tutorial"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
