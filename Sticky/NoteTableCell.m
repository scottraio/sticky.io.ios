//
//  NoteTableCell.m
//  Sticky
//
//  Created by Scott Raio on 12/16/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import "Note.h"
#import "NoteTableCell.h"

#import "Slash/Slash/SLSMarkupParser.h"



@implementation NoteTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cornerRadius = 5;
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.numberOfLines = 0;
        
        // http://stackoverflow.com/questions/3248201/why-is-scrolling-performance-poor-for-custom-table-view-cells-having-uisegmented
        // You may also want to set your cells' layers to rasterize themselves, like this:
        // cell.layer.shouldRasterize = YES;
        // cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        // This will collapse your view hierarchy into one flat bitmap, which is the kind of thing Core Animation just loves to draw.
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        self.layer.opaque = YES;
    }
    return self;
}

- (void)prepareCellContentsWithNote:(Note *)note
{
    //
    // Message label
    self.messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(5.0f, 25.0f, 280.0f, 0.0f)];
    self.messageLabel.font = [UIFont systemFontOfSize:14];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.messageLabel.dataDetectorTypes = UIDataDetectorTypeAll;
    
    [self.contentView addSubview:self.messageLabel];
    
    //
    // Date label
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 100.0f, 15.0f)];
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.textColor = [UIColor grayColor];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.dateLabel];
}

-(void)loadNotebookLabels:(NSArray *)notebooks
{

    // Initalise and set the frame of the tag list
    self.tagList = [[DWTagList alloc] initWithFrame:CGRectMake(5.0f, self.messageLabel.frame.size.height+35, 300.0f, 20.0f)];

    [self.tagList setTags:notebooks];

    // Add the taglist to your UIView
    [self.contentView addSubview:self.tagList];

}

-(void)setDateLabelText:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"M/d/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    self.dateLabel.text = dateString;
}

-(void)setMessageLabelText:(NSAttributedString *)message
{

    self.messageLabel.text = message;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

