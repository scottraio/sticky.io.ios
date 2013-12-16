//
//  NoteTableCell.h
//  Sticky
//
//  Created by Scott Raio on 12/16/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrettyKit.h"
#import "TTTAttributedLabel.h"
#import "DWTagList.h"

@interface NoteTableCell : PrettyTableViewCell

@property (nonatomic, retain) TTTAttributedLabel *messageLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) DWTagList *tagList;
-(void)prepareCellContentsWithNote:(Note *)note;
-(void)loadNotebookLabels:(NSArray *)notebooks;
-(void)setDateLabelText:(NSDate *)date;
-(void)setMessageLabelText:(NSAttributedString *)message;

@end
