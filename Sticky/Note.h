//
//  Note.h
//  Sticky
//
//  Created by Scott Raio on 12/14/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *plain_txt;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSArray *groups;
@property (nonatomic, copy) NSArray *links;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) NSDate *stacked_at;
@property (nonatomic, strong) NSDate *deleted_at;

-(NSMutableArray *)notebooks;
-(NSString *)prepMessage;
-(NSString *)stripMessageOfHTML;
-(NSString *)shortenMessageTxt:(NSString *)txt;
-(NSMutableAttributedString *)shortenMessageAttrTxt:(NSAttributedString *)txt;
-(NSAttributedString *)body;


@end
