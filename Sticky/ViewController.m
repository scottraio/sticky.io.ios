//
//  ViewController.m
//  ViewDeckExample
//

#import "Note.h"

#import "SVPullToRefresh.h"
#import "IIViewDeckController.h"

#import "ViewController.h"
#import "ExpandedViewController.h"
#import "NewNoteViewController.h"
#import "NoteTableCell.h"

// interface and properties

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;


@end

// implementation

@implementation ViewController

@synthesize currentPage;
@synthesize currentTag;
@synthesize currentNotebook;
@synthesize currentKeyword;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    //
    // Notification Center
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forceReload) name:@"refreshFeed" object:nil];
    
    ViewController *this = self;
    
    //
    // Defaults
    self.currentPage = 0;
    self.currentNotebook = nil;
    self.currentTag = nil;
    self.currentKeyword = nil;
    self.isLoading = false;
    self.dataSource = [NSMutableArray array];
    self.title = @"All Notes";
    
    //
    // Pretty Navigation Bar
    [self.navigationController setValue:[[PrettyNavigationBar alloc] init] forKeyPath:@"navigationBar"];
    PrettyNavigationBar *navBar = (PrettyNavigationBar *)self.navigationController.navigationBar;
    
    navBar.topLineColor = [UIColor colorWithHex:0x555555];
    navBar.bottomLineColor = [UIColor colorWithHex:0x000000];
    navBar.gradientEndColor = [UIColor colorWithHex:0x222222];
    navBar.gradientStartColor = [UIColor colorWithHex:0x333333];
    navBar.shadowOpacity = 0.8f;
    navBar.tintColor = navBar.gradientEndColor;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showNewNoteForm:)];
    
    //
    // Pull to refresh and infinate scroll
    [self.tableView addPullToRefreshWithActionHandler:^{
        // prepend data to dataSource, insert cells at top of table view
        
        [self.tableView beginUpdates];
        
        self.currentPage = 0;
        [this loadNotesOnPage:0 withNotebook:self.currentNotebook withTag:self.currentTag withKeyword:self.currentKeyword];
        
        [self.tableView endUpdates];
        
        [self.tableView.pullToRefreshView stopAnimating];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        // append data to data source, insert new cells at the end of table view
        [self.tableView beginUpdates];
        
        if (!self.isLoading) {
            ++self.currentPage;
            [this loadNotesOnPage:self.currentPage withNotebook:self.currentNotebook withTag:self.currentTag withKeyword:self.currentKeyword];
        }
        
        [self.tableView endUpdates];
        
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
    
    [self loadNotesOnPage:0 withNotebook:currentNotebook withTag:currentTag withKeyword:currentKeyword];
    
}

-(void)loadNotesOnPage:(int *)page withNotebook:(NSString *)notebook withTag:(NSString *)tag withKeyword:(NSString *)keyword
{
    self.isLoading = true;
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSString *notebookPath;
    NSString *tagPath;
    NSString *keywordPath;
    NSString *path = [NSString stringWithFormat:@"page=%d", page];
    
    if (notebook != nil) {
        notebookPath = [NSString stringWithFormat:@"&notebooks=%@", notebook];
        path = [path stringByAppendingString:notebookPath];
    } else if (tag != nil) {
        tagPath = [NSString stringWithFormat:@"&tags=%@", tag];
        path = [path stringByAppendingString:tagPath];
    } else if (keyword != nil) {
        keywordPath = [NSString stringWithFormat:@"&keyword=%@", keyword];
        path = [path stringByAppendingString:keywordPath];
    }
    
    NSString *endpoint = [NSString stringWithFormat:@"/notes.json?%@", path];
    
    [objectManager getObjectsAtPath:endpoint parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray* freshNotes = [mappingResult array];
        
        if(self.isViewLoaded) {
            
            if (page == 0) {
                [self.dataSource removeAllObjects];
            }
            
            [self.dataSource addObjectsFromArray:freshNotes];
            
            [self.tableView reloadData];
        }
        
        self.isLoading = false;
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
        if (error.code == -1016){
            //Do whatever here to handle authentication failures
            LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self presentModalViewController:loginController animated:YES];
        }
    }];
}

-(void)forceReload
{
    [self.tableView triggerPullToRefresh];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return YES;
}

- (IBAction)showNewNoteForm:(id)sender
{
    //NewNoteViewController *newNote = [[NewNoteViewController alloc] initWithNibName:@"NewNoteForm" bundle:nil];
    //newNote.modalPresentationStyle =  UIModalTransitionStyleCrossDissolve;
    //[self presentModalViewController:newNote animated:YES];
    
    
    NewNoteViewController *composeViewController = [[NewNoteViewController alloc] init];
    [composeViewController compose];
    [self presentViewController:composeViewController animated:NO completion:nil];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height;
    Note *note = [self.dataSource objectAtIndex:indexPath.row];
    
    NSString *txt = note.stripMessageOfHTML;
    CGSize size = [txt sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300,9000)];
    height = size.height;
    
    //
    // calc height of notebook labels
    if (note.groups.count > 0) {
        // Initalise and set the frame of the tag list
        //DWTagList *tagList = [[DWTagList alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 40.0f)];
        //[tagList setTags:[note notebooks]];
        height += 70;
    } else {
        height += 45;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NoteCell";
    
    NoteTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Note *note = [self.dataSource objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[NoteTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell prepareCellContentsWithNote:note];
    }
    
    cell.messageLabel.text = nil;
    [cell.tagList removeFromSuperview];
    
    [cell setDateLabelText:[note created_at]];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        //
        //
        
        NSArray *notebooks = [note notebooks];
        
        dispatch_async( dispatch_get_main_queue(), ^{            
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
            [cell loadNotebookLabels:notebooks];
        });
    });
    
    CGSize size = [[note stripMessageOfHTML] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300,9000)];
    [cell.messageLabel setFrame:CGRectMake(cell.messageLabel.frame.origin.x, cell.messageLabel.frame.origin.y, cell.messageLabel.frame.size.width, size.height)];
    [cell setMessageLabelText:[note shortenMessageAttrTxt:[note body]]];
    
    [cell prepareForTableView:tableView indexPath:indexPath];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Note *note = [self.dataSource objectAtIndex:indexPath.row];
    
    ExpandedViewController* controller = [[ExpandedViewController alloc] initWithNibName:@"ExpandedViewController" bundle:nil];
    controller.parent = note;
    [self.viewDeckController rightViewPushViewControllerOverCenterController:controller];
}


#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end



