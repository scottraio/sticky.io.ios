//
//  AppDelegate.m
//  ViewDeckExample
//

#import "AppDelegate.h"


@implementation AppDelegate 

@synthesize window = _window;
@synthesize loginController = _loginController;
@synthesize centerController = _viewController;
@synthesize leftController = _leftController;
@synthesize imageController = _imageController;
@synthesize currentUser = _currentUser;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    // let AFNetworking manage the activity
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    NSURL *baseURL = [NSURL URLWithString:@"https://sticky.io"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON]; // JSON data
    
    //
    // Grab credentials from keychain
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];

    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    
    [client setAuthorizationHeaderWithUsername:username password:password];
    
    //
    //
    // Init RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    
    //
    // notes mapping
    RKObjectMapping *notesMapping = [RKObjectMapping mappingForClass:[Note class]];
    notesMapping.setDefaultValueForMissingAttributes = YES;
    [notesMapping addAttributeMappingsFromDictionary:@{
     @"_id" : @"_id",
     @"message" : @"message",
     @"plain_txt" : @"plain_txt",
     @"tags" : @"tags",
     @"groups" : @"groups",
     @"links" : @"links",
     @"created_at" : @"created_at",
     @"stacked_at" : @"stacked_at",
     @"deleted_at" : @"deleted_at"
    }];
    
    //
    // user mapping
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    //userMapping.setDefaultValueForMissingAttributes = YES;
    [userMapping addAttributeMappingsFromDictionary:@{
     @"_id" : @"_id",
     @"name" : @"name",
     @"email" : @"email",
     @"phone_number" : @"phone_number",
     @"theme" : @"theme",
     @"tags" : @"tags"
    }];
    
    //
    // tag mapping
    RKObjectMapping *tagMapping = [RKObjectMapping mappingForClass:[Tag class]];
    tagMapping.setDefaultValueForMissingAttributes = YES;
    [tagMapping addAttributeMappingsFromDictionary:@{
     @"_id" : @"name"
    }];


    //
    // notebook mapping
    RKObjectMapping *notebookMapping = [RKObjectMapping mappingForClass:[Notebook class]];
    notebookMapping.setDefaultValueForMissingAttributes = YES;
    [notebookMapping addAttributeMappingsFromDictionary:@{
     @"_id" : @"_id",
     @"name" : @"name",
     @"color" : @"color",
     @"_owner" : @"owner",
     @"_members" : @"members",
     @"created_at" : @"created_at"
    }];

    //[userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"tags" toKeyPath:@"tags" withMapping:tagMapping]];
    //[userMapping addRelationshipMappingWithSourceKeyPath:@"tags" mapping:tagMapping];
    //[userMapping addRelationshipMappingWithSourceKeyPath:@"notebooks" mapping:notebookMapping];
    

    // Update date format so that we can parse Twitter dates properly
    // Wed Sep 29 15:31:08 +0000 2010
    [RKObjectMapping addDefaultDateFormatterForString:@"MMM d y" inTimeZone:nil];
    
    
    //
    // descriptors
    RKResponseDescriptor *notesDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:notesMapping
                                                                                       pathPattern:@"/notes.json"
                                                                                           keyPath:nil
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *expandedDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:notesMapping
                                                                                       pathPattern:@"/notes/:id/expanded.json"
                                                                                           keyPath:nil
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *userDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                       pathPattern:@"/payload.json"
                                                                                           keyPath:@"current_user"
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *tagDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:tagMapping
                                                                                   pathPattern:@"/payload.json"
                                                                                       keyPath:@"tags"
                                                                                   statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *notebookDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:notebookMapping
                                                                                  pathPattern:@"/payload.json"
                                                                                      keyPath:@"notebooks"
                                                                                  statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    //
    // add descriptors to object manager
    [objectManager addResponseDescriptorsFromArray:@[userDescriptor, notesDescriptor, expandedDescriptor, tagDescriptor, notebookDescriptor]];
    
    //
    // Build the view and load IIViewDeck
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.leftController = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    
    self.inboxViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.centerController = [[UINavigationController alloc] initWithRootViewController:self.inboxViewController];
    IIViewDeckController *deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.centerController 
                                                                                    leftViewController:self.leftController
                                                                                   rightViewController:nil];
    
    
    deckController.rightLedge = 100;
    deckController.leftLedge = 100;
    
    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    
    //
    // Load the compose window first. Important!
    [self.inboxViewController showNewNoteForm:nil];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [self.inboxViewController showNewNoteForm:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
