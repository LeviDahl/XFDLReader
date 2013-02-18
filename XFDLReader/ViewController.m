
#import "ViewController.h"
#import "RXMLElement.h"
#import "QuartzCore/QuartzCore.h"
#import "DrawLines.h"
#import "AppDelegate.h"
#import "GDataXMLNode.h"
#import "FormModel.h"
@interface ViewController ()
@property (nonatomic, strong) IBOutlet UIScrollView *pagingScrollView;
@property (nonatomic, strong) GDataXMLDocument *doc;
@property (nonatomic, strong) PageModel *pages;
@property (nonatomic, strong) NSMutableArray *pageArray;
@property (nonatomic, strong) FormModel *form;
@property (nonatomic, retain) UIPageControl* pageControl;
@property (nonatomic, strong) UIView *toolbarView;
@property (nonatomic, strong) NSString *fileHeader;
@property (nonatomic, strong) NSString *formNumber;
@end
BOOL loaded = NO;
 BOOL nextpagetrue;
@implementation ViewController
@synthesize scrollView, mainview, fielddata, toolbar, filepath, pickerview, pickerstring,  printController, backgroundColor, innerScrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageArray = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSData *filedata;
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"XFDL"];
    path = [path stringByAppendingPathComponent:filepath];
   // NSLog(@"path %@", path);
    if([fileManager fileExistsAtPath:path])
    {
        filedata  =  [fileManager contentsAtPath:path];
    }
    printController = [UIPrintInteractionController sharedPrintController];
    printController.delegate = self;
    pickerview = [[UIPickerView alloc] init];
    pickerview.dataSource = self;
    pickerview.delegate = self;
    pickerview.showsSelectionIndicator = YES;
    NSString *myData = [[NSString alloc] initWithData:filedata encoding:NSUTF8StringEncoding];
    self.fileHeader = [myData substringToIndex:51];
    NSString *newStr = [myData substringWithRange:NSMakeRange(51, [myData length]-51)];
    NSData *decodedData = [NSData dataWithBase64EncodedString:newStr];
    NSData *test = [decodedData gunzippedData];
  //  NSString *rawXML = [[NSString alloc] initWithData:test encoding:NSASCIIStringEncoding];
  //  NSLog(@"RAW %@", rawXML);
       UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionPane)];
    self.navigationItem.rightBarButtonItem = doneButton;
    NSError *error;
    self.doc = [[GDataXMLDocument alloc] initWithData:test options:0 error:&error];
    self.pages = [[PageModel alloc] init];
    NSArray *titles = [self.doc nodesForXPath:@"/_def_ns:XFDL/_def_ns:globalpage/_def_ns:global/_def_ns:xmlmodel/_def_ns:instances" error:&error];
   self.formNumber = [[[[[[[[[[titles objectAtIndex:0] childAtIndex:0] children] objectAtIndex:0] elementsForName:@"title"]  objectAtIndex:0] elementsForName:@"documentnbr"] objectAtIndex:0]attributeForName:@"number"] stringValue];
    NSArray *partyMembers = [self.doc.rootElement elementsForName:@"page"];
    scrollView.delegate = self;
    [scrollView setScrollEnabled:YES];
    int count = 0;
       for (GDataXMLElement *partyMember in partyMembers) {
       
      
           if (![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"INTRO"] && ![[[partyMember attributeForName:@"sid"]  stringValue] isEqualToString:@"PREPOP"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_3"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_1"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"PREPOP2"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_4"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_6"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_7"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_8"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_9"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_10"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_11"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_12"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_13"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_14"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_15"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_16"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_16a"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_17"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_18"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_19"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_20"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"CODE_TEMPLATE"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"ENCLOSURES"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"THIRTY_DAY_WAIVER"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"NON_CONCUR"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"RELIEF_FOR_CAUSE_BY_OFFICIAL"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"RESOURCE_PAGE"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_5"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_6a"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_21"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_22"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_23"]  && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_24"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_25"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_26"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_27"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_28"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_29"]  && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_30"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_31"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_32"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"TEMPLATE"])
           {
               if ([self.formNumber isEqualToString:@"2166-8-1"] || [self.formNumber isEqualToString:@"2166-8"])
               {
                   if (![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"PAGE3"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"PAGE4"]) {
                         [self.pages.pages addObject:partyMember];
                      [self loadPages];
                       [self loadFormGlobalsCount:count];
                       [self drawLabels];
                       [self drawLines];
                       [self drawTextFields];
                       [self drawImages];
                       count++;
                       innerScrollView.delegate = self;
                       CGFloat scalewidth =  innerScrollView.frame.size.width /innerScrollView.contentSize.width;
                       CGFloat scaleheight =  innerScrollView.frame.size.height /innerScrollView.contentSize.height;
                       CGFloat minScale = MIN(scalewidth, scaleheight);
                       innerScrollView.minimumZoomScale = minScale;
                       innerScrollView.maximumZoomScale = 2.0f;
                       innerScrollView.zoomScale = minScale;
                       [innerScrollView addSubview:mainview];
                       [scrollView addSubview:innerScrollView];
                   }
               }
               else
               {     [self.pages.pages addObject:partyMember];
                   [self loadPages];
                   [self loadFormGlobalsCount:count];
                   [self drawLabels];
                   [self drawLines];
                   [self drawTextFields];
                   [self drawImages];
                   count++;
                   innerScrollView.delegate = self;
                   CGFloat scalewidth =  innerScrollView.frame.size.width /innerScrollView.contentSize.width;
                   CGFloat scaleheight =  innerScrollView.frame.size.height /innerScrollView.contentSize.height;
                   CGFloat minScale = MIN(scalewidth, scaleheight);
                   innerScrollView.minimumZoomScale = minScale;
                   innerScrollView.maximumZoomScale = 2.0f;
                   innerScrollView.zoomScale = minScale;
                   [innerScrollView addSubview:mainview];
                   [scrollView addSubview:innerScrollView];
}
           }
    }
    scrollView.frame = CGRectMake(0, 0, innerScrollView.frame.size.width, [UIScreen mainScreen].bounds.size.width);
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(153,scrollView.frame.size.width,38,36)];
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    self.pageControl.enabled = TRUE;
    self.pageControl.numberOfPages = count;
    self.pageControl.backgroundColor = [UIColor blackColor];
   scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * count, scrollView.frame.size.height);
    NSLog(@"pages %@", [[[self.pages.pages objectAtIndex:0] attributeForName:@"sid"] stringValue]);
    }
- (void)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.mainview.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    NSLog(@"page %d", page+1);
}
-(void)checkBoxClicked:(UIButton *)button {
    NSLog(@"Button Clicked %d", button.tag);
    if ([button isSelected])
    {
      
        [button setSelected:NO];
    }
    else{
        [button setSelected:YES];
    }
    NSLog(@"button checked %c",[button isSelected]);
 
}
/*
-(void)comboBoxClicked:(UIButton *)button {
    [pickerarray removeAllObjects];
    NSLog(@"picker string %@", [[combodata objectAtIndex:button.tag] objectAtIndex:6]);
 if (![[[[combodata objectAtIndex:button.tag] objectAtIndex:6] substringToIndex:8] isEqualToString:@"RESOURCE"])
 {
        NSLog(@"cell data %@", [[celldata objectAtIndex:0] objectAtIndex:1]);
        for (int i =0; i < [celldata count]; i++)
        {
            if ([[[combodata objectAtIndex:button.tag] objectAtIndex:6] isEqualToString:[[celldata objectAtIndex:i] objectAtIndex:0]])
            {
                [pickerarray addObject:[celldata objectAtIndex:i]];
            }
        }
    [pickerarray addObject:[NSString stringWithFormat:@"%d", button.tag]];
    button.tag = arc4random();
    [pickerarray addObject:[NSString stringWithFormat:@"%d", button.tag]];
    [pickerview reloadAllComponents];
        NSLog(@"picker titles %@", pickerarray);
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
      pickerview.frame = CGRectMake(0, scrollView.frame.size.height-190, scrollView.frame.size.width, 180.0f);
        [scrollView addSubview:pickerview];
     mainview.userInteractionEnabled = NO;
 }
    else
    {
            NSLog(@"Resource button clicked");

            for (int i =0; i < [resourcearray count]; i++)
            {
                NSLog(@"combo data %@, %@", [[[combodata objectAtIndex:button.tag] objectAtIndex:6] substringFromIndex:14], [resourcearray objectAtIndex:i]);
                if ([[[[combodata objectAtIndex:button.tag] objectAtIndex:6] substringFromIndex:14] isEqualToString:[[resourcearray objectAtIndex:i] objectAtIndex:0]])
                {
                    [pickerarray addObject:[resourcearray objectAtIndex:i]];
                }
            }
            [pickerarray addObject:[NSString stringWithFormat:@"%d", button.tag]];
            button.tag = arc4random();
            [pickerarray addObject:[NSString stringWithFormat:@"%d", button.tag]];
            [pickerview reloadAllComponents];
            NSLog(@"picker titles %@", pickerarray);
           [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            pickerview.frame = CGRectMake(0, scrollView.frame.size.height-190, scrollView.frame.size.width, 180.0f);
            [scrollView addSubview:pickerview];
            mainview.userInteractionEnabled = NO;
        }
               //[self saveToDocumentsWithFileName:@"pdf.pdf"];
}*/
- (void)cancelAction {
    [self.view endEditing:TRUE];
    toolbar.hidden = YES;
    [scrollView setScrollEnabled:YES];
    mainview.userInteractionEnabled = TRUE;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if([textView hasText])
    {
        textView.layer.borderWidth = 0.0f;
        textView.backgroundColor = [UIColor clearColor];
        [scrollView setScrollEnabled:YES];
    }
    [toolbar removeFromSuperview];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    //  [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [scrollView setScrollEnabled:NO];
    // mainview.userInteractionEnabled = FALSE;
    if (toolbar)
    {
        toolbar = nil;
    }
    toolbar = [[UIToolbar alloc] init];
    CGSize size = [UIScreen mainScreen].bounds.size;
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)
    {
        size = CGSizeMake(size.height, size.width);
    }
    toolbar.frame =  toolbar.frame = CGRectMake(0,0,size.width, 44.0);
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                target: self
                                                                                action: @selector(cancelAction)];
    NSMutableArray* toolbarItems = [NSMutableArray array];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.tintColor = [UIColor darkGrayColor];
    [toolbar setTranslucent:YES];
    [toolbarItems addObject:flexibleSpaceLeft];
    [toolbarItems addObject:doneButton];
    toolbar.items = toolbarItems;
   self.toolbarView= [UIView new];
    [self.toolbarView addSubview:toolbar];
    self.toolbarView.frame = CGRectMake(0,0,toolbar.frame.size.width,44.0);
    NSLog(@"toolbarframe %@", NSStringFromCGRect(self.toolbarView.frame));
    mainview.userInteractionEnabled = NO;
     [textView setInputAccessoryView:self.toolbarView];
    return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
   pickerview.frame = CGRectMake(0, scrollView.frame.size.height-200, scrollView.frame.size.width, 180.0f);
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    //[self centerScrollViewContents];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    NSLog(@"scrollview zoomed frame %@", NSStringFromCGRect(innerScrollView.frame));
    [self centerScrollViewContents];
    
}
- (void)centerScrollViewContents {
    CGSize boundsSize = self.innerScrollView.bounds.size;
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
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollViews {
   CGFloat pageWidth = self.innerScrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    NSArray *temparray= [scrollView subviews];
    NSMutableArray *temp2 = [[NSMutableArray alloc] init];
    for (UIScrollView *tempscroll in temparray)
    {
        [temp2 addObject:tempscroll];
    }
     NSLog(@"scrollviews%@", temp2);
       if ([temp2 count] > 0)
    {
       if ([[[temp2 objectAtIndex:page ] subviews] count] > 0)
       {
        if ([[[[temp2 objectAtIndex:page ] subviews] objectAtIndex:0] isKindOfClass:[DrawLines class]])
        { NSLog(@"subviews%@", [[[temp2 objectAtIndex:page ] subviews] objectAtIndex:0]);
            return [[[temp2 objectAtIndex:page ] subviews] objectAtIndex:0];
        }
        else
        {
            return nil;
        }
       }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
        return YES;
}
-(BOOL)textViewShouldReturn:(UITextView*)textField {
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
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return @"title";
        
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"You selected this: ");
    [pickerview removeFromSuperview];
    pickerstring = [NSString stringWithFormat:@"%d",row];
    UIButton *button = (UIButton*)[mainview viewWithTag:7];
   /* if ([[pickerarray objectAtIndex:row] count] > 2)
    {
    [button setTitle:[[pickerarray objectAtIndex:row] objectAtIndex:2] forState:UIControlStateNormal];
    }
    else{
        [button setTitle:[[pickerarray objectAtIndex:row] objectAtIndex:1] forState:UIControlStateNormal];

    }
        button.tag = [[pickerarray objectAtIndex:[pickerarray count]-2] intValue];*/
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderWidth = 0.0f;
    mainview.userInteractionEnabled = YES;
}
-(void)saveToDocumentsWithFileName:(NSString*)aFilename {
    // Creates a mutable data object for updating with binary data, like a byte array
   
    NSMutableData *pdfData = [NSMutableData data];
    mainview.backgroundColor = [UIColor whiteColor];
    NSArray *array =  [scrollView subviews];
    UIGraphicsBeginPDFContextToData(pdfData, scrollView.bounds, nil);

    for (UIScrollView *innerViews in array)
    {
        for (UIView *views in [innerViews subviews])
        {
            if ([views isKindOfClass:[DrawLines class]])
            {
                NSLog(@"printframe %@", NSStringFromCGRect(views.bounds));
                UIGraphicsBeginPDFPageWithInfo(views.bounds, nil);
                CGContextRef pdfContext = UIGraphicsGetCurrentContext();
                [views.layer renderInContext:pdfContext];
            }
        }
    }
   
    UIGraphicsEndPDFContext();
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    [mailer setSubject:@"Sending Form"];
    [mailer addAttachmentData:[NSData dataWithContentsOfFile:documentDirectoryFilename]
                     mimeType:@"application/pdf"
                     fileName:aFilename];
    [self presentModalViewController:mailer animated:YES];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissModalViewControllerAnimated:YES];
    mainview.backgroundColor = backgroundColor;
}
-(void)actionPane {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Form Options"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Email to PDF", @"Print",@"Save XFDL File", nil];
        [actionSheet showInView:scrollView];
        loaded = NO;
    
  
       
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
            switch (buttonIndex) {
                case 0:
                    [self saveToDocumentsWithFileName:[NSString stringWithFormat:@"%@.pdf", [filepath stringByDeletingPathExtension]]];
                    break;
                case 1:
                    [self printButton];
                    break;
                case 2:
                    [self saveFile];
                    break;
                default:
                    break;
            }
    }
-(void)printButton{
    NSMutableData *pdfData = [NSMutableData data];
    innerScrollView.backgroundColor = [UIColor whiteColor];
    NSArray *array =  [scrollView subviews];
    UIGraphicsBeginPDFContextToData(pdfData, scrollView.bounds, nil);
    for (UIScrollView *innerViews in array)
    {
        for (UIView *views in [innerViews subviews])
        {
            if ([views isKindOfClass:[DrawLines class]])
            {
                NSLog(@"printframe %@", NSStringFromCGRect(views.bounds));
                UIGraphicsBeginPDFPageWithInfo(views.bounds, nil);
                CGContextRef pdfContext = UIGraphicsGetCurrentContext();
                [views.layer renderInContext:pdfContext];
            }
        }
    }
      UIGraphicsEndPDFContext();
 
    // Retrieves the document directories from the iOS device
  /*  NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];*/
    
    // instructs the mutable data object to write its context to a file on disk
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
        if (completed)
        {
            //mainview.backgroundColor = backgroundColor;
        }
    };
    printController.printingItem = pdfData;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSLog(@"IPAD");
        [printController presentFromRect:CGRectMake(100, 100, 200, 200) inView:scrollView animated:YES completionHandler:completionHandler];
    } else {
        [printController presentAnimated:YES completionHandler:completionHandler];
    }
}
- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)aRange replacementText:(NSString*)aText
{
    
    NSString* newText = [aTextView.text stringByReplacingCharactersInRange:aRange withString:aText];
    CGSize tallerSize = CGSizeMake(aTextView.frame.size.width,aTextView.frame.size.height*2); // pretend there's more vertical space to get that extra line to check on
    CGSize newSize = [newText sizeWithFont:aTextView.font constrainedToSize:tallerSize lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"height %f %f", newSize.height, aTextView.frame.size.height);
    if (newSize.height > aTextView.frame.size.height+5)
    {
        return NO;
    }
    else
        return YES;
}
-(void)loadPages {
     for (GDataXMLElement *page in self.pages.pages) {
         
         scrollView.pagingEnabled = YES;
    self.form = [[FormModel alloc] initWithParameters:page];
         [self.pageArray addObject:self.form];
         
     }
}
-(void)drawLabels {
    for (LabelModel *labelData in self.form.labels)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(roundf([[labelData.location objectForKey:@"x"] floatValue] /4 *3), roundf([[labelData.location objectForKey:@"y"] floatValue] /4 *3),roundf([[labelData.location objectForKey:@"width"] floatValue] /4 *3),roundf([[labelData.location objectForKey:@"height"] floatValue] /4 *3)))];
        label.text = labelData.value;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:[labelData.font objectForKey:@"fontname"] size:[[labelData.font objectForKey:@"fontsize" ]  intValue]];
        label.minimumFontSize = [[labelData.font objectForKey:@"fontsize" ] intValue];
        label.numberOfLines = 0;
        if ([labelData.justify isEqualToString:@"center"])
        {
            CGSize size = [label.text sizeWithFont:label.font];
            
            label.textAlignment = UITextAlignmentCenter;
            label.frame = CGRectIntegral(CGRectMake(label.frame.origin.x + (label.frame.size.width/2)-(size.width/2), label.frame.origin.y, label.frame.size.width, label.frame.size.height));
        NSLog(@"size123 %@", NSStringFromCGRect(label.frame));}

        [label sizeToFit];
        [mainview addSubview:label];
    }
}
-(void)drawLines {
    mainview.form = self.form;
    [mainview setNeedsDisplay];
}
-(void)drawTextFields {
    for (TextViewModel *fields in self.form.fields)
    {int count = 0;
        fields.field .frame =CGRectIntegral(CGRectMake(roundf([[fields.location objectForKey:@"x"] floatValue] /4 *3), roundf([[fields.location objectForKey:@"y"] floatValue] /4 *3),roundf([[fields.location objectForKey:@"width"] floatValue] /4 *3),roundf([[fields.location objectForKey:@"height"] floatValue] /4 *3)));
        fields.field.delegate = self;
        fields.field.text = fields.value;
        if ([fields.value length] == 0)
        {
            fields.field.layer.borderWidth = 1.0;
        }
        fields.field.contentInset = UIEdgeInsetsMake(-8,-8,-8,-8);
       fields.field.backgroundColor = [UIColor clearColor];
        fields.field.font = [UIFont fontWithName:[fields.font objectForKey:@"fontname"] size:[[fields.font objectForKey:@"fontsize" ]  intValue]];
       // NSLog(@"expected font: %@, %d, actual font: %@", [fields.font objectForKey:@"fontname"], [[fields.font objectForKey:@"fontsize" ] intValue], field.font);
        [mainview addSubview:fields.field];
        count++;
    }
}
-(void)drawImages {
    for (ImageModel *image in self.form.images)
    {
       for (DataModel *data in self.form.data)
       {
        if ([image.imageName isEqualToString:data.name])
        {
            NSLog(@"image name %@", data.name);
            NSData *decoded = [[NSData dataWithBase64EncodedString:data.data] gunzippedData];
            UIImage *images = [[UIImage alloc] initWithData:decoded];
            UIImageView *imageView =  [[UIImageView alloc]initWithImage:images];
            imageView.frame = CGRectIntegral(CGRectMake(roundf([[image.location objectForKey:@"x"] floatValue] /4 *3), roundf([[image.location objectForKey:@"y"] floatValue] /4 *3),roundf([[image.location objectForKey:@"width"] floatValue] /4 *3),roundf([[image.location objectForKey:@"height"] floatValue] /4 *3)));
            [mainview addSubview:imageView];
        }
       }
    }
}
-(void)loadFormGlobalsCount: (int) count {
    mainview = [[DrawLines alloc] init];
    innerScrollView = [[UIScrollView alloc] init];
    NSError *error;
NSArray *titles = [self.doc  nodesForXPath:@"/_def_ns:XFDL/_def_ns:globalpage/_def_ns:global/_def_ns:printsettings/_def_ns:dialog/_def_ns:orientation" error:&error];
  if ([titles count] > 0)
  {
     GDataXMLElement *orientation = [titles objectAtIndex:0];
    if ([self.form.page_orientation isEqualToString:@"letter"])
    {
       
           NSLog(@"title %@", orientation.stringValue);
       
        mainview.frame = CGRectIntegral(CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height));

    }
    else{
        mainview.frame = CGRectIntegral(CGRectMake(0,0,1024, 900));

           }
  }
   else
   {
         mainview.frame = CGRectIntegral(CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height));
   }
    innerScrollView.frame = CGRectIntegral(CGRectMake(mainview.frame.size.width * count,mainview.frame.origin.y, mainview.frame.size.width, mainview.frame.size.height));
    NSLog(@"fmainviewframe %@", NSStringFromCGRect(innerScrollView.frame));
  //  innerScrollView.frame = mainview.frame;
    innerScrollView.contentSize = mainview.frame.size;
    /*if ([[pages child:@"global.vfd_pagesize"].text isEqualToString:@"letter"]) {
        if ([[rootXML child:@"globalpage.global.printsettings.dialog.orientation"].text isEqualToString:@"landscape"])
        {
            mainview.frame = CGRectIntegral(CGRectMake(0,0,958,730));
        }
        else{
            mainview.frame = CGRectIntegral(CGRectMake(0,0,730,958));
        }
    }
    else if ([[pages child:@"global.vfd_pagesize"].text isEqualToString:@"custom"]) {
        NSArray *temp =  [[pages child:@"global.vfd_customsize"].text componentsSeparatedByString:@";"];
        if ([temp count] > 2)
        {
            if ([[temp objectAtIndex:2] isEqualToString:@"Pixels"])
            {
                mainview.frame = CGRectIntegral(CGRectMake(0,0,[[temp objectAtIndex:0] floatValue]/4 *3,[[temp objectAtIndex:1] floatValue]/4 *3));
            }
            else
            {
                mainview.frame = CGRectIntegral(CGRectMake(0,0,([[temp objectAtIndex:0] floatValue]*72)*4 /3,([[temp objectAtIndex:1] floatValue]*72)*4 /3));
            }
        }
    }
    else {
        if ([[rootXML child:@"globalpage.global.printsettings.dialog.orientation"].text isEqualToString:@"landscape"])
        {
            mainview.frame = CGRectIntegral(CGRectMake(0,0,958,730));
        }
        else{
            mainview.frame = CGRectIntegral(CGRectMake(0,0,730,958));
        }
    }*/
}
-(void)saveFile  {
  
    NSMutableArray *temp = [[NSMutableArray alloc] init];
   /* if ([self.formNumber isEqualToString:@"2166-8-1"] || [self.formNumber isEqualToString:@"2166-8"]) {
        NSError *error;
        NSArray *titles = [self.doc nodesForXPath:@"/_def_ns:XFDL/_def_ns:globalpage/_def_ns:global/_def_ns:xmlmodel/_def_ns:instances" error:&error];
        GDataXMLElement *instances = [[[titles objectAtIndex:0] children] objectAtIndex:7];
        NSLog(@"insta%@",instances);
        for (FormModel *form in self.pageArray)
        for (TextViewModel *fieldcheck in form.fields) {
            NSString *temps = [fieldcheck.field text];
            NSLog(@"temps %@", temps);
            for (GDataXMLNode *mains in [[[instances elementsForName:@"MAIN_DATA"] objectAtIndex:0]children])
              if ([fieldcheck.name isEqualToString:mains.name])
            { 
                [mains setStringValue:fieldcheck.field.text];
                NSLog(@"mains%@",mains);
            }
     }
    }
    else
    {*/
        NSArray *array = [[self.doc rootElement] elementsForName:@"page"];
    
    for (GDataXMLElement *element in array) {
        NSLog(@"root %@", [element attributeForName:@"sid"]);
        for (GDataXMLElement *f in [element elementsForName:@"field"]) {
            NSLog(@"root %@", [f attributeForName:@"sid"]);
            FormModel *currentPage = [self.pageArray objectAtIndex:[array indexOfObject:element]];
            for (TextViewModel *fieldcheck in currentPage.fields)
                {
                    NSString *temps = [fieldcheck.field text];
                NSLog(@"%@ for sid:%@",[fieldcheck.field text], fieldcheck.name);
                if ([fieldcheck.name isEqualToString:[f attributeForName:@"sid"].stringValue]) {
                    NSLog(@"field check succeeded, file sid %@", [f attributeForName:@"sid"].stringValue);
                        if ([[f elementsForName:@"value"] objectAtIndex:0] == nil)
                        {
                            GDataXMLElement * textValue =
                            [GDataXMLNode elementWithName:@"value" stringValue:temps];
                            [f addChild:textValue];
                        }
                        else
                        {[f removeChild:[[f elementsForName:@"value" ] objectAtIndex:0]];
                            GDataXMLElement * textValue =
                            [GDataXMLNode elementWithName:@"value" stringValue:temps];
                            [f addChild:textValue];
                        }
                    }
                
                else
                {
                    NSLog(@"field check did not succeed tag %@ and tag %@", fieldcheck.name, [f attributeForName:@"sid"].stringValue);
                }
            }
        
        }
    }
 //   }
 NSLog(@"test1234%@", temp);
    NSData *encoded = [self.doc.XMLData gzippedData];
    NSString *zipped = [encoded base64EncodedString];
    NSString *fullfile = [NSString stringWithFormat:@"%@\n%@", self.fileHeader,zipped];
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [[documentDirectories objectAtIndex:0] stringByAppendingPathComponent:@"XFDL"];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:@"test.xfdl"];
    
    // instructs the mutable data object to write its context to a file on disk
    [fullfile writeToFile:documentDirectoryFilename atomically:YES encoding:NSUTF8StringEncoding error:NULL];

}

   @end
