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
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *nickName;
@property (strong, nonatomic)NSString *about;
@property (strong, nonatomic)NSArray<NSString> *skills;
@property (strong, nonatomic)NSString *image;
@property (strong, nonatomic)NSString *background;
@property (strong, nonatomic)NSString *country;

- (NSMutableAttributedString *)attributedStringForSkills;

@end
