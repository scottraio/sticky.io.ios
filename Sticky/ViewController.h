//
//  ViewController.h
//  ViewDeckExample
//


#import <RestKit/RestKit.h>
#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController <UINavigationControllerDelegate>

@property (nonatomic) int currentPage;
@property (nonatomic) bool isLoading;
@property (nonatomic, retain) NSString *currentNotebook;
@property (nonatomic, retain) NSString *currentTag;
@property (nonatomic, retain) NSString *currentKeyword;

- (IBAction)showNewNoteForm:(id)sender;
- (void)loadNotesOnPage:(NSInteger *)page withNotebook:(NSString *)notebook withTag:(NSString *)tag withKeyword:(NSString *)keyword;

@end
