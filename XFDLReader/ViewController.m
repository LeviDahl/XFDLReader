//
//  ViewController.m
//  XFDLReader
//
//  Created by LeviMac on 9/8/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import "ViewController.h"
#import "RXMLElement.h"
#import "QuartzCore/QuartzCore.h"
#import "DrawLines.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize tempdata, scrollView, mainview, fielddata, toolbar, imagedata;
- (void)viewDidLoad
{
    
    [super viewDidLoad];
       AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    scrollView.delegate = self;
    
    mainview.frame = CGRectIntegral(mainview.frame);
    [scrollView addSubview:mainview];
    [scrollView setScrollEnabled:YES];
  
    scrollView.backgroundColor = [UIColor whiteColor];
    [scrollView setFrame:CGRectIntegral(scrollView.frame)];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"a2_1" ofType:@"xfdl"];
     tempdata = [[NSMutableArray alloc] init];
    fielddata = [[NSMutableArray alloc] init];
    imagedata = [[NSMutableArray alloc] init];
    appDelegate.linedata = [[NSMutableArray alloc] init];
    NSString *myData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
       NSString *newStr = [myData substringWithRange:NSMakeRange(51, [myData length]-51)];
    NSData *decodedData = [NSData dataWithBase64EncodedString:newStr];
    NSData *test = [decodedData gunzippedData];
    //NSString *rawXML = [[NSString alloc] initWithData:test encoding:NSUTF8StringEncoding];
    RXMLElement *rootXML = [RXMLElement elementFromXMLData:test];
    NSLog(@"xmlns = %@ ", [rootXML attribute:@"xmlns" inNamespace:@"*"]);
    [rootXML iterate:@"page.data" usingBlock: ^(RXMLElement *images) {
       if ([images attribute:@"sid"] !=nil)
       {
        [imagedata addObject:[images attribute:@"sid"]];
       }
        NSData *data = [[NSData alloc] init];
        
      if ([[images child:@"mimedata"].text isEqualToString:@""])
      {
          [imagedata addObject:@"No Mime Data"];

      }
        else
            
        {
            data = [NSData dataWithBase64EncodedString:[images child:@"mimedata"].text];
            NSData *decoded = [data gunzippedData];
            [imagedata addObject:decoded];
                   }
        
        
    }];
    [rootXML iterate:@"page.label" usingBlock: ^(RXMLElement *player) {
        NSString *title = [player attribute:@"sid"];
       NSMutableArray *test = [[NSMutableArray alloc] init];
        if ([title length] >= 5)
        title = [title substringToIndex:5];
              if ([title isEqualToString:@"LABEL"])
        {
            [player iterate:@"itemlocation.ae" usingBlock:^(RXMLElement *repElement) {
            [repElement iterate:@"ae" usingBlock:^(RXMLElement *xy) {
                NSString *temp = xy.text;
                [test addObject:temp];
             }];
                     }];
            if ([player child:@"value"].text != nil)
            {
            [test addObject:[player child:@"value"].text];
            }
            else
            {
                [test addObject:@""];
            }
            if ([player child:@"fontinfo"] != nil)
            {
                [player iterate:@"fontinfo.ae" usingBlock:^(RXMLElement *fontElement) {
                    [test addObject:fontElement.text];
                }];
                 }
            if ([player child:@"justify"] != nil) {
           [test addObject:[player child:@"justify"].text];
            }
            if ([player child:@"image"].text != nil)
            {
                [test addObject:@"image"];
                [test addObject:[player child:@"image"].text];
                
            }
            else
            {
                [test addObject:@"text"];

            }
            [tempdata addObject:test];
         
        }
        }];

    for(int i = 0; i < [tempdata count]; i++){
        if ([[tempdata objectAtIndex:i ]count] < 7) {
        if ([[[tempdata objectAtIndex:i] objectAtIndex:8] isEqualToString:@"image"])        {
            NSLog(@"This is an image");
           
             for(int j = 0; j < [imagedata count]; j++){
            
                 if ([[imagedata objectAtIndex:j] isKindOfClass:[NSString class]] &&[[imagedata objectAtIndex:j] isEqualToString:[[tempdata objectAtIndex:i] objectAtIndex:9]])
                 {
                     NSData *data = [imagedata objectAtIndex:j+1];
                     NSLog(@"image data %@", data);
                     UIImage *image = [[UIImage alloc] initWithData:data];
                     UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                     imageView.frame = CGRectIntegral(CGRectMake(roundf([[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:4] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:5] floatValue]/4 *3)));
                      NSLog(@"image frame %@",NSStringFromCGRect(imageView.frame));
                    
                     [mainview addSubview:imageView];
                                       }
             }
        }
        }
        else
        {
        UILabel *label =  [[UILabel alloc] initWithFrame: CGRectIntegral(CGRectMake(roundf([[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:4] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:5] floatValue]/4 *3)))];
        label.backgroundColor = [UIColor clearColor];
        
        
        if ([[tempdata objectAtIndex:i] count] > 8)
        {
            label.font = [UIFont fontWithName:@"Arial" size:[[[tempdata objectAtIndex:i] objectAtIndex:8] floatValue]];
            
        }
        label.text = [[tempdata objectAtIndex:i] objectAtIndex:6];
        if ([[tempdata objectAtIndex:i] count] > 10)
        {
            if ([[[tempdata objectAtIndex:i] objectAtIndex:10] isEqualToString:@"center"])
            {label.textAlignment = UITextAlignmentCenter;
            }
        }
        [mainview addSubview:label];
        }
    }
    [rootXML iterate:@"page.field" usingBlock: ^(RXMLElement *field) {
        NSMutableArray *test = [[NSMutableArray alloc] init];
        [field iterate:@"itemlocation.ae" usingBlock:^(RXMLElement *repElement) {
        [repElement iterate:@"ae" usingBlock:^(RXMLElement *xy) {
        NSString *temp = xy.text;
        [test addObject:temp];
        }];
        }];
        [field iterate:@"size.ae" usingBlock:^(RXMLElement *sizeElement) {
            [test addObject:sizeElement.text];
        }];
        if ([field child:@"justify"] != nil) {
            [test addObject:[field child:@"justify"].text];
        }
        else
        {
            [test addObject:@"left"];
        }
        if (![[field child:@"value"].text isEqualToString:@""]) {
            [test addObject:[field child:@"value"].text];
        }
        else {
            [test addObject:@""];
        }
    
        if ([field child:@"fontinfo"] != nil)
            {
                [field iterate:@"fontinfo.ae" usingBlock:^(RXMLElement *fontElement) {
                    [test addObject:fontElement.text];
                }];
            }
            
            [fielddata addObject:test];
      
              
     }];
    for(int i = 0; i < [fielddata count]; i++){
        UITextField *text = [[UITextField alloc] init];
    
       
      
  
        

        if ([[[fielddata objectAtIndex:i] objectAtIndex:3] isEqualToString:@"extent"])
        {
            text.frame =  CGRectIntegral(CGRectMake([[[fielddata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:4] floatValue]/4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:5] floatValue]/4 *3));
            NSLog(@"frame %@", NSStringFromCGRect(text.frame));
            text.font = [UIFont fontWithName:[[fielddata objectAtIndex:i] objectAtIndex:8] size:[[[fielddata objectAtIndex:i] objectAtIndex:9] floatValue]];
            if ([[[fielddata objectAtIndex:i] objectAtIndex:4] isEqualToString:@"center"]) {
                text.textAlignment = UITextAlignmentCenter;
                text.text = [[fielddata objectAtIndex:i] objectAtIndex:7];
            }
            

            
        }
        else{
             text.text = [[fielddata objectAtIndex:i] objectAtIndex:6];
            text.font = [UIFont fontWithName:[[fielddata objectAtIndex:i] objectAtIndex:7] size:[[[fielddata objectAtIndex:i] objectAtIndex:8] floatValue]];
            CGSize size = [@"A" sizeWithFont:text.font constrainedToSize:CGSizeMake(999, 9999) lineBreakMode:UILineBreakModeWordWrap];
            text.frame =   CGRectIntegral(CGRectMake([[[fielddata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3, ([[[fielddata objectAtIndex:i] objectAtIndex:3] floatValue])* size.width, size.height));
            NSLog(@"frame %@", NSStringFromCGRect(text.frame));
            if ([[[fielddata objectAtIndex:i] objectAtIndex:5] isEqualToString:@"center"]) {
                text.textAlignment = UITextAlignmentCenter;
            }
        }
       
        
        [mainview addSubview:text];
    }
    [rootXML iterate:@"page.line" usingBlock: ^(RXMLElement *lines) {
        NSMutableArray *tester = [[NSMutableArray alloc] init];
        [lines iterate:@"itemlocation.ae" usingBlock:^(RXMLElement *repElements) {
            [repElements iterate:@"ae" usingBlock:^(RXMLElement *xyz) {
                NSString *temp = xyz.text;
                
                [tester addObject:temp];
            }];
         
            
          
        }];
    [appDelegate.linedata addObject:tester];

        
          }];
   
   NSLog(@"field data = %@", fielddata);
    NSLog(@"lines%@", appDelegate.linedata);
    NSLog(@"test%@", tempdata);
 scrollView.contentSize = CGSizeMake(mainview.frame.size.width, mainview.frame.size.height);
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(UITextField *)textField {
    [scrollView setScrollEnabled:NO];
   
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
     NSString *deviceType = [UIDevice currentDevice].model;
    UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
    toolbar = [[UIToolbar alloc] init];
    if ([deviceType isEqualToString:@"iPhone Simulator"] && (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        toolbar.frame = CGRectMake(0.0, 64.0, scrollView.frame.size.width, 44.0);
    }
    else if ([deviceType isEqualToString:@"iPhone Simulator"] && (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationPortrait))
    {
        toolbar.frame = CGRectMake(0.0, 156.0, scrollView.frame.size.width, 44.0);
        
    }
    else if ([deviceType isEqualToString:@"iPad Simulator"] && (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationPortrait))
    {
        toolbar.frame = CGRectMake(0.0, 652.0, scrollView.frame.size.width, 44.0);
        
    }
    else if ([deviceType isEqualToString:@"iPad Simulator"] && (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        toolbar.frame = CGRectMake(0, 310.0, scrollView.frame.size.width, 44.0);
        
    }
    NSLog(@"device type %@", deviceType);
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                target: self
                                                                                action: @selector(cancelAction)];
    NSMutableArray* toolbarItems = [NSMutableArray array];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.tintColor = [UIColor darkGrayColor];
    [toolbar setTranslucent:YES];
    [toolbarItems addObject:flexibleSpaceLeft];
    [toolbarItems addObject:doneButton];
    toolbar.items = toolbarItems;
    [scrollView addSubview:toolbar];
    
    
}
- (void)keyboardWillHide:(UITextField *)textField {
    [toolbar removeFromSuperview];
    [scrollView setScrollEnabled:YES];
}
- (void)cancelAction{
    [self.view endEditing:TRUE];
    [toolbar removeFromSuperview];
      [scrollView setScrollEnabled:YES];
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

    NSString *deviceType = [UIDevice currentDevice].model;
    UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
  
    if ([deviceType isEqualToString:@"iPhone"] && (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        toolbar.frame = CGRectMake(0.0, 64.0, scrollView.frame.size.width, 44.0);
        
    }
    else if ([deviceType isEqualToString:@"iPhone"] && (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationPortrait))
    {
        toolbar.frame = CGRectMake(0.0, 156.0, scrollView.frame.size.width, 44.0);
        
    }
    else if ([deviceType isEqualToString:@"iPad"] && (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationPortrait))
    {
        toolbar.frame = CGRectMake(0.0, 652.0, scrollView.frame.size.width, 44.0);
        
    }
    else if ([deviceType isEqualToString:@"iPad"] && (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        toolbar.frame = CGRectMake(0, 310.0, scrollView.frame.size.width, 44.0);
        
    }

}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}
- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.mainview.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.mainview.frame = contentsFrame;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [self.scrollView.subviews objectAtIndex:0];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat scalewidth =  scrollView.frame.size.width /mainview.frame.size.width;
    CGFloat scaleheight =  scrollView.frame.size.height /mainview.frame.size.width;
    CGFloat minScale = MIN(scalewidth, scaleheight);
    scrollView.minimumZoomScale = minScale;
    scrollView.maximumZoomScale = 2;
    scrollView.zoomScale = 1.0f;
}
 

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        return YES;
}

@end
