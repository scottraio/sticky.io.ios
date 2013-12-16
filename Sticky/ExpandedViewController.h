//
//  PushedViewController.h
//  ViewDeckExample
//
//  Created by Tom Adriaenssen on 10/05/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//


#import <RestKit/RestKit.h>
#import <UIKit/UIKit.h>
#import <Note.h>

@interface ExpandedViewController : UITableViewController <UINavigationControllerDelegate> {
    NSArray *_notes;
}

@property (nonatomic, retain) Note *parent;


@end
