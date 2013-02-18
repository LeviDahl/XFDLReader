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
#import "LineModel.h"

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
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
   // CGFloat components[] = {0.0, 0.0, 1.0, 1.0};
    
   // CGColorRef color = CGColorCreate(colorspace, components);
    
    //CGContextSetStrokeColorWithColor(context, color);
  for (LineModel *lines in self.form.lines){
      x =  [[lines.location objectForKey:@"x" ] intValue];
      y = [[lines.location objectForKey:@"y" ] intValue];
       pointx = [[lines.location objectForKey:@"width" ] intValue];
        pointy = [[lines.location objectForKey:@"height" ] intValue];
       
     
       
        
        CGContextMoveToPoint(context, x /4*3, y /4*3);
      if (pointx > 5)
      {
        CGContextAddLineToPoint(context,(x /4*3)+ (pointx /4*3), y /4*3);
      }
      else
      {
          CGContextAddLineToPoint(context, x /4*3, (y /4*3)+ (pointy /4*3));
      }
        NSLog(@"line data= %d, %d, %d, %d", x, y, pointx, pointy);
    CGContextStrokePath(context);
   
  }
     CGColorSpaceRelease(colorspace);
//    CGColorRelease(color);

}

@end
