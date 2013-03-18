//
//  MainTableView.h
//  XFDLReader
//
//  Created by LeviMac on 11/13/12.
//  Copyright (c) 2012 LeviMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
@interface MainTableView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, ReaderViewControllerDelegate>
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *createNewFolder;
@property (nonatomic, retain) NSArray *paths;
@property (nonatomic, retain) NSMutableArray *filelist;
@property (nonatomic, retain) NSURL *fileURL;
- (void)handleOpenURL:(NSURL *)url;
typedef enum {
    AlertDeleteFolder,
    AlertNewFolder,
    AlertRenameFile
}AlertChoices;
@end 
 
/*
 if ([bgcolor count] != 0) {
 mainview.backgroundColor = [UIColor colorWithRed:([[bgcolor objectAtIndex:0] floatValue] /255.0) green:([[bgcolor objectAtIndex:0] floatValue] /255.0)blue:([[bgcolor objectAtIndex:0] floatValue] /255.0) alpha:1];
 scrollView.backgroundColor = mainview.backgroundColor;
 }*/
/*[pages iterate:@"label" usingBlock: ^(RXMLElement *player) {
 NSString *title = [player attribute:@"sid"];
 NSMutableArray *test = [[NSMutableArray alloc] init];
 if ([title length] >= 5)
 title = [title substringToIndex:5];

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
 }];*/
 /*[pages iterate:@"label" usingBlock: ^(RXMLElement *player) {
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