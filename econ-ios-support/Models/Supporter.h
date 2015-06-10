//
//  Supporter.h
//  econ-ios-support
//
//  Created by Anders Høst Kjærgaard on 10/06/15.
//  Copyright (c) 2015 e-conomic International A/S. All rights reserved.
//

#import "JSONModel.h"
#import <UIKit/UIKit.h>
#import "ECMLib.h"

@protocol NSString <NSObject>
@end

@interface Supporter : JSONModel
@property (strong, nonatomic)NSString<Optional> *name;
@property (strong, nonatomic)NSString<Optional> *callname;
@property (strong, nonatomic)NSString<Optional> *bio;
@property (strong, nonatomic)NSArray<NSString, Optional> *skills;
@property (strong, nonatomic)NSString<Optional> *education;
@property (strong, nonatomic)NSString<Optional> *country;
@property (strong, nonatomic)NSString<Optional> *initials;

- (NSMutableAttributedString *)attributedStringForSkills;

@end
