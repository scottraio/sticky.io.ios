//
//  NewNoteViewController.m
//  Sticky
//
//  Created by Scott Raio on 12/21/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import "Note.h"
#import "NewNoteViewController.h"

@interface NewNoteViewController ()

@end

@implementation NewNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    //self.navigationBar.backgroundColor = [UIColor colorWithHex:0x73a9ff];
    self.navigationBar.topLineColor = [UIColor colorWithHex:0x9cc2fc];
    self.navigationBar.bottomLineColor = [UIColor colorWithHex:0x5c9bf9];
    self.navigationBar.gradientEndColor = [UIColor colorWithHex:0x73a9ff];
    self.navigationBar.gradientStartColor = [UIColor colorWithHex:0x73a9ff];
    self.navigationBar.shadowOpacity = 0.8f;
    self.navigationBar.tintColor = self.navigationBar.gradientEndColor;
    
}

-(void)compose
{
    self.title = @"What's up?";
    self.hasAttachment = NO;
    // composeViewController.attachmentImage = [UIImage imageNamed:@"Flower.jpg"];
    
    self.text = @"";
    
    self.completionHandler = ^(REComposeResult result) {
        //if (result == REComposeResultCancelled) {
        //    NSLog(@"Cancelled");
        //}
        
        if (result == REComposeResultPosted) {
            [self postNewNote:self.text];
        }
    };

}

-(void)postNewNote:(NSString *)message
{
    Note *note = [[Note alloc] init];
    note.message = message;
    
    NSDictionary *params = @{@"message" : message};
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager postObject:note path:@"/notes.json" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //
        // refresh the feed after we create a new note
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFeed" object:nil];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //failed
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
