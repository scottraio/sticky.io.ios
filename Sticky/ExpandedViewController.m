//
//  PushedViewController.m
//  ViewDeckExample
//
//  Created by Tom Adriaenssen on 10/05/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import "Note.h"
#import "PrettyKit.h"
#import "ExpandedViewController.h"

@interface ExpandedViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ExpandedViewController

@synthesize parent;

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
    if(self.parent) {
        [self loadNotes:self.parent];
    }
}

- (void)loadNotes:(Note *)parent
{

    NSString *url = [NSString stringWithFormat:@"/notes/%@/expanded.json", parent._id];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:url
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray* notes = [mappingResult array];
                                NSLog(@"Loaded notes: %@", notes);
                                _notes = notes;
                                if(self.isViewLoaded) {
                                    [self.tableView reloadData];
                                }
                            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                            }]; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [[[_notes objectAtIndex:indexPath.row] message] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300,9000)];
    return size.height + 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Note Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
    }
    
    [cell prepareForTableView:self.tableView indexPath:indexPath];
    
    Note *note = [_notes objectAtIndex:indexPath.row];
    cell.textLabel.text = [note message];
    
    return cell;
}

#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end

