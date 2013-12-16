//
//  SettingsViewController.h
//  Sticky
//
//  Created by Scott Raio on 12/20/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrettyKit.h"

@interface SettingsViewController : UIViewController

@property (nonatomic, retain) IBOutlet PrettyNavigationBar *navBar;

-(IBAction)dismissModal:(id)sender;

@end
