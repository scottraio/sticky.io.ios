//
//  User.m
//  Sticky
//
//  Created by Scott Raio on 12/17/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import "User.h"
#import "Notebook.h"
#import "Tag.h"

@implementation User

+(void)addNotebooks:(NSArray *)notebooks andTagsToUserDefauls:(NSArray *)tags
{
    //[[NSUserDefaults standardUserDefaults] setObject:tags forKey:@"tags"];
    //[[NSUserDefaults standardUserDefaults] setObject:notebooks forKey:@"notebooks"];
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSMutableArray *notebooks = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"notebooks"]];

    NSMutableArray *notebooksTempArray = [[NSMutableArray alloc] init];
    for(Notebook *notebook in notebooks) {
        NSDictionary *notebookDict = @{
            @"name" : notebook.name,
            @"color" : notebook.color
        };
        
        [notebooksTempArray addObject:notebookDict];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:notebooksTempArray forKey:@"notebooks"];
}


@end
