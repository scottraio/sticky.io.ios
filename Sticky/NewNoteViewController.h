//
//  NewNoteViewController.h
//  Sticky
//
//  Created by Scott Raio on 12/21/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import "PrettyKit.h"
#import "REComposeViewController.h"
#import <RestKit/RestKit.h>

@interface NewNoteViewController :  REComposeViewController

@property (nonatomic, retain) IBOutlet PrettyNavigationBar *navBar;

-(void)compose;

@end
