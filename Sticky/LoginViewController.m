//
//  LoginViewController.m
//  Sticky
//
//  Created by Scott Raio on 12/13/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <QuartzCore/QuartzCore.h>

#import "LoginViewController.h"
#import "KeychainItemWrapper.h"
#import "PrettyKit.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    // Do any additional setup after loading the view from its nib.
    
    //
    // Pretty Navigation Bar
    //[self.navigationController setValue:[[PrettyNavigationBar alloc] init] forKeyPath:@"navigationBar"];
    self.navBar.topLineColor = [UIColor colorWithHex:0x555555];
    self.navBar.bottomLineColor = [UIColor colorWithHex:0x000000];
    self.navBar.gradientEndColor = [UIColor colorWithHex:0x222222];
    self.navBar.gradientStartColor = [UIColor colorWithHex:0x333333];
    self.navBar.shadowOpacity = 0.8f;
    self.navBar.tintColor = self.navBar.gradientEndColor;
    self.navBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sticky-logo-mobile.png"]];
    
    [self.loginBtn useBlueStyle];
    self.loginBtn.cornerRadius = 3.0f;
    self.loginTxt.clipsToBounds = YES;
    self.loginTxt.layer.masksToBounds = YES;
    self.loginTxt.layer.cornerRadius = 3.0f;

    self.passwordTxt.clipsToBounds = YES;
    self.passwordTxt.layer.cornerRadius = 3.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loginUser:(id)sender
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:self.loginTxt.text password:self.passwordTxt.text];
    
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];
    [keychainItem setObject:self.loginTxt.text forKey:(__bridge id)(kSecAttrAccount)];
    [keychainItem setObject:self.passwordTxt.text forKey:(__bridge id)(kSecValueData)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFeed" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPayload" object:nil];
    
    [self dismissModalViewControllerAnimated:YES];
    

}

@end
