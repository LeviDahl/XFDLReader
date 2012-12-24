//
//  MainTableView.h
//  XFDLReader
//
//  Created by LeviMac on 11/13/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSArray *paths;
@property (nonatomic, retain) NSArray *filelist;
@property (nonatomic, retain) NSURL *fileURL;
- (void)handleOpenURL:(NSURL *)url;

@end
