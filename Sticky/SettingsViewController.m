//
//  SettingsViewController.m
//  Sticky
//
//  Created by Scott Raio on 12/20/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    
    //
    // Pretty Navigation Bar
    //[self.navigationController setValue:[[PrettyNavigationBar alloc] init] forKeyPath:@"navigationBar"];
    self.navBar.topLineColor = [UIColor colorWithHex:0x555555];
    self.navBar.bottomLineColor = [UIColor colorWithHex:0x000000];
    self.navBar.gradientEndColor = [UIColor colorWithHex:0x222222];
    self.navBar.gradientStartColor = [UIColor colorWithHex:0x333333];
    self.navBar.shadowOpacity = 0.8f;
    self.navBar.tintColor = self.navBar.gradientEndColor;
}

-(IBAction)dismissModal:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
