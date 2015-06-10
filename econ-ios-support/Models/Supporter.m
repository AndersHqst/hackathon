//
//  Supporter.m
//  econ-ios-support
//
//  Created by Anders Høst Kjærgaard on 10/06/15.
//  Copyright (c) 2015 e-conomic International A/S. All rights reserved.
//

#import "Supporter.h"

@implementation Supporter

- (NSMutableAttributedString *)attributedStringForSkills {
    NSString *skillString = [self.skills componentsJoinedByString:@" // "];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:skillString];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, skillString.length)];
    for(NSString *string in self.skills) {
        NSRange range = [skillString rangeOfString:string];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor ecm_orange] range:range];
    }
    
    return attr;
}

@end
