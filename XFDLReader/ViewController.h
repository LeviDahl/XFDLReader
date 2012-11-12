//
//  ViewController.h
//  XFDLReader
//
//  Created by LeviMac on 9/8/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSData+GZIP.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate>


@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *tempdata;
@property (nonatomic, retain) NSMutableArray *imagedata;
@property (nonatomic, retain) IBOutlet UIView *mainview;
@property (nonatomic, retain) NSMutableArray *fielddata;
@property (nonatomic, retain) UIToolbar *toolbar;
@end
