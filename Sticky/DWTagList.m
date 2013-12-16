//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import "Notebook.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 5.0f
#define LABEL_MARGIN 5.0f
#define BOTTOM_MARGIN 5.0f
#define FONT_SIZE 11.0f
#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING 3.0f
#define BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.8]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor clearColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 0.0f)
#define BORDER_COLOR [UIColor clearColor].CGColor
#define BORDER_WIDTH 1.0f
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface DWTagList()

- (void)touchedTag:(id)sender;

@end

@implementation DWTagList

@synthesize view, textArray;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        [self addSubview:view];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        self.notebooks = [prefs arrayForKey:@"notebooks"];
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)setLabelBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
    [self display];
}

- (void)touchedTag:(id)sender{
    
    UITapGestureRecognizer *t = (UITapGestureRecognizer*)sender;
    UILabel *label = (UILabel*)t.view;
    
    if(label && self.delegate && [self.delegate respondsToSelector:@selector(selectedTag:)])
        [self.delegate selectedTag:label.text];
    
}

- (void)display
{
    for (UILabel *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (NSString *text in textArray) {
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:CGSizeMake(self.frame.size.width, 1500) lineBreakMode:UILineBreakModeWordWrap];
        textSize.width += HORIZONTAL_PADDING*2;
        textSize.height += VERTICAL_PADDING*2;
        UILabel *label = nil;
        if (!gotPreviousFrame) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
            totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > self.frame.size.width) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
            newRect.size = textSize;
            label = [[UILabel alloc] initWithFrame:newRect];
        }
        previousFrame = label.frame;
        gotPreviousFrame = YES;
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];

        lblTextColor = [UIColor whiteColor];
        
        for (NSDictionary *notebook in self.notebooks) {
            NSString *color = [notebook objectForKey:@"color"];
            NSString *name = [NSString stringWithFormat:@"@%@",[notebook objectForKey:@"name"]];
            
            
            if ([name isEqualToString:text]) {
                if ([color isEqualToString:@"green"]) {
                    lblBackgroundColor = UIColorFromRGB(0x46a546);
                } else if ([color isEqualToString:@"blue"]) {
                    lblBackgroundColor = UIColorFromRGB(0x3887B5);
                } else if ([color isEqualToString:@"yellow"]) {
                    lblBackgroundColor = UIColorFromRGB(0xffc40d);
                } else if ([color isEqualToString:@"orange"]) {
                    lblBackgroundColor = UIColorFromRGB(0xF78E55);
                } else if ([color isEqualToString:@"red"]) {
                    lblBackgroundColor = UIColorFromRGB(0x9d261d);
                } else if ([color isEqualToString:@"green-light"]) {
                    lblBackgroundColor = UIColorFromRGB(0x54ED6A);
                } else if ([color isEqualToString:@"orange-light"]) {
                    lblBackgroundColor = UIColorFromRGB(0xFFA100);
                } else if ([color isEqualToString:@"blue-light"]) {
                    lblBackgroundColor = UIColorFromRGB(0x6B77F7);
                } else if ([color isEqualToString:@"yellow-light"]) {
                    lblBackgroundColor = UIColorFromRGB(0xF7D96B);
                } else if ([color isEqualToString:@"red-light"]) {
                    lblBackgroundColor = UIColorFromRGB(0xE06359);
                }
            }
        }
        
        //if (!lblBackgroundColor) {
        //    [label setBackgroundColor:BACKGROUND_COLOR];
        //} else {
        //    [label setBackgroundColor:lblBackgroundColor];
        //}
        
        [label setBackgroundColor:lblBackgroundColor];
        [label setTextColor:lblTextColor];
        
        [label setText:text];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setShadowColor:TEXT_SHADOW_COLOR];
        [label setShadowOffset:TEXT_SHADOW_OFFSET];
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:CORNER_RADIUS];
        [label.layer setBorderColor:BORDER_COLOR];
        [label.layer setBorderWidth: BORDER_WIDTH];
        
        //Davide Cenzi, added gesture recognizer to label
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedTag:)];
        // if labelView is not set userInteractionEnabled, you must do so
        [label setUserInteractionEnabled:YES];
        [label addGestureRecognizer:gesture];
        
        [self addSubview:label];
    }
    sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 1.0f);
}

- (CGSize)fittedSize
{
    return sizeFit;
}

@end