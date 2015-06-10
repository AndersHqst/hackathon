//
//  SupportDetailViewController.m
//  econ-ios-support
//
//  Created by Anders Høst Kjærgaard on 10/06/15.
//  Copyright (c) 2015 e-conomic International A/S. All rights reserved.
//

#import "SupportDetailViewController.h"
#import "ECMLib.h"
#import "ChatViewController.h"
#import <Masonry.h>
#import "UIView+HUD.h"
#import "UIImageView+CircularImage.h"

@interface SupportDetailViewController ()
@property (nonatomic, strong)Supporter *supporter;
@property (nonatomic, strong)MFMailComposeViewController *mailController;
@end

@implementation SupportDetailViewController

- (id)initWithSupporter:(Supporter *)supporter {
    self = [super initWithNibName:@"SupportDetailView" bundle:[NSBundle mainBundle]];
    if(!self) return nil;
    
    self.supporter = supporter;
    
    return self;
}

- (void)setNavigationTitleView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    nameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20.0];
    nameLabel.text = self.supporter.name;
    [nameLabel sizeToFit];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    CGPoint nameCenter = CGPointMake(view.center.x, nameLabel.center.y);
    nameLabel.center = nameCenter;
    
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frame.size.height, 200, 20)];
    nickNameLabel.text = [NSString stringWithFormat:@"\"%@\"", self.supporter.nickName];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    nickNameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
    nickNameLabel.textColor = [UIColor grayColor];
    [nickNameLabel sizeToFit];
    CGPoint nickCenter = CGPointMake(view.center.x, nickNameLabel.center.y);
    nickNameLabel.center = nickCenter;
    
    [view sizeToFit];
    
    [view addSubview:nameLabel];
    [view addSubview:nickNameLabel];
    
    self.navigationItem.titleView = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.profileImageView setCircularProfileImage];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = [[ECMBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_top_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    [self setNavigationTitleView];
    
    self.profileImageView.image = [UIImage imageNamed:@"agent_gray_resized.png"];
    
    UIImage *image = [UIImage imageNamed:[self.supporter.initials stringByAppendingString:@".png"]];
    if(!image) {
        image = [UIImage imageNamed:[self.supporter.initials stringByAppendingString:@".jpg"]];
    }
    self.profileImageView.image = image;
    
    self.aboutLabel.text = self.supporter.about;
    self.backgroundLabel.text = self.supporter.background;
    self.flagImageView.image = [self supporterImage];
    self.skillsLabel.attributedText = [self.supporter attributedStringForSkills];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (UIImage *)supporterImage {
    if([self.supporter.country isEqualToString:@"se"]) {
        return [UIImage imageNamed:@"Sweden"];
    } else if([self.supporter.country isEqualToString:@"fi"]) {
        return [UIImage imageNamed:@"Finland"];
    } else if([self.supporter.country isEqualToString:@"no"]) {
        return [UIImage imageNamed:@"Norway"];
    }
    // default
    return [UIImage imageNamed:@"Denmark"];
}

#pragma mark - Actions

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)callButtonClick:(id)sender {
    NSLog(@"call mom");
    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"88204840"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)chatButtonClick:(id)sender {
    NSLog(@"show chat");
    ChatViewController *cvc = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
    
}

- (IBAction)mailButtonClick:(id)sender {
    NSLog(@"send email");
    self.mailController = [[MFMailComposeViewController alloc] init];
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"info@e-conomic.dk"];
    [self.mailController setToRecipients:toRecipients];
    [self.mailController setSubject:[NSString stringWithFormat:@"WOW support (Att: %@)", self.supporter.name]];
    self.mailController.mailComposeDelegate = self;
    [self presentViewController:self.mailController animated:YES completion:nil];
    
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^{
        switch (result) {
            case MFMailComposeResultSent:
                [self.view showHUD];
                [self.view hideHUDWithCheckmark:YES];
                break;
            case MFMailComposeResultSaved:
                [self.view showHUD];
                [self.view hideHUDWithCheckmark:YES];
                
                break;
            case MFMailComposeResultCancelled:
                // silent
                break;
            case MFMailComposeResultFailed:
                //                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Could not send email" message:@"Something went wrong" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                //                [av show];
                break;
            default:
                break;
        }
    }];
}
@end
