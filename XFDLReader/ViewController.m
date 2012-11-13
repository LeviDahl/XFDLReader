
#import "ViewController.h"
#import "RXMLElement.h"
#import "QuartzCore/QuartzCore.h"
#import "DrawLines.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize tempdata, scrollView, mainview, fielddata, toolbar, imagedata, pagesarray;
- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    scrollView.delegate = self;
    mainview.frame = CGRectIntegral(mainview.frame);
    [scrollView addSubview:mainview];
    [scrollView setScrollEnabled:YES];
    scrollView.backgroundColor = [UIColor whiteColor];
    [scrollView setFrame:CGRectIntegral(scrollView.frame)];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"a4856" ofType:@"xfdl"];
     tempdata = [[NSMutableArray alloc] init];
    fielddata = [[NSMutableArray alloc] init];
    imagedata = [[NSMutableArray alloc] init];
    pagesarray = [[NSMutableArray alloc] init];
   NSLog(@"pagenum %@", appDelegate.pagename);
    appDelegate.linedata = [[NSMutableArray alloc] init];
    NSString *myData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
       NSString *newStr = [myData substringWithRange:NSMakeRange(51, [myData length]-51)];
    NSData *decodedData = [NSData dataWithBase64EncodedString:newStr];
    NSData *test = [decodedData gunzippedData];
   UIBarButtonItem *doneButton = [[UIBarButtonItem alloc ] initWithTitle:@"Next Page" style:UIBarButtonItemStyleBordered target:self action:@selector(nextpage)];
    self.navigationItem.rightBarButtonItem = doneButton;
    RXMLElement *rootXML = [RXMLElement elementFromXMLData:test];
   
   if ([rootXML child:@"globalpage.global.formid.title"] != nil)
   {
       self.navigationItem.title = [rootXML child:@"globalpage.global.formid.title"].text;
   }
    [rootXML iterate:@"*" usingBlock: ^(RXMLElement *pages) {
        NSString *pagenum = [pages attribute:@"sid"];
        
        if ([pagenum length] >= 5)
            pagenum = [pagenum substringToIndex:5];
      
        if ([[pagenum substringToIndex:4] isEqualToString:@"PAGE"])
        {
            [pagesarray addObject:pagenum];
        }
         [pagesarray sortUsingSelector:@selector(caseInsensitiveCompare:)];
         NSLog(@"page array %@", pagesarray);
if ([appDelegate.pagename length]== 0)
{
    appDelegate.pagename = @"PAGE1";
}
        NSLog(@"pagename53 %@",  appDelegate.pagename);
        if ([pagenum isEqualToString:appDelegate.pagename])
        {
    if ([rootXML child:@"globalpage.global.date"] == nil)
    {
       
        NSMutableArray *bgcolor = [[NSMutableArray alloc] init];
        
      [pages iterate:@"global.bgcolor.*" usingBlock: ^(RXMLElement *colors) {
            [bgcolor addObject:colors.text];
        }];
        if ([bgcolor count] != 0) {
         mainview.backgroundColor = [UIColor colorWithRed:([[bgcolor objectAtIndex:0] floatValue] /255.0) green:([[bgcolor objectAtIndex:0] floatValue] /255.0)blue:([[bgcolor objectAtIndex:0] floatValue] /255.0) alpha:1];
        }
     
        [pages iterate:@"data" usingBlock: ^(RXMLElement *images) {
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
       [pages iterate:@"label" usingBlock: ^(RXMLElement *player) {
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
               
                if ([player child:@"justify"] != nil) {
                    [test addObject:[player child:@"justify"].text];
                }
                else {
                    [test addObject:@"left"];
                }
                if ([player child:@"image"].text != nil)
                {
                    [test addObject:@"image"];
                    [test addObject:[player child:@"image"].text];
                    
                }
                else
                {
                    [test addObject:@"text"];
                    [test addObject:@"No Image Data"];
                    
                }
                if ([player child:@"fontinfo"] != nil)
                {
                    [player iterate:@"fontinfo.ae" usingBlock:^(RXMLElement *fontElement) {
                        [test addObject:fontElement.text];
                    }];
                }
                else {
                    [test addObject:@"Arial"];
                    [test addObject:@"8"];
                }
                [tempdata addObject:test];
                
            }
        }];
       for(int i = 0; i < [tempdata count]; i++){
            if ([[tempdata objectAtIndex:i ]count] > 11) {
                if ([[[tempdata objectAtIndex:i] objectAtIndex:8] isEqualToString:@"image"])        {
                    NSLog(@"This is an image");
                    for(int j = 0; j < [imagedata count]; j++){
                        if ([[imagedata objectAtIndex:j] isKindOfClass:[NSString class]] &&[[imagedata objectAtIndex:j] isEqualToString:[[tempdata objectAtIndex:i] objectAtIndex:9]])
                        {
                            NSData *data = [imagedata objectAtIndex:j+1];
                            
                            UIImage *image = [[UIImage alloc] initWithData:data];
                            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                            imageView.frame = CGRectIntegral(CGRectMake(roundf([[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:4] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:5] floatValue]/4 *3)));
                            NSLog(@"image frame %@",NSStringFromCGRect(imageView.frame));
                            [mainview addSubview:imageView];
                        }
                    }
                }
                else{
                                           
                    
                    UILabel *label = [[UILabel alloc] init];
                    label.backgroundColor = [UIColor clearColor];
                    label.frame =  CGRectIntegral(CGRectMake(roundf([[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:4] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:5] floatValue]/4 *3)));
                    
                    label.font = [UIFont fontWithName:[[tempdata objectAtIndex:i] objectAtIndex:10] size:[[[tempdata objectAtIndex:i] objectAtIndex:11] floatValue]];
                    label.text = [[tempdata objectAtIndex:i] objectAtIndex:6];
                    label.numberOfLines = 0;

                        if ([[[tempdata objectAtIndex:i] objectAtIndex:7] isEqualToString:@"center"])
                        {label.textAlignment = UITextAlignmentCenter;
                        }
                    
                    [mainview addSubview:label];
                    
                }
            }
            else
            {
                    if ([[[tempdata objectAtIndex:i] objectAtIndex:8] isEqualToString:@"image"])        {
                        NSLog(@"This is an image");
                        for(int j = 0; j < [imagedata count]; j++){
                            if ([[imagedata objectAtIndex:j] isKindOfClass:[NSString class]] &&[[imagedata objectAtIndex:j] isEqualToString:[[tempdata objectAtIndex:i] objectAtIndex:9]])
                            {
                                NSData *data = [imagedata objectAtIndex:j+1];
                                UIImage *image = [[UIImage alloc] initWithData:data];
                                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                imageView.frame = CGRectIntegral(CGRectMake(roundf([[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3), image.size.width, image.size.height));
                                NSLog(@"image frame %@",NSStringFromCGRect(imageView.frame));
                                [mainview addSubview:imageView];
                            }
                        }
                    }
                else{
                UILabel *label = [[UILabel alloc] init];
                label.backgroundColor = [UIColor clearColor];
                   label.font = [UIFont fontWithName:[[tempdata objectAtIndex:i] objectAtIndex:7] size:[[[tempdata objectAtIndex:i] objectAtIndex:8] floatValue]];
                    label.numberOfLines = 0;
                    CGSize size = [[[tempdata objectAtIndex:i] objectAtIndex:3] sizeWithFont:label.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                    label.frame =   CGRectIntegral(CGRectMake([[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3, [[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3, size.width, size.height));
                      label.text = [[tempdata objectAtIndex:i] objectAtIndex:3];
                    NSLog(@"label font %@", label.font);
                    if ([[[tempdata objectAtIndex:i] objectAtIndex:7] isEqualToString:@"italic"]);
                    NSLog(@"label frame %@", NSStringFromCGRect(label.frame));
                    if ([[tempdata objectAtIndex:i] count] > 10)
                    {
                        if ([[[tempdata objectAtIndex:i] objectAtIndex:10] isEqualToString:@"center"])
                        {label.textAlignment = UITextAlignmentCenter;
                        }
                    }
                    [mainview addSubview:label];
                }
            }
        }
        [pages iterate:@"field" usingBlock: ^(RXMLElement *field) {
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
            else
            {
                [test addObject:@"Arial"];
                [test addObject:@"8"];
            }
            [fielddata addObject:test];
            
            
        }];
       for(int i = 0; i < [fielddata count]; i++){
            UITextField *text = [[UITextField alloc] init];
           text.tag = i;
           text.delegate = self;
           text.returnKeyType = UIReturnKeyNext;
            [mainview sendSubviewToBack:text];
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
                CGSize size = [@"A" sizeWithFont:text.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                
                text.frame =   CGRectIntegral(CGRectMake([[[fielddata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3, ([[[fielddata objectAtIndex:i] objectAtIndex:3] floatValue])* size.width, size.height));
                NSLog(@"frame %@", NSStringFromCGRect(text.frame));
                if ([[[fielddata objectAtIndex:i] objectAtIndex:5] isEqualToString:@"center"]) {
                    text.textAlignment = UITextAlignmentCenter;
                }
            }
            
            
            [mainview addSubview:text];
        }
        [pages iterate:@"line" usingBlock: ^(RXMLElement *lines) {
            NSMutableArray *tester = [[NSMutableArray alloc] init];
            [lines iterate:@"itemlocation.ae" usingBlock:^(RXMLElement *repElements) {
                [repElements iterate:@"ae" usingBlock:^(RXMLElement *xyz) {
                    NSString *temp = xyz.text;
                    
                    [tester addObject:temp];
                }];
                
                
                
            }];
            [appDelegate.linedata addObject:tester];
            
            
        }];
    }
  else
  {
       NSArray *bgcolor = [[pages child:@"global.bgcolor"].text componentsSeparatedByString:@","];
      mainview.backgroundColor = [UIColor colorWithRed:([[bgcolor objectAtIndex:0] floatValue] /255.0) green:([[bgcolor objectAtIndex:0] floatValue] /255.0)blue:([[bgcolor objectAtIndex:0] floatValue] /255.0) alpha:1];
      NSLog(@"background %@", bgcolor);
    [pages iterate:@"data" usingBlock: ^(RXMLElement *images) {
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
   [pages iterate:@"label" usingBlock: ^(RXMLElement *player) {
        NSString *title = [player attribute:@"sid"];
       NSMutableArray *test = [[NSMutableArray alloc] init];
        if ([title length] >= 5)
        title = [title substringToIndex:5];
              if ([title isEqualToString:@"LABEL"])
        {
            [player iterate:@"itemlocation.*" usingBlock:^(RXMLElement *repElement) {
                NSString *temp = repElement.text;
                [test addObject:temp];
            }];
            if ([player child:@"value"].text != nil)
            {
            [test addObject:[player child:@"value"].text];
            }
            else
            {
                [test addObject:@""];
            }
            if ([player child:@"justify"] != nil) {
                [test addObject:[player child:@"justify"].text];
            }
            else
            {
                [test addObject:@"left"];
            }
            if ([player child:@"image"].text != nil)
            {
                [test addObject:@"image"];
                [test addObject:[player child:@"image"].text];
                
            }
            else
            {
                [test addObject:@"text"];
                [test addObject:@"No Image Data"];
            }
            if ([player child:@"fontinfo"] != nil)
            {
                [player iterate:@"fontinfo.*" usingBlock:^(RXMLElement *fontElement) {
                    [test addObject:fontElement.text];
                }];
                 }
            
            [tempdata addObject:test];
         
        }
        }];
   for(int i = 0; i < [tempdata count]; i++){
        if ([[tempdata objectAtIndex:i ]count] < 7) {
        if ([[[tempdata objectAtIndex:i] objectAtIndex:8] isEqualToString:@"image"])        {
             for(int j = 0; j < [imagedata count]; j++){
                 if ([[imagedata objectAtIndex:j] isKindOfClass:[NSString class]] &&[[imagedata objectAtIndex:j] isEqualToString:[[tempdata objectAtIndex:i] objectAtIndex:9]])
                 {
                     NSData *data = [imagedata objectAtIndex:j+1];
                    UIImage *image = [[UIImage alloc] initWithData:data];
                     UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                     imageView.frame = CGRectIntegral(CGRectMake(roundf([[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:4] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:5] floatValue]/4 *3)));
                     [mainview addSubview:imageView];
                                       }
             }
        }
        }
        else
        {
            UILabel *label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 0;

            if ([[tempdata objectAtIndex:i] count] > 10)
            {
       label.frame = CGRectIntegral(CGRectMake(roundf([[[tempdata objectAtIndex:i] objectAtIndex:0] floatValue] /4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:3] floatValue]/4 *3)));
                label.font = [UIFont fontWithName:[[tempdata objectAtIndex:i] objectAtIndex:8] size:[[[tempdata objectAtIndex:i] objectAtIndex:9] floatValue]];
                label.text = [[tempdata objectAtIndex:i] objectAtIndex:4];
            }
            else{
                label.font = [UIFont fontWithName:[[tempdata objectAtIndex:i] objectAtIndex:6] size:[[[tempdata objectAtIndex:i] objectAtIndex:7] floatValue]];
                CGSize size = [[[tempdata objectAtIndex:i] objectAtIndex:2] sizeWithFont:label.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                label.frame =   CGRectIntegral(CGRectMake([[[tempdata objectAtIndex:i] objectAtIndex:0] floatValue] /4 *3, [[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue]/4 *3, size.width, size.height));
               label.text = [[tempdata objectAtIndex:i] objectAtIndex:2];
            }
        [mainview addSubview:label];
        }
    }
    [pages iterate:@"field" usingBlock: ^(RXMLElement *field) {
        NSMutableArray *test = [[NSMutableArray alloc] init];
        [field iterate:@"itemlocation.*" usingBlock:^(RXMLElement *repElement) {
       
        NSString *temp = repElement.text;
        [test addObject:temp];
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
                [field iterate:@"fontinfo.*" usingBlock:^(RXMLElement *fontElement) {
                    [test addObject:fontElement.text];
                }];
            }
            
            [fielddata addObject:test];
      
              
     }];
    for(int i = 0; i < [fielddata count]; i++){
        UITextField *text = [[UITextField alloc] init];
            text.frame =  CGRectIntegral(CGRectMake([[[fielddata objectAtIndex:i] objectAtIndex:0] floatValue] /4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:1] floatValue]/4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:3] floatValue]/4 *3));
            NSLog(@"frame %@", NSStringFromCGRect(text.frame));
            text.font = [UIFont fontWithName:[[fielddata objectAtIndex:i] objectAtIndex:6] size:[[[fielddata objectAtIndex:i] objectAtIndex:7] floatValue]];
            if ([[[fielddata objectAtIndex:i] objectAtIndex:4] isEqualToString:@"center"]) {
                text.textAlignment = UITextAlignmentCenter;
            }
                text.text = [[fielddata objectAtIndex:i] objectAtIndex:5];
        [mainview addSubview:text];
    }
    [pages iterate:@"line" usingBlock: ^(RXMLElement *lines) {
        NSMutableArray *tester = [[NSMutableArray alloc] init];
        [lines iterate:@"itemlocation.*" usingBlock:^(RXMLElement *repElements) {
                NSString *temp = repElements.text;
                [tester addObject:temp];
            }];
    [appDelegate.linedata addObject:tester];
          }];
  }
   NSLog(@"field data = %@", fielddata);
    NSLog(@"lines%@", appDelegate.linedata);
    NSLog(@"test%@", tempdata);
 scrollView.contentSize = CGSizeMake(mainview.frame.size.width, mainview.frame.size.height);
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
    }];
    NSString *tempstring = [appDelegate.pagename substringFromIndex:4];
    if ([tempstring intValue] == [pagesarray count])
    {
        self.navigationItem.rightBarButtonItem  = nil;
    }
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
- (void)cancelAction {
    [self.view endEditing:TRUE];
    [toolbar removeFromSuperview];
      [scrollView setScrollEnabled:YES];
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

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
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
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
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
        return YES;
}
-(void)nextpage {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    BOOL nextpagetrue;
     nextpagetrue = NO;
    for (int i = 0; i < [pagesarray count]; i++)
    {
          NSLog(@"arraypage %@", [pagesarray objectAtIndex:0]);
          NSLog(@"arraypage2 %@", appDelegate.pagename);
        
        if ([[pagesarray objectAtIndex:i] isEqualToString:appDelegate.pagename])
        {
            nextpagetrue = YES;
        }
    }
    if (nextpagetrue)
    {
        NSString *tempstring = [appDelegate.pagename substringFromIndex:4];
       if ([tempstring intValue] < [pagesarray count])
       {
        int i = [tempstring intValue] + 1;
        NSLog(@"tempstring %@", tempstring);
        appDelegate.pagename = [NSString stringWithFormat:@"%@%d", [appDelegate.pagename substringToIndex:4], i];
           NSLog(@"pagename %@", appDelegate.pagename);
           ViewController *viewCon = [self.storyboard instantiateViewControllerWithIdentifier:@"mainview"];
           [self.navigationController pushViewController:viewCon animated:YES];

       }
    }
  }
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    NSLog(@"tagtype %d", nextTag);
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    
    return YES; // We do not want UITextField to insert line-breaks.
}
-(void)viewWillDisappear:(BOOL)animated {
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([self isMovingFromParentViewController] )
    {
        NSLog(@"not called here");
        NSString *tempstring = [appDelegate.pagename substringFromIndex:4];
        if ([tempstring intValue] > 1){
        int i = [tempstring intValue] - 1;
        NSLog(@"tempstring %@", tempstring);
        appDelegate.pagename = [NSString stringWithFormat:@"%@%d", [appDelegate.pagename substringToIndex:4], i];
        }
    }
}

@end
