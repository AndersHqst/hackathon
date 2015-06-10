//
//  NSDate+Additions.m
//  econ-ios-support
//
//  Created by Anders Høst Kjærgaard on 10/06/15.
//  Copyright (c) 2015 e-conomic International A/S. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

-(NSString *)shortFormat {
    static NSDateFormatter *dateFormatter;
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        // [NSValueTransformer valueTransformerForName:TTTISO8601DateTransformerName]
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [dateFormatter stringFromDate:self];
}

@end
