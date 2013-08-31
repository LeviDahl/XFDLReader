
#import "ViewController.h"
#import "RXMLElement.h"
#import "QuartzCore/QuartzCore.h"
#import "DrawLines.h"
#import "AppDelegate.h"
#import "GDataXMLNode.h"
#import "FormModel.h"

@interface ViewController ()
@property (nonatomic, strong) GDataXMLDocument *doc;
@property (nonatomic, strong) PageModel *pages;
@property (nonatomic, strong) NSMutableArray *pageArray;
@property (nonatomic, strong) FormModel *form;
@property (nonatomic, retain) UIPageControl* pageControl;
@property (nonatomic, strong) UIView *toolbarView;
@property (nonatomic, strong) NSString *fileHeader;
@property (nonatomic, strong) NSString *formNumber;
@property (nonatomic, strong) NSString *formTitle;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *saveFileName;
@property (nonatomic, strong) NSString *emailFileName;
@property (nonatomic, strong) NSMutableDictionary *namespaces;
@property (nonatomic, strong) NSMutableArray *forms;
@end

BOOL loaded = NO;
BOOL nextpagetrue;
@implementation ViewController
@synthesize scrollView, mainview, toolbar, filepath, pickerview, pickerstring,  printController, backgroundColor, innerScrollView, pickerarray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageArray = [[NSMutableArray alloc] init];
    self.forms = [[NSMutableArray alloc] init];
    self.namespaces = [[NSMutableDictionary alloc] init];
    pickerarray = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *filedata;
    if([fileManager fileExistsAtPath:filepath])
    {
        filedata  =  [fileManager contentsAtPath:filepath];
    }
    printController = [UIPrintInteractionController sharedPrintController];
    printController.delegate = self;
    pickerview = [[UIPickerView alloc] init];
    pickerview.dataSource = self;
    pickerview.delegate = self;
    pickerview.showsSelectionIndicator = YES;
    NSString *myData = [[NSString alloc] initWithData:filedata encoding:NSUTF8StringEncoding];
    NSRange range = [myData rangeOfString:@"\n"];
    self.fileHeader = [myData substringToIndex:range.location];
    NSString *rawData = [myData substringFromIndex:range.location];
    if (![self.fileHeader isEqualToString:@"application/x-xfdl;content-encoding=\"asc-gzip\""])
    {
        NSData *decodedData = [NSData dataWithBase64EncodedString:rawData];
        NSData *test = [decodedData gunzippedData];
        //   NSString *rawXML = [[NSString alloc] initWithData:test encoding:NSASCIIStringEncoding];
        //  NSLog(@"RAW %@", rawXML);
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionPane)];
        self.navigationItem.rightBarButtonItem = doneButton;
        NSError *error;
        self.doc = [[GDataXMLDocument alloc] initWithData:test options:0 error:&error];
        NSArray *namespaceArray = self.doc.rootElement.namespaces;
        GDataXMLNode *node;
        for (GDataXMLNode *namespace in namespaceArray)
        {
            [self.namespaces setObject:namespace.stringValue forKey:[NSString stringWithFormat:@"ns%lu",(unsigned long)[namespaceArray indexOfObject:namespace]]];
            if ([namespace.name isEqualToString:@"xfdl"])
            {
                node = namespace;
            }
        }
        self.version = [node.stringValue lastPathComponent];
        NSLog(@"version %@", self.version);
        self.pages = [[PageModel alloc] init];
        
        if ([self.version isEqualToString:@"6.5"])
        {
            NSArray *titles = [self.doc nodesForXPath:@"/_def_ns:XFDL/_def_ns:globalpage/_def_ns:global/_def_ns:xmlmodel/_def_ns:instances" error:&error];
            if ([titles count] > 0) {
                self.formNumber = [[[[[[[[[[titles objectAtIndex:0] childAtIndex:0] children] objectAtIndex:0] elementsForName:@"title"]  objectAtIndex:0] elementsForName:@"documentnbr"] objectAtIndex:0]attributeForName:@"number"] stringValue];
            }
            NSArray *formTitle = [self.doc nodesForXPath:@"/_def_ns:XFDL/_def_ns:globalpage/_def_ns:global/_def_ns:formid/_def_ns:title" error:&error];
            if ([formTitle count] > 0) {
                GDataXMLElement *title= [formTitle objectAtIndex:0];
                self.formTitle = title.stringValue;
            }
            else
            {
                self.formTitle = self.formNumber;
            }
        }
        else if ([self.version isEqualToString:@"6.0"])
        { NSArray *titles = [self.doc nodesForXPath:@"/_def_ns:XFDL/_def_ns:globalpage/_def_ns:global/_def_ns:formid/_def_ns:title" error:&error];
            GDataXMLElement *title= [titles objectAtIndex:0];
            self.formTitle = title.stringValue;
            
            NSArray *titlecheck = [self.doc nodesForXPath:@"/_def_ns:XFDL/_def_ns:globalpage/_def_ns:global" error:&error];
            GDataXMLElement *formNum = [[[[[[[titlecheck objectAtIndex:0] elementsForName:@"custom:form_metadata"] objectAtIndex:0] elementsForName:@"custom:shorttitle"] objectAtIndex:0] elementsForName:@"custom:number"] objectAtIndex:0];
            self.formNumber = formNum.stringValue;
            NSLog(@"form number %@", self.formNumber);
        }
        self.title = self.formTitle;
        NSArray *partyMembers = [self.doc.rootElement elementsForName:@"page"];
        scrollView.delegate = self;
        [scrollView setScrollEnabled:YES];
        
        for (GDataXMLElement *partyMember in partyMembers) {
            if (![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"INTRO"] && ![[[partyMember attributeForName:@"sid"]  stringValue] isEqualToString:@"PREPOP"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_3"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_1"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"PREPOP2"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_4"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_6"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_7"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_8"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_9"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_10"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_11"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_12"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_13"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_14"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_15"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_16"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_16a"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_17"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_18"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_19"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_20"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"CODE_TEMPLATE"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"ENCLOSURES"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"THIRTY_DAY_WAIVER"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"NON_CONCUR"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"RELIEF_FOR_CAUSE_BY_OFFICIAL"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"RESOURCE_PAGE"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_5"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_6a"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_21"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_22"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_23"]  && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_24"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_25"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_26"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_27"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_28"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_29"]  && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_30"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_31"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"WIZ_32"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"TEMPLATE"])
            {
                if ([self.formNumber isEqualToString:@"2166-8-1"] || [self.formNumber isEqualToString:@"2166-8"])
                {
                    if (![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"PAGE3"] && ![[[partyMember attributeForName:@"sid"] stringValue] isEqualToString:@"PAGE4"]) {
                        [self.pages.pages addObject:partyMember];
                    }
                }
                else
                {     [self.pages.pages addObject:partyMember];
                    
                }
            }
        }
        [self loadPages];
        
        scrollView.frame = CGRectMake(0, 0, innerScrollView.frame.size.width, innerScrollView.frame.size.height);
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.pages.pages count], scrollView.frame.size.height);
        //   self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(153,scrollView.frame.size.width,scrollView.frame.size.height-20,36)];
        
        //    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        //   self.pageControl.enabled = TRUE;
        // self.pageControl.numberOfPages = [self.pages.pages count];
        //  self.pageControl.backgroundColor = [UIColor blackColor];
        
        NSLog(@"pages %@", [[[self.pages.pages objectAtIndex:0] attributeForName:@"sid"] stringValue]);
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unsupported File" message:@"Sorry, but this file is currently unsupported. Please check the support forum for more information." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 9;
        [alert show];
    }
}
- (void)changePage {
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.innerScrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
}
-(void)checkBoxClicked:(UIButton *)button {
    if ([button isSelected])
    {
        [button setSelected:NO];
    }
    else{
        [button setSelected:YES];
    }
    NSLog(@"button checked %c",[button isSelected] );
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setTitle:@"X" forState:UIControlStateSelected];
}
-(void)comboBoxClicked:(UIButton *)button {
    NSLog(@"Combobox button clicked");
    [pickerarray removeAllObjects];
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    FormModel *form = [self.forms objectAtIndex:page];
    ComboBoxModel *combo = [form.comboboxes objectAtIndex:button.tag];
    NSArray *string = [combo.group componentsSeparatedByString:@"."];
    if ([[string objectAtIndex:0] isEqualToString:form.description])
    {
        combo.group = [string objectAtIndex:1];
    }
    for (CellModel *cellGroup in form.cells)
    {
        if ([combo.group isEqualToString:cellGroup.group])
        {
            NSLog(@"%@ MATCH!",cellGroup.group);
            [pickerarray addObject:cellGroup.value];
        }
    }
    pickerview.frame = CGRectMake(0, scrollView.frame.size.height-190, scrollView.frame.size.width, 180.0f);
    [scrollView addSubview:pickerview];
    [pickerview reloadAllComponents];
    
}
- (void)cancelAction {
    [self.view endEditing:TRUE];
    toolbar.hidden = YES;
    [scrollView setScrollEnabled:YES];
    mainview.userInteractionEnabled = TRUE;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    scrollView.userInteractionEnabled = TRUE;
    if([textView hasText])
    {
        textView.layer.borderWidth = 0.0f;
        textView.backgroundColor = [UIColor clearColor];
    }
    [toolbar removeFromSuperview];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    FormModel *form = [self.pageArray objectAtIndex: self.pageControl.currentPage];
    for (TextViewModel *text in form.fields)
    {
        if (textView == text.field)
        {
            text.wasTextModified = true;
            NSLog(@"Found Text Box");
        }
    }
    scrollView.userInteractionEnabled = FALSE;
    if (toolbar)
    {
        toolbar = nil;
    }
    toolbar = [[UIToolbar alloc] init];
    
    //  NSLog(@"orientation123 %d",[[UIApplication sharedApplication] statusBarOrientation]);
    toolbar.frame =  toolbar.frame = CGRectMake(0,0,SCREEN_WIDTH, 44.0);
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
    [textView setInputAccessoryView:self.toolbarView];
    return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGFloat width;
    CGFloat height;
    if (mainview.frame.size.width > SCREEN_WIDTH)
    {
        width = mainview.frame.size.width;
    }
    else
    {
        width = SCREEN_WIDTH;
    }
    if (mainview.frame.size.height > SCREEN_HEIGHT)
    {
        height= mainview.frame.size.height;
    }
    else
    {
        height = SCREEN_HEIGHT;
    }
    for (UIView *subview in scrollView.subviews)
    {
       if ([subview isKindOfClass:[UIScrollView class]])
       {
               subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y, width, height);
               innerScrollView.frame = subview.frame;
        }
        
    }
    scrollView.frame = CGRectMake(0, 0, innerScrollView.frame.size.width, innerScrollView.frame.size.height);
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.pages.pages count], scrollView.frame.size.height);
    pickerview.frame = CGRectMake(0, scrollView.frame.size.height-200, scrollView.frame.size.width, 180.0f);
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    
    self.toolbarView.frame = CGRectMake(self.toolbarView.frame.origin.x, self.toolbarView.frame.origin.y, SCREEN_WIDTH, self.toolbarView.frame.size.height);
    self.toolbar.frame = self.toolbarView.frame;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    // NSLog(@"scrollview zoomed frame %@", NSStringFromCGRect(innerScrollView.frame));
   // [self centerScrollViewContents];
    
}
- (void)centerScrollViewContents {
  /* CGSize boundsSize = mainview.bounds.size;
    CGRect contentsFrame = mainview.frame;
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
    self.mainview.frame = contentsFrame;*/
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollViews {
    CGFloat pageWidth = self.innerScrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)+1;
    self.pageControl.currentPage = page;
    NSArray *temparray= [scrollView subviews];
    NSMutableArray *temp2 = [[NSMutableArray alloc] init];
    for (UIScrollView *tempscroll in temparray)
    {
        [temp2 addObject:tempscroll];
    }
    //   NSLog(@"scrollviews%@ %d", temp2, page);
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
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    return YES;
}
-(BOOL)textViewShouldReturn:(UITextView*)textField {
    NSInteger nextTag = textField.tag + 1;
    NSLog(@"tagtype %d", nextTag);
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerarray count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerarray objectAtIndex:row];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"You selected this:" );
    [pickerview removeFromSuperview];
    pickerstring = [NSString stringWithFormat:@"%d",row];
    [pickerarray removeAllObjects];
    UIButton *button = (UIButton*)[mainview viewWithTag:7];
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderWidth = 0.0f;
    mainview.userInteractionEnabled = YES;
}
-(void)saveToDocumentsWithFileName:(NSString*)aFilename {
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
                if ([[views subviews] count] > 0)
                {
                    for (UITextView *text in [views subviews])
                    {
                        NSLog(@"view %@", text);
                        if ([text isKindOfClass:[UITextView class]])
                        {
                            text.layer.borderWidth = 0.0;
                        }
                    }
                }
                
                NSLog(@"printframe %@", NSStringFromCGRect(views.bounds));
                UIGraphicsBeginPDFPageWithInfo(views.bounds, nil);
                CGContextRef pdfContext = UIGraphicsGetCurrentContext();
                [views.layer renderInContext:pdfContext];
            }
        }
    }
    
    UIGraphicsEndPDFContext();
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    
    NSString* documentDirectoryFilename = [[documentDirectory stringByAppendingPathComponent:@"PDFs" ] stringByAppendingPathComponent:aFilename];
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    self.emailFileName = documentDirectoryFilename;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PDF Saved" message:@"Your PDF has been saved. Would you like to email it?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    alert.tag = 7;
    [alert show];
    for (UIScrollView *innerViews in array)
    {
        for (UIView *views in [innerViews subviews])
        {
            if ([views isKindOfClass:[DrawLines class]])
            {
                if ([[views subviews] count] > 0)
                {
                    for (UITextView *text in [views subviews])
                    {
                        NSLog(@"view %@", text);
                        if ([text isKindOfClass:[UITextView class]])
                        {
                            text.layer.borderWidth = 1.0;
                        }
                    }
                }
            }
        }
    }
}
-(void)sendEmail:(NSString *)path {
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    [mailer setSubject:@"Sending Form"];
    NSData *pdfData = [[NSFileManager defaultManager] contentsAtPath:path];
    [mailer addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[path lastPathComponent]];
    [self presentModalViewController:mailer animated:YES];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissModalViewControllerAnimated:YES];
}
-(void)actionPane {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Form Options"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save as PDF", @"Print",@"Save XFDL File", nil];
    [actionSheet showInView:scrollView];
    loaded = NO;
    
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self saveToDocumentsWithFileName:[NSString stringWithFormat:@"%@.pdf", [[filepath lastPathComponent] stringByDeletingPathExtension]]];
            break;
        case 1:
            [self printButton];
            break;
        case 2:
            [self saveButtonPressed];
            break;
        default:
            break;
    }
}
-(void)willPresentAlertView:(UIAlertView *)alertView {
    if (alertView.tag == 5)
    {
        for (UIView *view in alertView.subviews) {
            if ([view isKindOfClass:[UITextField class]]||
                [view isKindOfClass:[UIButton class]] || view.frame.size.height==31) {
                CGRect rect=view.frame;
                rect.origin.y += 65;
                view.frame = rect;
            }
        }
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
                if ([[views subviews] count] > 0)
                {
                    for (UITextView *text in [views subviews])
                    {
                        NSLog(@"view %@", text);
                        if ([text isKindOfClass:[UITextView class]])
                        {
                            text.layer.borderWidth = 0.0;
                        }
                    }
                }
                NSLog(@"printframe %@", NSStringFromCGRect(views.bounds));
                UIGraphicsBeginPDFPageWithInfo(views.bounds, nil);
                CGContextRef pdfContext = UIGraphicsGetCurrentContext();
                [views.layer renderInContext:pdfContext];
            }
        }
    }
    UIGraphicsEndPDFContext();
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
        if (completed)
        {
            //mainview.backgroundColor = backgroundColor;
            for (UIScrollView *innerViews in array)
            {
                for (UIView *views in [innerViews subviews])
                {
                    if ([views isKindOfClass:[DrawLines class]])
                    {
                        if ([[views subviews] count] > 0)
                        {
                            for (UITextView *text in [views subviews])
                            {
                                NSLog(@"view %@", text);
                                if ([text isKindOfClass:[UITextView class]])
                                {
                                    text.layer.borderWidth = 1.0;
                                }
                            }
                        }
                    }
                }
            }
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
    int i = 0;
    for (GDataXMLElement *page in self.pages.pages) {
        self.form = [[FormModel alloc] initWithParameters:page andVersion:self.version];
        [self.pageArray addObject:self.form];
        [self loadFormGlobalsCount:i];
        [self drawLabels];
        [self drawLines];
        [self drawTextFields];
        [self drawImages];
        [self drawCheckBoxes];
        [self drawComboBoxes];
        [self.forms addObject:self.form];
        innerScrollView.delegate = self;
        CGFloat scalewidth =  innerScrollView.frame.size.width  /innerScrollView.contentSize.width;
        CGFloat scaleheight =  innerScrollView.frame.size.height /innerScrollView.contentSize.height;
        CGFloat minScale = MIN(scalewidth, scaleheight);
        innerScrollView.minimumZoomScale = minScale;
        innerScrollView.maximumZoomScale = 2.0f;
        innerScrollView.zoomScale = minScale;
        [innerScrollView addSubview:mainview];
        [scrollView addSubview:innerScrollView];
        innerScrollView.pagingEnabled = NO;
        scrollView.pagingEnabled = YES;
        [self centerScrollViewContents];
        i++;
    }
}

-(void)drawLabels {
    for (LabelModel *labelData in self.form.labels)
    {
        if (labelData.visible)
        {
            /*  if ([labelData.location objectForKey:@"width"] !=nil)
             {*/
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(roundf([[labelData.location objectForKey:@"x"] floatValue] /4 *3), roundf([[labelData.location objectForKey:@"y"] floatValue] /4 *3),roundf([[labelData.location objectForKey:@"width"] floatValue] /4 *3),roundf([[labelData.location objectForKey:@"height"] floatValue] /4 *3)))];
            //}
            
            label.text = labelData.value;
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:[labelData.font objectForKey:@"fontname"] size:[[labelData.font objectForKey:@"fontsize"]  intValue]];
            //  NSLog(@"label font %@",labelData.font);
            label.minimumFontSize = [[labelData.font objectForKey:@"fontsize"] intValue];
            label.numberOfLines = 0;
            if ([labelData.justify isEqualToString:@"center"])
            {
                CGSize size = [label.text sizeWithFont:label.font];
                
                label.textAlignment = UITextAlignmentCenter;
                label.frame = CGRectIntegral(CGRectMake(label.frame.origin.x + (label.frame.size.width/2)-(size.width/2), label.frame.origin.y, label.frame.size.width, label.frame.size.height));
                //    NSLog(@"size123 %@", NSStringFromCGRect(label.frame));
            }
            
            [label sizeToFit];
            [mainview addSubview:label];
        }
    }
}
-(void)drawLines {
    mainview.form = self.form;
    [mainview setNeedsDisplay];
}
-(void)drawTextFields {
    for (TextViewModel *fields in self.form.fields)
    {
        int count = 0;
        fields.field.frame =CGRectIntegral(CGRectMake(roundf([[fields.location objectForKey:@"x"] floatValue] /4 *3), roundf([[fields.location objectForKey:@"y"] floatValue] /4 *3),roundf([[fields.location objectForKey:@"width"] floatValue] /4 *3),roundf([[fields.location objectForKey:@"height"] floatValue] /4 *3)));
        fields.field.delegate = self;
        fields.field.text = fields.value;
        fields.field.autocorrectionType = UITextAutocorrectionTypeYes;
        if ([fields.value length] == 0)
        {
            fields.field.layer.borderWidth = 1.0;
        }
        fields.field.contentInset = UIEdgeInsetsMake(-8,-8,-8,-8);
        fields.field.backgroundColor = [UIColor clearColor];
        fields.field.font = [UIFont fontWithName:[fields.font objectForKey:@"fontname"] size:[[fields.font objectForKey:@"fontsize" ]  intValue]];
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
-(void)drawCheckBoxes {
    for (CheckBoxModel *check in self.form.checkboxes)
    {
        check.checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
        check.checkbox.titleLabel.font = [UIFont fontWithName:[check.font objectForKey:@"fontname"] size:[[check.font objectForKey:@"fontsize"] floatValue]];
        CGSize size = [@"A" sizeWithFont:check.checkbox.titleLabel.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        NSString *width = [NSString stringWithFormat:@"%.0f",size.height];
        NSString *height = [NSString stringWithFormat:@"%.0f",size.height];
        if ([check.location objectForKey:@"height"] == nil)
        {
            [check.location setObject:height forKey:@"height"];
        }
        if ([check.location objectForKey:@"width"] == nil)
        {
            [check.location setObject:width forKey:@"width"];
        }
        check.checkbox.frame = CGRectIntegral(CGRectMake(roundf([[check.location objectForKey:@"x"] floatValue] /4 *3), roundf([[check.location objectForKey:@"y"] floatValue] /4 *3),roundf([[check.location objectForKey:@"width"] floatValue] /4 *3),roundf([[check.location objectForKey:@"height"] floatValue] /4 *3)));
        check.checkbox.backgroundColor = [UIColor whiteColor];
        [check.checkbox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal | UIControlStateSelected];
        check.checkbox.layer.borderWidth = 1.0f;
        [check.checkbox addTarget:self action:@selector(checkBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
        if ([check.value isEqualToString:@"off"])
        {
            [check.checkbox setSelected:NO];
        }
        else {
            [check.checkbox setSelected:YES];
        }
        if (size.width > check.checkbox.frame.size.width || size.height > check.checkbox.frame.size.height)
        {
            
        }
        [check.checkbox setTitle:@"" forState:UIControlStateNormal];
        [check.checkbox setTitle:@"X" forState:UIControlStateSelected];
        check.checkbox.titleLabel.adjustsFontSizeToFitWidth = YES;
        //   [check.checkbox sizeToFit];
        [mainview addSubview:check.checkbox];
    }
}
-(void)drawComboBoxes {
    int count = 0;
    for (ComboBoxModel *comboboxes in self.form.comboboxes)
    {
        // UIPickerView *combobox = [[UIPickerView alloc] init];
        UIButton *combobox = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        combobox.frame = CGRectIntegral(CGRectMake(roundf([[comboboxes.location objectForKey:@"x"] floatValue] /4 *3), roundf([[comboboxes.location objectForKey:@"y"] floatValue] /4 *3),roundf([[comboboxes.location objectForKey:@"width"] floatValue] /4 *3),roundf([[comboboxes.location objectForKey:@"height"] floatValue] /4 *3)));
        // NSLog(@"expected font: %@, %d, actual font: %@", [fields.font objectForKey:@"fontname"], [[fields.font objectForKey:@"fontsize" ] intValue], field.font);
        combobox.tag = count;
        [combobox addTarget:self action:@selector(comboBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
        [mainview addSubview:combobox];
        count++;
    }
}

-(void)loadFormGlobalsCount:(int) count {
    mainview = [[DrawLines alloc] init];
    innerScrollView = [[UIScrollView alloc] init];
    NSError *error;
    
    NSArray *titles = [self.doc nodesForXPath:@"/_def_ns:XFDL/_def_ns:globalpage/_def_ns:global/_def_ns:printsettings/_def_ns:dialog/_def_ns:orientation" error:&error];
    if ([titles count] > 0)
    {
        GDataXMLElement *orientation = [titles objectAtIndex:0];
        if ([self.form.page_orientation isEqualToString:@"letter"])
        {
            
            NSLog(@"orientation %@", orientation.stringValue);
            if (isiPad())
            {
                mainview.frame = CGRectIntegral(CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height));
            }
            else {
                mainview.frame = CGRectIntegral(CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width *2+50,[UIScreen mainScreen].bounds.size.height*2+50));
            }
            
        }
        else{
            NSLog(@"orientation %@", orientation.stringValue);
            mainview.frame = CGRectIntegral(CGRectMake(0,0,950,900));
            
        }
    }
    else
    {
        
        if (isiPad())
        {
            mainview.frame = CGRectIntegral(CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height));
        }
        else {
            mainview.frame = CGRectIntegral(CGRectMake(0,0,730,998));
        }
    }
    if (isiPhone())
    {
        //innerScrollView.frame = CGRectMake(SCREEN_WIDTH*count, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    else
    {
        innerScrollView.frame = CGRectIntegral(CGRectMake((SCREEN_WIDTH * count),mainview.frame.origin.y, SCREEN_WIDTH, mainview.frame.size.height));
    }
    // NSLog(@"fmainviewframe %@", NSStringFromCGRect(innerScrollView.frame));
    innerScrollView.contentSize = mainview.frame.size;
}

-(void)saveButtonPressed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name your file" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",@"Use Current Filename", nil];
    alert.transform=CGAffineTransformMakeScale(1.0, 0.75);
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 5;
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 5)
    {
        if (buttonIndex == 1)
        {
            UITextField *fileName = [alertView textFieldAtIndex:0];
            if ([fileName.text length] > 0)
                self.saveFileName = [fileName.text stringByAppendingPathExtension:@"xfdl"];
        }
        else if (buttonIndex == 2)
        {
            self.saveFileName = [filepath lastPathComponent];
        }
        if (buttonIndex != 0)
        {
            [self saveFile];
        }
    }
    else if (alertView.tag == 7)
    {
        if (buttonIndex == 0)
        {
            [self sendEmail:self.emailFileName];
        }
    }
    else if (alertView.tag == 9)
    {
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)saveFile  {
    if ([self.saveFileName length] > 0)
    {
        if ([self.formNumber isEqualToString:@"2166-8-1"] || [self.formNumber isEqualToString:@"2166-8"]) {
            NSError *error;
            NSArray *titles = [self.doc nodesForXPath:@"/_def_ns:XFDL/_def_ns:globalpage/_def_ns:global/_def_ns:xmlmodel/_def_ns:instances" error:&error];
            GDataXMLElement *instances = [[[titles objectAtIndex:0] children] objectAtIndex:7];
            NSLog(@"insta%@",instances);
            for (FormModel *form in self.pageArray)
                for (TextViewModel *fieldcheck in form.fields) {
                    for (GDataXMLNode *mains in [[[instances elementsForName:@"MAIN_DATA"] objectAtIndex:0]children])
                        if ([fieldcheck.name isEqualToString:mains.name])
                        {
                            [mains setStringValue:fieldcheck.field.text];
                        }
                }
        }
        NSArray *array = self.pages.pages;
        int i = 0;
        for (GDataXMLElement *element in array) {
            FormModel *currentPage = [self.pageArray objectAtIndex:i];
            for (TextViewModel *fieldcheck in currentPage.fields)
            {
                if (fieldcheck.wasTextModified == false)
                    continue;
                for (GDataXMLElement *f in [element elementsForName:@"field"]) {
                    NSString *temps = [fieldcheck.field text];
                    if ([fieldcheck.name isEqualToString:[f attributeForName:@"sid"].stringValue]) {
                        if ([[f elementsForName:@"value"] objectAtIndex:0] == nil)
                        {
                            GDataXMLElement * textValue = [GDataXMLNode elementWithName:@"value"stringValue:temps];
                            [f addChild:textValue];
                        }
                        else
                        {
                            [f removeChild:[[f elementsForName:@"value" ] objectAtIndex:0]];
                            GDataXMLElement * textValue = [GDataXMLNode elementWithName:@"value" stringValue:temps];
                            [f addChild:textValue];
                        }
                    }
                }
            }
            for (GDataXMLElement *f in [element elementsForName:@"check"]) {
                for (CheckBoxModel *check in currentPage.checkboxes) {
                    NSString *temps;
                    if ([check.checkbox isSelected])
                    {
                        temps = @"on";
                    }
                    else
                    {
                        temps = @"off";
                    }
                    if ([[f elementsForName:@"value"] objectAtIndex:0] == nil)
                    {
                        GDataXMLElement *textValue = [GDataXMLNode elementWithName:@"value"stringValue:temps];
                        [f addChild:textValue];
                    }
                    else
                    {
                        [f removeChild:[[f elementsForName:@"value"] objectAtIndex:0]];
                        GDataXMLElement *textValue = [GDataXMLNode elementWithName:@"value" stringValue:temps];
                        [f addChild:textValue];
                    }
                }
                
            }
            i++;
        }
        NSData *encoded = [self.doc.XMLData gzippedData];
        NSString *zipped = [encoded base64EncodedString];
        NSString *fullfile = [NSString stringWithFormat:@"%@\n%@", self.fileHeader,zipped];
        NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        NSString* documentDirectory = [[documentDirectories objectAtIndex:0] stringByAppendingPathComponent:@"XFDL"];
        NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:self.saveFileName];
        NSError *error;
        if ([fullfile writeToFile:documentDirectoryFilename atomically:YES encoding:NSUTF8StringEncoding error:&error])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Saved Successfully!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong." message:@"Sorry, there was an error saving your file. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot save without filename" message:@"Please choose a filename and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end