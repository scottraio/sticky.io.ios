//
//  LeftViewController.m
//  ViewDeckExample
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "IIViewDeckController.h"

#import "User.h"
#import "Note.h"
#import "Tag.h"
#import "Notebook.h"

#import "LeftViewController.h"
#import "SettingsViewController.h"
#import "ViewController.h"
#import "LoginViewController.h"


@interface LeftViewController () <IIViewDeckControllerDelegate>

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *notebooks;

@end

@implementation LeftViewController

@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width-100, self.view.frame.size.height);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //
    // Notification Center
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPayload) name:@"refreshPayload" object:nil];
    
    self.tags = [NSMutableArray array];
    self.notebooks = [NSMutableArray array];
    
    //
    // set navigation bar
    self.searchBar.backgroundImage = [UIImage imageNamed:@"navbar-bg.png"];
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)];
    
    [self loadPayload];
}

-(void)loadPayload
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObjectsAtPath:@"/payload.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        if(self.isViewLoaded) {
            NSArray *payload = [mappingResult array];
            
            for (NSObject *item in payload) {
                if([item isKindOfClass:[Tag class]]) {
                    [self.tags addObject:item];
                }
                if([item isKindOfClass:[Notebook class]]) {
                    [self.notebooks addObject:item];
                }
            }
            
            [User addNotebooks:self.notebooks andTagsToUserDefauls:self.tags];
            
            
            
            [self.tableView reloadData];
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%d", error.code);
        if (error.code == -1016){
            //Do whatever here to handle authentication failures
            LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self presentModalViewController:loginController animated:YES];
        }
    }];
}

-(IBAction)loadSettingsController:(id)sender
{
    SettingsViewController *settingsController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self presentModalViewController:settingsController animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Keyboard

- (void)viewDeckControllerDidCloseLeftView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)viewDeckControllerWillCloseLeftView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section){
        case 0:
            return 40.0;
            break;
        case 1:
            return 40.0;
            break;
        default:
            return 55.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 20.0)];
    
    // create the button object
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor colorWithHex:0x222222];
    customView.backgroundColor = [UIColor blackColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithHex:0x666666];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:12];
    headerLabel.frame = CGRectMake(5.0, 0, 300.0, 20.0);
    
    // If you want to align the header text as centered
    // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
    
    if(section == 0) {
        headerLabel.text = @"NOTEBOOKS";
    } else if(section == 1) {
        headerLabel.text = @"TAGS";
    }
    
    [customView addSubview:headerLabel];
    
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section){
        case 0:
            return [self.notebooks count];
            break;
        case 1:
            return [self.tags count];
            break;
        default:
            return 1;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier;
    
    if (indexPath.row == 0) {
        cellIdentifier = @"NotebookCell";
    } else if (indexPath.section == 1) {
        cellIdentifier = @"TagCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    switch(indexPath.section) {
        case 0: {
            Notebook *notebook = [self.notebooks objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"@%@", notebook.name];
            break;
        }
        case 1: {
            Tag *tag = [self.tags objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"#%@", tag.name];
            break;
        }
    }

    tableView.rowHeight = 100;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:13];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav-cell.png"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
            ViewController* cc = (ViewController*)((UINavigationController*)controller.centerController).topViewController;
            cc.navigationItem.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            if ([cc respondsToSelector:@selector(tableView)]) {
                [cc.tableView deselectRowAtIndexPath:[cc.tableView indexPathForSelectedRow] animated:NO];
            }
            
            switch(indexPath.section) {
                case 0: {
                    NSString *notebook = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
                    [cc loadNotesOnPage:0 withNotebook:[notebook substringFromIndex:1] withTag:nil withKeyword:nil];
                    break;
                }
                case 1: {
                    NSString *tag = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
                    [cc loadNotesOnPage:0 withNotebook:nil withTag:[tag substringFromIndex:1] withKeyword:nil];
                    break;
                }
            }   
        }
    }];
}


@end
