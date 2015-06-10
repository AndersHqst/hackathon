//
//  SupporterTableViewCell.h
//  econ-ios-support
//
//  Created by Anders Høst Kjærgaard on 10/06/15.
//  Copyright (c) 2015 e-conomic International A/S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupporterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@end
