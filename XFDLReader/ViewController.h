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
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewController : UIViewController <UIScrollViewDelegate, UITextViewDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UIPrintInteractionControllerDelegate>
{
    NSString *filepath;
    UIDocumentInteractionController *documentController;
    CGPoint svos;
    UIToolbar *toolbar;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray *tempdata;
@property (nonatomic, retain) NSMutableArray *imagedata;
@property (nonatomic, retain) NSMutableArray *checkdata;
@property (nonatomic, retain) NSMutableArray *celldata;
@property (nonatomic, retain) NSMutableArray *combodata;
@property (nonatomic, retain) NSMutableArray *pagesarray;
@property (nonatomic, retain) NSMutableArray *pickerarray;
@property (nonatomic, retain) NSMutableArray *resourcearray;
@property (nonatomic, retain) IBOutlet UIView *mainview;
@property (nonatomic, retain) NSMutableArray *fielddata;
@property (nonatomic, retain) NSString *filepath;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIPickerView *pickerview;
@property (nonatomic, retain) NSString *pickerstring;
@property (nonatomic, retain) UIPrintInteractionController *printController;
@property (nonatomic, retain) UIView *keyboardView;
@property (nonatomic, retain) UIColor *backgroundColor;
-(void)nextpage;
@end
