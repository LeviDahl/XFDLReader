//
//  DrawLines.m
//  XFDLReader
//
//  Created by LeviMac on 11/6/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import "DrawLines.h"
#import "ViewController.h"
#import "AppDelegate.h"
@implementation DrawLines
@synthesize x, y, pointx, pointy;
- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
   // CGFloat components[] = {0.0, 0.0, 1.0, 1.0};
    
   // CGColorRef color = CGColorCreate(colorspace, components);
    
    //CGContextSetStrokeColorWithColor(context, color);
  for(int i = 0; i < [appDelegate.linedata count]; i++){
       if ([[appDelegate.linedata objectAtIndex:i] count] > 5)
       {
      x =  [[[appDelegate.linedata objectAtIndex:i] objectAtIndex:1] intValue];
      y = [[[appDelegate.linedata objectAtIndex:i] objectAtIndex:2] intValue];
       pointx = [[[appDelegate.linedata objectAtIndex:i] objectAtIndex:4] intValue];
        pointy = [[[appDelegate.linedata objectAtIndex:i] objectAtIndex:5] intValue];
       }
       else{
           x =  [[[appDelegate.linedata objectAtIndex:i] objectAtIndex:0] intValue];
           y = [[[appDelegate.linedata objectAtIndex:i] objectAtIndex:1] intValue];
           pointx = [[[appDelegate.linedata objectAtIndex:i] objectAtIndex:2] intValue];
           pointy = [[[appDelegate.linedata objectAtIndex:i] objectAtIndex:3] intValue];

       }
       
        
        CGContextMoveToPoint(context, x /4*3, y /4*3);
        if (pointy <= 5)
        {
        CGContextAddLineToPoint(context,(x /4*3)+ (pointx /4*3), y /4*3);
        }
        else if (pointx <= 5)
        {
             CGContextAddLineToPoint(context,x /4*3, (y /4*3)+ (pointy /4*3));
        }
        
        NSLog(@"line data= %d, %d, %d, %d", x, y, pointx, pointy);
    }
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
//    CGColorRelease(color);

}

@end
