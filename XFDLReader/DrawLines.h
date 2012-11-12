//
//  DrawLines.h
//  XFDLReader
//
//  Created by LeviMac on 11/6/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawLines : UIView
{
    NSMutableArray *data;
    int x;
    int y;
    int pointx;
    int pointy;
}
@property (nonatomic) int x;
@property (nonatomic) int y;
@property (nonatomic) int pointx;
@property (nonatomic) int pointy;

@end
