
#import "ViewController.h"
#import "RXMLElement.h"
#import "QuartzCore/QuartzCore.h"
#import "DrawLines.h"
#import "AppDelegate.h"
#import "GDataXMLNode.h"
@interface ViewController ()
@property (nonatomic, strong) IBOutlet UIScrollView *pagingScrollView;
@end
BOOL loaded = NO;
 BOOL nextpagetrue;
@implementation ViewController
@synthesize tempdata, scrollView, mainview, fielddata, toolbar, imagedata, pagesarray, filepath, checkdata, celldata, combodata, pickerview, pickerstring, pickerarray, resourcearray, printController, backgroundColor;
- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    scrollView.delegate = self;
    [scrollView setScrollEnabled:YES];
    [scrollView setFrame:CGRectIntegral(scrollView.frame)];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSData *filedata;
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"XFDL"];
    path = [path stringByAppendingPathComponent:filepath];
    NSLog(@"path %@", path);
    if([fileManager fileExistsAtPath:path])
    {
        filedata  =  [fileManager contentsAtPath:path];
    }
    self.pagingScrollView.pagingEnabled = TRUE;
    
    printController = [UIPrintInteractionController sharedPrintController];
    printController.delegate = self;
    tempdata = [[NSMutableArray alloc] init];
    fielddata = [[NSMutableArray alloc] init];
    imagedata = [[NSMutableArray alloc] init];
    pagesarray = [[NSMutableArray alloc] init];
    pickerarray = [[NSMutableArray alloc] init];
    checkdata = [[NSMutableArray alloc] init];
    celldata = [[NSMutableArray alloc] init];
    combodata = [[NSMutableArray alloc] init];
    resourcearray = [[NSMutableArray alloc] init];
    pickerview = [[UIPickerView alloc] init];
    pickerview.dataSource = self;
    pickerview.delegate = self;
    pickerview.showsSelectionIndicator = YES;
    appDelegate.linedata = [[NSMutableArray alloc] init];
    NSString *myData = [[NSString alloc] initWithData:filedata encoding:NSUTF8StringEncoding];
    NSString *newStr = [myData substringWithRange:NSMakeRange(51, [myData length]-51)];
    NSData *decodedData = [NSData dataWithBase64EncodedString:newStr];
    NSData *test = [decodedData gunzippedData];
   // NSString *rawXML = [[NSString alloc] initWithData:test encoding:NSASCIIStringEncoding];
   // NSLog(@"RAW %@", rawXML);
       UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionPane)];
    self.navigationItem.rightBarButtonItem = doneButton;
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:test
                                                           options:0 error:&error];
    if (doc == nil) {
    }
    NSArray *partyMembers = [doc.rootElement elementsForName:@"page"];
    for (GDataXMLElement *partyMember in partyMembers) {
        GDataXMLElement *label = [[[[partyMember elementsForName:@"global"] objectAtIndex:0]elementsForName:@"label"] objectAtIndex:0];
        NSLog(@"pagename = %@", label.stringValue);
    }
 /*   NSLog(@"%@", doc.rootElement);
    RXMLElement *rootXML = [RXMLElement elementFromXMLData:test];
   if ([rootXML child:@"globalpage.global.formid.title"] != nil)
   {
       self.navigationItem.title = [rootXML child:@"globalpage.global.formid.title"].text;
   }
    
    
    [rootXML iterate:@"*" usingBlock: ^(RXMLElement *pages) {
               NSString *pagenum = [pages attribute:@"sid"];
        if ([pagenum length] >= 6)
            pagenum = [pagenum substringToIndex:6];
        pagenum = [pagenum uppercaseString];
        if ([pagenum isEqualToString:@"AFFORM"])
        {
            pagenum = @"PAGE1";
        }
      //   NSLog(@"pagenum %@", pagenum);
        if ([[[pagenum substringToIndex:4] uppercaseString] isEqualToString:@"PAGE"])
        {
            [pagesarray addObject:pagenum];
        }
         [pagesarray sortUsingSelector:@selector(caseInsensitiveCompare:)];
if ([appDelegate.pagename length]== 0)
{
    appDelegate.pagename = @"PAGE1";
}
        if ([pagenum isEqualToString:appDelegate.pagename])
        {
            if ([rootXML child:@"globalpage.global.date"] == nil)
            {
                NSLog(@"6.5Form");
                if ([[pages child:@"global.vfd_pagesize"].text isEqualToString:@"letter"]) {
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
                }
                NSMutableArray *bgcolor = [[NSMutableArray alloc] init];
                [pages iterate:@"global.bgcolor.*" usingBlock: ^(RXMLElement *colors) {
                    [bgcolor addObject:colors.text];
                }];
                if ([bgcolor count] != 0) {
         mainview.backgroundColor = [UIColor colorWithRed:([[bgcolor objectAtIndex:0] floatValue] /255.0) green:([[bgcolor objectAtIndex:0] floatValue] /255.0)blue:([[bgcolor objectAtIndex:0] floatValue] /255.0) alpha:1];
            scrollView.backgroundColor = mainview.backgroundColor;
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
                               if (decoded != nil)
                {
                [imagedata addObject:decoded];
                }
            }
        }];
                [pages iterate:@"label" usingBlock: ^(RXMLElement *player) {
                    NSString *title = [player attribute:@"sid"];
                    NSMutableArray *test = [[NSMutableArray alloc] init];
                    if ([title length] >= 5)
                        title = [title substringToIndex:5];
                   
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
                                if ([fontElement.text isEqualToString:@"Book Antiqua"])
                                {
                                    [test addObject:@"Arial"];
                                }
                                else
                                {
                                    [test addObject:fontElement.text];
                                }
                            }];
                        }
                        else {
                            [test addObject:@"Arial"];
                            [test addObject:@"8"];
                        }
                        [tempdata addObject:test];
                    
                }];
                for(int i = 0; i < [tempdata count]; i++){
                    if ([[tempdata objectAtIndex:i ]count] > 11) {
                        if ([[[tempdata objectAtIndex:i] objectAtIndex:8] isEqualToString:@"image"])        {
                  //  NSLog(@"This is an image");
                    for(int j = 0; j < [imagedata count]; j++){
                        if ([[imagedata objectAtIndex:j] isKindOfClass:[NSString class]] &&[[imagedata objectAtIndex:j] isEqualToString:[[tempdata objectAtIndex:i] objectAtIndex:9]])
                        {
                            NSData *data = [imagedata objectAtIndex:j+1];
                            
                            UIImage *image = [[UIImage alloc] initWithData:data];
                            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                            imageView.frame = CGRectIntegral(CGRectMake(roundf([[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:4] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:5] floatValue]/4 *3)));
                         //   NSLog(@"image frame %@",NSStringFromCGRect(imageView.frame));
                            [mainview addSubview:imageView];
                        }
                    }
                }
                        else{
                    UILabel *label = [[UILabel alloc] init];
                    label.backgroundColor = [UIColor clearColor];
                    label.frame =  CGRectIntegral(CGRectMake(roundf([[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:4] floatValue]/4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:5] floatValue]/4 *3)));
                            if ([[[tempdata objectAtIndex:i] objectAtIndex:10] isEqualToString:@"Arial Narrow"])
                            {
                            label.font = [UIFont fontWithName:@"Arial" size:[[[tempdata objectAtIndex:i] objectAtIndex:11] floatValue]];
                            }
                            else{
                                 label.font = [UIFont fontWithName:[[tempdata objectAtIndex:i] objectAtIndex:10] size:[[[tempdata objectAtIndex:i] objectAtIndex:11] floatValue]];
                            }
                    label.text = [[tempdata objectAtIndex:i] objectAtIndex:6];
                    label.numberOfLines = 0;
                        if ([[tempdata objectAtIndex:i] count] > 7)
                        {
                        if ([[[tempdata objectAtIndex:i] objectAtIndex:7] isEqualToString:@"center"])
                        {label.textAlignment = UITextAlignmentCenter;
                        }
                        }
                    [mainview addSubview:label];
                    
                }
                    }
                    else
                    {
                        if ([[[tempdata objectAtIndex:i] objectAtIndex:5] isEqualToString:@"image"])        {
                       // NSLog(@"This is an image");
                        for(int j = 0; j < [imagedata count]; j++){
                            if ([[imagedata objectAtIndex:j] isKindOfClass:[NSString class]] &&[[imagedata objectAtIndex:j] isEqualToString:[[tempdata objectAtIndex:i] objectAtIndex:6]])
                            {
                                NSData *data = [imagedata objectAtIndex:j+1];
                                UIImage *image = [[UIImage alloc] initWithData:data];
                                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                imageView.frame = CGRectIntegral(CGRectMake(roundf([[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3), roundf([[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3), image.size.width, image.size.height));
                              //  NSLog(@"image frame %@",NSStringFromCGRect(imageView.frame));
                                [mainview addSubview:imageView];
                            }
                        }
                    }
                else{
                UILabel *label = [[UILabel alloc] init];
                label.backgroundColor = [UIColor clearColor];
                if ([[[tempdata objectAtIndex:i] objectAtIndex:7] isEqualToString:@"Arial Narrow"])
                {
                      label.font = [UIFont fontWithName:@"Arial" size:[[[tempdata objectAtIndex:i] objectAtIndex:8] floatValue]];
                }
                    else
                    {
                    label.font = [UIFont fontWithName:[[tempdata objectAtIndex:i] objectAtIndex:7] size:[[[tempdata objectAtIndex:i] objectAtIndex:8] floatValue]];
                    }
                    label.numberOfLines = 0;
                    CGSize size = [[[tempdata objectAtIndex:i] objectAtIndex:3] sizeWithFont:label.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                    label.frame =   CGRectIntegral(CGRectMake([[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3, [[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3, size.width, size.height));
                      label.text = [[tempdata objectAtIndex:i] objectAtIndex:3];
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
                    if (![[field attribute:@"sid" ] isEqualToString:@"SUBMISSION_TITLE_DISPLAY"] && ![[field attribute:@"sid" ] isEqualToString:@"REAS"] && ![[field attribute:@"sid" ] isEqualToString:@"SSN_PRINT"] && ![[field attribute:@"sid" ] isEqualToString:@"RATER_SSN_PRINT"] && ![[field attribute:@"sid" ] isEqualToString:@"REVIEWER_SSN_PRINT"] && ![[field attribute:@"sid" ] isEqualToString:@"SENIOR_RATER_SSN_PRINT"] && ![[field attribute:@"sid"] isEqualToString:@"VE_COMMENT1"] && ![[field attribute:@"sid"] isEqualToString:@"TF_NOTOT"] &&    ![[field attribute:@"sid"] isEqualToString:@"TG_GOTOT"] && ![[field attribute:@"sid"] isEqualToString:@"TF_GOTOT"] && ![[field attribute:@"sid"] isEqualToString:@"TG_NOTOT"])
                    {
                    [field iterate:@"itemlocation.ae" usingBlock:^(RXMLElement *repElement) {
                    [repElement iterate:@"ae" usingBlock:^(RXMLElement *xy) {
                    NSString *temp = xy.text;
                        if ([temp length] != 0)
                        {
                    [test addObject:temp];
                        }
                        else
                            NSLog(@"String length 0");
                        }];
                    }];
                    if ([field child:@"justify"] != nil) {
                        [test addObject:[field child:@"justify"].text];
                    }
                    else
                    {
                        [test addObject:@"left"];
                    }
                        if ([field child:@"value"] != nil) {
                    if (![[field child:@"value"].text isEqualToString:@""]) {
                        [test addObject:[field child:@"value"].text];
                    }
                    else {
                    [test addObject:@""];
                    }
                        }
                    else {
                        [test addObject:@""];
                    }
                        
                    if ([field child:@"size"] != nil)
                    {
                         [test addObject:@"size"];
                        [field iterate:@"size.*" usingBlock:^(RXMLElement *sizeElement) {
                            if (sizeElement.text != nil)
                            {
                            [test addObject:sizeElement.text];
                            }
                        }];
                    }
                    if ([field child:@"fontinfo"] != nil)
                    {
                        [field iterate:@"fontinfo.ae" usingBlock:^(RXMLElement *fontElement) {
                            if (fontElement.text != nil)
                            {
                            [test addObject:fontElement.text];
                            }
                        }];
                    }
                    else
                    {
                        [test addObject:@"Arial"];
                        [test addObject:@"8"];
                    }
                    [fielddata addObject:test];
                    }
                }];
                for(int i = 0; i < [fielddata count]; i++){
                    UITextView *text = [[UITextView alloc] init];

                    [text setScrollEnabled:NO];
                    text.contentInset = UIEdgeInsetsMake(-6,-6,-6,-6);
                    text.tag = i;
                    text.delegate = self;
                    //text.returnKeyType = UIReturnKeyDefault;
            if ([[[fielddata objectAtIndex:i] objectAtIndex:3] isEqualToString:@"extent"]){
                if ([[[fielddata objectAtIndex:i] objectAtIndex:8] isEqualToString:@"size"])
                {
                text.frame =  CGRectIntegral(CGRectMake([[[fielddata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3-1, [[[fielddata objectAtIndex:i] objectAtIndex:4] floatValue]/4 *3-2, [[[fielddata objectAtIndex:i] objectAtIndex:5] floatValue]/4 *3-2));
                
                
                text.font = [UIFont fontWithName:[[fielddata objectAtIndex:i] objectAtIndex:11] size:[[[fielddata objectAtIndex:i] objectAtIndex:12] floatValue]];
                    
                if ([[[fielddata objectAtIndex:i] objectAtIndex:4] isEqualToString:@"center"]) {
                    text.textAlignment = UITextAlignmentCenter;
                    }
                text.text = [[fielddata objectAtIndex:i] objectAtIndex:7];
                    if ([text hasText])
                    {
                        text.layer.borderWidth = 0.0f;
                        text.backgroundColor = [UIColor clearColor];
                    }
                    else
                    {
                         text.layer.borderWidth = 1.0f;
                    }
                }
                else
                {
                text.frame =  CGRectIntegral(CGRectMake([[[fielddata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3-1, [[[fielddata objectAtIndex:i] objectAtIndex:4] floatValue]/4 *3-2, [[[fielddata objectAtIndex:i] objectAtIndex:5] floatValue]/4 *3-2));
                    
                    text.font = [UIFont fontWithName:[[fielddata objectAtIndex:i] objectAtIndex:8] size:[[[fielddata objectAtIndex:i] objectAtIndex:9] floatValue]];
                    if ([[[fielddata objectAtIndex:i] objectAtIndex:4] isEqualToString:@"center"]) {
                        text.textAlignment = UITextAlignmentCenter;
                    }
                    text.text = [[fielddata objectAtIndex:i] objectAtIndex:7];
                    if ([text hasText])
                    {
                        text.layer.borderWidth = 0.0f;
                        text.backgroundColor = [UIColor clearColor];
                    }
                    else
                    {
                        text.layer.borderWidth = 1.0f;
                    }
                }
              

            }
            else{
                
                if ([text hasText])
                {
                    text.layer.borderWidth = 0.0f;
                    text.backgroundColor = [UIColor clearColor];
                }
                else
                {
                    text.layer.borderWidth = 1.0f;
                }
                text.font = [UIFont fontWithName:[[fielddata objectAtIndex:i] objectAtIndex:8] size:[[[fielddata objectAtIndex:i] objectAtIndex:9] floatValue]];
                CGSize size = [@"A" sizeWithFont:text.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                text.frame =   CGRectIntegral(CGRectMake([[[fielddata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3-1,([[[fielddata objectAtIndex:i] objectAtIndex:6] floatValue] / 1.1) * size.width, size.height * ([[[fielddata objectAtIndex:i] objectAtIndex:7] floatValue]*1.1)));
                if ([[[fielddata objectAtIndex:i] objectAtIndex:3] isEqualToString:@"center"]) {
                    text.textAlignment = UITextAlignmentCenter;
                }
                 text.text = [[fielddata objectAtIndex:i] objectAtIndex:4];
                
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
                [pages iterate:@"check" usingBlock: ^(RXMLElement *checks) {
            NSMutableArray *tester = [[NSMutableArray alloc] init];
            [checks iterate:@"itemlocation.ae" usingBlock:^(RXMLElement *repElements) {
                [repElements iterate:@"ae" usingBlock:^(RXMLElement *xyz) {
                    NSString *temp = xyz.text;
                    [tester addObject:temp];
                }];
                
            }];
            [tester addObject:[checks child:@"value"].text];
            [checkdata addObject:tester];
        }];
                for(int i = 0; i < [checkdata count]; i++){
            if ([[[checkdata objectAtIndex:i] objectAtIndex:3] isEqualToString:@"extent"])
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = arc4random();
            button.frame = CGRectIntegral(CGRectMake([[[checkdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3, [[[checkdata objectAtIndex:i] objectAtIndex:2] floatValue] /4 *3-1, [[[checkdata objectAtIndex:i] objectAtIndex:4] floatValue]/4 *3-1, [[[checkdata objectAtIndex:i] objectAtIndex:5] floatValue] /4 *3-2));
               // NSLog(@"button frame %@", NSStringFromCGRect( button.frame));
                button.backgroundColor = [UIColor whiteColor];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal | UIControlStateSelected];
                button.layer.borderWidth = 1.0f;
                [button addTarget:self action:@selector(checkBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
              
                if ([[[checkdata objectAtIndex:i] objectAtIndex:6] isEqualToString:@"off"])
                {
                    [button setSelected:NO];
                }
                else {
                    [button setSelected:YES];
                }
                 [button setTitle:@"" forState:UIControlStateNormal];
                [button setTitle:@"X" forState:UIControlStateSelected];
               
                  [mainview addSubview:button];
            }
            
        }
                [pages iterate:@"cell" usingBlock: ^(RXMLElement *cells) {
                NSMutableArray *tester = [[NSMutableArray alloc] init];
                [cells iterate:@"group" usingBlock:^(RXMLElement *repElements) {
                [tester addObject:repElements.text];
                if ([cells child:@"label"] != nil)
                {
                    [tester addObject:[cells child:@"label"].text];
                }
                [tester addObject:[cells child:@"value"].text];  
            }];
                [celldata addObject:tester];
        }];
                [pages iterate:@"combobox" usingBlock: ^(RXMLElement *combos) {
                NSMutableArray *tester = [[NSMutableArray alloc] init];
                    if (![[combos attribute:@"sid"] isEqualToString:@"SUBMISSION_TITLE"])
                    {
                [combos iterate:@"itemlocation.ae" usingBlock:^(RXMLElement *repElements) {
                [repElements iterate:@"ae" usingBlock:^(RXMLElement *xyz) {
                    NSString *temp = xyz.text;
                    [tester addObject:temp];
                }];
                
            }];
            if ([combos child:@"group"] != nil)
            {
                NSString *group;
                if ([[[combos child:@"group"].text substringToIndex:4] isEqualToString:@"PAGE"])
                {
                    group = [[combos child:@"group"].text substringFromIndex:6];
                }
                else{
                    group = [combos child:@"group"].text;
                    }
              
            [tester addObject:group];
            
            }
                    }
            [combodata addObject:tester];
        }];
                for(int i = 0; i < [combodata count]; i++){
                    if ([[combodata objectAtIndex:i] count] > 6)
                    {
                    if (![[[combodata objectAtIndex:i] objectAtIndex:6] isEqualToString:@"bc__GROUP"] && ![[[combodata objectAtIndex:i] objectAtIndex:6] isEqualToString:@"bestIn_GROUP"])
                    {
            if ([[[combodata objectAtIndex:i] objectAtIndex:3] isEqualToString:@"extent"])
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.titleLabel.font = [UIFont fontWithName:@"Arial" size:10];
                button.tag = i;
                button.backgroundColor = [UIColor whiteColor];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button.layer.borderWidth = 1.0f;
                button.frame = CGRectIntegral(CGRectMake([[[combodata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3, [[[combodata objectAtIndex:i] objectAtIndex:2] floatValue] /4 *3-1, [[[combodata objectAtIndex:i] objectAtIndex:4] floatValue]/4 *3-1, [[[combodata objectAtIndex:i] objectAtIndex:5] floatValue] /4 *3-2));
               // NSLog(@"button frame %@", NSStringFromCGRect( button.frame));
                [button addTarget:self action:@selector(comboBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [button setTitle:@"Select" forState:UIControlStateNormal];                
                [mainview addSubview:button];
            }
                    }
                    }
        }
            }
            else
            {
                NSLog(@"7.7Form");
                    if ([[rootXML child:@"globalpage.global.printsettings.dialog.orientation"].text isEqualToString:@"portrait"])
                    {
                        mainview.frame = CGRectIntegral(CGRectMake(0,0,730,958));
                    }
                    else if ([[rootXML child:@"globalpage.global.printsettings.dialog.orientation"].text isEqualToString:@"landscape"])
                    {
                         mainview.frame = CGRectIntegral(CGRectMake(0,0,1008,730));
                      
                                         }
                    else
                    {
                         mainview.frame = CGRectIntegral(CGRectMake(0,0,730,958));
                       
                    }
                    NSArray *bgcolor = [[pages child:@"global.bgcolor"].text componentsSeparatedByString:@","];
                    mainview.backgroundColor = [UIColor colorWithRed:([[bgcolor objectAtIndex:0] floatValue] /255.0) green:([[bgcolor objectAtIndex:0] floatValue] /255.0)blue:([[bgcolor objectAtIndex:0] floatValue] /255.0) alpha:1];
                    scrollView.backgroundColor = mainview.backgroundColor;
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
                           if (decoded != nil)
                           {
                               [imagedata addObject:decoded];
                           }
                       }
    }];
                   [pages iterate:@"label" usingBlock: ^(RXMLElement *player) {
                       NSString *title = [player attribute:@"sid"];
                       NSMutableArray *test = [[NSMutableArray alloc] init];
                       if ([title length] >= 5)
                           title = [title substringToIndex:5];
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
                [test addObject:[player child:@"fontinfo.fontname"].text];
                [test addObject:[player child:@"fontinfo.size"].text];
                if ([player child:@"fontinfo.effect"] != nil)
                {
                    [test addObject:[player child:@"fontinfo.effect"].text];
                }
                else{
                     [test addObject:@"plain"];
                }
                
            }
            else{
                [test addObject:@"Arial"];
                [test addObject:@"8"];
                [test addObject:@"plain"];
            }
            
            [tempdata addObject:test];
        }];
                    for(int i = 0; i < [tempdata count]; i++){
                        if (![[[tempdata objectAtIndex:i] objectAtIndex:0] isEqualToString:@"TOOLBAR"]&&![[[[tempdata objectAtIndex:i] objectAtIndex:0] substringToIndex:1] isEqualToString:@"S"])
                        {
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
                            if ([[tempdata objectAtIndex:i] count] > 11)
                            {
                                label.font = [UIFont fontWithName:[[tempdata objectAtIndex:i] objectAtIndex:8] size:[[[tempdata objectAtIndex:i] objectAtIndex:9] floatValue]];
                                CGSize size = [[[tempdata objectAtIndex:i] objectAtIndex:4] sizeWithFont:label.font constrainedToSize:CGSizeMake([[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue] /4*3 ,[[[tempdata objectAtIndex:i] objectAtIndex:3] floatValue] /4*3) lineBreakMode:NSLineBreakByWordWrapping];
                             //   NSLog(@"Label Size %@", NSStringFromCGSize(size));
                                label.frame =  CGRectIntegral(CGRectMake([[[tempdata objectAtIndex:i] objectAtIndex:0] floatValue] /4 *3, [[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue]/4 *3, size.width, size.height));
                                label.text = [[tempdata objectAtIndex:i] objectAtIndex:4];
                            }
                            else if ([[tempdata objectAtIndex:i] count] > 9 && [[tempdata objectAtIndex:i] count] <= 11)
                            {
                                if ([[[tempdata objectAtIndex:i] objectAtIndex:5] isEqualToString:@"text"]) {
                                    label.font = [UIFont fontWithName:[[tempdata objectAtIndex:i] objectAtIndex:7] size:[[[tempdata objectAtIndex:i] objectAtIndex:8] floatValue]];
                                    CGSize size = [[[tempdata objectAtIndex:i] objectAtIndex:3] sizeWithFont:label.font constrainedToSize:CGSizeMake([[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue] /4*3, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                                    label.frame =   CGRectIntegral(CGRectMake([[[tempdata objectAtIndex:i] objectAtIndex:0] floatValue] /4 *3, [[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue]/4 *3, size.width, size.height));
                                    label.text = [[tempdata objectAtIndex:i] objectAtIndex:3];
                                //    NSLog(@"Label Frame %@", NSStringFromCGRect(label.frame));
                                }
                                else{
                                    label.font = [UIFont fontWithName:[[tempdata objectAtIndex:i] objectAtIndex:8] size:[[[tempdata objectAtIndex:i] objectAtIndex:9] floatValue]];
                                    CGSize size = [[[tempdata objectAtIndex:i] objectAtIndex:4] sizeWithFont:label.font constrainedToSize:CGSizeMake([[[tempdata objectAtIndex:i] objectAtIndex:2] floatValue]/4*3,[[[tempdata objectAtIndex:i] objectAtIndex:3]floatValue]/4*3) lineBreakMode:NSLineBreakByWordWrapping];
                                    label.frame =   CGRectIntegral(CGRectMake([[[tempdata objectAtIndex:i] objectAtIndex:0] floatValue] /4 *3, [[[tempdata objectAtIndex:i] objectAtIndex:1] floatValue]/4 *3, size.width, size.height));
                                    label.text = [[tempdata objectAtIndex:i] objectAtIndex:4];
                               //     NSLog(@"Got Here");
                                }
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
                    }
                    [pages iterate:@"field" usingBlock: ^(RXMLElement *field) {
                            NSMutableArray *test = [[NSMutableArray alloc] init];
                            [test addObject:[field child:@"itemlocation.x"].text];
                            [test addObject:[field child:@"itemlocation.y"].text];
                        if ([field child:@"itemlocation.width"] != nil)
                        {
                            [test addObject:[field child:@"itemlocation.width"].text];
                        }
                        if ([field child:@"itemlocation.width"] != nil && [field child:@"itemlocation.height"] == nil && [field child:@"size.height"] == nil)
                        {
                            [test addObject:@"No Height"];
                        }
                        if ([field child:@"itemlocation.height"] != nil)
                        {
                            [test addObject:[field child:@"itemlocation.height"].text];
                        }
                        if ([field child:@"size.height"] != nil && [field child:@"itemlocation.height"] == nil) {
                            [test addObject:[field child:@"size.height"].text];
                            [test addObject:@"height"];
                        }
                        if ([field child:@"justify"] != nil) {
                            [test addObject:[field child:@"justify"].text];
                        }
                        else
                        {
                            [test addObject:@"left"];
                        }
                        if (![[field child:@"value"].text isEqualToString:@""] && [field child:@"value"] != nil) {
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
                        else {
                            [test addObject:@"Arial"];
                            [test addObject:@"8"];
                            [test addObject:@"plain"];
                        }
                        [fielddata addObject:test];         
                    }];
                    for(int i = 0; i < [fielddata count]; i++){
                        UITextView *text = [[UITextView alloc] init];
                        text.scrollEnabled = NO;
                        text.layer.borderWidth = 1.0f;
                        text.delegate = self;
                       if ([[[fielddata objectAtIndex:i] objectAtIndex:4] isEqualToString:@"height"])
                       {
                        text.font = [UIFont fontWithName:[[fielddata objectAtIndex:i] objectAtIndex:7] size:[[[fielddata objectAtIndex:i] objectAtIndex:8] floatValue]];
                            CGSize size = [@"A" sizeWithFont:text.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                            text.frame =  CGRectIntegral(CGRectMake([[[fielddata objectAtIndex:i] objectAtIndex:0] floatValue] /4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:1] floatValue]/4 *3,  ([[[fielddata objectAtIndex:i] objectAtIndex:2] floatValue]/4*3), size.height * [[[fielddata objectAtIndex:i] objectAtIndex:3] floatValue] *1.1));
                            if ([[[fielddata objectAtIndex:i] objectAtIndex:5] isEqualToString:@"center"]) {
                                text.textAlignment = UITextAlignmentCenter;
                            }
                            text.text = [[fielddata objectAtIndex:i] objectAtIndex:6];
                            if ([text hasText])
                            {
                                text.layer.borderWidth = 0.0f;
                                text.backgroundColor = [UIColor clearColor];
                            }
                            else
                            {
                                text.layer.borderWidth = 1.0f;
                            }
                       }
                       else{
                           if ([[[fielddata objectAtIndex:i] objectAtIndex:3] isEqualToString:@"No Height"])
                           {
                               text.font = [UIFont fontWithName:[[fielddata objectAtIndex:i] objectAtIndex:6] size:[[[fielddata objectAtIndex:i] objectAtIndex:7] floatValue]];
                               CGSize size = [@"A" sizeWithFont:text.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                               text.frame =  CGRectIntegral(CGRectMake([[[fielddata objectAtIndex:i] objectAtIndex:0] floatValue] /4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:1] floatValue]/4 *3-2,  [[[fielddata objectAtIndex:i] objectAtIndex:2] floatValue]/4*3, size.height));
                               NSLog(@"field frame %@", NSStringFromCGRect(text.frame));
                               if ([[[fielddata objectAtIndex:i] objectAtIndex:4] isEqualToString:@"center"]) {
                                   text.textAlignment = UITextAlignmentCenter;
                               }
                               text.text = [[fielddata objectAtIndex:i] objectAtIndex:5];
                               if ([text hasText])
                               {
                                   text.layer.borderWidth = 0.0f;
                                   text.backgroundColor = [UIColor clearColor];
                               }
                               else
                               {
                                   text.layer.borderWidth = 1.0f;
                               }
                           }
                           else
                           {
                           text.font = [UIFont fontWithName:[[fielddata objectAtIndex:i] objectAtIndex:6] size:[[[fielddata objectAtIndex:i] objectAtIndex:7] floatValue]];
                           text.frame =  CGRectIntegral(CGRectMake([[[fielddata objectAtIndex:i] objectAtIndex:0] floatValue] /4 *3, [[[fielddata objectAtIndex:i] objectAtIndex:1] floatValue]/4 *3-2,  [[[fielddata objectAtIndex:i] objectAtIndex:2] floatValue]/4*3, [[[fielddata objectAtIndex:i] objectAtIndex:3] floatValue]/4*3));
                           NSLog(@"field frame %@", NSStringFromCGRect(text.frame));
                           if ([[[fielddata objectAtIndex:i] objectAtIndex:4] isEqualToString:@"center"]) {
                               text.textAlignment = UITextAlignmentCenter;
                           }
                           text.text = [[fielddata objectAtIndex:i] objectAtIndex:5];
                           if ([text hasText])
                           {
                               text.layer.borderWidth = 0.0f;
                               text.backgroundColor = [UIColor clearColor];
                           }
                           else
                           {
                               text.layer.borderWidth = 1.0f;
                           }
                           }
                       }
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
                    [pages iterate:@"check" usingBlock: ^(RXMLElement *checks) {
                        NSMutableArray *tester = [[NSMutableArray alloc] init];
                        [checks iterate:@"itemlocation.*" usingBlock:^(RXMLElement *repElements) {
                        if (![repElements.tag isEqualToString:@"offsetx"] && ![repElements.tag isEqualToString:@"offsety"] && ![repElements.tag isEqualToString:@"alignl2l"])
                        {
                        NSString *temp = repElements.text;
                        
                            [tester addObject:temp];
                        }
                        }];
                        if ([checks child:@"value"] != nil && ![[checks child:@"value"].text isEqualToString:@""])
                        {
                            
                         [tester addObject:[checks child:@"value"].text];
                            
                        }
                    if ([checks child:@"fontinfo"] != nil)
                    {
                        [checks iterate:@"fontinfo.*" usingBlock:^(RXMLElement *fontElements) {
                            NSString *temp = fontElements.text;
                            [tester addObject:temp];
                        }];
                    }
                   
                    [checkdata addObject:tester];
                }];
                    for(int i = 0; i < [checkdata count]; i++){
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.tag = arc4random();
                        if ([[checkdata objectAtIndex:i] count] > 9)
                        {
                        button.frame = CGRectIntegral(CGRectMake([[[checkdata objectAtIndex:i] objectAtIndex:0] floatValue] /4 *3, [[[checkdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3, [[[checkdata objectAtIndex:i] objectAtIndex:2] floatValue]/4 *3, [[[checkdata objectAtIndex:i] objectAtIndex:3] floatValue] /4 *3));
                            if ([[[checkdata objectAtIndex:i] objectAtIndex:4] isEqualToString:@"off"])
                            {
                                [button setSelected:NO];
                            }
                            else {
                                [button setSelected:YES];
                            }
                        }
                        else
                        {
                            if ([[checkdata objectAtIndex:i] count] > 4) {
                            button.titleLabel.font = [UIFont fontWithName:[[checkdata objectAtIndex:i] objectAtIndex:3] size:[[[checkdata objectAtIndex:i] objectAtIndex:4] floatValue]];
                                if ([[[checkdata objectAtIndex:i] objectAtIndex:2] isEqualToString:@"off"])
                                {
                                    [button setSelected:NO];
                                }
                                else {
                                    [button setSelected:YES];
                                }
                            }
                            else
                            {
                                [button setSelected:NO];
                                 button.titleLabel.font = [UIFont fontWithName:@"Arial" size:8];
                            }
                            CGSize size = [@"A" sizeWithFont:button.titleLabel.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                             button.frame = CGRectIntegral(CGRectMake([[[checkdata objectAtIndex:i] objectAtIndex:0] floatValue]/4*3, ([[[checkdata objectAtIndex:i] objectAtIndex:1] floatValue] /4 *3),size.width+8, size.height));
                        }
                        NSLog(@"button frame %@", NSStringFromCGRect( button.frame));
                        button.backgroundColor = [UIColor whiteColor];
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal | UIControlStateSelected];
                        button.layer.borderWidth = 1.0f;
                        [button addTarget:self action:@selector(checkBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
                        [button setTitle:@"" forState:UIControlStateNormal];
                        [button setTitle:@"X" forState:UIControlStateSelected];
                        [mainview addSubview:button];
                    }
                }
            NSLog(@"field data = %@", fielddata);
            NSLog(@"lines%@", appDelegate.linedata);
            NSLog(@"labels%@", tempdata);
            NSLog(@"checkboxes %@", checkdata);
            NSLog(@"cells %@", celldata);
            NSLog(@"combobox %@", combodata);
            scrollView.contentSize = CGSizeMake(mainview.frame.size.width, mainview.frame.size.height);
            
        }
        if ([[pages attribute:@"sid"] isEqualToString:@"RESOURCE_PAGE"])
        {
            [pages iterate:@"cell" usingBlock: ^(RXMLElement *cells) {
                NSMutableArray *test = [[NSMutableArray alloc] init];
                [test addObject:[cells child:@"group"].text];
                if ([cells child:@"label"] != nil)
                {
                    [test addObject:[cells child:@"label"].text];
                }
                if ([cells child:@"value"] != nil)
                {
                    [test addObject:[cells child:@"value"].text];
                }
                [resourcearray addObject:test];
            }];
            NSLog(@"Resource Page %@", resourcearray);
        }
        }];
    [self centerScrollViewContents];*/
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
}
- (void)keyboardWillShow {
    NSString *deviceType = [UIDevice currentDevice].model;
    UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
    if ([deviceType isEqualToString:@"iPhone"] && (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
       
    }
    else if ([deviceType isEqualToString:@"iPhone"] && (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationPortrait))
    {
        toolbar.frame = CGRectMake(scrollView.contentOffset.x, 156.0, scrollView.frame.size.width, 44.0);
    }
    else if (([deviceType isEqualToString:@"iPad"] || [deviceType isEqualToString:@"iPad Simulator"]) && (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationPortrait))
    {
        toolbar.frame = CGRectMake(0.0, 652.0, scrollView.frame.size.width, 44.0);
    }
    else if (([deviceType isEqualToString:@"iPad"] || [deviceType isEqualToString:@"iPad Simulator"])&& (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        toolbar.frame = CGRectMake(0, 310.0, scrollView.frame.size.width, 44.0);
    }
    [scrollView setScrollEnabled:NO];
    svos = scrollView.contentOffset;
   
    [scrollView addSubview:toolbar];
}
- (void)keyboardWillHide {
    [toolbar removeFromSuperview];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentOffset:svos animated:YES];
}
- (void)cancelAction {
    [self.view endEditing:TRUE];
    [toolbar removeFromSuperview];
    [scrollView setScrollEnabled:YES];
    mainview.userInteractionEnabled = TRUE;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
if([textView hasText])
{
    textView.layer.borderWidth = 0.0f;
    textView.backgroundColor = [UIColor clearColor];
    
}
    }
-(void)textViewDidBeginEditing:(UITextView *)textView{
 //   [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
   
  
         
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [scrollView setScrollEnabled:NO];
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [scrollView setContentOffset:pt animated:YES];
    // mainview.userInteractionEnabled = FALSE;
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame =  toolbar.frame = CGRectMake(0,0,scrollView.frame.size.width, 44.0);
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
    UIView *newView = [UIView new];
    [newView addSubview:toolbar];
    newView.frame = CGRectMake(0,0,scrollView.frame.size.width, 44.0);
    [textView setInputAccessoryView:newView];
    mainview.userInteractionEnabled = NO;
    return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
   pickerview.frame = CGRectMake(0, scrollView.frame.size.height-200, scrollView.frame.size.width, 180.0f);
    [self centerScrollViewContents];
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
    return self.mainview;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat scalewidth =  scrollView.frame.size.width /scrollView.contentSize.width;
    CGFloat scaleheight =  scrollView.frame.size.height /scrollView.contentSize.height;
    CGFloat minScale = MIN(scalewidth, scaleheight);
    scrollView.minimumZoomScale = minScale;
    scrollView.maximumZoomScale = 2.0f;
    scrollView.zoomScale = minScale;
  //[self centerScrollViewContents];
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

   
     nextpagetrue = NO;
    for (int i = 0; i < [pagesarray count]; i++)
    {
          
        NSLog(@"pagenamer %@", appDelegate.pagename);
  NSLog(@"arraypager %@", pagesarray);
        if ([[pagesarray objectAtIndex:i] isEqualToString:appDelegate.pagename] && [pagesarray objectAtIndex:i] != [pagesarray lastObject])
        {
             appDelegate.pagename = [pagesarray objectAtIndex:(i +1)];
            NSLog(@"arraypage %@", pagesarray);
            NSLog(@"arraypage2 %@", appDelegate.pagename);
            NSLog(@"pagename %@", appDelegate.pagename);
            ViewController *viewCon = [self.storyboard instantiateViewControllerWithIdentifier:@"mainview"];
            viewCon.filepath = filepath;
            [self.navigationController pushViewController:viewCon animated:YES];
            break;
        }
        else
        {
            
        }
}
    if (nextpagetrue)
    {
     
          
       
    }
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
    [scrollView setContentOffset:svos animated:YES];
    
    return YES; // We do not want UITextField to insert line-breaks.
}
-(void)viewWillDisappear:(BOOL)animated {
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([self isMovingFromParentViewController] )
    {
        for (int i = 0; i < [pagesarray count]; i++)
        {
            
            NSLog(@"pagenamer %@", appDelegate.pagename);
            NSLog(@"arraypager %@", pagesarray);
            if ([[pagesarray objectAtIndex:i] isEqualToString:appDelegate.pagename] && [pagesarray objectAtIndex:i] <0)
            {
                appDelegate.pagename = [pagesarray objectAtIndex:(i-1)];
            }
        }
        /*
        NSLog(@"not called here");
        NSString *tempstring = [appDelegate.pagename substringFromIndex:4];
        if ([tempstring intValue] > 1){
        int i = [tempstring intValue] - 1;
        NSLog(@"tempstring %@", tempstring);
        appDelegate.pagename = [NSString stringWithFormat:@"%@%d", [appDelegate.pagename substringToIndex:4], i];
        }*/
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerarray count]-2;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[pickerarray objectAtIndex:row] objectAtIndex:1];
        
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"You selected this: ");
    [pickerview removeFromSuperview];
    pickerstring = [NSString stringWithFormat:@"%d",row];
    UIButton *button = (UIButton*)[mainview viewWithTag:[[pickerarray lastObject] intValue]];
    if ([[pickerarray objectAtIndex:row] count] > 2)
    {
    [button setTitle:[[pickerarray objectAtIndex:row] objectAtIndex:2] forState:UIControlStateNormal];
    }
    else{
        [button setTitle:[[pickerarray objectAtIndex:row] objectAtIndex:1] forState:UIControlStateNormal];

    }
        button.tag = [[pickerarray objectAtIndex:[pickerarray count]-2] intValue];
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderWidth = 0.0f;
    mainview.userInteractionEnabled = YES;
}
-(void)saveToDocumentsWithFileName:(NSString*)aFilename {
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    backgroundColor = mainview.backgroundColor;
    mainview.backgroundColor = [UIColor whiteColor];
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
       // Points the pdf converter to the mutable data object and to the UIView to be converted
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(mainview.bounds.origin.x, mainview.bounds.origin.y, mainview.bounds.size.width, mainview.bounds.size.height), nil);
                CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [mainview.layer renderInContext:pdfContext];
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
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *tempstring = [appDelegate.pagename substringFromIndex:4];
    if ([tempstring intValue] != [pagesarray count])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Form Options"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Next Page", @"Email to PDF", @"Print", nil];
        [actionSheet showInView:scrollView];
        loaded = YES;
    }
    else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Form Options"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Email to PDF", @"Print", nil];
        [actionSheet showInView:scrollView];
        loaded = NO;
    }
  
       
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
 AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (loaded == YES)
    {
    switch (buttonIndex) {
        case 0:
            [self nextpage];
            break;
        case 1: [self saveToDocumentsWithFileName:[NSString stringWithFormat:@"%@-%@.pdf",filepath, appDelegate.pagename]];
            break;
        case 2: [self printButton];
            break;
        default:
            break;
    }
    }
        else
        {
            switch (buttonIndex) {
                case 0:
                    [self saveToDocumentsWithFileName:[NSString stringWithFormat:@"%@-%@.pdf",filepath, appDelegate.pagename]];
                    break;
                case 1:
                    [self printButton];
                    break;
                case 2: 
                    break;
                default:
                    break;
            }
        }
    }
-(void)printButton{
    NSMutableData *pdfData = [NSMutableData data];
    mainview.backgroundColor = [UIColor whiteColor];
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    // Points the pdf converter to the mutable data object and to the UIView to be converted
     UIGraphicsBeginPDFPageWithInfo(CGRectMake(mainview.bounds.origin.x, mainview.bounds.origin.y, mainview.bounds.size.width, mainview.bounds.size.height), nil);
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [mainview.layer renderInContext:pdfContext];
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
            mainview.backgroundColor = backgroundColor;
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
    
}
@end
