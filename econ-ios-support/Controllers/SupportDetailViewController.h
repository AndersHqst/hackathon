//
//  SupportDetailViewController.h
//  econ-ios-support
//
//  Created by Anders Høst Kjærgaard on 10/06/15.
//  Copyright (c) 2015 e-conomic International A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Supporter.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface SupportDetailViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (id)initWithSupporter:(Supporter *)supporter;


@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;
- (IBAction)callButtonClick:(id)sender;
- (IBAction)chatButtonClick:(id)sender;
- (IBAction)mailButtonClick:(id)sender;
@end
