//
//  LoginViewController.h
//  Sticky
//
//  Created by Scott Raio on 12/13/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrettyKit.h"
#import "GradientButton.h"

@interface LoginViewController : UIViewController

@property (nonatomic, retain) IBOutlet PrettyNavigationBar *navBar;
@property (nonatomic, retain) IBOutlet GradientButton *loginBtn;
@property (nonatomic, retain) IBOutlet UITextField *loginTxt;
@property (nonatomic, retain) IBOutlet UITextField *passwordTxt;

-(IBAction)loginUser:(id)sender;

@end
