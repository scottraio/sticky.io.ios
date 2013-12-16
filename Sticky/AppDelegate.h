//
//  AppDelegate.h
//  ViewDeckExample
//

#import <UIKit/UIKit.h>

#import <RestKit/RestKit.h>
#import "IIViewDeckController.h"
#import "KeychainItemWrapper.h"

#import "Note.h"
#import "User.h"
#import "Tag.h"
#import "Notebook.h"

#import "ViewController.h"
#import "LoginViewController.h"
#import "LeftViewController.h"
#import "NewNoteViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
}

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) UIViewController *loginController;
@property (retain, nonatomic) UIViewController *centerController;
@property (retain, nonatomic) ViewController *inboxViewController;
@property (retain, nonatomic) UIViewController *leftController;
@property (retain, nonatomic) UIViewController *imageController;
@property (retain, nonatomic) User *currentUser;


@end
