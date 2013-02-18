#import "MainTableView.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "MainTableViewCell.h"
@interface MainTableView ()
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSString *folderNameNew;
@end

@implementation MainTableView
@synthesize myTableView, paths, filelist, fileURL;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)handleOpenURL:(NSURL *)url {
    fileURL = url;
 
    [self setUpTable];
}
NSArray *filePathsArray;
NSString *documentsDirectory;


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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController *viewCon = [self.storyboard instantiateViewControllerWithIdentifier:@"mainview"];
    viewCon.filepath = [[filelist objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewCon animated:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return [self.sections count];
}
- (CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
	return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

     NSFileManager *fileManager = [NSFileManager defaultManager];
       NSString *docsDirectory = [paths objectAtIndex:0];
    MainTableViewCell *cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([filelist count] > 0)
    {
        NSArray *temp = [filelist objectAtIndex:indexPath.section];
        if ([temp count]> 0)
        {
    cell.fileLabel.text = [[filelist objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            NSString *path = [docsDirectory stringByAppendingPathComponent:[[filelist objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
            NSDictionary *dict = [fileManager attributesOfItemAtPath:path error:NULL];
         
            NSDate *date = [dict fileModificationDate];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            if ([dateFormatter stringFromDate:date] != nil) {
                
            cell.modifiedLabel.text = [NSString stringWithFormat:@"Last Modified: %@",[dateFormatter stringFromDate:date]];
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
-(void)setUpTable
{
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
-(void)deleteFile:(NSString *)filename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docsDirectory = [paths objectAtIndex:0];
    NSString *path = [docsDirectory stringByAppendingPathComponent:@"XFDL"];
    NSString *filepath = [path stringByAppendingPathComponent:filename];
    if ([fileManager fileExistsAtPath:filepath])
    {
    [fileManager removeItemAtPath:filepath error:NULL];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Deleted" message:@"File Successfully Deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Deleted" message:@"File Could not be deleted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
   
    [self setUpTable];
}
-(void)newFolderButtonPressed {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choose your folder name" message:@"Please enter your folder name in the box below." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    alert.tag = AlertNewFolder;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
      [self.myTableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil]  forCellReuseIdentifier:@"MainTableViewCell"];
    self.filelist = [[NSMutableArray alloc]init];
    self.sections = [[NSMutableArray alloc]init];
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpTable) name: UIApplicationDidBecomeActiveNotification  object:nil];
   [self.createNewFolder addTarget:self action:@selector(newFolderButtonPressed) forControlEvents:UIControlEventTouchUpInside];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteFile:[[filelist objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertNewFolder)
    {
        if (buttonIndex == 0)
        {
        UITextField *folderName = [alertView textFieldAtIndex:0];
        self.folderNameNew= folderName.text;
            [self makeNewFolder];
        }
    }
}
@end
