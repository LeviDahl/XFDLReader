#import "MainTableView.h"
#import "ViewController.h"
#import "AppDelegate.h"
@interface MainTableView ()

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
      return [filelist count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController *viewCon = [self.storyboard instantiateViewControllerWithIdentifier:@"mainview"];
    viewCon.filepath = [filelist objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewCon animated:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([filelist count] > 0)
    {
    cell.textLabel.text = [filelist objectAtIndex:indexPath.row];
    }
    return cell;
}
-(void)setUpTable
{
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
    NSString *docsDirectory = [paths objectAtIndex:0];
    NSString *path = [docsDirectory stringByAppendingPathComponent:@"XFDL"];
    filelist = nil;
    filelist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    [myTableView reloadData];

   
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setUpTable];
     
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
    filelist = [fileManager contentsOfDirectoryAtPath:path error:nil];
   
    [myTableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  //  self.navigationItem.title = @"Loaded Files";
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 //   [self setUpTable];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpTable) name: UIApplicationDidBecomeActiveNotification  object:nil];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteFile:[filelist objectAtIndex:indexPath.row]];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)pushSupport:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.venturacountylife.com/xfdl/"]];
}
-(IBAction)pushAPD:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.apd.army.mil"]];
}
@end
