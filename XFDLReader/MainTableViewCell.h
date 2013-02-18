//
//  MainTableViewCell.h
//  XFDLReader
//
//  Created by Levi on 2/16/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileLabel;
@property (weak, nonatomic) IBOutlet UILabel *modifiedLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@end
