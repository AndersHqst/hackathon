//
//  SupporterTableViewCell.m
//  econ-ios-support
//
//  Created by Anders Høst Kjærgaard on 10/06/15.
//  Copyright (c) 2015 e-conomic International A/S. All rights reserved.
//

#import "SupporterTableViewCell.h"
#import <Masonry.h>
#import "UIImageView+CircularImage.h"

@implementation SupporterTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self.image setCircularProfileImage];
}

@end
