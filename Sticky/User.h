//
//  User.h
//  Sticky
//
//  Created by Scott Raio on 12/17/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *theme;
@property (nonatomic, copy) NSString *phone_number;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSArray *notebooks;

+(void)addNotebooks:(NSArray *)notebooks andTagsToUserDefauls:(NSArray *)tags;

@end
