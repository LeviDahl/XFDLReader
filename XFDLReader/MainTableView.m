#import "MainTableView.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "MainTableViewCell.h"
#import "TutorialViewController.h"
@interface MainTableView ()
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSString *folderNameNew;
@property (nonatomic, weak) IBOutlet UIButton *editSections;
@property (nonatomic, weak) IBOutlet UIButton *deleteFolder;
@property (nonatomic, weak) IBOutlet UIButton *renameFile;
@property (nonatomic, strong) NSString *mainFilename;
@property (nonatomic, strong) NSIndexPath *mainIndexPath;
@end

@implementation MainTableView
@synthesize myTableView, paths, filelist, fileURL;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSError *error;
   NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *oldPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[self.sections objectAtIndex:sourceIndexPath.section]stringByAppendingPathComponent:[[filelist objectAtIndex:sourceIndexPath.section] objectAtIndex:sourceIndexPath.row]]];
     NSString *newPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[self.sections objectAtIndex:destinationIndexPath.section]stringByAppendingPathComponent:[[filelist objectAtIndex:sourceIndexPath.section] objectAtIndex:sourceIndexPath.row]]];
    [fileManager moveItemAtPath:oldPath toPath:newPath error:&error];
    NSLog(@"oldPath %@ newpath %@", oldPath, newPath);
    [self setUpTable];
    [self.myTableView reloadData];
}
- (void)handleOpenURL:(NSURL *)url {
    fileURL = url;
 
    [self setUpTable];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   if ([filelist count] > 0)
   {
    NSArray *temp = [filelist objectAtIndex:section];
    if ([temp count] > 0)
    {
        return [temp count];
    }
    else
    {
        return 0;
    }
   }
    else
    {
        return 0;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sectionString = [self.sections objectAtIndex:indexPath.section];
    NSString *string = [sectionString stringByAppendingPathComponent:[[filelist objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    NSLog(@"extension %@",string);
    if ([[string pathExtension] isEqualToString:@"pdf"])
    {
        [self PDFView:string];
    }
    else
    {
    ViewController *viewCon = [self.storyboard instantiateViewControllerWithIdentifier:@"mainview"];
    viewCon.filepath = [[paths objectAtIndex:0] stringByAppendingPathComponent:string];
    [self.navigationController pushViewController:viewCon animated:YES];
    }
    
}
-(void)PDFView:(NSString *)filepath {
    NSString *docsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [docsDirectory stringByAppendingPathComponent:filepath];
    NSLog(@"fullpath: %@",fullPath);
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:fullPath password:nil];
    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
    readerViewController.delegate = self;
    readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:readerViewController animated:YES];
}
- (void)dismissReaderViewController:(ReaderViewController *)viewController{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)editMainFile:(id) sender {
    UITableViewCell *owningCell = (UITableViewCell*)[sender superview];
       	//From the cell get its index path.
	NSIndexPath *pathToCell = [myTableView indexPathForCell:owningCell];
    self.mainIndexPath = pathToCell;
    NSLog(@"Section:%d, Row:%d", pathToCell.section, pathToCell.row);
    [self.myTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    // Return the number of sections.
    return [self.sections count];
}
- (CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    
	return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSFileManager *fileManager = [NSFileManager defaultManager];
       NSString *docsDirectory = [paths objectAtIndex:0];
    MainTableViewCell *cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([filelist count] > 0)
    {
        NSArray *temp = [filelist objectAtIndex:indexPath.section];
        if ([temp count]> 0)
        {
    cell.fileLabel.text = [[filelist objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            NSString *path = [[docsDirectory stringByAppendingPathComponent:[self.sections objectAtIndex:indexPath.section]]stringByAppendingPathComponent:[[filelist objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            NSLog(@"path %@",path);
            NSDictionary *dict = [fileManager attributesOfItemAtPath:path error:NULL];
         
            NSDate *date = [dict objectForKey:NSFileModificationDate];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            if ([dateFormatter stringFromDate:date] != nil) {
                [cell.selectedButton addTarget:self
                                               action:@selector(editMainFile:)
                                     forControlEvents:UIControlEventTouchUpInside];
               if (indexPath.section == self.mainIndexPath.section && indexPath.row == self.mainIndexPath.row && self.mainIndexPath != nil)
               {
                     [cell.selectedButton setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
                   [cell setSelected:YES];
               }
                else
                {
                [cell.selectedButton setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
                    [cell setSelected:NO];
                }
            cell.modifiedLabel.text = [NSString stringWithFormat:@"Last Modified: %@",[dateFormatter stringFromDate:date]];
                   [cell.modifiedLabel sizeToFit];
            }
            else
            {
                 cell.modifiedLabel.text = @"No modification date";
             
            }
            
            NSLog(@"date %@", [dateFormatter stringFromDate:date]);
        }
    }
    return cell;
}
-(void)setUpTable{
    [filelist removeAllObjects];
      if (fileURL != nil)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [docsDirectory stringByAppendingPathComponent:@"XFDL"];
        path = [path stringByAppendingPathComponent:[fileURL lastPathComponent]];
        if(![fileManager fileExistsAtPath:path])
        {
            NSData *data = [NSData dataWithContentsOfURL:fileURL];
            [data writeToFile:path atomically:YES];
        }
    }
    [self directoryList];
    NSString *docsDirectory = [paths objectAtIndex:0];
         for (NSString *section in self.sections) {
    NSString *fullPath = [docsDirectory stringByAppendingPathComponent:section];
        NSArray *temp = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPath error:nil];
        [filelist addObject:temp];
 
    }
    [self.myTableView reloadData];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sections objectAtIndex:section];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setUpTable];
     
}
-(void)directoryList {
    BOOL isDir;
    [self.sections removeAllObjects];
    NSString *docsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *tester = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docsDirectory error:nil];
    for (NSString *filepaths in tester) {
        NSString *fullpath = [docsDirectory stringByAppendingPathComponent:filepaths];
        if ([fileManager fileExistsAtPath:fullpath isDirectory:&isDir] && isDir) {
            // NSArray *subpaths = [fileManager subpathsAtPath:docsDirectory];
            NSLog(@"subpaths %@", filepaths);
            if (![filepaths isEqualToString:@"Inbox"]) {
                [self.sections addObject:filepaths];
            }
        }
        else
        {
            NSLog(@"not directories %@", filepaths);
        }
    }
    [self.myTableView reloadData];
}
-(void)deleteFile:(NSString *)filename{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filename])
    {
    [fileManager removeItemAtPath:filename error:NULL];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Deleted" message:@"File Successfully Deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 23;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Deleted" message:@"File Could not be deleted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 23;

        [alert show];
    }
   
    [self setUpTable];
}
-(void)renameFile:(NSString *)filename{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *oldPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[self.sections objectAtIndex:self.mainIndexPath.section]];
    NSString *extension = [[oldPath stringByAppendingPathComponent:[[filelist objectAtIndex:self.mainIndexPath.section] objectAtIndex:self.mainIndexPath.row]] pathExtension];
    NSLog(@"extension %@",extension);
    if( [fileManager moveItemAtPath:[oldPath stringByAppendingPathComponent:[[filelist objectAtIndex:self.mainIndexPath.section] objectAtIndex:self.mainIndexPath.row]] toPath:[[oldPath stringByAppendingPathComponent:filename] stringByAppendingPathExtension:extension ] error:nil])
   {UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Renamed Successfully!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
       alert.tag = 13415;
                          [alert show];
                          }
                          else
                          {
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not rename file." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                              alert.tag = 12345;
                              [alert show];
                                 }
    [self setUpTable];
}
-(void)deleteFolder:(NSString *)filename{
     NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docs = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
    NSLog(@"docs%@",docs);
    if ([fileManager fileExistsAtPath:docs])
    {
        [fileManager removeItemAtPath:docs error:NULL];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Folder Deleted" message:@"Folder Successfully Deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 23;

        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Deleted" message:[NSString stringWithFormat:@"Folder %@ could not be deleted.", docs] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 23;
        [alert show];
    }
    
    [self setUpTable];
}
/*
- (void)moveFile:(NSString *)oldPath newFile:(NSString *)newFile {
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSLog(@"oldPath %@ newpath %@", oldPath, newFile);
    [self setUpTable];
    [self.myTableView reloadData];
}*/
-(void)deleteFolderButtonPressed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter the folder name to be deleted" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    alert.tag = AlertDeleteFolder;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}
-(void)newFolderButtonPressed {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choose your folder name" message:@"Please enter your folder name in the box below." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    alert.tag = AlertNewFolder;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
   
}
-(void)renameFileButtonPressed {
 if (self.mainIndexPath != nil)
 {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter the new file name" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    alert.tag = AlertRenameFile;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
 }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select a file." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag =9876;
        [alert show];

    }
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"tutorial"]isEqualToString:@"watchedTutorial"]) {
        TutorialViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorial"];
        [self presentViewController:vc animated:NO completion:nil];
    }
    self.title = @"XFDL Reader";
      [self.myTableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil]  forCellReuseIdentifier:@"MainTableViewCell"];
    self.filelist = [[NSMutableArray alloc]init];
    self.sections = [[NSMutableArray alloc]init];
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpTable) name: UIApplicationDidBecomeActiveNotification  object:nil];
   [self.createNewFolder addTarget:self action:@selector(newFolderButtonPressed) forControlEvents:UIControlEventTouchUpInside];
     [self.editSections addTarget:self action:@selector(beginEditing) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteFolder addTarget:self action:@selector(deleteFolderButtonPressed) forControlEvents:UIControlEventTouchUpInside];
      [self.renameFile addTarget:self action:@selector(renameFileButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}
-(void)beginEditing {
    if (![self.myTableView isEditing])
    {
    [self.myTableView setEditing: YES animated: YES];
        
    }
    else
    {
         [self.myTableView setEditing: NO animated: YES];
    }
}
-(void)makeNewFolder {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docsDirectory = [paths objectAtIndex:0];
    NSString *myNewDir = [docsDirectory stringByAppendingPathComponent:self.folderNameNew];
    if (![self.folderNameNew isEqualToString:@""]) {
    if ([fileManager createDirectoryAtPath:myNewDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not create directory." message:@"Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
NSLog(@"couldn't create directory");
    }
    }
else
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not create empty directory." message:@"Please choose a folder name and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [alert show];
}
     [self setUpTable];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
          [self deleteFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:[[self.sections objectAtIndex:indexPath.section]stringByAppendingPathComponent:[[filelist objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]]]];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertNewFolder)
    {
        if (buttonIndex == 0)
        {
        UITextField *folderName = [alertView textFieldAtIndex:0];
        self.folderNameNew= folderName.text;
            [self makeNewFolder];
        }
    }
    if (alertView.tag == AlertDeleteFolder)
    {
        if (buttonIndex == 0)
        {
            UITextField *folderName = [alertView textFieldAtIndex:0];
            [self deleteFolder:folderName.text];
        }
    }
    if (alertView.tag == AlertRenameFile)
    {
        if (buttonIndex == 0)
        {
            UITextField *folderName = [alertView textFieldAtIndex:0];
            [self renameFile:folderName.text];
        }
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSUInteger)supportedInterfaceOrientations{
        return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate{
    return NO;
}
@end
