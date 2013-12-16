//
//  LeftViewController.h
//  ViewDeckExample
//

#import <RestKit/RestKit.h>
#import <UIKit/UIKit.h>
#import "PrettyKit.h"

@interface LeftViewController : UIViewController <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView  *tableView;
@property (nonatomic, retain) IBOutlet PrettyNavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

-(IBAction)loadSettingsController:(id)sender;

@end
