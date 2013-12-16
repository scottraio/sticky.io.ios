//
//  Notebook.h
//  Sticky
//
//  Created by Scott Raio on 12/17/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notebook : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSArray *members;
@property (nonatomic, copy) NSDate *created_at;


@end
