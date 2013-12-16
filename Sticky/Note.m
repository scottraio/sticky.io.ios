//
//  Note.m
//  Sticky
//
//  Created by Scott Raio on 12/14/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import "Note.h"
#import "Slash/Slash/SLSMarkupParser.h"

@implementation Note

@synthesize message;

-(NSMutableArray *)notebooks
{
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    for(NSString *group in self.groups) {
        NSString *name = [NSString stringWithFormat:@"@%@", group];
        
        if (![groups containsObject:name]) {
            [groups addObject:name];
        }
    
    }
    
    return groups;
}

-(NSString *)prepMessage
{
    NSString *txt = self.message;
        
    NSRegularExpression *notebookRegex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //
    // trim, remove notebooks, and perform misc other cleanup
    txt = [notebookRegex stringByReplacingMatchesInString:txt options:0 range:NSMakeRange(0, [txt length]) withTemplate:@""];
    txt = [txt stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    return txt;
}

-(NSString *)stripMessageOfHTML
{
    // grab the prepped message with notebooks and whitespace removed
    NSString *txt = self.prepMessage;
    
    //
    // Remove html from string in order to get the actual height
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"<.*?>"
                                                                        options:0
                                                                          error:NULL];
    //
    // calc height of messsage text with @notebooks and html removed
    NSMutableString *mutableTxt = [NSMutableString stringWithString:txt];
    txt = [re stringByReplacingMatchesInString:mutableTxt options:0 range:NSMakeRange(0, txt.length) withTemplate:@""];
    
    return [self shortenMessageTxt:txt];

}

-(NSString *)shortenMessageTxt:(NSString *)txt
{
    //
    // grab the first 255 chars
    if (txt.length < 255) {
        return txt;
    } else {
        txt = [txt substringWithRange:NSMakeRange(0, 255)];
        return [txt stringByAppendingString:@"..."];
    }
}

-(NSMutableAttributedString *)shortenMessageAttrTxt:(NSAttributedString *)txt
{
    
    NSMutableAttributedString *mutxt = [[NSMutableAttributedString alloc] initWithAttributedString:txt];
    NSAttributedString *ellipsis = [[NSAttributedString alloc] initWithString:@"..."];
    
    //
    // grab the first 255 chars
    if (mutxt.length < 255) {
        return mutxt;
    } else {
        mutxt = [mutxt attributedSubstringFromRange:NSMakeRange(0, 255)];
        [mutxt appendAttributedString:ellipsis];
        return mutxt;
    }
}

-(NSAttributedString *)body
{
    //
    // grab the prepped message with notebooks and whitespace removed
    NSString *txt =  self.prepMessage;
    
    //
    // convert <br> to ascii
    txt = [txt stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    txt = [txt stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    
    // set the dictionary for every tag
    int defaultFontSize = 14;
    UIFont *defaultFont = [UIFont fontWithName:@"HelveticaNeue" size:defaultFontSize];
    
    NSDictionary *style = @{
    @"$default" : @{NSFontAttributeName  : defaultFont},
    @"span"     : @{NSFontAttributeName  : defaultFont},
    @"a"        : @{NSFontAttributeName  : defaultFont},
    @"strong"   : @{NSFontAttributeName  : [UIFont fontWithName:@"HelveticaNeue-Bold" size:defaultFontSize]},
    @"b"        : @{NSFontAttributeName  : [UIFont fontWithName:@"HelveticaNeue-Bold" size:defaultFontSize]},
    @"em"       : @{NSFontAttributeName  : [UIFont fontWithName:@"HelveticaNeue-Italic" size:defaultFontSize]},
    @"tag"      : @{NSFontAttributeName  : defaultFont, NSForegroundColorAttributeName: [UIColor grayColor] },
    @"h1"       : @{NSFontAttributeName  : [UIFont fontWithName:@"HelveticaNeue-Medium" size:48]},
    @"h2"       : @{NSFontAttributeName  : [UIFont fontWithName:@"HelveticaNeue-Medium" size:36]},
    @"h3"       : @{NSFontAttributeName  : [UIFont fontWithName:@"HelveticaNeue-Medium" size:32]},
    @"h4"       : @{NSFontAttributeName  : [UIFont fontWithName:@"HelveticaNeue-Medium" size:24]},
    @"h5"       : @{NSFontAttributeName  : [UIFont fontWithName:@"HelveticaNeue-Medium" size:18]},
    @"h6"       : @{NSFontAttributeName  : [UIFont fontWithName:@"HelveticaNeue-Medium" size:16]},
    @"div"      : @{NSFontAttributeName  : defaultFont}
    };

    // match tags to <tag>
    NSRegularExpression *tagRegex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *tagMatches = [tagRegex matchesInString:txt options:0 range:NSMakeRange(0, txt.length)];
    for (NSTextCheckingResult *tagMatch in tagMatches) {
        NSRange wordRange = [tagMatch rangeAtIndex:1];
        NSString *word = [txt substringWithRange:wordRange];
        NSString *tag = [NSString stringWithFormat:@"<tag>#%@</tag>", word];
        txt = [tagRegex stringByReplacingMatchesInString:txt options:0 range:NSMakeRange(0, [txt length]) withTemplate:tag];
    }
    
    NSAttributedString *attributedTxt = [SLSMarkupParser attributedStringWithMarkup:txt style:style error:nil];
    return attributedTxt;
}

@end
