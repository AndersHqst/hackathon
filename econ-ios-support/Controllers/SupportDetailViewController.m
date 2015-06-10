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

@interface MyLayoutManager : NSLayoutManager
@end

@implementation MyLayoutManager
- (void)fillBackgroundRectArray:(const CGRect *)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(UIColor *)color
{
    CGFloat halfLineWidth = 3.; // change this to change corners radius
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    if (rectCount == 1
        || (rectCount == 2 && (CGRectGetMaxX(rectArray[1]) < CGRectGetMinX(rectArray[0])))
        )
    {
        // 1 rect or 2 rects without edges in contact
        
        CGRect rect = rectArray[0];
        CGRect box = CGRectMake(rect.origin.x, rect.origin.y+7, rect.size.width, rect.size.height-7);
        CGPathAddRect(path, NULL, CGRectInset(box, halfLineWidth, halfLineWidth));
        if (rectCount == 2)
            CGPathAddRect(path, NULL, CGRectInset(rectArray[1], halfLineWidth, halfLineWidth));
    }
    else
    {
        // 2 or 3 rects
        NSUInteger lastRect = rectCount - 1;
        
        CGPathMoveToPoint(path, NULL, CGRectGetMinX(rectArray[0]) + halfLineWidth, CGRectGetMaxY(rectArray[0]) + halfLineWidth);
        
        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rectArray[0]) + halfLineWidth, CGRectGetMinY(rectArray[0]) + halfLineWidth);
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[0]) - halfLineWidth, CGRectGetMinY(rectArray[0]) + halfLineWidth);
        
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[0]) - halfLineWidth, CGRectGetMinY(rectArray[lastRect]) - halfLineWidth);
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[lastRect]) - halfLineWidth, CGRectGetMinY(rectArray[lastRect]) - halfLineWidth);
        
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[lastRect]) - halfLineWidth, CGRectGetMaxY(rectArray[lastRect]) - halfLineWidth);
        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rectArray[lastRect]) + halfLineWidth, CGRectGetMaxY(rectArray[lastRect]) - halfLineWidth);
        
        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rectArray[lastRect]) + halfLineWidth, CGRectGetMaxY(rectArray[0]) + halfLineWidth);
        
        CGPathCloseSubpath(path);
    }
    
    [color set]; // set fill and stroke color
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, halfLineWidth * 3.);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    CGContextAddPath(ctx, path);
    CGPathRelease(path);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}
@end

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

- (void)addSkillLabels {
    
    NSString *skills = self.supporter.skills;
    // setup text handling
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:skills];
    
    // use our subclass of NSLayoutManager
    MyLayoutManager *textLayout = [[MyLayoutManager alloc] init];
    
    [textStorage addLayoutManager:textLayout];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.view.bounds.size];
    
    [textLayout addTextContainer:textContainer];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0,20,self.view.bounds.size.width,self.view.bounds.size.height-20)
                                               textContainer:textContainer];
    textView.editable = YES;
    textView.selectable = YES;
    textView.font = [UIFont systemFontOfSize:20];
    textView.textColor = [UIColor blackColor];
    textView.contentInset = UIEdgeInsetsMake(-8,0,0,0);
    textView.editable = NO;
    textView.selectable = NO;
    
    [self.view addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.profileImageView.mas_right);
        make.top.equalTo(self.profileImageView.mas_top);
        make.bottom.equalTo(self.profileImageView.mas_bottom);
        make.right.equalTo(self.view).offset(20);
    }];
    
    NSArray *skillsArray = [skills componentsSeparatedByString:@" "];
    for(NSString *skill in skillsArray) {
        NSRange range = [self.supporter.skills rangeOfString:skill];
        [textView.textStorage setAttributes:[NSDictionary dictionaryWithObject:[UIColor ecm_orange] forKey:NSBackgroundColorAttributeName] range:range];
    }
    
}

- (void)setNavigationTitleView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
    nameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20.0];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 150, 20)];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    nickNameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
    nickNameLabel.textColor = [UIColor grayColor];
    
    nameLabel.text = self.supporter.name;
    nickNameLabel.text = [NSString stringWithFormat:@"\"%@\"", self.supporter.nickName];
    
    [view addSubview:nameLabel];
    [view addSubview:nickNameLabel];
    
    [self addSkillLabels];
    
    self.navigationItem.titleView = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = [[ECMBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_top_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    [self setNavigationTitleView];
    
    self.profileImageView.image = [UIImage imageNamed:@"agent_gray_resized.png"];
    
    dispatch_queue_t q = dispatch_queue_create("com.e-conomic.support", NULL);
    dispatch_async(q, ^{
        NSURL *imageUrl = [NSURL URLWithString:self.supporter.image];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        if(image){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.profileImageView.image = image;
            });
        }
    });
    
    self.aboutLabel.text = self.supporter.about;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
